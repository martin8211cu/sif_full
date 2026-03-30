<!--- VARIABLES DE TRADUCCION --->
<cfinclude template="RelacionCalculoRetro-translate.cfm">
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined ('url.RCNid') and not isdefined('form.RCNid')>
	<cfset form.RCNid=#url.RCNid#>
</cfif>
<cfif isdefined ('url.Tcodigo') and not isdefined('form.Tcodigo')>
	<cfset form.Tcodigo=#url.Tcodigo#>
</cfif>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Relaciones de C&aacute;lculo en Proceso"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<cf_templateheader title="#nombre_proceso#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#nombre_proceso#">
					<cfinclude template="RelacionCalculoRetro-listaForm.cfm">
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>