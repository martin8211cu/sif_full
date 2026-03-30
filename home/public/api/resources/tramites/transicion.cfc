<cfcomponent extends="taffy.core.resource" taffy_uri="/tramites/dotransicion">

    <cffunction name="post" access="public" output="false">
		<cfargument name="ActivityInstanceId"  type="numeric"  required="true">
        <cfargument name="TransitionId"  type="numeric"  required="true">
        <cfargument name="TransitionComments"  type="string"  required="false">

        <cfobject name="wf" component="sif.Componentes.Workflow.Management">

        <cfset status = 200>
        
        <cfscript>
			result=StructNew();
        </cfscript>
        
        <cftry>
            <cfset result["result"] = true>

            <cfset wf.doTransition( fromActivityInstance = arguments.ActivityInstanceId, 
                                    TransitionId = arguments.TransitionId, 
                                    TransitionComments = arguments.TransitionComments,
                                    dsn = arguments.userData.dsn) >

            <cfreturn representationOf(result).withStatus(status) />

        <cfcatch type="any">
            <cfset result["result"] = false>
            <cfset status = 500>
			<cfset result["message"] = cfcatch.stacktrace>
        </cfcatch>
        <cffinally>
            <cfreturn representationOf(result).withStatus(status) />
        </cffinally>
        </cftry>



	</cffunction>
	
</cfcomponent>



