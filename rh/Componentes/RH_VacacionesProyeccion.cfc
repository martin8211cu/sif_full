<cfcomponent hint="Realiza el cálculo de Nómina en relacion a las Cargas Obrero Patronales">
<!--- Creación de componente para el cálculo  de Proyeccion de Vacaciones
Este "Desarrollo para el cálculo de la “proyección y acreditación” de Días de Vacaciones tomando en cuenta los cortes en la Línea del Tiempo" se realizó para 
el cliente BNvital
En resumen el desarrollo se realiza para permitir al sistema las siguientes funcionalidades:
1)	Tomar en cuenta cada corte en la línea del tiempo que contenga un cambio de régimen.
2)	Calcular el proyectado por cada tracto que esté incluido en el periodo de cálculo
3)	Calcular los días de asignación de vacaciones según lo que fue proyectado en cada tracto.

DESARROLLO
Este desarrollo suplanta el antiguo cálculo del proyectado (soporte clientes viejos) sino que debe apegarse el Parámetro: tab Nomina -> "Proyectar Vacaciones según cortes en Línea de Tiempo"
--->
<!--- Autor Frederick Castro--->
<!--- Marzo del 2012 --->


<!---►►►►►►►METODO PRINCIPAL◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄--->
<!---►►►►►►►PARA CALCULO DE  ◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄--->
<!---►►►►►►►PROYECCION DE VACACIONES  ◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄◄--->

	<cffunction name="calcularProyectado" access="public" returntype="query">	<!--- calcula las proyecciones---->
	    <cfargument name="datasource" 			type="string" 	    required="yes"  default="#session.dsn#"  	hint="Nombre del Datasource de Coldfusion">
		<cfargument name="Ecodigo" 				type="numeric" 	    required="yes"  default="#session.Ecodigo#"  hint="Codigo Interno de la empresa">
		<cfargument name="IdsEmpleados" 		type="string"	    required="yes"    							hint="String de Ids de los empleados"><!--- recibe un string con la lista de empleados SEPARADA por comas(,)--->
		<cfargument name="fechaLimitaSuperior" 	type="date"	        required="no"  default="#createdate(year(now()),month(now()),day(now()))#"  hint="Limite de fecha Superior"><!--- recibe un string con la lista de empleados SEPARADA por comas(,)--->
		<cfargument name="totalizado"			type="boolean"	    required="no"  default="no">
		<cfargument name="Debug" 				type="boolean"	    required="no"  default="no">

		<cfset arguments.fechaLimitaSuperior=createdate(year(fechaLimitaSuperior),month(fechaLimitaSuperior),day(fechaLimitaSuperior))><!---se formatea la fecha para distintas suite BD--->

		<!--- crea las tablas temporales para almacenar la tabla de distribucion y el resultado final de distribucion--->
		<cfinvoke method="CrearTablasTemp">
				<cfinvokeargument name="datasource" value="#Arguments.datasource#">
		</cfinvoke>		

		<!--- obtener los distintos regimenes del empleado(s) desde la ultima fecha de vacaciones hasta ahora--->
		<cfquery datasource="#arguments.datasource#" name="regimenes">
		
		    insert into	#temp_ProyeccionesVacaciones# (DEid, regimen,fechaDesde, fechaHasta,fechaAntiguedad,fechaUltimaVaca,annos)
			select lt.DEid, lt.RVid, lt.LTdesde,lt.LThasta, (select ev.EVfantig
															from EVacacionesEmpleado ev
															where ev.DEid=lt.DEid) as fechaAntiguedad,
												
															(select case when <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaLimitaSuperior#"> < ev.EVfecha
																	   then <cf_dbfunction name="dateadd" args="-1, ev.EVfecha ,YYYY"> <!--- en el caso que la fecha de EVfecha sea mayor a la fecha a la liquidaccion se devuelve un año --->
																	 else
																	   ev.EVfecha 
																	 end 
															from EVacacionesEmpleado ev
															where ev.DEid=lt.DEid) as fechaUltimaVaca,
															
															(select <cf_dbfunction name="datediff" args="ev.EVfantig, #arguments.fechaLimitaSuperior#,yyyy">
															from EVacacionesEmpleado ev
															where ev.DEid=lt.DEid) as annos
			from LineaTiempo lt
			
			where LThasta >= (select case when <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaLimitaSuperior#"> < ev.EVfecha
									   then <cf_dbfunction name="dateadd" args="-1, ev.EVfecha ,YYYY"><!--- en el caso que la fecha de EVfecha sea mayor a la fecha a la liquidaccion se devuelve un año --->
									 else
									   ev.EVfecha 
									 end  
							  from EVacacionesEmpleado ev
							  where ev.DEid=lt.DEid)
			and   LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaLimitaSuperior#"> 					
								
			and lt.DEid in (#IdsEmpleados#)		
			
		</cfquery>
		<cfif debug >
			<cfoutput>fechaLimiteSuperior: #arguments.fechaLimitaSuperior#<br></cfoutput>
			<cfoutput>obtener los distintos regimenes del empleado desde la ultima fecha de vacaciones hasta ahora</cfoutput>
			<cfquery datasource="#arguments.datasource#" name="deb" maxrows="10">
				select* from #temp_ProyeccionesVacaciones# order by DEid, fechaDesde
			</cfquery><cfdump var="#deb#">
		</cfif>
		
		<!--- ajustar la fechaDesde y fechaHasta del empleado a las fecha debida: 
		- Las fechas deben empezar como mínimo desde la ultima vez que cumplieron anualidad
		- la fecha hasta no debe exceder la fecha superior --->
		<cfquery datasource="#arguments.datasource#">
			update #temp_ProyeccionesVacaciones# 
			set fechaDesde=fechaUltimaVaca
			where fechaDesde < fechaUltimaVaca
		</cfquery>
		<cfquery datasource="#arguments.datasource#">
			update #temp_ProyeccionesVacaciones# 
			set fechaHasta = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaLimitaSuperior#"> 	
			where fechaHasta > <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaLimitaSuperior#"> 	
		</cfquery>
		
		<cfif debug >
			<cfoutput>obtener las fechas de los cortes</cfoutput>
			<cfquery datasource="#arguments.datasource#" name="deb" maxrows="10">
				select* from #temp_ProyeccionesVacaciones# order by DEid, fechaDesde
			</cfquery><cfdump var="#deb#">
		</cfif>
		
		
		<!--- obtiene la cantidad de dias que se van a otorgar al empleado segun el tipo de regimen y el detalle entre años--->
		<cfquery datasource="#arguments.datasource#">
			update #temp_ProyeccionesVacaciones# 
				set dias=coalesce((select coalesce(rv.DRVdias, 0) 
								from DRegimenVacaciones rv 
								where rv.RVid =  #temp_ProyeccionesVacaciones#.regimen
			 					 and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
													from DRegimenVacaciones rv2 
								 					where rv2.RVid =  #temp_ProyeccionesVacaciones#.regimen
								   					and rv2.DRVcant <= #temp_ProyeccionesVacaciones#.annos
												   ) 
							   	)
							 ,0) ,							 
					diasAdicionales = coalesce((select coalesce(rv.DRVdiasadic, 0) 
								from DRegimenVacaciones rv 
								where rv.RVid =  #temp_ProyeccionesVacaciones#.regimen
			 					 and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
													from DRegimenVacaciones rv2 
								 					where rv2.RVid =  #temp_ProyeccionesVacaciones#.regimen
								   					and rv2.DRVcant <= #temp_ProyeccionesVacaciones#.annos
												   ) 
							   	) 
							 ,0) ,
					diasEnfermedad = coalesce((select coalesce(rv.DRVdiasenf, 0) 
								from DRegimenVacaciones rv 
								where rv.RVid =  #temp_ProyeccionesVacaciones#.regimen
			 					 and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
													from DRegimenVacaciones rv2 
								 					where rv2.RVid =  #temp_ProyeccionesVacaciones#.regimen
								   					and rv2.DRVcant <= #temp_ProyeccionesVacaciones#.annos
												   ) 
							   	)
							 ,0)		
							 
			</cfquery>	
			<cfif debug >	
			<cfoutput>obtiene la cantidad de dias que se van a otorgar al empleado segun el tipo de regimen y el detalle entre años</cfoutput>
			<cfquery datasource="#arguments.datasource#" name="deb" maxrows="10">
				select* from #temp_ProyeccionesVacaciones# order by DEid, fechaDesde
			</cfquery><cfdump var="#deb#">

		</cfif>

		
		<!--- se obtienela cantidad de meses entre las fechas desde y hasta, tomando en cuenta la cantida de dias entre 30. Esto para un dato mas preciso de los meses--->
		<cfquery datasource="#arguments.datasource#">
			update #temp_ProyeccionesVacaciones# 
			set meses=coalesce(((<cf_dbfunction name="datediff"	args="fechaDesde, fechaHasta,dd">)/30.0),0)
		</cfquery>
		<cfif debug >
			<cfoutput>obtener la cantidad de meses entre las fechas desde y hasta, tomando en cuenta la cantida de dias entre 30. Esto para un dato mas preciso</cfoutput>
			<cfquery datasource="#arguments.datasource#" name="deb" maxrows="10">
				select* from #temp_ProyeccionesVacaciones# order by DEid, fechaDesde
			</cfquery><cfdump var="#deb#">
		</cfif>
				
		<!--- Obteniendo el monto maximo de dias del empleado --->
		<cfquery datasource="#arguments.datasource#" name="Proyectado">
			update #temp_ProyeccionesVacaciones# 
			set   MaximoDias  = (
								select max(dias)
								from #temp_ProyeccionesVacaciones# a
								where a.DEid=#temp_ProyeccionesVacaciones#.DEid 
								)  
								
		</cfquery>
		<!--- se consulta el parametro que indica que si se debe de redondear el proyectado--->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#arguments.datasource#" ecodigo="#arguments.Ecodigo#" pvalor="600" default="0" returnvariable="vMostrarDecimales"/>
		<cfset cantDec=2>
		<cfif trim(vMostrarDecimales) EQ '1'><cfset cantDec=0></cfif>
		
		<!--- hace el calculo de dias multiplicando la cantidad de meses por los dias otorgados entre 12 --->
		<cfquery datasource="#arguments.datasource#">
			update #temp_ProyeccionesVacaciones# 
			set            dias  = round(((meses* dias)/12),#cantDec#),
			    diasAdicionales  = round(((meses* diasAdicionales)/12),#cantDec#),
    		     diasEnfermedad  = round(((meses* diasEnfermedad)/12) ,#cantDec#)
		</cfquery>
		<cfif debug >
			<cfoutput>hace el calculo de dias multiplicando la cantidad de meses por los dias otorgados entre 12 </cfoutput>
			<cfquery datasource="#arguments.datasource#" name="deb" maxrows="10">
				select* from #temp_ProyeccionesVacaciones# order by DEid, fechaDesde
			</cfquery><cfdump var="#deb#">
		</cfif>
		
		<!--- dado que el componente permite devolver un query con todo el detalle de la cantidad de días por empleado según el regimen, esta opción permite 
		obtener una sumatoria para mostrar como un valor total en el caso que se desea un solo valor
		- Esto funciona para:
			- el total de dias acumulados al momento de calcular las acciones,
			- El total de proyectado para el expediente
		---->
		
		<cfquery datasource="#arguments.datasource#" name="Proyectado">
			
			select DEid, 	max(regimen) as regimen	,
																
							case when max(MaximoDias) < sum(dias) then
								max(MaximoDias)
							else
								sum(dias)
							end as dias, 
							
							case when max(MaximoDias) < sum(diasAdicionales) then
								max(MaximoDias)
							else
								sum(diasAdicionales)
							end as diasAdicionales, 
							
							case when max(MaximoDias) < sum(diasEnfermedad) then
								max(MaximoDias)
							else
								sum(diasEnfermedad)
							end as diasEnfermedad 
							
			from #temp_ProyeccionesVacaciones#
			group by DEid <cfif Arguments.totalizado eq false>, regimen</cfif>
		</cfquery>
		
		<cfreturn #Proyectado#>
	</cffunction>
	
	<cffunction name="CrearTablasTemp" access="public">
		<cfargument name="datasource" type="string" required="yes" default="#session.dsn#">	
			  <cf_dbtemp name="temp_ProyeccionesVacaciones2" returnvariable="temp_ProyeccionesVacaciones" datasource="#Arguments.datasource#">	
					<cf_dbtempcol name="DEid"				type="numeric" 		mandatory="no">			
					<cf_dbtempcol name="regimen"			type="numeric" 		mandatory="no">			
					<cf_dbtempcol name="fechaDesde"			type="date" 		mandatory="no">	
					<cf_dbtempcol name="fechaHasta"			type="date" 		mandatory="no">			
					<cf_dbtempcol name="fechaAntiguedad"	type="date" 		mandatory="no">		
					<cf_dbtempcol name="fechaUltimaVaca"	type="date" 		mandatory="no">		
					<cf_dbtempcol name="dias"				type="float"		mandatory="no">		
					<cf_dbtempcol name="diasAdicionales"	type="float"		mandatory="no">		
					<cf_dbtempcol name="diasEnfermedad"  	type="float"		mandatory="no">		
					<cf_dbtempcol name="meses"				type="float"		mandatory="no">		
					<cf_dbtempcol name="annos"				type="float"		mandatory="no">	
					<cf_dbtempcol name="MaximoDias"			type="float"		mandatory="no">				
			  </cf_dbtemp>
	 </cffunction>
	
</cfcomponent>
