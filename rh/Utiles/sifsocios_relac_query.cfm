<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("Url.GSNid") and Url.GSNid gt 0 and not isdefined("Form.GSNid")>
	<cfparam name="Form.GSNid" default="#Url.GSNid#">
</cfif>

<cfparam name="url.excepto" type="numeric">

<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select SNcodigo, SNnumero, SNnombre
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(SNnumero) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			<cfif url.tipo neq 'A'>
				and SNtiposocio in ('A', '#url.tipo#')
			<cfelse>
				and SNtiposocio = 'A'
			</cfif>
		</cfif> 
		<cfif isdefined("url.GSNid") and len(trim(url.GSNid))>
			and GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
		</cfif>
		<!--- que no tienen papa --->
		and SNidPadre is null
		<cfif Len(url.excepto)>
		and SNid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.excepto#">
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.SNnumero#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	</cfif>
</cfif>