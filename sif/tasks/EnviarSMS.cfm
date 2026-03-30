<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Env&iacute;o automatizado de Mensajes SMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfquery name="sms" datasource="asp" >
	select  SMSid, para, asunto, texto
	from SMS
	where fecha_enviado is null
</cfquery>

<cfset start = Now()>
<cfoutput>
	<strong>Proceso de Env&iacute;o de Mesajes de SMS</strong><br>
	<strong>Iniciando proceso</strong> #TimeFormat(start,"HH:MM:SS")#<br>
</cfoutput>
<cfset contador = 0 >

<cfloop query="sms">
	<cfset tel = trim(sms.para) >
	<cfset msg = trim(sms.texto) >
	<cfset from = trim(sms.asunto) >
	
	<cfif len(trim(tel)) eq 7 and ( FindNoCase(3, tel) eq 1 or FindNoCase(8, tel) eq 1 ) >
		<cfhttp url="http://10.7.7.30:8300/cfmx/home/menu/portlets/sms/sms_sendjsp.jsp"
			method="get"
			name="jspquery">
			
			<cfhttpparam name="msg"  value="#msg#"  type="formfield">
			<cfhttpparam name="tel"  value="#tel#"  type="formfield">
			<cfhttpparam name="from" value="#from#" type="formfield">
			<cfhttpparam name="activate" value="activate" type="formfield">
		</cfhttp>
		<cfif ListFirst(cfhttp.statusCode, ' ') neq '200'>
			<cfoutput>
				<font size="1" face="Arial, Helvetica, sans-serif"><strong>Error</strong> enviando mensaje a destino #sms.para#<br><strong>Detalle del error:</strong> #cfhttp.statusCode#<br><br></font>
			</cfoutput>
			
			<cfquery datasource="asp">
				update SMS
				set reintentos = reintentos + 1
				where SMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#sms.SMSid#">
			</cfquery>
		<cfelseif jspquery.ok >
			<cfset contador = contador + 1 >
			<cfquery datasource="asp">
				update SMS
				set smpp_msg_id     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.msg_id#">
				,   src_ton         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.src_ton#">
				,   src_npi         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.src_npi#">
				,   src_num         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.src_num#">
				,   dest_ton         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.dest_ton#">
				,   dest_npi         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.dest_npi#">
				,   dest_num         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jspquery.dest_num#">
				,   fecha_enviado   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where SMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#sms.SMSid#">
			</cfquery>
		<cfelse>
			<cfquery datasource="asp">
				update SMS
				set reintentos = reintentos + 1
				where SMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#sms.SMSid#">
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

<cfoutput>
<cfset finish = Now()>
<strong>Mensajes enviados:</strong> #contador#<br>
<strong>Proceso terminado</strong> #TimeFormat(finish,"HH:MM:SS")#<br>
</cfoutput>
 
</body>
</html>