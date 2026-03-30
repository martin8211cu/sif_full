<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="Errores">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">

		<cfquery name="datos_escenario" datasource="#session.DSN#">
			select RHEdescripcion, RHEfdesde as desde, RHEfhasta as hasta
			from RHEscenarios
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<table width="95%" align="center" cellpadding="2" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><td align="left"><font size="2"><strong>Errores en proceso de Aprobaci&oacute;n de Escenario</strong></font></td></tr>
			<tr>
				<td>
					<cfoutput>
					<table width="100%" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%"><strong>Escenario:</strong>&nbsp;</td>
							<td>#datos_escenario.RHEdescripcion#</td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap"><strong>Fecha Inicio:</strong>&nbsp;</td>
							<td>#LSDateFormat(datos_escenario.desde, 'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap"><strong>Fecha Final:</strong>&nbsp;</td>
							<td>#LSDateFormat(datos_escenario.hasta, 'dd/mm/yyyy')#</td>
						</tr>

					</table>
					</cfoutput>
				</td>
			</tr>

			<tr><td><hr size="1" /></td></tr>			

			<cfif isdefined("form.filtrar") and len(trim(form.filtrar))>
				<tr>
					<td><font size="2"><strong>Situaci&oacute;n propuesta es menor a la actual</strong></font></td>
				</tr>
				<cfoutput>
				<tr>
					<td><font size="2"><strong>Plaza Presupuestaria:&nbsp;</strong>#trim(valida_montos.RHPPcodigo)# - #trim(valida_montos.RHPPdescripcion)#</font></td>
				</tr>
				<tr><td colspan="6"><strong>Las siguiente personas estas nombradas en la plaza presupuestaria, y estan afectadas por el movimiento:</strong>&nbsp</td></tr>
				</cfoutput>
				<tr><td>
					<table width="100%" cellpadding="2" cellspacing="0" align="center" style=" border: #e5e5e5 SOLID 1PX;">
						<tr>
							<td class="tituloListas">Empleado</td>
							<td align="right" class="tituloListas">Fecha Inicio</td>
							<td align="right" class="tituloListas">Fecha Final</td>
							<td align="right" class="tituloListas">Monto Actual</td>
							<td align="right" class="tituloListas">Monto Propuesto</td>
						</tr>
						<cfoutput query="valida_montos" >
						<tr class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
							<td>#valida_montos.DEidentificacion# - #valida_montos.DEnombre# #valida_montos.DEapellido1# #valida_montos.DEapellido2#</td>
							<td class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="right">#lsdateformat(valida_montos.PEfdesde, 'dd/mm/yyyy')#</td>
							<td class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="right">#lsdateformat(valida_montos.PEfhasta, 'dd/mm/yyyy')#</td>
							<td class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="right">#lsnumberformat(valida_montos.SAmonto, ',9.00')#</td>
							<td class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="right">#lsnumberformat(valida_montos.PEmonto, ',9.00')#</td>
						</tr>
						</cfoutput>
					</table>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
				
				<tr><td align="center">
					<cfoutput>
					<form name="form2" method="post" action="escenario-aprobar-sql.cfm" >
					<input type="hidden" name="RHEid" value="#form.RHEid#" />
					<input type="submit" name="Regresar" value="Regresar" />
					</form>
					</cfoutput>
				</tr>	
				
			<cfelse>

				<cfif isdefined("valida_cuentas") and valida_cuentas.recordcount gt 0 >
					<tr>
						<td><font size="2"><strong>Los siguientes formatos de cuenta no corresponden a Cuentas Presupuestarias v&aacute;lidas:</strong></font></td>
					</tr>
	
					<tr>
						<td>
							<!---<div style="overflow:auto; height:<cfif valida_montos.recordcount gt 50>350px;<cfelse>75px;</cfif>  border-style:solid; border: #e5e5e5 SOLID 1PX;"    >--->
							<table width="100%" cellpadding="2" cellspacing="0" align="center" style=" border: #e5e5e5 SOLID 1PX;">
								<tr>
									<td class="tituloListas" >Formato de Cuenta</td>
								</tr>
									<cfoutput>
									<cfloop query="valida_cuentas">
									<tr class="<cfif valida_cuentas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
										<td><cfif not len(trim(valida_cuentas.cuenta))><font color="##FF0000">Algunos formatos de cuenta no pudieron ser generados y quedaron vac&iacute;os.</font><cfelse>#trim(valida_cuentas.cuenta)# </cfif></td>
									</tr>
									</cfloop>
									</cfoutput>
							</table>
							<!---</div>--->
						</td>
					</tr>
				</cfif>

				<cfif isdefined("tablas_incompletas") and tablas_incompletas.recordcount gt 0 >
					<tr><td>&nbsp;</td></tr>		
					<tr>
						<td><font size="2"><strong>Tablas salariales inconsistentes</strong></font></td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="2" cellspacing="0" align="center" style=" border: #e5e5e5 SOLID 1PX;">
								<tr>
									<td class="tituloListas">Tipo</td>
									<td class="tituloListas">Tabla Salarial</td>
									<td  class="tituloListas">Fecha Inicial</td>
									<td  class="tituloListas">Fecha Final</td>
								</tr>
								<cfoutput query="tablas_incompletas">
								<tr>
									<td>#trim(tablas_incompletas.RHTTcodigo)# - #tablas_incompletas.RHTTdescripcion#</td>
									<td>#tablas_incompletas.RHETEdescripcion#</td>
									<td>#LSDateFormat(tablas_incompletas.RHETEfdesde, 'dd/mm/yyyy')#</td>
									<td>#LSDateFormat(tablas_incompletas.RHETEfhasta, 'dd/mm/yyyy')#</td>
								</tr>
								</cfoutput>
							</table>
						</td>	
					</tr>					

				</cfif>
	
				<cfif isdefined("valida_montos") and valida_montos.recordcount gt 0 >
					<tr><td>&nbsp;</td></tr>		

					<tr>
						<td><font size="2"><strong>Para las siguientes plazas, la situaci&oacute;n propuesta es menor a la situaci&oacute;n actual:</strong></font></td>
					</tr>
	
					<tr>
						<td>
							<div style="overflow:auto; height:<cfif valida_montos.recordcount gt 50>350px;<cfelse>75px;</cfif>  border-style:solid; border: #e5e5e5 SOLID 1PX;"    >
							<table width="100%" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td class="tituloListas">Plaza Presupuestaria</td>
									<td class="tituloListas" align="right">Monto Actual</td>
									<td class="tituloListas" align="right">Monto Propuesto</td>
									<td class="tituloListas" width="10%">&nbsp;</td>
								</tr>
									<cfoutput query="valida_montos" group="RHPPid">
									<tr class="<cfif valida_montos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
										<td>#trim(valida_montos.RHPPcodigo)# - #trim(valida_montos.RHPPdescripcion)#</td>
										<td  align="right">#lsnumberformat(valida_montos.SAmonto, ',9.00')#</td>
										<td align="right">#lsnumberformat(valida_montos.PEmonto, ',9.00')#</td>
										<td align="center"><img style="cursor:pointer;" onclick="javascript:detalle(#form.RHEid#, #valida_montos.RHPPid#)" src="/cfmx/rh/imagenes/findsmall.gif" alt="Ver detalle..." /></td>
									</tr>
									</cfoutput>
							</table>
							</div>
						</td>
					</tr>
	
				</cfif>
			</cfif>
			
			<cfif not isdefined("form.filtrar")>
			<tr><td align="center">
			<cfoutput>
			<form name="form3" method="post" action="TrabajarEscenario.cfm" >
			<input type="hidden" name="RHEid" value="#form.RHEid#" />
			<input type="submit" name="Regresar" value="Regresar" />
			</form>
			</cfoutput>
			</td></tr>
			</cfif>
			
			
		</table>
		
		<form name="form1" method="post" action="escenario-aprobar-sql.cfm">
			<input type="hidden" name="RHEid" value="" />
			<input type="hidden" name="RHPPid" value="" />
			<input type="hidden" name="filtrar" value="filtrar" />
		</form>
		
		<script language="javascript1.2" type="text/javascript">
			function detalle(RHEid, RHPPid){
				document.form1.RHEid.value = RHEid;
				document.form1.RHPPid.value = RHPPid;
				document.form1.submit();
			}
		</script>
		
		
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
