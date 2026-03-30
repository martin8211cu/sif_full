
<html>
<title>Indicadore de Capacitacion</title>
<script src="/cfmx/Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<body style="margin:0">
<cfprocessingdirective suppresswhitespace="yes">
<!---0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
<!--- tabla d epintado principal --->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="periodo" 					type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes" 						type="int"  	mandatory="yes">
	<cf_dbtempcol name="llave" 						type="varchar(50)" 	mandatory="yes">
	<cf_dbtempcol name="total_empleados"			type="float"	mandatory="yes">
	<cf_dbtempcol name="total_horas_programadas"	type="float"	mandatory="yes">
	<cf_dbtempcol name="total_horas_reales"			type="float"	mandatory="yes">
	<cf_dbtempcol name="total_emp_capacitados"		type="int"		mandatory="yes">
	<cf_dbtempcol name="total_gasto_capacitacion"	type="float"	mandatory="yes">
</cf_dbtemp>
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!----Variables---->
		<cfset inicio_mes = createdate(p, m, 1) >
		<cfset fin_mes    = createdate(p, m, daysinmonth(inicio_mes)) >
		<!--- 1.Calculo total empleados al inicio de cada mes  --->
		<cfquery datasource="#session.DSN#" name="rs_total">
			select coalesce(count(1), 0) as empleados
			from LineaTiempo lt			
				inner join RHPlazas p
					on p.RHPid=lt.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					<cfif isdefined("url.dependencias")>
						or cf.CFpath like '#rs_path.path#%'
					</cfif>
					)
				</cfif>			
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> between lt.LTdesde and lt.LThasta
		</cfquery>			
		<!--- 2. Busca las horas programadas --->
		<cfquery name="rsHrsProgramadas" datasource="#session.DSN#">
			select coalesce(sum(b.RHDChoras),0) as hrsProgramadas
			from RHEmpleadoCurso a
				inner join RHDiasCurso b
					on a.RHCid = b.RHCid
					and b.RHDCactivo = 1
					and  b.RHDCfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#">
				<!----Filtro de centro funcional---->
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>					
					inner join LineaTiempo c
						on a.DEid = c.DEid
						and b.RHDCfecha between  c.LTdesde and c.LThasta
					 inner join RHPlazas p
						on p.RHPid=c.RHPid				
					inner join CFuncional cf
						on cf.CFid=p.CFid						
						and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
								<cfif isdefined("url.dependencias")>
									or cf.CFpath like '#rs_path.path#%'
								</cfif>
							)
				</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!----3. Busca las horas reales de capacitacion---->
		<cfquery name="rsHrsReales" datasource="#session.DSN#">
			select coalesce(sum(a.RHAChoras),0) as hrsReales
			from RHAsistenciaCurso a
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					inner join LineaTiempo c
						on a.DEid = c.DEid
						and a.RHACdia  between  c.LTdesde and c.LThasta
					 inner join RHPlazas p
						on p.RHPid=c.RHPid				
					inner join CFuncional cf
						on cf.CFid=p.CFid						
						and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
								<cfif isdefined("url.dependencias")>
									or cf.CFpath like '#rs_path.path#%'
								</cfif>
							)
				</cfif>
			where a.RHACdia between <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#">		
		</cfquery>
		<!---4. Busca gasto de capacitacion---->
		<cfquery name="rsGasto" datasource="#session.DSN#">			
			select coalesce(sum(RHECtotempresa+RHECtotempleado),0) as gasto
			from RHEmpleadoCurso a
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					inner join LineaTiempo c
						on a.DEid = c.DEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= c.LThasta
						and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#">	>= c.LTdesde
					 inner join RHPlazas p
						on p.RHPid=c.RHPid				
					inner join CFuncional cf
						on cf.CFid=p.CFid						
						and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
								<cfif isdefined("url.dependencias")>
									or cf.CFpath like '#rs_path.path#%'
								</cfif>
							)
				</cfif>			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= a.RHECfhasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= a.RHECfdesde
				<!----En la moneda de la empresa para no sumar papas con chayotes......---->
				and a.idmoneda = (select Mcodigo 
									from Empresas b
									where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									)
		</cfquery>
		<!----5.Busca los empleados capacitados--->
		<cfquery name="rsCapacitados" datasource="#session.DSN#">			
			select coalesce(count(distinct a.DEid),0) as EmpleadosCap
			from RHEmpleadoCurso a
				inner join RHDiasCurso b
					on a.RHCid = b.RHCid
					and b.RHDCactivo = 1
					and  b.RHDCfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#">
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					inner join LineaTiempo c
						on a.DEid = c.DEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= c.LThasta
						and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#">	>= c.LTdesde
					 inner join RHPlazas p
						on p.RHPid=c.RHPid				
					inner join CFuncional cf
						on cf.CFid=p.CFid						
						and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
								<cfif isdefined("url.dependencias")>
									or cf.CFpath like '#rs_path.path#%'
								</cfif>
							)
				</cfif>			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!----6. Inserta los datos para el periodo/mes en la tabla principla---->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, llave, total_empleados, total_horas_programadas, total_horas_reales, total_gasto_capacitacion, total_emp_capacitados)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#p#_#m#">,
					<cfif rs_total.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">, 
					<cfelse>
						0,
					</cfif>
					<cfif rsHrsProgramadas.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsProgramadas.hrsProgramadas#">, 
					<cfelse>
						0,
					</cfif>
					<cfif rsHrsReales.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsReales.hrsReales#">,
					<cfelse>
						0,
					</cfif>
					<cfif rsGasto.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsGasto.gasto#">,
					<cfelse>
						0,
					</cfif>
					<cfif rsCapacitados.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCapacitados.EmpleadosCap#">
					<cfelse>
						0
					</cfif>
					)
		</cfquery>		
	</cfloop>
</cfloop>
<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select periodo, mes, llave, total_empleados, total_horas_programadas, total_horas_reales, total_gasto_capacitacion,total_emp_capacitados
	from #tbl_principal#
	order by periodo, mes
</cfquery>

<!---Datos de periodo/mes--->
<cfquery name="rsPeriodoMes" datasource="#session.DSN#">
	select distinct periodo
	from  #tbl_principal#
	order by periodo
</cfquery>
<cfsavecontent variable="LvarXML" >
	<data>
		<!----Columnas de datos (Hrs reales, Hrs Programadas, Gasto, etc)--->
		<variable name="<cfoutput>#xmlformat('DatosPeriodoMes')#</cfoutput>">
			<cfoutput query="rs_datos">
				<row>
					<column>#xmlformat(rs_datos.llave)#</column>
					<column>#xmlformat(rs_datos.periodo)#</column>
					<column>#xmlformat(rs_datos.mes)#</column>
					<cfif rs_datos.total_empleados EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_empleados)#</column></cfif> 						
					<cfif rs_datos.total_horas_reales EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_horas_reales)#</column></cfif> 
					<cfif rs_datos.total_horas_programadas EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_horas_programadas)#</column></cfif>
					<cfif rs_datos.total_gasto_capacitacion EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_gasto_capacitacion)#</column></cfif>
					<cfif rs_datos.total_emp_capacitados EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_emp_capacitados)#</column></cfif>																			
				</row>
			</cfoutput>
		</variable>
		<!----Datos de etiquetas de seleccion de años--->
		<cfoutput><variable name="#xmlformat('PeriodosSeleccion')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<!----Datos del periodo para el grafico pastel--->
		<cfoutput><variable name="#xmlformat('PeriodosPastel')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<!----Datos de las llaves para los indicadores--->
		<cfoutput><variable name="#xmlformat('LLavesIndicadores')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C1</column></row>
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C2</column></row>
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C3</column></row>
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C4</column></row>
			</cfoutput>
		</variable>		
	</data>
</cfsavecontent>
</cfprocessingdirective>

<!--- 
	El nombre del archivo XML debe ser unico, formado con la combinación de llaves que hacen a la información única,
	para que todos los usuarios que ven el archivo con la misma combinación de llaves vean la misma informacion
	En este caso la combinación es el IdEmpleado con el IdPuesto
--->
	<cfset irA = "/cfmx/rh/indicadores/capacitacion/ind-capacitacion.cfm?Detalle=1">
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset irA = irA & "&CFid=#url.CFid#">
	</cfif>
	<cfif isdefined("url.dependencias")>
		<cfset irA = irA & "&dependencias=#url.dependencias#">
	</cfif>
	<cfif isdefined("Detalle")>
		<cfinclude template="ind-capacitacion-detalle.cfm">
	<cfelse>
		<cf_viewFlash 
			movie = "capacitacion" 
			XMLfilename = "capacitacion2008_#session.Usucodigo#" 
			XMLvalue = "#LvarXML#"
			irA = "#irA#"
			path = "rh/indicadores/capacitacion" 
		>
	</cfif>
</body>
</html>
