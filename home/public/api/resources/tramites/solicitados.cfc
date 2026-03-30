<cfcomponent extends="taffy.core.resource" taffy_uri="/tramites/solicitados">

    <cffunction name="get" access="public" output="false">

        <cfset status = 200>
        
        <cfscript>
			result=StructNew();
        </cfscript>
        
        <cftry>
            <cfset result["result"] = true>

            <cfinvoke component="sif.Componentes.Workflow.Management" method="getOpenProcessesByRequester" returnvariable="workload">
                <cfinvokeargument name="Usucodigo" value="#arguments.userData.usucodigo#">
                <cfinvokeargument name="Conexion" value= "#arguments.userData.dsn#">
                <cfinvokeargument name="Ecodigo" value= "#arguments.userData.ecodigo#">
            </cfinvoke>
            
            <cfquery name="workload" dbtype="query">
				select * 
				  from workload
				 where 1=1
				<cfif isdefined("form.F_numero") and form.F_numero NEQ "">
					and cast(workload.ProcessInstanceId as varchar) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.F_numero#">
				</cfif>
				<cfif isdefined("form.F_tipo") and form.F_tipo NEQ "">
					and ( UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_tipo)#%">
					<cfif workload.Ecodigo neq session.Ecodigo or true>
					   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_tipo)#%">
					</cfif>
					    )
				</cfif>
				<cfif isdefined("form.F_nombre") and form.F_nombre NEQ "">
					and ( UPPER(workload.ProcessInstanceDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_nombre)#%">
					   OR UPPER(workload.ActivityDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_nombre)#%">
					    )
				</cfif>
				<cfif isdefined("form.F_asignado") and form.F_asignado NEQ "">
					and workload.StartTime between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.F_asignado)#">
											   and <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',1,LSParseDateTime(form.F_asignado))#">
				</cfif>
			</cfquery>

            <cfset result["data"] =  queryToArray(workload)>
            <cfreturn representationOf(result).withStatus(status) />

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
			<cfset result["message"] = cfcatch.stacktrace>
        </cfcatch>
        <cffinally>
            <cfreturn representationOf(result).withStatus(status) />
        </cffinally>
        </cftry>



	</cffunction>
	
</cfcomponent>
