
<cf_templateheader title="Mantenimiento de Concepto de Pagos a Terceros">
	<cfset titulo = 'Mantenimiento de Concepto de Pagos a Terceros'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif isdefined ("url.TESRPTCid") and len(trim(url.TESRPTCid)) and not isdefined("form.TESRPTCid")>
			<cfset form.TESRPTCid = url.TESRPTCid>
		</cfif>
		<cfif isdefined("form.TESRPTCid") AND form.TESRPTCid NEQ "">
			<cfset modo = "CAMBIO">
			<cfquery datasource="#session.dsn#" name="rsTESRPTconcepto">
				select TESRPTCcodigo, TESRPTCdescripcion, TESRPTCdevoluciones, TESRPTCCid,TESRPTCcxc,TESRPTCcxp 
				from TESRPTconcepto
				where CEcodigo = #session.CEcodigo#
				and TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
			</cfquery>
		<cfelse>
			<cfset modo = "ALTA">
			<cfquery datasource="#session.dsn#" name="rsTESRPTconcepto">
				select TESRPTCcodigo, TESRPTCdescripcion, TESRPTCdevoluciones, TESRPTCCid  
				from TESRPTconcepto
				where CEcodigo = #session.CEcodigo#
				and TESRPTCid = -1
			</cfquery>
		</cfif>
		
		<cfoutput>
			<form action="ConceptoPagosTerceros_Sql.cfm" method="post" name="form1" id="form1" onsubmit="javascript: return validar(this);">
				<input name="TESRPTCid" type="hidden" value="<cfif MODO EQ "CAMBIO">#form.TESRPTCid#</cfif>">
				<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
						<td valign="top" align="left">
							<input name="TESRPTCcodigo" type="text" size="2" tabindex="1" maxlength="2"
								value="<cfif MODO EQ "CAMBIO">#rsTESRPTconcepto.TESRPTCcodigo#</cfif>">
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
						<td>
							<input name="TESRPTCdescripcion" type="text" size="80" tabindex="1"
								value="<cfif MODO EQ "CAMBIO">#rsTESRPTconcepto.TESRPTCdescripcion#</cfif>">
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong>Reclasificar a Concepto Compras:&nbsp;</strong></td>
						<td valign="top" align="left">
								<cf_conlis title="Lista de Conceptos de Compra"
										campos = "TESRPTCCid, TESRPTCCcodigo, TESRPTCCdescripcion" 
										desplegables = "N,S,S" 
										modificables = "N,S,N" 
										traerInicial="#MODO NEQ 'ALTA' AND rsTESRPTconcepto.TESRPTCCid NEQ ""#"  
										traerFiltro="TESRPTCCid = #rsTESRPTconcepto.TESRPTCCid#"  
										size = "0,10,40"
										tabla="TESRPTconceptoCompras"
										columnas="TESRPTCCid, TESRPTCCcodigo, TESRPTCCdescripcion, case when TESRPTCCincluir=1 then 'INCLUIR' else 'EXCLUIR' end as enReporte"
										filtro="CEcodigo = #Session.CEcodigo#"
										desplegar="TESRPTCCcodigo, TESRPTCCdescripcion, enReporte"
										etiquetas="Concepto, Descripcion, En Reporte"
										formatos="S,S"
										align="left,left"
										asignar="TESRPTCCid, TESRPTCCcodigo, TESRPTCCdescripcion"
										asignarformatos="S,S"
										showEmptyListMsg="true"
										debug="false"
										tabindex="1"
								>
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong>Concepto para Devoluciones:&nbsp;</strong></td>
						<td>
							<cfif modo EQ "ALTA" OR rsTESRPTconcepto.TESRPTCdevoluciones NEQ "1"><strong>NO</strong><cfelse><strong>SÍ</strong></cfif>
						</td>
					</tr>
					<tr>
						<td align="right"nowrap="nowrap" ><strong>Cobros: &nbsp;<input name="Cobros" type="checkbox" value="1" id="TESRPTCcxc"<cfif isdefined ('rsTESRPTconcepto.TESRPTCcxc') and rsTESRPTconcepto.TESRPTCcxc eq 1>checked="checked"</cfif> /></strong></td>
						<td align="left"nowrap="nowrap"><strong>Pagos: &nbsp;<input name="Pagos" type="checkbox" value="1" <cfif isdefined ('rsTESRPTconcepto.TESRPTCcxp') and rsTESRPTconcepto.TESRPTCcxp eq 1>checked="checked"</cfif>/></strong></td>
					</tr>
					
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td valign="top" colspan="3">
							<cfset LvarDev = "">
							<cfif MODO EQ "CAMBIO" AND rsTESRPTconcepto.TESRPTCdevoluciones NEQ "1">
								<cfset LvarDev = "Para_Devoluciones">
							</cfif>
							<cf_botones modo='#MODO#' include="#LvarDev#" regresar="ConceptoPagosTerceros.cfm" tabindex="1">
						</td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<cfif MODO NEQ 'ALTA'>
						<cfinclude template="ConceptoPagosTercerosDet.cfm">
					</cfif>
			</form>	
			<cfif MODO NEQ 'ALTA'>
			
				<cfquery name="rsDetalleLista" datasource="#session.dsn#">
					select 
							a.TESRPTCid,
							a.TESRPTCfecha as fechaCambio,
							a.TESRPTCietuP,
							a.CFcuentaDB, db.CFformato as CFformatoDB,
								a.CFcuentaCR, cr.CFformato as CFformatoCR,
							case a.TESRPTCietu
								when  0 then 'NO'
								when  1 then 'SI'
							end as TESRPTCietu
					from TESRPTCietu a
						left join CFinanciera db
							on db.CFcuenta=a.CFcuentaDB
						left join CFinanciera cr
							on cr.CFcuenta=a.CFcuentaCR
					where a.TESRPTCid=#form.TESRPTCid#
					and a.Ecodigo=#session.Ecodigo#
				</cfquery>
			
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#rsDetalleLista#"
					desplegar="fechaCambio,TESRPTCietu,TESRPTCietuP,CFformatoDB,CFformatoCR"
					etiquetas="A partir de,Afecta,Porcentaje,Provisión Gasto x IETU (DB),Provisión IETU x Pagar (CR)"
					formatos="D,S,M,S,S"
					align="left,center,left,left,left"
					ira="ConceptoPagosTerceros_Form.cfm?ND"
					formName="formlista"
					keys="fechaCambio"
					maxRows="4"
					PageIndex="1"
					navegacion="&TESRPTCid=#form.TESRPTCid#"
					checkboxes="Y"
					incluyeForm="true" />
			</cfif>
			
			
			<script language="javascript" type="text/javascript">
				function validar(f) {
					var error_msg = '';
					if (f.TESRPTCcodigo.value == "") {
						error_msg += "\n - El Código no puede quedar en blanco.";
					}
					if (f.TESRPTCdescripcion.value == "") {
						error_msg += "\n - La Descripción no puede quedar en blanco.";
					}
					if (f.TESRPTCCcodigo.value == "") {
						error_msg += "\n - El Concepto de Compra a Reclasificar no puede quedar en blanco.";
					}
					if (!f.Cobros.checked && !f.Pagos.checked) {
						error_msg += "\n - Debe seleccionar uno Cobros o Pagos.";
					}
					
					<cfif modo NEQ 'ALTA'>
					if (f.chkIFE.checked) {
						if (f.TESRPTCietuP.value == "" || f.TESRPTCietuP.value == "0.00") {
							error_msg += "\n - El porcentaje de Impuesto no puede quedar en cero.";
						}
						if (f.CFcuentaDB.value == "") {
							error_msg += "\n - La Cuenta de Gasto no puede quedar en blanco.";
						}
						if (f.CFcuentaCR.value == "") {
							error_msg += "\n - La Cuenta de Impuesto por Pagar no puede quedar en blanco.";
						}
					}
					if (f.TESRPTCfecha.value == "") {
						error_msg += "\n - La Fecha no puede quedar en blanco.";
					}
					</cfif>
					
					if (!f.Cobros.checked && !f.Pagos.checked) {
						error_msg += "\n - Debe seleccionar uno Cobros o Pagos.";
					}
					
					// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						return false;
					}
					return true;
				}
				document.form1.TESRPTCcodigo.focus();
			</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
