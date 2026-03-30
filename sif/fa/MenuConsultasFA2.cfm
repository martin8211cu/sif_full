<cfinvoke component="sif.Componentes.Translate" method = "Translate" key = "LB_Titulo" default = "Consultas" returnvariable = "LB_Titulo" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionesFacturacion" default = "Transacciones de Facturaci&oacute;n" returnvariable ="LB_TransaccionesFacturacion" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionesContado" default = "Transacciones de Contado" returnvariable ="LB_TransaccionesContado" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionesCredito" default = "Transacciones de Cr&eacute;dito" returnvariable ="LB_TransaccionesCredito" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NotasCredito" default = "Notas de Cr&eacute;dito" returnvariable ="LB_NotasCredito" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionesAnuladas" default = "Transacciones Anuladas" returnvariable ="LB_TransaccionesAnuladas" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Comisiones" default = "Comisiones" returnvariable ="LB_Comisiones" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DetalleCostosIngresosAutomaticos" default = "Detalle de Costos e Ingresos Autom&aacute;ticos" returnvariable ="LB_DetalleCostosIngresosAutomaticos" xmlfile = "MenuConsultasFA2.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DetalleListasPrecios" default = "Detalle de Listas de Precios" returnvariable ="LB_DetalleListasPrecios" xmlfile = "MenuConsultasFA2.xml">


<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="#LB_Titulo#">

<table border="0" cellpadding="2" cellspacing="0">
	  <tr>
	    <td width="1%" align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repTransacciones.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td width="99%"  align="left" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repTransacciones.cfm" class="style1" tabindex="-1"><cfoutput>#LB_TransaccionesFacturacion#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repTransacciones.cfm?tipo=CO"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repTransacciones.cfm?tipo=CO" class="style1" tabindex="-1"><cfoutput>#LB_TransaccionesContado#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repTransacciones.cfm?tipo=CR"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repTransacciones.cfm?tipo=CR" class="style1" tabindex="-1"><cfoutput>#LB_TransaccionesCredito#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repTransacciones.cfm?tipo=NC"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repTransacciones.cfm?tipo=NC" class="style1" tabindex="-1"><cfoutput>#LB_NotasCredito#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repTransacciones.cfm?tipo=AN"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repTransacciones.cfm?tipo=AN" class="style1" tabindex="-1"><cfoutput>#LB_TransaccionesAnuladas#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/Comisiones.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/Comisiones.cfm" class="style1" tabindex="-1"><cfoutput>#LB_Comisiones#</cfoutput></a></div></td>
	  </tr>
	  
      <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repCosIng.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repCosIng.cfm" class="style1" tabindex="-1"><cfoutput>#LB_DetalleCostosIngresosAutomaticos#</cfoutput></a></div></td>
	  </tr>	
      
      <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/repCosIng.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/repListaPrecio.cfm" class="style1" tabindex="-1"><cfoutput>#LB_DetalleListasPrecios#</cfoutput></a></div></td>
	  </tr>	
 </table>
	<cf_web_portlet_end>