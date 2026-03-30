<cfset tempfile = GetTempDirectory()>
<cfcontent  type="application/vnd.ms-excel" file="#tempfile#/tmp_#session.usuario#.xls" deletefile="yes">
