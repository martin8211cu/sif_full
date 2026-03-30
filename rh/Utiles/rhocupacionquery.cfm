<!--- Recibe conexion, form, name, desc y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select rtrim(ltrim(RHOcodigo)) as RHOcodigo, RHOdescripcion 
		from RHOcupaciones
		where rtrim(ltrim(upper(RHOcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>
	<cfif rs.RecordCount NEQ 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHOcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHOdescripcion#</cfoutput>";
		</script>
	<cfelse>	
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>