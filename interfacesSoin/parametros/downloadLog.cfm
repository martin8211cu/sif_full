<cfsetting enablecfoutputonly="yes">
<cfset LvarLogName = "InterfacesSoin#DateFormat(now(),"YYYYMMDD")#">
<cfset LvarLogFile = "#expandPath("/WEB-INF/cfusion/logs/")##LvarLogName#.log">
<cfheader name="Content-Disposition" value="Attachment; filename=#LvarLogName#.txt">
<cfheader name="Expires" value="0">
<cfcontent type="text/plain" 	file="#LvarLogFile#" 	deletefile="no">
<cfabort>
