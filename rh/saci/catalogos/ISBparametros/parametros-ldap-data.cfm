<cfparam name="url.correo" default="">
<cfparam name="url.atributo" default="">
<cfparam name="url.valor" default="">
<cfquery datasource="#session.dsn#" name="ISBparametrosLDAP">
	select linea, atributo, valor, correo
	from ISBparametrosLDAP
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by correo,upper(atributo),linea
</cfquery>
<cfoutput><div id="tablaDatos"><table width="748" border="0" cellpadding="2" cellspacing="0">
  <tbody>
  <tr>
    <td width="20">&nbsp;</td>
	<td width="144"><strong>Atributo</strong></td>
	<td width="265"><strong>Valor</strong></td>
	<td colspan="2"><strong>Requiere servicio de correo activo<em>[1]</em></strong><strong>&nbsp;</strong></td>
	</tr>
  <tr id="linea_nueva" >
    <td>&nbsp;</td>
	<td><input type="text" onclick="setLinea(0)" name="atributo" value="# HTMLEditFormat( url.atributo ) #" onfocus="this.select()" /></td>
	<td><input type="text" onclick="setLinea(0)" name="valor" value="# HTMLEditFormat( url.valor ) #" onfocus="this.select()" /></td>
	<td width="62"><select name="correo" onclick="setLinea(0)" >
	<option value="1" <cfif url.correo is 1>selected="selected"</cfif>>S</option>
	<option value="0" <cfif url.correo is 0>selected="selected"</cfif>>N</option></select></td>
	<td width="237"><input type="submit" name="btnAgregar" value="Agregar" /></td>
  </tr>
  <cfloop query="ISBparametrosLDAP">
  <tr id="linea#linea#a" style="cursor:pointer;height:26px;">
    <td onclick="setLinea(#linea#,1)" align="right" >#CurrentRow#&nbsp;&nbsp;</td>
	<td onclick="setLinea(#linea#,1)" ><div class="data" style="width:140px" ># HTMLEditFormat( atributo ) #</div></td>
	<td onclick="setLinea(#linea#,2)" ><div class="data" style="width:260px"  ># HTMLEditFormat( valor ) #</div></td>
	<td onclick="setLinea(#linea#,3)" ><div class="data" ><cfif correo >Sí<cfelse>No</cfif></div></td>
	<td class="data" ><a href="parametros-apply.cfm?ldap=1&amp;action=del&amp;linea=# linea #" target="myframe">Eliminar</a></td>
  </tr>
  <tr id="linea#linea#b" style="display:none;height:26px;">
    <td align="right">&raquo;&nbsp;&nbsp;</td>
	<td><input class="flatinp" type="text" name="atributo#linea#" style="width:140px" value="# HTMLEditFormat( atributo ) #" onfocus="this.select()" /></td>
	<td><input class="flatinp" type="text" name="valor#linea#"style="width:260px"  value="# HTMLEditFormat( valor ) #" onfocus="this.select()" /></td>
	<td><select class="flatinp" name="correo#linea#">
	<option value="1" <cfif correo is 1>selected="selected"</cfif>>S</option>
	<option value="0" <cfif correo is 0>selected="selected"</cfif>>N</option></select></td>
	<td><input type="submit" name="btnUpdate#linea#" value="Modificar" /></td>
  </tr>
  </cfloop></tbody>
</table>
</div>
</cfoutput>