
 <cfset bcheck20 = false> 	<!--- No más de una tabla por Archivo --->
 <cfset bcheck1  = false>	<!--- Código de Tabla válido --->
 <cfset bcheck21 = false> 	<!--- Código de Puesto Presupuestario válido --->
 <cfset bcheck12 = false> 	<!--- código de categoría válido---->
 <cfset bcheck13 = false>	<!--- Código de Componente Válido---->	
 <cfset bcheck2  = false>	<!--- La combinación de Tabla,Puesto, Categoría sea válida---->
 <cfset bcheck24 = false>	<!--- Valida que la fecha se encuentre dentro del rango de fecha desde y hasta del escenario---->
 <cfset bcheck23 = false>	<!--- Validación de traslape de fechas---->


<cfquery name="rsCheck20" datasource="#session.DSN#"><!--- No más de una Tabla por archivo---->
	select distinct RHTTcodigo as check20
	from #table_name# 
</cfquery>


<cfquery name="x" datasource="#session.DSN#"><!--- No más de una Tabla por archivo---->
	select distinct *
	from #table_name# 
</cfquery>
<cfdump var="#x#">

<cfif rsCheck20.RecordCount EQ 1>
	<cfset bcheck20 = true>
</cfif>

<cfif bcheck20>

	<cfquery name="rsCheck1" datasource="#session.DSN#"><!--- codigos de tablas válidos---->
		select count(1) as check1
		from #table_name# x
		where  x.RHTTcodigo not in (
						select a.RHTTcodigo 
						from RHTTablaSalarial a 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
    
	<cfif bcheck1>
						
		<cfquery name="rsCheck12" datasource="#session.DSN#"><!--- código de categoría válido---->
			select count(1) as check12
			from #table_name# x
			where  x.RHCcodigo not in (
							select a.RHCcodigo 
							from RHCategoria a 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		</cfquery>
		<cfset bcheck12 = rsCheck12.check12 LT 1>

		<cfif bcheck12>
						
			<cfquery name="rsCheck13" datasource="#session.DSN#"><!--- Código de Componente Válido---->
				select count(1) as check13
				from #table_name# x
				where  x.CScodigo in (
								select a.CScodigo 
								from ComponentesSalariales a 
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and CSsalariobase=1)
			</cfquery>
			<cfset bcheck13 = rsCheck13.check13 LT 1>
            
			<cfif bcheck13>
						
				<cfquery name="rsCheck21" datasource="#session.DSN#"><!--- Código de Puesto Presupuestario válido --->
					select count(1) as check21
					from #table_name# x
					where  x.RHMPPcodigo not in (
									select a.RHMPPcodigo
									from RHMaestroPuestoP a 
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
				</cfquery>
				<cfset bcheck21 = rsCheck21.check21 LT 1>
				<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
             
				<cfif bcheck21>	 <!--- check21 ---> <!--- Código de Puesto Presupuestario válido --->
					
					<cfquery name="rsCheck2" datasource="#session.DSN#"> <!--- La combinación de Tabla,Puesto, Categoría sea válida---->
						select count(1) as check2
						from #table_name# x
						where rtrim(ltrim(x.RHTTcodigo)) #LvarCNCT# rtrim(ltrim(x.RHMPPcodigo)) #LvarCNCT# rtrim(ltrim(x.RHCcodigo))
						not in (
								select distinct
								rtrim(ltrim(c.RHTTcodigo)) #LvarCNCT# rtrim(ltrim(b.RHMPPcodigo)) #LvarCNCT# rtrim(ltrim(a.RHCcodigo))
								from  RHCategoriasPuesto z, RHTTablaSalarial c, RHMaestroPuestoP b, RHCategoria a
								where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
								  and z.RHTTid = c.RHTTid
								  and z.Ecodigo = c.Ecodigo
								  and c.RHTTcodigo = x.RHTTcodigo
								  and z.RHMPPid = b.RHMPPid
								  and z.Ecodigo = b.Ecodigo
								  and z.RHCid = a.RHCid
								  and z.Ecodigo = a.Ecodigo
							)
					</cfquery>
					<cfset bcheck2 = rsCheck2.check2 LT 1>
					                    
					<cfif bcheck2> <!--- check2 ---> <!--- La combinación de Tabla,Puesto, Categoría sea válida---->
						
						<cfquery name="rsCheck24" datasource="#session.DSN#"> <!--- Valida que la fecha se encuentre dentro del rango de fecha desde y hasta del escenario---->
							select count(1) as check24
							from #table_name# x, RHEscenarios e
							where e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">
							  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							  and ((x.fdesde not between e.RHEfdesde and e.RHEfhasta)or(x.fhasta not between e.RHEfdesde and e.RHEfhasta)) 
						</cfquery>
						
						<cfset bcheck24 = rsCheck24.check24 LT 1>
						
						<cfif bcheck24> <!--- Valida que la fecha se encuentre dentro del rango de fecha desde y hasta del escenario---->
								<cfquery name="rsCheck23" datasource="#session.DSN#"> <!--- Validación de traslape de fechas---->
									select count(1) as check23
									from #table_name# x, RHETablasEscenario b, RHTTablaSalarial w
									where b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">
									  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and b.RHTTid = w.RHTTid
									  and x.RHTTcodigo = w.RHTTcodigo
									  and x.fdesde <= b.RHETEfhasta
									  and x.fhasta >= b.RHETEfdesde
								</cfquery>
								
								<cfset bcheck23 = rsCheck23.check23 LT 1>
								
								<cfif bcheck23> <!--- Validación de traslape de fechas---->
										<!--- Inserta Tablas--->
										<cfquery name="rsMoneda" datasource="#session.DSN#"><!--- codigo moneda de la Empresa---->
											select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										</cfquery>
										<cfset Moneda = rsMoneda.Mcodigo>	
								
										<cfquery name="rs" datasource="#session.DSN#">
											select t.* , c.RHTTid, b.RHMPPid, a.RHCid, d.CSid
											from #table_name# t, RHTTablaSalarial c, RHMaestroPuestoP b, RHCategoria a, ComponentesSalariales d
											where t.RHTTcodigo = c.RHTTcodigo
											  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and t.RHMPPcodigo = b.RHMPPcodigo
											  and b.Ecodigo = c.Ecodigo
											  and t.RHCcodigo = a.RHCcodigo
											  and a.Ecodigo = c.Ecodigo
											  and t.CScodigo = d.CScodigo
											  and d.Ecodigo = c.Ecodigo
										</cfquery>
										
										
										<cftransaction>	
											<cfloop query="rs">
												<cflog text="registro: #rs.currentRow#" file="karol">
												<!--- Para Insertar el encabezado --->
												<cfif rs.CurrentRow EQ 1>
													<cfquery name="rsRHETablasEscenario" datasource="#session.DSN#">
														insert into RHETablasEscenario(RHEid, RHTTid, Ecodigo, RHETEdescripcion,RHETEesctabla, RHETEescenarioori, 
														RHETEtablavig,RHETEvariacion,RHETEfdesde, RHETEfhasta, RHETEcriterio, BMfecha, BMUsucodigo) 
														select <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">, 
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHTTid#">,
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
															<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.RHTTdescripcion#">,
															'I',
															 null,
															 null,
															 0.00,
															 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.fdesde#">,
															 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.fhasta#">,
															 0, 
															<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
														<cf_dbidentity1 datasource="#session.DSN#">		
													</cfquery>				
													<cf_dbidentity2 datasource="#session.DSN#" name="rsRHETablasEscenario">
												</cfif>
								
												<!--- Para insertar el detalle --->
												<cfquery name="rsRHDTablasEscenario" datasource="#session.DSN#">
													insert into RHDTablasEscenario(Ecodigo, RHETEid, RHEid, RHTTid, RHMPPid, RHCid,
														CSid,RHDTEmonto,Mcodigo, RHDTEfdesde, RHDTEfhasta, BMfecha, BMUsucodigo)
													select  
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHETablasEscenario.identity#">, 
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">, 
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHTTid#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHMPPid#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHCid#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CSid#">,
														<cfqueryparam cfsqltype="cf_sql_money" value="#rs.monto#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#Moneda#">,
                                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.fdesde#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.fhasta#">,
														<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
												</cfquery>
											</cfloop>
										</cftransaction>
								<cfelse><!--- check23 ---> <!--- Validación de traslape de fechas---->
									<cfquery name="ERR" datasource="#session.dsn#">
										select distinct 'La fecha de inicio o fin, son incorrectas, se traslapan con las fechas de inicio y fin de algún registro existente' as Motivo, 
										convert(varchar,datePart(dd,x.fdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,x.fdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,x.fdesde))	#LvarCNCT# ' a '#LvarCNCT# 
										convert(varchar,datePart(dd,x.fhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,x.fhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,x.fhasta))	as fecha_ingreso,
										convert(varchar,datePart(dd,b.RHETEfdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,b.RHETEfdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,b.RHETEfdesde))	#LvarCNCT# ' a '#LvarCNCT# 
										convert(varchar,datePart(dd,b.RHETEfhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,b.RHETEfhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,b.RHETEfhasta))  as Fecha_existente, 
										x.RHTTcodigo as cod_tabla
										from #table_name# x, RHETablasEscenario b, RHTTablaSalarial w
										where b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">
										  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										  and b.RHTTid = w.RHTTid
										  and x.RHTTcodigo = w.RHTTcodigo
										  and x.fdesde <= b.RHETEfhasta
										  and x.fhasta >= b.RHETEfdesde
									</cfquery>
								</cfif><!--- check23 ---> <!--- Validación de traslape de fechas---->
						
						<cfelse><!--- check24 ---> <!--- Valida que la fecha se encuentre dentro del rango de fecha desde y hasta del escenario---->
                        <cfset bcheck20 = false> 	<!--- No más de una tabla por Archivo --->
 
 							<cfquery name="ERR" datasource="#session.dsn#">
								select distinct 'La fecha que desea ingresar no esta dentro del rango de fechas del Escenario' as Motivo,
								convert(varchar,datePart(dd,x.fdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,x.fdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,x.fdesde))	#LvarCNCT# ' a '#LvarCNCT# 
								convert(varchar,datePart(dd,x.fhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,x.fhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,x.fhasta))	as fecha_ingreso,
								convert(varchar,datePart(dd,e.RHEfdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,e.RHEfdesde))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,e.RHEfdesde))	#LvarCNCT# ' a '#LvarCNCT# 
								convert(varchar,datePart(dd,e.RHEfhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(mm,e.RHEfhasta))#LvarCNCT#'/'#LvarCNCT#convert(varchar,datePart(yy,e.RHEfhasta))  as Fecha_existente 
												
								from #table_name# x, RHEscenarios e
								where e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHEid#">
								  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								  and ((x.fdesde not between e.RHEfdesde and e.RHEfhasta)or(x.fhasta not between e.RHEfdesde and e.RHEfhasta)) 
							
							</cfquery>
							
						</cfif> <!--- check24 ---> <!--- Valida que la fecha se encuentre dentro del rango de fecha desde y hasta del escenario---->
						
					<cfelse><!--- check2 ---> <!--- La combinación de Tabla,Puesto, Categoría sea válida---->
						<cfquery name="ERR" datasource="#session.dsn#">
							select 'No existe la relación entre Codigo de Tabla, Codigo de Categoría, y Codigo de Puesto Presupuestario' as Motivo,x.RHTTcodigo as CTabla, x.RHCcodigo as CCategoria, x.CScodigo as CPresupuestario
							from #table_name# x
							where rtrim(ltrim(x.RHTTcodigo)) #LvarCNCT# rtrim(ltrim(x.RHMPPcodigo)) #LvarCNCT# rtrim(ltrim(x.RHCcodigo))
							not in (
									select distinct
									rtrim(ltrim(c.RHTTcodigo)) #LvarCNCT# rtrim(ltrim(b.RHMPPcodigo)) #LvarCNCT# rtrim(ltrim(a.RHCcodigo))
									from  RHCategoriasPuesto z, RHTTablaSalarial c, RHMaestroPuestoP b, RHCategoria a
									where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
									  and z.RHTTid = c.RHTTid
									  and z.Ecodigo = c.Ecodigo
									  and c.RHTTcodigo = x.RHTTcodigo
									  and z.RHMPPid = b.RHMPPid
									  and z.Ecodigo = b.Ecodigo
									  and z.RHCid = a.RHCid
									  and z.Ecodigo = a.Ecodigo
							)
						</cfquery>
						
					</cfif> <!--- check2 ---> <!--- La combinación de Tabla,Puesto, Categoría sea válida---->
				
				<cfelse><!--- check21 ---> <!--- Código de Puesto Presupuestario válido --->
					
					<cfquery name="ERR" datasource="#session.dsn#">
						select 'No existe el código de Puesto Presupuestario que desea importar' as Motivo, x.RHMPPcodigo as Codigo_PPresupuestario
						from #table_name# x
						where  x.RHMPPcodigo not in (
										select a.RHMPPcodigo
										from RHMaestroPuestoP a 
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
					</cfquery>
				
				</cfif> <!--- check21 ---> <!--- Código de Puesto Presupuestario válido --->
			
			<cfelse><!--- check13 ---> <!--- código de categoría válido---->
				
				<cfquery name="ERR" datasource="#session.dsn#">
				select 'No existe el código de Componente Salarial que desea importar' as Motivo, x.CScodigo as CodigoComponente
				from #table_name# x
				where  x.CScodigo not in (
								select a.CScodigo 
								from ComponentesSalariales a 
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
				</cfquery>
			
			</cfif><!--- check13 ---> <!--- código de categoría válido---->
            
            
             <cfset bcheck20 = false> 	<!--- No más de una tabla por Archivo --->
				
		<cfelse><!--- check12 ---> <!--- código de categoría válido---->
			<cfquery name="ERR" datasource="#session.dsn#">
			select 'No existe el código de la Categorí Salarial que desea importar' as Motivo, x.RHCcodigo as CodigoCategoria
			from #table_name# x
			where  x.RHCcodigo not in (
							select a.RHCcodigo 
							from RHCategoria a 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			 </cfquery>
		</cfif>						

	<cfelse><!--- check1 ---> <!--- Código de Tabla válido --->

		<cfquery name="ERR" datasource="#session.dsn#">
		select 'No existe el código de tabla que desea importar' as Motivo, x.RHTTcodigo as CodigoTabla
		from #table_name# x
		where  x.RHTTcodigo not in (
						select a.RHTTcodigo 
						from RHTTablaSalarial a 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		</cfquery>	
	</cfif>	<!--- check1 ---> <!--- Código de Tabla válido --->					

<cfelse> <!--- check20 --->

	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Existen diferentes códigos de tabla en el script de importación' as Motivo 
	</cfquery>

</cfif> <!--- check20 --->
			
			
	
	
