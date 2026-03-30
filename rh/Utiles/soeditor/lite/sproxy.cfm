<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/pro/sproxy.cfm 11    11/21/02 4:29p James $
  Date Created: 12/12/2001
  Author: James Alexander
  Project: soEditor Pro 2.5
  Description: Spellchecker

--->

<cfscript>
	strText	= form.text;
  strControl = form.txt_ctrl;
  strCustomerid = form.customerid;
  strSessionid= form.sessionid;
  strWord = form.word;
  strText = Replace(strText, "&", "&amp;","ALL");
  strText = Replace(strText, Chr(9), "&##9;","ALL");
  strText = Replace(strText, Chr(34) , "&quot;","ALL");
  strText = Replace(strText, Chr(10), "&##10;","ALL");      
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<script>
<!--
var s = 'SPROXY.CFM (c) SpellChecker.Net 2000';
var frmslen = parent.frames.length;

function doload() {
	if (!parent.opener)
		return;
	if (!parent.opener.document) {
		parent.close();
		return;
	}
	if (frmslen != 0) {
		var f_src = document.forms[0];
		var ctrl = eval(
			'parent.opener.' + 
			f_src.txt_ctrl.value);
    if (parent.opener.soEditor<cfoutput>#URL.Field#</cfoutput>)
      parent.opener.soEditor<cfoutput>#URL.Field#</cfoutput>.DocumentHTML = f_src.msg_body.value;
		document.forms[1].submit();
		parent.close();
	}
}
//-->
</script>
</head>
<body bgcolor=white onload="doload();">
<script>if (frmslen == 0) document.write(s);</script>
<center>
<cfoutput>
<form>
<input type=hidden name=msg_body value="#strText#">
<input type=hidden name=txt_ctrl value="#strControl#">
</form>
<form method=post action="#strWord#">
<input type=hidden name=cmd value="eos">
<input type=hidden name=customerid value="#strCustomerid#">
<input type=hidden name=sessionid  value="#strSessionid#">
</form>
</cfoutput>
</body></html>

