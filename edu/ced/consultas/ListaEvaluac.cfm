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
            informe de evaluaciones<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
        <cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGrupos">
            Select distinct (convert(varchar,b.GRcodigo) + '|' + convert(varchar,c.Ncodigo)) as codigoGrupo,GRnombre 
			from Alumnos a , GrupoAlumno b , Grupo c , Nivel d , Grado e 
			where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
           		and Aretirado=0 
				and a.CEcodigo=b.CEcodigo 
				and a.Ecodigo=b.Ecodigo 
            	and b.GRcodigo = c.GRcodigo 
				and c.Ncodigo=d.Ncodigo 
				and c.SPEcodigo in ( select SPEcodigo from PeriodoVigente ) 
				and c.Gcodigo=e.Gcodigo 
            order by Norden, Gorden, GRnombre 
        </cfquery>
        <cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
            select Ncodigo, Ndescripcion 
			from Nivel 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and Preesco = 0
            order by Norden 
        </cfquery>
        <cfquery name="rsPeriodo" datasource="#Session.Edu.DSN#">
            select (convert(varchar,PEcodigo) + '|' + convert(varchar,pe.Ncodigo)) as PEcodigo,PEdescripcion 
			from PeriodoEvaluacion pe, Nivel n 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
            	and pe.Ncodigo=n.Ncodigo 
			order by PEorden 
        </cfquery>
        <cfquery name="rsMaterias" datasource="#Session.Edu.DSN#">
			select (convert(varchar,c.Mconsecutivo) + '|' + convert(varchar,m.Ncodigo) + '|' + convert(varchar,GRcodigo) + '|' + convert(varchar,Ccodigo)) as CodigoMat
				, Mnombre
			from Curso c
				, PeriodoVigente pv
				, Materia m
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and Melectiva in ('R','S')
				and m.Ncodigo=pv.Ncodigo		
        </cfquery>
 <script language="JavaScript" type="text/JavaScript">  
	var periodos = new Array();					
	var periodosText = new Array();						
	var niveles = new Array();						
	var grupos= new Array();	
	var gruposText = new Array();
	var nivelesGrupos= new Array();	
	var materias= new Array();	
	var materiasText = new Array();
	var nivelesMaterias= new Array();	
	var gruposMaterias= new Array();	
	
	// Esta funcin  nicamente debe ejecutarlo una vez
	function obtenerGrupos(f) {
		for(i=0; i<f.Grupo.length; i++) {
			var s = f.Grupo.options[i].value.split("|");
			// Cdigos de los detalles
			grupos[i]= s[0];
			gruposText[i] = f.Grupo.options[i].text;			
			nivelesGrupos[i] = s[1];									
		}
	}	

	function obtenerMateria(f) {
		for(i=0; i<f.Mcodigo.length; i++) {
			var s = f.Mcodigo.options[i].value.split("|");
			// C digos de los detalles
			materias[i]= s[0];
			materiasText[i] = f.Mcodigo.options[i].text;			
			nivelesMaterias[i] = s[1];
			gruposMaterias[i] = s[2];											
		}
	}	
	
	function obtenerPeriodos(f) {
		for(i=0; i<f.PEcodigo.length; i++) {
			var s = f.PEcodigo.options[i].value.split("|");
			// Cdigos de los detalles
			periodos[i]= s[0];
			periodosText[i] = f.PEcodigo.options[i].text;			
			niveles[i] = s[1];									
		}
	}
	
	function cargarGrupos(csource, ctarget, vdefault){
		// Limpiar Combo
		for (var i=ctarget.length-1; i >=0; i--) {
			ctarget.options[i]=null;
		}
		var k = csource.value;		
		var j = 0;
		
		for (var i=0; i<grupos.length; i++) {
			if (nivelesGrupos[i] == k) {
				nuevaOpcion = new Option(gruposText[i],grupos[i]);
				ctarget.options[j]=nuevaOpcion;
				if (vdefault != null && grupos[i] == vdefault) {
					ctarget.selectedIndex = j;
				}
				j++;
			}
		}
	}
	
	function cargarMateria(csource, ctarget, vdefault){
		// Limpiar Combo
		if(csource.form.Grupo.value != '-1'){
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 1;
				
			var nuevaOpcionTodos = new Option("-- Todos --",'-1');
			ctarget.options[0]=nuevaOpcionTodos;

			for (var i=0; i<materias.length; i++) {
				if (nivelesMaterias[i] == k && gruposMaterias[i] == csource.form.Grupo.value) {
					nuevaOpcion = new Option(materiasText[i],materias[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && materias[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		}else{
			for (var i=csource.form.Mcodigo.length-1; i >=0; i--) {
				csource.form.Mcodigo.options[i]=null;
			}
			csource.form.Mcodigo.options[0]=new Option("-- Todos --",'-1');		
		}
	}	
		
	function cargarPeriodo(csource, ctarget, vdefault){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 0;
			
			for (var i=0; i<grupos.length; i++) {
				if (grupos[i] == k) {
					for (var k=0; k<niveles.length; k++) {
						if(niveles[k] == nivelesGrupos[i]){
							nuevaOpcion = new Option(periodosText[k],periodos[k]);
							ctarget.options[j]=nuevaOpcion;
							if (vdefault != null && periodos[k] == vdefault) {
								ctarget.selectedIndex = j;
							}
							j++;							
						}
					}
					break;
				}
			}
		}
		
		function poneAdicionales(obj){
			var connVerAdicionales	= document.getElementById("verAdicionales");
		
			if(obj.checked)
				connVerAdicionales.style.display = "";
			else 
				connVerAdicionales.style.display = "none";
		}	
		
		function doConlis(f, opc) {
			if(opc == 1){	// Alumnos
				popUpWindow("conlisAlumnosEval.cfm?form=formEvalPree"
						+"&NombreAl=Alumno"
						+"&Ecodigo=Ecodigo" 
						+"&Ncodigo=" + f.Ncodigo.value
						+"&GRcodigo=" + f.Grupo.value,250,200,650,350);
			}else{	//Conceptos
				popUpWindow("conlisConcEval.cfm?form=formEvalPree"
						+"&NombConc=NombConc"
						+"&ECcodigo=ECcodigo" 
						+"&Mconsecutivo=" + f.Mcodigo.value
						+"&GRcodigo=" + f.Grupo.value
						+"&PEcodigo=" + f.PEcodigo.value,250,200,650,350);
			}
		} 
		
		function limpiar(obj) {
			obj.form.Ecodigo.value = '-1';
			obj.form.Alumno.value = '-- Todos --';
		} 
		
		function validaConc(f) {
			if(f.Grupo.value == ''){
				alert('Debe elegir primero un grupo');			
				f.Grupo.focus();
			}else{
				if(f.PEcodigo.value == ''){
					alert('Debe elegir primero un Per odo');
					f.PEcodigo.focus();
				}else{
					doConlis(f, 2);
				}			
			}
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
                        <cfset vParam = vParam  & "&btnGenerar=" & #form.btnGenerar#>
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
                      <cfif isdefined("form.FechaRep")>
                        <cfset vParam = vParam  & "&FechaRep=" & #form.FechaRep#>
                      </cfif>
                      <cfif isdefined("form.Ecodigo")>
                        <cfset vParam = vParam  & "&Ecodigo=" & #form.Ecodigo#>
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
                      <cfif isdefined("form.ckObs")>
                        <cfset vParam = vParam  & "&ckObs=" & #form.ckObs#>
                      </cfif>					  					  
                      <cfif isdefined("form.ckPM")>
                        <cfset vParam = vParam  & "&ckPM=" & #form.ckPM#>
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
                      <cfif isdefined("form.nomAdicio1")>
                         <cfset vParam = vParam  & "&nomAdicio1=" & #form.nomAdicio1#>
                      </cfif>
                      <cfif isdefined("form.nomAdicio2")>
                         <cfset vParam = vParam  & "&nomAdicio2=" & #form.nomAdicio2#>
                      </cfif>
                      <cfif isdefined("form.ECcodigo")>
                         <cfset vParam = vParam  & "&ECcodigo=" & #form.ECcodigo#>
                      </cfif>
					  					  
                      <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaEvaluacionesImpr.cfm">
                      <cfinvokeargument name="Param" value="#vParam#">
                    </cfinvoke>
                    <cfelse>
                    <cfinclude template="../../portlets/pNavegacionCED.cfm">
                  </cfif> </td>
              </tr>
            </table>
            <form name="formEvalPree" method="post" action="ListaEvaluac.cfm" >
				<input name="CursoSel" type="hidden" value="" id="CursoSel">
				<input name="Ecodigo" type="hidden" value="<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'><cfoutput>#form.Ecodigo#</cfoutput><cfelse>-1</cfif>" id="Ecodigo">				
				<input name="ECcodigo" type="hidden" value="<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1'><cfoutput>#form.ECcodigo#</cfoutput><cfelse>-1</cfif>" id="ECcodigo">								

              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td width="28%" class="subTitulo">Nivel</td>
                  <td width="31%" class="subTitulo">Titulo del Reporte</td>
                  <td width="28%" class="subTitulo">Visualizar en el reporte</td>
                  <td width="13%" class="subTitulo">Fecha de entrega</td>
                </tr>
                <tr> 
                  <td><select name="Ncodigo" id="Ncodigo" onChange="javascript: cargarGrupos(this,document.formEvalPree.Grupo,'<cfif isdefined('Form.Grupo') AND Form.Grupo NEQ ''><cfoutput>#Form.Grupo#</cfoutput></cfif>'); cargarPeriodo(this.form.Grupo, this.form.PEcodigo, '<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>'); cargarMateria(this,document.formEvalPree.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ '-1'><cfoutput>#Form.Mcodigo#</cfoutput></cfif>'); limpiar(this);">
                      <cfoutput query="rsNiveles"> 
                        <cfif isdefined('form.Ncodigo') and form.Ncodigo EQ rsNiveles.Ncodigo>
                          <option value="#rsNiveles.Ncodigo#" selected>#rsNiveles.Ndescripcion#</option>
                          <cfelse>
                          <option value="#rsNiveles.Ncodigo#">#rsNiveles.Ndescripcion#</option>
                        </cfif>
                      </cfoutput> </select> </td>
                  <td><input name="TituloRep" type="text" id="TituloRep" size="50" maxlength="100" onClick="this.select()" value="<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''><cfoutput>#form.TituloRep#</cfoutput></cfif>"></td>
                  <td><input name="ckPxC" type="checkbox" id="ckPxC2" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckPxC')> checked</cfif>>
                    Porcentajes por Concepto </td>
                  <td><a href="#"> 
                    <input name="FechaRep" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formEvalPree.FechaRep');"> 
                    </a></td>
                </tr>
                <tr> 
                  <td class="subTitulo">Grupo</td>
                  <td class="subTitulo">Corte de Impresi&oacute;n</td>
                  <td><input name="ckInci" type="checkbox" id="ckInci2" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckInci')> checked</cfif>>
                    Incidencias </td>
                  <td class="subTitulo">Firmas</td>
                </tr>
                <tr> 
                  <td><select name="Grupo" id="Grupo" onChange="javascript: cargarPeriodo(this, this.form.PEcodigo, '<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>'); cargarMateria(document.formEvalPree.Ncodigo,document.formEvalPree.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ '-1'><cfoutput>#Form.Mcodigo#</cfoutput></cfif>'); limpiar(this)">
                      <cfoutput query="rsFiltroGrupos"> 
                        <option value="#rsFiltroGrupos.codigoGrupo#">#rsFiltroGrupos.GRnombre#</option>
                      </cfoutput> </select> </td>
                  <td> 
                    <input type="radio" class="areaFiltro" name="rdCortes" value="PC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    Pgina Cont nua</td>
                  <td><input name="ckObs" type="checkbox" id="ckObs" value="ckObs" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckObs')> checked</cfif>>
                    Observaciones</td>
                  <td><input type="checkbox" name="ckPM" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckPM')>checked</cfif>>
                    Padre/Madre </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Alumnos</td>
                  <td><input type="radio" class="areaFiltro" name="rdCortes" value="PxA" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA'>checked</cfif>>
                    Pginas por Alumno</td>
                  <td>&nbsp;</td>
                  <td><input type="checkbox" name="ckA" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckA')>checked</cfif>>
                    Alumno </td>
                </tr>
                <tr> 
                  <td nowrap>
				  		<input name="Alumno" type="text" readonly="true" id="Alumno" size="40" maxlength="80" value="<cfif isdefined('form.Alumno') and form.Alumno NEQ '-- Todos --'><cfoutput>#form.Alumno#</cfoutput><cfelse>-- Todos --</cfif>">
				  		<a href="#"> 
							<img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis(document.formEvalPree, 1);">
						</a>
				  </td>
                  <td class="subTitulo">Periodo</td>
                  <td  class="subTitulo">Conceptos de Evaluaci&oacute;n</td>
                  <td><input type="checkbox" name="ckP" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckP')>checked</cfif>>
                    Profesor</td>
                </tr>
                <tr> 
                  <td class="subTitulo">Materia</td>
                  <td><select name="PEcodigo" id="PEcodigo" onChange="javascript: cargarMateria(document.formEvalPree.Ncodigo,document.formEvalPree.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ '-1'><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');">
                      <cfoutput query="rsPeriodo"> 
                          <option value="#rsPeriodo.PEcodigo#">#rsPeriodo.PEdescripcion#</option>
                      </cfoutput> </select></td>
                  <td>
				  	<input name="NombConc" type="text" id="NombConc" size="40" maxlength="80" value="<cfif isdefined('form.NombConc') and form.NombConc NEQ ''><cfoutput>#form.NombConc#</cfoutput><cfelse>-- Todos --</cfif>" readonly="true">
					<a href="#"> 
						<img src="../../Imagenes/Description.gif" alt="Lista de Encargados" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:validaConc(document.formEvalPree);">
					</a>				  
				  </td>
                  <td><input type="checkbox" name="ckD" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckD')>checked</cfif>>
                    Director</td>
                </tr>
                <tr> 
                  <td><select name="Mcodigo" id="Mcodigo">
                      <cfoutput query="rsMaterias"> 
                        <option value="#rsMaterias.CodigoMat#">#rsMaterias.Mnombre#</option>
                      </cfoutput> </select></td>
                  <td colspan="2" align="center">
					<div style="display: ;" id="verAdicionales"> 
                      <table width="70%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="18%">Adicional 1</td>
                          <td width="82%"><input name="nomAdicio1" type="text" id="nomAdicio1" value="<cfif isdefined('form.nomAdicio1') and form.nomAdicio1 NEQ ''><cfoutput>#form.nomAdicio1#</cfoutput><cfelse>Adicional 1</cfif>" size="60" maxlength="80"></td>
                        </tr>
                        <tr> 
                          <td>Adicional 2</td>
                          <td><input name="nomAdicio2" type="text" id="nomAdicio2" value="<cfif isdefined('form.nomAdicio2') and form.nomAdicio2 NEQ ''><cfoutput>#form.nomAdicio2#</cfoutput><cfelse>Adicional 2</cfif>" size="60" maxlength="80"></td>
                        </tr>
                      </table>
                    </div>				  
				  </td>
                  <td><input type="checkbox" name="ckAD" value="checkbox" onClick="javascript: poneAdicionales(this)" class="areaFiltro" <cfif isdefined('form.ckAD')>checked</cfif>>
                    Adicionales</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="3" align="center"><input name="btnGenerar" type="submit" id="btnGenerar" value="Reporte" ></td>
                </tr>

              </table>
              <cfif isdefined("form.btnGenerar")>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td> <cfinclude template="formListaEvaluaciones.cfm"> 
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
	obtenerGrupos(document.formEvalPree);	
	cargarGrupos(document.formEvalPree.Ncodigo,document.formEvalPree.Grupo,'<cfif isdefined("Form.Grupo") AND Form.Grupo NEQ ""><cfoutput>#Form.Grupo#</cfoutput></cfif>');
	obtenerPeriodos(document.formEvalPree);
	cargarPeriodo(document.formEvalPree.Grupo, document.formEvalPree.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>');	
	obtenerMateria(document.formEvalPree);
	cargarMateria(document.formEvalPree.Ncodigo, document.formEvalPree.Mcodigo, '<cfif isdefined("Form.Mcodigo") AND Form.Mcodigo NEQ "-1"><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');	
	poneAdicionales(document.formEvalPree.ckAD);
//------------------------------------------------------------------------------------------											
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEvalPree");	
	
	objForm.Ncodigo.required = true;
	objForm.Ncodigo.description = "Nivel";	
	objForm.Grupo.required = true;
	objForm.Grupo.description = "Grupo";
		
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