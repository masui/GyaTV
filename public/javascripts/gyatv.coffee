#
# スライドショー表示「GyaTV 」
# http://GyaTV.com
# 

iframes = [0..2].map -> 
  $('<iframe frameborder="0" marginwidth="0">')
    .appendTo $('body')

imgdivs = [0..2].map ->
  $('<div class="imagediv" align="center">')
    .append $('<img>')
    .appendTo $('body')

rand = (n) ->
  Math.floor Math.random() * n

loadNext = (params, seq) ->
  window.pageIndex =
    if window.pageIndex?
      (if seq then window.pageIndex+1 else rand params.length) % params.length
    else
      if seq then 0 else rand params.length
  url = params[window.pageIndex][0]
  window.imgIndex = (if window.imgIndex? then window.imgIndex+1 else 0) % imgdivs.length
  window.iframeIndex = (if window.iframeIndex? then window.iframeIndex+1 else 0) % iframes.length
  if url.match /(png|jpg|gif)$/i
    window.nextElement = imgdivs[window.imgIndex]
    loadPage window.nextElement.children(), url
  else
    window.nextElement = iframes[window.iframeIndex]
    loadPage window.nextElement, url

displayNext = (params, seq) ->
  if !window.curElement?
    loadNext params, seq
  else
    window.curElement.css 'display', 'none'
  window.curElement = window.nextElement
  window.curElement.css 'display','block'
  loadNext params, seq
  sec = params[window.pageIndex][1] || 10
  setTimeout ->
    displayNext params, seq
  , sec * 1000

# バックグラウンドでページ内容をロード
loadPage = (e,src) ->
  setTimeout ->
    e.attr 'src', src
  ,0

checkAndRun = (seq) ->
  $.getJSON gyatvURL, (data) ->
    lines = $.grep data['data'], (x) ->
      ! x.match(/^#/) && x.match(/http/)
    params = lines.map (line) ->
      matched = line.match /^(\[)*(http:\/\/[^ \]]+).*$/
      matched[2].split(/ /)
    displayNext params, seq

$ ->
  pairs = location.search.substring(1).split('&')
  checkAndRun pairs.indexOf('play=seq') >= 0
