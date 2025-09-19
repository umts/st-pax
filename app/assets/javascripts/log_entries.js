document.addEventListener('turbo:load', () => {
  const setLogEntryEditing = (logEntry, value) => {
    logEntry.querySelector('.log-entry-edit-button').hidden = value;
    logEntry.querySelector('.log-entry-delete-button').hidden = value;
    logEntry.querySelector('.log-entry-show').hidden = value;
    logEntry.querySelector('.log-entry-edit').hidden = !(value);
    logEntry.querySelector('.log-entry-edit-cancel-button').hidden = !(value);
  }

  document.querySelectorAll('.log-entry-edit-button').forEach((editButton) => {
    editButton.addEventListener('click', (e) => {
      setLogEntryEditing(e.currentTarget.closest('.log-entry'), true);
    });
  });

  document.querySelectorAll('.log-entry-edit-cancel-button').forEach((cancelButton) => {
    cancelButton.addEventListener('click', (e) => {
      setLogEntryEditing(e.currentTarget.closest('.log-entry'), false);
    });
  });
});
