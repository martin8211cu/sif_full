<cfif isdefined ('form.Importar')>
	<cflocation url="MetricasImportador.cfm">
</cfif>
<cfquery name="rsEstados" datasource="#session.DSN#">
	select  -1 as value, 'Todos' as description from dual
	union all
	select  0 as value, 'Inactivo' as description from dual
	union all
	select 1 as value, 'Activo' as description from dual
	order by 1
</cfquery>
		<table width="100%" border="0" align="center">
			<tr> 
				<td colspan="2"> 
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MIGMetricas"
						columnas="MIGMid, MIGMcodigo, MIGMnombre, case Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
						desplegar="MIGMcodigo, MIGMnombre, Dactiva"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Estado"
						formatos="S,S,S"
						filtro="MIGMesmetrica= 'M' and Ecodigo= #session.Ecodigo# order by MIGMcodigo"
						align="left,left,left"
						checkboxes="N"
						keys="MIGMid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGMcodigo, MIGMnombre,Dactiva, &nbsp;, &nbsp;"
						ira="Metricas.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
				</td>
			</tr>
			<tr>
				<td align="center">
					<form name="formRedirec" method="post" action="Metricas.cfm" style="margin: '0' ">
						<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
						<!---<input name="Importar" type="submit" value="Importar" tabindex="2">--->
					</form>
				</td>
			</tr>

		</table>
