<cfoutput>
<table width="100%" cellpadding="3" cellspacing="0">
	<tr> 
	  <td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
	</tr>
    <tr> 
      <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
		 <cfinclude template="../../expediente/consultas/frame-foto.cfm">
      </td>
      <td valign="top" nowrap> 
          <table width="100%" border="0" cellpadding="5" cellspacing="0">
            <tr> 
              <td class="fileLabel" width="10%" nowrap><cf_translate key="LB_Nombre_Completo">Nombre Completo:</cf_translate></td>
              <td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
            </tr>
            <tr> 
              <td class="fileLabel" nowrap>#rsEmpleado.NTIdescripcion#:</td>
              <td>#rsEmpleado.DEidentificacion#</td>
            </tr>
            <tr> 
              <td class="fileLabel" nowrap><cf_translate key="LB_Jornada_Ordinaria">Jornada Ordinaria:</cf_translate></td>
              <td>#rsEmpleado.Jornada#</td>
            </tr>
          </table>
      </td>
    </tr>
</table>
</cfoutput>