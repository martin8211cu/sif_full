<cfif isdefined('form.CcuentaCxP') and len(trim(form.CcuentaCxP)) GT 0>
<cfset Form.Ccuenta= form.CcuentaCxP>
</cfif>
<cfif isdefined ('form.DCambio') and Form.DCambio eq "Modificar" and isdefined ('Form.Ccuenta') and len(trim(Form.Ccuenta)) GT 0>	
	<cftransaction>
	<cfquery name="rs" datasource="#session.dsn#">
			UPDATE CuentasBancos
			SET 
				CcuentaCxP=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			WHERE
				CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
		</cfquery>
		</cftransaction>
</cfif>
<cfif isdefined ('form.DBorrar') and Form.DBorrar eq "Eliminar" and isdefined ('Form.Ccuenta') and len(trim(Form.Ccuenta)) GT 0>	
	<cftransaction>
	<cfquery name="rs" datasource="#session.dsn#">
			UPDATE CuentasBancos
			SET 
				CcuentaCxP = null
			WHERE
				CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
		</cfquery>
		</cftransaction>
</cfif>

<form action="SalariosPorPagar.cfm" method="post" name="SQLform">
<cfif isdefined ('form.CBid') and len(trim(form.CBid)) GT 0>
	<input type="hidden" name="CBid" value="<cfoutput>#form.CBid#</cfoutput>">
</cfif>
</form>
<html>
<head>
<title>Salarios Por Pagar</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
</body>
</html>
