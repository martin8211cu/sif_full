<cfset params = "">
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select ECcomodin from ComodinEvento  
		where ECcomodin = <cfqueryparam value="#Form.ECcomodin#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#"> 
			insert into ComodinEvento(ECcomodin,ECReferencia,ECReferenciaOtro,ECtipoDato,ECformato,ECactivo,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ECcomodin)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.ECReferencia)#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECReferenciaOtro#">,
                     <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ECtipoDato)#">,
                     <cfif isdefined("form.ECformato")>
 						'S',
					 <cfelse>
					 	'N',
					 </cfif>
                     <cfif isdefined("form.ECactivo")>
 						<cfqueryparam value="#form.ECactivo#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
		<cfset params=params&"&ECcomodin="&form.ECcomodin>	
	</cfif>
    
<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarEVcodigo= #item#>
        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from ComodinEvento
            where ECcomodin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarEVcodigo)#">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#Session.DSN#"
		table="ComodinEvento"
		redirect="comodin.cfm"
		timestamp="#form.ts_rversion#"				
		field1="ECcomodin" 
		type1="varchar"
		value1="#form.ECcomodin#"
		field2="ID_Comodin" 
		type2="integer" 
		value2="#form.ID_Comodin#">
			
	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update ComodinEvento set                     
			ECReferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.ECReferencia)#">, 
            ECReferenciaOtro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECReferenciaOtro#">,
            ECtipoDato = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ECtipoDato)#">,
            ECformato =
			 <cfif isdefined("form.ECformato")>
                'S',
             <cfelse>
                'N',
             </cfif>
             ECactivo = 
			 <cfif isdefined("form.ECactivo")>
                <cfqueryparam value="#form.ECactivo#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where ECcomodin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ECcomodin)#">
	</cfquery>
	<cfset params=params&"&ECcomodin="&form.ECcomodin>	
</cfif>

<cflocation url="Comodin.cfm">