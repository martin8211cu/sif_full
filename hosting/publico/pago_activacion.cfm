<!--- Inserta los datos personales --->
<cfquery datasource="asp" name="DPinserted">
	insert DatosPersonales (
		Pid, Pnombre, Papellido1, Papellido2, Pnacimiento,
		Psexo, Pcasa, Poficina, Pcelular, Pfax, Pemail1, 
		BMUsucodigo, BMfechamod)
	values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pnombre#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Papellido1#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Papellido2#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Session.UsuarioRegistro.Pnacimiento,'dd/mm/yyyy')#" null="#Len(Trim(Session.UsuarioRegistro.Pnacimiento)) EQ 0#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Psexo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Ptelnocturno#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pteldiurno#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pcelular#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pfax#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pemail1#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
		getdate())
	select @@identity as datos_personales
</cfquery>
<!--- Inserta la direccion --->
<cfquery datasource="asp" name="Dinserted">
	insert Direcciones (
		atencion, Ppais, direccion1, direccion2, ciudad, estado, codPostal,
		BMUsucodigo, BMfechamod)
	values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Session.UsuarioRegistro.Pnombre & ' ' & Session.UsuarioRegistro.Papellido1 & ' ' & Session.UsuarioRegistro.Papellido2)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Ppais#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pdireccion#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pdireccion2#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pciudad#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.Pprovincia#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.UsuarioRegistro.PcodPostal#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
		getdate())
	select @@identity as id_direccion
</cfquery>

<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
<cfset user = Session.UsuarioRegistro.Pemail1>
<cfset enviar_password = false>
<!--- Crear Usuario --->
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
<cfset usuario = sec.crearUsuario(Session.CEcodigo, Dinserted.id_direccion, DPinserted.datos_personales, Session.Idioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), user, enviar_password)>
<!--- Cambiar Password --->
<cfset sec.renombrarUsuario(usuario, user, Session.UsuarioRegistro.Ppassword)>
<!--- Asociar Referencia --->
<cfset ref = sec.insUsuarioRef(usuario, Session.UsuarioRegistro.EcodigoSDC, 'MEPersona', Session.UsuarioRegistro.MEpersona)>
<!--- AutoAfiliarse --->
<cfset Session.autoafiliado = usuario>

<!--- Enviar Correo --->
<cfset info = "">
<cfsavecontent variable="info">

	<cfif isdefined("rsInsert.donacion")>
		<cfset url.MEDdonacion = rsInsert.donacion>
	</cfif>
	<cfinclude template="pago_resumen_cont.cfm">

</cfsavecontent>

<cfmail from="SoyBautista.com administrator@soybautista.com" 
		to="#Session.UsuarioRegistro.Pemail1#"
		subject="Felicitaciones! Usted ha sido registrado en SoyBautista.com"
		type="html"
		>#info#</cfmail>

<cfset StructDelete(Session, "UsuarioRegistro")>
