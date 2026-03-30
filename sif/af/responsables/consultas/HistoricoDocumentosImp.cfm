<!--- Filtros --->
<cfset vsFiltro = ''>
<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "APlacaIni=" & form.APlacaIni>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "ADescripcionIni=" & form.ADescripcionIni>		
</cfif>
<cfif isdefined("form.APlacaFin") and len(trim(form.APlacaFin))>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "APlacaFin=" & form.APlacaFin>	
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "ADescripcionFin=" & form.ADescripcionFin>		
</cfif>
<cfif isdefined("form.estado") and len(trim(form.estado))>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "estado=" & form.estado>	
</cfif>

<!--- Para impresión de documentos --->	
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<cf_rhimprime datos="/sif/af/responsables/consultas/HistoricoDocumentosRep.cfm" paramsuri="#vsFiltro#"> 
<form name="form1">
	<cf_sifHTML2Word>
		<table width="100%">
			<tr><td><cfinclude template="HistoricoDocumentosRep.cfm"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><input type="button" value="Regresar" onClick="javascript: history.back();"></td></tr>
		</table>
	</cf_sifHTML2Word>
</form>