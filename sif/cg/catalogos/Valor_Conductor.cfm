<cf_templateheader title="Valores por Conductor"> 
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = 'Valores por Conductor'>
	
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif (isdefined('form.CGCid') and len(trim(form.CGCid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.CGCid'))>
	 		 <cfinclude template="Valor_Conductor_form.cfm">			
		<cfelse>
			<cfinclude template="Valor_Conductor_lista.cfm">
		</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>