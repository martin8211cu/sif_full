<cfsetting requesttimeout="8600">
<cfinvoke Key="LB_IndicadoresDeNomina" Default="Indicadores de Nomina" returnvariable="LB_IndNomina" component="sif.Componentes.Translate" method="Translate"/>
<html>
<cfoutput><title>#LB_IndNomina#</title></cfoutput>
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
	<cf_dbtempcol name="total_hrs_extra"			type="float"	mandatory="yes">
	<cf_dbtempcol name="total_hrs_efectivas"		type="float"	mandatory="yes">
	<cf_dbtempcol name="total_salarios"				type="float"	mandatory="yes">
	<cf_dbtempcol name="total_empleados"			type="float"	mandatory="yes">
</cf_dbtemp>
<!----Temporal de trabajo para hrs efectivas laboradas--->
<cf_dbtemp name="tbl_hrsrefectivas" returnvariable="tbl_hrsrefectivas">
	<cf_dbtempcol name="fdesde"		type="date"			mandatory="yes">
	<cf_dbtempcol name="fhasta"		type="date"			mandatory="yes">
	<cf_dbtempcol name="horas" 		type="float"  		mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="yes">
</cf_dbtemp>
<!---0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
	
<!---<cfloop from="#year(now())-1#" to="#year(now())-1#" index="p">
	<cfloop from="1" to="12" index="m">---->
		<!----Variables---->
		<cfset inicio_mes = createdate(p, m, 1) >
		<cfset fin_mes    = createdate(p, m, daysinmonth(inicio_mes)) >				
		<!--- 1. Calculo total empleados al inicio de cada mes  --->
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
		<!--- 2. Busca las horas extra --->
		<cfquery name="rsHrsExtra" datasource="#session.DSN#">						
			select coalesce(sum(ICvalor),0) as hrsExtra
			from RHIndicadoresDetalle a
				inner join HIncidenciasCalculo b
					on a.RHIDllave = b.CIid
					<!----Filtro de centro funcional---->
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>											
						inner join CFuncional cf
							on cf.CFid=b.CFid						
							and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or cf.CFpath like '#rs_path.path#%'
									</cfif>
								)
					</cfif>
				inner join HRCalculoNomina c
					on b.RCNid = c.RCNid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= c.RChasta
					and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= c.RCdesde
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			where a.RHIDtipo = 'C'			<!---Tipo Concepto de pago/incidencia--->
				and a.RHIcodigo = 65		<!---Indice de horas extras----> 	
		</cfquery>		
		<!----3. Busca las horas efectivas (OJO FALTA ver lo de si el dia de la semana corresponde a un dia laboral segun la jornada igual ke el caso del indicador de ausentismo)---->
		<!---3.1 Buscar la jornada en la planificacion de horarios del modulo de marcas--->
		<cfquery name="rsHrsEfectivasPlan" datasource="#session.DSN#">
			insert into #tbl_hrsrefectivas#(fdesde, fhasta, horas, DEid)
			select 	convert(date,b.RHPJfinicio)	 as fdesde,
					convert(date,b.RHPJffinal) as fhasta,
					(datediff(dd,RCdesde, RChasta)*e.RHJhoradiaria) as horas,
					c.DEid as DEid
			from HRCalculoNomina a	
				inner join HSalarioEmpleado c
					on a.RCNid = c.RCNid
				inner join RHPlanificador b
					on c.DEid = b.DEid
					and a.RCdesde <= convert(date,b.RHPJffinal)
					and a.RChasta >= convert(date,b.RHPJfinicio)							

					inner join RHJornadas e
						on b.RHJid = e.RHJid
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#">  <= a.RChasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= a.RCdesde
		</cfquery>		
		<!---3.2 Las fechas ke no estan en la planificacion de horarios buscar la jornada en la linea del tiempo--->
		<cfquery name="rsHrsEfectivasLT" datasource="#session.DSN#">
			insert into #tbl_hrsrefectivas#(fdesde, fhasta, horas, DEid)
			select 	LTdesde as fdesde,
					LThasta as fhasta,						
					(datediff(dd,RCdesde, RChasta)*f.RHJhoradiaria) as horas,
					c.DEid as DEid
			from HRCalculoNomina a	
				inner join HSalarioEmpleado c
					on a.RCNid = c.RCNid
				
				inner join LineaTiempo d
					on c.DEid = d.DEid
					and a.RCdesde <= d.LThasta
					and a.RChasta >= d.LTdesde
					and not exists(select 1
									from #tbl_hrsrefectivas#
									where #tbl_hrsrefectivas#.DEid = d.DEid
										and #tbl_hrsrefectivas#.fdesde <= d.LThasta
										and #tbl_hrsrefectivas#.fhasta >= d.LTdesde
									)
					
					inner  join RHJornadas f
						on d.RHJid = f.RHJid
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= a.RChasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >=  a.RCdesde								
		</cfquery>
		<!---3.3 Obtener el total de horas efectivas--->
		<cfquery name="rsHrsEfectivasTotal" datasource="#session.DSN#">
			select coalesce(sum(horas),0) as hrsEfectivas
			from #tbl_hrsrefectivas#
		</cfquery>
		<!----
		<cfquery name="rsHrsEfectivas" datasource="#session.DSN#">						
			select 	coalesce(sum(<cf_dbfunction name="datediff" args="RCdesde, RChasta">
								* (case when e.RHJhoradiaria is not null then 
										e.RHJhoradiaria 
									else f.RHJhoradiaria end)
								)							
							,0) as hrsEfectivas
			from HRCalculoNomina a	
				inner join HSalarioEmpleado c
					on a.RCNid = c.RCNid
				<!---Verificar en el planificador de jornadas---->
				left outer join RHPlanificador b
					on c.DEid = b.DEid
					and a.RCdesde <= <cf_dbfunction name="to_date" args="b.RHPJffinal"> 
					and a.RChasta >= <cf_dbfunction name="to_date" args="b.RHPJfinicio"> 
					
					left outer join RHJornadas e
						on b.RHJid = e.RHJid
				<!---Verificar en la linea del tiempo---->
				left outer join LineaTiempo d
					on c.DEid = d.DEid
					and a.RCdesde <= d.LThasta
					and a.RChasta >= d.LTdesde
					
					left outer join RHJornadas f
						on d.RHJid = f.RHJid
					
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						 inner join RHPlazas p
							on p.RHPid=d.RHPid				
						inner join CFuncional cf
							on cf.CFid=p.CFid						
							and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or cf.CFpath like '#rs_path.path#%'
									</cfif>
								)
					</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= a.RChasta	
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= a.RCdesde	
		</cfquery>	
		---->	
		<!---4. Busca monto sumatoria de los salarios---->
		<cfquery name="rsSalarios" datasource="#session.DSN#">			
			select coalesce(sum(SEliquido),0) as Salarios
			from HSalarioEmpleado a
				inner join CalendarioPagos cp
					on a.RCNid = cp.CPid
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					inner join LineaTiempo c
						on a.DEid = c.DEid
						and cp.Ecodigo = c.Ecodigo
						and cp.CPfpago between c.LTdesde and c.LThasta	
					inner join RHPlazas d
						on c.RHPid = d.RHPid
					inner join CFuncional e
						on d.CFid = e.CFid
						and ( e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
								<cfif isdefined("url.dependencias")>
									or e.CFpath like '#rs_path.path#%'
								</cfif>
							)
				</cfif>
		</cfquery>		
		<!----5. Inserta los datos para el periodo/mes en la tabla principla---->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, llave, total_hrs_extra, total_hrs_efectivas, total_salarios,total_empleados)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#p#_#m#">,
					<cfif isdefined("rsHrsExtra") and rsHrsExtra.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsExtra.hrsExtra#">, 
					<cfelse>
						0,
					</cfif>
					<cfif isdefined("rsHrsEfectivasTotal") and  rsHrsEfectivasTotal.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsEfectivasTotal.hrsEfectivas#">, 
					<cfelse>
						0,
					</cfif>
					<cfif isdefined("rsSalarios") and rsSalarios.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsSalarios.Salarios#">,
					<cfelse>
						0,
					</cfif>	
					<cfif isdefined("rs_total") and rs_total.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">
					<cfelse>
						0
					</cfif>	
					)
		</cfquery>			
	</cfloop>
</cfloop>
<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select periodo, mes, llave, total_hrs_extra, total_hrs_efectivas, total_salarios,total_empleados
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
					<cfif rs_datos.total_hrs_extra EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_hrs_extra)#</column></cfif> 						
					<cfif rs_datos.total_hrs_efectivas EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_hrs_efectivas)#</column></cfif> 
					<cfif rs_datos.total_salarios EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_salarios)#</column></cfif>
					<cfif rs_datos.total_empleados EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_empleados)#</column></cfif>
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
				<row><column>*</column></row>
				<row><column>*</column></row>
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
	<cfset irA = "/cfmx/rh/indicadores/nomina/ind-nomina.cfm?Detalle=1">
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset irA = irA & "&CFid=#url.CFid#">
	</cfif>
	<cfif isdefined("url.dependencias")>
		<cfset irA = irA & "&dependencias=#url.dependencias#">
	</cfif>
	<cfif isdefined("Detalle")>
		<cfinclude template="ind-nomina-detalle.cfm">
	<cfelse>
		<cf_viewFlash 
			movie = "nomina" 
			XMLfilename = "nomina2008_#session.Usucodigo#" 
			XMLvalue = "#LvarXML#"
			irA = "#irA#"
			path = "rh/indicadores/nomina" 
		>
	</cfif>
</body>
</html>
