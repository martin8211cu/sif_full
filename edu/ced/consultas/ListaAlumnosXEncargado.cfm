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
            Alumnos por Encargado<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" --> 

<!--- Consulta de Encargados --->
	 <cfquery datasource="#Session.Edu.DSN#" name="rsEncargados">
		select distinct e.persona,(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Nombre
		from EncargadoEstudiante a, Alumnos b, Estudiante c, Encargado d, PersonaEducativo e
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			and a.CEcodigo=b.CEcodigo 
			and a.Ecodigo=b.Ecodigo 
			and b.Ecodigo=c.Ecodigo 
			and a.EEcodigo=d.EEcodigo 
			and d.persona=e.persona
	  order by Nombre	 
	</cfquery>  
	
	<script language="JavaScript" type="text/javascript" >
		function cambiaEncar(obj){
			var connVerCortes	= document.getElementById("verCortes");
		
			if(obj.value == '-1')
				connVerCortes.style.display = "";
			else 
				connVerCortes.style.display = "none";
		}	
	</script>		

            <form name="formAluXEncar" method="post" action="ListaAlumnosXEncargado.cfm">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td colspan="3" > <cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
                      <cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
                        <cfset vParam = "">
                        <cfif isdefined("form.EEpersona")>
                          <cfset vParam = vParam  & "&EEpersona=" & #form.EEpersona#>
                        </cfif>
                        <cfif isdefined("form.rdCortes")>
                          <cfset vParam = vParam  & "&rdCortes=" & #form.rdCortes#>						  
                        </cfif>
						
                        <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaAlumnosXEncargadoImpr.cfm">
                        <cfinvokeargument name="Param" value="#vParam#">
                      </cfinvoke>
                      <cfelse>
                      <cfinclude template="../../portlets/pNavegacionCED.cfm">
                    </cfif> </td>
                </tr>
                <tr> 
                  <td width="42%" class="subTitulo">Encargados</td>
                  <td width="36%" rowspan="3"> <div style="display: ;" id="verCortes"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td class="subTitulo">Cortes por Impresi&oacute;n</td>
                        </tr>
                        <tr> 
                          <td><input type="radio" name="rdCortes" value="PC" class="areaFiltro" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                            P&aacute;ginas Continuas</td>
                        </tr>
                        <tr> 
                          <td><input type="radio" name="rdCortes" value="PXE" class="areaFiltro" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PXE'>checked</cfif>>
                            P&aacute;gina por Encargado</td>
                        </tr>
                      </table>
                    </div></td>
                  <td width="22%" rowspan="3" class="subTitulo" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar" value="Generar"></td>
                </tr>
                <tr> 
                  <td> <select name="EEpersona" id="EEpersona" onChange="javascript: cambiaEncar(this);">
                      <cfif isdefined("form.EEpersona") and #form.EEpersona# EQ "-1">
                        <option value="-1" selected>-- Todos --</option>
                        <cfelse>
                        <option value="-1">-- Todos --</option>
                      </cfif>
                      <cfoutput query="rsEncargados"> 
                        <cfif isdefined("form.EEpersona") and #form.EEpersona# EQ "#rsEncargados.persona#">
                          <option selected value="#rsEncargados.persona#">#rsEncargados.Nombre#</option>
                          <cfelse>
                          <option value="#rsEncargados.persona#">#rsEncargados.Nombre#</option>
                        </cfif>
                      </cfoutput> </select> </td>
                </tr>
                <tr> 
                  <td align="center">&nbsp;</td>
                </tr>
              </table>
			  
				<cfif isdefined('form.btnGenerar')>
					<hr>
					<cfinclude template="formListaAlumnosXEncargado.cfm">
				</cfif>			  
            </form>
			
			<script language="JavaScript" type="text/javascript" >
				cambiaEncar(document.formAluXEncar.EEpersona)
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