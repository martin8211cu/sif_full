<cfparam name="url.Tabla" 		type="numeric">	<!---Id de la tabla salarial ---->
<cfparam name="url.Vigencia" 	type="numeric">	<!---Id de la vigencia de la tabla salarial ---->
<cfparam name="url.Escenario" 	type="numeric">	<!---Id del escenario---->
<cfparam name="url.Origen" 		type="string">	<!---Origen para indicar si se esta llamando desde escenarios o desde escalas salariales--->
<cfif url.Origen EQ 'TS'>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 	c.RHTTcodigo,		
				e.RHMPPcodigo,
				f.RHCcodigo,
				b.RHVTfecharige,
				b.RHVTfechahasta,
				g.CScodigo,
				a.RHMCmonto,
				b.RHVTcodigo,
				b.RHVTdescripcion,
				b.RHVTdocumento
			
		from RHMontosCategoria a
		
			inner join RHVigenciasTabla b
				on a.RHVTid = b.RHVTid
		
			inner join RHTTablaSalarial c
				on b.RHTTid = c.RHTTid
		
			left outer join RHCategoriasPuesto d
				on a.RHCPlinea = d.RHCPlinea
		
				left outer join RHMaestroPuestoP e
					on d.RHMPPid = e.RHMPPid
				
				left outer join RHCategoria f
					on d.RHCid = f.RHCid
		
			inner join ComponentesSalariales g
				on a.CSid = g.CSid
		
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif isdefined("url.Tabla") and len(trim(url.Tabla))>
				and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Tabla#">
			</cfif>
			<cfif isdefined("url.Vigencia") and len(trim(url.Vigencia))>
				and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Vigencia#">
			</cfif>
	</cfquery>
<cfelseif url.Origen EQ 'ES'>
	<cfquery name="ERR" datasource="#session.DSN#">	
		select 	(select min(f.RHTTcodigo) 
				from RHTTablaSalarial f
				where b.RHTTid = f.RHTTid
				) as RHTTcodigo,
				(select min(c.RHMPPcodigo)
				from RHMaestroPuestoP c
				where a.RHMPPid = c.RHMPPid
				) as RHMPPcodigo,
				(select min(d.RHCcodigo) 
				from RHCategoria d
				where a.RHCid = d.RHCid
				) as RHCcodigo,
				a.RHDTEfdesde,
				a.RHDTEfhasta,		
				(select min(e.CScodigo)
				from ComponentesSalariales e
				where a.CSid = e.CSid
				) as CScodigo,
				a.RHDTEmonto,			
				(select min(g.RHVTcodigo)
				from RHVigenciasTabla g
				where b.RHTTid = g.RHTTid
				) as RHVTcodigo,
				b.RHETEdescripcion,
				'' as Documento
		from RHDTablasEscenario a
			inner join RHETablasEscenario b
				on a.RHETEid = b.RHETEid		
		where b.RHEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Escenario#">
			<cfif isdefined("url.Tabla") and len(trim(url.Tabla))>
				and b.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Tabla#">
			</cfif>
	</cfquery>
</cfif>