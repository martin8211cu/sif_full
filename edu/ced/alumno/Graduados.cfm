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
            alumnos graduados<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfif isdefined("Url.fNombreAl") and not isdefined("Form.fNombreAl")>
				<cfset Form.fNombreAl = Url.fNombreAl>
			</cfif>
		
			<cfif isdefined("Url.fAlumnoPid") and not isdefined("Form.fAlumnoPid")>
				<cfset Form.fAlumnoPid = Url.fAlumnoPid>
			</cfif>

			<cfif isdefined("Url.FPRcodigo") and not isdefined("Form.FPRcodigo")>
				<cfset Form.FPRcodigo = Url.FPRcodigo>
			</cfif>
			<table width="100%" border="0">
			  <tr>
				<td>
					<cfinclude template="../../portlets/pNavegacionCED.cfm">				
				</td>
			  </tr>
			  <tr>
				<td>
					<cfinclude template="formGraduados.cfm">
				</td>
			  </tr>
 			  <tr>
				<td>
					<cfinclude template="filtros/filtroGraduados.cfm">
				</td>
			</tr>
			<tr>
				<td>
				
					 <cfset f1 = "">
					 <cfset f2 = "">
					 <cfset f3 = "">
					 <cfset filtro = "">
					 <cfset navegacion = "">
					 
					<cfif isdefined("Form.fnombreAL") AND Form.fnombreAL NEQ "" >
						<cfset Form.fnombreAL = Form.fnombreAL>
						<cfset filtro = filtro &" and upper((pe.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like upper('%" & Form.fnombreAL & "%')">							
						<cfset f1 = Form.fnombreAL>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombreAL=" & Form.fnombreAL>
					</cfif>							
					<cfif isdefined("Form.fAlumnoPid") AND Form.fAlumnoPid NEQ "">
						<cfset Form.fAlumnoPid = Form.fAlumnoPid>
						<cfset filtro = filtro &" and upper(pe.Pid) like upper('%" & Form.fAlumnoPid & "%')">
						<cfset f2 = Form.fAlumnoPid>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fAlumnoPid=" & Form.fAlumnoPid>
					</cfif>
					<cfif isdefined("Form.FPRcodigo") AND Form.FPRcodigo NEQ "">
						<cfset Form.FPRcodigo = Form.FPRcodigo>
						<cfset filtro = filtro &" and pr.PRcodigo = " & Form.FPRcodigo >
						<cfset f3 = Form.FPRcodigo>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPRcodigo=" & Form.FPRcodigo>
					</cfif>
					
					
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaGraduados">
						<cfinvokeargument name="tabla" value="
							PersonaEducativo pe, Alumnos a, AlumnoRetirado ar, Promocion pr"/>
 						<cfinvokeargument name="columnas" value="						    
							convert(varchar,a.Ecodigo) as Ecodigo, convert(varchar,a.persona) as persona,
							(pe.Papellido1 + ' ' + pe.Papellido2 + ',' + pe.Pnombre) as nombre,
							convert(varchar,pe.Pnacimiento,103) as Pnacimiento, 
							pe.Pid, convert(varchar,pr.PRano) + ' - ' +  pr.PRdescripcion as ano
																 "/> 
						<cfinvokeargument name="desplegar" value="nombre,Pid,Pnacimiento"/>
						<cfinvokeargument name="etiquetas" value="Nombre,N. Identificaci&oacute;n,Fecha de Nacimiento"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="
												a.CEcodigo = #Session.Edu.CEcodigo#
												and ar.ARalta = 2
												  and a.Aretirado = 2
												  and a.persona=pe.persona
												  and a.CEcodigo = ar.CEcodigo
												  and a.Ecodigo = ar.Ecodigo
												  and ar.PRcodigo = pr.PRcodigo 
												  #filtro#
												order by nombre
															   " />
						<cfinvokeargument name="align" value="left,center,center"/>
						<cfinvokeargument name="ajustar" value="N,N,N"/>
						<cfinvokeargument name="irA" value="Graduados.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="Cortes" value="ano"/>
						<cfinvokeargument name="maxrows" value="17"/>						
						<cfinvokeargument name="debug" value="N"/>						
					</cfinvoke>
				</td>
			  </tr>
			</table>
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