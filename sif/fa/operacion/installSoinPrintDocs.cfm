<cfsetting enablecfoutputonly="yes">
<cfheader name="Content-Disposition" value="Attachment;filename=soinPrintDocs.zip">
<cfheader name="Expires" value="1">
<cfset LvarFile = ExpandPath("soinPrintDocs.zip")>
<cfcontent type="application/zip" file="#LvarFile#">
