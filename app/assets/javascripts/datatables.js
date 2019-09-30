$( document ).on("turbolinks:load", function() {
  $('#passengers').DataTable({
    stateSave: true,
    destroy: true,
    lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, 'All'] ]
  });
});
