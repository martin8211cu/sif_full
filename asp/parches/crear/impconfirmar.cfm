<h1>Confirmar importaciones</h1>
<p>Revise y modifique la lista de la importaciones según sea necesario antes de continuar </p>
<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="importar" returnvariable="imps" />

<cfparam name="url.so" default="asc">
<cfif Not ListFind('asc,desc',url.so)><cfset url.so = asc></cfif>
<cfparam name="url.sk" default="mapkey">
<cfif Not ListFind('mapkey,EImodulo,EIdescripcion', url.sk)><cfset url.sk = 'mapkey'></cfif>

<cfoutput>
<form id="form1" name="form1" method="post" action="impconfirmar-control.cfm"><table border="0" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" align="right"><input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
  <tr class="tituloListas">
    <th align="center">
	<cfset chkcount = ListLen(StructKeyList(imps)) >
	<input type="checkbox" checked="checked" onclick="for(i=1;i &lt;= #chkcount#; i++){ this.form['chk'+i].checked = this.checked };" /> </th>
    <th><a href="?sk=mapkey<cfif url.sk is 'mapkey' And url.so is 'asc'>&amp;so=desc</cfif>">Código</a></th>
    <th><a href="?sk=EImodulo<cfif url.sk is 'EImodulo' And url.so is 'asc'>&amp;so=desc</cfif>">Módulo</a></th>
    <th><a href="?sk=EIdescripcion<cfif url.sk is 'EIdescripcion' And url.so is 'asc'>&amp;so=desc</cfif>">Descripción</a></th>
    </tr>
  <cfset n=0>
  <cfloop list="#ArrayToList(StructSort(imps,'textnocase',url.so,url.sk))#" index="mapkey">
  <cfset n=n+1>
  <tr class="lista<cfif n mod 2>Par<cfelse>Non</cfif>">
    <td valign="top" align="center">
      <input name="sel" type="checkbox" value="# HTMLEditFormat(mapkey) #" checked="checked" id="chk#n#" />    </td>
    <td valign="top"><label for="chk#n#">#HTMLEditFormat( mapkey)#</label></td>
    <td valign="top" >#HTMLEditFormat( imps[mapkey].EImodulo)#</td>
    <td valign="top" >#HTMLEditFormat( imps[mapkey].EIdescripcion)#</td>
    </tr></cfloop>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
<cfif ArrayLen(session.parche.errores)>
<tr>    <td>&nbsp;</td><td colspan="4">
	<cfinclude template="lista-errores.cfm"/>
	</td></tr>
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" align="right"><input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
</table>
</form></cfoutput>
