<cfif isdefined("url.id") and Len(url.id) eq 0><cfset url.id=0></cfif>
<cfparam name="url.id" default="0" type="numeric">

<cf_templateheader title="Errores ocurridos en el servidor">
<cf_web_portlet_start titulo="Errores sin revisar"/>
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="903" height="352">
  <tr><td width="377" valign="top" align="left">
<cfinclude template="errores-lista.cfm">

</td><td width="514" valign="top" align="left">
<cfif url.id neq 0>
<cfinclude template="errores-form.cfm">
</cfif>
</td></tr></table>

<cf_web_portlet_end>

<cf_templatefooter>
