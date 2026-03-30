<cfset LvarSAporEmpleadoSolicitante=true>
<cfset LvarSAporEmpleadoCFM = "Solicitante">
<cfset GvarPorResponsable=false>
<cf_templateheader title="Reimpresión de Liquidaciones por Solicitante"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Reimpresión Liquidaciones de Empleados por Solicitante'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.GELid') and len(trim(form.GELid)) and not isdefined('url.regresar'))>					
					<cfinclude template="ReimpresionLiq_form.cfm">
				<cfelse>
					<cfinclude template="ReimpresionLiq_lista.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
