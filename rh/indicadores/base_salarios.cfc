<cfcomponent extends="home.Componentes.IndicadorBase">
	<cfset This.Icomportamiento = 0>
	<!---
		Comportamientos Posibles
		RHTcomportam   Comportamiento
		1              Percentil menor 25
		2              Percentil entre 25 y 50  
		3              Percentil entre 50 y 75
		4              Percentil mayor a 75
	--->
	
	<cffunction name="trae_default" returntype="query">
		<cfargument name="DSN" type="string" required="yes">
		<cfargument name="ecodigo" type="numeric" required="yes">
		<cfquery name="data" datasource="#arguments.DSN#">
			select EEid, ETid, Eid 
			from RHEncuestadora 
			where RHEdefault=1
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
		</cfquery>	
		<cfreturn data >
	</cffunction>

	<!--- 
		Valor mensual del indicador de Salarios vs Encuestas para una empresa.
		Resultado: Cantidad de personas con salario en un percentil, segun la encuesta
	--->
	<cffunction name="calcular">
		<cfargument name="datasource"  type="string"  required="yes" >
		<cfargument name="indicador"   type="string"  required="yes" >
		<cfargument name="Ecodigo"     type="numeric" required="yes" >
		<cfargument name="CEcodigo"    type="numeric" required="yes" >
		<cfargument name="fecha_desde" type="date"    required="yes" >
		<cfargument name="fecha_hasta" type="date"    required="yes" >
	
		<cfif This.Icomportamiento IS 0>
			<cfthrow message="Invocacion inválida, establezca primero el This.RHTcomportam">
		</cfif>
		<cfset datos_default = trae_default(arguments.datasource, arguments.Ecodigo)>
		<cfif datos_default.recordcount eq 0>
			<cfthrow message="Invocacion inválida, no se ha definido la empresa encuestadora default.">
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

		<cfquery datasource="#Arguments.datasource#" name="x" >
			insert into IndicadorValor ( indicador, 
										 Ecodigo, 
										 CEcodigo, 
										 fecha,
										 CFid, 
										 Ocodigo, 
										 Dcodigo, 
										 CFcodigo, 
										 CFpath, 
										 dia_semana, 
										 periodo, 
										 mes, 
										 trimestre,
										 texto, 
										 BMUsucodigo, 
										 BMfecha,
										 total, 
										 valor )

			select 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.indicador)#"> as indicador,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> as Ecodigo,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CEcodigo#"> as CEcodigo,
					ife.fecha,
					b.CFid,
					b.Ocodigo,
					b.Dcodigo,
					cf.CFcodigo,
					cf.CFpath,
					<cf_dbfunction name="date_part" args="DD,ife.fecha" datasource="#Arguments.datasource#" > as dia_semana,
					<cf_dbfunction name="date_part" args="YY,ife.fecha" datasource="#Arguments.datasource#" > as periodo,
					<cf_dbfunction name="date_part" args="MM,ife.fecha" datasource="#Arguments.datasource#" > as mes,
					<cf_dbfunction name="date_part" args="Q,ife.fecha"  datasource="#Arguments.datasource#" > as trimestre,
					cf.CFdescripcion as texto,
					#BMUsucodigo# as BMUsucodigo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as BMfecha,
					(	select 	count(1)
						from IndicadorFecha ife2
						
						join LineaTiempo a2
						on ife2.fecha between a2.LTdesde and a2.LThasta
						and a2.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a2.LTdesde and a2.LThasta
						
						inner join RHPlazas b2
						on a2.Ecodigo=b2.Ecodigo
						and a2.RHPid=b2.RHPid
						and b2.CFid=b.CFid
						and b2.Ocodigo=b.Ocodigo
						and b2.Dcodigo=b.Dcodigo
						
						inner join RHEncuestaPuesto c2
						on a2.RHPcodigo=c2.RHPcodigo
						and a2.Ecodigo=c2.Ecodigo
						and c2.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
						and c2.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.EEid#">
						
						inner join EncuestaSalarios es2
						on c2.EPid=es2.EPid
						and c2.EEid=es2.EEid
						and es2.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.EEid#">
						and es2.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.ETid#">
						and es2.Eid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.Eid#">
						
						where ife2.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha_desde#">
						                     and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha_hasta#">
						/*
						group by ife2.fecha, b2.CFid, b2.Ocodigo, b2.Dcodigo 
						*/
					),
					count(1) as valor
			from IndicadorFecha ife
			
			join LineaTiempo a
			on ife.fecha between a.LTdesde and a.LThasta
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
			
			inner join RHPlazas b
			on a.Ecodigo=b.Ecodigo
			and a.RHPid=b.RHPid
			
			inner join CFuncional cf
			on b.CFid=cf.CFid
			and b.Ecodigo=cf.CFid
			
			inner join RHEncuestaPuesto c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
			and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			and c.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.EEid#">
			
			inner join EncuestaSalarios es
			on c.EPid=es.EPid
			and c.EEid=es.EEid
			and es.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.EEid#">
			and es.ETid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.ETid#">
			and es.Eid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_default.Eid#">
			
			<cfif this.Icomportamiento eq 1 >
				and a.LTsalario <= es.ESp25
			<cfelseif this.Icomportamiento eq 2 >
				and a.LTsalario > es.ESp25 and a.LTsalario <= es.ESp50
			<cfelseif this.Icomportamiento eq 3 >
				and a.LTsalario > es.ESp50 and a.LTsalario <= es.ESp75
			<cfelseif this.Icomportamiento eq 4 >
				and a.LTsalario > es.ESp75
			</cfif>
			
			where ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha_desde#"> 
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha_hasta#">
			
			group by ife.fecha, b.CFid, b.Ocodigo, b.Dcodigo, cf.CFcodigo, cf.CFpath, cf.CFdescripcion 
			order by ife.fecha, b.CFid, b.Ocodigo, b.Dcodigo
		</cfquery>

	</cffunction>

</cfcomponent>