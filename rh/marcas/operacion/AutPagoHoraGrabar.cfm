
<cfquery name="GrabaIncMarcas" datasource="#Session.DSN#">
	Update IncidenciasMarcas
	set
		RetenerPago = <cfif isdefined('form.RetenerPago')> 1, <cfelse> 0, </cfif>
		JustificacionNoPago = <cfif isdefined('form.RetenerPago')>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.JustificacionNoPago#">
							  <cfelse>
							  	null
							  </cfif>			
	where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
		
</cfquery>

<form action="AutPagoHora-form.cfm" method="post" name="sql">
	<cfoutput>
		<input name="Iid" type="hidden" value="#form.Iid#"> 
		<input name="DEid" type="hidden" value="#form.DEid#">
		<input name="RHDMid" type="hidden" value="#form.RHDMid#">
		<input name="RHPMid" type="hidden" value="#form.RHPMid#">
		<input name="RHCMid" type="hidden" value="#form.RHCMid#">
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
