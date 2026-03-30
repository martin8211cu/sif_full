
<cfcomponent >
    <cffunction  name="getTiendasExternas" returntype="query">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">

        <cfquery name="q_TiendaExterna" datasource="#arguments.DSN#">
           select Codigo, Descripcion 
            from CRCTiendaExterna
            where Activo = 1
                and Ecodigo = #arguments.Ecodigo#
        </cfquery>

        <cfreturn q_TiendaExterna>
    </cffunction>
</cfcomponent>