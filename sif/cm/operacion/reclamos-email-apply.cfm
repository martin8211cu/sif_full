<!---  Saca el Código de Socio, Número de Reclamo y el costo del Reclamo --->
<cfquery name="rsSocio" datasource="#session.DSN#">
	select 	a.SNcodigorec, 
			a.EDRnumero, 
			(b.DRcantorig - b.DRcantrec) * c.DDRpreciou as Monto,
			d.SNnombre  
	from 	EReclamos a 
			inner join DReclamos b
				on a.Ecodigo = b.Ecodigo
				and a.ERid = b.ERid
			inner join DDocumentosRecepcion c
				on b.Ecodigo = c.Ecodigo
				and b.DDRlinea = c.DDRlinea
			inner join SNegocios d
				on a.SNcodigo = d.SNcodigo
				and a.Ecodigo = d.Ecodigo	
	where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
		and c.DDRgenreclamo = 1
</cfquery>

<cfset email_subject = "Número de Reclamo: #trim(rsSocio.EDRnumero)# por #NumberFormat(rsSocio.Monto,',0.00')#">
<cfset email_from = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
<cfset email_to = '"' & rsSocio.SNnombre & '" <' & form.email & '>'>
<cfset email_cc = '"' & rsSocio.SNnombre & '" <' & form.Ccemail & '>'>

<cfsavecontent variable="email_body">
	<html>
		<head></head>
		<body>
			<cfinclude template="reclamos-detalle.cfm">
		</body>
	</html>
</cfsavecontent>

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

<cflocation url="reclamos-email-enviado.cfm?ERid=#URLEncodedFormat(form.ERid)#&email=#URLEncodedFormat(form.email)#&Ccemail=#URLEncodedFormat(form.Ccemail)#&Pnombre=#URLEncodedFormat(form.Pnombre)#">
