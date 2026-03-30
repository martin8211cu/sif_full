<cfparam name="action" default="PuestosExt.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_PuestosExternos" datasource="#session.DSN#">
				insert into RHPuestosExternos (Ecodigo, RHPEcodigo, RHPEdescripcion)
				values ( 
					<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.RHPEcodigo#" cfsqltype="cf_sql_char">,
					<cfqueryparam value="#form.RHPEdescripcion#"  cfsqltype="cf_sql_varchar">
				)
			</cfquery>

		<cfelseif isdefined("form.Cambio")>
			<!--- <cfdump  var="#form#" abort> --->
			<!--- <cf_dbtimestamp
				datasource="#session.dsn#"
				table="RHPuestosExternos"
				redirect="PuestosExt-sql.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHPEid" type1="numeric" value1="#form.RHPEid#"
				field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#"> --->

			<cfquery name="ABC_PuestosExternos" datasource="#session.DSN#">
				update RHPuestosExternos set 
					RHPEcodigo = <cfqueryparam value="#form.RHPEcodigo#" cfsqltype="cf_sql_char">,
					RHPEdescripcion = <cfqueryparam value="#form.RHPEdescripcion#" cfsqltype="cf_sql_varchar">
				where RHPEid = <cfqueryparam value="#form.RHPEid#" cfsqltype="cf_sql_numeric">
				  <!--- and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric"> --->
			</cfquery>
			<cfset modo = 'CAMBIO'>

		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_PuestosExternos" datasource="#session.DSN#">
				delete from RHPuestosExternos
				where RHPEid = <cfqueryparam value="#form.RHPEid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>

	<cfcatch type="any">
		<cfrethrow>
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
	<form action="#action#" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif modo eq 'CAMBIO'><input name="RHPEid" type="hidden" value="#form.RHPEid#"></cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
