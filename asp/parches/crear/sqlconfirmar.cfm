<!---<cf_templateheader title="Confirmar archivos">
<cfinclude template="mapa.cfm">--->
<h1>Confirmar archivos SQL</h1>
<p>Revise y modifique la lista de la archivos SQL según sea necesario antes de continuar </p>

<cfparam name="url.so" default="asc">
<cfif Not ListFind('asc,desc',url.so)><cfset url.so = asc></cfif>
<cfparam name="url.sk" default="mapkey">
<cfif Not ListFind('dbms,esquema,secuencia,nombre,longitud', url.sk)><cfset url.sk = 'secuencia'></cfif>

<cfquery datasource="asp" name="items">
	select archivo, nombre, dbms, esquema, longitud, secuencia
	from APParcheSQL
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
	order by #url.sk#
</cfquery>

<script type="text/javascript">
<!--
function selectall(bool){
	var f = document.form2;
	document.bool = bool;
	for(i=1;i <= <cfoutput>#items.RecordCount#</cfoutput>; i++){
		if (f['chk'+i])
			f['chk'+i].checked = bool;
	};
}
function selfwk(bool){
	var f=document.form2;
	document.bool = bool;
	for(i=1;i <= <cfoutput>#items.RecordCount#</cfoutput>; i++){
		if (f['chk'+i] && f['chk'+i].value.match(/framework-.*.sql/))
			f['chk'+i].checked = bool;
	};
}
//-->
</script>

<cfoutput>
<form id="form2" name="form2" method="post" action="sqlconfirmar-control.cfm"><table border="0" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td colspan="5">Seleccionar: <a href="javascript:selectall(true)" style="text-decoration:underline">Todo</a> |
	  <a href="javascript:selectall(false)" style="text-decoration:underline">Nada</a> |
	  <a href="javascript:selfwk(!document.bool)" style="text-decoration:underline">Seguridad</a> </td>
    <td colspan="2" align="right">
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
  <tr class="tituloListas">
    <th align="center">&nbsp;</th>
    <th colspan="2"><cfif url.sk eq "secuencia">&nbsp;<cfelse><a href="?sk=secuencia<cfif url.sk is 'secuencia' And url.so is 'asc'>&amp;so=desc</cfif>">Sec</a></cfif></th>
    <th><a href="?sk=dbms<cfif url.sk is 'dbms' And url.so is 'asc'>&amp;so=desc</cfif>">DBMS</a></th>
    <th><a href="?sk=esquema<cfif url.sk is 'esquema' And url.so is 'asc'>&amp;so=desc</cfif>">Esquema</a></th>
    <th><a href="?sk=nombre<cfif url.sk is 'nombre' And url.so is 'asc'>&amp;so=desc</cfif>">Archivo</a></th>
    <th><a href="?sk=longitud<cfif url.sk is 'longitud' And url.so is 'asc'>&amp;so=desc</cfif>">Tama&ntilde;o</a></th>
  </tr>
  <cfloop query="items">
  <tr class="lista<cfif CurrentRow mod 2>Par<cfelse>Non</cfif>">
    <td valign="top" align="center">
      <input name="sel" type="checkbox" value="# HTMLEditFormat(dbms & '/' & esquema & '/' & nombre) #" checked="checked" id="chk#CurrentRow#" />
	  </td>
    <td valign="top" align="right">
	<cfif CurrentRow GT 1 and url.sk eq "secuencia">
	<a href="sqlconfirmar-control.cfm?archivo=# URLEncodedFormat(archivo) #&amp;sec=#CurrentRow-1#">&uarr;</a>
	<cfelseif url.sk neq "secuencia"># secuencia #
	</cfif></td>
    <td valign="top" align="left">
	<cfif CurrentRow LT RecordCount and url.sk eq "secuencia">
	<a href="sqlconfirmar-control.cfm?archivo=# URLEncodedFormat(archivo) #&amp;sec=#CurrentRow+1#">&darr;</a>
	<cfelse>&nbsp;
	</cfif></td>
    <td valign="top" align="center"><label for="chk#CurrentRow#">#HTMLEditFormat( dbms)#</label></td>
    <td valign="top" align="center"><label for="chk#CurrentRow#">#HTMLEditFormat( esquema)#</label></td>
    <td valign="top" align="center"><label for="chk#CurrentRow#">#HTMLEditFormat( nombre)#</label></td>
    <td valign="top" align="right"><label for="chk#CurrentRow#">#HTMLEditFormat(NumberFormat( longitud))#</label></td>
  </tr></cfloop>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<cfif ArrayLen(session.parche.errores)>
<tr>    <td>&nbsp;</td><td colspan="6">
	<cfinclude template="lista-errores.cfm"/></td></tr>
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td colspan="6" align="right">
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
</table>
</form></cfoutput>
<!---
<cf_templatefooter>
--->