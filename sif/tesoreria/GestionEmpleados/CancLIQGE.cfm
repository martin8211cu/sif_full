<cf_templateheader title="Cancelaci&oacute;n de Liquidaciones GE"> 
<cfinclude template="TESid_Ecodigo.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = 'Cancelaci&oacute;n de Liquidaciones de Gastos Empleados x Tesorer&iacute;a'>
  	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
    <cfset form.Tipo = 'GASTO'>
	<cfif (isdefined('form.GELid') and len(trim(form.GELid))) OR (isdefined('form.Nuevo')) or isdefined(('url.GELid'))OR (isdefined('url.Nuevo') or isdefined ('url.GEAid'))>
		<cfinclude template="CancLIQGE_form.cfm" >
	<cfelse>
		<cfinclude template="CancLIQGE_lista.cfm">
	</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>


