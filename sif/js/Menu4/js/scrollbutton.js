//<script>
/*
 * ScrollButton
 *
 * This script was designed for use with DHTML Menu 4
 *
 * This script was created by Erik Arvidsson
 * (http://webfx.eae.net/contact.html#erik)
 * for WebFX (http://webfx.eae.net)
 * Copyright 2002
 * 
 * For usage see license at http://webfx.eae.net/license.html	
 *
 * Version: 1.0
 * Created: 2002-05-28
 * Updated: 
 *
 */

function ScrollButton( oEl, oScrollContainer, nDir ) {
	this.htmlElement = oEl;
	this.scrollContainer = oScrollContainer;
	this.dir = nDir;
	
	var oThis = this;
	oEl.attachEvent( "onmouseover", function () {
		oThis.startScroll();
	} );
	oEl.attachEvent( "onmouseout", function () {
		oThis.endScroll();
	} );
}

ScrollButton.scrollIntervalPause = 100;
ScrollButton.scrollAmount = 18;

ScrollButton.prototype.startScroll = function () {
	var oThis = this;
	this._interval = window.setInterval( function () {
		switch ( oThis.dir ) {
		
			case 8:
				oThis.scrollContainer.scrollTop -= ScrollButton.scrollAmount;
				break;
			
			case 2:
				oThis.scrollContainer.scrollTop += ScrollButton.scrollAmount;
				break;
		
			case 4:
				oThis.scrollContainer.scrollLeft -= ScrollButton.scrollAmount;
				break;
			
			case 6:
				oThis.scrollContainer.scrollLeft += ScrollButton.scrollAmount;
				break;
		}
	}, ScrollButton.scrollIntervalPause );
};

ScrollButton.prototype.endScroll = function () {
	if ( this._interval != null ) {
		window.clearInterval( this._interval );
		delete this._interval;
	}
};