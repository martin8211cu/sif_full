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
	<!---Datos variables de etiquetas--->
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select b.DEid,
			   {fn concat({fn concat({fn concat({fn concat(b.DEnombre, ' ')}, b.DEapellido1)}, ' ')}, b.DEapellido2 )} as NombreCompleto,
			   e.EVfantig,
			   b.DEobs1 as Dato3,
			   b.DEobs2 as Dato4,
			   b.DEobs3 as Dato5,		   
			   <!-----El puesto del empleado al ultimo corte de la linea del tiempo---->
			   (select d.RHPdescpuesto
				from LineaTiempo c, RHPuestos d					
				where c.RHPcodigo = d.RHPcodigo
					and c.Ecodigo = d.Ecodigo
					and c.DEid = b.DEid
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
					and LThasta = (select max(LThasta)
									from LineaTiempo x
									where c.DEid = x.DEid) 	
				)as Dato6,
			   b.DEidentificacion,
			   c.DLfvigencia,
			   d.RHPdescpuesto,
			   f.Ddescripcion,
			   g.RHTdesc,
			   c.Ecodigo,
			   c.Tcodigo,
			   i.Msimbolo,
			   coalesce(a.RHLPrenta, 0) as renta,
			   coalesce(a.RHLPfecha,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) as RHLPfecha,
			   <cf_dbfunction name="to_float" args="h.FactorDiasSalario"> as FactorDiasSalario
			   
		from RHLiquidacionPersonal a
	
			inner join DatosEmpleado b
				on a.DEid = b.DEid
			
			inner join DLaboralesEmpleado c
				on a.DLlinea = c.DLlinea
			
			inner join RHPuestos d
				on c.Ecodigo = d.Ecodigo
				and c.RHPcodigo = d.RHPcodigo
			
			inner join EVacacionesEmpleado e
				on a.DEid = e.DEid
			
			inner join Departamentos f
				on c.Ecodigo = f.Ecodigo
				and c.Dcodigo = f.Dcodigo
	
			inner join RHTipoAccion g
				on c.RHTid = g.RHTid
	
			inner join TiposNomina h
				on c.Ecodigo = h.Ecodigo
				and c.Tcodigo = h.Tcodigo
				
			inner join Monedas i
				on h.Ecodigo = i.Ecodigo
				and h.Mcodigo = i.Mcodigo	
	
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	</cfquery>
	<!----Salario promedio--->	
	<cfset vn_cantMeses = 6><!---- El maximo son 6 meses ---->
	<!---Obtener los meses para promediar----->
	<cfquery name="rsCantMeses" datasource="#session.DSN#">
		select 	<cfif Application.dsinfo[session.DSN].type is 'oracle'>
					datediff('mm', a.EVfantig, sysdate)
				<cfelse>
					datediff(mm, a.EVfantig, getdate())
				</cfif>
				as cantmeses
				,a.EVfantig as Ingreso
		from EVacacionesEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">		
	</cfquery>
	<cfif rsCantMeses.RecordCount NEQ 0 and rsCantMeses.cantmeses LT 6><!----(Si son mas de 6 utiliza 6 sino la cantidad que tenga de laborar)---->
		<cfset vn_cantMeses = rsCantMeses.cantmeses>
	</cfif>
	<cfquery name="rsSalPromedio" datasource="#session.DSN#">
		select coalesce(sum(b.SEsalariobruto)/#vn_cantMeses#,0) + coalesce(sum(b.SEincidencias)/#vn_cantMeses#,0) as SalPromedio	
		from CalendarioPagos a
			inner join HSalarioEmpleado b
				on a.CPid = b.RCNid
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		where exists(select 1
					from HIncidenciasCalculo c,CIncidentes	d
					where b.RCNid = c.RCNid
						  and b.DEid = c.DEid
						  and c.CIid = d.CIid
						  and d.CIafectasalprom = 1)<!---Incidencias que tengan check de "Afecta salario promedio"---->
		<!----Del ultimo calendario de pago 6 meses o menos(si el periodo de laborar es < 6) hacia atras en el tiempo----->
		<cfif Application.dsinfo[session.DSN].type is 'oracle'>
			and a.CPdesde between dateadd('mm',-#vn_cantMeses#,(select max(CPdesde) 
																from CalendarioPagos x
																	inner join HSalarioEmpleado y
																		on x.CPid = y.RCNid
																		and y.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)
											)	
							and (select max(CPdesde) 
								from CalendarioPagos x
									inner join HSalarioEmpleado y
										on x.CPid = y.RCNid
										and y.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)	
		<cfelse>
			and a.CPdesde between dateadd(mm,-#vn_cantMeses#,(select max(CPdesde) 
																from CalendarioPagos x
																	inner join HSalarioEmpleado y
																		on x.CPid = y.RCNid
																		and y.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">) 
											)
							and (select max(CPdesde) 
								from CalendarioPagos x
									inner join HSalarioEmpleado y
										on x.CPid = y.RCNid
										and y.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)
		</cfif>
	</cfquery>
	<!---Rubros o montos a pagar--->
	<cfquery name="rsMontos" datasource="#session.DSN#">
		select  a.RHLPdescripcion
			   ,a.importe
		from RHLiqIngresos a
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
	<cfquery name="rsDetalleObligaciones" datasource="#Session.DSN#">
		select 	coalesce(rtrim(b.RHLDdescripcion), rtrim(b.RHLDreferencia)) as Descripcion, 
				b.importe as Resultado, d.SNnumero, d.SNnombre, 
				coalesce(e.Cformato, 'EL SOCIO NO TIENE CUENTA ASOCIADA') as Cformato, f.TDcodigo
		from RHLiquidacionPersonal a
			inner join RHLiqDeduccion b
				on a.DEid = b.DEid
				and a.DLlinea = b.DLlinea
			left outer join DeduccionesEmpleado c
				on b.Did = c.Did
				and b.DEid = c.DEid
			inner join SNegocios d
				on a.Ecodigo = d.Ecodigo
				and b.SNcodigo = d.SNcodigo
			left outer join CContables e
				on d.SNcuentacxp = e.Ccuenta 
			left outer join TDeduccion f
				on c.TDid = f.TDid
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		order by d.SNnumero, d.SNnombre
	</cfquery>
	<!---Tiempo Laborado---->
	<cfset Annos = DateDiff('yyyy', rsEncabezado.EVfantig, rsEncabezado.RHLPfecha)>
	<cfset Meses = DateDiff('m',  rsEncabezado.EVfantig, rsEncabezado.RHLPfecha)>
	<cfset Dias = DateDiff('d',  rsEncabezado.EVfantig, rsEncabezado.RHLPfecha)>
	<cfset vn_mtoliquidar = 0>

	<style type="text/css">
		.tituloReporte1 {
			font-size:15px;
			text-align:center;
		}		
		.tituloReporte2 {
			font-size:14px;
			text-align:center;
		}
		.recuadro1 {
			border-left: 1px solid black;
			border-top: 1px solid black;
			border-right: 3px solid black;
			border-bottom: 3px solid black;
		}		
		.recuadro2 {
			border-left: 1px solid black;
			border-top: 1px solid black;
			border-right: 1px solid black;
			border-bottom: 1px solid black;
		}		
		.Corte_Pagina
		{
		PAGE-BREAK-BEFORE: always;
		}
		.liquidar{ background-color:#E6E6E6;}		
	</style>
	
	<cfoutput>
		<table width="100%" cellspacing="0" cellpadding="2">			
			<!---======================================================----> 
			<!----BOLETA DE LIQUIDACION LABORAL HENKEL---->
			<!---======================================================----> 
			<tr>
				<td>
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td align="center" class="tituloReporte1">#Session.Enombre#</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center"><b><cf_translate  key="LB_LiquidacionYFiniquitoLaboral">Liquidaci&oacute;n y Finiquito Laboral</cf_translate></b></td>
						</tr>					  	
						<tr><td>&nbsp;</td></tr>
					</table>					
					<table width="90%" align="center" border="0" cellspacing="2" cellpadding="7">
						<!----======== Encabezado No.1 ========---->
						<tr>
							<td>
								<p align="justify">
									<cf_translate  key="LB_YoIngreseALaborarElDIa">
										<b>Yo,&nbsp;#rsEncabezado.NombreCompleto#</b> ingrese a laborar el d&iacute;a #LSDateFormat(rsCantMeses.Ingreso,'dd/mm/yyyy')# con c&eacute;dula de vecindad
										n&uacute;mero de orden #rsEncabezado.Dato3# de registro #rsEncabezado.Dato4# extendida en <b>#rsEncabezado.Dato5#</b>
										desempeñando en esta empresa el cargo #rsEncabezado.Dato6#.
									</cf_translate>
								</p>
								<p align="justify">
									<cf_translate  key="LB_HagoConstarPorEsteMedioQueEnEstaFecha">
										Hago constar por este medio, que en esta fecha he recibido la cantidad de #rsEncabezado.Msimbolo# #LSNumberFormat(rsTotalMontos.total, ',9.00')# en concepto de 
										liquidaci&oacute;n final de mi relaci&oacute;n jur&iacute;dico laboral con la empresa: #rsEmpresa.Edescripcion#, 
										consistente en lo que se detalla a continuaci&oacute;n:			
									</cf_translate>			
								</p>
							</td>
						</tr>												
						<!----======== Totales ========---->
						<tr>
							<td>
								<table border="0" width="65%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="5%" align="right" nowrap><cf_translate  key="LB_SalarioPromedio">Salario Promedio</cf_translate>:&nbsp;</td>
										<td class="recuadro2" width="35%">&nbsp;#LSNumberFormat(rsSalPromedio.SalPromedio, ',9.00')#</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td width="5%" align="right" nowrap><cf_translate  key="LB_TiempoLaborado">Tiempo Laborado</cf_translate>:&nbsp;</td>
										<td class="recuadro2" width="60%">
											&nbsp;
											<cf_translate key="LB_Anos">A&ntilde;os</cf_translate>:#Annos#&nbsp;
											<cf_translate key="LB_Meses">Meses</cf_translate>:#Meses#&nbsp;
											<cf_translate key="LB_Dias">D&iacute;as</cf_translate>:#Dias#
										</td>
									</tr>
								</table>
							</td>							
						</tr>
						<!---======== Rubros ========--->
						<tr>
							<td>								
								<table width="90%" cellpadding="0" cellspacing="0" border="0" align="">
									<cfloop query="rsMontos">
										<tr>
											<td width="60%">#rsMontos.RHLPdescripcion#</td>
											<td width="5%">#rsEncabezado.Msimbolo#</td>
											<td width="20%" align="right">#LSNumberFormat(rsMontos.importe, ',9.00')#</td>
										</tr>
									</cfloop>
									<tr>
										<td width="60%" class="liquidar"><b><cf_translate key="LB_LiquidoARecibir">LIQUIDO A RECIBIR</cf_translate></b></td>
										<td width="5%" class="liquidar"><b>#rsEncabezado.Msimbolo#</b></td>
										<td width="20%" align="right" class="liquidar"><b>#LSNumberFormat(rsTotalMontos.total, ',9.00')#</b></td>
									</tr>
								</table>
							</td>
						</tr>
						<!----======== Etiqueta final ========---->
						<tr>
							<td>
								<p align="justify">
									<cf_translate key="LB_Anos">
										En virtud de lo anterior, otorgo el mas completo y eficaz finiquito laboral por cualquier reclamaci&oacute;n
										que pudiera iniciarse en contra de la referida empresa y por haberme cubierto las prestaciones que de conformidad
										con la ley laboral me corresponden haciendo constar que me fueron cancelados y gozados oportunamente todos los derechos 
										derivados del contrato.
									</cf_translate>
								</p>
							</td>
						</tr>
						<!----======== Dado en =========----->
						<tr>
							<td>
								#rsEncabezado.Dato5#, #LSDateFormat(now(),'dd/mm/yyyy')#
							</td>
						</tr>
						<!----======== Trabajador ========--->
						<tr>
							<td>
								<table width="" cellpadding="0" cellspacing="0" align="center">
									<tr>
										<td style="border-top:1px solid black;" width="50%" align="center">
											<cf_translate key="LB_Firma_del_Trabajador">Firma del Trabajador</cf_translate>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<!----======== Revisado ========---->
						<tr>
							<td>
								<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
									<tr>
										<td style="border-top:1px solid black;" width="20%" align="center">
											<cf_translate key="LB_Revisado">Revisado</cf_translate>
										</td>
										<td width="40%">&nbsp;</td>
										<td style="border-top:1px solid black;" width="20%" align="center">
											<cf_translate key="LB_Aprobado">Aprobado</cf_translate>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<!----======== Pie ========---->
						<tr>
							<td>
								<p align="justify"><cf_translate key="LB_DoyFeFeHaberConfrontadoLosDatosArribaExpuestosFirmandoAnteMi">
									Doy fe de haber confrontado los datos arriba expuestos, firmando ante mi:
								</cf_translate></p>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<table width="40%" cellpadding="0" cellspacing="0" align="center">
									<tr><td align="center" style="border-top:1px solid black;">&nbsp;</td></tr>
								</table>							
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr class="pageEnd"><td>&nbsp;</td></tr>
			<tr><td class="Corte_Pagina">&nbsp;</td></tr><!----<H1 ></H1>--->
			<!---======================================================---->
			<!--- BOLETA DE DETALLE DE OBLIGACIONES --->
			<!---======================================================---->
			<tr>
				<td>
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td class="tituloReporte1">#Session.Enombre#</td>
						</tr>
						<tr align="center">
							<td class="tituloReporte2"><cf_translate key="LB_LIQUIDACION_LABORAL">LIQUIDACION LABORAL</cf_translate></td>
						</tr>
						<tr align="center">
							<td class="tituloReporte2"><cf_translate key="LB_DETALLE_OBLIGACIONES">DETALLE OBLIGACIONES</cf_translate></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
	
					<table width="90%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
						<tr>
							<td width="25%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Nombre">Nombre</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.NombreCompleto#</strong></td>
							<td width="1%">&nbsp;</td>
							<td width="24%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.RHPdescpuesto#</strong></td>
						</tr>
						<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate>:</td>
							<td><strong>#rsEncabezado.Deidentificacion#</strong></td>
							<td>&nbsp;</td>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Departamento">Departamento</cf_translate>:</td>
							<td><strong>#rsEncabezado.Ddescripcion#</strong></td>
						</tr>
						<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_de_Ingreso">Fecha de Ingreso</cf_translate>: </td>
							<td><strong>#LSDateFormat(rsEncabezado.EVfantig, 'dd/mm/yyyy')#</strong></td>
							<td>&nbsp;</td>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_de_Salida">Fecha de Salida</cf_translate>: </td>
							<td><strong>#LSDateFormat(rsEncabezado.DLfvigencia, 'dd/mm/yyyy')#</strong></td>
						</tr>
					</table>
					<br>
					
					<cfset TotalObligaciones = 0>
					<cfset ObligacionesSocio = 0>
					<cfset cortesocio = "">
					<cfset nombresocio = "">
					
					<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
						<cfloop query="rsDetalleObligaciones">
							<cfif cortesocio NEQ rsDetalleObligaciones.SNnumero>
								<!--- Pintar Sumatoria de Obligaciones --->
								<cfif rsDetalleObligaciones.CurrentRow NEQ 1>
									<tr>
										<td colspan="2"><strong>Total #nombresocio#:</strong></td>
										<td align="right">#LSNumberFormat(ObligacionesSocio, ',9.00')#</td>
										<td>&nbsp;</td>
									</tr>
								</cfif>
								<tr>
									<td style="border-bottom: 1px solid black; " colspan="4">
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td style="padding-right: 30px;"><strong><cf_translate key="LB_Socio_de_Negocio">Socio de Negocio</cf_translate>: #SNnumero# #SNnombre#</strong></td>
												<td><strong><cf_translate key="LB_Cuenta_Contable">Cuenta Contable</cf_translate>: #Cformato#</strong></td>
											</tr>
										</table>
									</td>
								</tr>
								<cfset cortesocio = rsDetalleObligaciones.SNnumero>
								<cfset nombresocio = rsDetalleObligaciones.SNnombre>
								<cfset ObligacionesSocio = 0>
							</cfif>							
							<tr>
								<td width="10%" align="center"><strong>#TDcodigo#</strong></td>
								<td>#Descripcion#</td>
								<td align="right">#LSNumberFormat(Resultado, ',9.00')#</td>
								<td width="50%" align="right">&nbsp;</td>
							</tr>							
							<cfset TotalObligaciones = TotalObligaciones + Resultado>
							<cfset ObligacionesSocio = ObligacionesSocio + Resultado>
						</cfloop>						
						<tr>
							<td colspan="2"><strong><cf_translate key="LB_total">Total</cf_translate> #nombresocio#:</strong></td>
							<td align="right">#LSNumberFormat(ObligacionesSocio, ',9.00')#</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" style="border-top: 1px solid black; "><strong><cf_translate key="LB_Total_Obligaciones">Total Obligaciones</cf_translate>:</strong></td>
							<td align="right" style="border-top: 1px solid black; ">#LSNumberFormat(TotalObligaciones, ',9.00')#</td>
							<td style="border-top: 1px solid black; ">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>		


