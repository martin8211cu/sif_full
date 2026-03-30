<cf_template>
<cf_templatearea name="title">Autorizadores</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">


<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Selecci&oacute;n de autorizadores'> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> 
  <td valign="top" width="45%"><cfinclude template="autorizador_list.cfm">
  </td>
  <td valign="top" width="10%">
  </td>
  <td valign="top" width="45%">
  <cfif isdefined("form.autorizador")>
  <cfinclude template="autorizador_p.cfm">
  </cfif>
  </td>
</tr>
</table>
</cf_web_portlet>


</cf_templatearea>
</cf_template>