<cfcomponent output="no">
	<!--- Generacion XML --->
	<cffunction name="fnGeneraXML" access="remote" output="no" returntype="xml">
    	<cfargument name="rs" 			type="query">
    	<cfargument name="Movimiento" 	type="string" default="Verificacion">
		<cfset names = rs.getMetaData().getColumnLabels()>
        <cfxml variable="xmlobject">
        <rs>
        <rows>
        <cfloop query="rs">
            <row>
                <id><cfoutput>#rs.currentrow#</cfoutput></id>
				<cfloop  index="i" from="1" to="#arraylen(names)#">
	                <cfoutput><#names[i]#>#evaluate("rs.#names[i]#")#</#names[i]#></cfoutput>
                </cfloop>
                <Date><cfoutput>#dateformat(now(), 'ddmmyyyy')##timeformat(now(), 'HHmm')#</cfoutput></Date>
                <Descr><cfoutput>#Arguments.Movimiento#</cfoutput></Descr>
            </row>
        </cfloop>
        </rows>
        <ctrl>
        <QTY><cfoutput>#rs.recordcount#</cfoutput></QTY>
        </ctrl>
        </rs>
        </cfxml>
		<cfreturn xmlobject>    
    </cffunction>

   	<!--- Cuentas --->
    <cffunction name="fnGeneraCuentas" access="remote" output="no" returntype="xml">
	    <cfargument name="Empresa"  type="numeric" required="yes">
        <cfargument name="Conexion" type="string"  required="yes">
	    <cfargument name="Cuenta"   type="string"  required="no" default="-1">
	    <cfargument name="Ciclo"    type="numeric" required="no" default="-1" hint="Corte de Cuenta de Saldos ( 1=Lunes, 2=Martes, ... 7 = Domingo )">
        <cfargument name="Cobro"    type="boolean" required="no" default="no">

        <cfquery name="rsresult" datasource="#Arguments.Conexion#">
            select 
                tc.QPtipoCteCod as CustType, 
                ct.QPcteDocumento as Customer, 
                b.QPctaBancoNum as Account, 
                sum(s.QPctaSaldosSaldo) as Amount
            from QPventaTags v
                inner join QPcuentaSaldos s
                    on s.QPctaSaldosid = v.QPctaSaldosid
                
                inner join QPcuentaBanco b
                    on b.QPctaBancoid = s.QPctaBancoid
                    
                    
                inner join QPcliente ct
                    on ct.QPcteid = b.QPcteid
                
                inner join QPtipoCliente tc
                    on tc.QPtipoCteid = ct.QPtipoCteid
            where v.Ecodigo = #Arguments.Empresa#
              and s.QPctaSaldosid is not null
              and b.QPctaBancoNum is not null
              and QPvtaAnulado <> 1  <!--- 1= Anulado 2= Sin Anular --->
			<cfif Arguments.Cuenta NEQ -1>
              and b.QPctaBancoNum = '#Arguments.Cuenta#'
            </cfif>
            <cfif Arguments.Ciclo NEQ -1>
              and s.QPctaSaldosCiclo = #Arguments.ciclo#
            </cfif>
            group by tc.QPtipoCteCod, ct.QPcteDocumento, b.QPctaBancoNum
        </cfquery>

		<cfif Arguments.Cobro>
        	<cfset LvarMovimiento = "Cobro Saldo PostPago">
		<cfelseif Arguments.Cuenta NEQ "-1">
        	<cfset LvarMovimiento = "Verificacion Cuenta">
		<cfelse>
        	<cfset LvarMovimiento = "Verificacion para Lista">	
        </cfif>
    
        <cfinvoke component="SOIN_HSBC_XML" method="fnGeneraXML" returnvariable="LvarXML">
            <cfinvokeargument name="rs" value="#rsresult#">
            <cfinvokeargument name="Movimiento" value="#LvarMovimiento#">
        </cfinvoke>
        <cfreturn LvarXML>
    </cffunction>

    <!--- Clientes --->
    <cffunction name="fnGeneraClientes" access="remote" output="no" returntype="xml">
	    <cfargument name="Empresa"  				type="numeric" 	required="yes">
        <cfargument name="Conexion" 				type="string" 	required="yes">
	    <cfargument name="TipoCliente"   			type="string"  	required="no" default="-1" hint="Cedula nacional, pasaporte, cedula residencia, etc">
	    <cfargument name="IdentificacionCliente"    type="string" 	required="no" default="-1">

        <cfquery name="rsresult" datasource="#Arguments.Conexion#">
            select 
            	b.QPtipoCteCod as TipoCliente,
                a.QPcteDocumento as Identificacion, 
                a.QPcteNombre as Nombre, 
                a.QPcteDireccion as Direccion, 
                a.QPcteTelefono1 as Telefono1,
                a.QPcteTelefono2 as Telefono2,
                a.QPcteTelefonoC as TelefonoC,
                a.QPcteCorreo as Correo
            from QPcliente a
            	inner join QPtipoCliente b
                	on b.QPtipoCteid = a.QPtipoCteid
            
            where a.Ecodigo = #Arguments.Empresa#
			<cfif Arguments.TipoCliente NEQ -1>
              and b.QPtipoCteCod = '#Arguments.TipoCliente#'
            </cfif>
            <cfif Arguments.IdentificacionCliente NEQ -1>
              and a.QPcteDocumento = '#Arguments.IdentificacionCliente#'
            </cfif>
            order by b.QPtipoCteCod, a.QPcteDocumento
        </cfquery>

		<cfif Arguments.TipoCliente NEQ -1 and Arguments.IdentificacionCliente NEQ -1>
        	<cfset LvarMovimiento = "Verifica Cliente">
        <cfelseif Arguments.IdentificacionCliente NEQ -1>
        	<cfset LvarMovimiento = "Verifica Cliente">
		<cfelse>
        	<cfset LvarMovimiento = "Genera Lista Clientes">	
        </cfif>
    
        <cfinvoke component="SOIN_HSBC_XML" method="fnGeneraXML" returnvariable="LvarXML">
            <cfinvokeargument name="rs" value="#rsresult#">
            <cfinvokeargument name="Movimiento" value="#LvarMovimiento#">
        </cfinvoke>
        <cfreturn LvarXML>
    </cffunction>
    
    <!--- Cobro --->
    <cffunction name="fnGeneraCobros" access="remote" output="no" returntype="xml">
	    <cfargument name="Empresa"  				type="numeric" 	required="yes">
        <cfargument name="Conexion" 				type="string" 	required="yes">
	    <cfargument name="TipoCliente"   			type="string"  	required="no" default="-1" hint="Cedula nacional, pasaporte, cedula residencia, etc">
	    <cfargument name="IdentificacionCliente"    type="string" 	required="no" default="-1">

        <cfquery name="rsresult" datasource="#Arguments.Conexion#">
            select 
            	b.QPtipoCteCod as TipoCliente,
                a.QPcteDocumento as Identificacion, 
                a.QPcteNombre as Nombre, 
                a.QPcteDireccion as Direccion, 
                a.QPcteTelefono1 as Telefono1,
                a.QPcteTelefono2 as Telefono2,
                a.QPcteTelefonoC as TelefonoC,
                a.QPcteCorreo as Correo
            from QPcliente a
            	inner join QPtipoCliente b
                	on b.QPtipoCteid = a.QPtipoCteid
            
            where a.Ecodigo = #Arguments.Empresa#
			<cfif Arguments.TipoCliente NEQ -1>
              and b.QPtipoCteCod = '#Arguments.TipoCliente#'
            </cfif>
            <cfif Arguments.IdentificacionCliente NEQ -1>
              and a.QPcteDocumento = '#Arguments.IdentificacionCliente#'
            </cfif>
            order by b.QPtipoCteCod, a.QPcteDocumento
        </cfquery>

		<cfif Arguments.TipoCliente NEQ -1 and Arguments.IdentificacionCliente NEQ -1>
        	<cfset LvarMovimiento = "Verifica Cliente">
        <cfelseif Arguments.IdentificacionCliente NEQ -1>
        	<cfset LvarMovimiento = "Verifica Cliente">
		<cfelse>
        	<cfset LvarMovimiento = "Genera Lista Clientes">	
        </cfif>
    
        <cfinvoke component="SOIN_HSBC_XML" method="fnGeneraXML" returnvariable="LvarXML">
            <cfinvokeargument name="rs" value="#rsresult#">
            <cfinvokeargument name="Movimiento" value="#LvarMovimiento#">
        </cfinvoke>
        <cfreturn LvarXML>
    </cffunction>
    
</cfcomponent>
