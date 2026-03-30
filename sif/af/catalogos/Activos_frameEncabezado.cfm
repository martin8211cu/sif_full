<cfinvoke component="sif.af.Componentes.Activo" method="getActivo" Aid="#form.Aid#"  Ecodigo="#form.Ecodigo#" returnvariable="rsActivo"/>
<cfoutput>
	<!--- Pintado de la Información --->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="10%">&nbsp;</td>
		<td class="tituloAlterno">Activo:#rsActivo.Aplaca# - #rsActivo.Adescripcion#</td>
		<td width="10%">&nbsp;</td>
	</tr>
	</table>	
</cfoutput>