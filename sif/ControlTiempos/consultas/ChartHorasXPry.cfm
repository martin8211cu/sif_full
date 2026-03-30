<cf_template>
	<cf_templatearea name="title">
		Análisis de Horas por Proyecto
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Actividades por Usuario">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br>
			<cfif isdefined("url.fecDesde") and not isdefined("form.fecDesde")>
				<cfset Form.fecDesde = Url.fecDesde>
			</cfif>
			<cfif isdefined("url.fecHasta") and not isdefined("form.fecHasta")>
				<cfset Form.fecHasta = Url.fecHasta>
			</cfif>			
			<cfif isdefined("url.cobrable") and not isdefined("form.cobrable")>
				<cfset Form.cobrable = Url.cobrable>
			</cfif>			
			<cfif isdefined("url.proyecto") and not isdefined("form.proyecto")>
				<cfset Form.proyecto = Url.proyecto>
			</cfif>			
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<form name="form1" action="SQLChartHorasXPry.cfm" method="post" >
							<table width="100%" cellspacing="0" cellpadding="0" class="AreaFiltro">
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
								<tr>
									<td width="18%" align="right"><strong>Fecha Desde:</strong>&nbsp;</td>
									<td width="10%"><cf_sifcalendario name="fecDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
									<td width="21%" align="right"><strong>Fecha Hasta:</strong>&nbsp;</td>
									<td width="9%"><cf_sifcalendario name="fecHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
									<td width="13%" nowrap><div align="right">
										Cobrable: &nbsp;
									</div></td>
									<td width="10%" nowrap>
										<select name="Cobrable">
											<option value="2"
												<cfif isdefined("Form.Cobrable")>
													<cfif TRim(Form.Cobrable) EQ "2">
														selected
													</cfif> 
												</cfif>>
												todos
											</option>
											<option value="1"
												<cfif isdefined("Form.Cobrable")>
													<cfif TRim(Form.Cobrable) EQ "1">
														selected
													</cfif> 
												</cfif>>
												sí
											</option>
											<option value="0"
												<cfif isdefined("Form.Cobrable")>
													<cfif TRim(Form.Cobrable) EQ "0">
														selected
													</cfif> 
												</cfif>>
												no
											</option>
										</select>
									</td>
									<td width="18%"><cf_botones values="Consultar"></td>
									<td width="1%">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
							</table>
						</form>
						<cfif isdefined("form.proyecto") or isdefined("Form.Cobrable")>
							<cfinclude template="formChartHorasXPry.cfm">
						</cfif>
						<br>
						<cf_qforms>
						<script language="JavaScript" type="text/javascript">
							<!--//
								objForm.fecDesde.description = "Fecha Desde";
								objForm.fecHasta.description = "Fecha Hasta";
								objForm.required("fecDesde,fecHasta");
							//-->
						</script>
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>