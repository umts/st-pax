$( document ).on("turbo:load", function() {
  $('#passengers').DataTable({
    fixedHeader: true,
    paging: false,
    order: [[0, 'asc']],
    stateSave: true,
  });
});

$( document ).on('turbo:before-cache', function() {
  $('#passengers').DataTable().destroy();
});
