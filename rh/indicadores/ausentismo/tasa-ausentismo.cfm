<cfsetting requesttimeout="8600">

<!--- 0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
</cfif>

<!--- datos provenientes de la tabla de linea del tiempo --->
<cf_dbtemp name="tbl_LineaTiempo" returnvariable="tbl_LineaTiempo">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="RHIDllave" 			type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="desde" 				type="date"  	mandatory="yes">
	<cf_dbtempcol name="hasta" 				type="date"  	mandatory="yes">
	<cf_dbtempcol name="dias_incapacidad"	type="int"  	mandatory="yes">
	<cf_dbtempcol name="periodo"	type="int"  	mandatory="no">
	<cf_dbtempcol name="mes"		type="int"  	mandatory="no">
</cf_dbtemp>

<!--- datos provenientes de la tabla de Pagos Saldos Exceso --->
<cf_dbtemp name="tbl_Saldos" returnvariable="tbl_Saldos">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="RHIDllave" 			type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="desde" 				type="date"  	mandatory="yes">
	<cf_dbtempcol name="hasta" 				type="date"  	mandatory="yes">
	<cf_dbtempcol name="dias_incapacidad"	type="int"  	mandatory="yes">
	<cf_dbtempcol name="periodo"			type="int"  	mandatory="no">
	<cf_dbtempcol name="mes"				type="int"  	mandatory="no">
</cf_dbtemp>

<!--- datos de traslape --->
<cf_dbtemp name="tbl_traslape" returnvariable="tbl_traslape">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="desde"		type="date"  	mandatory="yes">
	<cf_dbtempcol name="hasta"		type="date"  	mandatory="yes">
	<cf_dbtempcol name="dias"		type="int"  	mandatory="no">
	<cf_dbtempcol name="periodo"	type="int"  	mandatory="no">
	<cf_dbtempcol name="mes"		type="int"  	mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="tbl_tmpLineaTiempo" returnvariable="tbl_tmpLineaTiempo"><!---Acciones en la linea del tiempo (No retroactivas)--->
	<cf_dbtempcol name="DEid" 		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="RHIDllave"	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="desde"		type="date"	mandatory="yes">
	<cf_dbtempcol name="hasta"		type="date"	mandatory="yes">
	<cf_dbtempcol name="dias" 		type="int"  mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="tbl_tmpSaldosExceso" returnvariable="tbl_tmpSaldosExceso"><!---Acciones en saldos exceso (Retroactivas)--->
	<cf_dbtempcol name="DEid" 		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="RHIDllave"	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="desde"		type="date"	mandatory="yes">
	<cf_dbtempcol name="hasta"		type="date"	mandatory="yes">
	<cf_dbtempcol name="dias" 		type="int"  mandatory="yes">
</cf_dbtemp>

<!--- tabla d epintado principal --->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="periodo" 						type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes" 							type="int"  	mandatory="yes">
	<cf_dbtempcol name="dias_mes" 						type="float"  	mandatory="yes">
	<cf_dbtempcol name="total_empleados"				type="float"	mandatory="yes">
	<cf_dbtempcol name="total_dias_incapacidad"			type="float"	mandatory="yes">
	<cf_dbtempcol name="total_ausencia_justificada"		type="float"	mandatory="yes">
	<cf_dbtempcol name="total_ausencia_injustificada"	type="float"	mandatory="yes">
</cf_dbtemp>

<!---
<cfset inicio = now()>
<cfset inicio_ciclo = now()>
--->
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!--- 1.1.1 fechas --->		
		<cfset inicio_mes = createdate(p, m, 1) >
		<cfset fin_mes    = createdate(p, m, daysinmonth(inicio_mes)) >

		<!---LIMPIAR LAS TABLAS TEMPORALES DE DATOS--->
		<cfquery datasource="#session.DSN#">
			delete from #tbl_tmpLineaTiempo#
		</cfquery>
		<cfquery datasource="#session.DSN#">
			delete from #tbl_tmpSaldosExceso#
		</cfquery>		

		<!--- 1.1.2 calculo total empleados al inicio de cada mes  --->
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
			where <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> between lt.LTdesde and lt.LThasta
		</cfquery>	
		
		<!--- 1.1.3 insercion de datos provenientes de linea del tiempo  --->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_LineaTiempo#( DEid, RHIDllave, desde, hasta, dias_incapacidad )
			select 	lt.DEid, 
				 	RHIDllave, 
					(case when lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> else lt.LTdesde end) as desde,
					(case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> else lt.LThasta end) as hasta
					,
					<cf_dbfunction name='datediff' args='(case when lt.LTdesde < #inicio_mes# then #inicio_mes# else lt.LTdesde end),  
														(case when lt.LThasta > #fin_mes# then #fin_mes# else lt.LThasta end)
														'>
					+ 1 as dias_incapacidad
			from RHIndicadores a
				inner join RHIndicadoresDetalle b
					on a.RHIcodigo=b.RHIcodigo
				inner join LineaTiempo lt 
					on lt.RHTid=b.RHIDllave
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
			where a.RHIcodigo=30				 
				and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= lt.LThasta
				and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= lt.LTdesde
		</cfquery>

		<!--- 1.1.4 insercion de datos provenientes de Saldo Pagos Exceso --->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_Saldos#( DEid, RHIDllave, desde, hasta, dias_incapacidad ) 
			select 	s.DEid, 
					RHIDllave, 
					(case when s.RHSPEfdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> else s.RHSPEfdesde end) as desde,
					(case when s.RHSPEfhasta > <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> else s.RHSPEfhasta end) as hasta,
					<cf_dbfunction name='datediff' args='(case when s.RHSPEfdesde < #inicio_mes# then #inicio_mes# else s.RHSPEfdesde end),
														(case when s.RHSPEfhasta > #fin_mes# then #fin_mes# else s.RHSPEfhasta end) 
														'> + 1 as dias_incapacidad					
			from RHIndicadores a 
				inner join RHIndicadoresDetalle b	
					on a.RHIcodigo=b.RHIcodigo
				inner join RHSaldoPagosExceso s
					on s.RHTid=b.RHIDllave
					and s.RHSPEanulado = 0
					and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= s.RHSPEfhasta
					and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= s.RHSPEfdesde
				inner join DLaboralesEmpleado dle
					on dle.DLlinea=s.DLlinea
				inner join RHPlazas p 
					on  p.RHPid=dle.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
						<cfif isdefined("url.dependencias")>
							or cf.CFpath like '#rs_path.path#%'
						</cfif>
						)
					</cfif>	
			where a.RHIcodigo=30 				
		</cfquery>

		<!--- INICIO - aunsencias justificadas e injustificadas --->
		
			<!---Ausencias en Linea Tiempo--->
			<cfquery  name="rs1" datasource="#session.DSN#">		
				insert into #tbl_tmpLineaTiempo#( DEid, RHIDllave, desde, hasta, dias)
				select 	lt.DEid, 
						RHIDllave, 
						(case when lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(p,m,1)#"> then 
								<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(p,m,1)#"> 
							else lt.LTdesde end) as desde,
						(case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(p,m,daysinmonth(fin_mes))#">  then 
								<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(p,m,daysinmonth(fin_mes))#">
							else lt.LThasta end) as hasta,
						case when <cf_dbfunction name="datediff" args="lt.LTdesde, lt.LThasta,dd"> > 0 then
							<cf_dbfunction name="datediff" args="lt.LTdesde, lt.LThasta,dd"> +1
						else 0
						end as dias					
				from LineaTiempo lt
					inner join RHIndicadoresDetalle b 
						on lt.RHTid=b.RHIDllave	
						and b.RHIcodigo= 40 		<!---Ausentismo justificado--->		
					<!----Filtro de centro funcional---->
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						inner join RHPlazas p
							on p.RHPid=lt.RHPid					
						inner join CFuncional cf
							on cf.CFid=p.CFid
							and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or cf.CFpath like '#rs_path.path#%'
									</cfif>
								)
					</cfif>
				where <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= lt.LThasta
					and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= lt.LTdesde
			</cfquery>	
			<!---Ausencias en RHSaldoPagosExceso--->
			<cfquery name="rs2" datasource="#session.DSN#">
				insert into #tbl_tmpSaldosExceso#( DEid, RHIDllave, desde, hasta, dias)
				select 	se.DEid, 
						RHIDllave, 
						(case when se.RHSPEfdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(p,m,1)#"> then 
								<cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> 
						else se.RHSPEfdesde end) as desde,
						(case when se.RHSPEfhasta > <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> then 
								<cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> 
						else se.RHSPEfhasta end) as hasta,					
						case when <cf_dbfunction name="datediff" args="se.RHSPEfdesde, se.RHSPEfhasta,dd"> > 0 then
							<cf_dbfunction name="datediff" args="se.RHSPEfdesde, se.RHSPEfhasta,dd"> +1 
						else 0
						end as dias
				from RHSaldoPagosExceso se
					inner join RHIndicadoresDetalle b
						on se.RHTid=b.RHIDllave
						and b.RHIcodigo = 40	<!---Ausentismo justificado--->
					<!----Filtro de centro funcional---->
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						inner join LineaTiempo c	<!---Busca en la LT el centro funcional del empleado para el primer dia del mes para aplicar el filtro de CF--->
							on se.DEid = c.DEid
							and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> between c.LTdesde and c.LThasta
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
				where se.RHSPEanulado = 0
					and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <= se.RHSPEfhasta
					and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= se.RHSPEfdesde
			</cfquery>
			<!----Diferencia en dias repetidos--->
			<cfquery name="rs_diftotal" datasource="#session.DSN#">
				select coalesce((sum(a.dias)+sum(b.dias)),0) as diftotal
				from #tbl_tmpLineaTiempo# a
					inner join #tbl_tmpSaldosExceso# b
						on a.DEid = b.DEid
			</cfquery>
			<!---Dias "repetidos" por empleado--->
			<cfquery name="rs_repetidos" datasource="#session.DSN#">
				select  case when <cf_dbfunction name="datediff" args="	(case when a.desde < b.desde then b.desde else a.desde  end), 
																		(case when a.hasta > b.hasta then b.hasta else a.hasta  end),dd"> > 0 then
							<cf_dbfunction name="datediff" args="(case when a.desde < b.desde then b.desde else a.desde  end), 
																(case when a.hasta > b.hasta then b.hasta else a.hasta  end),dd">+1 
						else 0
						end as repetidos
				from #tbl_tmpLineaTiempo# a 
					inner join  #tbl_tmpSaldosExceso# b
						on a.DEid=b.DEid
				where	<!----1. registros se traslapan en fecha final de tabla 1 y fecha inicial de tabla 2---->
						( a.desde <= b.hasta and a.hasta >= b.desde )				
						<!---2. rango de fechas de tabla a contenido totalmente en registro de fechas de tabla b y viceversa ---->
						or 	( a.desde between b.desde and b.hasta  and a.hasta between b.desde and b.hasta )
						or 	( b.desde between a.desde and a.hasta  and b.hasta between a.desde and a.hasta )					
						<!---- 3. registros se traslapan en fecha final de tabla 2 y fecha inicial de tabla 1---->
						or	( b.desde <= a.hasta and b.hasta >= a.desde )				
			</cfquery>
			<cfset vn_justificada = 0>
			<cfif rs_repetidos.RecordCount NEQ 0>
				<cfset vn_justificada = rs_diftotal.diftotal-rs_repetidos.repetidos>
			<cfelse>
				<cfset vn_justificada = rs_diftotal.diftotal>
			</cfif>
			<!---=====================================================================================			
			=================== 1.1.4 calculo de total de ausencias injustificada ====================
			========================================================================================== --->				
			<cfquery name="rs_injustificadas" datasource="#session.DSN#">
				select 	<cf_dbfunction name='datediff' args='(case when a.LTdesde < #inicio_mes# then #inicio_mes# else a.LTdesde end),
															(case when a.LThasta > #fin_mes#  then #fin_mes# else a.LThasta end)	
															'> +1 as injustificadas
				from LineaTiempo a
					inner join RHIndicadoresDetalle b
						on a.RHTid = b.RHIDllave
						and b.RHIcodigo = 35  <!---Ausentismo injustificado--->
					<cfif isdefined("url.CFid") and len(trim(url.CFid))>
						inner join RHPlazas p
							on p.RHPid=a.RHPid
						inner join CFuncional cf
							on cf.CFid=p.CFid
							and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
									<cfif isdefined("url.dependencias")>
										or cf.CFpath like '#rs_path.path#%'
									</cfif>
								)
					</cfif>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#inicio_mes#"> <=  a.LThasta
					and <cfqueryparam cfsqltype="cf_sql_date" value="#fin_mes#"> >= a.LTdesde
			</cfquery>
		<!--- fin --->

		<!--- inserta la tabla principal --->
		<!---
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, dias_mes, total_empleados, total_dias_incapacidad, total_ausencia_justificada, total_ausencia_injustificada)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#daysinmonth(inicio_mes)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">, 
					0, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#vn_justificada#">,
					<cfif rs_injustificadas.RecordCount NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs_injustificadas.injustificadas#">
					<cfelse>
						0
					</cfif> )
		</cfquery>
		--->
		
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, dias_mes, total_empleados, total_dias_incapacidad, total_ausencia_justificada, total_ausencia_injustificada)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#daysinmonth(inicio_mes)#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">, 
					0, 
					0,
					0 )
		</cfquery>		
		
		
	</cfloop>
</cfloop>
<!---
<cfset fin_ciclo = now()>
Ciclo : <cfdump var="#abs(DateDiff('s', inicio_ciclo, fin_ciclo))#"><br />
--->

<!--- 1.1.5 Calcula periodo y mes para cada registro de las dos tablas temporales de LT y Saldos --->
<cfquery datasource="#session.DSN#">
	update #tbl_LineaTiempo#
	set  periodo = <cf_dbfunction name="date_part" args="YY,desde">,
	     mes = <cf_dbfunction name="date_part" args="MM,desde">
</cfquery>
<cfquery datasource="#session.DSN#">
	update #tbl_Saldos#
	set  periodo = <cf_dbfunction name="date_part" args="YY,desde">,
	     mes = <cf_dbfunction name="date_part" args="MM,desde">
</cfquery>

<!--- 1.1.6 Determina las fechas que se traslapan --->
<cfquery datasource="#session.DSN#">
	insert into #tbl_traslape#(DEid, desde, hasta)
	select 	a.DEid, 
			(case when a.desde < b.desde then b.desde else a.desde   end) as inicio_traslape,
			(case when a.hasta > b.hasta then b.hasta else a.hasta   end) as fin_traslape
	from #tbl_LineaTiempo# a, #tbl_Saldos# b
	where a.DEid=b.DEid	
		and (	<!--- 1. registros se traslapan en fecha final de tabla 1 y fech ainicial de tabla 2 --->
				( a.desde <= b.hasta and a.hasta >= b.desde )		
				<!--- 2. rango de fechas de tabla a contenido totalmente en registro de fechas d etabla b y viceversa  --->
				or 	( a.desde between b.desde and b.hasta  and a.hasta between b.desde and b.hasta )
				or 	( b.desde between a.desde and a.hasta  and b.hasta between a.desde and a.hasta )			
					<!--- 3. registros se traslapan en fecha final de tabla 2 y fech ainicial de tabla 1 --->
				or	( b.desde <= a.hasta and b.hasta >= a.desde )
			  )
</cfquery>

<!--- 1.1.7 Diferencia en dias de las fechas que se traslapan --->
<cfquery datasource="#session.DSN#">
	update #tbl_traslape#
	set dias = abs(<cf_dbfunction name="datediff" args="desde,hasta">)+1,			
	 	periodo =  <cf_dbfunction name="date_part" args="YY,desde">,
		mes = <cf_dbfunction name="date_part" args="MM,hasta">
</cfquery>

<!--- 1.1.8 Calculo del total de los dias que se traslapan, son restados de la tabla principal original --->
<cfquery datasource="#session.DSN#">
	update #tbl_principal#
		set total_dias_incapacidad = total_dias_incapacidad +( 	coalesce((	select sum(a.dias_incapacidad)
																		from #tbl_LineaTiempo# a
																		where a.periodo=#tbl_principal#.periodo
																			and a.mes=#tbl_principal#.mes), 0)
	  														)
</cfquery>
<cfquery datasource="#session.DSN#">
	update #tbl_principal#
		set total_dias_incapacidad = total_dias_incapacidad +( 	coalesce((	select sum(a.dias_incapacidad)
																			from #tbl_Saldos# a
																			where a.periodo=#tbl_principal#.periodo
																				and a.mes=#tbl_principal#.mes), 0)
		 													)
</cfquery>

<!--- 1.1.9 resta los dias que se contaron dobles --->
<cfquery datasource="#session.DSN#">
	update #tbl_principal#
		set total_dias_incapacidad = total_dias_incapacidad -( 	coalesce((	select sum(a.dias)
																			from #tbl_traslape# a
																			where a.periodo=#tbl_principal#.periodo
																				and a.mes=#tbl_principal#.mes), 0)
		 													 )
</cfquery>

<cfquery name="rs_datos" datasource="#session.DSN#">
	select periodo, mes, dias_mes, total_empleados, total_dias_incapacidad, total_ausencia_justificada, total_ausencia_injustificada
	from #tbl_principal#
	order by periodo, mes
</cfquery>

<!---
<cf_templatecss>
<table width="50%" border="1" align="center" cellpadding="1" cellspacing="0" >
	<cfoutput query="rs_datos">
		<tr>
			<td>#periodo#</td>
			<td>#mes#</td>
			<td width="5%" <cfif total_dias_incapacidad gt 0>bgcolor="##339900"</cfif>  >#total_dias_incapacidad#</td>
			<td width="5%" <cfif total_ausencia_justificada gt 0>bgcolor="##FFFF00"</cfif>>#total_ausencia_justificada#</td>
			<td width="5%" <cfif total_ausencia_injustificada gt 0>bgcolor="##FF0000"</cfif>>#total_ausencia_injustificada#</td>
		</tr>
	</cfoutput>
</table>
--->
<cfquery name="rs2" datasource="#session.DSN#">
	select distinct periodo
	from  #tbl_principal#
	order by periodo
</cfquery>

<!---
<cfset fin = now()>
Todos : <cfdump var="#abs(DateDiff('s', inicio, fin))#"><br />
--->

<cfsavecontent variable="data_xml_new" >
	<data>
		<variable name="<cfoutput>#xmlformat('DatosPeriodoMes')#</cfoutput>">
			<cfoutput query="rs_datos">
				<row>
					<column>#xmlformat(rs_datos.periodo)#</column>
					<column>#xmlformat(rs_datos.mes)#</column>
					<column>#xmlformat(total_empleados)#</column>
					<column>#xmlformat(rs_datos.dias_mes)#</column>
					<column>#xmlformat(rs_datos.total_dias_incapacidad)#</column>
					<column>#xmlformat(rs_datos.total_ausencia_justificada)#</column>
					<column>#xmlformat(rs_datos.total_ausencia_injustificada)#</column>
				</row>
			</cfoutput>
		</variable>
		
		<cfoutput><variable name="#xmlformat('DatosPeriodo')#"></cfoutput>
		<cfoutput query="rs2">
		<row><column>#xmlformat(rs2.periodo)#</column></row>
		</cfoutput>
		</variable>
	</data>
</cfsavecontent>

<!--- 
	El nombre del archivo XML debe ser unico, formado con la combinación de llaves que hacen a la informacion unica,
	para que todos los usuarios que ven el archivo con la misma combinación de llaves vean la misma informacion
	En este caso la combinacion es el IdEmpleado con el IdPuesto
--->
	<cfif isdefined("url.detalle")>
		<cfset parametrosr = "">
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			<cfset parametrosr= parametrosr & "&CFid=#url.CFid#"> 
		</cfif>
		<cfif isdefined("url.dependencias")>
			<cfset parametrosr= parametrosr & "&dependencias=#url.dependencias#"> 
		</cfif>
		<cf_htmlReportsHeaders 
			irA="tasa-ausentismo.cfm"
			FileName="tasaAusentismo.xls"
			method="url"
			title="Tasa de Ausentismo Laboral"
			param="#parametrosr#">
		<script type="text/javascript" language="javascript1.2">
			function fnImgBack(){
				<cfoutput>location.href = 'tasa-ausentismo.cfm?1=1'+'#parametrosr#';</cfoutput>
			}
		</script>

		<cfinvoke Key="LB_Tasa_de_Ausentismo_Laboral" Default="Tasa de Ausentismo Laboral" returnvariable="LB_IndRotacion" component="sif.Componentes.Translate" method="Translate"/>
		<style>
			.borde{
				border-right:1px solid black;
				border-bottom:1px solid black;
			}
		</style>
		
		<cfquery name="rs_idiomas" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
			from Idiomas a
				inner join VSidioma b
				on b.Iid = a.Iid
				and b.VSgrupo = 1
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idioma#">
			order by <cf_dbfunction name="to_number" args="b.VSvalor">			
		</cfquery>
		<cfset lista_meses = valuelist(rs_idiomas.m) >
		<cfif listlen(lista_meses) neq 12 >
			<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
		</cfif>

		<table width="80%" align="center" cellpadding="1" cellspacing="0">
			<tr>
				<td colspan="5" align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeTasaDeAusentismoLaboral">Detalle de Tasa de Ausentismo Laboral</cf_translate></strong></td>			
			</tr>
			<tr><td>&nbsp;</td></tr>

			<tr style="background-color:#FFFFCC;">
				<td width="12%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
				<td width="19%"><strong><cf_translate key="LB_CantEmpleados">Cant. Empleados</cf_translate></strong></td>
				<td width="19%" align="center" nowrap="nowrap"><strong><cf_translate key="LB_Incapacidades">Incapacidades</cf_translate></strong></td>
				<td width="18%" align="center" nowrap="nowrap"><strong><cf_translate key="LB_Renuncias">Ausencias Justificadas</cf_translate></strong></td>
				<td width="16%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Despidos">Ausencias Injustificadas</cf_translate></strong></td>
			</tr>

			<cfoutput query="rs_datos" group="periodo">
				<tr style="background-color:##F1F1F1"><td colspan="5" style=" border-bottom:1px solid black;">
					<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#rs_datos.periodo#</strong>
				</td></tr>
				<cfoutput>
					<tr>
						<td class="borde" style="border-left:1px solid black;">#listgetat(lista_meses, rs_datos.mes)#</td>
						<td class="borde" align="right">#rs_datos.total_empleados#</td>
						<td class="borde" align="right">#xmlformat(rs_datos.total_dias_incapacidad)#</td>
						<td class="borde" align="right">#xmlformat(rs_datos.total_ausencia_justificada)#</td>
						<td class="borde" align="right">#xmlformat(rs_datos.total_ausencia_injustificada)#</td>
					</tr>
				</cfoutput>
			</cfoutput>

		</table>
	<cfelse>
		<cfset irA = "">
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			<cfset irA = irA & "&CFid=#url.CFid#">
		</cfif>
		<cfif isdefined("url.dependencias")>
			<cfset irA = irA & "&dependencias=#url.dependencias#">
		</cfif>
		<cfoutput>
			<cf_viewFlash 
				movie = "ausentismo"
				XMLfilename = "Ausentismo2008_#session.Usucodigo#"
				XMLvalue = "#data_xml_new#"
				path = "rh/indicadores/ausentismo"
				irA			= "/cfmx/rh/indicadores/ausentismo/tasa-ausentismo.cfm?detalle=true#irA#" >
		</cfoutput>
		</div>				
	</cfif>		