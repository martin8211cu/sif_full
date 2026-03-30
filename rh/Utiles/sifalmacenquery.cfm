<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfparam name="url.Acodigo" default="">

<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select Aid, Almcodigo, Bdescripcion
		from Almacen
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(Almcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.valor))#">
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and Aid not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			<cfoutput>if (window.parent.func#url.codigo#Antes) {window.parent.func#url.codigo#Antes()}</cfoutput>
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Aid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.Almcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.Bdescripcion)#</cfoutput>";
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
			<cfif url.Acodigo NEQ "">
				if (window.parent.document.<cfoutput>#url.formulario#.#url.Acodigo#</cfoutput>.value != "")
					<cfoutput>window.parent.TraeArticulos#url.Acodigo#(window.parent.document.#url.formulario#.#url.Acodigo#.value);</cfoutput>
				window.parent.document.<cfoutput>#url.formulario#.#url.Acodigo#</cfoutput>.blur();
			</cfif>
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.blur();
		</script>
	<cfelse>
		<script language="JavaScript">
			<cfoutput>if (window.parent.func#url.codigo#Antes) {window.parent.func#url.codigo#Antes()}</cfoutput>
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	</cfif>
</cfif>