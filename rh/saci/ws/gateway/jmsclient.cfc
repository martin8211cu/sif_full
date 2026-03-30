<cfcomponent output="no">

<cffunction name="leerParametros" output="false" returntype="void">
	
	<!--- Parámetros --->
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="560" returnvariable="This._providerURL"/>
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="561" returnvariable="This._initialContextFactory"/>
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="562" returnvariable="This._queueConnectionFactory"/>
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="563" returnvariable="This._queueName"/>	
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="564" returnvariable="This._maxMessages"/>
	<cfinvoke component="saci.comp.ISBparametros" method="get" Pcodigo="565" returnvariable="This._receiveTimeout"/>
	
	<cfset paramsNuevos =
		This._providerURL & ',' & 
		This._initialContextFactory & ',' & 
		This._queueConnectionFactory & ',' & 
		This._queueName	 & ',' & 
		This._maxMessages & ',' & 
		This._receiveTimeout>
	<cfparam name="This.paramsLeidos" default="">
	
	<cfif paramsNuevos neq This.paramsLeidos>
		<cfset disconnect()>
	</cfif>
	
	<cfset getContext()>
</cffunction>

<!---getContext--->
<cffunction name="getContext" output="false" returntype="any" access="private">
	<cfset var env = CreateObject("java", "java.util.Properties")>
	<cfset var Context = CreateObject("java", "javax.naming.Context")>

	<cflog file="jmsclient" text="getContext:inicia">
	<cfif Not IsDefined('This.jndiContext')>
		<cfset env.setProperty(Context.PROVIDER_URL, This._providerURL)>
		<cfset env.setProperty(Context.INITIAL_CONTEXT_FACTORY, This._initialContextFactory)>
		<!---
		<cfset env.setProperty(Context.SECURITY_PRINCIPAL, 'jagadmin')>
		<cfset env.setProperty(Context.SECURITY_CREDENTIALS, '')>
		--->
   		<cfset env.setProperty('com.sybase.jms.debug', 'true')>
		<cflog file="jmsclient" text="getContext:InitialContext(#env.toString()#)">
		<cfset This.jndiContext = CreateObject("java", "javax.naming.InitialContext").init(env)>
	<cfelse>
		<cflog file="jmsclient" text="getContext:reusando context">
	</cfif>
</cffunction>

<!---connect--->
<cffunction name="connect" output="false" returntype="void">
	<cfset var Session = CreateObject("java", "javax.jms.Session")>

	<cfset leerParametros()>
	<cfif Not IsDefined('This.queueConnectionFactory')>
		<cflog file="jmsclient" text="connect:lookup(#This._queueConnectionFactory#)">
		<cfset This.queueConnectionFactory = This.jndiContext.lookup(JavaCast("string", This._queueConnectionFactory))>
	<cfelse>
		<cflog file="jmsclient" text="connect:reuse queueConnectionFactory">
	</cfif>
	
	<cfif Not IsDefined('This.queueConnection')>
		<cflog file="jmsclient" text="connect:createQueueConnection">
		<cfset This.queueConnection = This.queueConnectionFactory.createQueueConnection()>
	<cfelse>
		<cflog file="jmsclient" text="connect:reuse queueConnection">
	</cfif>
	
	<cfif Not IsDefined('This.queueSession')>
		<cflog file="jmsclient" text="connect:createQueueSession">
		<cfset This.queueSession = This.queueConnection.createQueueSession(false, Session.CLIENT_ACKNOWLEDGE)>
	<cfelse>
		<cflog file="jmsclient" text="connect:reuse queueSession">
	</cfif>
	
	<cfif Not IsDefined('This.queue')>
		<cflog file="jmsclient" text="connect:lookup (#This._queueName#)">
		<cfset This.queue = This.jndiContext.lookup(JavaCast("string", This._queueName))>
	<cfelse>
		<cflog file="jmsclient" text="connect:reuse queue">
	</cfif>		
	<cfif Not IsDefined('This.queueReceiver')>
		<cflog file="jmsclient" text="getMessage:createReceiver">
		<cfset This.queueReceiver = This.queueSession.createReceiver(This.queue)>
		
		<cflog file="jmsclient" text="getMessage:start">
		<cfset This.queueConnection.start()>
	<cfelse>
		<cflog file="jmsclient" text="connect:reuse queueReceiver">
	</cfif>
	
	<cflog file="jmsclient" text="connect:fin">
</cffunction>

<!---geMessage--->
<cffunction name="getMessage" output="false" returntype="any">
	<cflog file="jmsclient" text="getMessage:receive(#This._receiveTimeout# ms)">
	<cfreturn This.queueReceiver.receive(This._receiveTimeout)>
</cffunction>

<!---disconnect--->
<cffunction name="disconnect" output="false" returntype="void">
	<!--- no desconectar.  nunca, hasta que bajen el servidor --->
	<cftry>
		<cfif IsDefined('This.queueReceiver')>
			<cfset This.queueReceiver.close()>
			<cfset StructDelete(This, 'queueReceiver')>
		</cfif>
		<cfif IsDefined('This.queueSession')>
			<cfset This.queueSession.close()>
			<cfset StructDelete(This, 'queueSession')>
		</cfif>
		<cfif IsDefined('This.queueConnection')>
			<cfset This.queueConnection.close()>
			<cfset StructDelete(This, 'queueConnection')>
		</cfif>
		<cfif IsDefined('This.jndiContext')>
			<cfset StructDelete(This, 'jndiContext')>
		</cfif>
	<cfcatch type="any">
		<cflog file="jmsclient" text="Error cerrando conexión: #cfcatch.Type#: #cfcatch.Message# #cfcatch.Detail# #cfcatch.StackTrace#">
	</cfcatch>
	</cftry>
</cffunction>

<!---procesar--->
<cffunction name="procesar" output="false" returntype="numeric" access="public">
	<!---procesa todos los mensajes que haya--->
	<cfset var messageCount = 0>
	<cfset var buf = BinaryDecode(RepeatString('00', 10240), 'Hex')>
	<cfset var message = 0>
	<cflog file="jmsclient" text="procesar:inicia">
	<cftry>
	<cflock name="saci_ws_gateway_jmsclient_procesar" timeout="5">
		<cflog file="jmsclient" text="procesar:connect">
		<cfset connect()>
		<cflog file="jmsclient" text="procesar:cfloop">
		<cfloop from="1" to="#This._maxMessages#" index="dummy">
			<cfif IsDefined('server.stopjms')>
				<cflog file="jmsclient" text="procesar:server.stop recibido">
				<cfset StructDelete(server, 'stopjms')>
				<cfbreak>
			</cfif>
			<!--- Crear el receptor, procesar y acusar recibo --->
			<cflog file="jmsclient" text="procesar:getMessage">
			<cfset message = getMessage()>
			<cfif IsDefined('message')>
				<!---
					Se asume que es BytesMessage en UTF-8, ya que viene de RepConnector.
					Si fuera un TextMessage, se debería hacer un message.getText en lugar 
					de este manejo del buffer.
				--->
				<cflog file="jmsclient" text="procesar:readBytes">
				<cfset bytes = message.readBytes(buf)>
				<cfset messageText = CreateObject("java", "java.lang.String").init(buf, 0, bytes, 'UTF-8')>
				<cfset logMessage = REReplace(messageText, '\A.+eventId="(\S+)".+schema="(\S+)".+\Z', '\2 \1', 'one')>
				<cflog file="jmsclient" text="procesar:repconnEvento num #messageCount+1# ( # logMessage # )">
				<cfinvoke component="saci.ws.intf.repconnEvento" method="repconnEvento" evento="#messageText#" />
				<cflog file="jmsclient" text="procesar:acknowledge">
				<cfset message.acknowledge()>
				<cflog file="jmsclient" text="procesar:acknowledge ok">
				<cfset messageCount = messageCount + 1>
			<cfelse>
				<cflog file="jmsclient" text="procesar:No hay más mensajes">
				<cfbreak>
			</cfif>
		</cfloop>
	</cflock>
	<cfcatch type="any">
		<cflog file="jmsclient" text="procesar: #cfcatch.Type#:#cfcatch.Message# #cfcatch.Detail#">
		<!---finally--->
		<cflog file="jmsclient" text="procesar:disconnect">
		<cfset disconnect()>
		<cfrethrow>
	</cfcatch>
	</cftry>
	<!---finally--->
	<!---
		Mejor que no se desconecte si no es necesario.  Sólo en el catch se desconecta
	<cflog file="jmsclient" text="procesar:disconnect">
	<cfset disconnect()>
	--->
	<cflog file="jmsclient" text="procesar:Fin del proceso">
	<cfreturn messageCount>
</cffunction>

</cfcomponent>