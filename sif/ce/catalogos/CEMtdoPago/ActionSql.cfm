<cfparam name="modo" default="ALTA">

<cfif isdefined("Form.Clave")>
	<cfquery name="rsValidate" datasource="#session.DSN#">
	SELECT Id_MtdoPago
	FROM CEMtdoPago
	WHERE Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
</cfquery>
</cfif>

<!--- <cf_dump var="#rsValidate#"> --->


<cfif not isdefined("Form.Nuevo")>
	<!--- ALTAS --->
	<cfif isdefined("Form.Alta")>
		<!--- <cf_dump var="#rsValidate.recordCount#"> --->
		<cfif rsValidate.recordCount EQ 0>
			<cfif not isdefined("Form.Empresa")>
			<cfquery datasource="#Session.DSN#">
				INSERT INTO CEMtdoPago(Clave,Concepto)
	            VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Concepto#">)
			</cfquery>

			<cfelse>
			<cfquery datasource="#Session.DSN#">
				INSERT INTO CEMtdoPago(Clave,Concepto,Ecodigo)
	            VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Concepto#">, #Session.Ecodigo#)
			</cfquery>
		</cfif>
			<cfelse>
			<script language="JavaScript" type="text/javascript">
			var msg="El metodo de pago con la clave: <cfoutput>#form.Clave#</cfoutput>, ya existe." 
				alert(msg);
			</script>
		</cfif>
		<cfset modo="ALTA">

	<!--- ELIMINACION --->
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
					DELETE FROM CEMtdoPago WHERE Clave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
		</cfquery>
		
	  	<cfset modo="ALTA">

	<!--- MODIFICACION --->
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			<cfif not isdefined("Form.Empresa")>
				UPDATE CEMtdoPago SET Concepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Concepto#">, Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">, Ecodigo = NULL WHERE Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ClaveOld#">
				<cfelse> 
				UPDATE CEMtdoPago SET Concepto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Concepto#">, Ecodigo=#Session.Ecodigo# WHERE Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ClaveOld#">
			</cfif>
		</cfquery>
	  	<cfset modo="CAMBIO">
	</cfif>
</cfif>

	<cfset LvarAction = 'list.cfm'>


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>

	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="clave" type="hidden" value="<cfif isdefined("Form.clave")>#Form.clave#</cfif>">
	</cfif>
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>