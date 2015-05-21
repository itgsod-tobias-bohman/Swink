$ ->
  console.log('Ready')

  $('body').on 'submit', '.remover', ->
    removeLink($(this), event)

removeLink = (form, event) ->
  $('.remover').addClass('m-progress').prop('disabled', true)
  $.ajax
    url: form.attr('action'),
    method: form.attr('method'),
    data: form.serialize(),
    success: ->
      $('.remover').removeClass('m-progress').prop('disabled', false)
      form.parent().parent().remove()
      alertify.error('Link Removed');
    event.preventDefault()
