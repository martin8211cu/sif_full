<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfscript>
		LCFid = "";
		LCFcodigo  = ""; 
		LCFdescripcion = "";
	</cfscript>
	<cftry>
		<cfquery name="rs" datasource="#url.conexion#">
			select CFid, rtrim(ltrim(CFcodigo)) as CFcodigo, CFdescripcion
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			and rtrim(ltrim(upper(CFcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			<cfif isdefined("url.excluir") and len(trim(url.excluir )) and url.excluir neq -1>
				and CFid not in ( #url.excluir# )
			</cfif>
		</cfquery>
		<cfscript>
			if (rs.Recordcount){
				if (len(rs.CFid)) LCFid = rs.CFid;
				if (len(rs.CFcodigo)) LCFcodigo = rs.CFcodigo;
				if (len(rs.CFdescripcion)) LCFdescripcion = rs.CFdescripcion;
			}
		</cfscript>
		<cfcatch>
			<script language="javascript" type="text/javascript">
				alert("<cfoutput>#cfcatch.Message#</cfoutput>");
			</script>
		</cfcatch>
	</cftry>
	<script language="JavaScript">
		var descAnt = window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#LCFid#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(LCFcodigo)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(LCFdescripcion)#</cfoutput>";
		<cfoutput>
		if (window.parent.func#trim(Url.name)#) {window.parent.func#trim(Url.name)#();}		
		</cfoutput>
	</script>
</cfif>