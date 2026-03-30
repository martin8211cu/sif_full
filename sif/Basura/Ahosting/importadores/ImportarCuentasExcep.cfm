<cfscript>
	bcheck0 = false; // Chequeo de Existencia de Socio
	bcheck1 = false; // Chequeo de Tipo de Socio
	bcheck2 = false; // Chequeo de la Transaccion
	bcheck3 = false; // Chequeo de Cuenta Contable
	bcheck4 = false; // Chequeo de Repetidos
	bcheck5 = false; // Chequeo de que la cuenta de excepcion no este configurada anteriormente
</cfscript>

<!---NUEVO IMPORTADOR CUENTAS DE EXCEPCION
Realizado por Alejandro Bolaños Gómez APPHOSTING 08-04-2010 --->

<!---Se realiza lo siguiente: Se verifican los encabezadoz y se realizan las validaciones necesarias --->

<!--- Verifica si el Socio de Negocios existe en el Sistema --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0
	from #table_name# a
	where not exists (select 1 
			       	from SNegocios
			        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
			   	    and SNcodigoext = a.SNcodigoext)
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>

<!---Verifica que el tipo de socio de acuerdo al modulo dado  --->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
        from #table_name# a
        where not exists (select 1 
                        from SNegocios
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                        and SNcodigoext = a.SNcodigoext
                        and (SNtiposocio like 'A'
                        or SNtiposocio like 
                        case a.Modulo 
                        when 'CC' then 'C'
                        when 'CP' then 'P'
                        else 'X' end))
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>

<!--- Verifica que la Transaccion exista --->
<cfif bcheck1>
	<cfquery name="rsCuentas" datasource="#session.DSN#">
    	select *
        from #table_name#
    </cfquery>
    <cfif isdefined("rsCuentas") and rsCuentas.recordcount GT 0>
    <cfset varcheck2 = true>
    <cfloop query="rsCuentas">
    	<cfif rsCuentas.Modulo EQ "CC">
            <cfquery name="rsCheck2" datasource="#Session.DSN#">
                select count(1) as check2 
                from #table_name# a
                where not exists 
                    (select 1 
                     from CCTransacciones
                     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                     and CCTcodigo = a.CTcodigo)
            </cfquery>	
        	<cfif rsCheck2.check2 GT 0>
            	<cfset varcheck2 = false>
            </cfif>
        <cfelse>
        	<cfquery name="rsCheck2" datasource="#Session.DSN#">
                select count(1) as check2 
                from #table_name# a
                where not exists 
                    (select 1 
                     from CPTransacciones
                     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                     and CPTcodigo = a.CTcodigo)
            </cfquery>
            <cfif rsCheck2.check2 GT 0>
            	<cfset varcheck2 = false>
            </cfif>
        </cfif>	
    </cfloop>
    </cfif> 
    
    <cfset bcheck2 = varcheck2>
</cfif>

<!--- Verifica que la cuenta exista --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select 1
			from CFinanciera
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and CFformato like a.Cuenta
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Verifica que no haya registros repetidos en el layout --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select 1 as check4
		from #table_name# a
		group by SNcodigoext, Modulo, CTcodigo
        having count(1) > 1
	</cfquery>
    <cfif rsCheck4.recordcount EQ 0 or rsCheck4.check4 EQ "">
    	<cfset varcheck4 = 0>
    <cfelse>
    	<cfset varcheck4 = 1>
    </cfif>
	<cfset bcheck4 = varcheck4 LT 1>
</cfif>

<!---Verifica que la cuenta de excepcion no este configurada anteriormente--->
<cfif bcheck4>
	<cfquery name="rsCheck5" datasource="#Session.DSN#">
		select count(1) as check5
		from #table_name# a
		where exists
        (	select 1
			from SNCPTcuentas sp
            	inner join SNegocios s
             	on sp.Ecodigo = s.Ecodigo and sp.SNcodigo = s.SNcodigo
            where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and s.SNcodigoext = a.SNcodigoext
            and sp.CPTcodigo like
            case a.Modulo when 'CC' then 'XXX' else ltrim(rtrim(a.CTcodigo)) end
        ) 
        OR
        exists
        (	select 1
			from SNCCTcuentas sp
            	inner join SNegocios s
             	on sp.Ecodigo = s.Ecodigo and sp.SNcodigo = s.SNcodigo
            where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and s.SNcodigoext = a.SNcodigoext
            and sp.CCTcodigo like
            case a.Modulo when 'CC' then ltrim(rtrim(a.CTcodigo)) else 'XXX' end
        ) 
	</cfquery>
	<cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<cfif bcheck5>
	
    <cfquery name="rsCuentas" datasource="#session.DSN#">
    	select *
        from #table_name#
    </cfquery>
    
	<!--- Inserta cuentas de Excepcion --->
    <cfif isdefined("rsCuentas") and rsCuentas.recordcount GT 1>
    	<cfloop query="rsCuentas">
        	<!--- Obtiene el CFcuenta--->
            <cfquery name="rsCFcuenta" datasource="#session.DSN#">
            	select CFcuenta
                from CFinanciera
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and CFformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.Cuenta#">
            </cfquery>
            <!--- Obtiene el Codigo del Socio--->
            <cfquery name="rsSNcodigo" datasource="#session.DSN#">
            	select SNcodigo
                from SNegocios
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.SNcodigoext#">
            </cfquery>
			<cfif rsCuentas.Modulo EQ "CC">
                <cfquery datasource="#session.DSN#">
                    insert into SNCCTcuentas (Ecodigo, SNcodigo, CCTcodigo, CFcuenta, BMUsucodigo)
                    values
                    (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNcodigo.SNcodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsCuentas.CTcodigo)#">,
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCFcuenta.CFcuenta#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  
                     )
                </cfquery>
            <cfelse>
            	<cfquery datasource="#session.DSN#">
                    insert into SNCPTcuentas (Ecodigo, SNcodigo, CPTcodigo, CFcuenta, BMUsucodigo)
                    values
                    (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNcodigo.SNcodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsCuentas.CTcodigo)#">,
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCFcuenta.CFcuenta#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  
                     )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
<cfelse>
	<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El socio de negocios no existe: ' as MSG, a.SNcodigoext as Socio
            from #table_name# a
            where not exists (select 1 
                            from SNegocios
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                            and SNcodigoext = a.SNcodigoext)
        </cfquery>

    <!--- Fallo Check1 --->      
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El tipo de socio no corresponde con el modulo dado: ' as MSG, a.Modulo as Modulo, a.SNcodigoext as Socio
            from #table_name# a
            where not exists (select 1 
                            from SNegocios
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                            and SNcodigoext = a.SNcodigoext
                            and (SNtiposocio like 'A'
							or SNtiposocio like 
                            case a.Modulo 
                            when 'CC' then 'C'
                            when 'CP' then 'P'
                            else 'X' end))
		</cfquery>
	
	<!--- Fallo Check2 --->
    <cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Verifique que las transacciones dadas existan en las transacciones del modulo indicado: ' as MSG, a.Modulo as Modulo, a.CTcodigo as Transaccion
			from #table_name# a
		</cfquery>
    
	<!--- Fallo Check3 --->    
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Cuenta Financiera no existe: ' as MSG, a.Cuenta
            from #table_name# a
            where not exists
            (
                select 1
                from CFinanciera
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and CFformato like a.Cuenta
            )
		</cfquery>

	<!--- Fallo Check4 --->
	<cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'Registro Duplicado: ' as MSG, a.SNcodigoext, a.Modulo, a.CTcodigo
            from #table_name# a
            group by SNcodigoext, Modulo, CTcodigo
            having count(1) > 1
		</cfquery>

	<cfelse>
		<!--- Fallo Check5 --->
        <cfif not bcheck5>
            <cfquery name="ERR" datasource="#session.DSN#">
                select distinct 'Cuenta de Excepcion ya existe: ' as MSG, a.SNcodigoext as Socio, a.Modulo, a.CTcodigo as Transaccion
                from #table_name# a
                where exists
                (	select 1
                    from SNCPTcuentas sp
                        inner join SNegocios s
                        on sp.Ecodigo = s.Ecodigo and sp.SNcodigo = s.SNcodigo
                    where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                    and s.SNcodigoext = a.SNcodigoext
                    and sp.CPTcodigo like
                    case a.Modulo when 'CC' then 'XXX' else ltrim(rtrim(a.CTcodigo)) end
                ) 
                OR
                exists
                (	select 1
                    from SNCCTcuentas sp
                        inner join SNegocios s
                        on sp.Ecodigo = s.Ecodigo and sp.SNcodigo = s.SNcodigo
                    where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                    and s.SNcodigoext = a.SNcodigoext
                    and sp.CCTcodigo like
                    case a.Modulo when 'CC' then ltrim(rtrim(a.CTcodigo)) else 'XXX' end
                ) 
            </cfquery>
		</cfif>
	</cfif>
</cfif>
