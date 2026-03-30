<cfset params = "">
<cfif isdefined("Form.btnEnviar")>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select
            a.Ecodigo,
            a.AFMSid,
            a.AFMScodigo,
            a.AFMSdescripcion,
            a.ts_rversion
        from AFMotivosSalida a
        where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
          and a.AFMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFMScodigo)#">
    </cfquery>
    <cfif rsForm.RecordCount EQ 0>
    	<cfquery name="rsAltaGen" datasource="#session.dsn#">
			insert into AFMotivosSalida(Ecodigo,AFMScodigo,AFMSdescripcion,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFMScodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFMSdescripcion)#">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
    <cfelse>
        <cf_dbtimestamp datasource="#session.dsn#"
            table="AFMotivosSalida"
            redirect="motivoSalida.cfm"
            timestamp="#form.ts_rversion#"
            field1="Ecodigo"
            type1="integer"
            value1="#session.Ecodigo#"
            field2="AFMSid"
            type2="integer"
            value2="#form.AFMSid#">

        <cfquery name="rsCambioGen" datasource="#session.dsn#">
		update AFMotivosSalida set
			AFMSdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFMSdescripcion#">)),
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
    <cflocation url="EstructuraP.cfm">
</cfif>

<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select AFMScodigo from AFMotivosSalida
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and AFMScodigo = <cfqueryparam value="#Form.AFMScodigo#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into AFMotivosSalida(Ecodigo,AFMScodigo,AFMSdescripcion,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFMScodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFMSdescripcion)#">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
		<cfset params=params&"&AFMScodigo="&form.AFMScodigo>
	</cfif>

<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarAFMScodigo= #item#>


        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete AFMotivosSalida
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and AFMScodigo  = <cfqueryparam value="#LvarAFMScodigo#" cfsqltype="cf_sql_char">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="AFMotivosSalida"
		redirect="motivoSalida.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="AFMSid"
		type2="integer"
		value2="#form.AFMSid#">

	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update AFMotivosSalida set
			AFMSdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFMSdescripcion#">)),
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFMScodigo = <cfqueryparam value="#Form.AFMScodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset params=params&"&AFMScodigo="&form.AFMScodigo>
</cfif>

<cflocation url="motivoSalida.cfm?#params#" >