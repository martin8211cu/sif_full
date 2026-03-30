
<cfparam name="action" default="Calendario.cfm">
<cfif isdefined("form.ACCION")>
	<cftry>
		<cfif len(trim(form.ACCION)) and form.ACCION eq 'DELETE'>
			
            <cfquery datasource="asp" name="EliminarCitaQuery">
				delete from ORGAgendaCita
				where cita     		= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.cita#">
                and   agenda     	= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.agenda#">
				and   CEcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	
<cfoutput>
<form action="#action#" method="post" name="sql">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>