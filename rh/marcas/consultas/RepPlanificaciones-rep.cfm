<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDePlanificaciones" default="Reporte de Planificaciones" returnvariable="LB_ReporteDePlanificaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Lunes" default="Lunes" returnvariable="LB_Lunes" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Martes" default="Martes" returnvariable="LB_Martes" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Miercoles" default="Mi&eacute;rcoles" returnvariable="LB_Miercoles" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Jueves" default="Jueves" returnvariable="LB_Jueves" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Viernes" default="Viernes" returnvariable="LB_Viernes" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Sabado" default="Sabado" returnvariable="LB_Sabado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Domingo" default="Domingo" returnvariable="LB_Domingo" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_DiaNoPlanificado" default="D&iacute;a no planificado" returnvariable="LB_DiaNoPlanificado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SinAgrupar" default="Sin agrupar" returnvariable="LB_SinAgrupar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Dia" default="D&iacute;a" returnvariable="LB_Dia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jornada" default="Jornada" returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Libre" default="Libre" returnvariable="LB_Libre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Observaciones" default="Observaciones" returnvariable="LB_Observaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Grupo" default="Grupo" returnvariable="LB_Grupo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoInactivoALaFecha" default="Empleado inactivo a la fecha" returnvariable="LB_EmpleadoInactivoALaFecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!----================ OBTENER EMPLEADOS ================--->
<cfif isdefined("url.Gid") and len(trim(url.Gid))><!----Empleados de un grupo especifico--->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		select b.DEid, coalesce(a.Gid ,null) as Gid
		from RHCMGrupos a
			inner join RHCMEmpleadosGrupo b
				on a.Gid = b.Gid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Gid#">
	</cfquery>
<cfelseif isdefined("url.DEid") and len(trim(url.DEid))><!---Un empleado especifico---->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		select DEid, coalesce(Gid,null) as Gid
		from RHCMEmpleadosGrupo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">			
	</cfquery>
<cfelse>
	<cfquery name="rsEmpleados" datasource="#session.DSN#"><!---Todos los empleados en el planificador---->
		select distinct a.DEid, coalesce(b.Gid,null) as Gid
		from RHPlanificador a
			left outer join RHCMEmpleadosGrupo b
				on a.DEid = b.DEid
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!---================ LLENAR LA TEMPORAL CON LOS EMPLEADOS Y TODOS LOS DIAS DEL RANGO ================--->
<cfif rsEmpleados.RecordCount NEQ 0>
	<!---Crear una temporal con todas las fechas del rango--->
	<cf_dbtemp name="TMP_DiasRango" returnvariable="TMP_DiasRango">
		<cf_dbtempcol name="DEid"	type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="fecha" 	type="datetime"		mandatory="yes">
		<cf_dbtempcol name="grupo" 	type="int"		mandatory="no">
	</cf_dbtemp>
	<cfloop query="rsEmpleados">
		<cfset vn_grupo = rsEmpleados.Gid>
		<cfset vn_deid = rsEmpleados.DEid> 
		<cfset vd_fecha = CreateDate(year(LSParseDateTime(url.fdesde)),month(LSParseDateTime(url.fdesde)),day(LSParseDateTime(url.fdesde)))>
		<cfset vd_fechafinal = CreateDate(year(LSParseDateTime(url.fhasta)),month(LSParseDateTime(url.fhasta)),day(LSParseDateTime(url.fhasta)))>		
		<cfloop condition = "vd_fecha LTE vd_fechafinal">
			<cfquery datasource="#session.DSN#">
				insert into #TMP_DiasRango# (DEid,fecha,grupo)
				values(#vn_deid#,#vd_fecha#,<cfif len(trim(vn_grupo))>#vn_grupo#<cfelse>null</cfif>)				
			</cfquery>
			<cfset vd_fecha = DateAdd("D", 1,vd_fecha) >
		</cfloop>
	</cfloop>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	a.fecha
				,case <cf_dbfunction name="date_part" args="DW,a.fecha"> 
						when 1 then '#LB_Domingo#'
						when 2 then '#LB_Lunes#'
						when 3 then '#LB_Martes#'
						when 4 then '#LB_Miercoles#'
						when 5 then '#LB_Jueves#'
						when 6 then '#LB_Viernes#'
						when 7 then '#LB_Sabado#'
				end as Dia	
				,a.grupo
				,a.DEid
				,case when b.RHPJid is not null then 
						(select d.RHJdescripcion from RHJornadas d
						 where b.RHJid = d.RHJid
							and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)					
					else 
						(select e.RHJdescripcion from RHJornadas e
						where c.RHJid = e.RHJid
							and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)					
				end as Jornada
				,<cf_dbfunction name="concat" args="f.DEidentificacion,' - ',f.DEnombre,' ',f.DEapellido1,' ',f.DEapellido2"> as Empleado			
				,b.RHPlibre as IndicadorLibre 
				,case when b.RHPJid is null and c.LTid is not null then '#LB_DiaNoPlanificado#' 
					 when b.RHPJid is null and c.LTid is null then '#LB_EmpleadoInactivoALaFecha#'
				end as observaciones			
				,case when a.grupo is not null then <cf_dbfunction name="concat" args="g.Gcodigo,' ',g.Gdescripcion">
					else '#LB_SinAgrupar#'
				end as etiquetagrupo
				,f.DEidentificacion			
				,b.RHPJid
				,c.LTid		
				
		from #TMP_DiasRango# a
			inner join DatosEmpleado f
				on a.DEid = f.DEid
				
			left outer join RHCMGrupos g
				on a.grupo = g.Gid
				
			left outer join RHPlanificador  b
				on a.DEid = b.DEid
				<cfif Application.dsinfo[session.DSN].type is 'oracle'>
					and to_date(a.fecha) between to_date(b.RHPJfinicio) and to_date(b.RHPJffinal)
				<cfelse>
					and convert(datetime,a.fecha) between b.RHPJfinicio and b.RHPJffinal
				</cfif>
	
			left outer join LineaTiempo c
				on a.DEid = c.DEid
				and a.fecha between c.LTdesde and c.LThasta
	
		order by grupo, f.DEidentificacion, fecha		
	</cfquery>
</cfif>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<style>
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		height:20px}
	.corte_grupo {
		font-size:14px;
		font-weight:bold;
		background-color:#FFFFCC;
		height:20px}
	.detalle {font-size:14px;}		
</style>

<cfif isdefined("rsReporte") and rsReporte.RecordCount>
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td colspan="6">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>
						<cfoutput><cf_EncReporte
							Titulo="#LB_ReporteDePlanificaciones#"
							Color="##E3EDEF"				
							></cfoutput>
					</td></tr>
				</table>
			</td>
		</tr>
		<!----
		<cfoutput>
		<tr><td align="center" colspan="6" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td align="center" colspan="6" class="titulo_empresa2"><strong>#LB_ReporteDePlanificaciones#</strong></td></tr>
		<tr><td align="right" colspan="6" class="detalle">#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(now(),'hh:mm:ss')#</td></tr>
		<tr><td>&nbsp;</td></tr>		
		</cfoutput>
		----->
		<tr>
			<td width="2%" class="titulo_columna">&nbsp;</td>
			<td class="titulo_columna" width="5%"><strong><cf_translate key="LB_Dia">D&iacute;a</cf_translate></strong></td>
			<td class="titulo_columna" width="10%" align="center"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate></strong></td>
			<td class="titulo_columna" width="35%"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate></strong></td>
			<td class="titulo_columna" width="5%" nowrap align="center"><strong><cf_translate key="LB_Libre">Libre</cf_translate></strong></td>
			<td class="titulo_columna" width="30%"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate></strong></td>				
		</tr>
		<cfoutput query="rsReporte" group="grupo"><!---Corte de grupo--->			
			<tr>
				<td class="corte_grupo" colspan="6"><strong>#LB_Grupo#:&nbsp;#etiquetagrupo#</strong></td>
			</tr>
			<cfoutput group="DEid"><!---Corte de empleado--->
				<tr><td colspan="6" class="detalle">#Empleado#</td></tr>		
				<cfoutput><!---Dias--->
					<tr>
						<td width="2%">&nbsp;</td>
						<td class="detalle" style="border-top:1px solid black; border-left:1px solid black;">#Dia#</td>
						<td class="detalle" style="border-top:1px solid black; border-left:1px solid black;" align="center">#LSDateFormat(fecha,'dd/mm/yyyy')#</td>
						<td class="detalle" style="border-top:1px solid black;border-left:1px solid black;">#Jornada#</td>
						<td class="detalle" style="border-top:1px solid black;border-left:1px solid black;" align="center">
							<cfif IndicadorLibre EQ 1>X<cfelse>&nbsp;</cfif>
						</td>
						<td class="detalle" style="border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;">#observaciones#</td>
					</tr>
				</cfoutput>	
				<tr>					
					<td>&nbsp;</td>
					<td colspan="5" style="border-top:1px solid black;">&nbsp;</td>
				</tr>	
			</cfoutput>			
		</cfoutput>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>

