$( document ).on("turbolinks:load", function() {
  $.datetimepicker.setDateFormatter('moment');
  $('.datepicker').datetimepicker({
    timepicker: false,
    format: 'dddd, MMMM D, YYYY'
  });

  $('.registration-datepicker').datetimepicker({
    dateFormat: 'm/d/yy',
    maxDate: monthLimit()
  });

  function monthLimit(){
    return moment().add(6, 'months').calendar()
  }
});
