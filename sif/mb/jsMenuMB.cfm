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
stm_aix("p1i0","p0i0",[0,"Menú de SIF","","",-1,-1,0,"/cfmx/sif/indexSif.cfm","_self","Menú de SIF","Menú Principal del Sistema Financiero Integral","","",8,0,0,"","",0,0,0,0,1,"#ffffff",0,"#e8e9ea",0,"","",3,3,0,0,"#cccccc","#ffffff","#000000","#ff0000"]);
stm_aix("p1i1","p1i0",[0,"Menú de Bancos","","",-1,-1,0,"/cfmx/sif/mb/MenuMB.cfm","_self","Menú de Bancos","Menú de Bancos"]);
stm_ep();
stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
stm_aix("p0i2","p0i0",[0,"Operación ","","",-1,-1,0,"","_self","",""]);
stm_bpx("p2","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000","#ffffff","",2]);
stm_aix("p2i0","p1i0",[0,"Registro de Movimientos Bancarios","","",-1,-1,0,"/cfmx/sif/mb/operacion/listaMovimientos.cfm","_self","Registro de Movimientos Bancarios","Registro de Movimientos Bancarios"]);
stm_aix("p2i1","p1i0",[0,"Registro de Transferencias","","",-1,-1,0,"/cfmx/sif/mb/operacion/listaTransferencias.cfm","_self","Registro de Transferencias","Registro de Transferencias entre Cuentas Bancarias"]);
stm_aix("p2i2","p1i0",[0,"Registro de Estados de Cuenta","","",-1,-1,0,"/cfmx/sif/mb/operacion/listaEstadosCuenta.cfm","_self","Registro de Estados de Cuenta","Registro de Estados de Cuenta Bancarios"]);
stm_aix("p2i3","p0i1",[6,1,"#000000","",1,1]);
stm_aix("p2i4","p1i0",[0,"Conciliación Bancaria","","",-1,-1,0,"/cfmx/sif/mb/operacion/listaEstadosCuentaEnProceso.cfm","_self","Conciliación Bancaria","Conciliación Bancaria"]);
stm_ep();
stm_aix("p0i3","p2i3",[6,1,"transparent"]);
stm_aix("p0i4","p0i0",[0,"Consultas","","",-1,-1,0,"","_self","","","","",0,0,0,"","",0,0]);
stm_aix("p0i5","p0i1",[]);
stm_aix("p0i6","p0i2",[0,"Catálogos"]);
stm_bpx("p3","p1",[1,4,0,0,3,2,8,0,100,"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=0.28)",-2,"",-2,82,0,0,"#000000"]);
stm_aix("p3i0","p1i0",[0,"Bancos","","",-1,-1,0,"/cfmx/sif/mb/catalogos/Bancos.cfm","_self","Bancos","Bancos"]);
stm_aix("p3i1","p2i3",[]);
stm_aix("p3i2","p1i0",[0,"Tipos de Transacción","","",-1,-1,0,"/cfmx/sif/mb/catalogos/TiposTransaccion.cfm","_self","Tipos de Transacción","Tipos de Transacciones Bancarias"]);
stm_ep();
stm_aix("p0i7","p0i1",[]);
stm_ep();
stm_em();
//-->
</script>
</td>
  </tr>
</table>
<cfset monitoreo_modulo="SIFMB">
<cfinclude template="/sif/monitoreo.cfm">
