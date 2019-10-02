$( document ).on("turbolinks:load", function() {
  $('#passengers').DataTable({
    stateSave: true,
    lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, 'All'] ]
  });
});

$( document ).on('turbolinks:before-cache', function() {
  $('#passengers').DataTable().destroy();
});
