<cfif isdefined("form.Guardar")>

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
			
			<cfif isdefined("usuario") and Len(Trim(usuario))>
				<!--- Agregar Rol de Vendedor --->
				<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, 'SACI', 'VENDEDOR')>

				<cfif isdefined("form.Vid") and Len(Trim(form.Vid))>
					<!--- Agregar Referencia a Vendedor --->
					<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'ISBvendedor', form.Vid)>
				</cfif>
			<cfelse>
				<cfthrow message="Error: El usuario no se pudo crear">
			</cfif>

		</cfif>
	</cfif>

</cfif>

<cfinclude template="vendedor-redirect.cfm">
