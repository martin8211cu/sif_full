<cfsetting enablecfoutputonly="yes">
<cfparam name="form.acceso"             type="string"  default="">
<cfparam name="form.ActivityInstanceId" type="numeric" default="0">
<cfparam name="form.AppName"            type="string"  >
<cfparam name="form.AppLocation"        type="string"  >
<cfparam name="form.AppCommand"         type="string"  >
<cfparam name="form.dsn"                type="string"  >
<cfset secure = true>
<cfset debug_arguments = "">

<cftry>

	<cfset session.dsn = form.dsn>
	
	<cfif secure>
		<cfparam name="application.Workflow_InvocationRemote_Hashes" default="">
		<cfset my_password_position = ListFind(application.Workflow_InvocationRemote_Hashes, form.acceso)>
		
		<cfif my_password_position Is 0>
			<cflock name="application.invocationremote.hashes" timeout="2">
				<cfset application.Workflow_InvocationRemote_Hashes = "">
			</cflock>
			<cfinclude template="/home/check/no-access-404.cfm">
			<cfabort>
		</cfif>
		
		<cflock name="application.invocationremote.hashes" timeout="15">
			<cfparam name="application.Workflow_InvocationRemote_Hashes" default="">
			<cfset application.Workflow_InvocationRemote_Hashes = ListDeleteAt(application.Workflow_InvocationRemote_Hashes, my_password_position)>
		</cflock>
	</cfif>

	<cfif form.ActivityInstanceId EQ 0 >
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ArgumentosInvalidos"
		Default="Argumentos Inválidos"
		returnvariable="MSG_ArgumentosInvalidos"/>
		<cfthrow message="#MSG_ArgumentosInvalidos#">
	</cfif>
	
	<cfinvoke component="sif.Componentes.Workflow.WfApplication" method="init" returnvariable="wfinvoke_wfApplication" >
	<cfset wfinvoke_wfApplication.ApplicationName = form.AppName>
	<cfset wfinvoke_wfApplication.Location        = form.AppLocation>
	<cfset wfinvoke_wfApplication.Command         = form.AppCommand>
	<cfset wfinvoke_wfApplication.Type            = form.AppType>
	<cfset WfxArguments = QueryNew('ParameterName,Datatype,ValueIn')>
	<cfset debug_arguments = "">
	<cfloop condition="WfxArguments.RecordCount LT form.argc">
		<cfset QueryAddRow(WfxArguments)>
		<cfset QuerySetCell(WfxArguments, 'ParameterName', form['arg' & WfxArguments.RecordCount & 'n'])>
		<cfset QuerySetCell(WfxArguments, 'Datatype'     , form['arg' & WfxArguments.RecordCount & 'd'])>
		<cfset QuerySetCell(WfxArguments, 'ValueIn'      , form['arg' & WfxArguments.RecordCount & 'v'])>
		<cfset debug_arguments = ListAppend(debug_arguments,
			form['arg' & WfxArguments.RecordCount & 'n'] & "=" & 
			form['arg' & WfxArguments.RecordCount & 'v'])>
	</cfloop>
	<cftransaction>
	<cfinvoke component="sif.Componentes.Workflow.InvocationMgmt"
		method="callApplicationByType"
		activityInstanceId="#form.ActivityInstanceId#"
		application="#wfinvoke_wfApplication#"
		WfxArguments="#WfxArguments#"
		returnvariable="ret">
	</cfinvoke>
	</cftransaction>
	<cfoutput>ok</cfoutput>
<cfcatch type="any">
	<cfoutput>#cfcatch.Message#,#cfcatch.Detail# #form.AppName#,#debug_arguments#</cfoutput>
	<cfinclude template="/home/public/error/log_cfcatch.cfm">
</cfcatch>
</cftry>


