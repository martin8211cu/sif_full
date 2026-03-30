<cf_templateheader title="Lista de Gastos por Distribuir">
		<cf_web_portlet_start border="true" titulo="Lista de Gastos por Distribuir" >
		<cfoutput>
			<form style="margin:0" action="gastosDist.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td align="right" valign="middle" width="40%"><strong>Gastos por Distribuir desde:</strong></td>
					<td>		<cf_conlis
								campos="DGGDid,DGGDcodigo,DGGDdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Gastos por Distribuir"
								tabla="DGGastosDistribuir a"
								columnas="a.DGGDid,a.DGGDcodigo,a.DGGDdescripcion"
								filtro="1 = 1 order by a.DGGDcodigo"
								desplegar="DGGDcodigo,DGGDdescripcion"
								filtrar_por="DGGDcodigo,DGGDdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGGDid,DGGDcodigo,DGGDdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Gastos por Distribuir--"
								tabindex="1">
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="40%"><strong>Gasto por Distribuir hasta:</strong></td>
					<td>		<cf_conlis
								campos="DGGDid2,DGGDcodigo2,DGGDdescripcion2"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Gastos por Distribuir"
								tabla="DGGastosDistribuir a"
								columnas="a.DGGDid as DGGDid2,a.DGGDcodigo as DGGDcodigo2,a.DGGDdescripcion as DGGDdescripcion2"
								filtro="1 = 1 order by a.DGGDcodigo"
								desplegar="DGGDcodigo2,DGGDdescripcion2"
								filtrar_por="DGGDcodigo,DGGDdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="DGGDid2,DGGDcodigo2,DGGDdescripcion2"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Gastos por Distribuir --"
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
