<cfif Len(session.tempfile_xls) is 0>
	<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_xls = session.tempfile_xls>
	<cfset session.tempfile_xls = ''>
	
	<!--- o type = application/octet-stream ?? --->
	<cfheader name="Content-Disposition" value="attachment; filename=reporte-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfcontent  type="application/vnd.ms-excel" file="#tempfile_xls#" deletefile="yes">	
</cfif>

