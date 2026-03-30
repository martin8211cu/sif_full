<table align="center">
	<tr>
	  <td colspan="3" class="tituloAlterno">Justificación del Traslado de Presupuesto</td>
	</tr>
	<tr>
	  <td width="50%" align="center">
	  	<cfoutput>
	  	<textarea name="CPDEjustificacion" cols="100" rows="20">#trim(rsTraslado.CPDEjustificacion)#</textarea>
	  	</cfoutput>
	  </td>
	<tr>
	<tr>
	  <td width="50%" align="center">
	  	<input type="submit" value="Registrar" name="btnJustificacion" onclick="inhabilitarValidacion();">
	  </td>
	<tr>
</table>