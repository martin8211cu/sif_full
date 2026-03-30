<cfinclude template="vendedor-params.cfm">

<cfif isdefined("form.Crear")>

	<!--- Si viene la referencia se obtiene el query con los datos --->
	<cfif Len(Trim(Form.Pquien))>
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
				</cfif>
			</cfinvoke>

			<!--- Asignar el rol de vendedor al usuario --->
			<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
				<cfinvokeargument name="referencia" value="#form.Pquien#">
			</cfinvoke>
			
		</cfif>
		
	</cfif>

<cfelseif isdefined("form.AsignarRol")>

	<cfif Len(Trim(Form.Pquien))>

		<cfinvoke component="saci.comp.UsuarioSACI" method="init" />

		<!--- Asignar el rol de vendedor al usuario --->
		<cfinvoke component="saci.comp.UsuarioSACI" method="Asignar_Rol_VENDEDOR">
			<cfinvokeargument name="referencia" value="#form.Pquien#">
		</cfinvoke>

	</cfif>
	
</cfif>

<cfinclude template="vendedor-redirect.cfm">
