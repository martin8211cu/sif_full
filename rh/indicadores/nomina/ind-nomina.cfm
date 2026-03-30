<cfsetting requesttimeout="8600">
<cfinvoke Key="LB_IndicadoresDeNomina" Default="Indicadores de Nomina" returnvariable="LB_IndNomina" component="sif.Componentes.Translate" method="Translate"/>
<html>
<cfoutput><title>#LB_IndNomina#</title></cfoutput>
<body style="margin:0">
<cfprocessingdirective suppresswhitespace="yes">
<!---Obtiene las dependencias del cfuncional---->
<cfset CentrosLista = ''>
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#url.CFid#"
		Nivel = 5
		returnvariable="Dependencias"/>
	<cfset CentrosLista = ValueList(Dependencias.CFid)>
<cfelseif isdefined("url.CFid") and len(trim(url.CFid)) >
	<cfset CentrosLista = url.CFid>
</cfif>

<!--- tabla d epintado principal --->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="periodo" 					type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes" 						type="int"  	mandatory="yes">
	<cf_dbtempcol name="inicio_mes" 				type="datetime"  mandatory="yes">
	<cf_dbtempcol name="fin_mes" 					type="datetime"  mandatory="yes">
	<cf_dbtempcol name="llave" 						type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="total_hrs_extra"			type="float"	mandatory="no">
	<cf_dbtempcol name="total_hrs_efectivas"		type="float"	mandatory="no">
	<cf_dbtempcol name="total_salarios"				type="float"	mandatory="no">	
	<cf_dbtempcol name="total_empleados"			type="float"	mandatory="no">
	<cf_dbtempcol name="salarios_area1"				type="float"	mandatory="no">
	<cf_dbtempcol name="salarios_area2"				type="float"	mandatory="no">
	<cf_dbtempcol name="salarios_area3"				type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area1"			type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area2"			type="float"	mandatory="no">
	<cf_dbtempcol name="empleados_area3"			type="float"	mandatory="no">
</cf_dbtemp>
<!----Temporal de trabajo para hrs efectivas laboradas--->
<cf_dbtemp name="tbl_hrsrefectivas" returnvariable="tbl_hrsrefectivas">
	<cf_dbtempcol name="fdesde"		type="date"			mandatory="yes">
	<cf_dbtempcol name="fhasta"		type="date"			mandatory="yes">
	<cf_dbtempcol name="horas" 		type="float"  		mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="yes">
</cf_dbtemp>
<!----Temporal con los salarios de los empleados en los años tomados en cuenta en el indicador--->
<cf_dbtemp name="tbl_salariosempleado" returnvariable="tbl_salariosempleado">
	<cf_dbtempcol name="desde"		type="date"			mandatory="yes">
	<cf_dbtempcol name="hasta"		type="date"			mandatory="yes">
	<cf_dbtempcol name="liquido" 	type="float"  		mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="CFid" 		type="numeric"  	mandatory="yes">
</cf_dbtemp>
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!----Variables---->
		<cfset inicio_mes = createdate(p, m, 1) >
		<cfset fin_mes    = createdate(p, m, daysinmonth(inicio_mes)) >		
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, inicio_mes, fin_mes)
			values(	#p#, 
					#m#, 
					#inicio_mes#,
					#fin_mes#
					)
		</cfquery>
	</cfloop>
</cfloop>
<!---1. Actualiza empleados al iniciar el mes--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set total_empleados = coalesce((select coalesce(count(1), 0)
										from LineaTiempo lt, RHPlazas p, CFuncional cf
										where p.RHPid=lt.RHPid
											and cf.CFid=p.CFid
											<cfif isdefined("CentrosLista") and len(trim(CentrosLista))>
												and cf.CFid in (#CentrosLista#)
											</cfif>
											and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and #tbl_principal#.inicio_mes between lt.LTdesde and lt.LThasta
										<!----group by #tbl_principal#.inicio_mes---->
										),0)
</cfquery>
<!---2.Horas extra--->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set total_hrs_extra = coalesce((select coalesce(sum(ICvalor),0)
										from RHIndicadoresDetalle a, HIncidenciasCalculo b,  HRCalculoNomina c <cfif isdefined("url.CFid") and len(trim(url.CFid))>,CFuncional cf</cfif>
										where a.RHIDllave = b.CIid
											<!----Filtro de centro funcional---->											
											<cfif isdefined("CentrosLista") and len(trim(CentrosLista))>
												and cf.CFid=b.CFid	
												and cf.CFid in (#CentrosLista#)
											</cfif>
											and b.RCNid = c.RCNid
											and #tbl_principal#.inicio_mes <= c.RChasta
											and #tbl_principal#.fin_mes >= c.RCdesde
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and a.RHIDtipo = 'C'			<!---Tipo Concepto de pago/incidencia--->
											and a.RHIcodigo = 65			<!---Indice de horas extras----> 
										<!----group by #tbl_principal#.inicio_mes---->
										),0)
</cfquery>
<!---3. Horas efectivas laboradas--->
<cfquery name="rsHrsEfectivasPlan" datasource="#session.DSN#"><!---Carga en temporal las horas efectivas del planificador para no contarlas mas--->
	insert into #tbl_hrsrefectivas#(fdesde, fhasta, horas, DEid)
	select 	<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.DSN].type)>
				convert(date,c.RHPJfinicio)  as fdesde,
				convert(date,c.RHPJffinal)  as fhasta,
				coalesce(sum((datediff(dd,(case when convert(date,c.RHPJfinicio)  < z.inicio_mes then 
												z.inicio_mes
											else convert(date,c.RHPJfinicio)  end
											), 
											(case when convert(date,c.RHPJffinal) > z.fin_mes then 
												z.fin_mes
											else convert(date,c.RHPJffinal) end
											)
								))+1 *d.RHJhoradiaria),0)		
			<cfelse>
				to_date(c.RHPJfinicio,'dd-mm-yyyy') as fdesde,
				to_date(c.RHPJffinal,'dd-mm-yyyy') as fhasta,
				coalesce(sum(((case when convert(date,c.RHPJfinicio)  < z.inicio_mes then 
									z.inicio_mes
								else convert(date,c.RHPJfinicio)  end
								)
								- 
								(case when convert(date,c.RHPJffinal) > z.fin_mes then 
									z.fin_mes
								else convert(date,c.RHPJffinal) end
								))+1
						*d.RHJhoradiaria),0)	
			</cfif>
			,a.DEid as DEid		
	from HSalarioEmpleado a, CalendarioPagos b, #tbl_principal# z, RHPlanificador c, RHJornadas d
	where a.RCNid = b.CPid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and (b.CPperiodo = <cf_dbfunction name="date_part"   args="YY,z.inicio_mes"> 
			or b.CPperiodo = <cf_dbfunction name="date_part"   args="YY,z.fin_mes">
			)
		and (b.CPmes = <cf_dbfunction name="date_part"   args="MM,z.inicio_mes"> 
			or b.CPmes = <cf_dbfunction name="date_part"   args="MM,z.fin_mes">
			)
		and a.DEid = c.DEid
		<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.DSN].type)>
			and b.CPdesde <= convert(date,c.RHPJffinal)
			and b.CPhasta >= convert(date,c.RHPJfinicio)	
		<cfelse>
			and b.CPdesde <= to_date(c.RHPJffinal,'dd-mm-yyyy')
			and b.CPhasta >= to_date(c.RHPJfinicio,'dd-mm-yyyy')	
		</cfif>
		and c.RHJid = d.RHJid
		<cfif isdefined("url.CFid") and len(trim(url.CFid))><!----Filtro de cfuncional---->
			and exists (select 1
						from LineaTiempo x, RHPlazas y, CFuncional z
						where c.DEid = x.DEid
							and x.LTdesde <= c.RHPJffinal
							and x.LThasta >= c.RHPJfinicio
							and x.RHPid=y.RHPid
							and y.CFid = z.CFid
							<cfif isdefined("CentrosLista") and len(trim(CentrosLista))>
								and z.CFid in (#CentrosLista#)
							</cfif>
							<!---and (  z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or z.CFpath like '#rs_path.path#%'
									</cfif>
								)----->
						)
		</cfif>
	group by c.RHPJfinicio, c.RHPJffinal,a.DEid 		
</cfquery>		
<cfquery name="rs" datasource="#session.DSN#"><!----Carga las horas que NO estan en el planificador---->
	insert into #tbl_hrsrefectivas#(fdesde, fhasta, horas, DEid)
	select 	b.CPdesde, b.CPhasta
			,coalesce(sum(a.PEcantdias*(select RHJhoradiaria
										from RHJornadas f
										where a.RHJid = f.RHJid)
					  ),0)		
			, a.DEid
	from HPagosEmpleado a, CalendarioPagos b, #tbl_principal# c
	where a.RCNid = b.CPid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.PEtiporeg = 0
		and (b.CPperiodo = <cf_dbfunction name="date_part"   args="YY,c.inicio_mes"> 
			or b.CPperiodo = <cf_dbfunction name="date_part"   args="YY,c.fin_mes"> 
			)
		and (b.CPmes = <cf_dbfunction name="date_part"   args="MM,c.inicio_mes"> 
			or b.CPmes = <cf_dbfunction name="date_part"   args="MM,c.fin_mes">	
			)
		and not exists(select 1
					from #tbl_hrsrefectivas#
					where #tbl_hrsrefectivas#.DEid = a.DEid
						and #tbl_hrsrefectivas#.fdesde <= b.CPhasta
						and #tbl_hrsrefectivas#.fhasta >= b.CPdesde
					)
		<cfif isdefined("url.CFid") and len(trim(url.CFid))><!---Filtro de cfuncional---->
			and exists(select 1
						from RHPlazas x, CFuncional y
						where a.RHPid = x.RHPid
							and x.CFid = y.CFid
							<cfif isdefined("CentrosLista") and len(trim(CentrosLista))>
								and y.CFid in (#CentrosLista#)
							</cfif>
							<!---and (y.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or y.CFpath like '#rs_path.path#%'
									</cfif>
								)---->
						)	
		</cfif>			
	group by b.CPdesde, b.CPhasta, a.DEid
</cfquery>
<cfquery name="rs" datasource="#session.DSN#"><!----Actualiza las horas efectivas--->
	update #tbl_principal#
		set total_hrs_efectivas = coalesce((select sum(horas)
											from #tbl_hrsrefectivas# a
											where  #tbl_principal#.inicio_mes <= a.fhasta
												and #tbl_principal#.fin_mes >=  a.fdesde   
											),0)
</cfquery>
<!----4.Sumatoria de salarios del Area 1---->
<cfquery name="rs" datasource="#session.DSN#"><!---Temporal con todos los salarios de los años tomados en cuenta---->
	insert into #tbl_salariosempleado#(desde,hasta,liquido,DEid,CFid)	
	select cp.CPdesde, cp.CPhasta, a.SEliquido, a.DEid, d.CFid
	from HSalarioEmpleado a, CalendarioPagos cp, LineaTiempo c , RHPlazas d
	where a.RCNid = cp.CPid											
		and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.DEid = c.DEid
		and c.Ecodigo =  cp.Ecodigo	
		and cp.CPdesde <= c.LThasta
		and cp.CPhasta >= c.LTdesde
		and cp.CPperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())-3#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">
		and c.RHPid = d.RHPid
</cfquery>
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal# 
		set salarios_area1 =coalesce((select sum(liquido)
										from #tbl_salariosempleado# a, AreaIndDetalle x , AreaIndEncabezado y
										where  a.CFid = x.CFid
											and x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A1'
											and #tbl_principal#.inicio_mes <= a.hasta
											and #tbl_principal#.fin_mes >=  a.desde  
										),0)
</cfquery>
<!----5.Sumatoria de salarios del Area 2---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal# 
		set salarios_area2 =coalesce((select sum(liquido)
										from #tbl_salariosempleado# a, AreaIndDetalle x , AreaIndEncabezado y
										where  a.CFid = x.CFid
											and x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A2'
											and #tbl_principal#.inicio_mes <= a.hasta
											and #tbl_principal#.fin_mes >=  a.desde  
										),0)
</cfquery>
<!----6.Sumatoria de salarios del Area 3---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal# 
		set salarios_area3 =coalesce((select sum(liquido)
										from #tbl_salariosempleado# a, AreaIndDetalle x , AreaIndEncabezado y
										where  a.CFid = x.CFid
											and x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A3'
											and #tbl_principal#.inicio_mes <= a.hasta
											and #tbl_principal#.fin_mes >=  a.desde  
										),0)
</cfquery>
<!-----7. Empleados de Area 1---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area1 = coalesce((select count(1)
										from LineaTiempo lt, RHPlazas p, CFuncional cf 
										where p.RHPid=lt.RHPid
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
<!-----8. Empleados de Area 2---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area2 = coalesce((select count(1)
										from LineaTiempo lt, RHPlazas p, CFuncional cf
										where p.RHPid=lt.RHPid
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
<!-----9. Empleados de Area 3---->
<cfquery name="rs" datasource="#session.DSN#">
	update #tbl_principal#
		set empleados_area3 = coalesce((select count(1)
										from LineaTiempo lt, RHPlazas p, CFuncional cf
										where p.RHPid=lt.RHPid
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

<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select 	periodo, mes, llave, total_hrs_extra, total_hrs_efectivas, total_salarios,total_empleados
			,salarios_area1,salarios_area2,salarios_area3,empleados_area1,empleados_area2,empleados_area3
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
		<!----Columnas de datos (Hrs reales, Hrs Programadas, Gasto, etc)--->
		<variable name="<cfoutput>#xmlformat('DatosPeriodoMes')#</cfoutput>">
			<cfoutput query="rs_datos">
				<row>
					<column>#xmlformat(rs_datos.llave)#</column>
					<column>#xmlformat(rs_datos.periodo)#</column>
					<column>#xmlformat(rs_datos.mes)#</column>
					<cfif rs_datos.total_hrs_extra EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_hrs_extra)#</column></cfif> 						
					<cfif rs_datos.total_hrs_efectivas EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_hrs_efectivas)#</column></cfif> 
					<column>0.00</column><!---<cfif rs_datos.total_salarios EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_salarios)#</column></cfif>---->
					<cfif rs_datos.total_empleados EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.total_empleados)#</column></cfif>
					<cfif rs_datos.salarios_area1 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.salarios_area1)#</column></cfif>
					<cfif rs_datos.salarios_area2 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.salarios_area2)#</column></cfif>
					<cfif rs_datos.salarios_area3 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.salarios_area3)#</column></cfif>
					<cfif rs_datos.empleados_area1 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.empleados_area1)#</column></cfif>
					<cfif rs_datos.empleados_area2 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.empleados_area2)#</column></cfif>
					<cfif rs_datos.empleados_area3 EQ 0><column>0.00001</column><cfelse><column>#xmlformat(rs_datos.empleados_area3)#</column></cfif>					
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
		<cfoutput><variable name="#xmlformat('Areas')#"></cfoutput>
			<row><column>#xmlformat(Area No.1)#</column></row>
			<row><column>#xmlformat(Area No.2)#</column></row>
			<row><column>#xmlformat(Area No.3)#</column></row>
			<row><column>#xmlformat(General)#</column></row>
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
		<variable name="<cfoutput>#xmlformat('AreasEtiqueta')#</cfoutput>">
			<cfoutput query="rsAreas">
				<row>
					<column>#xmlformat(rsAreas.CodArea)#&nbsp;-&nbsp;#xmlformat(rsAreas.DescArea)#</column>
				</row>
			</cfoutput>
		</variable>						
	</data>
</cfsavecontent>
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
</cfprocessingdirective>
</body>
</html>
<!----=================================================================================================================================				
		<!---Limpiar la temporal--->
		<cfquery datasource="#session.DSN#">
			delete from #tbl_hrsrefectivas#
		</cfquery>
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
					coalesce((datediff(dd,RCdesde, RChasta)*e.RHJhoradiaria),0) as horas,
					c.DEid as DEid
			from HRCalculoNomina a	
				inner join HSalarioEmpleado c
					on a.RCNid = c.RCNid
				inner join RHPlanificador b
					on c.DEid = b.DEid
					and a.RCdesde <= convert(date,b.RHPJffinal)
					and a.RChasta >= convert(date,b.RHPJfinicio)							
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						and exists (select 1
									from LineaTiempo x, RHPlazas y, CFuncional z
									where b.DEid = x.DEid
										and x.LTdesde <= b.RHPJffinal
										and x.LThasta >= b.RHPJfinicio
										and x.RHPid=y.RHPid
										and y.CFid = z.CFid
										and ( z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
												<cfif isdefined("url.dependencias")>
													or z.CFpath like '#rs_path.path#%'
												</cfif>
											)
									)
					</cfif>	
					inner join RHJornadas e
						on b.RHJid = e.RHJid
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#">  <= a.RChasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= a.RCdesde
		</cfquery>		
		<!---3.2 Las fechas ke no estan en la planificacion de horarios buscar la jornada en la linea del tiempo--->
		<cfquery name="rsHrsEfectivasLT" datasource="#session.DSN#">
			insert into #tbl_hrsrefectivas#(fdesde, fhasta, horas, DEid)
			select 	coalesce(c.PEdesde,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) as fdesde,
					coalesce(c.PEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) as fhasta,					
					coalesce((datediff(dd,RCdesde, RChasta)*(select RHJhoradiaria
													from RHJornadas f
													where c.RHJid = f.RHJid)
							),0) as horas,
					c.DEid as DEid
			from HRCalculoNomina a	
				inner join HPagosEmpleado c
					on a.RCNid = c.RCNid
					and c.PEtiporeg = 0
					<!----Fechas ke no esten ya contempladas en el planificador---->
					and not exists(select 1
									from #tbl_hrsrefectivas#
									where #tbl_hrsrefectivas#.DEid = c.DEid
										and #tbl_hrsrefectivas#.fdesde <= c.PEhasta
										and #tbl_hrsrefectivas#.fhasta >= c.PEdesde
									)
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
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
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= a.RChasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >=  a.RCdesde	
			<!----
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
			----->								
		</cfquery>		
		<!---3.3 Obtener el total de horas efectivas--->
		<cfquery name="rsHrsEfectivasTotal" datasource="#session.DSN#">
			select coalesce(sum(horas),0) as hrsEfectivas
			from #tbl_hrsrefectivas#
		</cfquery>
		<!---Obtener sumatoria de salarios para AREA No.1--->
		<cfquery name="rsSalariosArea1" datasource="#session.DSN#">
			select coalesce(sum(SEliquido),0) as SalariosArea
			from HSalarioEmpleado a			
				inner join CalendarioPagos cp
					on a.RCNid = cp.CPid
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			
				inner join LineaTiempo c
					on a.DEid = c.DEid
					and c.Ecodigo =  cp.Ecodigo	
					and cp.CPfpago between c.LTdesde and c.LThasta
					
					inner join RHPlazas d
						on c.RHPid = d.RHPid
					<!----========== Se seleccione o no un cfuncional X en el filtro  se toman todos los del area ==========----->
					inner join CFuncional f
						on d.CFid = f.CFid
						and f.CFid in  (select x.CFid
										from AreaIndDetalle x, AreaIndEncabezado y
										where x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A1'			<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->			
										)	
		</cfquery>
		<!---Obtener sumatoria de salarios para AREA No.2--->
		<cfquery name="rsSalariosArea2" datasource="#session.DSN#">
			select coalesce(sum(SEliquido),0) as SalariosArea
			from HSalarioEmpleado a			
				inner join CalendarioPagos cp
					on a.RCNid = cp.CPid
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			
				inner join LineaTiempo c
					on a.DEid = c.DEid
					and c.Ecodigo =  cp.Ecodigo	
					and cp.CPfpago between c.LTdesde and c.LThasta
					
					inner join RHPlazas d
						on c.RHPid = d.RHPid
					<!----========== Se seleccione o no un cfuncional X en el filtro  se toman todos los del area ==========----->
					inner join CFuncional f
						on d.CFid = f.CFid
						and f.CFid in  (select x.CFid
										from AreaIndDetalle x, AreaIndEncabezado y
										where x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A2'			<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->			
										)	
		</cfquery>
		<!---Obtener sumatoria de salarios para AREA No.3--->
		<cfquery name="rsSalariosArea3" datasource="#session.DSN#">
			select coalesce(sum(SEliquido),0) as SalariosArea
			from HSalarioEmpleado a			
				inner join CalendarioPagos cp
					on a.RCNid = cp.CPid
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			
				inner join LineaTiempo c
					on a.DEid = c.DEid
					and c.Ecodigo =  cp.Ecodigo	
					and cp.CPfpago between c.LTdesde and c.LThasta
					
					inner join RHPlazas d
						on c.RHPid = d.RHPid
			
					<!----========== Se seleccione o no un cfuncional X en el filtro  se toman todos los del area ==========----->
					inner join CFuncional f
						on d.CFid = f.CFid
						and f.CFid in  (select x.CFid
										from AreaIndDetalle x, AreaIndEncabezado y
										where x.AreaEid = y.AreaEid
											and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and ltrim(rtrim(y.CodArea)) = 'A3'			<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->			
										)	
		</cfquery>
		<!---Busca total de empleados para el AREA 1---->
		<cfquery name="rsEmpleadosArea1" datasource="#session.DSN#">
			select coalesce(count(1), 0) as empleados
			from LineaTiempo lt			
				inner join RHPlazas p
					on p.RHPid=lt.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
					and cf.CFid in (select CFid
								from AreaIndDetalle x, AreaIndEncabezado y
									where x.AreaEid = y.AreaEid
										and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and ltrim(rtrim(y.CodArea)) = 'A1'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
								)
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= lt.LThasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >=  lt.LTdesde	
		</cfquery>
				<!---Busca total de empleados para el AREA 2---->
		<cfquery name="rsEmpleadosArea2" datasource="#session.DSN#">
			select coalesce(count(1), 0) as empleados
			from LineaTiempo lt			
				inner join RHPlazas p
					on p.RHPid=lt.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
					and cf.CFid in (select CFid
								from AreaIndDetalle x, AreaIndEncabezado y
									where x.AreaEid = y.AreaEid
										and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and ltrim(rtrim(y.CodArea)) = 'A2'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
								)
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= lt.LThasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >=  lt.LTdesde	
		</cfquery>
		<!---Busca total de empleados para el AREA 3---->
		<cfquery name="rsEmpleadosArea3" datasource="#session.DSN#">
			select coalesce(count(1), 0) as empleados
			from LineaTiempo lt			
				inner join RHPlazas p
					on p.RHPid=lt.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
					and cf.CFid in (select CFid
								from AreaIndDetalle x, AreaIndEncabezado y
									where x.AreaEid = y.AreaEid
										and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and ltrim(rtrim(y.CodArea)) = 'A3'	<!---OJOOOO QUEMADOOOOO, por ahora solo existen 3 AREAS(A1,A2 y A3)!!!!!---->	
								)
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= lt.LThasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >=  lt.LTdesde	
		</cfquery>
		<!---4. Busca monto sumatoria de los salarios---->
		<!--- 
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
		---->	
		<!----5. Inserta los datos para el periodo/mes en la tabla principal---->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, llave, total_hrs_extra, total_hrs_efectivas, total_salarios,total_empleados
										,salarios_area1,salarios_area2,salarios_area3,empleados_area1,empleados_area2,empleados_area3)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#p#_#m#">,
					<cfif isdefined("rsHrsExtra") and rsHrsExtra.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsExtra.hrsExtra#">, 
					<cfelse>0,</cfif>
					<cfif isdefined("rsHrsEfectivasTotal") and  rsHrsEfectivasTotal.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsHrsEfectivasTotal.hrsEfectivas#">, 
					<cfelse>0,</cfif>
					<cfif isdefined("rsSalarios") and rsSalarios.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsSalarios.Salarios#">,
					<cfelse>0,</cfif>	
					<cfif isdefined("rs_total") and rs_total.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">,
					<cfelse>0,</cfif>	
					<cfif isdefined("rsSalariosArea1") and rsSalariosArea1.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsSalariosArea1.SalariosArea#">,
					<cfelse>0,</cfif>	
					<cfif isdefined("rsSalariosArea2") and rsSalariosArea2.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsSalariosArea2.SalariosArea#">,
					<cfelse>0,</cfif>	
					<cfif isdefined("rsSalariosArea3") and rsSalariosArea3.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsSalariosArea3.SalariosArea#">,
					<cfelse>0,</cfif>	
					<cfif isdefined("rsEmpleadosArea1") and rsEmpleadosArea1.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsEmpleadosArea1.empleados#">,
					<cfelse>0,</cfif>
					<cfif isdefined("rsEmpleadosArea2") and rsEmpleadosArea2.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsEmpleadosArea2.empleados#">,
					<cfelse>0,</cfif>
					<cfif isdefined("rsEmpleadosArea3") and rsEmpleadosArea3.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsEmpleadosArea3.empleados#">
					<cfelse>0</cfif>
					)
		</cfquery>		
=================================================================================================================================---->