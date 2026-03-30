<!---<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">--->

<cfif isdefined("url.pageNum_lista0") and not isdefined("form.pageNum_lista0") >
	<cfset form.pageNum_lista0 = url.pageNum_lista0 >
</cfif>
<cfif isdefined("url.f_identificacion") and not isdefined("form.f_identificacion") >
	<cfset form.f_identificacion = url.f_identificacion >
</cfif>
<cfif isdefined("url.f_asociado") and not isdefined("form.f_asociado") >
	<cfset form.f_asociado = url.f_asociado >
</cfif>

<cfoutput>

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
		<cfif modo neq 'ALTA'>
			<tr>
				<td width="1%" nowrap="nowrap"><strong>#LB_Tipo_Credito#:</strong></td>
				<td>
					<cfif modo NEQ "ALTA">
						#trim(data_credito.ACCTcodigo)# - #data_credito.ACCTdescripcion#
					</cfif> 
				</td>
				<td width="1%" nowrap="nowrap"><strong>#LB_Periodicidad#:</strong></td>	
				<td>
					<cfif modo NEQ "ALTA">
						<cfif data.ACCAperiodicidad eq 0 >
							#LB_Semanal#
						<cfelseif data.ACCAperiodicidad eq 1 >
							#LB_Bisemanal#
						<cfelseif data.ACCAperiodicidad eq 2 >
							#LB_Quincenal#
						<cfelseif data.ACCAperiodicidad eq 3 >
							#LB_Mensual#
						</cfif>
					</cfif>	
				</td>
				
				<td width="1%" nowrap="nowrap"><strong>#LB_Plazo#:</strong></td>
				<td>
					<cfif MODO NEQ "ALTA">
						#LSNumberFormat(data.ACCTplazo, ',9')#					
					</cfif>
				</td>
				<td width="1%" nowrap="nowrap"><strong>#LB_Fecha_Inicio#:</strong></td>
		
				<td>
					<cfif MODO NEQ "ALTA">
						#LSDateFormat(data.ACCTfechaInicio,'dd/mm/yyyy')#
					</cfif>		
				</td>
			</tr>
  	
			<tr>
				<td width="1%" nowrap="nowrap"><strong>#LB_Tasa#:</strong></td>
				<td>
					<cfif MODO NEQ "ALTA">
						#LSNumberFormat(data.ACCTtasa, ',9.00')#%					
					</cfif>
				</td>
				<td width="1%" nowrap="nowrap"><strong>#LB_Tasa_mora#:</strong></td>
				<td>
					<cfif MODO NEQ "ALTA">
						#LSNumberFormat(data.ACPTtasamora, ',9.00')#%					
					</cfif>
				</td>
				<td width="1%" nowrap="nowrap"><strong>#LB_Monto#:</strong></td>	
				<td>
					<cfif MODO NEQ "ALTA">
						#LSNumberFormat(data.ACCTcapital, ',9.00')#	
					</cfif>
				</td>
				<td width="1%" nowrap="nowrap"><strong>#LB_Saldo#:</strong></td>	
				<td>
					<cfif MODO NEQ "ALTA">
					#LSNumberFormat(data.saldo, ',9.00')#	
				</cfif>
				</td>
			</tr>
		
			<tr><td colspan="8"><hr size="1" /></td></tr>
			<tr>
				<td colspan="8">
					<form name="form1" style="margin:0;" method="post" action="pagoextraordinario-sql.cfm" onsubmit="javascript:return validar();" >
						<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
							<input type="hidden" name="f_identificacion" value="#form.f_identificacion#" >
						</cfif>
						<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
							<input type="hidden" name="f_asociado" value="#form.f_asociado#" >
						</cfif>
						<cfif isdefined("form.pageNum_lista0") and len(trim(form.pageNum_lista0)) >
							<input type="hidden" name="pageNum_lista0" value="#form.pageNum_lista0#" >
						</cfif>
						<input type="hidden" name="ACAid" value="#form.ACAid#" >
						<cfif modo neq 'ALTA'>
							<input type="hidden" name="ACCAid" value="#form.ACCAid#" >
						</cfif>

						<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##CCCCCC">
							<tr>
								<td width="1%" nowrap="nowrap"><strong>#LB_Aplicar_pago2#:</strong></td>
								<td nowrap="nowrap" width="1%"><cf_monto name="ACCRPEmonto" decimales="2" value="" size="12" tabindex="1">	</td>
								<td>
									<input type="submit" class="btnAplicar" name="Aplicar" value="#LB_Aplicar_Pago#"  />
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			
			<cfif isdefined("url.ok") and isdefined("url.monto")>
				<tr><td></td></tr>
				<tr><td colspan="8" style="padding-left:30px" ><img src="/cfmx/rh/imagenes/w-check.gif" />&nbsp;&nbsp;Se registro exitosamente el pago por #LSNumberFormat(url.monto, ',9.00')#</td></tr>
				<tr><td></td></tr>
			</cfif>
			
		</cfif>

</cfoutput>

	<!--- planes de credito actuales del empleado --->
	<cfset extra = '' >
	<cfset navegacion = '' >
	<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
		<cfset extra = extra & ", '#form.f_identificacion#' as f_identificacion" >
		<cfset navegacion = navegacion & "&f_identificacion=#form.f_identificacion#" >
	</cfif>
	<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
		<cfset extra = ", '#form.f_asociado#' as f_asociado" >
		<cfset navegacion = navegacion & "&f_asociado=#form.f_asociado#" >													
	</cfif>
	<cfif isdefined("form.pageNum_lista0") and len(trim(form.pageNum_lista0)) >
		<cfset extra = ", '#form.pageNum_lista0#' as pageNum_lista0" >
		<cfset navegacion = navegacion & "&pageNum_lista0=#form.pageNum_lista0#" >													
	</cfif>
	
	<cf_dbfunction name="concat" args="e.DEapellido1,' ',e.DEapellido2,' ',e.DEnombre" returnvariable="asociado" >
	<cf_dbfunction name="concat" args="rtrim(d.ACCTcodigo),'-',d.ACCTdescripcion" returnvariable="tipo_credito" >

	<cfoutput>
	<tr><td>&nbsp;</td></tr>
	<tr bgcolor="##CCCCCC"><tr><td colspan="8" bgcolor="##CCCCCC"><strong>#LB_Creditos_correspondientes_al_asociado#</strong></td></tr></tr>
	<tr><td colspan="8">

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value=" 	ACCreditosAsociado b
		
													inner join ACAsociados c
													on b.ACAid=c.ACAid
													and c.ACAid=#form.ACAid#
													
													inner join DatosEmpleado e
													on e.DEid=c.DEid
													and e.Ecodigo=#session.Ecodigo#
													
													inner join ACCreditosTipo d
													on d.ACCTid=b.ACCTid "/>
			<cfinvokeargument name="columnas" value="  b.ACAid,
													   b.ACCAid,
													   e.DEidentificacion, 
													   #asociado# as asociado,
													   #tipo_credito# as tipo_credito, 
													   b.ACCTfechaInicio as inicio, 
													   b.ACCTcapital as monto, 
													   b.ACCTamortizado as amortizado,
													   b.ACCTcapital - b.ACCTamortizado as saldo #extra#"/>
			<cfinvokeargument name="desplegar" value="tipo_credito,inicio,monto, amortizado, saldo"/>
			<cfinvokeargument name="etiquetas" value="#LB_Tipo_Credito#,#LB_Fecha_Inicio#, #LB_Monto#, #LB_Amortizado#, #LB_Saldo#"/>
			<cfinvokeargument name="formatos" value="S,D,M,M,M"/>
			<cfinvokeargument name="filtro" value="b.ACCTcapital > b.ACCTamortizado
												order by e.DEapellido1, e.DEapellido2, e.DEnombre, d.ACCTcodigo"/>
			<cfinvokeargument name="align" value="left, center, right, right, right"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="keys" value="ACCAid,ACAid"/>
			<cfinvokeargument name="irA" value="pagoextraordinario.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="maxrows" value="0"/>
		</cfinvoke>
	</td></tr>
	</cfoutput>

	<tr><td colspan="8" align="center"><input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: location.href='pagoextraordinario-lista.cfm?1=1<cfoutput>#navegacion#</cfoutput>'" tabindex="1"></td></tr>

</table>

<cfif modo neq 'ALTA'>
	<cf_qforms form="form1">
	<script>
		<cfoutput>
			objForm.ACCRPEmonto.required = true;
			objForm.ACCRPEmonto.description = '#LB_Pago_Extraordinario#';
		</cfoutput>
		
		function validar(){
			if ( confirm('<cfoutput>#LB_Confirmar#</cfoutput>') ){
				return true;
			}
			return false;	
		}	
		document.form1.ACCRPEmonto.focus();		
	</script>
</cfif>
