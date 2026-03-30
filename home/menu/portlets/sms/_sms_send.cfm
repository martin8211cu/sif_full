<cfquery name="sms" datasource="asp">
	select  SMSid, para, asunto, texto
	from SMS
	where fecha_enviado is null
</cfquery>

<cfloop query="sms">
	<cfset tel = '8385196' >
	<cfset msg = trim(sms.texto) >
	<cfset from = trim(sms.asunto) >
	
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
		<script type="text/javascript">
		alert("No hay conexión con el gateway de SMPP. Status: <cfoutput>#cfhttp.statusCode#</cfoutput>");
		</script>
		</cfoutput>
	<cfelseif jspquery.ok >
		<cfoutput>
		<!---
		<script type="text/javascript">
			var f = window.parent.document.formsms;
			alert("Mensaje enviado al telefono #JSStringFormat(jspquery.dest_num)#." );
			f.envia.disabled = false;
			f.tel.value = "";
			f.msg.value = "";
		</script>
		--->
		</cfoutput>
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
		<cfoutput>
		<!---
		<script type="text/javascript">
			alert("#JSStringFormat(jspquery.errormsg)#");
			f.envia.disabled = false;
		</script>
		--->
		</cfoutput>
	</cfif>
</cfloop>
