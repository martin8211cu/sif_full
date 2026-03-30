<cfset modo="ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insFEmpleado" datasource="#Session.DSN#">	
					insert into FEmpleado 
					(DEid, NTIcodigo, FEidentificacion, Pid, FEnombre, FEapellido1, FEapellido2, FEfnac, FEdir,FEsexo,  Usucodigo, Ulocalizacion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEnombre#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEapellido1#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEapellido2#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfnac)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEdir#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEsexo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
						)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="insFEmpleado">
						
					<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delFEmpleado" datasource="#Session.DSN#">
					delete FEmpleado
					where FElinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FElinea#">
				</cfquery>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="updFEmpleado" datasource="#Session.DSN#">
					update FEmpleado set
						NTIcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
						FEidentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEidentificacion#">,
						Pid 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Pid#">,
						FEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEnombre#">,								
						FEapellido1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEapellido1#">,								
						FEapellido2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEapellido2#">,
						FEfnac 				= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfnac)#">,
						FEdir 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEdir#">
					where FElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Felinea#">
				</cfquery>
				<cfset modo="CAMBIO">
			</cfif>
		</cftransaction>	
	</cfif>
	
<cfif isdefined("Form.Alta")>
	<cfset vNewFam = "">
	<cfif isdefined('insFEmpleado')>
		<cfset vNewFam = insFEmpleado.identity>
		
	</cfif>
</cfif>	
	<cfset action = "expediente-cons.cfm">
	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="FElinea" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.FElinea")>#form.FElinea#<cfelseif isdefined('vNewFam')>#vNewFam#</cfif></cfoutput>">	
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="2">		
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
