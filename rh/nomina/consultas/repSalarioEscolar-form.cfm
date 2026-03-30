<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>

<!--- Tabla temporal de calendario de pagos --->
<cf_dbtemp name="calendario" returnvariable="calendario">
	<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
	<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
	<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
	<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
	<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
	<cf_dbtempcol name="TipoCambio" type="money"     mandatory="no">
	<cf_dbtempkey cols="RCNid">
</cf_dbtemp>

<!--- Define Form.TipoCambio --->
<cfparam name="Form.TipoCambio" default="1.00" type="numeric">	
<!--- Obtiene información del calendario de pago
selecccionado por el usuario. --->
<cfquery datasource="#session.dsn#">	
	insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago, TipoCambio)
	select CPid, CPdesde, CPhasta, Tcodigo, CPfpago, #Form.TipoCambio#
	from CalendarioPagos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
	and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
</cfquery>

<cf_dbtemp name="salida" returnvariable="salida">
	<cf_dbtempcol name="DEid"     			type="int"          mandatory="yes">
	<cf_dbtempcol name="DEidentificacion"   type="varchar(60)"  mandatory="no">
	<cf_dbtempcol name="Nombre"   			type="char(60)"     mandatory="no">
	<cf_dbtempcol name="Blanco"   			type="char(40)"     mandatory="no">
	<cf_dbtempcol name="Cuenta"   			type="varchar(17)"  mandatory="no">
	<cf_dbtempcol name="Monto"    			type="money"        mandatory="no">
	<cf_dbtempcol name="Deduccion"			type="money"        mandatory="no">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>


<!---Carga los Datos Generales del Empleado--->
<cfquery datasource="#session.dsn#">
	insert #salida# (DEid, DEidentificacion, Nombre, Blanco,Cuenta)
	select distinct 	a.DEid, a.DEidentificacion,
	<cf_dbfunction name="concat" args="a.DEapellido1+' '+a.DEapellido2+'  '+a.DEnombre" delimiters="+"> as Nombre,
	' ', a.DEdato7
	from DatosEmpleado a, LineaTiempo b, CalendarioPagos c, RHPlazas p, CFuncional f, #calendario# x
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and a.DEid = b.DEid
	and b.Tcodigo = x.Tcodigo 
	and c.Ecodigo = a.Ecodigo
	and c.Tcodigo = b.Tcodigo
	and c.CPid = x.RCNid
	and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
	and b.RHPid = p.RHPid
	and p.CFid = f.CFid
	order by a.DEid
</cfquery>

<!---cuando el salario escolar es cargado como deduccion--->
<!---Salarios Escolar Incluido como carga--->
<cfquery datasource="#session.dsn#">
	update #salida#
	set Monto = coalesce((select sum(a.CCvaloremp) 
		from HCargasCalculo a, #calendario# x
		where a.DEid = #salida#.DEid 
		and a.RCNid = x.RCNid 
		and a.DClinea in (select distinct a.DClinea
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#)),0)
		  

<!---Salarios Escolar Porcentaje de la deduccion--->		 

<!---	update #salida#
		set  Deduccion =	(select sum(b.Dvalor) 
		from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
		where a.DEid = #salida#.DEid
		and a.RCNid = x.RCNid 
		and a.DEid = b.DEid
		and a.Did = b.Did
		and b.TDid=z.TDid
		and z.TDid in (select distinct a.TDid
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#))
--->		  

<!---Salarios Escolar Porcentaje de la carga o porcentaje de deduccion si no esta la carga--->		 
	update #salida#
	set Deduccion = coalesce(coalesce((select ca.CEvaloremp
		from CargasEmpleado ca
		where ca.DClinea in (select distinct a.DClinea
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#
		  and ca.DEid = #salida#.DEid)) ,(select dc.DCvaloremp 
		from DCargas dc
		where dc.DClinea in (select distinct a.DClinea
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#))),
		  (select sum(b.Dvalor) 
		from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
		where a.DEid = #salida#.DEid
		and a.RCNid = x.RCNid 
		and a.DEid = b.DEid
		and a.Did = b.Did
		and b.TDid=z.TDid
		and z.TDid in (select distinct a.TDid
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#))
		  )
		   
<!---cuando el salario escolar es cargado como deduccion--->
<!---Salarios Escolar Incluido como Deduccion--->		  
	update #salida#
		set Monto = Monto + coalesce((select sum(a.DCvalor) 
		from HDeduccionesCalculo a, DeduccionesEmpleado b, #calendario# x, TDeduccion z
		where a.DEid = #salida#.DEid
		and a.RCNid = x.RCNid 
		and a.DEid = b.DEid
		and a.Did = b.Did
		and b.TDid=z.TDid
		and z.TDid in (select distinct a.TDid
		from RHReportesNomina c
			inner join RHColumnasReporte b
						inner join RHConceptosColumna a
						on a.RHCRPTid = b.RHCRPTid
				 on b.RHRPTNid = c.RHRPTNid
				and rtrim(ltrim(b.RHCRPTcodigo)) = 'MontoReb'
		where rtrim(ltrim(c.RHRPTNcodigo)) = 'Escol'
		  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<cfquery name="rsSalarioEscolar" datasource="#session.DSN#">
	select <cf_dbfunction name="string_part" args="DEidentificacion,1,10"> as DEidentificacion,	Nombre, Blanco,	<cf_dbfunction name="to_char" args="Cuenta"> as Cuenta,Monto,Deduccion
	from #salida#
</cfquery>


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteSalarioEscolarBP" Default="Reporte Salario Escolar Banco Popular" returnvariable="LB_ReporteSalarioEscolarBP"/>
<cfinclude template="repSalarioEscolar-rep.cfm">