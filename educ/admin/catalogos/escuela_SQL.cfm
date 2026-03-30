<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Facultad" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert Escuela 
						(Ecodigo, Fcodigo, EScodificacion, ESnombre, ESprefijo, Scodigo)
					values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#form.Fcodigo#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#form.EScodificacion#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#form.ESnombre#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#form.ESprefijo#" cfsqltype="cf_sql_char">,
						null
					)
						
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
					delete Escuela
					where Fcodigo = <cfqueryparam value="#Form.Fcodigo#" cfsqltype="cf_sql_numeric">
						and EScodigo = <cfqueryparam value="#form.EScodigo#" cfsqltype="cf_sql_numeric">
						and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					   
					<cfset modo="LISTA">
				<cfelseif isdefined("Form.Cambio")>
					update Escuela set
						EScodificacion = <cfqueryparam value="#form.EScodificacion#" cfsqltype="cf_sql_varchar">
						, ESnombre = <cfqueryparam value="#form.ESnombre#" cfsqltype="cf_sql_varchar">
						, ESprefijo = <cfqueryparam value="#form.ESprefijo#" cfsqltype="cf_sql_char">
					where Fcodigo = <cfqueryparam value="#Form.Fcodigo#" cfsqltype="cf_sql_numeric">
						and EScodigo = <cfqueryparam value="#form.EScodigo#" cfsqltype="cf_sql_numeric">
						and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  	and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						
					<cfset modo="LISTA">
				</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="facultades.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input type="hidden" name="nivel" value="#Form.nivel#">
	<cfif modo neq 'ALTA'>
		<input name="EScodigo" type="hidden" value="#Form.EScodigo#">		
	</cfif>
	<input name="Fcodigo" type="hidden" value="#Form.Fcodigo#">	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>