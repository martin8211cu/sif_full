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
            Horario de Curso<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
	<cfquery name="tipoCurso" datasource="#Session.Edu.DSN#">
		select m.Melectiva
		from Curso c, Materia m
		where c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
		and c.Mconsecutivo = m.Mconsecutivo
	</cfquery>
	<cfset melectiva = tipoCurso.Melectiva>
	
	<cfif melectiva EQ 'R'>
		<cfquery name="rsBloquesHorario" datasource="#Session.Edu.DSN#">
			select e.Hbloque, d.Hnombre+' : '+convert(varchar, e.Hentrada)+' - '+convert(varchar, e.Hsalida)+' : '+e.Hbloquenombre as Descripcion
			from Curso a, Grupo b, HorarioAplica c, HorarioTipo d, Horario e
			where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.GRcodigo = b.GRcodigo
			and b.Gcodigo = c.Gcodigo
			and c.Hcodigo = d.Hcodigo
			and d.Hcodigo = e.Hcodigo
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#" name="rsCurso">
			select b.PEdescripcion + ' : ' + c.SPEdescripcion as CursoLectivo,
				   (case d.Melectiva when 'R' then d.Mnombre + ' ' + g.GRnombre else a.Cnombre end) as Curso, e.Ndescripcion as Nivel, f.Gdescripcion as Grado, g.GRnombre as Grupo,
				   case d.Melectiva
						when 'R' then 'Regular'
						when 'S' then 'Sustitutiva'
						when 'E' then 'Electiva'
						when 'C' then 'Complementaria'
						else ''
				   end as Modalidad,
				   h.MTdescripcion as TipoMateria
			from Curso a, PeriodoEscolar b, SubPeriodoEscolar c, Materia d, Nivel e, Grado f, Grupo g, MateriaTipo h
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			  and a.PEcodigo = b.PEcodigo
			  and a.SPEcodigo = c.SPEcodigo
			  and a.Mconsecutivo = d.Mconsecutivo
			  and d.Ncodigo = e.Ncodigo
			  and d.Ncodigo = f.Ncodigo
			  and d.Gcodigo = f.Gcodigo
			  and a.GRcodigo *= g.GRcodigo
			  and d.MTcodigo = h.MTcodigo
		</cfquery>
	<cfelseif melectiva EQ 'S'>
		<cfquery name="rsBloquesHorario" datasource="#Session.Edu.DSN#">
			select distinct e.Hbloque, d.Hnombre+' : '+convert(varchar, e.Hentrada)+' - '+convert(varchar, e.Hsalida)+' : '+e.Hbloquenombre as Descripcion
			from Curso a, PeriodoEscolar b, Grado g, HorarioAplica c, HorarioTipo d, Horario e
			where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.PEcodigo = b.PEcodigo
			and b.Ncodigo = g.Ncodigo
			and g.Gcodigo = c.Gcodigo
			and c.Hcodigo = d.Hcodigo
			and d.Hcodigo = e.Hcodigo
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#" name="rsCurso">
			select b.PEdescripcion + ' : ' + c.SPEdescripcion as CursoLectivo,
				   a.Cnombre as Curso, e.Ndescripcion as Nivel, '' as Grado, '' as Grupo,
				   case d.Melectiva
						when 'R' then 'Regular'
						when 'S' then 'Sustitutiva'
						when 'E' then 'Electiva'
						when 'C' then 'Complementaria'
						else ''
				   end as Modalidad,
				   h.MTdescripcion as TipoMateria
			from Curso a, PeriodoEscolar b, SubPeriodoEscolar c, Materia d, Nivel e, MateriaTipo h
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			  and a.PEcodigo = b.PEcodigo
			  and a.SPEcodigo = c.SPEcodigo
			  and a.Mconsecutivo = d.Mconsecutivo
			  and d.Ncodigo = e.Ncodigo
			  and d.MTcodigo = h.MTcodigo
		</cfquery>
	</cfif>
	
	<cfquery name="rsInfraestructura" datasource="#Session.Edu.DSN#">
		select convert(varchar, Rconsecutivo) as Rconsecutivo, rtrim(Rcodigo)+' : '+rtrim(Rdescripcion) as Descripcion
		from Recurso
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfquery>


	<cfinclude template="../../portlets/pNavegacionCED.cfm">

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function regresarCursos() {
		location.href = "<cfoutput>#Session.Edu.RegresarUrl#</cfoutput>";
	}
</script>	

	<table class="areaDatos" width="100%">
	  <thead>
		<tr> 
		  <td colspan="5">Datos de Curso</td>
		</tr>
	  </thead>
	  <tbody>
	  	<tr>
		  <td colspan="3" align="center" valign="middle" style="font-size: 13pt; font-weight: bold;" nowrap><cfoutput>#rsCurso.Curso#</cfoutput></td>
		</tr>
		<tr> 
		  <td nowrap><strong>Curso Lectivo:</strong> <cfoutput>#rsCurso.CursoLectivo#</cfoutput></td>
		  <td nowrap><strong>Tipo de Materia:</strong> <cfoutput>#rsCurso.TipoMateria#</cfoutput></td>
		  <td nowrap><strong>Modalidad:</strong> <cfoutput>#rsCurso.Modalidad#</cfoutput></td>
		</tr>
		<tr> 
		  <td nowrap><strong>Nivel:</strong> <cfoutput>#rsCurso.Nivel#</cfoutput> </td>
		  <td nowrap><strong>Grado:</strong> <cfoutput>#rsCurso.Grado#</cfoutput> </td>
		  <td nowrap><strong>Grupo:</strong> <cfoutput>#rsCurso.Grupo#</cfoutput> </td>
		</tr>
	  </tbody>
	</table>
	<form name="form1" method="post" action="SQLHorarioCurso.cfm">
		<input type="hidden" name="Ccodigo" value="<cfoutput>#Form.Ccodigo#</cfoutput>">
		<cfif isdefined("Form.Hbloque")>
			<input type="hidden" name="HRdia_Ant" value="<cfoutput>#Form.HRdia#</cfoutput>">
			<input type="hidden" name="Hbloque_Ant" value="<cfoutput>#Form.Hbloque#</cfoutput>">
			<input type="hidden" name="Rconsecutivo_Ant" value="<cfoutput>#Form.Rconsecutivo#</cfoutput>">
		</cfif>
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td nowrap class="subTitulo">D&iacute;a</td>
			<td nowrap class="subTitulo">Bloque</td>
			<td nowrap class="subTitulo">Aula</td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap>
				<select name="HRdia">
				  <option value="0" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 0>selected</cfif>>Lunes</option>
				  <option value="1" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 1>selected</cfif>>Martes</option>
				  <option value="2" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 2>selected</cfif>>Mi&eacute;rcoles</option>
				  <option value="3" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 3>selected</cfif>>Jueves</option>
				  <option value="4" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 4>selected</cfif>>Viernes</option>
				  <option value="5" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 5>selected</cfif>>S&aacute;bado</option>
				  <option value="6" <cfif isdefined("Form.HRdia") and Form.HRdia EQ 6>selected</cfif>>Domingo</option>
				</select>
		  	</td>
			<td nowrap>
				<select name="Hbloque" id="Hbloque">
					<cfoutput query="rsBloquesHorario">
						<option value="#Hbloque#" <cfif isdefined("Form.Hbloque") and Form.Hbloque EQ rsBloquesHorario.Hbloque>selected</cfif>>#Descripcion#</option>
					</cfoutput>
				</select>
		  	</td>
			<td nowrap>
				<select name="Rconsecutivo" id="Rconsecutivo">
					<cfoutput query="rsInfraestructura">
						<option value="#Rconsecutivo#" <cfif isdefined("Form.Rconsecutivo") and Form.Rconsecutivo EQ rsInfraestructura.Rconsecutivo>selected</cfif>>#Descripcion#</option>
					</cfoutput>
				</select>
		  	</td>
			<td align="center" nowrap>
				<cfinclude template="../../portlets/pBotones.cfm">
				<!---
				<input type="submit" name="<cfif isdefined("Form.Hbloque")>btnCambiar<cfelse>btnAgregar</cfif>" value="<cfif isdefined("Form.Hbloque")>Modificar<cfelse>Agregar</cfif>">
				<cfif isdefined("Form.Hbloque")>
					<input type="submit" name="btnEliminar" value="Eliminar">
					<input type="submit" name="btnNuevo" value="Nuevo">
				</cfif>
				--->
			</td>
		  </tr>
		</table>
	</form>
	<cfinvoke 
	 component="edu.Componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="Curso a, HorarioGuia b, Horario c, Recurso d"/>
		<cfinvokeargument name="columnas" value="case b.HRdia when '0' then 'Lunes' 
																when '1' then 'Martes' 
																when '2' then 'Mircoles' 
																when '3' then 'Jueves' 
																when '4' then 'Viernes' 
																when '5' then 'S bado' 
																when '6' then 'Domingo' 
												   else '' end as Dia,
												   convert(varchar, c.Hentrada)+' - '+convert(varchar, c.Hsalida) + ' : ' + c.Hbloquenombre as Horario,
												   rtrim(Rcodigo)+' : '+rtrim(Rdescripcion) as Recurso, 
												   b.HRdia, convert(varchar, a.Ccodigo) as Ccodigo, convert(varchar, c.Hbloque) as Hbloque, convert(varchar, d.Rconsecutivo) as Rconsecutivo"/>
		<cfinvokeargument name="desplegar" value="Dia, Horario, Recurso"/>
		<cfinvokeargument name="etiquetas" value="Dia, Horario, Aula"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ccodigo = #Form.Ccodigo#
											and a.CEcodigo = #Session.Edu.CEcodigo#
											and a.Ccodigo = b.Ccodigo
											and b.Hcodigo = c.Hcodigo
											and b.Hbloque = c.Hbloque 
											and b.Rconsecutivo = d.Rconsecutivo
											order by b.HRdia, c.Hentrada, c.Hsalida, Rcodigo"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value="N,N,N"/>
		<cfinvokeargument name="irA" value="HorarioCurso.cfm"/>
	</cfinvoke>
	<p align="center">
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresarCursos();">
		<br>
		<br>
	</p>
	<script language="JavaScript" type="text/javascript">
		qFormAPI.errorColor = "#FFFFCC";
		//_addValidator("isTieneDependencias", __isTieneDependencias);
		
		objForm = new qForm("form1");
	
		<cfif modo EQ "ALTA">
			objForm.HRdia.required = true;
			objForm.HRdia.description = "Da";
			objForm.Hbloque.required = true;
			objForm.Hbloque.description = "Bloque";
			objForm.Rconsecutivo.required = true;
			objForm.Rconsecutivo.description = "Aula";
		<cfelseif modo EQ "CAMBIO">
			objForm.HRdia.required = true;
			objForm.HRdia.description = "D a";
			objForm.Hbloque.required = true;
			objForm.Hbloque.description = "Bloque";
			objForm.Rconsecutivo.required = true;
			objForm.Rconsecutivo.description = "Aula";
		</cfif>
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