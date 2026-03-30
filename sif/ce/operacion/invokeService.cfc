<cfcomponent>
    <cffunction  name="invokeServiceSIC" access="remote" returntype="Struct" returnformat="JSON">
        <cfargument name="rfc"    type="string" required="true"> 
        <cfargument name="f_type" type="string" required="true">
        <cfargument name="f_ini"  type="string" required="true">
        <cfargument name="f_fin"  type="string" required="true">
        <cfset urlBase = ObtenerDato(191001)>
        <cfset apiKey = ObtenerDato(191004)>
        <cfscript>
			result=StructNew();
        </cfscript>

        <cfhttp url="#urlBase#invoices" method="post" result="httpList" timeout="6000">
                <cfhttpparam type="header" name="apikey" value="#apiKey#"/>
                <cfhttpparam type="formField" name="rfc" value="#Arguments.rfc#"/> 
                <cfhttpparam type="formField" name="f_type" value="#Arguments.f_type#"/>
                <cfhttpparam type="formField" name="f_ini" value="#Arguments.f_ini#"/>
                <cfhttpparam type="formField" name="f_fin" value="#Arguments.f_fin#"/>
        </cfhttp>

          <cfset recordList = deserializeJSON(#httpList.filecontent#)>
           <cfset result["data"] = recordList>
           <cfreturn result> 

    </cffunction>

    <cffunction name="ObtenerDato" returntype="string">
        <cfargument name="pcodigo" type="numeric" required="true">
            <cfquery name="rs" datasource="#Session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
            </cfquery>
            <cfreturn #rs.Pvalor#>
    </cffunction>
</cfcomponent>