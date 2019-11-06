$( document ).on("turbolinks:load", function() {
  $('#passengers').DataTable({
    fixedHeader: true,
    lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, 'All'] ],
    order: [[0, 'asc']],
    stateSave: true,
  });
});

$( document ).on('turbolinks:before-cache', function() {
  $('#passengers').DataTable().destroy();
});
