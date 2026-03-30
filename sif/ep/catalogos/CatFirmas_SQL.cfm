<!--- <cf_dump var="#form#"> --->

<cfset params = "">
<!--- <cfif isdefined("Form.btnEnviar")>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select
            a.Ecodigo,
            a.ID_Estr,
            a.EPcodigo,
            a.EPdescripcion,
            a.ts_rversion
        from CGEstrProg a
        where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
          and a.EPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EVcodigo)#">
    </cfquery>
    <cfif rsForm.RecordCount EQ 0>
    	<cfquery name="rsAltaGen" datasource="#session.dsn#">
			insert into CGEstrProg(Ecodigo,EPcodigo,EPdescripcion,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPdescripcion)#">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
                     1
					)
		</cfquery>
    <cfelse>
        <cf_dbtimestamp datasource="#session.dsn#"
            table="CGEstrProg"
            redirect="CatFirmas.cfm"
            timestamp="#form.ts_rversion#"
            field1="Ecodigo"
            type1="integer"
            value1="#session.Ecodigo#"
            field2="ID_Estr"
            type2="integer"
            value2="#form.ID_Estr#">

        <cfquery name="rsCambioGen" datasource="#session.dsn#">
		update CGEstrProg set
			EPdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">)),
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
    <cflocation url="CatFirmas.cfm">
</cfif> --->

<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select Fcodigo from CGEstrCatFirma
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Fcodigo = <cfqueryparam value="#Form.EPcodigo#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into CGEstrCatFirma(Ecodigo,Fcodigo,Fdescripcion,NumFilas,NumColumnas,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPdescripcion)#">,
					 <cfqueryparam value="#Form.Filas#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#Form.Columnas#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
	</cfif>

<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarEPcodigo= #item#>

		<cfquery name="Transacciones" datasource="#Session.DSN#">
            delete CGEstrCatFirmaD
            where ID_Firma  = (select  ID_Firma
								from CGEstrCatFirma
            				where Ecodigo = #Session.Ecodigo#
            					and Fcodigo  = <cfqueryparam value="#LvarEPcodigo#" cfsqltype="cf_sql_char">)
        </cfquery>

        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete CGEstrCatFirma
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and Fcodigo  = <cfqueryparam value="#LvarEPcodigo#" cfsqltype="cf_sql_char">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="CGEstrCatFirma"
		redirect="CatFirmas.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="ID_Firma"
		type2="integer"
		value2="#form.ID_Estr#">

	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update CGEstrCatFirma set
			Fdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">)),
			NumFilas = <cfqueryparam value="#Form.Filas#" cfsqltype="cf_sql_integer">,
			NumColumnas	= <cfqueryparam value="#Form.Columnas#" cfsqltype="cf_sql_integer">,
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Fcodigo = <cfqueryparam value="#Form.EPcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset params=params&"&EPcodigo="&form.EPcodigo>
</cfif>

<cflocation url="CatFirmas.cfm?#params#" >
