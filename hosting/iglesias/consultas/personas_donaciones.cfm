<cfquery name="rsLista" datasource="#Session.dsn#">
	select 1
	from MEDDonacion a, MEDProyecto b
	where a.MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona#">
	and a.MEDproyecto = b.MEDproyecto
</cfquery>

<cfset STA = "<span class='style3'>">
<cfset STC = "</span>">

<style type="text/css">
<!--
.style2 {
font-size: 14px;
font-weight: bold;
font-style: italic;
}
.style3 {
font-size: 14px;
font-weight: bold;
font-style: italic;
}
-->
</style>
<fieldset><legend>Donaciones Realizadas</legend>
<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="MEDDonacion a, MEDProyecto b"/>
		<cfinvokeargument name="cortes" value="Proyecto"/>
		<cfinvokeargument name="columnas" value="a.MEpersona, Proyecto = b.MEDnombre, Fecha = a.MEDfecha, Monto = a.MEDimporte, Moneda = a.MEDmoneda"/>
		<cfinvokeargument name="desplegar" value="Fecha, Moneda, Monto"/>
		<cfinvokeargument name="etiquetas" value="#STA#Fecha#STC#, #STA#Moneda#STC#, #STA#Monto#STC#"/>
		<cfinvokeargument name="formatos" value="D, S, M"/>
		<cfinvokeargument name="filtro" value="a.MEpersona = #Form.MEpersona#
												and a.MEDproyecto = b.MEDproyecto
												order by Proyecto asc, Fecha desc"/>
		<cfinvokeargument name="align" value="left, left, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="personas_consulta.cfm"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="maxrows" value="0"/>
		<cfinvokeargument name="formName" value="listaDonaciones"/>
</cfinvoke>

<cfif rsLista.RecordCount lte 0>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#CCCCCC">
	<td>&nbsp;</td>
	<td align="center"><span class="style2">No tiene ninguna donación registrada.</span></td>
	<td>&nbsp;</td>
  </tr>
</table>
</cfif>
</fieldset>