<cf_htmlReportsHeaders 
	irA=""
	FileName="evaluacionesColaborador_#session.Usucodigo#.xls"
	method="url"
	title="vvv">

<script>
	function fnImgBack(){
		window.parent.location.href = 'evaluacionesColaborador-filtro.cfm';
	}
</script>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 1030
</cfquery>
<!--- 
--->
<cf_dbtemp name="tbl_resumen" returnvariable="tbl_resumen">
	<cf_dbtempcol name="RHRSid"	type="numeric"		mandatory="no">
	<cf_dbtempcol name="RHDRid"	type="numeric"		mandatory="no">
	<cf_dbtempcol name="RHIEid" type="numeric"		mandatory="no">
	<cf_dbtempcol name="DEid" 	type="numeric"		mandatory="no">	
	<cf_dbtempcol name="jefe" 	type="float"		mandatory="no">
	<cf_dbtempcol name="auto" 	type="float"		mandatory="no">
	<cf_dbtempcol name="otros" 	type="float"		mandatory="no">
	<cf_dbtempcol name="sub" 	type="float"		mandatory="no">
	<cf_dbtempcol name="tipo" 	type="char(1)"		mandatory="no">	
</cf_dbtemp>

<!----Inserta en el resumen 1 registro por c/item - instancia---->
<cfquery datasource="#session.DSN#">
	insert into #tbl_resumen#( RHRSid,	RHDRid, RHIEid, DEid, jefe, auto, otros, sub, tipo )
	select 	a.RHRSid,
			b.RHDRid
			,d.RHIEid
			,c.DEid
			,0.00 <!--- RHRnotaJefe --->
			,0.00 <!--- RHRnotaauto --->
			,0.00 <!--- RHRnotaotros --->
			,0.00 <!--- RHRnotasub --->
			,a.RHRStipo

	from RHRelacionSeguimiento a

		inner join RHDRelacionSeguimiento b
			on a.RHRSid = b.RHRSid
			and b.RHDRestado in (20, 30)	<!---Instancias publicadas---->
			
			<cfif isdefined("url.inicio") and len(trim(url.inicio)) and isdefined("url.fin") and len(trim(url.fin))>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#url.inicio#"> <= b.RHDRffin 
				and <cfqueryparam cfsqltype="cf_sql_date" value="#url.fin#"> >= b.RHDRfinicio 
			<cfelseif isdefined("url.inicio") and len(trim(url.inicio)) >
				and <cfqueryparam cfsqltype="cf_sql_date" value="#url.inicio#"> between b.RHDRfinicio and b.RHDRffin
			<cfelseif isdefined("url.fin") and len(trim(url.fin)) >
				and <cfqueryparam cfsqltype="cf_sql_date" value="#url.fin#"> between b.RHDRfinicio and b.RHDRffin
			</cfif>

		inner join RHEvaluados c
			on a.RHRSid = c.RHRSid
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfif>

		inner join RHItemEvaluar d
			on c.RHEid = d.RHEid

	where a.RHRSestado in ( 20, 30 )
	<cfif isdefined("url.RHRSid") and len(trim(url.RHRSid))>
		and a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHRSid#">	
	</cfif>

</cfquery>

<!----Respuestas---->
<cfquery name="rsDatos" datasource="#session.DSN#">					
	select  coalesce(sum(c.RHREnota),0) as notas	
			,a.RHDRid, b.RHEVtipo, c.RHIEid
	from RHDRelacionSeguimiento a
		inner join RHRSEvaluaciones b
			on a.RHDRid = b.RHDRid
			and b.RHRSEestado in (20, 30)	<!----Solo toma en cuenta las evaluaciones terminadas---->
		inner join RHRERespuestas c
			on b.RHRSEid = c.RHRSEid
	where a.RHDRid in ( select RHDRid from #tbl_resumen#)

	group by a.RHDRid, b.RHEVtipo, c.RHIEid
	order by RHDRid, c.RHIEid,  b.RHEVtipo			
</cfquery>

<!---Procesa las respuestas---->
<cfloop query="rsDatos">
	<cfquery name="rsCant" datasource="#session.DSN#">
		select count(1) as cant

		from RHRSEvaluaciones a

		inner join RHRERespuestas c
		on a.RHRSEid = c.RHRSEid

		where c.RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHIEid#">
			and a.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHDRid#">
			and a.RHEVtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.RHEVtipo#">
			and a.RHRSEestado = 20	<!----Solo toma en cuenta las evaluaciones terminadas---->
	</cfquery>	

	<cfset vn_notafinal = rsDatos.notas/rsCant.cant>

	<cfquery datasource="#session.DSN#">
		update #tbl_resumen#
			set 
			<cfif rsDatos.RHEVtipo EQ 'C'>	
				otros 
			<cfelseif rsDatos.RHEVtipo EQ 'A'>
				auto  
			<cfelseif rsDatos.RHEVtipo EQ 'S'>
				sub
			<cfelseif rsDatos.RHEVtipo EQ 'J'>
				jefe
			<cfelseif rsDatos.RHEVtipo EQ 'E'>
				jefe 
			</cfif>										
			= <cfqueryparam  cfsqltype="cf_sql_float" value="#vn_notafinal#">
		
		where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHDRid#">	
		  and RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHIEid#">
	</cfquery>
</cfloop>

<cfquery name="data"  datasource="#session.DSN#">
	select 	r.DEid,
			ie.RHIEid,
			de.DEidentificacion,
			de.DEnombre,
			de.DEapellido1,
			de.DEapellido2,
			r.jefe, 
			r.auto, 
			r.otros, 
			r.sub,
			h.RHHcodigo,
			h.RHHdescripcion,
			os.RHOScodigo,
			os.RHOStexto,
			rsm.RHRSdescripcion,
			rs.RHDRfinicio as inicio, 
			rs.RHDRffin as fin,
			r.tipo,
			coalesce(h.RHHcodigo, os.RHOScodigo) as item				
	
	from #tbl_resumen# r
	
	inner join RHDRelacionSeguimiento rs
	on rs.RHDRid=r.RHDRid
	
	inner join RHRelacionSeguimiento rsm 
	on rsm.RHRSid=rs.RHRSid
	
	inner join RHItemEvaluar ie
	on ie.RHIEid=r.RHIEid
	
	inner join DatosEmpleado de
	on de.DEid=r.DEid
	
	left join RHHabilidades h
	on h.RHHid=ie.RHHid
		
	left join RHObjetivosSeguimiento os
	on os.RHOSid=ie.RHOSid
	
	order by de.DEidentificacion, rsm.RHRSdescripcion, h.RHHcodigo, os.RHOScodigo, rs.RHDRfinicio, rs.RHDRffin
</cfquery>

<cf_templatecss>
<!----
<cfoutput>
<table width="100%" align="center">
	<tr><td align="center"><strong>#session.Enombre#</strong></td></tr>
	<tr><td align="center"><strong>Reporte de Evaluaciones de Talento por Colaborador</strong></td></tr>
</table>
</cfoutput>
<br>
---->
<table width="100%" align="center">
	<tr><td>
	<cf_EncReporte
		Titulo="Reporte de Evaluaciones de Talento por Colaborador"
		Color="##E3EDEF"				
		>
	</td></tr>	
</table>				

<table width="100%" cellpadding="2">
<cfoutput query="data" group="DEidentificacion">
	<cfif data.currentrow gt 1>
	<tr><td>&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="6"><strong>Empleado:</strong> #data.DEidentificacion# - #data.DEapellido1# #data.DEapellido2# #data.DEnombre#</td></tr>
	<cfoutput group="RHRSdescripcion">
		<tr class="listaCorte "><td colspan="6" align="left" style="padding-left:15px;"><strong>Relaci&oacute;n:</strong> #data.RHRSdescripcion#</td></tr>
		<tr>
			<td class="tituloListas" style="padding-left:40px;"><cf_translate key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Autoevaluacion">Autoevaluaci&oacute;n</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Jefe">Jefe</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Subordinados">Subordinados</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Otros">Otros</cf_translate></td>
			<td class="tituloListas" align="right"><cf_translate key="LB_Promedio">Promedio</cf_translate></td>
		</tr>
		<cfoutput group="item">
			<tr ><td colspan="6" align="left" style="padding-left:30px;"><strong>
				<cfif data.tipo eq 'C'><cf_translate key="LB_Competencia">Competencia</cf_translate>:<cfelse><cf_translate key="LB_Objetivo">Objetivo</cf_translate>:</cfif></strong>
				#data.item# - <cfif data.tipo eq 'C'>#data.RHHdescripcion#<cfelse>#data.RHOStexto#</cfif>
			</td></tr>
			<cfoutput>
				<cfset vn_promedio = 0>
				<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td style="padding-left:45px;" >#LSDateFormat(data.inicio, 'dd/mm/yyyy')# a #LSDateFormat(data.fin, 'dd/mm/yyyy')#</td>
					<td align="right">#LSNumberFormat(data.auto, ',9.00')#</td>
					<td align="right">#LSNumberFormat(data.jefe, ',9.00')#</td>
					<td align="right">#LSNumberFormat(data.sub, ',9.00')#</td>
					<td align="right">#LSNumberFormat(data.otros, ',9.00')#</td>
					<td align="right">
						<cfif isdefined("rsParametro")  and rsParametro.RecordCount NEQ 0 and rsParametro.Pvalor EQ 1>
							<cfset vn_promedio = (data.auto+data.jefe+data.sub+data.otros)/4>						
						<cfelse>
							<cfset vn_promedio = (data.jefe+data.sub+data.otros)/3>					
						</cfif>
						#LSNumberFormat(vn_promedio, ',9.00')#
					</td>
				</tr>
			</cfoutput>
		</cfoutput>
		
	</cfoutput>
</cfoutput>
<tr><td colspan="6" align="center"><cfif data.recordcount gt 0 >-Fin del Reporte-<cfelse>-No se encontraron registros-</cfif></td></tr>
</table>
