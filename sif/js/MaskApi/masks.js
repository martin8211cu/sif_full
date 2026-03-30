function _MaskAPI(){
	this.version = "0.3";
	this.instances = 0;
	this.objects = {};
}
MaskAPI = new _MaskAPI();

function Mask(m, t){
	this.mask = m;
	this.type = (typeof t == "string") ? t : "string";
	this.error = [];
	this.errorCodes = [];
	this.salir = true;
	this.value = "";
	this.strippedValue = "";
	this.allowPartial = false;
	this.mandatory = false;
	this.id = MaskAPI.instances++;
	this.ref = "MaskAPI.objects['" + this.id + "']";
	this.lastValue = "";
	MaskAPI.objects[this.id] = this;
}

Mask.prototype.attach = function (o, mascara, tipo, fnOnBlur, fnOnKeyDown, fnOnKeyUp, fnOnChange, enterAction){
	if (typeof fnOnBlur != "string") 	fnOnBlur = "";
	if (typeof fnOnKeyDown != "string")	fnOnKeyDown = "";
	if (typeof fnOnKeyUp != "string") 	fnOnKeyUp = "";
	if (typeof fnOnChange != "string") 	
		fnOnChange = "";
	else if (fnOnChange != "")
		fnOnChange = ";if(this.value != " + this.ref + ".lastValue) " + fnOnChange + ";"

	if (typeof enterAction != "string") 
		enterAction = "";
	else if (enterAction.replace(/\s*/,"") == "")
		enterAction = "";
	else
	{
		enterAction = "CF_enterAction = '" + enterAction + "';";
		o.onkeypress = new Function(enterAction);
	}

	o.onkeydown = new Function(enterAction+"return " + this.ref + ".isAllowKeyPress(this);"+fnOnKeyDown);
	
	o.onfocus = new Function(this.ref + ".lastValue = this.value");

	if ( document.selection )
		o.onkeyup = new Function("return " + this.ref + ".getKeyPress(this);"+fnOnKeyUp);
	else
		o.onkeyup = new Function("return " + this.ref + ".getKeyPress(this);"+fnOnKeyUp);

	if (tipo=="date")
		o.onmouseup = new Function("return " + this.ref + ".getMouseUp(this);");

	if (tipo=="number")
	{
		o.onblur = new Function("this.value = " + this.ref + ".format(this.value);"+fnOnBlur+fnOnChange);
	}
	else
	{
		o.onblur = new Function("this.value = " + this.ref + ".format(this.value);" + this.ref + ".MaskTest(this);"+fnOnBlur+fnOnChange);
	}
}

// *************************************************
// Ing. Oscar Bonilla, MBA
// 07/MAY/2004
// Variable global para almacenar el tamaño de la selección
// *************************************************
var GvarRLon;
// *************************************************
Mask.prototype.isAllowKeyPress = function (o){
	var e;
	if (window.Event)
		e = arguments.callee.caller.arguments[0];
	else
		e = window.event;
	// *********************************
	// Ing. Oscar Bonilla, MBA
	// 27/MAY/2004
	// Almacena el tamaño de la seleccion
	// *********************************
	if ( document.selection ) GvarRLon = document.selection.createRange().text.length;
	// *********************************

	// Ing. Oscar Bonilla, MBA
	// 13/SET/2005
	// Ignora la Mascara cuando viene en blanco para string
	if( this.type != "string" ) 
		return true;
	else if (this.mask.length == 0)
		return true;
		
	var xe = new xEvent(e);

	// *********************************
	// Ing. Oscar Bonilla, MBA
	// 27/MAY/2004
	// Permite digitar cuando esta todo el texto lleno pero hay caracteres seleccionados
	// *********************************
	if( ((xe.keyCode > 47) && (o.value.length-GvarRLon >= this.mask.length)) && !xe.ctrlKey ) return false;
	// *********************************
	return true;
}

Mask.prototype.getMouseUp = function (o, _u){
	// **********************************************************
	// Ing. Oscar Bonilla, MBA
	// 07/MAY/2004
	// Posiciona cursor para Mouse Up
	// **********************************************************
	var LvarPos;
	var LvarRange;
	var LvarLon;
	
	if (document.selection)
	{
		LvarRange = document.selection.createRange();
		if ( (this.type == "date") && (LvarRange.text.length == 0) )
		{
			LvarLon = o.value.length;
			LvarRange.moveEnd("textedit",1);
			LvarPos = LvarLon - LvarRange.text.length;
			if (o.value.charAt(LvarPos) == "/") LvarPos --;
			var LvarIni, LvarFin;
			for (LvarIni=LvarPos; LvarIni>0 && o.value.charAt(LvarIni-1) != "/"; LvarIni--);
			for (LvarFin=LvarPos; LvarFin<LvarLon-1 && o.value.charAt(LvarFin+1) != "/"; LvarFin++);
			LvarRange.moveStart("textedit",-1);
			LvarRange.moveEnd("textedit",-1);
			LvarRange.moveStart("character",LvarIni);
			LvarRange.moveEnd("character",LvarFin-LvarIni+1);
			LvarRange.select();
			return;
		}
	}
	// **********************************************************
	return true;
}
/*
function setSelectionRange(input, selectionStart, selectionEnd) {
  if (input.setSelectionRange) {
    input.focus();
    input.setSelectionRange(selectionStart, selectionEnd);
  }
  else if (input.createTextRange) {
    var range = input.createTextRange();
    range.collapse(true);
    range.moveEnd('character', selectionEnd);
    range.moveStart('character', selectionStart);
    range.select();
  }
}
*/
Mask.prototype.getKeyPress = function (o, _u)
{
	var e;
	if (window.Event)
		e = arguments.callee.caller.arguments[0];
	else
		e = window.event;
	this.allowPartial = true;
	var xe = new xEvent(e);

//	var k = String.fromCharCode(xe.keyCode);

	// **********************************************************
	// Ing. Oscar Bonilla, MBA
	// 07/MAY/2004
	// Posiciona cursor para las teclas [left] y [right]
	// **********************************************************
	var LvarPos;
	var LvarRange;
	var LvarLon;
	if (document.selection)
	{
		LvarRange = document.selection.createRange();
		if ( (this.type == "date") && (xe.keyCode == 37) )
		{
			LvarLon = o.value.length;
			LvarRange.moveEnd("textedit",1);
			LvarPos = LvarLon - LvarRange.text.length;
			if (o.value.charAt(LvarPos) == "/") LvarPos --;
			if (o.value.charAt(LvarPos-1) == "/") LvarPos-=2;
			var LvarIni, LvarFin;
			for (LvarIni=LvarPos; LvarIni>0 && o.value.charAt(LvarIni-1) != "/"; LvarIni--);
			for (LvarFin=LvarPos; LvarFin<LvarLon-1 && o.value.charAt(LvarFin+1) != "/"; LvarFin++);
			LvarRange.moveStart("textedit",-1);
			LvarRange.moveEnd("textedit",-1);
			LvarRange.moveStart("character",LvarIni);
			LvarRange.moveEnd("character",LvarFin-LvarIni+1);
			LvarRange.select();
			return;
		}
		else if ( (this.type == "date") && (xe.keyCode == 39) )
		{
			LvarLon = o.value.length;
			LvarRange.moveStart("textedit",-1);
			LvarPos = LvarRange.text.length;
			if (o.value.charAt(LvarPos-1) == "/") LvarPos ++;
			if (o.value.charAt(LvarPos) == "/") LvarPos+=2;
			var LvarIni, LvarFin;
			for (LvarIni=LvarPos; LvarIni>0 && o.value.charAt(LvarIni-1) != "/"; LvarIni--);
			for (LvarFin=LvarPos; LvarFin<LvarLon-1 && o.value.charAt(LvarFin+1) != "/"; LvarFin++);
			LvarRange.moveStart("textedit",-1);
			LvarRange.moveEnd("textedit",-1);
			LvarRange.moveStart("character",LvarIni);
			LvarRange.moveEnd("character",LvarFin-LvarIni+1);
			LvarRange.select();
			return;
		}
		else
		{
			LvarLon = o.value.length;
			LvarRange.moveStart("textedit",-1);
			LvarPos = LvarRange.text.length;
		}
	}
	// **********************************************************

	// *****************
	// Ing. Oscar Bonilla, MBA
	// 07/MAY/2004
	// Incluye la tecla [space] en la verificacion
	// *****************
	if( (xe.keyCode == 32) || (xe.keyCode > 47) || (_u == true) || (xe.keyCode == 8 || xe.keyCode == 46) ){
		var v = o.value, d;

		if( xe.keyCode == 8 || xe.keyCode == 46 ) 
			d = true;
		else 
			d = false

		if( this.type == "number" ) 
			this.value = this.setNumber(v, d);
		else if( this.type == "date" ) 
			this.value = this.setDateKeyPress(v, d);
		else if(this.mask.length == 0)
			this.value = v;
		else
			this.value = this.setGeneric(v, d);

		o.value = this.value;
		// ***********************************************
		// Ing. Oscar Bonilla, MBA
		// 07/MAY/2004
		// Posiciona el cursor
		// ***********************************************
		if (document.selection && (LvarPos != LvarLon) )
		{
			LvarRange.moveStart("textedit",-1);
			LvarRange.moveEnd("textedit",-1);
			if ((this.type == "date"))
			{
				LvarPos = LvarPos + GvarRLon;
				LvarRange.moveStart("character",LvarPos);
				LvarRange.moveStart("character",-1);
				LvarRange.moveEnd("character",-1);
			}
			else
			{
				// *********************************
				// Ing. Oscar Bonilla, MBA
				// 27/MAY/2004
				// Cuando es string, posiciona el cursor a la derecha de los caracteres no editables
				// *********************************
				if (this.type == "string")
				{
					if ((this.mask.substring(LvarPos,LvarPos+1)!="*") && (this.mask.substring(LvarPos,LvarPos+1)!="x") && (this.mask.substring(LvarPos,LvarPos+1)!="#") ) 
						LvarPos ++;
				}
				else
				{
					if (o.value.length == v.length + 1) LvarPos ++;
				}
				LvarRange.moveStart("character",LvarPos);
			}
			LvarRange.select();
		}
		// ***********************************************
	}
	/* */

	this.allowPartial = false;
	return true;
}

Mask.prototype.format = function (s){
	if( this.type == "number" ) 
		this.value = this.setNumber(s);
	else if( this.type == "date" ) 
		this.value = this.setDate(s);
	else 
		this.value = this.setGeneric(s);
		
	return this.value;
}

Mask.prototype.throwError = function (c, e, v){
	this.error[this.error.length] = e;
	this.errorCodes[this.errorCodes.length] = c;
	if( typeof v == "string" ) return v;
	return true;
}

// ***********************************************
// Ing. Oscar Bonilla, MBA
// 03/JUN/2004, 13/SET/2005
// Generic Mask
// ***********************************************
Mask.prototype.setGeneric = function (_v, _d){
	var LvarValor = _v, LvarMascara = this.mask;
	var r = "x#*", rx = {"x": new RegExp("[A-Za-z]"), "#": new RegExp("[0-9]"), "*": new RegExp("[A-Za-z0-9-]") };
	
	// Ing. Oscar Bonilla, MBA
	// 13/SET/2005
	// Ignora la Mascara cuando viene en blanco para string
	if (this.mask.length == 0)
		return LvarValor;
	
	var v = 0, u = -1, pf=true, m = 0, nv = "", sv = "";
	if (LvarValor.length > 0)
	{
		while (m <= LvarMascara.length)
		{
			c = LvarValor.charAt(v);
			p = LvarMascara.charAt(m);
			if ( (p!="") && (r.indexOf(p) > -1) ) 
			{
				if (v >= LvarValor.length)
				{
					pf = false;
					break;
				}

				if (rx[p].test(c))
				{
					nv = nv + c;
					sv = sv + c;
					m++;
					u = nv.length;
				}
				v++;
			}
			else
			{
				if (p == "!")
					p = LvarMascara.charAt(m++);
				nv = nv + p;
				m++;
				if (p == c) v++;
			}
		}
	}
	this.strippedValue = sv;
	nv = nv.substring(0, u);
	if( !this.allowPartial && this.mandatory && (m <= LvarMascara.length) && (LvarValor.length > 0) ) return this.throwError(1, "El valor \"" + _v + "\" debe coincidir con todo el formato " + this.mask + ".", _v);
  	return nv;
}
// ***********************************************

Mask.prototype.setGeneric1 = function (_v, _d){
	var v = _v, m = this.mask;
	var r = "x#*", rt = [], nv = "", t, x, a = [], j=0, rx = {"x": "A-Za-z", "#": "0-9", "*": "A-Za-z0-9" };

	// strip out invalid characters
	v = v.replace(new RegExp("[^" + rx["*"] + "]", "gi"), "");
	if( (_d == true) && (v.length == this.strippedValue.length) ) v = v.substring(0, v.length-1);
	this.strippedValue = v;
	var b=[];
	for( var i=0; i < m.length; i++ ){
		// grab the current character
		x = m.charAt(i);
		// check to see if current character is a mask, escape commands are not a mask character
		t = (r.indexOf(x) > -1);
		// if the current character is an escape command, then grab the next character
		if( x == "!" ) x = m.charAt(i++);
		// build a regex to test against
		if( (t && !this.allowPartial) || (t && this.allowPartial && (rt.length < v.length)) ) rt[rt.length] = "[" + rx[x] + "]";
		// build mask definition table
		a[a.length] = { "char": x, "mask": t };
	}

	var hasOneValidChar = false;
	// if the regex fails, return an error
	if( !this.allowPartial && !(new RegExp(rt.join(""))).test(v) ) return this.throwError(1, "El valor \"" + _v + "\" debe de estar en el formato " + this.mask + ".", _v);
	// loop through the mask definition, and build the formatted string
	else if( (this.allowPartial && (v.length > 0)) || !this.allowPartial ){
		for( i=0; i < a.length; i++ ){
			if( a[i].mask ){
				while( v.length > 0 && !(new RegExp(rt[j])).test(v.charAt(j)) ) v = (v.length == 1) ? "" : v.substring(1);
				if( v.length > 0 ){
					nv += v.charAt(j);
					hasOneValidChar = true;
				}
				j++;
			} else nv += a[i]["char"];
			if( this.allowPartial && (j > v.length) ) break;
		}
	}
	
	if( this.allowPartial && !hasOneValidChar ) nv = "";

	return nv;
}

Mask.prototype.setNumber = function(_v, _d){
	var v = String(_v).replace(/[^\d.-]*/gi, ""), m = this.mask;
	// make sure there's only one decimal point
	v = v.replace(/\./, "d").replace(/\./g, "").replace(/d/, ".");

	// check to see if an invalid mask operation has been entered
	if( !/^[\$]?((\$?[\+-]?([0#]{1,3},)?[0#]*(\.[0#]*)?)|([\+-]?\([\+-]?([0#]{1,3},)?[0#]*(\.[0#]*)?\)))$/.test(m) )
		return this.throwError(1, "Una mÃ¡scara invÃ¡lida fue indicada en el constructor de la \nMÃ¡scara.", _v);

	if( (_d == true) && (v.length == this.strippedValue.length) ) v = v.substring(0, v.length-1);

	if( this.allowPartial && (v.replace(/[^0-9]/, "").length == 0) ) return v;
	this.strippedValue = v;

	if( v.length == 0 ) v = NaN;
	var vn = Number(v);
	if( isNaN(vn) ) return this.throwError(2, "El valor digitado no es un nÃºmero.", _v);

	// if no mask, stop processing
	if( m.length == 0 ) return v;

	// get the value before the decimal point
	var vi = String(Math.abs((v.indexOf(".") > -1 ) ? v.split(".")[0] : v));
	// get the value after the decimal point
	var vd = (v.indexOf(".") > -1) ? v.split(".")[1] : "";
	var _vd = vd;

	var isNegative = (Math.abs(vn)*-1 == vn);

	// check for masking operations
	var show = {
		"$" : /^[\$]/.test(m),
		"(": (isNegative && (m.indexOf("(") > -1)),
		"+" : ( (m.indexOf("+") != -1) && !isNegative )
	}
	show["-"] = (isNegative && (!show["("] || (m.indexOf("-") != -1)));


	// replace all non-place holders from the mask
	m = m.replace(/[^#0.,]*/gi, "");

	/*
		make sure there are the correct number of decimal places
	*/
	// get number of digits after decimal point in mask
	var dm = (m.indexOf(".") > -1 ) ? m.split(".")[1] : "";
	if( dm.length == 0 ){
		vi = String(Math.round(Number(vi)));
		vd = "";
	} else {
		// find the last zero, which indicates the minimum number
		// of decimal places to show
		var md = dm.lastIndexOf("0")+1;
		// if the number of decimal places is greater than the mask, then round off
		if( vd.length > dm.length ) vd = String(Math.round(Number(vd.substring(0, dm.length + 1))/10));
		// otherwise, pad the string w/the required zeros
		else while( vd.length < md ) vd += "0";
	}

	/*
		pad the int with any necessary zeros
	*/
	// get number of digits before decimal point in mask
	var im = (m.indexOf(".") > -1 ) ? m.split(".")[0] : m;
	im = im.replace(/[^0#]+/gi, "");
	// find the first zero, which indicates the minimum length
	// that the value must be padded w/zeros
	var mv = im.indexOf("0")+1;
	// if there is a zero found, make sure it's padded
	if( mv > 0 ){
		mv = im.length - mv + 1;
		while( vi.length < mv ) vi = "0" + vi;
	}


	/*
		check to see if we need commas in the thousands place holder
	*/
	if( /[#0]+,[#0]{3}/.test(m) ){
		// add the commas as the place holder
		var x = [], i=0, n=Number(vi);
		while( n > 999 ){
			x[i] = "00" + String(n%1000);
			x[i] = x[i].substring(x[i].length - 3);
			n = Math.floor(n/1000);
			i++;
		}
		x[i] = String(n%1000);
		vi = x.reverse().join(",");
	}


	/*
		combine the new value together
	*/
	if( (vd.length > 0 && !this.allowPartial) || ((dm.length > 0) && this.allowPartial && (v.indexOf(".") > -1) && (_vd.length >= vd.length)) ){
		v = vi + "." + vd;
	} else if( (dm.length > 0) && this.allowPartial && (v.indexOf(".") > -1) && (_vd.length < vd.length) ){
		v = vi + "." + _vd;
	} else {
		v = vi;
	}

	if( show["$"] ) v = this.mask.replace(/(^[\$])(.+)/gi, "$") + v;
	if( show["+"] ) v = "+" + v;
	if( show["-"] ) v = "-" + v;
	if( show["("] ) v = "(" + v + ")";
	return v;
}

// ***********************************************
// Ing. Oscar Bonilla, MBA
// 07/MAY/2004
// Check for bad characters and only 1 negative
// ***********************************************
Mask.prototype.setNumberBlur = function (v){
	var v2 = "", n2=false, c="";
	for (var i=0; i<v.length; i++)
	{
		c = v.charAt(i);
		//if ( (/[.0-9]/gi).test(v.charAt(i)) )
		if ( (c=="0") || (c=="1") || (c=="2") || (c=="3") || (c=="4") || (c=="5") || (c=="6") || (c=="7") || (c=="8") || (c=="9") || (c==".") )
			v2 = v2 + c;
		else if ( (c == "-") && !n2 )
		{
			v2 = "-" + v2;
			n2 = true;
		}
	
	}
	return v2;
}
// ***********************************************

Mask.prototype.setDate = function (_v){

	if (_v == "")
		return "";
	var v = _v, m = this.mask;
	var a, e, mm, dd, yy, x, s;

	// split mask into array, to see position of each day, month & year
	a = m.split(/[^mdy]+/);
	// split mask into array, to get delimiters
	s = m.split(/[mdy]+/);
	// convert the string into an array in which digits are together
	e = v.split(/[^0-9]/);
	
	if( s[0].length == 0 ) s.splice(0, 1);

	for( var i=0; i < a.length; i++ ){
		x = a[i].charAt(0).toLowerCase();
		if( x == "m" ) mm = parseInt(e[i], 10)-1;
		else if( x == "d" ) dd = parseInt(e[i], 10);
		else if( x == "y" ) yy = parseInt(e[i], 10);
	}

	// if year is abbreviated, guess at the year
	if( String(yy).length < 3 ){
		yy = 2000 + yy;
		if( (new Date()).getFullYear()+20 < yy ) yy = yy - 100;
	}
	else if (yy > 2199 || yy < 1800)
	{
		return this.throwError(3,"El año indicado es inválido", _v);
	}
	
	// create date object
	var d = new Date(yy, mm, dd);

	if( d.getDate() != dd )return this.throwError(1, "El día indicado es inválido.", _v);
	else if( d.getMonth() != mm ) return this.throwError(2, "El mes indicado es incorrecto.", _v);

	var nv = "";

	for( i=0; i < a.length; i++ ){
		x = a[i].charAt(0).toLowerCase();
		if( x == "m" ){
			mm++;
			if( a[i].length == 2 ){
				mm = "0" + mm;
				mm = mm.substring(mm.length-2);
			}
			nv += mm;
		} else if( x == "d" ){
			if( a[i].length == 2 ){
				dd = "0" + dd;
				dd = dd.substring(dd.length-2);
			}
			nv += dd;
		} else if( x == "y" ){
			if( a[i].length == 2 ) nv += d.getYear();
			else nv += d.getFullYear();
		}

		if( i < a.length-1 ) nv += s[i];
	}
	if (nv.substring(2,6) == "/aN/")
	  nv = nv.substring(0,3);

	return nv;
}

Mask.prototype.setDateKeyPress = function (_v, _d){
	var v = _v, m = this.mask, k = v.charAt(v.length-1);
	var a, e, c, ml, vl, mm = "", dd = "", yy = "", x, p, z;
	var s1,s,j

	if( _d == true )
	{
		if (!document.selection)
			return v;
		while( (/[^0-9]/gi).test(v.charAt(v.length-1)) ) v = v.substring(0, v.length-1);
		if( (/[^0-9]/gi).test(this.strippedValue.charAt(this.strippedValue.length-1)) ) v = v.substring(0, v.length-1);
		if( v.length == 0 ) return "";
	}

	// ***********************************************
	// Ing. Oscar Bonilla, MBA
	// 07/MAY/2004
	// Elimina caracteres indeseados
	// ***********************************************
	var v2 = "", p2=0, c="";
	for (var i=0; i<v.length; i++)
	{
		c = v.charAt(i);
		//if ( (/[0-9]/gi).test(v.charAt(i)) )
		if ( (c=="0") || (c=="1") || (c=="2") || (c=="3") || (c=="4") || (c=="5") || (c=="6") || (c=="7") || (c=="8") || (c=="9") )
			v2 = v2 + c;
		else if (v.charAt(i) == "/" && p2<2)
		{
			v2 = v2 + c;
			p2++;
		}
	}
	v = v2;
	if (!document.selection && p2 == 2)
	  return v;
	// ***********************************************

	// split mask into array, to see position of each day, month & year
	a = m.split(/[^mdy]/);
	// split mask into array, to get delimiters
	s1 = m.split(/[mdy]/);
	// convert the string into an array in which digits are together
	e = v.split(/[^0-9]/);
	// position in mask
	p = (e.length > 0) ? e.length-1 : 0;
	// determine what mask value the user is currently entering
	c = a[p].charAt(0);
	// determine the length of the current mask value
	ml = a[p].length;

	var s = new Array();
	var j = 0;
	for( var i=0; i < s1.length; i++ ){
		if (s1[i].length > 0)
		{
			s[j] = s1[i];
			j++;
		}
	}

	for( var i=0; i < e.length; i++ ){
		x = a[i].charAt(0).toLowerCase();
		if( x == "m" ) mm = parseInt(e[i], 10)-1;
		else if( x == "d" ) dd = parseInt(e[i], 10);
		else if( x == "y" ) yy = parseInt(e[i], 10);
	}
	
	var nv = "";
	var j=0;

	for( i=0; i < e.length; i++ ){
		x = a[i].charAt(0).toLowerCase();
		if( x == "m" ){
			z = ((/[^0-9]/).test(k) && c == "m");
			mm++;
			if( (e[i].length == 2 && mm < 10) || (a[i].length == 2 && c != "m") || (mm > 1 && c == "m") || (z && a[i].length == 2) ){
				mm = "0" + mm;
				mm = mm.substring(mm.length-2);
			}
			vl = String(mm).length;
			ml = 2;
			nv += mm;
		} else if( x == "d" ){
			z = ((/[^0-9]/).test(k) && c == "d");
			if( (e[i].length == 2 && dd < 10) || (a[i].length == 2 && c != "d") || (dd > 3 && c == "d") || (z && a[i].length == 2) ){
				dd = "0" + dd;
				dd = dd.substring(dd.length-2);
			}
			vl = String(dd).length;
			ml = 2;
			nv += dd;
		} else if( x == "y" ){
			z = ((/[^0-9]/).test(k) && c == "y");
			if( c == "y" ) yy = String(yy);
			else {
				if( a[i].length == 2 ) yy = d.getYear();
				else yy = d.getFullYear();
			}
			if( (e[i].length == 2 && yy < 10) || (a[i].length == 2 && c != "y") || (z && a[i].length == 2) ){
				yy = "0" + yy;
				yy = yy.substring(yy.length-2);
			}
			// *****************************
			// Ing. Oscar Bonilla, MBA
			// 07/MAY/2004
			// Ajusta los años a la derecha igual que el dia y el mes
			// *****************************
			else if (!z && (String(yy).length > 4))
				yy = yy.substring(yy.length-4);
			// *****************************
			ml = a[i].length;
			vl = String(yy).length;
			nv += yy;
		}

		if( ((ml == vl || z) && (x == c) && (i < s.length)) || (i < s.length && x != c ) ) nv += s[i];
	}

	if (nv.substring(2,6) == "/aN/")
	  nv = nv.substring(0,3);

	nv=nv.substring(0,10);
	this.strippedValue = (nv == "NaN") ? "" : nv;

	return this.strippedValue;
}

function xEvent(e){
	// routine for NS, Opera, etc DOM browsers
	if( window.Event ){
		var isKeyPress = (e.type.substring(0,3) == "key");

		this.keyCode = (isKeyPress) ? parseInt(e.which, 10) : 0;
		this.button = (!isKeyPress) ? parseInt(e.which, 10) : 0;
		this.srcElement = e.target;
		this.type = e.type;
		this.x = e.pageX;
		this.y = e.pageY;
		this.screenX = e.screenX;
		this.screenY = e.screenY;
		if( !isKeyPress ){
			if( document.layers ){
				this.altKey = ((e.modifiers & Event.ALT_MASK) > 0);
				this.ctrlKey = ((e.modifiers & Event.CONTROL_MASK) > 0);
				this.shiftKey = ((e.modifiers & Event.SHIFT_MASK) > 0);
				this.keyCode = this.translateKeyCode(this.keyCode);
			} else {
				this.altKey = e.altKey;
				this.ctrlKey = e.ctrlKey;
				this.shiftKey = e.shiftKey;
			}
		}
	// routine for Internet Explorer DOM browsers
	} else {
		e = window.event;
		this.keyCode = parseInt(e.keyCode, 10);
		this.button = e.button;
		this.srcElement = e.srcElement;
		this.type = e.type;
		if( document.all ){
			this.x = e.clientX + document.body.scrollLeft;
			this.y = e.clientY + document.body.scrollTop;
		} else {
			this.x = e.clientX;
			this.y = e.clientY;
		}
		this.screenX = e.screenX;
		this.screenY = e.screenY;
		this.altKey = e.altKey;
		this.ctrlKey = e.ctrlKey;
		this.shiftKey = e.shiftKey;
	}
	if( this.button == 0 ){
		this.setKeyPressed(this.keyCode);
		this.keyChar = String.fromCharCode(this.keyCode);
	}
}

// this method will try to remap the keycodes so the keycode value
// returned will be consistent. this doesn't work for all cases,
// since some browsers don't always return a unique value for a
// key press.
xEvent.prototype.translateKeyCode = function (i){
	var l = {};
	// remap NS4 keycodes to IE/W3C keycodes
	if( !!document.layers ){
		if( this.keyCode > 96 && this.keyCode < 123 ) return this.keyCode - 32;
		l = {
			96:192,126:192,33:49,64:50,35:51,36:52,37:53,94:54,38:55,42:56,40:57,41:48,92:220,124:220,125:221,
			93:221,91:219,123:219,39:222,34:222,47:191,63:191,46:190,62:190,44:188,60:188,45:189,95:189,43:187,
			61:187,59:186,58:186,
			"null": null
		}
	}
	return (!!l[i]) ? l[i] : i;
}

		
// try to determine the actual value of the key pressed
xEvent.prototype.setKP = function (i, s){
	this.keyPressedCode = i;
	this.keyNonChar = (typeof s == "string");
	this.keyPressed = (this.keyNonChar) ? s : String.fromCharCode(i);
	this.isNumeric = (parseInt(this.keyPressed, 10) == this.keyPressed);
	this.isAlpha = ((this.keyCode > 64 && this.keyCode < 91) && !this.altKey && !this.ctrlKey);
	return true;
}

// try to determine the actual value of the key pressed
xEvent.prototype.setKeyPressed = function (i){
	var b = this.shiftKey;
	if( !b && (i > 64 && i < 91) ) return this.setKP(i + 32);
	if( i > 95 && i < 106 ) return this.setKP(i - 48);
	
	switch( i ){
		case 49: case 51: case 52: case 53: if( b ) i = i - 16; break;
		case 50: if( b ) i = 64; break;
		case 54: if( b ) i = 94; break;
		case 55: if( b ) i = 38; break;
		case 56: if( b ) i = 42; break;
		case 57: if( b ) i = 40; break;
		case 48: if( b ) i = 41; break;
		case 192: if( b ) i = 126; else i = 96; break;
		case 189: if( b ) i = 95; else i = 45; break;
		case 187: if( b ) i = 43; else i = 61; break;
		case 220: if( b ) i = 124; else i = 92; break;
		case 221: if( b ) i = 125; else i = 93; break;
		case 219: if( b ) i = 123; else i = 91; break;
		case 222: if( b ) i = 34; else i = 39; break;
		case 186: if( b ) i = 58; else i = 59; break;
		case 191: if( b ) i = 63; else i = 47; break;
		case 190: if( b ) i = 62; else i = 46; break;
		case 188: if( b ) i = 60; else i = 44; break;

		case 106: case 57379: i = 42; break;
		case 107: case 57380: i = 43; break;
		case 109: case 57381: i = 45; break;
		case 110: i = 46; break;
		case 111: case 57378: i = 47; break;

		case 8: return this.setKP(i, "[backspace]");
		case 9: return this.setKP(i, "[tab]");
		case 13: return this.setKP(i, "[enter]");
		case 16: case 57389: return this.setKP(i, "[shift]");
		case 17: case 57390: return this.setKP(i, "[ctrl]");
		case 18: case 57388: return this.setKP(i, "[alt]");
		case 19: case 57402: return this.setKP(i, "[break]");
		case 20: return this.setKP(i, "[capslock]");
		case 32: return this.setKP(i, "[space]");
		case 91: return this.setKP(i, "[windows]");
		case 93: return this.setKP(i, "[properties]");

		case 33: case 57371: return this.setKP(i*-1, "[pgup]");
		case 34: case 57372: return this.setKP(i*-1, "[pgdown]");
		case 35: case 57370: return this.setKP(i*-1, "[end]");
		case 36: case 57369: return this.setKP(i*-1, "[home]");
		case 37: case 57375: return this.setKP(i*-1, "[left]");
		case 38: case 57373: return this.setKP(i*-1, "[up]");
		case 39: case 57376: return this.setKP(i*-1, "[right]");
		case 40: case 57374: return this.setKP(i*-1, "[down]");
		case 45: case 57382: return this.setKP(i*-1, "[insert]");
		case 46: case 57383: return this.setKP(i*-1, "[delete]");
		case 144: case 57400: return this.setKP(i*-1, "[numlock]");
	}
	
	if( i > 111 && i < 124 ) return this.setKP(i*-1, "[f" + (i-111) + "]");

	return this.setKP(i);
}

Mask.prototype.MaskTest = function (obj){
	if (obj.value.length > 0) {
		var LvarError = "";
		for (var LvarErrorI=0;LvarErrorI < this.error.length; LvarErrorI++)
			LvarError = LvarError + this.error[LvarErrorI] + "\n";
		if (this.error.length != 0) 
		{
			alert(LvarError);
			obj.value = "";
			obj.focus();
			obj.select();
			obj.focus();
			this.error = new Array();
			this.salir = false;
			return false;
		}
	}
	return true;
}

