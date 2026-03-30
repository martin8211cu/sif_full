<cfset modo = "CAMBIO">
	<cftry>			
		<cfif isdefined("Form.btnAgregarAl") and form.btnAgregarAl EQ 1>
			<cfquery name="A_ProfGuiaAlumno" datasource="#Session.DSN#">
				set nocount on
					insert ProfesorGuiaAlumno 
					(PGpersona, Apersona, PGAfecha, BMUsucodigo)
					values (
						<cfqueryparam value="#form.PGpersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.ApersonaAlumno#" cfsqltype="cf_sql_numeric">
						, getDate()
						, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)
				set nocount off
			</cfquery>
		<cfelseif isdefined("Form.btnDesactAlumno") and form.btnDesactAlumno EQ 1>
			<cfquery name="A_ProfGuiaAlumno" datasource="#Session.DSN#">
				set nocount on
					update ProfesorGuiaAlumno set
						PGAactivo=0
						, PGAfecha = getDate()
						, BMUsucodigo=<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where PGpersona = <cfqueryparam value="#Form.PGpersona#" cfsqltype="cf_sql_numeric">
						and Apersona = <cfqueryparam value="#Form.IdDesactAlumno#" cfsqltype="cf_sql_numeric">
				set nocount off	
			</cfquery>
		<cfelseif isdefined("Form.btnActAlumno") and form.btnActAlumno EQ 1>
			<cfquery name="A_ProfGuiaAlumno" datasource="#Session.DSN#">
				set nocount on
					update ProfesorGuiaAlumno set
						PGAactivo=1
						, PGAfecha = getDate()
						, BMUsucodigo=<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where PGpersona = <cfqueryparam value="#Form.PGpersona#" cfsqltype="cf_sql_numeric">
						and Apersona = <cfqueryparam value="#Form.IdActAlumno#" cfsqltype="cf_sql_numeric">
				set nocount off	
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<form action="profGuia.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="PGpersona" type="hidden" value="<cfif isdefined("Form.PGpersona") and form.PGpersona NEQ ''>#Form.PGpersona#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="TP" type="hidden" value="DI">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>