<cfoutput> 
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
  <cfif isdefined("Url.DLlinea") and Len(Trim(Url.DLlinea)) and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
  </cfif>
  <table width="95%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 10px; margin-right: 10px;">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
		  <cfinclude template="frame-infoEmpleado.cfm">
	  </td>
    </tr>
	<tr> 
	  <td class="#Session.preferences.Skin#_thcenter"><cf_translate key="Acciones">ACCIONES</cf_translate></td>
	</tr>
    <tr> 
      <td valign="top" nowrap> 
		  <cfif isdefined("Form.DLlinea")>
			<cfinclude template="frame-detalleAcciones.cfm">
		  <cfelse>
			<cfinclude template="frame-laboral.cfm">
		  </cfif>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
<cfelse>
	<cf_translate key="MSG_LosDatosDeSuExpedienteLaboralNoEstanDisponibles">Los datos de su Expediente Laboral no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>
