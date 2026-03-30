<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default= "Importaci&oacute;n de saldos iniciales" XmlFile="saldosIniciales.xml" returnvariable="LB_titulo"/>

<cf_templateheader title="#LB_titulo#">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_titulo#">
			<cfinclude template="../../portlets/pNavegacion.cfm">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
					<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="55%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'IMPSALDINI' tabindex="1">
					</td>
					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="IMPSALDINI" mode="in"  tabindex="1">
					</td>
					</tr>
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
				</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
