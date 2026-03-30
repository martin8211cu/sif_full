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
            reporte de progreso<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
          

			<cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
				set nocount on 
					select convert(varchar, c.SPEcodigo) as SPEcodigo,
							a.Ndescripcion 
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
			<cfloop query="rsCursoLectivo">
				<cfset codCursoLectivo = rsCursoLectivo.SPEcodigo>
				<cfbreak>
			</cfloop>
			<cfif isdefined("Form.SPEcodigo")>
				<cfset codCursoLectivo = Form.SPEcodigo>
			</cfif>
			
			<cfif isdefined("codCursoLectivo")>
            <cfquery name="rsGrupos" datasource="#Session.Edu.DSN#">
				set nocount on 
					select convert(varchar, gr.GRcodigo) as GRcodigo,
							gr.GRnombre
					from Grupo gr, Nivel n, Grado g
					where gr.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
						and gr.Ncodigo = n.Ncodigo 
						and gr.Gcodigo = g.Gcodigo 
					order by n.Norden,g.Gorden
				set nocount off 
            </cfquery>
			<cfset codGrupo = -1>
			<cfif isdefined("Form.GRcodigo")
			AND (NOT isdefined("Form.grupoValido") OR Form.grupoValido EQ 1)>
				<cfset codGrupo = Form.GRcodigo>
			</cfif>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodos">
				select convert(varchar,peval.PEcodigo) as PEcodigo, peval.PEdescripcion 
				from PeriodoEvaluacion peval, PeriodoEscolar pe, SubPeriodoEscolar spe
				where spe.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
				and spe.PEcodigo = pe.PEcodigo
				and pe.Ncodigo = peval.Ncodigo
				order by peval.PEorden
			</cfquery>		
			<cfset codPeriodo = -1>
			<cfif isdefined("Form.PEcodigo")
			AND (NOT isdefined("Form.periodoValido") OR Form.periodoValido EQ 1)>
				<cfset codPeriodo = Form.PEcodigo>
			</cfif>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnos">
				select distinct convert(varchar,a.Ecodigo) as Ecodigo,
				pe.Papellido1, pe.Papellido2, pe.Pnombre
				from Alumnos a, PersonaEducativo pe, GrupoAlumno gra
				where a.persona = pe.persona
				and a.Ecodigo = gra.Ecodigo
				and a.Aretirado = 0
				<cfif codGrupo EQ -1>
				and gra.GRcodigo in (select GRcodigo from Grupo
				where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">)
				<cfelse>
				and gra.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
				</cfif>
				order by Papellido1,Papellido2,Pnombre
			</cfquery>
			<cfset codEstudiante = -1>
			<cfif isdefined("Form.Ecodigo")
			AND (NOT isdefined("Form.alumnoValido") OR Form.alumnoValido EQ 1)>
				<cfset codEstudiante = Form.Ecodigo>
			</cfif>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
				select convert(varchar,c.Ccodigo) as Ccodigo,
				Cnombre=case m.Melectiva
					when 'S' then c.Cnombre
					else m.Mnombre + ' - ' + gr.GRnombre
				end,
				Ctabla=case
					when m.EVTcodigo is null then 0
					else 1
				end
				from Curso c, Materia m, Grupo gr, Grado g
				where c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
				and c.Mconsecutivo = m.Mconsecutivo
				and c.GRcodigo *= gr.GRcodigo
				and m.Gcodigo *= g.Gcodigo
				<cfif codGrupo EQ -1>
				and m.Ncodigo in (select pe.Ncodigo from PeriodoEscolar pe, SubPeriodoEscolar spe
				where spe.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
				and spe.PEcodigo = pe.PEcodigo)
				<cfelse>
				and (c.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
				or (c.GRcodigo is null and m.Melectiva = 'S'
				and m.Ncodigo in (select pe.Ncodigo from PeriodoEscolar pe, SubPeriodoEscolar spe
				where spe.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
				and spe.PEcodigo = pe.PEcodigo)))
				</cfif>
				order by g.Gorden,m.Morden
			</cfquery>
			</cfif>
			
			<script type="text/javascript" src="../../js/utilesMonto.js"></script>
			<script type="text/javascript">
			function checkAdicional() {
				var spanAdicional = document.getElementById("divAdicional");
				if (document.formFiltro.firmaAdicional.checked)
					spanAdicional.style.visibility = "visible";
				else
					spanAdicional.style.visibility = "hidden";
			}
			
			function valida(form) {
				if (form.filtroNota.checked) {
					if (form.filtroPorcentaje.value == ""
					|| parseInt(form.filtroPorcentaje.value) > 100)
					{
						alert("Porcentaje debe ser menor a 100");
						form.filtroPorcentaje.focus();
						return false;
					}
				}
				return true;
			}
			</script>
			<script language="JavaScript" type="text/javascript" src="../../js/calendar.js">//</script>
			<cfif isdefined("Form.checkCurso")>
				<cfset codigosCursos = Form.checkCurso & ",">
			</cfif>
			<cfif isdefined("Form.checkTabla")>
				<cfset codigosTablas = Form.checkTabla & ",">
			</cfif>
			
		  <cfif isdefined("Form.btnGenerar")>
			<cfset Param = "">
			<cfif isdefined('Form.SPEcodigo')>
				<cfset Param = Param & "SPEcodigo=" & Form.SPEcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.GRcodigo')>
				<cfset Param = Param & "GRcodigo=" & Form.GRcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.PEcodigo')>
				<cfset Param = Param & "PEcodigo=" & Form.PEcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.Ecodigo')>
				<cfset Param = Param & "Ecodigo=" & Form.Ecodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.checkCurso')>
				<cfset Param = Param & "checkCurso=" & Form.checkCurso & "&">
			</cfif>				  
			<cfif isdefined('Form.checkTabla')>
				<cfset Param = Param & "checkTabla=" & Form.checkTabla & "&">
			</cfif>
			<cfif isdefined('Form.firmaEncargado')>
				<cfset Param = Param & "firmaEncargado=1&">
			</cfif>
			<cfif isdefined('Form.firmaAlumno')>
				<cfset Param = Param & "firmaAlumno=1&">
			</cfif>
			<cfif isdefined('Form.firmaProfesor')>
				<cfset Param = Param & "firmaProfesor=1&">
			</cfif>
			<cfif isdefined('Form.firmaDirector')>
				<cfset Param = Param & "firmaDirector=1&">
			</cfif>
			<cfif isdefined('Form.firmaAdicional')>
				<cfset Param = Param & "firmaAdicional=1&">
			</cfif>
			<cfif isdefined('Form.nombreAdicional')>
				<cfset Param = Param & "nombreAdicional=" & Form.nombreAdicional & "&">
			</cfif>
			<cfif isdefined('Form.filtroNota')>
				<cfset Param = Param & "filtroNota=1&">
			</cfif>
			<cfif isdefined('Form.filtroPorcentaje')>
				<cfset Param = Param & "filtroPorcentaje=" & Form.filtroPorcentaje & "&">
			</cfif>
			<cfif isdefined('Form.preguntasText')>
				<cfset Param = Param & "preguntasText=" & Form.preguntasText & "&">
			</cfif>
			<cfif isdefined('Form.ckTE')>
				<cfset Param = Param & "ckTE=" & Form.ckTE & "&">
			</cfif>
			<cfif isdefined('Form.ckTG')>
				<cfset Param = Param & "ckTG=" & Form.ckTG & "&">
			</cfif>
			<cfif isdefined('Form.rdCortes')>
				<cfset Param = Param & "rdCortes=" & Form.rdCortes & "&">
			</cfif>
			<cfif isdefined('Form.FechaRep')>
				<cfset Param = Param & "FechaRep=" & Form.FechaRep & "&">
			</cfif>
			
			<cfset Param = Param & "enPantalla=0"  & "&">
			<cfset Param = Param & "btnGenerar=1">

			
			<cfinvoke 
				component="edu.Componentes.NavegaPrint" 
				method="Navega" 
				returnvariable="pListaNavegable">
			 <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ProgressReportImpr.cfm">
			 <cfinvokeargument name="Param" value="#Param#">
			</cfinvoke>
		  <cfelse>
			<cfinclude template="../../portlets/pNavegacionCED.cfm">
		  </cfif>
			<script language="JavaScript1.2">
			function CambiaIdioma(ctl) {
				ctl.form.submit();
			}
			</script>
			<!---
			<form name="Languaje" method="post" style="margin: 0" action="ProgressReport.cfm">
				<div class="areaFiltro" align="left">Idioma: <br>
				  <select name="Idioma" onChange="javascript:CambiaIdioma('this.value');">
						<option value="ES_CR" <cfif Session.Idioma EQ "ES_CR">selected</cfif>>Spanish (Modern)</option>
						<option value="EN" <cfif Session.Idioma EQ "EN">selected</cfif>>English (US)</option>
				  </select>
				</div>
			</form>
			--->
			<form name="formFiltro" method="post" action="ProgressReport.cfm" onSubmit="return valida(this)">
			<input type="hidden" name="enPantalla" value="1">
			<input type="hidden" name="grupoValido" value="1">
			<input type="hidden" name="periodoValido" value="1">
			<input type="hidden" name="alumnoValido" value="1">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
                <tr> 
                  <td class="subTitulo">Curso Lectivo</td>
                  <td class="subTitulo">Grupo</td>
                  <td class="subTitulo">Firmas</td>
                </tr>
				<tr>			
                  <td>
				  <select name="SPEcodigo" id="SPEcodigo" onChange="javascript:document.formFiltro.grupoValido.value=0;document.formFiltro.periodoValido.value=0;document.formFiltro.alumnoValido.value=0;document.formFiltro.submit()">
                  	<cfoutput query="rsCursoLectivo"> 
                    <option value="#rsCursoLectivo.SPEcodigo#"
					<cfif isdefined('codCursoLectivo') AND codCursoLectivo EQ rsCursoLectivo.SPEcodigo>selected</cfif>>#rsCursoLectivo.Descripcion#</option>
                    </cfoutput>
				  </select>
				  </td>
				  <td><cfif isdefined("rsGrupos")>
				  <select name="GRcodigo" id="GRcodigo" onChange="javascript:document.formFiltro.periodoValido.value=0;document.formFiltro.alumnoValido.value=0;document.formFiltro.submit()">
				    <option value="-1" <cfif isdefined('codGrupo') AND codGrupo EQ -1>selected</cfif>>TODOS</option>
                  	<cfoutput query="rsGrupos">
                    <option value="#rsGrupos.GRcodigo#"
					<cfif isdefined('codGrupo') AND codGrupo EQ rsGrupos.GRcodigo>selected</cfif>>#rsGrupos.GRnombre#</option>
                    </cfoutput>
				  </select>
				  </cfif></td>
				  <td rowspan="4">
				    <table cellpadding="0" cellspacing="0" border="0" width="80%">
					  <tr>
					    <td><input name="firmaEncargado" value="1" type="checkbox" class="areaFiltro"
						<cfif isdefined('Form.firmaEncargado')>checked</cfif>></td>
						<td>Padre/Madre</td>
					  </tr>
					  <tr>
					    <td><input name="firmaAlumno" value="1" type="checkbox" class="areaFiltro"
						<cfif isdefined('Form.firmaAlumno')>checked</cfif>></td>
						<td>Alumno</td>
					  </tr>
					  <tr>
					    <td><input name="firmaProfesor" value="1" type="checkbox" class="areaFiltro"
						<cfif isdefined('Form.firmaProfesor')>checked</cfif>></td>
						<td>Profesor</td>
					  </tr>
					  <tr>
					    <td><input name="firmaDirector" value="1" type="checkbox" class="areaFiltro"
						<cfif isdefined('Form.firmaDirector')>checked</cfif>></td>
						<td>Director</td>
					  </tr>
					  <tr>
					    <td><input name="firmaAdicional" value="1" type="checkbox" class="areaFiltro"
						onClick="checkAdicional()" <cfif isdefined('Form.firmaAdicional')>checked</cfif>></td>
						<td>
						Adicional&nbsp;
						<span id="divAdicional"><input name="nombreAdicional"
						value="<cfif isdefined('Form.nombreAdicional')><cfoutput>#Form.nombreAdicional#</cfoutput></cfif>" type="text" size="30" maxlength="30"></span>
						</td>
					  </tr>
					</table>
				  </td>
				</tr>
                <tr> 
                  <td class="subTitulo">Per&iacute;odo de Evaluaci&oacute;n</td>
                  <td class="subTitulo">Alumno</td>
                </tr>
				<tr>
				  <td><cfif isdefined("rsPeriodos")>
				  <select name="PEcodigo" id="PEcodigo" onChange="javascript:document.formFiltro.alumnoValido.value=0;document.formFiltro.submit()">
				    <option value="-1" <cfif isdefined('codPeriodo') AND codPeriodo EQ -1>selected</cfif>>TODOS</option>
                  	<cfoutput query="rsPeriodos">
                    <option value="#rsPeriodos.PEcodigo#"
					<cfif isdefined('codPeriodo') AND codPeriodo EQ rsPeriodos.PEcodigo>selected</cfif>>#rsPeriodos.PEdescripcion#</option>
                    </cfoutput>
				  </select>
				  </cfif></td>
				  <td><cfif isdefined("rsAlumnos")>
				  <select name="Ecodigo" id="Ecodigo" onChange="javascript:document.formFiltro.submit()">
				    <option value="-1" <cfif isdefined('codEstudiante') AND codEstudiante EQ -1>selected</cfif>>TODOS</option>
                  	<cfoutput query="rsAlumnos">
                    <option value="#rsAlumnos.Ecodigo#"
					<cfif isdefined('codEstudiante') AND codEstudiante EQ rsAlumnos.Ecodigo>selected</cfif>>
					#rsAlumnos.Papellido1# #rsAlumnos.Papellido2# #rsAlumnos.Pnombre#</option>
                    </cfoutput>
				  </select>
				  </cfif></td>
				</tr>
				<tr><td colspan="2">
				<input name="filtroNota" value="1" type="checkbox" class="areaFiltro"
				<cfif isdefined("Form.filtroNota")>checked</cfif>>&nbsp;
				Mostrar solo alumnos con porcentaje de progreso inferior a&nbsp;
				<input name="filtroPorcentaje" type="text" size="8" maxlength="8" 
					value="<cfif isdefined('Form.filtroPorcentaje')><cfoutput>#Form.filtroPorcentaje#</cfoutput></cfif>" 
					onFocus="javascript:this.value=qf(this); this.select();" 
					onBlur="javascript:fm(this,0);" style="text-align: right;"
					onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">&nbsp;%
				</td></tr>
				<tr>
					<td>
						<input name="ckTE" type="checkbox" id="ckTE" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckTE')> checked</cfif>>
						Mostrar el % total Evaluado
					</td>
					<td> 
						<strong>Fecha de entrega:</strong> &nbsp;
					</td>
					<td> 
						<strong>Seleccionar Idioma:</strong> &nbsp;
					</td>
				</tr>
				<tr>
					<td>
						<input name="ckTG" type="checkbox" id="ckTG" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckTG')> checked</cfif>>
						Mostrar el % total Ganado
					</td>
					<td>
					<a href="#"> 
                    <input name="FechaRep" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formFiltro.FechaRep');">                    </a>
					</td>
					<td>
					  <select name="Idioma" onChange="javascript:CambiaIdioma(this);">
							<option value="ES_CR" <cfif Session.Idioma EQ "ES_CR">selected</cfif>>Spanish (Modern)</option>
							<option value="EN" <cfif Session.Idioma EQ "EN">selected</cfif>>English (US)</option>
					  </select>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="subTitulo"> <strong>Corte de Impresin</strong>
					</td>
				</tr>
				<tr>
				 <td nowrap> <input type="radio" class="areaFiltro" name="rdCortes" value="PC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    P gina Contnua</td>
                </tr>
                <tr> 
                  <td nowrap><input type="radio" class="areaFiltro" name="rdCortes" value="PxA" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA'>checked</cfif>>
                    P ginas por Alumno</td>
                </tr>
				
				<cfif isdefined("rsCursos")>
				<tr><td colspan="2">
					<table border="0" cellpadding="0" cellspacing="0" width="80%">
                	<tr> 
					  <td class="subTitulo">&nbsp;</td>
                  	  <td class="subTitulo">Curso</td>
                  	  <td class="subTitulo" style="text-align:center">Usar Tabla</td>
                	</tr>
					<cfset hayTablas = 0>
					<cfoutput query="rsCursos">
					<tr>
					  <td><input type="checkbox" name="checkCurso" value="#rsCursos.Ccodigo#" class="areaFiltro"
					  <cfif (isdefined("codigosCursos") AND Find(rsCursos.Ccodigo&",",codigosCursos) IS NOT 0)
					  OR isdefined("Form.checkTodosCursos")>checked</cfif>></td>
					  <td>#rsCursos.Cnombre#</td>
					  <td style="text-align:center">
					  <span style="visibility:<cfif rsCursos.Ctabla EQ 1><cfset hayTablas = 1>visible<cfelse>hidden</cfif>">
					  <input type="checkbox" name="checkTabla" value="#rsCursos.Ccodigo#" class="areaFiltro"
					  <cfif (isdefined("codigosTablas") AND Find(rsCursos.Ccodigo&",",codigosTablas) IS NOT 0)
					  OR isdefined("Form.checkTodosTablas")>checked</cfif>>
					  </span>
					  </td>
					</tr>
					</cfoutput>
					<tr>
					  <td><input type="checkbox" name="checkTodosCursos" value="1" class="areaFiltro" onClick="javascript:checkTodos1()"
					  <cfif isdefined("Form.checkTodosCursos")>checked</cfif>></td>
					  <td><strong>TODOS</strong></td>
					  <td style="text-align:center"><cfif hayTablas EQ 1>
					  <input type="checkbox" name="checkTodosTablas" value="1" class="areaFiltro" onClick="javascript:checkTodos2()"
					  <cfif isdefined("Form.checkTodosTablas")>checked</cfif>>
					  <cfelse>&nbsp;</cfif></td>
					</tr>
					</table>
				</td><td>&nbsp;</td></tr>
				<tr><td colspan="3">
				Enviar dudas o preguntas a:&nbsp;
				<input type="text" size="60" maxlength="60" name="preguntasText"
				value="<cfif isdefined('Form.preguntasText')><cfoutput>#Form.preguntasText#</cfoutput></cfif>">
				</td></tr>
				<tr><td colspan="3" style="text-align:center">
				<input type="submit" name="btnGenerar" value="Generar" onClick="javascript:setBtn(this)">
				</td></tr>
				</cfif>
			</table>
		  	</form>
			
			<cfif isdefined('Form.btnGenerar')>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">			
            	<tr> 
                	<td> 
                      <cfinclude template="ResultProgressReport.cfm">
					</td>
                </tr>
			</table>
			</cfif>
			  
			<script type="text/javascript">
			function checkTodos1() {
				for (var i = 0; i < document.formFiltro.elements.length; ++i)
					if (document.formFiltro.elements[i].type == "checkbox"
					&& document.formFiltro.elements[i].name == "checkCurso") {
						document.formFiltro.elements[i].checked = document.formFiltro.checkTodosCursos.checked;
					}
			}

			function checkTodos2() {
				for (var i = 0; i < document.formFiltro.elements.length; ++i)
					if (document.formFiltro.elements[i].type == "checkbox"
					&& document.formFiltro.elements[i].name == "checkTabla") {
						document.formFiltro.elements[i].checked = document.formFiltro.checkTodosTablas.checked;
					}
			}
			
			checkAdicional();
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