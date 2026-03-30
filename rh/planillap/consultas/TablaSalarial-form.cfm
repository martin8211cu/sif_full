<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Debe_seleccionar_la_Vigencia_de_la_Tabla_Salarial"
Default="Debe seleccionar la Vigencia de la Tabla Salarial."
returnvariable="MG_VigenciaTabla"/> 

<cfset listaComponentes = 0 >
<cfif isdefined("form.base") and len(trim(form.base)) >
	<cfset listaComponentes = form.base >
<cfelse>
	<cfquery name="rsbase" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CSsalariobase = 1
	</cfquery>
	<cfif rsbase.recordcount gt 0 and len(trim(rsbase.CSid)) >
		<cfset form.base = rsbase.CSid >
		<cfset listaComponentes = form.base >
	<cfelse>
		<cfset form.base = 0 >
	</cfif>
</cfif>

<cfif isdefined("form.chk") and len(trim(form.chk)) >
	<cfset listaComponentes = form.base & ',#form.chk#'>
</cfif>

<cfif isdefined("url.RHVTid") and not isdefined("form.RHVTid")>
	<cfset form.RHVTid = url.RHVTid >
</cfif>

<cfif not ( isdefined("form.RHVTid") and len(trim(form.RHVTid)) )>
	<cf_throw message="#MG_VigenciaTabla#"  errorcode="7025">
</cfif>

<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.DSN#">
	<cf_dbtempcol name="RHMPPid"	 		type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="RHCid"	 			type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="RHVTid"	 			type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="RHTTid"	 			type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="CSid"	 			type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="monto"	 			type="money"		mandatory="yes"> 
</cf_dbtemp>

<cf_dbtemp name="datosPivote" returnvariable="datosPivote" datasource="#session.DSN#">
	<cf_dbtempcol name="RHMPPid"	type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="RHCid"	 	type="numeric"		mandatory="yes"> 
	<cf_dbtempcol name="CSid"	 	type="numeric"		mandatory="yes"> 
</cf_dbtemp>

<cfquery datasource="#session.DSN#" >
	insert into #datos#( RHMPPid, 
		   				RHCid, 
					    RHVTid, 
					    RHTTid, 
					    CSid, 
					    monto )
	select e.RHMPPid, 
		   e.RHCid, 
		   a.RHVTid, 
		   b.RHTTid, 
		   (select CSid from ComponentesSalariales where Ecodigo = c.Ecodigo and CSsalariobase = 1), 
		   sum(RHMCmonto) as monto
	
	from RHMontosCategoria a
	inner join RHCategoriasPuesto e
		on e.RHCid=a.RHCid
	inner join RHVigenciasTabla b
		on b.RHVTid=a.RHVTid
		and b.Ecodigo = e.Ecodigo
	inner join RHTTablaSalarial c
		on c.RHTTid=b.RHTTid
		and c.Ecodigo = b.Ecodigo
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
	group by e.RHCid, e.RHMPPid,a.RHVTid,b.RHTTid,c.Ecodigo
	order by e.RHCid, e.RHMPPid,a.RHVTid,b.RHTTid,c.Ecodigo
</cfquery>

<!--- ================================================================================== --->
<!--- Llena la tabla pivote --->
<!--- ================================================================================== --->
<cfquery name="data0" datasource="#session.DSN#">
	select distinct RHMPPid 
	from #datos#
</cfquery>

<cfquery name="data2" datasource="#session.DSN#">
	select distinct a.CSid, b.CScodigo, b.CSdescripcion 
	from #datos# a
	inner join ComponentesSalariales b
	on b.CSid=a.CSid
	order by b.CScodigo 
</cfquery>

<cfloop query="data0">
	<cfset vRHMPPid = data0.RHMPPid >

	<cfquery name="data1" datasource="#session.DSN#">
		select distinct RHCid 
		from #datos#
		where RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHMPPid#">
	</cfquery>
	<cfloop query="data1">
		<cfset vRHCid = data1.RHCid >
		<cfloop query="data2">
			<cfquery datasource="#session.DSN#">
				insert into #datosPivote# (RHMPPid, RHCid, CSid)		
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHMPPid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#data2.CSid#"> )
			</cfquery>
		</cfloop>
	</cfloop>
</cfloop>
<!--- ================================================================================== --->
<cfquery name="data" datasource="#session.DSN#">
	select a.RHMPPid, 
		   a.RHCid, 
		   d.RHCcodigo, 
		   d.RHCdescripcion,  
		   b.RHVTid, 
		   b.RHTTid, 
		   f.RHTTcodigo, 
		   f.RHTTdescripcion, 
		   a.CSid, 
		   e.CScodigo, 
		   e.CSdescripcion, 
		   c.RHMPPcodigo, 
		   c.RHMPPdescripcion,
		   coalesce(b.monto, 0) as monto

	from #datosPivote# a

	left outer join #datos# b
	on b.RHMPPid=a.RHMPPid
	 and b.RHCid=a.RHCid
	 and b.CSid=a.CSid
	 
	inner join RHMaestroPuestoP c
	on c.RHMPPid=a.RHMPPid	 

	inner join RHCategoria d
	on d.RHCid = a.RHCid
	
	inner join ComponentesSalariales e
	on e.CSid = a.CSid
	
	left join RHTTablaSalarial f
	on f.RHTTid=b.RHTTid
	 
	order by <cf_dbfunction name="to_number" args="d.RHCcodigo">	,c.RHMPPcodigo,  e.CScodigo
</cfquery>

<cfquery name="vigencia" datasource="#session.DSN#">
	select a.RHVTcodigo, a.RHVTdescripcion, a.RHVTfecharige as rige, a.RHVTfechahasta as hasta, case a.RHVTestado when 'A' then 'Aplicado' else 'Pendiente' end as estado, b.RHTTcodigo, b.RHTTdescripcion
	from RHVigenciasTabla a
	
	inner join  RHTTablaSalarial b
	on b.RHTTid=a.RHTTid

	where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	
</cfquery>

<cf_templatecss>

<!--- manejo de totales --->
<cfset totales = structnew() >
<cfset promedio = structnew() >
<cfoutput query="data2">
	<cfset StructInsert(totales, data2.CSid, 0 )>
	<cfset StructInsert(promedio, data2.CSid, 0 )>
</cfoutput>

<cfoutput>
<table width="10%" align="center" cellpadding="2" cellspacing="0">
	<tr><td colspan="2" align="center" style="padding:8px;" nowrap="nowrap"><strong><font size="2">Reporte de Tabla Salarial</font></strong></td></tr>
	<tr>
		<td align="left" nowrap="nowrap"><strong>Tipo de Tabla:</strong></td>
		<td align="left" nowrap="nowrap">#vigencia.RHTTcodigo# - #vigencia.RHTTdescripcion#</td>
	</tr>
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
</table>
</cfoutput>
<br />
<cfif data.recordcount gt 0>
	<table width="98%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr class="tituloLista">
			<td class="tituloListas">Categor&iacute;a</td>
			<cfoutput query="data2">
				<td class="tituloListas" align="right">#data2.CScodigo#-#data2.CSdescripcion#</td>
			</cfoutput>
		</tr>	
		<cfoutput query="data" group="RHCid">
			<tr><td colspan="#data2.recordcount+1#" bgcolor="##FAFAFA"><strong>#data.RHCcodigo# - #data.RHCdescripcion#</strong></td></tr>
			<!--- limpia las variables para totalizar --->
			<cfloop query="data2">
				<cfset totales[data2.CSid] = 0 >
				<cfset promedio[data2.CSid] = 0 >
			</cfloop>
			<cfoutput group="RHMPPid">
				<tr>
					<td style="padding-left:20px;">Puesto Presupuestario: #data.RHMPPcodigo# - #data.RHMPPdescripcion#</td>
					<cfoutput>
						<td align="right">#LSNumberFormat(data.monto, ',9.00')#</td>
						<cfset totales[data.CSid] = totales[data.CSid] + data.monto >
						<cfset promedio[data.CSid] = promedio[data.CSid] + 1 >
					</cfoutput>
				</tr>
			</cfoutput>

			<tr bgcolor="##fAFAFA" style=" border-top-width:1px; border-top-color:##f5f5f5; border-top-style:solid;">
			<td style="padding-left:40px; border-top-width:1px; border-top-color:##f5f5f5; border-top-style:solid;"><strong>Promedio</strong></td>
			<cfloop query="data2">
				<td align="right" style=" border-top-width:1px; border-top-color:##f5f5f5; border-top-style:solid;">#LSNumberFormat(totales[data2.CSid]/promedio[data.CSid], ',9.00')#</td>
			</cfloop>
			</tr>
			<tr><td>&nbsp;</td></tr>

		</cfoutput>
		<tr><td style="padding:10px;" colspan="<cfoutput>#data2.recordcount+1#</cfoutput>" align="center">--- Fin del Reporte ---</td></tr>
	</table>
<cfelse>
	<table width="98%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center">No se encontraron registros</td></tr>
		<tr><td>&nbsp;</td></tr>		
	</table>
</cfif>