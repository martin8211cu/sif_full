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
						tabla="MIGMetas a
								left join MIGMetricas b
									on b.MIGMid=a.MIGMid"
						columnas="
									a.MIGMetaid,
									b.MIGMcodigo,
									a.Pfecha,
									a.Meta,
									a.Peso,
									case a.Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
						desplegar="MIGMcodigo,Pfecha,Meta,Peso,Dactiva"
						etiquetas="C&oacute;digo, Fecha, Meta, Peso, Estado,"
						formatos="S,D,S,S,S"
						filtro="a.Ecodigo=#session.Ecodigo# and b.MIGMesmetrica='I'  order by b.MIGMcodigo,a.Pfecha"
						align="left,left,left,left,left"
						checkboxes="N"
						keys="MIGMetaid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="b.MIGMcodigo,a.Pfecha,a.Meta,a.Peso,a.Dactiva"
						ira="MIGMetas.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="MIGMetas.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
			<input name="Importar" type="submit" value="Importar" tabindex="2">
		</form>
		</td>
	</tr>
</table>