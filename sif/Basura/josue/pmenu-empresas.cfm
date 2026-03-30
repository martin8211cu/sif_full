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

<script type="text/javascript" language="JavaScript1.2">
<!--
stm_bm(["menu7c2d",430,"","#img_blank#",0,"","",0,0,150,150,150,1,1,0,"","100%",0],this);
stm_sc(1,["transparent","transparent","","",3,3,0,0,"#MouseOut_AutoScroll#","##000000","#img_updisabled#","#img_upenabled#",7,9,0,"#img_downdisabled#","#img_downenabled#",7,9,0]);
stm_bp("p0",[0,4,0,0,1,3,13,13,100,"",-2,"",-2,90,0,0,"##7F7F7F","#Menu_Background#","",3,0,0,"#Border_PopUpMenu#"]);

stm_ai("p0i0",[1,"<strong>Compa&ntilde;&iacute;a:&nbsp;#session.Enombre#</strong>&nbsp;","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","#MouseOver_MenuItem#","#FontOver#","#FontOut#",0,0]);
stm_bpx("p1","p0",[1,4,0,0,0,3,0,0,83,"",-2,"",-2,58,0,0,"##7F7F7F","##FFFFFF","",3,1,1]);


<cfloop query="rsEmpresas">
	<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
		<cfset uri = '/cfmx/home/menu/index.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
	<cfelse>
		<cfset uri = '/cfmx/home/menu/portal.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
	</cfif>
	stm_aix("p1i#rsEmpresas.currentrow#","p0i0",[1,"#rsEmpresas.Enombre#","","",-1,-1,0,"#uri#","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);	
</cfloop>

/*
stm_aix("p1i0","p0i0",[1,"Opcion 1","","",-1,-1,0,"index1.cfm","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","##000000"]);
stm_aix("p1i1","p0i0",[1,"Opcion 2","","",-1,-1,0,"index2.cfm","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","##000000"]);
stm_aix("p1i2","p0i0",[1,"Opcion 3","","",-1,-1,0,"index3.cfm","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","##000000"]);
*/



stm_ai("p1i4",[6,1,"##000000","",0,0,0]);
stm_aix("p1i2","p0i0",[1,"Seleccionar Rol","","",-1,-1,0,"javascript:alert('hola')","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"##000000","##000000","##000000","##000000"]);
stm_ep();



/*
stm_ai("p0i0",[1,"Inicio&nbsp;&nbsp;     ","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0,0,0,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##CCCCCC","#MouseOver_MenuItem#","#FontOut#","#FontOver#",0,0]);
stm_ai("p0i1",[6,1,"##06437D","",0,0,0]);

stm_aix("p0i2","p0i0",[1,"Favoritos&nbsp;","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","#MouseOut_MenuGlobal#"]);
/*
stm_bpx("p1","p0",[1,4,0,0,0,3,0,0,83,"",-2,"",-2,58,0,0,"##F7F7F7","##FFFFFF","",3,1,1]);
stm_aix("p1i0","p0i0",[1,"Opcion 1","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#MouseOut_PopUpMenu#","#MouseOut_PopUpMenu#","#MouseOut_PopUpMenu#","#MouseOver_PopUpMenu#"]);
*/

/*
stm_aix("p1i1","p1i0",[1,"Opcion 2"]);
stm_aix("p1i2","p0i1",[]);
stm_aix("p1i3","p1i0",[1,"Organizar Mis Favoritos"]);
stm_ep();
*/

//stm_aix("p0i3","p0i2",[1,"Configuración","","",-1,-1,0,"","_self","","","","",13,8]);
/*
stm_bpx("p2","p1",[1,4,0,0,0,3,0,7]);
stm_aix("p2i0","p1i0",[1,"Parametrización del Sistema","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_arrowr#","#img_arrowr#",7,7]);
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

//stm_aix("p0i4","p0i2",[1,"Procesos","","",-1,-1,0,"","_self","","","","",7,7,0,"","",0,0]);

//stm_aix("p0i5","p0i2",[1,"Compañía: Soluciones Integrales S.A.","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,2]);

//stm_aix("p0i5","p0i2",[1,"XXXXXX","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,2]);

/*
stm_bpx("p8","p1",[]);
stm_aix("p8i0","p1i0",[1,"AAAAAAAAAAAAAAAAAAAAAA"]);
stm_aix("p8i1","p1i0",[1,"BBBBBBBBBBBBBBBBBBBBBBBBB"]);
stm_aix("p8i2","p1i0",[1,"CCCCCCCCCCCCCCCCCCCCCC"]);
stm_aix("p8i3","p8i0",[]);
stm_aix("p8i4","p8i0",[]);
stm_aix("p8i5","p8i0",[]);
stm_aix("p8i6","p8i0",[]);
stm_aix("p8i7","p8i0",[]);
stm_aix("p8i8","p8i0",[]);
stm_aix("p8i9","p8i0",[]);
stm_aix("p8i10","p8i0",[]);
stm_aix("p8i11","p8i0",[]);
stm_aix("p8i12","p8i0",[]);
stm_aix("p8i13","p8i0",[]);
stm_aix("p8i14","p8i0",[]);
stm_aix("p8i15","p8i0",[]);
stm_aix("p8i16","p8i0",[]);
stm_aix("p8i17","p8i0",[]);
stm_aix("p8i18","p8i0",[]);
stm_aix("p8i19","p8i0",[]);
stm_aix("p8i20","p8i0",[]);
stm_aix("p8i21","p8i0",[]);
stm_aix("p8i22","p8i0",[]);
stm_aix("p8i23","p8i0",[]);
stm_aix("p8i24","p8i0",[]);
stm_aix("p8i25","p8i0",[]);
stm_aix("p8i26","p8i0",[]);
stm_aix("p8i27","p8i0",[]);
stm_aix("p8i28","p8i0",[]);
stm_aix("p8i29","p8i0",[]);
stm_aix("p8i30","p8i0",[]);
stm_aix("p8i31","p8i0",[]);
stm_aix("p8i32","p8i0",[]);
stm_aix("p8i33","p8i0",[]);
stm_aix("p8i34","p8i0",[]);
stm_aix("p8i35","p8i0",[]);
stm_aix("p8i36","p8i0",[]);
stm_aix("p8i37","p8i0",[]);
stm_aix("p8i38","p8i0",[]);
stm_aix("p8i39","p8i0",[]);
stm_ep();
stm_ep();
*/

stm_em();
//-->
</script>
</cfoutput>

</body>
</html>

