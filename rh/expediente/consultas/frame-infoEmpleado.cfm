<cfoutput>
<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" cellpadding="3" cellspacing="0" >
	<tr>
	  <td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
	</tr>
    <tr>
      <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;">
		 <!--- <cfinclude template="frame-foto.cfm"> ---><!--- OPARRALES No mostraba correctamente la imagen 2018-05-22 --->
		 <cfinclude template="/rh/expediente/catalogos/frame-foto.cfm">
      </td>
      <td valign="top" nowrap>
          <table width="100%" border="0" cellpadding="5" cellspacing="0">
            <tr>
              <td class="fileLabel" width="10%" nowrap><cf_translate key="LB_Nombre_Completo">Nombre Completo</cf_translate>:</td>
              <td><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
            </tr>
            <tr>
              <td class="fileLabel" nowrap>#rsEmpleado.NTIdescripcion#:</td>
              <td>#rsEmpleado.DEidentificacion#</td>
            </tr>
			<cfif isdefined('Lvar_IncluyeFechaNac')>
			 <tr>
              <td class="fileLabel" nowrap>Fecha de Nacimiento:</td>
              <td>#LSDateFormat(rsEmpleado.FechaNacimiento,'dd/mm/yyyy')#</td>
            </tr>
			</cfif>
          </table>
      </td>
    </tr>
</table>
</cfoutput>