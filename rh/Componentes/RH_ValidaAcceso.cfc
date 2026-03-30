<!--- Este componente se encarga de Permitir o Negar el acceso a los usuarios. 
Fue realizado para la parametrización "2526" -> "Prohibir Incluir Insumos a la Nomina"--->

<cfcomponent>

<cfinvoke component="sif.Componentes.Translate"	method="Translate" key="MSG_AdministradorNoAsignado" default="Procesos de N&oacute;mina bloqueados<br><br>	S&oacute;lo el usuario Administrador" returnvariable="MSG_AdministradorNoAsignado"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate" key="MSG_NominasBloqueadas" default="Procesos de N&oacute;mina bloqueados<br><br>S&oacute;lo el usuario Administrador" returnvariable="MSG_NominasBloqueadas"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate" key="MSG_PuedeAgregarModificar" default="puede Agregar, Modificar o Eliminar elementos de la N&oacute;mina</br> Gracias!" returnvariable="MSG_PuedeAgregarModificar"/>	

	<cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>
	
	<cffunction name="validarAcceso" returntype="string" >
		<cfargument name="codigoEmpresa"		type="numeric" 	default="#session.Ecodigo#"		hint="codigo de la empresa">
		<cfargument name="usuario"	 			type="string" 	default="#session.usucodigo#" 	hint="usoCodigo requerido para comparación">
		<cfargument name="backs"	 			type="numeric" 	default="1" 					hint="cantidad de backs a realizar">
		<!--- Si no se envia el DataSource se busca de Session --->
		<cfif not isdefined('Arguments.datasource') and isdefined('Session.dsn')>
            <cfset Arguments.datasource = Session.dsn>
        </cfif>
        
					<cfquery name="rsValido" datasource="#Arguments.datasource#"><!--- revifica si permite o no validar--->
						select Pcodigo, Pvalor  
						from RHParametros 
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoEmpresa#">
						and Pcodigo=2526<!--- este es el Pcodigo de acceso valido--->
					</cfquery>

					<cfif rsValido.RecordCount GT 0 and rsValido.Pvalor EQ '1'>
							<cfquery name="rsUsuCodigoAdmin" datasource="#Arguments.datasource#"><!--- encuentra el usucodigo del administrador--->
								select coalesce(Pvalor,'0') as codigoAdmin
								from RHParametros 
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoEmpresa#">
								and Pcodigo=180<!--- este es el Pcodigo de administrador--->
							</cfquery>
		
							<cfif rsUsuCodigoAdmin.RecordCount GT 0 and rsUsuCodigoAdmin.codigoAdmin NEQ #usuario#><!---compara si el usuario administrador es el que se encuentra logeado actualmente--->
							
							<cf_dbfunction name="OP_concat" returnvariable="concat">
							<cfquery name="rsNombreAdministrador" datasource="#Arguments.datasource#"><!--- obtiene el nombre del administrador, es para información extra--->
								select Pnombre #concat#' '#concat# Papellido1 #concat#' '#concat# Papellido2 as nombre
								from Usuario a inner join DatosPersonales b
									on a.datos_personales = b.datos_personales						
								where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuCodigoAdmin.codigoAdmin#">
							</cfquery>	
								
	
								<cfset nombre="#MSG_AdministradorNoAsignado#">
								
								<cfif rsNombreAdministrador.RecordCount GT 0>
									<cfset nombre=rsNombreAdministrador.nombre>
								</cfif>
							
								
								<cfset request.error.backs=#backs#>
								<cfthrow detail = "#MSG_NominasBloqueadas# (#nombre#) #MSG_PuedeAgregarModificar#" 
								type="touser">
								<cfabort>
							</cfif> 
					</cfif>
	</cffunction>
</cfcomponent>