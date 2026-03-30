<cfreturn>
<cfinclude template="../Utiles/queryMenu.cfm">
<table width='100%' border='0' cellspacing='0' cellpadding='0' >
  <tr>
	<td nowrap> 
		
	<script type="text/javascript" language="JavaScript1.2">
	<!--
	stm_bm(["exnvfhr",400,"/cfmx/edu/js/DHTMLMenu/","blank.gif",0,"","",0,1,50,50,50,1,0,0]);
	stm_bp("p0",[0,4,0,0,0,2,8,7,100,"",-2,"",-2,90,0,0,"#000000","#a0a0ba","",3,1,1,"#a0a0ba"]);
	stm_ai("p0i0",[0,"Menú Principal","","",-1,-1,0,"","_self","","Menú Principal","","",5,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#a0a0ba",0,"#a0a0ba",0,"","",3,3,1,1,"#a0a0ba","#666666","#ffffff","#ffffff","8pt Verdana","8pt Verdana",0,0]);
	stm_bp("p1",[1,4,0,0,2,2,0,0,100,"",-2,"",-2,50,0,0,"#7f7f7f","#ffffff","",3,1,1,"#000000"]);
	for (var contador=0; contador<menuPrincipalOptions.length-1; contador++) {
		stm_aix("p1i"+contador,"p0i0",[0,menuPrincipalOptions[contador][0],"","",-1,-1,0,menuPrincipalOptions[contador][1],"_self",menuPrincipalOptions[contador][0],menuPrincipalOptions[contador][0],"","",0,0,0,"","",0,0,0,0,1,"#ffffff",1,"#a0a0ba",0,"","",3,3,0,0,"#ffffff","#ffffff","#000000"]);
	}
	stm_ep();
	stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
	stm_aix("p0i2","p0i0",[0,"Consultas","","",-1,-1,0,"","_self","","Consultas","","",8]);
	stm_bpx("p2","p1",[1,4,0,0,2,2,8,0,100,"",-2,"",-2,50,0,0,"#000000","#ffffff","",2]);
	stm_aix("p2i0","p1i0",[0,"Planes de Estudio por Profesor","","",-1,-1,0,"/cfmx/edu/director/consultas/consultarActividadesDIR.cfm","_self","Planes de Estudio por Profesor","Planes de Estudio por Profesor"]);
	stm_aix("p2i1","p1i0",[0,"Plan de Estudio por Estudiante","","",-1,-1,0,"/cfmx/edu/director/consultas/consultarActividadesEST.cfm","_self","Plan de Estudio por Estudiante","Plan de Estudio por Estudiante","","",8]);
	stm_ep();
	stm_ep();
	stm_em();
	//-->
	</script>

	</td>
  </tr>
</table>
<cfset monitoreo_modulo="EDU DIR">
<cfinclude template="../monitoreo.cfm">
