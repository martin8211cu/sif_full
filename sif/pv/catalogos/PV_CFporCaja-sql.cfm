<cfset params="">
<!---Agregar--->
<cfif isdefined('form.Alta')>
	<cfquery name="insertCajaCentroFuncional" datasource="#session.dsn#">
		insert into CajaCentroFuncional
		(Ecodigo,FAM01COD,CFid,CFcodigo, BMUsucodigo)
		values
		(
		#session.Ecodigo#, 
		<cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.FAM01COD#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
		<cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.CFcodigo#">,
		#session.usucodigo#
		)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertCajaCentroFuncional">
		<cfset params = 'PVCajaCFid='& insertCajaCentroFuncional.identity>	
<!---Cambio--->
<cfelseif isdefined('form.Cambio')>
	<cfset params = 'PVCajaCFid='& #form.PVCajaCFid#>
	<cfquery datasource="#session.dsn#">
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CajaCentroFuncional" 
			redirect="PV_CFporCaja.cfm?#params#"
			timestamp="#form.ts_rversion#"
			field1="PVCajaCFid,numeric,#form.PVCajaCFid#"> 
					
		update CajaCentroFuncional set
			FAM01COD     = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.FAM01COD#">,
			CFid         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
			CFcodigo     = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.CFcodigo#">,
			BMUsucodigo  = #session.usucodigo#
		where PVCajaCFid = #form.PVCajaCFid#
	</cfquery>
<!---Eliminar--->
<cfelseif isdefined('form.baja')>
		<cfquery datasource="#session.dsn#">
			delete from CajaCentroFuncional 
			 where PVCajaCFid = #form.PVCajaCFid#
		</cfquery>
</cfif>
<cflocation url="PV_CFporCaja.cfm?#params#">
