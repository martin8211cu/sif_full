<cfif isdefined("Form.MEpersona") and Len(Trim(Form.MEpersona)) NEQ 0 and Form.MEpersona NEQ 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif modo EQ "ALTA">
	<cfquery name="ABC_Persona" datasource="#Session.DSN#">
		insert MEPersona 
		(	MEOid, cliente_empresarial, Ecodigo, Pnombre, Papellido1, Papellido2, Ppais, Icodigo, TIcodigo, Pid, 
			Pnacimiento, Psexo, Pemail1, Pemail2, Pweb, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, 
			Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMfechamod
		)
		select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">, 
			'LIC', 
			'', 
			convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.Pnacimiento, 'YYYYMMDD')#">),
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
			null, 
			null, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ptelnocturno#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pteldiurno#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#">, 
			null, 
			null, 
			null, 
			null, 
			null, 
			1,
			convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Now(), 'YYYYMMDD')#">)
			
		select convert(varchar, @@identity) as MEpersona
	</cfquery>
	<cfset form.MEpersona = ABC_Persona.MEpersona>
<cfelse>
	<cfquery datasource="#Session.DSN#">
		update MEPersona
		set MEOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOid#">, 
			Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">, 
			Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">, 
			Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">, 
			Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">, 
			Pnacimiento = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.Pnacimiento, 'YYYYMMDD')#">),
			Psexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">, 
			Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#">, 
			Pdireccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#">, 
			Pciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#">, 
			Pprovincia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#">, 
			PcodPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#">, 
			Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ptelnocturno#">, 
			Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pteldiurno#">, 
			Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#">, 
			Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#">
		where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
</cfif>

<!--- Insercion o Actualizacion del Usuario en el Framework  --->
<cfif modo EQ 'ALTA' and isdefined("Form.chkGenerar")>

	<!--- Inserta los datos personales --->
	<cfquery datasource="asp" name="DPinserted">
		insert DatosPersonales (
			Pid, Pnombre, Papellido1, Papellido2, Pnacimiento,
			Psexo, Pcasa, Poficina, Pcelular, Pfax, Pemail1, 
			BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.Pnacimiento,'dd/mm/yyyy')#" null="#Len(Trim(Form.Pnacimiento)) EQ 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ptelnocturno#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pteldiurno#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">,
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
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Pnombre & ' ' & Form.Papellido1 & ' ' & Form.Papellido2)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
			getdate())
		select @@identity as id_direccion
	</cfquery>

	<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
	<cfset user = Form.Pemail1>
	<cfset enviar_password = false>
	<!--- Crear Usuario --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset usuario = sec.crearUsuario(Session.CEcodigo, Dinserted.id_direccion, DPinserted.datos_personales, Session.Idioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), user, enviar_password)>
	<!--- Cambiar Password --->
	<cfset sec.renombrarUsuario(usuario, user, Form.Ppassword)>
	<!--- Enviar usuario y password por Correo --->
	<cfset sec.enviarPassword(usuario, Form.Ppassword, true)>
	<!--- Asociar Referencia --->
	<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'MEPersona', Form.MEpersona)>


<cfelseif modo EQ 'CAMBIO' and isdefined("Form.haveUsr") and Form.haveUsr EQ '1'>
	<!--- Buscar Usuario según Codigo --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset datos_usuario = sec.getUsuarioByRef(Form.MEpersona, Session.EcodigoSDC, 'MEPersona')>
	
	<cfif datos_usuario.recordCount GT 0>
		<!--- Modificar Datos del Usuario en el Framework --->
		<!--- Modificar los datos personales --->
		<cfquery datasource="asp" name="DPupdated">
			update DatosPersonales
			set Pid         = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
				Pnombre     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">,
				Papellido1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">,
				Papellido2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">,
				Pnacimiento = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.Pnacimiento,'dd/mm/yyyy')#" null="#Len(Trim(Form.Pnacimiento)) EQ 0#">,
				Psexo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">,
				Pcasa       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ptelnocturno#">,
				Poficina    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pteldiurno#">,
				Pcelular    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#">,
				Pfax        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				BMfechamod = getdate()
			where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.datos_personales#">
		</cfquery>
		<!--- Modificar la direccion --->
		<cfquery datasource="asp" name="updated">
			update Direcciones
			set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Pnombre & ' ' & Form.Papellido1 & ' ' & Form.Papellido2)#">,
				Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">, 
				direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#">,
				direccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#">,
				ciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#">, 
				estado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#">, 
				codPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#">, 
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfechamod = getdate()
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.id_direccion#">
		</cfquery>
	</cfif>

</cfif>

<cfoutput>
	<cfif isdefined("Form.btnRegistrar")>
		<cfset action = "afiliacion-gracias.cfm">
	<cfelse>
		<cfset action = "afiliacion.cfm">
	</cfif>
	<form action="#action#" method="post">
		<cfif isdefined("Form.btnRegistrar")>
			<cfloop collection="#Form#" item="i">
				<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
			</cfloop>
		</cfif>
	</form>
</cfoutput>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
