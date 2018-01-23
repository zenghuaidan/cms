//browser mobile check
function isiphone() { if ((navigator.userAgent.match(/iPhone/i))) return true; else return false; }
function isipad() { if ((navigator.userAgent.match(/iPad/i))) return true; else return false; }
function isiphoneipad() { if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPad/i))) return true; else return false; }
function isios(v) {	
	var re = new RegExp("OS "+v,"i");
	if ((navigator.userAgent.match(re)) ) return true;
	else return false;
}
function isandroid() { 
	var ua = navigator.userAgent.toLowerCase();
	return (ua.indexOf("android") > -1); 
}

/*function ismobdev() { return (isipad()||isandroid()); }*/
function ismobdev() { return (isiphone() || isandroid()); }
