<cf_navegacion name="Bid">
<cf_navegacion name="CBid">
<cf_navegacion name="Mcodigo">
<cf_navegacion name="ts_rversion">
<cf_navegacion name="CBPMid">
<cf_navegacion name="BTid">

<cfif isdefined("form.McodigoS")>
	<cfset form.Mcodigo = form.McodigoS>
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Insertae" datasource="#Session.DSN#">
			<cfif isdefined("Form.Alta")>
				Insert CuentasPorMoneda (Bid,CBid,Mcodigo,BTid,Ecodigo)
				values
				(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				)
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
					delete from CuentasPorMoneda
					where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
						and CBPMid  = <cfqueryparam value="#Form.CBPMid#" cfsqltype="cf_sql_numeric">
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update CuentasPorMoneda set
						Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
                        CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">,
                        Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                        BTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and CBPMid = <cfqueryparam value="#Form.CBPMid#" cfsqltype="cf_sql_numeric">
				<cfset modo="ALTA">
			</cfif>
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="CBPMid" type="hidden" value="<cfif isdefined("Form.CBPMid")><cfoutput>#Form.CBPMid#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>