<cfset usuario = "">
<cfif isdefined("form.accion") and form.accion neq '3'>
	<cfif modo neq 'ALTA'>
		<cfif form.accion EQ '4'>
			<!--- Activar Usuario --->
			<cfquery name="rs" datasource="asp">
				update Usuario
				   set Uestado = 1
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
		<cfelseif form.accion EQ '5'>
			<!--- Desactivar Usuario --->
			<cfquery name="rs" datasource="asp">
				update Usuario
				   set Uestado = 0
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
		<cfelse>
			<!--- Modifica los datos personales --->
			<cf_datospersonales action="readform" name="data1">
			<cf_datospersonales action="update" key="#datos_personales#" name="data1" data="#data1#">
			<!--- Modifica la direccion --->
			<cf_direccion action="readform" form="frmUsuarios" name="data2">
			<cf_direccion action="update" form="frmUsuarios" key="#id_direccion#" name="data2" data="#data2#">

			<cfquery name="rsUsuario" datasource="asp">
				update Usuario
				set Ufhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Form.Ufhasta#">,
				    LOCIdioma = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCIdioma#">
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
			<cfset usuario = Form.Usucodigo>
		</cfif>
	<cfelse>
		<cfif Len(Trim(Form.Ufhasta)) NEQ 0>
			<cfset expira = ParseDateTime(Form.Ufhasta,'dd/mm/yyyy')>
		<cfelse>
			<cfset expira = ParseDateTime('01/01/6100','dd/mm/yyyy')>
		</cfif>
		<cfif isdefined("Form.rdGen") and Form.rdGen EQ "2">
			<cfset user = Form.username>
			<cfset enviar_password = false>
		<cfelseif isdefined("Form.rdGen") and Form.rdGen EQ "3">
			<cfset user = Form.username>
			<cfset enviar_password = false> <!--- Se envía despues de renombrar el Usulogin --->
		<cfelse>
			<cfset user = "*">
			<cfset enviar_password = true>
		</cfif>

		<cfquery name="checkUserExists" datasource="asp">
			select 1
			from Usuario
			where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		</cfquery>

		<!--- Inserta los datos personales --->
		<cf_datospersonales action="readform" name="data1">
		<cf_datospersonales action="insert" name="data1" data="#data1#">
		<!--- Inserta la direccion --->
		<cf_direccion action="readform" form="frmUsuarios" name="data2">
		<cf_direccion action="insert" form="frmUsuarios" name="data2" data="#data2#">

		<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

		<cfset usuario = sec.crearUsuario(Session.Progreso.CEcodigo, data2.id_direccion, data1.datos_personales, form.LOCIdioma, expira, user, enviar_password)>
		<cfif isdefined("Form.rdGen") and Form.rdGen EQ "2">
			<cfset sec.renombrarUsuario(usuario, user, form.password)>
            <!--- Esto se tiene que dejar, ya que si el dueño de pso sabe el password de fulanito es un problema de seguridad, este update hace que apenas se firme el usuario
				le pida cambio de contraseña
			 --->
			<cfquery datasource="asp">
				update UsuarioPassword
				   set PasswordSet = <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1999,01,01)#">
				 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">
			</cfquery>
		<cfelseif isdefined("Form.rdGen") and Form.rdGen EQ "3">
			<cfset sec.renombrarUsuario(usuario, user, "")>
			<cfset sec.generarPassword( usuario, true)>
		</cfif>
	</cfif>
<cfelse>
	<!--- Eliminar Usuario --->
	<cfquery name="rsSelUsuario" datasource="asp">
		select id_direccion, datos_personales
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
	<cfif isdefined('rsSelUsuario') and rsSelUsuario.recordCount GT 0>
		<cfquery name="rsDelUsuPassw" datasource="asp">
			delete from UsuarioPassword
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		</cfquery>
		<cfquery name="rsDelUsuario" datasource="asp">
			delete from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		</cfquery>
		<cfquery name="rsDelDirecciones" datasource="asp">
			delete from Direcciones
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.id_direccion#">
		</cfquery>
		<cfquery name="rsDelDatPerson" datasource="asp">
			delete from DatosPersonales
			where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.datos_personales#">
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cflocation addtoken="no" url="/cfmx/asp/catalogos/Permisos.cfm?Usucodigo=#usuario#">
	<cfelseif form.accion EQ 2 or form.accion EQ 3 or form.accion EQ 4 or form.accion EQ 5>
		<cflocation url="/cfmx/asp/catalogos/Usuarios.cfm">
	</cfif>
</cfif>