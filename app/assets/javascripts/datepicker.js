$( document ).on("turbolinks:load", function() {
  $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd'
  });

  $('.registration-datepicker').datetimepicker({
    dateFormat: 'm/d/yy',
    maxDate: monthLimit()
  });

  function monthLimit(){
    return moment().add(6, 'months').calendar()
  }
});
