
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Identificacion" 
	xml="/rh/generales.xml" 
	Default="Identificaci&oacute;n" 
	returnvariable="LB_Identificacion"/>	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Empleado" 
	Default="Empleado"
	xml="/rh/generales.xml" 
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Periodo" 
	Default="Per&iacute;odo"
	xml="/rh/generales.xml" 
	returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Mes" 
	Default="Mes"
	xml="/rh/generales.xml" 
	returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Carga_Obrero_Patronal" 
	Default="Carga"
	xml="/rh/generales.xml" 
	returnvariable="LB_Carga_Obrero_Patronal"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Saldo_Inicial" 
	Default="Saldo Inicial"
	xml="/rh/nomina/operacion/cesantia/consultas/cesantia.xml" 
	returnvariable="LB_Saldo_Inicial"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Monto_Mes" 
	Default="Monto Mes"
	xml="/rh/nomina/operacion/cesantia/consultas/cesantia.xml" 
	returnvariable="LB_Monto_Mes"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Provision_Mensual" 
	Default="Provisión Mensual"
	xml="/rh/nomina/operacion/cesantia/consultas/cesantia.xml" 
	returnvariable="LB_Prov"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Saldo_de_intereses_inicial" 
	Default="Saldo de intereses inicial"
	xml="/rh/nomina/operacion/cesantia/consultas/cesantia.xml" 
	returnvariable="LB_Saldo_intereses_inicial"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Intereses_Mes" 
	Default="Intereses Mes"
	xml="/rh/nomina/operacion/cesantia/consultas/cesantia.xml" 
	returnvariable="LB_Intereses_Mes"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="MGS_FinDelReporte" 
	xml="/rh/generales.xml" 
	Default="Fin del Reporte" 
	returnvariable="MGS_FinDelReporte"/>	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="MSG_NoSeEncontraronRegistros" 
	xml="/rh/generales.xml" 
	Default="No se encontraron registros" 
	returnvariable="MSG_NoSeEncontraronRegistros"/>	
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_Total" 
	xml="/rh/generales.xml" 
	Default="Total" 
	returnvariable="LB_Total"/>	

<!---  query para la consulta --->
<!---
<cfquery name="rs_datos" datasource="#session.DSN#">
	select a.DEid,
		  de.DEidentificacion,
		 de.DEnombre,
		 de.DEapellido1,
		 de.DEapellido2,
		 a.DClinea,
		 dc.DCcodigo,
		 dc.DCdescripcion, 
		 cf.CFcodigo,
		 cf.CFdescripcion,
		 a.RHCSperiodo, 
		 a.RHCSmes, 
		 a.RHCSsaldoInicial as saldo_inicial, 
		 a.RHCSmontoMes as monto_mes, 
		 a.RHCSsaldoInicial+a.RHCSmontoMes as total_monto, 
		 a.RHCSsaldoInicialInt as interes_inicial, 
		 a.RHCSmontoMesInt interes_mes, 
		 a.RHCSsaldoInicialInt+a.RHCSmontoMesInt as total_interes,  
		 a.RHCScerrado
	
	from RHCesantiaSaldos a
	
	inner join DatosEmpleado de
	on de.DEid=a.DEid
	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!--- filtro DEid --->
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	
	inner join DCargas dc
	on dc.DClinea=a.DClinea
	
	inner join LineaTiempo lt
	on lt.DEid=de.DEid
	and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
	
	inner join  RHPlazas p
	on p.RHPid=lt.RHPid
	
	inner join CFuncional cf
	on cf.CFid=p.CFid
	<!--- filtro CFid --->
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfif>
	
	where a.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">		<!--- filtro periodo --->
		and a.RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">				<!--- filtro mes --->
		and a.RHCScerrado = 1	
	
	order by cf.CFcodigo, cf.CFdescripcion, de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre, dc.DCcodigo, dc.DCdescripcion
</cfquery>
--->

<cfparam name="url.periodo" default="#year(now())#">

<cf_dbtemp name="tbl_trabajo" returnvariable="tbl_trabajo">
	<cf_dbtempcol name="DEid" 				type="numeric"			mandatory="yes">
	<cf_dbtempcol name="DEidentificacion"	type="varchar(60)" 		mandatory="yes">	
	<cf_dbtempcol name="DEnombre" 			type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="DEapellido1" 		type="varchar(80)" 		mandatory="yes">	
	<cf_dbtempcol name="DEapellido2" 		type="varchar(80)" 		mandatory="yes">
	<cf_dbtempcol name="DClinea" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="CFcodigo" 			type="char(10)" 		mandatory="no">	
	<cf_dbtempcol name="CFdescripcion" 		type="varchar(60)" 		mandatory="no">
	<cf_dbtempcol name="saldo_inicial" 		type="money" 			mandatory="yes">	
	<cf_dbtempcol name="monto_mes" 			type="money" 			mandatory="yes">
	<cf_dbtempcol name="total_monto" 		type="money" 			mandatory="yes">	
	<cf_dbtempcol name="interes_inicial" 	type="money" 			mandatory="yes">
	<cf_dbtempcol name="interes_mes" 		type="money" 			mandatory="yes">	
	<cf_dbtempcol name="total_interes" 		type="money" 			mandatory="yes">
	<cf_dbtempcol name="total" 				type="money" 			mandatory="yes">
	<cf_dbtempcol name="provision"			type="money" 			mandatory="no">	
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #tbl_trabajo#( DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, DClinea, CFcodigo, CFdescripcion, saldo_inicial, monto_mes, total_monto, interes_inicial, interes_mes, total_interes, total )
	select a.DEid,
		  de.DEidentificacion,
		 de.DEnombre,
		 de.DEapellido1,
		 de.DEapellido2,
		 min(a.DClinea) as DClinea,
		 min(cf.CFcodigo) as CFcodigo,
		 min(cf.CFdescripcion) as CFdescripcion,
		 sum(a.RHCSsaldoInicial) as saldo_inicial, 
		 sum(a.RHCSmontoMes) as monto_mes, 
		 sum(a.RHCSsaldoInicial+a.RHCSmontoMes) as total_monto, 
		 sum(a.RHCSsaldoInicialInt) as interes_inicial, 
		 sum(a.RHCSmontoMesInt) as interes_mes, 
		 sum(a.RHCSsaldoInicialInt+a.RHCSmontoMesInt) as total_interes,
		 sum(a.RHCSsaldoInicial+a.RHCSmontoMes+a.RHCSsaldoInicialInt+a.RHCSmontoMesInt) as total

	from RHCesantiaSaldos a
	
	inner join DatosEmpleado de
	on de.DEid=a.DEid
	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!--- filtro DEid --->
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	
	inner join DCargas dc
	on dc.DClinea=a.DClinea
	
	left join LineaTiempo lt
	on lt.DEid=de.DEid
	and lt.LTid = ( select max(LTid) from LineaTiempo where DEid = a.DEid and <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(url.periodo, url.mes, 1 )#"> <= LThasta and <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(url.periodo, url.mes, daysinmonth( createdate(url.periodo, url.mes, 1) ) )#"> > LTdesde )
	
	left join  RHPlazas p
	on p.RHPid=lt.RHPid
	
	left join CFuncional cf
	on cf.CFid=p.CFid
	<!--- filtro CFid --->
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfif>
	
	where a.RHCSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">		<!--- filtro periodo --->
		and a.RHCSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">				<!--- filtro mes --->
	
	group by a.DEid,
			 de.DEidentificacion,
			 de.DEnombre,
			 de.DEapellido1,
			 de.DEapellido2

	order by de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre
	<!--- order by cf.CFcodigo, cf.CFdescripcion, de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre --->
</cfquery>

<!--- calcula la provision de la primer quincena del mes/periodo --->
<cfquery datasource="#session.DSN#">
	update #tbl_trabajo#
	set provision =   ( select sum(hcc.CCvalorpat)
						from HCargasCalculo hcc, CalendarioPagos cp
						where hcc.DClinea = #tbl_trabajo#.DClinea
						  and hcc.DEid = #tbl_trabajo#.DEid
						  and cp.CPid=hcc.RCNid
						  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
						  and cp.CPtipo=0 )
</cfquery>

<!--- calcula la provision de la segunda quincena del mes/periodo --->

<!--- datos para el reporte --->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select 	CFcodigo,
			CFdescripcion,
			DEid, 
			DEidentificacion, 
			DEnombre, 
			DEapellido1, 
			DEapellido2, 
			saldo_inicial, 
			monto_mes, 
			total_monto, 
			interes_inicial, 
			interes_mes, 
			total_interes, 
			total,
			provision
	from #tbl_trabajo#
	order by DEidentificacion, DEapellido1, DEapellido2, DEnombre
</cfquery>

<cfset l_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >

<table width="98%" align="center" cellpadding="2" cellspacing="0">	
	<tr>
		<td colspan="8" align="center">
			<cfoutput>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td>
					<cf_EncReporte
						Titulo="#LB_nav__SPdescripcion#"
						Color="##E3EDEF"
						filtro1="#lb_Periodo#: #url.periodo#   #lb_mes#:#listgetat(l_meses, url.mes)#"	
					>
				</td></tr>
			</table>
			<!---================= ENCABEZADO ANTERIOR =================
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="center"><strong style="font-size:14px">#LB_nav__SPdescripcion#</strong></td>
				</tr>
				<tr>
					<td align="center"><strong>#lb_Periodo#:</strong> #url.periodo# <strong>#lb_mes#:</strong> #listgetat(l_meses, url.mes)#</td>
				</tr>
			</table>
			---->
			</cfoutput>
		</td>
	</tr>

	
	<cfoutput>
	<tr bgcolor="##CCCCCC">
		<td><strong>#lb_identificacion#</strong></td>
		<td><strong>#LB_Empleado#</strong></td>
		<td align="right"><strong>#LB_Prov#</strong></td>
		<td align="right"><strong>#LB_Saldo_Inicial#</strong></td>
		<td align="right"><strong>#LB_Monto_Mes#</strong></td>
		<td align="right"><strong>#LB_Saldo_intereses_inicial#</strong></td>
		<td align="right"><strong>#LB_Intereses_Mes#</strong></td>
		<td align="right"><strong>#LB_Total#</strong></td>
	</tr>
	</cfoutput>
	
<cfset v_total = 0 >
	<cfoutput query="rs_datos">
	<tr>
		<td>#rs_datos.DEidentificacion#</td>
		<td>#rs_datos.DEapellido1# #rs_datos.DEapellido2# #rs_datos.DEnombre#</td>
		<td align="right">#LSnumberformat(provision, ',9.00')#</td>
		<td align="right">#LSnumberformat(rs_datos.saldo_inicial, ',9.00')#</td>
		<td align="right">#LSnumberformat(rs_datos.monto_mes, ',9.00')#</td>
		<td align="right">#LSnumberformat(rs_datos.interes_inicial, ',9.00')#</td>
		<td align="right">#LSnumberformat(rs_datos.interes_mes, ',9.00')#</td>
		<td align="right">#LSnumberformat(rs_datos.total, ',9.00')#</td>
	</tr>
	<cfset v_total = v_total + rs_datos.interes_mes >
	</cfoutput>
	
	<!---
	<tr>
		<td colspan="5"></td>
		<td ><cfoutput>#LSnumberformat(v_total, ',9.00')#</cfoutput></td>		
	</tr>
	--->
	
	<cfoutput>
	<cfif rs_datos.recordcount gt 0 >
		<tr><td colspan="7" align="center">-- #MGS_FinDelReporte# --</td></tr>
	<cfelse>
		<tr><td colspan="7" align="center">-- #MSG_NoSeEncontraronRegistros# --</td></tr>	
	</cfif>
	</cfoutput>
</table>

