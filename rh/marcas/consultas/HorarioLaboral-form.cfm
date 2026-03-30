<cfsetting requesttimeout="3600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Enero" Default="Enero" returnvariable="LB_Enero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Febrero" Default="Febrero" returnvariable="LB_Febrero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Marzo" Default="Marzo" returnvariable="LB_Marzo" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Abril" Default="Abril" returnvariable="LB_Abril" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Mayo" Default="Mayo" returnvariable="LB_Mayo" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Junio" Default="Junio" returnvariable="LB_Junio" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Julio" Default="Julio" returnvariable="LB_Julio" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Agosto" Default="Agosto" returnvariable="LB_Agosto" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Setiembre" Default="Setiembre" returnvariable="LB_Setiembre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Octubre" Default="Octubre" returnvariable="LB_Octubre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Noviembre" Default="Noviembre" returnvariable="LB_Noviembre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Diciembre" Default="Diciembre" returnvariable="LB_Diciembre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Lunes" Default="Lunes" returnvariable="LB_Lunes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Martes" Default="Martes" returnvariable="LB_Martes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Miercoles" Default="Miércoles" returnvariable="LB_Miercoles" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jueves" Default="Jueves" returnvariable="LB_Jueves" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Viernes" Default="Viernes" returnvariable="LB_Viernes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Sabado" Default="Sábado" returnvariable="LB_Sabado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Domingo" Default="Domingo" returnvariable="LB_Domingo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Regresar" Default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>		
<cfinvoke Key="LB_Centro_Funcional" Default="Centro Funcional" returnvariable="LB_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>						
<cfinvoke Key="LB_Total_Empleados" Default="Total Empleados" returnvariable="LB_Total_Empleados" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_HorarioLaboral" Default="Reporte de Horario Laboral" returnvariable="titulo1" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorarioLaboralConDetalleCosto" Default="Reporte de Horario Laboral con detalle de costo" returnvariable="titulo2" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("form.Costo") and form.Costo eq 'S'>
	<cfset titulo = titulo2>
<cfelse>
	<cfset titulo = titulo1>
</cfif>							

	
<style>
	.LetraHora{
		font-size:9px
	}
	.LetraTitulo{
		font-size:10px;
		font-weight:bold;
	}
	.LetraEmpleado{
		font-size:10px;
	}
</style>

<!--- ************************************************************* --->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, 0 as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>
<!--- ************************************************************* --->
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset form.CFid = url.CFid>
	</cfif>	
	
	<cfif isdefined("form.CFid") and len(trim(form.CFid)) >
		<cfif isdefined("form.dependencias") >
			<cfset cf = getCentrosFuncionalesDependientes(form.CFid) >
			<cfset cf_lista = valuelist(cf.CFid) >
		<cfelse>
			<cfset cf_lista = form.CFid >
		</cfif>
	</cfif>
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<cfset form.DEid = url.DEid>
	</cfif>	

	<cfset meses = "#LB_Enero#,#LB_Febrero#,#LB_Marzo#,#LB_Abril#,#LB_Mayo#,#LB_Junio#,#LB_Julio#,#LB_Agosto#,#LB_Setiembre#,#LB_Octubre#,#LB_Noviembre#,#LB_Diciembre#">

	<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
		<cfset form.fdesde = url.fdesde>
	</cfif>
	<cfset vd_fechaFinal = DateAdd("d", 6, "#LSParseDateTime(form.fdesde)#")>	
	<!---- Tabla temporal para almacenar las fechas del rango---->
	<cf_dbtemp name="TempDias" returnvariable="TempDias" datasource="#session.DSN#">
		<cf_dbtempcol name="tmpDfecha" 		type="datetime"		mandatory="yes">		
		<cf_dbtempcol name="tmpDDia" 		type="varchar(15)"	mandatory="no">
	</cf_dbtemp>		
	
	<!---Tabla temporal para almacenar todas las fechas del rango---->
	<cf_dbtemp name="TempCMHL" returnvariable="TempCMHL" datasource="#session.DSN#">
		<cf_dbtempcol name="tmpfecha" 		type="datetime"		mandatory="yes">
		<cf_dbtempcol name="tmpDEid" 		type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpPuesto" 		type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="tmpRHJid" 		type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpLibre" 		type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpEntrada" 	type="datetime"		mandatory="no">
		<cf_dbtempcol name="tmpSalida" 		type="datetime"		mandatory="no">
		<cf_dbtempcol name="tmpDiferencia" 	type="float"		mandatory="no">
		<cf_dbtempcol name="tmpDia" 		type="varchar(15)"	mandatory="no">
		<cf_dbtempcol name="tmpFeriado" 	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpVacacion" 	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpCFuncional" 	type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpLTsalario" 			type="money"		mandatory="no">
		<cf_dbtempcol name="tmpFactorDiasSalario" 	type="varchar(100)"	mandatory="no">
		<cf_dbtempcol name="tmpRHJhoradiaria" 		type="money"		mandatory="no">		
	</cf_dbtemp>														

	<!---Inserta las fechas, los empleados con su cfuncional correspondiente ---->
	<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fdesde)), month(LSParseDateTime(form.fdesde)), day(LSParseDateTime(form.fdesde)), 00, 00,0)><!---Variable con la fecha---->
	<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
		<cfquery datasource="#session.DSN#">
			insert into #TempDias# (tmpDfecha)
			values (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">)
		</cfquery>
		<cfquery datasource="#session.DSN#">
			insert into #TempCMHL# (tmpfecha,tmpDEid,tmpCFuncional,tmpPuesto,tmpLTsalario,tmpFactorDiasSalario,tmpRHJhoradiaria)	
			select 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
					lt.DEid,
					a.CFid,
					c.RHPdescpuesto, 
					LTsalario,
					FactorDiasSalario,
					RHJhoradiaria		
			from RHPlazas a
				inner join LineaTiempo lt
					on a.RHPid = lt.RHPid
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#"> between lt.LTdesde and lt.LThasta
				inner join RHPuestos c
					on a.Ecodigo = c.Ecodigo
					and a.RHPpuesto = c.RHPcodigo
				inner join RHJornadas rhj
					on lt.Ecodigo = rhj.Ecodigo 
					and lt.RHJid = rhj.RHJid 
				inner join TiposNomina  tpn
					on lt.Ecodigo = tpn.Ecodigo
					and lt.Tcodigo = tpn.Tcodigo					

			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
			<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and a.CFid in (#cf_lista#)
		    </cfif>				
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>	
			
		</cfquery>			
		<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
	</cfloop>
	<!---Actualiza el dia de la semana---->
	<cfquery datasource="#session.DSN#">
		update #TempDias# set 								
			tmpDDia = case <cf_dbfunction name="date_part" args="dw,tmpDfecha">
						when 2 then
							'#LB_Lunes#'
						when 3 then
							'#LB_Martes#'
						when 4 then 
							'#LB_Miercoles#'
						when 5 then 
							'#LB_Jueves#'
						when 6 then
							'#LB_Viernes#'
						when 7 then
							'#LB_Sabado#'
						when 1 then
							'#LB_Domingo#'	
					end								
	</cfquery>	
	<!----Actualiza el dia de la semana---->
	<cfquery datasource="#session.DSN#">
		update #TempCMHL# set 								
			tmpDia = case  <cf_dbfunction name="date_part" args="dw,tmpfecha"> 
						when 2 then
							'#LB_Lunes#'
						when 3 then
							'#LB_Martes#'
						when 4 then 
							'#LB_Miercoles#'
						when 5 then 
							'#LB_Jueves#'
						when 6 then
							'#LB_Viernes#'
						when 7 then
							'#LB_Sabado#'
						when 1 then
							'#LB_Domingo#'	
					end								
	</cfquery>								
	<!----Actualiza los días feriados ----->
	<cfquery datasource="#session.DSN#">
		update #TempCMHL#
			set tmpFeriado = (select '1'
							  from #TempCMHL# a
								inner join RHFeriados b
									on a.tmpfecha = b.RHFfecha
									and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								where a.tmpfecha = 	#TempCMHL#.tmpfecha
								  and a.tmpDEid = #TempCMHL#.tmpDEid)
		where exists(select 1
		from #TempCMHL# a
			inner join RHFeriados b
				on a.tmpfecha = b.RHFfecha
				and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.tmpfecha = 	#TempCMHL#.tmpfecha
		  and a.tmpDEid = #TempCMHL#.tmpDEid)
	</cfquery>	
	<!---Actualiza los dias de vacaciones ---->
	<cfquery datasource="#session.DSN#">
		update #TempCMHL#
			set tmpVacacion = '1'
		where exists(select 1
					from  #TempCMHL# a
						inner join LineaTiempo b
							on  <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> 
							between  <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd"> and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
							and a.tmpDEid = b.DEid
						inner join RHTipoAccion c
							on b.RHTid = c.RHTid
							and b.Ecodigo = c.Ecodigo
							and c.RHTcomportam = 3
					where a.tmpfecha = 	#TempCMHL#.tmpfecha
					  and a.tmpDEid = #TempCMHL#.tmpDEid)
	</cfquery>														
	<!----Actualiza los datos de los días que si estan en el planificador--->
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempCMHL# set										
			<!---Prioridad al horario del planificador--->
			tmpLibre = (select case when <cf_dbfunction name="to_chartime" args="b.RHPJfinicio"> != <cf_dbfunction name="to_chartime" args="c.RHJhoraini"> then
							 <cf_dbfunction name="to_char" args="b.RHPlibre">
							else 									
								case when c.RHDJdia is null then '1'
								else
									<cf_dbfunction name="to_char" args="b.RHPlibre">
								end
							end
						from  #TempCMHL# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid) , 										
			tmpEntrada = (select case when <cf_dbfunction name="to_chartime" args="b.RHPJfinicio"> != <cf_dbfunction name="to_chartime" args="c.RHJhoraini"> then 
							b.RHPJfinicio
						  else
							c.RHJhoraini
						  end
						from  #TempCMHL# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid),													
			tmpSalida = (select case when <cf_dbfunction name="to_chartime" args="b.RHPJffinal">!= <cf_dbfunction name="to_chartime" args="c.RHJhorafin"> then 
							b.RHPJffinal
						else
							c.RHJhorafin
						end
						from  #TempCMHL# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid),
			tmpRHJid = (select b.RHJid
						from  #TempCMHL# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid) 
		where exists(select 1
					from  #TempCMHL# a
					inner join RHPlanificador b
						on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
						and a.tmpDEid = b.DEid									
					
					left outer join RHDJornadas c
						on b.RHJid = c.RHJid
						and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
					where a.tmpfecha = 	#TempCMHL#.tmpfecha
					  and a.tmpDEid = #TempCMHL#.tmpDEid)
	</cfquery>	
	<!----Actualiza los días que estan definidos en la linea del tiempo ---->
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempCMHL# set
			tmpLibre = 	(select case <cf_dbfunction name="date_part" args="dw,a.tmpfecha">
									when  2 then ( case when RHJmon = 1 then '0' else '1' end ) 
									when  3 then ( case when RHJtue = 1 then '0' else '1' end ) 
									when  4 then ( case when RHJwed = 1 then '0' else '1' end ) 
									when  5 then ( case when RHJthu = 1 then '0' else '1' end ) 
									when  6 then ( case when RHJfri = 1 then '0' else '1' end ) 
									when  7 then ( case when RHJsat = 1 then '0' else '1' end ) 
									when  1 then ( case when RHJsun = 1 then '0' else '1' end ) 
								end
						from  #TempCMHL# a
						inner join LineaTiempo b
						  	on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> 
								between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd">  
								and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd"> 
							and a.tmpDEid = b.DEid
						
						inner join RHJornadas c
							on b.RHJid = c.RHJid
						
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid)	,
			tmpEntrada = (select d.RHJhoraini
						from  #TempCMHL# a
						inner join LineaTiempo b
						  	on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd">  
								between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd">  
								and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
							and a.tmpDEid = b.DEid
						
						inner join RHJornadas c
							on b.RHJid = c.RHJid
						
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid)	,
			tmpSalida = (select d.RHJhorafin
						from  #TempCMHL# a
						inner join LineaTiempo b
						  	on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd">  
								between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd">  
								and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
							and a.tmpDEid = b.DEid
						
						inner join RHJornadas c
							on b.RHJid = c.RHJid
						
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid),
			tmpRHJid = (select b.RHJid												
							from  #TempCMHL# a
						inner join LineaTiempo b
						  	on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd">  
								between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd">  
								and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
							and a.tmpDEid = b.DEid
						
						inner join RHJornadas c
							on b.RHJid = c.RHJid
						
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid)
		where exists (	select 1
					  	from  #TempCMHL# a
						inner join LineaTiempo b
						  	on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd">  
								between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd">  
								and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
							and a.tmpDEid = b.DEid
						
						inner join RHJornadas c
							on b.RHJid = c.RHJid
						
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = 	#TempCMHL#.tmpfecha
						  and a.tmpDEid = #TempCMHL#.tmpDEid)			
										
	</cfquery>		
	<!--- VARIABLES DE CONVERSION --->
	<cf_dbfunction name="to_chartime" args="c.tmpEntrada" returnvariable="Lvar_tmpEntrada">
	<cf_dbfunction name="to_chartime" args="c.tmpSalida" returnvariable="Lvar_tmpSalida">
	<!----Actualiza la diferencia----->
	<cfquery datasource="#session.DSN#">
		update #TempCMHL# set
				<cfif Application.dsinfo[session.DSN].type neq 'oracle'>
			 		tmpDiferencia = (select datediff(hh,convert(varchar,c.tmpEntrada,108),convert(varchar,c.tmpSalida,108))
									from #TempCMHL# c
									where c.tmpfecha = 	#TempCMHL#.tmpfecha
									  and c.tmpDEid = #TempCMHL#.tmpDEid)
				<cfelse>
					tmpDiferencia = (select datediff('hh',c.tmpEntrada,c.tmpEntrada)
									from #TempCMHL# c
									where c.tmpfecha = 	#TempCMHL#.tmpfecha
									  and c.tmpDEid = #TempCMHL#.tmpDEid)
				</cfif>
		where exists(select 1
					from #TempCMHL# c
					where c.tmpfecha = 	#TempCMHL#.tmpfecha
					  and c.tmpDEid = #TempCMHL#.tmpDEid)
	</cfquery>

	<cfquery name="rsHorario" datasource="#session.DSN#" >
		select 	tmpDia,
				tmpfecha,
				tmpPuesto,
				tmpLTsalario,tmpFactorDiasSalario,tmpRHJhoradiaria,
				<cf_dbfunction name="date_format" args="tmpfecha,yyyymmdd"> as fechaCompara,
				tmpDiferencia,
				tmpLibre,
				tmpVacacion,
				tmpFeriado,		
				tmpCFuncional,	
				tmpEntrada as HoraInicio,
				tmpSalida as HoraSalida,
				a.tmpDEid,				
				(select coalesce(sum(tmpDiferencia),0)
				from #TempCMHL# c
				where a.tmpDEid = c.tmpDEid
				) as TotalEmpleado										
		from  #TempCMHL# a			
		order by a.tmpCFuncional, a.tmpDEid, a.tmpfecha asc
	</cfquery>

	<cfquery name="rsDias" datasource="#session.DSN#">
		select tmpDfecha,tmpDDia from #TempDias#
		order by tmpDfecha asc
	</cfquery>
	
	<cfif rsHorario.RecordCount gt 0 and rsHorario.RecordCount lt 10000 >
			<cfset LvarFileName = "HorarioLaboral#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	
			<cfif isdefined("form.Costo") and form.Costo eq 'S'>
				<cfset ir  = 'HorarioLaboralCosto.cfm'>
			<cfelse>
				<cfset ir  = 'HorarioLaboral.cfm'>
			</cfif>
	
			<cf_htmlReportsHeaders 
				title="Balance General" 
				filename="#LvarFileName#"
				irA="#ir#" 
				>
			<cfif not isdefined("form.btnDownload")>
				<cf_templatecss>
			</cfif>	
	</cfif>	
	
	
	<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
		<cfif rsHorario.RecordCount GT 10000>
			<tr><td align="center"><strong><cf_translate key="LB_LaCantidadDeRegistrosSobrepasaElLimite">La cantidad de registros sobrepasa el l&iacute;mite, por favor utilice mas filtros o cambie los seleccionados</cf_translate></strong></td></tr>
		<cfelse>
			<cfoutput>	
			<tr> 
				<td colspan="<cfif isdefined("form.Costo") and form.Costo eq 'S'>12<cfelse>10</cfif>">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
					<tr > 
						<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
					</tr>
					<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
						<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>		</strong>
					</tr>	
					<tr>
						<td class="LetraTitulo" align="center">
							<cf_translate key="LB_FechaHora">Fecha</cf_translate>:&nbsp;
							#LSDateFormat(now(),'dd/mm/yyyy')# - #LSTimeFormat(now(),'HH:mm')#
						</td>
					</tr>	
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>
			<cfif isdefined("rsHorario") and rsHorario.RecordCount NEQ 0>
				<tr>
					<td nowrap valign="bottom" width="10%" class="LetraTitulo"><cf_translate key="LB_Empleado">Nombre Empleado</cf_translate></td>				
					<td nowrap valign="bottom" width="10%" class="LetraTitulo"><cf_translate key="LB_Puesto">Puesto</cf_translate></td>	
					<cfoutput query="rsDias">
						<td width="5%" align="center" class="LetraTitulo" valign="top">
							#rsDias.tmpDDia# <br> #LSDateFormat(rsDias.tmpDfecha,'dd/mm/yyyy')#
						</td>
					</cfoutput>
					<td width="3%" class="LetraTitulo" align="right"><cf_translate key="LB_Total">Total</cf_translate></td>
					<!--- ************************ --->
					
					<cfif isdefined("form.Costo") and form.Costo eq 'S'>
						<td width="3%" class="LetraTitulo" align="right"><cf_translate key="LB_CostoXHora">Costo x hora</cf_translate></td>
						<td width="3%" class="LetraTitulo" align="right"><cf_translate key="LB_CostoTotal">Costo Total</cf_translate></td>
					</cfif>
					
				</tr>
				<cfset vs_corteCFuncional = ''><!---Variable con el corte por centro funcional--->
				<cfset vn_CFuncional = 0>	<!---Variable con la cantidad de horas por cfuncional--->
				<cfset vn_Empldisp1  = 0>	<!---Empleados disponibles lunes--->
				<cfset vn_Empldisp2  = 0>	<!---Empleados disponibles martes--->
				<cfset vn_Empldisp3  = 0>	<!---Empleados disponibles miercoles--->
				<cfset vn_Empldisp4  = 0>	<!---Empleados disponibles jueves--->
				<cfset vn_Empldisp5  = 0>	<!---Empleados disponibles viernes--->
				<cfset vn_Empldisp6  = 0>	<!---Empleados disponibles sabado--->
				<cfset vn_Empldisp7  = 0>	<!---Empleados disponibles domingo--->
				<cfset vn_totalCostoGral  = 0>	<!---Variable con el total de costo gral---->
				<cfset vn_totalGral = 0>		<!---Variable con el total de horas gral---->
				<cfoutput query="rsHorario" group="tmpDEid">				
					<cfset vn_empleado = rsHorario.tmpDEid>
					<cfset vn_Puesto   = rsHorario.tmpPuesto>
					
					<!---Obtener datos de empleado--->
					<cfquery name="rsEmpleado" datasource="#session.DSN#">
						select {fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})}	as Empleado
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHorario.tmpDEid#">
					</cfquery>
					<!---Obtener datos de centro funcional--->
					<cfquery name="rsCFuncional" datasource="#session.DSN#">
						select {fn concat(CFcodigo,{fn concat(' - ',CFdescripcion)})} as CFuncional
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHorario.tmpCFuncional#">
					</cfquery>



					<!---Pintar el corte--->
					<cfif vs_corteCFuncional NEQ tmpCFuncional>					
						<!---Pintar el total del centro funcional---->
						<cfif rsHorario.CurrentRow NEQ 1>
							<tr>
								<td align="left"  style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;"><strong>#LB_Total_Empleados#</strong></td>
								<td align="right" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">&nbsp;</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp1#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp2#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp3#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp4#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp5#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp6#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp7#</td>
								<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_CFuncional#</td>
								<cfif isdefined("form.Costo") and form.Costo eq 'S'>
									<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
									<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat(vn_totalCostoGral , ',.__')#</td>
								</cfif>
							</tr>
						</cfif>
						<tr class="TituloListas">
						<td colspan="<cfif isdefined("form.Costo") and form.Costo eq 'S'>12<cfelse>10</cfif>" style=" border-bottom:1px solid black;"><strong>#LB_Centro_Funcional#&nbsp;:&nbsp;#rsCFuncional.CFuncional#</strong></td></tr>
						<cfset vn_CFuncional = 0>
						<cfset vn_Empldisp1  = 0>	
						<cfset vn_Empldisp2  = 0>	
						<cfset vn_Empldisp3  = 0>	
						<cfset vn_Empldisp4  = 0>	
						<cfset vn_Empldisp5  = 0>	
						<cfset vn_Empldisp6  = 0>	
						<cfset vn_Empldisp7  = 0>
						<cfset vn_totalCostoGral  = 0>	
					</cfif>
					<tr>
						<td width="20%" nowrap class="LetraEmpleado" valign="top" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsEmpleado.Empleado#</td>					
						<td width="10%" nowrap class="LetraEmpleado" valign="top" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#vn_Puesto#</td>					
				
				
						<cfloop query="rsDias">
							<cfset vn_fecha = LSDateFormat(rsDias.tmpDfecha, "yyyymmdd")> 
							<cfquery name="rsDatos" dbtype="query">
								select 	tmpfecha,
										tmpDiferencia,
										tmpLibre,
										tmpVacacion,
										tmpFeriado,		
										HoraInicio,
										HoraSalida								 
								from rsHorario
								where fechaCompara = '#vn_fecha#'
									and tmpDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vn_empleado#">
							</cfquery>

							<cfif len(trim(rsDatos.HoraInicio)) and len(trim(rsDatos.HoraSalida))>
								<cfset vd_HoraInicio = LSTimeFormat(rsDatos.HoraInicio,'HH:mm')>
								<cfset vd_HoraSalida = LSTimeFormat(rsDatos.HoraSalida,'HH:mm')>
								<td width="5%" class="LetraHora" valign="top" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">
									#vd_HoraInicio# - #vd_HoraSalida#
								</td>
								<cfif rsDias.currentRow EQ 1>
									<cfset vn_Empldisp1  = vn_Empldisp1 + 1>
									
								<cfelseif rsDias.currentRow EQ 2>
									
									<cfset vn_Empldisp2  = vn_Empldisp2 + 1>
									
								<cfelseif rsDias.currentRow EQ 3>
									
									<cfset vn_Empldisp3  = vn_Empldisp3 + 1>
									
								<cfelseif rsDias.currentRow EQ 4>
									
									<cfset vn_Empldisp4  = vn_Empldisp4 + 1>
									
								<cfelseif rsDias.currentRow EQ 5>
									
									<cfset vn_Empldisp5  = vn_Empldisp5 + 1>
									
								<cfelseif rsDias.currentRow EQ 6>
									
									<cfset vn_Empldisp6  = vn_Empldisp6 + 1>
									
								<cfelseif rsDias.currentRow EQ 7>
									
									<cfset vn_Empldisp7  = vn_Empldisp7 + 1>
									
								</cfif>
							<cfelse>						
								<td class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;" align="center">
									<cfif rsDatos.tmpFeriado EQ 1>
										<cf_translate  key="LB_Feriado">Feriado</cf_translate> 
									<cfelseif rsDatos.tmpVacacion EQ 1>
										<cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate>
									<cfelseif rsDatos.tmpLibre EQ 1>
										<cf_translate  key="LB_Libre">Libre</cf_translate>
									<cfelse>
										&nbsp;
									</cfif>									
								</td>
							</cfif>
						</cfloop>
						<td class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;" width="3%" align="right">#rsHorario.TotalEmpleado#</td>	
						
						<!--- ************************ --->
						<cfset vn_Costoxhora = ((rsHorario.tmpLTsalario / rsHorario.tmpFactorDiasSalario) /rsHorario.tmpRHJhoradiaria)>	
						<cfset vn_CostoTotal = vn_Costoxhora * rsHorario.TotalEmpleado>	
						<cfset vn_totalCostoGral = vn_totalCostoGral + vn_CostoTotal>
						
						<!--- ************************ --->
						<cfif isdefined("form.Costo") and form.Costo eq 'S'>
							<td class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;" width="3%" align="right">#LSNumberFormat(vn_Costoxhora , ',.__')#</td>	
							<td class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;" width="3%" align="right">#LSNumberFormat(vn_CostoTotal , ',.__')#</td>							
						</cfif>
						<cfset vs_corteCFuncional = tmpCFuncional>
						<cfset vn_CFuncional = vn_CFuncional + rsHorario.TotalEmpleado>
						<cfset vn_totalGral = vn_totalGral + rsHorario.TotalEmpleado>
					</tr>
				</cfoutput>
				<cfoutput>
					<!---Pintar el total del ultimo cfuncional--->
					<tr>
						<td align="left"  style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;"><strong>#LB_Total_Empleados#</strong></td>
						<td align="right" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">&nbsp;</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp1#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp2#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp3#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp4#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp5#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp6#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_Empldisp7#</td>
						<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#vn_CFuncional#</td>
						<cfif isdefined("form.Costo") and form.Costo eq 'S'>
							<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
							<td align="right" class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat(vn_totalCostoGral , ',.__')#</td>
						</cfif>
					</tr>
					<tr>
						<td align="right" colspan="<cfif isdefined("form.Costo") and form.Costo eq 'S'>11<cfelse>9</cfif>" class="LetraTitulo"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>:&nbsp;</strong></td>
						<td align="right"><strong>#vn_totalGral#</strong></td>
					</tr>
				</cfoutput>
				<tr>
					<td colspan="<cfif isdefined("form.Costo") and form.Costo eq 'S'>12<cfelse>10</cfif>" align="center"><strong>------ <cf_translate key="LB_Ultimalinea">&Uacute;ltima l&iacute;nea</cf_translate> ------</strong></td>
				</tr>
				
			<cfelse>
				<tr>
					<td colspan="<cfif isdefined("form.Costo") and form.Costo eq 'S'>12<cfelse>10</cfif>" align="center"><strong>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</strong></td>
				</tr>
			</cfif>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>