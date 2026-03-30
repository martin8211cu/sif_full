<cfset params="ID_Evento="&#Form.ID_Evento#>

<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select ID_Evento,ID_Operacion from DEvento  
		where ID_Evento  = <cfqueryparam value="#Form.ID_Evento#" cfsqltype="cf_sql_integer">
		and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
        and Transaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Transaccion#">
        <cfif isdefined("form.ComplementoActivo")>
        	and Complemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Complemento)#">
        </cfif>
	</cfquery>
    
    <cfif isdefined("form.GeneraEvento") >
		<cfif Verifica_Origen(#Form.ID_Evento#,"#Form.Oorigen#")>
			<cfset params=params&"&Error=1">
            <cflocation url="ConfiguraEvento.cfm?#params#" >
        </cfif>
    </cfif>
	<cfif Verifica_OrigenTrans("#Form.Transaccion#","#Form.Oorigen#")>
        <cfset params=params&"&Error=2">
        <cflocation url="ConfiguraEvento.cfm?#params#" >
    </cfif>
	
	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#"> 
			insert into DEvento(ID_Evento,Ecodigo,OperacionCodigo,Oorigen,Transaccion,GeneraEvento,Complemento,
                                ComplementoActivo,BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Evento#">,
              		 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.OperacionCodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Oorigen)#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Transaccion#">, 
                     <cfif isdefined("form.GeneraEvento")>
 						<cfqueryparam value="#form.GeneraEvento#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfif isdefined("form.Complemento") and form.Complemento neq "XXXX">
                     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Complemento#">
                     <cfelse>
                     ''
                     </cfif>,
                     <cfif isdefined("form.ComplementoActivo")>
 						<cfqueryparam value="#Form.ComplementoActivo#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
	</cfif>
    
<cfelseif isdefined("Form.btneliminar")and isdefined("form.chk") and len(trim(form.chk))>
	<cfif isDefined("Url.ID_Evento")>
		<cfset Form.ID_Evento = #Url.ID_Evento#>
	</cfif>
    <cfset params="ID_Evento="&#Form.ID_Evento#>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarEVcodigo= #item#>
        <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from DEvento
            where ID_Evento  = <cfqueryparam value="#Form.ID_Evento#" cfsqltype="cf_sql_integer">
		  	and ID_Operacion = <cfqueryparam value="#LvarEVcodigo#"   cfsqltype="cf_sql_integer">
        </cfquery>
    </cfloop>
<cfelseif isdefined("Form.Cambio")>
    <cfif isdefined("form.GeneraEvento") >
		<cfif Verifica_Origen(#Form.ID_Evento#,"#Form.Oorigen#")>
			<cfset params=params&"&Error=1">
            <cflocation url="ConfiguraEvento.cfm?#params#" >
        </cfif>
    </cfif>
	<cfif Verifica_OrigenTrans("#Form.Transaccion#","#Form.Oorigen#","#Form.ID_Evento#")>
        <cfset params=params&"&Error=2">
        <cflocation url="ConfiguraEvento.cfm?#params#" >
    </cfif>

	<cf_dbtimestamp datasource="#session.dsn#"
		table="DEvento"
		redirect="ConfiguraEvento.cfm"
		timestamp="#form.ts_rversion#"				
		field1="ID_Evento" 
		type1="integer"
		value1="#Form.ID_Evento#"
		field2="ID_Operacion" 
		type2="integer" 
		value2="#form.ID_Operacion#">
			
	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update DEvento set 
			ID_Evento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Evento#">,
			OperacionCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.OperacionCodigo)#">,            
            Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Oorigen)#">,
            Transaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Transaccion#">,
            GeneraEvento =          
			 <cfif isdefined("form.GeneraEvento")> 
                <cfqueryparam value="#form.GeneraEvento#" cfsqltype="cf_sql_bit">,
             <cfelse>
                0,
             </cfif>
             ComplementoActivo =
			 <cfif isdefined("form.ComplementoActivo")>
                <cfqueryparam value="#form.ComplementoActivo#" cfsqltype="cf_sql_bit">,
                Complemento =
                <cfif isdefined("form.Complemento") and form.Complemento neq "XXXX">
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Complemento#">
                <cfelse>
                 ''
                </cfif>,
             <cfelse>
                0,
                Complemento = '',
             </cfif>
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where ID_Evento  = <cfqueryparam value="#Form.ID_Evento#"    cfsqltype="cf_sql_integer">
		  	and ID_Operacion = <cfqueryparam value="#Form.ID_Operacion#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>


<cflocation url="ConfiguraEvento.cfm?#params#" >

<cffunction name="Verifica_Origen" access="public" returntype="boolean">
	<cfargument name="ID_Evento" type="numeric" required="true">
    <cfargument name="Oorigen" type="string" required="true">
    
		<cfquery datasource="#Session.DSN#" name="rs_verifica">
			select ID_Evento,Oorigen from DEvento
			where 
            ID_Evento    = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID_Evento#">
			and Oorigen != <cfqueryparam cfsqltype="cf_sql_char"    value="#Oorigen#">
            and GeneraEvento = 1
		</cfquery>
        <cfif rs_verifica.RecordCount neq 0>
			<cfreturn true>
        <cfelse>
        	<cfreturn false>
        </cfif>
</cffunction>

<cffunction name="Verifica_OrigenTrans" access="public" returntype="boolean">
	<cfargument name="Transaccion" type="string" required="true">
    <cfargument name="Oorigen" type="string" required="true">
    <cfargument name="ID_Evento" type="numeric" required="false">
		<cfquery datasource="#Session.DSN#" name="rs_verifica">
			select Transaccion,Oorigen from DEvento
			where 
            Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#Transaccion#">
			and Oorigen = <cfqueryparam cfsqltype="cf_sql_char"    value="#Oorigen#">            
            and GeneraEvento = 1
            <cfif isdefined("ID_Evento")>
            	and ID_Evento !=  <cfqueryparam cfsqltype="cf_sql_integer" value="#ID_Evento#">
            </cfif>
		</cfquery>
        <cfif rs_verifica.RecordCount neq 0>
			<cfreturn true>
        <cfelse>
        	<cfreturn false>
        </cfif>
</cffunction>