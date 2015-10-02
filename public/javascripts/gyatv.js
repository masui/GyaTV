var body = $('body');
body.css('margin','0');
body.css('padding','0');
body.css('border','0');

var iframePools = 3;
var iframes = new Array(iframePools);
var iframeIndex = 0;
for(var i=0;i < iframePools;i++){
    var iframe = $('<iframe>');
    iframe.css('width','100%');
    iframe.css('height','100%');
    iframe.css('position','absolute');
    iframe.css('top','0');
    iframe.css('left','0');
    iframe.css('margin','0');
    iframe.css('padding','0');
    iframe.css('border','0');
    iframe.css('display','none');
    iframe.attr('frameborder','0');
    iframe.attr('marginwidth','0');
    body.append(iframe);
    iframes[i] = iframe;
}

var imgPools = 3;
var imgs = new Array(imgPools);
var divs = new Array(imgPools);
var imgIndex = 0;
for(var i=0;i < imgPools;i++){
    var div = $('<div>');
    div.css('margin','0');
    div.css('padding','0');
    div.css('border','0');
    div.css('display','none');
    div.css('height','100%');
    div.css('background-color','#444');
    div.attr('align','center');
    body.append(div);
    var img = $('<img>');
    img.css('margin','0');
    img.css('padding','0');
    img.css('border','0');
    img.css('height','100%');
    div.append(img);
    
    //  var img = $('<img>');
    //  //img.css('width','100%');
    //  img.css('height','100%');
    //  img.css('position','absolute');
    //  img.css('top','0');
    //  img.css('left','0');
    //  img.css('margin','0');
    //  img.css('padding','0');
    //  img.css('border','0');
    //  img.css('display','none');
    //  img.attr('frameborder','0');
    //  img.attr('marginwidth','0');
    //  img.attr('margin','auto');
    //  body.append(img);
    divs[i] = div;
    imgs[i] = img;
}

var pages = [];
var secs = [];  // 何秒待つか
var pageIndex = 0;

var curElement, nextElement;
var timeout = null;

function rand(n){
    return Math.floor(Math.random() * n);
}

function displayNext(firsttime){
    if(firsttime){
	pageIndex = rand(pages.length);
	imgIndex = 0;
	iframeIndex = 0;
	url = pages[pageIndex];
	if(url.match(/(png|jpg|gif)$/i)){
	    curElement = divs[imgIndex];
	    loadPage(imgs[imgIndex],url);
	}
	else {
	    curElement = iframes[iframeIndex];
	    loadPage(curElement,url);
	}
	curElement.css('display','block');
    }
    else {
	curElement.css('display','none');
	nextElement.css('display','block');
	curElement = nextElement;
    }
    sec = secs[pageIndex];
    // 次に表示するページをバックグラウンドでロード
    //pageIndex = (pageIndex+1) % pages.length;
    pageIndex = rand(pages.length);
    if(pageIndex == 0){
	checkAndRun();
    }
    url = pages[pageIndex];
    if(url.match(/(png|jpg|gif)$/i)){
	imgIndex = (imgIndex+1) % imgs.length;
	nextElement = divs[imgIndex];
	loadPage(imgs[imgIndex],url); // 非同期でロードしておく
    }
    else {
	iframeIndex = (iframeIndex+1) % iframes.length;
	nextElement = iframes[iframeIndex];
	loadPage(nextElement,url); // 非同期でロードしておく
    }
    
    // checkAndRun();
    
    timeout = setTimeout(function(){ displayNext(false); }, sec * 1000);
}

// バックグラウンドでページ内容をロード
function loadPage(e,src){
    setTimeout(function(){
	e.attr('src',src);
    },0);
}

var curJSON = [];

function checkAndRun(){
    $.getJSON(gyatvURL, function(data){
	if(data['data'].join() != curJSON.join()){
	    curJSON = data['data'];
	    // v = eval(curJSON);
	    v = curJSON;
	    pages = [];
	    pageIndex = 0;
	    for(var i in v){
		line = v[i];
		if(!line.match(/^#/)){
		    if(matched = line.match(/^(\[)*(http:\/\/[^ \]]+).*$/)){
			a = matched[2].split(/ /);
			pages.push(a[0]);
			sec = 10;
			if(a.length > 1) sec = parseInt(a[1]);
			secs.push(sec);
		    }
		}
	    }
	    if(timeout) clearTimeout(timeout);
	    displayNext(true);
	}
    });
}
