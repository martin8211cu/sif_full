<cfparam name="session.Usucodigo" default="0" type="numeric">
<cfparam name="form.email" default="">
<cfparam name="form.nombre" default="">
<cfparam name="form.apellido1" default="">
<cfparam name="form.apellido2" default="">
<cfparam name="form.pass" default="">
<cfparam name="form.pass2" default="">

<cfset form.email = Trim(form.email)>
<cfset form.pass  = Trim(form.pass)>
<cfset form.pass2 = Trim(form.pass2)>
<cfif Len(form.email) Is 0>
	<cfthrow message="Debe especificar un correo electrónico.">
</cfif>
<cfif REFind('^.+@.+\...+$', form.email) Is 0>
	<cfthrow message="Correo inválido: #HTMLEditFormat(form.email)#">
</cfif>
<cfif Len(form.pass) Is 0>
	<cfthrow message="Debe especificar una contraseña">
</cfif>
<cfif form.pass neq form.pass2>
	<cfthrow message="Debe especificar la misma contraseña en ambas casillas.<br>Este control le asegura que introdujo la contraseña que usted desea.">
</cfif>


<cfquery datasource="#session.dsn#" name="emp">
	select cliente_empresarial as CEcodigo
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

<cfif session.Usucodigo Is 0>
	<cfquery datasource="asp" name="dup">
		select 1
		from Usuario
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp.CEcodigo#">
		  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
	</cfquery>
	<cfif dup.RecordCount>
		<cflocation url="duplicado.cfm?email=#URLEncodedFormat(form.email)#">
	</cfif>

	<cf_datospersonales action="new" name="datos_personales">
	<cfset datos_personales.nombre = form.nombre>
	<cfset datos_personales.apellido1 = form.apellido1>
	<cfset datos_personales.apellido2 = form.apellido2>
	<cfset datos_personales.email1 = form.email>
	<cf_datospersonales action="update" data="#datos_personales#" name="datos_personales">

	<cf_direccion action="new" name="direccion">
	<cfset direccion.atencion = form.nombre & ' ' & form.apellido1 & ' ' & form.apellido2>
	<cf_direccion action="update" data="#direccion#" name="direccion">
	
	<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
	<!--- Crear Usuario --->
	<cfset idioma = "">
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset NuevoUsucodigo = sec.crearUsuario(emp.CEcodigo, direccion.id_direccion,
		datos_personales.datos_personales, idioma,
		ParseDateTime('01/01/6100','dd/mm/yyyy'), form.email, false)>
	<!--- Cambiar Password --->
	<cfset sec.renombrarUsuario(NuevoUsucodigo, form.email, form.pass)>
	
	<!--- AutoAfiliarse --->
	<cfset Session.autoafiliado = NuevoUsucodigo>
	<!--- FALTA ENVIAR EL CORREO DE REGISTRO --->
<cfelse>
	Usuario ya esta registrado, bienvenido
</cfif>
<cflocation url="gracias.cfm">