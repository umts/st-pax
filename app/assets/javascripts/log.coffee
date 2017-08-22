$(document).on 'turbolinks:load', ->
  $('.dispatch-log button.edit-entry').click (e) ->
    e.preventDefault()
    $(this).siblings('form').show()
    $(this).siblings('.content').hide()
    $(this).hide()
