<cf_templateheader title="Cierre de Contablidad Presupuestal Después de Retroactivos ">
	<cfflush interval="32">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cierre de Contablidad Presupuestal Después de Retroactivos'>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" align="right">
			<!---<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Cierre_mes_contable.htm">--->
		</td>
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td valign="top">&nbsp;</td>
		<td valign="top">
		  <cfinclude template="formCierreContaPres.cfm">
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
