<!---SQL De Detalle de Otras Deducciones Pagos --->
<!--- Variable de desarrollo para saber la acción realizada --->
<cfset Which = "">
<!--- Acciones --->
<cfif isDefined("Form.Accion") and len(trim(Form.Accion)) gt 0 and Form.Accion neq "Nuevo">
	<cftry>
		<cfquery name="rsOperaciones" datasource="#Session.DSN#">
			set nocount on
			<cfif UCase(Form.Accion) eq "ALTA"><!--- Alta --->
				insert into DDeducPagos
				(DRNlinea, DDdescripcion, DDmonto, CBcc, Mcodigo, DDnombre, DDidbeneficiario, DDpago, DDpagopor)
				values
				(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNlinea#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDmonto#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDnombre#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDidbeneficiario#">, 
				<cfif isDefined("Form.DDpago")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DDpagopor#">)
				<cfset Which = "Alta">
			<cfelseif UCase(Form.Accion) eq "CAMBIO"><!--- Cambio --->
				update DDeducPagos
				set DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">, 
				DDmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDmonto#">, 
				CBcc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CBcc#">, 
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
				DDnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDnombre#">, 
				DDidbeneficiario = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDidbeneficiario#">, 
				DDpago = <cfif isDefined("Form.DDpago")>1<cfelse>0</cfif>,
				DDpagopor = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DDpagopor#">
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#"> 
				<cfset Which = "Cambio">
			<cfelseif UCase(Form.Accion) eq "BAJA"><!--- Baja --->
				Delete from DDeducPagos
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#"> 
				<cfset Which = "Baja">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
	</cfcatch>
	</cftry>
</cfif>
<!--- Form --->
<form action="formDDeducPagos.cfm" method="post" name="SQLform">
	<input name="DRNlinea" type="hidden" value="<cfif isDefined("Form.DRNlinea")><cfoutput>#Form.DRNlinea#</cfoutput></cfif>">
	<input  name="DDpagopor" type="hidden" value="<cfif isDefined("Form.DDpagopor")><cfoutput>#Form.DDpagopor#</cfoutput></cfif>">
	<input name="formName" type="hidden" value="<cfif isDefined("Form.formName")><cfoutput>#Form.formName#</cfoutput></cfif>">
	<input  name="deducciones" type="hidden" value="<cfif isDefined("Form.deducciones")><cfoutput>#Form.deducciones#</cfoutput></cfif>">
</form>
<!--- Html --->
<html>
	<head>
		<title>Detalle de Otras Deducciones Pagos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<body>
		<!--- OJO Comentar al Terminar y Descomentar el script
		<cfdump var="#Form#">
		Acci&oacute;n = '<cfoutput>#Which#</cfoutput>' (si est&aacute; vac&iacute;o no hizo nada).
		<a href="javascript: document.SQLform.submit();">Continuar</a>--->
		<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
	</body>
</html>