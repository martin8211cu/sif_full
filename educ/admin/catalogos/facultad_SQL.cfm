<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Facultad" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert Facultad (Ecodigo, Fnombre, Fcodificacion)
					values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.Fnombre#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.Fcodificacion#" cfsqltype="cf_sql_varchar">
					)					
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
					delete Facultad
					where Fcodigo = <cfqueryparam value="#Form.Fcodigo#" cfsqltype="cf_sql_numeric">
						and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					   	and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					   
					<cfset modo="LISTA">
				<cfelseif isdefined("Form.Cambio")>
					update Facultad set
						Fnombre = <cfqueryparam value="#Form.Fnombre#" cfsqltype="cf_sql_varchar">,
						Fcodificacion = <cfqueryparam value="#Form.Fcodificacion#" cfsqltype="cf_sql_varchar">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						and Fcodigo  = <cfqueryparam value="#Form.Fcodigo#" cfsqltype="cf_sql_numeric">
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
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevoPlan")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	<cfif modo neq 'ALTA' or isdefined("Form.btnNuevoPlan")>
		<input name="Fcodigo" type="hidden" value="#Form.Fcodigo#">
	</cfif>
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