<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cfquery name="rsParametro" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 1030
</cfquery>
<!----Datos de los filtros--->
<cfif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2"> as Empleado
		from DatosEmpleado d
		where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>	
</cfif>
<cfif isdefined("form.RHTOid") and len(trim(form.RHTOid))>
	<cfquery name="rsTipoObjetivo" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="RHTOcodigo,' - ',RHTOdescripcion"> as TipoObjetivo
		from RHTipoObjetivo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHTOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTOid#">
	</cfquery>
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	i.RHOSid
			,i.RHOScodigo
			,i.RHOStexto
			,g.DEid
			,<cf_dbfunction name="concat" args="d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2"> as Evaluado			
			,g.DEideval
			,<cf_dbfunction name="concat" args="m.DEnombre,' ',m.DEapellido1,' ',m.DEapellido2"> as Evaluador
			,e.RHIEid
			,b.RHDRid
			,b.RHDRfinicio as inicio
			,b.RHDRffin as fin
			,e.RHIEporcentaje
			,coalesce(g.RHREnota,0) as RHREnota
			,((e.RHIEporcentaje * coalesce(g.RHREnota,0))/100) as porcAlcanzado <!---Regla de tres para saber segun la nota el porcentaje alcanzado---->			
	from RHRelacionSeguimiento a
		inner join RHDRelacionSeguimiento b
			on a.RHRSid = b.RHRSid
			<!---============== FILTRO DE FECHAS ==============----->
			<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
				<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
					and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						)	
				<cfelse>
					and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						)
				</cfif>
			<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between b.RHDRfinicio  and b.RHDRffin
			<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between b.RHDRfinicio and b.RHDRffin
			</cfif>
			<!---============== FILTRO DE EVALUACION ==============---->
			<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
				and b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDRid#">
			</cfif>
	
		inner join RHRSEvaluaciones f
			on b.RHDRid = f.RHDRid
	
		inner join RHRERespuestas g
			on f.RHRSEid = g.RHRSEid
		
		inner join RHItemEvaluar e
			on g.RHIEid = e.RHIEid
					
			inner join RHObjetivosSeguimiento i
				on e.RHOSid = i.RHOSid	
				<!----============== FILTRO DE TIPO DE OBJETIVO ==============---->
				<cfif isdefined("form.RHTOid") and len(trim(form.RHTOid))>
					and i.RHTOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTOid#">
				</cfif>
	
		<!----===== Datos del evaluado =====---->
		inner join DatosEmpleado d
			on g.DEid = d.DEid
			<!----============== FILTRO DE EMPLEADO ==============---->
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
	
		<!----===== Datos del evaluador =====---->
		inner join DatosEmpleado m
			on g.DEideval = m.DEid		
	
	where a.RHRStipo = 'O'
	order by i.RHOSid,g.DEid,b.RHDRid
</cfquery>

<cfquery name="rsTotales" datasource="#session.DSN#">
	select 	sum(coalesce(g.RHREnota,0)) as sumanotas,
			e.RHOSid,
			f.DEid
	from RHRelacionSeguimiento a
		inner join RHDRelacionSeguimiento b
			on a.RHRSid = b.RHRSid
			<!---============== FILTRO DE FECHAS ==============----->
			<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
				<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
					and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						)	
				<cfelse>
					and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						)
				</cfif>
			<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between b.RHDRfinicio  and b.RHDRffin
			<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between b.RHDRfinicio and b.RHDRffin
			</cfif>
			<!---============== FILTRO DE EVALUACION ==============---->
			<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
				and b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDRid#">
			</cfif>
	
		inner join RHRSEvaluaciones f
			on b.RHDRid = f.RHDRid
			<cfif isdefined("rsParametro") and rsParametro.RecordCount NEQ 0 and rsParametro.Pvalor EQ 0>
				and f.DEid != f.DEideval
			</cfif>
	
		inner join RHRERespuestas g
			on f.RHRSEid = g.RHRSEid
		
		inner join RHItemEvaluar e
			on g.RHIEid = e.RHIEid
					
			inner join RHObjetivosSeguimiento i
				on e.RHOSid = i.RHOSid	
				<!----============== FILTRO DE TIPO DE OBJETIVO ==============---->
				<cfif isdefined("form.RHTOid") and len(trim(form.RHTOid))>
					and i.RHTOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTOid#">
				</cfif>

		inner join DatosEmpleado d
			on g.DEid = d.DEid
			<!----============== FILTRO DE EMPLEADO ==============---->
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>

		inner join DatosEmpleado m
			on g.DEideval = m.DEid
	
	where a.RHRStipo = 'O'
	group by e.RHOSid, f.DEid
</cfquery>

<cf_templatecss>
<style>	
	.ProgressBar     { width: 16em; border: 1px solid black; background: #98C3E9; display: block;}/*#FF0000 #eef height:15%; height: 0.85em;*/
	.ProgressBarText { font-size:9px;   text-align: center; font-weight: normal;}/*position: absolute;*/
	.ProgressBarFill { background: #6A97CC; display: block; overflow: visible;}/*#CC0000 #aae height: 15px; */
	.ProgressBar1{
	 	position: relative; /* IE is dumb */
        display: block;                 
        float:left;     
		font-size:13px;
		text-align:center;
		vertical-align:middle; 
		color:#FFFFFF;
	}
</style>

</head>
<body>

<cfset vn_promedio = 0>

<cfset LvarFileName = "ReporteAlcanceObjetivos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
    title="Reporte de Alcance de Objetivos" 
    filename="#LvarFileName#"
    irA="rep-alcanceobjetivos-filtro.cfm" >

<table width="90%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td>
			<table width="90%" align="center" border="0" cellspacing="2" cellpadding="0" style="vertical-align:top;">
				<cfinvoke key="LB_ReporteDeAlcanceDeObjetivos" default="Reporte de Alcance de Objetivos"  returnvariable="LB_ReporteDeAlcanceDeObjetivos" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_Empleado" default="Empleado"  returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_Evaluacion" default="Evaluac&oacute;n"  returnvariable="LB_Evaluacion" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_TipoObjetivo" default="Tipo de Objetivo"  returnvariable="LB_TipoObjetivo" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_FechaDesde" default="Fecha desde"  returnvariable="LB_FechaDesde" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_FechaHasta" default="Fecha hasta"  returnvariable="LB_FechaHasta" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1=''>
				<cfset filtro2=''>
				<cfset filtro3=''>
				<cfset filtro4=''>
				<cfset filtro5=''>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					<cfset filtro1="#LB_Empleado#: #rsEmpleado.empleado#">
				</cfif>	
				<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
					<cfset filtro4="#LB_Evaluacion#: #LSDateFormat(rsDatos.inicio,'dd/mm/yyy')# - #LSDateFormat(rsDatos.fin,'dd/mm/yyy')#">
				</cfif>	
				<cfif isdefined("form.RHTOid") and len(trim(form.RHTOid))>
					<cfset filtro5="#LB_TipoObjetivo#: #rsTipoObjetivo.TipoObjetivo#">
				</cfif>					
				<cfif isdefined("form.finicio") and len(trim(form.finicio))>
					<cfset filtro2="#LB_FechaDesde#: #LSDateFormat(form.finicio,'dd/mm/yyy')#">
				</cfif> 
				<cfif isdefined("form.ffin") and len(trim(form.ffin))>
					<cfset filtro3="#LB_FechaHasta#: #LSDateFormat(form.ffin,'dd/mm/yyy')#">
				</cfif> 
				<cf_EncReporte
					Titulo="#LB_ReporteDeAlcanceDeObjetivos#"
					Color="##E3EDEF"		
					filtro1="#filtro1#"					
					filtro2="#filtro2#"	
					filtro3="#filtro3#"				
					filtro4="#filtro4#"
					filtro5="#filtro5#"
				>
			</table>
		</td>
	</tr>
	<!----
	<tr><!-----========= TITULOS  =========---->
		<td>			
			<cfoutput>
				<table width="100%" align="center" border="0" cellspacing="2" cellpadding="0" style="vertical-align:top;">
					<tr><td align="center"><strong><font size="3" style="font-size:13pt;"><cf_translate key="LB_Empresa">#Session.Enombre#</cf_translate></font></strong></td></tr>
					<tr><td align="center"><strong><font size="3" style="font-size:11pt;"><cf_translate key="LB_ReporteDeAlcanceDeObjetivos">Reporte de Alcance de Objetivos</cf_translate></font></strong></td></tr>				
					<tr><td align="center"><b><cf_translate key="LB_Fecha">Fecha</cf_translate>:</b>&nbsp;#LSDateFormat(now(),'dd/mm/yyyy')#</td></tr>
				</table>		
			</cfoutput>	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	----->
	<tr><!-----========= DETALLE =========---->
		<td>
			<table width="90%" cellpadding="2" cellspacing="0" border="0" align="center">				
				<cfif rsDatos.RecordCount NEQ 0>
					<cfoutput query="rsDatos" group="RHOSid">										
						<tr><!----===== Corte por empleado =====---->						
							<td colspan="7" style="background-color:##CCCCCC;">
								<b>#RHOScodigo# - #RHOStexto#</b>
							</td>
						</tr>	
						<cfoutput group="DEid">								
							<cfset vn_promedio = 0>			
							<cfquery name="suma" dbtype="query"><!---Obtener la sumatoria de las notas de todas las instancias para ese empleado/objetivo---->
								select *
								from rsTotales
								where RHOSid = #rsDatos.RHOSid#
									and DEid = #rsDatos.DEid#
							</cfquery>							
							<cfquery name="rsEvaluadores" datasource="#session.DSN#">
								select	 count(distinct(f.DEideval))*count(distinct(b.RHDRid)) as evaluadores
								from RHRelacionSeguimiento a
									inner join RHDRelacionSeguimiento b
										on a.RHRSid = b.RHRSid
										<!---============== FILTRO DE FECHAS ==============----->
										<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
											<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
												and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
													or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
													)	
											<cfelse>
												and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
													or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
													)
											</cfif>
										<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
											and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between b.RHDRfinicio  and b.RHDRffin
										<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
											and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between b.RHDRfinicio and b.RHDRffin
										</cfif>
										<!---============== FILTRO DE EVALUACION ==============---->
										<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
											and b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDRid#">
										</cfif>
									inner join RHRSEvaluaciones f
										on b.RHDRid = f.RHDRid
										and f.DEid = #rsDatos.DEid#
										<cfif isdefined("rsParametro") and rsParametro.RecordCount NEQ 0 and rsParametro.Pvalor EQ 0>
											and f.DEid != f.DEideval
										</cfif>
									inner join RHEvaluados g
										on a.RHRSid = g.RHRSid
									inner join RHItemEvaluar h	
										on g.RHEid = h.RHEid
										and h.RHOSid =#rsDatos.RHOSid#		
								where a.RHRStipo = 'O'	
							</cfquery>
							<cfset vn_promedio = suma.sumanotas/rsEvaluadores.evaluadores>
							<tr style="background-color:##F1F1F1;">
								<td>&nbsp;</td>
								<td colspan="4">
									<b style="font-size:10.5pt;"><cf_translate key="LB_Colaborador">Colaborador</cf_translate>:&nbsp;#Evaluado#</b>
								</td>
								<td align="right">
									<b><cf_translate key="LB_Promedio">Promedio</cf_translate>:&nbsp;#LSNumberFormat(vn_promedio,'999.99')#</b>
								</td>
							</tr>	
							<cfoutput group="RHDRid"><!---====== Corte por instancia de relacion ======---->
								<tr>								
									<td colspan="2">&nbsp;</td>
									<td>&nbsp;</td>
									<td colspan="3"><b><cf_translate key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:&nbsp;#LSDateFormat(inicio,'dd/mm/yyyy')# &nbsp;
									<cf_translate key="LB_Al">al</cf_translate>&nbsp;#LSDateFormat(fin,'dd/mm/yyyy')#</b></td>								
								</tr>
								<!----Titulo corte---->
								<tr>
									<td colspan="3">&nbsp;</td>
									<td>&nbsp;</td>
									<td><b><cf_translate key="LB_Evaluador">Evaluador</cf_translate></b></td>
									<td><b><cf_translate key="LB_PorcentajeAvance">Porcentaje Avance</cf_translate></b></td>
								</tr>	
								<cfoutput>	
									<tr <cfif rsDatos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
										<td colspan="3">&nbsp;</td>
										<td>&nbsp;</td>
										<td width="70%">#Evaluador#</td>										
										<td nowrap width="80%" valign="top">
											
											<cfset y = (rsDatos.RHREnota*300)/100><!---Convertir la nota a tamaño en pixeles---->
											<cfif RHREnota NEQ 0>
												<style type="text/css"> 
													##capa2_#rsDatos.CurrentRow#{ position:absolute; z-index:1; width:300px; background-color:##98C3E9;  border: 1px solid black;}											 
													##capa1_#rsDatos.CurrentRow#{ position:absolute; z-index:2; background-color:##6A97CC; width:#y#px; text-align:center;  border: 1px solid black;}
													##capa3_#rsDatos.CurrentRow#{ position:relative; z-index:3; width:300px; text-align:center;vertical-align:text-top;} 
												</style>
											<cfelse>
												<style type="text/css"> 
													##capa2_#rsDatos.CurrentRow#{ position:absolute; z-index:1; width:300px; background-color:##98C3E9;  border: 1px solid black;}											 
													##capa1_#rsDatos.CurrentRow#{ position:absolute; z-index:2; background-color:##6A97CC; width:#y#px; text-align:center;}
													##capa3_#rsDatos.CurrentRow#{ position:relative; z-index:3; width:300px; text-align:center;vertical-align:text-top;} 
												</style>
											</cfif>
											<div id="capa1_#rsDatos.CurrentRow#">&nbsp;</div>											
											<div id="capa2_#rsDatos.CurrentRow#">&nbsp;</div>
											<div id="capa3_#rsDatos.CurrentRow#">#LSNumberFormat(RHREnota,'99.99')#%</div>
										</td>										
									</tr>
								</cfoutput>
							</cfoutput>
						</cfoutput>					
					</cfoutput>
				<cfelse>
					<tr><td align="center" colspan="6"><b>----- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>-----</b></td></tr>
				</cfif>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>
</body>
</html>
