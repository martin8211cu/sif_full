<cfcomponent extends="base">
	<cffunction name="generacionSobre" access="public" returntype="void" output="false">
		<cfargument name="SOBCON" type="numeric">
		<cfargument name="origen" type="string" default="siic">
		
		<cfset control_inicio( Arguments, 'H033', 'sobre :' & Arguments.SOBCON )>
		<cftry>
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="generacionSobre_Q">
				select SOBACC, SOBCOR, SOBGEN, SOBTIP,
					<!--- El agente 199 es racsa en SACI2, y en SACI1/SIIC era el 0 --->
					case when SOBDUE = 0 then 199 else SOBDUE end as AGid
				from SSXSOB
				where SOBCON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SOBCON#">
			</cfquery>
			<cfset control_servicio( 'saci' )>
			<cfinvoke component="saci.comp.ISBsobres" method="Alta"
				Snumero="#Arguments.SOBCON#"
				SpwdAcceso="#generacionSobre_Q.SOBACC#"
				SpwdCorreo="#generacionSobre_Q.SOBCOR#"
				AGid="#generacionSobre_Q.AGid#"
				Sgenero="#generacionSobre_Q.SOBGEN#"
				Stipo="#generacionSobre_Q.SOBTIP#"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>