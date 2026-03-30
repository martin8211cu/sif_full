<HTML>
 <HEAD>
 <SCRIPT LANGUAGE="JavaScript">
 <!--
 String.prototype.trim = function () {    return this.replace(/^\s*/, "").replace(/\s*$/, "");
 }
 String.prototype.padL = function (nLength, sChar) {  var sreturn = this;  while (sreturn.length < nLength) {   sreturn = String(sChar) + sreturn;  }  return sreturn;
 }             
 function date_onkeydown() {  if (window.event.srcElement.readOnly) return;  var key_code = window.event.keyCode;  var oElement = window.event.srcElement;  if (window.event.shiftKey && String.fromCharCode(key_code) == "T") {        var d = new Date();       oElement.value = String(d.getMonth() + 1).padL(2, "0") + "/" +                         String(d.getDate()).padL(2, "0") + "/" +                        d.getFullYear();       window.event.returnValue = 0;    }    if (!window.event.shiftKey && !window.event.ctrlKey && !window.event.altKey) {        if ((key_code > 47 && key_code < 58) ||          (key_code > 95 && key_code < 106)) {            if (key_code > 95) key_code -= (95-47);           oElement.value =               oElement.value.replace(/[mdy]/, String.fromCharCode(key_code));        }        if (key_code == 8) {            if (!oElement.value.match(/^[mdy0-9]{2}\/[mdy0-9]{2}\/[mdy0-9]{4}$/))               oElement.value = "mm/dd/yyyy";           oElement.value = oElement.value.replace(/([mdy\/]*)[0-9]([mdy\/]*)$/,                function ($0, $1, $2) {                    var idx = oElement.value.search(/([mdy\/]*)[0-9]([mdy\/]*)$/);                    if (idx >= 5) {                        return $1 + "y" + $2;                    } else if (idx >= 2) {                        return $1 + "d" + $2;                    } else {                       return $1 + "m" + $2;                    }                } );           window.event.returnValue = 0;        }    }    if (key_code != 9) {       event.returnValue = false;    }
 }
 //-->
 </SCRIPT>
 </HEAD>
 <BODY>
 <FORM>
 <INPUT TYPE="text" NAME="txtDate" ID="txtDate" SIZE="10"  MAXLENGTH="10" onkeydown="date_onkeydown()" VALUE="AF-X-X-3-4-X-6">
 </FORM>
 </BODY>
</HTML>
