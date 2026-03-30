
<cfoutput> 
<cfif isdefined("rsOferente.RHOid") and Len(Trim(rsOferente.RHOid)) NEQ 0>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center">
  <table width="95%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 10px; margin-right: 10px;">
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>

    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_DATOSGENERALES">DATOS GENERALES</cf_translate></td>
    </tr>
    <tr> 
      <td valign="top" nowrap> 
		  <cfinclude template="../../Reclutamiento/consultas/frame-generalOferente.cfm">
	  </td>
    </tr>
    <tr>
      <td colspan="2" >&nbsp;</td>
    </tr>
  </table>
<cf_web_portlet_end>
<cfelse>
	<cf_translate key="LB_LosDatosDelExpedienteNoEstanDisponibles">Los datos del Expediente no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>