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
            temarios y evaluaciones por curso<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" --> 
            <cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
				set nocount on 
					select convert(varchar, a.Ncodigo) + '|' 
							+ convert(varchar, b.PEcodigo) + '|' 
							+ convert(varchar, c.SPEcodigo) as Codigo
						, a.Ndescripcion 
							+ ' : ' + b.PEdescripcion 
							+ ' : ' + c.SPEdescripcion as Descripcion 
					from Nivel a
							, PeriodoEscolar b
							, SubPeriodoEscolar c
							, PeriodoVigente 
					d where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and a.Ncodigo = b.Ncodigo 
						and b.PEcodigo = c.PEcodigo 
						and a.Ncodigo = d.Ncodigo 
						and b.PEcodigo = d.PEcodigo 
						and c.SPEcodigo = d.SPEcodigo 
					order by a.Norden 
				set nocount off 
            </cfquery>
			
           <!---  <cfquery datasource="#Session.Edu.DSN#" name="rsProfesores">
				select (convert(varchar,a.persona) + '|' + convert(varchar,Splaza)) as persona
					, (Papellido1 + ' ' 
					+ Papellido2 + ','
					+ Pnombre) as nombre 
				from 	PersonaEducativo a
						, Staff b 
				where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.persona=b.persona 
					and a.CEcodigo=b.CEcodigo 
					and b.retirado = 0 
					and b.autorizado = 1 
				order by nombre 
            </cfquery> --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsProfesores">
				select  distinct (convert(varchar,a.persona) + '|' + convert(varchar,b.Splaza)+ '|' + convert(varchar,pv.Ncodigo)) as persona
					, (Papellido1 + ' ' 
					+ Papellido2 + ','
					+ Pnombre) as nombre 
				from 	PersonaEducativo a
						, Staff b 
						, Curso c
						, PeriodoVigente pv
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and b.retirado = 0 
					and b.autorizado = 1
					and a.persona=b.persona 
					and a.CEcodigo=b.CEcodigo 
					and a.CEcodigo=c.CEcodigo 
					and b.CEcodigo=c.CEcodigo 
					and b.Splaza = c.Splaza
					and c.PEcodigo=pv.PEcodigo
					and c.SPEcodigo=pv.SPEcodigo

				order by nombre
			</cfquery>
            <cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
				select 	(convert(varchar,Ccodigo) + '|' +
							convert(varchar,Splaza)+ '|' +
							convert(varchar, c.PEcodigo) + '|' +
							convert(varchar, c.SPEcodigo)
						) as Codigo
						,(Mnombre + '' + GRnombre) as Nombre
				from Curso c, PeriodoVigente pv, Materia m, Grupo gr
				where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.PEcodigo=pv.PEcodigo
					and c.SPEcodigo=pv.SPEcodigo
					and Splaza is not null
					and c.Mconsecutivo=m.Mconsecutivo
					and c.GRcodigo=gr.GRcodigo
					and c.PEcodigo=gr.PEcodigo
					and c.SPEcodigo=gr.SPEcodigo
				Order by Ccodigo, Nombre
            </cfquery>

			<cfquery datasource="#Session.Edu.DSN#" name="rsPerEval">
				select (convert(varchar,Ncodigo) + '|'  + convert(varchar,PEcodigo)) as codigo, PEdescripcion 
				from PeriodoEvaluacion
				where Ncodigo is not null
				order by PEorden
			</cfquery>		

			<script language="JavaScript" type="text/javascript">
				var cursostext = new Array();
				var cursos = new Array();	
				var perEvaltext = new Array();
				var perEval = new Array();				
				var perEvalNivel = new Array();
				var profCursos = new Array();					
				var PEcodCursos = new Array();					
				var SPEcodCursos = new Array();
				var docentetext = new Array();
				var docente = new Array();
				var plaza = new Array();
				var Nivel = new Array();					
			
				// Esta funcin  nicamente debe ejecutarlo una vez
				function obtenerCursos(f) {
					for(i=0; i<f.cbCursos.length; i++) {
						var s = f.cbCursos.options[i].value.split("|");
						// Cdigos de los detalles
						cursos[i]= s[0];
						profCursos[i] = s[1];
						PEcodCursos[i] = s[2];						
						SPEcodCursos[i] = s[3];												
						cursostext[i] = f.cbCursos.options[i].text;
					}
				}
				
				// Esta funci n nicamente debe ejecutarlo una vez
				function obtenerPerEval(f) {
					for(i=0; i<f.cbPerEval.length; i++) {
						var s = f.cbPerEval.options[i].value.split("|");
						// C digos de los detalles
						perEvalNivel[i]= s[0];
						perEval[i] = s[1];										
						perEvaltext[i] = f.cbPerEval.options[i].text;
					}
				}								
				// Esta funcin  nicamente debe ejecutarlo una vez
				function obtenerDocente(f) {
					for(i=0; i<f.cbProfes.length; i++) {
						var s = f.cbProfes.options[i].value.split("|");
						// Cdigos de los detalles
						docente[i] = s[0];
						plaza[i] = s[1];
						Nivel[i] = s[2];
						
						docentetext[i] = f.cbProfes.options[i].text;
					}
				}

				function cargarDocentes(csourcePer, ctarget, vdefault, t){
					// Limpiar Combo
					//alert(vdefault);
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var h = csourcePer.value.split("|");			
					//var hProf = csourceProf.value.split("|");						
					var kNv_Nivel = h[0];
					var kNv_PE = h[1];
					var kNv_SPE = h[2];			
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("-- Todos --","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}
					//alert("El largo de profCursos es:",docente.length);		
					for (var i=0; i<docente.length; i++) {
						if (Nivel[i] == kNv_Nivel ) {
							nuevaOpcion = new Option(docentetext[i],docente[i]+'|'+plaza[i]+'|'+Nivel[i]);
							ctarget.options[j]=nuevaOpcion;
							if (vdefault != null && docente[i]+'|'+plaza[i]+'|'+Nivel[i] == vdefault) {
								ctarget.selectedIndex = j;
							}
							j++;
						}
					}
					if (!t) {
						var j = ctarget.length;
						nuevaOpcion = new Option("-------------------","");
						ctarget.options[j++]=nuevaOpcion;
						nuevaOpcion = new Option("Crear Nuevo ...","0");
						ctarget.options[j]=nuevaOpcion;
					}
				}	

				function cargarCursos(csourcePer,csourceProf, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var h = csourcePer.value.split("|");			
					var hProf = csourceProf.value.split("|");						
					var kNv_Nivel = h[0];
					var kNv_PE = h[1];
					var kNv_SPE = h[2];			
					var kBand = hProf[0];						
					var k = hProf[1];
					
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("-- Todos --","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}
							
					if (kBand != "-1" && kNv_Nivel != '-1') {	// Solo verifica los Cursos para el Periodo y el Profesor seleccionados
						for (var i=0; i<cursos.length; i++) {
							if (PEcodCursos[i] == kNv_PE && SPEcodCursos[i] == kNv_SPE && profCursos[i] == k ) {
								nuevaOpcion = new Option(cursostext[i],cursos[i]);
								ctarget.options[j]=nuevaOpcion;
		
								if (vdefault != null && cursos[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {
						if (kNv_Nivel == "-1" && kBand != "-1") {	// Solo verifica los cursos para el Profesor seleccionado, sin importar el Periodo
							for (var i=0; i<cursos.length; i++) {
								if (profCursos[i] == k ) {
									nuevaOpcion = new Option(cursostext[i],cursos[i]);
									ctarget.options[j]=nuevaOpcion;
			
									if (vdefault != null && cursos[i] == vdefault) {
										ctarget.selectedIndex = j;
									}
									j++;
								}
							}				
						}else{
							if (kNv_Nivel != "-1" && kBand == "-1") {	// Solo verifica los cursos por el Periodo seleccionado sin importar el Profesor
								for (var i=0; i<cursos.length; i++) {
									if (PEcodCursos[i] == kNv_PE && SPEcodCursos[i] == kNv_SPE) {
										nuevaOpcion = new Option(cursostext[i],cursos[i]);
										ctarget.options[j]=nuevaOpcion;
				
										if (vdefault != null && cursos[i] == vdefault) {
											ctarget.selectedIndex = j;
										}
										j++;
									}
								}
							}else{		// Solo verifica los cursos Sin filtrar ni por Periodo ni por Profesor										
								for (var i=0; i<cursos.length; i++) {
									nuevaOpcion = new Option(cursostext[i],cursos[i]);
									ctarget.options[i+1]=nuevaOpcion;
									
									if (vdefault != null && cursos[i] == vdefault) {
										ctarget.selectedIndex = i+1;
									}					
								}
							}
						}
					}									
					if (!t) {
						var j = ctarget.length;
						nuevaOpcion = new Option("-------------------","");
						ctarget.options[j++]=nuevaOpcion;
						nuevaOpcion = new Option("Crear Nuevo ...","0");
						ctarget.options[j]=nuevaOpcion;
					}
				}	
				
				function cargaPerEvaluacion(obj){
					obj.form.PEvalCodigo.value = obj.value;
					
//					alert('obj.form.PEvalCodigo.value >>' + obj.form.PEvalCodigo.value);
				}
				
				function cargaCod(obj){
					var hPer = obj.value.split("|");										
									
					obj.form.PEcodigo.value = hPer[1];										
					obj.form.SPEcodigo.value = hPer[2];
					
//					alert('obj.form.PEcodigo.value >>' + obj.form.PEcodigo.value + ' -- obj.form.SPEcodigo.value >>' + obj.form.SPEcodigo.value);
				}
				
				function cargaProfe(obj){
					var hPer = obj.value.split("|");										
					//alert(obj.value);
					
					if(hPer[0] != '-1'){
						obj.form.Splaza.value = hPer[1];
					}else{
						obj.form.Splaza.value = hPer[0];					
					}
										
//					alert('obj.form.Splaza.value >>' + obj.form.Splaza.value);					
				}	
				
				function cambioCurso(obj){
					alert('Periodo >>' + obj.form.cbPeriodo.value + ' -- PerEval >>' + obj.form.cbPerEval.value + ' -- cbProfe >>' + obj.form.cbProfes.value + ' -- Curso >>' + obj.form.cbCursos.value + ' -- PEcodigo >>' + obj.form.PEcodigo.value + ' -- SPEcodigo >>' + obj.form.SPEcodigo.value + ' -- Splaza >>' + obj.form.Splaza.value);
				}

				function limpiar(form){
					form.cbPeriodo.selectedIndex= 0;
					cargarCursos(document.formTemariosCurso.cbPeriodo,document.formTemariosCurso.cbProfes, document.formTemariosCurso.cbCursos, '<cfif isdefined("Form.cbCursos") AND Form.cbCursos NEQ "-1"><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true);								
					cargarPerEval(document.formTemariosCurso.cbPeriodo,document.formTemariosCurso.cbPerEval,'<cfif isdefined("Form.cbPerEval") AND Form.cbPerEval NEQ "-1"><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true);
					cargaCod(document.formTemariosCurso.cbPerEval);
					form.cbProfes.value= '-1|-1';					
					form.cbCursos.value= '-1';
				}
				
				function cargarPerEval(csourcePer, ctarget, vdefault, t){				
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var h = csourcePer.value.split("|");			
					var kNv_Nivel = h[0];			
					
					var j = 0;
					if (kNv_Nivel != '') {	// Solo verifica los periodos de evaluacion para el ciclo lectivo seleccionado
						for (var i=0; i<cursos.length; i++) {
							if (perEvalNivel[i] == kNv_Nivel) {
								nuevaOpcion = new Option(perEvaltext[i],perEval[i]);
								ctarget.options[j]=nuevaOpcion;
		
								if (vdefault != null && perEval[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {		// Solo verifica los Periodos de Evaluacion Sin filtrar por ciclo lectivo
						for (var i=0; i<perEval.length; i++) {
							nuevaOpcion = new Option(perEvaltext[i],perEval[i]);
							ctarget.options[i+1]=nuevaOpcion;
							
							if (vdefault != null && perEval[i] == vdefault) {
								ctarget.selectedIndex = i+1;
							}					
						}
					}									
					if (!t) {
						var j = ctarget.length;
						nuevaOpcion = new Option("-------------------","");
						ctarget.options[j++]=nuevaOpcion;
						nuevaOpcion = new Option("Crear Nuevo ...","0");
						ctarget.options[j]=nuevaOpcion;
					}
				}	

				function poneSemana(valor){
					var connVerSemanas	= document.getElementById("verSemanas");
				
					if(valor == 'S')
						connVerSemanas.style.display = "";
					else 
						connVerSemanas.style.display = "none";
				}
				
								
			</script>						
	
            <form name="formTemariosCurso" method="post" action="ListaTemariosXCurso.cfm">
 				<input name="PEcodigo" id="PEcodigo" type="hidden" value="">				
 				<input name="SPEcodigo" id="SPEcodigo" type="hidden" value="">								
 				<input name="PEvalCodigo" id="PEvalCodigo" type="hidden" value="">								
				<input name="Splaza" id="Splaza" type="hidden" value="">				
								
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
                <tr> 
                  <td colspan="4"> <cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
                      <cfset Param = "">
                      <cfif isdefined('form.PEvalCodigo') and form.PEvalCodigo NEQ ''>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "PEvalCodigo=" & Form.PEvalCodigo>
                      </cfif>
                      <cfif isdefined('form.PEcodigo') and form.PEcodigo NEQ ''>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "PEcodigo=" & Form.PEcodigo>
                      </cfif>
                      <cfif isdefined('form.SPEcodigo') and form.SPEcodigo NEQ ''>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "SPEcodigo=" & Form.SPEcodigo>
                      </cfif>
                      <cfif isdefined('form.cbCursos') and form.cbCursos NEQ '-1'>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "cbCursos=" & Form.cbCursos>
                      </cfif>
                      <cfif isdefined('form.Splaza') and form.Splaza NEQ '-1'>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "Splaza=" & Form.Splaza>
                      </cfif>
                      <cfif isdefined('form.rdFecha')>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "rdFecha=" & Form.rdFecha>
                      </cfif>
                      <cfif isdefined('form.cbSemana')>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "cbSemana=" & Form.cbSemana>
                      </cfif>				  
                      <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXC'>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "rdCorte=" & Form.rdCorte>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "imprime=1">						
                      </cfif>					  
                      <cfif isdefined('form.cbVer')>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "cbVer=" & Form.cbVer>
                      </cfif>					  
                      <cfif isdefined('form.ckVerDes')>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "ckVerDes=" & Form.ckVerDes>
                      </cfif>
					  					  
                      <cfinvoke 
								component="edu.Componentes.NavegaPrint" 
								method="Navega" 
								returnvariable="pListaNavegable">
                        <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaTemariosXCursoImpr.cfm">
                        <cfinvokeargument name="Param" value="#Param#">
                      </cfinvoke>
                      <cfelse>
                      <cfinclude template="../../portlets/pNavegacionCED.cfm">
                    </cfif> </td>
                </tr>
                <tr> 
                  <td colspan="4" class="subTitulo"><strong>Curso Lectivo</strong> 
                    <select name="cbPeriodo" id="select7" onChange="javascript: cargarDocentes(this,document.formTemariosCurso.cbProfes, '<cfif isdefined('Form.cbProfes') AND Form.cbProfes NEQ '-1'><cfoutput>#Form.cbProfes#</cfoutput></cfif>', true); cargarPerEval(this,document.formTemariosCurso.cbPerEval, '<cfif isdefined('Form.cbPerEval') AND Form.cbPerEval NEQ '-1'><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true); cargarCursos(this,document.formTemariosCurso.cbProfes, document.formTemariosCurso.cbCursos, '<cfif isdefined('Form.cbCursos') AND Form.cbCursos NEQ '-1'><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true); cargarPerEval(this,document.formTemariosCurso.cbPerEval, '<cfif isdefined('Form.cbPerEval') AND Form.cbPerEval NEQ '-1'><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true); cargaCod(this);cargaPerEvaluacion(document.formTemariosCurso.cbPerEval);">
                      <cfoutput query="rsCursoLectivo"> 
                        <option value="#rsCursoLectivo.Codigo#" <cfif isdefined('form.btnGenerar') and isdefined('form.cbPeriodo') and form.cbPeriodo EQ '#rsCursoLectivo.Codigo#'>selected</cfif>>#rsCursoLectivo.Descripcion#</option>
                      </cfoutput> </select></td>
                </tr>
                <tr> 
                  <td align="left" nowrap>&nbsp;</td>
                  <td align="left" nowrap>&nbsp;</td>
                  <td nowrap><strong>Opciones de Fecha</strong></td>
                  <td nowrap><strong>Impresi&oacute;n</strong></td>
                </tr>
                <tr> 
                  <td align="left" nowrap><div align="right"><strong>Profesor</strong> 
                    </div></td>
                  <td align="left" nowrap><select name="cbProfes" id="cbProfes" onChange="javascript: cargarCursos(document.formTemariosCurso.cbPeriodo,this, document.formTemariosCurso.cbCursos, '<cfif isdefined('Form.cbProfes') AND Form.cbProfes NEQ '-1'><cfoutput>#Form.cbProfes#</cfoutput></cfif>', true); cargaProfe(this);">
                      <option value="-1|-1|-1" <cfif isdefined('form.btnGenerar') and isdefined('form.cbProfes') and form.cbProfes EQ '-1'>selected</cfif>>-- 
                      Todos --</option>
                      <cfoutput query="rsProfesores"> 
                        <option value="#rsProfesores.persona#" <cfif isdefined('form.btnGenerar') and isdefined('form.cbProfes') and form.cbProfes EQ '#rsProfesores.persona#'>selected</cfif>>#rsProfesores.nombre#</option>
                      </cfoutput> </select></td>
                  <td nowrap><input type="radio" name="rdFecha" class="areaFiltro" value="P" onClick="javascript: poneSemana('P')" <cfif isdefined('form.rdFecha') and form.rdFecha EQ 'P'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdFecha')>checked</cfif>>
                    Per&iacute;odo </td>
                  <td nowrap><input border="0" class="areaFiltro" checked type="radio" name="rdCorte" value="PC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PC'> checked </cfif>>
                    P&aacute;ginas Continuas </td>
                </tr>
                <tr> 
                  <td width="26%" align="right" class="subTitulo"><strong>Curso</strong></td>
                  <td width="21%" class="subTitulo"><select name="cbCursos" id="cbCursos">
                      <!--- onChange="javascript: cambioCurso(this);" --->
                      <cfoutput query="rsCursos"> 
                        <option value="#rsCursos.Codigo#">#rsCursos.Nombre#</option>
                      </cfoutput> </select></td>
                  <td width="29%" nowrap><input type="radio" name="rdFecha" class="areaFiltro" value="S" onClick="javascript: poneSemana('S')" <cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>checked</cfif>>
                    Semanal </td>
                  <td width="24%" nowrap><input border="0"  type="radio" name="rdCorte" class="areaFiltro" value="PXC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXC'> checked </cfif>>
                    P&aacute;gina por Curso</td>
                </tr>
                <tr> 
                  <td align="right"><strong>Per&iacute;odo de Evaluaci&oacute;n</strong></td>
                  <td><select name="cbPerEval" id="select11" onChange="javascript: cargaPerEvaluacion(this);">
                      <cfoutput query="rsPerEval"> 
                        <option value="#rsPerEval.codigo#">#rsPerEval.PEdescripcion#</option>
                      </cfoutput> </select></td>
                  <td align="center"> <div style="display: ;" id="verSemanas"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="54%"> Semana </td>
                          <td width="46%"><select name="cbSemana" id="select6">
                              <cfoutput> 
                                <cfloop index = "LoopCount" from = "1" to = "57">
                                  <option value="#LoopCount#" <cfif isdefined('form.cbSemana') and form.cbSemana EQ '#LoopCount#'>selected</cfif>>#LoopCount#</option>
                                </cfloop>
                              </cfoutput> </select></td>
                        </tr>
                        <tr> 
                          <td width="54%"> Ver Descripci&oacute;n </td>
                          <td width="46%"><input name="ckVerDes" type="checkbox" class="areaFiltro" id="ckVerDes" value="checkbox" <cfif isdefined('form.ckVerDes')> checked</cfif>> 
                          </td>
                        </tr>
                      </table>
                    </div></td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr> 
                  <td align="right" nowrap class="subTitulo"><strong>Despliegue 
                    de</strong></td>
                  <td> <select name="cbVer" id="cbVer">
                      <option value="TE" <cfif isdefined('form.cbVer') and form.cbVer EQ 'TE'> selected</cfif>>Temas 
                      y Evaluaciones</option>
                      <option value="T" <cfif isdefined('form.cbVer') and form.cbVer EQ 'T'> selected</cfif>>Temas</option>
                      <option value="E" <cfif isdefined('form.cbVer') and form.cbVer EQ 'E'> selected</cfif>>Evaluaciones</option>
                    </select> </td>
                  <td colspan="2" align="center"> <div style="display: ;" id="verSemanas"> 
                      <input name="btnGenerar" type="submit" id="btnGenerar2" value="Generar">
                      <input name="btnLimpiar" type="button" id="btnLimpiar2" value="Limpiar" onClick="javascript: limpiar(document.formTemariosCurso)">
                    </div></td>
                </tr>
              </table>
			  
			  <p>&nbsp;</p><cfif isdefined('form.btnGenerar')>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">			
                  <tr> 
                    <td> 
					
                    <cfinclude template="formListaTemariosXCurso.cfm"> </td>
                  </tr>
				</table>
			  </cfif>			  
			  
            </form>
			
			<script language="JavaScript" type="text/JavaScript">
				obtenerCursos(document.formTemariosCurso);			
				obtenerPerEval(document.formTemariosCurso);											
				cargarCursos(document.formTemariosCurso.cbPeriodo,document.formTemariosCurso.cbProfes, document.formTemariosCurso.cbCursos, '<cfif isdefined("Form.cbCursos") AND Form.cbCursos NEQ "-1"><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true);
				cargarPerEval(document.formTemariosCurso.cbPeriodo,document.formTemariosCurso.cbPerEval,'<cfif isdefined("Form.cbPerEval") AND Form.cbPerEval NEQ "-1"><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true);
				cargaCod(document.formTemariosCurso.cbPeriodo);				
				cargaPerEvaluacion(document.formTemariosCurso.cbPerEval);
				poneSemana(<cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>'S'<cfelse>'P'</cfif>);
				
				obtenerDocente(document.formTemariosCurso);
				cargarDocentes(document.formTemariosCurso.cbPeriodo,document.formTemariosCurso.cbProfes, '<cfif isdefined("Form.cbProfes") AND Form.cbProfes NEQ "-1"><cfoutput>#Form.cbProfes#</cfoutput></cfif>', true);
				cargaProfe(document.formTemariosCurso.cbProfes);
			</script>
			
			<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
			<script language="JavaScript" type="text/JavaScript">
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("../../js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			</script> 
			
			<script language="JavaScript" type="text/javascript" >						
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("formTemariosCurso");	
			//------------------------------------------------------------------------------------------					
				objForm.cbPeriodo.required = true;
				objForm.cbPeriodo.description = "Ciclo Lectivo";	
				objForm.cbPerEval.required = true;
				objForm.cbPerEval.description = "Per odo de Evaluacin";					
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