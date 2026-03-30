<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

	<cffunction name="isUsingAsoc" access="public" returntype="boolean">
		<cfquery name="rs" datasource="#session.dsn#">
        	select 1
            from ACParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
		<cfreturn rs.recordcount GT 0>
	</cffunction>

	<cffunction name="get" access="public" returntype="string">
		<cfargument name="pcodigo" type="numeric" required="yes">
        <cfargument name="pdescripcion" type="string" required="no" default="#arguments.pcodigo#">
		<cfquery name="rs" datasource="#session.dsn#">
        	select Pvalor, Pdescripcion
            from ACParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Pcodigo#">
        </cfquery>
        <cfif rs.recordcount eq 0>
        	<cfthrow message="Error en Componente ACParametros. Metodo Get. El Par&aacute;metro #Arguments.Pdescripcion# no est&aacute; definido. Proceso Cancelado!">
        </cfif>
        <cfif rs.recordcount eq 1 and len(trim(rs.Pvalor)) eq 0>
        	<cfthrow message="Error en Componente ACParametros. Metodo Get. El Par&aacute;metro #rs.Pdescripcion# no est&aacute; definido. Proceso Cancelado!">
        </cfif>
		<cfreturn rs.Pvalor>
	</cffunction>
</cfcomponent>