<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfscript>
		LRHCid = "";
		LRHCcodigo  = "";
		LRHCdescripcion = "";
	</cfscript>
	<cftry>
		<cfquery name="rs" datasource="#url.conexion#">
			select a.RHCid, rtrim(ltrim(a.RHCcodigo)) as RHCcodigo, a.RHCdescripcion
			from RHCategoria a
			<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid))>
				inner join RHCategoriasPuesto x
					on x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
					and x.RHCid = a.RHCid
					<cfif isdefined("url.RHMPPid") and len(trim(url.RHMPPid))>
						and x.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
					</cfif>
			</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			and rtrim(ltrim(upper(a.RHCcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		</cfquery>
		<cfscript>
			if (rs.Recordcount){
				if (len(rs.RHCid)) LRHCid = rs.RHCid;
				if (len(rs.RHCcodigo)) LRHCcodigo = rs.RHCcodigo;
				if (len(rs.RHCdescripcion)) LRHCdescripcion = rs.RHCdescripcion;
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
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#LRHCid#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(LRHCcodigo)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(LRHCdescripcion)#</cfoutput>";
		<cfoutput>
		if (window.parent.func#trim(Url.name)#) {window.parent.func#trim(Url.name)#();}		
		</cfoutput>
	</script>
</cfif>