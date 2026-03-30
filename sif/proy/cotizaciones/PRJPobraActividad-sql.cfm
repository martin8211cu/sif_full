<!--- Faltan validaciones de indices alternos --->
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
	
		<cftransaction>

			<cfquery name="ABC_ObrasActividades" datasource="#Session.DSN#">
				insert into PRJPobraActividad (Ecodigo, PRJPAid, PRJPACcodigo, PRJPACdescripcion, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPAid)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPACcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPACdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		
		</cftransaction>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ObrasActividades" datasource="#Session.DSN#">
			delete PRJPobraActividad
			where PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>

		<cftransaction>
			
			<cfquery name="ABC_ObrasActividades" datasource="#Session.DSN#">
				update PRJPobraActividad set 
					PRJPACcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPACcodigo)#">,
					PRJPACdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJPACdescripcion#">
				where PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">  				  
	</cfif>
	
</cfif>

<cfoutput>
<form action="PRJPobraActividad.cfm?PRJPOid=#PRJPOid#&PRJPAid=#PRJPAid#" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="PRJPACid" type="hidden" value="#PRJPACid#">		
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

