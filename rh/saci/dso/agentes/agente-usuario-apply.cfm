<cfif isdefined('form.tipo') and form.tipo eq 'Externo'>
	<cfinclude template="agente-params.cfm">
</cfif>

<cfif isdefined("form.Crear")>

	<cfif Len(Trim(Form.Pquien))>
	
		<!--- Verificar que la persona tenga al menos una cuenta que no tenga la condición 'C' --->
		<cfquery name="chkCuenta" datasource="#session.dsn#">
			select count(1) as cantidad
			from ISBcuenta a
				inner join ISBproducto b
					on b.CTid = a.CTid
					and b.CTcondicion <> 'C'
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and a.CTtipoUso = 'A'
			and a.Habilitado = 1
		</cfquery>
		
		<!--- El agente debe estár habilitado al crear el Usuario de acceso al Sistema SACI --->
		<cfquery name="chkHabilitado" datasource="#session.dsn#">
			select count(1) as cant
			from ISBpersona a
				inner join ISBagente b
					on b.Pquien = a.Pquien
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and b.Habilitado = 1
		</cfquery>
		
	<cfif not chkHabilitado.cant GT 0>
			<cfthrow message="No se puede crear el Usuario SACI, el agente no está activo">
	<cfelse>		
		<cfif (chkCuenta.cantidad GT 0 or Form.tipo eq 'Interno')>

			<!--- Se obtiene el query con los datos --->
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
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
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
			
				<cfinvoke component="saci.comp.UsuarioSACI" method="init" />

				<cfinvoke component="saci.comp.UsuarioSACI" method="Alta" returnvariable="usuario">
					<cfinvokeargument name="tipoGeneracion" value="#form.rdGen#">
					<cfinvokeargument name="data" value="#data#">
					<cfinvokeargument name="referencia" value="#form.Pquien#">
					<cfif form.rdGen EQ 1>
						<cfinvokeargument name="email" value="#form.userEmail#">
					<cfelseif form.rdGen EQ 2>
						<cfinvokeargument name="user" value="#form.user#">
						<cfinvokeargument name="pass" value="#form.userPass1#">
					<cfelseif form.rdGen EQ 3>
						<cfinvokeargument name="user" value="#form.userexistente#">
					</cfif>
				</cfinvoke>
				
				<!--- Asignar el rol de agente al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_AGENTE">
					<cfinvokeargument name="referencia" value="#form.Pquien#">
				</cfinvoke>

				<!--- Asignar el rol de vendedor al usuario --->
				<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
					<cfinvokeargument name="referencia" value="#form.Pquien#">
				</cfinvoke>
				
			</cfif>

		<!--- Si la persona no tiene ninguna cuenta habilitada --->
		<cfelse>
			<cfthrow message="La persona debe tener una cuenta de agente y contrato de servicio activado antes de crearle un usuario de SACI">
		</cfif>
	</cfif>
</cfif>

<cfelseif isdefined("form.AsignarRol")>

	<cfif Len(Trim(Form.Pquien))>

		<!--- Verificar que la persona tenga al menos una cuenta que no tenga la condición 'C' --->
		<cfquery name="chkCuenta" datasource="#session.dsn#">
			select count(1) as cantidad
			from ISBcuenta a
				inner join ISBproducto b
					on b.CTid = a.CTid
					and b.CTcondicion <> 'C'
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and a.CTtipoUso = 'A'
			and a.Habilitado = 1
		</cfquery>
		
		<cfif (chkCuenta.cantidad GT 0 and isdefined(form.tipo) and form.tipo eq 'Externo') or form.tipo eq 'Interno' >

			<cfinvoke component="saci.comp.UsuarioSACI" method="init" />
			
			<!--- Asignar el rol de agente al usuario --->
			<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_AGENTE">
				<cfinvokeargument name="referencia" value="#form.Pquien#">
			</cfinvoke>
	
			<!--- Asignar el rol de vendedor al usuario --->
			<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
				<cfinvokeargument name="referencia" value="#form.Pquien#">
			</cfinvoke>
			
		<!--- Si la persona no tiene ninguna cuenta habilitada --->
		<cfelse>
			<cfthrow message="La persona debe tener una cuenta de agente y contrato de servicio activado antes de asignarle el rol de agente">

		</cfif>

	</cfif>
	
</cfif>

<cfinclude template="agente-redirect.cfm">
