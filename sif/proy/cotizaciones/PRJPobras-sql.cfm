<!--- Faltan validaciones de indices alternos --->
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
	
		<cftransaction>

			<cfquery name="ABC_Obras" datasource="#Session.DSN#">
				insert into PRJPobra (Ecodigo, PRJPOcliente, PRJPOdescripcion, PRJPOcodigo, PRJPOlugar, PRJPOnumero, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOcliente)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOcodigo)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOlugar)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOnumero)#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		
		</cftransaction>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_Obras" datasource="#Session.DSN#">
			delete PRJPobra
			where PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>

		<cftransaction>
			
			<cfquery name="ABC_Obras" datasource="#Session.DSN#">
				update PRJPobra set 
					PRJPOcliente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOcliente)#">,
					PRJPOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJPOdescripcion#">,
					PRJPOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJPOcodigo)#">,
					PRJPOlugar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJPOlugar#">,
					PRJPOnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJPOnumero#">
				where PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)				
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">  				  
	</cfif>
	
</cfif>

<cfoutput>
<form action="PRJPobras.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="PRJPOid" type="hidden" value="#PRJPOid#">
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

