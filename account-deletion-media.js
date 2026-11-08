// Remove private thread media before removing the Firestore record that grants
// its owner permission. The server persists cleanup intent before acknowledging.
export async function deleteFeedbackWithAttachments(ids, gateway) {
  for (let offset = 0; offset < ids.length; offset += 4) {
    await Promise.all(ids.slice(offset, offset + 4).map(async (id) => {
      const result = await gateway.cleanupThread(id);
      if (result?.cleanupAccepted !== true) {
        const error = new Error('Private feedback media cleanup was not accepted.');
        error.code = 'media-cleanup-failed';
        throw error;
      }
    }));
  }
  await gateway.deleteDocuments(ids);
}
