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
            Histrico de Evaluaciones de Preescolar <!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  <cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGrupos">  
				Select distinct (convert(varchar,b.GRcodigo) + '|' + convert(varchar,c.Ncodigo)) as codigoGrupo,GRnombre
				from 	Alumnos a
						, GrupoAlumno b
						, Grupo c
						, Nivel d
						, Grado e
				where 	a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
						and Aretirado=0
						and Preesco=1
						and a.CEcodigo=b.CEcodigo
						and a.Ecodigo=b.Ecodigo
						and b.GRcodigo  = c.GRcodigo
						and c.Ncodigo=d.Ncodigo
						and c.SPEcodigo in (
							select SPEcodigo
							   from PeriodoVigente
							)
						and c.Gcodigo=e.Gcodigo
				order by Norden, Gorden, GRnombre
		</cfquery>

<!--- Consulta de Alumnos --->
	<cfquery name="rsPeriodo" datasource="#Session.Edu.DSN#">
		select (convert(varchar,PEcodigo) + '|' + convert(varchar,pe.Ncodigo)) as PEcodigo,PEdescripcion
		from PeriodoEvaluacion pe, Nivel n
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and pe.Ncodigo=n.Ncodigo
		order by PEorden
	</cfquery>
	
	<cfquery name="rsAlumno" datasource="#Session.Edu.DSN#">
	select  convert(varchar,ga.GRcodigo) + '|' + convert(varchar,c.Ecodigo) as Ecodigo,
			a.persona,
			(a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre) as Nombre,
			b.Pnombre,
			convert(varchar,a.Pnacimiento,103) as Pnacimiento, 
			a.Pid,
			f.Gdescripcion as Grado,
			case when c.Aretirado=0 then 'Activo' when c.Aretirado=1 then 'Retirado' when c.Aretirado=2 then 'Graduado' end as estado
		from PersonaEducativo a, Pais b, Alumnos c, Estudiante d, Grado f, Promocion e, Nivel g , Grupo gr , GrupoAlumno ga
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and e.PRactivo = 1 
			and a.Ppais    = b.Ppais 
			and a.persona  = c.persona 
			and a.CEcodigo = c.CEcodigo 
			and c.persona  = d.persona 
			and c.Ecodigo  = d.Ecodigo 
			and c.PRcodigo = e.PRcodigo 
			and e.Gcodigo  = f.Gcodigo 
			and e.Ncodigo  = f.Ncodigo 
			and f.Ncodigo  = g.Ncodigo
	        --and g.Ncodigo    = gr.Ncodigo
			and f.Ncodigo  = gr.Ncodigo
			and f.Gcodigo  = gr.Gcodigo 

			and e.Gcodigo  = gr.Gcodigo 
			and e.Ncodigo  = gr.Ncodigo 
			and e.PEcodigo = gr.PEcodigo 
			and e.SPEcodigo = gr.SPEcodigo 

			and ga.Ecodigo  = c.Ecodigo
			and ga.CEcodigo = c.CEcodigo
			and ga.GRcodigo = gr.GRcodigo

		order by g.Norden,f.Gorden,e.Gcodigo,c.Nombre
	</cfquery>

<script language="JavaScript" type="text/JavaScript">  
	var Alumnotext = new Array();
	var Ecodigo = new Array();
	var grupo= new Array();
	var periodos = new Array();					
	var periodosText = new Array();						
	var niveles = new Array();						
	var grupos= new Array();	
	var gruposText = new Array();
	var nivelesGrupos= new Array();	
	
	// Esta funci n nicamente debe ejecutarlo una vez
	function obtenerGrupos(f) {
		for(i=0; i<f.Grupo.length; i++) {
			var s = f.Grupo.options[i].value.split("|");
			// C digos de los detalles
			grupos[i]= s[0];
			gruposText[i] = f.Grupo.options[i].text;			
			nivelesGrupos[i] = s[1];									
		}
	}	
	
	/*function obtenerPeriodos(f) {
		for(i=0; i<f.PEcodigo.length; i++) {
			var s = f.PEcodigo.options[i].value.split("|");
			// Cdigos de los detalles
			periodos[i]= s[0];
			periodosText[i] = f.PEcodigo.options[i].text;			
			niveles[i] = s[1];									
		}
	}*/	
	
				
	function cargarGrupos(form, vdefault){				
		// Limpiar Combo
		for (var i=form.Grupo.length-1; i >=0; i--) {
			form.Grupo.options[i]=null;
		}
		
		if (grupos.length > 0) {
			for (var i=0; i<grupos.length; i++) {
				nuevaOpcion = new Option(gruposText[i],grupos[i]);
				form.Grupo.options[i]=nuevaOpcion;
				
				if (vdefault != null && grupos[i] == vdefault) {
					form.Grupo.selectedIndex = i;
				}					
			}
		}	
	}	
	
	
	function obtenerAlumno(f) {
		for(i=0; i<f.Alumno.length; i++) {
			var s = f.Alumno.options[i].value.split("|");
			// C digos de los detalles
			grupo[i]= s[0];
			Ecodigo[i] = s[1];
			Alumnotext[i] = f.Alumno.options[i].text;
		}
	}
	
	function cargarAlumno(csource, ctarget, vdefault){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 1;

			var nuevaOpcionTodos = new Option("-- Todos --",'-1');
			ctarget.options[0]=nuevaOpcionTodos;
			
			for (var i=0; i<grupo.length; i++) {
				if (grupo[i] == k) {
					nuevaOpcion = new Option(Alumnotext[i],Ecodigo[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && Ecodigo[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		}
		
	/*function cargarPeriodo(csource, ctarget, vdefault){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 1;

			var nuevaOpcionTodos = new Option("-- Todos --",'-1');
			ctarget.options[0]=nuevaOpcionTodos;

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
		}*/
		
		function poneAdicionales(obj){
			var connVerAdicionales	= document.getElementById("verAdicionales");
		
			if(obj.checked)
				connVerAdicionales.style.display = "";
			else 
				connVerAdicionales.style.display = "none";
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
			<cfif isdefined("form.TituloProfClase")>
				<cfset vParam = vParam  & "&TituloProfClase=" & #form.TituloProfClase#>							
			</cfif>			
			<cfif isdefined("form.FechaRep")>
				<cfset vParam = vParam  & "&FechaRep=" & #form.FechaRep#>							
			</cfif>			
			<cfif isdefined("form.Alumno")>
				<cfset vParam = vParam  & "&Alumno=" & #form.Alumno#>							
			</cfif>
			<cfif isdefined("form.PEcodigo")>
				<cfset vParam = vParam  & "&PEcodigo=" & #form.PEcodigo#>							
			</cfif>			
			<cfif isdefined("form.ckEsc")>
				<cfset vParam = vParam  & "&ckEsc=" & #form.ckEsc#>							
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
				<cfif isdefined("form.ckAdic1")>
					<cfset vParam = vParam  & "&ckAdic1=" & #form.ckAdic1#>							
				</cfif>
				<cfif isdefined("form.ckAdic2")>
					<cfset vParam = vParam  & "&ckAdic2=" & #form.ckAdic2#>							
				</cfif>				
			</cfif>	
			<cfif isdefined("form.nomAdicio1")>
				<cfset vParam = vParam  & "&nomAdicio1=" & #form.nomAdicio1#>							
			</cfif>						
			<cfif isdefined("form.nomAdicio2")>
				<cfset vParam = vParam  & "&nomAdicio2=" & #form.nomAdicio2#> 
			</cfif>
										
					
			<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaEvalPreeHistImpr.cfm">							
			<cfinvokeargument name="Param" value="#vParam#">
		</cfinvoke>
	<cfelse>
		<cfinclude template="../../portlets/pNavegacionCED.cfm">					
	</cfif>
	<script language="JavaScript1.2">
		function CambiaIdioma(ctl) {
			ctl.form.submit();
		}
	</script>
	</td>
  </tr>
</table>
<form name="formEvalPree" method="post" action="ListaEvalPreeHist.cfm" >
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td width="20%" class="subTitulo">Grupo</td>
                  <td width="32%" class="subTitulo">Titulo del Reporte</td>
                  <td width="33%" class="subTitulo">Profesor de Clase</td>
                  <td width="15%" class="subTitulo">Firmas</td>
                </tr>
                <tr> 
                  <td> <!--- <select name="Grupo" id="Grupo" onChange="javascript: cargarAlumno(this, this.form.Alumno, '<cfif isdefined("Form.Alumno")><cfoutput>#Form.Alumno#</cfoutput></cfif>'); cargarPeriodo(this, this.form.PEcodigo, '<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>');"> --->
					<select name="Grupo" id="Grupo" onChange="javascript: cargarAlumno(this, this.form.Alumno, '<cfif isdefined("Form.Alumno")><cfoutput>#Form.Alumno#</cfoutput></cfif>');">
						<cfoutput query="rsFiltroGrupos"> 
							<option value="#rsFiltroGrupos.codigoGrupo#">#rsFiltroGrupos.GRnombre#</option>
						</cfoutput>
					</select> 
				 </td>
                  <td><input name="TituloRep" type="text" id="TituloRep" size="50" maxlength="100" onClick="this.select()" value="<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''><cfoutput>#form.TituloRep#</cfoutput></cfif>"></td>
                  <td><input name="TituloProfClase" type="text" id="TituloProfClase" size="35" maxlength="35" onClick="this.select()" value="<cfif isdefined('form.TituloProfClase') and form.TituloProfClase NEQ ''><cfoutput>#form.TituloProfClase#</cfoutput></cfif>"></td>
                  <td nowrap><input type="checkbox" name="ckPM" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckPM')>checked</cfif>>
                    Padre/Madre </td>
                </tr>
                <tr> 
                  <td class="subTitulo">Alumnos</td>
                  <td class="subTitulo">Corte de Impresi&oacute;n</td>
                  <td class="subTitulo">Fecha de entrega</td>
                  <td><input type="checkbox" name="ckA" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckA')>checked</cfif>>
                    Alumno </td>
                </tr>
                <tr> 
                  <td> <select name="Alumno" id="Alumno">
                      <cfoutput query="rsAlumno"> 
                        <option value="#rsAlumno.Ecodigo#">#rsAlumno.Nombre#</option>
                      </cfoutput> </select> </td>
                  <td><a href="#"> </a> <input type="radio" class="areaFiltro" name="rdCortes" value="PC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                    Pgina Cont nua</td>
                  <td><a href="#"> 
                    <input name="FechaRep" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formEvalPree.FechaRep');"> 
                    </a> </td>
                  <td><input type="checkbox" name="ckP" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckP')>checked</cfif>>
                    Profesor</td>
                </tr>
                <tr> 
                  <td class="subTitulo"><!--- Periodo ---> <strong>Seleccionar Idioma:</strong></td>
                  <td class="subTitulo"><input type="radio" class="areaFiltro" name="rdCortes" value="PxA" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA'>checked</cfif>>
                    Pginas por Alumno</td>
                  <td rowspan="4" >
					<div style="display: ;" id="verAdicionales"> 
                      <table width="63%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="82%" class="subTitulo"><input name="ckAdic1" class="areaFiltro" type="checkbox" id="ckAdic1" value="checkbox" <cfif isdefined('form.ckAdic1')>checked</cfif>>
                            Adicional 1</td>
                        </tr>
                        <tr> 
                          <td class="subTitulo"><input name="nomAdicio1" type="text" id="nomAdicio12" value="<cfif isdefined('form.nomAdicio1') and form.nomAdicio1 NEQ ''><cfoutput>#form.nomAdicio1#</cfoutput><cfelse>Adicional 1</cfif>" size="50" maxlength="80"></td>
                        </tr>
                        <tr> 
                          <td ><input name="ckAdic2" type="checkbox" class="areaFiltro" id="ckAdic2" value="checkbox" <cfif isdefined('form.ckAdic2')>checked</cfif>>
                            Adicional 2</td>
                        </tr>
                        <tr> 
                          <td><input name="nomAdicio2" type="text" id="nomAdicio22" value="<cfif isdefined('form.nomAdicio2') and form.nomAdicio2 NEQ ''><cfoutput>#form.nomAdicio2#</cfoutput><cfelse>Adicional 2</cfif>" size="50" maxlength="80"></td>
                        </tr>
                      </table>
                    </div>				  
				  </td>
                  <td><input type="checkbox" name="ckD" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckD')>checked</cfif>>
                    Director</td>
                </tr>
                <tr> 
                  <td class="subTitulo"> <input type="hidden"  name="PEcodigo" value="-1"><!--- <select name="PEcodigo" id="PEcodigo "   >
                      <cfoutput query="rsPeriodo"> 
                        <cfif isdefined("form.PEcodigo") and #form.PEcodigo# EQ #rsPeriodo.PEcodigo#>
                          <option value="#rsPeriodo.PEcodigo#" selected>#rsPeriodo.PEdescripcion#</option>
                          <cfelse>
                          <option value="#rsPeriodo.PEcodigo#">#rsPeriodo.PEdescripcion#</option>
                        </cfif>
                      </cfoutput> </select> --->
					   <select name="Idioma" onChange="javascript:CambiaIdioma(this);">
							<option value="ES_CR" <cfif Session.Idioma EQ "ES_CR">selected</cfif>>Spanish (Modern)</option>
							<option value="EN" <cfif Session.Idioma EQ "EN">selected</cfif>>English (US)</option>
					  </select>
				  </td>
                  <td class="subTitulo">Visualizar en el reporte</td>
                  <td class="subTitulo"><input type="checkbox" name="ckAD" value="checkbox" onClick="javascript: poneAdicionales(this)" class="areaFiltro" <cfif isdefined('form.ckAD')>checked</cfif>>
                    Adicionales</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td><input type="checkbox" name="ckEsc" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckEsc')>checked</cfif>>
                    Tabla de Evaluaci&oacute;n </td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;
				  	 
				  </td>
                  <td><!--- <input type="checkbox" name="ckObs" value="checkbox" class="areaFiltro" <cfif isdefined('form.ckObs')>checked</cfif>>
                    OBSERVACIONES por periodo --->&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td height="41" colspan="4" align="center">
<input name="btnGenerar" type="submit" id="btnGenerar3" value="Reporte" ></td>
                </tr>
              </table>
              <cfif isdefined("form.btnGenerar")>  
		<table width="100%" border="0" cellspacing="0" cellpadding="0">  
			<tr>
				<td>
					 <cfinclude template="formListaEvalPreeHist.cfm">
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
	obtenerAlumno(document.formEvalPree);
	obtenerGrupos(document.formEvalPree);	
	cargarGrupos(document.formEvalPree,'<cfif isdefined("Form.Grupo") AND Form.Grupo NEQ ""><cfoutput>#Form.Grupo#</cfoutput></cfif>');
	//obtenerPeriodos(document.formEvalPree);
	cargarAlumno(document.formEvalPree.Grupo, document.formEvalPree.Alumno, '<cfif isdefined("Form.Alumno") AND Form.Alumno NEQ "-1"><cfoutput>#Form.Alumno#</cfoutput></cfif>');
	//cargarPeriodo(document.formEvalPree.Grupo, document.formEvalPree.PEcodigo, '<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ "-1"><cfoutput>#Form.PEcodigo#</cfoutput></cfif>');	
	poneAdicionales(document.formEvalPree.ckAD);
//------------------------------------------------------------------------------------------											
	function __isTieneAdic() {
		// Valida que por lo menos se seleccione uno de los campos de las firmas adicionales
		var bandera = false;
		
		if (this.obj.form.ckAD.checked) {
			if(this.obj.form.ckAdic1.checked)
				bandera = true;
	
			if(this.obj.form.ckAdic2.checked)
				bandera = true;
		}else{
			bandera = true;
		}

		if (!bandera){
			this.error = "Error, debe seleccional al menos uno de los campos para las firmas adicionales";
			this.obj.form.ckAdic1.focus();
		}
	}
//------------------------------------------------------------------------------------------								
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneAdic", __isTieneAdic);
	objForm = new qForm("formEvalPree");	
	
	objForm.Grupo.required = true;
	objForm.Grupo.description = "Grupo";		
	objForm.Grupo.validateTieneAdic();
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