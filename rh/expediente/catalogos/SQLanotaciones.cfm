<cfset modo="ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
					<cfif isdefined("Form.Alta")>
						<cfquery name="insRHAnotaciones" datasource="#Session.DSN#">
							insert into RHAnotaciones 
							(DEid, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHAfecha)#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHAdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHAtipo#">
							)
							<cf_dbidentity1 datasource="#Session.DSN#">
						</cfquery>	
						<cf_dbidentity2 datasource="#Session.DSN#" name="insRHAnotaciones">
													
						<cfset modo="CAMBIO">
					<cfelseif isdefined("Form.Baja")>
						<cfquery name="delRHAnotaciones" datasource="#Session.DSN#">
							delete from RHAnotaciones
							where RHAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHAid#">
						</cfquery>	
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Cambio")>
						<cfquery name="updRHAnotaciones" datasource="#Session.DSN#">
							update RHAnotaciones set
								RHAfecha 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHAfecha)#">,
								RHAfsistema 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								RHAdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAdescripcion#">,								
								RHAtipo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAtipo#">
							where RHAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
								and DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						</cfquery>
						<cfset modo="CAMBIO">
					</cfif>
		</cftransaction>	
	</cfif>
	
	<cfif isdefined("Form.Alta")>
		<cfset vNewAnot = "">
		<cfif isdefined('insRHAnotaciones')>
			<cfset vNewAnot = insRHAnotaciones.identity>
		</cfif>
	</cfif>	

	<form action="expediente-cons.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="RHAid" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.RHAid")>#form.RHAid#<cfelseif isdefined('vNewAnot')>#vNewAnot#</cfif></cfoutput>">	
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="4">			
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
