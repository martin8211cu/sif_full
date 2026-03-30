<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RHRHImportadoresDeMarcas"
	Default="RH-Importadores de Marcas"
	returnvariable="LB_RHRHImportadoresDeMarcas"/>
<cfquery name="rsImportador" datasource="sifcontrol">
	select EIcodigo,EIid,EIdescripcion 
	from EImportador 
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
</cfquery>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Importar Marcas"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
</cfsilent>
<cf_templateheader title="#LB_RHRHImportadoresDeMarcas#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nombre_proceso#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="60%" valign="top">
					<cf_sifFormatoArchivoImpr EIcodigo="#rsImportador.EIcodigo#">
				</td>
				<td align="center" width="40%" valign="top">
					<cfif isdefined("rsImportador") and rsImportador.RecordCount NEQ 0>
						<cf_sifimportar EIcodigo="#rsImportador.EIcodigo#" EIid="#rsImportador.EIid#" mode="in">
						</cf_sifimportar>
					<cfelse>
						<strong>--- <cf_translate key="MSG_NoSeEncontroElImportadorSeleccionado">No se encontró el importador seleccionado</cf_translate>---</strong>
					</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>