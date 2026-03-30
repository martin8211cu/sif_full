<!-- InstanceBegin template="/Templates/LMenuDOC.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
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
			<cfset RolActual = 5>
			<cfset Session.RolActual = 5>
			<cfinclude template="../../portlets/pEmpresas2.cfm">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="area" style="padding-bottom: 3px;"> 
			  <td nowrap style="padding-left: 10px;">
			  <cfinclude template="../../portlets/pminisitio.cfm">
			  </td>
			  <td valign="top" nowrap> 
		  <!-- InstanceBeginEditable name="MenuJS" --> 
	  	<cfinclude template="../jsMenuDOC.cfm">
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
            Temarios y Evaluaciones<!-- InstanceEndEditable -->
			  </td>
			  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
			</tr>
			<tr> 
			  <td colspan="3" class="contenido-lbborder">
			  <!-- InstanceBeginEditable name="Mantenimiento2" -->

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_cod"
			 returnvariable="usr">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
				<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
			</cfinvoke>

            <cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
				set nocount on 
					select distinct  convert(varchar, a.Ncodigo) + '|' 
							+ convert(varchar, b.PEcodigo) + '|' 
							+ convert(varchar, c.SPEcodigo) as Codigo
						, a.Ndescripcion 
							+ ' : ' + b.PEdescripcion 
							+ ' : ' + c.SPEdescripcion as Descripcion 
						, b.PEcodigo, c.SPEcodigo
					from Nivel a
							, PeriodoEscolar b
							, SubPeriodoEscolar c
							, PeriodoVigente d
							, Curso cu
							, Staff s
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					    and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
						and cu.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and cu.CEcodigo = a.CEcodigo
						and a.CEcodigo = a.CEcodigo
						and a.Ncodigo = b.Ncodigo 
						and b.PEcodigo = c.PEcodigo 
						and a.Ncodigo = d.Ncodigo 
						and b.PEcodigo = d.PEcodigo 
						and c.SPEcodigo = d.SPEcodigo 
						and cu.SPEcodigo = d.SPEcodigo
						and cu.PEcodigo = d.PEcodigo
						and cu.Splaza = s.Splaza
					order by a.Norden 
				set nocount off 
            </cfquery>

            <cfquery datasource="#Session.Edu.DSN#" name="rsProfesor">
				select convert(varchar,Splaza) as Splaza
					, (Papellido1 + ' ' 
					+ Papellido2 + ','
					+ Pnombre) as nombre 
				from 	PersonaEducativo a
						, Staff b 
				where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.persona=b.persona 
					and a.CEcodigo=b.CEcodigo 
					and b.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
					and b.retirado = 0 
					and b.autorizado = 1 
				order by nombre 
            </cfquery>

            <cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
			select 	(convert(varchar,Ccodigo) + '|' +
							convert(varchar,c.Splaza)+ '|' +
							convert(varchar, c.PEcodigo) + '|' +
							convert(varchar, c.SPEcodigo)
						) as Codigo
						,(Mnombre + '' + GRnombre) as Nombre
						,c.PEcodigo,c.SPEcodigo,c.Ccodigo
				from Curso c, PeriodoVigente pv, Materia m, Grupo gr, Staff s
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
					and c.PEcodigo=pv.PEcodigo
					and c.SPEcodigo=pv.SPEcodigo
					and c.Splaza is not null
					and c.Mconsecutivo=m.Mconsecutivo
					and c.GRcodigo=gr.GRcodigo
					and c.PEcodigo=gr.PEcodigo
					and c.SPEcodigo=gr.SPEcodigo
					and c.Splaza = s.Splaza
					and c.CEcodigo = s.CEcodigo
				Order by Ccodigo, Nombre

            </cfquery>

			<cfquery datasource="#Session.Edu.DSN#" name="rsPerEval">
				select (convert(varchar,Ncodigo) + '|'  + convert(varchar,PEcodigo)) as codigo
				     , PEdescripcion 
					 , PEcodigo
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

				function cargarCursos(csourcePer,csourceProf, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var h = csourcePer.value.split("|");			
					var k = csourceProf.value;						
					var kNv_Nivel = h[0];
					var kNv_PE = h[1];
					var kNv_SPE = h[2];			
					
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("-- Todos --","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}
							
					if (k != "" && kNv_Nivel != '-1') {	// Solo verifica los Cursos para el Periodo y el Profesor seleccionados
						for (var i=0; i<cursos.length; i++) {
							if (PEcodCursos[i] == kNv_PE && SPEcodCursos[i] == kNv_SPE && profCursos[i] == k) {
								nuevaOpcion = new Option(cursostext[i],cursos[i]);
								ctarget.options[j]=nuevaOpcion;
		
								if (vdefault != null && cursos[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {
						if (kNv_Nivel == "-1" && k != "") {	// Solo verifica los cursos para el Profesor actual, sin importar el Periodo
							for (var i=0; i<cursos.length; i++) {
								if (profCursos[i] == k) {
									nuevaOpcion = new Option(cursostext[i],cursos[i]);
									ctarget.options[j]=nuevaOpcion;
			
									if (vdefault != null && cursos[i] == vdefault) {
										ctarget.selectedIndex = j;
									}
									j++;
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
				}
				
				function cargaCod(obj){
					var hPer = obj.value.split("|");										
									
					obj.form.PEcodigo.value = hPer[1];										
					obj.form.SPEcodigo.value = hPer[2];
				}
				
				function cambioCurso(obj){
					alert('Periodo >>' + obj.form.cbPeriodo.value + ' -- PerEval >>' + obj.form.cbPerEval.value + ' -- cbProfe >>' + obj.form.cbProfes.value + ' -- Curso >>' + obj.form.cbCursos.value + ' -- PEcodigo >>' + obj.form.PEcodigo.value + ' -- SPEcodigo >>' + obj.form.SPEcodigo.value + ' -- Splaza >>' + obj.form.Splaza.value);
				}

				function limpiar(form){
					form.cbPeriodo.selectedIndex= 0;
					cargarCursos(document.formTemariosEvalXProf.cbPeriodo,document.formTemariosEvalXProf.Splaza, document.formTemariosEvalXProf.cbCursos, '<cfif isdefined("Form.cbCursos") AND Form.cbCursos NEQ "-1"><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true);								
					cargarPerEval(document.formTemariosEvalXProf.cbPeriodo,document.formTemariosEvalXProf.cbPerEval,'<cfif isdefined("Form.cbPerEval") AND Form.cbPerEval NEQ "-1"><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true);
					cargaCod(document.formTemariosEvalXProf.cbPerEval);
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
						for (var i=0; i<perEval.length; i++) {
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
	
	<cfif isdefined("Url.C") and not isdefined("Form.cbCursos")>
		<cfparam name="Form.cbPerEval" default="#URL.P#">
		<cfparam name="Form.PEvalCodigo" default="#URL.P#">
		<cfquery dbtype="query" name="qryCE">
		  select rsCursos.Codigo as CodigoC, rsCursos.Ccodigo
		       , rsCursos.PEcodigo
		       , rsCursos.SPEcodigo
		       , rsCursoLectivo.Codigo as CodigoCL
		    from rsCursos, rsCursoLectivo
		   where rsCursos.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.C#">
		     and rsCursoLectivo.PEcodigo = rsCursos.PEcodigo
			 and rsCursoLectivo.SPEcodigo = rsCursos.SPEcodigo
		</cfquery>
		<cfparam name="Form.cbPeriodo" default="#qryCE.CodigoCL#">
		<cfparam name="Form.PEcodigo" default="#qryCE.PEcodigo#">
		<cfparam name="Form.SPEcodigo" default="#qryCE.SPEcodigo#">
		<cfparam name="Form.cbCursos" default="#qryCE.Ccodigo#">
		<cfparam name="Form.Splaza" default="#rsProfesor.Splaza#">
		<cfparam name="form.btnGenerar" default="">
	</cfif> 	
            <form name="formTemariosEvalXProf" method="post" action="ListaTemariosEvalXProf.cfm">
 				<input name="PEcodigo" id="PEcodigo" type="hidden" value="">				
 				<input name="SPEcodigo" id="SPEcodigo" type="hidden" value="">								
 				<input name="PEvalCodigo" id="PEvalCodigo" type="hidden" value="">										
				<input name="Splaza" id="Splaza" type="hidden" value="<cfoutput>#rsProfesor.Splaza#</cfoutput>">				
								
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
                      <cfif isdefined('form.Splaza') and form.Splaza NEQ ''>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "Splaza=" & Form.Splaza>
                      </cfif>
                      <cfif isdefined('form.cbCursos') and form.cbCursos NEQ '-1'>
                        <cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "cbCursos=" & Form.cbCursos>
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
                        <cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaTemariosEvalXProfImpr.cfm">
                        <cfinvokeargument name="Param" value="#Param#">
                        <cfinvokeargument name="Tipo" value="2">
                      </cfinvoke>
                      <cfelse>
                      <cfinclude template="../../portlets/pNavegacionDOC.cfm">
                    </cfif> </td>
                </tr>
                <tr> 
                  <td colspan="4" class="tituloAlterno">Profesor Actual: <cfoutput>#rsProfesor.nombre#</cfoutput></td>
                </tr>
                <tr> 
                  <td align="right" class="subTitulo"><strong>Curso Lectivo</strong></td>
                  <td colspan="3"><select name="cbPeriodo" id="select6" onChange="javascript: cargarCursos(this,document.formTemariosEvalXProf.Splaza, document.formTemariosEvalXProf.cbCursos, '<cfif isdefined('Form.cbCursos') AND Form.cbCursos NEQ '-1'><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true); cargarPerEval(this,document.formTemariosEvalXProf.cbPerEval, '<cfif isdefined('Form.cbPerEval') AND Form.cbPerEval NEQ '-1'><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true); cargaCod(this);cargaPerEvaluacion(document.formTemariosEvalXProf.cbPerEval);">
                      <cfoutput query="rsCursoLectivo"> 
                        <option value="#rsCursoLectivo.Codigo#" <cfif isdefined('form.btnGenerar') and isdefined('form.cbPeriodo') and form.cbPeriodo EQ '#rsCursoLectivo.Codigo#'>selected</cfif>>#rsCursoLectivo.Descripcion#</option>
                      </cfoutput> </select></td>
                </tr>
                <tr> 
                  <td align="right" class="subTitulo">Curso</td>
                  <td class="subTitulo"><select name="cbCursos" id="select">
                      <!--- onChange="javascript: cambioCurso(this);" --->
                      <cfoutput query="rsCursos"> 
                        <option value="#rsCursos.Codigo#">#rsCursos.Nombre#</option>
                      </cfoutput> </select></td>
                  <td nowrap class="subTitulo">Opciones de Fecha</td>
                  <td class="subTitulo">Impresi&oacute;n</td>
                </tr>
                <tr> 
                  <td align="right" nowrap><strong>Per&iacute;odo de Evaluaci&oacute;n</strong> 
                  </td>
                  <td align="left"><select name="cbPerEval" id="select2" onChange="javascript: cargaPerEvaluacion(this);">
                      <cfoutput query="rsPerEval"> 
                        <option value="#rsPerEval.codigo#">#rsPerEval.PEdescripcion#</option>
                      </cfoutput> </select> </td>
                  <td nowrap><input type="radio" name="rdFecha" value="P" class="areaFiltro" onClick="javascript: poneSemana('P')" <cfif isdefined('form.rdFecha') and form.rdFecha EQ 'P'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdFecha')>checked</cfif>>
                    Per&iacute;odo </td>
                  <td width="25%" nowrap><input border="0" class="areaFiltro" checked type="radio" name="rdCorte" value="PC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PC'> checked </cfif>>
                    P&aacute;ginas Continuas </td>
                </tr>
                <tr> 
                  <td width="20%" align="right" class="subTitulo"> Despliegue 
                    de </td>
                  <td width="26%" align="left"><select name="cbVer" id="cbVer">
                      <option value="TE" <cfif isdefined('form.cbVer') and form.cbVer EQ 'TE'> selected</cfif>>Temas y Evaluaciones</option>
                      <option value="T" <cfif isdefined('form.cbVer') and form.cbVer EQ 'T'> selected</cfif>>Temas</option>
                      <option value="E" <cfif isdefined('form.cbVer') and form.cbVer EQ 'E'> selected</cfif>>Evaluaciones</option>
                    </select> </td>
                  <td width="29%"><input type="radio" name="rdFecha" value="S" class="areaFiltro" onClick="javascript: poneSemana('S')" <cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>checked</cfif>>
                    Semana</td>
                  <td width="25%" nowrap><input border="0"  type="radio" name="rdCorte" class="areaFiltro" value="PXC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXC'> checked </cfif>>
                    P&aacute;gina por Curso</td>
                </tr>
                <tr> 
                  <td nowrap>&nbsp; </td>
                  <td align="center"><input name="btnGenerar" type="submit" id="btnGenerar3" value="Generar"> 
                    <input name="btnLimpiar" type="button" id="btnLimpiar3" value="Limpiar" onClick="javascript: limpiar(document.formTemariosEvalXProf)"></td>
                  <td align="center"> <div style="display: ;" id="verSemanas"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="52%"> Semana</td>
                          <td width="48%"><select name="cbSemana" id="cbSemana">
                              <cfoutput> 
                                <cfloop index = "LoopCount" from = "1" to = "57">
                                  <option value="#LoopCount#" <cfif isdefined('form.cbSemana') and form.cbSemana EQ '#LoopCount#'>selected</cfif>>#LoopCount#</option>
                                </cfloop>
                              </cfoutput> </select></td>
                        </tr>
                        <tr> 
                          <td width="52%"> Ver Descripci&oacute;n </td>
                          <td width="48%"><input name="ckVerDes" type="checkbox" class="areaFiltro" id="ckVerDes" value="checkbox" <cfif isdefined('form.ckVerDes')> checked</cfif>></td>
                        </tr>
                      </table>
                    </div></td>
                  <td width="25%" nowrap>&nbsp;</td>
                </tr>
              </table>
                <cfif isdefined('form.btnGenerar')>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">			
					  <tr>
						<td> <cfinclude template="formListaTemariosEvalXProf.cfm"> </td>
					  </tr>
					</table>
                </cfif>
            </form>
			
			<script language="JavaScript" type="text/JavaScript">
				obtenerCursos(document.formTemariosEvalXProf);			
				obtenerPerEval(document.formTemariosEvalXProf);											
				cargarCursos(document.formTemariosEvalXProf.cbPeriodo,document.formTemariosEvalXProf.Splaza, document.formTemariosEvalXProf.cbCursos, '<cfif isdefined("Form.cbCursos") AND Form.cbCursos NEQ "-1"><cfoutput>#Form.cbCursos#</cfoutput></cfif>', true);								
				cargarPerEval(document.formTemariosEvalXProf.cbPeriodo,document.formTemariosEvalXProf.cbPerEval,'<cfif isdefined("Form.cbPerEval") AND Form.cbPerEval NEQ "-1"><cfoutput>#Form.cbPerEval#</cfoutput></cfif>', true);
				cargaCod(document.formTemariosEvalXProf.cbPeriodo);				
				cargaPerEvaluacion(document.formTemariosEvalXProf.cbPerEval);
				poneSemana(<cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>'S'<cfelse>'P'</cfif>);
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
				objForm = new qForm("formTemariosEvalXProf");	
			//------------------------------------------------------------------------------------------					
				objForm.cbPeriodo.required = true;
				objForm.cbPeriodo.description = "Ciclo Lectivo";	
				objForm.cbPerEval.required = true;
				objForm.cbPerEval.description = "Perodo de Evaluaci n";					
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