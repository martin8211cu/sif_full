<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: ImportarArrendamiento.cfm                               --->
<!--- Fecha:  28/03/2014                                              --->
<!--- =============================================================== --->


<cfset session.IDFinan=#form.IDFinan#>
<cfset session.IVA=#form.IVA#>
<cfset session.NumPagos=#form.NumPagos#>
<cfset session.SaldoInsoluto=#form.SaldoInsoluto#>
<cfset session.SaldoInicial=#form.SaldoInicial#>
<cfset session.TasaAnual=#form.TasaAnual#>

<cfprocessingdirective pageencoding = "utf-8">

<cf_templateheader title="Importa tabla Amortizacón Financiamiento">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importa tabla Amort Financiamiento">
<table width="100%"  border="1" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo="FINANARCH" tabindex="1">

		</td>
		<td align="center" style="padding-left: 15px " valign="top">
			<cfoutput><div align="right"><input type="button" tabindex="1" name="Regresar" value="Regresar" onclick="window.location='Financiamiento.cfm?&IDFinan=#form.IDFinan#&modo=cambio&mododet=cambio&tipocambio=#form.tipocambio#'" /></div></cfoutput><br>
			<cf_sifimportar EIcodigo="FINANARCH" mode="in"  tabindex="1">

		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>

<cf_web_portlet_end>
<cf_templatefooter>