<cfset action = 'cons-expediente-portada.cfm'>

<cftransaction>
			<cfif isdefined("Form.btnAgregar")>	
				<cfquery name="rs_agrega" datasource="#Session.DSN#">
					insert into DExpedienteEmpleadoP (DEid, DEEPfecha, DEEPpatologia, DEEPtratamiento )
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECEfecha)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.patologia#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tratamiento#">
						)
				</cfquery>
			</cfif>	
	
			<cfif isdefined("Form.btnBorrar")>
				<cfquery name="rs_borra" datasource="#Session.DSN#">
					delete from DExpedienteEmpleadoP 
					where DEEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrar#">
				</cfquery>
			</cfif>	
				
</cftransaction>

<!---<cflocation url="cons-expediente-portada.cfm">--->

<form action="<cfoutput>#action#</cfoutput>" method="post" name="form">
	<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">

</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
