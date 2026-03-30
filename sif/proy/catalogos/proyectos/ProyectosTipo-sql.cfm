<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
				insert into PRJTiposProyectos (Ecodigo, PRJTdescripcion)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJTdescripcion#">
				)
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
				delete PRJTiposProyectos 
				where PRJTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJTid#">
			</cfquery>
			<cfset modo="BAJA">

		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
				update PRJTiposProyectos set 
					PRJTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJTdescripcion#">
				where PRJTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJTid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)				
			</cfquery>		
			<cfset modo="ALTA">  				  
		</cfif>			
		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="ProyectosTipo.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="PRJTid" type="hidden" value="#PRJTid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
