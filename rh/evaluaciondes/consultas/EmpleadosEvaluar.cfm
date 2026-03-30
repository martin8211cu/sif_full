<cfset vDesde = LSParsedateTime(url.desde) >
<cfset vHasta = LSParsedateTime(url.hasta) >
<cfif datecompare(vDesde, vHasta) gt 0>
	<cfset tmp = vDesde >
	<cfset vDesde = vHasta >
	<cfset vHasta = tmp >
</cfif>

<!--- si viene vacio, por defecto le pone 3 meses --->
<cfif len(trim(url.meses)) is 0 >
	<cfset url.meses = 3 >
</cfif>

<cf_dbtemp name="datos2" returnvariable="datos" datasource="#session.DSN#">
	<cf_dbtempcol name="CFcodigo"			type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="DEid"				type="numeric"		mandatory="yes" > 
	<cf_dbtempcol name="DEidentificacion"	type="varchar(60)"	mandatory="yes" > 
	<cf_dbtempcol name="DEnombre"			type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="ingreso"			type="datetime"		mandatory="yes" > 
	<cf_dbtempcol name="cumplimiento"		type="datetime"		mandatory="yes" > 
	<cf_dbtempcol name="nota"				type="float"		mandatory="no" > 
</cf_dbtemp>

<!--- dbfunction solo aguanta dateadd con dias ---> 
<cfquery datasource="#session.DSN#">
	insert into #datos#( CFcodigo, DEid, DEidentificacion, DEnombre, ingreso, cumplimiento )
	select 
			{fn concat(rtrim(cf.CFcodigo),{fn concat(' - ',cf.CFdescripcion)})} as CFcodigo,
		   a.DEid, b.DEidentificacion, 
		   {fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as DEnombre,
		   a.EVfantig, 
		   <cf_dbfunction name="dateaddm"	args="#url.meses#,a.EVfantig"> as EVcumplimiento

	from EVacacionesEmpleado a
	
	inner join DatosEmpleado b
	on b.DEid=a.DEid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	inner join LineaTiempo lt
	on lt.DEid=a.DEid
	and <cf_dbfunction name="dateaddm"	args="#url.meses#,a.EVfantig"> between lt.LTdesde and lt.LThasta		
	
	inner join RHPlazas p
	on p.RHPid=lt.RHPid
	
	inner join CFuncional cf
	on p.CFid=cf.CFid
	
	where 
		<cf_dbfunction name="dateaddm"	args="#url.meses#,a.EVfantig">
		between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vdesde#"> 
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vhasta#">
	order by cf.CFcodigo, b.DEidentificacion
</cfquery>

<!--- <cfquery datasource="#session.DSN#">
	update #datos#
	set nota = 	((coalesce(a.RHLEnotajefe, 0) + coalesce(a.RHLEnotaauto, 0) + coalesce(a.RHLEpromotros, 0)  ) 
	/ (case when a.RHLEnotajefe is null and a.RHLEnotaauto is null and a.RHLEpromotros is null then 1   
		when a.RHLEnotajefe is null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 2
		when a.RHLEnotajefe is not null and a.RHLEnotaauto is null and a.RHLEpromotros is not null then 2
		when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is  null then 2
		when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 3
		else 1 end) )
	from RHListaEvalDes a
	
	inner join #datos# b
	on b.DEid=a.DEid
	
	inner join RHEEvaluacionDes c
	on c.RHEEid=a.RHEEid
	and c.RHEEestado=3 
	and c.RHEEfecha = ( select max(c1.RHEEfecha)  
					from  RHEEvaluacionDes c1
					inner join RHListaEvalDes a1
					on a1.RHEEid = c1.RHEEid
					and a1.DEid = a.DEid
					where c1.Ecodigo = #session.Ecodigo#
					and c1.RHEEestado = 3   )
	
	where a.Ecodigo= #session.Ecodigo#
</cfquery> --->

<cfquery datasource="#session.DSN#" name="RSquery">
	select distinct DEid from #datos#
</cfquery>
<cfset VDeid = "">
<cfloop query="RSquery">
	<cfset VDeid = RSquery.DEid>
	<cfquery datasource="#session.DSN#">
		update #datos#
		set nota = (select 
			((coalesce(a.RHLEnotajefe, 0) + coalesce(a.RHLEnotaauto, 0) + coalesce(a.RHLEpromotros, 0)  ) 
			/ (case when a.RHLEnotajefe is null and a.RHLEnotaauto is null and a.RHLEpromotros is null then 1   
				when a.RHLEnotajefe is null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 2
				when a.RHLEnotajefe is not null and a.RHLEnotaauto is null and a.RHLEpromotros is not null then 2
				when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is  null then 2
				when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 3
				else 1 end) )
			from RHListaEvalDes a
			inner join RHEEvaluacionDes c	
				on c.RHEEid=a.RHEEid
			where a.Ecodigo= #session.Ecodigo#
			and #VDeid#=a.DEid
			and c.RHEEestado=3 
			and c.RHEEfecha = ( select max(c1.RHEEfecha)  
							from  RHEEvaluacionDes c1
							inner join RHListaEvalDes a1
								on a1.RHEEid = c1.RHEEid
								and a1.DEid = #VDeid#
							where c1.Ecodigo = #session.Ecodigo#
								and c1.RHEEestado = 3   )
		)
		where exists (
			select 
					1
					from RHListaEvalDes a
					inner join RHEEvaluacionDes c	
						on c.RHEEid=a.RHEEid
					where a.Ecodigo= #session.Ecodigo#
					and #VDeid#=a.DEid
					and c.RHEEestado=3 
					and c.RHEEfecha = ( select max(c1.RHEEfecha)  
									from  RHEEvaluacionDes c1
									inner join RHListaEvalDes a1
										on a1.RHEEid = c1.RHEEid
										and a1.DEid = #VDeid#
									where c1.Ecodigo = #session.Ecodigo#
										and c1.RHEEestado = 3   )
		)
		and #VDeid# = #datos#.DEid
	</cfquery>



</cfloop>




<cfquery name="data" datasource="#session.DSN#">
	select CFcodigo, DEid, DEidentificacion, DEnombre, ingreso, cumplimiento, coalesce(nota, 0) as nota
	from #datos#
	<cfif isdefined("url.criterio") and len(trim(url.criterio))>
		<cfif url.criterio eq 'CN' >
			where nota is not null
		<cfelseif url.criterio eq 'SN' >	
			where nota is null
		</cfif>
	</cfif>
	order by CFcodigo, DEidentificacion
</cfquery>

<cfif data.recordcount gt 0>
	<cfreport format="#url.formato#" template= "EmpleadosEvaluar.cfr" query="data">
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
		
		﻿<cf_templateheader title="#LB_RecursosHumanos#">
		
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteDeEmpleadosASerEvaluados"
				Default="Reporte de Empleados a ser Evaluados"
				returnvariable="LB_ReporteDeEmpleadosASerEvaluados"/>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
				titulo='#LB_ReporteDeEmpleadosASerEvaluados#'>
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="10%" align="center" cellpadding="2" cellspacing="0">
					<tr><td colspan="2" align="center" style="padding:8px;" nowrap="nowrap"><strong><font size="2">Reporte de Empleados a ser Evaluados</font></strong></td></tr>
					<tr>
						<td align="left" nowrap="nowrap"><strong><cf_translate key="LB_RangoDeFechas">Rango de fechas</cf_translate>:</strong></td>
						<td align="left" nowrap="nowrap"> <cf_translate key="LB_Del">del</cf_translate> #LSDateformat(vDesde, 'dd/mm/yyyy')# <cf_translate key="LB_Al">al</cf_translate> #LSDateformat(vHasta, 'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td align="left" nowrap="nowrap"><strong><cf_translate key="LB_CantidadDeMeses">Cantidad de meses</cf_translate>:</strong></td>
						<td align="left" nowrap="nowrap"> #url.meses#</td>
					</tr>
					
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center" colspan="2"><cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate></td></tr>
					<tr><td>&nbsp;</td></tr>
			<!---
					<tr>
						<td align="left" nowrap="nowrap"><strong>Vigencia: </strong></td>
						<td align="left" nowrap="nowrap">#vigencia.RHVTcodigo# - #vigencia.RHVTdescripcion#</td>
					</tr>
					<tr>
						<td align="left" nowrap="nowrap"><strong>Vigente desde </strong></td>
						<td align="left" nowrap="nowrap">#LSDateFormat(vigencia.rige, 'dd/mm/yyyy')# hasta #LSDateFormat(vigencia.hasta, 'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td align="left" nowrap="nowrap"><strong>Estado Vigencia:</strong></td>
						<td align="left" nowrap="nowrap">#vigencia.estado#</td>
					</tr>
			--->		
				</table>
			<cf_web_portlet_end>
		<cf_templatefooter>
	</cfoutput>
</cfif>