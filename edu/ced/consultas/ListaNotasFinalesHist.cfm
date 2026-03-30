<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
		<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
		<link href="../../css/edu.css" rel="stylesheet" type="text/css">
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

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top">
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
	  	  	<cfinclude template="../jsMenuCED.cfm">
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
				  <td width="2%"class="Titulo"><img  src="../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Informe Histrico de Notas Finales<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		
			
		
			
			<script language="JavaScript" type="text/JavaScript">  
				var periodos = new Array();					
				var periodosText = new Array();						
				var niveles = new Array();						
				var cursos = new Array();	
				var cursosText = new Array();
				var nivelesCursos= new Array();	
				var materias= new Array();	
				var materiasText = new Array();
				var nivelesMaterias= new Array();	
				
		
				
				
					function poneAdicionales(obj){
						var connVerAdicionales	= document.getElementById("verAdicionales");
					
						if(obj.checked)
							connVerAdicionales.style.display = "";
						else 
							connVerAdicionales.style.display = "none";
					}	
					
					function doConlis(f, opc) {
						if(opc == 1){	// Alumnos
							popUpWindow("conlisAlumnosHist.cfm?form=formNotaFinalHist"
									+"&NombreAl=Alumno"
									+"&Ecodigo=Ecodigo" 
									+"&Ncodigo=" + f.Ncodigo.value
									
									+"&Grupo=" + f.Grupo.value,250,200,300,350);
						}
					} 
					function doConlisCursoLec(f, opc) {
						if(opc == 1){	// Curso Lectivo
							window.open("conlisCursoLec.cfm?form=formNotaFinalHist"
									+"&SPEdescripcion=SPEdescripcion"
									+"&SPEcodigo=SPEcodigo"
									+"&PEcodigo=PEcodigo"
									+"&Ncodigo=Ncodigo",250,200,300,350);
						}
					} 
					
					function doConlisGrupos(f, opc) {
						if(opc == 1){	// Grupos
							window.open("conlisGrupos.cfm?form=formNotaFinalHist"
									+"&GRnombre=GRnombre"
									+"&Grupo=Grupo"
									+"&SPEcodigo="+ f.SPEcodigo.value
									+"&PEcodigo="+ f.PEcodigo.value
									+"&Ncodigo="+ f.Ncodigo.value,250,200,300,350);
						}
					} 
					
					function limpiar(obj) {
						obj.Ecodigo.value = '-1';
						obj.Alumno.value = '-- Todos --';
						obj.Grupo.value = '';
						obj.GRnombre.value = '';
						
					} 
					
					function validaConc(f) {
						if(f.Grupo.value == ''){
							alert('Debe elegir primero un grupo');			
							f.Grupo.focus();
						}
					}
				var popUpWin=0; 
				/*
				function popUpWindow(URLStr, left, top, width, height)
				{
				  if(popUpWin)
				  {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  //popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				  popUpWin = open(URLStr, 'popUpWin');
				}
				*/		 		
				function doConlisMateriaTabla() {
					popUpWindow("ConlisMateriaTabla.cfm?form=formNotaFinalHist"
					+"&Ncodigo="+document.formNotaFinalHist.Ncodigo.value
					//+"&SPEcodigo="+document.formNotaFinalHist.SPEcodigo.value
					+"&Grupo="+document.formNotaFinalHist.Grupo.value
					+"&cursos="+document.formNotaFinalHist.CursoTabla.value,250,100,650,500);
				}
			</script>
			<script language="JavaScript1.2">
				function CambiaIdioma(ctl) {
					ctl.form.submit();
				}
			</script>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> <cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
                    <cfinvoke 
			component="edu.Componentes.NavegaPrint" 
			method="Navega" 
			returnvariable="pListaNavegable">
                        <cfset vParam = "">
                      <cfif isdefined("form.btnGenerar")>
                        <cfset vParam = vParam  & "btnGenerar=" & #form.btnGenerar#>
                      </cfif>
                      <cfif isdefined("form.Grupo")>
                        <cfset vParam = vParam  & "&Grupo=" & #form.Grupo#>
                      </cfif>
                      <cfif isdefined("form.rdCortes")>
                        <cfset vParam = vParam  & "&rdCortes=" & #form.rdCortes#>
                        <cfif form.rdCortes EQ 'PxA'>
                          <cfset vParam = vParam  & "&imprime=1">
                        </cfif>
                      </cfif>
                      <cfif isdefined("form.TituloRep")>
                        <cfset vParam = vParam  & "&TituloRep=" & #form.TituloRep#>
                      </cfif>
					  <cfif isdefined("form.TituloProfClase")>
					  	<cfset vParam = vParam  & "&TituloProfClase=" & #form.TituloProfClase#>							
					  </cfif>
                      <cfif isdefined("form.FechaRep")>
                        <cfset vParam = vParam  & "&FechaRep=" & #form.FechaRep#>
                      </cfif>
					   <cfif isdefined("form.Ncodigo")>
                        <cfset vParam = vParam  & "&Ncodigo=" & #form.Ncodigo#>
                      </cfif>
                      <cfif isdefined("form.Ecodigo")>
                        <cfset vParam = vParam  & "&Ecodigo=" & #form.Ecodigo#>
                      </cfif>
                      <cfif isdefined("form.SPEcodigo")>
                        <cfset vParam = vParam  & "&SPEcodigo=" & #form.SPEcodigo#>
                      </cfif> 
					   <cfif isdefined("form.PEcodigo")>
                        <cfset vParam = vParam  & "&PEcodigo=" & #form.PEcodigo#>
                      </cfif> 
                      <cfif isdefined("form.ckPxC")>
                        <cfset vParam = vParam  & "&ckPxC=" & #form.ckPxC#>
                      </cfif>
                      <cfif isdefined("form.ckInci")>
                        <cfset vParam = vParam  & "&ckInci=" & #form.ckInci#>
                      </cfif>					  
                      <cfif isdefined("form.ckPM")>
                        <cfset vParam = vParam  & "&ckPM=" & #form.ckPM#>
                      </cfif>
					  <cfif isdefined("form.ckObs")>
                      	<cfset vParam = vParam  & "&ckObs=" & #form.ckObs#>
                      </cfif>					  
                      <cfif isdefined("form.ckA")>
                        <cfset vParam = vParam  & "&ckA=" & #form.ckA#>
                      </cfif>
                      <cfif isdefined("form.ckP")>
                         <cfset vParam = vParam  & "&ckP=" & #form.ckP#>
                      </cfif>
                      <cfif isdefined("form.ckD")>
                         <cfset vParam = vParam  & "&ckD=" & #form.ckD#>
                      </cfif>
                      <cfif isdefined("form.ckAD")>
                         <cfset vParam = vParam  & "&ckAD=" & #form.ckAD#>
                      </cfif>
                      <cfif isdefined("form.ckEst")>
                         <cfset vParam = vParam  & "&ckEst=" & #form.ckEst#>
                      </cfif>					  
                      <cfif isdefined("form.ckEsc")>
                         <cfset vParam = vParam  & "&ckEsc=" & #form.ckEsc#>
                      </cfif>
	                  <cfif isdefined("form.ckPG")>
                         <cfset vParam = vParam  & "&ckPG=" & #form.ckPG#>
                      </cfif>				  
	                  <cfif isdefined("form.ckPCF")>
                         <cfset vParam = vParam  & "&ckPCF=" & #form.ckPCF#>
                      </cfif>					  
                      <cfif isdefined("form.nomAdicio1")>
                         <cfset vParam = vParam  & "&nomAdicio1=" & #form.nomAdicio1#>
                      </cfif>
                      <cfif isdefined("form.nomAdicio2")>
                         <cfset vParam = vParam  & "&nomAdicio2=" & #form.nomAdicio2#>
                      </cfif>
                      <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaNotasFinalesHistImpr.cfm">
                      <cfinvokeargument name="Param" value="#vParam#">
                    </cfinvoke>
                    <cfelse>
	                    <cfinclude template="../../portlets/pNavegacionCED.cfm">
                  </cfif> 
				  </td>
              </tr>
            </table>
            <form name="formNotaFinalHist" method="post" action="ListaNotasFinalesHist.cfm" >
				<input name="CursoSel" type="hidden" value="" id="CursoSel">
				<input name="Ecodigo" type="hidden" value="<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'><cfoutput>#form.Ecodigo#</cfoutput><cfelse>-1</cfif>" id="Ecodigo">				
				<input name="ECcodigo" type="hidden" value="<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1'><cfoutput>#form.ECcodigo#</cfoutput><cfelse>-1</cfif>" id="ECcodigo">								

              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td width="28%" class="subTitulo">Curso Lectivo</td>
                  <td width="29%" class="subTitulo">Titulo del Reporte</td>
                  <td width="29%" class="subTitulo">Fecha de entrega</td>
                  <td width="14%" class="subTitulo">Firmas</td>
                </tr>
                <tr> 
                  <td><input name="SPEdescripcion" type="text" readonly="true" id="SPEdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.SPEdescripcion')><cfoutput>#form.SPEdescripcion#</cfoutput></cfif>">
                    <a href="#"><img src="../../Imagenes/Description.gif" alt="Lista de Curso Lectivo" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCursoLec(document.formNotaFinalHist, 1);limpiar(document.formNotaFinalHist);"></a>                  </td>
                  <td><input name="TituloRep" type="text" id="TituloRep" size="50" maxlength="100" onClick="this.select()" value="<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''><cfoutput>#form.TituloRep#</cfoutput></cfif>"></td>
                  <td> <a href="#"> 
                    <input name="FechaRep" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formNotaFinalHist.FechaRep');"> 
                    </a> </td>
                  <td nowrap> <input type="checkbox" name="ckPM" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckPM')>checked</cfif>>
                    Padre/Madre </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Grupo</td>
                  <td colspan="2" align="center" class="subTitulo">Visualizar 
                    en el reporte</td>
                  <td><input type="checkbox" name="ckA" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckA')>checked</cfif>>
                    Alumno </td>
                </tr>
                <tr> 
                  <td><input name="GRnombre" type="text" readonly="true" id="GRnombre" size="40" maxlength="80" value="<cfif isdefined('form.GRnombre')><cfoutput>#form.GRnombre#</cfoutput></cfif>">
                  <a href="#"><img src="../../Imagenes/Description.gif" alt="Lista de Grupo" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisGrupos(document.formNotaFinalHist, 1);"></a>
                  <input name="SPEcodigo" type="hidden" value="<cfif isdefined('form.SPEcodigo')><cfoutput>#form.SPEcodigo#</cfoutput></cfif>" id="SPEcodigo">
                  <input name="PEcodigo" type="hidden" value="<cfif isdefined('form.PEcodigo')><cfoutput>#form.PEcodigo#</cfoutput></cfif>" id="PEcodigo">
                  <input name="Ncodigo" type="hidden" value="<cfif isdefined('form.Ncodigo')><cfoutput>#form.Ncodigo#</cfoutput></cfif>" id="Ncodigo">
				  <input name="Grupo" type="hidden" value="<cfif isdefined('form.Grupo')><cfoutput>#form.Grupo#</cfoutput></cfif>" id="Grupo">
                  <input name="CursoTabla" type="hidden" value="" id="CursoTabla">
</td>
                  <td nowrap> <input name="ckPxC" type="checkbox" id="ckPxC" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckPxC')> checked</cfif>>
                    Notas por Periodo de Evaluaci&oacute;n</td>
                  <td><input type="checkbox" name="ckEsc" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckEsc')>checked</cfif>>
                    Tabla de Evaluaci&oacute;n &nbsp; </td>
                  <td><input type="checkbox" name="ckP" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckP')>checked</cfif>>
                    Profesor</td>
                </tr>
                <tr> 
                  <td class="subTitulo">Alumnos</td>
                  <td><input name="ckEst" type="checkbox" id="ckEst" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckEst')> checked</cfif>>
                    Estado de Promoci&oacute;n</td>
                  <td><input name="ckInci" type="checkbox" id="ckInci2" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckInci')> checked</cfif>>
                    Incidencias </td>
                  <td><input type="checkbox" name="ckD" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckD')>checked</cfif>>
                    Director</td>
                </tr>
                <tr>
                  <td class="subTitulo"><input name="Alumno" type="text" readonly="true" id="Alumno2" size="40" maxlength="80" value="<cfif isdefined('form.Alumno') and form.Alumno NEQ '-- Todos --'><cfoutput>#form.Alumno#</cfoutput><cfelse>-- Todos --</cfif>">
                    <a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis(document.formNotaFinalHist, 1);"> </a></td>
                  <td><input name="ckPCF" type="checkbox" id="ckPCF" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckPCF')> checked</cfif>>
                    Promedio por Curso</td>
                  <td><input name="ckObs" type="checkbox" id="ckObs" value="ckObs" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckObs')> checked</cfif>>
                    Observaciones</td>
                  <td nowrap> <input type="checkbox" name="ckAD" value="checkbox" onClick="javascript: poneAdicionales(this)" class="areaFiltro" <cfif isdefined('form.ckAD')>checked</cfif>>
                    Adicionales</td>
                </tr>
                <tr>
                  <td><strong>Idioma</strong></td>
                  <td><input name="ckPG" type="checkbox" id="ckPG" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckPG')> checked</cfif>>
                    Promedio Final</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="subTitulo"> <select name="Idioma" onChange="javascript:CambiaIdioma(this);">
							<option value="ES_CR" <cfif Session.Idioma EQ "ES_CR">selected</cfif>>Spanish (Modern)</option>
							<option value="EN" <cfif Session.Idioma EQ "EN">selected</cfif>>English (US)</option>
					  </select></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td nowrap><strong>Profesor de Clase</strong> </td>
                  <td align="center"><div align="left">
                  </div></td>
                  <td align="left">&nbsp; </td>
                  <td nowrap class="subTitulo">Corte de Impresi&oacute;n</td>
                </tr>
                <tr> 
                  <td rowspan="2" valign="top"><input name="TituloProfClase" type="text" id="TituloProfClase" size="35" maxlength="35" onClick="this.select()" value="<cfif isdefined('form.TituloProfClase') and form.TituloProfClase NEQ ''><cfoutput>#form.TituloProfClase#</cfoutput></cfif>"></td>
                  <td colspan="2" rowspan="2" align="center"> <div style="display: ;" id="verAdicionales"> 
                      <table width="78%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="18%" nowrap>Adicional 1</td>
                          <td width="82%"><input name="nomAdicio1" type="text" id="nomAdicio1" value="<cfif isdefined('form.nomAdicio1') and form.nomAdicio1 NEQ ''><cfoutput>#form.nomAdicio1#</cfoutput><cfelse>Adicional 1</cfif>" size="70" maxlength="80"></td>
                        </tr>
                        <tr> 
                          <td nowrap>Adicional 2</td>
                          <td><input name="nomAdicio2" type="text" id="nomAdicio2" value="<cfif isdefined('form.nomAdicio2') and form.nomAdicio2 NEQ ''><cfoutput>#form.nomAdicio2#</cfoutput><cfelse>Adicional 2</cfif>" size="70" maxlength="80"></td>
                        </tr>
                      </table>
                    </div></td>
                  <td nowrap> <input type="radio" class="areaFiltro" name="rdCortes" value="PC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    P gina Contnua</td>
                </tr>
                <tr> 
                  <td nowrap><input type="radio" class="areaFiltro" name="rdCortes" value="PxA" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA'>checked</cfif>>
                    P ginas por Alumno</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="3" align="center"><input name="btnGenerar" type="submit" id="btnGenerar" value="Reporte" ></td>
                </tr>
              </table>
              <cfif isdefined("form.btnGenerar")>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td> <cfinclude template="formNotasFinalesHist.cfm"> 
                    </td>
                  </tr>
                </table>
              </cfif>
            </form>
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
		
	poneAdicionales(document.formNotaFinalHist.ckAD);
	
//------------------------------------------------------------------------------------------											
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formNotaFinalHist");	
	
	objForm.SPEcodigo.required = true;
	objForm.SPEcodigo.description = "Curso Lectivo";
	objForm.Grupo.required = true;
	objForm.Grupo.description = "Grupo";	
	//objForm.Grupo.required = true;
	//objForm.Grupo.description = "Grupo";
		
//------------------------------------------------------------------------------------------					
</script>
		  
		  
          <!-- InstanceEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->