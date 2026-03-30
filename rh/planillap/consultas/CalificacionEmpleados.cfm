<cfset vDesde = LSParsedateTime(form.desde) >
<cfset vHasta = LSParsedateTime(form.hasta) >
<cfif datecompare(vDesde, vHasta) gt 0>
	<cfset tmp = vDesde >
	<cfset vDesde = vHasta >
	<cfset vHasta = tmp >
</cfif>

<cfif  isdefined("form.identificacion_desde1") and isdefined("form.identificacion_hasta2") and len(trim(form.identificacion_desde1)) and len(trim(form.identificacion_hasta2)) and CompareNoCase(form.identificacion_desde1, form.identificacion_hasta2) gt 0 >
	<cfset tmp = form.identificacion_desde1 >
	<cfset form.identificacion_desde1 = form.identificacion_hasta2 >
	<cfset form.identificacion_hasta2 = tmp >
</cfif>

<cfquery name="data" datasource="#session.DSN#" >
	select c.DEidentificacion,
		c.DEnombre,
		c.DEapellido1,
		c.DEapellido2, 
		convert( varchar, ( select EVfantig from EVacacionesEmpleado where DEid=b.DEid  ), 103) as ingreso,
		a.RHEEdescripcion, 
		a.RHEEfecha, 
		lt.RHPcodigo, 
		p.RHPdescpuesto, 
		pl.RHPcodigo as PLcodigo,
		pl.RHPdescripcion as PLdescripcion,
		(coalesce(b.RHLEnotajefe, 0) + coalesce(b.RHLEnotaauto, 0) + coalesce(b.RHLEpromotros, 0) ) / (	case when b.RHLEnotajefe is null and b.RHLEnotaauto is null and b.RHLEpromotros is null then 1   
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

	<cfif isdefined("form.identificacion_desde1") and len(trim(form.identificacion_desde1)) and isdefined("form.identificacion_hasta2") and len(trim(form.identificacion_hasta2)) >
		and c.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_desde1#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_hasta2#">
	<cfelseif isdefined("form.identificacion_desde1") and len(trim(form.identificacion_desde1)) >
		and c.DEidentificacion >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_desde1#">
	<cfelseif isdefined("form.identificacion_hasta2") and len(trim(form.identificacion_hasta2)) >
		and c.DEidentificacion <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_hasta2#">
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
	
	<cfif isdefined("form.chk_nota") and isdefined("form.nota_inferior") and len(trim(form.nota_inferior)) >
		and ( (coalesce(b.RHLEnotajefe, 0) + coalesce(b.RHLEnotaauto, 0) + coalesce(b.RHLEpromotros, 0) )/	(case when b.RHLEnotajefe is null and b.RHLEnotaauto is null and b.RHLEpromotros is null then 1   
																						when b.RHLEnotajefe is null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is null and b.RHLEpromotros is not null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is  null then 2
																						when b.RHLEnotajefe is not null and b.RHLEnotaauto is not null and b.RHLEpromotros is not null then 3
																						else 1 end)) < <cfqueryparam cfsqltype="cf_sql_integer" value="#replace(form.nota_inferior,',','','all')#">
	</cfif>																					
	
	order by c.DEidentificacion, a. RHEEfecha, a.RHEEdescripcion
</cfquery>

<cfif data.recordcount gt 0 >
	<cfreport format="#form.formato#" template= "CalificacionEmpleados.cfr" query="data">
		<cfreportparam name="empresa" value="#session.enombre#">
	</cfreport>

<cfelse>
	<cfoutput>
		<cf_template template="#session.sitio.template#">
		
			<cf_templatearea name="title">
				Recursos Humanos
			</cf_templatearea>
			
			<cf_templatearea name="body">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Empleados a ser Evaluados'>
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="10%" align="center" cellpadding="2" cellspacing="0">
						<tr><td colspan="2" align="center" style="padding:8px;" nowrap="nowrap"><strong><font size="2">Reporte de Calificaciones de Empleados</font></strong></td></tr>
						<tr>
							<td align="left" nowrap="nowrap"><strong>Rango de fechas:</strong></td>
							<td align="left" nowrap="nowrap"> del #LSDateformat(vDesde, 'dd/mm/yyyy')# al #LSDateformat(vHasta, 'dd/mm/yyyy')#</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td align="center" colspan="2">No se encontraron registros</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</cf_templatearea>
			
		</cf_template>
	</cfoutput>	
</cfif>

