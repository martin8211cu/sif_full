<cfset params = "">
<cfif isdefined("Form.btnEnviar")>
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
            redirect="EstructuraP.cfm"
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
    <cflocation url="EstructuraP.cfm">
</cfif>

<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select EPcodigo from CGEstrProg  
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and EPcodigo = <cfqueryparam value="#Form.EPcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#"> 
			insert into CGEstrProg(Ecodigo,EPcodigo,EPdescripcion,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPdescripcion)#">, 
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
		<cfset params=params&"&EPcodigo="&form.EPcodigo>	
	</cfif>
    
<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarEPcodigo= #item#>
        
        
        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete CGEstrProg
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and EPcodigo  = <cfqueryparam value="#LvarEPcodigo#" cfsqltype="cf_sql_char">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="CGEstrProg"
		redirect="EstructuraP.cfm"
		timestamp="#form.ts_rversion#"				
		field1="Ecodigo" 
		type1="integer"
		value1="#session.Ecodigo#"
		field2="ID_Estr" 
		type2="integer" 
		value2="#form.ID_Estr#">
			
	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update CGEstrProg set 
			EPdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">)),
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EPcodigo = <cfqueryparam value="#Form.EPcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset params=params&"&EPcodigo="&form.EPcodigo>	
</cfif>

<cflocation url="EstructuraP.cfm?#params#" >