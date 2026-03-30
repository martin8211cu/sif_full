<cfif isdefined("Url.DLlinea") and Len(Trim(Url.DLlinea)) and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>
<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isdefined("Form.DLlinea") and Len(Trim(Form.DLlinea))>
	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	<!---Datos Encabezado--->
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select 	c.DLlinea,
				<cf_dbfunction name="concat" args="b.DEapellido1,' ',DEapellido2,' ',b.DEnombre"> as Nombre
				,(select EVfantig from EVacacionesEmpleado x where x.DEid = c.DEid) as FechaIngreso
				,d.DLfvigencia  as FechaSalida
				,(select LTsalario from LineaTiempo z  
					where c.DEid = z.DEid 
						and <cf_dbfunction name="dateadd" args="-1, c.RHLPfecha"> between z.LTdesde and z.LThasta) as salario
				,c.RHLPfecha
				,case when d.DLobs is null then 
					e.RHTdesc
				else
					d.DLobs
				end as Motivo
		from RHLiquidacionPersonal c
			inner join DLaboralesEmpleado d
				on c.DLlinea = d.DLlinea	
			inner join RHTipoAccion e
				on d.RHTid = e.RHTid
			inner join DatosEmpleado b
				on c.DEid = b.DEid
		where c.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	</cfquery>
	<!---Rubros o montos a pagar--->
	<cfquery name="rsMontos" datasource="#session.DSN#">
		select  a.RHLPdescripcion
			   ,a.importe
			   ,b.Msimbolo
		from RHLiqIngresos a
			left outer join Monedas b
				on a.Mcodigo = b.Mcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
			and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">	
	</cfquery>
	<cfquery name="rsTotalMontos" datasource="#session.DSN#">
		select  sum(a.importe) as total
		from RHLiqIngresos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
			and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">	
	</cfquery>
	<!----Deducciones---->
	<cfquery name="rsDeducciones" datasource="#Session.DSN#">
		select 	coalesce(importe,0) as importe
				,RHLDdescripcion
				,b.Dmetodo
				,coalesce(a.RHLDporcentaje,0) as RHLDporcentaje
				,c.Msimbolo
		from RHLiqDeduccion a
			left outer join DeduccionesEmpleado b
				on a.Did = b.Did
				and a.DEid = b.DEid
			left outer join Monedas c
				on a.Mcodigo = c.Mcodigo
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
			and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">	
	</cfquery>		
	<cfset vn_totalPagar = 0>
	<cfset vn_totaldeducciones = 0>
	
	<cfoutput>
		<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">			
			<!----================ ENCABEZADO ================---->
			<tr>
				<td>
					<table width="90%" border="0" cellspacing="3" cellpadding="0" align="center">
						<tr><td colspan="2" align="center"><b style="font-size:15px;">#Ucase(Session.Enombre)#</b></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2"><b><cf_translate  key="LB_LIQUIDACIONFINAL">LIQUIDACION FINAL</cf_translate></b></td></tr>					  	
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="20%"><cf_translate key="LB_NombreDelTrabajador">Nombre del Trabajador</cf_translate>:&nbsp;</td>
							<td>#rsEncabezado.Nombre#</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_FechaDeIngreso">Fecha de Ingreso</cf_translate>:&nbsp;</td>
							<td>#LSDateFormat(rsEncabezado.FechaIngreso,'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_FechaDeSalida">Fecha de Salida</cf_translate>:&nbsp;</td>
							<td>#LSDateFormat(rsEncabezado.FechaSalida,'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_SalarioMensual">Salario Mensual</cf_translate>:&nbsp;</td>
							<td>#LSNumberFormat(rsEncabezado.salario,'999,999,999.99')#</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_MotivoDeSalida">Motivo de Salida</cf_translate>:&nbsp;</td>
							<td>#rsEncabezado.Motivo#</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			<!-----================ PRESTACIONES ================---->
			<tr>
				<td>				
					<table width="90%" align="center" border="0" cellspacing="3" cellpadding="0" align="center">
						<tr>
							<td colspan="2"><b><cf_translate key="LB_PAGODEPRESTACIONES">PAGO DE PRESTACIONES</cf_translate></b></td>
						</tr>
						<tr>
							<td>								
								<table width="90%" cellpadding="0" cellspacing="3" border="0">
									<cfloop query="rsMontos">
										<tr>
											<td width="60%">#rsMontos.RHLPdescripcion#</td>
											<td width="20%" align="right">#LSNumberFormat(rsMontos.importe, ',9.00')#</td>
										</tr>
									</cfloop>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td width="60%" align="right"><b><cf_translate key="LB_BrutoARecibir">Bruto a Recibir</cf_translate>&nbsp;</b></td>
										<td width="20%" align="right" style="border-top:1px solid black;"><b>#rsMontos.Msimbolo#&nbsp;#LSNumberFormat(rsTotalMontos.total, ',9.00')#</b></td>
									</tr>
								</table>
							</td>
						</tr>												
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<!----================ MENOS ================ ---->
			<cfif rsDeducciones.RecordCount NEQ 0>
				<tr>
					<td>
						<table width="85%" cellpadding="0" cellspacing="3" border="0" >
							<cfloop query="rsDeducciones">
								<tr>
									<td width="1%" nowrap>
										<cfif rsDeducciones.CurrentRow EQ 1>
											<b><cf_translate key="LB_Menos">Menos</cf_translate>:&nbsp;</b>
										<cfelse>	
											&nbsp;
										</cfif>
									</td>
									<td width="55%">										
										#rsDeducciones.RHLDdescripcion#
										<cfif rsDeducciones.Dmetodo EQ 0>
											(#RHLDporcentaje#%)
										</cfif>
									</td>
									<td align="right" width="30%">#LSNumberFormat(rsDeducciones.importe,'999,999,999.99')#</td>
								</tr>
								<cfset vn_totaldeducciones = vn_totaldeducciones + rsDeducciones.importe>
							</cfloop>
							<tr>
								<td colspan="2" align="right"><b><cf_translate key="LB_NetoARecibir">Deducciones</cf_translate></b>&nbsp;</td>
								<td style="border-top:1px solid black;" align="right"><b>#rsDeducciones.Msimbolo#&nbsp;#LSNumberFormat(vn_totaldeducciones,'999,999,999.99')#</b></td>
							</tr>
						</table>					
					</td>
				</tr>			
			<cfelse>
				<tr>
					<td>
						<table width="90%" cellpadding="0" cellspacing="3" border="0" align="center">
							<tr><td>----- <cf_translate key="LB_SinDeducciones">Sin deducciones</cf_translate> -----</td></tr>
						</table>
					</td>
				</tr>
			</cfif>
			<!----================ total ================ ---->
			<tr><td>&nbsp;</td></tr>
			<cfset vn_totalPagar = rsTotalMontos.total - vn_totaldeducciones>
			<tr>
				<td>
					<table width="90%" cellpadding="0" cellspacing="3" border="0" align="center">
						<tr>
							<td align="right"><b><cf_translate key="LB_TotalaPagar">Total a Pagar</cf_translate></b>&nbsp;</td>
							<td width="34%" align="right" style="border-top:1px solid black;"><b>#rsDeducciones.Msimbolo#&nbsp;#LSNumberFormat(vn_totalPagar,'999,999,999.99')#</b></td>
							<td width="10%">&nbsp;</td>
						</tr>
					</table>					
				</td>
			</tr>					
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<!----================ PIE DE PAGINA ================ ---->
			<tr>
				<td>
					<table width="90%" cellpadding="0" cellspacing="3" border="0" align="center">
						<tr>
							<td width="1%" nowrap><cf_translate key="LB_Preparado">Preparado</cf_translate>:&nbsp;</td>
							<td>____________________________________</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="1%" nowrap><cf_translate key="LB_Aprobado">Aprobado</cf_translate>:&nbsp;</td>
							<td>____________________________________</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="1%" nowrap><cf_translate key="LB_ReciboConforme">Recibo Conforme</cf_translate>:&nbsp;</td>
							<td>____________________________________</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
	</cfoutput>
</cfif>		


