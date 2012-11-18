window.g = g = {}

g.offset = 0.0
g.toffset = 0.0
g.w = $(window).width()

$('.flag').click (e) ->
  e.preventDefault()
  $(this).toggleClass 'selected'

$('.star').hover ->
    $(this).addClass('hover')
    $(this).prevAll().addClass('hover')
  ,
  ->
    $(this).parent().find('.star').removeClass('hover')

$('.star').click (e) ->
  e.preventDefault()
  $(this).parent('.rating').removeClass('_1 _2 _3 _4 _5')
  $(this).parent('.rating').addClass('_'+$(this).data('star'))

$('.photo').click ->
  g.toffset = $('.photo').index(this)
  up()

$('.bwtoggle').click ->
  $(this).toggleClass('selected')
  $(this).siblings('.img').toggleClass('bw')

update = ->
  $('.photo').each (i, e) ->
    ii = i - g.offset
    if (Math.abs(ii) > 2.5)
      $(e).css { display: 'none' }
      return

    h = 1.0 / ((ii * ii) + 1)
    h_slow = 1.0 / (((ii/5) * (ii/5)) + 1)
    h_fast = 1.0 / (((ii*1.5) * (ii*1.5)) + 1)
    filter = 'perspective(500px) rotate3d(0, 1, 0, '+(-90 * (Math.atan(ii) / Math.PI))+'deg) translate3d(0,0,'+((1 - h) * -1000)+'px)'
    $(e).css {
      display: 'inline-block',
      left: (Math.atan(ii / 3) * 500 - 400 + (g.w / 2)) + 'px',
      '-webkit-transform': filter,
      '-moz-transform': filter,
      'z-index': Math.round(1000.0 * h),
      '-webkit-filter': 'saturate('+h_fast+') blur('+(8 * (1-h))+'px) brightness('+Math.atan(h/1.25 - 0.8)+')',
    }


requestAnimationFrame = window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame

window.up = up = ->
  d = (g.toffset - g.offset) / 5.0
  g.offset += d
  update()

  if (Math.abs(d) > 0.0001)
    requestAnimationFrame up
requestAnimationFrame up

g.current = current = ->
  $($('.photo')[Math.round(g.offset)])

$(window).keydown (e) ->
  # console.log(e.keyCode)
  switch e.keyCode
    when 80 # Flag as pick
      current().find('.flag').addClass('selected')
    when 85 # Unflag as pick
      current().find('.flag').removeClass('selected')
    when 66 # Toggle b&w mode
      current().find('.bwtoggle').toggleClass('selected')
      current().find('.img').toggleClass('bw')

    when 49,50,51,52,53
      rating = current().find('.rating')
        .addClass('show')

      id = rating.data('showtimer')
      window.clearTimeout(id)

      id = window.setTimeout(
        ->
          rating.removeClass('show')
        2000)
      rating.data('showtimer', id)

      switch e.keyCode
        when 49
          console.log 2
          current().find('.rating')
            .removeClass('_1 _2 _3 _4 _5')
            .addClass('_1')
        when 50
          current().find('.rating')
            .removeClass('_1 _2 _3 _4 _5')
            .addClass('_2')
        when 51
          current().find('.rating')
            .removeClass('_1 _2 _3 _4 _5')
            .addClass('_3')
        when 52
          current().find('.rating')
            .removeClass('_1 _2 _3 _4 _5')
            .addClass('_4')
        when 53
          current().find('.rating')
            .removeClass('_1 _2 _3 _4 _5')
            .addClass('_5')

    when 37, 38
      g.toffset -= 1
    when 39, 32, 40
      g.toffset += 1

  # Bounds checking
  g.toffset = Math.min($('.photo').length - 1, Math.max(0, g.toffset))

  up()

$(window).resize (e) ->
  g.w = $(window).width()
  up()
