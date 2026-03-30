<cfinclude template="ConciliacionAnualRenta-etiquetas.cfm">
<!--- SE BUSCAN LOS DATOS RELACIONADOS CON LA EMPRESA --->
<cfquery  name="rsDatosEmpresa" datasource="#session.DSN#">
	select b.Enombre,direccion1,ciudad,estado,Etelefono1,Efax,codPostal,a.EIdentificacion
	from Empresas a
	inner join Empresa b
		  on b.Ecodigo = a.EcodigoSDC
	inner join Direcciones c
		  on c.id_direccion = b.id_direccion
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsDatosTabla" datasource="#session.DSN#">
	select EIRdesde,EIRhasta,IRcodigo,
	<cf_dbfunction name="date_part"   args="mm, EIRdesde"> as mesDesde,
	<cf_dbfunction name="date_part"   args="yyyy, EIRdesde"> as periodoDesde,
	<cf_dbfunction name="date_part"   args="mm, EIRhasta"> -1 as mesHasta,
	<cf_dbfunction name="date_part"   args="yyyy, EIRhasta"> as periodoHasta
	from EImpuestoRenta
	where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
</cfquery>
<!--- OBTIENE LE DEDUCIBLE --->
<cfquery name="rsMonto" datasource="#session.DSN#">
	select coalesce(sum(DCDvalor),0) as DCDvalor
	from ConceptoDeduc b
	inner join DConceptoDeduc c
		  on c.CDid = b.CDid
	where b.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDatosTabla.IRcodigo#">
	  and c.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
</cfquery>

<cfset Lvar_Deducible = rsMonto.DCDvalor>


<cf_dbtemp name="salidaConcRenta" returnvariable="salida">
	<cf_dbtempcol name="DEid"		type="numeric"      mandatory="yes">
	<cf_dbtempcol name="NIT"   		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="Nombre"   	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="AB"   		type="char(1)" 		mandatory="no">
	<cf_dbtempcol name="RentaNeta"	type="money" 		mandatory="no">
	<cf_dbtempcol name="RentaImpo"	type="money" 		mandatory="no">
	<cf_dbtempcol name="ImpuestoD"	type="money" 		mandatory="no">
	<cf_dbtempcol name="CreditoIVA"	type="money" 		mandatory="no">
	<cf_dbtempcol name="Retencion"	type="money" 		mandatory="no">
	<cf_dbtempcol name="Ajuste"		type="money" 		mandatory="no">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>

<cfset lvarPeriodoDesde = rsDatosTabla.periodoDesde>
<cfset lvarPeriodoHasta = rsDatosTabla.periodoHasta>
<cfset Lvar_Fhasta = rsDatosTabla.EIRhasta>
<!--- SE INSERTAN LAS PERSONAS QUE TIENEN LA LIQUIDACIÓN DE RENTA  --->
<cfquery name="rsEmpleados" datasource="#session.DSN#">
	insert into #salida#(DEid,NIT,Nombre)
	select DEid, DEdato3,{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})} as DEnombre
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and DEid in (select distinct DEid from RHLiquidacionRenta where Estado = 30)
</cfquery>
<!--- ESTADO EN QUE SE ENCUENTRA LA PERSONA A LA HORA DEL CIERRE DE PERIODO --->
<cfquery name="rsAB" datasource="#session.DSN#">
	update #salida#
	set AB = coalesce((select 'A'
						from LineaTiempo b
						where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Lvar_Fhasta)#"> between LTdesde and LThasta
						   and b.DEid = #salida#.DEid),'B')
</cfquery>


<!--- INGRESOS --->
<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set RentaNeta = (coalesce((
							select RentaAnual
							from RHLiquidacionRenta 
							where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
							  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodohasta#">
							  and DEid = #salida#.DEid),0))
</cfquery>
<!--- RENTA IMPONIBLE --->
<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set RentaImpo = (coalesce((	select RentaImponible
							from RHLiquidacionRenta 
							where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
							  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodohasta#">
							  and DEid = #salida#.DEid),0))
</cfquery>

<!--- IMPUESTO DETERMINADO --->
<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set ImpuestoD = (coalesce((	select ImpuestoAnualDet
							from RHLiquidacionRenta 
							where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
							  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodohasta#">
							  and DEid = #salida#.DEid),0))
</cfquery>
<!--- CREDITO IVA --->
<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set CreditoIVA = (coalesce((	select CreditoIVA
							from RHLiquidacionRenta 
							where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
							  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodohasta#">
							  and DEid = #salida#.DEid),0))
</cfquery>

<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set Retencion =  (coalesce((	select RentaRetenida
							from RHLiquidacionRenta 
							where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIRid#">
							  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodohasta#">
							  and DEid = #salida#.DEid),0))
</cfquery>

<cfquery name="rsDatosEmpleados" datasource="#session.DSN#">
	update #salida#
	set Ajuste = ImpuestoD - CreditoIVA - Retencion
</cfquery>
<cfquery name="rsReporte" datasource="#session.DSN#">
	select *
	from #salida#
	 where RentaNeta > <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_Deducible#">
</cfquery>
<cfquery name="rsTotales" datasource="#session.DSN#">
	select sum(RentaNeta) as TotalRN, sum(RentaImpo) as TotalRI, sum(ImpuestoD) as TotalID, sum(CreditoIVA) as TotalCI, sum(Retencion) as TotalRET, sum(Ajuste) as TotalA
	from #salida#
	where RentaNeta > <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_Deducible#">
</cfquery>
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo {
		font-size:60px;
		text-align:center;
		font-style:italic; 
		font-family:Arial, Helvetica, sans-serif}
	.titulo2 {
		font-size:18px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.titulo3 {
		font-size:14px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.titulo4 {
		font-size:12px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.titulo41{
		font-size:12px;
		text-align:left;
		font-family:Arial, Helvetica, sans-serif}
	.titulo5 {
		font-size:22px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.dato {
		font-size:12px;
		text-align:left;
		font-family:Arial, Helvetica, sans-serif}
	.dato2 {
		font-size:11px;
		font-family:Arial, Helvetica, sans-serif}
	.dato2c {
		font-size:11px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.dato3 {
		font-size:9px;
		font-family:Arial, Helvetica, sans-serif}

</style>
<cfoutput>
<table width="1000" border="0" cellpadding="0" cellspacing="0" align="center" style="border-color:CCCCCC">
	<!--- ENCABEZADO --->
	<tr >
		<td align="center" colspan="3">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="25%" class="titulo">SAT</td>
					<td width="75%">
						<table>
							<tr><td class="titulo2">#LB_SAT#</td></tr>
							<tr><td class="titulo3">#LB_ISR#</td></tr>
							<tr><td class="titulo3">#LB_CONCILIACIONANUAL#</td></tr>
							<tr><td class="titulo3">#LB_CONCILIACIONANUAL2#</td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="30%">
						<table width="100%" cellpadding="3">
							<tr>
								<td class="titulo4" valign="top">
									#LB_LUGARYFECHADEPRESENTACION#
								</td>
							</tr>
							<tr><td class="titulo4">#LB_DIA#&nbsp;&nbsp;#DatePart('d',Now())#&nbsp;&nbsp;&nbsp;#LB_MES#&nbsp;&nbsp;#DatePart('m',Now())#&nbsp;&nbsp;&nbsp;#LB_ANO#&nbsp;&nbsp;#DatePart('yyyy',Now())# </td></tr>
						</table>	
					</td>
					<td width="40%">&nbsp;</td>
					<td width="30%" align="center" class="titulo5">SAT -No. 1081</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td width="33%">
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_NUMEROIT##rsDatosEmpresa.Eidentificacion#</td>
								</tr>
								<tr><td class="titulo4">&nbsp;</td>
								</tr>
							</table>	
						</td>
						<td width="33%">
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_PERIODODEIMPOSICION#</td></tr>
								<tr><td class="titulo4">#LB_DEL#&nbsp;&nbsp;#LSDAteFormat(rsDatosTabla.EIRdesde,'dd/mm/yyyy')#<br>#LB_AL#&nbsp;&nbsp;#LSDateFormat(rsDatosTabla.EIRhasta,'dd/mm/yyyy')#</td></tr>
							</table>	
						</td>
						<td width="34%">
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_ADMINISTRACION#</td></tr>
								<tr><td>&nbsp;</td></tr>
							</table>	
						</td>
					</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table width="95%" cellpadding="5" cellspacing="0">
							<tr><td class="titulo41" valign="top">#LB_APELLIDOSYNOMBRESORAZONSOCIAL#</td></tr>
							<tr><td class="dato">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDatosEmpresa.enombre# </td></tr>
						</table>	
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top" nowrap="nowrap">#LB_NUMEROONOMBREDECALLEOAVENIDA#</td></tr>
								<tr><td class="titulo4">#rsDatosEmpresa.direccion1# </td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_NUMEROCASA#</td></tr>
								<tr><td class="titulo4">&nbsp;</td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_APTOOSIMILAR#</td></tr>
								<tr><td>&nbsp;</td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_ZONA#</td></tr>
								<tr><td class="titulo4">&nbsp;</td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_COLONIAOBARRIO#</td></tr>
								<tr><td class="titulo4">&nbsp;</td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_DEPARTAMENTO#</td></tr>
								<tr><td class="titulo4">#rsDatosEmpresa.estado# </td></tr>
							</table>	
						</td>
					</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top" nowrap="nowrap">#LB_MUNICIPIO#</td></tr>
								<tr><td class="titulo4">#rsDatosEmpresa.ciudad# </td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_TELEFONO#</td></tr>
								<tr><td class="titulo4">#rsDatosEmpresa.Etelefono1# </td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_FAX#</td></tr>
								<tr><td class="titulo4">#rsDatosEmpresa.Efax# </td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_APTOPOSTAL#</td></tr>
								<tr><td class="titulo4">&nbsp;#rsDatosEmpresa.codPostal#</td></tr>
							</table>	
						</td>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr><td class="titulo4" valign="top">#LB_EMAIL#</td></tr>
								<tr><td class="titulo4">&nbsp;</td></tr>
							</table>	
						</td>
					</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3"><table width="100%" cellpadding="0" cellspacing="0" border="1px"><tr><td>&nbsp;</td></tr></table></td></tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="2" cellspacing="0">
				<tr class="dato2c">
					<td width="9%">#LB_NIT#</td>
					<td width="27%">#LB_APELLIDOSYNOMBRESCOMPLETOS#</td>
					<td width="3%">#LB_AB#</td>
					<td width="10%">1<br>#LB_RENTANETA#</td>
					<td width="10%">2<br>#LB_RENTAIMPONIBLE#</td>
					<td width="10%">3<br>#LB_IMPUESTODETERMINADO#</td>
					<td width="10%">4<br>#LB_CREDITOIVASEGUNPLANILLA#</td>
					<td width="9%">5<br>#LB_RETENCIONESDEESTEPERIODO#</td>
					<td width="10%">6<br>#LB_AJUSTAARETENCIONES#</td>
				</tr>
				<cfloop query="rsReporte">
					<tr class="dato2">
						<td align="right">#NIT#</td>
						<td>#Nombre#</td>
						<td align="center">#AB#</td>
						<td align="right">#LSNumberFormat(RENTANETA,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(RentaImpo,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(IMPUESTOD,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(CREDITOIVA,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(RETENCION,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(Ajuste,'999,999.99')#</td>
					</tr>
				</cfloop>
				<tr class="dato2">
					<td align="center" colspan="3">#LB_TOTALES#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalRN,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalRI,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalID,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalCI,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalRET,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalA,'999,999.99')#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="1" cellpadding="5" cellspacing="0">
				<tr class="dato3">
					<td valign="top" width="40%">#LB_FIRMA#</td>
					<td width="40%">
						<table width="100%" border="0" cellpadding="7" cellspacing="0">
							<tr class="dato3"><td valign="middle" colspan="3">#LB_NITDEQUIENFIRMASINOESELTITULAR#</td></tr>
							<tr class="dato3">
								<td valign="top">#LB_CALIDADENQUESEACTUA#</td>
								<td>#LB_REPLEGAL#</td>
								<td>#LB_APODERADO#</td>
							</tr>
						</table>
					</td>
					<td width="20%" rowspan="2" valign="top">#LB_SELLODERECEPCIONSAT#</td>
				</tr>
				<tr><td colspan="2" class="dato3">#LB_NOMBRE#</td></tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>