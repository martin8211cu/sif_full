<cfset LvarCPConsolidacionPresupuesto="0">

<cfif isdefined('url.Speriodo')>
	<cfset form.Speriodo2 = #url.Speriodo#>
</cfif>
<cfif isdefined('url.Smes')>
	<cfset form.Smes = #url.Smes#>
</cfif>
<cfif isdefined('url.Mcodigo')>
	<cfset form.Mcodigo = #url.Mcodigo#>
</cfif>
<cfif isdefined('url.modo')>
	<cfset form.modo = #url.modo#>
</cfif>
<cfif isdefined('url.TCHid')>
	<cfset form.TCHid = #url.TCHid#>
</cfif>
<cfif isdefined('url.TCH')> 
	<cfinclude template="../../cg/operacion/TCHistoricos.cfm" >
<cfelse>	
<cf_templateheader title="Tipos de Cambio de Consolidaci&oacute;n de Presupuesto">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Cambio de Consolidaci&oacute;n de Presupuesto">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfinclude template="../../cg/operacion/ConversionEstFin-form.cfm">
    <cf_web_portlet_end>	
<cf_templatefooter>
</cfif>