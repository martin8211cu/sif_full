<cf_templateheader title="Listado de Actividades">

		<cf_web_portlet_start border="true" titulo="Listado de Actividades" >
		<cfoutput>
			<form style="margin:0" action="actividad.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td align="right" valign="middle" width="40%"><strong>Actividad desde:</strong></td>
					<td>		<cf_conlis
								campos="DGAid,DGAcodigo,DGAdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Actividades"
								tabla="DGActividades a"
								columnas="a.DGAid,a.DGAcodigo,a.DGAdescripcion"
								filtro="1 = 1 order by a.DGAcodigo"
								desplegar="DGAcodigo,DGAdescripcion"
								filtrar_por="DGAcodigo,DGAdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGAid,DGAcodigo,DGAdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Actividades --"
								tabindex="1">
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="40%"><strong>Actividad hasta:</strong></td>
					<td>		<cf_conlis
								campos="DGAid2,DGAcodigo2,DGAdescripcion2"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Actividades"
								tabla="DGActividades a"
								columnas="a.DGAid as DGAid2,a.DGAcodigo as DGAcodigo2,a.DGAdescripcion as DGAdescripcion2"
								filtro="1 = 1 order by a.DGAcodigo"
								desplegar="DGAcodigo2,DGAdescripcion2"
								filtrar_por="DGAcodigo,DGAdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGAid2,DGAcodigo2,DGAdescripcion2"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Actividades --"
								tabindex="1">
					</td>
				</tr>

				<tr>
					<td colspan="4" align="center"><input type="submit" name="btnConsultar" value="Consultar" class="btnConsulta" /></td>
				</tr>
			</table>
		</form>
		<cf_web_portlet_end>
		</cfoutput>
	<cf_templatefooter>		
