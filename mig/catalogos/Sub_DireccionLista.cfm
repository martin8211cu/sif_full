<cfif isdefined ('form.Importar')>
	<cflocation url="Sub_DireccionImportardor.cfm">
</cfif>
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
		<td valign="top"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGSDireccion"
				columnas="MIGSDid, MIGSDcodigo, MIGSDdescripcion, case Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
				desplegar="MIGSDcodigo, MIGSDdescripcion, Dactiva"
				etiquetas="C&oacute;digo, Descripci&oacute;n, Estado"
				formatos="S,S,S"
				filtro="Ecodigo=#session.Ecodigo# Order By MIGSDcodigo"
				align="left,left,left"
				checkboxes="N"
				keys="MIGSDid"
				MaxRows="15"
				pageindex="1"
				filtrar_automatico="true"
				mostrar_filtro="true"
				filtrar_por="MIGSDcodigo, MIGSDdescripcion,Dactiva, &nbsp;, &nbsp;"
				ira="Sub_Direccion.cfm"
				showEmptyListMsg="true"
				rsDactiva="#rsEstados#"
				inactivecol="valido">
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" width="50%">
		<form name="formRedirec" method="post" action="Sub_Direccion.cfm" style="margin: '0' ">
			<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
			<input name="Importar" type="submit" value="Importar" tabindex="2">
		</form>
		</td>
	</tr>
</table>