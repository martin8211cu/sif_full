<cfoutput>
<!--- Creación de Tablas Temporales para los Reportes de Balance --->
<cf_dbtemp name="ctassel_v1" returnvariable="tbl_ctassel" datasource="desarrollo">
	<cf_dbtempcol name="cgm1id" 	type="int" 			mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="cuentas_v1" returnvariable="tbl_cuentas" datasource="desarrollo">
	<cf_dbtempcol name="cgm1id" 	type="int"			mandatory="yes">
	<cf_dbtempcol name="cgm1idniv" 	type="int"     		mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="cuentas2_v1" returnvariable="tbl_cuentas2" datasource="desarrollo">
	<cf_dbtempcol name="mayor" 		type="char(4)"		mandatory="yes">
	<cf_dbtempcol name="cgm1idniv" 	type="int"			mandatory="yes">
	<cf_dbtempcol name="nombre" 	type="varchar(50)"	mandatory="yes">
	<cf_dbtempcol name="cgm1fi" 	type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="nivel" 		type="int"  		mandatory="yes">
	<cf_dbtempcol name="detalle" 	type="int"  		mandatory="yes">
	<cf_dbtempcol name="saldoini" 	type="money"  		mandatory="yes">
	<cf_dbtempcol name="debitos" 	type="money"  		mandatory="yes">		
	<cf_dbtempcol name="creditos" 	type="money"  		mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="sucursales_v1" returnvariable="tbl_sucursales" datasource="desarrollo">
	<cf_dbtempcol name="cge5cod" 	type="char(5)"  	mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="asientos_v1" returnvariable="tbl_asientos" datasource="desarrollo">
	<cf_dbtempcol name="cg5con" 	type="int"  		mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="periodos_v1" returnvariable="tbl_periodos" datasource="desarrollo">
	<cf_dbtempcol name="periodo" 	type="int"  		mandatory="yes">
	<cf_dbtempcol name="mes" 		type="int"  		mandatory="yes">
</cf_dbtemp>

<!--- Se insertan las Sucursales, los Asientos y Periodos, según parámetros de la pantalla --->
<cfset valor1 = "001">
<cfset niveldetalle = 2 >


<cfquery name="rsSucursales" datasource="desarrollo">
	insert into #tbl_sucursales# (cge5cod) 
	select a.CGE5COD
	from CGE005 a, CGE000 b
	where a.CGE1COD = b.CGE1COD
	  and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valor1#">
</cfquery>

<cfquery name="rsSucursales1" datasource="desarrollo">
	insert into #tbl_sucursales# (cge5cod) 
	select CGE5COD
	from anex_sucursald
	where cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valor1#">
</cfquery>

<!---
<cfloop index="1" from="i" to="#hay que poner el valor#">
<cfif>
--->
<cfquery name="rsAsientos" datasource="desarrollo">
	insert into #tbl_asientos# (cg5con) 
	select CG5CON
	FROM CGM005
</cfquery>
<!---
</cfif>
</cfloop>
--->

<!--- Se hace un ciclo para insertar tanto el Año y el Mes --->
<cfset mesini = 5>
<cfset mesfin = 8>  
<cfset anoini = 2002>
<cfset anofin = 2003>
<cfset bandera = 0>  
<cfset imes = mesini> 
<cfset iano = anoini> 

<cfloop condition="iano LTE anofin">
	<cfset bandera = 0>
	<cfloop condition="bandera EQ 0">
		<cfquery name="rsPeriodos" datasource="desarrollo">
			insert into #tbl_periodos# (periodo, mes) 
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#iano#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#imes#">)
		</cfquery>
			
		<cfset imes = imes + 1>
		
		<cfif ((iano * 100 + imes) GT (anofin * 100 + mesfin) ) or (imes GT 13)>
			<cfif imes GT 13>
				<cfset imes = 1>
			</cfif>
			<cfset bandera = 1>
		</cfif>
	</cfloop>
	<cfset iano = iano + 1>
</cfloop>

<!--- Se insertan las cuentas que cumplan con los criterios y que sean de último nivel. --->
<!--- Ciclo por cada cuenta incorporada en la pantalla como parámetros. --->
<!--- Etapa 1. Seleccion de las Cuentas a analizar --->
<cfquery name="rsInsertCtassel" datasource="desarrollo">
	insert into #tbl_ctassel# (cgm1id) 
	select c.CGM1ID
	from CGM001 c
	where c.CGM1IM = '0009'
		and c.CGM1CD like '%'
		and c.CTAMOV = 'S'
		and not exists (select 1 from #tbl_ctassel# cs where cs.cgm1id = c.CGM1ID)
</cfquery>

<!--- Etapa 2.  Procesamiento de los saldos de las cuentas --->
<!--- PROCESO --->
<!--- Con las cuentas seleccionadas se incorporan todas las cuentas a considerar --->

<cfquery name="rsInsertCuentas" datasource="desarrollo">
	insert into #tbl_cuentas# (cgm1id, cgm1idniv)
	select cu.CGM1ID, cu.ctanivel
	from #tbl_ctassel# a, CGM001cubo cu
	where cu.CGM1ID = a.cgm1id
		and cu.nivelcubo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#niveldetalle#">
</cfquery>

<!--- Insertar las cuentas de mayor que estan en el cubo --->
<cfquery name="rsInsertConCuboCuentas" datasource="desarrollo">
	insert into #tbl_cuentas2# (mayor, cgm1idniv, nombre, cgm1fi, nivel, detalle, saldoini, debitos, creditos)
	select distinct c.CGM1IM, cu.ctanivel, c.CTADES, c.CGM1FI, cu.nivelcubo, 
					case when cu.nivelcubo = <cfqueryparam cfsqltype="cf_sql_integer" value="#niveldetalle#">
								then 1 else 0 end,
					saldoini = 0.00, debitos = 0.00, creditos = 0.00 
	from #tbl_ctassel# a, CGM001cubo cu, CGM001 c
	where cu.CGM1ID = a.cgm1id
		and cu.nivelcubo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#niveldetalle#">
		and c.CGM1ID = cu.ctanivel
</cfquery>

<!--- Insertar las cuentas de mayor que no se encuentran en el cubo --->
<cfquery name="rsInsertSinCuboCuentas" datasource="desarrollo">
	insert into #tbl_cuentas2# (mayor, cgm1idniv, nombre, cgm1fi, nivel, detalle, saldoini, debitos, creditos)
	select distinct cm.CGM1IM, cm.CGM1ID, cm.CTADES, cm.CGM1FI, 0, 0, saldoini = 0.00, debitos = 0.00, creditos = 0.00
	from #tbl_ctassel# a, CGM001 c, CGM001 cm
	where c.CGM1ID = a.cgm1id
		and cm.CGM1IM = c.CGM1IM
		and cm.CGM1CD is null
</cfquery>

<cfquery name="rsUpdateSaldosCuentas" datasource="desarrollo">
	update #tbl_cuentas2# set saldoini = isnull((
		select sum(CTSSAN) 
		from CGM007 s, #tbl_asientos# a
		where s.CGM1ID = #tbl_cuentas2#.cgm1idniv
			and s.CTSPER = <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#">
			and s.CTSMES = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#">
			and s.CG5CON = a.cg5con), 0.00)
</cfquery>

<cfquery name="rsUpdateDebitosCuentas" datasource="desarrollo">
	update #tbl_cuentas2# set debitos = isnull((
		select sum(CTSDEB) 
		from CGM007 s, #tbl_asientos# a, #tbl_periodos# p
		where s.CGM1ID = #tbl_cuentas2#.cgm1idniv
			and s.CTSPER = p.periodo
			and s.CTSMES = p.mes
			and s.CG5CON = a.cg5con), 0.00)
</cfquery>

<cfquery name="rsUpdateCreditosCuentas" datasource="desarrollo">
	update #tbl_cuentas2# set creditos = isnull((
		select sum(CTSCRE) 
		from CGM007 s, #tbl_asientos# a, #tbl_periodos# p
		where s.CGM1ID = #tbl_cuentas2#.cgm1idniv
			and s.CTSPER = p.periodo
			and s.CTSMES = p.mes
			and s.CG5CON = a.cg5con), 0.00)
</cfquery>
		
<cfquery name="rsCuentasContables" datasource="desarrollo">
	select 	c.cgm1idniv as idCta,
			c.mayor as Mayor, 
			c.cgm1fi as Cuenta, 
			c.nivel as Nivel, 
			c.nombre as Descripcion,
			c.saldoini as SaldoInicial,
			c.debitos as Debitos,
			c.creditos as Creditos,
			detalle as Detalle,
			c.saldoini + c.debitos - c.creditos as Total
	from 	#tbl_cuentas2# c
	order by c.mayor, c.cgm1fi
</cfquery>


</cfoutput>	

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr><td nowrap> <cfinclude template="Reporte.cfm"> </td></tr>
		<tr><td nowrap>&nbsp;</td></tr>
	</table> 
</cfoutput>
