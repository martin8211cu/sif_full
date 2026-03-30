<cfcomponent>
<cffunction name="ReporteCCSS" access="public" output="true" returntype="query">
<cfargument name="Ecodigo" type="numeric" required="yes">
<cfargument name="periodo" type="numeric" required="yes">
<cfargument name="mes" type="numeric" required="yes">
<cfargument name="GrupoPlanillas" type="string" required="no">
<cfargument name="conexion" type="string" required="no">
<cfargument name="validar" type="boolean" required="no" default="false">
<cfargument name="debug" type="boolean" required="yes" default="false">
   <cfquery name="rh_ReporteCCSS_GC" datasource="#arguments.conexion#">
       set nocount on
       exec rh_ReporteCCSS_GC 
       @periodo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo#">
        , @mes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes#">
        , @Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        , @GrupoPlanillas = <cfif len(trim(Arguments.GrupoPlanillas)) eq 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.GrupoPlanillas#"></cfif>
       set nocount off
    </cfquery>
    <cfreturn rh_ReporteCCSS_GC>
    </cffunction>
</cfcomponent>
