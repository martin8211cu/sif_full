<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Wrappers para CIC" output="no">


	<!---Crear Logines en PSO con los roles Agentes, Vendedores, Clientes --->
	
	<cffunction name="crearLoginasp" access="remote" output="false" returntype="void" hint="CrearLogin en asp">
		<cfargument name="tipoGeneracion" type="numeric" required="Yes" displayname="Forma en que se va a generar el usuario">
		<cfargument name="user" type="string" required="No" default="*" displayname="Usuario de SACI">
		<cfargument name="pass" type="string" required="No" default="" displayname="Contraseña para Usuario de SACI">
		<cfargument name="email" type="string" required="No" default="" displayname="Email a donde se envia el usuario y password temporales">
		<cfargument name="Pquien" type="numeric" required="Yes" default="" displayname="Referencia a ISBpersona">
		<cfargument name="sufijo" type="string" required="No"  default="" displayname="sufijo para el nombre de los campos que llegan en data">
		<cfargument name="CEcodigo" type="numeric" required="No" default="#session.CEcodigo#" displayname="Código de Cuenta Empresarial">
		<cfargument name="EcodigoSDC" type="numeric" required="No" default="#session.EcodigoSDC#" displayname="Código de Empresa del Portal">
		<cfargument name="rol" type="string" required="Yes" displayname="Rol que se desea asociar (AGENTE,VENDEDOR O CLIENTE">
		
		<cfinvoke component="saci.comp.UsuarioSACI" method="init" />
		<cfinvoke component="saci.comp.UsuarioSACI" method="Tiene_Usuario" returnvariable="tieneUsuario">
		<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
		</cfinvoke>

		<cfif not tieneUsuario>
			
			<cfquery name="rsData" datasource="#session.dsn#">
				select a.Ppersoneria as Ppersoneria, 
					   a.Pid as Pid, 
					   a.Pnombre as Pnombre, 
					   a.Papellido as Papellido, 
					   a.Papellido2 as Papellido2, 
					   a.PrazonSocial as PrazonSocial, 
					   a.Ppais as Ppais, 
					   a.Pdireccion as Pdireccion, 
					   a.Ptelefono1 as Ptelefono1, 
					   a.Ptelefono2 as Ptelefono2, 
					   a.Pemail as Pemail
				from ISBpersona a
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
			</cfquery>
			<cfset data = StructNew()>
			<cfset StructInsert(data, "Ppersoneria", rsData.Ppersoneria, true)>
			<cfset StructInsert(data, "Pid", rsData.Pid, true)>
			<cfset StructInsert(data, "Pnombre", rsData.Pnombre, true)>
			<cfset StructInsert(data, "Papellido", rsData.Papellido, true)>
			<cfset StructInsert(data, "Papellido2", rsData.Papellido2, true)>
			<cfset StructInsert(data, "PrazonSocial", rsData.PrazonSocial, true)>
			<cfset StructInsert(data, "Ppais", rsData.Ppais, true)>
			<cfset StructInsert(data, "Pdireccion", rsData.Pdireccion, true)>
			<cfset StructInsert(data, "Ptelefono1", rsData.Ptelefono1, true)>
			<cfset StructInsert(data, "Ptelefono2", rsData.Ptelefono2, true)>
			<cfset StructInsert(data, "Pemail", rsData.Pemail, true)>
		
			<cfif rsData.recordCount>
			
				

				<cfinvoke component="saci.comp.UsuarioSACI" method="Alta" returnvariable="usuario">
					<cfinvokeargument name="tipoGeneracion" value="#Arguments.tipoGeneracion#">
					<cfinvokeargument name="data" value="#data#">
					<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
					<cfif Arguments.tipoGeneracion EQ 1>
						<cfinvokeargument name="email" value="#Arguments.email#">
					<cfelseif Arguments.tipoGeneracion EQ 2>
						<cfinvokeargument name="user" value="#Arguments.user#">
						<cfinvokeargument name="pass" value="#Arguments.pass#">
					</cfif>
				</cfinvoke>
			</cfif>
		</cfif>			
			
			<cfif Arguments.rol eq 'AGENTE'>

				<!--- Asignar el rol de agente al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_AGENTE">
					<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
				</cfinvoke>

				<!--- Asignar el rol de vendedor al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
					<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
				</cfinvoke>
			<cfelseif Arguments.rol eq 'VENDEDOR' >

				<!--- Asignar el rol de vendedor al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
					<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
				</cfinvoke>
			<cfelseif Arguments.rol eq 'CLIENTE'>		

				<!--- Asignar el rol de cliente al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_CLIENTE">
					<cfinvokeargument name="referencia" value="#Arguments.Pquien#">
				</cfinvoke>			
			</cfif>		
	
	</cffunction>
</cfcomponent>
