<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("Url.GSNid") and Url.GSNid gt 0 and not isdefined("Form.GSNid")>
	<cfparam name="Form.GSNid" default="#Url.GSNid#">
</cfif>
<cfif isdefined("Url.SNid") and not isdefined("Form.SNid")>
	<cfparam name="Form.SNid" default="#Url.SNid#">
</cfif>

<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select SNcodigo, SNnumero, SNnombre, SNid
		from SNegocios
		where Ecodigo=#session.Ecodigo#
		and SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.codigo)#">
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
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.SNnumero#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			<cfif isdefined('form.SNid')>window.parent.document.<cfoutput>#url.formulario#.#url.SNid#</cfoutput>.value="<cfoutput>#rs.SNid#</cfoutput>";</cfif>
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfif isdefined('form.SNid')>window.parent.document.<cfoutput>#url.formulario#.#url.SNid#</cfoutput>.value="";</cfif>
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	</cfif>
</cfif>