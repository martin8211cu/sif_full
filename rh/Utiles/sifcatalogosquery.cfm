<cfif isdefined("url.valor") and len(trim(url.valor)) gt 0>
	<cfquery name="rs" datasource="#url.conexion#">
		select PCEcatid, PCEcodigo, PCEdescripcion
		from PCECatalogo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and PCEactivo = 1
			and PCEcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.valor#">
		<cfif isdefined("url.llave") and len(trim(url.llave)) gt 0>
			and PCEref = 1
			and not PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#">
		</cfif>
	</cfquery>

	<script language="JavaScript">
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.PCEcatid#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.codigo#</cfoutput>.value="<cfoutput>#rs.PCEcodigo#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.PCEdescripcion#</cfoutput>";
		
		<cfif len(trim(url.funcion)) gt 0> 
			eval('window.parent.<cfoutput>#url.funcion#</cfoutput>(' + <cfoutput>#rs.PCEcatid#</cfoutput> + ')');
		</cfif>	
		
	</script>
</cfif>