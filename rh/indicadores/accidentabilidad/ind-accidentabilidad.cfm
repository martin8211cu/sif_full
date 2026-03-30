<cfsetting requesttimeout="8600">
<cfinvoke Key="LB_IndicadoresDeAccidentabilidad" Default="Indicadores de Accidentabilidad" returnvariable="LB_IndAccidentabilidad" component="sif.Componentes.Translate" method="Translate"/>
<html>
<cfoutput><title>#LB_IndAccidentabilidad#</title></cfoutput>
<body style="margin:0">

<cfprocessingdirective suppresswhitespace="yes">
<!---0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<!----
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
--->
<!--- tabla d epintado principal --->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="periodo" 					type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes" 						type="int"  	mandatory="yes">
	<cf_dbtempcol name="inicio_mes" 				type="datetime"  mandatory="yes">
	<cf_dbtempcol name="fin_mes" 					type="datetime"  mandatory="yes">
	<cf_dbtempcol name="semanasmes" 				type="int"  	mandatory="no">
	<cf_dbtempcol name="llave" 						type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="total_trabajadores"			type="float"	mandatory="no">
	<cf_dbtempcol name="total_hrs_capacitacion"		type="float"	mandatory="no">
	<cf_dbtempcol name="total_dias_perdidos"		type="float"	mandatory="no">	
	<cf_dbtempcol name="cant_accidentes_area1"		type="float"	mandatory="no">
	<cf_dbtempcol name="cant_accidentes_area2"		type="float"	mandatory="no">
	<cf_dbtempcol name="cant_accidentes_area3"		type="float"	mandatory="no">
	<cf_dbtempcol name="cant_dperdidos_area1"		type="float"	mandatory="no">
	<cf_dbtempcol name="cant_dperdidos_area2"		type="float"	mandatory="no">
	<cf_dbtempcol name="cant_dperdidos_area3"		type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area1"			type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area2"			type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area3"			type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_capacitacion_area1"		type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_capacitacion_area2"		type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_capacitacion_area3"		type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_trabajadas_area1"		type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_trabajadas_area2"		type="float"	mandatory="no">
	<cf_dbtempcol name="hrs_trabajadas_area3"		type="float"	mandatory="no">
</cf_dbtemp>
<cf_dbtemp name="tbl_PagosEmpleado" returnvariable="tbl_PagosEmpleado">
	<cf_dbtempcol name="CPid" 						type="numeric"  	mandatory="no">
	<cf_dbtempcol name="DEid" 						type="numeric"  	mandatory="no">
	<cf_dbtempcol name="PEcantdias" 				type="int"  		mandatory="no">
	<cf_dbtempcol name="desde" 						type="datetime"  	mandatory="no">
	<cf_dbtempcol name="hasta" 						type="datetime"  	mandatory="no">
	<cf_dbtempcol name="RHPid" 						type="numeric" 		mandatory="no">
	<cf_dbtempcol name="CFid"						type="numeric"		mandatory="no">
	<cf_dbtempcol name="RHJid"						type="numeric"		mandatory="no">
	<cf_dbtempcol name="horas_jornada"				type="float"		mandatory="no">	
</cf_dbtemp>
<!----
<!---0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
---->
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!----Variables---->
		<cfset inicio_mes = createdate(p, m, 1) >
		<cfset fin_mes    = createdate(p, m, daysinmonth(inicio_mes)) >		
			<cfquery datasource="#session.DSN#">
				insert into #tbl_principal#(periodo,mes,inicio_mes,fin_mes)	values (#p#, #m#, #inicio_mes#, #fin_mes#) 
			</cfquery>
	</cfloop>
</cfloop>
<!---1. Horas Capacitacion totales---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set total_hrs_capacitacion = coalesce((select sum(a.RHAChoras)
												from RHAsistenciaCurso a
												where a.RHACdia between #tbl_principal#.inicio_mes
														and #tbl_principal#.fin_mes
												),0)			
																
</cfquery>
<!---2. Total dias perdidos--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set total_dias_perdidos =coalesce((select sum(<cf_dbfunction name='datediff' args='(case when lt.LTdesde < c.inicio_mes then c.inicio_mes else lt.LTdesde end),  
																								(case when lt.LThasta > c.fin_mes then c.fin_mes else lt.LThasta end)
																'>)
											from  RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt
											where a.RHIcodigo=b.RHIcodigo
												 and #tbl_principal#.inicio_mes = c.inicio_mes
												 and #tbl_principal#.fin_mes = c.fin_mes
												 and lt.RHTid=b.RHIDllave
												 and convert(date,c.inicio_mes) <= lt.LThasta
												 and convert(date,c.fin_mes) >= lt.LTdesde
												 and  a.RHIcodigo =75 
											group by c.inicio_mes)
											,0)
</cfquery>
<!---3. Accidentes, dias perdidos area 1--->
<cfquery name="rs" datasource="#session.DSN#">	
	update #tbl_principal#
		set cant_accidentes_area1 = coalesce((select coalesce(count(1),0)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and #tbl_principal#.inicio_mes = c.inicio_mes
													and #tbl_principal#.fin_mes = c.fin_mes
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A1'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
												),0)
			,cant_dperdidos_area1 = coalesce((select 	sum(<cf_dbfunction name='datediff' args='(case when lt.LTdesde < c.inicio_mes then c.inicio_mes else lt.LTdesde end),  
																						(case when lt.LThasta > c.fin_mes then c.fin_mes else lt.LThasta end)
																'>)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A1'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
											),0)
</cfquery>
<!---4. Accidentes, dias perdidos area 2--->
<cfquery name="rs" datasource="#session.DSN#">	
	 update #tbl_principal#
		set cant_accidentes_area2 = coalesce((select coalesce(count(1),0)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and #tbl_principal#.inicio_mes = c.inicio_mes
													and #tbl_principal#.fin_mes = c.fin_mes
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A2'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
												),0)			
			, cant_dperdidos_area2 = coalesce((select SUM(<cf_dbfunction name='datediff' args='(case when lt.LTdesde < c.inicio_mes then c.inicio_mes else lt.LTdesde end),  
																								(case when lt.LThasta > c.fin_mes then c.fin_mes else lt.LThasta end)
															'>)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and #tbl_principal#.inicio_mes = c.inicio_mes
													and #tbl_principal#.fin_mes = c.fin_mes
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A2'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
												),0)	
</cfquery>
<!---5. Accidentes, dias perdidos area 3--->
<cfquery name="rs" datasource="#session.DSN#">	
	 update #tbl_principal#
		set cant_accidentes_area3 = coalesce((select coalesce(count(1),0)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and #tbl_principal#.inicio_mes = c.inicio_mes
													and #tbl_principal#.fin_mes = c.fin_mes
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A3'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
												),0)		
			, cant_dperdidos_area3 = coalesce((select SUM(<cf_dbfunction name='datediff' args='(case when lt.LTdesde < c.inicio_mes then c.inicio_mes else lt.LTdesde end),  
																								(case when lt.LThasta > c.fin_mes then c.fin_mes else lt.LThasta end)
															'>)
												from RHIndicadores a, #tbl_principal# c, RHIndicadoresDetalle b, LineaTiempo lt, RHPlazas p, CFuncional f
												where a.RHIcodigo=b.RHIcodigo
													and #tbl_principal#.inicio_mes = c.inicio_mes
													and #tbl_principal#.fin_mes = c.fin_mes
													and lt.RHTid=b.RHIDllave
													and c.inicio_mes <= lt.LThasta
													and c.fin_mes >= lt.LTdesde
													and lt.RHPid = p.RHPid
													and p.CFid = f.CFid
													and f.CFid in  (select x.CFid
																		from AreaIndDetalle x, AreaIndEncabezado y
																		where x.AreaEid = y.AreaEid
																			and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																			and ltrim(rtrim(y.CodArea)) = 'A3'		<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->		
																	)	
													and a.RHIcodigo =75
												group by c.inicio_mes	 
												),0)	
</cfquery>
<!---6. Busca el total de empleados del Area 1--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area1 =coalesce((select coalesce(count(1), 0)
											from LineaTiempo lt, RHPlazas p, CFuncional cf
											where  p.RHPid=lt.RHPid
												and cf.CFid=p.CFid
												and cf.CFid in (select CFid
																from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A1'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																)
												and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and #tbl_principal#.inicio_mes <= lt.LThasta
												and #tbl_principal#.fin_mes >=  lt.LTdesde		
											group by #tbl_principal#.inicio_mes	
										),0)	
</cfquery>
<!---7. Busca el total de empleados del Area 2--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area2 =coalesce((select coalesce(count(1), 0)
											from LineaTiempo lt, RHPlazas p, CFuncional cf
											where  p.RHPid=lt.RHPid
												and cf.CFid=p.CFid
												and cf.CFid in (select CFid
																from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A2'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																)
												and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and #tbl_principal#.inicio_mes <= lt.LThasta
												and #tbl_principal#.fin_mes >=  lt.LTdesde		
											group by #tbl_principal#.inicio_mes	
										),0)	
</cfquery>
<!---8. Busca el total de empleados del Area 3--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area3 =coalesce((select coalesce(count(1), 0)
											from LineaTiempo lt, RHPlazas p, CFuncional cf
											where  p.RHPid=lt.RHPid
												and cf.CFid=p.CFid
												and cf.CFid in (select CFid
																from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A3'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																)
												and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and #tbl_principal#.inicio_mes <= lt.LThasta
												and #tbl_principal#.fin_mes >=  lt.LTdesde		
											group by #tbl_principal#.inicio_mes	
										),0)	
</cfquery>
<!---9. Hras de capacitacion empleados Area 1--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set hrs_capacitacion_area1 = coalesce((	select coalesce(sum(a.RHAChoras),0)
												from RHAsistenciaCurso a, LineaTiempo c, RHPlazas p, CFuncional cf
												where a.DEid = c.DEid
													and a.RHACdia  between  c.LTdesde and c.LThasta
													and p.RHPid=c.RHPid	
													and cf.CFid=p.CFid
													and cf.CFid in (select CFid
																	from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A1'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																	)
													and a.RHACdia between #tbl_principal#.inicio_mes and #tbl_principal#.fin_mes
												group by #tbl_principal#.inicio_mes	
												),0)

</cfquery>
<!---10. Hras de capacitacion empleados Area 2--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set hrs_capacitacion_area2 = coalesce((	select coalesce(sum(a.RHAChoras),0)
												from RHAsistenciaCurso a, LineaTiempo c, RHPlazas p, CFuncional cf
												where a.DEid = c.DEid
													and a.RHACdia  between  c.LTdesde and c.LThasta
													and p.RHPid=c.RHPid	
													and cf.CFid=p.CFid
													and cf.CFid in (select CFid
																	from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A2'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																	)
													and a.RHACdia between #tbl_principal#.inicio_mes and #tbl_principal#.fin_mes
												group by #tbl_principal#.inicio_mes	
												),0)

</cfquery>
<!---11. Hras de capacitacion empleados Area 3--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set hrs_capacitacion_area3 = coalesce((	select coalesce(sum(a.RHAChoras),0)
												from RHAsistenciaCurso a, LineaTiempo c, RHPlazas p, CFuncional cf
												where a.DEid = c.DEid
													and a.RHACdia  between  c.LTdesde and c.LThasta
													and p.RHPid=c.RHPid	
													and cf.CFid=p.CFid
													and cf.CFid in (select CFid
																	from AreaIndDetalle x, AreaIndEncabezado y
																	where x.AreaEid = y.AreaEid
																		and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and ltrim(rtrim(y.CodArea)) = 'A3'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
																	)
													and a.RHACdia between #tbl_principal#.inicio_mes and #tbl_principal#.fin_mes
												group by #tbl_principal#.inicio_mes	
												),0)

</cfquery>
<!---============== OJAS NO TOMA EN CUENTA LA PLANIFICACION DEL PLANIFICADOR DE JORNADAS ==============----->
<!---12.Hrs Trabajadas Area 1--->
<cfquery datasource="#session.DSN#">
	insert into #tbl_PagosEmpleado#(CPid,DEid,PEcantdias,desde,hasta,RHPid,CFid,RHJid,horas_jornada)
	select cp.CPid, DEid, PEcantdias, cp.CPdesde as desde, cp.CPhasta as hasta, RHPid, null as CFid, pe.RHJid, null as horas_jornada
	from HPagosEmpleado pe, CalendarioPagos cp
	where  cp.CPid=pe.RCNid
		and cp.CPperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())-3#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">	
</cfquery>
<cfquery datasource="#session.DSN#">
	update #tbl_PagosEmpleado#
	set CFid = ( select CFid
				  from RHPlazas p
				   where p.RHPid=#tbl_PagosEmpleado#.RHPid),
		horas_jornada = coalesce( (  select  RHJhoradiaria
									 from RHJornadas d
									 where d.RHJid = #tbl_PagosEmpleado#.RHJid ), 0)
</cfquery>
<cfquery name="rs" datasource="#session.DSN#">			
	update #tbl_principal#
		set hrs_trabajadas_area1 =coalesce((select sum(PEcantdias*horas_jornada)
										  from #tbl_PagosEmpleado# a, AreaIndDetalle x, AreaIndEncabezado y
										  where x.CFid=a.CFid
											 and x.AreaEid = y.AreaEid
											 and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											 and ltrim(rtrim(y.CodArea)) = 'A1' <!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
											 and #tbl_principal#.inicio_mes <= a.hasta
											 and #tbl_principal#.fin_mes >=  a.desde              
											),0)								
</cfquery>
<!---13.Hrs Trabajadas Area 2--->
<cfquery name="rs" datasource="#session.DSN#">			
	update #tbl_principal#
		set hrs_trabajadas_area2 =coalesce((select sum(PEcantdias*horas_jornada)
										  from #tbl_PagosEmpleado# a, AreaIndDetalle x, AreaIndEncabezado y
										  where x.CFid=a.CFid
											 and x.AreaEid = y.AreaEid
											 and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											 and ltrim(rtrim(y.CodArea)) = 'A2' <!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
											 and #tbl_principal#.inicio_mes <= a.hasta
											 and #tbl_principal#.fin_mes >=  a.desde              
											),0)	
</cfquery>
<!---14.Hrs Trabajadas Area 3--->
<cfquery name="rs" datasource="#session.DSN#">			
	update #tbl_principal#
		set hrs_trabajadas_area3 =coalesce((select sum(PEcantdias*horas_jornada)
										  from #tbl_PagosEmpleado# a, AreaIndDetalle x, AreaIndEncabezado y
										  where x.CFid=a.CFid
											 and x.AreaEid = y.AreaEid
											 and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											 and ltrim(rtrim(y.CodArea)) = 'A3' <!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
											 and #tbl_principal#.inicio_mes <= a.hasta
											 and #tbl_principal#.fin_mes >=  a.desde              
											),0)
</cfquery>

<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select 	periodo,mes,llave,total_trabajadores,total_hrs_capacitacion,total_dias_perdidos,
			cant_accidentes_area1,cant_accidentes_area2,cant_accidentes_area3,
			cant_dperdidos_area1,cant_dperdidos_area2,cant_dperdidos_area3,
			empleados_area1,empleados_area2,empleados_area3,
			hrs_capacitacion_area1,hrs_capacitacion_area2,hrs_capacitacion_area3,
			hrs_trabajadas_area1,hrs_trabajadas_area2,hrs_trabajadas_area3
	from #tbl_principal#
	order by periodo, mes
</cfquery>

<!---Datos de periodo/mes--->
<cfquery name="rsPeriodoMes" datasource="#session.DSN#">
	select distinct periodo
	from  #tbl_principal#
	order by periodo
</cfquery>
<cfquery name="rsAreas" datasource="#session.DSN#">
	select CodArea,DescArea
	from AreaIndEncabezado 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CodArea in ('A1','A2','A3')
</cfquery>
<cfsavecontent variable="LvarXML" >
	<data>
		<variable name="<cfoutput>#xmlformat('DatosPeriodoMes')#</cfoutput>">
			<cfoutput query="rs_datos">
				<row>
					<column>#xmlformat(rs_datos.llave)#</column>
					<column>#xmlformat(rs_datos.periodo)#</column>					
					<cfif rs_datos.total_trabajadores EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.total_trabajadores)#</column></cfif> 						
					<cfif rs_datos.total_hrs_capacitacion EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.total_hrs_capacitacion)#</column></cfif> 
					<cfif rs_datos.total_dias_perdidos EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.total_dias_perdidos)#</column></cfif> 
					<cfif rs_datos.cant_accidentes_area1 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_accidentes_area1)#</column></cfif>
					<cfif rs_datos.cant_accidentes_area2 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_accidentes_area2)#</column></cfif>					
					<cfif rs_datos.cant_accidentes_area3 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_accidentes_area3)#</column></cfif>					
					<cfif rs_datos.cant_dperdidos_area1 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_dperdidos_area1)#</column></cfif>					
					<cfif rs_datos.cant_dperdidos_area2 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_dperdidos_area2)#</column></cfif>					
					<cfif rs_datos.cant_dperdidos_area3 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.cant_dperdidos_area3)#</column></cfif>					
					<cfif rs_datos.empleados_area1 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.empleados_area1)#</column></cfif>					
					<cfif rs_datos.empleados_area2 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.empleados_area2)#</column></cfif>					
					<cfif rs_datos.empleados_area3 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.empleados_area3)#</column></cfif>					
					<cfif rs_datos.hrs_capacitacion_area1 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_capacitacion_area1)#</column></cfif>					
					<cfif rs_datos.hrs_capacitacion_area2 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_capacitacion_area2)#</column></cfif>					
					<cfif rs_datos.hrs_capacitacion_area3 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_capacitacion_area3)#</column></cfif>					
					<cfif rs_datos.hrs_trabajadas_area1 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_trabajadas_area1)#</column></cfif>					
					<cfif rs_datos.hrs_trabajadas_area2 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_trabajadas_area2)#</column></cfif>					
					<cfif rs_datos.hrs_trabajadas_area3 EQ 0><column>0</column><cfelse><column>#xmlformat(rs_datos.hrs_trabajadas_area3)#</column></cfif>					
				</row>
			</cfoutput>
		</variable>
		<!----Datos de etiquetas de seleccion de años--->
		<cfoutput><variable name="#xmlformat('PeriodosSeleccion')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos1')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos2')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos3')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos4')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos5')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<cfoutput><variable name="#xmlformat('Periodos6')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#</column></row>
			</cfoutput>
		</variable>
		<!----Datos de las llaves para los indicadores--->
		<cfoutput><variable name="#xmlformat('LLaves')#"></cfoutput>
			<cfoutput query="rsPeriodoMes">
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C1</column></row>
				<row><column>#xmlformat(rsPeriodoMes.periodo)#_C2</column></row>
				<row><column>*</column></row>
				<row><column>*</column></row>
			</cfoutput>
		</variable>
		<variable name="<cfoutput>#xmlformat('Areas')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.CodArea)#&nbsp;-&nbsp;#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
		</variable>		
		<variable name="<cfoutput>#xmlformat('Area1')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
			<row><column>xmlformat(General)</column></row>
		</variable>
		<variable name="<cfoutput>#xmlformat('Area2')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
			<row><column>xmlformat(General)</column></row>
		</variable>	
		<variable name="<cfoutput>#xmlformat('Area3')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
			<row><column>xmlformat(General)</column></row>
		</variable>	
		<variable name="<cfoutput>#xmlformat('Area4')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
			<row><column>xmlformat(General)</column></row>
		</variable>	
		<variable name="<cfoutput>#xmlformat('Area5')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
			<row><column>xmlformat(General)</column></row>
		</variable>	
	</data>
</cfsavecontent>

<!--- 
	El nombre del archivo XML debe ser unico, formado con la combinación de llaves que hacen a la información única,
	para que todos los usuarios que ven el archivo con la misma combinación de llaves vean la misma informacion
	En este caso la combinación es el IdEmpleado con el IdPuesto
--->
<cfset inicio = now() >
	<cfset irA = "/cfmx/rh/indicadores/accidentabilidad/ind-accidentabilidad.cfm?Detalle=1">
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset irA = irA & "&CFid=#url.CFid#">
	</cfif>
	<cfif isdefined("url.dependencias")>
		<cfset irA = irA & "&dependencias=#url.dependencias#">
	</cfif>
	<cfif isdefined("Detalle")>
		<cfinclude template="ind-accidentabilidad-detalle.cfm">
	<cfelse>
		<cf_viewFlash 
			movie = "accidentabilidad" 
			XMLfilename = "accidentabilidad2008_#session.Usucodigo#" 
			XMLvalue = "#LvarXML#"
			irA = "#irA#"
			path = "rh/indicadores/accidentabilidad" 
		>
	</cfif>
</cfprocessingdirective>
</body>
</html>