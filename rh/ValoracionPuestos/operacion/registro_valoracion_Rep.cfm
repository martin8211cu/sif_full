<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consultas"
	Default="Consultas"
	returnvariable="LB_Consultas"/>
<cf_web_portlet_start border="true" titulo="#LB_Consultas#" skin="#Session.Preferences.Skin#" >
<cfoutput>
	<table width="100%"  border="0" cellspacing="3" cellpadding="0">
       <tr>
		<td width="1%" valign="middle"><div align="center"><a href="RClasificacionGradoPuesto.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="RClasificacionGradoPuesto.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><font  style="font-size:10px"><cf_translate key="LB_Clasificacion_de_grados_por_puesto">Clasificaci&oacute;n de grados por puesto</cf_translate></font></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center"><a href="../consultas/PuntosXFactor-rep.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="../consultas/PuntosXFactor-rep.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><font  style="font-size:10px"><cf_translate key="LB_Puntuacion_de_Factores_por_Puesto">Puntuaci&oacute;n de Factores por Puesto</cf_translate></font></a></strong></td>
	  </tr>
      <tr>
		<td width="1%" valign="middle"><div align="center"><a href="formDispersionPuestoR.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="formDispersionPuestoR.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Interno ">Equilibrio Interno</cf_translate></font></a></strong></td>
	  </tr>
      <!--- <tr>
		<td width="1%" valign="middle"><div align="center"><a href="formDispersionPuestoR.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="formDispersionPuestoR.cfm?RHVPid=#form.RHVPid#&SEL=#form.SEL#"><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Externo ">Equilibrio Externo</cf_translate></font></a></strong></td>
	  </tr> --->
      <tr>
		<td width="1%" valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></div></td>
		<td width="100%" valign="middle" nowrap><strong><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Externo ">Equilibrio Externo</cf_translate></font></strong></td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>