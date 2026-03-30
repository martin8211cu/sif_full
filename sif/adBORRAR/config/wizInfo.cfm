<cfquery name="rsTexto" datasource="asp">
	select WECdescripcion, WECtexto, WTCmascara
	from WTContable
	where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.WTCid#">
</cfquery>

<cfoutput>
<form name="form" method="post">
	<textarea name="info"><b><div align="center">#rsTexto.WECdescripcion#</div></b><div align="center"><b>M&aacute;scara: #rsTexto.WTCmascara#</b></div>#rsTexto.WECtexto#</textarea>
	<img name="ifImagen" src="/cfmx/sif/ad/config/imagenes/wtc#trim(url.WTCid)#.gif">
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">

	window.parent.document.getElementById("tdInfo").innerHTML = '<p>' + document.form.info.value + '</p>';
	window.parent.document.form1.infoImagen.src = document.form.ifImagen.src;
	window.parent.document.getElementById("trImagen").style.visibility = '';
	window.parent.document.form1.mascara.value = '<cfoutput>#rsTexto.WTCmascara#</cfoutput>';
</script>
