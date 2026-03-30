var	log = log4javascript.getLogger("ajaxCFC");

var popUpAppender = new log4javascript.PopUpAppender();
popUpAppender.setFocusPopUp(true);
popUpAppender.setReopenWhenClosed(true);
log.addAppender(popUpAppender);

/*
var browserConsoleAppender = new log4javascript.BrowserConsoleAppender();
log.addAppender(browserConsoleAppender);
*/

DWREngine.setDebug(true);