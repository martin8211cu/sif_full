<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select ECid, ECdesc
		from EContratosCM
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
		<cfif isdefined("url.prov") and len(trim(url.prov))>
			and SNcodigo =  <cfqueryparam value="#url.prov#" cfsqltype="cf_sql_numeric">
	    </cfif>

		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and ECid not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.ECid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.ECdesc)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			var params ="";		
			
			params = "<cfoutput>&id=#url.id#&desc=#url.desc#</cfoutput>";
			<cfif isdefined("url.excluir") and len(trim(url.excluir))>
				params = params + "&excluir=<cfoutput>#url.excluir#</cfoutput>";
			</cfif>				
			
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
					
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
	</cfif>
</cfif>

