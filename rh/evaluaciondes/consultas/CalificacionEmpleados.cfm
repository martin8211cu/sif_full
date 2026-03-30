<cfset vDesde = LSParsedateTime(url.desde) >
<cfset vHasta = LSParsedateTime(url.hasta) >
<cfif datecompare(vDesde, vHasta) gt 0>
	<cfset tmp = vDesde >
	<cfset vDesde = vHasta >
	<cfset vHasta = tmp >
</cfif>

<cfif  isdefined("url.identificacion_desde1") and isdefined("url.identificacion_hasta2") and len(trim(url.identificacion_desde1)) and len(trim(url.identificacion_hasta2)) and CompareNoCase(url.identificacion_desde1, url.identificacion_hasta2) gt 0 >
	<cfset tmp = url.identificacion_desde1 >
	<cfset url.identificacion_desde1 = url.identificacion_hasta2 >
	<cfset url.identificacion_hasta2 = tmp >
</cfif>

<cfquery name="data" datasource="#session.DSN#" >
	select c.DEidentificacion,
		c.DEnombre,
		c.DEapellido1,
		c.DEapellido2, 
		( select EVfantig from EVacacionesEmpleado where DEid=b.DEid  ) as ingreso,
		a.RHEEdescripcion, 
		a.RHEEfecha, 
		coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo, 
		p.RHPdescpuesto, 
		pl.RHPcodigo as PLcodigo,
		pl.RHPdescripcion as PLdescripcion,
		(coalesce(b.RHLEnotajefe, 0) + 
		coalesce(b.RHLEnotaauto, 0)
		 + coalesce(b.RHLEpromotros, 0) ) 
		 / (	case when b.RHLEnotajefe is null 
		 		and b.RHLEnotaauto is null and b.RHLEpromotros is null then 1   
			when b.RHLEnotajefe is null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 2
			when b.RHLEnotajefe is not null and b.RHLEnotaauto is null and b.RHLEpromotros is not null then 2
			when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is  null then 2
			when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 3
			else 1 end)  as promedio
	
	from RHEEvaluacionDes a
	
	inner join RHListaEvalDes b
	on b.RHEEid=a.RHEEid
	
	inner join DatosEmpleado c
	on c.DEid=b.DEid

	<cfif isdefined("url.identificacion_desde1") and len(trim(url.identificacion_desde1)) and isdefined("url.identificacion_hasta2") and len(trim(url.identificacion_hasta2)) >
		and c.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_desde1#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_hasta2#">
	<cfelseif isdefined("url.identificacion_desde1") and len(trim(url.identificacion_desde1)) >
		and c.DEidentificacion >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_desde1#">
	<cfelseif isdefined("url.identificacion_hasta2") and len(trim(url.identificacion_hasta2)) >
		and c.DEidentificacion <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_hasta2#">
	</cfif>		
	
	inner join LineaTiempo lt
	on lt.Ecodigo=c.Ecodigo
	and lt.DEid=c.DEid
	and a.RHEEfecha between lt.LTdesde and lt.LThasta
	
	inner join RHPuestos p
	on p.Ecodigo=lt.Ecodigo
	and p.RHPcodigo=lt.RHPcodigo
	
	inner join RHPlazas pl
	on pl.RHPid=lt.RHPid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHEEfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vhasta#">
	and a.RHEEestado = 3
	
	<cfif isdefined("url.chk_nota") and isdefined("url.nota_inferior") and len(trim(url.nota_inferior)) >
		and ( (coalesce(b.RHLEnotajefe, 0) + coalesce(b.RHLEnotaauto, 0) + coalesce(b.RHLEpromotros, 0) )/	(case when b.RHLEnotajefe is null and b.RHLEnotaauto is null and b.RHLEpromotros is null then 1   
																						when b.RHLEnotajefe is null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is null and b.RHLEpromotros is not null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is  null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 3
																						else 1 end)) < <cfqueryparam cfsqltype="cf_sql_integer" value="#replace(url.nota_inferior,',','','all')#">
	</cfif>																					
	
	order by c.DEidentificacion, a. RHEEfecha, a.RHEEdescripcion
</cfquery>

<cfif data.recordcount gt 0 >
	<cfreport format="#url.formato#" template= "CalificacionEmpleados.cfr" query="data">
		<cfreportparam name="empresa" value="#session.enombre#">
	</cfreport>

<cfelse>
	<cfoutput>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_RecursosHumanos"
			Default="Recursos Humanos"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_RecursosHumanos"/>
		<cf_templateheader title="#LB_RecursosHumanos#">

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteDeEmpleadosASerEvaluados"
				Default="Reporte de Empleados a ser Evaluados"
				returnvariable="LB_ReporteDeEmpleadosASerEvaluados"/>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
				titulo='#LB_ReporteDeEmpleadosASerEvaluados#'>
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="10%" align="center" cellpadding="2" cellspacing="0">
					<tr>
						<td colspan="2" align="center" style="padding:8px;" nowrap="nowrap">
							<strong><font size="2"><cf_translate key="LB_ReporteDeCalificacionesDeEmpleados">Reporte de Calificaciones de Empleados</cf_translate></font></strong>
						</td>
					</tr>
					<tr>
						<td align="left" nowrap="nowrap"><strong><cf_translate key="LB_RangoDeFechas">Rango de fechas</cf_translate>:</strong></td>
						<td align="left" nowrap="nowrap"> del #LSDateformat(vDesde, 'dd/mm/yyyy')# al #LSDateformat(vHasta, 'dd/mm/yyyy')#</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center" colspan="2"><cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
		<cf_templatefooter>
	</cfoutput>	
</cfif>

