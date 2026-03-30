<!---  Se obtienen los datos que ocupa el correo para ser enviado. --->
<cfset email_subject = "Reasignación de Ordenes de Compra.">
<cfset email_from = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
<cfset email_to = '"' & form.nameBuyerTo & '" <' & form.email & '>'>
<cfset email_cc = '"' & form.nameBuyerCc & '" <' & form.Ccemail & '>'>

<cfsavecontent variable="email_body">
	<html>
		<head></head>
		<body>
			<cfinclude template="reasignarOrden-Aviso.cfm">
		</body>
	</html>
</cfsavecontent>

<!--- Reasignación de la carga de trabajo --->
<cfinclude template="reasignarOrden-sql.cfm">

<cfquery datasource="#session.dsn#">
	insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
	values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
</cfquery>

<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) NEQ 0>
	<cfset copia = ListToArray(form.Ccemail,';')>
	<cfloop  from="1" to="#ArrayLen(copia)#" index="i">
		<cfquery datasource="#session.dsn#">
			insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#copia[i]#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
		</cfquery>
	</cfloop>
</cfif>

<cflocation url="reasignarOrden-email-enviado.cfm?EOidorden=#URLEncodedFormat(form.EOidorden)#&email=#URLEncodedFormat(form.email)#&Ccemail=#URLEncodedFormat(form.Ccemail)#&nameBuyerTo=#URLEncodedFormat(form.nameBuyerTo)#&nameBuyerCc=#URLEncodedFormat(form.nameBuyerCc)#&rb=#URLEncodedFormat(form.rb)#">
