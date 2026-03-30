<cf_templateheader title="Anulaci&oacute;n de Ordenes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Anulaci&oacute;n de Ordenes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfoutput>
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2" class="tituloAlterno" align="center"><strong>Lista de Solicitantes sin e-mail</strong></td></tr>
				<tr>
					<td class="tituloListas"><strong>Código</strong></td>
					<td class="tituloListas"><strong>Nombre</strong></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<cfloop index="i" list="#url.paramSolicitantes#" delimiters=",">
					<cfquery name="rsSolicitantes" datasource="#session.DSN#">
						select 	CMScodigo,
								CMSnombre
						from CMSolicitantes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CMSid = #i# 
					</cfquery>
					<tr>
						<td>#rsSolicitantes.CMScodigo#</td>
						<td>#rsSolicitantes.CMSnombre#</td>
					</tr>
				</cfloop>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" class="tituloListas">
						<strong>
							NOTA:  Los solicitantes que no tienen una cuenta de correo especificada no han sido notificados de la 
							anulación de la Orden de Compra
						</strong>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<form name="form1" action="anulaOrden.cfm">
							<input type="submit" value="Regresar" name="btnRegresar">
						</form>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>