<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Tipos de Movimiento">
			<cfif isdefined("url.RHTMid") and len(trim(url.RHTMid))>
				<cfset form.RHTMid = url.RHTMid >
			</cfif>		
			<cfif isdefined("url.tab") and not isdefined("form.tab")>
				<cfset form.tab = url.tab >
			</cfif>						
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfif (isdefined('form.RHTMid') and form.RHTMid NEQ '') or (isdefined('form.btnNuevo') and form.btnNuevo NEQ '')>
						<cfinclude template="RHtabsTipoMov-form.cfm">					
					<cfelse>
						<cfinclude template="listaTipoMov.cfm">
					</cfif>
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>
