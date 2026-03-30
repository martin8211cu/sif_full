<cfquery name="rsdataObj" datasource="#session.DSN#">
	select ltrim(rtrim(RHEBEarchivo)) as RHEBEarchivo, ltrim(rtrim(RHEBErutaPlan)) as RHEBErutaPlan
	from RHEBecasEmpleado
	where  RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEBEid#">  
</cfquery>
<cfif url.Tipo eq 1>

	<cfset yourFileName="#URLDecode(rsdataObj.RHEBEarchivo)#">
    <cfheader name="content-disposition" value="attachment; filename=#yourFileName#"> 
    <cfcontent file="#rsdataObj.RHEBErutaPlan#\#yourFileName#"  deletefile="no" type="application/unknown" reset="yes"> 

<cfelseif url.Tipo eq 2>

	<cftransaction>
		<cfif rsdataObj.recordCount GT 0>
            <cfset full_path_name = rsdataObj.RHEBErutaPlan & '\' & rsdataObj.RHEBEarchivo>
            <cffile action = "delete"	file = "#full_path_name#">
        </cfif>
        <cfquery datasource="#Session.DSN#">
            update RHEBecasEmpleado set 
                RHEBErutaPlan = null,
                RHEBEarchivo = null
            where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEBEid#">
        </cfquery>
    </cftransaction>
    
</cfif>