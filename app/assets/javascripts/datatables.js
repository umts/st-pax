const whenPassengersTableIsPresent = (callback) => {
  const element = document.querySelector('#passengers');
  if (element) {
    callback(element);
  }
}

document.addEventListener('turbo:load', () => {
  whenPassengersTableIsPresent((element) => {
    new DataTable(element, {
      fixedHeader: true,
      paging: false,
      order: [[0, 'asc']],
      stateSave: true,
    });
  })
})

document.addEventListener('turbo:before-cache', () => {
  whenPassengersTableIsPresent((element) => {
    new DataTable(element).destroy()
  })
})
