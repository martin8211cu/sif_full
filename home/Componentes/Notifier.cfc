<cfcomponent>
    <cffunction name="get" access="public" returntype="query">


        <cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
            <cfinvokeargument name="Conexion"  value="#session.dsn#">
            <cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
        </cfinvoke>

        <cfset myQuery = QueryNew("NotifyUrl,NotifyUsucodigoRef,Notifyfecha,NotifyAsunto,ProcessInstanceId", "VarChar,BigInt,Time,varchar,Integer")>

        <cfloop query="workload">
			<cfset newRow = QueryAddRow(MyQuery, 1)>
            <cfset temp = QuerySetCell(myQuery, "NotifyUrl", "/cfmx/sif/tr/consultas/aprobacion-detalle.cfm?from=aprobacion&ProcessInstanceId=#ProcessInstanceId#&ActivityInstanceId=#ActivityInstanceId#", currentrow)>
            <cfset temp = QuerySetCell(myQuery, "NotifyUsucodigoRef", Beneficiario, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "Notifyfecha",STARTTIME, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "NotifyAsunto",PROCESSDESCRIPTION&'<br>'&PROCESSINSTANCEDESCRIPTION, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "ProcessInstanceId", ProcessInstanceId, currentrow)>
      	</cfloop>

        <cfset myQueryFinal = QueryNew("NotifyUrl,NotifyUsucodigoRef,Notifyfecha,NotifyAsunto,ProcessInstanceId", "VarChar,BigInt,Time,varchar,Integer")>

        <cfloop query="myQuery">
            <cfquery name="rsExisteNRP" datasource="#session.dsn#">
                select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ProcessInstanceId#">
            </cfquery>

            <cfif rsExisteNRP.cantidad eq 0>
                <cfset newRow = QueryAddRow(myQueryFinal, 1)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyUrl", NotifyUrl, currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyUsucodigoRef", NotifyUsucodigoRef , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "Notifyfecha", Notifyfecha , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyAsunto", NotifyAsunto , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "ProcessInstanceId", ProcessInstanceId, currentrow)>


            </cfif>
        </cfloop>



       <!---- ordena por fecha mas vieja---->
        <cfquery dbtype="query" name="myQuery">
        select * from myQueryFinal order by Notifyfecha asc
       	</cfquery>

        <cfreturn myQuery>

    </cffunction>

	<!--- Funcion para insertar mensajes de notificacion en la session --->
	<cffunction name="insertFlashMeesage" access="public">
		<cfargument name="message" type="string" required="true">
		<cfargument name="type" type="string" required="false" default="succes"> <!--- success,error,warning --->
		<cfargument name="closeOnClick" type="boolean" required="false" default="false">

		<cfset session.flashMessage.message = Arguments.message>
		<cfset session.flashMessage.type = Arguments.type>
		<cfset session.flashMessage.closeOnClick = Arguments.closeOnClick>


	</cffunction>
</cfcomponent>