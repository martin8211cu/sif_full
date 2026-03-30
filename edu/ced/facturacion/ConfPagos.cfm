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
            Configuraci&oacute;n Pago de Servicios<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
				<cfparam name="Form.sel" default="#Url.sel#">
			</cfif>	
				 <cfset f1 = "">
				 <cfset f2 = "">
				 <cfset f3 = "-1">
				 <cfset filtro = "">
				 <cfset navegacion = "">
				 
				<cfif isdefined("Form.fRHnombre") AND #Form.fRHnombre# NEQ "" >
					<cfset filtro = #filtro# &" and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like upper('%" & #Form.fRHnombre# & "%')">							
					<cfset f1 = Form.fRHnombre>
					<cfset navegacion = "fRHnombre=" & Form.fRHnombre>														
				</cfif>							
				<cfif isdefined("Form.filtroRhPid") AND #Form.filtroRhPid# NEQ "">
					<cfset filtro = #filtro# &" and upper(Pid) like upper('%" & #Form.filtroRhPid# & "%')">
					<cfset f2 = Form.filtroRhPid>
					<cfset navegacion = "filtroRhPid=" & Form.filtroRhPid>																					
				</cfif>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<form name="formBuscar" method="post" action="">			  	  
						<tr>
							<td><cfinclude template="../../portlets/pNavegacionCED.cfm"></td>
						</tr>
						<tr> 
						<td valign="middle" align="right">  
						  <label id="letiqueta1"><a href="javascript: limpiaFiltrado(); buscar();">Seleccione un encargado:  </a></label>
						  <label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();">Pagos de Servicios: </a> </label>			  
						  <a href="javascript: limpiaFiltrado(); buscar();">
							  <img src="/cfmx/edu/Imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0"> 
						  </a> </td>
						</tr>
						
					</form>	  							
					<tr style="display: ;" id="verFiltroListaEncar"> 
					  <td> 
						<form name="formFiltroListaEncar" method="post" action="ConfPagos.cfm">
							<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
							<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
							
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							<tr> 
								<td>
									<cfinclude template="filtros/filtroConfPagos.cfm">
								</td>
							</tr>
						  </table>
						</form>
					  </td>
					</tr>		
					<tr style="display: ;" id="verLista"> 
					  <td> 
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>
								<cfinvoke 
								 component="edu.Componentes.pListas"
								 method="pListaEdu"
								 returnvariable="pListaEncar">
									<cfinvokeargument name="tabla" value="PersonaEducativo a, Pais b, Encargado c"/>
									<cfinvokeargument name="columnas" value="distinct convert(varchar,a.persona) as persona, (Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre) as nombre, b.Pnombre, Pid, 'Docente' as Rol, sel=1, convert(varchar,c.EEcodigo) as EEcodigo"/> 
									<cfinvokeargument name="desplegar" value="nombre,Pnombre, Pid"/>
									<cfinvokeargument name="etiquetas" value="Nombre,Pa&iacute;s,N. Identificaci&oacute;n"/>
									<cfinvokeargument name="formatos" value="V,V,V"/>
									<cfinvokeargument name="formName" value=""/>	
									<cfinvokeargument name="filtro" value="a.CEcodigo = #Session.Edu.CEcodigo# 
						                                   and a.Ppais=b.Ppais 
														   and a.persona = c.persona
														   and c.Usucodigo is not null
														   and c.Ulocalizacion is not null
														   #filtro# 
														   order by nombre"/>
									<cfinvokeargument name="align" value="left,center,center"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="ConfPagos.cfm"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="debug" value="N"/>
								</cfinvoke>
							</td>
						  </tr>
						  
						</table>
					  </td>
					</tr>
					<tr style="display: ;" id="verPagina"> 
					  <td> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td></td>
								</tr>
								<!--- <tr>
									<td><cfinclude template="../../portlets/pNavegacionCED.cfm"></td>
								</tr> --->					
								<tr>
								<td><cfinclude template="formConfPagos.cfm"></td>
								</tr>
							</table>
					  </td>
					</tr>
				  </table>
				        <script language="JavaScript" type="text/javascript">
			var Bandera = "L";
			
			function buscar(){
				
				var connVerLista			= document.getElementById("verLista");
				var connVerPagina			= document.getElementById("verPagina");				
				var connverFiltroListaEncar	= document.getElementById("verFiltroListaEncar");								
				var connVerEtiqueta1		= document.getElementById("letiqueta1");												
				var connVerEtiqueta2		= document.getElementById("letiqueta2");																
				
					
				if(document.formFiltroListaEncar.filtrado.value != "")
					Bandera = "L";
					
				if(document.formFiltroListaEncar.sel.value == "1")
					Bandera = "P";	
				
			
				if(Bandera == "L"){	// Ver Lista
					Bandera = "P";
					connVerLista.style.display = "";
					connverFiltroListaEncar.style.display = "";					
					connVerPagina.style.display = "none";
					document.formBuscar.imageBusca.src="/sif/rh/imagenes/notas.gif";
					connVerEtiqueta1.style.display = "none";
					connVerEtiqueta2.style.display = "";					
					document.formBuscar.imageBusca.alt="Configuracin";
				}else{	//Pagina
					Bandera = "L";				
					connVerLista.style.display = "none";
					connverFiltroListaEncar.style.display = "none";					
					connVerPagina.style.display = "";
					document.formBuscar.imageBusca.src="/cfmx/edu/Imagenes/find.small.png";					
					connVerEtiqueta1.style.display = "";
					connVerEtiqueta2.style.display = "none";										
					document.formBuscar.imageBusca.alt="Lista de encargados";
				}
			}				
			
			
			function limpiaFiltrado(){
				
				document.formFiltroListaEncar.filtrado.value = "";
				document.formFiltroListaEncar.sel.value = 0;
				
			}
			
			buscar();
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