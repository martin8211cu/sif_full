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
	  <td class="#Session.preferences.Skin#_thcenter"><cf_translate key="ListaBeneficios">LISTA DE BENEFICIOS</cf_translate></td>
	</tr>
    <tr> 
      <td valign="top" nowrap> 
		  <cfinclude template="frame-beneficios.cfm">
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
<cfelse>
	<cf_translate key="MSG_LosDatosDeSusBeneficiosNoEstanDisponibles">Los datos de sus Beneficios no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>
