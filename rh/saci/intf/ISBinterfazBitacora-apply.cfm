<cfif IsDefined('form.btnResolver')>
	<cfquery datasource="#session.dsn#">
		update ISBinterfazBitacora
		set resuelto_por = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		,  resuelto_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">
		,  resuelto_fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IBid#">
	</cfquery>
	<cflocation url="ISBinterfazBitacora-form.cfm?IBid=#form.IBid#">
<cfelseif IsDefined('form.btnSSXS02')>
	<cfquery datasource="#session.dsn#" name="data">
		select S02CON
		from ISBinterfazBitacora b
		where b.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IBid#">
	</cfquery>
	<cfinvoke component="saci.ws.intf.SSXS02" method="reenviar" S02CON="#data.S02CON#"/>
	<cflocation url="ISBinterfazBitacora-form.cfm?IBid=#form.IBid#">
<cfelseif IsDefined('form.btnReenviar')>

	<cfquery datasource="#session.dsn#" name="data">
		select
			b.args, b.args_text, i.componente, i.metodo
		from ISBinterfazBitacora b
			left join ISBinterfaz i
				on i.interfaz = b.interfaz
		where b.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IBid#">
	</cfquery>
	
	<cfset comp = CreateObject("component", "saci.ws.intf." & data.componente)>
	<cfset comp.control_reenviar(form.IBid)>
	<cfif Len(data.args_text)>
		<cfset args_real = data.args_text>
	<cfelse>
		<cfset args_real = data.args>
	</cfif>
	<cfset argcol = StructNew()>
	<cfloop list="#args_real#" index="pair">
		<cfset StructInsert(argcol, URLDecode( ListFirst(pair, '=') ), URLDecode( ListRest(pair, '=') ), true)>
	</cfloop>
	<cfinvoke component="#comp#" method="#data.metodo#" argumentcollection="#argcol#" />
	<cflocation url="ISBinterfazBitacora-form.cfm?IBid=#form.IBid#">
<cfelse>
	<cfthrow message="Acción inválida">
</cfif>
