
/*
** Funciones para mover los portlets
** El prefijo para las funciones y variables globales es pm de "portlet move"
*/
window.pm_animationIntervalObject = 0;
pm_source_name = null;
pm_current_target = null;
pm_column_array = 0;

function pm_trace(s){
	//return;
	if (!document.formtrace) return;
	var newopt = document.createElement("option");
	newopt.text = s;
	document.formtrace.select1.add(newopt, (dd.ie ? 0 : document.firstopt?document.firstopt:null));
	document.firstopt=newopt;
}

function show_sizes(){
	var s = "";
	for(k=0;k<pm_portlet_array.length;k++){
		var el = dd.elements[pm_portlet_array[k].name];
		s+=el.name+"</b>,row="+pm_portlet_array[k].row
			+", col="+pm_portlet_array[k].col
			+", x="+el.x+", y="+el.y+", w="+el.w+", h="+el.h+'\u0013';
	}
	alert(s);
}

function pm_extra_init(seguir){
	for(i=0;i<pm_portlet_array.length;i++)
	{
		with (pm_portlet_array[i])
		{
			if (name.indexOf("pm_extra") == 0) 
			{
				var obj = document.all?document.all[name]:document.getElementById(name);
				dd.elements[name].w = Math.max(pm_mincolwidth,dd.elements[name].w);
				obj.style.width  = dd.elements[name].w;
				obj.style.borderTop = "solid 2px #CCCCCC";
			}
		}
	}
	if (!seguir && dd.ie)
	{
		window.setTimeout ("pm_extra_init(true);",1);
		return;
	}
	var pms = "";
	for(i=0;i<pm_portlet_array.length;i++)
	{
		with (pm_portlet_array[i])
		{
			LvarXY = findXY(name);
			dd.elements[name].x = LvarXY[0];
			dd.elements[name].y = LvarXY[1];
			pms += name + "=" + dd.elements[name].x + "," + dd.elements[name].y + "\n"; 
		}
	}

	//alert(pms);
}

function pm_reposition_portlets(useAnimation){
	var i,j;
	var pm_rows = 0, pm_cols = 0;
	for(i=0;i<pm_portlet_array.length;i++){
		// contar filas y columnas
		pm_cols=Math.max(pm_portlet_array[i].col , pm_cols);
		pm_rows=Math.max(pm_portlet_array[i].row , pm_rows);
	}

	// calcular x,w de cada columna
	pm_column_array=new Array(pm_cols+1);
	for(i=0;i<=pm_cols;i++) pm_column_array[i]={x:0,w:(i?pm_mincolwidth:0)};
	for(i=0;i<pm_portlet_array.length;i++){
		var el = dd.elements[pm_portlet_array[i].name];
		var col = pm_portlet_array[i].col;
		if (!pm_portlet_array[i].extra) {
			pm_column_array[col].w=Math.max(pm_column_array[col].w , el.w);
		} 
	}
	
	return;
}

function pm_set_target (new_target, portlet_info) {
	if(new_target != pm_current_target){
		pm_trace ( '  pm_set_target(' + (new_target?new_target.name:null) + ')');
		if(pm_current_target)
			pm_current_target.setBgColor("white");
		pm_current_target = new_target;
		if(pm_current_target) {
			if (!portlet_info.extra) {
				pm_current_target.setBgColor("gray");
			}
			dd.elements.separator.show();
			dd.elements.separator.moveTo(pm_current_target.x, pm_current_target.y - pm_marginy*3/4);
			dd.elements.separator.resizeTo(pm_column_array[portlet_info.col].w, pm_marginy/2);
			//dd.elements.separator.resizeTo(new_target.w, 10);
		} else {
			dd.elements.separator.hide();
		}
	}
}

function pm_select_target(){
	var targetx=0,targetwx=0,targety=0, maxy=0; maxi=0;
		targetfound=-2;

	// Determina la menor columna mayor o igual al cursor
	for (var i=0;i<pm_portlet_array.length;i++) 
	{
		if (pm_portlet_array[i].name != "pm_handler") 
		{
			var el = dd.elements[pm_portlet_array[i].name];
			var wx = el.x + Math.max(el.w, pm_column_array[pm_portlet_array[i].col].w);
			if ((dd.e.x >= el.x) && (dd.e.x <= wx))
			{
				if ((targetx == 0) || (el.x < targetx))
				{
					targetx = el.x;
					targetwx = wx;
					targetfound=-1;
				}
			}
		}
	}

	// Determina la menor fila mayor o igual al cursor, si está en la columna escogida
	if (targetfound==-1)
	{
		for (var i=0;i<pm_portlet_array.length;i++) 
		{
			if (pm_portlet_array[i].name != "pm_handler") 
			{
				var el = dd.elements[pm_portlet_array[i].name];
				if ((el.x >= targetx) && (el.x <= targetwx))
				{
					if (el.y >= maxy)
					{
						maxy = el.y;
						maxi = i;
					}

					var hy = el.y + el.y;
					if ((el.y >= dd.e.y))
					{
						if ((targety == 0) || (el.y < targety))
						{
							targety = el.y;
							targetfound = i;
						}
					}
				}
			}
		}
	}

	if (targetfound == -1)
		targetfound = maxi;
	if (targetfound > -1){
		pm_set_target( dd.elements[pm_portlet_array[targetfound].name] , pm_portlet_array[targetfound] );
	} else {
		pm_set_target( null, null );
	}
}

function pm_move_dropped_portlet(s_source, s_target){
	// lo mueve en terminos de row/col
	if (pm_current_target) {
		var target_row = -1, target_col = -1, target_i = -1;
		var source_row = -1, source_col = -1, source_i = -1;
		for (var i=0;i<pm_portlet_array.length;i++) {
			if (target_i == -1 && pm_portlet_array[i].name == s_target) {
				target_i   = i;
				target_row = pm_portlet_array[i].row;
				target_col = pm_portlet_array[i].col;
				if (source_i != -1) break;
			} else if (source_i == - 1 && pm_portlet_array[i].name == s_source) {
				source_i   = i;
				source_row = pm_portlet_array[i].row;
				source_col = pm_portlet_array[i].col;
				if (target_i != -1) break;
			}
		}
		if (target_i == -1 || source_i == -1) {
			pm_trace ( 'assertion failed: invalid (target,source)=('+s_target+':'+target_i+','+s_source+':'+source_i+')' );
			return;
		}
		pm_trace('src rc='+source_row+','+source_col+'; tgt rc='+target_row+','+target_col);
		for (var i=0;i<pm_portlet_array.length;i++) with (pm_portlet_array[i]){
			if (i == source_i) {
				row = target_row - ((target_col == source_col) && (source_row < target_row) ? 1 : 0);
				col = target_col;
			} else if (source_col == target_col) {
				// move in the same column
				if (col == source_col) {
					if (source_row < row && row < target_row) {
						row--;
					} else if (source_row > row && row >= target_row) {
						row++;
					}
				}
			} else {
				// adjust source columns
				if (col == source_col && row > source_row) {
					row--;
				}
				// adjust target columns
				if (col == target_col && row >= target_row) {
					row++;
				}
			}
		}
	}
	pm_set_target ( null , null );
}

function pm_onmousedown_handle(s_source){
	// s_source : nombre del div que se va a mover
	if (!dd || !dd.elements.pm_handle) return;
	var e_source = dd.elements[s_source];
	dd.elements.pm_handle.moveTo(e_source.x, e_source.y);
	dd.elements.pm_handle.resizeTo(e_source.w, e_source.h);
	dd.elements.pm_handle.maximizeZ();
	dd.elements.pm_handle.show();
	pm_source_name = s_source;
}

function findXY(name) {
	var obj = document.all?document.all[name]:document.getElementById(name);
	var curX = curY = 0;
	while (obj.offsetParent) 
	{
		curX += obj.offsetLeft;
		curY += obj.offsetTop;
		obj = obj.offsetParent;
	}
	return [curX,curY];
}

function pm_server_update(){
	var sa = new Array(), curN = 1;
	sa[0] = "id_pagina=" + pm_idpagina;
	for (var i=0; i<pm_portlet_array.length; i++) {
		with (pm_portlet_array[i]) {
			if (name.indexOf("pm_name") == 0) 
			{
				sa [sa.length] = "n" + (curN++) + "=" + col + "," + row + "," + name.substring(7,50);
			}
			LvarXY = findXY(name);
			dd.elements[name].x = LvarXY[0];
			dd.elements[name].y = LvarXY[1];
		}
	}
	window.open("/cfmx/home/menu/portlets/pzn/portlet-move.cfm?" + sa.join("&"), "pm_iframe");
	//location.href="";
}

function my_DragFunc(){
	//pm_trace ( 'drag ' + dd.obj.name + ' to (' + dd.obj.x + ',' + dd.obj.y + ')' );
	pm_select_target();
}

function my_DropFunc(){
	pm_trace (  'drop ' + dd.obj.name );
	//pm_reposition_portlets(useAnimation);
	
	dd.elements.pm_handle.hide();
	if ((pm_source_name != null) && (pm_current_target != null) && (pm_source_name != pm_current_target.name)) {
		var s_source = pm_source_name;
		var s_target = pm_current_target.name;
		
		var n_source = document.all?document.all[s_source]:document.getElementById(s_source);
		var n_target = document.getElementById?document.getElementById(s_target):document.all[s_target];
		
		pm_move_dropped_portlet(pm_source_name, pm_current_target.name);
		
		n_source.parentNode.removeChild(n_source);
		n_target.parentNode.insertBefore(n_source, n_target);
		
		pm_server_update();
		dd.recalc();
		pm_source_name = null;
	}
}
function my_PickFunc(){
	pm_trace ( 'pick ' + dd.obj.name );
	pm_reposition_portlets(true);
}
