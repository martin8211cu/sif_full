<cfinclude template="../../Utiles/general.cfm">
<cfset Session.RegresarURL = "/cfmx/edu/docencia/MenuDOC.cfm">
<!--- <cfdump var="#session.Usucodigo#"> --->
<!--- <cfdump var="#Session.Usucodigo#"> --->
<html><!-- InstanceBegin template="/Templates/LMenuDOC.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../../../js/DHTMLMenu/stm31.js"></script>
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
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      	<cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
		  	<cfset RolActual = 5>
			<cfset Session.RolActual = 5>
			<cfinclude template="../../../portlets/pEmpresas2.cfm">
		  </td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
	  			Docencia
      <!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../../portlets/pminisitio.cfm">
		  </td>
          <td valign="top" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" --> 
		  <cfinclude template="../jsMenuDOC.cfm" > 
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
          <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  	Conceptos de Evaluacion
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		    <cfquery name="rsCursoLectivo" datasource="#Session.DSN#">
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
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		 				and s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						and s.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
						and cu.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
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
			
		  	<cfquery datasource="#Session.DSN#" name="rsCursos">
			set nocount on
			select distinct (convert(varchar,c.Ccodigo) + '|' + convert(varchar,m.Ncodigo) + '|' + convert(varchar,c.PEcodigo) + '|' + convert(varchar,c.SPEcodigo) ) as codCurso, 
					(Mnombre+' '+GRnombre) as nombCurso
					, Norden, Gorden
			from Curso c, Materia m, Grupo g,  Staff s, Nivel n, Grado k,  PeriodoVigente v
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
 				and s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and s.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
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
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and s.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
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
	<!--- 	<cfdump var="#rsCursos#"> --->
		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select (convert(varchar,PEcodigo) + '|' + convert(varchar,pe.Ncodigo)) as PEcodigo, PEdescripcion
			from PeriodoEvaluacion pe, Nivel n
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and pe.Ncodigo=n.Ncodigo
			order by PEorden
		</cfquery>

	<script language="JavaScript" type="text/JavaScript">  
		var curso = new Array();				
		var cursoText = new Array();	
		var nivelCurso = new Array();			
		var PEcodigoCurso = new Array();					
		var SPEcodigoCurso = new Array();							

		// Esta función únicamente debe ejecutarlo una vez
		function obtenerCursos(f) {
			alert('obtenerCursos');
			
			for(i=0; i<f.Ccodigo.length; i++) {
				var s = f.Ccodigo.options[i].value.split("|");
				// Códigos de los detalles
				curso[i]= s[0];
				nivelCurso[i] = s[1];
				PEcodigoCurso[i] = s[2];						
				SPEcodigoCurso[i] = s[3];												
				cursoText[i] = f.Ccodigo.options[i].text;
			}
		}	
	
		function obtenerCursoLec(obj){
			alert('obtenerCursoLec');
			
			var hPer = obj.value.split("|");

			obj.form.PEcodigo.value = hPer[1];
			obj.form.SPEcodigo.value = hPer[2];				
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

			alert(curso.length + ' -- Carga Curso >> Nivel >>' + kNv_Nivel + ' -- kNv_PE >>' + kNv_PE + ' -- kNv_SPE >>' + kNv_SPE); 

			for (var i=0; i<curso.length; i++) {
				alert(nivelCurso[i] + '=' + kNv_Nivel + ' -- ' + PEcodigoCurso[i] + '=' + kNv_PE + ' -- ' + SPEcodigoCurso[i] + '=' + kNv_SPE); 
				
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
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
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
							<cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaConceptosEvalimpr.cfm">							
							<cfinvokeargument name="Param" value="&Ccodigo=#Ccodigo#&btnGenerar=#btnGenerar#&rdCortes=#rdCortes#&PEcodigo=#PEcodigo#">
							<cfinvokeargument name="Tipo" value="2">
						</cfinvoke>
					<cfelse>
						<!--- <cfinclude template="../../portlets/pNavegacionCED.cfm"> --->					
					</cfif>
				</td>
				
			</tr>
		</table>
		<form name="formListaConceptos" method="post" action="ListaConceptosEval.cfm" class="areaFiltro" >
 				<input name="PEcodigo" id="PEcodigo" type="hidden" value="">
 				<input name="SPEcodigo" id="SPEcodigo" type="hidden" value="">

				
		      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="11%" align="right"  class="subTitulo">&nbsp;</td>
                  <td width="21%"  class="subTitulo">&nbsp;</td>
                  <td width="26%"  class="subTitulo">&nbsp;</td>
                  <td width="42%"  class="subTitulo">&nbsp;</td>
                </tr>
                <tr>
                  <td align="right"  class="subTitulo">&nbsp;</td>
                  <td  class="subTitulo">&nbsp;</td>
                  <td  class="subTitulo">&nbsp;</td>
                  <td  class="subTitulo">&nbsp;</td>
                </tr>
                <tr>
                  <td align="right"  class="subTitulo">Curso Lectivo</td>
                  <td  class="subTitulo"><select name="cbCurLec" id="cbCurLec" onChange="javascript: cargarCursos(this,this.form.Ccodigo,'<cfif isdefined('Form.Ccodigo') AND Form.Ccodigo NEQ '-1'><cfoutput>#Form.Ccodigo#</cfoutput></cfif>',true); obtenerCursoLec(this);">
                      <cfoutput query="rsCursoLectivo"> 
                        <option value="#rsCursoLectivo.Codigo#" <cfif isdefined('form.btnGenerar') and isdefined('form.cbCurLec') and form.cbCurLec EQ '#rsCursoLectivo.Codigo#'>selected</cfif>>#rsCursoLectivo.Descripcion#</option>
                      </cfoutput> </select></td>
                  <td  class="subTitulo">&nbsp;</td>
                  <td  class="subTitulo">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="subTitulo" align="right">Curso:</td>
                  <td> <select name="Ccodigo" id="Ccodigo"  >
                      <cfoutput query="rsCursos"> 
                        <option value="#codCurso#" <cfif isdefined("Form.Ccodigo") and Form.Ccodigo EQ rsCursos.codCurso>selected</cfif>>#nombCurso#</option>
                      </cfoutput> </select> </td>
                  <td>&nbsp;</td>
                  <td align="left" nowrap> <input type="radio" name="rdCortes" value="SC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'SC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    Separar Grupo (Contínua) </td>
                </tr>
                <tr> 
                  <td class="subTitulo" align="right">Periodo:</td>
                  <td><select name="PEcodigo" id="PEcodigo "   >
                      <cfoutput query="rsPeriodo"> 
                        <cfif isdefined("form.PEcodigo") and #form.PEcodigo# EQ #rsPeriodo.PEcodigo#>
                          <option value="#rsPeriodo.PEcodigo#" selected>#rsPeriodo.PEdescripcion#</option>
                          <cfelse>
                          <option value="#rsPeriodo.PEcodigo#">#rsPeriodo.PEdescripcion#</option>
                        </cfif>
                      </cfoutput> </select></td>
                  <td>&nbsp;</td>
                  <td align="left" nowrap> <input type="radio" name="rdCortes" value="CxG" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'CxG'>checked</cfif>>
                    Separar Grupo (P&aacute;gina) </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="center"> 
                  <td colspan="4"> <input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" > 
                  </td>
                </tr>
                <tr> 
                  <td colspan="4">  </td>
                </tr>
              </table>

		</form>
		<cfif isdefined("form.btnGenerar")>
	        <cfinclude  template="formListaConceptosEval.cfm">
        </cfif>
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
			obtenerCursoLec(document.formListaConceptos.cbCurLec);
			obtenerCursos(document.formListaConceptos);
			cargarCursos(document.formListaConceptos.cbCurLec,document.formListaConceptos.Ccodigo, '<cfif isdefined("Form.Ccodigo") AND Form.Ccodigo NEQ "-1"><cfoutput>#Form.Ccodigo#</cfoutput></cfif>', true);											

				
//			obtenerCursoLectivo(document.formListaConceptos);	
//			obtenercursos(document.formListaConceptos);	
			//CargarCursoLectivo(document.formListaConceptos,'<cfif isdefined("Form.cbCurLec") AND Form.cbCurLec NEQ ""><cfoutput>#Form.cbCurLec#</cfoutput></cfif>');

//			cargarcursos(document.formListaConceptos.cbCurLec,'<cfif isdefined("Form.Ccodigo") AND Form.Ccodigo NEQ ""><cfoutput>#Form.Ccodigo#</cfoutput></cfif>');
//			obtenerPeriodos(document.formListaConceptos);
//			cargarPeriodo(document.formListaConceptos.cbCurLec, document.formListaConceptos.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>');	

		//------------------------------------------------------------------------------------------											
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("formListaConceptos");	
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
</body>
<!-- InstanceEnd --></html>
