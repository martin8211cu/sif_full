<cfparam name="url.id" default="0" type="numeric">
<cf_templateheader title="Correos sin enviar"><cf_web_portlet_start titulo="Correos sin enviar">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="903" height="352">
  <tr><td width="377" valign="top" align="left">
<cfinclude template="correo-lista.cfm">

</td><td width="514" valign="top" align="left">

<span style="color:red;font-weight:bold;">
	
	El mensaje fue enviado con &eacute;xito
	</span>
</td></tr></table>

<cf_web_portlet_end>
<cf_templatefooter>
