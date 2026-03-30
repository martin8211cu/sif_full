<cfsetting requesttimeout="3600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="BTN_Regresar" Default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>		
<cfinvoke Key="LB_Centro_Funcional" Default="Centro Funcional"	 returnvariable="LB_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>						
<cfinvoke Key="LB_VariacionHoras" Default="Reporte Variaci&oacute;n horas vrs planificaci&oacute;n de horario" returnvariable="titulo" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
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

<!---Tabla temporal para almacenar todas las fechas del rango---->
<cf_dbtemp name="TempVariacion" returnvariable="TempVariacion" datasource="#session.DSN#">
	<cf_dbtempcol name="tmpfecha" 		 type="datetime"		mandatory="yes">
	<cf_dbtempcol name="tmpDEid" 		 type="numeric"			mandatory="yes">
	<cf_dbtempcol name="Empleado" 		 type="varchar(256)"	mandatory="no">
	<cf_dbtempcol name="tmpRHJid" 		 type="numeric"			mandatory="no">
	<cf_dbtempcol name="tmpPlanificado"  type="float"			mandatory="no">
	<cf_dbtempcol name="tmpReal" 		 type="float"			mandatory="no">
	<cf_dbtempcol name="tmpVariacion" 	 type="float"			mandatory="no">
	<cf_dbtempcol name="tmpCFuncional" 	 type="numeric"			mandatory="no">
	<cf_dbtempcol name="CentroFuncional" type="varchar(100)"	mandatory="no">
	<cf_dbtempcol name="tmpFeriado" 	 type="char(1)"			mandatory="no">
	<cf_dbtempcol name="tmpVacacion" 	 type="char(1)"			mandatory="no">
	<cf_dbtempcol name="tmpLibre" 		 type="char(1)"			mandatory="no">
	<cf_dbtempcol name="tmpEntrada" 	 type="datetime"		mandatory="no">
	<cf_dbtempcol name="tmpSalida" 		 type="datetime"		mandatory="no">
</cf_dbtemp>
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

	<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
		<cfset form.fdesde = url.fdesde>
	</cfif>
	
	<cfif isdefined("url.fHasta") and len(trim(url.fHasta))>
		<cfset form.fHasta = url.fHasta>
	</cfif>
	
	<!---Inserta las fechas, los empleados con su cfuncional correspondiente ---->
	<cfset vd_fecha  = CreateDateTime(year(LSParseDateTime(form.fdesde)), month(LSParseDateTime(form.fdesde)), day(LSParseDateTime(form.fdesde)), 00, 00,0)><!---Variable con la fecha---->
	<cfset vd_fechaFinal = CreateDateTime(year(LSParseDateTime(form.fHasta)), month(LSParseDateTime(form.fHasta)), day(LSParseDateTime(form.fHasta)), 00, 00,0)><!---Variable con la fecha---->

	<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
		<cfquery datasource="#session.DSN#">
			insert into #TempVariacion# (tmpfecha,tmpDEid,tmpCFuncional,tmpRHJid,Empleado,CentroFuncional)	
			select 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
					lt.DEid,
					a.CFid,
					lt.RHJid, 
					{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})}	as Empleado,
					d.CFdescripcion
			from RHPlazas a
				inner join LineaTiempo lt
					on a.RHPid = lt.RHPid
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#"> between lt.LTdesde and lt.LThasta
				inner join CFuncional d
					on  a.Ecodigo   = d.Ecodigo
					and a.CFid 		= d.CFid	
				inner join DatosEmpleado e
					on lt.Ecodigo = e.Ecodigo
					and lt.DEid = e.DEid

			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
			<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and a.CFid in (#cf_lista#)
			</cfif>				
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and e.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>	
		</cfquery>	
		<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
	</cfloop>			
	
	<!----Actualiza los días feriados ----->
	<cfquery datasource="#session.DSN#">
		update #TempVariacion#
			set tmpFeriado = '1'
		where exists(select 1
					from #TempVariacion# a
					inner join RHFeriados b
						on a.tmpfecha = b.RHFfecha
						and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					where a.tmpfecha = #TempVariacion#.tmpfecha
					  and a.tmpDEid = #TempVariacion#.tmpDEid)
	</cfquery>
	<!---Actualiza los dias de vacaciones ---->
	<cfquery datasource="#session.DSN#">
		update #TempVariacion#
			set tmpVacacion = '1'
		where exists(select 1
					from  #TempVariacion# a
					inner join LineaTiempo b
						on  <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> 
							between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd"> and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
						and a.tmpDEid = b.DEid
					inner join RHTipoAccion c
						on b.RHTid = c.RHTid
						and b.Ecodigo = c.Ecodigo
						and c.RHTcomportam = 3
					where a.tmpfecha = #TempVariacion#.tmpfecha
					  and a.tmpDEid = #TempVariacion#.tmpDEid)
	</cfquery>
	<!----Actualiza los datos de los días que si estan en el planificador--->
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempVariacion# set										
			<!---Prioridad al horario del planificador--->
			tmpLibre = (select case when <cf_dbfunction name="to_chartime" args="b.RHPJfinicio"> != <cf_dbfunction name="to_chartime" args="c.RHJhoraini"> then
						 <cf_dbfunction name="to_char" args="b.RHPlibre">
						else 									
							case when c.RHDJdia is null then '1'
							else
								<cf_dbfunction name="to_char" args="b.RHPlibre">
							end
						end
						from  #TempVariacion# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = #TempVariacion#.tmpfecha
						  and a.tmpDEid = #TempVariacion#.tmpDEid),
			tmpEntrada =  (select case when <cf_dbfunction name="to_chartime" args="b.RHPJfinicio"> != <cf_dbfunction name="to_chartime" args="c.RHJhoraini"> then 
							b.RHPJfinicio
						  else
							c.RHJhoraini
						  end
						from  #TempVariacion# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = #TempVariacion#.tmpfecha
						  and a.tmpDEid = #TempVariacion#.tmpDEid),													
			tmpSalida = (select case when <cf_dbfunction name="to_chartime" args="b.RHPJffinal"> != <cf_dbfunction name="to_chartime" args="c.RHJhorafin"> then 
							b.RHPJffinal
						else
							c.RHJhorafin
						end
						from  #TempVariacion# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						left outer join RHDJornadas c
							on b.RHJid = c.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = #TempVariacion#.tmpfecha
						  and a.tmpDEid = #TempVariacion#.tmpDEid)
		where exists(select 1
					from  #TempVariacion# a
					inner join RHPlanificador b
						on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
						and a.tmpDEid = b.DEid									
					left outer join RHDJornadas c
						on b.RHJid = c.RHJid
						and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
					where a.tmpfecha = #TempVariacion#.tmpfecha
					  and a.tmpDEid = #TempVariacion#.tmpDEid)
	</cfquery>	
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempVariacion# set
			tmpLibre = 	(select case <cf_dbfunction name="date_part" args="dw,a.tmpfecha">
							when  2 then ( case when RHJmon = 1 then '0' else '1' end ) 
							when  3 then ( case when RHJtue = 1 then '0' else '1' end ) 
							when  4 then ( case when RHJwed = 1 then '0' else '1' end ) 
							when  5 then ( case when RHJthu = 1 then '0' else '1' end ) 
							when  6 then ( case when RHJfri = 1 then '0' else '1' end ) 
							when  7 then ( case when RHJsat = 1 then '0' else '1' end ) 
							when  1 then ( case when RHJsun = 1 then '0' else '1' end ) 
						end
						from  #TempVariacion# a
						inner join RHJornadas c
							on a.tmpRHJid = c.RHJid
						left outer join RHDJornadas d
							on a.tmpRHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is not  null
						  and a.tmpfecha = #TempVariacion#.tmpfecha
						  and a.tmpDEid = #TempVariacion#.tmpDEid),
			tmpEntrada = (select d.RHJhoraini
							from  #TempVariacion# a
							inner join RHJornadas c
								on a.tmpRHJid = c.RHJid
							left outer join RHDJornadas d
								on a.tmpRHJid = d.RHJid
								and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
							where a.tmpRHJid is not  null
							  and a.tmpfecha = #TempVariacion#.tmpfecha
							  and a.tmpDEid = #TempVariacion#.tmpDEid),
			tmpSalida = (select d.RHJhorafin
						from  #TempVariacion# a
						inner join RHJornadas c
							on a.tmpRHJid = c.RHJid
						left outer join RHDJornadas d
							on a.tmpRHJid = d.RHJid
							and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is not  null
						  and a.tmpfecha = #TempVariacion#.tmpfecha
						  and a.tmpDEid = #TempVariacion#.tmpDEid)
		where exists(select 1
					from  #TempVariacion# a
					inner join RHJornadas c
						on a.tmpRHJid = c.RHJid
					left outer join RHDJornadas d
						on a.tmpRHJid = d.RHJid
						and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
					where a.tmpRHJid is not  null
					  and a.tmpfecha = #TempVariacion#.tmpfecha
					  and a.tmpDEid = #TempVariacion#.tmpDEid)
	</cfquery>				
	
	<!----Actualiza la tmpPlanificado----->
	<cfquery datasource="#session.DSN#">
		update #TempVariacion# set
			<cfif Application.dsinfo[session.DSN].type neq 'oracle'>
			tmpPlanificado = coalesce(datediff(hh, convert(varchar, tmpEntrada, 108), convert(varchar, tmpSalida, 108)),0)
			<cfelse>
			tmpPlanificado = (select coalesce(datediff('hh', c.tmpEntrada, c.tmpSalida),0)
							  from #TempVariacion# c
								where c.tmpfecha = #TempVariacion#.tmpfecha
								  and c.tmpDEid = #TempVariacion#.tmpDEid)
			</cfif>
		where exists(select 1
					from #TempVariacion# c
					where c.tmpfecha = #TempVariacion#.tmpfecha
					  and c.tmpDEid = #TempVariacion#.tmpDEid)
	</cfquery>	
	<!----Actualiza la tmpReal----->
	<cfquery datasource="#session.DSN#">
		update #TempVariacion# set
			 tmpReal = (select coalesce((CAMtotminlab/60),0)
			 			from #TempVariacion# a
						inner join RHCMCalculoAcumMarcas b
							on  a.tmpDEid    = b.DEid  
							and ((({fn YEAR(a.tmpfecha)} * 100 + {fn MONTH(a.tmpfecha)} ) * 100 ) + {fn DAYOFMONTH(a.tmpfecha)})  
							>=  ((({fn YEAR(b.CAMfdesde)} * 100   + {fn MONTH(b.CAMfdesde)}   ) * 100 ) + {fn DAYOFMONTH(b.CAMfdesde)})    
							and ((({fn YEAR(a.tmpfecha)} * 100 + {fn MONTH(a.tmpfecha)} ) * 100 ) + {fn DAYOFMONTH(a.tmpfecha)})  
							<=  ((({fn YEAR(b.CAMfhasta)} * 100   + {fn MONTH(b.CAMfhasta)}   ) * 100 ) + {fn DAYOFMONTH(b.CAMfhasta)})
						 where a.tmpfecha = #TempVariacion#.tmpfecha
						   and a.tmpDEid = #TempVariacion#.tmpDEid)
		where exists(select 1
					from #TempVariacion# a
					inner join RHCMCalculoAcumMarcas b
						on  a.tmpDEid    = b.DEid  
						and ((({fn YEAR(a.tmpfecha)} * 100 + {fn MONTH(a.tmpfecha)} ) * 100 ) + {fn DAYOFMONTH(a.tmpfecha)})  
						>=  ((({fn YEAR(b.CAMfdesde)} * 100   + {fn MONTH(b.CAMfdesde)}   ) * 100 ) + {fn DAYOFMONTH(b.CAMfdesde)})    
						and ((({fn YEAR(a.tmpfecha)} * 100 + {fn MONTH(a.tmpfecha)} ) * 100 ) + {fn DAYOFMONTH(a.tmpfecha)})  
						<=  ((({fn YEAR(b.CAMfhasta)} * 100   + {fn MONTH(b.CAMfhasta)}   ) * 100 ) + {fn DAYOFMONTH(b.CAMfhasta)})
					 where a.tmpfecha = #TempVariacion#.tmpfecha
					   and a.tmpDEid = #TempVariacion#.tmpDEid)  
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #TempVariacion# set
			 tmpReal = coalesce(tmpReal,0)
	</cfquery>		

	<cfquery name="rsVariacionHoras" datasource="#session.DSN#" >
		select tmpfecha,Empleado,tmpCFuncional,CentroFuncional,tmpPlanificado,tmpReal,tmpFeriado,tmpVacacion,tmpLibre
		from #TempVariacion#
		order by tmpCFuncional,tmpDEid,tmpfecha
	</cfquery>
	<!--- <cfdump var="#rsVariacionHoras#"> --->

	<cfif rsVariacionHoras.RecordCount gt 0 and rsVariacionHoras.RecordCount lt 10000 >
			<cfset LvarFileName = "VariacionHoras_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<cf_htmlReportsHeaders 
				title="#titulo#" 
				filename="#LvarFileName#"
				irA="VariacionHoras.cfm" 
				>
			<cfif not isdefined("form.btnDownload")>
				<cf_templatecss>
			</cfif>	
	</cfif>	
	
	<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
		<cfif rsVariacionHoras.RecordCount GT 10000>
			<tr><td align="center"><strong><cf_translate key="LB_LaCantidadDeRegistrosSobrepasaElLimite">La cantidad de registros sobrepasa el l&iacute;mite, por favor utilice mas filtros o cambie los seleccionados</cf_translate></strong></td></tr>
		<cfelse>
			<cfoutput>	
			<tr> 
				<td colspan="5">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
					<tr> 
						<td colspan="5" nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
					</tr>
					<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
						<td nowrap colspan="5" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>	
					</tr>	
					<tr>
						<td colspan="5" class="LetraTitulo" align="center">
							<cf_translate key="LB_Desde">Desde</cf_translate>
							:&nbsp;
							#Form.fdesde# 
							<cf_translate key="LB_Hasta">Hasta</cf_translate>
							:&nbsp;
							#Form.fHasta# 
						</td>
					</tr>	
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>
			<!--- <cf_dump var="#rsVariacionHoras#"> --->
			<cfif isdefined("rsVariacionHoras") and rsVariacionHoras.RecordCount NEQ 0>
				<cfoutput query="rsVariacionHoras" group="tmpCFuncional">
					<tr>
						<td colspan="5" style=" border-bottom:1px solid black;"><strong>#LB_Centro_Funcional#&nbsp;:&nbsp;#rsVariacionHoras.CentroFuncional#</strong></td></tr>
					</tr>			
					<tr>
						<td nowrap align="left"   valign="bottom" width="30%" class="areaFiltro"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>				
						<td nowrap align="center" valign="bottom" width="5%" class="areaFiltro"><cf_translate key="LB_DiaPlanificado">D&iacute;a Planificado</cf_translate></td>	
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_TiempoPlanificado">Tiempo Planificado</cf_translate></td>
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_TiempoTrabajado">Tiempo Trabajado</cf_translate></td>
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_PorcentajeVariacion">Porcentaje Variaci&oacute;n</cf_translate></td>
					</tr>
					<cfoutput>
						<tr>
							<td align="left"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsVariacionHoras.Empleado#</td>
							<td align="center"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#LSDateFormat(rsVariacionHoras.tmpfecha,'dd/mm/yyyy')#</td>
							<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">
								<cfif tmpFeriado EQ 1>
									<cf_translate  key="LB_Feriado">Feriado</cf_translate> 
								<cfelseif tmpVacacion EQ 1>
									<cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate>
								<cfelseif tmpLibre EQ 1>
									<cf_translate  key="LB_Libre">Libre</cf_translate>
								<cfelse>
									#LSNumberFormat(rsVariacionHoras.tmpPlanificado, ',.99')#
								</cfif>															
							</td>
							<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat(rsVariacionHoras.tmpReal, ',.99')#</td>
							<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">
								<cfif tmpFeriado EQ 1 and tmpReal gt  0 >
									100%
								<cfelseif tmpVacacion EQ 1 and tmpReal gt 0 >
									100%
								<cfelseif tmpLibre EQ 1  and tmpReal gt 0>
									100%
								<cfelseif tmpPlanificado  gt 0 and tmpReal eq 0>	
									0%
								<cfelseif tmpPlanificado  gt 0 and tmpReal gt 0>
									#LSNumberFormat(((rsVariacionHoras.tmpReal /rsVariacionHoras.tmpPlanificado)*100)-100, ',.99')#
								<cfelse>
									 &nbsp;
								</cfif>	
								
							</td>
						</tr>
					</cfoutput>

				</cfoutput>
				<tr>
					<td colspan="5" align="center"><strong>------ <cf_translate key="LB_Ultimalinea">&Uacute;ltima l&iacute;nea</cf_translate> ------</strong></td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="5" align="center"><strong>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</strong></td>
				</tr>
			</cfif>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>