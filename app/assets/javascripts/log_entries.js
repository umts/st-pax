$(document).on('turbo:load', function() {
  function setLogEntryEditing(logEntry, change) {
    var edit = logEntry.find('.log-entry-edit-button');
    var destroy = logEntry.find('.log-entry-delete-button');
    var show = logEntry.find('.log-entry-show');
    var form = logEntry.find('.log-entry-edit');
    var cancel = logEntry.find('.log-entry-edit-cancel-button');

    edit.prop('hidden', change);
    destroy.prop('hidden', change);
    show.prop('hidden', change);
    form.prop('hidden', !(change));
    cancel.prop('hidden', !(change));
  }

  $('.log-entry-edit-button').on('click', function (e) {
    var theClickedElement = $(e.target);
    var parent = theClickedElement.closest('.log-entry');
    setLogEntryEditing(parent, true);
  });

  $('.log-entry-edit-cancel-button').on('click', function (e) {
    var theClickedElement = $(e.target);
    var parent = theClickedElement.closest('.log-entry');
    setLogEntryEditing(parent, false);
  });
});
