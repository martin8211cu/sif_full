<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select c.Cid, c.Ccodigo, c.Cdescripcion, coalesce(c.Ucodigo, '') as Ucodigo, cc.cuentac
		from Conceptos c
		inner join CConceptos cc
			on cc.CCid=c.CCid
		where c.Ecodigo		   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and upper(c.Ccodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
		  and upper(c.Ctipo)   = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(url.tipo))#">
		</cfif>
		<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
			#url.filtroextra#
		</cfif>
	</cfquery>
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value='<cfoutput>#rs.Cid#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value='<cfoutput>#rs.Ccodigo#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value='<cfoutput>#rs.Cdescripcion#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>.value='<cfoutput>#trim(rs.Ucodigo)#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>.value='<cfoutput>#rs.cuentac#</cfoutput>';	
			<cfoutput>
				if (window.parent.func#url.name#) { window.parent.func#url.name#();}			
			</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>.value="";	
		</script>
	</cfif>
</cfif>