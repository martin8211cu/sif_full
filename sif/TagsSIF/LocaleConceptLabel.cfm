<cfparam name="Attributes.Name"			type="string" 	Default="">
<cfparam name="Attributes.Default"		type="string" 	Default="">
<cfoutput>
<span id="locLblC__#Attributes.Name#">#Attributes.Default#</span>
<script language="JavaScript">
	document.locLblDflC__#Attributes.Name# = '#Attributes.Default#';
	if (document.locLblValC__#Attributes.Name#)
	{
		var LvarTxt = document.createTextNode(document.locLblValC__#Attributes.Name#);
		var LvarLbl = document.getElementById("locLblC__#Attributes.Name#");
		LvarLbl.replaceChild(LvarTxt,LvarLbl.firstChild);
	}
</script>
</cfoutput>