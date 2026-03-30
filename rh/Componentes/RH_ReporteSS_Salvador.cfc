<!--- 	Migracion a ANSI SQL del procedimiento almacenado RH_ReporteSS_Salvador.
			CREATE  proc RH_ReporteSS_Salvador
				@periodo int,    				/* Ao que se consulta */
				@mes     int,   				/* Mes que se consulta */
				@Ecodigo numeric,  				/* Empresa que se consulta */
				@GrupoPlanillas char(5) =null,  /* Grupo de planillas que se desea consultar , si es nulo, son todas */
				@masivo int = 0
 

--->
<cfcomponent>
	<cffunction name="RH_ReporteSS_Salvador" access="public" returntype="query">
		<cfargument name="periodo" 			type="numeric" 	required="yes">
		<cfargument name="mes" 				type="numeric" 	required="yes">		
		<cfargument name="GrupoPlanillas" 	type="string" 	required="no" default="">				
		<cfargument name="masivo" 			type="numeric" 	required="no" default="0">
		<cfargument name="conexion" 		type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">

<!---<cfdump var="#arguments#">--->


		<!--- declaracion de variables --->
		<cfset numpat 			= '' >
		<cfset ocodigo 			= '' >
		<cfset adscrita 		= '' >
		<cfset periodol 		= arguments.periodo >
		<cfset mesl 			= arguments.mes >
		<cfset registro25 		= '' >
		<cfset registro35 		= '' >
		<cfset mensaje 			= '' >
		<cfset onumpatinactivo 	= '' >
		<cfset largo = len(ltrim(rtrim(arguments.GrupoPlanillas))) >
		
		<cfset fecini 		= '' >
		<cfset fecfin 		= '' >
		<cfset periodoA 	= '' >
		<cfset mesA 		= '' >
		<cfset PatAct 		= 0  >
		<cfset PatAnt 		= 0  >
		<cfset GenAct 		= 0  >
		<cfset GenAnt 		= 0  >
		<cfset TotCamb 		= 0  >
		<cfset TotSCamb 	= 0  >
		<cfset PatEmp  		= '' >
		<cfset TOTempcam 	= '' >
		<cfset TOTempncam 	= '' >
		<cfset TOTemp  		= '' >

		<!--- creacion de tablas temporales --->
		<cf_dbtemp name="rh_salida_ccss" returnvariable="salida">
			<cf_dbtempcol name="Patron" 	type="char(25)" mandatory="no" >
			<cf_dbtempcol name="PatAct" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="PatAnt" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="GenAct" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="GenAnt" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="TotCamb" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="TotSCamb" 	type="money"  	mandatory="no" >
			<cf_dbtempcol name="TOTempcam" 	type="integer"	mandatory="no" >
			<cf_dbtempcol name="TOTempncam"	type="integer"  mandatory="no" >
			<cf_dbtempcol name="TOTemp" 	type="integer"  mandatory="no" >
		</cf_dbtemp>
		
		<cf_dbtemp name="rh_salida1_ccss" returnvariable="salida1">
			<cf_dbtempcol name="NUMPAT" 		type="varchar(40)" 	mandatory="no" >
			<cf_dbtempcol name="DEid" 			type="numeric" 	mandatory="no" >
			<cf_dbtempcol name="NoSeguroSocial" type="varchar(25)" 	mandatory="no" >
			<cf_dbtempcol name="cedula" 		type="varchar(25)" 	mandatory="no" >
			<cf_dbtempcol name="Nombre" 		type="varchar(60)"	mandatory="no" >
			<cf_dbtempcol name="actual" 		type="money" 		mandatory="no" >
			<cf_dbtempcol name="anterior" 		type="money" 		mandatory="no" >
			<cf_dbtempcol name="Mensaje" 		type="varchar(255)"	mandatory="no" >
			<cf_dbtempcol name="HorasJornada" 	type="numeric"		mandatory="no" >
		</cf_dbtemp>
		
		<cf_dbtemp name="rh_salida_temp_ccss" returnvariable="temp">
			<cf_dbtempcol name="DEid"			type="numeric"		mandatory="no" >
			<cf_dbtempcol name="FECHDE"			type="datetime"		mandatory="no" >
			<cf_dbtempcol name="FECHAS"			type="datetime"		mandatory="no" > 
			<cf_dbtempcol name="Ecodigo"		type="integer" 		mandatory="no" >
			<cf_dbtempcol name="Ocodigo"		type="int" 			mandatory="no" >
			<cf_dbtempcol name="RHPcodigo"		type="char(20)" 	mandatory="no" >
			<cf_dbtempcol name="Salario"		type="money" 		mandatory="no" >
			<cf_dbtempcol name="Incidencias"	type="money" 		mandatory="no" >
			<cf_dbtempcol name="MONTO"			type="money" 		mandatory="no" >
			<cf_dbtempcol name="Salarioa"		type="money" 		mandatory="no" >
			<cf_dbtempcol name="Incidenciasa"	type="money" 		mandatory="no" >
			<cf_dbtempcol name="MONTOa"			type="money" 		mandatory="no" >
			<cf_dbtempcol name="Mensaje"		type="varchar(255)"	mandatory="no" >
			<cf_dbtempcol name="Fechamax"		type="datetime" 	mandatory="no" >
			<cf_dbtempcol name="Numpatronal"	type="varchar(35)" 	mandatory="no" >
		</cf_dbtemp>

		<cfif arguments.mes eq 1>
			<cfset mesA = 12 > 
			<cfset periodoA = arguments.periodo - 1 >
		<cfelse>
			<cfset mesA = arguments.mes - 1 > 
			<cfset periodoA = arguments.periodo >
		</cfif>

		<cfquery name="rs_oficina" datasource="#arguments.conexion#">
			select 1 
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and coalesce(Onumpatronal,'0') = '0' 
			  and Onumpatinactivo = 0
		</cfquery>

		<cfquery name="rs_calendario" datasource="#arguments.conexion#">
			select 1 
			from CalendarioPagos cp, HPagosEmpleado pe,  Oficinas o
		  	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and cp.CPmes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
      		  and cp.CPid = pe.RCNid 
			  and cp.Tcodigo = pe.Tcodigo 
			  and pe.Ocodigo = o.Ocodigo
      		  and cp.Ecodigo = o.Ecodigo 
			  and o.Onumpatronal is null
		</cfquery>

		<cfif rs_oficina.recordcount gt 0 and rs_calendario.recordcount gt 0> <!--- if principal --->
			<cfquery datasource="#arguments.conexion#">
				delete from #temp#
			</cfquery>

			<cfset PatEmp = 0 >

			<cfif len(trim(numpat))>
				<cfset numpat = '0' >
			</cfif> 
			
			<cfset fecini = createdate(arguments.periodo, arguments.mes, 1) >
			<cfset fechatmp = dateadd('m', 1, fecini) >
			<cfset fecfin = dateadd('d', -1, fechatmp) >

			<cfif PatEmp eq 0>
		  		<cfset NUMPAT = '0' >
			</cfif>
			
			<cfquery datasource="#arguments.conexion#" name="x">
				insert into #Temp#(DEid, Numpatronal, Ecodigo, FECHDE, FECHAS, Salario)
				select 	DEid, 
						o.Onumpatronal, 
						cp.Ecodigo, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#fecini#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#fecfin#">, 
						sum(PEmontores) 
				from CalendarioPagos cp, HPagosEmpleado pe,  Oficinas o
				where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
					and pe.RCNid = cp.CPid
					and o.Ecodigo = cp.Ecodigo
					and cp.CPnocargasley = 0
					and o.Ocodigo = pe.Ocodigo
					and coalesce(o.Onumpatronal, '0') = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
					and pe.RHTid not in (select RHTid from RHTipoAccion where RHTcomportam =5)
				group by DEid, o.Onumpatronal, cp.Ecodigo
			</cfquery>

			<!--- les actualizo las incidencias --->
			<cfquery datasource="#arguments.conexion#"	>
				update #Temp# 
				set Incidencias = coalesce(	(select sum(ICmontores)
											 from CalendarioPagos cp, HIncidenciasCalculo ic, CIncidentes ci
											 where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
											   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
											   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
											   and cp.CPnocargasley = 0
											   and cp.CPid  = ic.RCNid    
											   and #Temp#.DEid = ic.DEid
											   and ic.CIid = ci.CIid 
											   and ci.CInocargasley = 0 )
										  , 0)
			</cfquery>												
 	
			<!--- les actualizo los pagos recibidos el periodo anterior --->
			<cfquery datasource="#arguments.conexion#"	>
				update #Temp# 
				set Salarioa = coalesce((	select sum(PEmontores)
											from CalendarioPagos cp, HPagosEmpleado pe
											where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
											   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">
											   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
												   and cp.CPnocargasley = 0
												   and cp.CPid = pe.RCNid   
												   and cp.Tcodigo =  pe.Tcodigo  
												   and #Temp#.DEid = pe.DEid )
										, 0)
			</cfquery>												

 			<!--- les actualizo las incidencias recibidas el periodo anterior --->
			<cfquery datasource="#arguments.conexion#"	>
				update #Temp# 
				set Incidenciasa = 	coalesce((	select sum(ICmontores)
												from CalendarioPagos cp, HIncidenciasCalculo ic, CIncidentes ci
												where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
												  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">
												  and cp.CPmes= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
												  and cp.CPnocargasley = 0
												  and cp.CPid = ic.RCNid 
												  and #Temp#.DEid= ic.DEid
												  and ic.CIid = ci.CIid 
												  and ci.CInocargasley = 0 )
										   , 0)
			</cfquery>													
 	
			<cfquery datasource="#arguments.conexion#">
				update #Temp# 
				set Fechamax = (	select max(PEdesde)
									from CalendarioPagos cp, HPagosEmpleado pe
									where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
									and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
									and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
									and cp.CPnocargasley = 0
									and cp.CPid = pe.RCNid  
									and cp.Tcodigo = pe.Tcodigo
									and #Temp#.DEid = pe.DEid
									and pe.PEtiporeg = 0 )
			</cfquery>											
 	
			<cfquery datasource="#arguments.conexion#">
				update #Temp# set RHPcodigo = (	 select RHPcodigo
												 from CalendarioPagos cp, HPagosEmpleado pe
												 where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
												   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
												   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
												   and cp.CPnocargasley = 0
												   and cp.CPid = pe.RCNid  
												   and cp.Tcodigo =  pe.Tcodigo   
												   and #Temp#.DEid = pe.DEid
												   and #Temp#.Fechamax = pe.PEdesde
												   and pe.PEtiporeg = 0 )
			</cfquery>									
			<cfquery datasource="#arguments.conexion#">
				update #Temp#
				set MONTO = Salario + Incidencias, 
					MONTOa = Salarioa + Incidenciasa, 
					Mensaje = 'SIN CAMBIO'
			</cfquery>
 	
			<cfquery datasource="#arguments.conexion#">
				update #Temp#
				set Mensaje = 'CON CAMBIO REPORTADO'
				WHERE MONTO != MONTOa
			</cfquery>	
 
			<cfquery name="rs_p300" datasource="#arguments.conexion#">
				select Pvalor 
				from RHParametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
				  and Pcodigo = 300
			</cfquery>
			<cfset NUMPAT = trim(rs_p300.Pvalor) >
 	
			<cfif arguments.masivo eq 0 >
				<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre" returnvariable="vnombre">
				<cfquery datasource="#arguments.conexion#">
					insert into #Salida1#( NUMPAT,DEid,NoSeguroSocial,cedula, Nombre, actual, anterior,  Mensaje )
					SELECT 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">, 
							b.DEid,
							<cf_dbfunction name="string_part" args="DESeguroSocial,1,25">,
							<cf_dbfunction name="string_part" args="DEidentificacion,1,25">,
							<cf_dbfunction name="string_part" args="#preservesinglequotes(vnombre)#,1,60">,							
							MONTO,
							MONTOa,
							Mensaje
					from #Temp# a, DatosEmpleado b
					where a.DEid = b.DEid
					order by b.DEapellido1, b.DEapellido2, b.DEnombre
				</cfquery>
			<cfelse>
				<cfquery name="rs1" datasource="#arguments.conexion#">
					select coalesce(sum(MONTO),0) as monto, 
						   coalesce(sum(MONTOa),0) as montoa 
					from #Temp#
				</cfquery>
				<cfset PatAct = rs1.monto >
				<cfset PatAnt = rs1.montoa >
				
				<cfquery name="rs2" datasource="#arguments.conexion#">
					select coalesce(sum(MONTO),0) as monto, 
						   coalesce(sum(MONTOa),0) as montoa 
					from #Temp#
				</cfquery>	
				<cfset GenAct = rs2.monto >
				<cfset GenAnt = rs2.montoa >
				<cfquery name="rs3" datasource="#arguments.conexion#">
					Select coalesce(sum(MONTO),0) as monto
					from #Temp# 
					where Mensaje != 'SIN CAMBIO'
				</cfquery>
				<cfset TotCamb = rs3.monto>				
				<cfquery name="rs4" datasource="#arguments.conexion#">
					Select coalesce(sum(MONTO),0) as monto
					from #Temp# 
					where Mensaje = 'SIN CAMBIO'
				</cfquery>	
				<cfset TotSCamb = rs4.monto >
								
				<cfquery datasource="#arguments.conexion#">
					insert into  #Salida#(	Patron, 
										PatAct, 
										PatAnt, 
										GenAct, 
										GenAnt, 
										TotCamb, 
										TotSCamb )
					values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#PatAct#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#PatAnt#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#GenAct#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#GenAnt#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#TotCamb#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#TotSCamb#">  )
				</cfquery>
			</cfif> 
			<cfquery datasource="#arguments.conexion#">
				delete from #Temp#
			</cfquery>	
		</cfif> <!--- if principal --->

		<!--- Se verifica si hay oficinas con diferentes numeros patronales --->

		<cfquery name="rs_oficinas" datasource="#session.DSN#">
			select 1 
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and coalesce(Onumpatronal,'0') != '0' 
			  and Onumpatinactivo = 0
		</cfquery>
		<cfif rs_oficinas.recordcount gt 0>
			<cfif len(trim(arguments.GrupoPlanillas))>
				<cfquery name="rs_numpat" datasource="#arguments.conexion#">
					select min(Onumpatronal) as numpat
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
					  and <cf_dbfunction name="string_part" args="Oficodigo,1,#largo#"> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.GrupoPlanillas)#"> 
					  and Onumpatronal is not null
				</cfquery>  
				<cfset numpat = rs_numpat.numpat >
			<cfelse>
				<cfquery name="rs_numpat" datasource="#arguments.conexion#">
					select min(Onumpatronal) as numpat
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
					  and Onumpatronal is not null
				</cfquery>
				<cfset numpat = rs_numpat.numpat >
			</cfif>
			
			<cfloop condition="#len(trim(numpat))# gt 0">
			<!---while @NUMPAT is not null--->
			<!---begin--->
				<cfquery name="rs_numpat" datasource="#arguments.conexion#">
					select count (distinct Onumpatinactivo)  as cuenta
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
					 and  Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
				</cfquery>
				<cfif rs_numpat.cuenta gt 1>
					<cfthrow message="Existen Oficinas cerradas y otras abiertas para el nmero patronal #NUMPAT#, esto no es permitido">
				</cfif>
				
				<cfquery name="rs_numpat" datasource="#arguments.conexion#">
					select Onumpatinactivo 
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
					  and Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
				</cfquery>
				<cfset Onumpatinactivo = rs_numpat.Onumpatinactivo >
		
				<cfif Onumpatinactivo eq 0 >
					<cfset PatEmp = 1 >
					<cfif len(trim(numpat)) eq 0>
						<cfset numpat = '0' >
					</cfif>
		
					<cfset fecini = createdate(arguments.periodo, arguments.mes, 1) >
					<cfset fechatmp = dateadd('m', 1, fecini) >
					<cfset fecfin = dateadd('d', -1, fechatmp) >
					
					<cfif PatEmp eq 0 >
						<cfset NUMPAT = '0' >
					</cfif>
		
<!------------------------------------------------------ Inserto al personal con pagos en el periodo --------------------------------------------------------->
					<cfquery datasource="#arguments.conexion#" name="x">
						insert into #Temp#(DEid, Ocodigo, Ecodigo, FECHDE, FECHAS, Salario)
						select 	DEid, 
								pe.Ocodigo, 
								cp.Ecodigo, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecini#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecfin#">, 
								sum(PEmontores)
		
						from CalendarioPagos cp, HPagosEmpleado pe, Oficinas o
		
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
						  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
						  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
						  and cp.CPid = pe.RCNid   
						  and cp.Tcodigo = pe.Tcodigo 
						  and pe.Ocodigo = o.Ocodigo
						  and cp.Ecodigo = o.Ecodigo 
						  and coalesce(o.Onumpatronal, '0') = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
						  and pe.RHTid not in (select RHTid from RHTipoAccion where RHTcomportam =5)
						group by DEid, pe.Ocodigo, cp.Ecodigo
					</cfquery>
	
					<!--- les actualizo las incidencias --->
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set Incidencias = coalesce((	select sum(ICmontores)
														from CalendarioPagos cp, HIncidenciasCalculo ic, CIncidentes ci
														where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
														  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
														  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
														  and cp.CPid = ic.RCNid
														  and #Temp#.DEid = ic.DEid
														  and ic.CIid = ci.CIid and ci.CInocargasley = 0 )
											, 0)
					</cfquery>												
		
					<!--- les actualizo los pagos recibidos el periodo anterior --->
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set Salarioa = coalesce((	select sum(PEmontores)
													from CalendarioPagos cp, HPagosEmpleado pe
													where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
													  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">
													  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
													  and cp.CPid = pe.RCNid   
													  and cp.Tcodigo =  pe.Tcodigo  
													  and #Temp#.DEid = pe.DEid )
												, 0)
					</cfquery>											
		
					<!--- les actualizo las incidencias recibidas el periodo anterior --->
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set Incidenciasa = coalesce((	select sum(ICmontores)
														from CalendarioPagos cp, HIncidenciasCalculo ic, CIncidentes ci
														where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
														  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">
														  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
														  and cp.CPid = ic.RCNid
														  and #Temp#.DEid = ic.DEid
														  and ic.CIid = ci.CIid and ci.CInocargasley = 0 )
													,0)
					</cfquery>											
		
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set Fechamax = (	select max(PEdesde)
											from CalendarioPagos cp, HPagosEmpleado pe
											where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
											  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
											  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
											  and cp.CPid = pe.RCNid  
											  and cp.Tcodigo =  pe.Tcodigo 
											  and #Temp#.DEid = pe.DEid
											  and pe.PEtiporeg = 0 )
					</cfquery>
		
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set RHPcodigo = (	select RHPcodigo
											from CalendarioPagos cp, HPagosEmpleado pe
											where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
											  and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
											  and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
											  and cp.CPid = pe.RCNid  
											  and cp.Tcodigo =  pe.Tcodigo   
											  and #Temp#.DEid = pe.DEid
											  and #Temp#.Fechamax = pe.PEdesde
											  and pe.PEtiporeg = 0 )
					</cfquery>
		
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set MONTO = Salario + Incidencias, 
							MONTOa = Salarioa + Incidenciasa, 
							Mensaje = 'SIN CAMBIO'
					</cfquery>
		
					<cfquery datasource="#arguments.conexion#">
						update #Temp# 
						set Mensaje = 'CON CAMBIO REPORTADO'
						WHERE MONTO != MONTOa
					</cfquery>
		
					<cfif arguments.masivo eq 0>
						<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre" returnvariable="vnombre">
						
						<!---<cf_dumptable var="#Temp#">--->
						<cfquery datasource="#arguments.conexion#">
							insert into #Salida1# ( NUMPAT, DEid,NoSeguroSocial,cedula, Nombre, actual, anterior,  Mensaje )
							SELECT 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">, 
									b.DEid,
									<cf_dbfunction name="string_part" args="DESeguroSocial,1,25">,
									<cf_dbfunction name="string_part" args="DEidentificacion,1,25">,
									<cf_dbfunction name="string_part" args="#preservesinglequotes(vnombre)#,1,60">,
									MONTO,
									MONTOa,
									Mensaje
							
							from #Temp# a, DatosEmpleado b
							
							where a.DEid = b.DEid
							
							order by b.DEapellido1, b.DEapellido2, b.DEnombre
						</cfquery>
					<cfelse>
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							select 	coalesce(sum(MONTO),0) as monto, 
									coalesce(sum(MONTOa),0) as montoa
							from #Temp#
						</cfquery>
						<cfset PatAct = rs_datos.monto >
						<cfset PatAnt = rs_datos.montoa >
						
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							select 	coalesce(sum(MONTO),0) as monto, 
									coalesce(sum(MONTOa),0) as montoa
							from #Temp#
						</cfquery>
						<cfset GenAct = rs_datos.monto >
						<cfset GenAnt = rs_datos.montoa >
						
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							Select coalesce(sum(MONTO),0) as monto
							from #Temp# 
							where Mensaje != 'SIN CAMBIO'
						</cfquery>
						<cfset TotCamb = rs_datos.monto >
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							Select coalesce(sum(MONTO),0) as monto
							from #Temp#
							where Mensaje = 'SIN CAMBIO'
						</cfquery>
						<cfset TotSCamb = rs_datos.monto >
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							Select count(1) as total
							from #Temp# 
							where Mensaje != 'SIN CAMBIO'
						</cfquery>
						<cfset TOTempcam = rs_datos.total >
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							Select count(1) as total
							from #Temp# 
							where Mensaje = 'SIN CAMBIO'
						</cfquery>
						<cfset TOTempncam = rs_datos.total >
						<cfquery name="rs_datos" datasource="#arguments.conexion#">
							Select count(1) as total 
							from #Temp#
						</cfquery>
						<cfset TOTemp = rs_datos.total>
						<cfquery datasource="#arguments.conexion#">
							insert into #Salida# (	Patron, 
													PatAct, 
													PatAnt, 
													GenAct, 
													GenAnt, 
													TotCamb, 
													TotSCamb, 
													TOTempcam, 
													TOTempncam, 
													TOTemp)
							values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#PatAct#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#PatAnt#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#GenAct#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#GenAnt#">, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#TotCamb#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#TotSCamb#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#TOTempcam#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#TOTempncam#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#TOTemp#">  )
						</cfquery>
					</cfif>
		
					<cfquery datasource="#arguments.conexion#">
						delete from #Temp#
					</cfquery>
				</cfif>
		
				<cfif len(trim(arguments.GrupoPlanillas))>
					<cfquery name="rs_numpat" datasource="#arguments.conexion#">
						select min(Onumpatronal) as numpat
						from Oficinas 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
						  and <cf_dbfunction name="string_part" args="Oficodigo,1,#largo#"> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.GrupoPlanillas)#"> 
						  and Onumpatronal > <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
						  and Onumpatronal is not null
					</cfquery>
					<cfset numpat = rs_numpat.numpat >
				<cfelse>
					<cfquery name="rs_numpat" datasource="#arguments.conexion#">
						select min(Onumpatronal) as numpat 
						from Oficinas 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
						  and Onumpatronal > <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
						  and Onumpatronal is not null
					</cfquery>
					<cfset numpat = rs_numpat.numpat >
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif arguments.masivo eq 1>
			<cfquery name="rs_salida" datasource="#arguments.conexion#">
				select 	Patron, 
						PatAct, 
						PatAnt, 
						GenAct, 
						GenAnt, 
						TotCamb, 
						TotSCamb, 
						TOTempcam, 
						TOTempncam, 
						TOTemp 
				from #Salida#
			</cfquery>	
		<cfelse>
			<cfquery name="rs_salida" datasource="#arguments.conexion#">
				select 	NUMPAT,
						DEid,
						NoSeguroSocial, 
						cedula, 
						Nombre, 
						actual, 
						anterior, 
						Mensaje 
				from #Salida1# 
				order by NUMPAT, Nombre
				<!----Cambio solicitado por JuanCa Gutierrez 04/03/2009--->
				<!---order by NUMPAT,  cedula---->				
			</cfquery>
		</cfif>
		<cfreturn rs_salida >
	</cffunction>
</cfcomponent>