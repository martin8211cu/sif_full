<cf_templateheader title="Conceptos">

		<cf_web_portlet_start border="true" titulo="Conceptos de Estado de Resultados" >
		<cfoutput>
			<form style="margin:0" action="conceptos.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td align="right" valign="middle" width="40%"><strong>Concepto desde:</strong></td>
					<td>		<cf_conlis
								campos="DGCid,DGCcodigo,DGdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Conceptos de Estado de Resultados"
								tabla="DGConceptosER a"
								columnas="a.DGCid, a.DGCcodigo, a.DGdescripcion "
								filtro="1 = 1 order by a.DGCcodigo"
								desplegar="DGCcodigo,DGdescripcion "
								filtrar_por="DGCcodigo,DGdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGCid,DGCcodigo,DGdescripcion "
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Conceptos de Estaod de Resultados --"
								tabindex="1">
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="40%"><strong>Concepto hasta:</strong></td>
					<td>		<cf_conlis
								campos="DGCid2,DGCcodigo2,DGdescripcion2"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Conceptos de Estado de Resultados"
								tabla="DGConceptosER a"
								columnas="a.DGCid as DGCid2, a.DGCcodigo as DGCcodigo2, a.DGdescripcion as DGdescripcion2 "
								filtro="1 = 1 order by a.DGCcodigo"
								desplegar="DGCcodigo2,DGdescripcion2 "
								filtrar_por="DGCcodigo,DGdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGCid2,DGCcodigo2,DGdescripcion2 "
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Conceptos de Estaod de Resultados --"
								tabindex="1">
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Tipo:</strong></td>
					<td align="left" valign="middle">
						<select name="DGtipo">
							<option value="" >- Todos -</option>
							<option value="I" >Ingreso</option>
							<option value="G" >Gasto</option>
						</select>
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Comportamiento:</strong></td>
					<td align="left" valign="middle">
						<select name="Comportamiento">
							<option value="" >- Todos -</option>
							<option value="O"  >Objeto de Gasto</option>
							<option value="P" >Producto</option>
						</select>
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Referencia:</strong></td>
					<td align="left" valign="middle">
						<select name="referencia">
							<option value="" >- Todos -</option>
							<option value="10"  >Ventas</option>
							<option value="20" >Costo de Ventas</option>
							<option value="30"  >Otros Ingresos de Operaci&oacute;n</option>
							<option value="40" >Gastos Directos</option>
							<option value="41" >Gastos Indirectos</option>
							<option value="50"  >Otros Gastos Deducibles</option>
							<option value="60" >Asignaci&oacute;n Gastos Administrativos</option>
							<option value="70"  >Otros Ingresos No Gravables</option>
							<option value="80" >Otros Gastos No Deducibles</option>
							<option value="90"  >Impuestos</option>
						</select>
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
