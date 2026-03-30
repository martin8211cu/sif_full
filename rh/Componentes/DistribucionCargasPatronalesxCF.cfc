<!--- Este componente se encarga de distribuir las Cargas Patronales en los distintos Centros Funcionales donde laboró el empleado.
 * Este porcentaje de distribucion se obtiene tomando en cuenta los salarios e incidencias recibidos por el empleado en los distintos centros funcionales, 
 se suman los montos positivos y se distribuyen entre los centros funcionales positivos para determinar qué porcentaje de las Cargas Patronales le corresponde a cada
 centro donde el empleado laboró.
 Nota: Este proceso es el prederminado que debe realizar el sistema, debido que permite distribuir adecuadamente las Cargas Patronales en los centros que fueron cargadas--->
<!--- Creación: 20/12/11---->
<!--- Este proceso (rh.Componentes.DistribucionCargasPatronalesxCF)  se invoca desde el componente: RH_CuentasTipo.cfc---->
<cfcomponent>
<cfset debug=false>

	<!--- funcion principal que se encarga de seguir el flujo de la distribucion de cargas, llamando a cada una de las funciones necesarias--->
	<cffunction name="RealizarDistribucion" access="public">

		<!--- crea las tablas temporales para almacenar la tabla de distribucion y el resultado final de distribucion--->
		<cfinvoke method="CreasTablasTemp">
				<cfinvokeargument name="Conexion" value="#Arguments.conexion#">
		</cfinvoke>		
		
		<!--- se encarga de llenar una tabla de porcentajes de Cargas patronales por centro funcional de cada empleado para posteriormente distribuir---->		
		<cfinvoke method="LlenarTablePorceCF">
				<cfinvokeargument name="Conexion" value="#Arguments.conexion#">
				<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
		</cfinvoke>		
				
		<!---- a partir de la tabla de distribucion obtenida en el paso anterior se procede a llenar la tabla de con la nueva distribucion de Cargas Patronales--->
		<cfinvoke method="LlenarTemporalDistribucion">
				<cfinvokeargument name="Conexion" value="#Arguments.conexion#">
				<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
		</cfinvoke>		
		
		<!---- La función para obtener la tabla de porcentajes trabaja con muchos decimales, por lo que esto puede resultar en un error de balancedo de decimales. 
		Por tal motivo este proceso se encarga de balancear la diferencia de estos decimales--->
		<cfinvoke method="BalancearTemporarlDistribucion">
				<cfinvokeargument name="Conexion" value="#Arguments.conexion#">
				<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
		</cfinvoke>	
	
		<!--- esta función se encarga de sustituir en la tabla de RCuentasTipo los resultados de distribución calculados durante todo el proceso 
		y que se encuentran en la tabla temporal de distribución---->
		<cfinvoke method="SustituirRegistros">
				<cfinvokeargument name="Conexion" value="#Arguments.conexion#">
				<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
		</cfinvoke>		
		
	</cffunction>

	<!--- crea las tablas temporales para almacenar la tabla de distribución y el resultado final de la distribución--->
	<cffunction name="CreasTablasTemp" access="public">
			<cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">	
				<!--- Se crea una Tabla Temporal, para analizar por Empleado, el porcentaje de Salario que se distribuye en cada CF	--->
				  <cf_dbtemp name="PorcDistrCargas" returnvariable="PorcDistrCargas" datasource="#Arguments.Conexion#">	
						<cf_dbtempcol name="Ecodigo"  			type="numeric"		mandatory="yes">			  
						<cf_dbtempcol name="RCNid"  			type="numeric"		mandatory="yes">
						<cf_dbtempcol name="DEid"				type="numeric" 		mandatory="no">			
						<cf_dbtempcol name="CFid"				type="numeric" 		mandatory="no">			
						<cf_dbtempcol name="montores"			type="float"		mandatory="no">			
						<cf_dbtempcol name="montototal"			type="float"		mandatory="no">						
						<cf_dbtempcol name="porcentajeCF"		type="float"		mandatory="no" default="0">						
				  </cf_dbtemp> 
		  
				<!--- Se Crea Tabla Temporal de Paso para Analizar los Registros 10,11,20,21 (Salario e Incidencias) y realizar la Distribucion de los Registros 30 
			   (Cargas Patronales)		--->
				  <cf_dbtemp name="DistrCargasCF" returnvariable="DistrCargasCF" datasource="#Arguments.Conexion#">
							<cf_dbtempcol name="id"					type="numeric" 		mandatory="yes" identity="true">		<!--- identity --->
							<cf_dbtempcol name="RCTidREF"			type="numeric" 		mandatory="yes"><!--- registro (llave) origen --->
							<cf_dbtempcol name="RCNid"  			type="numeric"		mandatory="yes">
							<cf_dbtempcol name="Ecodigo"  			type="int"			mandatory="yes">
							<cf_dbtempcol name="tiporeg"  			type="int"			mandatory="no">
							<cf_dbtempcol name="DEid"				type="numeric" 		mandatory="no">
							<cf_dbtempcol name="referencia"			type="numeric" 		mandatory="no">
							<cf_dbtempcol name="cuenta"				type="varchar(100)"	mandatory="no">
							<cf_dbtempcol name="valor"				type="varchar(100)"	mandatory="no">
							<cf_dbtempcol name="Cformato"			type="varchar(100)"	mandatory="no">
							<cf_dbtempcol name="Ccuenta"			type="numeric" 		mandatory="no">
							<cf_dbtempcol name="CFcuenta"			type="numeric" 		mandatory="no">
							<cf_dbtempcol name="tipo"				type="char"			mandatory="no">
							<cf_dbtempcol name="CFid"				type="numeric" 		mandatory="no">
							<cf_dbtempcol name="Ocodigo"  			type="int"			mandatory="no">
							<cf_dbtempcol name="Dcodigo"  			type="int"			mandatory="no">
							<cf_dbtempcol name="montores"			type="float"		mandatory="no">
							<cf_dbtempcol name="vpresupuesto"  		type="int"			mandatory="no">
							<cf_dbtempcol name="BMfechaalta"		type="datetime"   	mandatory="no">
							<cf_dbtempcol name="BMUsucodigo"		type="numeric" 		mandatory="no">
							<cf_dbtempcol name="RHPPid"				type="numeric" 		mandatory="no">
							<cf_dbtempcol name="Periodo"  			type="int"			mandatory="no">
							<cf_dbtempcol name="Mes"  				type="int"			mandatory="no">
							<cf_dbtempcol name="valor2"				type="varchar(100)"	mandatory="no">
							<cf_dbtempcol name="CSid"				type="numeric" 		mandatory="no">
							<cf_dbtempcol name="procesado"			type="int" 			mandatory="no">
							<cf_dbtempcol name="insertado"			type="int" 			mandatory="no">
							<cf_dbtempcol name="SB_INC"				type="float"		mandatory="no"><!--- Salario base para incidencias --->
							<cf_dbtempcol name="CFidOrigen"			type="numeric" 		mandatory="no"><!--- Centro  funcional origen --->
							<cf_dbtempcol name="montoresORI"		type="float"		mandatory="no"><!--- monto origen  --->
							<cf_dbtempcol name="porcentajeAPL"		type="money"		mandatory="no"><!--- porcentaje de aplicaciÃ³n  --->
							<cf_dbtempcol name="tipod"				type="varchar(25)"	mandatory="no">
							<cf_dbtempcol name="montoorigen" 		type="float" 		mandatory="no">
							<cf_dbtempindex cols="RCNid,referencia,Mes,Periodo">
							<cf_dbtempindex cols="RCNid,Mes,Periodo">
						</cf_dbtemp> 	  				
	</cffunction>
	
	<!--- se encarga de llenar una tabla de porcentajes de Cargas patronales por centro funcional de cada empleado para posteriormente distribuir---->		
	<cffunction name="LlenarTablePorceCF" access="public">
			<cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">	
			<cfargument name="RCNid" type="numeric" required="yes">			
			<!--- Se limpia la Tabla Temporal --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
				delete from  #PorcDistrCargas#
			</cfquery>	
			
		   <!--- anteriormente se separaron positivos de negativos para obtener los montos totales de cada elemento--->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			INSERT INTO #PorcDistrCargas# (Ecodigo,RCNid,DEid, CFid, montores)
			SELECT Ecodigo, RCNid,DEid, CFid, sum(montores)
					FROM RCuentasTipo 
					WHERE montores > 0
					and tiporeg in (10,11,20,21)
					and RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			GROUP BY Ecodigo, RCNid,DEid, CFid
		   </cfquery>	   
			
				<cfif debug>
					<cf_dumptable var="#PorcDistrCargas#" abort="false">
				</cfif>	
			
			<cfquery datasource="#arguments.conexion#" name="rscopiar"><!--- borra aquellos montos que son negativos---->
			DELETE FROM #PorcDistrCargas# 
			WHERE montores < = 0
			</cfquery>
			
				<cfif debug>
					<cf_dumptable var="#PorcDistrCargas#" abort="false">
				</cfif>	
				
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			UPDATE #PorcDistrCargas# 
			
			SET montototal= coalesce(
							(select sum(montores)
							from #PorcDistrCargas# a
							where #PorcDistrCargas#.DEid= a.DEid
							),0)
			</cfquery>
			<cfquery datasource="#arguments.conexion#" name="rscopiar">		<!--- Se eliminan los registros donde la Distribucion no se da porcentajeCF = 1--->
			DELETE FROM #PorcDistrCargas# 
			WHERE montores = montototal
			</cfquery>
				<cfif debug>
					<cf_dumptable var="#PorcDistrCargas#" abort="false">
				</cfif>		
			<!--- Se establecen el Factor de Distribucion por Empleado  y Centro Funcional--->	
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
				update  #PorcDistrCargas#
				set porcentajeCF= montores/montototal
			</cfquery>	
				<cfif debug>
					<cf_dumptable var="#PorcDistrCargas#" abort="false">
				</cfif>	
				
	</cffunction>
	
	<!---- a partir de la tabla de distribucion obtenida en la fucion "LlenarTablePorceCF" se procede a llenar la tabla de con la nueva distribucion de Cargas Patronales--->
	<cffunction name="LlenarTemporalDistribucion" access="public">
			<cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">	
			<cfargument name="RCNid" type="numeric" required="yes">			
			<!--- ***************** --->
			<!--- INSERTA SALARIOS  --->
			<!--- ***************** --->
	
			<!--- Se limpia la Tabla Temporal --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
				delete from  #DistrCargasCF#
			</cfquery>	
			
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into #DistrCargasCF# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
											BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
											Mes,CSid,procesado,insertado,tipod)
				select 
					a.RCTid, 
					a.RCNid, 
					a.Ecodigo, 
					a.tiporeg, 
					cf.CFcuentac as cuenta, 
					coalesce(( select ec.valor2 
					   from CFExcepcionCuenta ec
					   where ec.CFid=decs.CFid 
						 and ec.valor1=a.valor2 ), a.valor2),
					a.valor2, 
					a.Cformato, 
					a.Ccuenta, 
					a.CFcuenta, 
					a.tipo, 
					decs.CFid,
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					a.montores *(decs.porcentajeCF) as montores, 
					a.montores  as montoresORI, 
					(decs.porcentajeCF*100) as DECSporcentaje, 
					1,
					a.BMfechaalta, 
					a.BMUsucodigo, 
					a.DEid, 
					a.RHPPid, 
					a.referencia, 
					a.vpresupuesto, 
					a.Periodo, 
					a.Mes,
					null,
					1,
					0,
					'CARGAS PATRONALES'
				from RCuentasTipo a
				  inner join #PorcDistrCargas# decs
						on   a.DEid 	= decs.DEid
						and  a.RCNid	= decs.RCNid 
						and  a.Ecodigo 	= decs.Ecodigo    
				  inner join CFuncional cf
						on 	decs.CFid 		= cf.CFid						
						and decs.Ecodigo 	= cf.Ecodigo 
				where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tipo = 'D'
				and   tiporeg in (30,31,40,41)
			</cfquery>
	</cffunction>
	
	
	<!--- esta función se encarga de balancear las diferencias de la distribución debido a la precision en decimales,
	agregando al maximo de cada distribucion la diferencia sumada---->
	<cffunction name="BalancearTemporarlDistribucion" access="public">
			<cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">	
			<cfargument name="RCNid" type="numeric" required="yes">			

		<cfquery datasource="#arguments.conexion#" name="rscopiar"> <!---redondea los montos de las cargas distribuidas a 2 decimales--->
				UPDATE #DistrCargasCF#
				SET montores = round(montores,2)
		</cfquery>
		
		<cfquery datasource="#arguments.conexion#" name="rscopiar"> <!---suma al ultimo registro de los grupos de DEid, referencia la diferencia con respecto a montoresORI (el cuál posee la suma total)--->
				UPDATE #DistrCargasCF#
				SET montores = montores + (montoresORI - (Select coalesce(sum(montores),0)
														 from #DistrCargasCF# dc
														 Where #DistrCargasCF#.DEid= dc.DEid
														 and #DistrCargasCF#.referencia= dc.referencia
														 and #DistrCargasCF#.RCNid= dc.RCNid)
														 
														 )
				Where id in (Select Max(rct.id)
								from #DistrCargasCF# rct
								Where #DistrCargasCF#.referencia= rct.referencia
								and #DistrCargasCF#.DEid=rct.DEid
								and #DistrCargasCF#.RCNid=rct.RCNid
								group by rct.referencia, rct.DEid, rct.RCNid)
		</cfquery>	
	</cffunction>
	
	<!--- esta función se encarga de sustituir en la tabla de RCuentasTipo los resultados de distribución calculados durante todo el proceso 
	y que se encuentran en la tabla temporal de distribución---->
	<cffunction name="SustituirRegistros" access="public">
			<cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">	
			<cfargument name="RCNid" type="numeric" required="yes">	
	
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
				delete 
				from RCuentasTipo
				Where RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and exists (Select 1
							from #DistrCargasCF# b
							Where RCuentasTipo.RCTid=b.RCTidREF
							and RCuentasTipo.RCNid=b.RCNid)
			</cfquery>
			
			<!--- inserta las cargas Patronales  ya distribuidas  en RCuentasTipo--->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			  insert into RCuentasTipo (  RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, 
											BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			   select 
					RCNid, 
					Ecodigo, 
					tiporeg, 
					cuenta, 
					valor,
					valor2,
					Cformato, 
					Ccuenta, 
					CFcuenta, 
					tipo, 
					CFid, 
					Ocodigo, 
					Dcodigo, 
					montores, 
					BMfechaalta, 
					BMUsucodigo, 
					DEid, 
					RHPPid, 
					referencia, 
					vpresupuesto, 
					Periodo, 
					Mes
				from #DistrCargasCF#
				where RCNid	= #arguments.RCNid#
			</cfquery>				
	</cffunction>

</cfcomponent>