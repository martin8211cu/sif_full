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
		<cfinclude template="../jsMenuDOC.cfm" > 
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
            Alumnos<!-- InstanceEndEditable -->
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

		<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
			set nocount on
			select 	convert(varchar,c.Ccodigo) as codCurso, 
					(Mnombre+' '+GRnombre) as nombCurso,
					Norden, Gorden
			from Curso c, Materia m, Grupo g, PeriodoVigente v, Staff s, Nivel n, Grado k
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
				and c.Mconsecutivo = m.Mconsecutivo
				and m.Melectiva = 'R'
				and c.GRcodigo = g.GRcodigo
				and m.Ncodigo = v.Ncodigo
				and c.PEcodigo = v.PEcodigo
				and c.SPEcodigo = v.SPEcodigo
				and c.Splaza = s.Splaza
				and m.Ncodigo = n.Ncodigo
				and m.Ncodigo = k.Ncodigo
				and m.Gcodigo = k.Gcodigo
			union
			select 	convert(varchar,c.Ccodigo) as codCurso,
					Cnombre as nombCurso,
					Norden, 100000 as Gorden
			from Curso c, Materia m, PeriodoVigente v, Staff s, Nivel n
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
				and s.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				and c.Mconsecutivo = m.Mconsecutivo
				and m.Melectiva = 'S'
				and m.Ncodigo = v.Ncodigo
				and c.PEcodigo = v.PEcodigo
				and c.SPEcodigo = v.SPEcodigo
				and c.Splaza = s.Splaza
				and m.Ncodigo = n.Ncodigo
			order by 3,4,2
			set nocount off
		</cfquery>
		  
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
							<cfif isdefined("form.Ccodigo")>
								<cfset Ccodigo = #form.Ccodigo#>	
							</cfif>
							
							<cfif isdefined("form.rdCortes")>
								<cfset rdCortes = #form.rdCortes#>	
							</cfif>
							<cfinvokeargument name="printEn" value="imprime/ListaAlumnosXProfImpr.cfm">
							<cfinvokeargument name="Param" value="&Ccodigo=#Ccodigo#&btnGenerar=#btnGenerar#&rdCortes=#rdCortes#">
							<cfinvokeargument name="Tipo" value="2">
						</cfinvoke>
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionDOC.cfm">
					</cfif>
				</td>
              </tr>
              <tr>
                <td>
					<form name="formMatElectSust" method="post" action="ListaAlumnosXProf.cfm">
                    <table width="100%" border="0">
                      <tr> 
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">Curso:</td>
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
                          
						  </div>
						  </td>
                        <td align="center"> <div style="display: ;" id="verDiaEstud"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
							  	<td >
									<select name="Ccodigo" id="Ccodigo">
										  <option value="-1" <cfif isdefined("form.Ccodigo") and form.Ccodigo EQ "-1">selected</cfif>>- 
										Todos -</option>
										<cfoutput query="rsCursos"> 
										<option value="#codCurso#" <cfif isdefined("Form.Ccodigo") and Form.Ccodigo EQ rsCursos.codCurso>selected</cfif>>#nombCurso#</option>
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
                            </table>
                          </div></td>
                        <td width="15%" align="center">&nbsp;
						</td>
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
				 			<cfinclude template="formListaAlumnosXProf.cfm">
						</cfif>
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