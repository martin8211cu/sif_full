<cfcomponent extends="base">
	<cffunction name="generacionTarjeta" access="public" returntype="void" output="false">
		<cfargument name="TPPLOG" type="string" required="yes">
		<cfargument name="TPPPRE" type="string" required="yes">
		<cfargument name="TPPFGN" type="date" required="yes">
		<cfargument name="origen" type="string" default="siic">
		
		<cfset control_inicio( Arguments, 'H032', Arguments.TPPLOG )>
		<cftry>
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="generacionTarjeta_Q">
				select TPPPAS,TPPPRE
				from SSGTPP 
				where TPPLOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TPPLOG#">
				  and TPPPRE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TPPPRE#">
				  <!---and TPPFGN = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPPFGN#">--->
			</cfquery>

			<cfquery datasource="#session.dsn#" name="datos_prefijo">
				select vigencia,preciotarjeta,(preciotarjeta/preciohora) * 3600 as segundosoriginales
				from ISBprefijoPrepago
				where prefijo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TPPPRE#">
			</cfquery>

			<cfif isdefined('datos_prefijo') and datos_prefijo.RecordCount eq 0>
				<cfthrow message="No existe el Prefijo #Arguments.TPPPRE#">		
			</cfif>
			
			<cfif isdefined('generacionTarjeta_Q') and generacionTarjeta_Q.RecordCount eq 0>
				<cfthrow message="No se encontro la tarjeta #Arguments.TPPLOG#">		
			</cfif>
			
			<cfset control_servicio( 'saci' )>
			<cfinvoke component="saci.comp.ISBprepago" method="Alta"
				PQcodigo="0020"
				TJlogin="#Arguments.TPPLOG#"
				TJpassword="#generacionTarjeta_Q.TPPPAS#"
				
				TJgeneracion="#Arguments.TPPFGN#"
				TJestado="0"
				TJliquidada="0"
				TJprecio = "#datos_prefijo.preciotarjeta#"
				TJvigencia="#datos_prefijo.vigencia#"
				TJoriginal="#datos_prefijo.segundosoriginales#"
				TJdsaldo="#datos_prefijo.segundosoriginales#" />
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="generacionTarjeta_Q">
				update SSGTPP
				set TPPESTR = 1
				where TPPLOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TPPLOG#">
				  and TPPPRE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TPPPRE#">
				  and TPPFGN = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPPFGN#">
			</cfquery>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>