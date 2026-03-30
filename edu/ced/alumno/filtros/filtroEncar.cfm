<!--- <cfform action="../inicioAgregaEncar.cfm" name="filtroEncar" > --->
<form action="" name="filtroEncar" method="post" >
	<input type="hidden" id="personaAl" name="personaAl" value="<cfoutput>#form.personaAl#</cfoutput>">
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td width="14%" class="subTitulo">Nombre </td>
      <td width="29%" class="subTitulo"><input name="fEncarNombre" type="text" id="fEncarNombre" size="50" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fEncarNombre") AND #Form.fEncarNombre# NEQ "" ><cfoutput>#Form.fEncarNombre#</cfoutput></cfif>"></td>
      <td width="57%" rowspan="2" align="center" valign="middle"><input name="btnBuscarEncar" type="submit" id="btnBuscarEncar" value="Buscar" ></td>
    </tr>
    <tr> 
      <td class="subTitulo">Identificaci&oacute;n</td>
      <td class="subTitulo"><input name="filtroEncarPid" type="text" size="25" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.filtroEncarPid") AND #Form.filtroEncarPid# NEQ "" ><cfoutput>#Form.filtroEncarPid#</cfoutput></cfif>"></td>
    </tr>
  </table>
</form>
