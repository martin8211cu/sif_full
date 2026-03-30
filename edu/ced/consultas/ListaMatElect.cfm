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
            Materias Electivas<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
				select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion 
				from Nivel 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				order by Norden
			</cfquery>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
				select convert(varchar, b.Ncodigo)
					   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
					   b.Gdescripcion
				from Nivel a, Grado b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ncodigo = b.Ncodigo 
				order by a.Norden, b.Gorden
			</cfquery>
			
			<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
				select convert(varchar, a.Ncodigo)
					   + '|' + convert(varchar, a.Gcodigo)
					   + '|' + convert(varchar, a.GRcodigo) as GRcodigo,GRnombre
				from Grupo a, PeriodoVigente b, Nivel c, Grado d
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.Ncodigo=b.Ncodigo
					and b.Ncodigo=c.Ncodigo
					and a.Gcodigo=d.Gcodigo
					and a.PEcodigo=b.PEcodigo
					and a.SPEcodigo=b.SPEcodigo
				order by Norden,Gorden,GRnombre			
			</cfquery>
	
			<script language="JavaScript" type="text/javascript">
				var grupostext = new Array();
				var grupos = new Array();	
				var gradosGrupo = new Array();
				var nivelesGrupo = new Array();
						
				var gradostext = new Array();
				var grados = new Array();
				var niveles = new Array();
			
				// Esta funcin  nicamente debe ejecutarlo una vez
				function obtenerGrados(f) {
					for(i=0; i<f.FGcodigo.length; i++) {
						var s = f.FGcodigo.options[i].value.split("|");
						// Cdigos de los detalles
						niveles[i]= s[0];
						grados[i] = s[1];
						gradostext[i] = f.FGcodigo.options[i].text;
					}
				}
				
				function obtenerGrupos(f) {
					for(i=0; i<f.FGRcodigo.length; i++) {
						var s = f.FGRcodigo.options[i].value.split("|");
						// C digos de los detalles
						nivelesGrupo[i]= s[0];
						gradosGrupo[i] = s[1];
						grupos[i] = s[2];				
						grupostext[i] = f.FGRcodigo.options[i].text;
					}
				}
						
				
				function cargarGrupos(csourceNiv,csource, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var kNv = csourceNiv.value;
					var k = csource.value;
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("Todos","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}			
					if (k != "-1" && kNv != '-1') {	// Solo verifica los grupos para el Nivel y el Grado seleccionados
						for (var i=0; i<grupos.length; i++) {
							if (nivelesGrupo[i] == kNv && gradosGrupo[i] == k) {
								nuevaOpcion = new Option(grupostext[i],grupos[i]);
								ctarget.options[j]=nuevaOpcion;
		
								if (vdefault != null && grupos[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {
						if (kNv == "-1" && k != "-1") {	// Solo verifica los grupos para el Grado seleccionado, sin importar el Nivel
							for (var i=0; i<grupos.length; i++) {
								if (gradosGrupo[i] == k) {
									nuevaOpcion = new Option(grupostext[i],grupos[i]);
									ctarget.options[j]=nuevaOpcion;
			
									if (vdefault != null && grupos[i] == vdefault) {
										ctarget.selectedIndex = j;
									}
									j++;
								}
							}				
						}else{
							if (kNv != "-1" && k == "-1") {	// Solo verifica los grupos por el Nivel seleccionado sin importar el Grado
								for (var i=0; i<grupos.length; i++) {
									if (nivelesGrupo[i] == kNv) {
										nuevaOpcion = new Option(grupostext[i],grupos[i]);
										ctarget.options[j]=nuevaOpcion;
				
										if (vdefault != null && grupos[i] == vdefault) {
											ctarget.selectedIndex = j;
										}
										j++;
									}
								}
							}else{		// Solo verifica los grupos Sin filtrar ni por Nivel ni por Grado										
								for (var i=0; i<grupos.length; i++) {
									nuevaOpcion = new Option(grupostext[i],grupos[i]);
									ctarget.options[i+1]=nuevaOpcion;
									if (vdefault != null && grupos[i] == vdefault) {
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
		
				function cargarGrados(csource, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var k = csource.value;
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("Todos","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}
					if (k != "-1") {
						for (var i=0; i<grados.length; i++) {
							if (niveles[i] == k) {
								nuevaOpcion = new Option(gradostext[i],grados[i]);
								ctarget.options[j]=nuevaOpcion;
		
								if (vdefault != null && grados[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {
						for (var i=0; i<grados.length; i++) {
							nuevaOpcion = new Option(gradostext[i],grados[i]);
							ctarget.options[i+1]=nuevaOpcion;
							if (vdefault != null && grados[i] == vdefault) {
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
				
				function electivasXGrupo(obj){
					var connVerEstud 	= document.getElementById("verEstud");
					var connVerDiaEstud 	= document.getElementById("verDiaEstud");			
		
					if((obj.checked) && (obj.value == 'TipoRepEG')){
						connVerEstud.style.display = "";
						connVerDiaEstud.style.display = "";
					}else{
						connVerEstud.style.display = "none";
						connVerDiaEstud.style.display = "none";
						obj.form.NombreAl.value = "";
						obj.form.Ecodigo.value = "";
						obj.form.Dia.value = "T";
					}
				}
				
				function electivasXGrupoInicio(obj){
					var connVerEstud 	= document.getElementById("verEstud");
					var connVerDiaEstud 	= document.getElementById("verDiaEstud");			
			
					if(obj[2].checked){
						connVerEstud.style.display = "";
						if(obj[2].form.NombreAl.value == "")
							connVerDiaEstud.style.display = "";
						else
							connVerDiaEstud.style.display = "none";
					}else{
						connVerEstud.style.display = "none";
						connVerDiaEstud.style.display = "none";
						obj[2].form.NombreAl.value = "";
						obj[2].form.Ecodigo.value = "";
						obj[2].form.Dia.value = "T";
					}
				}		
				
				function inicio(obj){
					electivasXGrupoInicio(obj);
				}
				
				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function doConlis() {
					popUpWindow("conlisAlumnos.cfm?form=formMatElectSust"
								+"&Ecodigo=Ecodigo"
								+"&NombreAl=NombreAl",250,200,650,350);
				} 
				
				function limpiaAl(obj){
				
				if(obj.form.TipoRep[2].checked){
					var connVerDiaEstud 	= document.getElementById("verDiaEstud");			
					connVerDiaEstud.style.display = "";
				}
				
					obj.form.NombreAl.value = "";
					obj.form.Ecodigo.value = "";
					obj.form.Dia.value = "T";
					
					obj.form.FNcodigo.value = "-1";			
					obj.form.FGcodigo.value = "-1";			
					obj.form.FGRcodigo.value = "-1";			
				}				
			</script>		  
		  
            <table width="100%" border="0">
              <tr>
                <td>
					<cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
						<cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
					<!--- Electivas con Sustitutivas --->
						<cfif isdefined('form.TipoRep') and form.TipoRep EQ 'TipoRepES'>
								<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/formListaMatElect_SustImpr.cfm">
								<cfinvokeargument name="Param" value="&FNcodigo=#form.FNcodigo#&FGcodigo=#form.FGcodigo#&FGRcodigo=#form.FGRcodigo#">
					<!--- Alumnos por Electivas --->								
						<cfelseif isdefined('form.TipoRep') and form.TipoRep EQ 'TipoRepAE'>
								<cfif isdefined("form.btnGenerar") <!--- and form.FGcodigo NEQ "-1" --->>
									<cfset btnGenerar = #form.btnGenerar#>	
								</cfif>	
															
								<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaMatElect_AlumnoImpr.cfm">							
								<cfinvokeargument name="Param" value="&FNcodigo=#form.FNcodigo#&FGcodigo=#form.FGcodigo#&btnGenerar=#btnGenerar#&FGRcodigo=#form.FGRcodigo#">								
					<!--- Electivas por Grupos --->								
						<cfelseif isdefined('form.TipoRep') and form.TipoRep EQ 'TipoRepEG'>
								<cfif isdefined("form.btnGenerar")>
									<cfset btnGenerar = #form.btnGenerar#>	
								</cfif>
								<cfif isdefined("form.Dia")>
									<cfset Dia = #form.Dia#>	
								</cfif>
								<cfif isdefined("form.Ecodigo")>
									<cfset Ecodigo = #form.Ecodigo#>	
								</cfif>
								<cfif isdefined("form.rdCortes")>
									<cfset rdCortes = #form.rdCortes#>	
								</cfif>
																								
								<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaMatSust_GrupoImpr.cfm">							
								<cfinvokeargument name="Param" value="&FNcodigo=#form.FNcodigo#&FGcodigo=#form.FGcodigo#&btnGenerar=#btnGenerar#&FGRcodigo=#form.FGRcodigo#&Dia=#Dia#&Ecodigo=#Ecodigo#&rdCortes=#rdCortes#">
							</cfif>
						</cfinvoke>
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionCED.cfm">					
					</cfif>
				</td>
              </tr>
              <tr>
                <td>
					<form name="formMatElectSust" method="post" action="ListaMatElect.cfm" >
                    <cfset banderaES = ''>
					<cfset banderaAE = ''>
					<cfset banderaEG = ''>
					
					
					<cfif isdefined('form.TipoRep') and form.TipoRep EQ 'TipoRepEG'>
						<cfset banderaEG = 'checked'>
					<cfelseif isdefined('form.TipoRep') and form.TipoRep EQ 'TipoRepAE'>
						<cfset banderaAE = 'checked'>					
					<cfelse>			
						<cfset banderaES = 'checked'>
					</cfif>
					
						
                    <table width="100%" border="0">
                      <tr> 
                        <td class="subTitulo">Nivel</td>
                        <td class="subTitulo">Grado</td>
                        <td class="subTitulo">Grupo</td>
                        <td width="15%" rowspan="2" align="center"><input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript: limpiaAl(this)">
                          <input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" ></td>
                      </tr>
                      <tr> 
                        <td> <select name="FNcodigo" id="FNcodigo" onChange="javascript: cargarGrados(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true); cargarGrupos(this,this.form.FGcodigo, this.form.FGRcodigo, '<cfif isdefined("Form.FGRcodigo")><cfoutput>#Form.FGRcodigo#</cfoutput></cfif>', true)">
                            <option value="-1">Todos</option>
                            <cfoutput query="rsNiveles"> 
                              <option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
                            </cfoutput> </select> </td>
                        <td> <select name="FGcodigo" id="FGcodigo" onChange="javascript: cargarGrupos(this.form.FNcodigo,this, this.form.FGRcodigo, '<cfif isdefined("Form.FGRcodigo")><cfoutput>#Form.FGRcodigo#</cfoutput></cfif>', true)">
                            <cfoutput query="rsGrado"> 
                              <option value="#Codigo#" >#Gdescripcion#</option>
                            </cfoutput> </select> </td>
                        <td> <select name="FGRcodigo" id="FGRcodigo">
                            <cfoutput query="rsGrupos"> 
                              <option value="#GRcodigo#" >#GRnombre#</option>
                            </cfoutput> </select> </td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center"> <div style="display: ;" id="verEstud"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td class="subTitulo">Estudiante</td>
                              </tr>
                              <tr> 
                                <td nowrap> <input name="NombreAl" type="text" id="NombreAl" size="80" maxlength="180" readonly="true" value="<cfif isdefined("form.btnGenerar") and isdefined("form.NombreAl") AND #form.NombreAl# NEQ "" ><cfoutput>#form.NombreAl#</cfoutput></cfif>"> 
                                  <a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();" > 
                                  </a> </td>
                              </tr>
							  <input name="Ecodigo" type="hidden" value="<cfif isdefined("form.btnGenerar") and isdefined("form.Ecodigo") AND #form.Ecodigo# NEQ "" ><cfoutput>#form.Ecodigo#</cfoutput></cfif>">
                            </table>
                          </div></td>
                        <td align="center"> <div style="display: ;" id="verDiaEstud"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="27%" class="subTitulo">D&iacute;a</td>
                                <td width="73%"><input type="radio" name="rdCortes" value="SC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'SC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                                  Sin separaci&oacute;n </td>
                              </tr>
                              <tr> 
                                <td><select name="Dia" id="Dia" >
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "T" >
                                      <option value="T" selected>-- Todos --</option>
                                      <cfelse>
                                      <option value="T">-- Todos --</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "0" >
                                      <option value="0" selected>Lunes</option>
                                      <cfelse>
                                      <option value="0">Lunes</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "1" >
                                      <option value="1" selected>Martes</option>
                                      <cfelse>
                                      <option value="1">Martes</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "2" >
                                      <option value="2" selected>Mi&eacute;rcoles</option>
                                      <cfelse>
                                      <option value="2">Mi&eacute;rcoles</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "3" >
                                      <option value="3" selected>Jueves</option>
                                      <cfelse>
                                      <option value="3">Jueves</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "4" >
                                      <option value="4" selected>Viernes</option>
                                      <cfelse>
                                      <option value="4">Viernes</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "5" >
                                      <option value="5" selected>S&aacute;bado</option>
                                      <cfelse>
                                      <option value="5">S&aacute;bado</option>
                                    </cfif>
                                    <cfif isdefined("form.btnGenerar") and isdefined("form.Dia") AND #form.Dia# EQ "6" >
                                      <option value="6">Domingo</option>
                                      <cfelse>
                                      <option value="6">Domingo</option>
                                    </cfif>
                                  </select></td>
                                <td><input type="radio" name="rdCortes" value="CxG" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'CxG'>checked</cfif>>
                                  Separar Grupo por P&aacute;gina</td>
                              </tr>
                            </table>
                          </div></td>
                        <td width="15%" align="center">&nbsp;
						</td>
                      </tr>
                      <tr> 
                        <td width="25%" align="left"><input name="TipoRep" id="TipoRep" type="radio"  onClick="javascript: electivasXGrupo(this)" value="TipoRepES" <cfoutput>#banderaES#</cfoutput>>
                          Electivas con Sustitutivas</td>
                        <td width="24%" align="left"><input type="radio" name="TipoRep" id="TipoRep"  onClick="javascript: electivasXGrupo(this)" value="TipoRepAE" <cfoutput>#banderaAE#</cfoutput>>
                          Alumnos por Electivas</td>
                        <td width="36%" align="left"><input type="radio" name="TipoRep" id="TipoRep" onClick="javascript: electivasXGrupo(this)" value="TipoRepEG" <cfoutput>#banderaEG#</cfoutput>>
                          Electivas por Grupos</td>
                        <td width="15%" align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="4" align="center"> <hr></td>
                      </tr>
                      <tr> 
                        <td colspan="4" align="center">&nbsp;</td>
                      </tr>
                    </table>
                  	</form>				
				  
                </td>
              </tr>
			  	<cfif isdefined("form.btnGenerar")>
				  <tr>
					<td height="23">
						<cfif isdefined("form.TipoRep")>
							<cfif form.TipoRep EQ 'TipoRepES'><!--- Electivas con Sustitutivas --->
								<cfinclude template="formListaMatElect_Sust.cfm">
							<cfelseif form.TipoRep EQ 'TipoRepAE'><!--- Alumnos por Electivas --->
								 <cfinclude template="formListaMatElect_Alumno.cfm">
							<cfelseif form.TipoRep EQ 'TipoRepEG'><!--- Electivas por Grupos --->
								<cfinclude template="formListaMatSust_Grupo.cfm">
							</td></tr></cfif>
						</cfif>
				</cfif>
            </table>
			
			<script language="JavaScript" type="text/JavaScript">
				obtenerGrados(document.formMatElectSust);
				cargarGrados(document.formMatElectSust.FNcodigo, document.formMatElectSust.FGcodigo, '<cfif isdefined("Form.FGcodigo") AND Form.FGcodigo NEQ "-1"><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
				obtenerGrupos(document.formMatElectSust);
				cargarGrupos(document.formMatElectSust.FNcodigo,document.formMatElectSust.FGcodigo, document.formMatElectSust.FGRcodigo, '<cfif isdefined("Form.FGRcodigo") AND Form.FGRcodigo NEQ "-1"><cfoutput>#Form.FGRcodigo#</cfoutput></cfif>', true);				
				inicio(document.formMatElectSust.TipoRep);
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