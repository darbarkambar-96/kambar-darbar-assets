import { firebaseDeletionConfig } from './account-deletion-config.js';
import { deleteFeedbackWithAttachments } from './account-deletion-media.js';
import {
  AccountDeletionError,
  createAccountDeletionClient,
  deletionErrorMessage,
  isProtectedDeletionAccount,
} from './account-deletion-core.js';

const byId = (id) => document.getElementById(id);
const status = byId('status');
const signInButton = byId('sign-in');
const signInActions = byId('sign-in-actions');
const accountPanel = byId('account-panel');
const emailLabel = byId('account-email');
const confirmBox = byId('confirm-deletion');
const deleteButton = byId('delete-account');
const changeButton = byId('change-account');
const accountHeading = byId('account-heading');
const deletionDescription = byId('deletion-description');
const confirmationLabel = byId('deletion-confirmation');
const deletionNote = byId('deletion-note');
let busy = false;
let ready = false;
let displayedUid = null;
let finished = false;
let protectedAccount = false;

function setStatus(message, kind = 'info') {
  status.textContent = message;
  status.dataset.kind = kind;
}

function setBusy(value) {
  busy = value;
  accountPanel.setAttribute('aria-busy', String(value));
  updateControls();
}

function updateControls() {
  signInButton.disabled = !ready || busy || finished;
  changeButton.disabled = busy;
  confirmBox.disabled = busy || protectedAccount;
  deleteButton.disabled = busy || protectedAccount || !displayedUid || !confirmBox.checked;
}

function renderAccount(user) {
  displayedUid = user?.uid || null;
  protectedAccount = isProtectedDeletionAccount(user?.email);
  emailLabel.textContent = user?.email || '';
  confirmBox.checked = false;
  accountHeading.textContent = protectedAccount ? 'Administrator account protected' : 'Confirm the app account to delete';
  deletionDescription.hidden = protectedAccount;
  confirmationLabel.hidden = protectedAccount;
  deleteButton.hidden = protectedAccount;
  deletionNote.hidden = protectedAccount;
  accountPanel.hidden = !user || finished;
  signInActions.hidden = Boolean(user) || finished;
  updateControls();
}

async function bootstrap() {
  try {
    // A blocked CDN produces a useful error rather than a loading form forever.
    const sdk = 'https://www.gstatic.com/firebasejs/13.2.0/';
    const [appSdk, authSdk, storeSdk] = await Promise.all([
      import(`${sdk}firebase-app.js`),
      import(`${sdk}firebase-auth.js`),
      import(`${sdk}firebase-firestore.js`),
    ]);
    const app = appSdk.initializeApp(firebaseDeletionConfig, 'kambar-account-deletion');
    const auth = authSdk.getAuth(app);
    await authSdk.setPersistence(auth, authSdk.inMemoryPersistence);
    const store = storeSdk.getFirestore(app);

    function requireSameUser(account) {
      const user = auth.currentUser;
      if (isProtectedDeletionAccount(user?.email)) throw new AccountDeletionError('admin-protected');
      if (!user || user.uid !== account.uid) throw new AccountDeletionError('identity-changed');
      return user;
    }

    function googleProvider(email = null) {
      const provider = new authSdk.GoogleAuthProvider();
      provider.setCustomParameters({
        prompt: 'select_account',
        ...(email ? { login_hint: email } : {}),
      });
      return provider;
    }

    const gateway = {
      async currentAccount() {
        const user = auth.currentUser;
        return user ? { uid: user.uid, email: user.email || '' } : null;
      },
      async reauthenticate(account) {
        const user = requireSameUser(account);
        // Reauthenticate the confirmed User. A sign-in call at this stage could
        // replace it with a different Google account.
        const result = await authSdk.reauthenticateWithPopup(user, googleProvider(account.email));
        if (result.user.uid !== account.uid) throw new AccountDeletionError('identity-changed');
        const verifiedUser = requireSameUser(account);
        const token = await authSdk.getIdTokenResult(verifiedUser, true);
        requireSameUser(account);
        return {
          uid: verifiedUser.uid,
          email: typeof token.claims.email === 'string' ? token.claims.email : '',
          emailVerified: token.claims.email_verified === true,
        };
      },
      async feedbackDocumentIds({ field, value, limit }) {
        const request = storeSdk.query(
          storeSdk.collection(store, 'feedback'),
          storeSdk.where(field, '==', value),
          storeSdk.limit(limit),
        );
        const snapshot = await storeSdk.getDocsFromServer(request);
        return snapshot.docs.map((record) => record.id);
      },
      async deleteFeedback(ids) {
        const current = auth.currentUser;
        if (!current) throw new AccountDeletionError('not-signed-in');
        const account = { uid: current.uid, email: current.email || '' };
        await deleteFeedbackWithAttachments(ids, {
          async cleanupThread(id) {
            const user = requireSameUser(account);
            const token = await user.getIdToken();
            requireSameUser(account);
            const response = await fetch(
              `https://darbar-admin.bitsyav.com/api/feedback/threads/${encodeURIComponent(id)}/attachments`,
              { method: 'DELETE', headers: { Authorization: `Bearer ${token}` }, cache: 'no-store' },
            );
            requireSameUser(account);
            if (!response.ok) {
              throw new AccountDeletionError(response.status === 403 ? 'permission-denied' : 'network-request-failed');
            }
            return response.json();
          },
          async deleteDocuments(documentIds) {
            requireSameUser(account);
            const batch = storeSdk.writeBatch(store);
            for (const id of documentIds) batch.delete(storeSdk.doc(store, 'feedback', id));
            await batch.commit();
          },
        });
      },
      async deleteAuthenticationAccount(account) {
        await authSdk.deleteUser(requireSameUser(account));
      },
      async clearBrowserSession() {
        await authSdk.signOut(auth);
      },
    };
    const client = createAccountDeletionClient(gateway, ({ stage, removedFeedback }) => {
      if (stage === 'reauthenticate') setStatus('Confirm the same Google account in the sign-in pop-up.');
      if (stage === 'feedback') setStatus(`Removing your associated feedback… ${removedFeedback} removed. Keep this page open.`);
      if (stage === 'account') setStatus('Removing your Kambar Darbar app account… Keep this page open.');
    });

    authSdk.onAuthStateChanged(auth, (user) => {
      // Let an active deletion render its result rather than replacing its
      // confirmed UID during reauthentication or final account removal.
      if (!busy) renderAccount(user);
    });
    confirmBox.addEventListener('change', updateControls);

    signInButton.addEventListener('click', async () => {
      if (busy || !ready) return;
      setBusy(true);
      setStatus('Choose the Google account used in the Kambar Darbar app.');
      try {
        await authSdk.signInWithPopup(auth, googleProvider());
        renderAccount(auth.currentUser);
        setStatus(protectedAccount
          ? deletionErrorMessage(new AccountDeletionError('admin-protected'))
          : 'Check the email address above, then confirm whether to delete this app account.');
      } catch (error) {
        renderAccount(auth.currentUser);
        setStatus(deletionErrorMessage(error), 'error');
      } finally {
        setBusy(false);
      }
    });

    changeButton.addEventListener('click', async () => {
      if (busy) return;
      setBusy(true);
      try {
        await authSdk.signOut(auth);
        renderAccount(null);
        setStatus('Sign in with the Google account you want to use.');
      } catch {
        setStatus('The browser could not clear its sign-in session. Close and reopen this page before choosing another account.', 'error');
      } finally {
        setBusy(false);
      }
    });

    deleteButton.addEventListener('click', async () => {
      if (busy || protectedAccount || !displayedUid || !confirmBox.checked) return;
      const expectedUid = displayedUid;
      setBusy(true);
      try {
        await client.deleteConfirmedAccount({ expectedUid, confirmed: true });
        finished = true;
        renderAccount(null);
        setStatus('Your Kambar Darbar app account and associated feedback have been deleted. Your Google account has not been deleted.', 'success');
      } catch (error) {
        if (error.accountDeleted) {
          finished = true;
          renderAccount(null);
          setStatus(deletionErrorMessage(error), 'success');
        } else {
          renderAccount(auth.currentUser);
          setStatus(deletionErrorMessage(error), 'error');
        }
      } finally {
        setBusy(false);
      }
    });

    ready = true;
    updateControls();
    setStatus('Sign in with Google to identify your Kambar Darbar app account.');
  } catch {
    ready = false;
    updateControls();
    setStatus('Secure sign-in could not load. Check your connection and reload this page, or use account deletion in the updated Android app.', 'error');
  }
}

void bootstrap();
