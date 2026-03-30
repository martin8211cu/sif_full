<cfoutput> 
<cfset session.params.mododespliegue = 0>
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center">
  <table width="95%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 10px; margin-right: 10px;">
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>

    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_DATOS_GENERALES">DATOS GENERALES</cf_translate></td>
    </tr>
    <tr> 
      <td valign="top" nowrap> 

		  <cfinclude template="../../expediente/consultas/frame-general.cfm">

	  </td>
      <td align="center" valign="top" nowrap>
	  	<cfinclude template="../../expediente/consultas/frame-jerarquiaPuesto.cfm">
	  </td>
    </tr>
	
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_LISTA_DE_FAMILIARES">LISTA DE FAMILIARES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-familiares.cfm">
	  </td>
    </tr>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_SITUACION_ACTUAL">SITUACION ACTUAL</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-situacionActual.cfm">
	  </td>
    </tr>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_VACACIONES">VACACIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-vacaciones.cfm">
	  </td>
    </tr>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_CARGAS">CARGAS</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-cargas.cfm">
	  </td>
    </tr>	
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_DEDUCCIONES">DEDUCCIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-deducciones.cfm">
	  </td>
    </tr>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_OTROS_EXPEDIENTES">OTROS EXPEDIENTES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-expedientes.cfm">
	  </td>
    </tr>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_ANOTACIONES">ANOTACIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="../../expediente/consultas/frame-anotaciones.cfm">
	  </td>
    </tr>

    <tr>
      <td colspan="2" >&nbsp;</td>
    </tr>
  </table>
<cf_web_portlet_end>
<cfelse>
	<cf_translate key="LB_Los_datos_de_su_Expediente_Laboral_no_estaan_disponibles">Los datos de su Expediente Laboral no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>