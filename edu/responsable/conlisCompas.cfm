<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
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
<cfif isdefined('form.cboCompasTempVAL') and form.cboCompasTempVAL EQ "-999">		<!--- consulta para todos los compañeros --->
	<cfset campos = "distinct convert(varchar,a.persona) as persona, Pemail1, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreCompa">
	<cfset tablas = " Alumnos a, 
			Estudiante e,
			PersonaEducativo ped,
			GrupoAlumno ga,
			Grupo g,
			PeriodoVigente pv">
			<!--- ESTUDIANTES COMPANEROS DE GRUPOS POR ESTUDIANTE --->
	<cfset filtro = " a.CEcodigo=#Session.Edu.CEcodigo#
			and ga.GRcodigo in (
				Select g.GRcodigo
					from Alumnos a, 
						Estudiante e,
						GrupoAlumno ga,
						Grupo g,
						PeriodoVigente pv
					where a.CEcodigo=#Session.Edu.CEcodigo#
						and e.Ecodigo in (#ValueList(usr.num_referencia,',')#)
						and a.Ecodigo=e.Ecodigo
						and a.persona=e.persona
						and e.Ecodigo=ga.Ecodigo
						and a.CEcodigo=ga.CEcodigo
						and ga.GRcodigo=g.GRcodigo
						and g.PEcodigo=pv.PEcodigo
						and g.SPEcodigo=pv.SPEcodigo
						and g.Ncodigo=pv.Ncodigo
				)
			and a.Ecodigo=e.Ecodigo
			and a.persona=e.persona
			and e.persona=ped.persona
			and a.Ecodigo=ga.Ecodigo
			and a.CEcodigo=ga.CEcodigo
			and ga.GRcodigo=g.GRcodigo
			and g.PEcodigo=pv.PEcodigo
			and g.SPEcodigo=pv.SPEcodigo
			and g.Ncodigo=pv.Ncodigo">			
			
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) like upper('%" & #form.txtNombre# & "%')">
	</cfif>
	
	<cfset filtro = filtro & " union ">
	
	<!--- ESTUDIANTES COMPANEROS DE MATERIAS SUSTITUTIVAS POR ESTUDIANTE --->
	<cfset filtro = filtro & " 
		select distinct convert(varchar,a.persona) as persona, Pemail1, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreCompa
		from Alumnos a,
			Estudiante e,
			PersonaEducativo ped,
			AlumnoCalificacionCurso acc,
			Curso c,
			PeriodoVigente pv
		where a.CEcodigo=#Session.Edu.CEcodigo#
			and acc.Ccodigo in (
				select c.Ccodigo
				from Alumnos a,
					Estudiante e,
					AlumnoCalificacionCurso acc,
					Curso c,
					PeriodoVigente pv,
					Materia m
				where a.CEcodigo=#Session.Edu.CEcodigo#
					and e.Ecodigo in (#ValueList(usr.num_referencia,',')#)
					and a.Ecodigo=e.Ecodigo
					and a.persona=e.persona
					and e.Ecodigo=acc.Ecodigo
					and a.CEcodigo=acc.CEcodigo
					and acc.CEcodigo=c.CEcodigo
					and acc.Ccodigo=c.Ccodigo
					and c.PEcodigo=pv.PEcodigo
					and c.SPEcodigo=pv.SPEcodigo
					and c.Mconsecutivo=m.Mconsecutivo
					and m.Melectiva = 'S'
			)
			and a.Ecodigo=e.Ecodigo
			and a.persona=e.persona
			and e.Ecodigo=acc.Ecodigo
			and e.persona=ped.persona
			and a.CEcodigo=acc.CEcodigo
			and acc.CEcodigo=c.CEcodigo
			and acc.Ccodigo=c.Ccodigo
			and c.PEcodigo=pv.PEcodigo
			and c.SPEcodigo=pv.SPEcodigo	
	 ">	
	 
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) like upper('%" & #form.txtNombre# & "%')">
	</cfif>	 
<cfelseif isdefined('form.cboCompasTempVAL') and form.cboCompasTempVAL EQ "-998">	<!--- Compa;eros de grupos --->
	<cfset campos = "distinct convert(varchar,a.persona) as persona, Pemail1, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreCompa">
	<cfset tablas = " Alumnos a, 
				Estudiante e,
				PersonaEducativo ped,
				GrupoAlumno ga,
				Grupo g,
				PeriodoVigente pv">
			<!--- ESTUDIANTES COMPANEROS DE MATERIAS SUSTITUTIVAS --->
	<cfset filtro = " a.CEcodigo=#Session.Edu.CEcodigo#
					and ga.GRcodigo in (
						Select distinct g.GRcodigo
						from Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo=#Session.Edu.CEcodigo#
							and e.Ecodigo in (#ValueList(usr.num_referencia,',')#)
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and e.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
							and g.Ncodigo=pv.Ncodigo
					)					
					and a.Ecodigo=e.Ecodigo
					and a.persona=e.persona
					and e.persona=ped.persona
					and a.Ecodigo=ga.Ecodigo
					and a.CEcodigo=ga.CEcodigo
					and ga.GRcodigo=g.GRcodigo
					and g.PEcodigo=pv.PEcodigo
					and g.SPEcodigo=pv.SPEcodigo
					and g.Ncodigo=pv.Ncodigo">			
		
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) like upper('%" & #form.txtNombre# & "%')">
	</cfif>
<cfelseif isdefined('form.cboCompasTempVAL') and form.cboCompasTempVAL NEQ "-998" and form.cboCompasTempVAL NEQ "-999">	<!--- Compa;eros de materias sustitutivas --->
	<cfset campos = "distinct convert(varchar,a.persona) as persona, Pemail1, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreCompa">
	<cfset tablas = " Alumnos a,
				Estudiante e,
				PersonaEducativo ped,
				AlumnoCalificacionCurso acc,
				Curso c,
				PeriodoVigente pv,
				Materia m">
	<cfset filtro = " a.CEcodigo=#Session.Edu.CEcodigo#
				and acc.Ccodigo = #form.cboCompasTempVAL#
				and a.Ecodigo=e.Ecodigo
				and a.persona=e.persona
				and e.Ecodigo=acc.Ecodigo
				and e.persona=ped.persona
				and a.CEcodigo=acc.CEcodigo
				and acc.CEcodigo=c.CEcodigo
				and acc.Ccodigo=c.Ccodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and m.Melectiva = 'S'
				">			
		
	<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) like upper('%" & #form.txtNombre# & "%')">
	</cfif>
</cfif>	 
	
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
	  <cfinvokeargument name="etiquetas" value="nombre Compañero"/>
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
		window.close();
	}
</script>