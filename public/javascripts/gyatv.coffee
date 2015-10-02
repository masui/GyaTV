#
# スライドショー表示「GyaTV 」
# http://GyaTV.com
# 

iframeIndex = 0
imgIndex = 0

body = $('body')
  
iframes = [0..2].map -> 
  $('<iframe frameborder="0" marginwidth="0">')
    .appendTo(body)

imgdivs = [0..2].map ->
  $('<div class="imagediv" align="center">')
    .append $('<img>')
    .appendTo body

pages = []
secs = []   # 何秒待つか

curElement = null
nextElement = null

rand = (n) ->
  Math.floor Math.random() * n

displayNext = (firsttime) ->
  if firsttime
    pageIndex = rand pages.length
    imgIndex = 0
    iframeIndex = 0
    url = pages[pageIndex]
    if url.match /(png|jpg|gif)$/i
      curElement = imgdivs[imgIndex]
      # loadPage imgs[imgIndex], url│
      loadPage curElement.children(), url
    else
      curElement = iframes[iframeIndex]
      loadPage curElement, url
    curElement.css 'display','block'
  else
    curElement.css 'display', 'none'
    nextElement.css 'display', 'block'
    curElement = nextElement
    
  # 次に表示するページをバックグラウンドでロード
  # pageIndex = (pageIndex+1) % pages.length;
  pageIndex = rand pages.length
  # if pageIndex == 0
  #   checkAndRun()
  sec = secs[pageIndex]
  url = pages[pageIndex]
  if url.match /(png|jpg|gif)$/i
    imgIndex = (imgIndex+1) % imgdivs.length
    nextElement = imgdivs[imgIndex]
    loadPage nextElement.children(), url # 非同期でロードしておく
  else
    iframeIndex = (iframeIndex+1) % iframes.length
    nextElement = iframes[iframeIndex]
    loadPage nextElement, url  # 非同期でロードしておく
  setTimeout ->
    displayNext false
  , sec * 1000

# バックグラウンドでページ内容をロード
loadPage = (e,src) ->
  setTimeout ->
    e.attr 'src', src
  ,0

curJSON = []

checkAndRun = ->
  $.getJSON gyatvURL, (data) ->
    if data['data'].join() != curJSON.join()
      curJSON = data['data']
      # v = curJSON
      pages = []
      pageIndex = 0
      for line in curJSON
        if !line.match /^#/
          if matched = line.match /^(\[)*(http:\/\/[^ \]]+).*$/
            a = matched[2].split(/ /)
            pages.push a[0]
            sec = 5
            if a.length > 1
              sec = parseInt a[1]
            secs.push sec
      displayNext true
