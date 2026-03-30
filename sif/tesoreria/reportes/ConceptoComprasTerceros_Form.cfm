
<cf_templateheader title="Mantenimiento de Concepto de Compras a Terceros">
	<cfset titulo = 'Mantenimiento de Concepto de Compras a Terceros'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif isdefined ("url.TESRPTCCid") and len(trim(url.TESRPTCCid)) and not isdefined("form.TESRPTCCid")>
			<cfset form.TESRPTCCid = url.TESRPTCCid>
		</cfif>
		
		<cfif isdefined("form.TESRPTCCid") AND form.TESRPTCCid NEQ "">
			<cfset modo = "CAMBIO">
			<cfquery datasource="#session.dsn#" name="rsTESRPTconceptoCompras">
				select TESRPTCCcodigo, TESRPTCCdescripcion, TESRPTCCincluir
				from TESRPTconceptoCompras
				where CEcodigo = #session.CEcodigo#
				and TESRPTCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCCid#">
			</cfquery>
		<cfelse>
			<cfset modo = "ALTA">
		</cfif>
 		
		<cfoutput>
			<form action="ConceptoComprasTerceros_Sql.cfm" method="post" name="form1" id="form1" onsubmit="javascript: return validar(this);">
				<input name="TESRPTCCid" type="hidden" value="<cfif MODO EQ "CAMBIO">#form.TESRPTCCid#</cfif>">
				<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
						<td valign="top" align="left">
							<input name="TESRPTCCcodigo" type="text" size="2" maxlength="2" tabindex="1"
								value="<cfif MODO EQ "CAMBIO">#rsTESRPTconceptoCompras.TESRPTCCcodigo#</cfif>">
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
						<td>
							<input name="TESRPTCCdescripcion" type="text" size="80" tabindex="1"
								value="<cfif MODO EQ "CAMBIO">#rsTESRPTconceptoCompras.TESRPTCCdescripcion#</cfif>">
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong>Incluir en Reporte:&nbsp;</strong></td>
						<td>
							<select name="TESRPTCCincluir">
								<option value="1" <cfif modo NEQ "ALTA" AND rsTESRPTconceptoCompras.TESRPTCCincluir EQ "1"> selected</cfif>>Incluir</option>
								<option value="0" <cfif modo NEQ "ALTA" AND rsTESRPTconceptoCompras.TESRPTCCincluir EQ "0"> selected</cfif>>Excluir</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td valign="top" colspan="3">
							<cf_botones modo='#MODO#' regresar="ConceptoComprasTerceros.cfm" tabindex="1">
						</td>
					</tr>
				</table>
			</form>	
			
			<script language="javascript" type="text/javascript">
				function validar(f) {
					var error_msg = '';
					if (f.TESRPTCCcodigo.value == "") {
						error_msg += "\n - El Código no puede quedar en blanco.";
					}
					if (f.TESRPTCCdescripcion.value == "") {
						error_msg += "\n - La Descripción no puede quedar en blanco.";
					}
					// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						return false;
					}
					return true;
				}
				document.form1.TESRPTCCcodigo.focus();
			</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>