<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif not isdefined("url.Ecodigo") or len(trim(url.Ecodigo)) eq 0>
    <cfset url.Ecodigo = session.Ecodigo>
  </cfif>	
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select convert(varchar, CFid) as CFid, rtrim(ltrim(CFcodigo)) as CFcodigo, CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ecodigo#">
		and rtrim(ltrim(upper(CFcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		<cfif isdefined("url.dpto") and url.dpto NEQ "">
			and Dcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.dpto#">
		</cfif>
		<cfif isdefined("url.of") and url.of NEQ "">
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.of#">		
		</cfif>
	</cfquery>
	<script language="JavaScript">	
		<cfif isdefined('rs') and rs.recordCount GT 0>
			parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.CFid#</cfoutput>";
			parent.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.CFcodigo#</cfoutput>";
			parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.CFdescripcion#</cfoutput>";
		<cfelse>
			parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			parent.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		</cfif>
		<cfif isdefined("url.onblur") and len(trim(url.onblur))>
			parent.<cfoutput>#url.onblur#</cfoutput>;
		</cfif>
	</script>	
</cfif>