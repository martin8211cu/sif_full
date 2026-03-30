<cfquery datasource="#session.dsn#" name="DataField">
    select b.DataFieldName, b.Description, b.Label, b.InitialValue, b.Prompt, b.Length, b.Datatype,
        xdf.Value
    from WfDataField b
        left join WfxDataField xdf
            on b.DataFieldName = xdf.DataFieldName
    where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
      and xdf.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
    order by b.DataFieldName
</cfquery>
<cfset conta = 0>
<cfloop query="DataField">
	<cfif conta eq 2>
        <cfset ECodigo =  DataField.Value>
    <cfelseif conta eq 0>
        <cfset ESidsolicitud =  DataField.Value>
    </cfif>
    <cfset conta= conta+1>
</cfloop>
<cf_templatecss>
<cfif DataField.recordcount>
	<cfset consultar_Ecodigo = Ecodigo>
</cfif>
<cfset url.ESestado=20>
<div align="center">
<cfparam name="url.ProcessInstanceId" type="numeric">
<cfparam name="url.ActivityInstanceId" type="numeric">

<cfinvoke component="sif.Componentes.Workflow.Management" method="getDetailURL"
	returnvariable="link"
	ProcessInstanceId="#url.ProcessInstanceId#">
   
   <cfset nLink = replace("#link#","ConsultaAcciones.cfm","") >
   <cfif LEN(nLink) neq LEN(link) >
      	<cfset link = replace("#link#","rh/nomina/operacion/tramites","proyecto7") >
   		<cflocation addtoken="no" url="#link#">
   </cfif>
   <cfset nLink = replace("#link#","aprobacionIncidencias.cfm","") >
   <cfif LEN(nLink) neq LEN(link) >
   		
   <cfelse>
   		<cflocation addtoken="no" url="#link#">
   </cfif>
</div>

