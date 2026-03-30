<cfparam name="action" default="SalarioPuesto.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
<!---	<cftry>--->
		<cfquery name="ABC_SalarioPuesto" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert SalarioPuesto ( Ecodigo, NPcodigo, RHPcodigo, SPfechaini, SPfechafin, SPsalario )
							 values ( <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">,
									  <cfqueryparam value="#form.NPcodigo#"       cfsqltype="cf_sql_char">,
									  <cfqueryparam value="#form.RHPcodigo#"       cfsqltype="cf_sql_char">,
									  convert(datetime, <cfqueryparam value="#form.SPfechaini#" cfsqltype="cf_sql_char">, 103),
									  <cfif len(trim(form.SPfechafin)) gt 0 >convert(datetime, <cfqueryparam value="#form.SPfechafin#" cfsqltype="cf_sql_char">, 103)<cfelse>null</cfif>,
									  <cfqueryparam value="#form.SPsalario#"       cfsqltype="cf_sql_money">
									)
				
			<cfelseif isdefined("form.Cambio")>
				update SalarioPuesto
				set NPcodigo   = <cfqueryparam value="#form.NPcodigo#"       cfsqltype="cf_sql_char">, 
				    RHPcodigo  = <cfqueryparam value="#form.RHPcodigo#"       cfsqltype="cf_sql_char">, 
					SPfechaini = convert(datetime, <cfqueryparam value="#form.SPfechaini#" cfsqltype="cf_sql_char">, 103), 
					SPfechafin = <cfif len(trim(form.SPfechafin)) gt 0 >convert(datetime, <cfqueryparam value="#form.SPfechafin#" cfsqltype="cf_sql_char">, 103)<cfelse>null</cfif>, 
					SPsalario  = <cfqueryparam value="#form.SPsalario#"       cfsqltype="cf_sql_money">
				where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SPid      =  <cfqueryparam value="#form.SPid#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				  
				  <cfset modo = 'CAMBIO'>
				  
			<cfelseif isdefined("form.Baja")>
				delete from SalarioPuesto
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SPid    = <cfqueryparam value="#form.SPid#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
<!---
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cfif>	

<cfoutput>
<form action="SalarioPuesto.cfm" method="post" name="sql">
	<input name="modo"      type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="RHPcodigo" type="hidden" value="<cfif isdefined("form.RHPcodigo")>#form.RHPcodigo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="SPid" type="hidden" value="#form.SPid#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>