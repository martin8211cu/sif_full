<cfsetting enablecfoutputonly="yes">
<cfif not IsDefined('url.nossl')>
		<cf_ssl secure='no' url="/cfmx/home/public/login-enter.cfm?nossl=">
<cfelse>
	<!---- validacion para si la info del formulario es del usuario que desea entrar---->
	<cfif isdefined('session.LoginRequest.owner') and !(isdefined('session.Usucodigo') and session.LoginRequest.owner eq session.Usucodigo)>
		<cfset structDelete(session, "LoginRequest")>
	</cfif>
	<cfif isdefined('session.LoginRequest')>
		<cfset temp1 = session.LoginRequest.uri>
		<cfif Len(session.LoginRequest.URL)>
			<cfset temp1 = temp1 & '?' & session.LoginRequest.URL>
		</cfif>
	
		<cfif StructIsEmpty(session.LoginRequest.FORM)>
			<cfset StructDelete(session, 'LoginRequest')>
			<cflocation url="#temp1#" addtoken="no">
		<cfelse>
			<cfoutput><html><body onLoad="document.form1.submit()"><form action="#HTMLEditFormat(temp1)#" name="form1" id="form1" method="post">
				<cfset keys = StructKeyArray(session.LoginRequest.FORM)>
				<cfloop from="1" to="#ArrayLen(keys)#" index="ikey">
					<cfif keys[ikey] neq 'FIELDNAMES'>
						<input type="hidden" name="#HTMLEditFormat(keys[ikey])#" value="#HTMLEditFormat(session.LoginRequest.FORM[keys[ikey]])#">
					</cfif>
				</cfloop>
			</form></body></html></cfoutput>
			<cfset StructDelete(session, 'LoginRequest')>
		</cfif>
	<cfelse>
		<cflocation url="index.cfm" addtoken="no">
	</cfif>
</cfif>