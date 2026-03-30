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
            alumnos por Grupo<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
            <!--- Consultas --->
            <!---  Para el combo de Grupos  --->
            <cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
				Select distinct b.GRcodigo, GRnombre
				from 	Alumnos a
						, GrupoAlumno b
						, Grupo c
						, Nivel d
						, Grado e
				where 	a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and Aretirado=0
						and a.CEcodigo=b.CEcodigo
						and a.Ecodigo=b.Ecodigo
						and b.GRcodigo  = c.GRcodigo
						and c.Ncodigo=d.Ncodigo
						and c.SPEcodigo in (
							select SPEcodigo
							   from PeriodoVigente
							)
						and c.Gcodigo=e.Gcodigo
				order by Norden, GRnombre
            </cfquery>
            <table width="100%" border="0">
              <tr> 
                <td> 
				<cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
                    <cfset Param = "cbGrupos=#form.cbGrupos#">
                    <cfif isdefined("form.rdCorte")>
						<cfset Param = Param & Iif(Len(Trim(Param)) NEQ 0, DE("&"), DE("")) & "rdCorte=" & Form.rdCorte>						
						<cfset Param = Param & "&imprime=1">						
                    </cfif>			 		
					
                    <cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
                      <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaEstudXGrupoImpr.cfm">
                      <cfinvokeargument name="Param" value="#Param#">
                    </cfinvoke>
                    <cfelse>
                    <cfinclude template="../../portlets/pNavegacionCED.cfm">
                  </cfif> </td>
              </tr>
              <tr> 
                <td><form name="form1" method="post" action="" >
                    <table class="area" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="21%" align="right">Grupos</td>
                        <td width="38%"> 
                          <select name="cbGrupos" id="cbGrupos" onChange="javascript: cambioGrupos(this);">
                            <option value="-1" <cfif isdefined("form.cbGrupos") and form.cbGrupos EQ "-1">selected</cfif>>-- Todos --</option>
                            <option value="-2" <cfif isdefined("form.cbGrupos") and form.cbGrupos EQ "-2">selected</cfif>>-- Alumnos sin asignar (para ste Periodo) --</option>								
                            <cfoutput query="rsGrupos"> 
                              <option value="#rsGrupos.GRcodigo#" <cfif isdefined("form.cbGrupos") and form.cbGrupos EQ #rsGrupos.GRcodigo#>selected</cfif>>#rsGrupos.GRnombre#</option>
                            </cfoutput> </select></td>
                        <td width="41%">
							<div style="display: ;" id="verGruposTodos">
								
                            <table width="100%" class="area" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td align="center" valign="middle"><input border="0" checked class="area" type="radio" name="rdCorte" value="PC"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PC'> checked </cfif>> 
                                </td>
                                <td>P&aacute;ginas Continuas</td>
                              </tr>
                              <tr> 
                                <td align="center" valign="middle"><input border="0" class="area" type="radio" name="rdCorte" value="PXG"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXG'> checked </cfif>></td>
                                <td>P&aacute;gina por Grupo</td>
                              </tr>
                              <tr>
                                <td align="center" valign="middle"><input border="0" class="area" type="radio" name="rdCorte" value="AA"  <cfif isdefined('form.rdCorte') and form.rdCorte EQ 'AA'> checked </cfif>></td>
                                <td>Alumnos Alfab&eacute;ticamente</td>
                              </tr>
                            </table>
                          </div>	  
						  </td>
                      </tr> 
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>					  
                      <tr> 
                        <td colspan="3" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar2" value="Generar">
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
	            <cfinclude template="formListaEstudXGrupos.cfm">
			</cfif>
            <script language="JavaScript" type="text/javascript">
				function inicio(){
					var cbGrupos = document.getElementById('cbGrupos');
					
					cambioGrupos(cbGrupos);
				}
				
				function cambioGrupos(obj){
					var connVerGruposTodos 	= document.getElementById("verGruposTodos");
				
					if(obj.value == '-1')
						connVerGruposTodos.style.display = "";
					else
						connVerGruposTodos.style.display = "none";
				}
				inicio();
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