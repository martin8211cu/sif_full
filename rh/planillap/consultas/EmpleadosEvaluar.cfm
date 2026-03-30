<cfset vDesde = LSParsedateTime(form.desde) >
<cfset vHasta = LSParsedateTime(form.hasta) >
<cfif datecompare(vDesde, vHasta) gt 0>
	<cfset tmp = vDesde >
	<cfset vDesde = vHasta >
	<cfset vHasta = tmp >
</cfif>

<!--- si viene vacio, por defecto le pone 3 meses --->
<cfif len(trim(form.meses)) is 0 >
	<cfset form.meses = 3 >
</cfif>

<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.DSN#">
	<cf_dbtempcol name="CFcodigo"			type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="DEid"				type="numeric"		mandatory="yes" > 
	<cf_dbtempcol name="DEidentificacion"	type="varchar(60)"	mandatory="yes" > 
	<cf_dbtempcol name="DEnombre"			type="varchar(255)"	mandatory="yes" > 
	<cf_dbtempcol name="ingreso"			type="datetime"		mandatory="yes" > 
	<cf_dbtempcol name="cumplimiento"		type="datetime"		mandatory="yes" > 
	<cf_dbtempcol name="nota"				type="float"		mandatory="no" > 
</cf_dbtemp>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<!--- dbfunction solo aguanta dateadd con dias ---> 
<cfquery datasource="#session.DSN#">
	insert into ##datos( CFcodigo, DEid, DEidentificacion, DEnombre, ingreso, cumplimiento )
	select rtrim(cf.CFcodigo)#LvarCNCT# ' - '#LvarCNCT#  cf.CFdescripcion as CFcodigo, 
		   a.DEid, b.DEidentificacion, 
		   b.DEnombre#LvarCNCT# ' '#LvarCNCT#  b.DEapellido1#LvarCNCT# ' '#LvarCNCT#  b.DEapellido2 as DEnombre , 
		   a.EVfantig, 
		   dateadd(mm, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.meses#">, a.EVfantig  ) as EVcumplimiento

	from EVacacionesEmpleado a
	
	inner join DatosEmpleado b
	on b.DEid=a.DEid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	inner join LineaTiempo lt
	on lt.DEid=a.DEid
	and dateadd(mm, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.meses#">, a.EVfantig  ) between lt.LTdesde and lt.LThasta		
	
	inner join RHPlazas p
	on p.RHPid=lt.RHPid
	
	inner join CFuncional cf
	on p.CFid=cf.CFid
	
	where dateadd(mm, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.meses#">, a.EVfantig  ) between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vhasta#">
	order by cf.CFcodigo, b.DEidentificacion
</cfquery>

<cfquery datasource="#session.DSN#">
	update ##datos
	set nota = 	(coalesce(a.RHLEnotajefe, 0) + coalesce(a.RHLEnotaauto, 0) + coalesce(a.RHLEpromotros, 0)  ) / (case when a.RHLEnotajefe is null and a.RHLEnotaauto is null and a.RHLEpromotros is null then 1   
																						when a.RHLEnotajefe is null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 2
																						when a.RHLEnotajefe is not null and a.RHLEnotaauto is null and a.RHLEpromotros is not null then 2
																						when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is  null then 2
																						when a.RHLEnotajefe is not null and a.RHLEnotaauto is not null and a.RHLEpromotros is not null then 3
																						else 1 end) 
	
	
	from RHListaEvalDes a
	
	inner join ##datos b
	on b.DEid=a.DEid
	
	inner join RHEEvaluacionDes c
	on c.RHEEid=a.RHEEid
	and c.RHEEestado=3 
	and c.RHEEfecha = ( select max(c1.RHEEfecha)  
					from  RHEEvaluacionDes c1
					inner join RHListaEvalDes a1
					on a1.RHEEid = c1.RHEEid
					and a1.DEid = a.DEid
					where c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and c1.RHEEestado = 3   )
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select CFcodigo, DEid, DEidentificacion, DEnombre, ingreso, cumplimiento, coalesce(nota, 0) as nota
	from ##datos
	<cfif isdefined("form.criterio") and len(trim(form.criterio))>
		<cfif form.criterio eq 'CN' >
			where nota is not null
		<cfelseif form.criterio eq 'SN' >	
			where nota is null
		</cfif>
	</cfif>
	order by CFcodigo, DEidentificacion
</cfquery>

<cfif data.recordcount gt 0>
	<cfreport format="#form.formato#" template= "EmpleadosEvaluar.cfr" query="data">
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
		<tr><td colspan="2" align="center" style="padding:8px;" nowrap="nowrap"><strong><font size="2">Reporte de Empleados a ser Evaluados</font></strong></td></tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Rango de fechas:</strong></td>
			<td align="left" nowrap="nowrap"> del #LSDateformat(vDesde, 'dd/mm/yyyy')# al #LSDateformat(vHasta, 'dd/mm/yyyy')#</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Cantidad de meses:</strong></td>
			<td align="left" nowrap="nowrap"> #form.meses#</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="2">No se encontraron registros</td></tr>
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
			</cf_templatearea>
			
		</cf_template>



	</cfoutput>
</cfif>