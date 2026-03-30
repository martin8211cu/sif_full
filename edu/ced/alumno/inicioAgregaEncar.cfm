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
            Encargados por Alumno<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->

			<cfif isdefined("Url.personaAl") and not isdefined("Form.personaAl")>
              
              <cfparam name="Form.personaAl" default="#Url.personaAl#">
			</cfif>
		  
			<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
				Select (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Nombre, Pid
				from PersonaEducativo a, Alumnos b
				where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaAl#">
					and a.persona=b.persona
					and a.CEcodigo=b.CEcodigo		
			</cfquery>		  
			
			<cfset filtro = " 	a.persona=b.persona
								and CEcodigo = #Session.Edu.CEcodigo#
								and EEcodigo not in (
										Select a.EEcodigo
										from EncargadoEstudiante a, Alumnos b
										where a.CEcodigo=#Session.Edu.CEcodigo#
											and b.persona=	#form.personaAl#
											and a.CEcodigo=b.CEcodigo
											and a.Ecodigo=b.Ecodigo )"> 
											
			<cfif isdefined("form.btnBuscarEncar")>
              
              <cfif isdefined("form.fEncarNombre") AND #form.fEncarNombre# NEQ "" >
                
                <cfset filtro = #filtro# & " and Upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like upper('%" & #Form.fEncarNombre# & "%')">									
				</cfif>
              <cfif isdefined("form.filtroEncarPid") AND #form.filtroEncarPid# NEQ "" >
                
                <cfset filtro = #filtro# & " and Upper(Pid) like upper('%" & #Form.filtroEncarPid# & "%')">
				</cfif>
			</cfif> 
			
																	
			<cfif isdefined("form.btnBuscarEncar") and isdefined("form.fEncarNombre") AND #form.fEncarNombre# NEQ "" >
              
              <cfset filtro = #filtro# & " and Upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like upper('%" & #Form.fEncarNombre# & "%')">									
			</cfif> 														

            <table width="100%" border="0">
              <tr> 
                <td colspan="2"><cfinclude template="../../portlets/pNavegacionCED.cfm"></td>
              </tr>
              <tr class="area"> 
                <td class="subTitulo">Alumno: <cfoutput>#rsForm.Nombre#</cfoutput></td>
                <td class="subTitulo">C&eacute;dula: <cfoutput>#rsForm.Pid#</cfoutput></td>
              </tr>
              <tr> 
                <td> <cfinclude template="filtros/filtroEncar.cfm"> </td>
                <td width="46%" rowspan="3" valign="top"> <table width="100%" border="1">
                    <tr> 
                      <td> <cfinclude template="formAgregaEncar.cfm"> </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td class="subTitulo">Lista de encargados sin asociar </td>
              </tr>
              <tr> 
                <td> <form name="EncargadosSinAsociar" action="inicioAgregaEncar.cfm" method="post">
                    <cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="ListaEncar">
                      <cfinvokeargument name="tabla" value="Encargado a, PersonaEducativo b"/>
                      <cfinvokeargument name="columnas" value="EEcodigo,personaAl=#form.personaAl#,(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Nombre, Pid"/>
                      <cfinvokeargument name="desplegar" value="Nombre,Pid"/>
                      <cfinvokeargument name="etiquetas" value="Nombre,N. Identificaci&oacute;n"/>
                      <cfinvokeargument name="formatos" value=""/>
                      <cfinvokeargument name="filtro" value="#filtro# order by Nombre" />
                      <cfinvokeargument name="align" value="left,center"/>
                      <cfinvokeargument name="ajustar" value="N"/>
                      <cfinvokeargument name="irA" value="inicioAgregaEncar.cfm"/>
                      <cfinvokeargument name="incluyeForm" value="false"/>
                      <cfinvokeargument name="formName" value="EncargadosSinAsociar"/>
                    </cfinvoke>
                  </form></td>
              </tr>
              <tr> 
                <td colspan="2" class="subTitulo">Lista de encargados asociados</td>
              </tr>
              <tr> 
                <td colspan="2"> <cfinclude template="listaEncarAsoc.cfm"> </td>
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