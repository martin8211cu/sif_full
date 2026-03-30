<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">

<cfif isdefined("url.RESPOSTEO")>
	<script language="JavaScript">
		Resultado = "<cfoutput>#url.RESPOSTEO#</cfoutput>"
		alert(Resultado)
	</script>
</cfif>

<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** 
<cfinclude template="../portlets/pNavegacionFT.cfm">--->
<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
 	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
 	qFormAPI.include("*");
</SCRIPT>

<cf_templateheader title="Pagos en Cola">

<cfif IsDefined("url.IDSESSION")>
	<cflocation url="../operacion/cjc_ColaPagos.cfm">
</cfif>
<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->

<table width="100%" border="0" >
	<tr>
		<td>
			<cfinclude template="../operacion/cjc_formColaPagos.cfm">
		</td>
  	</tr>
 </table>
<!---***************************************************** --->
<cf_templatefooter>