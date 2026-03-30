<cfcomponent extends="ejecutor" hint="Envía el mensaje de notificación con el resultado del parche">
	
	<cffunction name="ejecuta" hint="Ejecuta la tarea" output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Enviando mensaje')>
		
		<cfset This.enviar_mensaje()>
		
		<cfset This.fin(num_tarea)>
	</cffunction>
	
	<cffunction name="enviar_mensaje" hint="Envía el mensaje de correo" output="false">
		<cfargument name="email" default="">
		
		<cfif Len(Trim(email)) EQ 0>
			<cfinvoke component="asp.parches.comp.instala" method="get_servidor"
				returnvariable="servidor" />
			<cfquery datasource="asp" name="APServidor">
				select admin_email
				from APServidor
				where servidor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#servidor#">
			</cfquery>
			<cfset email = APServidor.admin_email>
		</cfif>
		
		<cfinvoke component="asp.parches.comp.instala" method="redactar_mensaje" returnvariable="message" />
		<cfquery datasource="asp">
			insert into SMTPQueue (
				SMTPremitente, SMTPhtml, SMTPdestinatario, SMTPasunto, SMTPtexto)
			values (' ', 1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#message.subject#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#message.body#">)
		</cfquery>
	</cffunction>

</cfcomponent>
