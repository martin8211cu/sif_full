<cf_templateheader title="Reporte de Saldos de Consolidados de &Oacute;rdenes de Compra">
			<!--- Obtiene los datos del proveedor --->
			<cfquery name="rsInfoProveedor" datasource="#session.dsn#">
				select sn.SNnombre
				from SNegocios sn
				where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			</cfquery>
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Saldos de Consolidados de Ordenes de Compra'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			
			<cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">

			<cfoutput>
				<form action="ConsolidadoOCs-filtro.cfm" name="formCorreoEnviado" method="post">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td class="subTitulo tituloListas">&nbsp;</td>
	  						<td colspan="3" class="subTitulo tituloListas">
								<img src="OrdenesCompra-email.gif" width="37" height="12">&nbsp;&nbsp; El correo ha sido enviado satisfactoriamente 
							</td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>De:</td>
	  						<td>&nbsp;</td>
	  						<td>#enviadoPor#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Para:</td>
	  						<td>&nbsp;</td>
	 					 	<td>#HTMLEditFormat(rsInfoProveedor.SNnombre)# &lt;#HTMLEditFormat(url.email)#&gt;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td>Copia:</td>
	  						<td>&nbsp;</td>
	  						<td><cfif isdefined("url.Ccemail") and len(trim(url.Ccemail)) gt 0>&lt;#HTMLEditFormat(url.Ccemail)#&gt;</cfif></td>
	  					</tr>
						<tr>
							<td>&nbsp;</td>
							<td>Asunto:</td>
	  						<td>&nbsp;</td>
	  						<td>#Asunto#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
	  						<td colspan="3"><input type="submit" value="Continuar" name="btnContinuar"></td>
	  					</tr>
						<tr>
	  						<td colspan="4">&nbsp;</td>
	  					</tr>
					</table>
				</form>
				
				<cfif url.TipoReporte eq 'R'>
					<cfinclude template="ConsolidadoOCs-represum.cfm">
				<cfelseif url.TipoReporte eq 'D'>
					<cfinclude template="ConsolidadoOCs-repdet.cfm">
				</cfif>

			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
