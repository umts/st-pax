const whenPassengersTableIsPresent = (callback) => {
  const element = document.querySelector('#passengers');
  if (element) {
    callback(element);
  }
};

document.addEventListener('turbo:load', () => {
  whenPassengersTableIsPresent((passengerTable) => {
    const dataTable = new DataTable(passengerTable, {
      fixedHeader: true,
      paging: false,
      order: [[0, 'asc']],
      stateSave: true,
    });

    const filterPassengers = () => {
      const selected = document.querySelector('.passenger-filter:checked').value;
      document.querySelector('.filter-name').textContent = selected.charAt(0).toUpperCase() + selected.slice(1);
      dataTable.columns(5).search(selected === 'all' ? '' : selected).draw();
    };

    filterPassengers();
    document.querySelectorAll('.passenger-filter').forEach((filterInput) => {
      filterInput.addEventListener('change', filterPassengers);
    });
  });
});

document.addEventListener('turbo:before-cache', () => {
  whenPassengersTableIsPresent((element) => {
    new DataTable(element).destroy();
  });
});
