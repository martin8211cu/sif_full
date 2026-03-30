<cfcomponent>
	<cffunction name="Alta" access="public" returntype="any">
		<cfargument name="Tcodigo" type="string" required="yes">
		<cfargument name="Usucodigo" type="string" required="yes">
		<cfargument name="Ecodigo" type="string" required="no"  default="#session.Ecodigo#">
		
		<cftry>
			<cfquery datasource="#session.DSN#">
				insert into TiposNominaPermisos ( Tcodigo, Usucodigo, Ecodigo, BMUsucodigo)
				 values('#Arguments.Tcodigo#',#Arguments.Usucodigo#,#session.Ecodigo#,#session.Usucodigo#)
			</cfquery >
			
			<cfquery name="rsResult" datasource="#session.DSN#">
				select *, 'ok' as mensaje from TiposNominaPermisos
				where Tcodigo = '#Arguments.Tcodigo#'
					and	Usucodigo=#Arguments.Usucodigo#
					and	Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfreturn rsResult>
		<cfcatch type="any">
			<cfquery name="rsResult" datasource="#session.DSN#">
				select * from TiposNominaPermisos
				where 1=0
			</cfquery >		
			<cfreturn rsResult>
		</cfcatch>
		</cftry>
	</cffunction>
	
	
	<cffunction name="Cambio" access="public" returntype="string">
		<cfargument name="Ecodigo" type="string" required="no"  default="#session.Ecodigo#">
		<cfargument name="Tcodigo" type="string" required="yes">
		<cfargument name="Usucodigo" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="Baja" access="public" returntype="string">
		<cfargument name="Ecodigo" type="string" required="no"  default="#session.Ecodigo#">
		<cfargument name="Tcodigo" type="string" required="yes">
		<cfargument name="Usucodigo" type="string" required="yes">
		
		<cfset myResult="foo">
		
			<cfquery name="rsResult" datasource="#session.DSN#">
				Delete from TiposNominaPermisos
				where Tcodigo = '#Arguments.Tcodigo#'
					and	Usucodigo=#Arguments.Usucodigo#
					and	Ecodigo=#session.Ecodigo#
			</cfquery>

		<cfreturn myResult>
	</cffunction>
</cfcomponent>