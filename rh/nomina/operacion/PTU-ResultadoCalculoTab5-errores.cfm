<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_templatecss>
		<script language="javascript1.2" type="text/javascript">
			var popUpWin = 0;
			function detalle(cfcuenta, rcnid){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
		
				var width = 700;
				var height = 550;
				var left = 300;
				var top = 150;
		
				popUpWin = open('PTU-ResultadoCalculoTab5-erroresDetalle.cfm?cfcuenta='+cfcuenta, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
		</script>
		<cfif NOT isdefined("LvarfnTipoReg")>
		<cfinclude template="fnTipoRegDescripcion.cfm">
		<cfset LvarfnTipoReg = "">
		</cfif>
		
		<!-----==================== TRADUCCION =======================---->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Listado_de_Errores_en_la_Aplicacion"
			Default="Listado de Errores en la Aplicaci&oacute;n"	
			returnvariable="LB_Listado_de_Errores_en_la_Aplicacion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Regresar"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Seguir_con_la_Aplicacion"
			Default="Seguir con la Aplicación"
			returnvariable="BTN_Seguir_con_la_Aplicacion"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Desea_seguir_con_la_Aplicacion_de_la_Relacion_de_Calculo_aunque_hayan_cuentas_sin_fondos_suficientes"
			Default="Desea seguir con la Aplicación de la Relación de Cálculo, aunque hayan cuentas sin fondos suficientes?"
			returnvariable="MSG_Desea_seguir_con_la_Aplicacion_de_la_Relacion_de_Calculo_aunque_hayan_cuentas_sin_fondos_suficientes"/>	
		
		
		<cfset titulo = '#LB_Listado_de_Errores_en_la_Aplicacion#' >

		<!---<cf_web_portlet_start titulo="<cfoutput>#titulo#</cfoutput>" border="true" >--->
			<table width="100%" align="center" cellpadding="0" cellspacing="0">
				<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td style="padding-left:57px"><strong><font size="2"><cf_translate key="LB_Listado_de_Errores_en_la_Aplicacion">Listado de Errores en la Aplicaci&oacute;n</cf_translate></font></strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cfinclude template="/rh/portlets/pRelacionCalculoPTU.cfm"></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>
						<!--- Errores de Contabilidad --->

						<cfif tipo eq 0 >
							<form name="form1" style="margin:0">
							<table width="95%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td colspan="2" class="tituloListas"><strong><cf_translate key="LB_Lista_de_validacion_de_errores">LISTA DE VALIDACION DE ERRORES</cf_translate></strong></td>
								</tr>
								<tr>
									<td class="tituloListas"><strong><cf_translate key="LB_Descripcion_del_Error">Descripci&oacute;n del Error</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>	
								</tr>
								<cfoutput query="cuentas_tipo">
									<tr>
										<td>#cuentas_tipo.descripcion#</td>
										<td>#fnTipoRegDescripcion(cuentas_tipo.tiporeg)#</td>
									</tr>
								</cfoutput>
								<tr><td colspan="2" align="center"><cf_botones values="#BTN_Regresar#"></td></tr>
							</table>
							</form>
							<cfoutput>
							<script language="javascript1.2" type="text/javascript">
								function funcRegresar(){
									location.href = '#Lvar_Regresar#?RCNid=#form.RCNid#';
									return false;
								}
							</script>
							</cfoutput>

						<cfelseif tipo eq 10 >
							<!--- Formato de Cuenta Financiera inválido --->
							<form name="form1" style="margin:0">
							<table width="95%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td colspan="2" class="tituloListas"><strong><cf_translate key="LB_Lista_de_cuentas_financieras_con_formato_invalido_o_no_existente">LISTA DE CUENTAS FINANCIERAS CON FORMATO INVÁLIDO O NO EXISTENTE</cf_translate></strong></td>
								</tr>
								<tr>
									<td class="tituloListas"><strong><cf_translate key="LB_Formato_cuenta_financiera">Formato Cuenta Financiera</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
									<td align="right" class="tituloListas"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
								</tr>
									<cfoutput query="errores_pres" group="Cformato">
										<tr>
											<td>#errores_pres.Cformato#</td>
											<td>#fnTipoRegDescripcion(errores_pres.tiporeg)#</td>
											<td align="right">#LSNumberFormat(montores, ',9.0')#</td>
										</tr>
									</cfoutput>
								<tr>
									<td>
										<cfoutput><cf_botones values="#BTN_Regresar#"></cfoutput>
									</td>
								</tr>
							</table>
							</form>
						<cfelseif tipo eq 20>
							<!--- Cuentas Financieras que requieren Control de Presupuesto asociadas a un tipo de registro que no verifica presupuesto --->
							<form name="form1" style="margin:0">
							<table width="95%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td colspan="6" class="tituloListas">
										<strong>
											<cf_translate key="LB_Lista_de_cuentas_cuyo_tipo_de_registro_esta_mal_configurado">
											LISTA DE CUENTAS FINANCIERAS CUYO TIPO DE REGISTRO ESTA MAL CONFIGURADO<BR>
											(Cuentas Financieras que requieren Control de Presupuesto, asociadas a un Tipo de Registro que no verifica Presupuesto)
											</cf_translate>
										</strong>
									</td>
								</tr>
								<tr>
									<td class="tituloListas"><strong><cf_translate key="LB_Cuenta_Financiera">Cuenta Financiera</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Periodos">Período</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Tipo_registro">Tipo Registro</cf_translate></strong></td>
									<td align="right" class="tituloListas"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
								</tr>
									<cfoutput query="errores_pres" group="Cformato">
										<tr>
											<td>#errores_pres.Cformato#</td>
											<td>#errores_pres.CFdescripcion#</td>
											<td>#errores_pres.Periodo#-#errores_pres.Mes#</td>
											<td>#fnTipoRegDescripcion(errores_pres.TipoReg)#</td>
											<td align="right">#LSNumberFormat(montores, ',9.0')#</td>
										</tr>
									</cfoutput>
								<tr><td colspan="4" align="center"><cfoutput><cf_botones values="#BTN_Regresar#"></cfoutput></td></tr>
							</table>
							</form>
						<cfelseif tipo eq 21 OR tipo eq 22>
							<!--- Cuenta de Presupuesto sin Fondos --->
							<form name="form1" style="margin:0">
							<table width="95%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td colspan="9" class="tituloListas"><strong><cf_translate key="LB_Lista_de_cuentas_financieras_con_errores_en_control_de_presupuesto">LISTA DE CUENTAS FINANCIERAS CON ERRORES EN CONTROL DE PRESUPUESTO</cf_translate></strong></td>
								</tr>
								<tr>
									<td class="tituloListas"><strong><cf_translate key="LB_Cuenta_Financiera">Cuenta Financiera</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Cuenta_Presupuesto">Cuenta Presupuesto</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Periodo">Período</cf_translate></strong></td>
									<td class="tituloListas"><strong><cf_translate key="LB_Ofi">Ofi.</cf_translate></strong></td>
									<td class="tituloListas" align="right"><strong><cf_translate key="LB_Disponible">Disponible</cf_translate><BR><cf_translate key="LB_Anterior">Anterior</cf_translate></strong></td>
									<td class="tituloListas" align="right"><strong><cf_translate key="LB_monto">Monto</cf_translate><BR><cf_translate key="LB_Movimiento">Movimiento</cf_translate></strong></td>
									<td class="tituloListas" align="right"><strong><cf_translate key="LB_NRPs">NRPs</cf_translate><BR><cf_translate key="LB_Pendientes">Pendientes</cf_translate></strong></td>
									<td class="tituloListas" align="right"><strong><cf_translate key="LB_Exceso_neto">Exceso Neto</cf_translate><BR><cf_translate key="LB_Generado">Generado</cf_translate></strong></td>
									<td class="tituloListas" align="center"><strong><cf_translate key="LB_MSG">MSG</cf_translate></strong></td>
								</tr>
									<cfoutput query="errores_pres">
										<tr>
											<td nowrap>#errores_pres.Cformato#&nbsp;&nbsp;</td>
											<td nowrap>#errores_pres.CPformato#&nbsp;&nbsp;</td>
											<td nowrap>#errores_pres.Periodo#-#errores_pres.Mes#&nbsp;&nbsp;</td>
											<td>#errores_pres.CodigoOficina#&nbsp;&nbsp;</td>
										<cfif errores_pres.ConError EQ "1">
											<td align="right">#LSNumberFormat(errores_pres.DisponibleAnterior, ',9.0')#</td>
											<td align="right">#LSNumberFormat(errores_pres.Monto, ',9.0')#</td>
											<td align="right">#LSNumberFormat(errores_pres.NRPsPendientes, ',9.0')#</td>
											<td align="right"><strong>#LSNumberFormat(errores_pres.ExcesoNeto, ',9.0')#</strong></td>
											<td align="center"><strong>Sin Fondos</strong></td>
										<cfelse>
											<td colspan="5"><strong>#errores_pres.MSG#</strong></td>
										</cfif>
										</tr>
									</cfoutput>
								<tr>
									<td colspan="9" align="center">
									<cfif tipo eq 21>
										<cfoutput><cf_botones values="Regresar"></cfoutput>
									<cfelse>
										<BR>
										<cf_translate key="LB_LasCuentasAnterioresTienenFondosInsuficientesPeroEstaActivoElControlAbiertoParaPagoDeNomina">Las cuentas anteriores tienen fondos insuficientes pero está activo el <strong>Control Abierto</strong> para Pago de Nómina,<BR>puede continuar con la Aplicacion de la Relación de Cálculo</cf_translate>
										<BR>
										<BR>
										<cfoutput><cf_botones values="#BTN_Regresar#,#BTN_Seguir_con_la_Aplicacion#" names="Regresar,btnSeguir"></cfoutput>
										<cfoutput>
										<cfloop collection=#form# item="x">
											<cfif x NEQ "FIELDNAMES">
												<input type="hidden" name="#x#" value="#form[x]#">
											</cfif>
										</cfloop>
										</cfoutput>
										<script language="javascript">
											function funcbtnSeguir()
											{
												<cfoutput>
												if (confirm("#MSG_Desea_seguir_con_la_Aplicacion_de_la_Relacion_de_Calculo_aunque_hayan_cuentas_sin_fondos_suficientes#"))
												{
													document.form1.method = "POST";
													document.form1.submit();
											 	}
												else
													return false;
												</cfoutput>
											}
										</script>
									</cfif>
									</td>
								</tr>
							</table>
							</form>
						</cfif>		
					</td>		
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<!---<cf_web_portlet_end>--->
	</cf_templatearea>
</cf_template>

