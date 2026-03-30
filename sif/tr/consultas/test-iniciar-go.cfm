
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Inicio de Tr&aacute;mites
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">

<cfparam name="form.ProcessId" type="numeric">

<cfquery datasource="#session.dsn#" name="Tramites">
	select a.Name as PackageName, b.Name as ProcessName,
		a.PackageId, b.ProcessId
	from WfPackage a
		join WfProcess b
			on a.PackageId = b.PackageId
	where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	order by PackageName, ProcessName
</cfquery>
<cfquery datasource="#session.dsn#" name="DataField">
	select b.Name, b.Description, b.Label, b.InitialValue, b.Prompt, b.Length, b.Datatype
	from WfDataField b
	where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	  and b.Prompt = 1
	order by Name
</cfquery>

<cfobject name="wf" component="sif.Componentes.Workflow.Management">
<cfoutput>

	Description: #form.Description# ...<br>
	<cfset data_items = StructNew()>
	<cfloop query="DataField">
		<cfif IsDefined('form.text_' & DataField.Name)>
			<cfset data_items[DataField.Name] = form['text_' & DataField.Name]>
			#DataField.Name# : #form['text_' & DataField.Name]# ...<br>
		</cfif>
	</cfloop>
	<cfset ProcessInstanceId = wf.startProcess(form.ProcessId, session.Usucodigo, form.SubjectId, form.Description, data_items)>

</cfoutput>

<form action="consola.cfm" method="get">
<input type="submit" name="c" value="Terminado">
</form>


	</cf_templatearea>
</cf_template>