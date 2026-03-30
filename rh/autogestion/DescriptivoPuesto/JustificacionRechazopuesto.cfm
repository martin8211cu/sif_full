<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" id="TBL1">
	<tr><td colspan="2" style="color:##0099FF"><strong><cf_translate key="LB_JustificacionRechazo">Ingrese una justificaci&oacute;n de su Rechazo</cf_translate></strong></td></tr>
	<tr><td align="center">
		<textarea name="IjustificacionW" id="IjustificacionW" cols="50" rows="10"></textarea>
	</td></tr>
	<tr><td align="center">
	<input name="BNTCancelar" type="button" onClick="javascript: CancelarRechazo()" value="Cancelar" />
	<input name="BNTAceptar" type="button" onclick="javascript: AceptarRechazo()"  value="Aceptar"/>
	</td>
	</tr>
</table>
</cfoutput>