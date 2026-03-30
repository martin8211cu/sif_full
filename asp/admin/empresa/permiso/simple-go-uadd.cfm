<!--- Crear usuario --->
<cfset expira = CreateDate(6100,1,1)>

<cfset user = form.username>
<cfset enviar_password = Len(form.password) is 0>
<cfset password = form.password>
<cfset idiomaUsuario = ''>
<cfquery name="checkUserExists" datasource="asp">
	select Usucodigo, Usulogin, datos_personales
	from Usuario
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
	<cfif Len(form.usucodigo)>
	and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">
	<cfelse>
	and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user#">
	</cfif>
</cfquery>

<!--- Validar nuevo usuario y contraseña tanto en alta como en cambio --->
<cfif Len(form.username) and Len(form.password)>
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta"
		CEcodigo="#session.simple._ctaemp#" returnvariable="dataPoliticas"/>
	<cfinvoke component="home.Componentes.ValidarPassword" method="validar" data="#dataPoliticas#"
		user="#user#" pass="#form.password#" returnvariable="valida"/>
	<cfif ArrayLen(valida.erruser) Or ArrayLen(valida.errpass)>
		<cfset msgvalida = 'Se detectaron los siguientes errores: '>
			<cfloop from="1" to="#ArrayLen(valida.erruser)#" index="i">
				<cfset msgvalida = msgvalida & '<li>#(valida.erruser[i] )#'>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(valida.errpass)#" index="i">
				<cfset msgvalida = msgvalida & '<li>#(valida.errpass[i] )#'>
			</cfloop>
		</script>
		<cfthrow message="#msgvalida#">
	</cfif>
</cfif>

<cfif Len(form.usucodigo)>
	<!--- modificar usuario existente --->
	<cfif Not checkUserExists.RecordCount>
		<cfthrow message="El usuario NO existe">
	</cfif>
	<cfif (form.username neq checkUserExists.Usulogin) and Not Len(form.password)>
		<cfthrow message="Si se cambia el usuario, hay que especificar nuevamente el password">
	</cfif>
	<cfquery datasource="asp">
		update DatosPersonales
		set Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
		    Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido1#">,
		    Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email1#">
		where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#checkUserExists.datos_personales#">
	</cfquery>
	<cfif (form.username neq checkUserExists.Usulogin)>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset sec.renombrarUsuario(form.usucodigo, user, form.password)>
	</cfif>
<cfelse>
	<cfif checkUserExists.RecordCount>
		<cfthrow message="El usuario ya existe">
	</cfif>
	
	<!--- Inserta los datos personales --->
	<!---<cfset StructAppend(form, url)>--->
	<cf_datospersonales action="readform" name="data1">
	<cfif Not Len(data1.nombre)>
		<cfset data1.nombre = user>
	</cfif>
	<cf_datospersonales action="insert" name="data1" data="#data1#">
	<!--- Inserta la direccion --->
	<cf_direccion action="readform" name="data2">
	<cf_direccion action="insert" name="data2" data="#data2#">
	
	<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	
	<cfset usuario = sec.crearUsuario(session.simple._ctaemp, data2.id_direccion,
		data1.datos_personales, idiomaUsuario, expira, user, enviar_password)>
	<cfset sec.renombrarUsuario(usuario, user, password)>
</cfif>
<cflocation url="simple.cfm?reload&hideuser">