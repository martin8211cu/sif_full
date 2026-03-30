<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">
<cfif not isdefined("Form.CJX19REL") and not isdefined("url.CJX19REL")>
	<cfset Form.CJX19REL = "0">
<cfelse>
	<cfif isdefined("Form.CJX19REL") and not isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#Form.CJX19REL#">
	<cfelseif not isdefined("Form.CJX19REL") and isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#url.CJX19REL#">
	<cfelseif isdefined("Form.CJX19REL") and isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#Form.CJX19REL#">
	</cfif>	
</cfif>

<cfset Gastos    = "../operacion/cjc_PrincipalGasto.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Anticipos = "../operacion/cjc_PrincipalAnticipos.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Posteo = "../operacion/cjc_PrincipalPosteo.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Consulta  = "../operacion/cjc_PrincipalConsulta.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">

<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
 	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
 	qFormAPI.include("*");
</SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	seleccionado('PST')
</script> 

<cf_templateheader title="Pantalla Unica">

<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** 
<cfinclude template="../portlets/pNavegacionFT.cfm">--->
<cfinclude template="../portlets/MenuGastos.cfm">

	<!--- *********************** --->
	<!---** AREA DE PINTADO    ** --->
	<!---************************ --->
	<table width="100%" border="0" >
		<tr>
			<td>
				<cfinclude template="cjc_formPosteo.cfm">
			</td>
		</tr>
	</table>
<cf_templatefooter>
