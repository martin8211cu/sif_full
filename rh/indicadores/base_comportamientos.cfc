<cfcomponent extends="home.Componentes.IndicadorBase">
<cfset This.RHTcomportam = 0>
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

<!---
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
	<cfquery name="comportamientos_rs" datasource="#Arguments.datasource#">
		delete from IndicadorValor
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		  and fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
		                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#">
	</cfquery>
	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo)>
		<cfset BMUsucodigo = session.Usucodigo>
	<cfelse>
		<cfset BMUsucodigo = 0>
	</cfif>
	<cfset Arguments.fecha = Arguments.fecha_desde>
	<cfquery name="comportamientos_rs" datasource="#Arguments.datasource#" >
		insert into IndicadorValor (
			indicador, Ecodigo, CEcodigo, Dcodigo, Ocodigo, fecha,
			CFid, CFcodigo, CFpath, dia_semana, periodo, mes, trimestre,
			texto, valor, total,
			BMUsucodigo, BMfecha)
		select
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#"> as indicador,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">   as Ecodigo,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">  as CEcodigo,
			lt.Dcodigo, lt.Ocodigo,
			ife.fecha as fecha,
			
			cf.CFid, cf.CFcodigo, cf.CFpath,
			<cf_dbfunction name="date_part" args="DW,ife.fecha" datasource="#Arguments.datasource#"> as dia_semana,
			<cf_dbfunction name="date_part" args="YY,ife.fecha" datasource="#Arguments.datasource#"> as periodo,
			<cf_dbfunction name="date_part" args="MM,ife.fecha" datasource="#Arguments.datasource#"> as mes,
			<cf_dbfunction name="date_part" args="Q,ife.fecha" datasource="#Arguments.datasource#"> as trimestre,
			
			cf.CFdescripcion, count(1) as valor, 
			
			( 	select count(1)
				from LineaTiempo lt2
				
				inner join Departamentos d2
				on lt2.Ecodigo=d2.Ecodigo
				and lt2.Dcodigo=d2.Dcodigo
				
				inner join Oficinas o2
				on lt2.Ecodigo=o2.Ecodigo
				and lt2.Ocodigo=o2.Ocodigo
				
				inner join RHPlazas p2
				on lt2.RHPid=p2.RHPid
				and lt2.Ecodigo=p2.Ecodigo
				
				inner join CFuncional cf2
				on cf2.Ecodigo=p2.Ecodigo
				and cf2.CFid=p2.CFid
				and cf2.CFid=cf.CFid
				
				where lt2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and ife.fecha between lt2.LTdesde and lt2.LThasta
				and lt2.Ocodigo=lt.Ocodigo
				and lt2.Dcodigo=lt.Dcodigo) as total,
			
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#BMUsucodigo#"> as BMUsucodigo,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> as BMfecha
		from IndicadorFecha ife
			join DLaboralesEmpleado a
			  on ife.fecha between a.DLfvigencia and a.DLffin
			join RHTipoAccion b
			  on  a.RHTid = b.RHTid
			  and a.Ecodigo = b.Ecodigo
			join LineaTiempo lt
			  on  a.DEid = lt.DEid
			  and a.DLfvigencia between lt.LTdesde and lt.LThasta
			join RHPlazas rhp
			  on rhp.RHPid = lt.RHPid
			join CFuncional cf
			  on rhp.CFid = cf.CFid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		  and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.RHTcomportam#">
		  and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#"> 
							  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by lt.Dcodigo, lt.Ocodigo, ife.fecha, a.DLfvigencia, cf.CFid, cf.CFcodigo, cf.CFpath, cf.CFdescripcion
	</cfquery>
</cffunction>
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
	<cfquery name="comportamientos_rs" datasource="#Arguments.datasource#">
		delete from IndicadorValor
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		  and fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
		                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#">
	</cfquery>

	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo)>
		<cfset BMUsucodigo = session.Usucodigo>
	<cfelse>
		<cfset BMUsucodigo = 0>
	</cfif>
	<cfset Arguments.fecha = Arguments.fecha_desde>


	<cfquery datasource="#Arguments.datasource#" >
		select cf.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, cf.CFcodigo, cf.CFpath, cf.CFdescripcion, count(1) as total 
		into ##i
		
		from IndicadorFecha ife
		
		join LineaTiempo lt
		on ife.fecha between lt.LTdesde and lt.LThasta
						
		join Departamentos d
		on lt.Ecodigo=d.Ecodigo
		and lt.Dcodigo=d.Dcodigo
					
		join Oficinas o
		on lt.Ecodigo=o.Ecodigo
		and lt.Ocodigo=o.Ocodigo
						
		join RHPlazas p
		on lt.RHPid=p.RHPid
		and lt.Ecodigo=p.Ecodigo
						
		join CFuncional cf
		on cf.Ecodigo=p.Ecodigo
		and cf.CFid=p.CFid
						
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by cf.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, cf.CFcodigo, cf.CFpath, cf.CFdescripcion
	</cfquery>

	<cfquery datasource="#Arguments.datasource#" >
		select cf.CFid, lt.Ocodigo, lt.Dcodigo, ife.fecha, count(1) as valor
		into ##j
		from IndicadorFecha ife
			join DLaboralesEmpleado a
			  on ife.fecha between a.DLfvigencia and a.DLffin
			join RHTipoAccion b
			  on  a.RHTid = b.RHTid
			  and a.Ecodigo = b.Ecodigo
			join LineaTiempo lt
			  on  a.DEid = lt.DEid
			  and a.DLfvigencia between lt.LTdesde and lt.LThasta
			join RHPlazas rhp
			  on rhp.RHPid = lt.RHPid
			join CFuncional cf
			  on rhp.CFid = cf.CFid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		  and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.RHTcomportam#">
		  and ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
		group by cf.CFid, lt.Dcodigo, lt.Ocodigo, ife.fecha

	</cfquery>

	<cfquery name="x" datasource="#Arguments.datasource#" >
		insert into IndicadorValor (
			indicador, Ecodigo, CEcodigo, Dcodigo, Ocodigo, fecha,
			CFid, CFcodigo, CFpath, dia_semana, periodo, mes, trimestre,
			texto, valor, total,
			BMUsucodigo, BMfecha)

		select <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.indicador#">, #Arguments.Ecodigo#, #Arguments.CEcodigo#, i.Dcodigo, i.Ocodigo, i.fecha, i.CFid, i.CFcodigo, i.CFpath, datepart(dd,i.fecha),datepart(yy,i.fecha),datepart(mm,i.fecha),datepart(qq,i.fecha),i.CFdescripcion, coalesce(j.valor,0) as valor, i.total, #BMUsucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		from ##i i 
		left join ##j j 
		on i.CFid = j.CFid 
		and i.Ocodigo = j.Ocodigo 
		and i.Dcodigo = j.Dcodigo 
		and i.fecha = j.fecha
	</cfquery>

<cfquery datasource="#Arguments.datasource#">
	drop table ##i
</cfquery>
<cfquery datasource="#Arguments.datasource#">
	drop table ##j
</cfquery>

</cffunction>

</cfcomponent>