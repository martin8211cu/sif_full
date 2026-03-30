 <script id="Sothink Widgets:PageletServer.DynamicMenu" type="text/javascript" language="JavaScript1.2" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<table width='100%' border='0' cellspacing='0' cellpadding='0'>
  <tr>
    <td nowrap class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"> 
		<script type="text/javascript" language="JavaScript1.2">
		<!--
		stm_bm(["exnvfhr",400,"/cfmx/sif/js/DHTMLMenu/","blank.gif",0,"","",0,1,100,100,150,1,0,0,""],this);
		stm_bp("p0",[0,4,0,0,0,2,0,7,100,"",-2,"",-2,90,0,0,"#000000","transparent","",3,0,0,"#a0a0ba"]);
		stm_ai("p0i0",[0,"Menú Principal","","",-1,-1,0,"","_self","Menú Principal","Menú Principal","","",0,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#ffffff",1,"#ffffff",1,"","",3,3,0,0,"#666666","#999999","#ffffff","#000000","8pt Verdana","8pt Verdana",0,0]);
		stm_bp("p1",[1,4,0,0,0,3,8,0,100,"",-2,"",-2,90,0,0,"#7f7f7f","#ffffff","",3,1,1,"#000000"]);
		stm_aix("p1i0","p0i0",[0,"Menú de SIF","","",-1,-1,0,"/cfmx/sif/indexSif.cfm","_self","Menu de SIF","Menú Principal del Sistema Financiero Integral","","",8,0,0,"","",0,0,0,0,1,"#ffffff",0,"#e8e9ea",0,"","",3,3,0,0,"#cccccc","#ffffff","#000000","#ff0000"]);
		stm_aix("p1i1","p1i0",[0,"Menú de Inventarios","","",-1,-1,0,"/cfmx/sif/iv/MenuIV.cfm","_self","Menú de Inventarios","Menú de Inventarios"]);
		stm_ep();
		stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
		stm_aix("p0i2","p0i0",[0,"Operación ","","",-1,-1,0,"","_self","",""]);
		stm_bpx("p2","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000","#ffffff","",2]);
		stm_aix("p2i0","p1i0",[0,"Requisiciones","","",-1,-1,0,"/cfmx/sif/iv/operacion/listaRequisicion.cfm","_self","Requisiciones","Requisiciones"]);
		stm_aix("p2i1","p1i0",[0,"Ajustes","","",-1,-1,0,"/cfmx/sif/iv/operacion/listaAjuste.cfm","_self","Ajustes","Ajustes"]);
		stm_aix("p2i2","p1i0",[0,"Movimientos Interalmacén","","",-1,-1,0,"/cfmx/sif/iv/operacion/listaMovInterAlmacen.cfm","_self","Movimientos Interalmacén","Movimientos Interalmacén"]);
		stm_ep();
		stm_aix("p0i3","p0i1",[6,1,"transparent","",1,1]);
		stm_aix("p0i4","p0i2",[0,"Consultas"]);
		stm_bpx("p3","p1",[]);
		stm_aix("p3i0","p1i0",[0,"Kardex Resumido","","",-1,-1,0,"/cfmx/sif/iv/consultas/kardexResumido.cfm","_self","Kardex Resumido","Kardex Resumido"]);
		stm_aix("p3i1","p1i0",[0,"Kardex Detallado","","",-1,-1,0,"/cfmx/sif/iv/consultas/kardexDetallado.cfm","_self","Kardex Detallado","Kardex Detallado"]);
		stm_aix("p3i2","p1i0",[0,"Existencias por Almacén","","",-1,-1,0,"/cfmx/sif/iv/consultas/Existencias.cfm","_self","Existencias por Almacén","Existencias por Almacén"]);
		stm_ep();
		stm_aix("p0i5","p0i1",[]);
		stm_aix("p0i6","p0i2",[0,"Catálogos"]);
		stm_bpx("p4","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000"]);
		stm_aix("p4i0","p1i0",[0,"Almacenes","","",-1,-1,0,"/cfmx/sif/iv/catalogos/Almacen.cfm","_self","Almacenes","Almacenes"]);
		stm_aix("p4i1","p1i0",[0,"Artículos","","",-1,-1,0,"/cfmx/sif/iv/catalogos/Articulos.cfm","_self","Artículos","Artículos"]);
		stm_aix("p4i2","p1i0",[0,"Clasificaciones de Artículos","","",-1,-1,0,"/cfmx/sif/iv/catalogos/Clasificacion.cfm","_self","Clasificaciones de Artículos","Clasificaciones de Artículos"]);
		stm_aix("p4i3","p1i0",[0,"Tipos de Requisición","","",-1,-1,0,"/cfmx/sif/iv/catalogos/TRequisicion.cfm","_self","Tipos de Requisición","Tipos de Requisición"]);
		stm_aix("p4i4","p1i0",[0,"Impuestos","","",-1,-1,0,"/cfmx/sif/iv/catalogos/Impuestos.cfm","_self","Impuestos","Impuestos"]);
		stm_aix("p4i5","p1i0",[0,"Unidades","","",-1,-1,0,"/cfmx/sif/iv/catalogos/Unidades.cfm","_self","Unidades","Unidades"]);
		stm_aix("p4i6","p0i3",[6,1,"#000000"]);
		stm_aix("p4i7","p1i0",[0,"Cuentas por Requisición","","",-1,-1,0,"/cfmx/sif/iv/catalogos/CTipoRequisicion.cfm","_self","Cuentas por Requisición","Cuentas por Requisición"]);
		stm_aix("p4i8","p1i0",[0,"Cuentas de Inventario","","",-1,-1,0,"/cfmx/sif/iv/catalogos/CuentasInventario.cfm","_self","Cuentas de Inventario","Cuentas de Inventario"]);
		stm_ep();
		stm_aix("p0i7","p0i1",[]);
		stm_ep();
		stm_em();
		//-->
		</script>
</td>
  </tr>
</table>
<cfset monitoreo_modulo="SIFIV">
<cfinclude template="/sif/monitoreo.cfm">
