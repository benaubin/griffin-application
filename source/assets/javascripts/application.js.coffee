#= require tweetnacl/nacl-fast.min
#= require tweetnacl-util/nacl-util.min
#= require_self
$ -> 
  $('.scroll-button').click ->
    $('html, body').animate
      scrollTop: $('.about').offset().top
    , 500

  information = $('#information')
  # Get the encrypted student information and the nonce from the information element
  [encrypted, nonce] = information.attr('data-encrypted').split(";")
  # Decode the nonce and encrypted data from Base64
  encrypted = nacl.util.decodeBase64(encrypted)
  nonce = nacl.util.decodeBase64(nonce)
  # Get the private key from the hash part of the url
  key = location.hash.slice(1)
  # Decode the key from Base64
  key = nacl.util.decodeBase64(key)
  # Decrypt the information
  decrypted = false
  try
    decrypted = nacl.secretbox.open(encrypted, nonce, key)
  catch e
    console.warn("Could not decrypt because of #{e}")
  if decrypted
    # Encode the raw decrypted bytes into a JSON string
    decrypted = nacl.util.encodeUTF8(decrypted)
    # Parse the JSON string
    decrypted = JSON.parse(decrypted)
    for info in decrypted
      card = information.find(".card-template .card").clone()
      card.find('.card-title').text(info.value)
      card.find('.card-subtitle').text(info.title)
      card.appendTo(information)

    $('.share-alert').show().click ->
      location.hash = ""
      location.reload(true)
  else
    $('.alert-danger').show()

  $('.timeline-item').each (i) ->
    item = $(@)
    scrollPoint = $(@).offset().top - 150
    $(window).resize ->
      scrollPoint = item.offset().top - 150
    $(window).scroll ->
      scrolledAt = $(window).scrollTop() + $(window).height()
      if scrolledAt > scrollPoint
        item.addClass('scrolled')
      else if scrolledAt + 150 < scrollPoint
        item.removeClass('scrolled')