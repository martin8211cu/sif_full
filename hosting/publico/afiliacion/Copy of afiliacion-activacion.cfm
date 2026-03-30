<cffunction name="CambiaPassw" access="public" returntype="string" output="true">
	<!--- devuelve true si hay un error, false si todo sale bien --->
	<cfargument name="loginn" type="string" required="false" default="">
	<cfargument name="passw" type="string" required="false" default="">

	<cfif not isdefined('__afilia')>
		<!--- Instanciacion del EJB --->
		<cftry>
				<cfobject action="create" name="ctx"  type="java" class="javax.naming.Context">
				<cfobject action="create" name="prop" type="java" class="java.util.Properties">
				
				<cfset prop.init()>
				<cfset prop.put(ctx.SECURITY_PRINCIPAL, 'guest')>
				<cfset prop.put(ctx.SECURITY_CREDENTIALS, 'guest')>
				<cfobject action="create" name="initContext" type="java" class="javax.naming.InitialContext">
				<cfset initContext.init(prop)>
				<cfset homeAfilia = initContext.lookup("SdcSeguridad/Afiliacion")>
				
				<cfset __afilia = homeAfilia.create()>
			<cfcatch>
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfreturn true>
			</cfcatch>
		</cftry>
	</cfif>
	<cfif Len(Trim(loginn)) NEQ 0 and Len(Trim(passw)) NEQ 0>
		<!--- cambia el password --->
		<cftry>
			<cfset __afilia.cambiaPassword(loginn, passw)>
		<cfcatch type="any">
			<cfreturn true>
		</cfcatch>
		</cftry>
	</cfif>
	<cfreturn false>	
</cffunction>


<cfif isdefined("Form.btnRegistrar")>
	<!--- Averiguar el ambito de login de la cuenta empresarial --->
	<cfquery name="rsAmbito" datasource="asp">
		select ambitoLogin
		from CuentaClienteEmpresarial
		where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.cecodigo#">
	</cfquery>
	<cfif rsAmbito.ambitoLogin EQ 'C'>
		<cfset NewUsulogin = Form.Pemail1 & '%' & Session.cecodigo>
	<cfelse>
		<cfset NewUsulogin = Form.Pemail1>
	</cfif>
</cfif>

	<cftransaction>
		<!--- <cftry> --->
			<cfif isdefined("Form.btnRegistrar")>
				<cfset empresaARRAY = ListToArray(Form.Iglesia, '|')>
				<cfset empresa = empresaARRAY[2]>
				<cfset empresaSDCRegistro = empresaARRAY[1]>
			<cfelse>
				<cfset empresa = session.Ecodigo>
				<cfset empresaSDCRegistro = session.EcodigoSDC>
			</cfif>
			
			<cfif Not IsDefined("form.MEpersona") OR Len(Form.MEpersona) EQ 0 or form.MEpersona EQ 0>
				<cfquery name="ABC_Persona" datasource="#Session.DSN#">
					insert MEPersona 
					(	MEOid, cliente_empresarial, Ecodigo, Pnombre, Papellido1, Papellido2, Ppais, Icodigo, TIcodigo, Pid, 
						Pnacimiento, Psexo, Pemail1, Pemail2, Pweb, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, 
						Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMfechamod
					)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.cecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">, 
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
					and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.cecodigo#">
				</cfquery>
			</cfif>
			
			<cfif IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0 and
				  Len(Trim(session.MEpersona)) EQ 0> 
				
				<!--- Pasarlo de Empresa --->
				<!--- Darle el rol --->
				<cfinvoke 
				 component="sif.rh.Componentes.usuarios"
				 method="add_rol"
				 returnvariable="UsrInserted">
					<cfinvokeargument name="cliente_empresarial" value="#Session.sitio.cliente_empresarial#"/>
					<cfinvokeargument name="Ecodigo" value="#empresaSDCRegistro#"/>
					<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
					<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
					<cfinvokeargument name="referencias" value="#form.MEpersona#"/>
					<cfinvokeargument name="roles" value="me.afiliado"/>
					<cfinvokeargument name="activacion" value="1"/>
				</cfinvoke>
			</cfif> 
			
			<!--- Insercion del Usuario en el Framework --->
			<cfinvoke 
			 component="sif.rh.Componentes.usuarios"
			 method="upd_usuario"
			 returnvariable="UsrInserted">
				<cfinvokeargument name="consecutivo" value="#empresa#"/>
				<cfinvokeargument name="sistema" value="me"/>
				<cfinvokeargument name="referencias" value="#form.MEpersona#"/>
				<cfinvokeargument name="roles" value="me.afiliado"/>
				<cfinvokeargument name="activacion" value="1"/>
				<cfinvokeargument name="Pnombre" value="#form.Pnombre#"/>
				<cfinvokeargument name="Papellido1" value="#form.Papellido1#"/>
				<cfinvokeargument name="Papellido2" value="#form.Papellido2#"/>
				<cfinvokeargument name="Ppais" value="#form.Ppais#"/>
				<cfinvokeargument name="TIcodigo" value="LIC"/>
				<cfinvokeargument name="Pid" value=""/>
				<cfinvokeargument name="Pnacimiento" value="#Form.Pnacimiento#"/>
				<cfinvokeargument name="Psexo" value="#Form.Psexo#"/>
				<cfinvokeargument name="Pemail1" value="#Form.Pemail1#"/>
				<cfinvokeargument name="Pemail2" value=""/>
				<cfinvokeargument name="Pdireccion" value="#Form.Pdireccion#"/>
				<cfinvokeargument name="Pcasa" value="#Form.Ptelnocturno#"/>
				<cfinvokeargument name="Poficina" value="#Form.Pteldiurno#"/>
				<cfinvokeargument name="Pcelular" value="#Form.Pcelular#"/>
				<cfinvokeargument name="Pfax" value="#Form.Pfax#"/>
				<cfinvokeargument name="Ppagertel" value=""/>
				<cfinvokeargument name="Ppagernum" value=""/>
				<cfinvokeargument name="Pciudad" value="#Form.Pciudad#"/>
				<cfinvokeargument name="Pprovincia" value="#Form.Pprovincia#"/>
				<cfinvokeargument name="PcodPostal" value="#Form.PcodPostal#"/>
				<!---
				<cfinvokeargument name="upd_referencia" value="#Form.MEpersona#"/>
				<cfinvokeargument name="upd_rol" value="me.afiliado"/>
				--->
				<cfinvokeargument name="dominio_roles" value="no_borrar"/> <!--- para que no borre nada --->
				<cfinvokeargument name="modificar_usuario_activo" value="true"/>
			</cfinvoke>

			<cfif (Len(session.Usucodigo) EQ 0 or session.Usucodigo is 0) and IsDefined("form.Ppassword")>
				<cfquery name="rsUpdUsuario" datasource="#Session.DSN#">
					update Usuario
					set Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
						Usueplogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
						Usutemporal = 0
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsrInserted.Usucodigo#">
					and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#UsrInserted.Ulocalizacion#">
					and Usutemporal = 1
				</cfquery>
				
				<cfscript>
					CambiaPassw(NewUsulogin, Form.Ppassword);
				</cfscript>

				<cfset Session.autoafiliado = Form.Pemail1>
				
				<!--- Enviar el Correo de Confirmación de Registro --->
				<cfquery name="enviarCorreo" datasource="asp">
					insert SMTPQueue(SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="SoyBautista.com<administrator@soybautista.com>">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Felicitaciones! Usted ha sido registrado en SoyBautista.com">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value=" 
						<html>
						<head>
						<title>SoyBautista.com</title>
						</head>
						
						<body>
						Bienvenido a SoyBautista.com!<br>
						<br>
						Este mensaje de confirmaci&oacute;n es enviado a todos los usuarios <br>
						que acaban de Subscribirse al portal de SoyBautista.com<br>
						<br>
						Usted ha sido registrado con la cuenta <strong>#Form.Pemail1#</strong><br>
						Por favor, no responda a este mensaje.<br>
						<br>
						Para ingresar con su cuenta acceda al sitio <strong>http://www.soybautista.com</strong><br>
						</body>
						</html>">,
						1
					)
				</cfquery>
				
			</cfif>
<!---
			<cfcatch type="any">
				<cftransaction action="rollback">
				<cfinclude template="/sif/errorpages/BDerror.cfm">
				<cfabort>
				
			</cfcatch>
		</cftry>--->
	</cftransaction>

<cfoutput>
<cfif isdefined("Form.btnRegistrar")>
	<!--- Averiguar parametro en la empresa para saber si se redirecciona a pago de registro --->
	<cfquery name="rsParametroEmpresa" datasource="#Session.DSN#">
		select Pvalor 
		from MEParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
		and Pcodigo = 10
	</cfquery>
	<cfif rsParametroEmpresa.Pvalor EQ 1>
		<form action="../pago_registro.cfm" method="get">
		</form>
	<cfelse>
		<cfset action = "afiliacion-gracias.cfm">
		<form action="#action#" method="post">
			<cfif isdefined("Form.btnRegistrar")>
				<cfloop collection="#Form#" item="i">
					<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
				</cfloop>
			</cfif>
		</form>
	</cfif>
<cfelse>
	<cfset action = "afiliacion.cfm">
	<form action="#action#" method="post">
		<cfif isdefined("Form.btnRegistrar")>
			<cfloop collection="#Form#" item="i">
				<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
			</cfloop>
		</cfif>
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
