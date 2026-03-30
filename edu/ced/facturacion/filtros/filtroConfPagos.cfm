<cfform action="" name="" >
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td width="5%" >Nombre </td>
      <td width="48%" ><input name="fRHnombre" type="text" id="fRHnombre" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fRHnombre") AND #Form.fRHnombre# NEQ "" ><cfoutput>#Form.fRHnombre#</cfoutput></cfif>"></td>
      <td width="8%" >Identificaci&oacute;n </td>
      <td width="15%" ><input name="filtroRhPid" type="text" size="25" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.filtroRhPid") AND #Form.filtroRhPid# NEQ "" ><cfoutput>#Form.filtroRhPid#</cfoutput></cfif>"></td>
      <td align="center" > <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" ></td>
    </tr>
  </table>
</cfform>
