<cfset LvarSAporEmpleadoSolicitante=true>
<cfset LvarSAporEmpleadoCFM = "Solicitante">
<cf_templateheader title="Reimpresión de Anticipos por Solicitante"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Reimpresión Anticipos de Empleados por Solicitante'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.GEAid') and len(trim(form.GEAid)) and not isdefined('url.regresar'))>					
					<cfinclude template="ReimpresionAnt_form.cfm">
				<cfelse>
					<cfinclude template="ReimpresionAnt_lista.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
