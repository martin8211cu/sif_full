<cfif Len(session.menues.id_root) is 0>
	<cfset session.menues.id_root=0></cfif>
<cfquery datasource="asp" name="items" cachedwithin="#CreateTimeSpan(0,0,-10,0)#">
	select
			m.id_item as item, m.etiqueta_item as etiqueta, papa.id_padre as papa, r.profundidad, r.ruta as ruta,
			<!--- estos siguientes sirven para determinar si el menu es clicable o no --->
			m.SScodigo, m.SMcodigo, m.SPcodigo, m.id_pagina, m.url_item
	from SRelacionado r
			join SMenuItem m
				on m.id_item = r.id_hijo
			join SRelacionado papa
				on papa.id_hijo = m.id_item
				and papa.profundidad = 1
			join SRelacionado papx <!--- asegurarse de que papa sea hijo de session.menues.root --->
				on papx.id_hijo = papa.id_padre
				and papx.id_padre = #session.menues.id_root#
	where r.id_padre = #session.menues.id_root#
		and (m.SScodigo is null or m.SMcodigo is null or m.SPcodigo is null 
			or exists (select * from vUsuarioProcesos x
			where x.SScodigo = m.SScodigo
			  and x.SMcodigo = m.SMcodigo
			  and x.SPcodigo = m.SPcodigo
			  and x.Usucodigo = #session.Usucodigo#
			  and x.Ecodigo = #session.EcodigoSDC#) )
	order by r.profundidad desc, r.ruta
</cfquery>

<cfquery datasource="asp" name="shortcuts">
	select s.id_shortcut, 
		s.descripcion_shortcut, s.id_item,
		s.SScodigo, s.SMcodigo, s.SPcodigo, s.url_shortcut
	from SShortcut s
	where s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	order by s.id_item
</cfquery>

<cfquery name="rsEmpresas" datasource="asp">
	select distinct
		e.Ecodigo,
		e.Enombre,
		e.Ereferencia,
		c.Ccache, e.ts_rversion
		<!--- para manejar el cache de la imagen --->
	from vUsuarioProcesos up, Empresa e, Caches c
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and up.Ecodigo = e.Ecodigo
	  and c.Cid = e.Cid
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	order by upper( e.Enombre )
	</cfif>
</cfquery>


<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

/* mlm functions */
document.mlm_hide_array=new Array();
document.mlm_hide_td=new Array();
document.mlm_hide_timer = 0;
document.mlm_hide_millis = 0;
document.mlm_hide_delay = 1500;

function trace_this(s) {
	var ss = 'timer='+document.mlm_hide_timer+',millis='+document.mlm_hide_millis+',now='+new Date().getTime()+',s=' + s;
	window.status = ss;
	if (mysb = document.getElementById('mystatusbar'))
		mysb.innerHTML += '<br>'+ss;
}

function mlm_hide(nivel,forzar){  <!--- nivel=0..n --->
	//trace_this('hide('+nivel+','+forzar+')');
	if (forzar || document.mlm_hide_timer != 0 && document.mlm_hide_millis <= new Date().getTime()) {
		//trace_this('HIDING('+nivel+')');
		document.mlm_hide_timer=0;
		for (i = nivel; i < document.mlm_hide_array.length; i++) {
			mlm_layer_style(document.mlm_hide_array[i]).visibility = 'hidden';
			window.status = ',i=' + i;
		}
		for (i = nivel; i < document.mlm_hide_td   .length; i++) {
			document.mlm_hide_td[i].className = i ? 'mlm_item' : 'mlm_topitem';
		}
		document.mlm_hide_array.length = nivel;
		document.mlm_hide_td   .length = nivel;
	}
}
function mlm_layer_style(layerid){
	var the_layer = (!layerid) ? null :
		document.getElementById ? document.getElementById(layerid) :
		document.all  ? document.all[layerid] :
		document.layers ? document.layers[layerid] : null;
	return the_layer ? the_layer.style : null;
}
function mlm_top(x) { 
	return x ? x.offsetTop + mlm_top(x.offsetParent) : 0;
}
function mlm_left(x) { 
	var ll = 0;
	do ll += x.offsetLeft;
		while (x = x.offsetParent);
	return ll;
}
function mlm_over(menutd,nivel,layerid){
	//trace_this('mlm_over('+nivel+')');
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	mlm_hide(nivel,true);
	menutd.className = nivel ? 'mlm_sel' : 'mlm_topsel';
	document.mlm_hide_td   [nivel] = menutd;
}
function mlm_move(menutd,nivel){
	//trace_this('mlm_move('+nivel+')');
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	if (document.mlm_hide_timer) {
		window.clearTimeout(document.mlm_hide_timer);
		document.mlm_hide_timer = 0;
	}
}
function mlm_click(menutd,nivel,layerid){
	//trace_this('mlm_click('+nivel+')');
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	mlm_hide(nivel,true);
	menutd.className = nivel ? 'mlm_sel' : 'mlm_topsel';
	document.mlm_hide_td   [nivel] = menutd;
	if (layerst = mlm_layer_style(layerid)) {
		document.mlm_hide_array[nivel] = layerid;
		<!---
		var xx = menutd;
		var ss = new Array();
		var ll = 0;
		while (xx) {
			ss [ss.length] = xx.tagName + ' ' + xx.offsetLeft;
			ll += xx.offsetLeft;
			xx = xx.offsetParent;
		}
		alert(ss.join (' / ') + '; superLeft==' + mlm_left(menutd) + ', calc = ' + ll);
		--->
		if (nivel) { <!--- nivel 1..n == derecha --->
			layerst.left = (mlm_left(menutd) + menutd.offsetWidth) + 'px';
			layerst.top  = (mlm_top(menutd)) + 'px';
		} else { <!--- nivel 0 = debajo --->
			layerst.left = (mlm_left(menutd)) + 'px';
			layerst.top  = (mlm_top(menutd)  + menutd.offsetHeight) + 'px';
		}
		layerst.visibility = 'visible';
	}
}
function mlm_out(menutd,nivel,layerid){
	//trace_this('mlm_out('+nivel+')');
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	if (!document.mlm_hide_timer) {
		document.mlm_hide_timer=window.setTimeout('mlm_hide(0)',document.mlm_hide_delay);
	}
}
function add_shortcut(){
<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPcodigo)>
	var shortcut_text = prompt('¿Con qué nombre desea agregar esta opción a sus favoritos?','<cfoutput>#JSStringFormat(ubicacionSP.SPdescripcion)#</cfoutput>');
	if (shortcut_text) {
	<cfoutput>
		window.open('/cfmx/home/menu/portlets/shortcut_add.cfm?s=#URLEncodedFormat(ubicacionSS.SScodigo)
			#&m=#URLEncodedFormat(ubicacionSM.SMcodigo)
			#&p=#URLEncodedFormat(ubicacionSP.SPcodigo)
			#&t='+escape(shortcut_text),'menu_action');
	</cfoutput>
	}
<cfelse>
    alert('No disponible cuando se invoca el menú reducido');
</cfif>
}
//-->
</script>
<style type="text/css">
<!--
table.mlm_item {
	border:1px solid black;
}
.mlm_layer {
	x-background-color:skyblue;
	background-color:#999999;
}
.mlm_topitem  {
	font-family:Geneva, Arial, Helvetica, sans-serif;
	font-size: 12px;
	cursor:pointer;
	color:white;
	x-background-color:#003399;
	background-color:#999999;
	font-weight:bold;
}
.mlm_topsel  {
	font-family:Geneva, Arial, Helvetica, sans-serif;
	font-size: 12px;
	cursor:pointer;
	x-color:black;
	x-background-color:#0099FF;
	background-color:#666666;
	font-weight:bold;
	color:white;
}
.mlm_item, .mlm_item * {
	font-family:Geneva, Arial, Helvetica, sans-serif;
	font-size: 12px;
	cursor:pointer;
	x-color:black;
	x-font-weight:normal;
	x-background-color:skyblue;
	color:#666666;
	background-color:white;
	font-weight:bold;
}
.mlm_sel,.mlm_sel * {
	font-family:Geneva, Arial, Helvetica, sans-serif;
	font-size: 12px;
	cursor:pointer;
	x-color:black;
	x-font-weight:normal;
	x-background-color:#0099FF;
	background-color:#666666;
	font-weight:bold;
	color:white;
}
-->
</style>

<cfset submenues = ''>

<cfoutput query="items" group="papa">
	<cfif items.profundidad GT 1>
		<div id="Layer#items.papa#" class="mlm_layer" style="position:absolute; left:0px; top:0px; z-index:1;visibility:hidden;">
		<table border="0" cellspacing="0" cellpadding="0" class="mlm_item">
		<cfset subitem_count = 0>
		<cfoutput>
			<cfif Len(SScodigo) And Len(SMcodigo) And Len(SPcodigo)
					Or Len(id_pagina) Or Len(url_item)
					Or ListFind(submenues, items.item)>
				<tr>
				<td class="mlm_item"
					onMouseOver="mlm_click(this,#items.profundidad-1#,'Layer#items.item#')"
					onMouseOut="mlm_out(this,#items.profundidad-1#,'Layer#items.item#')"
					onMouseMove="mlm_move(this,#items.profundidad-1#)"
					<cfif Not ListFind(submenues, items.item)>
					onClick="location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#'"
					</cfif>  >
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr><td align="left" height="16">&nbsp;<cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">#HTMLEditFormat(items.etiqueta)#</cf_translateDB>&nbsp;</td>
							<td align="right" valign="bottom"><cfif ListFind(submenues, items.item)>
							<img src="/cfmx/home/menu/arrow_r.gif" align="bottom" width="7" height="7">&nbsp;
							</cfif></td></tr>
						</table>						
					</td>
				</tr>
				<cfset subitem_count = subitem_count + 1>
			</cfif>
		</cfoutput>
		<cfif subitem_count GT 0>
			<cfset submenues = ListAppend(submenues, items.papa)>
		</cfif>
		</table>
		</div>
	</cfif>
</cfoutput>


<div id="LayerFavoritos" style="position:absolute; left:731px; top:194px; z-index:1; visibility:hidden">
  <table border="0" cellspacing="0" cellpadding="0" class="mlm_item" id="mlm_TableFavoritos">
  
<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPcodigo)>
    <tr>
      <td class="mlm_item" onMouseOver="mlm_over(this,1)" 
	  	onMouseOut="mlm_out(this,1)" 
		onClick="add_shortcut()"
		onMouseMove="mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="agregar_favoritos" xmlFile="/home/menu/general.xml">Agregar a Favoritos</cf_translate>...&nbsp;&nbsp;</td>
    </tr>
</cfif>
    <tr>
      <td class="mlm_item" onMouseOver="mlm_over(this,1)" 
	  	onMouseOut="mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portlets/shortcut_edit.cfm'"
		onMouseMove="mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="organizar_favoritos" xmlFile="/home/menu/general.xml">Organizar mis Favoritos</cf_translate>&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td class="mlm_item" onMouseOver="mlm_over(this,1)" 
	  	onMouseOut="mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portlets/indicadores/personalizar.cfm'"
		onMouseMove="mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="personalizar_pagina" xmlFile="/home/menu/general.xml">Personalizar esta p&aacute;gina</cf_translate>&gt;&gt;&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td style="background-color:black"></td>
    </tr>
  <cfoutput query="shortcuts">
  
    <cfif Len(shortcuts.id_item) >
		<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;i=" & shortcuts.id_item >
	<cfelseif Len(shortcuts.SScodigo) And Len(shortcuts.SMcodigo) And Len(shortcuts.SPcodigo) >
		<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) & "&amp;m=" & URLEncodedFormat(shortcuts.SMcodigo) & "&amp;p=" & URLEncodedFormat(shortcuts.SPcodigo) >
	<cfelseif Len(shortcuts.SScodigo) And Len(shortcuts.SMcodigo) >
		<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) & "&amp;m=" & URLEncodedFormat(shortcuts.SMcodigo) >
	<cfelseif Len(shortcuts.SScodigo) >
		<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) >
	<cfelseif Len(shortcuts.url_shortcut) >
		<cfset shortcut_link = shortcuts.url_shortcut >
		<cfif mid(shortcut_link, 1, 1) EQ '/' And mid(shortcut_link, 1, 6) NEQ '/cfmx/'>
			<cfset shortcut_link = '/cfmx' & shortcut_link >
		</cfif>
	</cfif>
    <tr><!--- esta estructura debe estar igual en shortcut_add.cfm --->
      <td class="mlm_item" id="mlm_TdFavoritos_#shortcuts.id_shortcut#"
	    onMouseOver="mlm_over(this,1)" 
	  	onMouseOut="mlm_out(this,1)" 
		onClick="location.href='#shortcut_link#'"
		onMouseMove="mlm_move(this,1)">&nbsp;&nbsp; #HTMLEditFormat(shortcuts.descripcion_shortcut)#&nbsp;&nbsp;</td>
    </tr>
  </cfoutput>
  </table>
</div>

<div id="LayerEmp" style="position:absolute; left:731px; top:194px; z-index:1; visibility:hidden">
  <table border="0" cellspacing="0" cellpadding="0" class="mlm_item">
  
  <cfoutput query="rsEmpresas">
    <tr>
      <td class="mlm_item" onMouseOver="mlm_over(this,1,'Layer#items.item#')" 
	  	onMouseOut="mlm_out(this,1,'Layer#items.item#')" 
		onClick="location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#'"
		onMouseMove="mlm_move(this,1)"><cfif rsEmpresas.Ecodigo is session.EcodigoSDC><b>&gt;<cfelse>&nbsp;</cfif>
		#HTMLEditFormat(rsEmpresas.Enombre)#
		<cfif rsEmpresas.Ecodigo is session.EcodigoSDC>&lt;</b><cfelse>&nbsp;</cfif>
		</td>
    </tr>
  </cfoutput>
  <tr><td class="mlm_item" height="1" style="background-color:black"><img src="/cfmx/home/menu/blank.gif" width="1" height="1"></td></tr>
  <tr><td class="mlm_item" onMouseOver="mlm_over(this,1)" 
	  	onMouseOut="mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portal_rol.cfm'"
		onMouseMove="mlm_move(this,1)">&nbsp;<cf_translate key="seleccionar_rol" xmlFile="/home/menu/general.xml">Seleccionar Rol</cf_translate>&nbsp;</td></tr>
  </table>
</div>

<table width="980" border="0" cellpadding="0" cellspacing="0" class="mlm_topitem">
	
		<tr><td width="41">
				<table border="0" cellpadding="0" cellspacing="0"><tr height="16">
				    <td width="41" align="center" class="mlm_topitem"
						onmouseover="mlm_over(this,0)" 
						onmouseout="mlm_out(this,0)" 
						onmousemove="mlm_move(this,0)"
						onclick="location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;root=1'"
						><cf_translate key="inicio">Inicio</cf_translate></td>
				</tr></table>
			</td>
		    <td width="92">
				<table border="0" cellpadding="0" cellspacing="0"><tr height="16">
				    <td width="92" align="center" class="mlm_topitem"
						onclick="mlm_click(this,0,'LayerFavoritos')" 
						onmouseover="mlm_over(this,0,'LayerFavoritos')" 
						onmouseout="mlm_out(this,0,'LayerFavoritos')" 
						onmousemove="mlm_move(this,0)"
						nowrap="nowrap"
						>&nbsp;<cf_translate key="favoritos">Favoritos</cf_translate>&nbsp;<img src="/cfmx/home/menu/arrow_d.gif" width="7" height="7">&nbsp;</td>
				</tr></table>
			</td>
		    <td align="left" >
				<table border="0" cellpadding="0" cellspacing="0">
					<tr height="16">
						<cfoutput query="items">
						<cfif items.profundidad Is 1 And ListFind(submenues, items.item)>
						<td  align="center" class="mlm_topitem"
							onclick="mlm_click(this,0,'Layer#items.item#')" 
							onmouseover="mlm_over(this,0,'Layer#items.item#')" 
							onmouseout="mlm_out(this,0,'Layer#items.item#')" 
							onmousemove="mlm_move(this,0)">&nbsp;&nbsp;<cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">#HTMLEditFormat(items.etiqueta)#</cf_translateDB>&nbsp;
							<img src="/cfmx/home/menu/arrow_d.gif" width="7" height="7">&nbsp;
							</td>
						</cfif>
						</cfoutput>
					</tr>
				</table>
			</td>
		    <td align="right" >
				<table border="0" cellpadding="0" cellspacing="0">
					<tr height="16">
						<td align="center" class="mlm_topitem"
							onclick="mlm_click(this,0,'LayerEmp')" 
							onmouseover="mlm_over(this,0,'LayerEmp')" 
							onmouseout="mlm_out(this,0,'LayerEmp')" 
							onmousemove="mlm_move(this,0)" nowrap>&nbsp;<cf_translate key="compania">Compa&ntilde;&iacute;a</cf_translate>:&nbsp;<cfoutput>#HTMLEditFormat(session.Enombre)#</cfoutput>
								&nbsp;
							<img src="/cfmx/home/menu/arrow_d.gif" width="7" height="7">&nbsp;</td>
					</tr>
				</table>
			</td>
		    </tr>
	</table>
  <iframe width="1" height="1" id="menu_action" name="menu_action" frameborder="0" style="width:1px;height:1px;display:none;visibility:hidden"></iframe>
<!---
usado solamente para el javascript:trace_this()

<cfif session.sitio.ip is '10.7.7.30'>
<div onclick="this.innerHTML='cleared'" style="width:850px;height:450px;overflow:scroll;font-family:Arial, Helvetica, sans-serif;font-size:9pt" id="mystatusbar">
bitacora
</div>
</cfif>
---->