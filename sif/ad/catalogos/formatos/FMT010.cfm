
<cfparam name="url.FMT00COD" type="numeric" >
<cfparam name="url.FMT10LIN" default="">


<cfquery datasource="sifcontrol" name="data">
	select FMT00COD,FMT10LIN,FMT10PAR,FMT10DEF,FMT10TIP,FMT10LON
	from FMT010
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
	  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT10LIN#" null="#Len(url.FMT10LIN) is 0#">
</cfquery>
<cfquery datasource="sifcontrol" name="nextval">
	select coalesce(max(FMT10LIN),0)+1 as nextval
	from FMT010
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
</cfquery>

<cfoutput>

<form action="FMT010-sql.cfm" method="post" name="form2">
<input type="hidden" name="FMT00COD" value="#HTMLEditFormat(url.FMT00COD)#">
  <table  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td colspan="3" class="subTitulo">Par&aacute;metros para la consulta </td>
      </tr>
    <tr>
      <td colspan="2"><strong>N&uacute;mero</strong></td>
      <td width="15">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><input type="text" value="<cfif Len(data.FMT10LIN)>#HTMLEditFormat(data.FMT10LIN)#<cfelse>#nextval.nextval#</cfif>" name="FMT10LIN" onFocus="this.select()"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><strong>Tipo</strong></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><select name="FMT10TIP">
          <option value="0" <cfif data.FMT10TIP is 0>selected</cfif>>texto</option>
          <option value="1" <cfif data.FMT10TIP is 1>selected</cfif>>n&uacute;mero</option>
          <option value="2" <cfif data.FMT10TIP is 2>selected</cfif>>fecha</option>
            </select></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><strong>Longitud</strong></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><input type="text" value="#HTMLEditFormat(data.FMT10LON)#" name="FMT10LON" onBlur="this.value=isNaN(this.value)?10:parseInt(this.value,10)" onFocus="this.select()"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><strong>Nombre</strong></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><input type="text" value="#HTMLEditFormat(data.FMT10PAR)#" name="FMT10PAR" onFocus="this.select()"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><strong>Valor default </strong></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><input type="text" value="#HTMLEditFormat(data.FMT10DEF)#" name="FMT10DEF" onFocus="this.select()"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td width="12">&nbsp;</td>
      <td width="191">
	  <cfif Len(data.FMT10LIN)>
	  <input type="submit" name="btnGuardar" value="Guardar">
	  <input type="submit" name="btnEliminar" value="Eliminar">
	  <input type="button" name="btnNuevo" value="Nuevo" onClick="location.href='FMT000.cfm?FMT00COD=#URLEncodedFormat(url.FMT00COD)#'">
	  <cfelse>
	  <input type="submit" name="btnGuardar" value="Agregar">
	  <input type="submit" name="btnAutomatico" value="Llenado autom&aacute;tico">
	  </cfif></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>

</cfoutput>