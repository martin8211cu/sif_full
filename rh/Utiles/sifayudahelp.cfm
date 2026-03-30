<html>
<head>
<title>Ayuda del Sistema</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--- <cf_templatecss> --->
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td>
<cfif isdefined("url.Acodigo") and len(trim(url.Acodigo)) gt 0>
	<cfquery name="rs" datasource="sifcontrol">
		select Adesc 
		from Ayuda 
		where Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Acodigo#">
		  and Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">
	</cfquery>
	<cfif rs.RecordCount GT 0>
		<cfoutput query="rs">
			#Adesc#
		</cfoutput>
	<cfelse>
    <cfoutput><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Ayuda no disponible.</font></cfoutput> 
  </cfif>
</cfif>
</td>
<td>
<img name="imasist" src="/cfmx/rh/imagenes/asistente1.gif"></td>
<td>
</tr>
</table><br>
<div align="center">
  <input type="button" name="cerrar" value="Cerrar" onClick="window.close();" style="background-color: #FAFAFA; font-size: xx-small">
</div>
</body>
</html>
