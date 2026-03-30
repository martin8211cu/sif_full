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
		  	<cfif isdefined('form.rdTipoRep')>
				<cfif form.rdTipoRep EQ 'AA'>
					Alumnos Aplazados
				<cfelse>
					Alumnos con los Mejores Promedios				
				</cfif>
			<cfelse>
				Mejores Promedios y Alumnos Aplazados
			</cfif>
           <!-- InstanceEndEditable -->
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
		
		
 <script language="JavaScript" type="text/JavaScript">  
	var niveles = new Array();						
	var grupos= new Array();	
	var gruposText = new Array();
	var nivelesGrupos= new Array();	

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
	
	function doConlis(f) {
		popUpWindow("conlisAlumnosEval.cfm?form=formPromedios"
				+"&NombreAl=Alumno"
				+"&Ecodigo=Ecodigo" 
				+"&Ncodigo=" + f.Ncodigo.value
				+"&GRcodigo=" + f.Grupo.value,250,200,650,350);
	} 
		
	function limpiar(obj) {
		obj.form.Ecodigo.value = '-1';
		obj.form.Alumno.value = '-- Todos --';
	} 
	
	function verMayor(obj){
		var connVerMayor	= document.getElementById("verMayor");
	
		if(obj.value == 'MP')
			connVerMayor.style.display = "";
		else 
			connVerMayor.style.display = "none";
	}	
	
	function verMayorInicio(valor){
		var connVerMayor	= document.getElementById("verMayor");
	
		if(valor != ''){
			if(valor == 'MP')
				connVerMayor.style.display = "";
			else 
				connVerMayor.style.display = "none";
		}else{
			connVerMayor.style.display = "none";		
		}
	}		
	
	function verificaNota(obj){
		if (new Number(obj.value) > 100) {		
			alert('Error, digit  un promedio mayor al 100 %')
			obj.focus();
			obj.select();			
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
                      <cfif isdefined("form.rdTipoRep")>
                        <cfset vParam = vParam  & "&rdTipoRep=" & #form.rdTipoRep#>
                        <cfset vParam = vParam  & "&MayorQue=" & #form.MayorQue#>						
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
					  					  
                      <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaPromediosImpr.cfm">
                      <cfinvokeargument name="Param" value="#vParam#">
                    </cfinvoke>
                    <cfelse>
                    <cfinclude template="../../portlets/pNavegacionCED.cfm">
                  </cfif> </td>
              </tr>
            </table>
            <form name="formPromedios" method="post" action="ListaPromedios.cfm" >
				<input name="Ecodigo" type="hidden" value="<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'><cfoutput>#form.Ecodigo#</cfoutput><cfelse>-1</cfif>" id="Ecodigo">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td width="27%" class="subTitulo">Nivel</td>
                  <td width="31%" class="subTitulo">Titulo del Reporte</td>
                  <td class="subTitulo">Tipo de reporte</td>
                </tr>
                <tr> 
                  <td><select name="Ncodigo" id="select" onChange="javascript: cargarGrupos(this,document.formPromedios.Grupo,'<cfif isdefined('Form.Grupo') AND Form.Grupo NEQ ''><cfoutput>#Form.Grupo#</cfoutput></cfif>'); limpiar(this);">
                      <cfoutput query="rsNiveles"> 
                        <cfif isdefined('form.Ncodigo') and form.Ncodigo EQ rsNiveles.Ncodigo>
                          <option value="#rsNiveles.Ncodigo#" selected>#rsNiveles.Ndescripcion#</option>
                          <cfelse>
                          <option value="#rsNiveles.Ncodigo#">#rsNiveles.Ndescripcion#</option>
                        </cfif>
                      </cfoutput> </select> </td>
                  <td><input name="TituloRep" type="text" id="TituloRep2" size="50" maxlength="100" onClick="this.select()" value="<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''><cfoutput>#form.TituloRep#</cfoutput></cfif>"></td>
                  <td width="25%"><input type="radio" name="rdTipoRep" onClick="javascript: verMayor(this);" value="AA" class="areaFiltro" <cfif isdefined('form.rdTipoRep') and form.rdTipoRep EQ 'AA'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdTipoRep')>checked</cfif>>
                    Alumnos Aplazados</td>
                </tr>
                <tr> 
                  <td class="subTitulo">Grupo</td>
                  <td class="subTitulo">Fecha de entrega</td>
                  <td><input type="radio" name="rdTipoRep" onClick="javascript: verMayor(this);" value="MP" class="areaFiltro" <cfif isdefined('form.rdTipoRep') and form.rdTipoRep EQ 'MP'>checked</cfif>>
                    Mejores Promedios</td>
                </tr>
                <tr> 
                  <td><select name="Grupo" id="Grupo" onChange="javascript: limpiar(this);">
                      <cfoutput query="rsFiltroGrupos"> 
                        <option value="#rsFiltroGrupos.codigoGrupo#">#rsFiltroGrupos.GRnombre#</option>
                      </cfoutput> </select> </td>
                  <td><a href="#"> 
                    <input name="FechaRep" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formPromedios.FechaRep');"> 
                    </a> </td>
                  <td> <div style="display: ;" id="verMayor"> Mayor que 
                      <input name="MayorQue" type="text" id="MayorQue2" onFocus="this.select()" style="text-align: right" onBlur="javascript: verificaNota(this);" onKeyUp="javascript: snumber(this,5,0);" value="<cfif isdefined('form.MayorQue') and form.MayorQue NEQ '80'><cfoutput>#form.MayorQue#</cfoutput><cfelse>80</cfif>" size="8" maxlength="8">
                      % </div></td>
                </tr>
                <tr> 
                  <td class="subTitulo">Alumnos</td>
                  <td class="subTitulo">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap> <input name="Alumno" type="text" readonly="true" id="Alumno2" size="40" maxlength="80" value="<cfif isdefined('form.Alumno') and form.Alumno NEQ '-- Todos --'><cfoutput>#form.Alumno#</cfoutput><cfelse>-- Todos --</cfif>"> 
                    <a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis(document.formPromedios);"> 
                    </a> </td>
                  <td colspan="2" align="center"><input name="btnGenerar" type="submit" id="btnGenerar" value="Reporte" ></td>
                </tr>
              </table>
              <cfif isdefined("form.btnGenerar")>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td> 
						<cfif isdefined("form.rdTipoRep") and form.rdTipoRep EQ 'AA'>
							<cfinclude template="formListaAAplazados.cfm">						
						<cfelse>
							<cfinclude template="formListaMejoresPromedios.cfm">
						</cfif>
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
				
				function __isMayorQue(valor) {
					// Valida que si se selecciona el tipo de reporte de mejores promedios
					// se digite el valor de "mayor que"

					if (this.obj.form.rdTipoRep[1].checked) {
						if(this.obj.form.MayorQue.value == ""){
							this.error = "Error, debe digitar el valor de Mayor Que";
							this.obj.form.MayorQue.focus();
						}
					}
				}				
			//------------------------------------------------------------------------------------------						
				obtenerGrupos(document.formPromedios);	
				cargarGrupos(document.formPromedios.Ncodigo,document.formPromedios.Grupo,'<cfif isdefined("Form.Grupo") AND Form.Grupo NEQ ""><cfoutput>#Form.Grupo#</cfoutput></cfif>');
				verMayorInicio('<cfif isdefined("Form.rdTipoRep") AND Form.rdTipoRep NEQ ""><cfoutput>#Form.rdTipoRep#</cfoutput></cfif>');
			//------------------------------------------------------------------------------------------											
				qFormAPI.errorColor = "#FFFFCC";
				_addValidator("isMayorQue", __isMayorQue);
				objForm = new qForm("formPromedios");	
				
				objForm.Ncodigo.required = true;
				objForm.Ncodigo.description = "Nivel";	
				objForm.Grupo.required = true;
				objForm.Grupo.description = "Grupo";
				
				objForm.Grupo.validateMayorQue();
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