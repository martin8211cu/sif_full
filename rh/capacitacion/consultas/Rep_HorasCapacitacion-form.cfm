<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
        
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CapacitacionYDesarrollo"
	Default="Capacitación y desarrollo"
	returnvariable="LB_CapacitacionYDesarrollo"/> 

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeHorasDeCapacitacion"
	Default="Reporte de horas de capacitación"
	returnvariable="LB_ReporteDeHorasDeCapacitacion"/> 
	
	<cf_web_portlet_start titulo="#LB_ReporteDeHorasDeCapacitacion#">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<table width="98%" cellpadding="0" cellspacing="0" align="center">			
			<tr>
				<td width="1">&nbsp;</td>
				<td><cfinclude template="Rep_HorasCapacitacion-rep.cfm"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="1">&nbsp;</td>
				<td><center>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>
				<cfoutput>
				<form action="Rep_HorasCapacitacion.cfm"><input type="submit" value="#BTN_Regresar#"></form></center></td>
				</cfoutput>
			</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>