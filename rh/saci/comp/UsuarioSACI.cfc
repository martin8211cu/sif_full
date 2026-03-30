<!--- 
	Este componente no debe tener <cftransaction> externos

	tipoGeneracion acepta 2 valores:
	1: Genera usuario y passwords temporales y lo envia por correo
	2: Crea el usuario con password especificado por el cliente
--->

<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para operaciones con Usuario de SACI">

	<!--- Función para instanciación de este componente --->
	<cffunction name="init">
		<!--- Instanciar el componente de seguridad --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset Request.sec = sec>
	</cffunction>

	<!--- 
		Para el nombre de los campos que llegan en la estructura data se asumen los nombre de los campos pintados por el tag de persona 
		Adicionalmente se puede usar el parámetro de sufijo en caso de que los nombres de esos campos lo tengan
	--->

	<cffunction name="Inactivacion" output="false" returntype="numeric" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">

		<cfset LvarError = 0>

		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfif rsUsuario.recordCount>
			<cfquery name="name" datasource="asp">
				update Usuario
				set Uestado = 0
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
			</cfquery>
		
		<cfelse>
			<cfset LvarError = 1>
		</cfif>

		<cfreturn LvarError>
	</cffunction>

	<cffunction name="Activacion" output="false" returntype="numeric" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">

		<cfset LvarError = 0>

		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfif rsUsuario.recordCount>
			<cfquery name="name" datasource="asp">
				update Usuario
				set Uestado = 1
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
			</cfquery>
		
		<cfelse>
			<cfset LvarError = 1>
		</cfif>

		<cfreturn LvarError>
	</cffunction>

	<cffunction name="Tiene_Usuario" output="false" returntype="boolean" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">
	  
		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfreturn (rsUsuario.recordCount GT 0)>
	</cffunction>

	<cffunction name="Tiene_Rol" output="false" returntype="boolean" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">
		<cfargument name="SRcodigo" type="string" required="Yes" displayname="Rol a buscar">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">
	  

		<cfset result = false>
		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfif rsUsuario.recordCount>
			<cfquery name="chkExistencia" datasource="asp">
				select count(1) as cantidad
				from UsuarioRol
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
				and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="SACI">
				and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SRcodigo#">
			</cfquery>
			<cfset result = (chkExistencia.cantidad GT 0)>
		</cfif>
		
		<cfreturn result>
	</cffunction>

	<cffunction name="Asignar_Rol_AGENTE" output="false" returntype="void" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">

		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		

		
		<cfif rsUsuario.recordCount>
			<cfquery name="refAgente" datasource="#session.dsn#">
				select AGid
				from ISBagente
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.referencia#">
			</cfquery>
			<cfif refAgente.recordCount>
				<cfset rsUsuario2 = Request.sec.getUsuarioByRef(refAgente.AGid, Arguments.EcodigoSDC, 'ISBagente')>
				<cfif rsUsuario2.recordCount EQ 0>

					<!--- Insertar Referencia --->
					<cfset ref = Request.sec.insUsuarioRef(rsUsuario.Usucodigo, Arguments.EcodigoSDC, 'ISBagente', refAgente.AGid)>
					<!--- Insertar Rol --->
					<cfset rolIns = Request.sec.insUsuarioRol(rsUsuario.Usucodigo, Arguments.EcodigoSDC, 'SACI', 'AGENTE')>
				</cfif>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="Asignar_Rol_VENDEDOR" output="false" returntype="void" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">

		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfif rsUsuario.recordCount>
			<cfquery name="refVendedor" datasource="#session.dsn#">
				select Vid
				from ISBvendedor
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.referencia#">
			</cfquery>
			<cfif refVendedor.recordCount>
				<cfset rsUsuario2 = Request.sec.getUsuarioByRef(refVendedor.Vid, Arguments.EcodigoSDC, 'ISBvendedor')>
				<cfif rsUsuario2.recordCount EQ 0>
					<!--- Insertar Referencia --->
					<cfset ref = Request.sec.insUsuarioRef(rsUsuario.Usucodigo, Arguments.EcodigoSDC, 'ISBvendedor', refVendedor.Vid)>
					<!--- Insertar Rol --->
					<cfset rolIns = Request.sec.insUsuarioRol(rsUsuario.Usucodigo, Arguments.EcodigoSDC, 'SACI', 'VENDEDOR')>
				</cfif>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="Asignar_Rol_CLIENTE" output="false" returntype="void" access="remote">
		<cfargument name="referencia" type="string" required="Yes" displayname="Referencia a ISBpersona">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">

		<!--- Obtener el usucodigo a partir de la referencia --->
		<cfset rsUsuario = Request.sec.getUsuarioByRef(Arguments.referencia, Arguments.EcodigoSDC, 'ISBpersona')>
		
		<cfif rsUsuario.recordCount GT 0>
			<!--- Insertar Rol --->
			<cfset rolIns = Request.sec.insUsuarioRol(rsUsuario.Usucodigo, Arguments.EcodigoSDC, 'SACI', 'CLIENTE')>
		</cfif>

	</cffunction>

	<cffunction name="Alta" output="false" returntype="numeric" access="remote">
		<cfargument name="tipoGeneracion" type="numeric" required="Yes" displayname="Forma en que se va a generar el usuario">
		<cfargument name="data" type="struct" required="Yes" displayname="Formulario con Datos Requeridos">
		<cfargument name="user" type="string" required="No" default="*" displayname="Usuario de SACI">
		<cfargument name="pass" type="string" required="No" default="" displayname="Contraseña para Usuario de SACI">
		<cfargument name="email" type="string" required="No" default="" displayname="Email a donde se envia el usuario y password temporales">
		<cfargument name="referencia" type="string" required="No" default="" displayname="Referencia a ISBpersona">
		<cfargument name="sufijo" type="string" required="No"  default="" displayname="sufijo para el nombre de los campos que llegan en data">
		<cfargument name="CEcodigo" type="numeric" required="No" default="#session.CEcodigo#" displayname="Código de Cuenta Empresarial">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">

		<cfif Len(Trim(Arguments.user)) EQ 0>
			<cfset Arguments.user = '*'>
		</cfif>

		<cfif Arguments.tipoGeneracion EQ 1 and Len(Trim(Arguments.email)) EQ 0>
			<cfthrow message="Error: El email es requerido.">
		</cfif>

		<cfif Arguments.tipoGeneracion EQ 2 and (Len(Trim(Arguments.user)) EQ 0 or Len(Trim(Arguments.pass)) EQ 0)>
			<cfthrow message="Error: Falta enviar el usuario o el password.">
		</cfif>

		<cfif Arguments.tipoGeneracion EQ 3 and (Len(Trim(Arguments.user)) EQ 0)>
			<cfthrow message="Error: Falta enviar el usuario.">
		</cfif>


		<cfif not (isdefined('Arguments.data.Pid#Arguments.sufijo#') and Len(Trim(Evaluate('Arguments.data.Pid#Arguments.sufijo#'))))>
			<cfthrow message="Error: No vienen suficientes datos para crear el usuario">
		</cfif>

		<cfset expira = ParseDateTime('01/01/6100','dd/mm/yyyy')>
		<cfset enviar_password = (Arguments.tipoGeneracion EQ 1)>

		<cfif Arguments.tipoGeneracion EQ 2>
			<cfquery name="checkUserExists" datasource="asp">
				select count(1) as cantidad
				from Usuario
				where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.user#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
			
			<cfif checkUserExists.cantidad GT 0>
				<cfthrow message="Error: El usuario #Arguments.user# ya existe en la base de datos. Por favor seleccione otro.">
			</cfif>
		</cfif>
		
		<cfif Arguments.tipoGeneracion EQ 3>
			<cfquery name="checkUserNotExists" datasource="asp">
				select Usucodigo as usuario
				from Usuario
				where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.user#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
			
			<cfif checkUserNotExists.RecordCount eq 0>
				<cfthrow message="Error: El usuario #Arguments.user# no existe en la base de datos. Por favor seleccione otro.">
			</cfif>

		</cfif>
		
		<!--- Averiguar el Idioma y Pais de la Cuenta Empresarial --->
		<cfquery name="rsDatosCuenta" datasource="asp">
			select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
			from CuentaEmpresarial a, Direcciones b
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			and a.id_direccion = b.id_direccion
		</cfquery>


	<cfif Arguments.tipoGeneracion neq 3>			
		<cftransaction>
		
			<!--- Inserta los datos personales --->
			<cfquery name="DPinserted" datasource="asp">
				insert into DatosPersonales (Pid, Pnombre, Papellido1, Papellido2, Pcasa, Pcelular, Pemail1, BMUsucodigo, BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Pid#Arguments.sufijo#')#">,
					<cfif Evaluate('Arguments.data.Ppersoneria' & Arguments.sufijo) EQ 'J'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.PrazonSocial#Arguments.sufijo#')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Pnombre#Arguments.sufijo#')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Papellido#Arguments.sufijo#')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Papellido2#Arguments.sufijo#')#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Ptelefono1#Arguments.sufijo#')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Ptelefono2#Arguments.sufijo#')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="DPinserted">
			<cfset datos_personales = DPinserted.identity>
	
			<!--- Inserta la direccion --->
			<cfquery name="Dinserted" datasource="asp">
				insert into Direcciones (atencion, direccion1, Ppais, BMUsucodigo, BMfechamod)
				values (
					<cfif Evaluate('Arguments.data.Ppersoneria' & Arguments.sufijo) EQ 'J'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.PrazonSocial#Arguments.sufijo#')#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Evaluate('Arguments.data.Pnombre#Arguments.sufijo#') & ' ' & Evaluate('Arguments.data.Papellido#Arguments.sufijo#') & ' ' & Evaluate('Arguments.data.Papellido2#Arguments.sufijo#'))#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Pdireccion#Arguments.sufijo#')#">,
					<cfif isdefined("Arguments.data.Ppais#Arguments.sufijo#") and Len(Trim(Evaluate('Arguments.data.Ppais#Arguments.sufijo#')))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Arguments.data.Ppais#Arguments.sufijo#')#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosCuenta.Ppais#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="Dinserted">
			<cfset id_direccion = Dinserted.identity>
			
		</cftransaction>
		

		<!--- Creación del Usuario --->
		<cfset usuario = Request.sec.crearUsuario(Arguments.CEcodigo, id_direccion, datos_personales, rsDatosCuenta.LOCIdioma, expira, Arguments.user, enviar_password)>
		<cfif Arguments.tipoGeneracion EQ 2>
			<cfset Request.sec.renombrarUsuario(usuario, Arguments.user, Arguments.pass)>
		</cfif>
	
	</cfif>
	
		<cfif Arguments.tipoGeneracion eq 3>
			<!--- Asociar Referencia a ISBpersona --->
			<cfset usuario = #checkUserNotExists.usuario#>
			<cfif Len(Trim(Arguments.referencia))>
			<cfset ref = Request.sec.insUsuarioRef(usuario, Arguments.EcodigoSDC, 'ISBpersona', Arguments.referencia)>
			</cfif>
		<cfelse>
			<!--- Asociar Referencia a ISBpersona --->
			<cfif Len(Trim(Arguments.referencia))>
				<cfset ref = Request.sec.insUsuarioRef(usuario, Arguments.EcodigoSDC, 'ISBpersona', Arguments.referencia)>
			</cfif>
		</cfif>			
		<cfreturn usuario>
		
	</cffunction>
	
</cfcomponent>
