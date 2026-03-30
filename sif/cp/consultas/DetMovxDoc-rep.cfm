<!--- <cfdump var="#form#">
<cfdump var="#url#">
 --->
<cfset params = "&Documento=#form.Documento#" >
<cfset params = params & "&SNcodigo=#form.SNcodigo#" >

<!--- <cf_templateheader template="#session.sitio.template#"> --->
<table width="98%" cellpadding="2" cellspacing="0">
	<tr><td><cf_rhimprime datos="/sif/cp/consultas/DetMovxDoc-reporte.cfm" paramsuri="#params#" regresar="/cfmx/sif/cp/consultas/DetMovxDoc.cfm"></td></tr>
	<tr><td><cfinclude template="DetMovxDoc-reporte.cfm"></td></tr>
</table>
<!--- <cf_templatefooter> --->

<script language="javascript1.2" type="text/javascript">
	document.title = 'Cuentas por Pagar - Movimientos por Documento';
</script>

