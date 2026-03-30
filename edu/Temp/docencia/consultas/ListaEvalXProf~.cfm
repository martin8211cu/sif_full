<cfinclude template="../../Utiles/general.cfm">
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
              Docencia<!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../../portlets/pminisitio.cfm">
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
          <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Informe de Evaluaciones<!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
          <cfquery datasource="#Session.DSN#" name="rsCursos">
				select 	convert(varchar,Ccodigo) + '|' + convert(varchar,pv.Ncodigo) as Ccodigo  , (Mnombre + '' + GRnombre) as CursoNombre
				from Curso c, PeriodoVigente pv, Materia m, Grupo gr, Nivel n, Staff st
				where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">					
					and retirado=0				
					and c.PEcodigo=pv.PEcodigo
					and c.SPEcodigo=pv.SPEcodigo
					and c.Mconsecutivo=m.Mconsecutivo
					and m.Ncodigo=gr.Ncodigo
					and c.GRcodigo=gr.GRcodigo
					and c.PEcodigo=gr.PEcodigo
					and c.SPEcodigo=gr.SPEcodigo
					and gr.Ncodigo=n.Ncodigo
					and c.CEcodigo=st.CEcodigo
					and c.Splaza=st.Splaza
				Order by Norden, Ccodigo, CursoNombre		  
            </cfquery>
			
          <cfquery datasource="#Session.DSN#" name="rsPeriodos">
				Select (convert(varchar, PEcodigo) + '|' +  convert(varchar,pe.Ncodigo)) as CodPER , PEdescripcion
				from PeriodoEvaluacion pe, Nivel n
				Where pe.Ncodigo=n.Ncodigo
					and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				Order by Norden, PEdescripcion		  
          </cfquery>
			
			
            <table width="100%" border="0">
              <tr> 
                <td> 
				<cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
				 	<cfset Param = "">
                    <cfif isdefined("form.Ccodigo") and form.Ccodigo NEQ "">
                      <cfset Param = "Ccodigo=#form.Ccodigo#">
                    </cfif>
                    <cfif isdefined("form.cbPeriodos") and form.cbPeriodos NEQ "">
                      <cfset Param = "cbPeriodos=#form.cbPeriodos#">
                    </cfif>					
					
                    <cfif isdefined("form.rdCorte")>
						<cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "rdCorte=" & Form.rdCorte>						
						<cfset Param = Param & "&imprime=1">						
                    </cfif>			 		
					
                    <cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
                      <cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaEvalXProfImpr.cfm">
					  <cfinvokeargument name="Tipo" value="2">
                      <cfinvokeargument name="Param" value="#Param#">
                    </cfinvoke>
                    <cfelse>
                    <cfinclude template="../../portlets/pNavegacionDOC.cfm">
                  </cfif> </td>
              </tr>
              <tr> 
                <td><form name="formFiltroEval" method="post" action="ListaEvalXProf.cfm" >
					<input name="Ccodigo" type="hidden" value="" id="Ccodigo">
					
                    <table class="area" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="10%" align="right">Cursos </td>
                        <td width="22%"> <select name="cbCursos" id="cbCursos" onChange="javascript: cargaCcodigo(this); cambioCurso(this); cargarPeriodo(this, document.formFiltroEval.cbPeriodos, '<cfif isdefined("Form.cbPeriodos") AND Form.cbPeriodos NEQ "-1"><cfoutput>#Form.cbPeriodos#</cfoutput></cfif>');">
                            <option value="-1" <cfif isdefined("form.cbCursos") and form.cbCursos EQ "-1">selected</cfif>>- 
                            Todos -</option>
                            <cfoutput query="rsCursos"> 
                              <option value="#rsCursos.Ccodigo#" <cfif isdefined("form.cbCursos") and form.cbCursos EQ #rsCursos.Ccodigo#>selected</cfif>>#rsCursos.CursoNombre#</option>
                            </cfoutput> </select></td>
                        <td width="15%" align="right">Períodos: </td>
                        <td width="24%">
							<select name="cbPeriodos" id="cbPeriodos">
                            	<cfoutput query="rsPeriodos"> 
                              	<option value="#rsPeriodos.CodPER#">#rsPeriodos.PEdescripcion#</option>
                            	</cfoutput> 
							</select>
						</td>
                        <td width="29%"> <div style="display: ;" id="verCursoTodos"> 
                            <table width="100%" class="area" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td align="center" valign="middle"><input border="0" checked class="area" type="radio" name="rdCorte" value="PC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PC'> checked </cfif>> 
                                </td>
                                <td>P&aacute;ginas continuas</td>
                              </tr>
                              <tr> 
                                <td align="center" valign="middle"><input border="0" class="area" type="radio" name="rdCorte" value="PXC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXC'> checked </cfif>></td>
                                <td>P&aacute;gina por Curso</td>
                              </tr>
                            </table>
                          </div></td>
                      </tr>
                      <tr> 
                        <td colspan="5" align="center" valign="middle">&nbsp;</td>
                      </tr>					  
                      <tr> 
                        <td colspan="5" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar2" value="Generar"> 
                          <hr></td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
              <cfif isdefined("form.btnGenerar")>
                <tr> 
                  <td height="21">&nbsp;</td>
                </tr>
              </cfif>
            </table>
			<cfif isdefined('form.btnGenerar')>
	            <cfinclude template="formListaEvalXProf.cfm">
			</cfif>
            <script language="JavaScript" type="text/javascript">
				var periodos = new Array();					
				var periodosText = new Array();						
				var nivelesXPeriodo = new Array();			
				
				function cargaCcodigo(obj) {
					var s = obj.value.split("|");

					obj.form.Ccodigo.value= s[0];
				}		
			
				// Esta función únicamente debe ejecutarlo una vez
				function obtenerPeriodos(f) {
					for(i=0; i<f.cbPeriodos.length; i++) {
						var s = f.cbPeriodos.options[i].value.split("|");
						// Códigos de los detalles
						periodos[i]= s[0];
						periodosText[i] = f.cbPeriodos.options[i].text;			
						nivelesXPeriodo[i] = s[1];
					}									
				}

				function cargarPeriodo(csource, ctarget, vdefault){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var s = csource.value.split("|");
					var k = s[1];	//Codigo del Nivel
					var j = 0;
	
					if(csource.value != '-1'){
						for (var i=0; i<periodos.length; i++) {
							if (nivelesXPeriodo[i] == k) {
								nuevaOpcion = new Option(periodosText[i],periodos[i]);
								ctarget.options[j]=nuevaOpcion;
								if (vdefault != null && periodos[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;							
							}
						}					
					}else{					
						for (var i=0; i<periodos.length; i++) {
							nuevaOpcion = new Option(periodosText[i],periodos[i]);
							ctarget.options[j]=nuevaOpcion;
							if (vdefault != null && periodos[i] == vdefault) {
								ctarget.selectedIndex = j;
							}
							j++;							
						}
					}				
				}							
			
				function inicio(){
					var cbCursos = document.getElementById('cbCursos');
					
					cambioCurso(cbCursos);
				}
				
				function cambioCurso(obj){
					var connVerCursoTodos 	= document.getElementById("verCursoTodos");
				
					if(obj.value == '-1')
						connVerCursoTodos.style.display = "";
					else
						connVerCursoTodos.style.display = "none";
				}
				inicio();
				obtenerPeriodos(document.formFiltroEval);
				cargarPeriodo(document.formFiltroEval.cbCursos, document.formFiltroEval.cbPeriodos, '<cfif isdefined("Form.cbPeriodos") AND Form.cbPeriodos NEQ "-1"><cfoutput>#Form.cbPeriodos#</cfoutput></cfif>');				
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
