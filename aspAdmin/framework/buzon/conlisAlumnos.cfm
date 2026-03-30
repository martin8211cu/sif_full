<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.docente"/>
</cfinvoke>

<cfif isdefined("Url.forma") and not isdefined("Form.forma")>
	<cfparam name="Form.forma" default="#Url.forma#">
</cfif> 
<cfif isdefined("Url.txtEtiqueta") and not isdefined("Form.txtEtiqueta")>
	<cfparam name="Form.txtEtiqueta" default="#Url.txtEtiqueta#">
</cfif> 
<cfif isdefined("Url.cboCurso") and not isdefined("Form.cboCurso")>
	<cfparam name="Form.cboCurso" default="#Url.cboCurso#">
</cfif> 
<cfif isdefined("Url.txtNombre") and not isdefined("Form.txtNombre")>
	<cfparam name="Form.txtNombre" default="#Url.txtNombre#">
</cfif> 

<html>
<head>
<title>Alumnos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<form name="form1" method="post" action="conlisAlumnos.cfm">
	<input type="hidden" name="forma" value="<cfoutput>#form.forma#</cfoutput>">
	<input type="hidden" name="txtEtiqueta" value="<cfoutput>#form.txtEtiqueta#</cfoutput>">	
	<input type="hidden" name="cboCurso" value="<cfoutput>#form.cboCurso#</cfoutput>">	
		
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" class="subTitulo">Alumno</td>
    </tr>
    <tr> 
      <td width="68%"><input name="txtNombre" type="text" id="txtNombre" size="80" maxlength="180" value="<cfif isdefined('form.txtNombre') and form.txtNombre NEQ ""><cfoutput>#form.txtNombre#</cfoutput></cfif>"></td>
      <td width="32%"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
    </tr>
  </table>
</form>

<cfset navegacion = ""> 
<cfset campos = ""> 
<cfset tablas = ""> 
<cfset filtro = ""> 

<!--- Alumnos de Curso --->
	<cfset campos = "distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreAlumno">
	<cfset tablas = "AlumnoCalificacionCurso acc, Curso cs, PeriodoVigente pv, Alumnos al, PersonaEducativo pe">
	<cfset filtro = "acc.Ccodigo = #Form.cboCurso#
					and acc.CEcodigo = #Session.CEcodigo#
					and acc.Ccodigo = cs.Ccodigo
					and acc.CEcodigo = cs.CEcodigo
					and cs.Splaza in (#ValueList(usr.num_referencia,',')#)
					and cs.PEcodigo = pv.PEcodigo
					and cs.SPEcodigo = pv.SPEcodigo
					and acc.Ecodigo = al.Ecodigo
					and acc.CEcodigo = al.CEcodigo
					and al.CEcodigo = pe.CEcodigo
					and al.persona = pe.persona">			
		
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) like upper('%" & #form.txtNombre# & "%')">
	</cfif>

	<cfset filtro = filtro & " union select persona = '-1', nombreDoc= '** Todos los Alumnos **' order by nombreAlumno">
	
	<cfif isdefined('form.forma')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "forma=" & Form.forma>
	</cfif>
	<cfif isdefined('form.txtEtiqueta')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtEtiqueta=" & Form.txtEtiqueta>
	</cfif>
	<cfif isdefined('form.cboCurso')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboCurso=" & Form.cboCurso>
	</cfif>
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtNombre=" & Form.txtNombre> 
	</cfif>	
	
	<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaMADocumento">
	  <cfinvokeargument name="tabla" value="#tablas#"/>
	  <cfinvokeargument name="columnas" value="#campos#"/>
	  <cfinvokeargument name="desplegar" value="nombreAlumno"/>
	  <cfinvokeargument name="etiquetas" value="Nombre Alumno"/>
	  <cfinvokeargument name="formatos" value=""/>
	  <cfinvokeargument name="filtro" value="#filtro#" />
	  <cfinvokeargument name="align" value="left"/>
	  <cfinvokeargument name="ajustar" value="N"/>
	  <cfinvokeargument name="funcion" value="fnAsignar"/>
	  <cfinvokeargument name="fparams" value="persona, nombreAlumno"/>
	  <cfinvokeargument name="navegacion" value="#navegacion#"/>
	  <cfinvokeargument name="debug" value="N"/>
	   <cfinvokeargument name="maxrows" value="13"/> 
	</cfinvoke>								

</body>
</html>

<script language="JavaScript" type="text/javascript" >
	function fnAsignar(parPersona,parNombreCompa) {
		window.opener.document.<cfoutput>#form.forma#.#form.txtEtiqueta#</cfoutput>.value = parNombreCompa;
		window.opener.document.<cfoutput>#form.forma#.cboAlumno</cfoutput>.value = parPersona;
		window.close();
	}
</script>
