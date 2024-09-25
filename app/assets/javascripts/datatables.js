$( document ).on("turbolinks:load", function() {
  $('#passengers').DataTable({
    fixedHeader: true,
    paging: false,
    order: [[0, 'asc']],
    stateSave: true,
  });
});

$( document ).on('turbolinks:before-cache', function() {
  $('#passengers').DataTable().destroy();
});
