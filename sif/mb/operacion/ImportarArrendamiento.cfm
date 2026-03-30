<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: ImportarArrendamiento.cfm                               --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 16/04/2014    	                          --->
<!--- =============================================================== --->

<cfset session.idArrend=#form.IDArrend#>
<cfset session.IVA=#form.IVA#>
<cfset session.NumMensualidades=#form.NumMensualidades#>
<cfset session.SaldoInsoluto=#form.SaldoInsoluto#>
<cfset session.SaldoInicial=#form.SaldoInicial#>
<cfset session.TasaAnual=#form.TasaAnual#>

<cfprocessingdirective pageencoding = "utf-8">

<cf_templateheader title=" Importacón de Tabla de Amortización">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación de Tabla de Amortización">
<table width="100%"  border="1" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo="CARGAAMORT" tabindex="1">

		</td>
		<td align="center" style="padding-left: 15px " valign="top">
			<cfoutput><div align="right"><input type="button" tabindex="1" name="Regresar" value="Regresar" onclick="window.location='Arrendamiento.cfm?&idarrend=#form.idarrend#&modo=cambio&mododet=cambio&tipocambio=#form.tipocambio#'" /></div></cfoutput><br>
			<cf_sifimportar EIcodigo="CARGAAMORT" mode="in"  tabindex="1">

		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>

<cf_web_portlet_end>
<cf_templatefooter>