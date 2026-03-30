<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EjecucionDeScriptsDeExportacion"
	Default="Ejecuci&oacute;n de Scripts de Exportaci&oacute;n "
	returnvariable="LB_EjecucionDeScriptsDeExportacion"/> 

	<cf_templatearea name="title">
		<cfoutput>#LB_EjecucionDeScriptsDeExportacion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cfif not isdefined("FORM.MODULO") and isdefined("URL.MODULO")>
        	<cfset FORM.MODULO = replace(#URL.MODULO#,'?',' ','all')>
            <cfset FORM.MODULO = replace(form.MODULO,'_',' ','all')>
		</cfif>
		<cfif not isdefined("FORM.PARAMETROS") and isdefined("URL.PARAMETROS")>
			<cfset FORM.PARAMETROS =URL.PARAMETROS>
		</cfif>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_EjecucionDeScriptsDeExportacion#'>
			<cfinclude template="formSeleccionExportadores.cfm">
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
