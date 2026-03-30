<!---  --->
<cfset params = "">
<cfset modo = "ALTA">
<!--- <cf_dump var="#form#"> --->

<cftry>
	<cfif isdefined("form.Alta")>
		<cfquery name="rsCF" datasource="#session.DSN#">
			insert into CRCCCFuncionales (CRCCid,CFid,BMUsucodigo,CRCCfalta)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRCCid#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
		</cfquery>

		<cfset params="&modo="&#modo#>
								
	<cfelseif isdefined("form.Baja")>
		<cfquery name="rsCF" datasource="#session.DSN#">
			delete from CRCCCFuncionales
			where CRTCCid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRTCCid#">
			  and CFid     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#">
		</cfquery>	

		<cfset params="?modo="&#modo#>
	</cfif> 

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="CentrosF-Custodia.sql.cfm#params#">