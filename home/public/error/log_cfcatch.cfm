<cftry>
	<cfset headers = GetHTTPRequestData().headers>
	
	<cfset _Error_Server = CGI.SERVER_NAME & ":" & CGI.SERVER_PORT>
	<cfif StructKeyExists(headers,"X-Forwarded-Host")>
		<cfset _Error_Server = headers["X-Forwarded-Host"]>
	</cfif>
	<cfif Len(_Error_Server) EQ 0>
		<cfset _Error_Server = headers["Host"]>
	</cfif>
	
	<cfset _Error_IPAddress = CGI.REMOTE_ADDR>
	<cfif StructKeyExists(headers,"X-Forwarded-For")>
		<cfset _Error_IPAddress = headers["X-Forwarded-For"]>
	</cfif>
	<cfif Len(_Error_IPAddress) EQ 0>
		<cfset _Error_IPAddress = headers["Host"]>
	</cfif>
	
	<!--- Resolver dirección IP del solicitante --->
<!---		Se guarda el ip sin el hostname
	<cftry>
		<cfif not IsDefined('Application.ResolveAddressCache')>
			<cfset Application.ResolveAddressCache = StructNew()>
		</cfif>
		<cfif StructKeyExists(Application.ResolveAddressCache, _Error_IPAddress)>
			<cfset _Error_IPAddress = _Error_IPAddress & "/" 
				& Application.ResolveAddressCache[_Error_IPAddress]>
		<cfelse>
			<cfif REFind('^[12]?[0-9]{1,2}(\.[12]?[0-9]{1,2}){3}$', _Error_IPAddress )>
				<cfset _Error_NumericAddress = ListToArray(_Error_IPAddress, ".")>
				<cfobject action="create" type="java" name="InetAddress" class="java.net.InetAddress">
				<cfset HostAddr = InetAddress.getByAddress(_Error_NumericAddress)>
				<cfset HostName = HostAddr.getHostName()>
				<cfif _Error_IPAddress neq HostName and Len(HostName) Neq 0>
					<cfset StructInsert(Application.ResolveAddressCache, _Error_IPAddress, HostName)>
					<cfset _Error_IPAddress = _Error_IPAddress & "/" & HostName>
				</cfif>
			</cfif>
		</cfif>
	<cfcatch type="any">
	</cfcatch>
	</cftry>
 --->		
	
	<cfset _Error_Login = "anonymous">
	<cfif IsDefined("session.Usuario")>
		<cfset _Error_Login = session.Usuario>
	</cfif>
	
	<cfset _Error_URL = "//" & _Error_Server & CGI.SCRIPT_NAME >
	<cfif Len(CGI.QUERY_STRING)>
		<cfset _Error_URL = _Error_URL & "?" & CGI.QUERY_STRING>
	</cfif>
	
<cfset _Error_Message		= cfcatch.Message & " " & cfcatch.Detail>
<cfset _Error_DateTime		= now()>
<cfset _Error_Diagnostics	= _Error_Message>
<cfif isdefined('cfcatch.sql')>
	<cfset _Error_Diagnostics	= _Error_Message & " " & cfcatch.sql>
</cfif>
<cfinvoke component="home.public.error.stack_trace" method="fnGetStackTrace" LprmError="#cfcatch#" returnvariable="_Error_StackTrace"></cfinvoke>
	<cfif IsDefined("session.monitoreo.SScodigo")>
		<cfset _Error_Componente = session.monitoreo.SScodigo & ',' & session.monitoreo.SMcodigo & ',' & session.monitoreo.SPcodigo>
	<cfelse>
		<cfset _Error_Componente = ''>
	</cfif>

	<cftransaction>
		<cfquery datasource="aspmonitor" name="data">
		insert into MonErrores (sessionid, componente, titulo, cuando, ip, url, login, detalle, detalle_extra)
		values (
			<cfif IsDefined('session.monitoreo.sessionid')>
			<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.monitoreo.sessionid#">
			<cfelse> 0 </cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_Componente, 40)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_Message, 60)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#_Error_DateTime#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_IPAddress, 30)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_URL, 255)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_Login, 40)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_Error_Diagnostics, 255)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"   value="#_Error_Diagnostics & '<br>' & _Error_StackTrace#">)
		<cf_dbidentity1 datasource="aspmonitor">
		</cfquery>
		<cf_dbidentity2 datasource="aspmonitor" name="data">
	</cftransaction>
	<cfset Request.errorid = data.identity>
	<cfset session.errorid = data.identity>
<cfcatch type="any">
	<cflog file="log_cfcatch"  text="#cfcatch.Message#, #cfcatch.Detail#">
</cfcatch>
</cftry>
