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
						tabla="MIGParametros"
						columnas="
									MIGParid,
									MIGParcodigo,
									MIGPardescripcion,
									MIGPartipo,
									case MIGParactual when 'S' then 'SI' when 'N' then 'NO' end as MIGParactual,
									case Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
						desplegar="MIGParcodigo, MIGPardescripcion, MIGPartipo, MIGParactual, Dactiva"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Tipo, Aplica Calificaci&oacute;n, Estado"
						formatos="S,S,S,S,S"
						filtro="Ecodigo= #session.Ecodigo# order by MIGParcodigo"
						align="left,left,left,left,left"
						checkboxes="N"
						keys="MIGParid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGParcodigo, MIGPardescripcion, MIGPartipo, MIGParactual, Dactiva, &nbsp;, &nbsp;"
						ira="MIGParametro.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="MIGParametro.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
		</form>
		</td>
	</tr>
</table>
