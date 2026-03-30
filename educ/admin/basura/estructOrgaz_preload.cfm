<cfquery name="rsExisteRoot" datasource="#Session.DSN#">
	select count(1) as cant
	from EstructuraOrganizacional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and EScodigoPadre is null
</cfquery>

<cfif rsExisteRoot.cant EQ 0>
	<cfquery name="rsInsertarRoot" datasource="#Session.DSN#">
		insert EstructuraOrganizacional (Ecodigo, ESOcodificacion, ESOnombre, EScodigoPadre)
		select Ecodigo, "", Edescripcion, null
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
