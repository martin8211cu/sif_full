<cfsetting enablecfoutputonly="yes">
<cfheader name="Content-Disposition" value="Attachment;filename=PDtoCF.zip">
<cfheader name="Expires" value="1">
<cfset LvarFile = ExpandPath("PDtoCF.zip")>
<cfcontent type="application/zip" file="#LvarFile#">
