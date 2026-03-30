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
            Evaluaciones por Profesor<!-- InstanceEndEditable -->
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
			
        <cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGrupos">
            Select distinct (convert(varchar,gr.GRcodigo) + '|' + convert(varchar,gr.Ncodigo)) as codigoGrupo,GRnombre 
			from  Grupo gr , Nivel n , Grado gd, PeriodoVigente pv, Curso c, Staff st
			where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
				and st.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
				and gr.Ncodigo=n.Ncodigo 
				and gr.Gcodigo=gd.Gcodigo 
				and gr.PEcodigo=pv.PEcodigo
				and gr.SPEcodigo=pv.SPEcodigo
				and gr.GRcodigo=c.GRcodigo
				and n.CEcodigo=c.CEcodigo
				and pv.PEcodigo=c.PEcodigo
				and pv.SPEcodigo=c.SPEcodigo
				and c.CEcodigo=st.CEcodigo
				and c.Splaza=st.Splaza			
            order by Norden, Gorden, GRnombre 		
        </cfquery>

        <!--- <cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
            select convert(varchar,n.Ncodigo), Ndescripcion 
			from Nivel 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and Preesco = 0
            order by Norden 
        </cfquery> --->
        <cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
        	select distinct convert(varchar,n.Ncodigo) as Ncodigo, Ndescripcion 
		from  Grupo gr, Nivel n , Grado gd, PeriodoVigente pv, Curso c, Staff st
		where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		  and st.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">) --->
		  and gr.Ncodigo=n.Ncodigo 
		  and gr.Gcodigo=gd.Gcodigo 
		  and gr.PEcodigo=pv.PEcodigo
		  and gr.SPEcodigo=pv.SPEcodigo
		  and gr.GRcodigo=c.GRcodigo
		  and n.CEcodigo=c.CEcodigo
		  and pv.PEcodigo=c.PEcodigo
		  and pv.SPEcodigo=c.SPEcodigo
		  and c.CEcodigo=st.CEcodigo
		  and c.Splaza=st.Splaza	
		  and n.Preesco = 0
		group by n.Ncodigo, Ndescripcion          
        </cfquery>


        <cfquery name="rsPeriodo" datasource="#Session.Edu.DSN#">
            select (convert(varchar,PEcodigo) + '|' + convert(varchar,pe.Ncodigo)) as PEcodigo,PEdescripcion 
			from PeriodoEvaluacion pe, Nivel n 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
            	and pe.Ncodigo=n.Ncodigo 
			order by PEorden 
        </cfquery>
        <cfquery name="rsMaterias" datasource="#Session.Edu.DSN#">
			select (convert(varchar,c.Mconsecutivo) + '|' + convert(varchar,pv.Ncodigo) + '|' + convert(varchar,GRcodigo) + '|' + convert(varchar,Ccodigo)) as CodigoMat
				, Mnombre
			from Curso c
				, Staff st
				, PeriodoVigente pv
				, Materia m 
			where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and st.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
				and c.CEcodigo=st.CEcodigo
				and c.Splaza=st.Splaza
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and pv.Ncodigo=m.Ncodigo
				and c.Mconsecutivo=m.Mconsecutivo
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
		
		function doConlis(f) {
			//Conceptos
			popUpWindow("/cfmx/edu/ced/consultas/conlisConcEval.cfm?form=formEvalProf"
					+"&NombConc=NombConc"
					+"&ECcodigo=ECcodigo" 
					+"&Mconsecutivo=" + f.Mcodigo.value
					+"&GRcodigo=" + f.Grupo.value
					+"&PEcodigo=" + f.PEcodigo.value,250,200,650,350);
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
					doConlis(f);
				}			
			}
		} 		

</script>


            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> <cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
						<cfset vParam = "">
						<cfif isdefined("form.btnGenerar")>
							<cfset vParam = vParam  & "&btnGenerar=" & #form.btnGenerar#>
						</cfif>
						<cfif isdefined("form.Mcodigo")>
							<cfset vParam = vParam  & "&Mcodigo=" & #form.Mcodigo#>
						</cfif>												
						<cfif isdefined("form.rdCortes")>
							<cfset vParam = vParam  & "&rdCortes=" & #form.rdCortes#>
							<cfif form.rdCortes EQ 'PxC'>
								<cfset vParam = vParam  & "&imprime=1">
							</cfif>
						</cfif>
						<cfif isdefined("form.PEcodigo")>
							<cfset vParam = vParam  & "&PEcodigo=" & #form.PEcodigo#>
						</cfif>
						<cfif isdefined("form.ckPxC")>
							<cfset vParam = vParam  & "&ckPxC=" & #form.ckPxC#>
						</cfif>
						<cfif isdefined("form.Ncodigo")>
							<cfset vParam = vParam  & "&Ncodigo=" & #form.Ncodigo#>
						</cfif>						
						<cfif isdefined("form.Grupo")>
							<cfset vParam = vParam  & "&Grupo=" & #form.Grupo#>
						</cfif>
						<cfif isdefined("form.ECcodigo")>
							<cfset vParam = vParam  & "&ECcodigo=" & #form.ECcodigo#>
						</cfif>
						<cfif isdefined("form.Splaza")>
							<cfset vParam = vParam  & "&Splaza=" & #form.Splaza#>
						</cfif>												  
						
						<cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
													  
						  <cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaEvalXProfImpr.cfm">
						  <cfinvokeargument name="Tipo" value="2">
						  <cfinvokeargument name="Param" value="#vParam#">
						</cfinvoke>
                    <cfelse>
                    	<cfinclude template="../../portlets/pNavegacionDOC.cfm">
                    </cfif> 
				</td>
              </tr>
            </table>

            <form name="formEvalProf" method="post" action="ListaEvalXProf.cfm" >
			  <input name="ECcodigo" type="hidden" value="<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1'><cfoutput>#form.ECcodigo#</cfoutput><cfelse>-1</cfif>" id="ECcodigo">

              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td width="28%" class="subTitulo">Nivel</td>
                  <td width="29%" class="subTitulo">Periodo</td>
                  <td width="29%" class="subTitulo">Visualizar en el reporte</td>
                </tr>
                <tr> 
                  <td><select name="Ncodigo" id="Ncodigo" onChange="javascript: cargarGrupos(this,document.formEvalProf.Grupo,'<cfif isdefined('Form.Grupo') AND Len(Trim(Form.Grupo)) NEQ 0><cfoutput>#Form.Grupo#</cfoutput></cfif>');cargarPeriodo(this.form.Grupo, this.form.PEcodigo, '<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>'); cargarMateria(this,document.formEvalProf.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ -1><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');">
                      <cfoutput query="rsNiveles"> 
                        <cfif isdefined('form.Ncodigo') and form.Ncodigo EQ rsNiveles.Ncodigo>
                          <option value="#rsNiveles.Ncodigo#" selected>#rsNiveles.Ndescripcion#</option>
                          <cfelse>
                          <option value="#rsNiveles.Ncodigo#">#rsNiveles.Ndescripcion#</option>
                        </cfif>
                      </cfoutput> </select> 
					<input name="Splaza" type="hidden" value="<cfoutput>#ValueList(usr.num_referencia,',')#</cfoutput>" id="Splaza">
				</td>
                  <td><select name="PEcodigo" id="PEcodigo" onChange="javascript: cargarMateria(document.formEvalProf.Ncodigo,document.formEvalProf.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ -1><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');">
                      <cfoutput query="rsPeriodo"> 
                        <option value="#rsPeriodo.PEcodigo#">#rsPeriodo.PEdescripcion#</option>
                      </cfoutput> </select></td>
                  <td> <a href="#"> </a> <input name="ckPxC" type="checkbox" id="ckPxC" value="checkbox" class="areaFiltro" <cfif isdefined('form.btnGenerar') and isdefined('form.ckPxC')> checked</cfif>> 
                    Porcentajes por Concepto </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Grupo</td>
                  <td class="subTitulo">Conceptos de Evaluaci&oacute;n</td>
                  <td class="subTitulo">Corte de Impresi&oacute;n</td>
                </tr>
                <tr> 
                  <td><select name="Grupo" id="Grupo" onChange="javascript: cargarPeriodo(this, this.form.PEcodigo, '<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>'); cargarMateria(document.formEvalProf.Ncodigo,document.formEvalProf.Mcodigo,'<cfif isdefined('Form.Mcodigo') AND Form.Mcodigo NEQ '-1'><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');">
                      <cfoutput query="rsFiltroGrupos"> 
                        <option value="#rsFiltroGrupos.codigoGrupo#">#rsFiltroGrupos.GRnombre#</option>
                      </cfoutput> </select> </td>
                  <td><input name="NombConc" type="text" id="NombConc2" size="40" maxlength="80" value="<cfif isdefined('form.NombConc') and form.NombConc NEQ '-- Todos --'><cfoutput>#form.NombConc#</cfoutput><cfelse>-- Todos --</cfif>" readonly="true"> 
                    <a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Conceptos de Evaluacin" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:validaConc(document.formEvalProf);"> 
                    </a> </td>
                  <td><input type="radio" class="areaFiltro" name="rdCortes" value="PC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    P gina Contnua</td>
                </tr>
                <tr> 
                  <td class="subTitulo">Materia</td>
                  <td>&nbsp;</td>
                  <td><input type="radio" class="areaFiltro" name="rdCortes" value="PxC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxC'>checked</cfif>>
                    P ginas por Curso</td>
                </tr>
                <tr> 
                  <td><select name="Mcodigo" id="Mcodigo">
                      <cfoutput query="rsMaterias"> 
                        <option value="#rsMaterias.CodigoMat#">#rsMaterias.Mnombre#</option>
                      </cfoutput> </select> </td>
                  <td class="subTitulo" align="center"><input name="btnGenerar" type="submit" id="btnGenerar2" value="Reporte" ></td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              <cfif isdefined("form.btnGenerar")>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td>  <cfinclude template="formListaEvalXProf.cfm">
                    </td>
                  </tr>
                </table>
              </cfif>
            </form>

            <script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>			
            <script language="JavaScript" src="../../js/qForms/qforms.js">//</script>			
            <script language="JavaScript" type="text/javascript" >			
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("../../js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");			
			//------------------------------------------------------------------------------------------						
				obtenerGrupos(document.formEvalProf);	
				cargarGrupos(document.formEvalProf.Ncodigo,document.formEvalProf.Grupo,'<cfif isdefined("Form.Grupo") AND Form.Grupo NEQ ""><cfoutput>#Form.Grupo#</cfoutput></cfif>');
				obtenerPeriodos(document.formEvalProf);
				cargarPeriodo(document.formEvalProf.Grupo, document.formEvalProf.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>');	
				obtenerMateria(document.formEvalProf);
				cargarMateria(document.formEvalProf.Ncodigo, document.formEvalProf.Mcodigo, '<cfif isdefined("Form.Mcodigo") AND Form.Mcodigo NEQ "-1"><cfoutput>#Form.Mcodigo#</cfoutput></cfif>');	
				
				//------------------------------------------------------------------------------------------											
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("formEvalProf");
					
				objForm.Ncodigo.required = true;
				objForm.Ncodigo.description = "Nivel";	
				objForm.Grupo.required = true;
				objForm.Grupo.description = "Grupo";				
				objForm.PEcodigo.required = true;
				objForm.PEcodigo.description = "Perodo";								
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