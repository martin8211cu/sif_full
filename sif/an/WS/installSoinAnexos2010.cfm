<cfsetting enablecfoutputonly="yes">
<cfheader name="Content-Disposition" value="Attachment;filename=soinAnexos2010.exe">
<cfheader name="Expires" value="1">
<cfset LvarFile = ExpandPath("soinAnexos2010.exe")>
<cfcontent type="application/exe" file="#LvarFile#">