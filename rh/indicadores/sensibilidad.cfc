<cfcomponent extends="home.Componentes.IndicadorBase">
	<!--- 2 = Cese --->
	<cfset This.RHTcomportam = 2>
<!---
	Comportamientos Posibles
	RHTcomportam   Comportamiento
	1              Nombramiento 
	2              Cese  
	3              Vacaciones  
	4              Permiso  
	5              Incapacidad  
	6              Cambio  
	7              Anulacion  
	8              Aumento  
	9              Cambio de Empresa  
--->

<!--- 
	Valor mensual del indicador de acciones por tipo para una empresa.
	Resultado: Cantidad de acciones con un tipo de comportamiento
--->

<cffunction name="calcular">
	<cfargument name="datasource"  type="string"  required="yes" >
	<cfargument name="indicador"   type="string"  required="yes" >
	<cfargument name="Ecodigo"     type="numeric" required="yes" >
	<cfargument name="CEcodigo"    type="numeric" required="yes" >
	<cfargument name="fecha_desde" type="date"    required="yes" >
	<cfargument name="fecha_hasta" type="date"    required="yes" >

	<cfif This.RHTcomportam IS 0>
		<cfthrow message="Invocacion inválida, establezca primero el This.RHTcomportam">
	</cfif>
	
	<cftransaction>
	
	<cfset limpiar(datasource,indicador,Ecodigo,CEcodigo,fecha_desde,fecha_hasta)>

	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo)>
		<cfset BMUsucodigo = session.Usucodigo>
	<cfelse>
		<cfset BMUsucodigo = 0>
	</cfif>
	<cfset Arguments.fecha = Arguments.fecha_desde>
	
	<cfset tblTotal = temptable(1,datasource)>
	<cfset tblValor = temptable(2,datasource)>

	<cfquery datasource="#Arguments.datasource#" >
		insert into #tblTotal# (CFid,Ocodigo,Dcodigo,fecha,valor)
		select p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, count(1) as total 
		from IndicadorFecha ife
		
		join LineaTiempo lt
			on ife.fecha between lt.LTdesde and lt.LThasta
						
		join RHPlazas p
			on lt.RHPid=p.RHPid
			and lt.Ecodigo=p.Ecodigo
						
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha
	</cfquery>

	<cfquery datasource="#Arguments.datasource#" >
		insert into #tblValor# (CFid,Ocodigo,Dcodigo,fecha,valor)
		select p.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, count(1) as valor
		from IndicadorFecha ife
			join DLaboralesEmpleado a
			  on ife.fecha between a.DLfvigencia and a.DLffin
			join RHTipoAccion b
			  on  a.RHTid = b.RHTid
			  and a.Ecodigo = b.Ecodigo
			join LineaTiempo lt
			  on  a.DEid = lt.DEid
			  and a.DLfvigencia between lt.LTdesde and lt.LThasta
			join RHPlazas p
			  on p.RHPid = lt.RHPid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		  and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.RHTcomportam#">
		  and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by p.CFid, lt.Dcodigo, lt.Ocodigo, ife.fecha
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
			( i.valor - coalesce(j.valor,0) ) as valor, i.valor as total,
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


