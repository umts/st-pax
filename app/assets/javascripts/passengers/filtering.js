function updatePassengerFilter() {
  var selected = $("input[name=filter]:checked").val();
  var column = $("table#passengers th").index($(".permanent"));

  if (selected == 'all') selected = '';
  $("table#passengers").DataTable().columns(column).search(selected).draw();
}

$(document).on("turbolinks:load", function() {
  $("input[name=filter]").on("change", updatePassengerFilter);
  updatePassengerFilter();
});
