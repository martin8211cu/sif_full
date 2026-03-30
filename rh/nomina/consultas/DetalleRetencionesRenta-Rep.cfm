<cfinclude template="DetalleRetencionesRenta-etiquetas.cfm">
<!--- SE BUSCAN LOS DATOS RELACIONADOS CON LA EMPRESA --->
<cfquery  name="rsDatosEmpresa" datasource="#session.DSN#">
	select b.Enombre,direccion1,ciudad,estado,Etelefono1,Efax,codPostal,a.Eidentificacion
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
<!--- RETENCIONES --->
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
		font-size:10px;
		font-family:Arial, Helvetica, sans-serif}
	.dato2c {
		font-size:10px;
		text-align:center;
		font-family:Arial, Helvetica, sans-serif}
	.dato3 {
		font-size:9px;
		font-family:Arial, Helvetica, sans-serif}

</style>
<cfoutput>
<table border="1" cellpadding="0" cellspacing="0" align="center" style="border-color:CCCCCC">
	<!--- ENCABEZADO --->
	<tr >
		<td align="center" colspan="2">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="25%" class="titulo">SAT</td>
					<td width="75%">#LB_SAT#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="4" cellspacing="3">
				<tr class="dato"><td>#LB_ELAGENTERETENEDOR#:&nbsp;&nbsp;#rsDatosEmpresa.enombre#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_NIT#: #rsDatosEmpresa.Eidentificacion#</td></tr>
				<tr class="dato"><td>#LB_ConDomicilioFiscalEn#:&nbsp;&nbsp;#rsDatosEmpresa.direccion1#</td></tr>
				<tr class="dato"><td>#LB_HACECONSTARQUE#</td></tr>
				<tr class="dato"><td>#LB_HACECONSTARQUE2#&nbsp;&nbsp;#LSDateFormat(Lvar_Fhasta,'dd/mm/yyyy')#</td></tr>
				<tr class="dato"><td>#LB_CONFORME#:</td></tr>
		  </table>
		</td>
		<td align="center"	 valign="middle">SAT-No 1141</td>
	</tr>
	<tr >
		<td align="center" colspan="2">
			<table border="0" cellpadding="4" cellspacing="0">
				<tr class="dato"><td nowrap="nowrap">#LB_DetalleDevoluciones#&nbsp;#lvarPeriodoHasta#&nbsp;#LB_DetalleDevoluciones2#</td></tr>
		  </table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%" border="1" cellpadding="2" cellspacing="0">
				<tr class="dato2c">
					<td width="3%" nowrap="nowrap">#LB_NoDEORDEN#</td>
					<td width="27%">#LB_CONTRIBUYENTE#</td>
					<td width="10%">#LB_RENTAIMPONIBLE#</td>
					<td width="10%">#LB_IMPUESTODETERMINADO#</td>
					<td width="10%">#LB_IVAIMPUESTORET#</td>
					<td width="10%">#LB_RETENCIONESDESCONTADAS#</td>
					<td width="30%">#LB_FIRMADERECIBIDO#</td>
				</tr>
				<cfloop query="rsReporte">
					<tr class="dato2">
						<td align="center">#rsReporte.CurrentRow#</td>
						<td>#Nombre#</td>
						<td align="right">#LSNumberFormat(RentaImpo,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(IMPUESTOD,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(CREDITOIVA+RETENCION,'999,999.99')#</td>
						<td align="right">#LSNumberFormat(Ajuste,'999,999.99')#</td>
						<td align="right">&nbsp;</td>
					</tr>
				</cfloop>
				<tr class="dato2">
					<td align="center" colspan="2">#LB_TOTALES#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalRI,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalID,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalCI+rsTotales.TotalRET,'999,999.99')#</td>
					<td align="right">#LSNumberFormat(rsTotales.TotalA,'999,999.99')#</td>
					<td align="right">&nbsp;</td>
				</tr>
		  </table>
		</td>
	</tr>
</table>
</cfoutput>