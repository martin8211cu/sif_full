<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	<cfif url.tipocompetencia EQ 1 or url.tipocompetencia EQ 0><!----Solo habilidades o ambos---->
		select 	coalesce(a.RHPcodigoext,a.RHPcodigo) as codigoPuesto,
				a.RHPdescpuesto as descPuesto,
				c.RHNcodigo as nivel,
				d.RHHcodigo as codigo,
				d.RHHdescripcion as descripcion,
				coalesce(b.RHHpeso,0) as peso,
				coalesce(b.RHHpesoJefe,0) as pesojefe
		from RHPuestos a
			inner join RHHabilidadesPuesto b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
			left outer join RHNiveles c
				on b.RHNid = c.RHNid
			inner join RHHabilidades d
				on b.RHHid = d.RHHid
				and b.Ecodigo = d.Ecodigo
			inner join CFuncional e
				on a.CFid = e.CFid
				and a.Ecodigo = e.Ecodigo	
				<!----Filtro de centro funcional---->
				<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
					and (e.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCFuncional.CFpath#/%">
							or e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
						)
				<cfelseif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("form.dependencias")>
					and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidI#">
				</cfif>		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			<!---Filtro de puesto---->
			<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
			</cfif>
	</cfif>	
	<cfif url.tipocompetencia EQ 0><!----Ambos habilidades y conocimientos--->
		union
	</cfif>
	<cfif url.tipocompetencia EQ 2 or url.tipocompetencia EQ 0><!----Solo conocimientos o ambos---->
		select 	coalesce(a.RHPcodigoext,a.RHPcodigo) as codigoPuesto,
				a.RHPdescpuesto as descPuesto,
				c.RHNcodigo as nivel,
				d.RHCcodigo as codigo,
				d.RHCdescripcion as descripcion,
				coalesce(b.RHCpeso,0) as peso,
				0 as pesojefe
		from RHPuestos a
			inner join RHConocimientosPuesto b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
			left outer join RHNiveles c
				on b.RHNid = c.RHNid
			inner join RHConocimientos d
				on b.RHCid = d.RHCid
				and b.Ecodigo = d.Ecodigo	
			inner join CFuncional e
				on a.CFid = e.CFid
				and a.Ecodigo = e.Ecodigo	
				<!----Filtro de centro funcional---->
				<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.dependencias")>
					and (e.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCFuncional.CFpath#/%">
							or e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
						)
				<cfelseif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("form.dependencias")>
					and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidI#">
				</cfif>			
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			<!---Filtro de puesto---->
			<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
			</cfif>				
	</cfif>
	order by 1,4 
				
</cfquery>
<style>
	td{font-family:Arial, Helvetica, sans-serif; font-size:8pt;}
</style>

<cf_htmlReportsHeaders 
	irA="Exportarhabilidades.cfm"
	FileName="ExportarHabilidadesConocimientosPuesto#session.Usucodigo#.xls"
	method="url"
	title="">
	
<table width="98%" cellpadding="2" cellspacing="1">
	<tr>
		<td nowrap="nowrap"><b><cf_translate key="LB_CodigoPuesto">C&oacute;digo Puesto</cf_translate></b></td>
		<td nowrap="nowrap"><b><cf_translate key="LB_NombreDelPuesto">Nombre del Puesto</cf_translate></b></td>
		<td align="center"><b><cf_translate key="LB_Nivel">Nivel</cf_translate></b></td>
		<td nowrap="nowrap"><b>
			<cfif url.tipocompetencia EQ 1>
				<cf_translate key="LB_CodigoHabilidad">C&oacute;digo Habilidad</cf_translate>
			<cfelseif url.tipocompetencia EQ 2>
				<cf_translate key="LB_CodigoCompetencia">C&oacute;digo Competencia</cf_translate>
			<cfelse>
				<cf_translate key="LB_CodigoCompetencia">C&oacute;digo Competencia</cf_translate>
			</cfif>			
		</b></td>
		<td nowrap="nowrap"><b>
			<cfif url.tipocompetencia EQ 1>
				<cf_translate key="LB_NombreDeHabilidad">Nombre de Habilidad</cf_translate>
			<cfelseif url.tipocompetencia EQ 2>
				<cf_translate key="LB_NombreCompetencia">Nombre Competencia</cf_translate>
			<cfelse>
				<cf_translate key="LB_NombreCompetencia">Nombre Competencia</cf_translate>
			</cfif>		
		</b></td>
		<td align="right"><b><cf_translate key="LB_Peso">Peso</cf_translate></b></td>
		<td nowrap="nowrap" align="right"><b><cf_translate key="LB_PesoJefe">Peso Jefe</cf_translate></b></td>
	</tr>
	<cfif rsDatos.RecordCount NEQ 0>
		<cfoutput query="rsDatos">
			<tr>
				<td>#codigoPuesto#</td>		
				<td>#descPuesto#</td>
				<td align="center">#nivel#</td>
				<td>#codigo#</td>
				<td>#descripcion#</td>
				<td align="right">#LSNumberFormat(peso,'999.99')#</td>
				<td align="right">#LSNumberFormat(pesojefe,'999.99')#</td>
			</tr>		
		</cfoutput>
	<cfelse>
		<tr><td colspan="7" align="center">
			------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------
		</td></tr>
	</cfif>
</table>