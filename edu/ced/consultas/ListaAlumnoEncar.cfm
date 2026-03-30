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
           Encargados por Alumno<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
	<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGruposCons">  
		select a.GRnombre as Grupo, 
		b.Ndescripcion as Ndescripcion, 
		Norden, 
		Gorden, 
		convert(varchar,a.GRcodigo) as GRcodigo,
		substring(c.Gdescripcion,1,50) as NombGrado
		from Grupo a, Nivel b, Grado c, PeriodoVigente d, Materia e, Curso f, Staff g, PersonaEducativo h
    	where b.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
      	and e.Melectiva = 'R'
        	and a.Ncodigo   = b.Ncodigo
        	and b.Ncodigo   = c.Ncodigo
        	and a.Gcodigo   = c.Gcodigo
        	and c.Ncodigo   = d.Ncodigo
        	and d.Ncodigo   = e.Ncodigo
        	and c.Gcodigo   = e.Gcodigo
        	and e.Mconsecutivo = f.Mconsecutivo
        	and b.CEcodigo  = f.CEcodigo
        	and a.GRcodigo  = f.GRcodigo
        	and d.PEcodigo  = f.PEcodigo
        	and d.SPEcodigo = f.SPEcodigo
        	and f.CEcodigo  *= g.CEcodigo
        	and f.Splaza    *= g.Splaza
        	and g.CEcodigo  *= h.CEcodigo
        	and g.persona   *= h.persona
    	order by b.Norden, c.Gorden
</cfquery>
<cfquery name="rsFiltroGrupos" dbtype="query">
	 select distinct GRcodigo , Grupo
	 from rsFiltroGruposCons 
	 order by Norden, Gorden, Grupo 
</cfquery>
<script language="JavaScript" type="text/JavaScript">  
		  function AlumnoRetirado()
		 {
		// alert(document.formAlumEncar.Aretirado1.checked);		
			 if(!document.formAlumEncar.Aretirado1.checked ) 
			 {
				 document.formAlumEncar.Aretirado.value=0;  
				 document.formAlumEncar.Grupo.style.visibility = 'visible';      	
			 }
			 else
			 {
				 document.formAlumEncar.Aretirado.value=1;  
				 document.formAlumEncar.Grupo.style.visibility = 'hidden';        	
			 }
			//alert(formAlumEncar.Aretirado.value);
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
							<cfif isdefined("form.btnGenerar")>
								<cfset btnGenerar = #form.btnGenerar#>	
							</cfif>
							<cfif isdefined("form.Grupo")>
								<cfset Grupo = #form.Grupo#>	
							</cfif>
							<cfif isdefined("form.Aretirado")>
								<cfset Aretirado = #form.Aretirado#>	
							<cfelse>
								<cfset Aretirado = 1>	
							</cfif>
							<cfif isdefined("form.rdCortes")>
								<cfset rdCortes = #form.rdCortes#>	
							</cfif>
							<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaAlumnoEncarImpr.cfm">							
							<cfinvokeargument name="Param" value="&Grupo=#Grupo#&btnGenerar=#btnGenerar#&rdCortes=#rdCortes#&Aretirado=#Aretirado#">
						</cfinvoke>
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionCED.cfm">					
					</cfif>
				</td>
              </tr>
              <tr>
                <td>
					<form name="formAlumEncar" method="post" action="ListaAlumnoEncar.cfm" >
                    <table width="100%" border="0">
                      <tr> 
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">Grupos:</td>
                        <td width="15%" rowspan="2" align="center"><input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript: limpiaAl(this)">
                          <input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" ></td>
                      </tr>
                      <tr> 
                     	<td colspan="4"></td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center"> <div style="display: ;" id="verEstud"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            	<tr> 
                                	<td >&nbsp;</td>
	                            </tr>
    	                        <tr> 
									<td >&nbsp;</td>
    							</tr>
                            </table>
                          
						  </td>
                        <td align="center"> <div style="display: ;" id="verDiaEstud"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
							  	<td >
									<select name="Grupo" id="Grupo"  >
										<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1">
											<option value="-1" selected>-- Todos --</option>
										<cfelse>
											<option value="-1">-- Todos --</option>
										</cfif>
										<cfoutput query="rsFiltroGrupos"> 
											<cfif isdefined("form.Grupo") and #form.Grupo# EQ #rsFiltroGrupos.GRcodigo#>
												<option value="#rsFiltroGrupos.GRcodigo#" selected>#rsFiltroGrupos.Grupo#</option>
											<cfelse>
												<option value="#rsFiltroGrupos.GRcodigo#">#rsFiltroGrupos.Grupo#</option>
											</cfif>
										</cfoutput>
									</select>
                                </td>
                                <td ><input type="radio" name="rdCortes" value="SC" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'SC'>checked<cfelseif not isdefined('btnGenerar') and not isdefined('form.rdCortes')>checked</cfif>>
                                  Separar Grupo (Contnua) </td>
                              </tr>
                              <tr> 
                                <td>
							    </td>
                                <td><input type="radio" name="rdCortes" value="CxG" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'CxG'>checked</cfif>>
                                  Separar Grupo (P&aacute;gina)</td>
								</tr>
								<tr> 
									<td>
									<input name="Aretirado" type="hidden" value="0">
									</td>
									<td>
									<input  name="Aretirado1" type="checkbox" value="0" <cfif isdefined('form.Aretirado') and  #form.Aretirado# EQ 1> checked  </cfif> onClick="javascript:AlumnoRetirado();" >
										Alumnos Retirados
										
									 </td>
								</tr>
                            </table>
                          </div></td>
                        <td width="15%" align="center">&nbsp;
						</td>
                      </tr>
                      <tr> 
                       <!---  <td width="25%" align="left"><input name="TipoRep" id="TipoRep" type="radio"  onClick="javascript: electivasXGrupo(this)" value="TipoRepES" <cfoutput>#banderaES#</cfoutput>>
                          Electivas con Sustitutivas</td>
                        <td width="24%" align="left"><input type="radio" name="TipoRep" id="TipoRep"  onClick="javascript: electivasXGrupo(this)" value="TipoRepAE" <cfoutput>#banderaAE#</cfoutput>>
                          Alumnos por Electivas</td>
                        <td width="36%" align="left"><input type="radio" name="TipoRep" id="TipoRep" onClick="javascript: electivasXGrupo(this)" value="TipoRepEG" <cfoutput>#banderaEG#</cfoutput>>
                          Electivas por Grupos</td>
                        <td width="15%" align="center">&nbsp;</td> --->
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
			   <tr>
					<td height="23">
					  	<cfif isdefined("form.btnGenerar")>
				 			<cfinclude template="formListaAlumnoEncar.cfm">
					<!--- 	<cfif isdefined("form.TipoRep")>
							<cfif form.TipoRep EQ 'TipoRepES'><!--- Electivas con Sustitutivas --->
								<cfinclude template="formListaMatElect_Sust.cfm">
							<cfelseif form.TipoRep EQ 'TipoRepAE'><!--- Alumnos por Electivas --->
								 <cfinclude template="formListaMatElect_Alumno.cfm">
							<cfelseif form.TipoRep EQ 'TipoRepEG'><!--- Electivas por Grupos --->
								<cfinclude template="formListaMatSust_Grupo.cfm">
							</td></tr></cfif>
						</cfif> --->
						</cfif>
					</td>
			 	</tr>
            </table>
			<script language="JavaScript" type="text/javascript">
				AlumnoRetirado();
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