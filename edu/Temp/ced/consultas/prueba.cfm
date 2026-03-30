<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenu04.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../../../js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/javascript">
	// Funciones para el Manejo de Botones
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" rowspan="2" valign="middle">
		  	<cfset RolActual = 0>
			<cfinclude template="../../../portlets/pEmpresas2.cfm">
			</td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
	  			Titulo
      <!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td valign="bottom" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" --> 
      <!-- InstanceEndEditable -->	
		  </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
	<cfif isdefined("Session.CEcodigo")>
		<cfoutput>
		<table class="area" width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td align="right"><font color="##009900" size="2"><strong><a href="/minisitio/#Session.CEcodigo#/f#Session.CEcodigo#.html">Ir a P&aacute;gina Web de #rsPagWebCollege.CEnombre#</a></strong></font></td>
			</tr>
		</table>
		</cfoutput>
	</cfif>
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="left" valign="top" nowrap></td>
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->Titulo1<!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td valign="top" nowrap>
		<cfinclude template="/sif/menu.cfm">
	</td>
    <td valign="top" width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  	TituloPortlet
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  <cfquery datasource="#Session.DSN#" name="rsFiltroGruposCons">  
		select a.GRnombre as Grupo, 
		b.Ndescripcion as Ndescripcion, 
		Norden, 
		Gorden, 
		convert(varchar,a.Ncodigo) + '|' + convert(varchar,a.GRcodigo) as GRcodigo,
		substring(c.Gdescripcion,1,50) as NombGrado
		from Grupo a, Nivel b, Grado c, PeriodoVigente d, Materia e, Curso f, Staff g, PersonaEducativo h
    	where b.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
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

<!--- Consulta de Alumnos --->
	<cfquery name="rsAlumno" datasource="#session.DSN#">
		select c.Ecodigo,
			a.persona,
			(a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre) as Nombre,
			b.Pnombre,
			convert(varchar,a.Pnacimiento,103) as Pnacimiento, 
			a.Pid,
			f.Gdescripcion as Grado,
			case when c.Aretirado=0 then 'Activo' when c.Aretirado=1 then 'Retirado' when c.Aretirado=2 then 'Graduado' end as estado
		from PersonaEducativo a, Pais b, Alumnos c, Estudiante d, Grado f, Promocion e, Nivel g 
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and e.PRactivo = 1 
			and a.Ppais=b.Ppais 
			and a.persona=c.persona 
			and a.CEcodigo=c.CEcodigo 
			and c.persona=d.persona 
			and c.Ecodigo=d.Ecodigo 
			and c.PRcodigo=e.PRcodigo 
			and e.Gcodigo=f.Gcodigo 
			and e.Ncodigo=f.Ncodigo 
			and f.Ncodigo=g.Ncodigo

		order by g.Norden,f.Gorden,e.Gcodigo,c.Nombre
	</cfquery>

<cfquery name="rsFiltroGrupos" dbtype="query">
	 select distinct GRcodigo , Grupo
	 from rsFiltroGruposCons 
	 order by Norden, Gorden, Grupo 
</cfquery>
<script language="JavaScript" type="text/JavaScript">  
	gruposText = new Array();
	grupos = new Array();
	niveles = new Array();
	
	function obtenerGrupo(f) {
			for(i=0; i<f.Grupo.length; i++) {
				var s = f.Grupo.options[i].value.split("|");
				// Códigos de los detalles
				niveles[i]= s[0];
				grupos[i] = s[1];
				grupostext[i] = f.Grupo.options[i].text;
			}
		}
	
	function cargarAlumno(csource, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 0;

			for (var i=0; i<Alumno.length; i++) {
				if (niveles[i] == k) {
					nuevaOpcion = new Option(gruposText[i],grupos[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && grupos[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
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

							<cfif isdefined("form.rdCortes")>
								<cfset rdCortes = #form.rdCortes#>	
							</cfif>
							<cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ListaEvalPreeImpr.cfm">							
							<cfinvokeargument name="Param" value="&Grupo=#Grupo#&btnGenerar=#btnGenerar#&rdCortes=#rdCortes#">
						</cfinvoke>
					<cfelse>
						<cfinclude template="../../portlets/pNavegacionCED.cfm">					
					</cfif>
				</td>
              </tr>
			  </table>
            <!---   <tr>
                <td> --->
					<form name="formEvalPree" method="post" action="ListaEvalPree.cfm" >
                    <table width="100%" border="0">
                      <tr> 
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">&nbsp;</td>
                        <td class="subTitulo">Grupo:</td>
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
									<select name="Grupo" id="Grupo"   onChange="javascript:cargarAlumno(this, this.form.Alumno, '<cfif isdefined("Form.Alumno")><cfoutput>#Form.Alumno#</cfoutput></cfif>', true);">
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
                                  Separar Grupo (Contínua) </td>
                              </tr>
                              <tr> 
                                <td>
								<select name="Alumno" id="Alumno"   >
										<cfif isdefined("form.Alumno") and #form.Alumno# EQ "-1">
											<option value="-1" selected>-- Todos --</option>
										<cfelse>
											<option value="-1">-- Todos --</option>
										</cfif>
										<cfoutput query="rsAlumno"> 
											<cfif isdefined("form.Alumno") and #form.Alumno# EQ #rsAlumno.Ecodigo#>
												<option value="#rsAlumno.Ecodigo#" selected>#rsAlumno.Nombre#</option>
											<cfelse>
												<option value="#rsAlumno.Ecodigo#">#rsAlumno.Nombre#</option>
											</cfif>
										</cfoutput>
									</select>
							    </td>
                                <td><input type="radio" name="rdCortes" value="CxG" <cfif isdefined('form.rdCortes') and form.rdCortes EQ 'CxG'>checked</cfif>>
                                  Separar Grupo (P&aacute;gina)</td>
								</tr>
								<tr> 
									<td>
									
									</td>
									<td>
									
										
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
//Para los grados
	obtenerGrupo(document.formEvalPree);
	cargarAlumno(document.formEvalPree.Grupo, document.formEvalPree.Alumno, '', true);
//------------------------------------------------------------------------------------------						
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEvalPree");	
//------------------------------------------------------------------------------------------					
	
</script>				  
                </td>
              </tr>
			   <tr>
					<td height="23">
					  	<cfif isdefined("form.btnGenerar")>
				 			<cfinclude template="formListaEvalPree.cfm">
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

          <!-- InstanceEndEditable -->
		  </td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table>
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
