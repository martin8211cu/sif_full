<!---  RHHabilidades --->
<cfquery name="data" datasource="#session.DSNnuevo#">
	select 1 
	from RHHabilidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif data.recordcount eq 0 >
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHHabilidades(Ecodigo, RHHcodigo, RHHdescripcion,RHHdescdet, BMusuario, BMfecha, BMusumod, BMfechamod, PCid, RHHubicacionB, BMUsucodigo)
		select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			   RHHcodigo, RHHdescripcion, RHHdescdet,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
			   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
			   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			   PCid, RHHubicacionB,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from RHHabilidades
		where Ecodigo = #vn_Ecodigo#
		and RHHubicacionB is not null
	</cfquery>
</cfif>
