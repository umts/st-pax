$( document ).on("turbolinks:load", function() {
  $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd'
  });

  $('.registration-datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: monthLimit()
  });

  function monthLimit(){
    return moment().add(6, 'weeks').calendar()
  }
});
