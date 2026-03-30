
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_IncidenciasTipo" datasource="#Session.Edu.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists ( select 1 from IncidenciasTipo 
					where ITdescripcion = <cfqueryparam value="#Form.ITdescripcion#" cfsqltype="cf_sql_varchar">
				)
				begin
				
					insert into IncidenciasTipo (ITdescripcion, ITcodigo, ITmonto)
					values(
						<cfqueryparam value="#Form.ITdescripcion#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Form.ITcodigo#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#Form.ITmonto#" cfsqltype="cf_sql_money">
						)
				end	
				else 
					select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				if not exists (select 1 from Incidencias 
								where ITid =  <cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
				)
				begin
					if not exists (select 1 from DFactura 
									where ITid =  <cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
					)
					begin					
						delete from IncidenciasTipo
						where ITid = <cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
					end
					else 
						select 1
				end
				else 
					select 1
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update IncidenciasTipo set
					ITdescripcion = <cfqueryparam value="#Form.ITdescripcion#" cfsqltype="cf_sql_varchar">,
					ITmonto = <cfqueryparam value="#Form.ITmonto#" cfsqltype="cf_sql_money">,
					ITcodigo = <cfqueryparam value="#Form.ITcodigo#" cfsqltype="cf_sql_char">
				where ITid = <cfqueryparam value="#Form.ITid#" cfsqltype="cf_sql_numeric">
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
<form action="Incidencias.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="ITid" type="hidden" value="<cfif isdefined("Form.ITid")><cfoutput>#Form.ITid#</cfoutput></cfif>">
	<input name="modulo" type="hidden" value="<cfif isdefined("form.modulo")><cfoutput>#form.modulo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<input name="o" type="hidden" value="<cfif isdefined("form.o")><cfoutput>#form.o#</cfoutput></cfif>">
	<input name="persona" type="hidden" value="<cfif isdefined("Form.persona")><cfoutput>#Form.persona#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


