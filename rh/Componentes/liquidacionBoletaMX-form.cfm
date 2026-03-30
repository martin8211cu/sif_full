<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RegistroPatronal" Default="Registro Patronal" 	returnvariable="LB_RegistroPatronal"/>

<cfif isdefined("Url.DLlinea") and Len(Trim(Url.DLlinea)) and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>

<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>


<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
	<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
	<cfinvokeargument name="DEid" value="#form.DEid#">
</cfinvoke>

<cfquery datasource="#session.dsn#" name="rsEmpresa">
	select b.direccion1, b.direccion2, b.ciudad, a.Eidentificacion , b.codPostal, a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
      from Empresa a
	    inner join Direcciones b
		  on a.id_direccion = b.id_direccion
	 where a.Ecodigo = #session.Ecodigosdc#
</cfquery>


<cfquery name="rsFactor" datasource="#Session.DSN#">
	select FactorDiasSalario
	from DLaboralesEmpleado dle
		inner join TiposNomina tn
			on tn.Ecodigo = dle.Ecodigo and tn.Tcodigo = dle.Tcodigo
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
	and DEid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
<cfif rsFactor.recordcount eq 0 or len(trim(rsFactor.FactorDiasSalario)) eq 0>
	<cfquery name="rs" datasource="#Arguments.Conexion#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo#  
		  and Pcodigo = 80
	</cfquery>
	<cfset factor = rs.Pvalor>
<cfelse>
	<cfset factor = rsFactor.FactorDiasSalario>
</cfif>

<cfset salarioDiario = rsLF.RHLFLsalarioMensual / factor>
<cfset Factor = rsLF.RHLFLisptSalario / rsLF.RHLFLsalarioMensual>
<cfset BaseImp = rsLF.RHLFLtotalL  - rsLF.RHLFLisptL>
<cfset ISPTL = BaseImp * Factor>
<cfset ISPT = rsLF.RHLFLisptF + ISPTL>
<cfset TotalD = ISPT + rsLF.RHLFLinfonavit>

<cfset fecha = now()>
<cfset fecha1 = now()>

<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fecha">
	<cfinvokeargument name="Fecha" value="#fecha#">
</cfinvoke>
<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
	<cfinvokeargument name="Monto" value="#rsLF.RHLFLresultado#">
</cfinvoke>

<cfset LvarMes = DatePart("m",fecha1)>

<cfif LvarMes EQ "01">
	<cfset LvarMes = "Enero">
<cfelseif LvarMes EQ "02">
	<cfset LvarMes = "Febrero">
<cfelseif LvarMes EQ "03">
	<cfset LvarMes = "Marzo">
<cfelseif LvarMes EQ "04">
	<cfset LvarMes = "Abril">
<cfelseif LvarMes EQ "05">
	<cfset LvarMes = "Mayo">
<cfelseif LvarMes EQ "06">
	<cfset LvarMes = "Junio">
<cfelseif LvarMes EQ "07">
	<cfset LvarMes = "Julio">
<cfelseif LvarMes EQ "08">
	<cfset LvarMes = "Agosto">
<cfelseif LvarMes EQ "09">
	<cfset LvarMes = "Septiembre">
<cfelseif LvarMes EQ "10">
	<cfset LvarMes = "Octubre">
<cfelseif LvarMes EQ "11">
	<cfset LvarMes = "Noviembre">
<cfelseif LvarMes EQ "12">
	<cfset LvarMes = "Diciembre">
</cfif>


<cfif isdefined("Form.DLlinea") and Len(Trim(Form.DLlinea))>
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select b.DEid,
			   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
			   b.DEidentificacion,
			   e.EVfantig,
			   c.DLfvigencia,
			   d.RHPdescpuesto,
			   f.Ddescripcion,
			   g.RHTdesc,
			   c.Ecodigo,
			   c.Tcodigo,
			   i.Msimbolo,
			   i.Mnombre,
			   coalesce(a.RHLPrenta, 0) as renta,
			   coalesce(a.RHLPfecha,getdate()) as RHLPfecha,
			   <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,
			   <cf_dbfunction name="datediff" args="e.EVfantig, c.DLfvigencia"> as diasAnt
			   
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
	</cfquery>
	
	<cfquery name="rsDetallePrestaciones" datasource="#Session.DSN#">
		select a.DEid, a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe, 
			   b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
		from RHLiqIngresos a
			inner join DDConceptosEmpleado b
				on a.DLlinea = b.DLlinea and a.CIid = b.CIid
			inner join CIncidentes c
				on b.CIid = c.CIid
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and coalesce(c.CISumarizarLiq,0) = 0
		and a.RHLPautomatico = 1
	</cfquery>
	

	<cfquery name="rsDetalleObligaciones" datasource="#Session.DSN#">
		select b.DEid,coalesce(rtrim(b.RHLDdescripcion), rtrim(b.RHLDreferencia)) as Descripcion, b.importe as Resultado, d.SNnumero, d.SNnombre, coalesce(e.Cformato, 'EL SOCIO NO TIENE CUENTA ASOCIADA') as Cformato, f.TDcodigo
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
	
	<cfquery name="rsDetalleOtrasPrestacionesSP" datasource="#Session.DSN#">
		select a.RHLPdescripcion as Descripcion, 
			case when b.DDCcant is null then coalesce(a.importe,0) else coalesce(b.DDCimporte,0) end as importe,
			coalesce(b.DDCres,0) as Resultado, 
			coalesce(b.DDCcant,0) as Cantidad
		from RHLiqIngresos a
		left outer join DDConceptosEmpleado  b
			on b.CIid = a.CIid
			and b.DLlinea = a.DLlinea
		left outer join CIncidentes c
			on c.CIid = b.CIid
			and coalesce(c.CISumarizarLiq,0) = 1
			and coalesce(c.CIMostrarLiq,0)   = 1
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		and a.RHLPautomatico = 0
	</cfquery>
	
	<cfquery name="rsDetalleAportesRealizados" datasource="#Session.DSN#">
		select a.RHLCdescripcion as Descripcion, a.importe as Resultado
		from RHLiqCargas a
		inner join DCargas   b
			on a.DClinea = b.DClinea
			and coalesce(DCSumarizarLiq,0) = 0
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
	
	<cfquery name="rsSumaAportesRealizados" dbtype="query">
		select sum(Resultado) Resultado
		from rsDetalleAportesRealizados
	</cfquery>
	
	
	<style type="text/css">
		.tituloReporte1 {
			font-size:18px;
		}
		
		.tituloReporte2 {
			font-size:16px;
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
		
		H1.Corte_Pagina
		{
			PAGE-BREAK-AFTER: always
		}
		
		.Datos{
			font-weight:bold;
			width:30%;
		}
	</style>
	
<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="2">
		<tr>
			<td>
				<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                    <!---????Corporacion e imagen????--->
						<td></td>
                        <!---<td><strong class="tituloReporte1">#session.CEnombre#</strong></td>--->
                        <td rowspan="6" align="right" valign="middle" style="padding-right: 30px;"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
					</tr>
                    <!---????Empresa y Direcciones????--->
                    <tr><td colspan="2"><strong class="tituloReporte2">#session.Enombre#</strong></td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion1#</td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion2#</td></tr>
                    <!---????Ciudad, codigo Postal, Telefono y Fax????--->
                    <tr style="font-size:9px">
                    	<td colspan="2" class="td12">
							<cfif len(trim(rsEmpresa.ciudad))>#rsEmpresa.ciudad#</cfif>
                            <cfif len(trim(rsEmpresa.codPostal))>,C.P. #rsEmpresa.codPostal#</cfif>
                            <cfif len(trim(rsEmpresa.Etelefono1))>,Tel. #rsEmpresa.Etelefono1#</cfif>
                            <cfif len(trim(rsEmpresa.Efax))>,Fax. #rsEmpresa.Efax#</cfif>
                    	</td>
                    </tr>
                     <!---????RFC y Registro Patronal????--->
                    <tr style="font-size:9px">
                    	<td colspan="2">
                        	<cfif len(trim(rsEmpresa.Eidentificacion))>R.F.C. #rsEmpresa.Eidentificacion#&nbsp;</cfif>
                            <cfif len(trim(rsEmpresa.Enumlicencia))>#LB_RegistroPatronal#: #rsEmpresa.Enumlicencia#</cfif>
                        </td>
                    </tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="2"><strong>PRESENTE</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td class="tituloReporte2" colspan="2"><strong>BUENO POR: &nbsp;#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(rsLF.RHLFLresultado)#</strong></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="justify" style="padding-right: 30px;" colspan="2">Recib&iacute; de <strong>#Session.Enombre#</strong> la cantidad de <strong>&nbsp;#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(rsLF.RHLFLresultado)# (#MontoLetras# #rsEncabezado.Mnombre#)</strong>, por concepto de SUELDO, FINIQUITO Y LIQUIDACI&Oacute;N, manifestando que he venido laborando en forma ordinaria, precisamente hasta el d&iacute;a de hoy en que doy por terminada mi relaci&oacute;n de trabajo, y con motivo de la <strong>RENUNCIA</strong> voluntaria irrevocable al puesto y trabajo que ven&iacute;a desempe&ntilde;ando, mencionando que a la fecha no se me adeuda cantidad alguna por los conceptos de salarios devengados, vacaciones, prima vacacional, aguinaldo, tiempo extraordinario, reparto de utilidades, s&eacute;ptimos d&iacute;as, d&iacute;as de descanso obligatorio, ni por ninguna otra prestaci&oacute;n se&ntilde;alada en la Ley Federal del Trabajo vigente o a m&iacute; contrato individual de trabajo, me pudiesen corresponder, otorgandoen este acto el recibo finiquito mas amplio de obligaciones que en derecho corresponde, si&eacute;ndome cubiertas las prestaciones que a continuaci&oacute;n se precisan:</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<tr><td>&nbsp;</td></tr>
					</tr>
					<tr><td colspan="2"><table width="70%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td class="Datos">Nombre:</td>
							<td>#rsEncabezado.NombreCompleto#</td>
						</tr>
						<tr>
							<td class="Datos">Fecha de baja:</td>
							<td>#LSDateFormat(rsEncabezado.DLfvigencia, 'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td class="Datos">Fecha de ingreso:</td>
							<td>#LSDateFormat(rsEncabezado.EVfantig, 'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td class="Datos">D&iacute;as Transcurridos de Antig&uuml;edad:</td>
							<td>#rsEncabezado.diasAnt#</td>
						</tr>
						<tr>
							<td class="Datos">Salario Diario:</td>
							<td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(salarioDiario)#</td>
						</tr>
						
						<cfquery name="rsTotalPer" dbtype="query">
							select sum(Resultado) as total
							from rsDetallePrestaciones
						</cfquery>
						
						<cfquery name="rsTotalOtros" dbtype="query">
							select sum(Importe) as total
							from rsDetalleOtrasPrestacionesSP
						</cfquery>
						
						<cfif rsTotalOtros.recordcount EQ 0>
							<cfset vOtrasPerc = 0>
						<cfelse>
							<cfset vOtrasPerc = #rsTotalOtros.total#>
						</cfif>
						
						
						<cfquery name="rsDetAportesRealizados" datasource="#Session.DSN#">
							select coalesce(sum(a.importe),0) as monto
							from RHLiqCargas a
							inner join DCargas   b
								on a.DClinea = b.DClinea
								and coalesce(DCSumarizarLiq,0) = 0
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						</cfquery>
						
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							
							
							
							<td class="Datos">PERCEPCIONES:</td>
							<td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(rsTotalPer.total + vOtrasPerc)#</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="2">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<cfloop query="rsDetallePrestaciones">
									<tr>
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDetallePrestaciones.Descripcion#</td>
										<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
										<td align="right" width="10%" nowrap>#fnFormatMoney(rsDetallePrestaciones.Resultado)#</td>
									</tr>
								</cfloop>
									<tr>
										<td>&nbsp;</td>
									</tr>
									
									
								<cfloop query="rsDetalleOtrasPrestacionesSP">
									<tr>
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDetalleOtrasPrestacionesSP.Descripcion#</td>
										<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
										<td align="right" width="10%" nowrap>#fnFormatMoney(rsDetalleOtrasPrestacionesSP.importe)#</td>
									</tr>
									<!--- <cfset TotalPrestaciones = TotalPrestaciones + importe> --->
								</cfloop>
							</table>
						</td></tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td class="Datos">DEDUCCIONES:</td>
							<td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(TotalD)#</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="2">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ISPT</td>
										<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
										<td align="right" width="10%" nowrap>#fnFormatMoney(ISPT)#</td>
									</tr>
									<cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit neq 0>
										<tr>
											<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cr&eacute;dito de Infonavit</td>
											<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
											<td align="right" width="10%" nowrap>#fnFormatMoney(rsLF.RHLFLinfonavit)#</td>
										</tr>
									</cfif>
							</table>
						</td></tr>
						<cfif rsDetalleAportesRealizados.recordCount> 
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td class="Datos">CARGAS SOCIALES:</td>
								<td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(rsSumaAportesRealizados.Resultado)#</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr><td colspan="2">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<cfloop query="rsDetalleAportesRealizados">
											<tr>
												<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDetalleAportesRealizados.Descripcion#</td>
												<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
												<td align="right" width="10%" nowrap>(#fnFormatMoney(rsDetalleAportesRealizados.Resultado)#)</td>
											</tr>
										</cfloop>
								</table>
							</td></tr>
						</cfif>
					</table></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">

						<table width="70%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td><strong>TOTAL A RECIBIR</strong></td>
									<td align="center" width="5%"><strong>#rsEncabezado.Msimbolo#</strong></td>
									<cfset montoT =  rsLF.RHLFLresultado > <!---rsTotalPer.total + rsTotalOtros.total--->
									 <cfif rsDetAportesRealizados.recordcount gt 0>
									 	<cfset montoT = rsLF.RHLFLresultado > <!---montoT - rsDetAportesRealizados.monto--->
									</cfif>
									<td align="right" width="10%" nowrap><strong>#fnFormatMoney(montoT)#</strong></td>
								</tr>
						</table>
					</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr><tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr><tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr><tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2" align="center">___________________________________________________</td></tr>
					<tr><td colspan="2" align="center"><strong>#rsEncabezado.NombreCompleto#</strong></td></tr>
					<tr><td colspan="2" align="center"><strong>#UCASE(LvarMes)# DE #DatePart("yyyy",fecha1)#</strong></td></tr>
					
				</table>
			</td>
		</tr>
		
		<tr class="pageEnd"><td>&nbsp;</td></tr>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>

		<!--- BOLETA DE DETALLE DE OBLIGACIONES --->
		<tr>
			<td>
				<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
                    <!---????Corporacion e imagen????--->
                    	<td></td>
						<!---<td><strong class="tituloReporte1">#session.CEnombre#</strong></td>--->
                        <td rowspan="6" align="right" valign="middle" style="padding-right: 30px;"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
					</tr>
                    <!---????Empresa y Direcciones????--->
                    <tr><td colspan="2"><strong class="tituloReporte2">#session.Enombre#</strong></td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion1#</td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion2#</td></tr>
                    <!---????Ciudad, codigo Postal, Telefono y Fax????--->
                    <tr style="font-size:9px">
                    	<td colspan="2" class="td12">
							<cfif len(trim(rsEmpresa.ciudad))>#rsEmpresa.ciudad#</cfif>
                            <cfif len(trim(rsEmpresa.codPostal))>,C.P. #rsEmpresa.codPostal#</cfif>
                            <cfif len(trim(rsEmpresa.Etelefono1))>,Tel. #rsEmpresa.Etelefono1#</cfif>
                            <cfif len(trim(rsEmpresa.Efax))>,Fax. #rsEmpresa.Efax#</cfif>
                    	</td>
                    </tr>
                     <!---????RFC y Registro Patronal????--->
                    <tr style="font-size:9px">
                    	<td colspan="2">
                        	<cfif len(trim(rsEmpresa.Eidentificacion))>R.F.C. #rsEmpresa.Eidentificacion#&nbsp;</cfif>
                            <cfif len(trim(rsEmpresa.Enumlicencia))>#LB_RegistroPatronal#: #rsEmpresa.Enumlicencia#</cfif>
                        </td>
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
<cffunction name="fnFormatMoney" access="private" returntype="string">
	<cfargument name="Monto" type="numeric">
	<cfargument name="Decimales" type="numeric" default="2">
	<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#"),'none')>
</cffunction>
</cfif>
