<cfsetting enablecfoutputonly="yes">

<cfquery name="rsVerificaExistenciaDocumentosCP" datasource="#session.dsn#" cachedwithin="#createtimespan(0, 1, 0, 0)#">
	select count(1) as CantidadDocumentos
	from EDocumentosCP
	where Ecodigo = #session.ecodigo#
	  and EDsaldo > 0
</cfquery>

<cfset Lvar_MenuCP_PresentarGraficos = true>

<cfif rsVerificaExistenciaDocumentosCP.CantidadDocumentos EQ 0 or rsVerificaExistenciaDocumentosCP.CantidadDocumentos GT 3000>
	<cfset Lvar_MenuCP_PresentarGraficos = false>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_MenuPrinc	= t.Translate('TIT_MenuPrinc','Men&uacute; Principal de Cuentas por Pagar')>

<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Pagar">
		<cfinclude template="../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" titulo="#TIT_MenuPrinc#">
			<div class="">	
				<div class="row">
					<div class="col col-md-3">
						<cf_menu sscodigo="SIF" smcodigo="CP">
					</div>
					<div class="col col-md-9">	
						<cfif Lvar_MenuCP_PresentarGraficos>
							<cfinclude template="MenuDocumentos.cfm">
						</cfif>
					</td>
				 </tr>

				  <tr>
					<td   valign="top">
						<cfif Lvar_MenuCP_PresentarGraficos>
							<cfinclude template="MenuGrafico.cfm">
						</cfif>
					</td>
				 </tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>