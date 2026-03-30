<!--- <cf_dump var="#form#"> --->

<cfif isdefined("Form.Guardar")>
	<cfquery datasource="#Session.DSN#">
		delete  from CECuentasCFDI where Ccuenta =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CECuentasCFDI(Ccuenta,Descripcion,CFormato,Ecodigo)
		values(
		       <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
		       (select Cdescripcion as cdescripcion from CContables where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">),
		       <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">+'-'+<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFormato#">,
		       <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
               )
	</cfquery>

</cfif>

<cfif isdefined("Form.Eliminar")>
	<cfquery datasource="#Session.DSN#">
		delete  from CECuentasCFDI where Ccuenta =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
	</cfquery>
</cfif>

<cfset LvarAction = 'ParametrosCE.cfm'>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
    <input type="hidden" name="modo" value="#form.modo#">
	<cfif #form.modo# eq "CAMBIO">
		<input type="hidden" name="CFCUENTA" value="#form.Ccuenta#">
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