$( document ).on("turbolinks:load", function() {
  $.datetimepicker.setDateFormatter('moment');
  $('.datepicker').datetimepicker({
    timepicker: false,
    format: 'dddd, MMMM D, YYYY'
  });
});
