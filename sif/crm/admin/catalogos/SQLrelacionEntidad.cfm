<cfparam name="action" default="relacionEntidad.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_Ocupaciones" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert CRMRelacionEntidad 
				(CEcodigo, Ecodigo, CRMEid1, CRMEid2, CRMTRid, CRMREfechaini, CRMREfechafin)
				values (
					<cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
					<cfqueryparam value="#form.CRMEid1#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.CRMEid2#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.CRMTRid#" cfsqltype="cf_sql_numeric">,
					convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMREfechaini#">, 103),
					convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMREfechafin#">, 103)
				)
			<cfelseif isdefined("form.Cambio")>	
				update CRMRelacionEntidad
					set CRMEid1= <cfqueryparam value="#form.CRMEid1#" cfsqltype="cf_sql_numeric">,
					 CRMEid2= <cfqueryparam value="#form.CRMEid2#" cfsqltype="cf_sql_numeric">,
					 CRMTRid= <cfqueryparam value="#form.CRMTRid#" cfsqltype="cf_sql_numeric">,
					 CRMREfechaini= convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMREfechaini#">, 103),
					 CRMREfechafin= convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMREfechafin#">, 103)
				where CRMREid =  <cfqueryparam value="#form.CRMREid#" cfsqltype="cf_sql_numeric">
					and CEcodigo= <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
					and Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete from CRMRelacionEntidad
				where CRMREid =  <cfqueryparam value="#form.CRMREid#" cfsqltype="cf_sql_numeric">
					and CEcodigo= <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
					and Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<input name="CRMREid" type="hidden" value="#form.CRMREid#">
	</cfif>
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