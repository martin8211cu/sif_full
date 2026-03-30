<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfsetting requesttimeout="36000">
<cf_templatecss>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>

<cfset meses = ''>
<cfset lista_meses = ('Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre') >
<cfset meses = listgetat(lista_meses, form.mes) >

<cfquery name="data" datasource="#Session.DSN#">
	select  c.DEid,
			min(d.Enombre) as Enombre,
			min(d.Eidentificacion) as Eidentificacion,
			min(d.Enumero) as Enumero,
			min(d.Eactividad) as Eactividad,
			min(d.Eidresplegal) as Eidresplegal,
			min(d.Enumlicencia) as Enumlicencia,
			min(d.Etelefono1) as Etelefono1,
			min(e.direccion2) as direccion2,
			min(e.atencion) as atencion,
			min(e.direccion1) as direccion1,
			(select Pvalor from RHParametros where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 300) as NumeroPatronal,
			min(case  when  f.DESeguroSocial is null then 
					'999-9999' 
				else 
					f.DESeguroSocial
				end) 
			as DESeguroSocial,	
			'2' as campo13,
			min(f.DEidentificacion) as DEidentificacion,
			min(<cf_dbfunction name="concat" args="f.DEapellido1,' ',f.DEapellido2">) as Empleado,
			min(f.DEnombre) as DEnombre,
			min(f.DEsexo) as DEsexo,
			min(f.DEdato1) as DEdato1,
			min(f.DEdato2) as DEdato2,
			min(f.DEinfo3) as DEinfo3,
			min(f.DEdato4) as DEdato4,		
			min(f.DEinfo2) as DEinfo2,
			min(f.DEdato6) as DEdato6,
			min(f.DEdato5) as DEdato5,
			min(case when ((select <cf_dbfunction name="date_part" args="MM,EVfantig"> 
							from EVacacionesEmpleado x 
							where x.DEid =c.DEid )= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
							and 
							(select <cf_dbfunction name="date_part" args="YY,EVfantig"> 
							from EVacacionesEmpleado x 
							where x.DEid =c.DEid )= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
						  )  then
					'Ingreso Nuevo'
				else
					f.DEinfo1
				end
			) as Ingreso,		
			min(case when f.NTIcodigo ='P' then
				'P'
			else
				' '
			end) as Pasaporte,
			
			sum(c.SErenta) as Renta, 		
			sum(
				(coalesce(c.SEsalariobruto +
							(select sum(ICmontores)
							from HIncidenciasCalculo y
							where y.RCNid = a.RCNid 
								and y.DEid = c.DEid
								and CIid in (select CIid
												from RHReportesNomina c
													inner join RHColumnasReporte b
														on b.RHRPTNid = c.RHRPTNid
														and b.RHCRPTcodigo = 'SAL'
													inner join RHConceptosColumna a
														on a.RHCRPTid = b.RHCRPTid
												where c.RHRPTNcodigo = 'SSP'
													and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											)
							)
				,0))
			) as salario,
			sum(
				(select coalesce(sum(ICmontores),0)
				from HIncidenciasCalculo z
				where z.RCNid = a.RCNid
					and z.DEid = c.DEid
					and CIid in (select CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
										on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'DTM'
									inner join RHConceptosColumna a
										on a.RHCRPTid = b.RHCRPTid
								where c.RHRPTNcodigo = 'SSP'
									and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								)
				)
			) as DecimoTMes,
			sum(
				(select coalesce(sum(ICmontores),0)
				from HIncidenciasCalculo z
				where z.RCNid = a.RCNid
					and z.DEid = c.DEid
					and CIid in (select CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
										on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OT'
									inner join RHConceptosColumna a
										on a.RHCRPTid = b.RHCRPTid
								where c.RHRPTNcodigo = 'SSP'
									and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								)
				)
			) as OtrosIngresos
	from HRCalculoNomina a
		inner join CalendarioPagos b
			on a.RCNid = b.CPid
			and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
			and b.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
		inner join HSalarioEmpleado c
			on a.RCNid = c.RCNid
		inner join DatosEmpleado f
			on c.DEid = f.DEid
		inner join Empresa d
			on a.Ecodigo = d.Ecodigo
			inner join Direcciones e
				on d.id_direccion = e.id_direccion
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by c.DEid
</cfquery>

<cfset LvarFileName = "ReporteSegusoSocial#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
    title="Reporte Salario CCSS" 
    filename="#LvarFileName#"
    irA="reporteSeguroSocialPanama-filtro.cfm" >
<!---Total por pagina---->	
<cfset vn_totalPexc = 0><!---excepciones--->
<cfset vn_totalPsal = 0><!---salarios--->
<cfset vn_totalPrenta = 0><!---renta---->
<cfset vn_totalPdecimo = 0><!----decimo t.mes--->
<!---Totales finales--->
<cfset vn_totalexc = 0><!---excepciones--->
<cfset vn_totalsal = 0><!---salarios--->
<cfset vn_totalrenta = 0><!---renta---->
<cfset vn_totaldecimo = 0><!----decimo t.mes--->

<cfset vn_lineas = 0>
<cfset vb_hubocorte = false>

<style>
	.bordes{
	border-right:1px solid black;
	border-bottom:1px solid black;}
	.bordesEncab{
	border-right:1px solid black;
	border-bottom:1px solid black;
	border-top:1px solid black;}		
</style>

<cfoutput>
<cfsavecontent variable="EncabezadoPagina">
	<table width="98%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr><!-----========= TITULOS  =========---->
		<td>			
			<table width="98%" align="center" border="0" cellspacing="2" cellpadding="0" style="vertical-align:top;">
				<tr><td colspan="2" align="center" ><strong><font size="3"><cf_translate key="LB_CajaDeSeguroSocial">CAJA DE SEGURO SOCIAL</cf_translate></font></strong></td></tr>
				<tr>						
					<td align="center">
						<strong><font size="2"><cf_translate  key="LB_PlanillaMensualDeCuotasAportesEImpuestosSobreLaRenta">PLANILLA MENSUAL DE CUOTAS, APORTES E IMPUESTOS SOBRE LA RENTA</cf_translate></font></strong>
					</td>
				</tr>
				<tr><td colspan="2" align="center"><font size="2"><strong><cf_translate  key="LB_CorrespondienteAlMesDe">CORRESPONDIENTE AL MES DE</cf_translate>:&nbsp;</strong>#meses#&nbsp;<strong><cf_translate  key="LB_De">DE</cf_translate>:&nbsp;</strong>#form.periodo#</font></td></tr>
				<tr><td><b><cf_translate key="LB_Fecha">Fecha</cf_translate>:</b>&nbsp;#LSDateFormat(now(),'dd/mm/yyyy')#</td></tr>
			</table>			
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><!----========= ENCABEZADO =========----->
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td align="right"><b><cf_translate key="LB_NombreDelPatrono">Nombre del Patrono</cf_translate>:&nbsp;</b></td>
					<td>#data.Enombre#</td>
					<td width="1%" nowrap align="right"><b><cf_translate key="LB_NombreDelLugarDeTrabajo">Nombre del Lugar de Trabajo</cf_translate>:&nbsp;</b></td>
					<td>#data.direccion1#</td>
				</tr>
				<tr>
					<td align="right"><b><cf_translate key="LB_DireccionFiscal">Direcci&oacute;n Fiscal</cf_translate>:&nbsp;</b></td>
					<td>#data.direccion2#</td>
					<td align="right"><b><cf_translate key="LB_ActividadEconomica">Actividad Econ&oacute;mica</cf_translate>:&nbsp;</b></td>
					<td>#data.Eactividad#</td>
				</tr>
				<tr>
					<td align="right"><b><cf_translate key="LB_CedulaJuridica">C&eacute;dula Jur&iacute;dica</cf_translate>:&nbsp;</b></td>
					<td>#data.Eidentificacion#</td>
					<td align="right"><b><cf_translate key="LB_CedulaNatural">C&eacute;dula Natural</cf_translate>:&nbsp;</b></td>
					<td>
						<table width="98%" cellpadding="0" cellspacing="0">
							<tr>
								<td align="right"><b><cf_translate key="LB_CedulaNatural">C&eacute;dula Natural</cf_translate>:&nbsp;</b></td>
								<td >#data.Eidresplegal#</td>
								<td align="right"><b><cf_translate key="LB_Licencia">Licencia</cf_translate>:&nbsp;</b></td>
								<td>#data.Enumlicencia#</td>
								<td align="right"> <b><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate>:&nbsp;</b></td>
								<td>#data.Etelefono1#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="1%" nowrap align="right"><b><cf_translate key="LB_RepresentanteLegal">Representante Legal</cf_translate>:&nbsp;</b></td>
					<td>#data.atencion#</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="right"><b><cf_translate key="LB_Correlativo">Correlativo</cf_translate>:&nbsp;</b></td>
					<td>#data.Enumero#</td>
					<td align="right"><b><cf_translate key="LB_NoPatronal">No.Patronal</cf_translate>:&nbsp;</b></td>
					<td>#data.NumeroPatronal#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	</table>
</cfsavecontent>
<cfsavecontent variable="titulos">
	<tr valign="bottom">
		<td width="2%" class="bordesEncab" style="border-left:1px solid black;">&nbsp;</td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_No.Seguro">No.Seguro</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></b></td>
		<td width="200" class="bordesEncab"><b><cf_translate key="LB_Apellido">Apellido</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_Nombre">Nombre</cf_translate></b></td>
		<td width="2%" class="bordesEncab" align="center"><b><cf_translate key="LB_S">S</cf_translate></b></td>
		<td width="2%" class="bordesEncab" align="center"><b><cf_translate key="LB_TC">TC</cf_translate></b></td>
		<td width="2%" class="bordesEncab" align="center"><b><cf_translate key="LB_P">D<br>P</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_No.Empleado">No.<br>Empleado</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_Salario">Salario</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_MontoIR">Monto I/R</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_ClaveIR">Clave I/R</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_DecimoTMes">D&eacute;cimo <br>T.Mes</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_OtrosIngresos">Otros<br> Ingresos</cf_translate></b></td>
		<td width="1%" class="bordesEncab">&nbsp;</td>
		<td width="2%" class="bordesEncab"><b><cf_translate key="LB_Pasaporte">Pasa-<br>porte</cf_translate></b></td>
		<td width="5%" class="bordesEncab"><b><cf_translate key="LB_CedulaNueva">C&eacute;dula<br> Nueva</cf_translate></b></td>
		<td width="10%" class="bordesEncab"><b><cf_translate key="LB_Observaciones">Observaciones</cf_translate></b></td>
	</tr>
</cfsavecontent>
</cfoutput>
<cfoutput>
<cfif data.recordCount GT 0 >
	<table width="98%" cellpadding="2" cellspacing="0" align="center" border="0" style="vertical-align:text-top ">					
		<cfloop query="data">												
			<cfset vn_lineas = vn_lineas+1>						
			<cfif vn_lineas EQ 1>
				<cfset vn_totalPexc = 0>
				<cfset vn_totalPsal = 0>
				<cfset vn_totalPrenta = 0>
				<cfset vn_totalPdecimo = 0>
				<tr><td colspan="18" align="center">#EncabezadoPagina#</td></tr>
				#titulos#
			</cfif> 
			<tr>
				<td width="2%" class="bordes" style="border-left:1px solid black;">
					<cfif len(trim(data.campo13))>#data.campo13#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DESeguroSocial))>#data.DESeguroSocial#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DEidentificacion))>#data.DEidentificacion#<cfelse>&nbsp;</cfif>
				</td>
				<td width="50%" class="bordes">
					<cfif len(trim(data.Empleado))>#data.Empleado#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DEnombre))>#data.DEnombre#<cfelse>&nbsp;</cfif>
				</td>
				<td width="2%" class="bordes">
					<cfif len(trim(data.DEsexo))>#data.DEsexo#<cfelse>&nbsp;</cfif>
				</td>
				<td width="2%" class="bordes">
					<cfif len(trim(data.DEdato1))>#data.DEdato1#<cfelse>&nbsp;</cfif>
				</td>
				<td width="2%" class="bordes">
					<cfif len(trim(data.DEdato2))>#data.DEdato2#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DEinfo3))>#data.DEinfo3#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.salario))>#LSNumberFormat(data.salario,'999,999,999.99')#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.Renta))>#LSNumberFormat(data.Renta,'999,999,999.99')#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DEdato4))>#data.DEdato4#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.DecimoTMes))>#LSNumberFormat(data.DecimoTMes,'999,999,999.99')#<cfelse>&nbsp;</cfif>
				</td>
				<td width="5%" class="bordes">
					<cfif len(trim(data.OtrosIngresos))>#LSNumberFormat(data.OtrosIngresos,'999,999,999.99')#<cfelse>&nbsp;</cfif>
				</td>
				<td width="1%" class="bordes">
					<cfif len(trim(data.DEdato5))>#data.DEdato5#<cfelse>&nbsp;</cfif>
				</td>
				<td width="2%" class="bordes">
					<cfif len(trim(data.Pasaporte))>#data.Pasaporte#<cfelse>&nbsp;</cfif>
				</td>					
				<td width="5%" class="bordes">
					<cfif len(trim(data.DEinfo2))>#data.DEinfo2#<cfelse>&nbsp;</cfif>
				</td>
				<td width="10%" class="bordes">
					<cfif len(trim(data.Ingreso))>#data.Ingreso#<cfelse>&nbsp;</cfif>
				</td>
			</tr>
			<!----Total final---->
			<cfif IsNumeric(data.DEdato1)>
				<cfset vn_totalexc = vn_totalexc+data.DEdato1>
			<cfelse>
				<cfset vn_totalexc = vn_totalexc+0.00>
			</cfif>
			<cfset vn_totalsal = vn_totalsal+data.salario> 
			<cfset vn_totalrenta = vn_totalrenta+data.Renta>
			<cfset vn_totaldecimo = vn_totaldecimo+data.DecimoTMes>
			<!----Total por pagina---->
			<cfif IsNumeric(data.DEdato1)>
				<cfset vn_totalPexc = vn_totalPexc+data.DEdato1>
			<cfelse>
				<cfset vn_totalPexc = vn_totalPexc+0.00>
			</cfif>
			<cfset vn_totalPsal = vn_totalPsal+data.salario> 
			<cfset vn_totalPrenta = vn_totalPrenta+data.Renta>
			<cfset vn_totalPdecimo = vn_totalPdecimo+data.DecimoTMes>
			
			<cfif vn_lineas GT 15>
				<tr><!----=========== CORTE PAGINA ===========----->						
					<td colspan="4" valign="bottom" align="center">
						_______________________________<br>
						<cf_translate key="LB_SelloYFirmaAutorizada">SELLO Y FIRMA AUTORIZADA</cf_translate>
					</td>
					<td colspan="13">
						<table cellpadding="0" cellspacing="0" border="0" align="right">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>&nbsp;</td>
								<td align="right">---<cf_translate key="LB_SALARIO">SALARIO</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_IMPUESTOR">IMPUESTO R</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_EXCEPCIONES">EXCEPCIONES</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_EXCEPCIONES">DECIMO T.MES</cf_translate>---</td>
							</tr>
							<tr>
								<td align="right"><b><cf_translate key="LB_TOTALPORPAGINA">TOTAL POR PAGINA</cf_translate>:&nbsp;</b></td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPsal,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPrenta,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPexc,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPdecimo,'999,999,999.99')#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><p style="page-break-after:always;">&nbsp;</p></td></tr>
				<cfset vb_hubocorte = true>
				<cfset vn_lineas = 0>
			</cfif>
		</cfloop>
		<!-----================== ULTIMOS CORTES ==================----->
		<cfif data.RecordCount LTE 15>
			<cfset vb_hubocorte = true>
		</cfif>
		<tr><!----=========== CORTE PAGINA ===========----->						
			<td colspan="4" valign="bottom" align="center">
				_______________________________<br>
				<cf_translate key="LB_SelloYFirmaAutorizada">SELLO Y FIRMA AUTORIZADA</cf_translate>
			</td>
			<td colspan="13" valign="top">
				<table cellpadding="0" cellspacing="0" border="0" align="right">
					<cfif vb_hubocorte>
						<tr><td>&nbsp;</td></tr>
							<tr>
								<td>&nbsp;</td>
								<td align="right">---<cf_translate key="LB_SALARIO">SALARIO</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_IMPUESTOR">IMPUESTO R</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_EXCEPCIONES">EXCEPCIONES</cf_translate>---</td>
								<td align="right" nowrap>&nbsp;---<cf_translate key="LB_EXCEPCIONES">DECIMO T.MES</cf_translate>---</td>
							</tr>
							<tr>
								<td align="right"><b><cf_translate key="LB_TOTALPORPAGINA">TOTAL POR PAGINA</cf_translate>:&nbsp;</b></td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPsal,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPrenta,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPexc,'999,999,999.99')#</td>
								<td align="right">&nbsp;#LSNumberFormat(vn_totalPdecimo,'999,999,999.99')#</td>
							</tr>
					</cfif>
					<tr><!-----=========== CORTE FINAL ===========----->
						<td align="right"><b><cf_translate key="LB_TOTALFINAL">TOTAL FINAL</cf_translate>:&nbsp;</b></td>
						<td align="right">&nbsp;#LSNumberFormat(vn_totalsal,'999,999,999.99')#</td>
						<td align="right">&nbsp;#LSNumberFormat(vn_totalrenta,'999,999,999.99')#</td>
						<td align="right">&nbsp;#LSNumberFormat(vn_totalexc,'999,999,999.99')#</td>
						<td align="right">&nbsp;#LSNumberFormat(vn_totaldecimo,'999,999,999.99')#</td>
					</tr>
				</table>
			</td>
		</tr>		
	</table>
</cfif>	
</cfoutput>
</body>
</html>
