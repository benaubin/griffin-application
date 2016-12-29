#= require_tree .
$ -> 
  $('.scroll-button').click ->
    $('html, body').animate
      scrollTop: $('.timeline-header').offset().top
    , 500
  
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