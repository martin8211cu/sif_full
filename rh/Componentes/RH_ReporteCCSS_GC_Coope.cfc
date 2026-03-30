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
       exec rh_reporteGC 
       @CPperiodo = #Arguments.periodo#
        , @CPmes =  #Arguments.mes#
        , @Ecodigo =  #Arguments.Ecodigo#
       set nocount off
    </cfquery>
    <cfreturn rh_ReporteCCSS_GC>
    </cffunction>
</cfcomponent>
