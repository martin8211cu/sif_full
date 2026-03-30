<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>

<fieldset><legend>Importar Resultados de Conteo</legend>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="47%" align="left" valign="top">
		<cf_sifFormatoArchivoImpr EIcodigo = "RPIMP_AFTFRC">
	</td>
    <td width="47%" align="center" valign="top">
		<cf_sifimportar EIcodigo="RPIMP_AFTFRC" mode="in"
				width="350" height="350">
			<cf_sifimportarparam name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
		</cf_sifimportar>
	</td>
	<td width="6%" align="right" valign="top">
		<form action="aftfHojasCoteo.cfm" method="post" name="formImportarBack" style="margin:0">
			<cfoutput>
			<input type="hidden" id="AFTFid_hoja" name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
			<cfinclude template="aftfHojasCoteo-hiddens.cfm">
			<cfinclude template="aftfHojasCoteo-hiddenshoja.cfm">
			<cf_botones values="Regresar, Refrescar">
			</cfoutput>
		</form>
	</td>
  </tr>
</table>



</fieldset>

</td>
</tr>
</table>

<script language="javascript" type="text/javascript">
	<!--//
	var _ifrImportar_src = document.getElementById("ifrImportar").src;
	function funcRefrescar() {
		document.getElementById("ifrImportar").src=_ifrImportar_src;
		return false;
	}
	//-->
</script>