<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.REindicaciones
	from RHRegistroEvaluacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
		and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">
		and a.REaplicaempleado = 1
</cfquery>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
	<tr>											
		<td>#rsDatos.REindicaciones#</td>
	</tr>
</table>
</cfoutput>
