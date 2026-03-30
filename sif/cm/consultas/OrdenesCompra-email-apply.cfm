<!--- Consultas --->
<cfquery name="hdr" datasource="#session.dsn#" >
	select a.EOnumero, coalesce (a.EOtotal, 0) as EOtotal, a.CMCid, b.SNnombre, b.SNemail, m.Msimbolo, m.Miso4217
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

<cfquery datasource="#session.DSN#" name="rs" maxrows="1">
	select CMFfirma
	from CMFirmaComprador
	where 2 > 1
	<cfif len(trim(hdr.CMCid)) GT 0>
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.CMCid#">
	</cfif>
</cfquery>

<!--- Asignacion de variables --->
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset email_from = Politicas.trae_parametro_global("correo.cuenta")>
<cfif len(triM(email_from)) EQ 0>
	<cfset email_from = "scompras@dospinos.com">
</cfif>
<cfset email_subject = "Orden de compra Número #hdr.EOnumero# por #hdr.Msimbolo##NumberFormat(hdr.EOtotal,',0.00')#">
<!----<cfset email_from = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">----->
<cfset email_to = '"' & hdr.SNnombre & '" <' & form.email & '>'>
<cfset email_cc = '"' & hdr.SNnombre & '" <' & form.Ccemail & '>'>
<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>

<cffile action="write" file="#tempfile#.gif" output="#rs.CMFfirma#" >

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


<cfset LvarSNnombre = email_to>
<cfset LvarSNnombre = replace(LvarSNnombre,',',' ' ,'all')>
<cfset LvarSNnombre = replace(LvarSNnombre,';',' ' ,'all')>


<cfset LvarSNnombreCC = email_cc>
<cfset LvarSNnombreCC = replace(LvarSNnombreCC,',',' ' ,'all')>
<cfset LvarSNnombreCC = replace(LvarSNnombreCC,';',' ' ,'all')>
<cfset AttachmentsDirectory = GetTempDirectory() & 'attachments/'>
<cfif Not DirectoryExists (AttachmentsDirectory)>
	<cfdirectory action="create" directory="#AttachmentsDirectory#">
</cfif>
<cfset AttachedFilename = "#AttachmentsDirectory#OC_#form.EOidorden#.html">

<cffile action = "write" file = "#AttachedFilename#" output = "#email_body#">
<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) GT 0>
	<cfmail from="#email_from#" to="#PreserveSinglequotes(LvarSNnombre)#" cc="#PreserveSinglequotes(LvarSNnombreCC)#" subject="#email_subject#" type="html">
		<cfmailparam file="#tempfile#.gif" type="image/gif" ContentID="firma" >
        <cfmailparam file="#AttachedFilename#" type="html">
	</cfmail>
<cfelse>	
	<cfmail from="#email_from#" to="#PreserveSinglequotes(LvarSNnombre)#" subject="#email_subject#" type="html">
		<cfmailparam file="#tempfile#.gif" type="image/gif" ContentID="firma">
		<cfmailparam file="#AttachedFilename#" type="html">
	</cfmail>	
</cfif>

<!---	
<!--- Este código se comento porque se cambio por el TAG de <cfmail> de ColdFusion --->
<cfquery datasource="#session.dsn#">
	insert into SMTPQueue (	SMTPremitente,SMTPdestinatario,SMTPasunto,SMTPtexto,SMTPhtml)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
</cfquery>

<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) NEQ 0>
	<cfset copia = ListToArray(form.Ccemail,';')>
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
--->
<cfquery name="rsUpdateImpresion" datasource="#session.DSN#">
	Update EOrdenCM 
		set  EOImpresion = 'I'
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cflocation url = "OrdenesCompra-email-enviado.cfm?EOidorden=#URLEncodedFormat(form.EOidorden)#&email=#URLEncodedFormat(form.email)#&Ccemail=#URLEncodedFormat(form.Ccemail)#">
