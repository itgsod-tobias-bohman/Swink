$ ->
  console.log('Ready')

  $('body').on 'submit', '.adder', ->
    addLink($(this), event)

addLink = (form, event) ->
  $.ajax
    url: form.attr('action'),
    method: form.attr('method'),
    data: form.serialize(),
    success: ->
      console.log('Added')
      n = noty(text: 'Link added!')
      $('#link').val ''
      $('#tag').val ''
      $('#secret').attr 'checked', false
    event.preventDefault()
