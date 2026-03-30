<cfsetting enablecfoutputonly="yes">

<cfquery name="rsVerificaExistenciaDocumentosCP" datasource="#session.dsn#" cachedwithin="#createtimespan(0, 1, 0, 0)#">
	select count(1) as CantidadDocumentos
	from EDocumentosCP
	where Ecodigo = #session.ecodigo#
	and EDsaldo > 0
</cfquery>

<cfset Lvar_MenuCP_PresentarGraficos = true>

<cfif rsVerificaExistenciaDocumentosCP.CantidadDocumentos EQ 0 or rsVerificaExistenciaDocumentosCP.CantidadDocumentos GT 1500>
	<cfset Lvar_MenuCP_PresentarGraficos = false>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<!--- <cfset TIT_MenuPrinc	= t.Translate('TIT_MenuPrinc','Men&uacute; Principal de Cuentas por Pagar')> --->

<cfsetting enablecfoutputonly="no">
<!--- <cf_templateheader title="SIF - Cuentas por Pagar">
		<cfinclude template="../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" titulo="#TIT_MenuPrinc#"> --->
		<cf_importlibs>
			<link href="/cfmx/plantillas/erp/css/erp.css" rel="stylesheet" type="text/css">

			<div class="">
				<div class="row">
					<!--- <div class="col col-md-3">
						 <cf_menu sscodigo="SIF" smcodigo="CP">
						 <cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_r" mostrar="V"/>
					</div> --->
					<div class="col col-md-12">
						<cfif Lvar_MenuCP_PresentarGraficos>
							<cfinclude template="MenuDocumentos.cfm">
							<cfinclude template="MenuGrafico.cfm">
						</cfif>
					</div>
				</div>
				<div class="row">&nbsp;</div>
			</div>
		<cf_web_portlet_end>
<!--- 	<cf_templatefooter> --->