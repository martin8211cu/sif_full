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
						tabla="MIGMetricas a
								inner join MIGResponsables b
									on a.MIGRecodigo=b.MIGReid
								inner join MIGResponsables c
									on a.MIGReidduenno=c.MIGReid"
						columnas="
									a.MIGMid,
									a.MIGMcodigo,
									a.MIGMnombre,
									b.MIGRenombre as nombre,
									c.MIGRenombre as nombR,
									a.MIGRecodigo,
									case a.Dactiva 
										when 0 then 'Inactivo' 
										when 1 then 'Activo' end as Dactiva"
						desplegar="MIGMcodigo,MIGMnombre,nombre,nombR,Dactiva"
						etiquetas="C&oacute;digo, Nombre Indicador,Dueño Responsable,Responsable,Estado"
						formatos="S,S,S,S,S"
						filtro="a.MIGMesmetrica='I' and a.Ecodigo=#session.Ecodigo# order by a.MIGMcodigo"
						align="left,left,left,left,left"
						checkboxes="N"
						keys="MIGMid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGMcodigo,MIGMnombre,b.MIGRenombre,c.MIGRenombre,Dactiva, &nbsp;, &nbsp;"
						ira="Indicadores.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="Indicadores.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
			<!---<input name="Importar" type="submit" value="Importar" tabindex="2">--->
		</form>
		</td>
	</tr>
</table>