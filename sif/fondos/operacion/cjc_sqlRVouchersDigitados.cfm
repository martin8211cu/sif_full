<cfinclude template="cjc_sqlRVouchersDigitadosContent.cfm">
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">
