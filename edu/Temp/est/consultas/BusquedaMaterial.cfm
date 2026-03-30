<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenuEST.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
		  	<cfset RolActual = 6>
			<cfset Session.RolActual = 6>
			<cfinclude template="../../../portlets/pEmpresas2.cfm">
		  </td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
	  			Material de Apoyo
      <!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../../portlets/pminisitio.cfm">
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
          <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Consulta <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfinclude template="/edu/responsable/commonDocencia.cfm"> 

			<cfscript>
				sbInitFromSession("cboAlumno", "-999",false);
				sbInitFromSession("cboCurso", "-1",false);
				sbInitFromSession("cboPeriodo", "-999",false);
			</cfscript>
			<cfparam name="form.hdnTipoOperacion" default="">
			<cfparam name="form.hdnTipoActividad" default="">
			<cfparam name="form.hdnCodigo" default="">
			<cfparam name="form.hdnFecha" default="">
			<cfparam name="form.hdnFechaFinal" default="">
			<!--- <cfdump var="#form#"> --->
		<cfinclude template="/edu/responsable/qrysAlumnoCursoPeriodo.cfm"> 
		<!--- <cfquery datasource="#Session.DSN#" name="rsMateriaTipo">
			select convert(varchar,a.MTcodigo) + '|' + convert(varchar,b.id_documento)  as codigo, substring(a.MTdescripcion,1,60) as MTdescripcion
			from MateriaTipo a, DocumentoMateriaTipo b
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
			   and a.MTcodigo = b.MTcodigo
		</cfquery> --->
		<cfquery datasource="#Session.DSN#" name="rsMateriaTipo">
			select  distinct convert(varchar,MT.MTcodigo)  as codigo, 
			substring(MT.MTdescripcion,1,60) as MTdescripcion
			from Alumnos a , 
					 Curso c, 
					 AlumnoCalificacionCurso b, 
					 Materia d,  
					 Grado g, 
					 AlumnoCalificacionPerEval e, 
					 PeriodoEvaluacion f,
					 Nivel n,
					 Grupo gru ,
					 GrupoAlumno ga,
					 Materia Melec,
					 Curso Celec,
					 MateriaTipo MT,
					 DocumentoMateriaTipo DMT
				where n.CEcodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
				  and b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#"> 
				  and a.Aretirado = 0
				  and a.Ecodigo = b.Ecodigo
				  and a.CEcodigo = b.CEcodigo 
				  and b.Ccodigo = c.Ccodigo 
				  and c.Mconsecutivo = d.Mconsecutivo 
				  and b.Ecodigo = e.Ecodigo 
				  and b.CEcodigo = e.CEcodigo 
				  and b.Ccodigo = e.Ccodigo 
				  and e.PEcodigo = f.PEcodigo 
				  and f.Ncodigo = d.Ncodigo 
				  and ((d.Melectiva = 'C') or (d.Melectiva = 'R') or (d.Melectiva = 'S'))
				  and d.Ncodigo = g.Ncodigo
				  and g.Ncodigo = n.Ncodigo
			
				  and gru.GRcodigo = ga.GRcodigo
				  and gru.Gcodigo = g.Gcodigo
				  and a.Ecodigo = ga.Ecodigo
			
					  
				  and gru.SPEcodigo = c.SPEcodigo
				
				  and b.ACCelectiva *= Celec.Ccodigo
				  and Celec.Mconsecutivo *= Melec.Mconsecutivo
			
				  and d.MTcodigo = MT.MTcodigo
				  and n.CEcodigo = MT.CEcodigo  
				  and DMT.MTcodigo =* MT.MTcodigo


			
		</cfquery>
		<!--- <cfdump var="#rsMateriaTipo#"> --->
		<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 23/04/2003 --->
	
		<cfquery datasource="#Session.DSN#" name="rsMAAtributo">
			select convert(varchar,MAA.id_tipo) + '|' + convert(varchar,MAA.id_atributo) + '|' + MAA.tipo_atributo as id_atributo, 
				substring(MAA.nombre_atributo,1,35) as nombre_atributo, convert(varchar,MAA.id_atributo) as id_atrib 
				
			from MATipoDocumento MAT, MAAtributo MAA
			where MAT.id_tipo = MAA.id_tipo
			<!---   <cfif isdefined("form.tipo") and len(trim(form.tipo)) neq 0 >
			  	and MAA.id_tipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tipo#">
			  </cfif> --->
		</cfquery>
	
		<cfquery datasource="#Session.DSN#" name="rsMAValorAtributo">
			select convert(varchar,MAVA.id_atributo) + '|' + convert(varchar,MAVA.id_valor) as id_valor, 
			convert(varchar,MAVA.id_valor) as valor_atrib, 
			substring(MAVA.contenido,1,35) as contenido
			from MAValorAtributo MAVA, MAAtributo MAA
			where MAVA.id_atributo = MAA.id_atributo
			 <!---  <cfif isdefined("form.id_atributo") and len(trim(form.id_atributo)) neq 0 >
			  	and MAVA.id_atributo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_atributo#">
			  </cfif> --->
		</cfquery>
		<!--- <cfdump var="#rsMAValorAtributo#">  --->
		<cfquery datasource="#Session.DSN#" name="rsMATipoDocumento">
			select distinct convert(varchar,MAT.id_tipo)  as tipo, substring(MAT.nombre_tipo,1,35) as nombre_tipo
			from MATipoDocumento MAT, BibliotecaCentroE BCE
			where BCE.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
			  and MAT.id_biblioteca = BCE.id_biblioteca
		</cfquery>
		<!--- <cfdump var="#rsMATipoDocumento#"> 
		<cfdump var="#rsMAAtributo#">  --->
		<script language="JavaScript" type="text/JavaScript">  
			var MAT_id_tipo = new Array();
			var tipoText = new Array();
			
			var MAA_id_tipo = new Array();
			var MAA_id_atributo = new Array();
			var MAA_tipo_atributo = new Array();
			var AtributoText = new Array();
			
			var MAVA_id_tipo = new Array();
			var MAVA_id_atributo = new Array();
			var MAVAAtributoText = new Array();
			
			function obtenerTipoDocumento(f) {
				//var f = document.form1;
				//alert("f es:"+f.value);
				//alert("tipo es:"+document.form1.tipo);
				//alert("f.tipo.length es:"+f.tipo.length);
				
					for(i=0; i<f.tipo.length; i++) {
						//var s = f.tipo.options[i].value.split("|");
						var s = f.tipo.options[i].value;
						//alert(s);
						// Códigos de los detalles
						MAT_id_tipo[i] = s; 
						//alert(MAT_id_tipo[i]);
						tipoText[i] = f.tipo.options[i].text;
					}
			}
			
			// Esta función únicamente debe ejecutarlo una vez
			function obtenerValorAtributo(f) {
				//alert("Entro 3");
				//select convert(varchar,MAVA.id_valor) + '|' +  convert(varchar,MAVA.id_atributo) as id_valor, 			
				for(i=0; i<f.valor.length; i++) {
					var s = f.valor.options[i].value.split("|");
					//alert("valor atributo es: "+s);
					// Códigos de los detalles
					MAVA_id_tipo[i] =  s[0];
					MAVA_id_atributo[i] = s[1];
					
					MAVAAtributoText[i] = f.valor.options[i].text;
				}
			}
			
			//select convert(varchar,MAA.id_tipo) + '|' + convert(varchar,MAA.id_atributo) + '|' + MAA.tipo_atributo as id_atributo,
			// Esta función únicamente debe ejecutarlo una vez
			function obtenerAtributo(f) {
				//alert("Entro 2");			
				for(i=0; i<f.atributo.length; i++) {
					var s = f.atributo.options[i].value.split("|");
					//alert(s);
					// Códigos de los detalles
					MAA_id_tipo[i] =  s[0];
					MAA_id_atributo[i] = s[1];
					MAA_tipo_atributo[i]= s[2];
					AtributoText[i] = f.atributo.options[i].text;
				}
			}
			
			
			function cargarAtributo(csourceTipoAtrib, ctarget, vdefault, t){
				// Limpiar Combo
				for (var i=ctarget.length-1; i >=0; i--) {
					ctarget.options[i]=null;
				}
				var kNv_id_tipo = csourceTipoAtrib.value;
				var j = 0;
				//alert ("kNv_id_tipo es:"+kNv_id_tipo);
				if (t) {
					var nuevaOpcion = new Option("(- No interesa -)","-1");
					ctarget.options[j]=nuevaOpcion;
					j++;
				}
				for (var i=0; i<MAA_id_tipo.length; i++) {
					if (MAA_id_tipo[i] == kNv_id_tipo ) {
						//nuevaOpcion = new Option(AtributoText[i],MAA_id_atributo[i] + '|' + MAA_tipo_atributo[i]);
						nuevaOpcion = new Option(AtributoText[i],MAA_id_atributo[i]);
						ctarget.options[j]=nuevaOpcion;
						if (vdefault != null && MAA_id_atributo[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			}
			
			function cargarValor(csourceValAtrib, ctarget, vdefault, t){
				// Limpiar Combo
				for (var i=ctarget.length-1; i >=0; i--) {
					ctarget.options[i]=null;
				}
				var h = csourceValAtrib.value.split("|");			
				var kNv_Val_id_tipo = h[0];
				var kNv_val_valor = h[1];
				//alert("kNv_Val_id_tipo es: "+kNv_Val_id_tipo); 
				//var kNv_Val_id_tipo = csourceValAtrib.value;
				
				var j = 0;
				if (t) {
					var nuevaOpcion = new Option("(- No interesa -)","-1");
					ctarget.options[j]=nuevaOpcion;
					j++;
				}
				for (var i=0; i<MAVA_id_tipo.length; i++) {
						//alert("MAVA_id_tipo es: " + MAVA_id_tipo[i]); alert("kNv_Val_id_tipo es: "+kNv_Val_id_tipo);
					if (MAVA_id_tipo[i] == kNv_Val_id_tipo ) {
						nuevaOpcion = new Option(MAVAAtributoText[i],MAVA_id_atributo[i] );
						ctarget.options[j]=nuevaOpcion;
						if (vdefault != null && MAVA_id_atributo[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			}

		</script>
		<!---------------------------------------------------------------------------------- --->

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function ocultar(obj){
		var valor1= document.getElementById("valor1");
		var valor2= document.getElementById("valor2");
		
		//recorrer el arreglo del atributo 
		//alert("el valor de ocultar es: " + obj.value);
		
		//alert(obj.length);
		//alert("holas");
		for(i=0; i<MAA_id_atributo.length; i++) {
			//alert(MAA_id_atributo[i]);				
			//alert("En ocultar obj.value es: " + obj.value);
			//alert("En ocultar MAA_tipo_atributo[i] es: " + MAA_tipo_atributo[i]);
			if (MAA_id_atributo[i] == obj.value) {
				//alert(MAA_tipo_atributo[i]);
				//alert(obj.value);
				if(MAA_tipo_atributo[i] == 'V'){
					valor1.style.display = "";
					valor2.style.display = "";
				}else {
					valor1.style.display = "none";
					valor2.style.display = "none";
				}
			}
		}
	}
</script>
		<form name="form1" method="post" action="BusquedaMaterial.cfm">
			<input name="MTcodigo" id="MTcodigo" type="hidden" value="">
			<input name="id_documento" id="id_documento" type="hidden" value="">
			<!--- <input name="id_atributo" id="id_atributo" type="hidden" value=""> --->
			<!--- <input name="id_tipo" id="id_tipo" type="hidden" value=""> --->
			<input name="tipo_atributo" id="tipo_atributo" type="hidden" value="">
			<input name="id_valor" id="id_valor" type="hidden" value="">
			<!--- <input type="hidden" name="tipo" value="<cfif isdefined('form.tipo')><cfoutput>#form.tipo#</cfoutput></cfif>"> --->
		      <table width="100%" border="0" cellspacing="1" cellpadding="1" class="areaFiltro">
                <tr> 
                  <td colspan="4"> 
				  <!---
                    <cfif isdefined("form.btnGenerar") and form.btnGenerar NEQ "">
                      <cfinvoke 
							component="edu.Componentes.NavegaPrint" 
							method="Navega" 
							returnvariable="pListaNavegable">
                        	<cfif isdefined("form.btnGenerar")>
								<cfset btnGenerar = #form.btnGenerar#>	
							</cfif>
							<cfif isdefined("form.id_documento")>
								<cfset id_documento = #form.id_documento#>	
							</cfif>
							<cfif isdefined("form.id_atributo")>
								<cfset id_atributo = #form.id_atributo#>	
							</cfif>
							<cfif isdefined("form.tipo")>
								<cfset tipo = #form.tipo#>	
							</cfif>
							<cfif isdefined("form.tipo_atributo")>
								<cfset tipo_atributo = #form.tipo_atributo#>	
							</cfif>
							<cfif isdefined("form.id_valor")>
								<cfset id_valor = #form.id_valor#>	
							</cfif>
                        <cfinvokeargument name="printEn" value="/cfmx/edu/docencia/consultas/imprime/ListaIncidenciasImpr.cfm">
                        <cfinvokeargument name="Param" value="&btnGenerar=#btnGenerar#&id_documento=#id_documento#&id_atributo=#id_atributo#&tipo=#tipo#&tipo_atributo=#tipo_atributo#&id_valor=#id_valor#">
                        <cfinvokeargument name="Tipo" value="2">
                      </cfinvoke>
                      <cfelse>
                    </cfif> 
					--->
					</td>
                </tr>
                <tr>
                  <td class="subTitulo">&nbsp;</td>
                  <td align="left" class="subTitulo">Alumno</td>
                  <td align="left" class="subTitulo">Tipo de Materia</td>
                  <td class="subTitulo">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="subTitulo">&nbsp;</td>
                  <td align="left" class="subTitulo"> 
                    <select name="cboAlumno"
                style="font:10px Verdana, Arial, Helvetica, sans-serif;"
                onChange="fnReLoad();">
                      <cfset LvarSelected="0">
                      <cfset LvarFirst="">
                      <cfoutput query="qryAlumnos"> 
                        <cfif currentRow eq 1>
                          <cfset LvarFirst=Codigo>
                          <cfset LvarPersonaAlumno="#Persona#">
                        </cfif>
                        <option value="#Codigo#"
	  <cfif #form.cboAlumno# eq #Codigo#> selected<cfset LvarSelected="1"><cfset LvarPersonaAlumno="#Persona#">
	  </cfif>>#Descripcion#</option>
                      </cfoutput> 
                      <cfif #LvarSelected# eq "0">
                        <cfif LvarFirst neq "">
                          <cfset form.cboAlumno=LvarFirst>
                          <cfelse>
                          <cfset form.cboAlumno="-999">
                          <cfset LvarPersonaAlumno="-999">
                        </cfif>
                      </cfif>
                    </select></td>
                  <td align="left" nowrap class="subTitulo"> 
                    <!--- <select name="codigo" id="codigo" onChange="javascript: cargarTipo(this,this.form.tipo,'<cfif isdefined('Form.tipo') AND Form.tipo NEQ '-1'><cfoutput>#Form.tipo#</cfoutput></cfif>',true); obtenerMateriaTipo(this);"> --->
                    <select name="codigo" id="codigo" >
                       <option value="-1" <cfif isdefined("form.codigo") and form.codigo EQ "-1">selected</cfif>>(- No interesa -)</option>
					  <cfoutput query="rsMateriaTipo"> 
                        <option value="#rsMateriaTipo.codigo#" <cfif isdefined('form.btnGenerar') and isdefined('form.codigo') and form.codigo EQ '#rsMateriaTipo.codigo#'>selected</cfif>>#rsMateriaTipo.MTdescripcion#</option>
                      </cfoutput> </select></td>
                  <td class="subTitulo">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="18%" class="subTitulo">&nbsp;</td>
                  <td width="48%" align="left" class="subTitulo">Tipo de Documento</td>
                  <td width="34%" align="left" class="subTitulo">Tipo de Contenido</td>
                  <td width="34%" class="subTitulo">&nbsp;</td>
                </tr>
                <tr> 
                	<td width="18%">&nbsp;</td>
                  	
                  <td width="48%" align="left"> 
                    <select name="tipo" id="tipo" onChange="javascript:  cargarAtributo(this,this.form.atributo,'<cfif isdefined('Form.atributo') AND Form.atributo NEQ '-1'><cfoutput>#Form.atributo#</cfoutput></cfif>',true);">> 
                       <option value="-1" <cfif isdefined("form.tipo") and form.tipo EQ "-1">selected</cfif>>(- No interesa -)</option> 
                      <cfoutput query="rsMAtipoDocumento"> 
                        <option value="#rsMAtipoDocumento.tipo#"<cfif isdefined('form.btnGenerar') and isdefined('form.tipo') and form.tipo EQ '#rsMAtipoDocumento.tipo#'>selected</cfif>>#rsMAtipoDocumento.nombre_tipo#</option>
                      </cfoutput> </select> </td>
                  <td width="34%" align="left">
				  	<select name="tipo_contenido" id="tipo_contenido"> 
                    	<option value="-1" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "-1">selected</cfif>>(- No interesa -)</option>
						<option value="I" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "I">selected</cfif>>Imagen</option>
						<option value="D" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "D">selected</cfif>>Documento</option>
						<option value="L" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "L">selected</cfif>>Link</option>
						<option value="T" <cfif isdefined("form.tipo_contenido") and form.tipo_contenido EQ "T">selected</cfif>>Texto</option>
                    </select></td>
                  <td width="34%">&nbsp; </td>
                </tr>
                <tr> 
                  <td width="18%" class="subTitulo">&nbsp;</td>
                  <td width="48%" align="left" class="subTitulo">Atributo</td>
                  <td width="34%" align="left" class="subTitulo"><div id="valor1">Valor</div></td>
                  <td width="34%" class="subTitulo">&nbsp; </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td align="left"> 
                    <select name="atributo" id="atributo"  onChange="javascript: ocultar(this.form.atributo); cargarValor(this,this.form.valor,'<cfif isdefined('Form.valor') AND Form.valor NEQ '-1'><cfoutput>#Form.valor#</cfoutput></cfif>',true);" >
                     <!---  <option value="-1" <cfif isdefined("form.atributo") and form.atributo EQ "-1">selected</cfif>>- (No Interesa) -</option> --->
                      <cfoutput query="rsMAAtributo"> 
                        <option value="#rsMAAtributo.id_atributo#"<cfif isdefined('form.btnGenerar') and isdefined('form.atributo') and form.atributo EQ '#rsMAAtributo.id_atrib#'>selected</cfif>>#rsMAAtributo.nombre_atributo#</option>
                      </cfoutput> </select>
                  </td>
					<td align="left" valign="middle"> 
						<div id="valor2">
							<select name="valor" id="valor">
								<!--- <option value="-1" <cfif isdefined("form.valor") and form.valor EQ "-1">selected</cfif>>- (No Interesa) -</option> --->
								<cfoutput query="rsMAValorAtributo"> 
									<option value="#rsMAValorAtributo.id_valor#"<cfif isdefined('form.btnGenerar') and isdefined('form.valor') and form.valor EQ '#rsMAValorAtributo.valor_atrib#'>selected</cfif>>#rsMAValorAtributo.contenido#</option>
								</cfoutput> 
							</select>
						</div>
					</td>
                  <td colspan="2" rowspan="3" align="center" valign="middle"><input name="btnGenerar" type="submit" id="btnGenerar2" value="Generar" > 
                  </td>
                </tr>
                <tr> 
                  <td width="18%" class="subTitulo">&nbsp;</td>
                  <td width="48%" class="subTitulo">&nbsp;</td>
                  <td width="34%"  class="subTitulo">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp; </td>
                  <td>&nbsp;</td>
                </tr>
              </table>
		</form>
		<!--- <cfdump var="#form#"> --->
		<cfif isdefined("form.btnGenerar")> 
				<cfinclude template="formBusquedaMaterial.cfm">
		</cfif>

			<script language="JavaScript" type="text/javascript" >
				obtenerTipoDocumento(document.form1);
				obtenerAtributo(document.form1);
				cargarAtributo(document.form1.tipo,document.form1.atributo, '<cfif isdefined("Form.atributo") AND Form.atributo NEQ "-1"><cfoutput>#Form.atributo#</cfoutput></cfif>', true);	
				obtenerValorAtributo(document.form1);
				//cargarValorAtributo
				cargarValor(document.form1.atributo,document.form1.valor, '<cfif isdefined("Form.valor") AND Form.valor NEQ "-1"><cfoutput>#Form.valor#</cfoutput></cfif>', true);	
			</script>
			<script language="JavaScript">
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
							
				ocultar(document.form1.atributo);		
			</script>
			
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
