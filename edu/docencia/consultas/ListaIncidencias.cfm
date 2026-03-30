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
		  	Incidencias por Curso
		  <!-- InstanceEndEditable -->
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
			<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
				set nocount on
				select distinct (convert(varchar,c.Ccodigo) + '|' + convert(varchar,m.Ncodigo) + '|' + convert(varchar,c.PEcodigo) + '|' + convert(varchar,c.SPEcodigo) ) as codCurso, 
						(Mnombre+' '+GRnombre) as nombCurso
						, Norden, Gorden
				from Curso c, Materia m, Grupo g,  Staff s, Nivel n, Grado k,  PeriodoVigente v
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Melectiva = 'R'
					and c.GRcodigo = g.GRcodigo
					and m.Ncodigo = v.Ncodigo
					and c.PEcodigo = v.PEcodigo
					and c.SPEcodigo = v.SPEcodigo
					and c.Splaza = s.Splaza
					and m.Ncodigo = n.Ncodigo
					and m.Ncodigo = k.Ncodigo
					and m.Gcodigo = k.Gcodigo
				union
				select distinct ( convert(varchar,c.Ccodigo)  + '|' + convert(varchar,m.Ncodigo) + '|' + convert(varchar,c.PEcodigo) + '|' + convert(varchar,c.SPEcodigo)) as codCurso,
						Cnombre as nombCurso
						, Norden
						, 100000 as Gorden
				from Curso c, Materia m,  Staff s, Nivel n , PeriodoVigente v
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Melectiva = 'S'
					and m.Ncodigo = v.Ncodigo
					and c.PEcodigo = v.PEcodigo
					and c.SPEcodigo = v.SPEcodigo
					and c.Splaza = s.Splaza
					and m.Ncodigo = n.Ncodigo
				order by 3,4,2
				set nocount off
			</cfquery>
			<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodo">
				select (convert(varchar,PEcodigo) + '|'  + convert(varchar,Ncodigo) ) as PEcodigo, PEdescripcion 
				from PeriodoEvaluacion
				where Ncodigo is not null
				order by PEorden
			</cfquery>	
		<script language="JavaScript" type="text/JavaScript">  
			var curso = new Array();				
		var cursoText = new Array();	
		var nivelCurso = new Array();			
		var PEcodigoCurso = new Array();					
		var SPEcodigoCurso = new Array();							
		
		var periodo = new Array();				
		var periodoText = new Array();	
		var PEcodigoPeriodo = new Array();		
		var nivelPeriodo = new Array();					

		// Esta funcin  nicamente debe ejecutarlo una vez
		function obtenerPer(f) {
			for(i=0; i<f.PEcodigo.length; i++) {
				var s = f.PEcodigo.options[i].value.split("|");
				// Cdigos de los detalles
				periodo[i]= s[0];
				nivelPeriodo[i] = s[1];
				PEcodigoPeriodo[i] = s[2];						
				periodoText[i] = f.PEcodigo.options[i].text;
			}
		}

		// Esta funci n nicamente debe ejecutarlo una vez
		function obtenerCursos(f) {
			for(i=0; i<f.Ccodigo.length; i++) {
				var s = f.Ccodigo.options[i].value.split("|");
				// C digos de los detalles
				curso[i]= s[0];
				nivelCurso[i] = s[1];
				PEcodigoCurso[i] = s[2];						
				SPEcodigoCurso[i] = s[3];												
				cursoText[i] = f.Ccodigo.options[i].text;
			}
		}	
	
		function obtenerCursoLec(obj){
			var hPer = obj.value.split("|");
			
			obj.form.PeriodoEsc.value = hPer[1];	
			obj.form.SPEcodigo.value = hPer[2];				
		}	

		function cargarPer(csourceCurLect, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var h = csourceCurLect.value.split("|");			
			var kNv_Nivel = h[0];
			var kNv_PE = h[1];
			var kNv_SPE = h[2];			
	
			var j = 0;
			if (t) {
				var nuevaOpcion = new Option("-- Todos --","-1");
				ctarget.options[j]=nuevaOpcion;
				j++;
			}

			for (var i=0; i<periodo.length; i++) {
				if (nivelPeriodo[i] == kNv_Nivel) {
					nuevaOpcion = new Option(periodoText[i],periodo[i]);
					ctarget.options[j]=nuevaOpcion;

					if (vdefault != null && periodo[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		}		
		
		function cargarCursos(csourceCurLect, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var h = csourceCurLect.value.split("|");			
			var kNv_Nivel = h[0];
			var kNv_PE = h[1];
			var kNv_SPE = h[2];			
	
			var j = 0;
			if (t) {
				var nuevaOpcion = new Option("-- Todos --","-1");
				ctarget.options[j]=nuevaOpcion;
				j++;
			}
			for (var i=0; i<curso.length; i++) {
				if (nivelCurso[i] == kNv_Nivel && PEcodigoCurso[i] == kNv_PE && SPEcodigoCurso[i] == kNv_SPE) {
					nuevaOpcion = new Option(cursoText[i],curso[i]);
					ctarget.options[j]=nuevaOpcion;

					if (vdefault != null && curso[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		}	
		
	</script>
	
	<form name="formListaIncidencias" method="post" action="ListaIncidencias.cfm">
		<input name="SPEcodigo" id="SPEcodigo" type="hidden" value="">
		<input name="PeriodoEsc" id="PeriodoEsc" type="hidden" value="">
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
			<tr> 
            	<td colspan="2">
					<cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
						<cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
							<cfif isdefined("form.btnGenerar")>
								<cfset btnGenerar = #form.btnGenerar#>	
							</cfif>
							<cfif isdefined("form.Ccodigo")>
								<cfset Ccodigo = #form.Ccodigo#>	
							</cfif>
							
							<cfif isdefined("form.rdCortes")>
								<cfset rdCortes = #form.rdCortes#>	
							</cfif>
							<cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaIncidenciasImpr.cfm">							
							<cfinvokeargument name="Param" value="&Ccodigo=#Ccodigo#&btnGenerar=#btnGenerar#&rdCortes=#rdCortes#&PEcodigo=#PEcodigo#&SPEcodigo=#SPEcodigo#&PeriodoEsc=#PeriodoEsc#">
							<cfinvokeargument name="Tipo" value="2">
						</cfinvoke>
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionDOC.cfm">
					</cfif>				  
				  </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Curso Lectivo</td>
                  <td class="subTitulo">Cortes de Impresi&oacute;n</td>
                </tr>
                <tr> 
                  <td><select name="cbCurLec" id="cbCurLec" onChange="javascript: cargarCursos(this,this.form.Ccodigo,'<cfif isdefined('Form.Ccodigo') AND Form.Ccodigo NEQ '-1'><cfoutput>#Form.Ccodigo#</cfoutput></cfif>',true); obtenerCursoLec(this);cargarPer(this,document.formListaIncidencias.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>', false);">
                      <cfoutput query="rsCursoLectivo"> 
                        <option value="#rsCursoLectivo.Codigo#" <cfif isdefined('form.btnGenerar') and isdefined('form.cbCurLec') and form.cbCurLec EQ '#rsCursoLectivo.Codigo#'>selected</cfif>>#rsCursoLectivo.Descripcion#</option>
                      </cfoutput> </select></td>
                  <td> <input type="radio" class="areaFiltro" name="rdCortes" value="SC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'SC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    Separar Curso (Contnua) </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Curso</td>
                  <td> <input type="radio" class="areaFiltro" name="rdCortes" value="CxG" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'CxG'>checked</cfif>>
                    Separar Curso (P&aacute;gina) </td>
                </tr>
                <tr> 
                  <td><select name="Ccodigo" id="Ccodigo">
                      <cfoutput query="rsCursos"> 
                        <option value="#rsCursos.codCurso#">#rsCursos.nombCurso#</option>
                      </cfoutput> </select></td>
                  <td rowspan="3" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar2" value="Generar" ></td>
                </tr>
                <tr> 
                  <td class="subTitulo">Periodo</td>
                </tr>
                <tr> 
                  <td><select name="PEcodigo" id="PEcodigo">
                      <cfoutput query="rsPeriodo"> 
                          <option value="#rsPeriodo.PEcodigo#">#rsPeriodo.PEdescripcion#</option>
                      </cfoutput> </select></td>
                </tr>
              </table>
            </form>
			<cfif isdefined("form.btnGenerar")>
		        <cfinclude  template="formListaIncidencias.cfm">
    	    </cfif>
			<script language="JavaScript" type="text/javascript" >
			obtenerCursoLec(document.formListaIncidencias.cbCurLec);
			obtenerCursos(document.formListaIncidencias);
			cargarCursos(document.formListaIncidencias.cbCurLec,document.formListaIncidencias.Ccodigo, '<cfif isdefined("Form.Ccodigo") AND Form.Ccodigo NEQ "-1"><cfoutput>#Form.Ccodigo#</cfoutput></cfif>', true);											
			obtenerPer(document.formListaIncidencias);
			cargarPer(document.formListaIncidencias.cbCurLec,document.formListaIncidencias.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>', false);														
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