<!---
	acordarme de poner el cache otra vez (session.menu_cache.content.content = '')
	tamaño antes del cambio por javascripts:
		294.51 KB (301,581 bytes)
	tamaño sin opciones de menu: (cota inferior)
		62.84 KB (64,345 bytes)
	poniendo js:
		139.73 KB (143,081 bytes)
	final:
		129.05 KB (132,143 bytes)
	nocache:
		<cfset session.menu_cache.content.content = ''>
	La variable Request.mlm_part1 se debe establecer si se desea
	poner el menu una parte al inicio y otra al final
--->
<cfparam name="session.menu_cache" default="#StructNew()#">
<cfparam name="session.menu_cache.time" default="">
<cfparam name="session.menu_cache.args" default="">
<cfparam name="session.menu_cache.content" default="#StructNew()#">
<cfparam name="session.menu_cache.content.content" default="">
<!---
	se establece un cache de 900 segundos para esta pantalla
	debido a que la generacion del menu es muy lenta.
--->
<cfparam name="session.menues.id_root" default="0">
<cfif Len(session.menues.id_root) is 0>
	<cfset session.menues.id_root=0></cfif>
<cfset menu_cache_args = session.menues.id_root & ',' & session.EcodigoSDC>
<cfif (session.menu_cache.args NEQ menu_cache_args) OR
      (Len(session.menu_cache.content.content) EQ 0) OR
      (Len(session.menu_cache.time) EQ 0) OR
      (DateDiff("s", session.menu_cache.time, Now()) GT 900)>
<cfquery datasource="asp" name="items" cachedwithin="#CreateTimeSpan(0,0,15,0)#">
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
	order by s.descripcion_shortcut, s.id_item
</cfquery>
<cfquery name="rsEmpresas" datasource="asp">
	select distinct
		e.Ecodigo,
		e.Enombre,
		e.Ereferencia,
		upper( e.Enombre ) as Enombre_upper,
		c.Ccache, e.ts_rversion
		<!--- para manejar el cache de la imagen --->
	from vUsuarioProcesos up, Empresa e, Caches c
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and up.Ecodigo = e.Ecodigo
	  and c.Cid = e.Cid
	  and (e.Eactiva = 1 or e.Ecodigo = 1)<!--- Ecodigo = 1 por si las moscas --->
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	order by e.Enombre
	</cfif>
</cfquery>
<cfsavecontent variable="session.menu_cache.content.content2">
<script language="JavaScript" type="text/JavaScript" defer="defer">
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
document.mlm_hide_id=new Array();
document.mlm_hide_timer = 0;
document.mlm_hide_millis = 0;
document.mlm_hide_delay = 1500;
<!---
function trace_this(s) {
	var ss = 'timer='+document.mlm_hide_timer+',millis='+document.mlm_hide_millis+',now='+new Date().getTime()+',s=' + s;
	window.status = ss;
	if (mysb = document.getElementById('mystatusbar'))
		mysb.innerHTML += '<br>'+ss;
}
--->
function mlm_hide(nivel,forzar){  <!--- nivel=0..n --->
	<!---trace_this('hide('+nivel+','+forzar+')');--->
	if (forzar || document.mlm_hide_timer != 0 && document.mlm_hide_millis <= new Date().getTime()) {
		<!---trace_this('HIDING('+nivel+')');--->
		document.mlm_hide_timer=0;
		for (i = nivel; i < document.mlm_hide_array.length; i++) {
			if ( mlm_layer_style(document.mlm_hide_array[i]) ) {
				mlm_layer_style(document.mlm_hide_array[i]).visibility = 'hidden';
				mlm_hide_elems(document.mlm_hide_array[i],+1);
				<!---window.status = ',i=' + i;--->
			} else {
				/* alert( " no hay para i = " + i + ", " + document.mlm_hide_array[i] ) ; */
			}
		}
		for (i = nivel; i < document.mlm_hide_td   .length; i++) {
			if (document.mlm_hide_td[i]) {
				document.mlm_hide_td[i].className = i ? 'mlm_item' : 'mlm_topitem';
			}
		}
		document.mlm_hide_array.length = nivel;
		document.mlm_hide_td   .length = nivel;
	}
}
function mlm_layer_obj(layerid){
	return (!layerid) ? null :
		document.getElementById ? document.getElementById(layerid) :
		document.all  ? document.all[layerid] :
		document.layers ? document.layers[layerid] : null;
}
function mlm_layer_style(layerid){
	var the_layer = mlm_layer_obj(layerid);
	return the_layer ? the_layer.style : null;
}
function mlm_top(x) { 
	//return x ? x.offsetTop + mlm_top(x.offsetParent) : 0;
	var ll = 0;
	do { ll += x.offsetTop;
	} while (x = x.offsetParent);
	return ll;
}
function mlm_left(x) { 
	var ll = 0;
	do { ll += x.offsetLeft;
	} while (x = x.offsetParent);
	return ll;
}
function mlm_over(menutd,nivel,layerid){
	<!---trace_this('mlm_over('+nivel+')');--->
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	mlm_hide(nivel,true);
	menutd.className = nivel ? 'mlm_sel' : 'mlm_topsel';
	document.mlm_hide_td   [nivel] = menutd;
}
function mlm_move(menutd,nivel){
	<!---trace_this('mlm_move('+nivel+')');--->
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	if (document.mlm_hide_timer) {
		window.clearTimeout(document.mlm_hide_timer);
		document.mlm_hide_timer = 0;
	}
}
function mlm_show(menutd,nivel,layerid,itemid){
	<!---
		Muestra el submenu especificado
		menutd:  td sobre el que hice clic para abrir el submenu
		nivel:   nivel del menu que se va a mostrar
		layerid: layerid del hijo por abrir
		itemid:  id_item (id_padre) del contenido que se debe mostrar
	--->
	<!---trace_this('mlm_show('+nivel+')');--->
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	mlm_hide(nivel,true);
	menutd.className = nivel ? 'mlm_sel' : 'mlm_topsel';
	document.mlm_hide_td   [nivel] = menutd;
	document.mlm_hide_id   [nivel] = itemid;
	if (layerst = mlm_layer_style(layerid)) {
		document.mlm_hide_array[nivel] = layerid;
		if(itemid) {
			<!--- primero voy a llenar el contenido de los submenues dentro del [layerid] --->
			var info = document['mlm_info'+itemid];
			if (info) {
				for(var infoindex = 1; ; infoindex++) {
					var menurow = mlm_menurow(nivel+1, infoindex);
					if(menurow){
						if (infoindex < info.length) {
							var infochild = document['mlm_info' + (info[infoindex].item) ];
							menurow.trobj.style.display = '';
							menurow.spanobj.innerHTML = info[infoindex].etiqueta;
							menurow.arrowobj.style.visibility = infochild ? 'inherit' : 'hidden';
						} else {
							menurow.trobj.style.display = 'none';
						}
					} else {
						break;
					}
				}
			}
			
			if(info||(itemid==true)){
				if (nivel) { <!--- nivel 1..n == derecha --->
					layerst.left = (mlm_left(menutd) + menutd.offsetWidth) + 'px';
					layerst.top  = (mlm_top(menutd)) + 'px';
				} else { <!--- nivel 0 = debajo --->
					layerst.left = (mlm_left(menutd)) + 'px';
					layerst.top  = (mlm_top(menutd)  + menutd.offsetHeight) + 'px';
				}
				mlm_hide_elems(layerid,-1);
				layerst.visibility = 'visible';
				layerst.zIndex = ""+(nivel+6);<!--- asegurarse de que los submenues tapen los menues anteriores --->
			}
		}
	}
}
function mlm_out(menutd,nivel,layerid){
	<!---trace_this('mlm_out('+nivel+')');--->
	document.mlm_hide_millis = new Date().getTime() + document.mlm_hide_delay;
	if (!document.mlm_hide_timer) {
		document.mlm_hide_timer=window.setTimeout('mlm_hide(0)',document.mlm_hide_delay);
	}
}
function mlm_clicked(profundidad,hijo){
	var item_hijo = mlm_hijo(profundidad,hijo);<!---
	alert("prof:"+profundidad+",hijo:"+hijo+",item:"+item_hijo);--->
	if(item_hijo){
		location.href='/cfmx/home/menu/portal.cfm?_nav=1&i=' + item_hijo;
	}
}
function mlm_hijo(profundidad,hijo){
	var papiid = document.mlm_hide_id [profundidad];
	if (! papiid) return 0;
	var info = document['mlm_info'+papiid];
	if (! info) return 0;
	if (! info[hijo]) return 0;
	return info[hijo].item;
}
function mlm_showevent(e){
	if (!e) e = window.event;
	var elem = (e.target) ? e.target : e.srcElement;
	if(!elem)return;
	var parentId = elem.parentNode.id;
	if(!parentId) return;
	var myarray = parentId.split('_');
	if(!myarray || myarray.length != 4)return;
	var profundidad = parseInt(myarray[2]), hijo = parseInt(myarray[3]);
	mlm_show(elem, profundidad, 'Layer'+(1+profundidad), mlm_hijo( (profundidad-1) , hijo ) )
}
function mlm_menurow(profundidad,hijo){
	var spanid  = 'mlm_item_'  + (profundidad) + '_' + hijo,
		arrowid = 'mlm_arrow_' + (profundidad) + '_' + hijo,
		trid    = 'mlm_tr_'    + (profundidad) + '_' + hijo;
	var spanobj  = document.all ? document.all[spanid]  : document.getElementById(spanid),
		arrowobj = document.all ? document.all[arrowid] : document.getElementById(arrowid),
		trobj    = document.all ? document.all[trid]    : document.getElementById(trid);
	if(spanobj && arrowobj){
		return {spanobj:spanobj,arrowobj:arrowobj,trobj:trobj};
	}
	return null;
}
function add_shortcut(){
	if (document.mlm_ubica_SPcodigo) {
		var shortcut_text = prompt('¿Con qué nombre desea agregar esta opción a sus favoritos?', document.mlm_ubica_SPdescripcion);
		if (shortcut_text) {
		<cfoutput>
			window.open('/cfmx/home/menu/portlets/shortcut_add.cfm?s=' + escape(document.mlm_ubica_SScodigo) +
				'&m=' + escape(document.mlm_ubica_SMcodigo) +
				'&p=' + escape(document.mlm_ubica_SPcodigo) +
				'&t='+escape(shortcut_text),'menu_action');
		</cfoutput>
		}
	} else {
	    alert('La opción de favoritos no está disponible para los menús de navegación, solamente para las páginas aplicativas');
	}
}

<!---
mlm_hide_tags: indica que tags se ocultan debajo del menu
DEBERÍA CAMBIARSE MLM_HIDE_TAGS PARA QUE OPERE SEGUN ESTAS REGLAS:

SELECT SOLAMENTE PARA IE MAC
OBJECT SOLAMENTE PARA IE4 + SAFARI
APPLET SOLAMENTE PARA IE4
IFRAME SOLAMENTE PARA IE MAC + (IE WINDOWS < 5.5)
var m=stgme(p);
if(!st_load||nNN4||nOP||p.isst)	
	return;
if(m.mhds&&!nIEM)
	menu_oculta_elem("SELECT",c,p);
if(m.mhdo&&(nIE4||navigator.appVersion.indexOf("Safari")>=0))	{
	menu_oculta_elem("OBJECT",c,p);
	if(nIE4)
		menu_oculta_elem("APPLET",c,p);
}
if(m.mhdi&&(nIEM||nIEW&&nVER<5.5))
	menu_oculta_elem("IFRAME",c,p);
	
	--->
<!---
segun el User-Agent:
mlm_hide_tags = 'SELECT,OBJECT,APPLET,IFRAME'.split(',');

EL IFRAME SE OCULTA PORQUE PUEDE CONTENER OTROS ELEMENTOS ADENTRO
QUE NO SE ESTÁN CONTEMPLANDO ,EG. PORTLETS DE TRAMITES CON SELECT

--->
mlm_hide_tags = (document.all?'SELECT,OBJECT,APPLET,IFRAME':'OBJECT,APPLET,IFRAME').split(',');
function mlm_hide_elems(layerid,counter){
	
	var tagi = 0, elemi = 0, el = null, el_t=0, el_l=0, el_w = 0, el_h = 0, myvis = 0;
	var layerobj = mlm_layer_obj(layerid);
	var ly_l = mlm_left(layerobj),<!--- ly = layer --->
		ly_t = mlm_top (layerobj),
		ly_w = layerobj.offsetWidth,
		ly_h = layerobj.offsetHeight;
	for(tagi=0;tagi<mlm_hide_tags.length;tagi++){
		var elems = document.all?document.all.tags(mlm_hide_tags[tagi]):document.getElementsByTagName(mlm_hide_tags[tagi]);
		for(elemi=0;elemi<elems.length;elemi++){
			el = elems[elemi];<!--- el=elemento--->
			el_l = mlm_left(el);			if (ly_l + ly_w < el_l) continue;
			el_t = mlm_top (el);			if (ly_t + ly_h < el_t) continue;
			el_w = el.offsetWidth;			if (ly_l > el_l + el_w ) continue;
			el_h = el.offsetHeight;			if (ly_t > el_t + el_h ) continue;
			myvis = el.myvis;
			myvis = (myvis?myvis:0)+counter;
			el.myvis = myvis;
			if((counter==+1) && (myvis ==  0)) {
				el.style.visibility = el.originalVisibility ? el.originalVisibility : 'visible';
			} else if((counter==-1) && (myvis == -1)) {
				el.originalVisibility = el.style.visibility;
				el.style.visibility = 'hidden';
			}
		}
	}
}
<cfset submenues = ''>
<cfset maxprof = 1>
<cfset maxhijo = ArrayNew(1)>
<cfset ArraySet(maxhijo,1,10,0)>
<!--- GENERAR OPCIONES DEL MENU --->
<cfoutput query="items" group="papa">
	<cfif items.profundidad GT 1>
		<cfif maxprof LT items.profundidad><cfset maxprof = items.profundidad></cfif>
		document.mlm_info#items.papa# = new Array({ profundidad:#items.profundidad# }
		<cfset subitem_count = 0><!---
		---><cfoutput><!---
		---><cfif Len(SScodigo) And Len(SMcodigo) And Len(SPcodigo)
					Or Len(id_pagina) Or Len(url_item)
					Or ListFind(submenues, items.item)><!--- 
					
			Recordar que hay que
					
			<cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">#HTMLEditFormat(items.etiqueta)#</cf_translateDB> 
			
			---><cfinvoke component="sif.Componentes.TranslateDB" method="Translate"
				 VSvalor="#items.item#" Default="#items.etiqueta#" VSgrupo="124" Idioma="#session.Idioma#"	
				 returnvariable="translated_value"
				 />,  { item:#items.item#, etiqueta:'# JSStringFormat(translated_value) #' }
		</cfif><!---
		---><cfset subitem_count = subitem_count + 1><!---
	---></cfoutput>
		);
		<cfif subitem_count GT 0>
			<cfset submenues = ListAppend(submenues, items.papa)>
			<cfif (maxhijo[profundidad-1] LT subitem_count)>
				<cfset maxhijo[profundidad-1]=subitem_count>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>
//-->
</script>
<!--- GENERAR CHUNCHES VACIOS PARA MOSTRAR LOS MENUES EN CADA NIVEL --->
<cfoutput>
<cfloop from="1" to="#maxprof#" index="profundidad">
	<div id="Layer#profundidad#" class="mlm_layer" style="position:absolute; left:0px; top:0px; z-index:1;visibility:hidden;">
	<table border="0" cellspacing="0" cellpadding="0" class="mlm_item">
	<cfloop from="1" to="#maxhijo[profundidad]#" index="hijo">
		<tr id="mlm_tr_#profundidad#_#hijo#"><td class="mlm_item"
			onmouseover="if(window.mlm_show)mlm_show(this,#profundidad#,'Layer#profundidad+1#',mlm_hijo( #profundidad-1# , #hijo# ) )"
			onmouseout="if(window.mlm_out)mlm_out(this,#profundidad#,'Layer#profundidad+1#')"
			onmousemove="if(window.mlm_move)mlm_move(this,#profundidad#)"
			onclick="if(window.mlm_clicked)mlm_clicked(#profundidad-1#,#hijo#)">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr><td align="left" height="16" id="mlm_item_#profundidad#_#hijo#">-</td>
		<td align="right" valign="bottom">
		<img id="mlm_arrow_#profundidad#_#hijo#" src="/cfmx/home/menu/arrow_r.gif" align="bottom" width="7" height="7" alt="&gt;">&nbsp;
		</td></tr></table>						
		</td></tr>
	</cfloop>
	</table>
	</div>
</cfloop>
</cfoutput>
<div id="LayerFavoritos" class="mlm_layer" style="position:absolute; left:731px; top:194px; z-index:1; visibility:hidden">
  <table border="0" cellspacing="0" cellpadding="0" class="mlm_item" id="mlm_TableFavoritos">
    <tr id="mlm_agregar_favoritos_TR" style="display:none">
      <td class="mlm_item" onMouseOver="if(window.mlm_over)mlm_over(this,1)" 
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1)" 
		onClick="add_shortcut()"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="agregar_favoritos" xmlFile="/home/menu/general.xml">Agregar a Favoritos</cf_translate>...&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td class="mlm_item" onMouseOver="if(window.mlm_over)mlm_over(this,1)" 
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portlets/shortcut_edit.cfm'"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="organizar_favoritos" xmlFile="/home/menu/general.xml">Organizar favoritos</cf_translate>&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td class="mlm_item" onMouseOver="if(window.mlm_over)mlm_over(this,1)" 
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portlets/indicadores/personalizar.cfm'"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">&nbsp;&nbsp;<cf_translate key="personalizar_pagina" xmlFile="/home/menu/general.xml">Personalizar esta p&aacute;gina</cf_translate>&gt;&gt;&nbsp;&nbsp;</td>
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
	    onMouseOver="if(window.mlm_over)mlm_over(this,1)" 
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1)" 
		onClick="location.href='#shortcut_link#'"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">&nbsp;&nbsp; #HTMLEditFormat(shortcuts.descripcion_shortcut)#&nbsp;&nbsp;</td>
    </tr>
  </cfoutput>
  </table>
</div>
<!--- EMPRESAS --->
<div id="LayerEmp" class="mlm_layer" style="position:absolute; left:731px; top:194px; z-index:1; visibility:hidden">
  <table border="0" cellspacing="0" cellpadding="0" class="mlm_item">
  <cfoutput query="rsEmpresas">
	<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
		<cfset uri = '/cfmx/home/menu/index.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
	<cfelse>
		<cfset uri = '/cfmx/home/menu/portal.cfm?_nav=1&amp;root=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
	</cfif>
    <tr>
	  <td class="mlm_item"><cfif rsEmpresas.Ecodigo is session.EcodigoSDC>&gt;<cfelse>&nbsp;</cfif></td>
      <td class="mlm_item" onMouseOver="mlm_over(this,1,'Layer#items.item#')" nowrap="nowrap"
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1,'Layer#items.item#')" 
		onClick="location.href='#uri#'"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">
		&nbsp;#HTMLEditFormat(  REReplace( rsEmpresas.Enombre, '<[^>]+>', '', 'all') )#&nbsp;
		</td>
    </tr>
  </cfoutput>
  <tr><td class="mlm_item" colspan="2" height="1" style="background-color:black"><img src="/cfmx/home/menu/blank.gif" width="1" height="1" alt=""></td></tr>
  <tr><td class="mlm_item">&nbsp;</td><td class="mlm_item" onMouseOver="if(window.mlm_over)mlm_over(this,1)" 
	  	onMouseOut="if(window.mlm_out)mlm_out(this,1)" 
		onClick="location.href='/cfmx/home/menu/portal_rol.cfm?url=' + escape(location.pathname)"
		onMouseMove="if(window.mlm_move)mlm_move(this,1)">&nbsp;<cf_translate key="seleccionar_rol" xmlFile="/home/menu/general.xml">Seleccionar Rol...</cf_translate>&nbsp;</td></tr>
  </table>
</div>
  <iframe width="1" height="1" id="menu_action" name="menu_action" frameborder="0" style="width:1px;height:1px;display:none;visibility:hidden"></iframe>
<!---
usado solamente para el javascript:trace_this()
<cfif session.sitio.ip is '10.7.7.30'>
<div onclick="this.innerHTML='cleared'" style="width:850px;height:450px;overflow:scroll;font-family:Arial, Helvetica, sans-serif;font-size:9pt" id="mystatusbar">
bitacora
</div>
</cfif>
---->
</cfsavecontent>
<cfsavecontent variable="session.menu_cache.content.content">
<!--- BARRA DE MENU HORIZONTAL --->
<table width="980" border="0" cellpadding="0" cellspacing="0" class="mlm_topbar">
	<tr><td width="49">
		<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
			<cfset uri = '/cfmx/'>
		<cfelse>
			<cfset uri = '/cfmx/home/menu/portal.cfm?_nav=1&amp;root=1' >
		</cfif>
		<table border="0" cellpadding="0" cellspacing="0"><tr>
			<td width="49" height="16" align="center" class="mlm_topitem" style="background-image:none"
				onmouseover="if(window.mlm_over)mlm_over(this,0)" 
				onmouseout="if(window.mlm_out)mlm_out(this,0)" 
				onmousemove="if(window.mlm_move)mlm_move(this,0)" 
				onclick="location.href='<cfoutput>#uri#</cfoutput>'"
				nowrap="nowrap"
				><cf_translate key="inicio" xmlFile="/home/menu/general.xml">Inicio</cf_translate></td>
		</tr></table>
	</td>
	<td width="92">
		<table border="0" cellpadding="0" cellspacing="0"><tr>
			<td width="92" height="16" align="center" class="mlm_topitem"
				onclick="if(window.mlm_show)mlm_show(this,0,'LayerFavoritos',true)" 
				onmouseover="if(window.mlm_over)mlm_over(this,0,'LayerFavoritos')" 
				onmouseout="if(window.mlm_out)mlm_out(this,0,'LayerFavoritos')" 
				onmousemove="if(window.mlm_move)mlm_move(this,0)"
				nowrap="nowrap"
				>&nbsp;<cf_translate key="favoritos" xmlFile="/home/menu/general.xml">Favoritos</cf_translate>&nbsp;&nbsp;</td>
		</tr></table>
	</td>
	<td align="left" >
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<cfoutput query="items">
			<cfif items.profundidad Is 1 And ListFind(submenues, items.item)>
			<td height="16" align="center" class="mlm_topitem"
				onclick="if(window.mlm_show)mlm_show(this,0,'Layer#1#','#items.item#',true)" 
				onmouseover="if(window.mlm_over)mlm_over(this,0,'Layer#1#')" 
				onmouseout="if(window.mlm_out)mlm_out(this,0,'Layer#1#')" 
				onmousemove="if(window.mlm_move)mlm_move(this,0)"
				nowrap="nowrap">&nbsp;&nbsp;<cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">#HTMLEditFormat(items.etiqueta)#</cf_translateDB>&nbsp;&nbsp;
				</td>
			</cfif>
			</cfoutput>
		</tr>
		</table>
	</td>
	<td align="right" >
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="16" align="center" class="mlm_topitem"
				onclick="if(window.mlm_show)mlm_show(this,0,'LayerEmp',true)" 
				onmouseover="if(window.mlm_over)mlm_over(this,0,'LayerEmp')" 
				onmouseout="if(window.mlm_out)mlm_out(this,0,'LayerEmp')" 
				onmousemove="if(window.mlm_move)mlm_move(this,0)" nowrap="nowrap">&nbsp;<cf_translate key="compania" xmlFile="/home/menu/general.xml">Compa&ntilde;&iacute;a</cf_translate>:&nbsp;<cfoutput>#HTMLEditFormat(REReplace( session.Enombre, '<[^>]+>', '', 'all'))#</cfoutput>
					&nbsp;&nbsp;</td>
		</tr>
		</table>
	</td>
	</tr>
</table>
</cfsavecontent>
<cfset session.menu_cache.time = Now()>
<cfset session.menu_cache.args = menu_cache_args>
</cfif>
<cfoutput>
<cfif IsDefined('request.mlm_part1')>
	#session.menu_cache.content.content#
	<cfset StructDelete(request,'mlm_part1')>
	<cfset request.mlm_part2 = 1>
<cfelseif IsDefined('request.mlm_part2')>
	#session.menu_cache.content.content2#
	<cfset StructDelete(request,'mlm_part2')>
<cfelse><!--- si no estuvo ninguna variable --->
	#session.menu_cache.content.content#
	#session.menu_cache.content.content2#
</cfif>
</cfoutput>
<!--- esta parte no se "cachea" porque depende de cada pantalla --->
<cfif (Not IsDefined('ubicacionSP')) and (IsDefined('session.menues.SScodigo') and IsDefined('session.menues.SMcodigo') and IsDefined('session.menues.SPcodigo'))>
	<!--- debe estar idéntico en portal_tabs.cfm --->
	<cfquery datasource="asp" name="ubicacionSP">
		select SPcodigo, SPdescripcion
		from SProcesos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
		  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
	</cfquery>
</cfif>
<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPdescripcion)>
<cfoutput>
<script type="text/javascript">
<!--
	document.mlm_ubica_SScodigo      = '#JSStringFormat( session.menues.SScodigo )#';
	document.mlm_ubica_SMcodigo      = '#JSStringFormat( session.menues.SMcodigo )#';
	document.mlm_ubica_SPcodigo      = '#JSStringFormat( session.menues.SPcodigo )#';
	document.mlm_ubica_SPdescripcion = '#JSStringFormat( ubicacionSP.SPdescripcion )#';
	var fav_tr = document.all ? document.all.mlm_agregar_favoritos_TR : document.getElementById('mlm_agregar_favoritos_TR');
	if (fav_tr && fav_tr.style) {
		fav_tr.style.display = '';
	}
//-->
</script>
</cfoutput>
</cfif>
