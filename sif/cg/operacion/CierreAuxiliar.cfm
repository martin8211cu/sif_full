<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Contabilidad General" 
returnvariable="LB_Titulo" xmlfile="CierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo1" default="Cierre de Mes de Auxiliares" 
returnvariable="LB_Titulo1" xmlfile="CierreAuxiliar.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cfflush interval="32">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo1#'>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<!---<tr>
			<td colspan="2" align="right">
				<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Cierre_auxiliar.htm">
			</td>
		</tr>--->
		<tr> 
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr> 
			<td valign="top">
		</td>
			<td valign="top"><cfinclude template="formCierreAuxiliar.cfm"></td>
		</tr>
	</table>
	<cf_web_portlet_end>	
<cf_templatefooter>