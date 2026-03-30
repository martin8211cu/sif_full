<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Carrera" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert Carrera (Ecodigo, CARnombre, CARcodificacion, EScodigo)
					values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.CARnombre#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#CARcodificacion#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.EScodigo#" cfsqltype="cf_sql_numeric">)
					
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
					delete Carrera
					where CARcodigo = <cfqueryparam value="#Form.CARcodigo#" cfsqltype="cf_sql_numeric">
						and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					   	and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					   
					<cfset modo="LISTA">
				<cfelseif isdefined("Form.Cambio")>
					update Carrera set
						CARnombre = <cfqueryparam value="#Form.CARnombre#" cfsqltype="cf_sql_varchar">,
						CARcodificacion = <cfqueryparam value="#Form.CARcodificacion#" cfsqltype="cf_sql_varchar">,
						EScodigo = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						and CARcodigo  = <cfqueryparam value="#Form.CARcodigo#" cfsqltype="cf_sql_numeric">
					  	and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					  
					<cfset modo="LISTA">
				</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="CarrerasPlanes.cfm" method="post" name="sql">
<cfoutput>
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevoPlan")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
			<cfset modo = "ALTA">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
		<input type="hidden" name="EScodigo" value="#Form.EScodigo#">
	</cfif>
	<cfif modo neq 'ALTA' or isdefined("Form.btnNuevoPlan")>
		<input name="CARcodigo" type="hidden" value="#Form.CARcodigo#">
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