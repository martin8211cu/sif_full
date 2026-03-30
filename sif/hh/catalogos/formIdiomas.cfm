<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>
<cfif modo neq "ALTA">
  <cfquery name="rsLinea" datasource="sifcontrol">
  select * from Idiomas where Iid = 
  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
  </cfquery>
</cfif>
 
<form method="post" name="form1" action="SQLIdiomas.cfm">
  <table width="364" align="center">
    <tr valign="baseline"> 
      <td width="75" align="right" nowrap>Código:</td>
      <td width="480"><input name="Icodigo" type="text" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Icodigo#</cfoutput></cfif>" size="20" maxlength="20"></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Descripción:</td>
      <td><input name="Descripcion" type="text" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Descripcion#</cfoutput></cfif>" size="40" maxlength="80"></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Locale:</td>
      <td><input name="Inombreloc" type="text" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Inombreloc#</cfoutput></cfif>" size="40" maxlength="80"></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><div align="center"><cfinclude template="../../portlets/pBotones.cfm"></div></td>
    </tr>
  </table>
  <input type="hidden" name="Iid" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Iid#</cfoutput></cfif>">
</form>
<p>&nbsp;</p>
  