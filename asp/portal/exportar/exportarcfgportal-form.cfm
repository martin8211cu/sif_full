<!--- Consultas --->
<table width="45%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="6%" nowrap><div align="center"></div></td>
    <td width="94%" colspan="2" nowrap>&nbsp;</td>
  </tr>
  <form action="exportarcfgportal-apply.cfm" method="post" name="form1">
	  <tr>
		<td nowrap colspan="3" class="itemtit"><div align="center">&nbsp;Seleccione las opciones de exportación que desea realizar:</div></td>
	  </tr>
	  <tr>
		<td align="center" nowrap><input name="menues" type="checkbox" id="menues" value="1" checked></td>
		<td colspan="2" nowrap>Exportar Men&uacute;es</td>
	  </tr>
	  <tr>
		<td align="center" nowrap>&nbsp;</td>
		<td nowrap>
		<input name="menuesocultos" type="checkbox" id="menuesocultos" value="1">
		</td>
	    <td nowrap>Incluir Men&uacute;es Ocultos</td>
	  </tr>
	  <tr>
		<td align="center"><input name="paginas" type="checkbox" id="paginas" value="1" checked></td>
        <td colspan="2">Exportar P&aacute;ginas / Portlets</td>
      </tr>
	  <tr>
	    <td colspan="3">&nbsp;</td>
    </tr>
	  <tr>
	    <td colspan="3"><font color="#FF0000"><strong>Precauci&oacute;n:</strong></font> Recuerde que al exportar &uacute;nicamente los men&uacute;es debe asegurarse de que los procesos y las p&aacute;ginas a las cuales hace referencia deben existir</td>
	  </tr>
  	  <tr>
  	    <td nowrap colspan="3" class="itemtit">&nbsp;</td>
    </tr>
  	  <tr>
		<td nowrap colspan="3" class="itemtit"><div align="left">&nbsp;Seleccione el formato del archivo exportado:</div></td>
	  </tr>
	  <tr>
		<td align="center" nowrap><input type="radio" name="tipo" value="sql" checked></td>
		<td colspan="2" nowrap><a href="#" onClick="javascript:form1.tipo.checked=true">sql</a>
		para <cfparam name="url.dbms" default="#Left(Application.dsinfo.asp.type,3)#">
		<select name="dbms" id="dbms">
	      <option value="syb" <cfif url.dbms is 'syb'>selected</cfif>>Sybase</option>
	      <option value="ora" <cfif url.dbms is 'ora'>selected</cfif>>Oracle</option>
	      <option value="db2" <cfif url.dbms is 'db2'>selected</cfif>>DB2</option>
        </select>
		</td>
	  </tr>
	  <tr>
	    <td align="center" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><input type="checkbox" id="insertonly" name="insertonly"></td>
        <td valign="top" nowrap>
			Generar solamente inserts <br>
			Requiere que la base de datos destino est&eacute; vac&iacute;a.
		</td>
    </tr> 
	  <tr>
	    <td nowrap>&nbsp;</td>
	    <td colspan="2" nowrap>&nbsp;</td>
    </tr>
	  <tr>
	    <td nowrap>&nbsp;</td>
		<td colspan="2" nowrap>
		    <div align="center">
		     <input name="exportar" type="submit" id="exportar" value="Exportar">
	        </div>
		</td>
	  </tr>
  </form>
  <tr>
    <td nowrap></td>
    <td colspan="2" nowrap>&nbsp;</td>
  </tr>
</table>
