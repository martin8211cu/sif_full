<cffunction name="fnSendMessage" returntype="string">
  <cfargument name="LprmSubject"        	type="string" required="true">	<!--- Asunto del Mensaje --->
  <cfargument name="LprmMessage"        	type="string" required="true"> <!--- Mensaje --->
  <cfargument name="LprmFrom"      			type="string" required="false" default=""> <!--- Remitente --->
  <cfargument name="LprmTo"      			type="string" required="false" default=""> <!--- Destinatario --->
  <cfargument name="LprmUsucodigo"      	type="string" required="false" default=""> <!--- Usuario Destinatario --->
  <cfargument name="LprmUlocalizacion"  	type="string" required="false" default=""> <!--- Localizacion Destinatario --->
  <cfargument name="LprmGroup"  			type="query" required="false"> <!--- Conjunto de Usuarios --->
  <cfargument name="LprmToCol"      		type="string" required="false" default=""> <!--- Columna en el query que contiene Destinatario --->
  <cfargument name="LprmKind"           	type="string"  required="false" default="B"> <!--- Tipo de Mensaje a Enviar: A - Ambos, B - Buzón, C - Correo, P - con Prioridad al Buzon y luego al Correo si no es posible --->
  <cfargument name="LprmUsarPantallaError"  type="boolean" required="false" default="false"> <!--- Usar Pantalla de Error --->
 
	<cfset LvarTblError = "">
	<cfset UsuariosNoEnviados = "">
	<cfset LprmTo2 = LprmTo>
 	<!--- Inicializacion de Componentes --->
	<cftry>
		<cfobject action="create" name="ctx"  type="java" class="javax.naming.Context">

		<cfobject action="create" name="prop" type="java" class="java.util.Properties">
		<cfset prop.init()>
		<cfset prop.put(ctx.INITIAL_CONTEXT_FACTORY, "com.sybase.ejb.InitialContextFactory")>
		<cfset prop.put(ctx.PROVIDER_URL, Session.PROVIDER_URL)>
		<cfset prop.put(ctx.SECURITY_PRINCIPAL, Session.SECURITY_PRINCIPAL)>
		<cfset prop.put(ctx.SECURITY_CREDENTIALS, Session.SECURITY_CREDENTIALS)>

		<cfobject action="create" name="initContext" type="java" class="javax.naming.InitialContext">
		<cfset initContext.init(prop)>
		<cfset home = initContext.lookup("utilitarios/Mensajeria")>
		<cfset Mensajeria = home.create()>

		<cfobject action="create" name="BigDecimal" type="java" class="java.math.BigDecimal">
	<cfcatch type="any">
		<cfset LvarTblError = "fnSendMessage: Error al utilizar Servidor de correos<br><br>" & cfcatch.Message>
		<cfif LprmUsarPantallaError>
			<cfset LvarURL = "/cfmx/edu/errorPages/BDerror.cfm?errType=0&errMsg=" & urlencodedformat(LvarTblError)>
			<cflocation addtoken="no" url="#LvarURL#">
		</cfif>
		<cfreturn LvarTblError>
	</cfcatch>
	</cftry>

	<!--- Envio de Mensajes --->
	<cfif isdefined("LprmGroup") and LprmGroup.recordCount GT 0>

		<cfset UsrOrigen = BigDecimal.init(Session.Edu.Usucodigo)>
		<cfset Consecutivo = BigDecimal.init(Session.Edu.CEcodigo)>
		<cfloop query="LprmGroup">
			<cfset UsrDestino = BigDecimal.init(LprmGroup.Usucodigo)>
			<cfif Len(Trim(LprmToCol)) NEQ 0>
				<cfset LprmTo2 = Evaluate("LprmGroup." & LprmToCol)>
			</cfif>

			<cfif isdefined("LprmGroup.activo") and LprmGroup.activo EQ 1 and isdefined("LprmGroup.Usutemporal") and LprmGroup.Usutemporal EQ 0>
				<!--- Mensaje al Buzon --->
				<cfif LprmKind EQ "A" or LprmKind EQ "B" or LprmKind EQ "P">
					<cftry>
						<cfscript>
							Mensajeria.sendToBuzon(UsrDestino,
												   LprmGroup.Ulocalizacion,
												   LprmFrom,
												   LprmTo2,
												   LprmSubject,
												   LprmMessage,
												   "4",
												   UsrOrigen,
												   Session.Ulocalizacion);
						</cfscript>
						<cfset EnviadoAlBuzon = true>
					<cfcatch type="any">
						<cfset EnviadoAlBuzon = false>
						<cfif LprmKind EQ "A" and LprmKind NEQ "P">
							<cfset UsuariosNoEnviados = UsuariosNoEnviados & Iif(UsuariosNoEnviados NEQ "",DE(","),DE("")) & LprmGroup.Usucodigo >
						</cfif>
					</cfcatch>
					</cftry>
				</cfif>
			<!--- Si el usuario no esta activo no se envia el mensaje al buzon --->
			<cfelse>
				<cfset EnviadoAlBuzon = false>
				<cfif LprmKind NEQ "A" and LprmKind NEQ "P">
					<cfset UsuariosNoEnviados = UsuariosNoEnviados & Iif(UsuariosNoEnviados NEQ "",DE(","),DE("")) & LprmGroup.Usucodigo >
				</cfif>
			</cfif>
			<!--- Mensaje al Correo --->
			<cfif LprmKind EQ "A" or LprmKind EQ "C" or (LprmKind EQ "P" and not EnviadoAlBuzon)>
				<cftry>
					<cfscript>
						Mensajeria.sendHtmlEmail("edu", 
												 UsrDestino,
												 LprmGroup.Ulocalizacion,
												 Consecutivo,
												 LprmSubject,
												 LprmMessage,
												 UsrOrigen,
												 Session.Ulocalizacion,
												 Consecutivo);
					</cfscript>
				<cfcatch type="any">
					<cfset UsuariosNoEnviados = UsuariosNoEnviados & Iif(UsuariosNoEnviados NEQ "",DE(","),DE("")) & LprmGroup.Usucodigo >
				</cfcatch>
				</cftry>
			</cfif>
				
		</cfloop>

	<cfelseif Len(Trim(LprmUsucodigo)) NEQ 0 and Len(Trim(LprmUlocalizacion)) NEQ 0>

		<cfset UsrDestino = BigDecimal.init(LprmUsucodigo)>
		<cfset UsrOrigen = BigDecimal.init(Session.Edu.Usucodigo)>
		<cfset Consecutivo = BigDecimal.init(Session.Edu.CEcodigo)>
		<!--- Mensaje al Buzon --->
		<cfif LprmKind EQ "A" or LprmKind EQ "B" or LprmKind EQ "P">
			<cftry>
				<cfscript>
					Mensajeria.sendToBuzon(UsrDestino,
										   LprmUlocalizacion,
										   LprmFrom,
										   LprmTo2,
										   LprmSubject,
										   LprmMessage,
										   "4",
										   UsrOrigen,
										   Session.Ulocalizacion);
				</cfscript>
				<cfset EnviadoAlBuzon = true>
			<cfcatch type="any">
				<cfset EnviadoAlBuzon = false>
				<cfif LprmKind NEQ "A" and LprmKind NEQ "P">
					<cfset UsuariosNoEnviados = UsuariosNoEnviados & Iif(UsuariosNoEnviados NEQ "",DE(","),DE("")) & LprmUsucodigo >
				</cfif>
			</cfcatch>
			</cftry>
		</cfif>
		<!--- Mensaje al Correo --->
		<cfif LprmKind EQ "A" or LprmKind EQ "C" or (LprmKind EQ "P" and not EnviadoAlBuzon)>
			<cftry>
				<cfscript>
					Mensajeria.sendHtmlEmail("edu", 
											 UsrDestino,
											 LprmUlocalizacion,
											 Consecutivo,
											 LprmSubject,
											 LprmMessage,
											 UsrOrigen,
											 Session.Ulocalizacion,
											 Consecutivo);
				</cfscript>
			<cfcatch type="any">
				<cfset UsuariosNoEnviados = UsuariosNoEnviados & Iif(UsuariosNoEnviados NEQ "",DE(","),DE("")) & LprmUsucodigo >
			</cfcatch>
			</cftry>
		</cfif>
	</cfif>

	<cfset initContext.close()>
	
	<cfif Len(Trim(LvarTblError)) NEQ 0>
		<cfreturn LvarTblError>
	<cfelseif Len(Trim(UsuariosNoEnviados)) NEQ 0>
		<cfreturn UsuariosNoEnviados>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>
