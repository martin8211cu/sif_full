<cfcomponent>
	<cffunction name="AltaCuentaEmpresarial" access="public" returntype="numeric" hint="Funcion para crear Nuevas Cuentas Empresariales">
    	<cfargument name="id_direccion" type="numeric" required="no">
        <cfargument name="Mcodigo" 		type="numeric" required="no">
        <cfargument name="LOCIdioma" 	type="string"  required="yes">
        <cfargument name="CEaliaslogin" type="string"  required="yes">
        <cfargument name="CEnombre" 	type="string"  required="yes">
        <cfargument name="Pais" 		type="string"  required="no">
        <cfargument name="CEtelefono1" 	type="string"  required="yes" default="">
        <cfargument name="CEtelefono2" 	type="string"  required="yes" default="">
        <cfargument name="CEfax" 		type="string"  required="yes" default="">
        <cfargument name="CEcontrato" 	type="string"  required="yes" default="">
        <cfargument name="BMUsucodigo" 	type="numeric" required="yes" default="-1">
        <cfargument name="CElogo" 		type="any" 	   required="yes" default="">
        <cfargument name="Miso4217" 	type="string"  required="no">
        <cfargument name="Conexion" 	type="string"  required="no" default="asp">
        <cfargument name="codigo_pais" 	type="string"  required="no" >
        <cfargument name="TransaccionAtiva" 	type="boolean"  required="no" default="false" >
        
        <cfif Arguments.BMUsucodigo EQ -1 and isdefined('session.Usucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.Mcodigo') and NOT isdefined('Arguments.Miso4217')>
        	<cfthrow message="Se debe enviar el código o el ISO de la moneda de la corporación.">
        <cfelseif isdefined('Arguments.Mcodigo')>
        	<cfset Mcodigo = Arguments.Mcodigo>
        <cfelse>
        	<cfquery name="rsMonedas" datasource="#Arguments.Conexion#">
            	select min(Mcodigo) as Mcodigo 
                	from Moneda 
                where Miso4217 = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Miso4217#">
            </cfquery>
            <cfif rsMonedas.Recordcount>
            	<cfset Arguments.Mcodigo = rsMonedas.Mcodigo>
            <cfelse>
            	<cfthrow message="El ISO de la moneda enviada no existe.">
            </cfif>
        </cfif>

		<cfif Arguments.TransaccionAtiva >
           <cfset AltaCuentaEmpresarialLogica(Arguments)>
        <cfelse>
            <cftransaction>
            	 <cfset AltaCuentaEmpresarialLogica(Arguments)>
            </cftransaction>
        </cfif>
        <cfreturn rs.identity> 
     </cffunction>
     
     <cffunction name="AltaCuentaEmpresarialLogica" access="private">	
     	 <cfargument name="Arguments" 	type="any"  required="no">
     	
     	<cfif not isdefined('Arguments.codigo_pais')>
           <cfquery name="rsCodigoPais" datasource="#Arguments.Conexion#">
                select CPcodigo
                from CPais
                where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pais#">
            </cfquery>
            <cfif rsCodigoPais.RecordCount eq 0>
                <cfset Arguments.codigo_pais = '00000'>
            <cfelse>
                <cfset Arguments.codigo_pais = Mid(NumberFormat(trim(rsCodigoPais.CPcodigo),'00000'),1,5) >
            </cfif>
        </cfif>
		<cfquery name="rsCuentaOrder" datasource="#Arguments.Conexion#">
			select CEcuenta
			from CuentaEmpresarial a
			where a.CEcuenta like '#Arguments.codigo_pais#-%'
				and ({fn LENGTH({fn RTRIM(a.CEcuenta)}  )}) - 6 = 5
			order by a.CEcuenta desc
		</cfquery>	
		<cfif isdefined('rsCuentaOrder') and rsCuentaOrder.recordCount GT 0>
			<cfset varNewCuenta = "">
			<cfset concatenar = "">			
			<cfloop query="rsCuentaOrder">
				<cfset varNewCuenta = MID(Trim(rsCuentaOrder.CEcuenta),7,5) >
					<cfif Isnumeric(varNewCuenta)>
						<cfset varNewCuenta = varNewCuenta + 1>
						<cfif Len(varNewCuenta) LT 5>
							<cfset cantCeros = 5 - (Len(varNewCuenta))>
							<cfloop index = "LoopCount" from = "1" to = #cantCeros#>
								<cfset concatenar = concatenar & '0'>
							</cfloop>
						</cfif>
						<cfset varNewCuenta = Insert(concatenar,varNewCuenta,0)>
						<cfbreak>
					</cfif>
			</cfloop>
		</cfif>		
		<cfif isdefined('varNewCuenta') and varNewCuenta NEQ ''>
			<cfset code = Arguments.codigo_pais & '-' & NumberFormat(varNewCuenta,'00000')>
		<cfelse>
			<cfset code = Arguments.codigo_pais & '-00001'>
		</cfif>
        <cfif NOT isdefined('Arguments.id_direccion')>
        	<cfquery datasource="#Arguments.Conexion#" name="inserted">
                insert INTO Direcciones (
                    Ppais,BMUsucodigo, BMfechamod)
                values (
                        <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Pais#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">
                       )
                <cf_dbidentity1 verificar_transaccion="false" datasource="#Arguments.Conexion#">
            </cfquery>
            	<cf_dbidentity2 verificar_transaccion="false" datasource="#Arguments.Conexion#" name="inserted">
            <cfset id_direccion = inserted.identity>
        <cfelse>
        	<cfset id_direccion = Arguments.id_direccion>
        </cfif>
        
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert INTO CuentaEmpresarial(
            	id_direccion,Mcodigo,LOCIdioma,CEaliaslogin,CEnombre,CEcuenta,CEtelefono1,CEtelefono2,CEfax,CEcontrato,BMfecha,BMUsucodigo,CElogo)
				values ( <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#id_direccion#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.LOCIdioma#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEaliaslogin#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEnombre#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#code#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEtelefono1#" voidnull>,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEtelefono2#" voidnull>,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEfax#" 	    voidnull>,
						 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CEcontrato#"  voidnull>,
						 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
						 <cf_jdbcquery_param cfsqltype="cf_sql_blob" 		value="#Arguments.CElogo#"		voidnull>
					   )
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
			<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rs">
                
          <cfif len(trim(Arguments.CEaliaslogin))>
            <cfinvoke method="validaAlias" returnvariable="LvarLoginValido"
                   CEcodigo	= "#rs.identity#"
                   alias	= "#Arguments.CEaliaslogin#"
                   Conexion = "#Arguments.Conexion#"/>
            <cfif not LvarLoginValido>
             	<cfreturn -1>
                <cfthrow message="Error. El alias de Cuenta Empresarial seleccionado está asociado a otra cuenta.">
            </cfif>
        </cfif>	
     </cffunction>

     
      <cffunction name="getCuentaE" returntype="query">
		<cfargument name="alias" 	required="yes" type="string">
        <cfargument name="Conexion"	required="no"  type="string" default="asp">
        		
		<cfquery name="data" datasource="#Arguments.Conexion#">
			select CEcodigo,CEaliaslogin 
			from CuentaEmpresarial
			where CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.alias)#">
		</cfquery>
		<cfreturn data>
	</cffunction>
     
    <cffunction name="validaAlias" returntype="boolean" hint="Valida que el alias del acuenta sea unico">
		<cfargument name="CEcodigo" required="yes" type="numeric">
		<cfargument name="alias" 	required="yes" type="string">
        <cfargument name="Conexion"	required="no"  type="string" default="asp">
		
		<cfquery name="data" datasource="#Arguments.Conexion#">
			select CEaliaslogin 
			from CuentaEmpresarial
			where CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.alias)#">
			  and CEcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>

		<cfif data.recordCount gt 0 >
			<cfreturn false>
		<cfelse>	
			<cfreturn true>
		</cfif>
	</cffunction>
</cfcomponent>