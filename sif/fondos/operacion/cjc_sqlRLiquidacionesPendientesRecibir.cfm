<cfinclude template="cjc_sqlRLiquidacionesPendientesRecibirContent.cfm">
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">


