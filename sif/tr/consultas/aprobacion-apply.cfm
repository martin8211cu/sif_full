<cfparam name="url.from" default="">
<cfparam name="url.ProcessInstanceId" default="">
<cfobject name="wf" component="sif.Componentes.Workflow.Management">

<cfif isDefined("url.action") and url.action is 'start' >
	<cfset wf.startActivity(url.ActivityInstanceId) >
<cfelseif isDefined("url.action") and url.action is 'finish' >
	<cfset wf.completeActivity(url.ActivityInstanceId) >
<cfelseif isDefined("url.action") and url.action is 'forward' >
	<cfset wf.forward(url.ProcessInstanceId) >
<cfelseif isDefined("url.action") and url.action is 'forward-all' >
	<cfset wf.forward(0) >
	<cflocation addtoken="no" url="consola.cfm">
<cfelseif isDefined("url.TransitionId") >

	<cfquery datasource="#session.dsn#" name="transition_info">
		select AskForComments
		from WfTransition
		where TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TransitionId#">
	</cfquery>
	
	<cfif transition_info.AskForComments AND NOT IsDefined('url.TransitionComments')>
		<cflocation url="aprobacion-obs.cfm?from=#URLEncodedFormat(url.from)
			#&ProcessInstanceId=#URLEncodedFormat(url.ProcessInstanceId)
			#&ActivityInstanceId=#URLEncodedFormat(url.ActivityInstanceId)
			#&TransitionId=#URLEncodedFormat(url.TransitionId)#">
	</cfif>

	<cfparam name="url.TransitionComments" default="">

	<cfset wf.doTransition(url.ActivityInstanceId, url.TransitionId, url.TransitionComments) >
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_InvocacionErronea"
	Default="Invocación errónea"
	returnvariable="MSG_InvocacionErronea"/>

	<cfthrow message="#MSG_InvocacionErronea#">
</cfif>

<cfif Len(url.ProcessInstanceId)>
	<cfset link = wf.getDoneURL(url.ProcessInstanceId)>
	<cfif Len(link)>
		<cfif find("?",link)>
			<cflocation addtoken="no" url="#link#&from=#url.from#">
		<cfelse>
			<cflocation addtoken="no" url="#link#?from=#url.from#">
		</cfif>
	</cfif>
</cfif>

<cfif url.from is 'aprobacion'>
	<cflocation addtoken="no" url="aprobacion.cfm">
<cfelseif url.from is 'consola'>
	<cflocation addtoken="no" url="consola.cfm">
<cfelseif url.from is 'pendientes'>
	<cflocation addtoken="no" url="pendientes.cfm">
<cfelse>
	<cflocation addtoken="no" url="solicitados.cfm">
</cfif>


