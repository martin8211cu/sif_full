<cfif GPaso EQ 0>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
		<tr>
			<td align="center"><strong>Proceso de Solicitud</strong><br> <br></td>
		</tr>
			<td>
				Seleccione la solicitud de personal para crear el concurso. Esto lo llevar&aacute; al paso 1.
				Para eliminar solicitudes de personal ya creadas, seleccione las que desea eliminar y haga click en el bot&oacute;n de Eliminar
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
<cfelseif GPaso EQ 1>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
		<tr>
			<td align="center"><strong>Registro de Concurso</strong><br> <br></td>
		</tr>
		<tr>
			<td>
				En este paso se podrá ingresar el concurso para suplir el puesto que se necesita. <br> <br> Los campos: Puesto, N&deg; 
				Plazas, C&oacute;digo de Concurso, Centro Funcional, Descripción, Fecha de Apertura y Fecha de Cierre son requeridos.
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
<cfelseif GPaso EQ 2>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	 	<tr>
			<td align="center"><strong>Selecci&oacute;n de Plazas</strong><br> <br></td>
		</tr>
		<tr>
			<td>
				En este paso se podrá seleccionar <br> la(s) plaza(s) para el concurso solicitado.
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
<cfelseif GPaso EQ 3>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
		<tr>
			<td align="justify"><strong>Criterios de Evaluación</strong><br> <br></td>
		</tr>
		<tr>
			<td>
				En este paso se podrá seleccionar <br> los criterios con que se evaluar&aacute; el concurso solicitado.
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
<cfelseif GPaso EQ 4>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	 	<tr>
			<td align="center"><strong>Publicaci&oacute;n</strong><br> <br>
		</tr>
		<tr>
			<td>
				En este paso se podrá hacer p&uacute;blico el presente concurso.
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
</cfif>
