<cfcomponent>
	<cffunction name="calcularFactorMonto" access="public" returntype="string" >
		<cfargument name="periodo" 		type="numeric" required="yes">
		<cfargument name="monto" 		type="string" required="yes">		
		<cfargument name="DSN" 			type="string" required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">

		<!--- 1. obtiene el total de dias en al asociacion de todos los empleados (sumatoria) --->
		<cfquery name="rs_total_dias" datasource="#arguments.DSN#">
			select coalesce(sum(ACDDdias), 0) as total
			from ACDistribucionDividendos
			where ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
		<!--- 2. calculo del factor monto --->
		<cfif len(trim(rs_total_dias.total)) eq 0 or rs_total_dias.total eq 0 >
			<cfreturn >
		</cfif>

		<cfset factor_monto = arguments.monto/rs_total_dias.total >
		<cfreturn factor_monto >
		
	</cffunction>

	<!---	RESULTADO
			Realiza el proceso de distribucion de excedentes para cada uno de los asociados.
				1. Inserta el encabezado para los calculos
				2. Inserta todos los asociados y les calcula los dias que estuvieron como asociados durante el periodo
				3. Calcula el factor monto
				4. Realiza el calculo del monto que le corresponde a cada asociado
	--->
	<cffunction name="calcular" access="public" >
		<cfargument name="periodo" 		type="numeric" required="yes">
		<cfargument name="monto" 		type="string" required="yes">
		<cfargument name="BMUsucodigo"	type="string" required="no" default="#session.Usucodigo#">
		<cfargument name="DSN" 			type="string" required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">
		
		<!--- 1. Fechas de inicio y fin del periodo --->
		<cfset fecha_inicio = createdate(arguments.periodo, 1, 1) >
		<cfset fecha_final  = createdate(arguments.periodo, 12, 31) >
		
		<!--- 2. Tabla temporal para manejar los cortes de la linea del tiempo del asociado --->
		<cf_dbtemp name="Fechas" returnvariable="Fechas" datasource="#Arguments.DSN#">
			<cf_dbtempcol name="ACAid" 			type="numeric" 	mandatory="yes"	>
			<cf_dbtempcol name="ACLTAfdesde" 	type="datetime"	mandatory="yes">
			<cf_dbtempcol name="ACLTAfhasta" 	type="datetime" mandatory="yes">
		</cf_dbtemp>
		
		<!--- 3. Inserta los cortes de la linea del tiempo de los asociados, pero solo los
			     que incluyan el periodo que se esta procesando
		--->
		<cfquery datasource="#arguments.DSN#">
			insert into #Fechas#( ACAid, ACLTAfdesde, ACLTAfhasta )
			select lta.ACAid, lta.ACLTAfdesde, lta.ACLTAfhasta
			from ACLineaTiempoAsociado lta, ACAsociados a, DatosEmpleado de
			where <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_inicio#"> <= lta.ACLTAfhasta
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_final#"> >= lta.ACLTAfdesde 
			 and a.ACAid = lta.ACAid
			 and de.DEid=a.DEid
			 and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			 and a.ACAestado=1 <!--- solo socios activos--->
			order by lta.ACLTAfdesde
		</cfquery>

		<!--- 4. Elimina los cortes que no corresponden al ultimo corte del empleado en el periodo. 
				 Osea se va a trabajar con el ultimo periodo de ingreso a la asociacion en el periodo.
				 Ej:
				 	Para el socio 1 estan los siguientes cortes en el periodo:
						1. 25/10/2006 - 03/03/2007
						2. 01/06/2007 - 30/08/2007
						3. 15/09/2007 - 01/01/6100
						
					Si estamos procesando el periodo 2007 , estos calzan en este periodo, pero el corte valido es el ultimo
					del periodo, en este caso el 3, del 15/09/2007 - 01/01/6100
		--->
		<cfquery datasource="#arguments.DSN#">
			delete from #Fechas#
			where ACLTAfdesde < ( 	select max(a.ACLTAfdesde) 
									from #Fechas# a 
									where a.ACAid = #Fechas#.ACAid )
		</cfquery>
		
		<!--- 5. Existencia de registro para el periodo/empresa --->
		<cfquery name="rs_existe_calculo" datasource="#arguments.DSN#">
			select ACDDEestado as estado
			from ACDistribucionDividendosE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
		</cfquery>
		<cfif rs_existe_calculo.estado eq 3 >
			<cfthrow detail="Error. No se puede realizar el proceso de Distribuci&oacute;n de Excedentes, el proceso ya fue calculado y aplicado.">
		</cfif>
		
		<!--- 6. Elimina los datos, si los hay, pues va a recalcular --->
		<cfquery datasource="#arguments.DSN#">
			delete from ACDistribucionDividendos 
			where ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfquery datasource="#arguments.DSN#">
			delete from ACDistribucionDividendosE 
			where ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<!--- 7. inserta informacion de la distribucion: Periodo y Monto. Solo si no lo ha creado --->
		<cfquery datasource="#arguments.DSN#" >
			insert into ACDistribucionDividendosE( ACDDEperiodo, Ecodigo, ACDDEmonto, BMUsucodigo, BMfecha )
			values( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#arguments.monto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
		</cfquery>

		<!--- 8. inserta informacion de los empleados que estan en al linea del tiempo para el periodo dado --->
		<cfquery datasource="#arguments.DSN#" >
			insert into ACDistribucionDividendos( ACAid, ACDDEperiodo, Ecodigo, ACDDdias, BMUsucodigo, BMfecha )
			select lta.ACAid,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
				   sum(abs(datediff( <cfif Application.dsinfo[session.DSN].type eq 'oracle'>'dd'<cfelse>dd</cfif>,
							case when lta.ACLTAfdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_inicio#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_inicio#"> else lta.ACLTAfdesde end,
							case when <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> <  <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_final#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> else <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_final#"> end)))+1 as dias,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">									 
								  
			from #Fechas# lta, ACAsociados a, DatosEmpleado de
			
			where a.ACAid=lta.ACAid
			 and de.DEid = a.DEid
			 and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_inicio#"> <= lta.ACLTAfhasta
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_final#"> >= lta.ACLTAfdesde 
			 and a.ACAestado = 1
			
			group by lta.ACAid
		</cfquery>
		
		<!--- 9. calcula el factor/monto--->
		<cfset fm = calcularFactorMonto(arguments.periodo, arguments.monto) >
		<cfif len(trim(fm)) eq 0 ><cfset fm = 0 ></cfif>
		
		<!--- 10. Actualiza la tabla de Distribucion, para poner el monto correspondiente a cada empleado
				 Este monto corresponde al factor monto multiplicado por la cantidad de dias del empleado.
		--->
		<cfquery datasource="#arguments.DSN#">
			update ACDistribucionDividendos
			set ACDDmonto = ACDDdias * <cfqueryparam cfsqltype="cf_sql_float" value="#fm#">
			where ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

	</cffunction>
	
	<!---	RESULTADO
			Marca como aplicado el proceso de distribucion de excedentes para el periodo dado
	--->
	<cffunction name="aplicar" access="public" >
		<cfargument name="periodo" 		type="numeric" required="yes">
		<cfargument name="BMUsucodigo"	type="string" required="no" default="#session.Usucodigo#">
		<cfargument name="DSN" 			type="string" required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">

		<!--- 1. Modifica la tabla de encabezado --->
		<cfquery datasource="#arguments.DSN#">
			update ACDistribucionDividendosE
			set ACDDEestado = 2
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
		</cfquery>

		<!--- 2. Modifica la tabla de detalles --->
		<cfquery datasource="#arguments.DSN#">
			update ACDistribucionDividendos
			set ACDDestado = 2
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
		</cfquery>

		<!--- 3. Mueve el parametro de periodo al siguiente periodo (arguments.periodo+1) --->
		<!---
		<cfquery datasource="#arguments.DSN#">
			update ACParametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.periodo+1#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and Pcodigo = 10
		</cfquery>

		<!--- 4. Mueve el parametro de mes al primer mes del nuevo periodo --->		
		<cfquery datasource="#arguments.DSN#">
			update ACParametros
			set Pvalor = 1
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and Pcodigo = 20
		</cfquery>
		--->

	</cffunction>
</cfcomponent>