<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajuste Costo de Ventas'>

<cfquery datasource="sifinterfaces">
	delete ACostoVentas
	where sessionid = #session.monitoreo.sessionid#
</cfquery>

<form name="form1" method="post" action="ProcAjusteCV.cfm">
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td align="right">
			<center>
				<strong> EL PROCESO DE AJUSTE DE COSTO DE VENTAS GENERA UNA POLIZA DE AJUSTE </strong>
				<BR>
				<strong> PARA LA CUENTA DE BALANCE EN AQUELLAS ORDENES COMERCIALES CON SALDO </strong>
				<BR>
				<strong> QUE SEAN SELECCIONADAS POR EL USUARIO. </strong>
			</center>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2"><cf_botones values="Continuar" names="Continuar" tabindex="1"></td></tr>
</table>
</form>
<cf_web_portlet_end>
<cf_templatefooter>