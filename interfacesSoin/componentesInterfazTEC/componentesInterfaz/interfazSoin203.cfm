<!---
	Interfaz 203
	Interfaz de Intercambio de Información de Datos Familiares
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 16/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz203" datasource="sifinterfaces">
		SELECT 	ID, EcodigoSDC, Imodo, IdentificacionEmpleado, IdentificacionFamiliar, TipoIdentificacion, Nombre, Apellido1, Apellido2, 
				TipoParentezco, FechaNacimiento, Sexo, Direccion, BMUsucodigo, ts_rversion
		FROM 	IE203
		WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz203.recordcount eq 0>
		<cfthrow message="Error en Interfaz 203. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Procesamiento de Interfaz 203. --->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_Error_de_Interfaz_203" returnvariable="MSG_Error_de_Interfaz_203" Default="Error de Interfaz 203" component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="MSG_Proceso_Cancelado" returnvariable="MSG_Proceso_Cancelado" Default="Proceso Cancelado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Error_Empresa" returnvariable="MSG_Error_Empresa" Default="La empresa no existe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_Modo" returnvariable="MSG_Error_Modo" Default="Esta interfaz solo permite Imodo A=Alta, B=Baja y C=Cambio." component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_Empleado" returnvariable="MSG_Error_Empleado" Default="El Empleado no existe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_TipoID" returnvariable="MSG_Error_TipoID" Default="Tipo de Indentificación incorrecto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_Parentesco" returnvariable="MSG_Error_Parentesco" Default="El tipo de parentesco no existe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_IDPariente" returnvariable="MSG_Error_IDPariente" Default="El pariente no existe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="MSG_Error_Pariente" returnvariable="MSG_Error_Pariente" Default="El pariente ya existe" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES TRADUCCION --->
<!--- FUNCIONES DE VALIDACION --->
<!--- VALIDA LA EMPRESA 100 --->
<!--- <cffunction name="getValidaEmpresaDF" access="private" returntype="numeric">
	<cfargument name="EcodigoSDC" required="yes" type="string">
	
	<cfquery name="query" datasource="#Session.DSN#">
		select Ereferencia
		from Empresa c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#"> 
	</cfquery>
	<cfif query.RecordCount EQ 0>			
		<cfthrow message="Error 100. #MSG_Error_de_Interfaz_203# #MSG_Error_Empresa#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn query.Ereferencia>
</cffunction> --->
<!--- VALIDA EL MODO 200 --->
<!--- <cffunction name="getValidModo" access="private" returntype="string">
	<cfargument name="Modo" required="yes" type="string">
	<cfargument name="Empleado" required="yes" type="string">
	<cfif NOT ListFind("A,C,B",Arguments.Modo)>
		<cfthrow message="Error 200. #MSG_Error_de_Interfaz_203# #MSG_Error_Modo#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn Arguments.Modo>
</cffunction> --->
<!--- VALIDA QUE EL EMPLEADO EXISTA 300 --->
<!--- <cffunction name="getValidEmpleado" access="private" returntype="numeric">
	<cfargument name="EcodigoSDC" required="yes" type="string">
	<cfargument name="Empleado" 		 required="yes" type="string">
	
	<cfquery name="query" datasource="#Session.DSN#">
		select DEid
		from DatosEmpleado b
		inner join Empresa c
			on c.Ereferencia = b.Ecodigo
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#"> 
		where b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Empleado#"> 
	</cfquery>
	<cfif query.RecordCount EQ 0>			
		<cfthrow message="Error 300. #MSG_Error_de_Interfaz_203# #MSG_Error_Empleado#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn query.DEid>
</cffunction> --->
<!--- VALIDA El TIPO DE INDENTIFICACION 400 --->
<!--- <cffunction access="private" name="getValidTipoID" output="false" returntype="string">
	<cfargument name="TipoID" required="yes" type="string">
	<cfquery name="rsTipoID" datasource="#session.DSN#"	>
		select NTIcodigo
		from NTipoIdentificacion
		where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoID#">
	</cfquery>
	<cfif rsTipoID.RecordCount EQ 0>
		<cfthrow message="Error 400. #MSG_Error_de_Interfaz_203# #MSG_Error_TipoID#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn rsTipoID.NTIcodigo>
</cffunction> --->
<!--- VALIDA EL PARENTESCO 500 --->
<!--- <cffunction access="private" name="getValidParentesco" output="false" returntype="numeric">
	<cfargument name="TipoParentesco" required="yes" type="string">
	<cfquery name="rsParentesco" datasource="#session.DSN#">
		select Pid
		from RHParentesco
		where Pid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoParentesco#">
	</cfquery>
	<cfif rsParentesco.RecordCount EQ 0>
		<cfthrow message="Error 500. #MSG_Error_de_Interfaz_203# #MSG_Error_Parentesco#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn rsParentesco.Pid>
</cffunction> --->
<!--- BUSCA LA LINEA DEL EMPLEADO 600 --->
<!--- <cffunction access="private" name="getFElinea" output="false" returntype="numeric">
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="IDPariente" required="yes" type="string">
	<cfquery name="rsFElinea" datasource="#session.DSN#">
		select FElinea
		from FEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and FEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IDPariente#">
	</cfquery>
	<cfif rsFElinea.RecordCount EQ 0>
		<cfthrow message="Error 600. #MSG_Error_de_Interfaz_203# #MSG_Error_IDPariente#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfreturn rsFElinea.FElinea>
</cffunction>
 --->
<cftransaction>
	<!--- VALIDA LAS VARIABLES --->
	<cfif NOT ListFind("A,C,B",readInterfaz203.Imodo)>
		<cfthrow message="Error 200. #MSG_Error_de_Interfaz_203# #MSG_Error_Modo#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfset Valida_Modo = readInterfaz203.Imodo>
	
	<!--- <cfset Valida_DEid = getValidEmpleado(readInterfaz203.EcodigoSDC,readInterfaz203.IdentificacionEmpleado)> --->
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select DEid
		from DatosEmpleado b
		inner join Empresa c
			on c.Ereferencia = b.Ecodigo
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz203.EcodigoSDC#"> 
		where b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.IdentificacionEmpleado#"> 
	</cfquery>
	<cfif rsEmpleado.RecordCount EQ 0>			
		<cfthrow message="Error 300. #MSG_Error_de_Interfaz_203# #MSG_Error_Empleado#. #MSG_Proceso_Cancelado#!">
	</cfif>
	<cfset Valida_DEid = rsEmpleado.DEid>
	
	<cfif ListFind("A,C",Valida_Modo)>
		<cfquery name="rsEmpresa" datasource="#Session.DSN#">
			select Ereferencia
			from Empresa c
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz203.EcodigoSDC#"> 
		</cfquery>
		<cfif rsEmpresa.RecordCount EQ 0>			
			<cfthrow message="Error 100. #MSG_Error_de_Interfaz_203# #MSG_Error_Empresa#. #MSG_Proceso_Cancelado#!">
		</cfif>
		<cfset Valida_Empresa 	 = rsEmpresa.Ereferencia>
		<cfquery name="rsTipoID" datasource="#session.DSN#"	>
			select NTIcodigo
			from NTipoIdentificacion
			where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz203.TipoIdentificacion#">
		</cfquery>
		<cfif rsTipoID.RecordCount EQ 0>
			<cfthrow message="Error 400. #MSG_Error_de_Interfaz_203# #MSG_Error_TipoID#. #MSG_Proceso_Cancelado#!">
		</cfif>
		<cfset Valida_TipoID  = rsTipoID.NTIcodigo>
		<cfquery name="rsParentesco" datasource="#session.DSN#">
			select Pid
			from RHParentesco
			where Pid = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz203.TipoParentezco#">
		</cfquery>
		<cfif rsParentesco.RecordCount EQ 0>
			<cfthrow message="Error 500. #MSG_Error_de_Interfaz_203# #MSG_Error_Parentesco#. #MSG_Proceso_Cancelado#!">
		</cfif>
		<cfset Valida_Parentesco = rsParentesco.Pid>
	</cfif>
	<cfif ListFind("C,B",readInterfaz203.Imodo)>
		<cfquery name="rsFElinea" datasource="#session.DSN#">
			select FElinea
			from FEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_DEid#">
			  and FEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.IdentificacionFamiliar#">
		</cfquery>
		<cfif rsFElinea.RecordCount EQ 0>
			<cfthrow message="Error 600. #MSG_Error_de_Interfaz_203# #MSG_Error_IDPariente#. #MSG_Proceso_Cancelado#!">
		</cfif>
		<cfset Lvar_FElinea = rsFElinea.FElinea>
	</cfif>
	<cfif ListFind("A",readInterfaz203.Imodo)>
		<cfquery name="rsFElinea" datasource="#session.DSN#">
			select FElinea
			from FEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_DEid#">
			  and FEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.IdentificacionFamiliar#">
		</cfquery>
		<cfif rsFElinea.RecordCount NEQ 0>
			<cfthrow message="Error 700. #MSG_Error_de_Interfaz_203# #MSG_Error_Pariente#. #MSG_Proceso_Cancelado#!">
		</cfif>
	</cfif>
	<cfif Valida_Modo EQ 'A'>
		<!--- INSERTA UN FAMILIAR --->
		<cfquery  name="rsInsert" datasource="#session.DSN#">
			insert into FEmpleado 
					(DEid, NTIcodigo, FEidentificacion, Pid, 
						FEnombre, FEapellido1, FEapellido2, FEfnac, FEdir, FEsexo, IDInterfaz,
						Usucodigo, Ulocalizacion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_DEid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Valida_TipoID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.IdentificacionFamiliar#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_Parentesco#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.nombre#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Apellido1#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Apellido2#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(readInterfaz203.FechaNacimiento)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Direccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Sexo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz203.ID#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
						)
		</cfquery>
	<cfelseif Valida_Modo EQ 'B'>
		<!--- <cfset Lvar_FElinea = getFElinea(Valida_DEid,readInterfaz203.IdentificacionFamiliar)> --->
		<!--- BORRA UN FAMILIAR --->
		<cfquery name="rsDelete" datasource="#session.DSN#">
			delete FEmpleado
			where FElinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_FElinea#">
		</cfquery>
	<cfelseif Valida_Modo EQ 'C'>
		<!--- <cfset Lvar_FElinea = getFElinea(Valida_DEid,readInterfaz203.IdentificacionFamiliar)> --->
		<!--- MODIFICAR LOS DATOS DEL FAMILIAR --->
		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update FEmpleado set
				NTIcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Valida_TipoID#">,
				FEidentificacion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.IdentificacionFamiliar#">,
				Pid 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_Parentesco#">,
				FEnombre 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Nombre#">,								
				FEapellido1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Apellido1#">,								
				FEapellido2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Apellido2#">,
				FEfnac 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(readInterfaz203.FechaNacimiento)#">,
				FEdir 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Direccion#">,
				FEsexo 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz203.Sexo#">,
				IDInterfaz		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz203.ID#">
			where FElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_FElinea#">			
		</cfquery>
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>