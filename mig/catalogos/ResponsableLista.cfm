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
			tabla="MIGResponsables"
			columnas="MIGReid, MIGRcodigo, MIGRenombre,MIGRecorreo,MIGRecorreoadicional, case Dactivas when 0 then 'Inactivo' when 1 then 'Activo' end as Dactivas"
			desplegar="MIGRcodigo, MIGRenombre,MIGRecorreo,MIGRecorreoadicional, Dactivas"
			etiquetas="C&oacute;digo, Nombre Responsable, Correo Electr&oacute;nico, Correo Electr&oacute;nico Adicional,Estado"
			formatos="S,S,S,S,S"
			filtro="Ecodigo=#session.Ecodigo# order by MIGRcodigo"
			align="left,left,left,left,left"
			checkboxes="N"
			keys="MIGReid"
			MaxRows="15"
			pageindex="1"
			filtrar_automatico="true"
			mostrar_filtro="true"
			filtrar_por="MIGRcodigo, MIGRenombre,MIGRecorreo,MIGRecorreoadicional,Dactivas, &nbsp;, &nbsp;"
			ira="Responsable.cfm"
			showEmptyListMsg="true"
			rsDactivas="#rsEstados#"
			inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="Responsable.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
			<input name="Importar" type="submit" value="Importar" tabindex="2">
		</form>
		</td>
	</tr>
</table>
