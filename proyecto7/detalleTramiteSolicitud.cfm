<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cfif not isdefined("url.SC")>
    <cfquery datasource="#session.dsn#" name="DataField">
        select b.DataFieldName, b.Description, b.Label, b.InitialValue, b.Prompt, b.Length, b.Datatype,
            xdf.Value
        from WfDataField b
            left join WfxDataField xdf
                on b.DataFieldName = xdf.DataFieldName
        where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
          and xdf.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
        order by b.DataFieldName
    </cfquery>
    <cfset conta = 0>
    <cfloop query="DataField">
        <cfif conta eq 1>
            <cfset ECodigo =  DataField.Value>
        <cfelseif conta eq 0>
            <cfset ESidsolicitud =  DataField.Value>
        </cfif>
        <cfset conta= conta+1>
    </cfloop>

    <cfif DataField.recordcount>
        <cfset consultar_Ecodigo = Ecodigo>
    </cfif>
<cfelse>
	<cfset ESidsolicitud = url.ESidsolicitud>
</cfif>
<cf_templatecss>
<cfset url.ESestado=20>
<div align="center">
    <form name="form1">
        <cfinclude template="MisSolicitudes-vistaForm.cfm">
    </form>
</div>
</div>