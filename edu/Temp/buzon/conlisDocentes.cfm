<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.director"/>
</cfinvoke>

<cfif isdefined("Url.forma") and not isdefined("Form.forma")>
	<cfparam name="Form.forma" default="#Url.forma#">
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
	
	<cfset campos = "distinct convert(varchar,st.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDoc">
	<cfset tablas = "DirectorNivel dn, Nivel nv, Curso cs, Materia ma, PeriodoVigente pv, Staff st, PersonaEducativo pe">
	<cfset filtro = " dn.Dcodigo in (#ValueList(usr.num_referencia,',')#)
					and nv.CEcodigo = #Session.CEcodigo#
					and nv.Ncodigo = dn.Ncodigo
					and nv.CEcodigo = cs.CEcodigo
					and cs.Mconsecutivo = ma.Mconsecutivo
					and ma.Ncodigo = nv.Ncodigo
					and cs.PEcodigo = pv.PEcodigo
					and cs.SPEcodigo = pv.SPEcodigo
					and cs.Splaza = st.Splaza
					and cs.CEcodigo = st.CEcodigo
					and st.CEcodigo = pe.CEcodigo
					and st.persona = pe.persona
					and st.autorizado = 1">
	
	<cfif isdefined("Form.rdTipoDoc") and Form.rdTipoDoc EQ 1>
		<cfif isdefined("Form.cboNivelesTemp") and Form.cboNivelesTemp NEQ "-1" and Form.cboNivelesTemp NEQ "-999">
			<cfset filtro = filtro & " and nv.Ncodigo = " & Form.cboNivelesTemp>
		</cfif>
	<cfelseif isdefined("Form.rdTipoDoc") and Form.rdTipoDoc EQ 2>
		<cfif isdefined("Form.cboTiposMatTemp") and Form.cboTiposMatTemp NEQ "-1" and Form.cboTiposMatTemp NEQ "-999">
			<cfset filtro = filtro & " and ma.MTcodigo = " & Form.cboTiposMatTemp>
		</cfif>
	</cfif>
	<cfif isdefined("Form.txtNombre") and len(trim(Form.txtNombre)) NEQ 0>
		 <cfset filtro = filtro & " and upper(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) like upper('%" & Form.txtNombre & "%')">
	</cfif>
	<cfset filtro = filtro & " union select '-2' as persona, '** TODOS LOS PROFESORES **' as nombreDoc order by nombreDoc">
	
	<cfif isdefined('form.forma')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "forma=" & Form.forma>
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
	  <cfinvokeargument name="filtro" value="#filtro#" />
	  <cfinvokeargument name="align" value="left"/>
	  <cfinvokeargument name="ajustar" value="N"/>
	  <cfinvokeargument name="funcion" value="fnAsignar"/>
	  <cfinvokeargument name="fparams" value="persona,nombreDoc"/> 
	  <cfinvokeargument name="navegacion" value="#navegacion#"/>
	  <cfinvokeargument name="debug" value="N"/>
	   <cfinvokeargument name="maxrows" value="10"/> 
	</cfinvoke>								

	<script language="JavaScript" type="text/javascript" >
		function fnAsignar(parPersona,parNombreDoc) {
			window.opener.document.<cfoutput>#form.forma#.#form.txtDocente#</cfoutput>.value = parNombreDoc;
			window.opener.document.<cfoutput>#form.forma#.#form.cboDocenteTemp#</cfoutput>.value = parPersona;
			window.close();
		}
	</script>

</body>
</html>

