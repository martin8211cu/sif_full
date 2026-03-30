<!--- Consultas --->
<cfquery datasource="#session.dsn#" name="hdr">
	select a.EOnumero, coalesce (a.EOtotal, 0) as EOtotal, b.SNnombre, b.SNemail, m.Msimbolo, m.Miso4217
	from EOrdenCM a
		left join SNegocios b
			on b.Ecodigo = a.Ecodigo
			and b.SNcodigo = a.SNcodigo
		left join Monedas m
			on m.Ecodigo = a.Ecodigo
			and m.Mcodigo = a.Mcodigo
	where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	
<cfset email_subject = "Orden de compra Número #hdr.EOnumero# por #hdr.Msimbolo##NumberFormat(hdr.EOtotal,',0.00')#">
<cfset email_from = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
<cfset email_to = '"' & hdr.SNnombre & '" <' & form.email & '>'>
<cfset email_cc = '"' & hdr.SNnombre & '" <' & form.Ccemail & '>'>
	
<cfsavecontent variable="email_body" >
	<html>
		<head>
			<style type="text/css">
				.tituloIndicacion {
					font-size: 10pt;
					font-variant: small-caps;
					background-color: #CCCCCC;
				}
				.tituloListas {
					font-weight: bolder;
					vertical-align: middle;
					padding: 2px;
					background-color: #F5F5F5;
				}
				.listaNon { 
					background-color:#FFFFFF; 
					vertical-align:middle; 
					padding-left:5px;
				}
				.listaPar { 
					background-color:#FAFAFA; 
					vertical-align:middle; 
					padding-left:5px;
				}
				body,td {
					font-size: 12px;
					background-color: #f8f8f8;
					font-family: Verdana, Arial, Helvetica, sans-serif;
				}
			</style>
		</head>
		<body>
			<cfinclude template="OrdenesCompra-email-archivo.cfm">
		</body>
	</html>
</cfsavecontent>
<cfif isdefined("form.email") and len(trim(form.email)) NEQ 0>
	<cfquery datasource="#session.dsn#">
		insert into SMTPQueue (	SMTPremitente,SMTPdestinatario,SMTPasunto,SMTPtexto,SMTPhtml)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
	</cfquery>
</cfif>
<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) NEQ 0>
	<cfset copia = "" >
	<cfset copia = ListToArray(form.Ccemail,';')>
	<!--- <cfdump var="copia es: #form.Ccemail#"> <br>
	<cfdump var="Largo de copia es: #ArrayLen(copia)#"> <br> --->
	
	<cfloop  from="1" to="#ArrayLen(copia)#" index="i">
		<cfquery datasource="#session.dsn#">
			insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#copia[i]#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
		</cfquery>
	</cfloop>
	
</cfif>

<cflocation url = "OrdenesCompra-email-enviado.cfm?EOidorden=#URLEncodedFormat(form.EOidorden)#&email=#URLEncodedFormat(form.email)#&Ccemail=#URLEncodedFormat(form.Ccemail)#">

