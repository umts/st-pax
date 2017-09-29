$(document).on 'turbolinks:load', ->
  tableElementIds = [
    '#passengers.admin-table'
    '#passengers.dispatch-table'
  ]
  i = 0
  while i < tableElementIds.length
    tableElementId = tableElementIds[i]
    if $.isEmptyObject($.find(tableElementId))
      i++
      continue
    table = undefined
    if $.fn.DataTable.isDataTable(tableElementId)
      table = $(tableElementId).DataTable()
    else
      table = $(tableElementId).DataTable() #Some options would go here...

    document.addEventListener 'turbolinks:before-cache', ->
      table.destroy()
      return

    i++

  return