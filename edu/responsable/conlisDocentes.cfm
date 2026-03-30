<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.director"/>
</cfinvoke>

<cfif isdefined("Url.forma") and not isdefined("Form.forma")>
	<cfparam name="Form.forma" default="#Url.forma#">
</cfif> 
<cfif isdefined("Url.txtEtiqueta") and not isdefined("Form.txtEtiqueta")>
	<cfparam name="Form.txtEtiqueta" default="#Url.txtEtiqueta#">
</cfif> 
<cfif isdefined("Url.cboDocenteTemp") and not isdefined("Form.cboDocenteTemp")>
	<cfparam name="Form.cboDocenteTemp" default="#Url.cboDocenteTemp#">
</cfif> 
<cfif isdefined("Url.txtDocente") and not isdefined("Form.txtDocente")>
	<cfparam name="Form.txtDocente" default="#Url.txtDocente#">
</cfif> 
<cfif isdefined("Url.rdTipoDoc") and not isdefined("Form.rdTipoDoc")>
	<cfparam name="Form.rdTipoDoc" default="#Url.rdTipoDoc#">
</cfif> 
<cfif isdefined("Url.cboNivelesTemp") and not isdefined("Form.cboNivelesTemp")>
	<cfparam name="Form.cboNivelesTemp" default="#Url.cboNivelesTemp#">
</cfif> 
<cfif isdefined("Url.cboTiposMatTemp") and not isdefined("Form.cboTiposMatTemp")>
	<cfparam name="Form.cboTiposMatTemp" default="#Url.cboTiposMatTemp#">
</cfif> 


<html>
<head>
<title>Docentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<form name="form1" method="post" action="conlisDocentes.cfm">
	<input type="hidden" name="forma" value="<cfoutput>#form.forma#</cfoutput>">
	<input type="hidden" name="txtEtiqueta" value="<cfoutput>#form.txtEtiqueta#</cfoutput>">	
	<input type="hidden" name="cboDocenteTemp" value="<cfoutput>#form.cboDocenteTemp#</cfoutput>">	
	<input type="hidden" name="rdTipoDoc" value="<cfoutput>#form.rdTipoDoc#</cfoutput>">
	<input type="hidden" name="cboNivelesTemp" value="<cfoutput>#form.cboNivelesTemp#</cfoutput>">			
	<input type="hidden" name="txtDocente" value="<cfoutput>#form.txtDocente#</cfoutput>">				
	<input type="hidden" name="cboTiposMatTemp" value="<cfoutput>#form.cboTiposMatTemp#</cfoutput>">				
		
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" class="subTitulo">Docente</td>
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



<cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ "1">		<!--- Consulta de docentes por nivel --->
	<cfif isdefined('form.cboNivelesTemp') and form.cboNivelesTemp EQ "-999">	<!--- Todos los docentes de todos los niveles --->
		<cfset campos = "distinct 
							convert(varchar,s.persona) as persona, 
							(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc">
		<cfset tablas = " Staff	s,
							PersonaEducativo pe,
							Curso c,
							PeriodoVigente pv,
							Grupo gr,
							Materia m">
		<cfset filtro = " s.persona=pe.persona
				and c.Splaza=s.Splaza
				and s.CEcodigo=c.CEcodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.GRcodigo=gr.GRcodigo
				and pv.PEcodigo=gr.PEcodigo
				and pv.SPEcodigo=gr.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and s.CEcodigo in(
					Select n.CEcodigo
					from Director d,
						DirectorNivel dn,
						Nivel n,
						CentroEducativo ce
				where d.Dcodigo in (#ValueList(usr.num_referencia,',')#)
				and n.CEcodigo=#Session.Edu.CEcodigo#
				and d.Dcodigo=dn.Dcodigo
				and dn.Ncodigo=n.Ncodigo
				and n.CEcodigo=ce.CEcodigo
					)">			
					
	<cfelseif isdefined('form.cboNivelesTemp') and form.cboNivelesTemp NEQ "-999">		<!--- Consulta de docentes por Tipo de materia y por un nivel seleccionado --->		
		<cfset campos = "distinct 
							convert(varchar,s.persona) as persona, 
							(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc">
		<cfset tablas = " Staff	s,
							PersonaEducativo pe,
							Curso c,
							PeriodoVigente pv,
							Grupo gr,
							Materia m,
							Nivel n">	
		<cfset filtro = "  gr.Ncodigo=#form.cboNivelesTemp#
				and s.persona=pe.persona
				and c.Splaza=s.Splaza
				and s.CEcodigo=c.CEcodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.GRcodigo=gr.GRcodigo
				and pv.PEcodigo=gr.PEcodigo
				and pv.SPEcodigo=gr.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and gr.Ncodigo=m.Ncodigo
				and m.Ncodigo=n.Ncodigo				
				and s.CEcodigo in(
					Select n.CEcodigo
					from Director d,
						DirectorNivel dn,
						Nivel n,
						CentroEducativo ce
				where d.Dcodigo in (#ValueList(usr.num_referencia,',')#)
				and n.CEcodigo=#Session.Edu.CEcodigo#
				and d.Dcodigo=dn.Dcodigo
				and dn.Ncodigo=n.Ncodigo
				and n.CEcodigo=ce.CEcodigo
					)">				
	</cfif>
<cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ "2">		<!--- Consulta de docentes por Tipo de materia --->
	<cfif isdefined('form.cboTiposMatTemp') and form.cboTiposMatTemp EQ "-999">	<!--- Todos los docentes de todos los tipos de materia --->
		<cfset campos = "distinct 
							convert(varchar,s.persona) as persona, 
							(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc">
		<cfset tablas = " Staff	s,
							PersonaEducativo pe,
							Curso c,
							PeriodoVigente pv,
							Grupo gr,
							Materia m">
		<cfset filtro = " s.persona=pe.persona
				and c.Splaza=s.Splaza
				and s.CEcodigo=c.CEcodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.GRcodigo=gr.GRcodigo
				and pv.PEcodigo=gr.PEcodigo
				and pv.SPEcodigo=gr.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and s.CEcodigo in(
					Select n.CEcodigo
					from Director d,
						DirectorNivel dn,
						Nivel n,
						CentroEducativo ce
				where d.Dcodigo in (#ValueList(usr.num_referencia,',')#)
				and n.CEcodigo=#Session.Edu.CEcodigo#
				and d.Dcodigo=dn.Dcodigo
				and dn.Ncodigo=n.Ncodigo
				and n.CEcodigo=ce.CEcodigo
					)">			
	<cfelseif isdefined('form.cboTiposMatTemp') and form.cboTiposMatTemp NEQ "-999">	<!--- Todos los docentes por tipos de materia especifico --->
		<cfset campos = "distinct 
							convert(varchar,s.persona) as persona, 
							(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc">
		<cfset tablas = " Staff	s,
							PersonaEducativo pe,
							Curso c,
							PeriodoVigente pv,
							Grupo gr,
							Materia m">
		<cfset filtro = " m.MTcodigo=#form.cboTiposMatTemp#
				and s.persona=pe.persona
				and c.Splaza=s.Splaza
				and s.CEcodigo=c.CEcodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.GRcodigo=gr.GRcodigo
				and pv.PEcodigo=gr.PEcodigo
				and pv.SPEcodigo=gr.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and s.CEcodigo in(
					Select n.CEcodigo
					from Director d,
						DirectorNivel dn,
						Nivel n,
						CentroEducativo ce
				where d.Dcodigo in (#ValueList(usr.num_referencia,',')#)
				and n.CEcodigo=#Session.Edu.CEcodigo#
				and d.Dcodigo=dn.Dcodigo
				and dn.Ncodigo=n.Ncodigo
				and n.CEcodigo=ce.CEcodigo
					)">			
	</cfif>			
</cfif>

		<cfif isdefined('form.txtNombre') and len(trim(form.txtNombre)) NEQ 0>
			 <cfset filtro = #filtro# & " and upper(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) like upper('%" & #form.txtNombre# & "%')">
		</cfif>

		
		 <cfset filtro = #filtro# & "
			union
			
			select persona = '-2', nombreDoc= '** Todos **'
			
			Order by nombreDoc
		  ">

	<cfif isdefined('form.forma')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "forma=" & Form.forma>
	</cfif>
	<cfif isdefined('form.txtEtiqueta')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtEtiqueta=" & Form.txtEtiqueta>
	</cfif>
	<cfif isdefined('form.cboDocenteTemp')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboDocenteTemp=" & Form.cboDocenteTemp>
	</cfif>
	<cfif isdefined('form.txtDocente')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtDocente=" & Form.txtDocente>
	</cfif>	
	<cfif isdefined('form.rdTipoDoc')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "rdTipoDoc=" & Form.rdTipoDoc>
	</cfif>	
	<cfif isdefined('form.cboNivelesTemp')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboNivelesTemp=" & Form.cboNivelesTemp>
	</cfif>
	<cfif isdefined('form.cboTiposMatTemp')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cboTiposMatTemp=" & Form.cboTiposMatTemp>
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
	  <cfinvokeargument name="desplegar" value="nombreDoc"/>
	  <cfinvokeargument name="etiquetas" value="Docente"/>
<!--- 	  <cfinvokeargument name="formatos" value=""/> --->
	  <cfinvokeargument name="filtro" value="#filtro#" />
	  <cfinvokeargument name="align" value="left"/>
	  <cfinvokeargument name="ajustar" value="N"/>
 	  <cfinvokeargument name="funcion" value="fnAsignar"/>
	  <cfinvokeargument name="fparams" value="persona,nombreDoc"/> 
 	  <cfinvokeargument name="navegacion" value="#navegacion#"/>
	  <cfinvokeargument name="debug" value="N"/>
	   <cfinvokeargument name="maxrows" value="13"/> 
	</cfinvoke>								

</body>
</html>

<script language="JavaScript" type="text/javascript" >
	function fnAsignar(parPersona,parNombreDoc) {
		window.opener.document.<cfoutput>#form.forma#.#form.txtDocente#</cfoutput>.value=parNombreDoc;
		window.opener.document.<cfoutput>#form.forma#.#form.cboDocenteTemp#</cfoutput>.value=parPersona;	
			
		window.close();
	}
</script>
