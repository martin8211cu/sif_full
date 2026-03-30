<cfsetting requesttimeout="3600">

<cf_dbtemp name="aguinempleado" returnvariable="aguinempleado" datasource="#session.dsn#">
	<cf_dbtempcol name="RCNid" 		type="numeric"	mandatory="yes">
	<cf_dbtempcol name="RHTid" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="LTid" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="CIid" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="DEid" 		type="numeric"	mandatory="yes">
	<cf_dbtempcol name="fdesde" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="fhasta" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="CFid" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="Monto" 		type="money"	mandatory="yes">
	<cf_dbtempcol name="MontoFinal"	type="money"	mandatory="no">
	<cf_dbtempcol name="vigente" 	type="numeric"	mandatory="no">
		
</cf_dbtemp>
<!--- <cfset form.vigente=1> --->
<!--- Inserta las Nóminas Ordinarias del Empleado ---> 
<cfquery name="InsertPagosEmpleado" datasource="#session.DSN#">
	insert into #aguinempleado# (RCNid, RHTid, DEid, LTid, fdesde, fhasta, CFid, Monto)
	select 
		pe.RCNid, 
		pe.RHTid, 
		pe.DEid, 
		pe.LTid,
		pe.PEdesde,
		pe.PEhasta,
		null,
		pe.PEmontores
	from CalendarioPagos cp
		inner join HPagosEmpleado pe
			on pe.RCNid = cp.CPid
			inner join EVacacionesEmpleado eve
			on pe.DEid=eve.DEid
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#">
	  and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#">
	  and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
	  and cp.CPtipo=0 <!--- Nominas Ordinarias --->
<!--- LZ 20091208, Tomando en cuenta la Fecha de Antiguedad mas reciente, se determina que historicos deben tomarse en cuenta --->
	  	  and cp.CPhasta >= eve.EVfantig
</cfquery>

<!--- Inserta las Nóminas Extraordinarias (Especiales) del Empleado ---> 
<cfquery name="InsertPagosEmpleadoEX" datasource="#session.DSN#">
	insert into #aguinempleado# (RCNid, RHTid, DEid, LTid, fdesde, fhasta, CFid, Monto)
	select 
		se.RCNid, 
		lt.RHTid, 
		se.DEid, 
		lt.LTid,
		cp.CPhasta,
		cp.CPhasta,
		null,
		0
	from CalendarioPagos cp
		inner join HSalarioEmpleado se
			on se.RCNid = cp.CPid
			inner join EVacacionesEmpleado eve
			on se.DEid=eve.DEid
			inner join LineaTiempo lt
			on se.DEid = lt.DEid
			and cp.CPhasta between lt.LTdesde and lt.LThasta
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and cp.Ecodigo=lt.Ecodigo
	  and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#">
	  and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#">
	  and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
	  and cp.CPtipo=1 <!--- Nominas Especiales --->
	  and cp.CPnorenta=0
<!--- LZ 20091208, Tomando en cuenta la Fecha de Antiguedad mas reciente, se determina que historicos deben tomarse en cuenta --->
	  	  and cp.CPhasta >= eve.EVfantig
</cfquery>

<!--- query que hay que modificar para excluir incidencias o aplicar factor... --->
<!---
<cfquery name="InsertIncidenciasCalc" datasource="#session.DSN#">
	select 
		ic.RCNid, 
		ic.CIid, 
		ic.DEid, 
		ic.ICfecha,
		ic.ICfecha,
		ic.CFid,
		
		<!--- multiplicar por el factor definido en RHIncidenciasAguinaldo para las incidencias con propiedad de aplicar factor--->
		ic.ICmontores * coalesce(( select RHIAaplicarFactor
	  					  from RHIncidenciasAguinaldo
						  where CIid = ic.CIid
						    and RHIAaplicarFactor = 1  ), 1) as ICmontores

	from CalendarioPagos cp
		inner join HIncidenciasCalculo ic
			on ic.RCNid = cp.CPid
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#">
	  and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#">
	  and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
	  and ic.ICmontores > 1000
	  
	  <!--- no toma en cuenta las incidencias definidas en la tabla RHIncidenciasAguinaldo, con propiedad de excluir --->
	  and not exists ( 	select 1
	  					from RHIncidenciasAguinaldo
						where CIid = ic.CIid
						  and RHIAexcluir = 1 )
	  
	  
</cfquery>
<cfdump var="#InsertIncidenciasCalc#">
--->


<cfquery name="InsertIncidenciasCalc" datasource="#session.DSN#">
	insert into #aguinempleado# (RCNid, CIid, DEid, fdesde, fhasta, CFid, Monto)
	select 
		ic.RCNid, 
		ic.CIid, 
		ic.DEid, 
		ic.ICfecha,
		ic.ICfecha,
		ic.CFid,
		
		<!--- multiplicar por el factor definido en RHIncidenciasAguinaldo para las incidencias con propiedad de aplicar factor--->
		ic.ICmontores * coalesce(( select RHIAfactor
	  					  from RHIncidenciasAguinaldo
						  where CIid = ic.CIid
						    and RHIAaplicarFactor = 1  ), 1) as ICmontores

	from CalendarioPagos cp
		inner join HIncidenciasCalculo ic
		on ic.RCNid = cp.CPid

	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<!--- LZ 2009-12-08 Solo deberían tomarse en CUenta las Incidencias de las Mismas Nominas insertadas previamente) 
Comento las Condicionales ORiginales e Incluyo la relacion explicada.
--->
<!---	  and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#">
	  and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#">
	  and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#"> --->
	  and exists (	Select 1 
	  				from #aguinempleado# agui
	  				where agui.RCNid=ic.RCNid
	  				and agui.DEid = ic.DEid)
	  
	  <!--- no toma en cuenta las incidencias definidas en la tabla RHIncidenciasAguinaldo, con propiedad de excluir --->
	  and not exists ( 	select 1
	  					from RHIncidenciasAguinaldo
						where CIid = ic.CIid
						  and RHIAexcluir = 1 )
	  
	  
</cfquery>

<!--- CUANDO SE REQUIERE POR CENTRO FUNCIONAL --->

<cfquery name="UpdateCF" datasource="#session.DSN#">
	update #aguinempleado#
	set CFid = 
		((
		select min(p.CFid) 
		from LineaTiempo lt 
			inner join RHPlazas p
					on p.RHPid = lt.RHPid
		where lt.DEid = #aguinempleado#.DEid 
		  and #aguinempleado#.fdesde between lt.LTdesde and lt.LThasta
		))
	where CFid is null
</cfquery>

<cfquery name="UpdateCF" datasource="#session.DSN#">
	update #aguinempleado#
	set CFid = ((
		select min(p.CFid) 
		from HLineaTiempo lt 
			inner join RHPlazas p
					on p.RHPid = lt.RHPid
		where lt.DEid = #aguinempleado#.DEid 
		  and lt.LTid = #aguinempleado#.LTid 
		))
	where CFid is null
</cfquery>

<cfquery name="Updatevig" datasource="#session.DSN#">
	update #aguinempleado#
	set vigente = 0
	where vigente is null
</cfquery>
<cfquery name="Updatevig" datasource="#session.DSN#">
	update #aguinempleado#
	set vigente = 1
	where DEid in (
		select de.DEid
		from DatosEmpleado de, LineaTiempo lt
		where de.Ecodigo = #Session.Ecodigo#
		  and de.DEid = lt.DEid
		  and de.Ecodigo = lt.Ecodigo 
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> between lt.LTdesde and lt.LThasta
	)
</cfquery>

<!--- 
		Actualizar el campo MontoFinal con las siguientes condiciones
		Si el tipo de Accion existe,  se debe multiplicar el monto * el factor
		Si la incidencia existe, se debe multiplica el monto * el factor asignado a la incidencia
 --->

<cfquery name="DeleteExcluir" datasource="#session.DSN#">
	delete #aguinempleado#
	where exists(
		select 1
		from RHDrpt rp
		where rp.rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTid#">
		  and rp.CIid = #aguinempleado#.CIid
		  and rp.Excluir = 1
		  and rp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		)
</cfquery>

<cfquery name="UpdateMontoFinal" datasource="#session.DSN#">
	update #aguinempleado#
	set MontoFinal = Monto * coalesce((select Factor 
										from RHDrpt rp 
										where rp.rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTid#">
										  and rp.RHTid = #aguinempleado#.RHTid), 1)
	where #aguinempleado#.RHTid is not null
</cfquery>

<cfquery name="UpdateMontoFinal2" datasource="#session.DSN#">
	update #aguinempleado#
	set MontoFinal = Monto * coalesce((select Factor 
										from RHDrpt rp 
										where rp.rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTid#">
										  and  rp.CIid = #aguinempleado#.CIid), 1)
	where #aguinempleado#.RHTid is null
</cfquery>



<cfquery name="Columnas" datasource="#session.DSN#">
	select distinct CPid, CPcodigo
	from #aguinempleado# ag
	inner join CalendarioPagos cp
		on cp.CPid = ag.RCNid
	order by CPcodigo
</cfquery>
<!--- <cfquery name="rsReporte" datasource="#session.DSN#">
		select sum(a.Monto) as MontoCP, 
			sum(a.MontoFinal) as MontoAg,
			min({fn concat(e.DEnombre,{fn concat(' ',{fn concat(e.DEapellido1,{fn concat( ' ',e.DEapellido2)})})})}) as Nombre,
			e.DEid,
			min(a.RCNid) as RCNid,
			cp.CPcodigo as Codigo, 
			e.DEidentificacion
		from ##aguinempleado a
			inner join CalendarioPagos cp
				on cp.CPid = a.RCNid
			inner join DatosEmpleado e
				on e.DEid = a.DEid
		group by e.DEid,e.DEidentificacion,cp.CPcodigo
		order by e.DEidentificacion,cp.CPcodigo
	</cfquery>
	<cfdump var="#rsReporte#"> --->
<!---  
<cf_dumptable var="#aguinempleado#" top="2000" filtro="1 = 1 order by DEid,fdesde">
--->
<cfif isdefined('url.Corte') and url.Corte EQ '0'>
	<!--- Reporte por Empleado / Calendario Pago --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select min(e.DEapellido1) as DEapellido1,
			   min(e.DEapellido2) as DEapellido2,
			   min(e.DEnombre) as DEnombre,
			e.DEidentificacion, 
			min({fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat( ' ',e.DEnombre)})})})}) as Nombre,
			cp.CPcodigo as Codigo, 
			min(a.RCNid) as RCNid, 
			sum(a.Monto) as MontoCP, 
			sum(a.MontoFinal) as MontoAg,
			e.DEid
		from #aguinempleado# a
			inner join CalendarioPagos cp
				on cp.CPid = a.RCNid
			inner join DatosEmpleado e
				on e.DEid = a.DEid
		<cfif isdefined('url.vigente')>
			where a.vigente = 1
		</cfif>
		group by e.DEid,e.DEidentificacion, cp.CPcodigo
		order by DEapellido1, DEapellido2, DEnombre, cp.CPcodigo
		
	</cfquery>
<cfelseif url.Corte EQ '1'>
	<!--- Reporte por Empleado / Calendario Pago --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	min(e.DEapellido1) as DEapellido1,
			   	min(e.DEapellido2) as DEapellido2,
			   	min(e.DEnombre) as DEnombre,
				cf.CFcodigo as CodigoCF,
				cf.CFid,cf.CFdescripcion, 
				min({fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat( ' ',e.DEnombre)})})})}) as Nombre,
				cp.CPcodigo as Codigo, 
				min(a.RCNid) as RCNid, 
				sum(a.Monto) as MontoCP, 
				sum(a.MontoFinal) as MontoAg,
				e.DEid
		from #aguinempleado# a
			inner join CalendarioPagos cp
				on cp.CPid = a.RCNid
			inner join DatosEmpleado e
				on e.DEid = a.DEid
			inner join CFuncional cf
				on cf.CFid = a.CFid
		<cfif isdefined('url.vigente')>
			where a.vigente = 1
		</cfif>
				
		group by cf.CFcodigo,cf.CFid,cf.CFdescripcion, e.DEid, e.DEidentificacion, cp.CPcodigo
		order by cf.CFcodigo,cf.CFdescripcion, DEapellido1, DEapellido2, DEnombre, cp.CPcodigo
	</cfquery>
<cfelseif url.Corte EQ '2'>
	<!--- Reporte por Centro Funcional / Calendario Pago --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select cf.CFcodigo as CodigoCF, cf.CFid, cf.CFdescripcion,
			cp.CPcodigo as Codigo, 
			' ' as DEidentificacion, 
			' ' as Nombre, 
			min(a.RCNid) as RCNid, 
			sum(a.Monto) as MontoCP, 
			sum(a.MontoFinal) as MontoAg
		from #aguinempleado# a
			inner join CalendarioPagos cp
				on cp.CPid = a.RCNid
			inner join DatosEmpleado e
				on e.DEid = a.DEid
			inner join CFuncional cf
				on cf.CFid = a.CFid
		<cfif isdefined('url.vigente')>
			where a.vigente = 1
		</cfif>
				
		group by cf.CFcodigo,cf.CFid,cf.CFdescripcion,cp.CPcodigo
		order by cf.CFcodigo, cp.CPcodigo	
	</cfquery>
</cfif>