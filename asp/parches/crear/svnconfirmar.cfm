<cf_templateheader title="Confirmar archivos">
<cfinclude template="mapa.cfm">
<h1>Confirmar archivos</h1>
<p>Revise y modifique la lista de archivos según sea necesario antes de continuar </p>

<cfparam name="url.so" default="asc">
<cfif Not ListFind('asc,desc',url.so)><cfset url.so = asc></cfif>
<cfparam name="url.sk" default="nombre">
<cfif Not ListFind('nombre,fecha,autor,revision', url.sk)><cfset url.sk = 'nombre'></cfif>

<cfquery datasource="asp" name="items">
	select f.nombre, f.fecha, f.autor, f.revision, f.msg,
		f2.parche as parche2, p2.nombre as nombre_parche2, f2.revision as revision2
	from APFuente f
		left join APFuente f2
			on f2.nombre = f.nombre
			  and f2.parche != f.parche
			  and f2.revision >= f.revision
		left join APParche p2
			on p2.parche = f2.parche
	where f.parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
	order by f.#url.sk#
</cfquery>

<script type="text/javascript">
document.rev_msg = {
<cfset revs = StructNew()>
<cfoutput query="items">
<cfif Not StructKeyExists(revs, Revision)>
<cfset StructInsert(revs, Revision, 1)>
M#Revision#: "# JSStringFormat ( Replace( Msg, Chr(10), '<br>','all')) #",
</cfif>
</cfoutput>
fin:1};
document.dup_msg = {
<cfoutput query="items" group="nombre">
<cfoutput><cfif Len (parche2)>
M#CurrentRow#: "<cfoutput><br># JSStringFormat(nombre_parche2)#<cfif revision2 neq revision> (Rev. #JSStringFormat(revision2)#)</cfif></cfoutput>",
</cfif>
</cfoutput>
</cfoutput>
fin:1};
document.rev_prefix = '<strong>Revisi&oacute;n número msgnum</strong><br>';
document.rev_suffix = '<br><br><em> Haga clic en el número de versi&oacute;n para ver m&aacute;s detalles </em><br>';
document.dup_prefix = '<strong>Este archivo ya se incluye en el parche:</strong>';
document.dup_suffix = '';

function showmsg(msgtype,target,msgnum){
	var msgtext = document[msgtype + '_msg']['M' + msgnum];
	if(!msgtext)return;
	msgtext = document[msgtype + '_prefix']+msgtext+document[msgtype + '_suffix'];
	msgtext = msgtext.replace(/msgnum/g, msgnum);
	with(document.getElementById('floatinlayer')){
		innerHTML = msgtext;
		style.top = document.body.scrollTop;//mlm_top(target) + "px";
		style.left = document.body.scrollLeft;//mlm_left(target) - 320 + "px";
		style.display='block';
	}
}
function hidemsg(){
	document.getElementById('floatinlayer').style.display='none';
}
function selectall(bool){
	var f = document.form1;
	for(i=1;i <= <cfoutput>#items.RecordCount#</cfoutput>; i++){
		if (f['chk'+i])
			f['chk'+i].checked = bool;
	};
}
function selnodup(){
	var f=document.form1;
	for(i=1;i <= <cfoutput>#items.RecordCount#</cfoutput>; i++){
		if (f['chk'+i])
			f['chk'+i].checked = !document.dup_msg['M'+i];
	};
}
</script>
<div class="ayuda" id="floatinlayer" style="display:none;left:550px;width:300px;position:absolute;padding:7px">
</div>
<form style="width:700px; height:100%; overflow: auto; " id="form1" name="form1" method="post" action="svnconfirmar-control.cfm">
<table border="0" cellspacing="0" cellpadding="2" width="200">
  <tr>
    <td colspan="3">Seleccionar: <a href="javascript:selectall(true)" style="text-decoration:underline">Todo</a> |
	<a href="javascript:selectall(false)" style="text-decoration:underline">Nada</a> |
	<a href="javascript:selnodup()" style="text-decoration:underline">Sin repetir</a> </td>
    
    <td colspan="5" align="right" nowrap="nowrap"><input name="buscar" type="submit" id="buscar" value="Buscar más..." class="btnAnterior" />
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
	<cfoutput>
  <tr class="tituloListas">
    <th>&nbsp;</th><th align="center">&nbsp;</th>
    <th><a href="?sk=nombre<cfif url.sk is 'nombre' And url.so is 'asc'>&amp;so=desc</cfif>">Nombre</a></th>
    <th colspan="2"><a href="?sk=fecha<cfif url.sk is 'fecha' And url.so is 'asc'>&amp;so=desc</cfif>">Fecha</a></th>
    <th><a href="?sk=autor<cfif url.sk is 'autor' And url.so is 'asc'>&amp;so=desc</cfif>">Modificado por</a></th>
    <th><a href="?sk=revision<cfif url.sk is 'revision' And url.so is 'asc'>&amp;so=desc</cfif>"> Revisión</a></th>
    <th>Obs</th>
  </tr>
	</cfoutput>
  <cfoutput query="items" group="nombre">
  <tr class="lista<cfif CurrentRow mod 2>Par<cfelse>Non</cfif>">
  <td align="right" valign="top">#CurrentRow#.</td>
    <td valign="top" align="center">
      <input name="sel" type="checkbox" value="# HTMLEditFormat(nombre) #" checked="checked" id="chk#CurrentRow#" />    </td>
    <td valign="top" style="white-space:normal"><label for="chk#CurrentRow#">#HTMLEditFormat( Replace( nombre, '/', '/ ', 'all') )#</label></td>
    <td valign="top" nowrap="nowrap" align="center">
		<cfif DatePart('yyyy', Now()) NEQ DatePart('yyyy', fecha)>
	#DateFormat( fecha, 'yyyy-mmm-dd')#
		<cfelse>
	#DateFormat( fecha, 'mmm-dd')#
		</cfif></td>
	<td valign="top" align="center" nowrap="nowrap">#TimeFormat( fecha,'HH:mm')#</td>
    <td valign="top" align="center">#HTMLEditFormat( autor)#</td>
    <td valign="top" align="center"
		onmouseout="hidemsg()" style="cursor:pointer" onmouseover="showmsg('rev', this, #Revision#)" >
	<a href="http://desarrollo/viewcvs?root=coldfusion&rev=#Revision#&view=rev" target="_blank">
	#HTMLEditFormat( revision)#</a></td>
    <td valign="top" align="center"
		onmouseout="hidemsg()" style="cursor:pointer" onmouseover="showmsg('dup', this, #CurrentRow#)" > 
	<cfif Len (parche2)>
	<img src="../images/info16.png" width="16" height="16" border="0" />
	 </cfif>
		&nbsp;</td>
  </tr></cfoutput>
  <tr>
    <td colspan="8">&nbsp;</td>
  </tr>
<cfif ArrayLen(session.parche.errores)>
<tr>    <td>&nbsp;</td><td colspan="8">
	<cfinclude template="lista-errores.cfm"/></td></tr>
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td colspan="7" align="right"><input name="buscar" type="submit" id="buscar" value="Buscar más..." class="btnAnterior" />
      <input name="actualizar" type="submit" id="actualizar" value="Actualizar" class="btnAplicar"  />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
</table>
<BR /><BR />
</form>
<cf_templatefooter>
