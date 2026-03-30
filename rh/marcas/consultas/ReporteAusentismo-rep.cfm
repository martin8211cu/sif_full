<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeAusentismo" Default="Reporte de Ausentismo" returnvariable="LB_ReporteDeAusentismo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Feriado" Default="Feriado" returnvariable="LB_Feriado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Lunes" Default="Lunes" returnvariable="LB_Lunes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Martes" Default="Martes" returnvariable="LB_Martes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Miercoles" Default="Miércoles" returnvariable="LB_Miercoles" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jueves" Default="Jueves" returnvariable="LB_Jueves" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Viernes" Default="Viernes" returnvariable="LB_Viernes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Sabado" Default="Sábado" returnvariable="LB_Sabado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Domingo" Default="Domingo" returnvariable="LB_Domingo" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
		<cfset vd_fechaInicial = LSParseDateTime(url.fdesde)>
	<cfelse>
		<cfset vd_fecha = CreateDateTime(year(now()), month(now()), day(now()), 00, 00,0)><!---Variable con la fecha---->
		<cfloop condition = "#DayOfWeek(vd_fecha)# NEQ 2">				
			<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
		</cfloop>
		<cfset vd_fechaInicial = vd_fecha >
	</cfif>
	<cfif isdefined("url.fhasta") and len(trim(url.fhasta))>
		<cfset vd_fechaFinal = LSParseDateTime(url.fhasta)>
	<cfelse>
		<cfset vd_fechaFinal = DateAdd("d", 6, "#vd_fechaInicial#")><!---Fecha del dia + 6 dias para presentar 7 días de la semana apartir de hoy---->
	</cfif>

	<!---Tabla temporal para almacenar todas las fechas del rango seleccionado---->
	<cf_dbtemp name="TempDiasRA" returnvariable="TempDias" datasource="#session.DSN#">
		<cf_dbtempcol name="tmpfecha" 	type="datetime"		mandatory="yes">
	</cf_dbtemp>
	
	<!---Tabla temporal para almacenar los Empleados relacionados en el reporte ---->
	<cf_dbtemp name="TempRangoFechasRA" returnvariable="TempRangoFechas" datasource="#session.DSN#">
		<cf_dbtempcol name="tmpfecha" 		type="datetime"		mandatory="yes">
		<cf_dbtempcol name="tmpDEid" 		type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpRHJid" 		type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpLibre" 		type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpEntrada" 	type="datetime"		mandatory="no">
		<cf_dbtempcol name="tmpSalida" 		type="datetime"		mandatory="no">
		<cf_dbtempcol name="tmpfechaMarca" 	type="datetime"		mandatory="no">
		<cf_dbtempcol name="tmpDia" 		type="varchar(15)"	mandatory="no">
		<cf_dbtempcol name="tmpFeriado" 	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpVacacion" 	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tmpCFuncional" 	type="numeric"		mandatory="no">
		<cf_dbtempcol name="tmpCFcodigo" 	type="varchar(10)"	mandatory="no">
		<cf_dbtempcol name="tmpCFdesc" 		type="varchar(60)"	mandatory="no">
		<cf_dbtempcol name="tmpDcodigo" 	type="numeric"		mandatory="no">
	</cf_dbtemp>	
	
    <cfset vd_fecha = CreateDateTime(year(vd_fechaInicial), month(vd_fechaInicial), day(vd_fechaInicial), 00, 00,0)><!---Variable con la fecha---->
	<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
		<cfquery datasource="#session.DSN#">
			insert into #TempDias# (tmpfecha)
			values(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">)
		</cfquery>
		<cfquery datasource="#session.DSN#">
			insert into #TempRangoFechas# (tmpfecha,tmpDEid,tmpCFuncional,tmpCFcodigo,tmpCFdesc,tmpDcodigo,tmpRHJid)	
			select <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
					de.DEid,
					p.CFid,
					cf.CFcodigo,
					cf.CFdescripcion,
                	cf.Dcodigo,
                	lt.RHJid
			from DatosEmpleado de
			inner join LineaTiempo lt
				on lt.Ecodigo = de.Ecodigo
				and de.DEid = lt.DEid
				and getdate() between lt.LTdesde and lt.LThasta
				<cfif not isdefined('url.DEid') and isdefined("url.RHJid") and len(trim(url.RHJid))>
				and lt.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
				</cfif>
			inner join RHPlazas p
				on p.Ecodigo = lt.Ecodigo
				and p.RHPid = lt.RHPid
				<cfif not isdefined('url.DEid') and isdefined('url.CFid') and url.CFid GT 0>
					and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				</cfif>
			inner join CFuncional cf
				on cf.Ecodigo = p.Ecodigo
				and cf.CFid = p.CFid
				<cfif not isdefined('url.DEid') and isdefined('url.Dcodigo') and url.Dcodigo GT 0>
				   and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Dcodigo#">
				</cfif>
			where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined('url.DEid') and url.DEid GT 0>
			  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfif>
		</cfquery>
		<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
	</cfloop>
	<!----Actualiza el dia de la semana---->
	<cfquery datasource="#session.DSN#">
		update #TempRangoFechas# set 								
			tmpDia = case <cf_dbfunction name="date_part" args="dw,tmpfecha">
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
		update #TempRangoFechas#
			set tmpFeriado =  (select distinct '1'
								from #TempRangoFechas# a, RHFeriados b
								where a.tmpfecha = b.RHFfecha
								  and a.tmpfecha = #TempRangoFechas#.tmpfecha
								  and b.Ecodigo  = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		where exists(select 1
					 from #TempRangoFechas# a, RHFeriados b
					 where a.tmpfecha = b.RHFfecha
					   and a.tmpfecha = #TempRangoFechas#.tmpfecha
					   and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>	
	<!---Actualiza los dias de vacaciones ---->
	<cfquery datasource="#session.DSN#">
		update #TempRangoFechas#
			set tmpVacacion = (select '1'
								 from  #TempRangoFechas# a, LineaTiempo b, RHTipoAccion c
								 where <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> 
											between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd"> 
											  and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
								   and a.tmpDEid = b.DEid
									and a.tmpfecha = #TempRangoFechas#.tmpfecha
								   and b.RHTid = c.RHTid
								   and b.Ecodigo = c.Ecodigo
								   and c.RHTcomportam = 3
								)
		where exists(select 1
					 from  #TempRangoFechas# a, LineaTiempo b, RHTipoAccion c
					 where <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> 
							between <cf_dbfunction name="date_format" args="b.LTdesde,yyyymmdd"> 
							  and <cf_dbfunction name="date_format" args="b.LThasta,yyyymmdd">
					   and a.tmpDEid = b.DEid
					    and a.tmpfecha = #TempRangoFechas#.tmpfecha
					   and b.RHTid = c.RHTid
					   and b.Ecodigo = c.Ecodigo
					   and c.RHTcomportam = 3)
	</cfquery>
	<!----Actualiza los datos de los días que si estan en el planificador--->
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempRangoFechas# set										
			<!---Prioridad al horario del planificador--->
			tmpLibre = (select 	distinct case when b.RHPJfinicio !=  c.RHJhoraini then
							 		<cf_dbfunction name="to_char" args="b.RHPlibre">
							   	else 									
									case when c.RHDJdia is null then '1'
									else
										<cf_dbfunction name="to_char" args="b.RHPlibre">
									end
								end	
						from  #TempRangoFechas# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						left outer join RHDJornadas c
								on b.RHJid = c.RHJid
								and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
						where a.tmpfecha = 	#TempRangoFechas#.tmpfecha)
		where exists(select 1
					from  #TempRangoFechas# a
						inner join RHPlanificador b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
							and a.tmpDEid = b.DEid									
						left outer join RHDJornadas c
								on b.RHJid = c.RHJid
								and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = c.RHDJdia
					where a.tmpfecha = 	#TempRangoFechas#.tmpfecha)
	</cfquery>	

	<!----Actualiza los días que estan definidos en la linea del tiempo ---->
	<cfquery name="updatePlan" datasource="#session.DSN#">
		update #TempRangoFechas# set
			tmpLibre = 	(select case <cf_dbfunction name="date_part" args="dw,a.tmpfecha">
						 	when  2 then ( case when RHJmon = 1 then '0' else '1' end ) 
							when  3 then ( case when RHJtue = 1 then '0' else '1' end ) 
							when  4 then ( case when RHJwed = 1 then '0' else '1' end ) 
							when  5 then ( case when RHJthu = 1 then '0' else '1' end ) 
							when  6 then ( case when RHJfri = 1 then '0' else '1' end ) 
							when  7 then ( case when RHJsat = 1 then '0' else '1' end ) 
							when  1 then ( case when RHJsun = 1 then '0' else '1' end ) 
						end
						from  #TempRangoFechas# a
						inner join LineaTiempo b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> between b.LTdesde and b.LThasta
							and a.tmpDEid = b.DEid
							
							inner join RHJornadas c
								on b.RHJid = c.RHJid
								
								left outer join RHDJornadas d
									on c.RHJid = d.RHJid
									and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
						where a.tmpRHJid is null
						  and a.tmpfecha = #TempRangoFechas#.tmpfecha	
						)
		where exists (select 1
					  from  #TempRangoFechas# a
						inner join LineaTiempo b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> between b.LTdesde and b.LThasta
							and a.tmpDEid = b.DEid
							
							inner join RHJornadas c
								on b.RHJid = c.RHJid
								
								left outer join RHDJornadas d
									on c.RHJid = d.RHJid
									and <cf_dbfunction name="date_part" args="dw,a.tmpfecha"> = d.RHDJdia
					 where a.tmpRHJid is null
					   and a.tmpfecha = #TempRangoFechas#.tmpfecha	)
	</cfquery>	
	<cfquery name="updateFechaMarca" datasource="#session.DSN#">
		update #TempRangoFechas# set										
			<!---Prioridad al horario del planificador--->
			tmpfechaMarca = (select distinct <cf_dbfunction name="date_format" args="fechahoramarca,yyyymmdd">
							from  #TempRangoFechas# a
							inner join RHControlMarcas b
								on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.fechahoramarca,yyyymmdd">
								and a.tmpDEid = b.DEid									
							where a.tmpfecha = 	#TempRangoFechas#.tmpfecha)
		where exists(select 1
					from  #TempRangoFechas# a
						inner join RHControlMarcas b
							on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.fechahoramarca,yyyymmdd">
							and a.tmpDEid = b.DEid									
					where a.tmpfecha = 	#TempRangoFechas#.tmpfecha)
	</cfquery>
<!--- <cf_dumptable var="#TempRangoFechas#"> --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.tmpDEid as DEid,
				{fn concat(DEidentificacion,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})})})} as NombreEmp, --->
                c.CFid,
				c.CFcodigo,
				c.CFdescripcion,
                c.Dcodigo,
                a.tmpRHJid as RHJid,
				a.tmpfecha as Fecha
		from #TempRangoFechas# a
		inner join DatosEmpleado b
			on b.DEid = a.tmpDEid
		inner join CFuncional c
			on c.CFid = a.tmpCFuncional
		where tmpfechaMarca is null
		  and tmpFeriado is null
		  and (tmpLibre = '0' or tmpLibre is null)
		  and (tmpVacacion = '0' or  tmpVacacion is null)
		order by Dcodigo, CFid, DEidentificacion, tmpRHJid,tmpfecha
	</cfquery>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>



<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:15px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:15px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:15px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:16px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:15px;
		text-align:left;}
	.detaller {
		font-size:15px;
		text-align:right;}
	.detallec {
		font-size:15px;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>

<cfif rsReporte.RecordCount>
    <table width="80%" align="center" border="0" cellspacing="0" cellpadding="2">
        <cfoutput>
        <tr><td align="center" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2"><strong>#LB_ReporteDeAusentismo#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2"><strong>#LB_Fecha#: #LSDateFormat(Now(),'dd/mm/yyyy')#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2"><strong>#LB_FechaDesde#: #LSDateFormat(url.Fdesde,'dd/mm/yyyy')#&nbsp;&nbsp;#LB_FechaHasta#: #LSDateFormat(url.Fhasta,'dd/mm/yyyy')#</strong></td></tr>
        <tr><td colspan="4">&nbsp;</td></tr>
        </cfoutput>
      	<cfoutput query="rsReporte" group="Dcodigo">
        	<!--- DEPARTAMENTO --->
        	<cfquery name="rsDescDepto" datasource="#session.DSN#" >
            	select Ddescripcion
                from Departamentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.Dcodigo#">
            </cfquery>
			<tr><td width="100%" height="1" bgcolor="000000" ></td></tr>
        	<tr class="listaCorte1">
                <td >&nbsp;
              <cf_translate key="LB_Departamento">Departamento</cf_translate>  	  :&nbsp;#Dcodigo# - #rsDescDepto.Ddescripcion#</td>
            </tr>
            <tr><td height="1" bgcolor="000000"></td>
     		<cfoutput group="CFid">
            	<cfset Lvar_CFid = CFid>
            	<!--- CENTRO FUNCIONAL --->
            	<cfquery name="rsCFuncional" datasource="#session.DSN#">
                	select  CFcodigo, CFdescripcion
                    from CFuncional
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CFid#">
                </cfquery>
            	<tr class=	"listaCorte1">
                    <td>&nbsp;
                  <cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>  	  :&nbsp;#rsCFuncional.CFcodigo# - #rsCFuncional.CFdescripcion#</td>
                </tr>
                <tr><td  width="100%"  height="1" bgcolor="000000"></td>
                </tr>
                <cfoutput group="RHJid">
                	<cfquery name="rsJornada" datasource="#session.DSN#">
                    	select RHJcodigo,RHJdescripcion
                        from RHJornadas
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                          and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.RHJid#">
                    </cfquery>
                    <tr class=	"listaCorte1">
                        <td>&nbsp;
                      <cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;#rsJornada.RHJcodigo# - #rsJornada.RHJdescripcion#</td>
                    </tr>
                    <tr><td  width="100%"  height="1" bgcolor="000000"></td></tr>
					<!--- AGRUPADO POR EMPLEADO --->
                    <cfset Lvar_TotalRebajadoEmp = 0>
                    <cfoutput group="DEid">
                        <tr class="listaCorte2">
                            <td>&nbsp;
                          <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;&nbsp;#NombreEmp#</td>
                        </tr>
                       	<tr><td  width="100%"  height="1" bgcolor="000000"></td></tr>
						<tr><td>&nbsp;</td></tr>
                        <cfoutput>
                        <tr><td class="detalle">#LSDateFormat(Fecha,'dd/mm/yyyy')#</td></tr>
                        </cfoutput>
                    </cfoutput><!--- AGRUPADO EMPLEADO --->
                    <tr><td>&nbsp;</td></tr>
                </cfoutput><!--- AGRUPADO JORNADA --->
        	</cfoutput><!--- AGRUPADO CENTRO FUNCIONAL --->
    	</cfoutput><!--- AGRUPADO DEPARTAMENTO --->
    </table>
<cfelse>
	 <table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
     	<cfoutput>
        <tr><td align="center"class="titulo_empresa2"><strong>#LB_NoHayDatosRelacionados#</strong></td></tr>
        </cfoutput>
	</table>
</cfif>