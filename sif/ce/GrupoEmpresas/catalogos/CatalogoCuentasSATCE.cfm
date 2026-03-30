<cfif isdefined("Form.Cambio") or isdefined("form.btnRegresar") or isdefined("form.BotonSel")>
	<cfset modo="CAMBIO">


</cfif>
<cfif isdefined("url.modo") and len(trim(url.modo)) and not isdefined("form.modo")>
	<cfset form.modo = url.modo>
</cfif>

<cfquery name="rs" datasource="#session.dsn#">
	select CAgrupador, Descripcion
	from CEAgrupadorCuentasSAT where CAgrupador = #form.CAgrupador#
</cfquery>
<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas" returnvariable="LB_Titulo" component="sif.Componentes.Translate"
method="Translate" xmlfile="CatalogoCuentasSATCE.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#: #rs.CAgrupador#: #rs.Descripcion#'>
		<cfset filtro = "">
		<cfset navegacion = "">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="../../../portlets/pNavegacionCG.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="100%" align="center">
						<tr>
							<td align="right">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
					<cfinclude template="formCatalogoCuentasSATCE.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
