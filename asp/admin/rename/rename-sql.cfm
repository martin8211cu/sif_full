<cfset status = 0>
<cfset error = ''>

<cfif IsDefined('form.rename')>
	<!--- 1. Validacion de no existencia del nuevo login --->
	<cfquery name="existe_login" datasource="asp">
		select 1
		from Usuario 
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
		  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.newlogin)#">
	</cfquery>
	
	<cfif existe_login.recordcount eq 0>
		<!--- 	2. 	Valida existencia del email del usuario.
					Si no existe o es diferente al digitado, modifica el email del usuario.
		 --->
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
	
		<!--- 3. Cambia login del usuario y le genera un nuevo password --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset usuario = sec.renombrarUsuario(form.usucodigo, form.newlogin, '') >
		<cfset usuario = sec.generarPassword( form.Usucodigo, true ) >
		<cfset status = 'El usuario ha sido renombrado y se le ha generado una nueva contraseña'>
		<cfset error = 0>
	<cfelse>
		<cfset status = 'Existe un usuario con login #form.newlogin#, por favor digite otro login.'>
		<cfset error = 1>
	</cfif>
</cfif>


<cfset params = '' >
<cfif isdefined("form.ctaemp") and len(trim(form.ctaemp)) ><cfset params = params & '&ctaemp=#URLEncodedFormat(form.ctaemp)#'></cfif>
<cfif isdefined("form.s_login") and len(trim(form.s_login)) ><cfset params = params & '&s_login=#URLEncodedFormat(form.s_login)#'></cfif>
<cfif isdefined("form.s_nombre") and len(trim(form.s_nombre)) ><cfset params = params & '&s_nombre=#URLEncodedFormat(form.s_nombre)#'></cfif>				
<cfif isdefined("form.s_email") and len(trim(form.s_email)) ><cfset params = params & '&s_email=#URLEncodedFormat(form.s_email)#'></cfif>		
<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) ><cfset params = params & '&pageNum_lista=#form.pageNum_lista#'></cfif>		

<cflocation url="rename.cfm?Usucodigo=#form.Usucodigo#&error=#error#&msg=#URLEncodedFormat(status)##params#">