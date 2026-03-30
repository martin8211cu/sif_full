<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_tiposCiclos" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert TarifasTipo 
					(Ecodigo, TTnombre, TTtipo)
					values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_tinyint">
						, <cfqueryparam value="#form.TTnombre#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.TTtipo#" cfsqltype="cf_sql_tinyint">)				

					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
					delete TarifasTipo
					where TTcodigo = <cfqueryparam value="#form.TTcodigo#" cfsqltype="cf_sql_numeric">
					   
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Cambio")>
					update TarifasTipo set
						TTnombre = <cfqueryparam value="#form.TTnombre#" cfsqltype="cf_sql_varchar">,
						TTtipo = <cfqueryparam value="#form.TTtipo#" cfsqltype="cf_sql_tinyint">
					where TTcodigo = <cfqueryparam value="#form.TTcodigo#" cfsqltype="cf_sql_numeric">
					  
					<cfset modo="CAMBIO">
				</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="tipoTarifas.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="TTcodigo" id="TTcodigo" type="hidden" value="<cfif isdefined("Form.TTcodigo") and modo NEQ 'ALTA'>#Form.TTcodigo#</cfif>">
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