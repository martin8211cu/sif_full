
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_FacturaConceptos" datasource="#Session.Edu.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists ( select 1 from FacturaConceptos 
					where FCdescripcion = <cfqueryparam value="#Form.FCdescripcion#" cfsqltype="cf_sql_varchar">
				)
				begin
				
					insert into FacturaConceptos (FCdescripcion, FCcodigo, FCmonto)
					values(
						<cfqueryparam value="#Form.FCdescripcion#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Form.FCcodigo#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#Form.FCmonto#" cfsqltype="cf_sql_money">
						)
				end	
				else 
					select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				if not exists (select 1 from FactConceptosAlumno 
								where FCid =  <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
				)
				begin
					delete from FacturaConceptos
					where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
				end
				else 
					select 1
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update FacturaConceptos set
					FCdescripcion = <cfqueryparam value="#Form.FCdescripcion#" cfsqltype="cf_sql_varchar">,
					FCmonto = <cfqueryparam value="#Form.FCmonto#" cfsqltype="cf_sql_money">,
					FCcodigo = <cfqueryparam value="#Form.FCcodigo#" cfsqltype="cf_sql_char">
				where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
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
<form action="../facturacion/Facturacion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="modulo" type="hidden" value="<cfif isdefined("form.modulo")><cfoutput>#form.modulo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


