<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Importador de Saldos Iniciales para Cesant&iacute;a"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>

<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_nav__SPdescripcion#'>
		<table width="98%" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td width="50%" valign="top"><cf_sifFormatoArchivoImpr EIcodigo = 'CESANTIA'></td>
				<td width="50%" valign="top"><cf_sifimportar EIcodigo="CESANTIA" mode="in" /></td>
			</tr>
		</table>
	 <cf_web_portlet_end>
	<cf_templatefooter>