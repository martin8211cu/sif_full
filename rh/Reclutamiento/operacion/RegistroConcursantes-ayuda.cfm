<!---*******************************--->
<!--- definición de ayudas según    --->
<!--- el paso en que encuentra      --->
<!---*******************************--->
 <cfif GPaso EQ 0>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Selecci&oacute;n de Concursos</strong><br> 
		  <br>
		Seleccione el concurso con el cual desea trabajar en la inclusi&oacute;n de los participantes.
		<td>&nbsp;</td>
	  </tr>
	</table>
 <cfelseif GPaso EQ 1>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Inclusi&oacute;n de Concursantes</strong><br> 
		  <br>
			En este paso se podr&aacute; ingresar los participantes para las diferentes plazas en con curso.
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelseif GPaso EQ 2>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Valoraci&oacute;n de Pruebas </strong><br> 
		  <br>
			En este paso se podr&aacute; modificar la valoraci&oacute;n de las pruebas a realizar para el concurso seleccionado 
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelseif GPaso EQ 3>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Resumen</strong><br> 
		  <br>
			Muestra informaci&oacute;n general del concurso
		<td>&nbsp;</td>
	  </tr>
	</table>
</cfif>
