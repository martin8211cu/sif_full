<!--- <cfdump var="#form#"> --->

<cfset modo="ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
			
					<cfif isdefined("Form.Alta")>
						<cfquery name="insertaRHPreparacionOferentes" datasource="#Session.DSN#">
							insert into RHPreparacionOferentes 
							(Ecodigo,RHOid, GAcodigo, RHPOnombre, RHPOtitulo, RHPOaingreso, RHPOmingreso, RHPOaegreso, RHPOmegreso, RHPOEstado, BMUsucodigo)
							values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPOnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPOtitulo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOaingreso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOmingreso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOaegreso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOmegreso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOEstado#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)
							<cf_dbidentity1 datasource="#Session.DSN#">
						</cfquery>	
						<cf_dbidentity2 datasource="#Session.DSN#" name="insertaRHPreparacionOferentes">
													
						<cfset modo="CAMBIO">
					<cfelseif isdefined("Form.Baja")>
						<cfquery name="delRHAnotaciones" datasource="#Session.DSN#">
							delete from RHPreparacionOferentes
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHPOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOid#">
						</cfquery>	
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Cambio")>
						<cfquery name="updRHAnotaciones" datasource="#Session.DSN#">
							update RHPreparacionOferentes set
								Ecodigo	     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								GAcodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">,
								RHPOnombre 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPOnombre#">,
								RHPOtitulo 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPOtitulo#">,
								RHPOaingreso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOaingreso#">,
								RHPOmingreso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOmingreso#">,
								RHPOaegreso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOaegreso#">,
								RHPOmegreso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOmegreso#">,
								RHPOEstado   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPOEstado#">,
								BMUsucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHPOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPOid#">
							  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid#">
						</cfquery>
						<cfset modo="CAMBIO">
					</cfif>
		</cftransaction>	
	</cfif>
	
<cfif isdefined("Form.Alta")>
	<cfset vNewPrep = "">
	<cfif isdefined('insertaRHPreparacionOferentes')>
		<cfset vNewPrep = insertaRHPreparacionOferentes.identity>
	</cfif>
</cfif>	
	<form action="OferenteExterno.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="RHPOid" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.RHPOid")>#form.RHPOid#<cfelseif isdefined('vNewPrep')>#vNewPrep#</cfif></cfoutput> ">	
		<input name="RHOid" type="hidden" value="<cfif isdefined("form.RHOid")><cfoutput>#form.RHOid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="3">			
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
