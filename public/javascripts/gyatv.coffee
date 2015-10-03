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

displayNext = (params, seq) ->
  if !window.curElement?
    window.pageIndex = (if seq then 0 else rand params.length)
    window.imgIndex = 0
    window.iframeIndex = 0
    url = params[window.pageIndex][0]
    if url.match /(png|jpg|gif)$/i
      window.curElement = imgdivs[window.imgIndex]
      loadPage window.curElement.children(), url
    else
      window.curElement = iframes[window.iframeIndex]
      loadPage window.curElement, url
  else
    window.curElement.css 'display', 'none'
    window.curElement = window.nextElement
  window.curElement.css 'display','block'

  window.pageIndex = (if seq then window.pageIndex+1 else rand params.length) % params.length
  url = params[window.pageIndex][0]
  sec = params[window.pageIndex][1] || 10
  if url.match /(png|jpg|gif)$/i
    window.imgIndex = (window.imgIndex+1) % imgdivs.length
    window.nextElement = imgdivs[window.imgIndex]
    loadPage window.nextElement.children(), url # 非同期でロードしておく
  else
    window.iframeIndex = (window.iframeIndex+1) % iframes.length
    window.nextElement = iframes[window.iframeIndex]
    loadPage window.nextElement, url  # 非同期でロードしておく
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
