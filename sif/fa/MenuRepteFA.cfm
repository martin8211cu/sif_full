<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default= "Reporte de Facturaci&oacute;n" XmlFile="MenuRepteFA.xml" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SociosNegocioParaDistribucionGastos" Default= "Socios de Negocio para Distribuci&oacute;n de Gastos" XmlFile="MenuRepteFA.xml" returnvariable="LB_SociosNegocioParaDistribucionGastos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ParametrosReporteDistribucionGastos" Default= "Parametros del Reporte de Distribución de Gastos" XmlFile="MenuRepteFA.xml" returnvariable="LB_ParametrosReporteDistribucionGastos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDistribucionGastos" Default= "Reporte de Distribución de Gastos" XmlFile="MenuRepteFA.xml" returnvariable="LB_ReporteDistribucionGastos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteTimbres" Default= "Reporte de Timbres Usados" XmlFile="MenuRepteFA.xml" returnvariable="LB_ReporteTimbres"/>
<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="#LB_Titulo#">

<table border="0" cellpadding="2" cellspacing="0">
		<tr>
            <td align="right" class="etiquetaProgreso"><a href="catalogos/SNDistGasto.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
            <td class="etiquetaProgreso"><div align="left"><a href="catalogos/SNDistGasto.cfm" tabindex="-1"><cfoutput>#LB_SociosNegocioParaDistribucionGastos#</cfoutput></a></div></td>
          </tr>
	  <tr>
	    <td width="1%" align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/ParamDistGastos.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td width="99%"  align="left" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/ParamSNDistGasto.cfm" class="style1" tabindex="-1"><cfoutput>#LB_ParametrosReporteDistribucionGastos#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/RpteDistGastos.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/RpteDistGastos.cfm" class="style1" tabindex="-1"><cfoutput>#LB_ReporteDistribucionGastos#</cfoutput></a></div></td>
	  </tr>

	  <tr>
	    <td align="right" valign="middle" class="etiquetaProgreso"><a href="consultas/RpteTimbUs.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td align="center" valign="middle" class="etiquetaProgreso"><div align="left"><a href="consultas/RpteTimbUs.cfm" class="style1" tabindex="-1"><cfoutput>#LB_ReporteTimbres#</cfoutput></a></div></td>
	  </tr>

 </table>
	<cf_web_portlet_end>