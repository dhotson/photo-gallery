window.g = g = {}

g.offset = 0.0
g.toffset = 0.0
g.w = $(window).width()


update = ->
  $('.photo').each (i, e) ->
    ii = i - g.offset
    if (Math.abs(ii) >= 5)
      $(e).css { display: 'none' }
      return

    h = 1.0 / ((ii * ii) + 1)
    h_slow = 1.0 / (((ii/5) * (ii/5)) + 1)
    h_fast = 1.0 / (((ii*1.5) * (ii*1.5)) + 1)
    $(e).css {
      display: 'inline-block',
      position: 'absolute',
      top: '50px',
      left: (Math.atan(ii / 3) * 500 - 400 + (g.w / 2)) + 'px',
      '-webkit-transform-origin': '50% 50% 0',
      '-webkit-transform': 'perspective(800px) rotate3d(0, 1, 0, '+(-90 * (Math.atan(ii) / Math.PI))+'deg) translate3d(0,0,'+((1 - h) * -1000)+'px)',
      'z-index': Math.round(1000.0 * h),
      '-webkit-filter': 'saturate('+h_fast+') blur('+(8 * (1-h))+'px) brightness('+Math.atan(h/2 - 0.5)+')',
    }


requestAnimationFrame = window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame

up = ->
  d = (g.toffset - g.offset) / 4.0
  g.offset += d
  console.log(g.offset)
  update()

  if (Math.abs(d) > 0.001)
    requestAnimationFrame up
requestAnimationFrame up

$(window).keydown (e) ->
  if (e.keyCode == 37)
    g.toffset -= 1
  else
    g.toffset += 1
  up()

$(window).resize (e) ->
  g.w = $(window).width()
  up()
