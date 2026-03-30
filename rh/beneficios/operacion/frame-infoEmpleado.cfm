<cfoutput>
<table width="100%" cellpadding="3" cellspacing="0">
    <tr> 
      <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
		 <cfinclude template="frame-foto.cfm">
      </td>
      <td valign="middle" nowrap> 
          <table width="100%" border="0" cellpadding="5" cellspacing="0">
            <tr> 
              <td class="#Session.preferences.Skin#_thcenter">Nombre Completo</td>
			</tr>
            <tr> 
              <td><strong>#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</strong></td>
            </tr>
            <tr> 
              <td class="#Session.preferences.Skin#_thcenter">#rsEmpleado.NTIdescripcion#</td>
			</tr>
            <tr> 
              <td><strong>#rsEmpleado.DEidentificacion#</strong></td>
            </tr>
          </table>
      </td>
    </tr>
</table>
</cfoutput>