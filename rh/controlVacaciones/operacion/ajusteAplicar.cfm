
<!--- registroMasivoAjuste.cfm --->
<!--- Variables de Traducción --->
<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Proceso de aplicaci&oacute;n de Ajuste de Vacaciones"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>


<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfinclude template="registroMasivoAjuste-label.cfm">
		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">			
					<cfinclude template="ajusteAplicar-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
