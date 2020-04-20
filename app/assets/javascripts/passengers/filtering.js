function updatePassengerFilter() {
  if (!$(".passenger-filters input").length) return;

  var selected = $(".passenger-filters input[name=filter]:checked").val();
  var column = $("table#passengers th").index($(".permanent"));

  $("span.filter-name").text(
    selected.charAt(0).toUpperCase() + selected.slice(1)
  );
  if (selected == 'all') selected = '';
  $("table#passengers").DataTable().columns(column).search(selected).draw();
}

$(document).on("turbolinks:load", function() {
  $("input[name=filter]").on("change", updatePassengerFilter);
  updatePassengerFilter();
});
