<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		insert FAM009
			(FAM09MAQ, Ecodigo, FAM09DES, BMUsucodigo, fechaalta)
		values (
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#url.valor#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Maquina - #url.valor#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#Now()#">)
	</cfquery>
</cfif>

