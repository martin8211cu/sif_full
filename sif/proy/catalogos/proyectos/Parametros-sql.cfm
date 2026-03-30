<cfif isdefined("Form.btnGuardar")>
	<cftry>
		<cfif Len(Trim(Form.ts_rversion))>
			<cfquery name="updParams" datasource="#Session.DSN#">
				if not exists (
					select 1
					from PRJproyecto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				)
				update PRJparametros set 
					PCEcatidProyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatidProyecto#">, 
					PCEcatidRecurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatidRecurso#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="updParams" datasource="#Session.DSN#">
				insert into PRJparametros (Ecodigo, PCEcatidProyecto, PCEcatidRecurso)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatidProyecto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatidRecurso#">
				)
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="Parametros.cfm" method="post" name="sql">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
