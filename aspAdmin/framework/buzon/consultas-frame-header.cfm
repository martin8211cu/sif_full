<cfset roles = "edu.admin, edu.docente, edu.estudiante, edu.encargado, edu.asistente, edu.director">
<cfset rolesDesc = "Administrador del Centro de Estudios, Docente, Estudiante, Padre de Familia o Encargado, Asistente, Director">
<cfset rolCod = "4, 5, 6, 7, 11, 12">
<cfset tabChoice = 1>

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>

<cfquery name="rolesUsr" datasource="#Session.DSN#">
	select distinct b.rol
	from UsuarioEmpresarial a, UsuarioEmpresa d, EmpresaID e, UsuarioPermiso b, Rol c, Empresa f, CuentaClienteEmpresarial g
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	  and e.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Usucodigo = d.Usucodigo
	  and a.Ulocalizacion = d.Ulocalizacion
	  and a.cliente_empresarial = d.cliente_empresarial
	  and a.activo = 1
	  and d.activo = 1
	  and d.Ecodigo = f.Ecodigo
	  and d.cliente_empresarial = f.cliente_empresarial
	  and f.activo = 1
	  and e.Ecodigo = f.Ecodigo
	  and e.sistema = 'edu'
	  and e.consecutivo is not null
	  and e.nombre_cache is not null
	  and e.activo = 1
	  and b.Usucodigo = d.Usucodigo
	  and b.Ulocalizacion = d.Ulocalizacion
	  and b.cliente_empresarial = d.cliente_empresarial
	  and b.Ecodigo = d.Ecodigo
	  and b.activo = 1
	  and b.rol = c.rol
	  and c.sistema = e.sistema
	  and c.activo = 1
	  and f.cliente_empresarial = g.cliente_empresarial
	  and g.activo = 1
</cfquery>

<!--- Si la Session.RolActual no existe, tiene un rol que no corresponde a ninguno de educacion o que no le corresponde se carga un rol por defecto --->
<cfif not isdefined("Session.RolActual") 
       or ListFind(Replace(rolCod, ' ' , '', 'all'), Session.RolActual, ',') EQ 0 
	   or ListFind(Replace(ValueList(rolesUsr.rol, ','), ' ', '', 'all'), 
	               Trim(
				   		ListGetAt(roles, ListFind(Replace(rolCod, ' ' , '', 'all'), Session.RolActual, ','), ',')
				   ), 
				   ',') EQ 0>
	<cfif rolesUsr.recordCount GT 0>
		<cfif Trim(rolesUsr.rol) EQ 'edu.admin'>
			<cfset Session.RolActual = 4>
		<cfelseif Trim(rolesUsr.rol) EQ 'edu.docente'>
			<cfset Session.RolActual = 5>
		<cfelseif Trim(rolesUsr.rol) EQ 'edu.estudiante'>
			<cfset Session.RolActual = 6>
		<cfelseif Trim(rolesUsr.rol) EQ 'edu.encargado'>
			<cfset Session.RolActual = 7>
		<cfelseif Trim(rolesUsr.rol) EQ 'edu.asistente'>
			<cfset Session.RolActual = 11>
		<cfelseif Trim(rolesUsr.rol) EQ 'edu.director'>
			<cfset Session.RolActual = 12>
		</cfif>
	</cfif>
</cfif>

<cfif isdefined("Form.rol") and ListFind(Replace(ValueList(rolesUsr.rol, ','), ' ', '', 'all'), Form.rol, ',') NEQ 0>
	<cfif Trim(Form.rol) EQ 'edu.admin'>
		<cfset Session.RolActual = 4>
	<cfelseif Trim(Form.rol) EQ 'edu.docente'>
		<cfset Session.RolActual = 5>
	<cfelseif Trim(Form.rol) EQ 'edu.estudiante'>
		<cfset Session.RolActual = 6>
	<cfelseif Trim(Form.rol) EQ 'edu.encargado'>
		<cfset Session.RolActual = 7>
	<cfelseif Trim(Form.rol) EQ 'edu.asistente'>
		<cfset Session.RolActual = 11>
	<cfelseif Trim(Form.rol) EQ 'edu.director'>
		<cfset Session.RolActual = 12>
	</cfif>
</cfif>
