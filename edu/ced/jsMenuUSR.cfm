<cfinclude template="../Utiles/queryMenu.cfm">
<!--- <script id="Sothink Widgets:PageletServer.DynamicMenu" type="text/javascript" language="JavaScript1.2" src="/cfmx/edu/js/DHTMLMenu3.5/stm31.js"></script> --->
<table width='100%' border='0' cellspacing='0' cellpadding='0' >
  <tr>
    <td nowrap> 

<!--- 
<script type="text/javascript" language="JavaScript1.2">
<!--
beginSTM("exnvfhr","static","0","0","none","true","true","310","150","100","100","/edu/js/DHTMLMenu3.5/","blank.gif");
beginSTMB("auto","0","0","horizontally","arrow_r.gif","7","7","0","2","#a0a0ba","","tiled","#a0a0ba","1","solid","0","Normal","50","8","0","7","7","0","0","0","#000000","false","#a0a0ba","#a0a0ba","#a0a0ba","none");
appendSTMI("false","Menú&nbsp;Principal","left","middle","","","-1","-1","0","normal","#a0a0ba","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","5","0","0","Menú&nbsp;Principal","","_self","Verdana","8pt","#ffffff","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","1","solid","#a0a0ba","#a0a0ba","#666666","#666666","#a0a0ba","#a0a0ba","#666666","#666666","Menú Principal","","","tiled","tiled");
beginSTMB("auto","0","0","vertically","arrow_r.gif","0","0","0","3","#ffffff","","tiled","#000000","1","solid","0","Normal","50","0","0","0","0","0","0","0","#7f7f7f","false","#000000","#000000","#000000","none");
for (var contador=0; contador<menuPrincipalOptions.length-1; contador++) {
  appendSTMI("false",menuPrincipalOptions[contador][0],"left","middle","","","-1","-1","0","normal",
  "transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0",
  menuPrincipalOptions[contador][0],menuPrincipalOptions[contador][1],"_self","Verdana","8pt","#000000","normal",
  "normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff",
  "#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff",
  menuPrincipalOptions[contador][0],"","","tiled","tiled");
//appendSTMI("false","Menú&nbsp;de&nbsp;Administración&nbsp;del&nbsp;Centro&nbsp;de&nbsp;Estudio","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0","Menú&nbsp;de&nbsp;Administración&nbsp;del&nbsp;Centro&nbsp;de&nbsp;Estudio","/edu/ced/MenuCED.cfm","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Menú de Administración del Centro de Estudio","","","tiled","tiled");
}
endSTMB();
appendSTMI("false","Menu&nbsp;Item&nbsp;1","left","middle","","","-1","-1","0","sepline","transparent","#000099","blank.gif","1","-1","-1","","","-1","-1","0","","","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","","","","tiled","tiled");
appendSTMI("false","Usuarios","left","middle","","","-1","-1","0","normal","#a0a0ba","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","8","0","0","Usuarios","","_self","Verdana","8pt","#ffffff","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","1","solid","#a0a0ba","#a0a0ba","#666666","#666666","#a0a0ba","#a0a0ba","#666666","#666666","Usuarios","","","tiled","tiled");
beginSTMB("auto","0","0","vertically","arrow_r.gif","0","0","3","2","#ffffff","","tiled by y","#000000","1","solid","0","Fade","35","8","0","0","0","0","0","0","#000000","false","#000000","#000000","#000000","none");
appendSTMI("false","Preparar&nbsp;cartas&nbsp;de&nbsp;afiliación","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0","Preparar&nbsp;cartas&nbsp;de&nbsp;afiliación","/edu/ced/seleccion.cfm","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Preparar cartas de afiliación","","","tiled","tiled");
appendSTMI("false","Reimpresión&nbsp;de&nbsp;cartas","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","8","0","0","Reimpresión&nbsp;de&nbsp;cartas","/edu/ced/seleccion.cfm?buscar=4","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Reimpresión de cartas","","","tiled","tiled");
appendSTMI("false","Verificación&nbsp;de&nbsp;usuarios","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0","Verificación&nbsp;de&nbsp;usuarios","/edu/ced/seleccion.cfm?buscar=5","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Verificación de usuarios","","","tiled","tiled");
appendSTMI("false","Reenvío&nbsp;de&nbsp;contraseñas","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0","Reenvío&nbsp;de&nbsp;contraseñas","/edu/ced/seleccion.cfm?buscar=8","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Reenvío de contraseñas","","","tiled","tiled");
appendSTMI("false","Consulta&nbsp;de&nbsp;usuarios","left","middle","","","-1","-1","0","normal","transparent","#a0a0ba","","1","-1","-1","blank.gif","blank.gif","-1","-1","0","Consulta&nbsp;de&nbsp;usuarios","/edu/ced/seleccion.cfm?buscar=3","_self","Verdana","8pt","#000000","normal","normal","none","Verdana","8pt","#ffffff","normal","normal","none","0","solid","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","#ffffff","Consulta de usuarios","","","tiled","tiled");
endSTMB();
endSTMB();
endSTM();
//-->
</script>
 --->

<script type="text/javascript" language="JavaScript1.2">
<!--
stm_bm(["exnvfhr",400,"/edu/js/DHTMLMenu/","blank.gif",0,"","",0,1,50,50,50,1,0,0]);
stm_bp("p0",[0,4,0,0,0,2,8,7,100,"",-2,"",-2,90,0,0,"#000000","#a0a0ba","",3,1,1,"#a0a0ba"]);
stm_ai("p0i0",[0,"Menú Principal","","",-1,-1,0,"","_self","","Menú Principal","","",5,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#a0a0ba",0,"#a0a0ba",0,"","",3,3,1,1,"#a0a0ba","#666666","#ffffff","#ffffff","8pt Verdana","8pt Verdana",0,0]);
stm_bp("p1",[1,4,0,0,2,2,0,0,100,"",-2,"",-2,50,0,0,"#7f7f7f","#ffffff","",3,1,1,"#000000"]);
for (var contador=0; contador<menuPrincipalOptions.length-1; contador++) {
	stm_aix("p1i"+contador,"p0i0",[0,menuPrincipalOptions[contador][0],"","",-1,-1,0,menuPrincipalOptions[contador][1],"_self",menuPrincipalOptions[contador][0],menuPrincipalOptions[contador][0],"","",0,0,0,"","",0,0,0,0,1,"#ffffff",1,"#a0a0ba",0,"","",3,3,0,0,"#ffffff","#ffffff","#000000"]);
}
stm_ep();
stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
stm_aix("p0i2","p0i0",[0,"Usuarios","","",-1,-1,0,"","_self","","Usuarios","","",8]);
stm_bpx("p2","p1",[1,4,0,0,2,2,8,0,100,"",-2,"",-2,50,0,0,"#000000","#ffffff","",2]);
stm_aix("p2i0","p1i0",[0,"Preparar cartas de afiliación","","",-1,-1,0,"/edu/ced/seleccion.cfm","_self","Preparar cartas de afiliación","Preparar cartas de afiliación"]);
stm_aix("p2i1","p1i0",[0,"Reimpresión de cartas","","",-1,-1,0,"/edu/ced/seleccion.cfm?buscar=4","_self","Reimpresión de cartas","Reimpresión de cartas","","",8]);
stm_aix("p2i2","p1i0",[0,"Verificación de usuarios","","",-1,-1,0,"/edu/ced/seleccion.cfm?buscar=5","_self","Verificación de usuarios","Verificación de usuarios"]);
stm_aix("p2i3","p1i0",[0,"Reenvío de contraseñas","","",-1,-1,0,"/edu/ced/seleccion.cfm?buscar=8","_self","Reenvío de contraseñas","Reenvío de contraseñas"]);
stm_aix("p2i4","p1i0",[0,"Consulta de usuarios","","",-1,-1,0,"/edu/ced/seleccion.cfm?buscar=3","_self","Consulta de usuarios","Consulta de usuarios"]);
stm_ep();
stm_ep();
stm_em();
//-->
</script>

</td>
  </tr>
</table>
<cfset monitoreo_modulo="EDU USR">
<cfinclude template="../monitoreo.cfm">
