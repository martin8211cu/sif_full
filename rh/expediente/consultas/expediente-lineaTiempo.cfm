<cfoutput> 
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
  <table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
		 <cfinclude template="frame-foto.cfm">
      </td>
      <td colspan="2" valign="top" nowrap> 
          <table width="100%" border="0" cellpadding="5" cellspacing="0">
            <tr> 
              <td class="#Session.preferences.Skin#_thcenter" colspan="2">DATOS GENERALES</td>
            </tr>
            <tr> 
              <td class="fileLabel" width="10%" nowrap>Nombre Completo:</td>
              <td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
            </tr>
            <tr> 
              <td class="fileLabel" nowrap>#rsEmpleado.NTIdescripcion#:</td>
              <td>#rsEmpleado.DEidentificacion#</td>
            </tr>
            <tr> 
              <td class="#Session.preferences.Skin#_thcenter" colspan="2">ACCIONES</td>
            </tr>
			<tr>
			   <td colspan="2">
			   	  <cfinclude template="frame-lineaTiempo.cfm">
			   </td>
			</tr>
          </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
  </table>
<cfelse>
	Los datos de su Expediente Laboral no est&aacute;n disponibles
</cfif>
</cfoutput>
