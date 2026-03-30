<cfif isdefined("url.RHPcodigo") and Len(Trim(url.RHPcodigo)) and isdefined("url.HYERVid") and Len(Trim(url.HYERVid))>
	<cfquery name="rs" datasource="#Session.DSN#">
		select rtrim(ltrim(a.RHPcodigo)) as RHPcodigo, a.RHPdescpuesto 
		from RHPuestos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and rtrim(ltrim(upper(a.RHPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.RHPcodigo))#">
		and not exists (
			select 1
			from HYDRelacionValoracion b
			where b.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
			and b.RHPcodigo = a.RHPcodigo
			and b.Ecodigo = a.Ecodigo
		)
	</cfquery>
	<script language="JavaScript">
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHPcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPdescpuesto#</cfoutput>";
	</script>
</cfif>