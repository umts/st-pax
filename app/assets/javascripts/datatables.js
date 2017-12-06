$(document).on("turbolinks:load", function() {
  if (!$.fn.dataTable.isDataTable('#passengers')) {
    var columns = [null,
                   null,
                   null,
                   null,
                   { "bSortable": false },
                   { "bSortable": false },
                   null,
                   { "bSortable": false },
                   { "bSortable": false }];
    if($('#passengers').hasClass('admin-table'))
      columns.push({ "bSortable": false });
    $('#passengers').DataTable({
      "aoColumns": columns,
      "aLengthMenu": [[25, 50, 75, 100, -1], [25, 50, 75, 100, "All"]],
      "iDisplayLength": 100
    });
  }
});
