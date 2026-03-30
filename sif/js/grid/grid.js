/*----------------------------------------------------------------------------\
|                               Grid Widget 1.0                               |
|-----------------------------------------------------------------------------|
|                          Created by Emil A Eklund                           |
|                  (http://webfx.eae.net/contact.html#emil)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An object based grid widget, targeted at database powered web applications, |
| incorporating features found in popular spreadsheet and database management |
| applications. Currently only internet explorer 5.5 and later are supported. |
|-----------------------------------------------------------------------------|
|                   Copyright (c) 2000 - 2003 Emil A Eklund                   |
|-----------------------------------------------------------------------------|
| This software is provided "as is", without warranty of any kind, express or |
| implied, including  but not limited  to the warranties of  merchantability, |
| fitness for a particular purpose and noninfringement. In no event shall the |
| authors or  copyright  holders be  liable for any claim,  damages or  other |
| liability, whether  in an  action of  contract, tort  or otherwise, arising |
| from,  out of  or in  connection with  the software or  the  use  or  other |
| dealings in the software.                                                   |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| This  software is  available under the  three different licenses  mentioned |
| below.  To use this software you must chose, and qualify, for one of those. |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Non-Commercial License          http://webfx.eae.net/license.html |
| Permits  anyone the right to use the  software in a  non-commercial context |
| free of charge.                                                             |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Commercial license           http://webfx.eae.net/commercial.html |
| Permits the  license holder the right to use  the software in a  commercial |
| context. Such license must be specifically obtained, however it's valid for |
| any number of  implementations of the licensed software.                    |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| GPL - The GNU General Public License    http://www.gnu.org/licenses/gpl.txt |
| Permits anyone the right to use and modify the software without limitations |
| as long as proper  credits are given  and the original  and modified source |
| code are included. Requires  that the final product, software derivate from |
| the original  source or any  software  utilizing a GPL  component, such  as |
| this, is also licensed under the GPL license.                               |
|-----------------------------------------------------------------------------|
| Dependencies: grid.css (To set up the CSS of the grid classes)              |
|-----------------------------------------------------------------------------|
| 2002-07-03 | Fixed quite a few focus/blur realted bugs, and updated the key |
|            | navigation code to better support the home and end keys.       |
| 2002-08-05 | The setNewIds method now accepts the id substitute -1 as as an |
|            | an  indicator that  something went wrong,  thus resetting  the |
|            | changed flag for each column in the affected row.              |
| 2002-08-06 | Added the setColLengths method, can  be used  to limit the max |
|            | length that can be typed into each column.                     |
| 2002-08-07 | Rows may now be selected by clicking on the id column.         |
| 2002-08-08 | Fixed a  bug that  caused all key  navigation to stop  working |
|            | when either deleting a row or selecting one by clicking on the |
|            | id column for that row.                                        |
| 2002-08-11 | Fixed a few minor problems caused by the previous fix.         |
| 2002-09-22 | Renamed dumpMatrix method to getGridData.                      |
|-----------------------------------------------------------------------------|
| Created 2000-01-20 | All changes are in the log above. | Updated 2002-09-22 |
\----------------------------------------------------------------------------*/

var webFXGridHandler = {
	idCounter : 0,
	idPrefix  : "webfx-grid-object-",
	getId     : function() { return this.idPrefix + this.idCounter++; },
	all       : {},
	scroll    : function(id) { this.all[id]._scroll(); },
	resize    : function(id) { this.all[id].calcSize(); },
	click     : function() { var e = getElement(window.event.srcElement); if (e) { this.all[e.id].click(); } },
	select    : function() {
		var e = getElement(window.event.srcElement);
		if ((e) && (e.tagName == 'TD')) {
			var s = e.parentNode.parentNode.parentNode.parentNode.className;
			if (s == 'webfxGridMain') { this.all[e.id].select(); }
			else if (s == 'webfxGridMainIdCol') { this.all[e.rowid].select(true); }
		}
	},
	deselect  : function() { var e = getElement(window.event.srcElement); if ((e) && (e.tagName == 'TD') && (this.all[e.id])) { this.all[e.id].parent.deselect(); } },
	over      : function() { var e = getElement(window.event.srcElement); if ((e) && (e.tagName == 'TD') && (this.all[e.id])) { this.all[e.id].parent.over(); } },
	out       : function() { var e = getElement(window.event.srcElement); if ((e) && (e.tagName == 'TD') && (this.all[e.id])) { this.all[e.id].parent.out(); } },
	keydown   : function() { var e = getElement(window.event.srcElement); if ((e) && (e.tagName == 'TD') && (this.all[e.id])) { this.all[e.id].parent.parent._selected._handleKey(); } },
	//select    : function() { return (window.event.srcElement.tagName == 'INPUT')?true:false; },
	boxkey    : function() { return this.all[window.event.srcElement.id]._handleKey(); },
	boxblur   : function() { this.all[window.event.srcElement.id]._blurBox(); },
	sort      : function(id, col) { this.all[id].sort(col); },
	headDown  : function(e) { this.all[e.id]._headDown(); },
	headUp    : function(e) { this.all[e.id]._headUp(); },
	headMove  : function(e) { this.all[e.id]._headMove(); }
};

function getElement(e) {
	if (e.tagName == 'TD') { return e; }
	else if (e.tagName == 'SPAN') { return e.parentNode; }
	else return null;
}

function WebFXGrid(p0, p1, bUnescapeData) {
	var r = (p0.length)?p0.length:p0;
	var c = (p0.length && p0[0].length)?p0[0].length:p1;
	this.id = webFXGridHandler.getId();
	webFXGridHandler.all[this.id] = this;
	this.rows          = new Array();
	this.headers       = new Array();
	this.colSizes      = new Array();
	this.colFlags      = new Array();
	this.colLinkData   = new Array();
	this.colDefault    = new Array();
	this.colTypes      = new Array();
	this.colLengths    = new Array();
	this.cols          = c;
	this.flags         = 7; /* bit map | 1 - update, 2 - insert, 4 - delete */
	this.minimal       = 25;
	this.defColSize    = 100;
	this.resizeArea    = 7; // Actual
	this.resizeAreaV   = 5; // Visible
	this.hideBoxOnBlur = true;
	this.groupByFirst  = false;
	this.colSort       = true;
	this.autoExpand    = false;
	this._active       = false;
	this._selected     = null;
	this._selectedRow  = null;
	this._selectedCell = null;
	this._boxid        = null;
	this._uri          = null;
	this._rendered     = false;
	this._showsid      = true;
	this._sortBy       = 0;
	this._sortDesc     = true;
	this._headCell     = null;
	this._headX        = null;
	this._headChange   = null;
	this._headSize     = null;
	this._headColSize  = new Array();
	this._headColSplit = new Array();
	this.onSelect      = null;
	this.onColResize   = null;
	this.onSort        = null;
	this.onChange      = null;
	this.onNewRow      = null;
	for (var i = 0; i < r; i++) {
		this.rows[i] = new WebFXGridRow(((p0.length > i)?p0[i]:c), -1, bUnescapeData);
		this.rows[i].parent = this;
}	}

WebFXGrid.prototype.setCellValue = function(iRow, iCell, sValue, iIndex) {
	if ((iRow >= this.rows.length) || (iCell >= this.rows[iRow].cells.length)) { return; }
	var oCell = this.rows[iRow].cells[iCell];
	var eCell = document.getElementById(oCell.id).childNodes(0);
	var iSid = oCell.parent.sid;
	oCell.value = new String(sValue);
	oCell._changed = true;
	if (oCell._dropdown) {
		var sText = '<No Data Selected>';
		if (oCell.value.indexOf(',') > 0) { sText = '<Multiple Values>'; }
		else {
			var d = this.colLinkData[iCell];
			if (d.length > 1) {
				var iCounter = -1, iSelected = 1, d = this.colLinkData[iCell];
				for (var i = 1; i < d.length; i++) {
					if (iIndex >= 0) {
						if ((d[i][2] == iSid) || (d[i][2] == 0)) { iCounter++; }
						if (iCounter == iIndex) { iSelected = i; oCell.value = d[i][0]; break; }
					}
					else if (d[i][0] == oCell.value) { iSelected = i; break; }
				}
				sText = d[iSelected][1];
	}	}	}
	else { sText = oCell.value; }
	eCell.innerText = sText;
}

WebFXGrid.prototype.setUri = function(s) {
	this._uri = s;
}

WebFXGrid.prototype.setHeaders = function(a) {
	this.headers = a;
}

WebFXGrid.prototype.setColSizes = function(a) {
	this.colSizes = a;
}

WebFXGrid.prototype.getColSizes = function() {
	return this.colSizes;
}

WebFXGrid.prototype.setAutoExpand = function(b) {
	this.autoExpand = b;
}

WebFXGrid.prototype.setRowsServerIds = function(a) {
	for (var i = 0; i < this.rows.length; i++) {
		this.rows[i].sid = a[i];
	}
}

WebFXGrid.prototype.setLinkData = function(a) {
	this.colLinkData = a;
}

WebFXGrid.prototype.setColDropData = WebFXGrid.prototype.setLinkData;

WebFXGrid.prototype.setColTypes = function(a) {
	/* 0 - int
	 * 1 - string
	 * 2 - date
	 * 3 - float
	 */
	this.colTypes = a;
}


WebFXGrid.prototype.setColFlags = function(a) {
	/* Bitmap
	 * Bit 1 - Read only
	 * Bit 2 - Mandatory
	 * Bit 4 - Mask data (password field)
	 * Bit 8 - Hidden
	 */
	this.colFlags = a;
}

WebFXGrid.prototype.setColLengths = function(a) {
	this.colLengths = a;
}

WebFXGrid.prototype.setCellStyles = function(a) {
	for (var r = 0; r < this.rows.length; r++) {
		for (var c = 0; c < this.rows[r].cells.length; c++) {
			if ((a.length > r) && (a[r].length > c) && (a[r][c])) {
				this.rows[r].cells[c].style = a[r][c];
}	} }	}

WebFXGrid.prototype.setColDefault = function(a) {
	this.colDefault = a;
}

WebFXGrid.prototype.getShowSid = function() {
	return this._showsid;
}

WebFXGrid.prototype.setShowSid = function(b) {
	if (b == null) {
		if (this._showsid) { this._showsid = false; }
		else { this._showsid = true; }
	}
	else { this._showsid = b; }
	if (this._rendered) { this._updateIdCol(); }
}

WebFXGrid.prototype.getSelected = function() {
	return this._selected;
}

WebFXGrid.prototype.selectFirst = function() {
	this.rows[0].select();
}

WebFXGrid.prototype.selectLast = function() {
	this.rows[this.rows.length - 1].select();
}

WebFXGrid.prototype._updateIdCol = function() {
	document.getElementById(this._corn).childNodes(0).innerText = ((this._showsid)?'ID':'#');
	row = 0;
	for (var i = 0; i < this.rows.length; i++) {
		if (!this.rows[i]._deleted) {
			if ((!this._selectedRow) || (this._selected != this.rows[i]) || !(this._active)) {
				document.getElementById(this.rows[i].id).className = ((!this._showsid) && (row & 0x01))?'odd':'even';
			}
			if (document.getElementById(this._idcl).childNodes(0).childNodes(0).childNodes.length > i) {
				document.getElementById(this._idcl).childNodes(0).childNodes(0).childNodes(i).childNodes(0).innerText = (this._showsid)?((this.rows[i].sid != null)?this.rows[i].sid:'-'):(row + 1);
				row++;
}	}	}	}

WebFXGrid.prototype.setNewIds = function(a) {
	var r = 0;
	for (var i = 0; i < this.rows.length; i++) {
		if (this.rows[i].sid == null) {
			if (a.length <= r) { break; }
			if (a[r] == -1) {
				for (var l = 0; l < this.rows[i].cells.length; l++) {
					this.rows[i].cells[l]._changed = true;
				}
			}
			else {
				this.rows[i].sid = a[r];
				if (this._showsid) { document.getElementById(this._idcl).childNodes(0).childNodes(0).childNodes(i).childNodes(0).innerText = a[r]; }
			}
			r++;
}	}	}

WebFXGrid.prototype.setId = function(i, id) {
	this.rows[i].sid = id;
	if (this._showsid) { document.getElementById(this._idcl).childNodes(0).childNodes(0).childNodes(i).childNodes(0).innerText = id; }
}

WebFXGrid.prototype.setHideBoxOnBlur = function(b) {
	this.hideBoxOnBlur = b;
}

WebFXGrid.prototype.sort = function(col) {
	if (!this.colSort) { return; }
	this.hideBox();
	var selectedEl = null;
	if (this._selected) {
		this._selected.deselect(true);
		selectedEl = this._selected;
		this._selected = null;
	}
	if (this._sortBy == col) { this._sortDesc = !this._sortDesc; }
	if (col == -1) { this.rows.sort(compareBySid(this._sortDesc)); }
	else { this.rows.sort(compareByColumn(col, this._sortDesc, this.colTypes[col])); }
	var e = document.getElementById(this._main).childNodes(0).childNodes(1);
	var cell, selected, d, o;
	var cl = document.getElementById(this._idcl).childNodes(0).childNodes(0).childNodes;
	if (col >= 0) {
		var b = document.getElementById(this._head).childNodes(0).childNodes(0).childNodes(0).childNodes(col)._sort;
		if (b == false) { return false; }
	}
	if (this._rendered) {
		for (var r = 0; r < e.childNodes.length; r++) {
			for (var c = 0; c < e.childNodes[r].childNodes.length; c++) {
				cell = e.childNodes(r).childNodes(c);
				o = this.rows[r].cells[c];
				if (o._dropdown) {
					if (o.value.indexOf(',') > 0) { cell.childNodes(0).innerText = '<Multiple Values>'; }
					else {
						d = this.colLinkData[c];
						for (var i = 1; i < d.length; i++) {
							if (d[i][0] == o.value) { selected = i; }
						}
						if (!selected) { selected = 0; }
						cell.childNodes(0).innerText = (this.rows[r].sid != null)?d[selected][1]:'';
				}	}
				else { cell.childNodes(0).innerText = (o.value)?o.value:''; }
				cell.id = o.id;
				cell.style.cssText = o.style;
				webFXGridHandler.all[cell.id] = o;
			}
			e.childNodes(r).id = this.rows[r].id;
			webFXGridHandler.all[e.childNodes(r).id] = this.rows[r];
		}
		this._updateIdCol();
	}
	e = document.getElementById(this._head).childNodes(0).childNodes(0).childNodes(0);
	if (this._sortBy >= 0) { e.childNodes(this._sortBy).childNodes(1).innerText = ''; }
	else { document.getElementById(this._corn).childNodes(1).innerText = ''; }
	if (col >= 0) { e.childNodes(col).childNodes(1).innerText = ((this._sortDesc)?5:6); }
	else { document.getElementById(this._corn).childNodes(1).innerText = ((this._sortDesc)?5:6); }
	this._sortBy = col;
	if (selectedEl) {
		var o = document.getElementById(selectedEl.id);
		var main = document.getElementById(this._main);
		var head = document.getElementById(this._head);
		if (main.scrollTop > o.offsetTop) { main.scrollTop = o.offsetTop - 1; }
		if ((main.scrollTop + main.clientHeight) - o.offsetTop - head.offsetHeight < o.offsetHeight) { main.scrollTop = o.offsetTop - (main.clientHeight - o.offsetHeight) + head.offsetHeight - 1; }
		selectedEl.select();
	}
	if (this.onSort) { this.onSort(this); }
}

WebFXGrid.prototype.find = function(condition) {
	var o, d, str, selected;
	for (var r = 0; r < this.rows.length; r++) {
		for (var c = 0; c < this.rows[r].cells.length; c++) {
			o = this.rows[r].cells[c];
			if (o._dropdown) {
				d = this.colLinkData[c];
				for (var i = 1; i < d.length; i++) {
					if (d[i][0] == o.value) { selected = i; }
				}
				if (o.value == -1) { str = ""; }
				else { str = d[selected][1]; }
			}
			else { str = o.value; }
			if (str.indexOf(condition) >= 0) { this.rows[r].select(); break; }
}	}	}

WebFXGrid.prototype.addRow = function(p0, sid) {
	if (!(this.flags & 0x02)) { return; }
	if (!p0) { p0 = this.cols; }
	var r = (p0[0])?p0.length:1;
	var c = (p0[0] && p0[0][0])?p0[0].length:p0;
	if ((p0[0]) && (!p0[0][0])) {
		var foo = p0;
		p0 = new Array();
		p0[0] = foo;
		r = 1;
	}
	var e, foo, bar;
	for (var i = 0; i < r; i++) {
		this.rows[this.rows.length] = new WebFXGridRow(((p0.length > i)?p0[i]:c), ((sid)?((sid[i])?sid[i]:sid):null));
		this.rows[this.rows.length - 1].parent = this;
		if (this._rendered) {
			e = document.getElementById(this._main).childNodes(0).childNodes(1);
			foo = this.rows[this.rows.length - 1]._generate(e, this.rows.length - 2);
			e.appendChild(foo);
			foo = document.createElement("TR");
			bar = document.createElement("TD");
			bar.innerText = '-';
			bar.rowid = this.rows[this.rows.length - 1].id;
			bar.onclick = function() { webFXGridHandler.select(); }
			foo.appendChild(bar);
			document.getElementById(this._idcl).childNodes(0).childNodes(0).appendChild(foo);
	}	}
	if (!this._showsid) { this._updateIdCol(); }
	if (this.onNewRow) { this.onNewRow(this); }
}

WebFXGrid.prototype.removeRow = function(row) {
	if (!(this.flags & 0x04)) { return; }
	var e = ((row)?row:this._selectedRow);
	var o = webFXGridHandler.all[e.id];
	if (!o) { return; }
	var sibling = ((e.previousSibling)?e.previousSibling:e.nextSibling);
	if (sibling) { webFXGridHandler.all[sibling.id].select(true); }
	for (var i = 0; i < e.parentNode.childNodes.length; i++) {
		if (e.parentNode.childNodes(i).id == e.id) { break; }
	}
	e.parentNode.deleteRow(i);
	document.getElementById(this._idcl).childNodes(0).childNodes(0).deleteRow(i);
	o._remove();
	if (!this._showsid) { this._updateIdCol(); }
	if (this.onChange) { this.onChange(this); }
}

WebFXGrid.prototype.addCol = function(sValue) {
	if (!(this.flags & 0x02)) { return; }
	for (var i = 0; i < this.rows.length; i++) {
		this.rows[i].cells[this.rows[i].cells.length] = new WebFXGridCell(sValue);
		this.rows[i].cells[this.rows[i].cells.length - 1].parent = this.rows[i];
		if (this._rendered) {
			document.getElementById(this.rows[i].id).appendChild(this.rows[i].cells[this.rows[i].cells.length - 1]._generateCell());
	}	}
	if (this._rendered) {
		var e = document.getElementById(this.id).childNodes(0).childNodes(0).childNodes(0);
		var c = e.insertCell(e.childNodes.length - 1);
		c.innerText = sValue;
	}
	this.cols++;
}

WebFXGrid.prototype.dump = function(b) {
	var foo, str, rows, count = 0;
	rows = this._uri + 'rows=[';
	str = ']';
	for (var i = 0; i < this.rows.length; i++) {
		foo = this.rows[i]._dump(b);
		if (foo) {
			if (this.rows[i].sid != null) {
				if (count) { rows += ','; }
				rows += escape(this.rows[i].sid);
			}
			str += foo; count++;
	}	}
	for (var i = 0; i < this.rows.length; i++) {
		if (this.rows[i]._deleted) { this.rows[i]._remove(); }
	}
	if (count) { return rows + str; }
	else { return null; }
}

WebFXGrid.prototype.getGridData = function() {
	var a = new Array;
	for (var r = 0; r < this.rows.length; r++) {
		a[r] = new Array;
		for (var c = 0; c < this.rows[r].cells.length; c++) {
			a[r][c] = escape(this.rows[r].cells[c].value);
	}	}
	return a;
}

/* Deprecated */
WebFXGrid.prototype.dumpMatrix = WebFXGrid.prototype.getGridData;

WebFXGrid.prototype.setSize = function(w, h) {
	document.getElementById(this.id).style.width = w;
	document.getElementById(this.id).style.height = h;
	this.calcSize();
}

WebFXGrid.prototype.calcSize = function() {
	var root   = document.getElementById(this.id);
	var main   = document.getElementById(this._main);
	var corner = document.getElementById(this._corn);
	var head   = document.getElementById(this._head);
	var idcol  = document.getElementById(this._idcl);
	var x = main.clientLeft;
	var y = main.clientTop;
	main.style.width   = root.clientWidth;
	main.style.height  = root.clientHeight;
	corner.style.top   = y;
	corner.style.left  = x;
	head.style.left    = x + corner.offsetWidth;
	head.style.top     = y;
	idcol.style.left   = x;
	idcol.style.top    = y + corner.offsetHeight;
	head.style.width   = main.clientWidth - idcol.clientWidth;
	idcol.style.height = main.clientHeight - head.clientHeight;
}

WebFXGrid.prototype.focus = function() {
	if (this.getSelected()) { this.getSelected().select(); }
	else { this.selectFirst(); }
};

WebFXGrid.prototype.toString = function() {
	this._boxid   = webFXGridHandler.getId(); webFXGridHandler.all[this._boxid]   = this;
	this._dropid  = webFXGridHandler.getId(); webFXGridHandler.all[this._dropid]  = this;
	this._drop2id = webFXGridHandler.getId(); webFXGridHandler.all[this._drop2id] = this;
	this._main = webFXGridHandler.getId(); webFXGridHandler.all[this._main] = this;
	this._corn = webFXGridHandler.getId(); webFXGridHandler.all[this._corn] = this;
	this._head = webFXGridHandler.getId(); webFXGridHandler.all[this._head] = this;
	this._idcl = webFXGridHandler.getId(); webFXGridHandler.all[this._idcl] = this;
	this._rendered = true;
	var str = '<div id="' + this.id + '" class="webfxGrid" onresize="webFXGridHandler.resize(this.id);" onfocus="webFXGridHandler.select(this.id);" onselectstart="webFXGridHandler.select();" onmousedown="webFXGridHandler.headDown(this);" onmousemove="webFXGridHandler.headMove(this);" onmouseup="webFXGridHandler.headUp(this);">';
	str += '<div id="' + this._main + '" class="webfxGridMain" onfocus="webFXGridHandler.select(this.parentNode.id);" onscroll="webFXGridHandler.scroll(this.parentNode.id);">';
	str += '<table cellspacing="0" onclick="webFXGridHandler.click();" ondblclick="webFXGridHandler.click();" onmouseover="webFXGridHandler.over();" onmouseout="webFXGridHandler.out();" onkeydown="webFXGridHandler.keydown(); return false;">';
	str += '<colgroup span="' + this.cols + '">'
	for (var i = 0; i < this.cols; i++) {
		str += '<col style="width: ' + ((this.colSizes[i])?this.colSizes[i]:this.defColSize) + ';" />';
	}
	str += '</colgroup>'
	for (var i = 0; i < this.rows.length; i++) {
		str += this.rows[i]._toString(i);
	}
	str += '</table></div>';
	str += '<div id="' + this._corn + '" onclick="webFXGridHandler.sort(this.parentNode.id,-1);" class="webfxGridMainCorner"><nobr>ID</nobr><span></span></div>';
	str += '<div id="' + this._head + '" class="webfxGridMainHeader"><table cellspacing="0"><tr>';
	for (var i = 0; i < this.cols; i++) {
		str += '<td style="width: ' + ((this.colSizes[i])?this.colSizes[i]:this.defColSize) + ';" onclick="webFXGridHandler.sort(this.parentNode.parentNode.parentNode.parentNode.parentNode.id,' + i + ');"><nobr>' + this.headers[i] + '</nobr><span>' + ((this._sortBy == i)?'5':'') + '</span></td>';
	}
	str += '</tr></table></div>';
	str += '<div id="' + this._idcl + '" class="webfxGridMainIdCol"><table cellspacing="0">';
  for (var i = 0; i < this.rows.length; i++) {
		str += '<tr><td onclick="webFXGridHandler.select()" rowid="' + this.rows[i].id + '">' + ((this.rows[i].sid != null)?this.rows[i].sid:'-') + '</td></tr>';
	}
	str += '</table></div>';
	str += '<input type="text" id="' + this._boxid + '" class="webfxGridBox" onkeydown="return webFXGridHandler.boxkey();" onblur="webFXGridHandler.boxblur();" />';
	str += '<select id="' + this._dropid + '" class="webfxGridBox" onkeydown="return webFXGridHandler.boxkey();" onblur="webFXGridHandler.boxblur();"></select>';
	str += '<select multiple="true" id="' + this._drop2id + '" class="webfxGridBox" onkeydown="return webFXGridHandler.boxkey();" onblur="webFXGridHandler.boxblur();"></select>';
	str += '</div>';
	return str;
}

function WebFXGridRow(p0, sid, bUnescapeData) {
	var c         = (p0.length)?p0.length:p0;
	this.id       = webFXGridHandler.getId();
	this.cells    = new Array();
	this.parent   = null;
	this.sid      = sid || null;
	this._deleted = false;
	webFXGridHandler.all[this.id] = this;
	for (var i = 0; i < c; i++) {
		this.cells[i] = new WebFXGridCell((p0.length > i)?((bUnescapeData)?unescape(p0[i]):p0[i]):"");
		this.cells[i].parent = this;
}	}

WebFXGridRow.prototype.over = function() {
	if (this.parent._selected != this) {
		var e = document.getElementById(this.id);
		e.style.background = '#DEDEFF'
}	}

WebFXGridRow.prototype.out = function() {
	if (this.parent._selected != this) {
		var e = document.getElementById(this.id);
		e.className = ((!this.parent._showsid) && (e.rowIndex & 0x01))?'odd':'even';
}	}

WebFXGridRow.prototype.select = function(b) {
	if ((this.parent._selected) && (this.parent._selected != this)) {
		var e = document.getElementById(this.parent._selected.id);
		e.className = ((!this.parent._showsid) && (e.rowIndex & 0x01))?'odd':'even';
	}
	document.getElementById(this.id).className = 'selected';
	this.parent._active = true;
	this.parent._selected = this;
	this.parent._selectedRow = document.getElementById(this.id);
	if (b) {
		document.getElementById(this.id).childNodes(0).focus();
		document.getElementById(this.parent._main).scrollLeft = 0
	}
	if (this.parent.onSelect) { this.parent.onSelect(this); }
}

WebFXGridRow.prototype.deselect = function(b) {
	if (!(b) && ((document.activeElement.tagName == 'INPUT') || (document.activeElement.tagName == 'SELECT'))) { return; }
	var e = document.getElementById(this.parent._selected.id);
	e.className = ((!this.parent._showsid) && (e.rowIndex & 0x01))?'odd':'even';
	var w;
	for (var i = 1; i < e.childNodes.length; i++) {
		w = e.childNodes(i).style.width;
		e.childNodes(i).style.cssText = this.cells[i-1].style;
		if (w) { e.childNodes(i).style.width = w; }
	}
	this.parent._active = false;
}

WebFXGridRow.prototype._initRow = function() {
	var e, l, v, str, d = this.parent.colLinkData;
	for (var i = 0; i < this.cells.length; i++) {
		e = document.getElementById(this.cells[i].id); v = 0;
		if ((this.parent.colDefault[i]) && !(this.cells[i].value)) { this.cells[i].value = this.parent.colDefault[i]; }
		if (this.cells[i]._dropdown) {
			for (l = 1; l < d[i].length; l++) {
				if (d[i][l][0] == this.cells[i].value) { v = l; break; }
			}
			str = d[i][v][1];
		}
		else { str = this.cells[i].value; }
		e.childNodes(0).innerText = str;
		this.cells[i]._changed = true;
	}
}

WebFXGridRow.prototype._handleKey = function() {
	var key = window.event.keyCode;
	if ((key == 38) || (key == 40) || (key == 35) || (key == 36)) {
		var o;
		if (key == 38) { o = document.getElementById(this.id).previousSibling; }
		else if (key == 40) { o = document.getElementById(this.id).nextSibling; }
		else if (key == 35) { o = document.getElementById(this.parent.rows[this.parent.rows.length - 1].id); }
		else { o = document.getElementById(this.parent.rows[0].id); }
		if (o) {
			var main = document.getElementById(this.parent._main);
			var head = document.getElementById(this.parent._head);
			if (main.scrollTop > o.offsetTop) { main.scrollTop = o.offsetTop - 1; }
			if ((main.scrollTop + main.clientHeight) - o.offsetTop - head.offsetHeight < o.offsetHeight) { main.scrollTop = o.offsetTop - (main.clientHeight - o.offsetHeight) + head.offsetHeight - 1; }
			webFXGridHandler.all[o.id].select();
		}
	}
	else if (key == 13) { this.parent._showBox(this.cells[0].id); }
	else if (key == 46) { this.parent.removeRow(); }
	//else if (key == 33) { document.getElementById(this.parent.id).childNodes(1).doScroll('scrollbarPageUp'); }
	//else if (key == 34) { document.getElementById(this.parent.id).childNodes(1).doScroll('scrollbarPageDown'); }
}

WebFXGridRow.prototype._toString = function(r) {
	var str = "<tr id=\"" + this.id +"\">";
	//str += "<th>" + ((this.parent._showsid)?((this.sid != null)?this.sid:'-'):i) + "</th>";
	for (var i = 0; i < this.cells.length; i++) {
		str += this.cells[i]._toString(i, r);
	}
	str += "</tr>";
	return str;
}

WebFXGridRow.prototype._remove = function() {
	if ((!this._deleted) && (this.sid)) { this._deleted = true;	}
	else {
		for (var i = 0; i + 1 < this.parent.rows.length; i++) {
			if (this.parent.rows[i].id >= this.id) { this.parent.rows[i] = this.parent.rows[i + 1]; }
		}
		this.parent.rows[this.parent.length-1] = null;
		this.parent.rows.length -= 1;
}	}

WebFXGridRow.prototype._generate = function(e, r) {
	var bar = document.createElement("TR");
	bar.id = this.id;
	for (var i = 0; i < this.cells.length; i++) {
		bar.appendChild(this.cells[i]._generateCell(e, r, i));
	}
	return bar;
}

WebFXGridRow.prototype._dump = function(b) {
	var str = '&' + ((this.sid != null)?this.sid:'new') + '=';
	var changed = 0;
	if (this._deleted) {
		str += 'd';
		changed++;
	}
	else {
		str += '[';
		for (var i = 0; i < this.cells.length; i++) {
			if ((this.cells[i]._changed) || (b)) { str += "'" + escape(this.cells[i].value) + "'"; changed++; }
			this.cells[i]._changed = false;
			if (i + 1 < this.cells.length) { str += ','; }
		}
		str += ']';
	}
	if (changed) { return str; }
	else { return null }
}

function WebFXGridCell(sValue) {
	this.id       = webFXGridHandler.getId();
	this.value    = sValue;
	this.index    = 0;
	this.parent   = null;
	this.style    = '';
	this._collapsed = false;
	this._changed   = false;
	this._dropdown  = false;
	webFXGridHandler.all[this.id] = this;
}

WebFXGridCell.prototype._toString = function(i, r) {
	this.index = i;
	var str, foo, rows = 0;
	if ((this.parent.parent.groupByFirst) && (i == 0) && (!this._collapsed)) {
		for (var n = r + 1; n < this.parent.parent.rows.length; n++) {
			if (this.parent.parent.rows[n].cells[0].value == this.value) { this.parent.parent.rows[n].cells[0]._collapsed = true; rows++; }
	}	}
	str = "<td id=\"" + this.id + "\" ";
	if (rows) { this.style = 'border-bottom: 0px;'; }
	else if (this._collapsed) { this.style = 'border-top: 0px; border-bottom: 0px;'; }
	//this.style += 'width: ' + ((this.parent.parent.colSizes[i])?this.parent.parent.colSizes[i]:this.parent.parent.defColSize) + 'px';
	str += " style=\"" + this.style + "\"";
	str += ">";
	if (!this.value) { this.value = ''; }
	if (this._collapsed) { foo = ''; }
	else if ((this.parent.parent.colLinkData.length > i) && (this.parent.parent.colLinkData[i].length > 1)) {
		this._dropdown = true;
		var d = this.parent.parent.colLinkData[i];
		var selected = 1;
		if (this.value != '') {
			if (this.value.indexOf(',') > 0) { foo = '<Multiple Values>'; }
			else {
				for (var l = 1; l < d.length; l++) {
					if (d[l][0] == this.value) { selected = l; }
				}
				if (d[0] == -1) { foo = ''; }
				else { foo = d[selected][1]; }
		}	}
		else { foo = ''; }
	}
	else { foo = this.value; }
	if (foo) {
		foo = foo.replace('<', '&lt;');
		foo = foo.replace('>', '&gt;');
	}
	str += '<span>' + foo + '</span></td>';
	return str;
}

WebFXGridCell.prototype._generateCell = function(e, r, c) {
	this.index = c;
	var d = this.parent.parent.colLinkData[c];
	var foo = document.createElement("TD");
	var bar = document.createElement("SPAN");
	foo.id = this.id;
	if (d[1]) {
		this._dropdown = true;
		if (this.value) {
			var foobar;
			if (this.value.indexOf(',') >= 0) { foobar = '<Multiple Values>'; }
			else {
				for (var i = 1; i < d.length; i++) {
					if (d[i][0] == this.value) { selected = i; }
				}
				if (this.value == -1) { foobar = ""; }
				else { foobar = d[selected][1]; }
		}	}
		else { foobar = ""; }
		bar.innerText = foobar;
	}
	else { bar.innerText = ((this.value)?this.value:""); }
	foo.appendChild(bar);
	return foo;
}

WebFXGridCell.prototype.click = function() {
	this.parent.parent._hideBox(true);
	this.parent.select(true);
	this.parent.parent._showBox(this.id);
}


/* box functions */

WebFXGrid.prototype._showBox = function (id) {
	var e = document.getElementById(id);
	var o = webFXGridHandler.all[e.id];
	var x = e.offsetLeft;
	var y = e.offsetTop;
	var isd = o._dropdown;
	var txt = document.getElementById(this._boxid);
	var drp = document.getElementById(this._dropid);
	var dr2 = document.getElementById(this._drop2id);
	var box = (o._dropdown)?drp:txt;
	var main = document.getElementById(this._main);
	if (o._collapsed) { box = txt; isd = false; box.readOnly = true; }
	if ((this.colFlags[e.cellIndex] & 0x01) || ((this.colFlags[e.cellIndex] & 0x08) && (o.parent.sid != null)) || !(this.flags & 0x01)) { box = txt; isd = false; box.readOnly = true; }
	if (this.colDefault[e.cellIndex] && !o.value) { o.value = this.colDefault[e.cellIndex]; }
	if (e.offsetLeft < main.scrollLeft) { main.scrollLeft = e.offsetLeft; }
	else if (e.offsetLeft + e.offsetWidth > main.scrollLeft + main.clientWidth) { main.scrollLeft = e.offsetLeft - (main.clientWidth - e.offsetWidth) + document.getElementById(this._idcl).offsetWidth; }
	x += e.offsetParent.offsetLeft;
	y += e.offsetParent.offsetTop;
	var op = e;
	var coltype = this.colTypes[e.cellIndex];
	var maxlen = 255;
	if (coltype == 0) { maxlen = 10; }
	else if ((coltype == 1) && (this.colLengths.length > e.cellIndex)) { maxlen = this.colLengths[e.cellIndex]; }
	else if (coltype == 2) { maxlen = 19; }
	else if (coltype == 3) { maxlen = 20; }
	while (op = op.offsetParent) {
		x -= op.scrollLeft;
		y -= op.scrollTop;
	}
	var w = e.offsetWidth;
	var foo = e;
	while ((w < this.minimal) && (foo.nextSibling)) {
		foo = foo.nextSibling;
		w += foo.offsetWidth;
	}
	var h = e.offsetHeight;
	x += 1; y += 1; w -= 1; h -= 2; /* Compensate the position and size for the the width of the cell border */
	if (o._dropdown) {
		var d = this.colLinkData[e.cellIndex];
		if (d[0]) { box = dr2; h = '100px'; }
		var option, selected = 0, count = 0, val;
		val = ',' + o.value + ',';
		if (o._changed == -1) { o._changed = true; }
		for (var i = 1; i < d.length; i++) {
			if (isd) {
				if ((o.parent.sid == d[i][2]) || (d[i][2] == 0)) {
					option = document.createElement("OPTION");
					option.value = d[i][0];
					option.text  = d[i][1];
					if (box.multiple) {
						if (val.indexOf(',' + d[i][0] + ',') >= 0) { option.selected = true; }
					}
					else {
						if (d[i][0] == o.value) { selected = count; }
					}
					box.add(option);
					count++;
			}	}
			else if (d[i][0] == o.value) { selected = i; }
		}
		if ((isd) && (!box.options.length)) {
			option = document.createElement("OPTION");
			option.value = 0;
			option.text  = '<No Data>';
			box.add(option);
			selected = 0;
		}
		if ((isd) && !(box.multiple)) { box.selectedIndex = selected; }
		else { box.value = d[selected][1]; }
	}
	else if (o._collapsed) { box.value = ''; }
	else {
		box.value = o.value;
		box.maxLength = maxlen;
	}
	box.style.left   = x - ((isd)?1:0);
	box.style.top    = y - ((isd)?1:0);
	box.style.width  = w;
	box.style.height = h;
	if (document.activeElement != box) { box.style.display = 'block'; box.focus(); }
	if (!isd) { box.select(); }
	this._selectedCell = e;
	this._selectedCell.className = 'selected';
}

WebFXGrid.prototype._hideBox = function(nohide) {
	//if (!nohide) { return; }
	if (!this._selectedCell) { return; }
	this._selectedCell.className = '';
	var call = false;
	var box = document.getElementById(this._boxid);
	var drop = document.getElementById(this._dropid);
	var dr2 = document.getElementById(this._drop2id);
	if (((box.style.display == 'block') && (drop.style.display == 'block')) || ((box.style.display == 'block') && (dr2.style.display == 'block')) || ((drop.style.display == 'block') && (dr2.style.display == 'block'))) {
		if (document.activeElement == box) { drop.style.display = 'none'; dr2.style.display = 'none'; }
		else if (document.activeElement == drop) { box.style.display = 'none'; dr2.style.display = 'none'; }
		else { box.style.display = 'none'; drop.style.display = 'none'; }
		return;
	}
	var value = '';
	if (dr2.style.display == 'block') { drop = dr2; }
	if (box.style.display == 'block') {
		value = box.value;
		var type = this.colTypes[webFXGridHandler.all[this._selectedCell.id].index];
		if (this.colFlags[this._selectedCell.cellIndex-1]) { type = 1; }
		if (box.readOnly) { value = webFXGridHandler.all[this._selectedCell.id].value; }
		else if (box.value == '') { value = ''; }
		else if (type == 0) { value = (isNaN(parseInt(box.value))?0:parseInt(box.value)); }
		else if (type == 1) { value = box.value; }
		else if (type == 2) { value = box.value; }
		else if (type == 3) { value = (isNaN(parseFloat(box.value))?0:parseFloat(box.value)); }
		if (this._selectedCell.childNodes(0).innerText != value) { webFXGridHandler.all[this._selectedCell.id]._changed = true; call = true; }
		if (!box.readOnly) { this._selectedCell.childNodes(0).innerText = value; }
		box.readOnly = false;
		box.value = '';
	}
	else if (drop.style.display == 'block') {
		if (!webFXGridHandler.all[this._selectedCell.id]._dropdown) { return; }
		if (!drop.options) { return; }
		value = '';
		if (drop.multiple) {
			var selcount = 0;
			for (var i = 0; i < drop.options.length; i++) {
				if (drop.options[i].selected) {
					if (selcount) { value += ','; }
					value += drop.options[i].value;
					selcount++;
			}	}
			if (selcount > 1) { this._selectedCell.childNodes(0).innerText = '<Multiple Values>'; }
			else { this._selectedCell.childNodes(0).innerText = drop.options[(drop.selectedIndex >= 0)?drop.selectedIndex:0].text; }
			if (value == '') { value = 0; }
		}
		else {
			value = drop.options[drop.selectedIndex].value;
			this._selectedCell.childNodes(0).innerText = drop.options[drop.selectedIndex].text;
		}
		if (webFXGridHandler.all[this._selectedCell.id].value != value) { webFXGridHandler.all[this._selectedCell.id]._changed = true; call = true; }
		for (var i = drop.options.length; i >= 0; i--) {
			drop.options[i] = null;
		}
		box = drop;
	}
	else { return; }
	if (this.colFlags[this._selectedCell.cellIndex] != 1) {
		webFXGridHandler.all[this._selectedCell.id].value = value;
	}
	box.style.display = 'none';
	if (!nohide) {
		var main = document.getElementById(this._main);
		var tmp = main.scrollLeft;
		this._selectedCell.childNodes(0).focus();
		main.scrollLeft = tmp;
	}
	if ((this.flags & 0x02) && (!this._selectedCell.parentNode.nextSibling) && (this._selectedCell.childNodes(0).innerText != '')) {
		if (this.autoExpand) {
			this.addRow(null);
			webFXGridHandler.all[this._selectedCell.parentNode.id]._initRow();
	}	}
	if ((call) && (this.onChange)) { this.onChange(this._selectedCell); }
	if (!nohide) { this._selectedCell = null; }
}

WebFXGrid.prototype._blurBox = function() {
	if ((document.activeElement.className != 'webfxGridBox') && (this.hideBoxOnBlur)) { this._hideBox(); }
}

WebFXGrid.prototype.hideBox = WebFXGrid.prototype._hideBox;


WebFXGrid.prototype._handleKey = function() {
	var key = window.event.keyCode;
	var e = window.event.srcElement;
	var cell = null;
	if ((key == 37) || (key == 39)) {
		if (e.tagName == 'INPUT') {
			var r = document.selection.createRange();
			var elRange = e.createTextRange();
			if ((key == 37) && (elRange.compareEndPoints("StartToStart", r) == 0)) { cell = this._selectedCell.previousSibling; }
			else if ((key == 39) && (elRange.compareEndPoints("EndToEnd", r) == 0)) { cell = this._selectedCell.nextSibling; }
		}
		else {
			if (key == 37) { cell = this._selectedCell.previousSibling; }
			else if (key == 39) { cell = this._selectedCell.nextSibling; }
	}	}
	else if ((key == 38) || (key == 40) || (key == 13)) {
		if (!this._selectedCell) { return false; }
		if (((key == 38) || (key == 40)) && (e.tagName == 'SELECT')) { return true; }
		var e = this._selectedCell.parentNode;
		if (e) {
			var row, col = this._selectedCell.cellIndex;
			var sibling;
			if ((key == 38) || ((key == 13) && (window.event.shiftKey))) { sibling = e.previousSibling; }
			else { sibling = e.nextSibling; }
			if (sibling) {
				this._hideBox(true);
				row = webFXGridHandler.all[sibling.id];
				var o = sibling;
				var main = document.getElementById(this._main);
				var head = document.getElementById(this._head);
				if (main.scrollTop > o.offsetTop) { main.scrollTop = o.offsetTop - 1; }
				if ((main.scrollTop + main.clientHeight) - o.offsetTop - head.offsetHeight < o.offsetHeight) { main.scrollTop = o.offsetTop - (main.clientHeight - o.offsetHeight) + head.offsetHeight - 1; }
				row.select();
				this._showBox(row.cells[col].id);
			}
			return false;
	}	}
	else if ((key == 9)) {
		if (!this._selectedCell) { return false; }
		if (window.event.shiftKey) { cell = this._selectedCell.previousSibling; }
		else { cell = this._selectedCell.nextSibling; }
	}
	else if (key == 27) { this._hideBox(); return false; }
	else if ((e.tagName != 'INPUT') && (e.tagName != 'SELECT')) {
		if (key == 33) { document.getElementById(this.parent.id).childNodes(1).doScroll('scrollbarPageUp'); }
		else if (key == 34) { document.getElementById(this.parent.id).childNodes(1).doScroll('scrollbarPageDown'); }
		else if (key == 35) { this.parent.selectLast(); }
		else if (key == 36) { this.parent.selectFirst(); }
	}
	if (cell) {
		this._hideBox(true);
		this._showBox(webFXGridHandler.all[cell.id].id);
		return false;
}	}


WebFXGrid.prototype._scroll = function() {
	var main   = document.getElementById(this._main);
	var head   = document.getElementById(this._head);
	var idcol  = document.getElementById(this._idcl);
	head.scrollLeft = main.scrollLeft
	idcol.scrollTop = main.scrollTop;
}



WebFXGrid.prototype._headDown = function() {
	var e = window.event.srcElement;
	if (e.tagName != "TD") { e = e.parentNode; }
	if ((e.tagName == "TD") && (e.parentNode.parentNode.parentNode.parentNode.id == this._head)) {
		e = checkIfResize(e, window.event.x, this.resizeAreaV);
		if (!e) { return; }
		this._headCell = e;
		var foo = new Array();
		for (var i = 0; i < e.parentNode.childNodes.length; i++) {
			foo[i] = e.parentNode.childNodes[i].clientWidth;
		}
		for (var i = 0; i < e.parentNode.childNodes.length; i++) {
			e.parentNode.childNodes[i].style.width = foo[i];
		}
		this._headX = window.event.x;
		this._headW = e.clientWidth;
		e.style.width = e.clientWidth;
		e._sort = false;
		if (e.nextSibling) { e.nextSibling._sort = false; }
	}
	else { e._sort = true; }
};

WebFXGrid.prototype._headMove = function() {
	if (this._headCell) {
		var w = this._headW + (window.event.x - this._headX);
		if (w >= 5) { this._headCell.style.width = w; }
	}
	else {
		var e = window.event.srcElement;
		if (e.tagName != "TD") { e = e.parentNode; }
		if ((e.tagName == "TD") && (e.parentNode.parentNode.parentNode.parentNode.id == this._head)) {
			if (checkIfResize(e, window.event.x, this.resizeAreaV)) { e.style.cursor = 'e-resize'; }
			else if (e.style.cursor == 'e-resize') { e.style.cursor = 'hand'; }
	}	}
};


WebFXGrid.prototype._headUp = function() {
	var e = window.event.srcElement;
	if (this._headCell) {
		this._headCell = null;
		this._headW = 0;
		this._headX = 0;
		e._sort = false;
		var h = document.getElementById(this._head).childNodes[0].childNodes(0).childNodes[0].childNodes;
		var tableCols = document.getElementById(this._main).childNodes[0].childNodes[0].childNodes;
		for (var i = 0; i < h.length; i ++) {
			tableCols[i].style.width = this.colSizes[i] = h[i].clientWidth;
		}
		if (this.onColResize) { this.onColResize(); }
	}
	else {
		if (e.tagName != "TD") { e = e.parentNode; }
		if (e.tagName == "TD") { e._sort = true; }
	}
};

function checkIfResize(e, ex, i) {
	var x = 0;
	var foo = e;
	while (foo.offsetParent != null) {
		x += foo.offsetLeft + foo.clientLeft;
		if (foo.scrollLeft > 0) { x -= foo.scrollLeft; }
		foo = foo.offsetParent;
	}
	if ((ex - x <= i) && (e.cellIndex >= 1)) { return e.previousSibling; }
	if ((e.offsetWidth + x) - ex <= i) { return e; }
	return null;
}

function compareByColumn(c, d, t) {
	var fTypeCast = String;
	if (t == 0) { fTypeCast = parseInt; }
	else if (t == 3) { fTypeCast = parseFloat; }
	return function (n1, n2) {
		if (n1.sid == null) { return +1; }
		if (n2.sid == null) { return -1; }
		if (fTypeCast(n1.cells[c].value) < fTypeCast(n2.cells[c].value)) { return (d) ? -1 : +1; }
		if (fTypeCast(n1.cells[c].value) > fTypeCast(n2.cells[c].value)) { return (d) ? +1 : -1; }
		return 0;
	};
}

function compareBySid(d) {
	return function (n1, n2) {
		if (n1.sid == null) { return +1; }
		if (n2.sid == null) { return -1; }
		if (n1.sid < n2.sid) { return (d) ? -1 : +1; }
		if (n1.sid > n2.sid) { return (d) ? +1 : -1; }
		return 0;
	};
}