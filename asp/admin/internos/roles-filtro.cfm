<cfquery datasource="asp" name="roles">
	select 	{fn concat({fn concat(rtrim(SScodigo) ,'.')}, rtrim(SRcodigo))} as codigo, <!--- rtrim(SScodigo)||'.'||rtrim(SRcodigo) as codigo, --->
			rtrim(SScodigo) as SScodigo, 
			rtrim(SRcodigo) as SRcodigo, 
			SRdescripcion
	from SRoles
	where SRinterno = 1
	order by SScodigo, SRcodigo
</cfquery>
<cfoutput>
<form action="roles.cfm" method="get" name="filtro" id="filtro"><table border="0" cellspacing="2" cellpadding="2" bgcolor="##ededed" style="border:1px solid black ">
  <tr>
    <td colspan="3">Criterio de despliegue </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp; </td>
    <td>Rol</td>
    <td colspan="5">
      <select name="fRol" id="fRol">
        <option value="" <cfif Len(url.fRol) is 0>selected</cfif>>-Todos-</option>
		<cfloop query="roles">
        <option value="#roles.codigo#" <cfif roles.codigo EQ url.fRol>selected</cfif>>#roles.SScodigo#.#roles.SRcodigo# - #roles.SRdescripcion#</option>
		</cfloop>
      </select> </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Usuario (login) </td>
    <td><input type="text" name="fUid" value="#HTMLEditFormat(Trim(url.fUid))#" onFocus="this.select()" size="20" maxlength="30"></td>
    <td>Usuario (nombre)</td>
    <td><input type="text" name="fNom" value="#HTMLEditFormat(Trim(url.fNom))#" onFocus="this.select()" size="20" maxlength="30"></td>
    <td>Empresa</td>
    <td><input type="text" name="fEmp" value="#HTMLEditFormat(Trim(url.fEmp))#" onFocus="this.select()" size="20" maxlength="30"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="6" align="center">          <input type="submit" name="Submit" value="Filtrar">          </td>
    </tr>
</table>
</form>
</cfoutput>


