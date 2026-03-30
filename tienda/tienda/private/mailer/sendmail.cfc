<cfcomponent displayname="Enviar correos de la tienda referentes a un pedido">

	<cffunction name="sendmail" output="false" returntype="boolean">
		<cfargument name="template" type="string">
		<cfargument name="pedido"   type="numeric">
		<cfargument name="Ecodigo"  type="string">
		<cfargument name="dsn"      type="string">
	
	<cfquery datasource="#Arguments.DSN#" name="ArteTienda">
		select correo_clientes
		from ArteTienda
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	
	<cfquery datasource="#Arguments.DSN#" name="Empresas">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	
	<cfquery datasource="#Arguments.dsn#" name="Tracking" maxrows="1">
		select e.tracking_no, t.nombre_transportista, t.tracking_url
		from CarritoEnvio e, Carrito c, Transportista t
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and e.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pedido#">
		  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pedido#">
		  and t.transportista =* c.transportista
		order by e.id_envio desc
	</cfquery>
	
	<cfquery datasource="#Arguments.dsn#" name="Usucodigo">
		select Usucodigo
		from Carrito
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pedido#" >
	</cfquery>
	<cfif Usucodigo.RecordCount Is 0 OR Len(Usucodigo.Usucodigo) Is 0>
		<cfthrow message="El pedido #Arguments.Ecodigo# - #Arguments.pedido# no existe">
	</cfif>
	<cfquery datasource="asp" name="datos_usuario">
		select datos_personales
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo.Usucodigo#">
	</cfquery>
	<cfif datos_usuario.RecordCount Is 0>
		<cfthrow message="El usuario #Usucodigo.Usucodigo# registrado para el pedido #Arguments.Ecodigo# - #Arguments.pedido# no existe.">
	</cfif>
	<cf_datospersonales action="select" key="#datos_usuario.datos_personales#" name="datos_personales">
	<cfif Len(datos_personales.email1) Is 0>
		<cfthrow message="El usuario #Usucodigo.Usucodigo# registrado para el pedido #Arguments.Ecodigo# - #Arguments.pedido# no tiene registrada una cuenta de correo electrónico.">
	</cfif>

	<cfsavecontent variable="_mail_body">
		<cfset args = StructNew()>
		<cfset args.datos_personales = datos_personales>
		<cfset args.pedido = Arguments.pedido>
		<cfset args.tracking_no = Trim(Tracking.tracking_no)>
		<cfset args.nombre_transportista = Trim(Tracking.nombre_transportista)>
		<cfset args.tracking_url = Trim(Tracking.tracking_url)>
		<cfparam name = "session.sitio.host">
		<cfset args.hostname = session.sitio.host>
		<cfset args.Usucodigo = Usucodigo.Usucodigo>
		<cfset args.CEcodigo = session.CEcodigo>
		<cfset args.correo_clientes = Trim(ArteTienda.correo_clientes)>
		<cfset args.nombre_tienda = Empresas.Edescripcion>
		<cfset request.MailArguments = args>
		<cfinclude template="/tienda/tienda/private/mailer/#Arguments.template#">
	</cfsavecontent>
	
	
	<cfquery datasource="asp">
			insert SMTPQueue (
				SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value='"Recepcion de pedidos" <gestion@soin.co.cr>'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos_personales.email1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Pedido número #Arguments.pedido#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
	</cfquery>
	<cflog file="tienda_mailer" text="Correo enviado para pedido #Arguments.pedido#, template #Arguments.template#">
	
	<cfreturn true>
	
	</cffunction>
</cfcomponent>