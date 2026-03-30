<cfquery name="rsdataObj" datasource="#session.DSN#">
	select ltrim(rtrim(RHAEarchivo)) as RHAEarchivo ,RHAEtipo , ltrim(rtrim(RHAEruta)) as RHAEruta
	from RHArchEmp
	where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAEid#">  
</cfquery>


<cfset yourFileName="#URLDecode(rsdataObj.RHAEarchivo)#">
 
<cfheader name="content-disposition" value="attachment; filename=#yourFileName#"> 
<cfcontent file="#rsdataObj.RHAEruta#\#yourFileName#"  deletefile="no" type="application/unknown" reset="yes"> 