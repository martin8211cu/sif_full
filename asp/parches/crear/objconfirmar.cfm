<cf_templateheader title="Confirmar archivos">
<cfinclude template="mapa.cfm">
<h1>Confirmar tablas y procedimientos</h1>
<p>Revise y modifique la lista de archivos según sea necesario antes de continuar </p>
<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="tabla" returnvariable="collection" />
<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="procedimiento" returnvariable="col2" />

<cfparam name="url.so" default="asc">
<cfif Not ListFind('asc,desc',url.so)><cfset url.so = asc></cfif>
<cfparam name="url.sk" default="mapkey">
<cfif Not ListFind('mapkey,crdate,esquema', url.sk)><cfset url.sk = 'mapkey'></cfif>

<cfparam name="url.so2" default="asc">
<cfif Not ListFind('asc,desc',url.so2)><cfset url.so2 = asc></cfif>
<cfparam name="url.sk2" default="mapkey">
<cfif Not ListFind('mapkey,crdate,esquema', url.sk2)><cfset url.sk2 = 'mapkey'></cfif>

<cfoutput>
<script type="text/javascript">
var floatinmsg = {
<cfloop list="#ListSort(StructKeyList(collection), 'textnocase')#" index="item">
"# JSStringFormat( collection[item].mapkey)#": {#''
	#c: new Array(null <cfloop collection="#collection[item].columna#" item="columna"
		>,{n:'# JSStringFormat( collection[item].columna[columna].nombre )#',#''
		#t: '#  JSStringFormat( collection[item].columna[columna].tipo )#<cfif (collection[item].columna[columna].longitud)
				>(# JSStringFormat( collection[item].columna[columna].longitud )#)</cfif>',#''
		#u: '<cfif collection[item].columna[columna].nulos>S<cfelse>N</cfif>'}</cfloop>),
	i: new Array(null<cfloop collection="#collection[item].indice#" item="indice"
		>,{n: '# JSStringFormat( collection[item].indice[indice].nombre )#',#''
		#u:'<cfif collection[item].indice[indice].unico>S<cfelse>N</cfif>',#''
		#g:'<cfif collection[item].indice[indice].agrupado>S<cfelse>N</cfif>',#''
		#c:' <cfloop list="#ArrayToList (StructSort ( collection[item].indice[indice].columna, 'numeric', 'asc', 'posicion'))#" index="columna"
				>#collection[item].indice[indice].columna[columna].columna# </cfloop>'}</cfloop>)},</cfloop>
fin:1};
function showmsg(target,mapkey){
	var entry = floatinmsg[mapkey];
	var html =' ';
	html += '<div style=\'float:right\'><a href=\'javascript:hidemsg()\'>[&times;]</a></div>';
	html += '<strong>Tabla: '+mapkey+'</strong><br>';
	html += '<table width=345 align=center border=0 cellspacing=0 cellpadding=1>';
	html += '<tr class=\'tituloListas\'><td><strong>Columna</strong></td><td><strong>Tipo</strong></td><td><strong>Nulos</strong></td></tr>';
	for(var i=1;i<entry.c.length;i++){
	html += '<tr class=\'lista' +(i % 2 ? 'Par':'Non')+ '\'>';
	html += '<td>'+entry.c[i].n+'</td>';
	html += '<td nowrap>'+entry.c[i].t+'</td>';
	html += '<td>'+entry.c[i].u+'</tr>';
	}
	html += '</table><br>';
	html += '<table width=345 align=center border=0 cellspacing=0 cellpadding=1>';
	html += '<tr class=\'tituloListas\'><td><strong>&Iacute;ndice</strong></td><td><strong>U</strong></td><td><strong>C</strong></td><td><strong>Cols</strong></td></tr>';
	for(var i=1;i<entry.i.length;i++){
	html += '<tr class=\'lista' +(i % 2 ? 'Par':'Non')+ '\'>';
	html += '<td>'+entry.i[i].n+'</td>';
	html += '<td>'+entry.i[i].u+'</td>';
	html += '<td>'+entry.i[i].g+'</td>';
	html += '<td>'+entry.i[i].c+'</td></tr>';
	}
	html += '</table>';

	with(document.getElementById('floatinlayer')){
		innerHTML = html;
		style.top = document.body.scrollTop//mlm_top(target)-240 + "px";
		//style.left = (mlm_left(target)+320) + "px"; // mlm_left no sirve con A en IE6
		style.display='block';
	}
}
function hidemsg(){
	document.getElementById('floatinlayer').style.display='none';
}
</script>
<div class="tab_contents" id="floatinlayer" style="display:none;left:550px;width:350px;position:absolute;padding:7px">
</div>
<form id="form1" name="form1" method="post" action="objconfirmar-control.cfm"><table border="0" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" align="right"><input name="buscar" type="submit" id="buscar" value="Buscar más..." class="btnAnterior" />
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
<!--- Procedimientos --->
  <tr class="tituloListas">
    <th align="center">
	<cfset chkcount = ListLen(StructKeyList(col2)) >
	<input type="checkbox" checked="checked" onclick="for(i=1;i &lt;= #chkcount#; i++){ this.form['proc'+i].checked = this.checked };" /> </th>
    <th><a href="?sk2=#url.sk2#&amp;so2=#url.so2#&amp;sk=mapkey<cfif url.sk is 'mapkey' And url.so is 'asc'>&amp;so=desc</cfif>">Procedimiento</a></th>
    <th colspan="2"><a href="?sk2=#url.sk2#&amp;so2=#url.so2#&amp;sk=crdate<cfif url.sk is 'crdate' And url.so is 'asc'>&amp;so=desc</cfif>">Fecha de creación</a></th>
    <th><a href="?sk2=#url.sk2#&amp;so2=#url.so2#&amp;sk=esquema<cfif url.sk is 'esquema' And url.so is 'asc'>&amp;so=desc</cfif>">Esquema</a></th>
    </tr>
  <cfset n=0>
  <cfloop list="#ArrayToList(StructSort(col2,'textnocase',url.so,url.sk))#" index="mapkey">
  <cfset n=n+1>
  <tr class="lista<cfif n mod 2>Par<cfelse>Non</cfif>">
    <td valign="top" align="center">
      <input name="sel2" type="checkbox" value="# HTMLEditFormat(mapkey) #" checked="checked" id="proc#n#" />    </td>
    <td valign="top"><label for="proc#n#">#HTMLEditFormat( mapkey)#</label></td>
    <td valign="top" align="center">#DateFormat( col2[mapkey].crdate, 'yyyy-mmm-dd')#</td>
	<td valign="top" align="center">#TimeFormat( col2[mapkey].crdate,'HH:mm:ss')#</td>
    <td valign="top" align="center">#HTMLEditFormat( col2[mapkey].esquema)#</td>
    </tr></cfloop>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" align="right"><input name="buscar" type="submit" id="buscar" value="Buscar más..." class="btnAnterior" />
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
  <!--- Tablas --->
  <tr class="tituloListas">
    <th align="center">
	<cfset chkcount = ListLen(StructKeyList(collection)) >
	<input type="checkbox" checked="checked" onclick="for(i=1;i &lt;= #chkcount#; i++){ this.form['chk'+i].checked = this.checked };" /> </th>
    <th><a href="?sk=#url.sk#&amp;so=#url.so#&amp;sk2=mapkey<cfif url.sk2 is 'mapkey' And url.so2 is 'asc'>&amp;so2=desc</cfif>">Tabla</th>
    <th colspan="2"><a href="?sk=#url.sk#&amp;so=#url.so#&amp;sk2=crdate<cfif url.sk2 is 'crdate' And url.so2 is 'asc'>&amp;so2=desc</cfif>">Fecha de creación</th>
    <th><a href="?sk=#url.sk#&amp;so=#url.so#&amp;sk2=esquema<cfif url.sk2 is 'esquema' And url.so2 is 'asc'>&amp;so2=desc</cfif>">Esquema </th>
    </tr>
  <cfset n=0>
  <cfloop list="#ArrayToList(StructSort(collection,'textnocase',url.so2,url.sk2))#" index="mapkey">
  <cfset n=n+1>
  <tr class="lista<cfif n mod 2>Par<cfelse>Non</cfif>">
    <td valign="top" align="center">
      <input name="sel" type="checkbox" value="# HTMLEditFormat(mapkey) #" checked="checked" id="chk#n#" />    </td>
    <td valign="top">
	<a onmouseover="window.status='Haga clic para ver la definición de la tabla';return true;"
		onmouseout="window.status='';return true;"
		href="javascript:showmsg(this, &quot;# JSStringFormat( mapkey ) #&quot;)">#HTMLEditFormat( mapkey)#</a></td>
    <td valign="top" align="center">#DateFormat( collection[mapkey].crdate, 'yyyy-mmm-dd')#</td>
	<td valign="top" align="center">#TimeFormat( collection[mapkey].crdate,'HH:mm:ss')#</td>
    <td valign="top" align="center">#HTMLEditFormat( collection[mapkey].esquema)#</td>
    </tr></cfloop>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
<cfif ArrayLen(session.parche.errores)>
<tr>    <td>&nbsp;</td><td colspan="4">
	<cfinclude template="lista-errores.cfm"/></td></tr>
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" align="right"><input name="buscar" type="submit" id="buscar" value="Buscar más..." class="btnAnterior" />
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
</table>
</form></cfoutput>
<cf_templatefooter>
