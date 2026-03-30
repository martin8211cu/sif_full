<cfset params = ''>
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="nuevo" datasource="#Session.DSN#">			
				insert into RHLiqRecalcular (Ecodigo,CIidrecalculo,CIidresultado)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidAjustar#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidAjustado#">
						)
			</cfquery>
			<cfset params = '?modo=CAMBIO'>				
		<cfelseif isdefined("Form.Baja")>						
			<cfquery datasource="#session.DSN#">
				delete from RHLiqRecalcular 
				where CIidrecalculo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidrecalculo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset modo="BAJA">
			<cfset params = '?modo='& modo>
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<cfoutput>	
	<cflocation url="recalcularliquidacion.cfm?#params#">
</cfoutput>
