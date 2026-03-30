<cfquery name="rsLista" datasource="#Session.dsn#">
	select 1
	from MEPersona a, MERelacionFamiliar b, MEParentesco c
	where a.MEpersona = b.MEpersona2
	and a.activo = 1
	and b.MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona#">
	and b.MEPid = c.MEPid
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
<fieldset><legend>Familiares</legend>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="MEPersona a, MERelacionFamiliar b, MEParentesco c"/>
		<cfinvokeargument name="columnas" value="a.MEpersona, Nombre = Pnombre + ' ' + Papellido1 + ' ' + Papellido2, Parentesco = MEPnombre"/>
		<cfinvokeargument name="desplegar" value="Nombre, Parentesco"/>
		<cfinvokeargument name="etiquetas" value="#STA#Nombre#STC#, #STA#Parentesco#STC#"/>
		<cfinvokeargument name="formatos" value="S, S"/>
		<cfinvokeargument name="filtro" value="a.MEpersona = b.MEpersona2
												and a.activo = 1
												and b.MEpersona1 = #Form.MEpersona#
												and b.MEPid = c.MEPid
												order by Nombre, Parentesco"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="personas_consulta.cfm"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="maxrows" value="0"/>
		<cfinvokeargument name="formName" value="listaFamiliares"/>
</cfinvoke>

<cfif rsLista.RecordCount lte 0>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#CCCCCC">
	<td>&nbsp;</td>
	<td align="center"><span class="style2">No tiene ningún famliar registrado.</span></td>
	<td>&nbsp;</td>
  </tr>
</table>
</cfif>
</fieldset>