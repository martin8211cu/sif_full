<cfset params = "">
<cfif isdefined("Form.btnEnviar")>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select
            a.Ecodigo,
            a.AFDSid,
            a.AFDcodigo,
            a.AFDdescripcion,
            a.ts_rversion
        from CGEstrProg a
        where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
          and a.AFDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFDcodigo)#">
    </cfquery>
    <cfif rsForm.RecordCount EQ 0>
    	<cfquery name="rsAltaGen" datasource="#session.dsn#">
			insert into AFDestinosSalida(Ecodigo,AFDcodigo,AFDdescripcion,
						AFDAtencion,
						AFDdireccion1,
						AFDdireccion2,
						AFDciudad,
						AFDestado,
						AFDcodigo_postal,
						Ppais,
						AFDtelefono,
						AFDfax,
						AFDcorreo_electronico,
						BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFDcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDAtencion)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion1)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion2)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDciudad)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDestado)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcodigo_postal)#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ppais)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDtelefono)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDfax)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcorreo_electronico)#">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
                   )
		</cfquery>
    <cfelse>
        <cf_dbtimestamp datasource="#session.dsn#"
            table="AFDestinosSalida"
            redirect="destinoSalida.cfm"
            timestamp="#form.ts_rversion#"
            field1="Ecodigo"
            type1="integer"
            value1="#session.Ecodigo#"
            field2="AFDSid"
            type2="integer"
            value2="#form.AFDSid#">

        <cfquery name="rsCambioGen" datasource="#session.dsn#">
		update AFDestinosSalida set
			AFDdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFDdescripcion#">)),
			AFDAtencion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDAtencion)#">,
			AFDdireccion1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion1)#">,
			AFDdireccion2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion2)#">,
			AFDciudad=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDciudad)#">,
			AFDestado=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDestado)#">,
			AFDcodigo_postal=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcodigo_postal)#">,
			Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ppais)#">,
			AFDtelefono=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDtelefono)#">,
			AFDfax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDfax)#">,
			AFDcorreo_electronico=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcorreo_electronico)#">,
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and AFDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFDcodigo)#">
        </cfquery>
    </cfif>
    <cflocation url="destinoSalida.cfm">
</cfif>

<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select AFDcodigo from AFDestinosSalida
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and AFDcodigo = <cfqueryparam value="#Form.AFDcodigo#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into AFDestinosSalida(Ecodigo,AFDcodigo,AFDdescripcion,
						AFDAtencion,
						AFDdireccion1,
						AFDdireccion2,
						AFDciudad,
						AFDestado,
						AFDcodigo_postal,
						Ppais,
						AFDtelefono,
						AFDfax,
						AFDcorreo_electronico,
						BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFDcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDAtencion)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion1)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion2)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDciudad)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDestado)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcodigo_postal)#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ppais)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDtelefono)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDfax)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcorreo_electronico)#">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
                   )
		</cfquery>
		<cfset params=params&"&AFDcodigo="&form.AFDcodigo>
	</cfif>

<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarAFDcodigo= #item#>


        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete AFDestinosSalida
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and AFDcodigo  = <cfqueryparam value="#LvarAFDcodigo#" cfsqltype="cf_sql_char">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="AFDestinosSalida"
		redirect="destinoSalida.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="AFDSid"
		type2="integer"
		value2="#form.AFDSid#">

	<cfquery name="rsCambioGen" datasource="#session.dsn#">
		update AFDestinosSalida set
			AFDdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AFDdescripcion#">)),
			AFDAtencion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDAtencion)#">,
			AFDdireccion1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion1)#">,
			AFDdireccion2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDdireccion2)#">,
			AFDciudad=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDciudad)#">,
			AFDestado=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDestado)#">,
			AFDcodigo_postal=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcodigo_postal)#">,
			Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ppais)#">,
			AFDtelefono=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDtelefono)#">,
			AFDfax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDfax)#">,
			AFDcorreo_electronico=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.AFDcorreo_electronico)#">,
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and AFDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.AFDcodigo)#">
        </cfquery>
	<cfset params=params&"&AFDcodigo="&form.AFDcodigo>
</cfif>

<cflocation url="destinoSalida.cfm?#params#" >