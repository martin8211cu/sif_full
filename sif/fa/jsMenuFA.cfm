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
stm_aix("p1i1","p1i0",[0,"Menú de Facturación","","",-1,-1,0,"/cfmx/sif/fa/MenuFA.cfm","_self","Menú de Facturación","Menú de Facturación"]);
stm_ep();
stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
stm_aix("p0i2","p0i0",[0,"Operación ","","",-1,-1,0,"","_self","",""]);
stm_bpx("p2","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000","#ffffff","",2]);
stm_aix("p2i0","p1i0",[0,"Registro de Transacciones","","",-1,-1,0,"/cfmx/sif/fa/operacion/listaTransaccionesFA.cfm","_self","Registro de Transacciones","Registro de Transacciones"]);
stm_ep();
stm_aix("p0i3","p0i1",[6,1,"transparent","",1,1]);
stm_aix("p0i4","p0i0",[0,"Consultas","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0]);
stm_aix("p0i5","p0i1",[]);
stm_aix("p0i6","p0i2",[0,"Catálogos"]);
stm_bpx("p3","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000"]);
stm_aix("p3i0","p1i0",[0,"Cajas","","",-1,-1,0,"/cfmx/sif/fa/catalogos/Cajas.cfm","_self","Cajas","Cajas"]);
stm_aix("p3i1","p1i0",[0,"Tipos de Transacción x Caja","","",-1,-1,0,"/cfmx/sif/fa/catalogos/TipoTransaccionCaja.cfm","_self","Tipos de Transacción x Caja","Tipos de Transacción x Caja"]);
stm_aix("p3i2","p1i0",[0,"Talonarios","","",-1,-1,0,"/cfmx/sif/fa/catalogos/Talonarios.cfm","_self","Talonarios","Talonarios"]);
stm_aix("p3i3","p1i0",[0,"Vendedores","","",-1,-1,0,"/cfmx/sif/fa/catalogos/Vendedores.cfm","_self","Vendedores","Vendedores"]);
stm_aix("p3i4","p1i0",[0,"Lista de Precios","","",-1,-1,0,"/cfmx/sif/fa/catalogos/listaLPrecios.cfm","_self","Lista de Precios","Lista de Precios"]);
stm_ep();
stm_aix("p0i7","p0i1",[]);
stm_ep();
stm_em();
//-->
</script>
</td>
  </tr>
</table>
<cfset monitoreo_modulo="SIFFA">
<cfinclude template="/sif/monitoreo.cfm">
