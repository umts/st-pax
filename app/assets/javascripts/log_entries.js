$(document).on('turbolinks:load', function() {
  $('.log-entry-edit-button').on('click', function (e) {
    var theClickedElement = $(e.target);
    var parent = theClickedElement.closest('.log-entry');
    var edit = parent.find('.log-entry-edit-button');
    var destroy = parent.find('.log-entry-delete-button');
    var show = parent.find('.log-entry-show');
    var form = parent.find('.log-entry-edit');
    var cancel = parent.find('.log-entry-edit-cancel-button');

    edit.prop('hidden', true);
    destroy.prop('hidden', true);
    show.prop('hidden', true);
    form.prop('hidden', false);
    cancel.prop('hidden', false);
  });

  $('.log-entry-edit-cancel-button').on('click', function (e) {
    var theClickedElement = $(e.target);
    var parent = theClickedElement.closest('.log-entry');
    var edit = parent.find('.log-entry-edit-button');
    var destroy = parent.find('.log-entry-delete-button');
    var show = parent.find('.log-entry-show');
    var form = parent.find('.log-entry-edit');
    var cancel = parent.find('.log-entry-edit-cancel-button');

    edit.prop('hidden', false);
    destroy.prop('hidden', false);
    show.prop('hidden', false);
    form.prop('hidden', true);
    cancel.prop('hidden', true);
  });
});
