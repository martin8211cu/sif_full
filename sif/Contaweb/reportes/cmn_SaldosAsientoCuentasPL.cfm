<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">
<cf_template template="#session.sitio.template#">
<!---***************************************************** --->

<cf_templatearea name="title">
	Archivo por Lista de las Cuentas Contables
</cf_templatearea>
<!---***************************************************** --->
<cf_templatearea name="left" >
</cf_templatearea>
<cf_templatearea name="body">
<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** --->

<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
 	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
 	qFormAPI.include("*");
</SCRIPT>
<cfif IsDefined("url.IDSESSION")>
	<cflocation url="../reportes/cmn_SaldosAsientoCuentasPL.cfm">
</cfif>
<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<link href="/cfmx/sif/Contaweb/css/estilos.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" >
	<tr>
		<td>
			<cfinclude template="cmn_formSaldosAsientoCuentasPL.cfm">
		</td>
  	</tr>
</table>
<!---***************************************************** --->
</cf_templatearea>
</cf_template>
