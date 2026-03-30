<cfcomponent extends="home.Componentes.IndicadorBase">
<!--- 
	Idoneidad de la gente segun el test de bezinger
--->

<cffunction name="calcular">
	<cfargument name="datasource"  type="string"  required="yes" >
	<cfargument name="indicador"   type="string"  required="yes" >
	<cfargument name="Ecodigo"     type="numeric" required="yes" >
	<cfargument name="CEcodigo"    type="numeric" required="yes" >
	<cfargument name="fecha_desde" type="date"    required="yes" >
	<cfargument name="fecha_hasta" type="date"    required="yes" >

	<cftransaction>
	
	<cfset limpiar(datasource,indicador,Ecodigo,CEcodigo,fecha_desde,fecha_hasta)>

	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo)>
		<cfset BMUsucodigo = session.Usucodigo>
	<cfelse>
		<cfset BMUsucodigo = 0>
	</cfif>
	<cfset Arguments.fecha = Arguments.fecha_desde>
	
	<cfset tblTotal = temptable (1,datasource) >
	<cfset tblValor = temptable (2,datasource) >

	<cfquery datasource="#Arguments.datasource#" >
		insert into #tblValor# (CFid,Ocodigo,Dcodigo,fecha,valor)
		select p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, count(1) as valor 
		from IndicadorFecha ife
		join LineaTiempo lt
			on ife.fecha between lt.LTdesde and lt.LThasta
		join RHPlazas p
			on lt.RHPid = p.RHPid
			and lt.Ecodigo = p.Ecodigo
		join RHPuestos pu<!--- no se hace join con p.RHPcodigo porque esta malo en desarrollo --->
			on lt.RHPcodigo = lt.RHPcodigo
			and lt.Ecodigo = lt.Ecodigo
		join PerfilUsuarioB pb
			on pb.Ecodigo = lt.Ecodigo
			and pb.DEid = lt.DEid
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		and pb.FRval >= floor(pu.FRval * (100 - pu.FRtol) / 100)
		and pb.FLval >= floor(pu.FLval * (100 - pu.FLtol) / 100)
		and pb.BRval >= floor(pu.BRval * (100 - pu.BRtol) / 100)
		and pb.BLval >= floor(pu.BLval * (100 - pu.BLtol) / 100)
		group by p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha
	</cfquery>

	<cfquery datasource="#Arguments.datasource#" >
		insert into #tblTotal# (CFid,Ocodigo,Dcodigo,fecha,valor)
		select p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, count(1) as total 
		from IndicadorFecha ife
		join LineaTiempo lt
			on ife.fecha between lt.LTdesde and lt.LThasta
		join RHPlazas p
			on lt.RHPid = p.RHPid
			and lt.Ecodigo = p.Ecodigo
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha
	</cfquery>

	<cfquery datasource="#Arguments.datasource#" >
		insert into IndicadorValor (
			indicador, Ecodigo, CEcodigo, Dcodigo, Ocodigo, fecha,
			CFid, CFcodigo, CFpath, dia_semana, periodo, mes, trimestre,
			texto, valor, total,
			BMUsucodigo, BMfecha)

		select <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.indicador#">, #Arguments.Ecodigo#, #Arguments.CEcodigo#, 
			i.Dcodigo, i.Ocodigo, i.fecha, cf.CFid, cf.CFcodigo, cf.CFpath,
			<cf_dbfunction name="date_part" args="DD,i.fecha" datasource="#Arguments.datasource#" > as dia_semana,
			<cf_dbfunction name="date_part" args="YY,i.fecha" datasource="#Arguments.datasource#" > as periodo,
			<cf_dbfunction name="date_part" args="MM,i.fecha" datasource="#Arguments.datasource#" > as mes,
			<cf_dbfunction name="date_part" args="Q,i.fecha"  datasource="#Arguments.datasource#" > as trimestre,
			cf.CFdescripcion,
			i.valor - coalesce(j.valor,0) as valor, i.valor as total,
			#BMUsucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		from #tblTotal# i 
		join CFuncional cf
			on cf.CFid = i.CFid
		left join #tblValor# j 
			on i.CFid = j.CFid 
			and i.Ocodigo = j.Ocodigo 
			and i.Dcodigo = j.Dcodigo 
			and i.fecha = j.fecha
	</cfquery>
	
	</cftransaction>

</cffunction>

</cfcomponent>

