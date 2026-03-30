<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">
<cf_template template="#session.sitio.template#">
<!---***************************************************** --->

<cf_templatearea name="title">
	Parámetros Globales
</cf_templatearea>
<!---***************************************************** --->
<cf_templatearea name="left" >
	<!--- <cfinclude template="../Menu.cfm"> --->
</cf_templatearea>
<cf_templatearea name="body">
<cfif not isdefined("Form.CJM00COD") and not isdefined("url.CJM00COD")>
	<cfset Form.CJM00COD = "0">
<cfelse>
	<cfif isdefined("Form.CJM00COD") and not isdefined("url.CJM00COD")>
		<cfset Form.CJM00COD = "#Form.CJM00COD#">
	<cfelseif not isdefined("Form.CJM00COD") and isdefined("url.CJM00COD")>
		<cfset Form.CJM00COD = "#url.CJM00COD#">
	<cfelseif isdefined("Form.CJM00COD") and isdefined("url.CJM00COD")>
		<cfset Form.CJM00COD = "#Form.CJM00COD#">
	</cfif>	
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

<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->

<table width="100%" border="0" >
	<tr>
		<td>
			<cfinclude template="../catalogos/cjc_formParamGlobal.cfm">
		</td>
  	</tr>
 </table>
<!---***************************************************** --->
</cf_templatearea>
</cf_template>
