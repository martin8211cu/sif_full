<cfparam name="url.ProcessInstanceId" type="numeric">
<cfparam name="url.ActivityInstanceId" type="numeric">

<cfinvoke component="sif.Componentes.Workflow.Management" method="getDetailURL"
	returnvariable="link"
	ProcessInstanceId="#url.ProcessInstanceId#">
<cflocation addtoken="no" url="#link#">