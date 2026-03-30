<cfif isdefined('form.chk')>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.DSN#">
			update IncidenciasMarcas 
			set RetenerPago = 1
			where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		</cfquery>			
	</cfloop> 
</cfif>


<form action="aprobacionIncidencias.cfm" method="post" name="sql">
	<cfoutput>
		<input name="RHPMid" type="hidden" value="#form.RHPMid#">
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>