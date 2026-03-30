<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" >
		<tr><td width="10%">&nbsp;</td><td valign="top" align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr>
				<td valign="top">
					<cf_conlis
					campos="ECid,ECcodigo,ECdescripcion"
					asignar="ECid,ECcodigo,ECdescripcion"
					size="0,10,40"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="Cargas de Empleado"					
					tabla="ECargas"
					columnas="Ecodigo,ECid,ECcodigo, ECdescripcion"
					filtro="Ecodigo =  #form.EcodigoO#
							order by ECcodigo,ECdescripcion"
					desplegar="ECcodigo,ECdescripcion"
					filtrar_por="ECcodigo,ECdescripcion"
					etiquetas="Código,Descripción"
					formatos="S,S"
					align="left,left"
					asignarformatos="I,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg="-- No hay Datos --"
					tabindex="1"
					conexion="#form.DSNO#">	
					</td>
				</table>
		</td></tr>
	</table>
</cfoutput>