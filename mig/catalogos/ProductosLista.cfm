<cfquery name="rsEstados" datasource="#session.DSN#">
	select  -1 as value, 'Todos' as description from dual
	union all
	select  0 as value, 'Inactivo' as description from dual
	union all
	select 1 as value, 'Activo' as description from dual
	order by 1
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td valign="top" nowrap="nowrap"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MIGProductos a
								left join MIGProLineas b
									on b.MIGProLinid=a.MIGProLinid"
						columnas="
									a.MIGProid,
									case a.Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva,
									a.MIGProcodigo,
									a.MIGPronombre,
									b.MIGProLindescripcion"
						desplegar="MIGProcodigo,MIGPronombre,MIGProLindescripcion,Dactiva"
						etiquetas="C&oacute;digo, Descripción, Línea Negocio"
						formatos="S,S,S,S"
						filtro="a.Ecodigo=#session.Ecodigo#  order by a.MIGProcodigo"
						align="left,left,left,left"
						checkboxes="N"
						keys="MIGProid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGProcodigo,MIGPronombre,MIGProLindescripcion,a.Dactiva, &nbsp;"
						ira="Productos.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="Productos.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
			<input name="Importar" type="submit" value="Importar" tabindex="2">
		</form>
		</td>
	</tr>
</table>