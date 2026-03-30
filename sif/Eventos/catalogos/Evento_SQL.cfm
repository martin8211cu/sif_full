<cfset params = "">
<cfif isdefined("Form.btnEnviar")>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select 
            a.Ecodigo,
            a.ID_Evento,
            a.EVcodigo,
            a.EVdescripcion,
            a.EVformato,
            a.EVComplemento,
            a.EVactivo,
            a.EVtipoConsecutivo,            
            a.AgregaOperacion,
            a.ts_rversion
        from EEvento a
        where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
          and a.EVgenerico = 1
    </cfquery>	
    <cfif rsForm.RecordCount EQ 0>
    	<cfquery name="rsAltaGen" datasource="#session.dsn#">
			insert into EEvento(Ecodigo,EVcodigo,EVdescripcion,EVformato,EVComplemento, EVactivo, EVtipoConsecutivo, AgregaOperacion, BMUsucodigo, EVgenerico)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EVcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EVdescripcion)#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EVformato#">,0,
<!---                     <cfif isdefined("form.EVComplemento")>
 						<cfqueryparam value="#form.EVComplemento#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
                     </cfif>
--->                     
					 <cfif isdefined("form.EVactivo")>
 						<cfqueryparam value="#form.EVactivo#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETipoConsecutivo#">,0,
<!---                     <cfif isdefined("form.AgregaOperacion")>
 						<cfqueryparam value="#form.AgregaOperacion#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
--->                     
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
                     1
					)
		</cfquery>
    <cfelse>
        <cf_dbtimestamp datasource="#session.dsn#"
            table="EEvento"
            redirect="Evento.cfm"
            timestamp="#form.ts_rversion#"				
            field1="Ecodigo" 
            type1="integer"
            value1="#session.Ecodigo#"
            field2="ID_Evento" 
            type2="integer" 
            value2="#form.ID_Evento#">
        
        <cfquery name="rsCambioGen" datasource="#session.dsn#">
		update EEvento set 
			EVdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EVdescripcion#">)),
			EVformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EVformato#">, 
            EVactivo =           
			 <cfif isdefined("form.EVactivo")>
                <cfqueryparam value="#form.EVactivo#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
			EVtipoConsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETipoConsecutivo#">,  
<!---            AgregaOperacion =          
			<cfif isdefined("form.AgregaOperacion")>
                <cfqueryparam value="#form.AgregaOperacion#" cfsqltype="cf_sql_bit">,
            <cfelse>
                0,
            </cfif>
            EVComplemento =
            <cfif isdefined("form.EVComplemento")>
 				<cfqueryparam value="#form.EVComplemento#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
---> 
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EVgenerico = 1
        </cfquery>
    </cfif>
    <cflocation url="EventoGen.cfm">
</cfif>
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select EVcodigo from EEvento  
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and EVcodigo = <cfqueryparam value="#Form.EVcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#"> 
			insert into EEvento(Ecodigo,EVcodigo,EVdescripcion,EVformato,EVComplemento,EVactivo,EVtipoConsecutivo,AgregaOperacion,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EVcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EVdescripcion)#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EVformato#">,
                     <cfif isdefined("form.EVComplemento")>
 						<cfqueryparam value="#form.EVComplemento#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
                     </cfif>
                     <cfif isdefined("form.EVactivo")>
 						<cfqueryparam value="#form.EVactivo#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETipoConsecutivo#">,
                     <cfif isdefined("form.AgregaOperacion")>
 						<cfqueryparam value="#form.AgregaOperacion#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
		<cfset params=params&"&EVcodigo="&form.EVcodigo>	
	</cfif>
    
<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarEVcodigo= #item#>
        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from EEvento
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and EVcodigo  = <cfqueryparam value="#LvarEVcodigo#" cfsqltype="cf_sql_char">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="EEvento"
		redirect="Evento.cfm"
		timestamp="#form.ts_rversion#"				
		field1="Ecodigo" 
		type1="integer"
		value1="#session.Ecodigo#"
		field2="ID_Evento" 
		type2="integer" 
		value2="#form.ID_Evento#">
			
	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update EEvento set 
			EVdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EVdescripcion#">)),
			EVformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EVformato#">, 
            EVactivo =           
			 <cfif isdefined("form.EVactivo")>
                <cfqueryparam value="#form.EVactivo#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
			EVtipoConsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETipoConsecutivo#">,  
            AgregaOperacion =          
			<cfif isdefined("form.AgregaOperacion")>
                <cfqueryparam value="#form.AgregaOperacion#" cfsqltype="cf_sql_bit">,
            <cfelse>
                0,
            </cfif>
            EVComplemento =
            <cfif isdefined("form.EVComplemento")>
 				<cfqueryparam value="#form.EVComplemento#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
 
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EVcodigo = <cfqueryparam value="#Form.EVcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset params=params&"&EVcodigo="&form.EVcodigo>	
</cfif>

<cflocation url="Evento.cfm?#params#" >