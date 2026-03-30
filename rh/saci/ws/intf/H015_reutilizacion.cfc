<cfcomponent extends="base">
	<cffunction name="reutilizacion_Login" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">
		<cfargument name="cuecue" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<cfset control_inicio( Arguments, 'H015')>
		<cftry>
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="#session.dsn#" name="querylogin">
				select LGlogin
				from ISBlogin
				where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
				and Habilitado in (2,4)			
			</cfquery>
			
			<cfif Not Len(querylogin.LGlogin)>
			 <cfthrow message="El login #querylogin.LGlogin# no está borrado">		
			</cfif>
			
			<cfquery datasource="#session.dsn#" name="Contrato">
				update ISBlogin set Habilitado = 4
				from ISBlogin
				where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
			</cfquery>

			
			<!--- cumplimiento --->
			<cfif Arguments.origen is 'siic'>
				<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"/>
			</cfif>			
			<cfset control_final( )>

		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				Error="#Request._saci_intf.Error#"
				S02CON="#Arguments.S02CON#"/>
		</cfcatch>		
		</cftry>
	</cffunction>
</cfcomponent>