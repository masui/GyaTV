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

displayNext = (pages, secs, seq) ->
  if window.firsttime
    # pageIndex = rand pages.length
    window.pageIndex = (if seq then 0 else rand pages.length)
    window.imgIndex = 0
    window.iframeIndex = 0
    window.firsttime = false
    url = pages[window.pageIndex]
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

  window.pageIndex = if seq then window.pageIndex+1 else rand pages.length
  window.pageIndex %= pages.length
      
  sec = secs[window.pageIndex]
  url = pages[window.pageIndex]
  if url.match /(png|jpg|gif)$/i
    window.imgIndex = (window.imgIndex+1) % imgdivs.length
    window.nextElement = imgdivs[window.imgIndex]
    loadPage window.nextElement.children(), url # 非同期でロードしておく
  else
    window.iframeIndex = (window.iframeIndex+1) % iframes.length
    window.nextElement = iframes[window.iframeIndex]
    loadPage window.nextElement, url  # 非同期でロードしておく
  setTimeout ->
    displayNext pages, secs, seq
  , sec * 1000

# バックグラウンドでページ内容をロード
loadPage = (e,src) ->
  setTimeout ->
    e.attr 'src', src
  ,0

checkAndRun = (seq) ->
  $.getJSON gyatvURL, (data) ->
    pages = []
    secs = []
    window.firsttime = true
    window.pageIndex = 0
    for line in data['data']
      if !line.match /^#/
        if matched = line.match /^(\[)*(http:\/\/[^ \]]+).*$/
          a = matched[2].split(/ /)
          pages.push a[0]
          secs.push if a.length > 1 then parseInt(a[1]) else 10
    displayNext pages, secs, seq

$ ->
  pairs = location.search.substring(1).split('&')
  checkAndRun pairs.indexOf('play=seq') >= 0
