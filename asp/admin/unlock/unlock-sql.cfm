<cfset status = ''>
<cfif form.Usucodigo is 1>
	<cflocation url="unlock.cfm">
</cfif>

<cfquery datasource="asp" name="usuario">
	select p.Pemail1, p.datos_personales
	from Usuario u
		join DatosPersonales p
			on u.datos_personales = p.datos_personales
	where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
</cfquery>

<cfif Trim(form.email) neq Trim(usuario.Pemail1)>
	<cfquery datasource="asp">
		update DatosPersonales
		set Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
		where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario.datos_personales#">
	</cfquery>
</cfif>
<cfif IsDefined('form.lock')>
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	
	<cfset sesion_bloqueo_cant      = Politicas.trae_parametro_global("sesion.bloqueo.cant")>
	<cfset sesion_bloqueo_duracion  = Politicas.trae_parametro_global("sesion.bloqueo.duracion")>
	<cfset sesion_bloqueo_periodo   = Politicas.trae_parametro_global("sesion.bloqueo.periodo")>
	
	<cfif sesion_bloqueo_duracion>
		<cfset LIbloqueo = DateAdd('n', sesion_bloqueo_duracion, Now())>
		<cfquery datasource="aspmonitor">
			insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LIbloqueo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Usuario bloqueado por el administrador">, 0)
		</cfquery>
	<cfelse>
		<cfquery datasource="asp">
			update UsuarioPassword
			set AllowedAccess = 0
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.Usucodigo#">
			  and AllowedAccess = 1
		</cfquery>
	</cfif>
	<cfset status = 'El usuario ha sido bloqueado'>
<cfelseif IsDefined('form.unlock') or IsDefined('form.send')>
	<cfquery datasource="aspmonitor">
		update UsuarioBloqueo
		set desbloqueado = 1
		where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.Usucodigo#">
		  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.CEcodigo#">
		  and desbloqueado = 0
	</cfquery>
	<cfquery datasource="asp">
		update UsuarioPassword
		set AllowedAccess = 1
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.Usucodigo#">
		  and AllowedAccess = 0
	</cfquery>
	<cfif IsDefined('form.send')>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfif sec.generarPassword(form.Usucodigo, true)>
			<cfset status = 'Se ha enviado una nueva contraseña al usuario'>
		<cfelse>
			<cfset status = 'Ocurrió un error enviando la contraseña'>
		</cfif>
	<cfelse>
		<cfset status = 'El usuario ha sido desbloqueado'>
	</cfif>
<cfelseif IsDefined('form.send')>

	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfif sec.generarPassword(form.Usucodigo, true)>
		<cfset status = 'Se ha enviado una nueva contraseña al usuario'>
	<cfelse>
		<cfset status = 'Ocurrió un error enviando la contraseña'>
	</cfif>
</cfif>
<cflocation url="unlock.cfm?Usucodigo=#form.Usucodigo#&msg=#URLEncodedFormat(status)#">
