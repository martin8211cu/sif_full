<!--- 
	Creado por: Ana Villavicencio
	Fecha: 22 de julio del 2005
	Motivo: Nueva opción en Contabilidad General.
			Proceso para la Revaluación de Cuentas de Mayor.
 --->

<cfinvoke  key="LB_Titulo" default="Revaluaci&oacute;n de Cuentas de Mayor" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="Revaluacion.xml"/>

	<cf_templateheader title="#LB_Titulo#">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
			titulo='#LB_Titulo#'>
			<cfinclude template="Funciones.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<!---<tr><td align="right" colspan="2"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url=""></td></tr>--->
			  	<tr><td valign="top"><cfinclude template="formRevaluacion.cfm"></td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>