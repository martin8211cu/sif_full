<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>
	<cfif isdefined("url.img")>
	<cfoutput>
	#url.img#
	</cfoutput>
	</cfif>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<cfif isdefined("url.img") and not isdefined("url.natural")>
	<script language="javascript1.4" type="text/javascript">
	function showPicture() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var nuevo = window.open('showImg.cfm?img=#JSStringFormat(url.img)#&natural=1','FotoNatural','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
	</script>
	<cfoutput>
	<img src="#url.img#" width="75" height="100" onClick="showPicture()" style="cursor:hand">
	</cfoutput>
<cfelseif isdefined("url.img") and isdefined("url.natural")>
	<cfoutput>
	<img src="#url.img#">
	</cfoutput>
<cfelseif isdefined("url.MEEid")>
	<cf_sifleerimagen autosize="true" border="false" Tabla="MEEntidad" Campo="MEEimagen" Condicion="MEEid = #url.MEEid#" Conexion="#session.DSN#">
</cfif>
</body>