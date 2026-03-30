<style type="text/css">
<!--
.etiquetaCampo {
	font-family: Tahoma;
	font-size: 14px;
	font-style:inherit;
}
.textoCampo {
	font-family: Tahoma;
	font-size: 12px;
}
-->
</style>

<table align="center" width="90%"  border="0">
  <tr>
	<td>&nbsp;</td>
	<td class="etiquetaCampo" align="center">
	  ¡Bienvenido al Sistema Financiero Integral!
	  </td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td align="left" valign="top">
	<cf_web_portlet_start border="false" skin="#Session.Preferences.Skin#" tituloalign="center">
	<table width="100%"  border="0">
	  <tr>
		<td class="textoCampo">
		  Su empresa no tiene definidas las opciones b&aacute;sicas para su funcionamiento. 
		  Haga click al bot&oacute;n Configurar para iniciar el proceso de configuraci&oacute;n general, as&iacute; podr&aacute; utilizar el sistema.
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center">
			<form name="form1" method="post" action="wizGeneral01.cfm">
				<input name="Configurar" type="submit" value="Configurar &gt;&gt;">
			</form>
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
	</td>
	<td width="1%">&nbsp;</td>
	<td width="1%" valign="top">
		<cfset thisForm = 0>
		<cfinclude template="frame-Progreso.cfm">
	</td>
  </tr>
</table>
