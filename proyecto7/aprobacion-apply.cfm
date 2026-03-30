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
    <!--- Verifica si el proceso pertenece a una SC y si este genero un NRP --->
    <cfquery name="rsExisteNRP" datasource="#session.dsn#">
        select NRP from ESolicitudCompraCM where ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
    </cfquery>
    <cfif len(trim(rsExisteNRP.NRP)) gt 0>
    	<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(rsExisteNRP.NRP)#">
    </cfif>
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
   <cfset nLink = replace("#link#","/sif/cm/operacion/","/proyecto7/") >
	<cfif Len(link)>
		<cfif find("?",nLink)>
			<cflocation addtoken="no" url="#nLink#&from=#url.from#">
		<cfelse>
			<cflocation addtoken="no" url="#nLink#?from=#url.from#">
		</cfif>
	</cfif>
</cfif>

<cfif url.from is 'solicitudCompras'>
	<cflocation addtoken="no" url="solicitudCompras.cfm">
<cfelseif url.from is 'recursosHumanos'>
	<cflocation addtoken="no" url="recursosHumanos.cfm">
<cfelseif url.from is 'pendientes'>
	<cflocation addtoken="no" url="pendientes.cfm">
<cfelse>
	<cflocation addtoken="no" url="solicitados.cfm">
</cfif>


