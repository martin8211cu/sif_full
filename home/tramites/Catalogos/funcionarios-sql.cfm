<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfset nuevo = false >
		<cftransaction>
			<cfif not len(trim(form.id_persona))>
				<cfset nuevo = true >
				<cfquery name="persona" datasource="#session.tramites.dsn#">
					insert into TPPersona( id_tipoident, identificacion_persona, nombre, apellido1, apellido2, email1, extranjero, BMUsucodigo, BMfechamod )
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipoident#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_persona#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="persona">
				<cfset form.id_persona = persona.identity >
			</cfif>
			
			<cfquery name="ABC_Fucn" datasource="#session.tramites.dsn#" >
				insert into TPFuncionario( id_inst,
										   id_persona,
										   vigente_desde, 
										   vigente_hasta,
										   es_admin,
										   BMUsucodigo,
										   BMfechamod )
				values( <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.id_inst#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.id_persona#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">, 
						<cfif isdefined("form.es_admin")>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_Fucn">
		</cftransaction>

		<cfset modo="CAMBIO">
		<cfset Form.id_funcionario = ABC_Fucn.identity>
		
		<!--- Persona tiene usuario asociado --->
		<cfquery name="usuario" datasource="asp">
			select Usucodigo
			from UsuarioReferencia
			where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_persona#">
			and STabla = 'TPPersona'
		</cfquery>
		<cfif usuario.recordcount eq 0 >
			<cfset nuevo = true >
		</cfif>

		<cfif nuevo >
			<!---//////////////////// Creación de usuario /////////////////////////----->								
			<cfinclude template="/home/tramites/getEmpresa.cfm">

			<cfif getEmpresa.recordcount gt 0>
				<cftransaction>
				<!--- Inserta Direccion --->
				<cfquery name="direccion" datasource="asp">
					insert into Direcciones(Ppais, BMUsucodigo, BMfechamod)
					values( 'CR',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="direccion">
		
				<!--- Inserta Datos Personales --->
				<cfquery name="datospersonales" datasource="asp">
					insert into DatosPersonales(Pid, Pnombre, Papellido1, Papellido2, Pemail1, BMUsucodigo, BMfechamod)
					values( <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_persona#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="datospersonales">
				</cftransaction>
	
				<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
				<!---Creacion de usuario---->
				<cfset usulogin = '*'>
				<cfif isdefined("form.login") and len(trim(form.login))>
					<cfset usulogin = trim(form.login) >
				</cfif>
				
				<cfset usuario = sec.crearUsuario(getEmpresa.CEcodigo, direccion.identity, datospersonales.identity, getEmpresa.LOCIdioma, createdate(6100, 1, 1 ), usulogin, true)>		
				
				<!--- Inserta UsuarioReferencia --->
				<cfquery datasource="asp">
					insert UsuarioReferencia(Usucodigo, Ecodigo, STabla, llave, BMfecha, BMUsucodigo)
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#getEmpresa.EcodigoSDC#">,
							'TPPersona',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
				</cfquery>
				
				<cfif isdefined("form.es_admin")>
					<!--- asigna rol de tramites --->
					<cfset rolIns = sec.insUsuarioRol(usuario, getEmpresa.EcodigoSDC, 'sys', 'tramites')>
				</cfif>
			</cfif>
		</cfif>

	<cfelseif isdefined("Form.Baja")>

		<cfquery name="ABC_Fucn" datasource="#session.tramites.dsn#">			
			delete TPFuncionario 
			where  id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">				  
		</cfquery>
		<cfset p = "?tab=4&id_inst=#form.id_inst#">
		<cflocation url="instituciones.cfm#p#">

		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<!---
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPFuncionario"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_funcionario" 
			type1="numeric" 
			value1="#form.id_funcionario#">
			--->
		<cfquery name="ABC_Fucn" datasource="#session.tramites.dsn#">			
			update TPFuncionario 
			set vigente_desde  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">, 
				vigente_hasta  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">,
				es_admin = <cfif isdefined("form.es_admin")>1<cfelse>0</cfif>
			where  id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
		</cfquery>
		<cfset modo="CAMBIO">
		
		<!---//////////////////// Creación de usuario /////////////////////////----->								
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfinclude template="/home/tramites/getEmpresa.cfm">
		
		<cfquery name="user" datasource="asp">
			select Usucodigo
			from UsuarioReferencia
			where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_persona#">
			and STabla = 'TPPersona'
		</cfquery>
		<cfif len(trim(user.Usucodigo))>
			<cfif isdefined("form.es_admin") >
				<!--- asigna rol de tramites --->
				<cfset rolIns = sec.insUsuarioRol(user.Usucodigo, getEmpresa.EcodigoSDC, 'sys', 'tramites')>
			<cfelseif not isdefined("form.es_admin") >
				<cfset rolIns = sec.delUsuarioRol(user.Usucodigo, getEmpresa.EcodigoSDC, 'sys', 'tramites')>
			</cfif>
		</cfif>

	</cfif>			
<cfelse>
	<cfset p = "?tab=4&id_inst=#form.id_inst#&nuevo=1">

	<cflocation url="instituciones.cfm#p#">
</cfif>

<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") >
	<cfquery datasource="#session.tramites.dsn#">
		delete TPFuncionarioGrupo
		where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
	</cfquery>

	<cfif isdefined("form.grupos")>
		<cfloop list="#form.grupos#" index="i">
			<cfquery datasource="#session.tramites.dsn#">
				insert into TPFuncionarioGrupo( id_funcionario, id_grupo, BMUsucodigo, BMfechamod )
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		</cfloop>
	</cfif>
	
	
	<cfquery datasource="#session.tramites.dsn#">
		delete TPFuncionarioServicio
		where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
	</cfquery>

	<cfif isdefined("form.servicios")>
		<cfloop list="#form.servicios#" index="i">
			<cfquery datasource="#session.tramites.dsn#">
				insert into TPFuncionarioServicio( id_funcionario, id_tiposerv, BMUsucodigo, BMfechamod )
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>

<cfset p = "?tab=4&id_inst=#form.id_inst#">
<cfif isdefined("form.id_funcionario") and len(trim(form.id_funcionario))>
	<cfset p = p & "&id_funcionario=#form.id_funcionario#">
</cfif>


<cflocation url="instituciones.cfm#p#">



