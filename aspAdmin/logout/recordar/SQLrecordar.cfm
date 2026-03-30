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

<cffunction name="generaPassw" access="public" returntype="string" output="true">
	<cfset myList = "a,b,c,d,e,f,g,h,i,j,k,m,n,o,p,q,r,s,t,u,v,w,x,y,z,2,3,4,5,6,7,8,9">	
	<cfset myArrayList = ListToArray(myList)>
	<cfset newClave = "">
	
	<cfloop index = "LoopCount" from = "1" to = "6">
		<cfset newClave = newClave & myArrayList[RandRange(1, ArrayLen(myArrayList) )]>
	</cfloop>

	<cfreturn newClave>	
</cffunction>

<cffunction name="mandaCorreo" access="public" returntype="string" output="true">
	<!--- devuelve true si hay un error, false si todo sale bien --->
	<cfargument name="Usucod" type="string" required="true">
	<cfargument name="Ulocaliz" type="string" required="true">
	<cfargument name="nuevaClave" type="string" required="true">	
	
	<cfset asuntoMail 	= "Clave de acceso, migestion.net">
	<cfset textoMail 	= "Usted ha solicitado una nueva clave de acceso para el portal.La nueva clave es " 
							& nuevaClave 
							& ". Debe utilizarla en minusculas, no utilice letras mayusculas al ingresarla.">

	<cfif not isdefined('__Mensajeria')>
		<!--- Instanciacion del EJB para mandar correos --->
		<cftry>
				<cfobject action="create" name="ctx"  type="java" class="javax.naming.Context">
				<cfobject action="create" name="prop" type="java" class="java.util.Properties">
				<cfset prop.init()>
		
				<cfset prop.put(ctx.SECURITY_PRINCIPAL, 'guest')>
				<cfset prop.put(ctx.SECURITY_CREDENTIALS, 'guest')>
				<cfobject action="create" name="initContext" type="java" class="javax.naming.InitialContext">
				<cfset initContext.init(prop)>
				<cfset home = initContext.lookup("utilitarios/Mensajeria")>
				<cfset __Mensajeria = home.create()>
			<cfcatch>
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>			
				
				<cfreturn true>
			</cfcatch> 
		</cftry>
	</cfif>
	
	<cfif Usucod NEQ '' and Ulocaliz NEQ '' and nuevaClave NEQ ''>
			<cfset __Mensajeria.MensajeCorreo (
								  Usucod
								, Ulocaliz
								, asuntoMail
								, textoMail)>									
	</cfif>
	
	<cfreturn false>	
</cffunction>

<!--- Solo permite digitar la respuesta a la pregunta 2 veces, si no logra acertar la respuesta en esas 2 oportunidades
		despliega de nuevo la p[agina de logueo para introducir el login y password para empezar el proceso de nuevo --->
<cfif isdefined('form.retry') and form.retry GT 2>
	<cfset action = '/cfmx/sif/'>
<cfelse>
	<cfquery name="QRY_usuario" datasource="#session.DSN#">
		select  (Pnombre || ' ' || Papellido1 || ' ' || Papellido2) as nombreDest
				,Pemail1
				, Usucodigo
				, Ulocalizacion
				, Usupregunta as pregunta
				, Usurespuesta as respuesta,
				Usueplogin
		from Usuario
		where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.login#">
		  and Usutemporal = 0
	</cfquery>
	
	<cfset intentos = 0>
	<cfif form.login EQ "pso" OR QRY_usuario.recordCount EQ 0
		OR Len(Trim(QRY_usuario.pregunta)) EQ 0  OR Len(Trim(QRY_usuario.respuesta)) EQ 0>
		<cfset action = '/cfmx/sif/logout/recordar/recordarImposible.cfm'>
	<cfelse>
		<cfset action = '/cfmx/sif/logout/recordar/recordar.cfm'>
		
		<cfif isdefined('form.retry')>
			<cfset intentos = form.retry + 1>
		<cfelse>
				<cfset intentos = 0>
		</cfif>		
		
		<cfif isdefined('form.respuesta') and form.respuesta NEQ ''>
			<cfset error = ''>
			<cfif form.respuesta NEQ QRY_usuario.respuesta>
				<cfset error = 'La respuesta no coincide con nuestros registros.'>
			<cfelse>
				<cfset nuevaClave = "">
				<cfset nuevaClave = generaPassw()>
				<cfset ErrorCamPass = false>
				
				<!--- Se envia la nueva contrasenia por correo   --->
				<cfset ErrorCamPass = CambiaPassw(form.login,nuevaClave)>

				<cfif ErrorCamPass NEQ true>
					<cfset correoOK = mandaCorreo(QRY_usuario.Usucodigo,QRY_usuario.Ulocalizacion,nuevaClave)>
				
					<cfif correoOK EQ false>
						<cfset action = '/cfmx/sif/logout/recordar/recordarFin.cfm'>
					<cfelse>
						<cfset action = '/cfmx/sif/'>				
					</cfif>
				<cfelse>
					<cfset action = '/cfmx/sif/'>
				</cfif>
			</cfif>		
		</cfif>
	</cfif>
</cfif>

<HTML>
<head>
</head>
<body>
<cfoutput>
	<form action="#action#" method="post">
		<input type="hidden" name="login" value="#form.login#">
		<cfif isdefined('QRY_usuario') and QRY_usuario.recordCount GT 0>
			<input type="hidden" name="pregunta" value="#QRY_usuario.pregunta#">
			<input type="hidden" name="retry" value="#intentos#">			
			<cfif isdefined('error') and error NEQ ''>
				<input type="hidden" name="error" value="#error#">
			</cfif>
		</cfif>
	</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>