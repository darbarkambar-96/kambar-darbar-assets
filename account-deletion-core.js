// Pure dependency-injected deletion ordering. No Firebase, DOM or network imports.
export const FEEDBACK_PAGE_SIZE = 200;
export const PROTECTED_ADMIN_EMAIL = 'darbarkambar@gmail.com';

export function isProtectedDeletionAccount(email) {
  return typeof email === 'string' && email.trim().toLowerCase() === PROTECTED_ADMIN_EMAIL;
}

export class AccountDeletionError extends Error {
  constructor(code, { dataMayHaveBeenDeleted = false, accountDeleted = false } = {}) {
    super('Account deletion could not be completed.');
    this.name = 'AccountDeletionError';
    this.code = code;
    this.dataMayHaveBeenDeleted = dataMayHaveBeenDeleted;
    this.accountDeleted = accountDeleted;
  }
}

export function normalizedDeletionCode(error) {
  const code = typeof error?.code === 'string' ? error.code : 'deletion-failed';
  if (['auth/popup-closed-by-user', 'auth/cancelled-popup-request', 'cancelled'].includes(code)) return 'cancelled';
  if (['auth/user-mismatch', 'auth/user-not-found', 'identity-changed'].includes(code)) return 'identity-changed';
  if (['auth/network-request-failed', 'unavailable', 'deadline-exceeded'].includes(code)) return 'network-request-failed';
  return code.startsWith('auth/') ? code.slice(5) : code;
}

export function deletionErrorMessage(error) {
  if (error?.accountDeleted) {
    return 'Your Kambar Darbar app account and associated feedback were deleted. The browser could not finish clearing its local session; close this page.';
  }
  const code = normalizedDeletionCode(error);
  const partial = error?.dataMayHaveBeenDeleted
    ? ' Some feedback may already have been removed. Your app-account deletion has not been confirmed.'
    : ' No deletion has been confirmed.';
  if (code === 'cancelled') return 'Google confirmation was cancelled. Your app account was not deleted.';
  if (code === 'admin-protected') return 'Account deletion is disabled for the Darbar administrator account. Use a different Google account to delete a personal app account.';
  if (code === 'confirmation-required') return 'Select the confirmation checkbox before deleting your app account.';
  if (['identity-changed', 'not-signed-in', 'user-token-expired'].includes(code)) {
    return `Sign in again with the same Google account and confirm the displayed email address.${partial}`;
  }
  if (code === 'email-not-verified') return 'Google must verify this email address before its associated feedback can be deleted. No deletion has begun.';
  if (code === 'popup-blocked') return 'Allow Google sign-in pop-ups for this page, then try again. No deletion has begun.';
  if (['unauthorized-domain', 'operation-not-allowed', 'invalid-api-key'].includes(code)) {
    return 'Web sign-in is temporarily unavailable. Please use account deletion in the updated Android app, or try this page later.';
  }
  if (code === 'permission-denied') return `The app could not complete removal of the associated feedback. Please try again later.${partial}`;
  if (code === 'requires-recent-login') return `Google confirmation expired. Confirm the same account again and retry.${partial}`;
  if (code === 'network-request-failed') return `Check your connection, keep this page open and try again.${partial}`;
  if (code === 'already-in-progress') return 'Deletion is already in progress. Keep this page open until it finishes.';
  return `Deletion did not finish. Please try again.${partial}`;
}

export function createAccountDeletionClient(gateway, onProgress = () => {}) {
  let busy = false;

  async function assertSameAccount(expected) {
    const current = await gateway.currentAccount();
    if (isProtectedDeletionAccount(current?.email)) {
      throw new AccountDeletionError('admin-protected');
    }
    if (!current || current.uid !== expected.uid ||
        current.email?.trim().toLowerCase() !== expected.email.trim().toLowerCase()) {
      throw new AccountDeletionError('identity-changed');
    }
  }

  return {
    async deleteConfirmedAccount({ expectedUid, confirmed = false }) {
      if (busy) throw new AccountDeletionError('already-in-progress');
      if (!confirmed) throw new AccountDeletionError('confirmation-required');
      busy = true;
      let dataMayHaveBeenDeleted = false;
      let accountDeleted = false;
      let removedFeedback = 0;
      try {
        const account = await gateway.currentAccount();
        if (!account) throw new AccountDeletionError('not-signed-in');
        if (isProtectedDeletionAccount(account.email)) throw new AccountDeletionError('admin-protected');
        if (!expectedUid || account.uid !== expectedUid) throw new AccountDeletionError('identity-changed');
        if (!account.email?.trim()) throw new AccountDeletionError('email-not-verified');
        onProgress({ stage: 'reauthenticate', removedFeedback });
        const verified = await gateway.reauthenticate(account);
        if (!verified || verified.uid !== account.uid ||
            verified.email?.trim().toLowerCase() !== account.email.trim().toLowerCase()) {
          throw new AccountDeletionError('identity-changed');
        }
        if (verified.emailVerified !== true) throw new AccountDeletionError('email-not-verified');
        await assertSameAccount(account);
        const filters = [
          { field: 'userId', value: account.uid },
          { field: 'userEmail', value: verified.email },
        ];
        onProgress({ stage: 'feedback', removedFeedback });
        while (true) {
          for (const filter of filters) {
            while (true) {
              await assertSameAccount(account);
              const ids = await gateway.feedbackDocumentIds({ ...filter, limit: FEEDBACK_PAGE_SIZE });
              if (!ids.length) break;
              if (ids.length > FEEDBACK_PAGE_SIZE) throw new AccountDeletionError('invalid-feedback-page');
              await assertSameAccount(account);
              dataMayHaveBeenDeleted = true;
              await gateway.deleteFeedback(ids);
              removedFeedback += ids.length;
              onProgress({ stage: 'feedback', removedFeedback });
            }
          }
          let remaining = false;
          for (const filter of filters) {
            await assertSameAccount(account);
            const ids = await gateway.feedbackDocumentIds({ ...filter, limit: 1 });
            remaining = remaining || ids.length > 0;
          }
          if (!remaining) break;
        }
        await assertSameAccount(account);
        onProgress({ stage: 'account', removedFeedback });
        // Keep the credential needed by Firestore until all owned-data writes
        // have been acknowledged. Auth and Firestore are not one transaction.
        await gateway.deleteAuthenticationAccount(account);
        accountDeleted = true;
        try {
          await gateway.clearBrowserSession();
        } catch {
          throw new AccountDeletionError('local-cleanup-failed');
        }
        return { removedFeedback, accountDeleted: true };
      } catch (error) {
        throw new AccountDeletionError(normalizedDeletionCode(error), {
          dataMayHaveBeenDeleted: dataMayHaveBeenDeleted || error?.dataMayHaveBeenDeleted === true,
          accountDeleted: accountDeleted || error?.accountDeleted === true,
        });
      } finally {
        busy = false;
      }
    },
  };
}
