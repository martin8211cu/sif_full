<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and Len(Trim(url.dato)) 
	  and isdefined("url.Ecodigo") and Len(Trim(url.Ecodigo))
	  and isdefined("url.EEid") and Len(Trim(url.EEid))
	  and isdefined("url.conexion") and Len(Trim(url.conexion))
	  >
	<cfquery name="rs" datasource="#url.conexion#">
		select distinct rtrim(b.RHPcodigo) as RHPcodigo, b.RHPdescpuesto
		from RHEncuestaPuesto a
			inner join RHPuestos b
			   on b.Ecodigo = a.Ecodigo
			   and b.RHPcodigo = a.RHPcodigo
			   and rtrim(ltrim(upper(b.RHPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		and a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
	</cfquery>
	<script language="JavaScript">
		parent.document.<cfoutput>#url.f#.#url.p1#</cfoutput>.value="<cfoutput>#rs.RHPcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.f#.#url.p2#</cfoutput>.value="<cfoutput>#rs.RHPdescpuesto#</cfoutput>";
	</script>
<cfelse>
	<script language="JavaScript">
		parent.document.<cfoutput>#url.f#.#url.p1#</cfoutput>.value = "";
		parent.document.<cfoutput>#url.f#.#url.p2#</cfoutput>.value = "";
	</script>
</cfif>
