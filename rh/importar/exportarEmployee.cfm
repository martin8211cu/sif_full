<cfsetting requesttimeout="#600#">
<cftransaction>
	<cf_dbtemp name="empleados" returnvariable="empleados" datasource="#session.dsn#">
		<cf_dbtempcol name="empced"  	type="varchar(30)" mandatory="no">
		<cf_dbtempcol name="nopatr"  	type="varchar(30)" mandatory="no">
		<cf_dbtempcol name="notarj"  	type="varchar(30)" mandatory="no">
		<cf_dbtempcol name="empnomb"  	type="varchar(14)" mandatory="no">
		<cf_dbtempcol name="empapel"  	type="varchar(20)" mandatory="no">
		<cf_dbtempcol name="empadr1"   	type="varchar(35)"  mandatory="no">
		<cf_dbtempcol name="empadr2"  	type="varchar(35)" mandatory="no">
		<cf_dbtempcol name="empcity"  	type="varchar(24)"  mandatory="no">
		<cf_dbtempcol name="empstate"  	type="varchar(2)" mandatory="no">
		<cf_dbtempcol name="empzip" 	type="varchar(10)" mandatory="no">
		<cf_dbtempcol name="empmarital" type="varchar(1)"  mandatory="no">
		<cf_dbtempcol name="empchauf" 	type="varchar(1)"  mandatory="no">
		<cf_dbtempcol name="emphouse" 	type="varchar(1)" mandatory="no">
		<cf_dbtempcol name="emplicen"  	type="varchar(10)" mandatory="no">
		<cf_dbtempcol name="empsssid" 	type="varchar(30)" mandatory="no">
		<cf_dbtempcol name="empretir"   type="money"  mandatory="no">
		<cf_dbtempcol name="empsinot" 	type="varchar(4)"  mandatory="no">
		<cf_dbtempcol name="empagrno" 	type="varchar(1)" mandatory="no">
	</cf_dbtemp>
	<cfquery name="rsInsertA" datasource="#session.DSN#">
		insert into #empleados#
		select distinct 
			substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8), 
			substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9),
			e.DEtarjeta,
			e.DEnombre,
			e.DEapellido1 || ' ' || e.DEapellido2,
			case when {fn LOCATE('#chr(10)#', e.DEdireccion)}  >= 2 then substring(e.DEdireccion, 1, {fn LOCATE('#chr(10)#', e.DEdireccion)} -2) end,
			substring(e.DEdireccion, {fn LOCATE('#chr(10)#', e.DEdireccion)} + 1, 35),
			' ',
			'PR',
			' ',
			case when e.DEcivil = 1 then 'M' else 'S' end,
			'N',
			'N',
			' ',
			(select min(fe.FEidentificacion) from FEmpleado fe where fe.DEid = e.DEid and fe.Pid = 3),
			0.00,
			' ',
			'N'
		from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
		where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		  and se.RCNid = cp.CPid
		  and e.DEid = se.DEid
		  and e.Ecodigo = cp.Ecodigo
	</cfquery>
	<cfquery name="rsUpdateA" datasource="#session.DSN#">
		update #empleados#
		set empcity = substring(empadr2, {fn LOCATE('#chr(10)#', empadr2)} + 1, 35),
			empadr2 = case when {fn LOCATE('#chr(10)#', empadr2)} >2 then substring(empadr2, 1, {fn LOCATE('#chr(10)#', empadr2)} - 2) end
		where {fn LOCATE('#chr(10)#', empadr2)} > 1
	</cfquery>
	<cfquery name="rsUpdateB" datasource="#session.DSN#">
		update #empleados#
		set empcity = substring(empcity, 1, {fn LOCATE('#chr(10)#', empcity)} - 2)
		where {fn LOCATE('#chr(10)#', empcity)} > 0
	</cfquery>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 
			empced,
			nopatr,
			notarj,
			empnomb,
			empapel,
			empadr1,
			empadr2,
			empcity,
			empstate,
			empzip,
			empmarital,
			empchauf,
			emphouse,
			emplicen,
			empsssid,
			empretir,
			empsinot,
			empagrno
		from #empleados#
	</cfquery>
	<cfquery name="rsDrop" datasource="#session.DSN#">
		drop table #empleados#
	</cfquery>
</cftransaction>