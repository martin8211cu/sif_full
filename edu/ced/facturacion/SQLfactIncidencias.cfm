
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_FacturaIncidencias" datasource="#Session.Edu.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
			

				insert into Incidencias (CEcodigo, Ecodigo, Idescripcion, Ifecha, Imonto, ITid)
				values(
					<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_char">,
					convert( datetime, <cfqueryparam value="#form.Ifecha#" cfsqltype="cf_sql_varchar">, 103 ),
					<cfqueryparam value="#Form.Imonto#" cfsqltype="cf_sql_money">,
					<cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
					)

				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
	
				delete from Incidencias
				where Iid = <cfqueryparam value="#Form.Iid#" cfsqltype="cf_sql_numeric">
	
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Incidencias set
					Ecodigo = <cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">,
					Imonto = <cfqueryparam value="#Form.Imonto#" cfsqltype="cf_sql_money">,
					Idescripcion = <cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_char">,
					Ifecha = convert( datetime, <cfqueryparam value="#Form.Ifecha#" cfsqltype="cf_sql_varchar">, 103 ),
					ITid = <cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
				where Iid = <cfqueryparam value="#Form.Iid#" cfsqltype="cf_sql_numeric">
				  <cfset modo="CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="../facturacion/FactIncidencias.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Iid" type="hidden" value="<cfif isdefined("Form.Iid")><cfoutput>#Form.Iid#</cfoutput></cfif>">
	<input name="ITid" type="hidden" value="<cfif isdefined("Form.ITid")><cfoutput>#Form.ITid#</cfoutput></cfif>">
	<!--- <input name="modulo" type="hidden" value="<cfif isdefined("form.modulo")><cfoutput>#form.modulo#</cfoutput></cfif>"> --->
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


