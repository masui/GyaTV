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
  if !window.CurElement?
    window.pageIndex = (if seq then 0 else rand params.length)
    window.imgIndex = 0
    window.iframeIndex = 0
    url = params[window.pageIndex].url
    if url.match /(png|jpg|gif)$/i
      window.curElement = imgdivs[window.imgIndex]
      loadPage window.curElement.children(), url
    else
      window.curElement = iframes[window.iframeIndex]
      loadPage window.curElement, url
    window.curElement.css 'display','block'
  else
    window.curElement.css 'display', 'none'
    window.nextElement.css 'display', 'block'
    window.curElement = window.nextElement

  window.pageIndex = if seq then window.pageIndex+1 else rand params.length
  window.pageIndex %= params.length
      
  url = params[window.pageIndex].url
  sec = params[window.pageIndex].sec
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
      a = matched[2].split(/ /)
      url: a[0]
      sec: if a.length > 1 then parseInt(a[1]) else 10
    displayNext params, seq

$ ->
  pairs = location.search.substring(1).split('&')
  checkAndRun pairs.indexOf('play=seq') >= 0
