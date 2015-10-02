#
# スライドショー表示「GyaTV 」
# http://GyaTV.com
# 

iframes = []
iframeIndex = 0
iframePools = 3

imgdivs = []
imgs = []
imgIndex = 0
imgPools = 3

body = $('body')
body.css
  margin: '0'
  padding: '0'
  border: '0'
  # 'background-image': 'url("/images/exclusive_paper.gif")'
  
for i in [0...iframePools]
  iframe = $('<iframe>')
    .attr
      frameborder: '0'
      marginwidth: '0'
    .css
      width: '100%'
      height: '100%'
      position: 'absolute'
      top: '0'
      left: '0'
      margin: '0'
      padding: '0'
      border: '0'
      display: 'none'
  body.append iframe
  iframes.push iframe

for i in [0...imgPools]
  div = $('<div>')
    .attr
      align: 'center'
    .css
      margin: '0'
      padding: '0'
      border: '0'
      display: 'none'
      height: '100%'
      'background-color': '#444'
  img = $('<img>')
    .css
     margin: '0'
     padding: '0'
     border: '0'
     height: '100%'
  div.append img
  body.append div
  imgdivs.push div
  imgs.push img

pages = []
secs = []   # 何秒待つか

curElement = null
nextElement = null

timeout = null

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
      loadPage imgs[imgIndex], url
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
    imgIndex = (imgIndex+1) % imgs.length
    nextElement = imgdivs[imgIndex]
    loadPage imgs[imgIndex], url # 非同期でロードしておく
  else
    iframeIndex = (iframeIndex+1) % iframes.length
    nextElement = iframes[iframeIndex]
    loadPage nextElement, url  # 非同期でロードしておく
  timeout = setTimeout ->
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
      clearTimeout timeout if timeout
      displayNext true
