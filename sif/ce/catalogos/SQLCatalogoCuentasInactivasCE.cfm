<cfparam name="modo" default="ALTA">
<cfif isdefined("Cuenta_cuenta")>
	<cftry>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CEInactivas(Ccuenta, Cformato, Cdescripcion, Ecodigo, BMUsucodigo, FechaGeneracion)
			VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
		</cfquery>
		<cfcatch type ="Database">
		</cfcatch>
	</cftry>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Cuenta_subcuenta")>
	<cfquery name="cuentas" datasource="#Session.DSN#">
		SELECT Ccuenta,Cformato, Cdescripcion FROM  CContables WHERE Ecodigo = #Session.Ecodigo# and Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
	</cfquery>
	<cfloop query="cuentas">
		<cftry>
			<cfquery datasource="#Session.DSN#">
				INSERT INTO CEInactivas(Ccuenta, Cformato, Cdescripcion, Ecodigo, BMUsucodigo, FechaGeneracion)
				VALUES ('#cuentas.Ccuenta#', '#cuentas.Cformato#', '#cuentas.Cdescripcion#', #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
			</cfquery>
			<cfcatch type ="Database">

			</cfcatch>
		</cftry>
	</cfloop>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Elimina_cuenta")>
	<cfif #Form.tipoME# eq 'cuenta'>
		<cfquery datasource="#Session.DSN#">
			DELETE FROM CEInactivas WHERE Ecodigo = #Session.Ecodigo# and Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta#">
		</cfquery>
	</cfif>
	<cfif #Form.tipoME# eq 'subcuenta'>
		<cfquery name="EliminarCuentas" datasource="#Session.DSN#">
			SELECT Ccuenta,Cformato, Cdescripcion FROM  CContables WHERE Ecodigo = #Session.Ecodigo# and Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
		</cfquery>
		<cfloop query="EliminarCuentas">
			<cfquery datasource="#Session.DSN#">
				DELETE FROM CEInactivas WHERE Ecodigo = #Session.Ecodigo# and Ccuenta = '#EliminarCuentas.Ccuenta#'
			</cfquery>
		</cfloop>
	</cfif>
	<cfset modo="ALTA">
</cfif>

<cfset LvarAction = 'CatalogoCuentasInactivasCE.cfm'>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	</cfoutput>
</form>

<HTML>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>
