<cfcomponent>
	<!---=========================================================================================================--->
	<cffunction name="AltaEmpleado" access="public" returntype="numeric" hint="Funcion para Crear un Nuevo Empleado">
        <cfargument name="DEidentificacion" type="string"  required="yes"  hint="Identificacion">
        <cfargument name="DEnombre" 		type="string"  required="yes"  hint="Nombre del Empleado">
        <cfargument name="Mcodigo" 			type="numeric" required="no"  hint="Codigo de la Moneda">
        <cfargument name="CBcc" 			type="string"  required="yes"  hint="Cuenta Cliente">
        <cfargument name="NTIcodigo" 		type="string"  required="no" default="G" 	   hint="Tipo de Indentificacion">
        <cfargument name="DEapellido1"		type="string"  required="no" default=""  	   hint="Primer Apellido del Empleado">
        <cfargument name="DEapellido2" 		type="string"  required="no" default=""  	   hint="Segundo Apellido del Empleado">
        <cfargument name="DEdireccion" 		type="string"  required="no" default="" 	   hint="Direccion">
        <cfargument name="DEtelefono1" 		type="string"  required="no" default="" 	   hint="Telefono 1">
        <cfargument name="DEtelefono2" 		type="string"  required="no" default="" 	   hint="Telefono 2">
        <cfargument name="DEemail" 			type="string"  required="no" default="" 	   hint="Correo Eletronico">
        <cfargument name="DEcivil" 			type="numeric" required="no" default="0" 	   hint="Estado Civil (0 = Soltero)">
        <cfargument name="DEfechanac" 		type="date"    required="no" default="#now()#" hint="Fecha de Nacimiento">
       	<cfargument name="DEsexo" 			type="string"  required="no" default="M" 	   hint="Genero">
        <cfargument name="DEobs1" 			type="string"  required="no" default="" 	   hint="Observación 1">
        <cfargument name="DEobs2" 			type="string"  required="no" default="" 	   hint="Observación 2">
        <cfargument name="DEobs3" 			type="string"  required="no" default="" 	   hint="Observación 3">
        <cfargument name="DEobs4" 			type="string"  required="no" default="" 	   hint="Observación 4">
        <cfargument name="DEobs5" 			type="string"  required="no" default="" 	   hint="Observación 5">
        <cfargument name="DEdato1" 			type="string"  required="no" default="" 	   hint="Dato Variable 1">
        <cfargument name="DEdato2" 			type="string"  required="no" default="" 	   hint="Dato Variable 2">
        <cfargument name="DEdato3" 			type="string"  required="no" default="" 	   hint="Dato Variable 3">
        <cfargument name="DEdato4" 			type="string"  required="no" default="" 	   hint="Dato Variable 4">
        <cfargument name="DEdato5" 			type="string"  required="no" default=""	 	   hint="Dato Variable 5">
        <cfargument name="DEdato6" 			type="string"  required="no" default="" 	   hint="Dato Variable 4">
        <cfargument name="DEdato7" 			type="string"  required="no" default="" 	   hint="Dato Variable 5">
        <cfargument name="DEinfo1" 			type="string"  required="no" default="" 	   hint="Información 1">
        <cfargument name="DEinfo2" 			type="string"  required="no" default="" 	   hint="Información 2">
        <cfargument name="DEinfo3" 			type="string"  required="no" default="" 	   hint="Información 3">
        <cfargument name="DEinfo4" 			type="string"  required="no" default="" 	   hint="Información 4">
        <cfargument name="DEinfo5" 			type="string"  required="no" default=""	 	   hint="Información 5">
        <cfargument name="Bid" 				type="numeric" required="no" default="-1"	   hint="Banco">
        <cfargument name="DEtarjeta" 		type="string"  required="no" default=""	       hint="Tarjeta">
        <cfargument name="DEpassword" 		type="string"  required="no" default=""	       hint="Contraseña">
        <cfargument name="Ppais" 			type="string"  required="no" default=""	       hint="Pais">
        <cfargument name="CBTcodigo" 		type="numeric" required="no" default="0"	   hint="Tipo de Cuenta">
        <cfargument name="DEcuenta" 		type="string"  required="no" default=""	       hint="Cuenta">
        <cfargument name="DEporcAnticipo" 	type="numeric" required="no" default="0"	   hint="Porcentaje de Anticipo">
        <cfargument name="RFC" 				type="string"  required="no" default=""	       hint="Registro Federal de Contribuyentes(Mexico)">
        <cfargument name="CURP" 			type="string"  required="no" default=""	       hint="Clave Única de Registro de Población(Mexico)">
        <cfargument name="ZEid" 			type="numeric" required="no" default="-1"	   hint="Zona Economica">
        <cfargument name="DEsdi" 			type="numeric" required="no" default="-1"	   hint="Salario Diario Integrado(Mexico)">
        <cfargument name="conexion" 		type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="Ecodigo" 			type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="UsuCodigo"		type="numeric" required="no" hint="Usuario del Portal">
        <cfargument name="Ulocalizacion"	type="numeric" required="no" hint="Localización">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        	<cfset Arguments.UsuCodigo = session.UsuCodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" returnvariable="vUsaIDautomatico"
			      Ecodigo="#Arguments.Ecodigo#" Pvalor="2045" default="0"/>
        <cfif vUsaIDautomatico NEQ 0>
        	<cfset Arguments.NTIcodigo = 'G'>
        </cfif>
        
        <cfinvoke method="VerificarExistenciaEmpleado">
             <cfinvokeargument name="NTIcodigo"	 	   value="#Arguments.NTIcodigo#">
             <cfinvokeargument name="DEidentificacion" value="#Arguments.DEidentificacion#">
        </cfinvoke>
        <cfif NOT ISDEFINED('Arguments.Mcodigo')>
            <cfquery name="rsEmpresa" datasource="#Arguments.conexion#">
                select Mcodigo from Empresas where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Arguments.Ecodigo#">
            </cfquery>
            <cfset Arguments.Mcodigo = rsEmpresa.Mcodigo>
        </cfif>

		<cfquery name="ABC_datosEmpl" datasource="#Arguments.conexion#">
				insert into DatosEmpleado (
					Ecodigo, 		NTIcodigo, 		DEidentificacion,	DEnombre, 	
					DEapellido1, 	DEapellido2,	Mcodigo, 			CBcc, 
					DEdireccion,	DEtelefono1,	DEtelefono2,		DEemail,
					DEcivil, 		DEfechanac,		DEsexo, 			DEobs1, 
					DEobs2, 		DEobs3, 		DEobs4, 			DEobs5,
					DEdato1, 		DEdato2, 		DEdato3, 			DEdato4, 	
					DEdato5, 		DEdato6, 		DEdato7, 			DEinfo1, 
					DEinfo2, 		DEinfo3, 		DEinfo4, 			DEinfo5, 
					Usucodigo,		Ulocalizacion,	Bid, 				DEtarjeta,
					DEpassword,     Ppais,			CBTcodigo, 		    DEcuenta,			
                    DEporcAnticipo, DESeguroSocial, ZEid, 				DEsdi, 
                    RFC, CURP)
				values (
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.NTIcodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEidentificacion#">,
     				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEnombre#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEapellido1#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEapellido2#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Mcodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CBcc#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEdireccion#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEtelefono1#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEtelefono2#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DEemail#" 	 voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#Arguments.DEcivil#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.DEfechanac#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEsexo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.DEobs1#"  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEobs2#"  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEobs3#"  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEobs4#"  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEobs5#"  voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato1#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato2#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato3#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato4#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato5#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato6#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEdato7#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEinfo1#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEinfo2#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEinfo3#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEinfo4#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	 value="#Arguments.DEinfo5#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Ulocalizacion#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.Bid#" 		      voidnull null="#Arguments.Bid EQ -1#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.DEtarjeta#" 	      voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#hash(Arguments.DEpassword)#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Ppais#" 			  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.CBTcodigo#" 		  voidnull>,	
					<cf_jdbcquery_param cfsqltype="cf_sql_char" 	 value="#Arguments.DEcuenta#" 		  voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.DEporcAnticipo#"   voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Replace(Arguments.DEidentificacion,'-','','ALL')#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.ZEid#"  null="#Arguments.ZEid EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_money" 	 value="#Arguments.DEsdi#" null="#Arguments.DEsdi EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.RFC#"  voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CURP#" voidnull>
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_datosEmpl">
		<cfreturn ABC_datosEmpl.identity>
	</cffunction>
<!---=========================================================================================================--->
    <cffunction name="VerificarExistenciaEmpleado" access="public" hint="Verifica si existe el empleado en la empresa actual o en la corporacion">
        <cfargument name="DEidentificacion" type="string"  required="yes" hint="Identificacion">
        <cfargument name="NTIcodigo" 		type="string"  required="no"  hint="Tipo de Indentificacion" default="G">
        <cfargument name="conexion" 		type="string"  required="no"  hint="Nombre del DataSource">
        <cfargument name="Ecodigo" 			type="numeric" required="no"  hint="Codigo de la Empresa">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

    	<cfif Session.cache_empresarial EQ 0>
			<cfquery name="rsExisteEmpleado" datasource="#Arguments.conexion#">
				select 1 from DatosEmpleado a
				  where a.NTIcodigo 	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NTIcodigo#">
					and a.DEidentificacion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DEidentificacion#">
					and a.Ecodigo           = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="rsEmpresaEmpleado" datasource="asp">
				select distinct c.Ereferencia
				from Empresa b
                	inner join Empresa c
                    	on c.CEcodigo = b.CEcodigo
				where b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfquery name="rsExisteEmpleado" datasource="#Arguments.conexion#">
				select 1 from DatosEmpleado
				  where NTIcodigo 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NTIcodigo#">
					and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DEidentificacion#">
				  <cfif rsEmpresaEmpleado.recordCount GT 0>
					and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" separator="," value="#ValueList(rsEmpresaEmpleado.Ereferencia, ',')#">)
				  <cfelse>
					and Ecodigo = 0
				  </cfif>
			</cfquery>
		</cfif>
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_ElEmpleadoYaExiste"
				Key="MSG_ElEmpleadoYaExiste"
				Default="El Empleado ya existe"/>
			    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEmpleadoYaExiste#." addtoken="no">
			   <cfabort> 
		</cfif>
	</cffunction>
<!---=========================================================================================================--->
    <cffunction name="AltaEmpleadosTipo" access="public" hint="Funcion para crear nuevos Tipos de Empleados">
        <cfargument name="DEid"  		type="numeric"  required="yes" hint="Id del Empleado">
        <cfargument name="TEid"  		type="numeric"  required="no"  hint="TEid">
        <cfargument name="ETNumConces"  type="numeric"  required="no"  hint="ETNumConces">
        <cfargument name="conexion" 	type="string"   required="no"  hint="Nombre del DataSource">
        <cfargument name="Ecodigo" 		type="numeric"  required="no"  hint="Codigo de la Empresa">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfquery name="ABC_empleadosTipo" datasource="#Arguments.conexion#">
             insert into EmpleadosTipo(DEid, TEid, ETNumConces)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TEid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ETNumConces#">
                )
		</cfquery>
    </cffunction>
<!---=========================================================================================================--->
	<cffunction name="AltaEmpleadoPortal" access="public" returntype="numeric" hint="Funcion para Crear un Nuevo Empleado en el framwork de seguridad">
        <cfargument name="Pid" 				type="string"  required="yes"  hint="Identificacion">
        <cfargument name="Pnombre" 			type="string"  required="yes"  hint="Nombre del Empleado">
        <cfargument name="Papellido1"		type="string"  required="no" default=""  	   hint="Primer Apellido del Empleado">
        <cfargument name="Papellido2" 		type="string"  required="no" default=""  	   hint="Segundo Apellido del Empleado">
        <cfargument name="Pnacimiento" 		type="any"     required="no" default="" 		hint="Fecha de Nacimiento">
        <cfargument name="Psexo" 			type="string"  required="no" default="M" 	   hint="Genero">
        <cfargument name="Pcasa" 			type="string"  required="no" default="" 	   hint="Telefono 1">
        <cfargument name="Pcelular" 		type="string"  required="no" default="" 	   hint="Telefono 2">
        <cfargument name="Pemail1" 			type="string"  required="no" default="" 	   hint="Correo Eletronico">
        <cfargument name="UsuCodigo"		type="numeric" required="no" hint="Usuario del Portal">
       
        <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        	<cfset Arguments.UsuCodigo = session.UsuCodigo>
        </cfif>
       	 
   		<cfquery datasource="asp" name="DPinserted">
			insert into DatosPersonales (Pid, Pnombre, Papellido1, Papellido2, Pnacimiento, Psexo, Pcasa, Pcelular, Pemail1, BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pnombre#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Papellido1#"   voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.Papellido2#"   voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Pnacimiento#"  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Psexo#" 		  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.Pcasa#" 		  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Pcelular#" 	  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Pemail1#" 	  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#session.UsuCodigo#" 	  voidnull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="DPinserted">
        <cfreturn DPinserted.identity>
     </cffunction>
<!---===========================================================================--->     
<cffunction name="AltaDireccionPortal" access="public" returntype="numeric" hint="Funcion para la Direccion en el framework de seguridad">
    <cfargument name="atencion"			type="string"  required="yes"   default=""  hint="Atencion">
    <cfargument name="direccion1" 		type="string"  required="yes"   default=""  hint="Dirección 1">
    <cfargument name="Ppais"			type="numeric" required="no"   hint="Codigo Pais">
    <cfargument name="CEcodigo"			type="numeric" required="no"   hint="Codigo de Corporación">
    <cfargument name="UsuCodigo"		type="numeric" required="no"   hint="Usuario del Portal">
       
	<cfif not isdefined('Arguments.CEcodigo') and isdefined('session.CEcodigo')>
        <cfset Arguments.CEcodigo = session.CEcodigo>
    </cfif>
    <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        <cfset Arguments.UsuCodigo = session.UsuCodigo>
    </cfif>
    <cfif NOT ISDEFINED('Arguments.Ppais')>
        <cfquery name="rsDatosCuenta" datasource="asp">
            select b.Ppais
              from CuentaEmpresarial a
                inner join Direcciones b
                    on b.id_direccion = a.id_direccion
            where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
        </cfquery>
        <cfset Arguments.Ppais = rsDatosCuenta.Ppais>
   </cfif>
    
    <cfquery datasource="asp" name="Dinserted">
        insert into Direcciones (atencion, direccion1, Ppais, BMUsucodigo, BMfechamod)
        values (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.atencion#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.direccion1#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppais#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
        )
        <cf_dbidentity1 datasource="asp">
    </cfquery>
    <cf_dbidentity2 datasource="asp" name="Dinserted">
     <cfreturn Dinserted.identity>
 </cffunction>
<!---===================================================================================--->
 <cffunction name="GetEmpleado" access="public" hint="Funcion para obtener los datos de un Empleado" returntype="query">
        <cfargument name="DEid"  		type="numeric" required="no" hint="Id del Empleado">
        <cfargument name="Tcodigo"  	type="string"  required="no" hint="Id del Empleado">
        <cfargument name="Estado"  		type="string"  required="no" hint="Obenter empleado activos y/o inactivos" default="0,1">
        <cfargument name="conexion" 	type="string"  required="no" hint="Nombre del DataSource">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        	<cf_dbfunction name="OP_concat" datasource="#Arguments.conexion#" returnvariable="_Cat">

        <cfquery name="rs_datosEmpl" datasource="#Arguments.conexion#">
			<!---Empleados Activos a la fecha--->
            <cfif ListFind(Arguments.Estado,'1')>
            select  a.Ecodigo, 			a.NTIcodigo, 		a.DEidentificacion,	a.DEnombre, 	
					a.DEapellido1, 		a.DEapellido2,		a.Mcodigo, 			a.CBcc, 
					a.DEdireccion,		a.DEtelefono1,	    a.DEtelefono2,		a.DEemail,
					a.DEcivil, 			a.DEfechanac,		a.DEsexo, 			a.DEsdi,
					a.Usucodigo,		a.Ulocalizacion,	a.Bid, 				a.DEtarjeta,
					a.DEpassword,    	a.Ppais,			a.CBTcodigo, 		a.DEcuenta,			
                    a.DEporcAnticipo, 	a.DESeguroSocial, 	a.ZEid, 			c.CFid,
                    b.Ocodigo, 			b.Dcodigo, 			b.RHPcodigo, 		b.RHJid,
                    b.Tcodigo,			a.DEid, 			a.RFC, 				a.CURP,
                    a.DEnombre #_Cat# ' ' #_Cat# a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 as NombreCompleto,
                    Case a.DEcivil 
                    when 0 then 'Soltero(a)' 
                    when 1 then 'Casado(a)' 
                    when 2 then 'Divorciado(a)' 
                    when 3 then 'Viudo(a)' 
                    when 4 then 'Union Libre'
                    when 5 then 'Separado(a)' 
                    else '' end as DEcivilLabel,
                    case a.DEsexo when 'M' then 'Masculino' else 'Femenino' end as LabelDEsexo,
                    (select Pnombre from Pais where Ppais = a.Ppais) Nacionalidad,
                    1 as Activo, b.RVid
                from DatosEmpleado a
                	inner join LineaTiempo b
                        inner join RHPlazas c
                            on c.RHPid = b.RHPid
                        on b.DEid = a.DEid
                        and <cf_dbfunction name="today">  between LTdesde and LThasta
            		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    <cfif isdefined('Arguments.DEid')>
                    	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    </cfif>
                    <cfif isdefined('Arguments.Tcodigo')>
                      and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Tcodigo#">
                    </cfif>
          	</cfif>   
            <cfif Listlen(Arguments.Estado) eq 2>
            union
            </cfif>
            <cfif ListFind(Arguments.Estado,'1')>
            <!---Empleados Inactivos, Nombrados--->
            select  a.Ecodigo, 			a.NTIcodigo, 		a.DEidentificacion,	a.DEnombre, 	
					a.DEapellido1, 		a.DEapellido2,		a.Mcodigo, 			a.CBcc, 
					a.DEdireccion,		a.DEtelefono1,		a.DEtelefono2,		a.DEemail,
					a.DEcivil, 			a.DEfechanac,		a.DEsexo, 			a.DEsdi,
					a.Usucodigo,		a.Ulocalizacion,	a.Bid, 				a.DEtarjeta,
					a.DEpassword,    	a.Ppais,			a.CBTcodigo, 		a.DEcuenta,			
                    a.DEporcAnticipo, 	a.DESeguroSocial, 	a.ZEid,				c.CFid,
                    b.Ocodigo, 			b.Dcodigo, 			b.RHPcodigo, 		b.RHJid,
                    b.Tcodigo,			a.DEid,				a.RFC, 				a.CURP,
                   a.DEnombre #_Cat# ' ' #_Cat# a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 as NombreCompleto,
                   Case a.DEcivil 
                    when 0 then 'Soltero(a)' 
                    when 1 then 'Casado(a)' 
                    when 2 then 'Divorciado(a)' 
                    when 3 then 'Viudo(a)' 
                    when 4 then 'Union Libre'
                    when 5 then 'Separado(a)' 
                    else '' end as DEcivilLabel,
                    case a.DEsexo when 'M' then 'Masculino' else 'Femenino' end as LabelDEsexo,
                   (select Pnombre from Pais where Ppais = a.Ppais) Nacionalidad,
					0 as Activo, b.RVid
                from DatosEmpleado a
                	inner join LineaTiempo b
                        inner join RHPlazas c
                            on c.RHPid = b.RHPid
                        on b.DEid = a.DEid
                        and LThasta = (select Max(LThasta) from LineaTiempo where DEid = a.DEid)
                where (select count(1) from LineaTiempo where DEid = a.DEid and <cf_dbfunction name="today"> between LTdesde and LThasta) = 0
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    <cfif isdefined('Arguments.DEid')>
                    	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    </cfif>
                    <cfif isdefined('Arguments.Tcodigo')>
                      and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Tcodigo#">
                    </cfif>
           		</cfif>
            <!---Empleados Inactivos no Nombrados--->
        </cfquery>
        <cfreturn rs_datosEmpl>
  </cffunction>
<!---=========================================================================================================--->
	<cffunction name="CambioEmpleadoRemote" access="remote" hint="Funcion para Modificar un Empleado">
    	<cfargument name="DEid" 	type="numeric" required="yes" hint="Id del Empleado">
        <cfargument name="DEemail" 	type="string"  required="no"  hint="Correo Eletronico">
    	<cfinvoke method="CambioEmpleado">
        	<cfinvokeargument name="DEid"    value="#Arguments.DEid#">
            <cfinvokeargument name="DEemail" value="#Arguments.DEemail#">
        </cfinvoke>
    </cffunction>
    
	<cffunction name="CambioEmpleado" access="public" returntype="numeric" hint="Funcion para Modificar un Empleado">
        <cfargument name="DEid" 			type="numeric" required="yes" hint="Id del Empleado">
        <cfargument name="DEemail" 			type="string"  required="no"  hint="Correo Eletronico">
        <cfargument name="DEtelefono1" 		type="string"  required="no"  hint="Telefono 1">
        <cfargument name="DESeguroSocial"	type="string"  required="no"  hint="Seguro Social">
        <cfargument name="DEtelefono2" 		type="string"  required="no" hint="Telefono 2">
		<cfargument name="DEfechanac" 		type="date"    required="no" hint="Fecha de Nacimiento">
        <cfargument name="DEidentificacion" type="string"  required="no" hint="Identificacion">
        <cfargument name="DEnombre" 		type="string"  required="no" hint="Nombre del Empleado">
        <cfargument name="Mcodigo" 			type="numeric" required="no" hint="Codigo de la Moneda">
        <cfargument name="CBcc" 			type="string"  required="no" hint="Cuenta Cliente">
        <cfargument name="NTIcodigo" 		type="string"  required="no" hint="Tipo de Indentificacion">
        <cfargument name="DEapellido1"		type="string"  required="no" hint="Primer Apellido del Empleado">
        <cfargument name="DEapellido2" 		type="string"  required="no" hint="Segundo Apellido del Empleado">
        <cfargument name="DEdireccion" 		type="string"  required="no" hint="Direccion">
        <cfargument name="DEcivil" 			type="numeric" required="no" hint="Estado Civil (0 = Soltero)">
        <cfargument name="CBTcodigo" 		type="numeric" required="no" hint="Tipo de Cuenta">
        <cfargument name="Bid" 				type="numeric" required="no" hint="Banco">
        <cfargument name="DEsdi" 			type="numeric" required="no" hint="Salario Diario Integrado(Mexico)">
        <cfargument name="DEtarjeta" 		type="string"  required="no" hint="Tarjeta">
        <cfargument name="DEsexo" 			type="string"  required="no" hint="Genero">
        <cfargument name="RFC" 				type="string"  required="no" hint="Registro Federal de Contribuyentes(Mexico)">
        <cfargument name="CURP" 			type="string"  required="no" hint="Clave Única de Registro de Población(Mexico)">
       	 
        <cfargument name="DEobs1" 			type="string"  required="no" hint="Observación 1">
        <cfargument name="DEobs2" 			type="string"  required="no" hint="Observación 2">
        <cfargument name="DEobs3" 			type="string"  required="no" hint="Observación 3">
        <cfargument name="DEobs4" 			type="string"  required="no" hint="Observación 4">
        <cfargument name="DEobs5" 			type="string"  required="no" hint="Observación 5">
        <cfargument name="DEdato1" 			type="string"  required="no" hint="Dato Variable 1">
        <cfargument name="DEdato2" 			type="string"  required="no" hint="Dato Variable 2">
        <cfargument name="DEdato3" 			type="string"  required="no" hint="Dato Variable 3">
        <cfargument name="DEdato4" 			type="string"  required="no" hint="Dato Variable 4">
        <cfargument name="DEdato5" 			type="string"  required="no" hint="Dato Variable 5">
        <cfargument name="DEdato6" 			type="string"  required="no" hint="Dato Variable 4">
        <cfargument name="DEdato7" 			type="string"  required="no" hint="Dato Variable 5">
        <cfargument name="DEinfo1" 			type="string"  required="no" hint="Información 1">
        <cfargument name="DEinfo2" 			type="string"  required="no" hint="Información 2">
        <cfargument name="DEinfo3" 			type="string"  required="no" hint="Información 3">
        <cfargument name="DEinfo4" 			type="string"  required="no" hint="Información 4">
        <cfargument name="DEinfo5" 			type="string"  required="no" hint="Información 5">
       
        
        <cfargument name="DEpassword" 		type="string"  required="no" hint="Contraseña">
        <cfargument name="Ppais" 			type="string"  required="no" hint="Pais">
       
        <cfargument name="DEcuenta" 		type="string"  required="no" hint="Cuenta">
        <cfargument name="DEporcAnticipo" 	type="numeric" required="no" hint="Porcentaje de Anticipo" default="-1">
        
        <cfargument name="ZEid" 			type="numeric" required="no" hint="Zona Economica">
        
        <cfargument name="conexion" 		type="string"  required="no" hint="Nombre del DataSource">        
        <cfargument name="Ecodigo" 			type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="UsuCodigo"		type="numeric" required="no" hint="Usuario del Portal">
        <cfargument name="Ulocalizacion"	type="numeric" required="no" hint="Localización">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        	<cfset Arguments.UsuCodigo = session.UsuCodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        
		<cfquery name="ABC_datosEmpl" datasource="#Arguments.conexion#">
				Update DatosEmpleado
                 	set Usucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">
                    <cfif isdefined('Arguments.DEemail')>
                    	,DEemail = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEemail#">
                    </cfif>
                     <cfif isdefined('Arguments.DEnombre')>
                    	,DEnombre = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEnombre#">
                    </cfif>
                     <cfif isdefined('Arguments.DEapellido1')>
                    	,DEapellido1 = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEapellido1#">
                    </cfif>
                     <cfif isdefined('Arguments.DEapellido2')>
                    	,DEapellido2 = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEapellido2#">
                    </cfif>
                    <cfif isdefined('Arguments.DESeguroSocial')>
                    	,DESeguroSocial = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DESeguroSocial#">
                    </cfif>
                    <cfif isdefined('Arguments.DEtelefono1')>
                    	,DEtelefono1 = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEtelefono1#">
                    </cfif>
                    <cfif isdefined('Arguments.DEtelefono2')>
                    	,DEtelefono2 = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEtelefono2#">
                    </cfif>
                    <cfif isdefined('Arguments.Ppais')>
                    	,Ppais = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
                    </cfif>
                    <cfif isdefined('Arguments.DEcivil')>
                    	,DEcivil = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DEcivil#">
                    </cfif>
                    <cfif isdefined('Arguments.DEfechanac')>
                    	,DEfechanac = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.DEfechanac#">
                    </cfif>
                    <cfif isdefined('Arguments.DEsexo')>
                    	,DEsexo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEsexo#">
                    </cfif>
                    <cfif isdefined('Arguments.Bid')>
                    	,Bid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Bid#" voidnull null="#Arguments.Bid EQ -1#">
                    </cfif>
                    <cfif isdefined('Arguments.CBTcodigo')>
                    	,CBTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CBTcodigo#" voidnull>
                    </cfif>
                    <cfif isdefined('Arguments.CBcc')>
                    	,CBcc = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.CBcc#">
                    </cfif>
                    <cfif isdefined('Arguments.DEcuenta')>
                    	,DEcuenta = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.DEcuenta#" voidnull>
                    </cfif>
                    <cfif isdefined('Arguments.DEsdi')>
                    	,DEsdi = <cf_jdbcquery_param cfsqltype="cf_sql_money" 	 value="#Arguments.DEsdi#" null="#Arguments.DEsdi EQ -1#">
                    </cfif>
                    <cfif isdefined('Arguments.DEtarjeta')>
                    	,DEtarjeta =  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DEtarjeta#" voidnull>
                    </cfif>
                    <cfif isdefined('Arguments.DEpassword')>
                    	,DEpassword = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#hash(Arguments.DEpassword)#" voidnull> 
                    </cfif>
                    <cfif isdefined('Arguments.RFC')>
                    	,RFC = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.RFC#" voidnull> 
                    </cfif>
                    <cfif isdefined('Arguments.CURP')>
                    	,CURP = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.CURP#" voidnull> 
                    </cfif>
                    <cfif isdefined('Arguments.DEporcAnticipo')>
                    	,DEporcAnticipo = <cf_jdbcquery_param cfsqltype="cf_sql_money" 	 value="#Arguments.DEporcAnticipo#" null="#Arguments.DEporcAnticipo EQ -1#">
                    </cfif>
                    <cfif isdefined('Arguments.DEdireccion')>
                    	,DEdireccion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.DEdireccion#" voidnull>
                    </cfif>
                                       
                where DEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.DEid#">
			</cfquery>
		<cfreturn Arguments.DEid>
	</cffunction>
    <!--- Funciones para Dirección del Empleado --->
    <!--- Funcion para ingresar direccion del empleado--->
    <cffunction name="fnAltaDireccion" access="public" returntype="numeric" hint="Funcion para la Direccion">
        <cfargument name="DEid"				type="numeric"  required="yes">
        <cfargument name="DGid" 			type="numeric"  required="no">
        <cfargument name="DIEMdestalles"	type="string" 	required="yes">
        <cfargument name="DIEMapartado"		type="string" 	required="yes">
        <cfargument name="DIEMtipo"			type="numeric" 	required="yes">
        <cfargument name="Usuario"			type="numeric" 	required="no">
        <cfargument name="Ecodigo"			type="numeric" 	required="no">
        <cfargument name="Conexion"			type="numeric" 	required="no">
           
        <cfif not isdefined('Arguments.Usuario')>
            <cfset Arguments.Usuario = session.usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = session.ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsDireccion" datasource="#Arguments.Conexion#">
			insert into DEmpleado(DEid,DGid,DIEMdestalles,DIEMapartado,DIEMtipo,Ecodigo,BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
				<cfif isdefined('Arguments.DGid')><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#"><cfelse>null></cfif>,
			  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DIEMdestalles#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DIEMapartado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DIEMtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">)
        <cf_dbidentity1>
       	</cfquery>  
      	<cf_dbidentity2 name="rsDireccion">
        <cfreturn rsDireccion.identity>
     </cffunction>
     
     <!--- Funcion para ingresar direccion del empleado--->
     <cffunction name="fnCambioDireccion" access="public" returntype="numeric" hint="Funcion para la Direccion">
        <cfargument name="DIEMid"			type="numeric"  required="yes">
        <cfargument name="DGid" 			type="numeric"  required="no">
        <cfargument name="DIEMdestalles"	type="string" 	required="yes">
        <cfargument name="DIEMapartado"		type="string" 	required="yes">
        <cfargument name="Usuario"			type="numeric" 	required="no">
        <cfargument name="Ecodigo"			type="numeric" 	required="no">
        <cfargument name="Conexion"			type="numeric" 	required="no">
           
        <cfif not isdefined('Arguments.Usuario')>
            <cfset Arguments.Usuario = session.usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = session.ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery datasource="#Session.DSN#">
			update DEmpleado set 
				DGid 		  = <cfif isdefined('Arguments.DGid')><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#"><cfelse>null></cfif>,
				DIEMdestalles = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DIEMdestalles#">,
				DIEMapartado  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DIEMapartado#">,
				Ecodigo		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			where DIEMid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DIEMid#">
		</cfquery>
        
     	<cfreturn Arguments.DIEMid>
     </cffunction>
     
     <cffunction name="fnEstaCesado" access="public" returntype="boolean">
        <cfargument name="DEid"	 type="numeric"  required="yes">
        <cfargument name="Conexion" type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        <cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfset lvarCesado = false>
        <cfquery name="rsCese" datasource="#Arguments.Conexion#">
            select DLfechaaplic, DLfvigencia, coalesce(DLffin,'61000101') as DLffin
            from DLaboralesEmpleado dle
                inner join RHTipoAccion ta
                    on ta.RHTid = dle.RHTid
                inner join RHLiquidacionPersonal lp
                        on lp.DLlinea = dle.DLlinea and lp.RHLPestado = 0
            where dle.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and ta.RHTcomportam = 2
                and dle.DLfvigencia = (select max(dle2.DLfvigencia)
                                    from DLaboralesEmpleado dle2
                                        inner join RHTipoAccion ta2
                                            on ta2.RHTid = dle2.RHTid
                                    where dle2.DEid = dle.DEid
                                      and ta2.RHTcomportam = ta.RHTcomportam)
            order by DLfechaaplic  asc
        </cfquery>
    	<cfif rsCese.recordcount gt 0>
        	<cfset lvarCesado = true>
        </cfif>
        <cfreturn lvarCesado>
     </cffunction>
     
     <cffunction name="fnGetLiquidacion" access="public" returntype="query">
        <cfargument name="DEid"	 		type="numeric"  required="yes">
        <cfargument name="RHLPestado"	type="string"   required="no" default="0">
        <cfargument name="Conexion"		type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsCese" datasource="#Arguments.Conexion#">
            select DLfechaaplic, DLfvigencia, coalesce(DLffin,'61000101') as DLffin
            from DLaboralesEmpleado dle
                inner join RHTipoAccion ta
                    on ta.RHTid = dle.RHTid
                inner join RHLiquidacionPersonal lp
                        on lp.DLlinea = dle.DLlinea and lp.RHLPestado = 0
            where dle.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and ta.RHTcomportam = 2
                and dle.DLfvigencia = (select max(dle2.DLfvigencia)
                                    from DLaboralesEmpleado dle2
                                        inner join RHTipoAccion ta2
                                            on ta2.RHTid = dle2.RHTid
                                    where dle2.DEid = dle.DEid
                                      and ta2.RHTcomportam = ta.RHTcomportam)
            order by DLfechaaplic  asc
       	</cfquery>
        <cfquery name="rsLiq" datasource="#Arguments.Conexion#">
            select lp.DLlinea, ta.RHTdesc, dle.DLobs, dle.DLfvigencia, coalesce(lp.RHLPrenta, 0) as renta
            from RHLiquidacionPersonal lp
                inner join DLaboralesEmpleado dle
                    on dle.DLlinea = lp.DLlinea
                inner join RHTipoAccion ta
                    on ta.RHTid = dle.RHTid
            where lp.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and ta.RHTcomportam = 2
              <cfif rsCese.recordcount gt 0>
              and dle.DLfechaaplic >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCese.DLfechaaplic#">
              and dle.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCese.DLfvigencia#"> 
                                      and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCese.DLffin#">
              and lp.RHLPestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLPestado#" list="yes">)
              <cfelse>
              	and 1=2
              </cfif>
              and lp.Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfreturn rsLiq>
	</cffunction>
    
    <cffunction name="fnExisteLineaTiempo" access="public" returntype="boolean">
        <cfargument name="DEid"	 	type="numeric"  required="yes">
        <cfargument name="LTdesde" 	type="date"     required="yes">
        <cfargument name="LThasta" 	type="date"     required="no">
        <cfargument name="Conexion" type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsLT" datasource="#Arguments.Conexion#">
            select 1
            from LineaTiempo
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            <cfif isdefined('Arguments.Fecha2')>
              and(
              	LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LThasta#">
                or LThasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LThasta#">
                or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#"> between LTdesde and LThasta
                or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LThasta#"> between LTdesde and LThasta
         	  )
            <cfelse>
            	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#"> between LTdesde and LThasta
           	</cfif>
       	</cfquery>
        <cfreturn rsLT.recordcount gt 0>
	</cffunction>
    
    <cffunction name="fnAccionNoRetroactivas" access="public" returntype="query">
        <cfargument name="DEid"	 	type="numeric"  required="yes">
        <cfargument name="RHTid"	type="numeric"  required="yes">
        <cfargument name="LThasta" 	type="date"     required="yes">
        <cfargument name="Conexion" type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
       <cfquery name="rsAccion" datasource="#Arguments.conexion#">
            select ta.RHTdesc, dle.DLfvigencia, dle.DLffin
            from RHSaldoPagosExceso spe
            	inner join DLaboralesEmpleado dle
                	on dle.DEid = spe.DEid and dle.DLlinea = spe.DLlinea
               	inner join RHTipoAccion ta
                	on ta.RHTid = spe.RHTid
            where spe.RHSPEid = (
                                select min(pe.RHSPEid) 
                                from RHSaldoPagosExceso pe 
                                where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                                  and pe.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTid#">
                                  and spe.RHSPEanulado != 1 
                                  and pe.RHSPEfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LThasta#">
            	)
            and spe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        <cfreturn rsAccion>
	</cffunction>
                
    <cffunction name="fnHistoricoLT" access="public" returntype="query">
        <cfargument name="DEid"	 	type="numeric"  required="yes">
        <cfargument name="LTdesde" 	type="date"     required="yes">
        <cfargument name="DLffin" 	type="date"     required="no">
        <cfargument name="Ecodigo"  type="numeric"  required="no">
        <cfargument name="Conexion" type="string"   required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsAcciones" datasource="#Session.DSN#">
        	select distinct lt.LTid, lt.LTdesde, lt.LThasta, dle.DLvdisf, ta.RHTdesc, ta.RHTcomportam, max(dle.DLlinea) as DLlinea
            from LineaTiempo lt
                 inner join DLaboralesEmpleado dle
                    on lt.DEid = dle.DEid and lt.Ecodigo = dle.Ecodigo and lt.RHTid = dle.RHTid
                      and (dle.DLfvigencia >= lt.LTdesde or lt.LTdesde between dle.DLfvigencia and dle.DLffin)  
                 inner join RHTipoAccion ta
                    on ta.Ecodigo = dle.Ecodigo and ta.RHTid = dle.RHTid
            where lt.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and (lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#">
			  <cfif isdefined("Arguments.DLffin") and Len(Trim(Arguments.DLffin)) NEQ 0>
                and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.DLffin#"> 
              </cfif>)
            group by lt.LTid, lt.LTdesde, lt.LThasta, dle.DLvdisf, ta.RHTdesc, ta.RHTcomportam
            union
            select distinct lt.LTid, lt.LTdesde, lt.LThasta, dle.DLvdisf, ta.RHTdesc, ta.RHTcomportam, max(dle.DLlinea) as DLlinea
            from LineaTiempo lt
                 inner join DLaboralesEmpleado dle
                    on lt.DEid = dle.DEid and lt.Ecodigo = dle.Ecodigo and lt.RHTid = dle.RHTid
                      and (dle.DLfvigencia >= lt.LTdesde or lt.LTdesde between dle.DLfvigencia and dle.DLffin)  
                 inner join RHTipoAccion ta
                    on ta.Ecodigo = dle.Ecodigo and ta.RHTid = dle.RHTid
            where lt.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and (lt.LThasta	>= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTdesde#">
              <cfif isdefined("Arguments.DLffin") and Len(Trim(Arguments.DLffin)) NEQ 0>
                and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.DLffin#"> 
              </cfif>)
            group by lt.LTid, lt.LTdesde, lt.LThasta, dle.DLvdisf, ta.RHTdesc, ta.RHTcomportam
            order by LTdesde 
      	</cfquery> 
        <cfreturn rsAcciones>
	</cffunction>
</cfcomponent>