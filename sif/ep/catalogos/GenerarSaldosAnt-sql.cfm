<!--- <cf_dump var="#form#"> --->
<cfif isdefined("Form.Alta")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into CGEstrProgConfigSaldo(ID_Estr, Descripcion,TipoAplica,Cant, BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPGdescripcion)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.numMeses#">,
                    <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>

<cfelseif isdefined("Form.Baja")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from CGEstrProgConfigSaldo
            where ID_Saldo = <cfqueryparam value="#Form.ID_Saldo#" cfsqltype="cf_sql_integer">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
		</cfquery>

<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="CGEstrProgConfigSaldo"
		redirect="GenerarSaldosAnt-form.cfm"
		timestamp="#form.ts_rversion#"
		field1="ID_Saldo"
		type1="integer"
		value1="#Form.ID_Saldo#"
		field2="ID_Estr"
		type2="integer"
		value2="#form.ID_Estr#">

	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update CGEstrProgConfigSaldo set
			Descripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPGdescripcion#">)),
            TipoAplica = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
            Cant = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.numMeses#">,
			BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where ID_Saldo = <cfqueryparam value="#Form.ID_Saldo#" cfsqltype="cf_sql_integer">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>

</cfif>

<cfset params = "">

<cfif isdefined("form.ID_Grupo")>
	<cfset params=params&"&ID_Grupo="&form.ID_Grupo>
</cfif>
<cfif isdefined("form.ID_Estr")>
	<cfset params=params&"&fID_Estr="&form.ID_Estr>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=1">

<cflocation url="ConfigEstrProg.cfm?#params#">