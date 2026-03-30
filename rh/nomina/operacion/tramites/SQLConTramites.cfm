<cfobject name="wf" component="sif.Componentes.Workflow.Operations">
<cfif isDefined("btnIniciar") >
	<cfset wf.startActivity(form.ActivityInstanceId) >
<cfelseif isDefined("btnCompletar") >
	<cfset wf.completeActivity(form.ActivityInstanceId) >
<cfelseif isDefined("btnTrans") >
	<cfset wf.doTransition(form.ActivityInstanceId, form.TransitionId) >
</cfif>

<!--- <script language="JavaScript1.2">alert('done');</script> --->
<cflocation addtoken="no" url="ConTramites.cfm?tipo=1">
