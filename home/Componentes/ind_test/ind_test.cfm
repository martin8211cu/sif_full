<cfset mes = 3>
<cfset ano = 2005>

<style type="text/css">
tr.f1 td {
	border-top:1px solid red;
}
</style>
<table width="400" border="0" cellpadding="2" cellspacing="0">
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td colspan="2">Anterior</td>
<td colspan="2">Actual</td>
</tr>
<tr>
  <td>Fecha</td>
  <td>Filtro</td>
  <td>Desde</td>
  <td>Hasta</td>
  <td>Desde</td>
  <td>Hasta</td>
</tr>

<cfloop from="1" to="31" index="dia">

	<cfloop from="6" to="6" index="f">
	
	<cfset hoy = CreateDate(ano,mes,dia) >
	
	
		<cfinvoke component="home.Componentes.IndicadorTiempos" method="filtro#f#" returnvariable="x" fecha="#hoy#" ></cfinvoke>
		<cfoutput>
<tr <cfif f is 1>class="f1"</cfif>>
  <td>#LSDateFormat(hoy)#</td>
  <td>#f#</td>
  <td>#LSDateFormat(x.desde_ant)#</td>
  <td>#LSDateFormat(x.hasta_ant)#</td>
  <td>#LSDateFormat(x.desde_act)#</td>
  <td>#LSDateFormat(x.hasta_act)#</td>
</tr></cfoutput>
	
	</cfloop>

</cfloop>

</table>