<!---*******************************************
*******Sistema Financiero Integral**************
*******GestiÃ³n de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de CreaciÃ³n: Ene/2006**************
*******Desarrollado por: Dorian Abarca GÃ³mez****
********************************************--->
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0;">
  <tr>
    <td valign="top" width="50%">
		<fieldset><legend>Asiento Contable</legend>
			<cfinclude template="Conciliacion-hecontables.cfm"/>
		</fieldset>	
	</td>
	<td>&nbsp;</td>
    <td valign="top" width="50%" align="right">
		<fieldset><legend>Gesti&oacute;n de Activos</legend>
			<cfinclude template="Conciliacion-gatransacciones.cfm"/>
		</fieldset>
	</td>
  </tr>
</table>
