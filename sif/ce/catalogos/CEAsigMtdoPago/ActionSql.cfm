<cfparam name="modo" default="ALTA">
<!--- <cf_dump var="#form.idasig#"> --->
<cfif not isdefined("Form.Nuevo")>
	<!--- MODIFICACION --->
		<cfquery datasource="#session.DSN#">
			<cfif isdefined("Form.MtdoPago") AND MtdoPago EQ -1>
				UPDATE TEStipoMedioPago SET TESTMPMtdoPago = NULL WHERE TESTMPtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idasig#"> 
				<cfelse> 
				UPDATE TEStipoMedioPago SET TESTMPMtdoPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mtdopago#"> WHERE TESTMPtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idasig#">
			</cfif>
		</cfquery>
	  	<cfset modo="CAMBIO">
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