<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Cierre de Mes Contable" 
returnvariable="LB_Titulo" xmlfile="CierreMes.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cfflush interval="32">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <!---<tr>
		<td colspan="2" align="right">
			<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Cierre_mes_contable.htm">
		</td>
	  </tr>--->
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td valign="top">&nbsp;</td>
		<td valign="top">
		  <cfinclude template="formCierreMes.cfm">
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
