<cfif isdefined("url.empresa") and not isdefined("form.empresa") >
	<cfset form.empresa = url.empresa >
</cfif>
<cfif isdefined("url.Usulogin") and not isdefined("form.Usulogin") >
    <cfset form.Usulogin = url.Usulogin >
</cfif>
<cfif isdefined("url.Usulogin2") and not isdefined("form.Usulogin2") >
    <cfset form.Usulogin2 = url.Usulogin2 >
</cfif>
<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo") >
    <cfset form.SScodigo = url.SScodigo >
</cfif>
<cfset vdetalle = ''>
<cfif isdefined("url.detalle") and not isdefined("form.detalle") >
    <cfset form.detalle = url.detalle >
    <cfset vdetalle = "&detalle=#form.detalle#">
</cfif>
<cfif isdefined("url.usucodigo") and len(trim(url.usucodigo))  >
    <cfif isdefined("url.SRcodigo") and len(trim(url.SRcodigo)) and isdefined("url.vSScodigo") and len(trim(url.vSScodigo)) and isdefined("url.vEmpresa") and len(trim(url.vEmpresa)) >
        <cfset vdetalle = vdetalle & "&vEmpresa=#url.vempresa#&usucodigo=#url.usucodigo#&SRcodigo=#url.SRcodigo#&vSScodigo=#url.vSScodigo#">
    </cfif>
</cfif>
<cf_templateheader title="Permisos por Usuario">
    <cf_web_portlet_start border="true" titulo="Permisos por Usuario">
    <cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_htmlreportsheaders
        title="UsuarioPermisos" 
        filename="UsuarioPermisos#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
        ira="usuariosPermisos-filtro.cfm">
    <cfinclude template="usuariosPermisos-form.cfm">
    <cf_web_portlet_end>		
<cf_templatefooter>	