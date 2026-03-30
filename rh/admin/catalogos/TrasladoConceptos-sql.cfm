<cfset params = ''>
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="nuevo" datasource="#Session.DSN#">			
				insert into RHTransferIncidencia (Ecodigo,CIidEmpOrigen,CIidEquivalencia,CIidEmpDestino)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidOrigen#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidEquivalencia#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidDestino#">
						)
			</cfquery>
			<cfset params = '?modo=CAMBIO'>				
		<cfelseif isdefined("Form.Baja")>						
			<cfquery datasource="#session.DSN#">
				delete from RHTransferIncidencia 
				where CIidEmpOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidEmpOrigen#">
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
	<cflocation url="TrasladoConceptos.cfm?#params#">
</cfoutput>
