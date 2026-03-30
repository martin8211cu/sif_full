<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>
<script type="text/javascript" language="JavaScript1.2" src="/cfmx/sif/Basura/marcel/sothink/stm31.js"></script>

<!--- definición de colores --->
<cfset Menu_Background = "##06437D">
<cfset MouseOver_MenuItem = "##FFFFFF">
<cfset MouseOut_MenuGlobal ="##FFFFFF">
<cfset MouseOut_AutoScroll = "##FFFFF7">
<cfset MouseOut_PopUpMenu = "##FFFFFF">
<cfset MouseOver_PopUpMenu = "##000000">
<cfset Border_PopUpMenu = "##356595">
<cfset Submenu_Background = "##CCE3F8"> <!--- Color de fondo de los submenus --->
<cfset Submenu_ColorLetra = "##000000"> <!--- Color de letra de los submenus --->

<!--- definición de tipo de letra --->
<cfset FontOut = "9pt Arial">
<cfset FontOver = "9pt Arial">

<!--- definición de imagenes --->
<cfset img_updisabled ="/cfmx/sif/Basura/marcel/sothink/up_disabled.gif">
<cfset img_upenabled ="/cfmx/sif/Basura/marcel/sothink/up_enabled.gif">
<!---<cfset img_sampleredarrow ="/cfmx/sif/Basura/marcel/sothink/sample_red_arrow.gif">--->
<cfset img_sampleredarrow ="/cfmx/home/menu/portlets/arrow_main.gif">
<cfset img_downenabled ="/cfmx/sif/Basura/marcel/sothink/down_enabled.gif">
<cfset img_downdisabled ="/cfmx/sif/Basura/marcel/sothink/down_disabled.gif">
<cfset img_arrowr ="/cfmx/sif/Basura/marcel/sothink/arrow_r.gif">
<cfset img_blank = "/cfmx/sif/Basura/marcel/sothink/blank.gif">

<body>
<cfoutput>

<cfset x = 2000000000010419 >
<cfquery datasource="#session.DSN#" name="items" >
	select
			m.id_item as item, m.etiqueta_item as etiqueta_old, papa.id_padre as papa, r.profundidad, r.ruta as ruta,
			<!--- estos siguientes sirven para determinar si el menu es clicable o no --->
			m.SScodigo, m.SMcodigo, m.SPcodigo, m.id_pagina, m.url_item,
			coalesce((	select VSdesc
						from VSidioma
						where Iid     = 3
						  and VSgrupo = 124
						  and VSvalor = convert(varchar, m.id_item) ), m.etiqueta_item) as etiqueta
	from SRelacionado r
			join SMenuItem m
				on m.id_item = r.id_hijo
			join SRelacionado papa
				on papa.id_hijo = m.id_item
				and papa.profundidad = 1
			join SRelacionado papx <!--- asegurarse de que papa sea hijo de session.menues.root --->
				on papx.id_hijo = papa.id_padre
				and papx.id_padre = #x#
	where r.id_padre = #x#
		
		<!---and r.profundidad <= 3--->
	
		and (m.SScodigo is null or m.SMcodigo is null or m.SPcodigo is null 
			or exists (select * from vUsuarioProcesos x
			where x.SScodigo = m.SScodigo
			  and x.SMcodigo = m.SMcodigo
			  and x.SPcodigo = m.SPcodigo
			  and x.Usucodigo = 27
			  and x.Ecodigo = 2) )
	order by r.ruta, r.profundidad asc
</cfquery>

<!--- /////////////////////////////////////////////////////////////////////////////// --->
<!--- /////////////////////////////////////////////////////////////////////////////// --->
<!--- /////////////////////////////////////////////////////////////////////////////// --->
<!---
<cfoutput query="items">
	<cfif items.profundidad eq profundidadant and len(trim(profundidadant))>
		</li>
	<cfelse>
		<cfif items.profundidad gt profundidadant and len(trim(profundidadant))>
		<cfif items.profundidad gt 2>
			<ul style="width:190px; top:1px; left:186px;" >
		<cfelse>
			<ul style="width:190px;" >
		</cfif>
	</cfif>
	<cfif items.profundidad lt profundidadant and len(trim(profundidadant))>
		<!--- cierra tags desde el nivel donde quedo hasta el nivel 1--->
		<cfset cerrar = ((profundidadant-items.profundidad)*2) >
		<cfloop from="1" to="#cerrar#" index="i">
			<cfif i mod 2 >
				</li>
			<cfelse>
				</ul>
			</cfif>
		</cfloop>
		</cfif>
	</cfif>
	
	<li><a href="<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>"><!---<cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">--->#HTMLEditFormat(traducir[items.item])#<!---</cf_translateDB>---></a>
	<cfset profundidadant = items.profundidad >
</cfoutput>	<!--- cierra tags desde el nivel donde quedo hasta el nivel 1--->	
--->
<!--- /////////////////////////////////////////////////////////////////////////////// --->
<!--- /////////////////////////////////////////////////////////////////////////////// --->
<!--- /////////////////////////////////////////////////////////////////////////////// --->

<script type="text/javascript" language="JavaScript1.2">
<!--
stm_bm(["menu7c2d",430,"","blank.gif",0,"","",0,0,150,150,150,1,1,0,"","100%",0],this);
stm_sc(1,["transparent","transparent","","",3,3,0,0,"##FFFFF7","##000000","up_disabled.gif","up_enabled.gif",7,9,0,"down_disabled.gif","down_enabled.gif",7,9,0]);
stm_bp("p0",[0,4,0,0,1,3,13,13,100,"",-2,"",-2,90,0,0,"##7F7F7F","##06437D","",3,0,0,"##000000"]);

stm_ai("p0i0",[0,"Inicio","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0,0,2,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","##FFCC00","bold 9pt Arial","bold 9pt Arial",0,0]);

stm_aix("p0i1","p0i0",[1,"Favoritos&nbsp;","","",-1,-1,0,"","_self","","","","",0,0,0,"sample_red_arrow.gif","sample_red_arrow.gif",13,8,0,0]);
stm_bpx("p1","p0",[1,4,0,0,0,3,0,0,83,"",-2,"",-2,58,0,0,"##7F7F7F","##FFFFFF","",3,1,1]);
stm_aix("p1i0","p0i0",[1,"Opcion 1","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0,0,0,1,"##999999",0,"##FFCC00",0,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","##000000"]);
stm_aix("p1i1","p1i0",[1,"Opcion 2"]);
stm_ai("p1i2",[6,1,"##000000","",0,0,0]);
stm_aix("p1i3","p1i0",[1,"Organizar Mis Favoritos"]);
stm_ep();

/* ///////////////////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////////////////////////////////////////////////// */
<cfset profundidadant = 1 >
<cfset cerrar = 0 >
<cfset data = querynew('menu,nivel,hijos','integer,integer,integer')>
<cfset newRow = QueryAddRow(data, 1)>
<cfset temp = QuerySetCell(data, "menu", 1)>
<cfset temp = QuerySetCell(data, "nivel", 1)>
<cfset temp = QuerySetCell(data, "hijos", 2)>

<cfset vMenu = 1 >
<cfloop query="items" >

	<cfif items.profundidad eq 1 and items.currentrow neq 1>
		<cfloop from="1" to="#cerrar#" index="i">
			stm_ep();
		</cfloop>
		<cfset cerrar = 0>	
	</cfif>
	<cfif (items.profundidad gt profundidadant) >
		<cfquery dbtype="query" name="m">
			select max(menu) as menu from data
		</cfquery>
		<cfif len(trim(m.menu))>
			<cfset vMenu = m.menu + 1>
		</cfif>
		<cfset newRow = QueryAddRow(data, 1)>
		<cfset temp = QuerySetCell(data, "menu", #vMenu#)>
		<cfset temp = QuerySetCell(data, "nivel", #items.profundidad#)>
		<cfset temp = QuerySetCell(data, "hijos", 1)>
	
		stm_bpx('p#vMenu#',"p#profundidadant#",<cfif items.profundidad eq 2>[]<cfelse>[1,2,0,-1]</cfif>); 
		<cfset cerrar = cerrar + 1 >
		stm_aix('p#vMenu#i0',"p#vMenu-1#i0",[1,"#items.etiqueta#","","",-1,-1,0,"","_self","","","","",0,0,0,"arrow_r.gif","arrow_r.gif",7,7]);
	<cfelseif items.profundidad lt profundidadant >
		<cfquery dbtype="query" name="m">
			select max(menu) as menu 
			from data
			where nivel = #items.profundidad#
		</cfquery>
		<cfset indice = 1 >
		<cfif len(trim(m.menu))>
			<cfset vMenu = m.menu>
			<cfquery dbtype="query" name="h">
				select hijos
				from data
				where menu = #vMenu#
			</cfquery>
			<cfset indice = h.hijos >
			<cfquery name='tmp' dbtype='query'>
				select * from data
			</cfquery>
			<cfset data = querynew('menu,nivel,hijos','integer,integer,integer')>
			<cfloop query="tmp">
				<cfset newRow = QueryAddRow(data, 1)>
				<cfset temp = QuerySetCell(data, "menu", #tmp.menu#)>
				<cfset temp = QuerySetCell(data, "nivel", #tmp.nivel#)>
				<cfif tmp.menu eq vMenu >
					<cfset temp = QuerySetCell(data, "hijos", #tmp.hijos#+1)>
				<cfelse>
					<cfset temp = QuerySetCell(data, "hijos", #tmp.hijos#)>
				</cfif>
			</cfloop>
			
		</cfif>
		<cfset cerrar = cerrar - 1 >
		stm_ep();
		stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"#items.etiqueta#","","",-1,-1,0,"","_self","","","","",13,8]);
	<cfelse>
		<cfquery dbtype="query" name="m">
			select max(menu) as menu 
			from data
			where nivel = #items.profundidad#
		</cfquery>
		<cfset indice = 1 >
		<cfif len(trim(m.menu))>
			<cfset vMenu = m.menu>
			<cfquery dbtype="query" name="h">
				select hijos
				from data
				where menu = #vMenu#
			</cfquery>
			<cfset indice = h.hijos >
			<cfquery name='tmp' dbtype='query'>
				select * from data
			</cfquery>
			<cfset data = querynew('menu,nivel,hijos','integer,integer,integer')>
			<cfloop query="tmp">
				<cfset newRow = QueryAddRow(data, 1)>
				<cfset temp = QuerySetCell(data, "menu", #tmp.menu#)>
				<cfset temp = QuerySetCell(data, "nivel", #tmp.nivel#)>
				<cfif tmp.menu eq vMenu >
					<cfset temp = QuerySetCell(data, "hijos", #tmp.hijos#+1)>
				<cfelse>
					<cfset temp = QuerySetCell(data, "hijos", #tmp.hijos#)>
				</cfif>
			</cfloop>
		</cfif>
		stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"#items.etiqueta#","","",-1,-1,0,"","_self","","","","",13,8]);
	</cfif>
	<cfset profundidadant = items.profundidad >
</cfloop>
<cfloop from="1" to="#cerrar#" index="i">
	stm_ep();
</cfloop>


/*
stm_aix("p0i2","p0i1",[1,"Configuración","","",-1,-1,0,"","_self","","","","",13,8]);
stm_bpx("p2","p1",[1,4,0,0,0,3,0,7]);
	stm_aix("p2i0","p1i0",[1,"Parametrización del Sistema","","",-1,-1,0,"","_self","","","","",0,0,0,"arrow_r.gif","arrow_r.gif",7,7]);
	stm_bpx("p3","p2",[1,2,0,-1]);

		stm_aix("p3i0","p1i0",[0,"Parámetros Generales"]);
		stm_aix("p3i1","p2i0",[1,"Parámetros de Nómina"]);
		stm_bpx("p4","p3",[]);
			stm_aix("p4i0","p2i0",[1,"Estructura Organizacional"]);
			stm_bpx("p5","p1",[1,2,0,-1]);
				stm_aix("p5i0","p1i0",[1,"Puestos"]);
			stm_ep();
		stm_ep();

		stm_aix("p3i2","p2i0",[0,"Parámetros de Desarrollo Humano"]);
		stm_bpx("p6","p3",[]);
			stm_aix("p6i0","p2i0",[0,"Capacitación y Desarrollo"]);
			stm_bpx("p7","p5",[]);
				stm_aix("p7i0","p1i0",[1,"Cursos"]);
			stm_ep();
		stm_ep();
	stm_ep();

	stm_aix("p2i1","p1i0",[0,"Opcion 1"]);
	stm_ep();
*/	

/*stm_aix("p0i3","p0i1",[1,"Procesos","","",-1,-1,0,"","_self","","","","",7,7,0,"","",0,0]);*/
	
/*
stm_aix("p0i4","p0i0",[1,"Compañía: Soin","","",-1,-1,0,"","_self","","","","",0,0,0,"sample_red_arrow.gif","sample_red_arrow.gif",13,8]);
stm_bpx("p8","p1",[]);
		stm_aix("p8i0","p1i0",[1,"prueba"]);
	stm_ep();
stm_ep();
*/

stm_em();
//-->
</script>


<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td><select name="x" >
		<option value="soda">Soda Stereo</option>
		<option value="rage">Rage Against the machine</option>
		<option value="korn">KORN</option>
	</select></td></tr>
</table>

</cfoutput>

</body>
</html>

