$ ->
  console.log('Ready')

  $('body').on 'submit', '.adder', ->
    addLink($(this), event)

addLink = (form, event) ->
  $('#submit-button').addClass('m-progress')
  $.ajax
    url: form.attr('action'),
    method: form.attr('method'),
    data: form.serialize(),
    success: ->
      console.log('Added')
      alertify.success('Link Added')
      $('#link').val ''
      $('#tag').val ''
      $('#secret').attr 'checked', false
      $('#submit-button').removeClass('m-progress')
    event.preventDefault()
