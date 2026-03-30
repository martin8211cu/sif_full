<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos2/Plantilla.cfm">
<cf_template template="#session.sitio.template#">
<!---***************************************************** --->

<cf_templatearea name="title">
	Consulta de cuentas 
</cf_templatearea>
<!---***************************************************** --->
<cf_templatearea name="left" >
	<!--- <cfinclude template="../Menu.cfm"> --->
</cf_templatearea>
<cf_templatearea name="body">

<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** 

<cfinclude template="../portlets/pNavegacionFT.cfm">--->
<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
 	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
 	qFormAPI.include("*");
</SCRIPT>

<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->

<table width="100%" border="0" >
	<tr>
		<td>
			<cfinclude template="cmn_formconsultacuenta.cfm">
		</td>
  	</tr>
 </table>
<!---***************************************************** --->
</cf_templatearea>
</cf_template>

