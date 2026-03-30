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
	select coalesce(FactorDiasIMSS,FactorDiasSalario) as FactorDiasSalario
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

<cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
    select coalesce(sum(importe),0) as totDeduc
    from RHLiqDeduccion
    where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
</cfquery>

	<cfset salarioDiario = rsLF.RHLFLsalarioMensual / factor>
    <cfset BaseImp = rsLF.RHLFLtotalL  - rsLF.RHLFLisptL>
    <cfif rsLF.RHLFLsalarioMensual neq 0>
        <cfset Factor = rsLF.RHLFLisptSalario / rsLF.RHLFLsalarioMensual>
    <cfelse>
        <cfset Factor = 0>
    </cfif>
    <cfset ISPTL = BaseImp * Factor>
    <cfset ISPT = rsLF.RHLFLisptF + ISPTL>
    <cfset TotalD = ISPT + rsLF.RHLFLinfonavit+rsSumRHLiqDeduccion.totDeduc>

<cfset fecha = now()>
<cfset fecha1 = now()>

<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fecha">
	<cfinvokeargument name="Fecha" value="#fecha#">
</cfinvoke>
<!---<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
	<cfinvokeargument name="Monto" value="#rsLF.RHLFLresultado#">
</cfinvoke>--->

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

<!---ERBG Cambio del path fijo INICIA--->
<cfquery name="getDatosCert" datasource="#session.dsn#">
	select archivoKey from RH_CFDI_Certificados
</cfquery>
<cfset vsPath_A = left(#getDatosCert.archivoKey#,2)>
<!---ERBG Cambio del path fijo FIN--->

<cfif isdefined("Form.DLlinea") and Len(Trim(Form.DLlinea))>
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select b.DEid,
			   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
			   b.DEidentificacion,
			   a.RHLPfingreso as EVfantig,
			   <cf_dbfunction name="dateadd" args="-1,c.DLfvigencia"> as DLfvigencia,
			   d.RHPdescpuesto,
			   f.Ddescripcion,
			   g.RHTdesc,
			   c.Ecodigo,
			   c.Tcodigo,
			   i.Msimbolo,
			   i.Mnombre,
			   coalesce(a.RHLPrenta, 0) as renta,
			   coalesce(a.RHLPfecha,getdate()) as RHLPfecha,
			   h.FactorDiasSalario as FactorDiasSalario,
			   <cf_dbfunction name="datediff" args="a.RHLPfingreso, c.DLfvigencia"> as diasAnt

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
		@page :right {
		 margin-left: .5cm;
		 margin-right: .5cm;
		}

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

		<!---H1.Corte_Pagina--->
		.Corte_Pagina
		{
			<!---page-break-after: always;--->
		}

		.Datos{
			font-weight:bold;
			width:30%;
		}
	</style>

    <cfquery name="rsDetAportes" datasource="#Session.DSN#">
        select coalesce(sum(a.importe),0) as monto
        from RHLiqCargas a
        inner join DCargas   b
            on a.DClinea = b.DClinea
            and coalesce(DCSumarizarLiq,0) = 0
        where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    </cfquery>


	<cfset montoT =  rsLF.RHLFLresultado > <!---rsTotalPer.total + rsTotalOtros.total--->
     <cfif rsDetAportes.recordcount gt 0>
        <cfset montoT = rsLF.RHLFLresultado > <!---montoT - rsDetAportesRealizados.monto--->
    </cfif>
    <cfif rsSumRHLiqDeduccion.totDeduc neq 0>
        <cfset montoT = montoT - rsSumRHLiqDeduccion.totDeduc>
    </cfif>
    <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
        <cfinvokeargument name="Monto" value="#montoT#">
    </cfinvoke>

<!---<cfoutput>--->
	<table width="100%" cellspacing="0" cellpadding="2" style="margin-left: none !important;" class="tablaEncabezado">
		<tr>
			<td>
            <cfoutput>
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
						<td class="tituloReporte2" colspan="2"><strong>BUENO POR: &nbsp;#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(montoT)#</strong></td>		<!---rsLF.RHLFLresultado--->
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<!-- <tr> -->
<!-- 						<td align="justify" style="padding-right: 30px;" colspan="2">Recib&iacute; de <strong>#Session.Enombre#</strong> la cantidad de <strong>&nbsp;#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(montoT)# (#MontoLetras# #rsEncabezado.Mnombre#)</strong>, por concepto de SUELDO, FINIQUITO, LIQUIDACI&Oacute;N Y FONDO DE AHORRO, manifestando que he venido laborando en forma ordinaria, precisamente hasta el d&iacute;a de hoy en que doy por terminada mi relaci&oacute;n de trabajo, y con motivo de la <strong>RENUNCIA</strong> voluntaria irrevocable al puesto y trabajo que ven&iacute;a desempe&ntilde;ando, mencionando que a la fecha no se me adeuda cantidad alguna por los conceptos de salarios devengados, vacaciones, prima vacacional, aguinaldo, tiempo extraordinario, reparto de utilidades, s&eacute;ptimos d&iacute;as, d&iacute;as de descanso obligatorio, ni por ninguna otra prestaci&oacute;n se&ntilde;alada en la Ley Federal del Trabajo vigente o a m&iacute; contrato individual de trabajo, me pudiesen corresponder, otorgando en este acto el recibo finiquito mas amplio de obligaciones que en derecho corresponde, si&eacute;ndome cubiertas las prestaciones que a continuaci&oacute;n se precisan:</td> -->
<!-- 					</tr> -->
					<tr>
						<td align="justify" colspan="2">Recib&iacute; de
							<strong>#Session.Enombre#</strong> la cantidad de <strong>&nbsp;#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(montoT)#
								(#MontoLetras# #rsEncabezado.Mnombre#)</strong>, por concepto de Aguinaldo, Vacaciones Ptes a disfrutar,
								Vacaciones, prima vacacional, como finiquito originado por mi <strong>RENUNCIA</strong> voluntaria que
								present&eacute; el d&iacute;a <strong>#LSDateFormat(rsEncabezado.DLfvigencia, 'dd/mm/yyyy')#.</strong>
								Con la cantidad que recibo quedan totalmente saldadas todas y cada una de las prestaciones a que tuve derecho
								derivadas de mi contrato de trabajo y de la Ley de la Materia, manifestando igualmente, que durante el tiempo
								que preste mis servicios no sufr&iacute; enfermedad profesional ni riesgo de trabajo alguno. En consecuencia nada
								tengo que reclamar a <strong>#Session.Enombre#</strong>, ni a quienes sus derechos represente, por lo que la presente
								ampara el m&aacute;s amplio finiquito que en derecho proceda. Integrado por los siguientes conceptos: </td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<!---<tr><td>&nbsp;</td></tr>--->
					</tr>
					<tr><td colspan="2">
                    <table width="80%" border="0" cellpadding="0" cellspacing="0">
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
							<!--- <td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(rsTotalPer.total + vOtrasPerc)#</td> --->
							<td>
					        	#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney((rsTotalPer.total eq '' ? 0 : rsTotalPer.total) + (vOtrasPerc eq '' ? 0 :vOtrasPerc))#
					        </td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="3">
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
                        	<cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF neq 0>
                        		<cfset TotalD = #rsLF.RHLFLisptF#>
                            <cfelse>
                            	<cfset TotalD = #ISPT#>
                            </cfif>
                            <cfif rsLF.RHLFLISPTRealL gt 0>
                            	<cfset TotalD = TotalD + #rsLF.RHLFLISPTRealL#/100>
                            </cfif>
                            <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit neq 0>
                            	<cfset TotalD = TotalD + #rsLF.RHLFLinfonavit#>
                            </cfif>
                            <cfif rsSumRHLiqDeduccion.totDeduc neq 0>
                                <cfquery name="rsDetRHLiqDeduccion" datasource="#session.DSN#">
                                    select importe
                                    from RHLiqDeduccion
                                    where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
                                </cfquery>
                                <cfloop query="rsDetRHLiqDeduccion">
									<cfset TotalD = TotalD + #rsDetRHLiqDeduccion.importe#>
                                </cfloop>
                            </cfif>
							<td class="Datos">DEDUCCIONES:</td>
							<td>#rsEncabezado.Msimbolo#&nbsp;#fnFormatMoney(TotalD)#</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="3">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF neq 0>
                                        <tr>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ISPT Finiquito</td>
                                            <td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
                                            <!---<td align="right" width="10%" nowrap>#fnFormatMoney(ISPTF)#</td>--->
                                            <td align="right" width="10%" nowrap>#fnFormatMoney(rsLF.RHLFLisptF)#</td>
                                        </tr>
                                    <cfelse>
                                        <tr>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ISPT</td>
                                            <td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
                                            <td align="right" width="10%" nowrap>#fnFormatMoney(ISPT)#</td>
                                        </tr>
                                    </cfif>
                                    <cfif rsLF.RHLFLISPTRealL gt 0>
                                    	<tr>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ISPT Real Liquidación</td>
                                            <td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
                                            <td  align="right" width="10%" nowrap>#fnFormatMoney(rsLF.RHLFLISPTRealL/100)#</td>
                                    	</tr>
                                    </cfif>
									<cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit neq 0>
										<tr>
											<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cr&eacute;dito de Infonavit</td>
											<td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
											<td align="right" width="10%" nowrap>#fnFormatMoney(rsLF.RHLFLinfonavit)#</td>
										</tr>
									</cfif>
                                    <cfif rsSumRHLiqDeduccion.totDeduc neq 0>
                                        <cfquery name="rsDetRHLiqDeduccion" datasource="#session.DSN#">
                                            select RHLDdescripcion, importe
                                            from RHLiqDeduccion
                                            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
                                        </cfquery>
                                        <cfloop query="rsDetRHLiqDeduccion">
                                            <tr>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDetRHLiqDeduccion.RHLDdescripcion#</td>
                                                <td align="center" width="5%">&nbsp;#rsEncabezado.Msimbolo#&nbsp;</td>
                                                <td align="right" width="10%" nowrap>#fnFormatMoney(rsDetRHLiqDeduccion.importe)#</td>
                                            </tr>
                                        </cfloop>
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
							<tr><td colspan="3">
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
					</table>
                    </td>
                   	</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="3">

						<table width="80%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td><strong>TOTAL A RECIBIR</strong></td>
									<td align="center" width="5%"><strong>#rsEncabezado.Msimbolo#</strong></td>
									<cfset montoT =  rsLF.RHLFLresultado > <!---rsTotalPer.total + rsTotalOtros.total--->
									 <cfif rsDetAportesRealizados.recordcount gt 0>
									 	<cfset montoT = rsLF.RHLFLresultado > <!---montoT - rsDetAportesRealizados.monto--->
									</cfif>
                                    <cfif rsSumRHLiqDeduccion.totDeduc neq 0>
                                    	<cfset montoT = montoT - rsSumRHLiqDeduccion.totDeduc>
                                    </cfif>
									<td align="right" width="10%" nowrap><strong>#fnFormatMoney(montoT)#</strong></td>
								</tr>
						</table>

					</td></tr>

					<tr><td colspan="2">&nbsp;</td></tr><tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2" align="center">___________________________________________________</td></tr>
					<tr><td colspan="2" align="center"><strong>#rsEncabezado.NombreCompleto#</strong></td></tr>
					<tr><td colspan="2" align="center"><strong>#UCASE(LvarMes)# DE #DatePart("yyyy",fecha1)#</strong></td></tr>
				</table>
            </cfoutput>
			</td>
		</tr>
	</table>

	<!--- OPARRALES 2019-02-18
		- Modificacion para generar gerarquia de carpetas y dar mejor estructura a los archivos de Liquidacion - Finiquito
	 --->
	<cfset vsPath_A = "#Left(ExpandPath(GetContextRoot()),2)#">
	<!--- Ejemplo Liquidacion-Finiquito2019 --->
	<cfset rutaDirTmp = '#vsPath_A#\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Liquidacion-Finiquito#Year(Now())#'>
	<cfif !directoryExists(rutaDirTmp)>
		<cfset directoryCreate(rutaDirTmp)>
	</cfif>

	<!--- Ejemplo Liquidacion-Finiquito2019/Liquidacion-Finiquito-DEMO --->
	<cfset rutaDirTmp = '#vsPath_A#\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Liquidacion-Finiquito#Year(Now())#'>
	<cfif !directoryExists(rutaDirTmp)>
		<cfset directoryCreate(rutaDirTmp)>
	</cfif>


	<cfquery name="rsBaja" datasource="#session.dsn#">
		select
			concat(LTRIM(RTRIM(de.DEidentificacion)),'_',LTRIM(RTRIM(de.DEnombre)),'_',LTRIM(RTRIM(de.DEapellido1)),'_',LTRIM(RTRIM(de.DEapellido1))) as Empleado,
            dateadd(dd, -1, c.DLfvigencia) as FechaBaja,
            g.RHTdesc MotivoBaja
		from RHLiquidacionPersonal a
		inner join DatosEmpleado de
			on a.DEid = de.DEid
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
		inner join RHTipoAccion g
			on c.RHTid = g.RHTid
		where
			a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
	</cfquery>

	<!--- Ejemplo Liquidacion-Finiquito2019/Liquidacion-Finiquito-DEMO/0007-Bond_JamesBond --->
	<cfset rutaDirTmp = '#vsPath_A#\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Liquidacion-Finiquito#Year(Now())#\#rsBaja.Empleado#'>
	<cfif !directoryExists(rutaDirTmp)>
		<cfset directoryCreate(rutaDirTmp)>
	</cfif>

	<!--- PARA EL CASO DE LIQUIDACIONES Y/O FINIQUITOS LOS ARCHIVOS SE GUARDAN EN LA CARPETA CON EL NOMBRE DEL EMPLEADO --->

	<cfoutput>
		<!---  A partir de aqui  mando  llamar al  generador de cfdi  --->
		<cfquery name="rsReciboLiqCFDI" datasource="#session.dsn#" >
		   select * from RH_CFDI_RecibosNomina
		     where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		     and DLlinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
		     and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		     and stsTimbre = 1
		</cfquery>

		<cfif rsReciboLiqCFDI.RecordCount EQ 0 and rsEncabezado.DLfvigencia GT '2013-12-31'>
			<cfinvoke component="rh.Componentes.GeneraCFDIs" method="obtenerCFDI">
		          <cfinvokeargument name="DEid" value="#form.DEid#">
		          <cfinvokeargument name="DLlinea" value="#form.DLlinea#">
			</cfinvoke>
		</cfif>
		<!--- Hasta aqui--->
	</cfoutput>

	<cfoutput>
        <div class="Corte_Pagina"></div>
	</cfoutput>
<cfquery name="rsReciboLiqCFDI" datasource="#session.dsn#" >
   select * from RH_CFDI_RecibosNomina
     where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
     and DLlinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
     and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
     and stsTimbre = 1
</cfquery>
	<table width="100%" cellspacing="0" cellpadding="2">
    	<tr><td><H1 class="Corte_Pagina"></H1></td></tr>
		<cfif rsReciboLiqCFDI.stsTimbre EQ 1>
		<tr>
			<td>
            <cfoutput>
                <table width="90%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
					<cfset imgQR = #vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Liquidacion-Finiquito#Year(Now())#\#rsBaja.Empleado#\Liq_#DEid#_#DLlinea#.jpg">
                    <tr>
                        <td colspan="3" width="100" height="100" style="margin-right: 3px solid;">
                            <table>
                                <tr>
                                    <td width="21%" valign="top" class="logoTop" rowspan="2">
                                        <cfimage action="writeToBrowser" source="#imgQR#" height=100 width=100>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="7" width="950">
                            <table>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>Cadena Original del Complemento de Certificación Digital del SAT</strong></td></tr>
                                <cfset longCadena = len(#rsReciboLiqCFDI.CadenaSAT#)>
                                <cfset iCadena = 1>
                                <cfloop condition="longCadena gt 0">
                                    <tr><td nowrap="nowrap" style="font-size:8px;">#Mid(rsReciboLiqCFDI.CadenaSAT,iCadena,150)#</td></tr>
                                    <cfset longCadena = #longCadena# - 150>
                                    <cfset iCadena = #iCadena# + 150>
                                </cfloop>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>Sello Digital del Emisor</strong></td></tr>
                                <cfset longCadena = len(#rsReciboLiqCFDI.SelloDigital#)>
                                <cfset iCadena = 1>
                                <cfloop condition="longCadena gt 0">
                                    <tr><td nowrap="nowrap" style="font-size:8px;">#Mid(rsReciboLiqCFDI.SelloDigital,iCadena,150)#</td></tr>
                                    <cfset longCadena = #longCadena# - 150>
                                    <cfset iCadena = #iCadena# + 150>
                                </cfloop>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>Sello digital del SAT</strong></td></tr>
                                <cfset longCadena = len(#rsReciboLiqCFDI.SelloSAT#)>
                                <cfset iCadena = 1>
                                <cfloop condition="longCadena gt 0">
                                    <tr><td nowrap="nowrap" style="font-size:8px;">#Mid(rsReciboLiqCFDI.SelloSAT,iCadena,150)#</td></tr>
                                    <cfset longCadena = #longCadena# - 150>
                                    <cfset iCadena = #iCadena# + 150>
                                </cfloop>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>No de Serie del Certificado del SAT:</strong> #rsReciboLiqCFDI.certificadoSAT#</td></tr>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>Folio Fiscal:</strong> #rsReciboLiqCFDI.Timbre#</td></tr>
                                <tr><td  nowrap="nowrap" style="font-size:11px;"><strong>Fecha Timbrado:</strong> #rsReciboLiqCFDI.FechaTimbrado#</td></tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </cfoutput>
            </td>
        </tr>
        <cfelse>
		<!--- BOLETA DE DETALLE DE OBLIGACIONES --->
		<tr>
			<td>
            <cfoutput>
				<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
                   <!--- ????Corporacion e imagen????--->
                    	<td></td>
						<!-- <td><strong class="tituloReporte1">#session.CEnombre#</strong></td> -->
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
                    <!--- ????RFC y Registro Patronal????--->
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
				<!---<br>--->

				<cfset TotalObligaciones = 0>
				<cfset ObligacionesSocio = 0>
				<cfset cortesocio = "">
				<cfset nombresocio = "">

				<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
					<cfloop query="rsDetalleObligaciones">
						<cfif cortesocio NEQ rsDetalleObligaciones.SNnumero>
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
            </cfoutput>
			</td>
		</tr>
        </cfif>
	</table>
<!---</cfoutput>--->
<cffunction name="fnFormatMoney" access="private" returntype="string">
	<cfargument name="Monto" type="numeric">
	<cfargument name="Decimales" type="numeric" default="2">
	<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#"),'none')>
</cffunction>
</cfif>
