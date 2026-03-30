<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: ImportarPre-factura.cfm                               --->
<!--- Fecha:  02/06/2014                                              --->
<!--- Última Modificación: 02/06/2014    	                          --->
<!--- =============================================================== --->

<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
        	select Pvalor from Parametros where Pcodigo = '17200' and Ecodigo = #session.Ecodigo#
        </cfquery>

        <cfset value = "#rsPCodigoOBJImp.Pvalor#">
<!-- Fin Querys AFGM-SPR -->

<cfprocessingdirective pageencoding = "utf-8">

<cf_templateheader title=" Importacón de Pre-facturas">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación de Pre-facturas">
<table width="100%"  border="1" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
		<cfif value eq '4.0'>
		 	<cf_sifFormatoArchivoImpr EIcodigo="FAIMPORTAPF4" tabindex="1">
		<cfelse>
			<cf_sifFormatoArchivoImpr EIcodigo="FAIMPORTAPF" tabindex="1">
		 </cfif>
			

		</td>
		<td align="center" style="padding-left: 15px;" valign="top">
			<cfoutput><div align="right"><input type="button" tabindex="1" name="Regresar" value="Regresar" onclick="window.location='../MenuFA.cfm'" /></div></cfoutput><br>
			<cfif value eq '4.0'>
				<cf_sifimportar EIcodigo="FAIMPORTAPF4" mode="in"  tabindex="1">
			<cfelse>
				<cf_sifimportar EIcodigo="FAIMPORTAPF" mode="in"  tabindex="1">
			</cfif>


		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>

<cf_web_portlet_end>
<cf_templatefooter>