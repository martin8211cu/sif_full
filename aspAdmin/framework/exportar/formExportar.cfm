<!--- Consultas --->
<!--- 1. Sistemas --->
<cfquery name="sistemas" dataSource="sdc">
	select rtrim(sistema) as sistema, nombre
	from Sistema where activo = 1
	order by orden,nombre
</cfquery>

<!--- 2. Modulos --->
<cfquery name="modulos" dataSource="sdc">
	select rtrim(m.sistema) as sistema, rtrim(m.modulo) as modulo, m.nombre, s.nombre as nombre_sistema
	from Modulo m, Sistema s
	where m.activo = 1
	  and s.activo = 1
	  and s.sistema = m.sistema
	order by s.orden,s.nombre,m.orden,m.nombre
</cfquery>

<!--- JavaScripts --->
<script type="text/javascript">
function preparar(f) {
	if (f.tipo[0].checked || f.tipo[1].checked) {
		return true;
	} else {
		return false;
	}
}
</script>

<table width="45%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="6%" nowrap><div align="center"></div></td>
    <td width="94%" nowrap>&nbsp;</td>
  </tr>

  <form action="SQLExportar.cfm" method="post" name="form1">
	  <tr>
		<td nowrap colspan="2" class="itemtit"><div align="center">&nbsp;Seleccione el tipo de exportación que desea realizar:</div></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center">
		  <input name="rango" type="radio" value="t" checked>
	    </div></td>
		<td nowrap><a href="#" onClick="javascript:form1.rango[0].checked=true">Exportar todo</a></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center">
		  <input type="radio" name="rango" value="s">
	    </div></td>
		<td nowrap><a href="#" onClick="javascript:form1.rango[1].checked=true">Exportar un sistema espec&iacute;fico</a></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center"></div></td>
		<td nowrap>
			<select name="sistema" id="sistema" onChange="javascript:form1.rango[1].checked=true" onclick="javascript:form1.rango[1].checked=true">
				<cfoutput query="Sistemas">
					<option value="#sistema#">#sistema# - #nombre#</option>
				</cfoutput>
    	    </select>
		</td>
	  </tr>
	  <tr>
		<td nowrap><div align="center">
		  <input type="radio" name="rango" value="m">
	    </div></td>
		<td nowrap><a href="#" onClick="javascript:form1.rango[2].checked=true">Exportar un m&oacute;dulo espec&iacute;fico</a></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center"></div></td>
		<td nowrap>
			<select name="modulo" id="modulo" onChange="javascript:form1.rango[2].checked=true" onclick="javascript:form1.rango[2].checked=true">
				<cfset lsistema = "">
				<cfoutput query="modulos">
					<cfif lsistema neq sistema>
						<cfset lsistema = sistema>
					</cfif>
					<option value="#modulo#">#modulo# - #nombre#</option>
				</cfoutput>
			</select>
		</td>
	  </tr>

		<tr><td>&nbsp;</td></tr>
  	  <tr>
		<td nowrap colspan="2" class="itemtit"><div align="left">&nbsp;Seleccione el formato del archivo exportado:</div></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center">
		  <input name="tipo" type="radio" value="xml" checked>
	    </div></td>
		<td nowrap><a href="#" onClick="javascript:form1.tipo[0].checked=true">xml</a></td>
	  </tr>
	  <tr>
		<td nowrap><div align="center">
		  <input type="radio" name="tipo" value="sql">
	    </div></td>
		<td nowrap><a href="#" onClick="javascript:form1.tipo[1].checked=true">sql</a></td>
	  </tr>
	  <tr>
	    <td nowrap>&nbsp;</td>
		<td nowrap>
		    <div align="center">
		     <input name="exportar" type="submit" id="exportar" value="Exportar">
	        </div>
		</td>
	  </tr>
  </form>
  <tr>
    <td nowrap><div align="center"></div></td>
    <td nowrap>&nbsp;</td>
  </tr>
</table>