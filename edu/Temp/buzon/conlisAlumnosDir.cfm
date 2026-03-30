<cfif isdefined("Url.forma") and not isdefined("Form.forma")>
	<cfparam name="Form.forma" default="#Url.forma#">
</cfif> 
<cfif isdefined("Url.txtEtiqueta") and not isdefined("Form.txtEtiqueta")>
	<cfparam name="Form.txtEtiqueta" default="#Url.txtEtiqueta#">
</cfif> 
<cfif isdefined("Url.cboGrupo") and not isdefined("Form.cboGrupo")>
	<cfparam name="Form.cboGrupo" default="#Url.cboGrupo#">
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
<form name="form1" method="post" action="conlisAlumnosDir.cfm">
	<input type="hidden" name="forma" value="<cfoutput>#form.forma#</cfoutput>">
	<input type="hidden" name="txtEtiqueta" value="<cfoutput>#form.txtEtiqueta#</cfoutput>">	
	<input type="hidden" name="cboGrupo" value="<cfoutput>#form.cboGrupo#</cfoutput>">	
		
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
	<cfset tablas = "Grupo gr, Nivel nv, Grado gd, PeriodoVigente pv, GrupoAlumno ga, Alumnos al, PersonaEducativo pe">
	<cfset filtro = "gr.GRcodigo = #Form.cboGrupo#
					and gr.PEcodigo = pv.PEcodigo
					and gr.SPEcodigo = pv.SPEcodigo
					and gr.Ncodigo = nv.Ncodigo
					and nv.CEcodigo = #Session.CEcodigo#
					and gr.Gcodigo = gd.Gcodigo
					and gr.GRcodigo = ga.GRcodigo
					and ga.Ecodigo = al.Ecodigo
					and al.CEcodigo = #Session.CEcodigo#
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
	<cfif isdefined('form.cboGrupo')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboGrupo=" & Form.cboGrupo>
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
