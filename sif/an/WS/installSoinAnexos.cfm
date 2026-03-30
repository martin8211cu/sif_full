<cfsetting enablecfoutputonly="yes">
<cfheader name="Content-Disposition" value="Attachment;filename=soinAnexos.zip">
<cfheader name="Expires" value="1">
<cfset LvarFile = ExpandPath("soinAnexos.zip")>
<cfcontent type="application/zip" file="#LvarFile#">

