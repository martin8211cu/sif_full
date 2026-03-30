<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>
<cfparam name="form.tarjeta" default="">
<cfif Len(form.tarjeta) IS 0>
	<cf_tarjeta action="readform" name="tarj">
	<cf_tarjeta action="update" data="#tarj#" name="tarj">
	<cfquery datasource="aspsecure">
		insert UsuarioTarjeta (id_tarjeta, Usucodigo, BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#tarj.id_tarjeta#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			getdate())
	</cfquery>
<cfelse>
	<cf_tarjeta action="select" key="#form.tarjeta#" name="tarj">
</cfif>
<!---
<cf_tarjeta action="link.add"    data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.remove" data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.input"  data="#tarj#" type="user" associd="#session.Usucodigo#">
<cf_tarjeta action="link.get"    data="#tarj#" type="user" associd="#session.Usucodigo#">
--->

<cftransaction>
<cfquery datasource="#session.dsn#">
	update Carrito
	set id_tarjeta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tarj.id_tarjeta#">
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

<cfquery datasource="#session.dsn#">
	insert Nota (id_carrito, Ecodigo, nota, Usulogin, Usucodigo)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">,
		'Checkout y medio de pago registrados.',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
</cfquery>

<cfquery datasource="#session.dsn#">
	update Carrito
	set estado = 200 <!--- PAGADO --->
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

</cftransaction>

<cfinvoke component="tienda.tienda.private.mailer.sendmail" method="sendmail">
	<cfinvokeargument name="template"  value="pedido-recibido.cfm">
	<cfinvokeargument name="pedido"	   value="#session.id_carrito#">
	<cfinvokeargument name="Ecodigo"   value="#session.comprar_Ecodigo#">
	<cfinvokeargument name="DSN"	   value="#session.dsn#">	
</cfinvoke>

<cfset id_carrito = session.id_carrito>
<cfset StructDelete(session, "id_carrito")>
<cfset StructDelete(session, "total_carrito")>
<cfset StructDelete(session, "carrito_anonimo")>
<cflocation url="payment_thanks.cfm?id=#id_carrito#">
