$( document ).on("turbolinks:load", function() {
  $('#passengers.admin-table').DataTable({
  "aoColumns": [
    null,
    null,
    null,
    { "bSortable": false },
    { "bSortable": false },
    null,
    { "bSortable": false },
    { "bSortable": false },
    { "bSortable": false },
  ],
  "aLengthMenu": [[25, 50, 75, 100, -1], [25, 50, 75, 100, "All"]],
  "iDisplayLength": 100
});

  $('#passengers.dispatch-table').DataTable({
  "aoColumns": [
    null,
    null,
    null,
    { "bSortable": false },
    { "bSortable": false },
    null,
    { "bSortable": false },
    { "bSortable": false },
  ],
  "aLengthMenu": [[25, 50, 75, 100, -1], [25, 50, 75, 100, "All"]],
  "iDisplayLength": 100
});
});
