<cfparam name="action" default="tipoRelacion.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_Ocupaciones" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert CRMTipoRelacion (CEcodigo, Ecodigo, CRMTRcodigo, CRMTRdescripcion)
				values (
				<cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">, 
				<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
				<cfqueryparam value="#form.CRMTRcodigo#" cfsqltype="cf_sql_char">, 
				<cfqueryparam value="#form.CRMTRdescripcion#" cfsqltype="cf_sql_varchar">
				)

			<cfelseif isdefined("form.Cambio")>	
				update CRMTipoRelacion
					set CRMTRcodigo = <cfqueryparam value="#form.CRMTRcodigo#" cfsqltype="cf_sql_char">,
						CRMTRdescripcion = <cfqueryparam value="#form.CRMTRdescripcion#" cfsqltype="cf_sql_varchar">
				where CRMTRid =  <cfqueryparam value="#form.CRMTRid#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete from CRMTipoRelacion
				where CRMTRid =  <cfqueryparam value="#form.CRMTRid#" cfsqltype="cf_sql_numeric">
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
	<cfif modo eq 'CAMBIO'><input name="CRMTRid" type="hidden" value="#form.CRMTRid#"></cfif>
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