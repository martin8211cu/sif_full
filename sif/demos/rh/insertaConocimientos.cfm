<!---  RHConocimientos --->
<cfquery name="data" datasource="#session.DSNnuevo#">
	select 1 
	from RHConocimientos 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
</cfquery>
<cfif data.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHConocimientos(Ecodigo, RHCcodigo, RHCdescripcion, BMusuario, BMfecha, BMusumod, BMfechamod)
		select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			  RHCcodigo, RHCdescripcion,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">, 
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		from RHConocimientos
		where Ecodigo=#vn_Ecodigo#
	</cfquery>
</cfif>

