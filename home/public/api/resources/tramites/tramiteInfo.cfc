<cfcomponent extends="taffy.core.resource" taffy_uri="/tramites/info">

    <cffunction name="get" access="public" output="false">
        <cfargument name="ProcessInstanceId"  type="numeric"  required="true">
		<cfargument name="ActivityInstanceId"  type="numeric"  required="true">

        <cfset status = 200>
        
        <cfscript>
			result=StructNew();
        </cfscript>
        
        <cftry>
            <cfset result["result"] = true>

            <cfquery datasource="#arguments.userData.dsn#" name="responsables">
                select xap.Name, xap.Description, xap.Usucodigo, u.Usulogin,
                        case xp.ParticipantType
                        when 'HUMAN' 		then '<cf_translate key="LB_HUMAN">Usuario</cf_translate>'
                        when 'ORGUNIT' 		then '<cf_translate key="LB_ORGUNIT">Jefatura de Centro Funcional</cf_translate>'
                        when 'ADMIN' 		then '<cf_translate key="LB_ADMIN">Administrador de Támites</cf_translate>'
                        when 'ROLE' 		then '<cf_translate key="LB_ROLE">Grupo de Permiso o Rol</cf_translate>'
                        when 'BOSS' 		then '<cf_translate key="LB_BOSS">Jefatura paso anterior</cf_translate>'
                        when 'BOSS1' 		then '<cf_translate key="LB_BOSS1">Jefatura Origen</cf_translate>'
                        when 'BOSS2' 		then '<cf_translate key="LB_BOSS2">Jefatura Destino</cf_translate>'
                        when 'BOSSES1' 		then '<cf_translate key="LB_BOSSES1">Rol Autorizador Oficina Origen</cf_translate>'
                        when 'BOSSES2' 		then '<cf_translate key="LB_BOSSES2">Rol Autorizador Oficina Destino</cf_translate>'
                        end Type
                from WfxActivityParticipant xap
                    left join Usuario u on u.Usucodigo = xap.Usucodigo
                    left join WfParticipant xp
                        on xp.ParticipantId = xap.ParticipantId
                where xap.ActivityInstanceId = #arguments.ActivityInstanceId# 
                order by xap.ParticipantId, u.Usucodigo
            </cfquery>

            <cfquery datasource="#arguments.userData.dsn#" name="detalle">
                select xa.ProcessInstanceId,
                        case xap.HasTransition
                        when 0 then ' '
                        when 1 then 'X'
                        end as Aprobadopor,
                        xa.ActivityInstanceId,
                        a.Name AS ActivityName, xt.TransitionInstanceId,
                        t.Name AS TransitionName,a.ActivityId,
                        xa.StartTime, xa.FinishTime, xt.TransitionTime,
                        xap.Name As ParticipantName, xap.Description as ParticipantDescription, u.Usulogin,
                        case 
                            when (len(t.Name) > 0) then 'Completado' 
                            when xa.State = 'COMPLETED' then 'Asignado'
                            else
                                case xa.State
                                    when 'INACTIVE' 	then 'Inactivo'
                                    when 'SUSPENDED' 	then 'Suspendido'
                                    when 'ACTIVE' 		then 'No Iniciado'
                                end			
                        end status                    
                from WfxActivity xa
                    inner join WfActivity a
                        on xa.ActivityId = a.ActivityId
                    left join WfxTransition xt
                        left join WfTransition t
                            on t.TransitionId = xt.TransitionId
                        on xt.FromActivityInstance = xa.ActivityInstanceId
                    left join WfxActivityParticipant xap
                        left join Usuario u
                            on u.Usucodigo = xap.Usucodigo
                        on xap.ActivityInstanceId = xa.ActivityInstanceId
                where xa.ProcessInstanceId = #ProcessInstanceId#
                order by xa.StartTime, xa.ActivityInstanceId, xt.TransitionTime, xt.TransitionInstanceId, xap.ParticipantId, u.Usucodigo
            </cfquery>

            <cfset rsPendientes = QueryNew("actividad,status,respon")>
            <cfset varActivitys = ValueList(detalle.ActivityId)>
            <cfset salir = false>
            <cfloop index = "LoopCount" from = "1" to = "100">
                <cfquery datasource="#arguments.userData.dsn#" name="detalle2">
                    Select a.ActivityId, a.Name as nombreActiv, b.ParticipantId, c.Name, c.Description, u.Usulogin, ParticipantType
                    from WfActivity a
                        left outer join WfActivityParticipant b
                        on  a.ProcessId = b.ProcessId
                        and a.ActivityId = b.ActivityId
                        left outer join WfParticipant c
                        left outer join Usuario u on u.Usucodigo = c.Usucodigo
                            on b.ParticipantId = c.ParticipantId
                    Where a.ActivityId in (
                            select ToActivity
                            from WfTransition
                            where FromActivity in (#varActivitys#))
                        and a.ActivityId not in (#varActivitys#)
                </cfquery>

                <cfif detalle2.recordCount EQ 0>
                    <cfset salir = true>
                <cfelse>
                    <cfset varActiv2 = ValueList(detalle2.ActivityId)>
                    <cfset varActivitys = varActivitys & ',' & varActiv2>
                    <cfloop query="detalle2">
                        <cfset QueryAddRow(rsPendientes,1)>
                        <cfset QuerySetCell(rsPendientes,"actividad",nombreActiv)>
                        <cfif Usulogin NEQ "">
                            <cfset QuerySetCell(rsPendientes,"respon", "#ParticipantType# #Name# (#Usulogin#)")>
                        <cfelse>
                            <cfset QuerySetCell(rsPendientes,"respon", "#ParticipantType# #Name#")>
                        </cfif>
                    </cfloop>
                </cfif>
                <cfif salir EQ true>
                    <cfbreak>
                </cfif>
            </cfloop>

            <cfinvoke component="sif.Componentes.Workflow.Management"
				  method="getAllowedTransitions"
				  returnvariable="rsTrans">
                <cfinvokeargument name="ActivityInstanceId" value="#arguments.ActivityInstanceId#">
                <cfinvokeargument name="dsn" value="#arguments.userData.dsn#">
            </cfinvoke>
            
            <cfset result["data"]["responsable"] =  queryToStruct(responsables)>
            <cfset result["data"]["historia"] =  queryToArray(detalle)>
            <cfset result["data"]["pendiente"] =  queryToArray(rsPendientes)>
            <cfset result["data"]["transiciones"] =  queryToArray(rsTrans)>

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



