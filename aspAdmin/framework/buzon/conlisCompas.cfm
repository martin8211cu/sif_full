<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.estudiante"/>
</cfinvoke>

<cfif isdefined("Url.forma") and not isdefined("Form.forma")>
	<cfparam name="Form.forma" default="#Url.forma#">
</cfif> 
<cfif isdefined("Url.txtEtiqueta") and not isdefined("Form.txtEtiqueta")>
	<cfparam name="Form.txtEtiqueta" default="#Url.txtEtiqueta#">
</cfif> 
<cfif isdefined("Url.cboCompasTemp") and not isdefined("Form.cboCompasTemp")>
	<cfparam name="Form.cboCompasTemp" default="#Url.cboCompasTemp#">
</cfif> 
<cfif isdefined("Url.cboCompasTempVAL") and not isdefined("Form.cboCompasTempVAL")>
	<cfparam name="Form.cboCompasTempVAL" default="#Url.cboCompasTempVAL#">
</cfif> 
<cfif isdefined("Url.txtNombre") and not isdefined("Form.txtNombre")>
	<cfparam name="Form.txtNombre" default="#Url.txtNombre#">
</cfif> 

<html>
<head>
<title>Compa&ntilde;eros</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<form name="form1" method="post" action="conlisCompas.cfm">
	<input type="hidden" name="forma" value="<cfoutput>#form.forma#</cfoutput>">
	<input type="hidden" name="txtEtiqueta" value="<cfoutput>#form.txtEtiqueta#</cfoutput>">	
	<input type="hidden" name="cboCompasTemp" value="<cfoutput>#form.cboCompasTemp#</cfoutput>">	
	<input type="hidden" name="cboCompasTempVAL" value="<cfoutput>#form.cboCompasTempVAL#</cfoutput>">		
		
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" class="subTitulo">Compa&ntilde;ero</td>
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

<!--- Compañeros de grupos --->
<cfif isdefined('form.cboCompasTempVAL') and form.cboCompasTempVAL EQ "-999">
	<cfset campos = "distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreCompa">
	<cfset tablas = "Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, GrupoAlumno ga2, Alumnos al2, PersonaEducativo pe">
	<cfset filtro = "al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
				  and al.CEcodigo = #Session.CEcodigo#
				  and al.Ecodigo = ga.Ecodigo
				  and al.CEcodigo = ga.CEcodigo
				  and ga.GRcodigo = gr.GRcodigo
				  and gr.PEcodigo = pv.PEcodigo
				  and gr.SPEcodigo = pv.SPEcodigo
				  and ga.CEcodigo = ga2.CEcodigo
				  and ga.GRcodigo = ga2.GRcodigo
				  and ga2.Ecodigo = al2.Ecodigo
				  and ga2.CEcodigo = al2.CEcodigo
				  and al2.persona = pe.persona
				  and al.Ecodigo != al2.Ecodigo">			
		
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) like upper('%" & #form.txtNombre# & "%')">
	</cfif>
	
<!--- Compañeros de materias sustitutivas --->
<cfelseif isdefined('form.cboCompasTempVAL') and form.cboCompasTempVAL NEQ "-999">
	<cfset campos = "distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreCompa">
	<cfset tablas = "Alumnos al, AlumnoCalificacionCurso acc, Curso cs, Materia ma, PeriodoVigente pv, AlumnoCalificacionCurso acc2, Alumnos al2, PersonaEducativo pe">
	<cfset filtro = "al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
				  and al.CEcodigo = #Session.CEcodigo#
				  and acc.Ccodigo = #form.cboCompasTempVAL#
				  and al.Ecodigo = acc.Ecodigo
				  and al.CEcodigo = acc.CEcodigo
				  and acc.Ccodigo = cs.Ccodigo
				  and acc.CEcodigo = cs.CEcodigo
				  and cs.Mconsecutivo = ma.Mconsecutivo
				  and ma.Melectiva = 'S'
				  and cs.PEcodigo = pv.PEcodigo
				  and cs.SPEcodigo = pv.SPEcodigo
				  and acc.CEcodigo = acc2.CEcodigo
				  and acc.Ccodigo = acc2.Ccodigo
				  and acc2.Ecodigo = al2.Ecodigo
				  and acc2.CEcodigo = al2.CEcodigo
				  and al2.CEcodigo = pe.CEcodigo
				  and al2.persona = pe.persona
				  and al.Ecodigo != al2.Ecodigo">			
		
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) like upper('%" & #form.txtNombre# & "%')">
	</cfif>

</cfif>	 
	
	<!--- Este filtro se usaba para poder enviar mensaje a todos los compañeros --->
	<!---
	<cfset filtro = filtro & " union select '-999' as persona, '** TODOS LOS COMPAÑEROS **' as nombreCompa order by nombreCompa">
	--->
	<cfset filtro = filtro & " order by nombreCompa">
	
	<cfif isdefined('form.forma')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "forma=" & Form.forma>
	</cfif>
	<cfif isdefined('form.txtEtiqueta')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtEtiqueta=" & Form.txtEtiqueta>
	</cfif>
	<cfif isdefined('form.cboCompasTemp')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboCompasTemp=" & Form.cboCompasTemp>
	</cfif>
	<cfif isdefined('form.cboCompasTempVAL')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboCompasTempVAL=" & Form.cboCompasTempVAL>
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
	  <cfinvokeargument name="desplegar" value="nombreCompa"/>
	  <cfinvokeargument name="etiquetas" value="Nombre Compañero"/>
	  <cfinvokeargument name="formatos" value=""/>
	  <cfinvokeargument name="filtro" value="#filtro#" />
	  <cfinvokeargument name="align" value="left"/>
	  <cfinvokeargument name="ajustar" value="N"/>
	  <cfinvokeargument name="funcion" value="fnAsignar"/>
	  <cfinvokeargument name="fparams" value="persona,nombreCompa"/>
	  <cfinvokeargument name="navegacion" value="#navegacion#"/>
	  <cfinvokeargument name="debug" value="N"/>
	   <cfinvokeargument name="maxrows" value="13"/> 
	</cfinvoke>								

</body>
</html>

<script language="JavaScript" type="text/javascript" >
	function fnAsignar(parPersona,parNombreCompa) {
		window.opener.document.<cfoutput>#form.forma#.#form.txtEtiqueta#</cfoutput>.value=parNombreCompa;
		window.opener.document.<cfoutput>#form.forma#.#form.cboCompasTemp#</cfoutput>.value=parPersona;	
		window.opener.document.<cfoutput>#form.forma#.unAlumno</cfoutput>.value="1";
		window.close();
	}
</script>
