<cfif Len(session.tempfile_cfm) is 0>
	<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_cfm = session.tempfile_cfm>
	<cfset session.tempfile_cfm = ''>
	<cfcontent file="#tempfile_cfm#" deletefile="yes" type="text/html">
</cfif>
