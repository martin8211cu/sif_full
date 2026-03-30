<!---<cfsetting enablecfoutputonly="yes">
<cfset LvarwhereEspecial = "">
<cfquery name="rsVerificaSocio" datasource="asp">
	select llave
	from UsuarioReferencia u
	where Usucodigo = #session.Usucodigo#
	  and STabla = 'SNegocios'
</cfquery>
<cfif isdefined("rsVerificaSocio") and len(trim(rsVerificaSocio.llave)) GT 0>
	<cfset session.SocioCxC = rsVerificaSocio.llave>
	<cfset LvarwhereEspecial = " and SNcodigo = #rsVerificaSocio.llave#">
	<cfset form.SNcodigo = session.SocioCxC>
	<cflocation url="../../sif/cc/consultas/analisisSocio.cfm?SNcodigo=#session.SocioCxC#">
</cfif>

<cfquery name="rsVerificaExistenciaDocumentosCC" datasource="#session.dsn#" cachedwithin="#createtimespan(0, 1, 0, 0)#">
	select count(1) as CantidadDocumentos
	from Documentos
	where Ecodigo = #session.ecodigo#
	  and Dsaldo > 0
	  #LvarwhereEspecial#
</cfquery>

<cfset Lvar_MenuCC_PresentarGraficos = true>

<cfif rsVerificaExistenciaDocumentosCC.CantidadDocumentos EQ 0 or rsVerificaExistenciaDocumentosCC.CantidadDocumentos GT 1500>
	<cfset Lvar_MenuCC_PresentarGraficos = false>
</cfif>

<cfsetting enablecfoutputonly="no">
--->
<cf_templateheader title="Producci&oacute;n">
		<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Producci&oacute;n">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="1%" rowspan="13">
					<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>
							<cf_menu sscodigo="OTROS" smcodigo="PROD">
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
<!---
			  <tr>
			  	<td valign="top" align="center">
				<cfif Lvar_MenuCC_PresentarGraficos>
					<cfinclude template="../../sif/cc/MenuCC-documentos-v2.cfm">
					<cf_tabs>
						<cf_tab text="An&aacute;lisis de Vencimiento">
							<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td valign="top" align="center">
								<cfif Lvar_MenuCC_PresentarGraficos>
									<cfset session.referencia = 'MenuCC.cfm'>
									<cfinclude template="../../sif/cc/MenuCC-barGraph-v2.cfm">
								<cfelse>
									&nbsp;
								</cfif>
								</td>
							  </tr>
							   <tr>
								<td nowrap align="center" style="vertical-align:top" class="smenu55">--- Los montos de los gr&aacute;ficos est&aacute;n expresados en moneda local. --- </td>
							  </tr>
							</table>
						</cf_tab>
						<cf_tab text="An&aacute;lisis de Morosidad">
							<table width="1%" align="center"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td align="center">
								<cfif Lvar_MenuCC_PresentarGraficos>
									<cfinclude template="../../sif/cc/MenuCC-pieGraph.cfm">
								<cfelse>
									&nbsp;
								</cfif>
								</td>
							  </tr>
							  <tr>
								<td nowrap align="center" style="vertical-align:top" class="smenu55">--- Los montos de los gr&aacute;ficos est&aacute;n expresados en moneda local. --- </td>
							  </tr>
							</table>
						</cf_tab>
					</cf_tabs>
				<cfelse>&nbsp;	
				</cfif>
				</td>
			  </tr>
			  <cfif Lvar_MenuCC_PresentarGraficos>
				  
			  </cfif>
--->			  
			</table>
			</div>
		<cf_web_portlet_end>
	<cf_templatefooter>