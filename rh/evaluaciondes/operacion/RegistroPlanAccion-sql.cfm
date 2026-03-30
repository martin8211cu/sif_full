<cfif isdefined("form.Aceptar")>
	<cfquery datasource="#session.DSN#">
		update RHListaEvalDes
		set RHLEobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHLEobservacion#">
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and DEid =     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>
<form action="RegistroPlanAccion.cfm" method="post" name="sql">
	<input name="RHEEid" 			type="hidden" value="<cfif isdefined("form.RHEEid")><cfoutput>#form.RHEEid#</cfoutput></cfif>">	
	<input name="DEid" 				type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">	
	<input name="DEIDENTIFICACION" 	type="hidden" value="<cfif isdefined("form.DEIDENTIFICACION2")><cfoutput>#form.DEIDENTIFICACION2#</cfoutput></cfif>">	
	<input name="NOMBREEMP" 		type="hidden" value="<cfif isdefined("form.NOMBREEMP2")><cfoutput>#form.NOMBREEMP2#</cfoutput></cfif>">	
	<cfif isdefined("form.Aceptar")>
	<input name="Procesar" 		type="hidden">	
	</cfif>
 </form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>