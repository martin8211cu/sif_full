<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->

<!--- Tags para la traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default= "Transferencia de P&oacute;lizas" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConsultaEstatus" Default= "Consulta Estatus de P&oacute;lizas" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_ConsultaEstatus"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReportePolizas" Default= "Reporte de P&oacute;lizas Transferidas y Aplicadas" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_ReportePolizas"/>

<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<ul>  
		</br><li>
			<a href="PolizasImportadas-consulta.cfm"><cfoutput>#LB_ConsultaEstatus#</cfoutput></a>
		</li></br>
		<br><li>
			<a href="PolizasImportadas-reporte.cfm"><cfoutput>#LB_ReportePolizas#</cfoutput></a>
		</li></br>
	</ul>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->