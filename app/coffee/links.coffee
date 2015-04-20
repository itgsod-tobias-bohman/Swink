$ ->
  console.log('Ready')
  getLinks()

  $('body').on 'submit', '.remover', ->
    removeLink($(this), event)

removeLink = (form, event) ->
  $.ajax
    url: form.attr('action'),
    method: form.attr('method'),
    data: form.serialize(),
    success: ->
      form.parent().remove()
      n = noty(text: 'Link removed!')
    event.preventDefault()

getLinks = ->
  $.ajax
    url: '/links.json',
    dataType: 'json',
    error: (jgXHR, textStatus, errorThrown) ->
      console.log "AJAX ERROR: #{textStatus}, #{errorThrown}",
    success: renderLinks

renderLinks = (links) ->
  source = $('#links-template').html()
  template = Handlebars.compile source
  $('body').append(template(links))
