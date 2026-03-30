<cfparam name="action" default="tipoEvento.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_Ocupaciones" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert CRMTipoEvento (CEcodigo, Ecodigo, CRMTEVcodigo, CRMTEVdescripcion, CRMTEVseguimiento, CRMTEVpublico)
					values (
					<cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
					<cfqueryparam value="#form.CRMTEVcodigo#" cfsqltype="cf_sql_char">, 
					<cfqueryparam value="#form.CRMTEVdescripcion#" cfsqltype="cf_sql_varchar">,
					<cfif isdefined("form.CRMTEVseguimiento")>1<cfelse>0</cfif>,
					<cfif isdefined("form.CRMTEVpublico")>1<cfelse>0</cfif>
					)
					
			<cfelseif isdefined("form.Cambio")>	
				update CRMTipoEvento
					set CRMTEVcodigo = <cfqueryparam value="#form.CRMTEVcodigo#" cfsqltype="cf_sql_char">,
						CRMTEVdescripcion = <cfqueryparam value="#form.CRMTEVdescripcion#" cfsqltype="cf_sql_varchar">,
						CRMTEVseguimiento = <cfif isdefined("form.CRMTEVseguimiento")>1<cfelse>0</cfif>,
						CRMTEVpublico = <cfif isdefined("form.CRMTEVpublico")>1<cfelse>0</cfif>
				where CRMTEVid =  <cfqueryparam value="#form.CRMTEVid#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete from CRMTipoEvento
				where CRMTEVid =  <cfqueryparam value="#form.CRMTEVid#" cfsqltype="cf_sql_numeric">
					and CEcodigo=<cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
					and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
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
	<cfif modo eq 'CAMBIO'><input name="CRMTEVid" type="hidden" value="#form.CRMTEVid#"></cfif>
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