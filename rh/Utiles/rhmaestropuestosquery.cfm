<cfif isdefined("url.dato") and len(trim(url.dato)) and isdefined("url.empresa") and Len(Trim(url.empresa))>
	<cfquery name="rs" datasource="#session.DSN#">
		select a.RHMPPid, a.RHMPPcodigo, a.RHMPPdescripcion
		from RHMaestroPuestoP a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
		  and a.RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid))>
			and exists (
				select 1
				from RHCategoriasPuesto x
				where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
				<cfif isdefined("url.RHCid") and len(trim(url.RHCid)) >
					and x.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
				</cfif>
				and x.RHMPPid = a.RHMPPid
			)
			
		</cfif>
<!---		select  distinct u.RHMPPid, 
				   u.RHMPPcodigo,
				   u.RHMPPdescripcion,
				   t.RHCid,
				   t.RHCdescripcion,
				   t.RHCcodigo,
				   t.RHCcodigo#LvarCNCT#' - '#LvarCNCT# t.RHCdescripcion as descrip
		from RHMontosCategoria a 
		
		inner join RHVigenciasTabla b 
		on b.RHVTid = a.RHVTid 
		and b.RHTTid=#url.RHTTid#
		
		inner join ComponentesSalariales c 
		on c.CSid = a.CSid 
		
		left outer join RHCategoriasPuesto r 
		on r.RHCPlinea = a.RHCPlinea 
		
		left outer join RHTTablaSalarial s 
		on s.RHTTid = r.RHTTid 
		
		left outer join RHCategoria t 
		on t.RHCid = r.RHCid 
		
		left outer join RHMaestroPuestoP u 
		on u.RHMPPid = r.RHMPPid 
		
		where u.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
		and u.RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid))>
		and exists (
			select 1
			from RHCategoriasPuesto x
			where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
			<cfif isdefined("url.RHCid") and len(trim(url.RHCid)) >
				and x.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
			</cfif>
			and x.RHMPPid = u.RHMPPid
		)
	</cfif>--->
	</cfquery>
	


	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.RHMPPid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.RHMPPcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHMPPdescripcion#</cfoutput>";
			if (window.parent.func<cfoutput>#Url.codigo#</cfoutput>) {window.parent.func<cfoutput>#Url.codigo#</cfoutput>()}				
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			if (window.parent.func<cfoutput>#Url.codigo#</cfoutput>) {window.parent.func<cfoutput>#Url.codigo#</cfoutput>()}				
		</script>
	</cfif>
</cfif>