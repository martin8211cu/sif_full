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

<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Pagar">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" titulo="Men&uacute; Principal de Cuentas por Pagar">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0;">
				 <tr>
					<td  valign="top" width="80%">
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
                 <tr>
                 	<td>
                    	<form name="formPrincipal" action="/cfmx/sif/B2B/CxP/consultas/RFacturasCP2.cfm" method="post">
                    		<input name="ConDocs" value="Consulta de Documentos" type="submit"/>
                        </form>
                    </td>
                 </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>