<cfparam name="url.id" type="numeric">
<cf_templateheader title="Reenviar"><cf_web_portlet_start titulo="Reenviar mensaje">

<!---
<div align="center">
<cfif isDefined("url.id")>
<cfinclude template="reenviar-form.cfm">
</cfif>
</div>--->
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="903" height="352">
  <tr><td width="377" valign="top" align="left">
<cfinclude template="correo-lista.cfm">

</td><td width="514" valign="top" align="left">
<cfif url.id neq 0>
<cfinclude template="reenviar-form.cfm">
</cfif>
</td></tr></table>


<cf_web_portlet_end>
<cf_templatefooter>
