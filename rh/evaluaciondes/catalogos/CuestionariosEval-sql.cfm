<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="sihay" datasource="#Session.DSN#">
			select PCid as hay from RHEvaluacionCuestionarios 
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		</cfquery>
		<cfif isdefined("sihay") and sihay.RecordCount GT 0>

		<cfelse>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHEvaluacionCuestionarios (Ecodigo, PCid, BMUsucodigo, fechaalta)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					) 
			</cfquery>
		</cfif>
		<cfset modo = "ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHEvaluacionCuestionarios
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		</cfquery>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfoutput>
<form action="CuestionariosEval.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="PCid" type="hidden" value="<cfif isdefined("form.PCid") and modo neq 'ALTA'>#form.PCid#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
