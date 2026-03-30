<cf_templateheader title="Aprobaci&oacute;n Liquidaciones de Empleados">
<cf_navegacion name="form.GELid" navegacion="">
	<cfset titulo = 'Aprobar Liquidaciones'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
	
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
       
<cfparam name="url.tab" default="1">
<!---<cfdump var="#form#">--->
<cfparam name="session.Liquidacion.GELid" default="">
	<cfinclude template="TESid_Ecodigo.cfm">
	<cfif isdefined("form.AAprobar")>
		<cfinclude template="LiquidacionAprobar_sql.cfm">
	<cfelseif isdefined('form.GELid') and len(trim(form.GELid)) or  isdefined("form.GEAid") or isdefined("url.pagenum_listaAnti") or isdefined ('url.GELid')>
		<cfinclude template="LiquidacionAprobar_form.cfm">	
	<cfelse>
		<cfinclude template="LiquidacionAprobar_lista.cfm">
	</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>



