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

displayNext = (firsttime) ->
  if firsttime
    pageIndex = rand window.pages.length
    window.imgIndex = 0
    window.iframeIndex = 0
    url = window.pages[pageIndex]
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
    
  # pageIndex = (pageIndex+1) % window.pages.length;  # シーケンシャル
  pageIndex = rand window.pages.length                # ランダム
  sec = window.secs[pageIndex]
  url = window.pages[pageIndex]
  if url.match /(png|jpg|gif)$/i
    window.imgIndex = (window.imgIndex+1) % imgdivs.length
    window.nextElement = imgdivs[window.imgIndex]
    loadPage window.nextElement.children(), url # 非同期でロードしておく
  else
    window.iframeIndex = (window.iframeIndex+1) % iframes.length
    window.nextElement = iframes[window.iframeIndex]
    loadPage window.nextElement, url  # 非同期でロードしておく
  setTimeout ->
    displayNext false
  , sec * 1000

# バックグラウンドでページ内容をロード
loadPage = (e,src) ->
  setTimeout ->
    e.attr 'src', src
  ,0

checkAndRun = ->
  $.getJSON gyatvURL, (data) ->
    window.pages = []
    window.secs = []
    pageIndex = 0
    for line in data['data']
      if !line.match /^#/
        if matched = line.match /^(\[)*(http:\/\/[^ \]]+).*$/
          a = matched[2].split(/ /)
          window.pages.push a[0]
          window.secs.push if a.length > 1 then parseInt(a[1]) else 5
    displayNext true
