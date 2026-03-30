<!---*******************************--->
<!--- definición de ayudas según    --->
<!--- el paso en que encuentra      --->
<!---*******************************--->
 <cfif GPaso EQ 0>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Lista de puestos</strong><br> 
		  <br>
		Seleccione un puesto para crear o modificar el plan de sucesión.
		<td>&nbsp;</td>
	  </tr>
	</table>
 <cfelseif GPaso EQ 1>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Inclusi&oacute;n / Modificación del plan de sucesi&oacute;n.</strong><br> 
		  <br>
			En este paso se podr&aacute; ingresar  o modificar el plan de sucesi&oacute;n que sea selecionado previamente.
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelseif GPaso EQ 2>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Inclusi&oacute;n de Candidatos al Puesto </strong><br> 
		  <br>
			En este paso se podr&aacute; agregar los empleados que participaran en el plan de sucesi&oacute;n. 
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelseif GPaso EQ 3>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><strong>Progreso del Plan de Sucesi&oacute;n</strong><br> 
		  <br>
			Muestra informaci&oacute;n de la calificaciones obtenidas por los candidatos al puesto 
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelseif GPaso EQ 4>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td>&nbsp;</td>
		<td><p><strong>Detalle del Progreso</strong><br> 
	      <br>
			Muestra informaci&oacute;n detallada de las evaluaciones  obtenidas por un empleado
			tanto en sus habilidades conductuales como los conocimientos técnicos
		<td>&nbsp;</td>
	  </tr>
	</table>	
</cfif>
