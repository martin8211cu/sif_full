<!--- Faltan validaciones de indices alternos --->
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
	
		<cftransaction>

			<cfquery name="ABC_ObrasArea" datasource="#Session.DSN#">
				insert into PRJPobraArea (Ecodigo, PRJPOid, PRJPAcodigo, PRJPAdescripcion, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOid)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPAcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPAdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		
		</cftransaction>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ObrasArea" datasource="#Session.DSN#">
			delete PRJPobraArea
			where PRJPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPAid#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>

		<cftransaction>
			
			<cfquery name="ABC_Obras" datasource="#Session.DSN#">
				update PRJPobraArea set 
					PRJPAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPAcodigo)#">,
					PRJPAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJPAdescripcion#">
				where PRJPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPAid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)				
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">  				  
	</cfif>
	
</cfif>

<cfoutput>
<form action="PRJPobraArea.cfm?PRJPOid=#PRJPOid#" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="PRJPAid" type="hidden" value="#PRJPAid#">		
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

