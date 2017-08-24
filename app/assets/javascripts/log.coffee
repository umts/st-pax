$(document).on 'turbolinks:load', ->
  $('.dispatch-log button.edit-entry').click (e) ->
    e.preventDefault()
    li = $(this).parents('li')
    li.find('.text p').hide()
    li.find('.text .edit-form').show()
    li.find('.actions .button_to').hide()
    $(this).hide()
