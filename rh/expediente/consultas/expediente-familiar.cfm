<cfoutput> 
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
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
	  <td class="#Session.preferences.Skin#_thcenter"><cf_translate key="ListaFamiliares">LISTA DE FAMILIARES</cf_translate></td>
	</tr>
    <tr> 
      <td valign="top" nowrap> 
		  <cfinclude template="frame-familiares.cfm">
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
