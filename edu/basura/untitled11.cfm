<cfinclude template="../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenuAST.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<script language="JavaScript" src="../js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      
		<table class="area" width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="25%" style="padding-left: 5px;">
					<a href="/jsp/sdc/org/agenda/">

						<img alt="Ir a agenda personal" src="/cfmx/edu/Imagenes/agenda.gif" width="32" height="25" align="ABSMIDDLE" border="0" />
					</a>
					<a href="/jsp/sdc/org/agenda/">
					12 de Agosto de 2003
					
					</a>
				</td>
				<td class="tituloAlterno" width="50%">
					
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp">Marielena Guardia  </a>
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp"><img alt="Ir a configuraci&oacute;n personal" src="/cfmx/edu/Imagenes/yo.gif" width="32" height="25" align="ABSMIDDLE" border="0" /></a>

					
				</td>
				<td align="right" width="25%" style="padding-right: 5px;">
					<a href="/cfmx/edu/buzon/">No tiene mensajes nuevos</a>
					<a href="/cfmx/edu/buzon/"><img alt="ir al buz&oacute;n" src="/cfmx/edu/Imagenes/email/e-mail.gif" height="25" align="ABSMIDDLE" border="0" /></a> 
				</td>
			</tr>
		</table>
	
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
		  	<cfset RolActual = 11>
			<cfset Session.RolActual = 11>
			<cfinclude template="../portlets/pEmpresas2.cfm">
		  </td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" -->
			  Asistencia
			<!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../portlets/pminisitio.cfm">
		  </td>
          <td valign="top" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" -->

  	    
<script type="text/javascript">
	var menuPrincipalOptions = new Array (

	new Array('Pago de facturas personales','/sdc/bpp/fac/index.jsp'),

	new Array('Administración del centro de estudio','/cfmx/edu/ced/MenuCED.cfm'),

	new Array('Apoyo familiar','/cfmx/edu/responsable/consultarActividades.cfm'),

	new Array('Asistencia','/cfmx/edu/asistencia/MenuAST.cfm'),

	new Array('Mi cuaderno de estudios','/cfmx/edu/est/consultarActividades.cfm'),

	new Array('Docencia','/cfmx/edu/docencia/MenuDOC.cfm'),

	new Array('Administración de Sitios','/cfmx/edu/minisitios/index.cfm'),

	new Array('Rendimiento académico','/cfmx/edu/director/consultas/consultarActividadesDIR.cfm'),

	new Array('Usuarios','/sdc/sec/afiliar/carta.jsp'),

	new Array('Solicitud de pasaportes','/sif/Tramites/consulta1.cfm'),

	new Array('Bienes Patrimoniales','/sdc/abp/'),

	new Array('Anuncios clasificados','/sdc/dc/'),

	new Array('Finanzas Personales','/sdc/fp/'),

	new Array('','')
	);
</script>


<table width='100%' border='0' cellspacing='0' cellpadding='0' >
  <tr>
    <td nowrap> 

 
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
stm_aix("p0i2","p0i0",[0,"Asistencia","","",-1,-1,0,"","_self","","Asistencia","","",8]);
stm_bpx("p2","p1",[1,4,0,0,2,2,8,0,100,"",-2,"",-2,50,0,0,"#000000","#ffffff","",2]);
stm_aix("p2i0","p1i0",[0,"Planificar Período","","",-1,-1,0,"/edu/asistencia/planearPeriodo.cfm","_self","Planificar Período","Planificar Período"]);
stm_aix("p2i1","p1i0",[0,"Evaluar Período","","",-1,-1,0,"/edu/asistencia/calificarEvaluaciones.cfm","_self","Evaluar Período","Evaluar Período","","",8]);
stm_aix("p2i2","p1i0",[0,"Evaluar Curso Final","","",-1,-1,0,"/edu/asistencia/calificarCurso.cfm","_self","Evaluar Curso Final","Evaluar Curso Final"]);
stm_aix("p2i3","p1i0",[0,"Incidencias y Comunicados","","",-1,-1,0,"/edu/asistencia/incidencias.cfm","_self","Incidencias y Comunicados","Incidencias y Comunicados"]);
stm_aix("p2i4","p1i0",[0,"Copia de Temarios y Evaluaciones","","",-1,-1,0,"/edu/asistencia/utilitarios/copiaTemaEval.cfm","_self","Copia de Temarios y Evaluaciones","Copia de Temarios y Evaluaciones"]);
stm_ep();
stm_ep();
stm_em();
//-->
</script>

</td>
  </tr>
</table>

      <!-- InstanceEndEditable -->	
		  </td>
        </tr>
      </table>
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="left" valign="top" nowrap></td>
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td valign="top" nowrap>
		<cfinclude template="/sif/menu.cfm">
	</td>
    <td valign="top" width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img  src="../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" -->
		    REGISTRO DE CALIFICACIONES Y EVALUACION DEL PERIODO
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		    
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="areaMenu">
  <tr align="left"> 
	<td><a href="/cfmx/edu" tabindex="-1">Educaci&oacute;n</a></td>
	<td>|</td>

	<td nowrap><a href="/cfmx/edu/asistencia/MenuAST.cfm" tabindex="-1">Asistencia</a></td>
	<td>|</td>
	<td width="100%"><a href="/cfmx/edu/asistencia/MenuAST.cfm" tabindex="-1">Regresar</a></td>
  </tr>
</table>

	
	

	
	

	
	
	
	
	

	
	

	
	

	
	

	
	

	
	


	
		
	
		
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        background-color: #FF0000;
        WIDTH: 20px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        display: none;
      }
      .txtPar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        border:0;
      }
      .txtImpar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        background-color:#D8E5F2;
        border:0;
      }
      .linEnc {
        background-color:#A9C6E1;
        height:38px; width:51px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncPrc {
        background-color:#A9C6E1;
        height:40px; width:51px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncProm {
        background-color:#A9C6E1;
        height:19px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : right;
      }
      .linEncEva {
        background-color:#A9C6E1;
        width:100%;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        text-align : center;
        vertical-align : middle;
      }
      .linPar {
		border: solid 1px #D8E5F2;
		height: 21px;
		font:  10px Verdana, Arial, Helvetica, sans-serif;
		wrap:  none;
      }
      .linImpar {
        background-color:#D8E5F2; 
		border: solid 1px #D8E5F2; 
		height: 21px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
    -->
    </style>
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>

<script language="JavaScript" src="/cfmx/edu/docencia/calificarEvaluaciones1_00.js"></script>
<script language="JavaScript" type="text/JavaScript">
    <!--
	
      var GvarRow1 = 5;
      var GvarRowN = 2;
      var GvarRowAlumno = -1;
      var GvarProIndex = 0;
      var GvarCurIndex = 0;
      var GvarPerIndex = 0;
      var GvarOrdIndex = 0;

      GvarValueAnt = "";
      GvarRowAnt = -1;

      // Uno por Concepto
      var GvarConceptos = new Array();
      
        GvarConceptos["C23"] = 10.00;
      
        GvarConceptos["C24"] = 10.00;
      
        GvarConceptos["C25"] = 20.00;
      
        GvarConceptos["C26"] = 35.00;
      
        GvarConceptos["C27"] = 10.00;
      
        GvarConceptos["C28"] = 10.00;
      
        GvarConceptos["C31"] = 5.00;
      
      var GvarConceptosN = 7;

      // Uno por Estudiante
      var GvarConceptosXEstudiantes = new Array();
      var GvarEstudiantesN = 10;

      // Uno por Calficacion
      var GvarComponentes = new Array(
      
            new objCalificacion("C26", 16.66,  5.83)
        
          , new objCalificacion("C26", 16.66,  5.83)
        
          , new objCalificacion("C26", 16.66,  5.83)
        
          , new objCalificacion("C27",100.00, 10.00)
        
          , new objCalificacion("C23", 50.00,  5.00)
        
          , new objCalificacion("C26", 16.66,  5.83)
        
          , new objCalificacion("C24",100.00, 10.00)
        
          , new objCalificacion("C23", 50.00,  5.00)
        
          , new objCalificacion("C26", 16.66,  5.83)
        
          , new objCalificacion("C31",100.00,  5.00)
        
          , new objCalificacion("C26", 16.70,  5.85)
        
          , new objCalificacion("C28",100.00, 10.00)
        
          , new objCalificacion("C25",100.00, 20.00)
        
        );
      var GvarComponentesN = GvarComponentes.length;
      var GvarPlaneado = true;
	  

      var GvarTablaMateria = "";

      function fnInicializarCalculos(LvarEst)
	  {
        GvarConceptosXEstudiantes[LvarEst] = new objConceptoXEstudiante (new Array(), 0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C23"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C24"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C25"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C26"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C27"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C28"] = new objCXE(0,0,0);
        
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C31"] = new objCXE(0,0,0);
        
	  }
    -->
    </script>
<form name="frmNotas" method="post" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
		
<table>
  <tr>
    <td>
      Profesor:
      <select name="cboProfesor" id="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option> 
          <option value="0">* Cursos sin Profesor</option>

        
          <option value="282" selected>Blanco  Lucrecia</option>
        
          <option value="286">Bolaños Rigioni Jose Pablo</option>
        
          <option value="27">Campbell Bernaby Eugenia</option>
        
          <option value="283">Castro Morales Nancy</option>
        
          <option value="306">Chaves Sarmiento Israel</option>
        
          <option value="22">Cruz Muñoz Aracelly</option>

        
          <option value="299">Cruz Romero Mario</option>
        
          <option value="20">Delgado Hidalgo Cinthya</option>
        
          <option value="163">Hernández Hernández Luisa María</option>
        
          <option value="309">Hurtado González Francisco Javier</option>
        
          <option value="176">Marenco Rojas Helen</option>
        
          <option value="23">Martín Liñeiro Barbara</option>

        
          <option value="29">Murillo Rivas Marta Eugenia</option>
        
          <option value="175">Ramírez Marín Oliver Elías</option>
        
          <option value="298">Revertér  Juan Antonio</option>
        
          <option value="179">Rimolo Baritti Ana María</option>
        
          <option value="24">Robles Brenes María del Rocío</option>
        
          <option value="19">Rodríguez Avila Margoth</option>

        
          <option value="284">Rojas Jiménez Andrea</option>
        
          <option value="303">Sequeira Avila César</option>
        
          <option value="280">Torres López Heizel</option>
        
          <option value="281">Vega  Gabriela</option>
        
          <option value="164">Villalobos Ellis Nory</option>
        
          <option value="28">Víquez Jiménez Rodrigo</option>

        
      </select>
      Curso:
      <select name="cboCurso" id="cboCurso" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
		
          <option value="5271" selected>Science Segundo Grado</option>
        
          <option value="5297">Science Tercer Grado</option>
        
          <option value="5306">Science Cuarto Grado</option>
        
          <option value="5326">Science Quinto Grado</option>

        
          <option value="5364">Science Séptimo Año</option>
        
          <option value="5386">Science Octavo Año</option>
        
      </select><br><br>

      

      Período:
      <select name="cboPeriodo" id="cboPeriodo" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value == "-999") 
			              fnLoadcalificarCurso();
						else
						  fnReLoad();'>
        
          <option value="23">Primer Trimestre</option>
        
          <option value="24" selected>Segundo Trimestre</option>

        
          <option value="25">Tercer Trimestre</option>
        			  
      </select>
	  
      Ordenamiento Componentes: 
      <select name="cboOrdenamiento" id="cboOrdenamiento" size="1" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
        <option value="0" selected>Cronológico</option>
        <option value="1">Por Concepto</option>
      </select>
	  
        <input type="hidden" name="txtRows" id="txtRows" value="10">

        <input type="hidden" name="txtCols" id="txtCols" value="13">
	  
	</td>
	<td align="center">
    
		<a href="javascript:a=window.open('reporteProgreso.cfm?N=1&PR=282&C=5271&E='+document.getElementById('tdCodigoAlumno').value+'&P=24', 'ReporteProgreso','left=50,top=10,scrollbars=yes,resiable=yes,width=700,height=550,alwaysRaised=yes','Reporte de Progreso');a.focus();"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Reporte de Progreso del Curso"></a>&nbsp;&nbsp;
	  
	</td>
  </tr>
</table>
      <br>
      <br>

    

<table border="0" width="100%">
<tr>
<td valign="top">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="150" valign="top">
		<div style="width:150px; overflow:hidden; border-right:1px solid #FFFFFF">
		<table id="tblEstudiantes" border="0" cellspacing="0" cellpadding="0">
		<tr>

			<td class="linEnc" style="text-align:left;">Estudiante</td>
			<td class="linEnc"></td>
		</tr>
		<tr id="trPrcC1" >
			<td class="linEncPrc" style="text-align:left;">Porcentajes por Concepto</td>
			<td class="linEncPrc"></td>
		</tr>
		<tr id="trPrcP1" >

			<td class="linEncProm" style="text-align:Left;">Contribución al Promedio</td>
			<td class="linEncProm"></td>
		</tr>
		<tr>
			<td class="linEncProm" style="text-align:Left;">Cerrar Evaluaci&oacute;n</td>
			<td class="linEncProm"></td>
		</tr>

		<tr class="tdInvisible">
			<td></td>
			<td></td>
		</tr>
		
		<tr>
			<td class="linPar" nowrap>Bello Andrade Isabella</td>
			<td><input type="hidden" name="txtEcodigo1" id="txtEcodigo1" value="1104"></td>
		</tr>

	
		<tr>
			<td class="linImpar" nowrap>Cerdas Delgado Mariana</td>
			<td><input type="hidden" name="txtEcodigo2" id="txtEcodigo2" value="264"></td>
		</tr>
	
		<tr>
			<td class="linPar" nowrap>Cordero Chavarría Mariel</td>
			<td><input type="hidden" name="txtEcodigo3" id="txtEcodigo3" value="1354"></td>
		</tr>

	
		<tr>
			<td class="linImpar" nowrap>Fonseca Rodríguez Marcelo</td>
			<td><input type="hidden" name="txtEcodigo4" id="txtEcodigo4" value="568"></td>
		</tr>
	
		<tr>
			<td class="linPar" nowrap>Giaconi Magdaleno Elio</td>
			<td><input type="hidden" name="txtEcodigo5" id="txtEcodigo5" value="674"></td>
		</tr>

	
		<tr>
			<td class="linImpar" nowrap>Olmos Nuñez Raymond</td>
			<td><input type="hidden" name="txtEcodigo6" id="txtEcodigo6" value="1316"></td>
		</tr>
	
		<tr>
			<td class="linPar" nowrap>Seiler Delgado Nicole</td>
			<td><input type="hidden" name="txtEcodigo7" id="txtEcodigo7" value="989"></td>
		</tr>

	
		<tr>
			<td class="linImpar" nowrap>Sobrado Mora Isabel</td>
			<td><input type="hidden" name="txtEcodigo8" id="txtEcodigo8" value="258"></td>
		</tr>
	
		<tr>
			<td class="linPar" nowrap>Ugarte Villalobos Federico</td>
			<td><input type="hidden" name="txtEcodigo9" id="txtEcodigo9" value="566"></td>
		</tr>

	
		<tr>
			<td class="linImpar" nowrap>Villegas Acosta Mariana</td>
			<td><input type="hidden" name="txtEcodigo10" id="txtEcodigo10" value="1308"></td>
		</tr>
	
		<tr id="trprm1">
			<td class="linEncProm" style="text-align:Left; font-weight:bold;" onDblClick="return fnVerPrms();">Promedio</td>
		</tr>
		<tr id="trprm1">

			<td style="height:20px;">&nbsp;</td>
		</tr>
		</table>
		</div>
		</td>
		<td id="divWidth1" valign="top" style="border: 0; padding: 0px; margin: 0px; height:100%;">
		
		<table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
		<tr>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: What do my bones and muscles do? ( 16.66%)">

				What do my bones and muscles do?</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: A heart beat ( 16.66%)">
				A heart beat</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: What is matter? ( 16.66%)">
				What is matter?</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo Extra Clase ( 10.00%), 
Evaluacion: Science Fair (100.00%)">
				Science Fair</div></td>

		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Quices ( 10.00%), 
Evaluacion: Quiz #1 ( 50.00%)">
				Quiz #1</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: What can we find out about liquids? ( 16.66%)">
				What can we find out about liquids?</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Parciales ( 10.00%), 
Evaluacion: Parcial Test (100.00%)">
				Parcial Test</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Quices ( 10.00%), 
Evaluacion: Quiz#2 ( 50.00%)">

				Quiz#2</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: What can we find out about gases? ( 16.66%)">
				What can we find out about gases?</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Actividad Integrada (  5.00%), 
Evaluacion: Field Trip (100.00%)">
				Field Trip</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trabajo en Clase ( 35.00%), 
Evaluacion: What happens when you mix matter? ( 16.70%)">
				What happens when you mix matter?</div></td>

		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Concepto ( 10.00%), 
Evaluacion: Concepto (100.00%)">
				Concepto</div></td>
		
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title="
Concepto: Trimestral ( 20.00%), 
Evaluacion: Trimestral test (100.00%)">
				Trimestral test</div></td>
					  
		</tr>
		<tr id="trPrcC2" class="linEncPrc">
		
			<td class="linEncPrc"> 16.66%<br>de<br> 35.00%</td>

		
			<td class="linEncPrc"> 16.66%<br>de<br> 35.00%</td>
		
			<td class="linEncPrc"> 16.66%<br>de<br> 35.00%</td>
		
			<td class="linEncPrc">100.00%<br>de<br> 10.00%</td>

		
			<td class="linEncPrc"> 50.00%<br>de<br> 10.00%</td>
		
			<td class="linEncPrc"> 16.66%<br>de<br> 35.00%</td>
		
			<td class="linEncPrc">100.00%<br>de<br> 10.00%</td>

		
			<td class="linEncPrc"> 50.00%<br>de<br> 10.00%</td>
		
			<td class="linEncPrc"> 16.66%<br>de<br> 35.00%</td>
		
			<td class="linEncPrc">100.00%<br>de<br>  5.00%</td>

		
			<td class="linEncPrc"> 16.70%<br>de<br> 35.00%</td>
		
			<td class="linEncPrc">100.00%<br>de<br> 10.00%</td>
		
			<td class="linEncPrc">100.00%<br>de<br> 20.00%</td>

					  
		</tr>
		<tr id="trPrcP2" class="linEncProm">
		
			<td class="linEncProm">  5.83%</td>
		
			<td class="linEncProm">  5.83%</td>
		
			<td class="linEncProm">  5.83%</td>
		
			<td class="linEncProm"> 10.00%</td>

		
			<td class="linEncProm">  5.00%</td>
		
			<td class="linEncProm">  5.83%</td>
		
			<td class="linEncProm"> 10.00%</td>
		
			<td class="linEncProm">  5.00%</td>
		
			<td class="linEncProm">  5.83%</td>

		
			<td class="linEncProm">  5.00%</td>
		
			<td class="linEncProm">  5.85%</td>
		
			<td class="linEncProm"> 10.00%</td>
		
			<td class="linEncProm"> 20.00%</td>
					  
		</tr>

		<tr class="linEncProm">
		
			<td class="linEncProm"> 
				<input name="chkCerrar1" id="chkCerrar1" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar1Ant" id="hdnCerrar1Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar2" id="chkCerrar2" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar2Ant" id="hdnCerrar2Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar3" id="chkCerrar3" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar3Ant" id="hdnCerrar3Ant" type="hidden" 
					value="0">

			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar4" id="chkCerrar4" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar4Ant" id="hdnCerrar4Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar5" id="chkCerrar5" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar5Ant" id="hdnCerrar5Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar6" id="chkCerrar6" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar6Ant" id="hdnCerrar6Ant" type="hidden" 
					value="0">

			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar7" id="chkCerrar7" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar7Ant" id="hdnCerrar7Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar8" id="chkCerrar8" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar8Ant" id="hdnCerrar8Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar9" id="chkCerrar9" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar9Ant" id="hdnCerrar9Ant" type="hidden" 
					value="0">

			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar10" id="chkCerrar10" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar10Ant" id="hdnCerrar10Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar11" id="chkCerrar11" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar11Ant" id="hdnCerrar11Ant" type="hidden" 
					value="0">
			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar12" id="chkCerrar12" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar12Ant" id="hdnCerrar12Ant" type="hidden" 
					value="0">

			</td>
		
			<td class="linEncProm"> 
				<input name="chkCerrar13" id="chkCerrar13" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar13Ant" id="hdnCerrar13Ant" type="hidden" 
					value="0">
			</td>
					  
		</tr>
		<tr class="tdInvisible">
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente1" id="txtECcomponente1" value="11756" class="tdInvisible">
					
			</td>

		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente2" id="txtECcomponente2" value="11757" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente3" id="txtECcomponente3" value="11813" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente4" id="txtECcomponente4" value="11819" class="tdInvisible">
					
			</td>

		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente5" id="txtECcomponente5" value="11815" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente6" id="txtECcomponente6" value="11814" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente7" id="txtECcomponente7" value="11816" class="tdInvisible">
					
			</td>

		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente8" id="txtECcomponente8" value="11817" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente9" id="txtECcomponente9" value="11818" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente10" id="txtECcomponente10" value="11820" class="tdInvisible">
					
			</td>

		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente11" id="txtECcomponente11" value="11821" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente12" id="txtECcomponente12" value="11823" class="tdInvisible">
					
			</td>
		
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente13" id="txtECcomponente13" value="11822" class="tdInvisible">
					
			</td>

					  
		</tr>
		
		<tr>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_1" id="txtNota1_1" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_2" id="txtNota1_2" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_3" id="txtNota1_3" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_4" id="txtNota1_4" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_5" id="txtNota1_5" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 88.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_6" id="txtNota1_6" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_7" id="txtNota1_7" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_8" id="txtNota1_8" maxlength="6"
				class="txtPar"

				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_9" id="txtNota1_9" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_10" id="txtNota1_10" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_11" id="txtNota1_11" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_12" id="txtNota1_12" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota1_13" id="txtNota1_13" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_1" id="txtNota2_1" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_2" id="txtNota2_2" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_3" id="txtNota2_3" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_4" id="txtNota2_4" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_5" id="txtNota2_5" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_6" id="txtNota2_6" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_7" id="txtNota2_7" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_8" id="txtNota2_8" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 95.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_9" id="txtNota2_9" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_10" id="txtNota2_10" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_11" id="txtNota2_11" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_12" id="txtNota2_12" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota2_13" id="txtNota2_13" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linPar"> 
			
			<input type="text" name="txtNota3_1" id="txtNota3_1" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_2" id="txtNota3_2" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_3" id="txtNota3_3" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_4" id="txtNota3_4" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_5" id="txtNota3_5" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 63.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_6" id="txtNota3_6" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_7" id="txtNota3_7" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 60.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_8" id="txtNota3_8" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 50.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_9" id="txtNota3_9" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_10" id="txtNota3_10" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_11" id="txtNota3_11" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_12" id="txtNota3_12" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota3_13" id="txtNota3_13" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_1" id="txtNota4_1" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_2" id="txtNota4_2" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_3" id="txtNota4_3" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_4" id="txtNota4_4" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_5" id="txtNota4_5" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 88.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_6" id="txtNota4_6" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_7" id="txtNota4_7" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_8" id="txtNota4_8" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_9" id="txtNota4_9" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_10" id="txtNota4_10" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_11" id="txtNota4_11" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_12" id="txtNota4_12" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota4_13" id="txtNota4_13" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linPar"> 
			
			<input type="text" name="txtNota5_1" id="txtNota5_1" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 70.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_2" id="txtNota5_2" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 70.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_3" id="txtNota5_3" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_4" id="txtNota5_4" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_5" id="txtNota5_5" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 75.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_6" id="txtNota5_6" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_7" id="txtNota5_7" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_8" id="txtNota5_8" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 90.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_9" id="txtNota5_9" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_10" id="txtNota5_10" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_11" id="txtNota5_11" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_12" id="txtNota5_12" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota5_13" id="txtNota5_13" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_1" id="txtNota6_1" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_2" id="txtNota6_2" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_3" id="txtNota6_3" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_4" id="txtNota6_4" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_5" id="txtNota6_5" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_6" id="txtNota6_6" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_7" id="txtNota6_7" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 97.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_8" id="txtNota6_8" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_9" id="txtNota6_9" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_10" id="txtNota6_10" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_11" id="txtNota6_11" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_12" id="txtNota6_12" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota6_13" id="txtNota6_13" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linPar"> 
			
			<input type="text" name="txtNota7_1" id="txtNota7_1" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 95.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_2" id="txtNota7_2" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_3" id="txtNota7_3" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_4" id="txtNota7_4" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_5" id="txtNota7_5" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_6" id="txtNota7_6" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_7" id="txtNota7_7" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 83.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_8" id="txtNota7_8" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_9" id="txtNota7_9" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_10" id="txtNota7_10" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_11" id="txtNota7_11" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_12" id="txtNota7_12" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota7_13" id="txtNota7_13" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_1" id="txtNota8_1" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_2" id="txtNota8_2" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_3" id="txtNota8_3" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_4" id="txtNota8_4" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_5" id="txtNota8_5" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_6" id="txtNota8_6" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_7" id="txtNota8_7" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 97.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_8" id="txtNota8_8" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 90.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_9" id="txtNota8_9" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_10" id="txtNota8_10" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_11" id="txtNota8_11" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			

			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_12" id="txtNota8_12" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota8_13" id="txtNota8_13" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linPar"> 
			
			<input type="text" name="txtNota9_1" id="txtNota9_1" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_2" id="txtNota9_2" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_3" id="txtNota9_3" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_4" id="txtNota9_4" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_5" id="txtNota9_5" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_6" id="txtNota9_6" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_7" id="txtNota9_7" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 90.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_8" id="txtNota9_8" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_9" id="txtNota9_9" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_10" id="txtNota9_10" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_11" id="txtNota9_11" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_12" id="txtNota9_12" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linPar"> 
			
			<input type="text" name="txtNota9_13" id="txtNota9_13" maxlength="6"
				class="txtPar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
		</tr>
<tr>

			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_1" id="txtNota10_1" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_2" id="txtNota10_2" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="100.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_3" id="txtNota10_3" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 70.00">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_4" id="txtNota10_4" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_5" id="txtNota10_5" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_6" id="txtNota10_6" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_7" id="txtNota10_7" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 70.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_8" id="txtNota10_8" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value=" 80.00">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_9" id="txtNota10_9" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_10" id="txtNota10_10" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">

			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_11" id="txtNota10_11" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_12" id="txtNota10_12" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>
			
			<td class="linImpar"> 
			
			<input type="text" name="txtNota10_13" id="txtNota10_13" maxlength="6"
				class="txtImpar"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				style="border=1px solid #CCCCCC;;"
				value="">
			
			</td>

			
                        </tr>
                        <tr id="trPrm2">
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>

						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>

						  
                          <td class="linEncProm">0.00</td>
						  
                          <td class="linEncProm">0.00</td>
						  
                        </tr>
                      </table>
		
                </td>
                <td width="102" valign="top">
                  <table id="tblPromedios" border="0" cellspacing="0" cellpadding="0">
                    <tr>

                      <td class="linEnc" width="101">Ganado</td>
                      <td class="linEnc" width="101">Progreso</td>
                      <td class="linEnc" width="101">Ajuste</td>
                    </tr>
                    <tr id="trPrcC3">
                      <td class="linEncPrc" width="101">&nbsp;</td>
                      <td class="linEncPrc" width="101">&nbsp;</td>

                      <td class="linEncPrc" width="101">&nbsp;</td>
                    <tr id="trPrcP3">
                      <td class="linEncProm" width="101">&nbsp;</td>
                      <td class="linEncProm" width="101">&nbsp;</td>
                      <td class="linEncProm" width="101">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="linEncProm" colspan="3" align="center" nowrap> Cerrar Per&iacute;odo: 
                        <input name="chkCerrarPeriodo" id="chkCerrarPeriodo" type="checkbox"
                               class="linEncProm" style="border:0px"
                               value="1"
                               onClick="fnCerrarPeriodo();"> 
                        <input name="hdnCerrarPeriodoAnt" id="hdnCerrarPeriodoAnt" type="hidden"
                               value="0">

                        <input name="hdnCursoCerrado" id="hdnCursoCerrado" type="hidden"
                               value="0">
					  </td>
                    </tr>
                    <tr class="tdInvisible">
                      <td></td>
                      <td></td>
                      <td>
                         
					  </td>
                    </tr>

					
                  
                    <tr class="linPar">
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtGanado1" id="txtGanado1"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtProgreso1" id="txtProgreso1"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtAjuste1" id="txtAjuste1"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value=" 50.00">

 					  </td>
                    
                    </tr>
                  
                    <tr class="linImpar">
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtGanado2" id="txtGanado2"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtProgreso2" id="txtProgreso2"
                                readonly
                                value="0">
					  </td>

                    
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtAjuste2" id="txtAjuste2"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value=" 90.00">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linPar">
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtGanado3" id="txtGanado3"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linPar">

                         <input type="text" class="txtPar" 
						        name="txtProgreso3" id="txtProgreso3"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtAjuste3" id="txtAjuste3"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value=" 50.00">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linImpar">
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtGanado4" id="txtGanado4"
                                readonly
                                value="0">

					  </td>
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtProgreso4" id="txtProgreso4"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtAjuste4" id="txtAjuste4"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linPar">

                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtGanado5" id="txtGanado5"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtProgreso5" id="txtProgreso5"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtAjuste5" id="txtAjuste5"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>

                    
                    </tr>
                  
                    <tr class="linImpar">
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtGanado6" id="txtGanado6"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtProgreso6" id="txtProgreso6"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linImpar">

                         <input type="text" class="txtImpar" 
						        name="txtAjuste6" id="txtAjuste6"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linPar">
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtGanado7" id="txtGanado7"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtProgreso7" id="txtProgreso7"
                                readonly
                                value="0">

					  </td>
                    
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtAjuste7" id="txtAjuste7"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linImpar">
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtGanado8" id="txtGanado8"
                                readonly
                                value="0">
					  </td>

                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtProgreso8" id="txtProgreso8"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtAjuste8" id="txtAjuste8"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>
                    
                    </tr>
                  
                    <tr class="linPar">
                      <td width="101" class="linPar">

                         <input type="text" class="txtPar" 
						        name="txtGanado9" id="txtGanado9"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtProgreso9" id="txtProgreso9"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linPar">
                         <input type="text" class="txtPar" 
						        name="txtAjuste9" id="txtAjuste9"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">
 					  </td>
                    
                    </tr>

                  
                    <tr class="linImpar">
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtGanado10" id="txtGanado10"
                                readonly
                                value="0">
					  </td>
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtProgreso10" id="txtProgreso10"
                                readonly
                                value="0">
					  </td>
                    
                      <td width="101" class="linImpar">
                         <input type="text" class="txtImpar" 
						        name="txtAjuste10" id="txtAjuste10"
                                Style="border=1px solid #CCCCCC;"
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="">

 					  </td>
                    
                    </tr>
                  
                    <tr id="trprm3">
                      <td class="linEncProm" colspan="3" style="text-align=center; font-weight:bold; color:#0000FF;">0</td>
                    </tr>
                  </table>
                </td>
              </tr>

            </table>
          </td>
          <td></td>
          <td valign="top"><input name="tdCodigoAlumno" id="tdCodigoAlumno" type="hidden" value="-1">
        <table id="tblConceptos" border="0" cellspacing="0" cellpadding="0" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" width="350" colspan="6" style="border-Bottom: 1px solid #FFFFFF; text-align:left; font-size: 14px; ">Estudiante</td>
          </tr>
        
          <tr class="linEncEva"> 
            <td align="center" style="border-right: 1px solid #FFFFFF"> <p align="left">

			  <b>Concepto de Evaluacion</b></p></td>
            <td align="center" colspan="4" class="linEncProm"> <p align="center">
			  <b>Contribucion al Progreso</b> </td>
            <td align="center" class="linEncProm" rowspan="2"> <p align="center">
			<b>Progreso</b></p></td>
          </tr>

          <tr class="linEncEva">
            <td align="center" style="border-right: 1px solid #FFFFFF">&nbsp;</td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;"
			    title="Ganado = Sumatoria por Concepto(Nota X Peso de la Evaluacion)"> 
			  <b>Ganado&nbsp;</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;"
			    title="Evaluado = Sumatoria por Concepto(Peso de la Evaluacion con nota)"> 
              <b>Evaluado</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;" 
			    title="Contribucion = Ganado / Evaluado"> 
              <b>Contribuc.</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;" 
			    title="%Concepto = Porcentaje asignado al Concepto de Evaluacion (en negrita aparecen los que fueron evaluados)"> 
              <b>%Concepto</b></td>

          </tr>
          
			  <tr class="linPar"> 
				<td rowspan="2">Quices&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">10.00</td>

				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linPar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>

		  
			  <tr class="linImpar"> 
				<td rowspan="2">Parciales&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">10.00</td>
				<td class="txtPar" align="right">&nbsp;</td>

			  </tr>
			  <tr class="linImpar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>
		  
			  <tr class="linPar"> 
				<td rowspan="2">Trimestral&nbsp;</td>

				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">20.00</td>
				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linPar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>

				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>
		  
			  <tr class="linImpar"> 
				<td rowspan="2">Trabajo en Clase&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>

				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">35.00</td>
				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linImpar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>

				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>
		  
			  <tr class="linPar"> 
				<td rowspan="2">Trabajo Extra Clase&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>

				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">10.00</td>
				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linPar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>

				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>
		  
			  <tr class="linImpar"> 
				<td rowspan="2">Concepto&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>

				<td class="txtPar" align="right">10.00</td>
				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linImpar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>

			  </tr>
		  
			  <tr class="linPar"> 
				<td rowspan="2">Actividad Integrada&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">5.00</td>

				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="linPar"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>

		  
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Obtenido</td>
            <td align="right" 
title="Total Ganado = Sumatoria(Ganado X %Concepto), 
es decir, es la contribucion ponderada de Calificaciones Ganadas de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total Evaluado = Sumatoria(Evaluado X %Concepto), 
es decir, es la contribucion ponderada de Calificaciones Evaluadas de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total Contribucion = Sumatoria(Contribucion X %Concepto), 
es decir, es la contribucion ponderada de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total %Conceptos Evaluados = Sumatoria(%Concepto con Evaluaciones)" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Progreso Periodo = Total Contribucion / Total %Conceptos Evaluados, 
es decir, es el promedio ponderado de Progresos de cada Concepto de Evaluacion" style="color: #0000FF">&nbsp;</td>
          </tr>
          		   
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Ajuste</td>

            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          
            <td align="center" style="color: #0000FF;" title="Ajuste digitado por el profesor al final del periodo.">&nbsp;</td>
		  
          </tr>
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Asignado</td>
            <td align="center" colspan="4" nowrap width=202 style="color: #0000FF; font-weight: bold; overflow:hidden;">&nbsp;</td>

            <td align="center" style="font-weight:bold; color: #0000FF; font-weight: bold;"
			    title="Progreso Asignado = Si hay ajuste: Ajuste, si no: Progreso.">&nbsp;</td>
          </tr>
	    
        <tr>
          <td valign="middle" colspan="3">
            Visualizar:
          </td>
            <td valign="middle" colspan="4">
            Digitar por:
          </td>
        </tr>

        <tr>
            <td valign="top" colspan="3"> <p> 
				<input type="hidden" name="hdnChkPorcentajesXConcepto" value="">
                <input type="checkbox" name="chkPorcentajesXConcepto" id="chkPorcentajesXConcepto" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      checked
                      onClick="fnPorcentajes(this,event,'C');" value="1">
                Porcentajes por Concepto<br>
				<input type="hidden" name="hdnChkPorcentajesXPromedio" value="">
                <input type="checkbox" name="chkPorcentajesXPromedio" id="chkPorcentajesXPromedio" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      checked
                       onClick="fnPorcentajes(this,event,'P');" value="1">
                Contribuci&oacute;n al Promedio <br>

				<input type="hidden" name="hdnChkPromedioXComponente" value="">
                <input type="checkbox" name="chkPromedioXComponente" id="chkPromedioXComponente" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      checked
                       onClick="fnPromedio(this,event);" value="1">
                Promedios por Componente<br>
				<input type="hidden" name="hdnChkCalcular" value="">
                <input type="checkbox" name="chkCalcular" id="chkCalcular" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      
                      onClick="fnChkCalcular();" value="1">
                Calcular en Línea </p>
              </td>
            <td valign="top" colspan="4">

            <select name="chkXAlumno" id="chkXAlumno" size="1" 
			        style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;">
              <option value="false" selected>Calificacion</option>
              <option value="true">Alumno</option>
            </select>
          </td>
        </tr>
      </table>
	    <input name="btnGrabar" id="btnGrabar" type="submit" value="Guardar" disabled onClick="if (!document.getElementById('chkCalcular').checked) fnProcesoInicial();">

        <input name="chkDesecharCambios" id="chkDesecharCambios" type="checkbox" value="1" checked onClick="document.frmNotas.btnGrabar.disabled=document.frmNotas.chkDesecharCambios.checked;"> Desechar Cambios
		</td>
        </tr>
      </table>
    <br>
    <br>
    </form>
    <script type="text/javascript">fnProcesoInicial();</script>

  		  <!-- InstanceEndEditable -->
		  </td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table>
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
