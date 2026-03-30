<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Talonarios" datasource="#Session.DSN#">
			<cfif isdefined("Form.Alta")>
				Insert TipoVentaPerdida (Ecodigo, VPnombre)
				values
				(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.VPnombre)#">
				)
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
					delete from TipoVentaPerdida
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and VPid = <cfqueryparam value="#Form.VPid#" cfsqltype="cf_sql_numeric">
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update TipoVentaPerdida set 
						VPnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.VPnombre)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and VPid = <cfqueryparam value="#Form.VPid#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				<cfset modo="ALTA">
			</cfif>
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="VentaPerdida.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="VPid" type="hidden" value="<cfif isdefined("Form.VPid")><cfoutput>#Form.VPid#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>