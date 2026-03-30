<!--- Averiguar las Empresas dependiendo desde donde se accesa --->
<cfif isdefined("Form.btnRegistrar")>
	<cfset empresaARRAY = ListToArray(Form.Iglesia, '|')>
	<cfset empresa = empresaARRAY[2]>
	<cfset empresaSDCRegistro = empresaARRAY[1]>
<cfelse>
	<cfset empresa = session.Ecodigo>
	<cfset empresaSDCRegistro = session.EcodigoSDC>
</cfif>
		
<!--- Averiguar si se debe realizar un pago antes de Subscribirse --->
<cfquery name="rsParametroEmpresa" datasource="#Session.DSN#">
	select rtrim(Pvalor) as Pvalor
	from MEParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
	and Pcodigo = 10
</cfquery>
<cfset pago = rsParametroEmpresa.Pvalor>

<!--- Modo Registro de Persona --->
<cfif isdefined("Form.btnRegistrar") and (Not IsDefined("form.MEpersona") OR Len(Trim(Form.MEpersona)) EQ 0 or form.MEpersona EQ 0)>
	<cfquery name="ABC_Persona" datasource="#Session.DSN#">
		insert MEPersona 
		(	MEOid, cliente_empresarial, Ecodigo, Pnombre, Papellido1, Papellido2, Ppais, Icodigo, TIcodigo, Pid, 
			Pnacimiento, Psexo, Pemail1, Pemail2, Pweb, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, 
			Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMfechamod
		)
		select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">, 
			'LIC', 
			'0', 
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
	
<!--- Modo Cambio de Persona --->
<cfelseif isdefined("Form.btnGuardar") and isdefined("Form.MEpersona") and Len(Trim(Form.MEpersona)) NEQ 0>
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

<!--- Insercion del Usuario en el Framework, cuando se esta registrando sin pago --->
<cfif isdefined("Form.btnRegistrar") and pago NEQ 1>
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
	<!--- Asociar Referencia --->
	<cfset ref = sec.insUsuarioRef(usuario, empresaSDCRegistro, 'MEPersona', Form.MEpersona)>
	<!--- AutoAfiliarse --->
	<cfset Session.autoafiliado = usuario>
	<!--- FALTA ENVIAR EL CORREO DE REGISTRO --->


<!--- Modificacion del Usuario en el Framework en modo Cambio --->
<cfelseif isdefined("Form.btnGuardar") and IsDefined("session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
	<!--- Buscar Usuario según Codigo --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset datos_usuario = sec.getUsuarioByCod(Session.Usucodigo, Session.EcodigoSDC, 'MEPersona')>
	
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
	<!--- Si se esta registrando con Pago --->
	<cfif isdefined("Form.btnRegistrar") and pago EQ 1>
		<!--- Crear estructura en Session para pasarselo al Pago --->
		<cfif not isdefined("Session.UsuarioRegistro")>
			<cfset Session.UsuarioRegistro = StructNew()>
		</cfif>
		<cfset StructInsert(Session.UsuarioRegistro, "Ecodigo", empresa, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "EcodigoSDC", empresaSDCRegistro, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "MEpersona", Form.MEpersona, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "MEOid", Form.MEOid, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pnombre", Form.Pnombre, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Papellido1", Form.Papellido1, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Papellido2", Form.Papellido2, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Ppais", Form.Ppais, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pnacimiento", Form.Pnacimiento, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Psexo", Form.Psexo, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pemail1", Form.Pemail1, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pdireccion", Form.Pdireccion, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pdireccion2", Form.Pdireccion2, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pciudad", Form.Pciudad, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pprovincia", Form.Pprovincia, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "PcodPostal", Form.PcodPostal, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Ptelnocturno", Form.Ptelnocturno, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pteldiurno", Form.Pteldiurno, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pcelular", Form.Pcelular, true)>
		<cfset StructInsert(Session.UsuarioRegistro, "Pfax", Form.Pfax, true)>
		
		<cfset StructInsert(Session.UsuarioRegistro, "Ppassword", Form.Ppassword, true)>
		
		<form action="../pago_registro.cfm" method="get">
		</form>

	<!--- Si se esta registrando sin Pago --->
	<cfelseif isdefined("Form.btnRegistrar") and pago NEQ 1>
		<form action="afiliacion-gracias.cfm" method="post">
			<cfloop collection="#Form#" item="i">
				<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
			</cfloop>
		</form>

	<!--- Si esta en modo CAMBIO --->
	<cfelse>
		<form action="afiliacion.cfm" method="post">
		</form>
	</cfif>
</cfoutput>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
