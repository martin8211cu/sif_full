<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
<cfset getPageContext().getResponse().setHeader("Cache-Control","public")>
<cfif Len(session.tempfile_xls) is 0>
<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_xls = session.tempfile_xls>
	<cfset session.tempfile_xls = ''>
	<cfheader name="Content-Disposition" value="attachment; filename=reporte-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" >
	<cfcontent  type="application/vnd.ms-excel" file="#tempfile_xls#" deletefile="yes">
</cfif>
