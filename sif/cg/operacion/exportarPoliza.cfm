<html>
<head>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
	<cfset PolizaExp = t.Translate('PolizaExp','Exportaci&oacute;n de P&oacute;lizas')>
	<cfset PolizaExpp = t.Translate('PolizaExpp','Exportar P&oacute;liza')>
<title><cfoutput>#PolizaExpp#</cfoutput></title>

<cf_templatecss>
<cf_templatecss>

</head>
<body>

	<cfif isdefined("url.IDcontable") and not isdefined("form.IDcontable")>
		<cfset form.IDcontable = url.IDcontable >
	</cfif>
	
	<cfquery name="rs" datasource="#session.DSN#">
		select Edescripcion from EContables where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">		
	</cfquery>
	
	<cfoutput>
	<table border="0" width="100%" cellspacing="0" cellpadding="2" align="center" style="border-color:##000000; border-style:solid; border-width:1px;" >
		<tr>
			<td valign="top" align="center" class="tituloListas"><b>#PolizaExp#</b></td>
		</tr>

		<tr>
			<td valign="top" align="center">#PolizaE#: #rs.Edescripcion#</td>
		</tr>

		<tr>
			<td valign="top" align="center">
				<cf_sifimportar EIcodigo="CG01" mode="out">
					<cf_sifimportarparam name="IDcontable" value="#form.IDcontable#">
				</cf_sifimportar>
			</td>
		</tr>
	</table>
	</cfoutput>

		
<script language="javascript1.2" type="text/javascript">
	function cerrar() {
		window.close();
		return false;
	}
</script>		

</body>
</html>

