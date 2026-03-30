<cfcomponent extends="taffy.core.resource" taffy_uri="/notifications">

    <cffunction name="get" access="public" output="false">

        <cfset status = 200>
        
        <cfscript>
			result=StructNew();
        </cfscript>
        
        <cftry>
            <cfset result["result"] = true>
            <cfinvoke component="commons.Componentes.Notifier" method="get" returnvariable="Notifications">
                <cfinvokeargument name="dsn" value= "#arguments.userData.dsn#">
                <cfinvokeargument name="Usucodigo" value="#arguments.userData.usucodigo#">
                <cfinvokeargument name="Ecodigo" value="#arguments.userData.ecodigo#">
                <cfinvokeargument name="soloTramites" value="false">
            </cfinvoke>
            
            <cfif Notifications.recordCount gt 0>
                <cfset result["data"] =  queryToArray(Notifications)>
            <cfelse>
                <cfset result["data"] =  arrayNew(1)>
            </cfif>
        <cfcatch type="any">
            <cfset result["result"] = false>
            <cfset status = 500>
			<cfset result["message"] = cfcatch.message>
        </cfcatch>
        <cffinally>
            <cfreturn representationOf(result).withStatus(status) />
        </cffinally>
        </cftry>



	</cffunction>
	
</cfcomponent>
