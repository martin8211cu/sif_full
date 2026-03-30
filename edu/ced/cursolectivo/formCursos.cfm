<cfif isdefined("Url.cbcursolectivo") and not isdefined("Form.cbcursolectivo")>
	<cfparam name="Form.cbcursolectivo" default="#Url.cbcursolectivo#">
</cfif>
<cfif isdefined("Url.Gcodigo") and not isdefined("Form.Gcodigo")>
	<cfparam name="Form.Gcodigo" default="#Url.Gcodigo#">
</cfif>
<cfif isdefined("Url.rcursotipo") and not isdefined("Form.rcursotipo")>
	<cfparam name="Form.rcursotipo" default="#Url.rcursotipo#">
</cfif>

<cfif isdefined("Form.cbcursolectivo") and Len(Trim(Form.cbcursolectivo)) NEQ 0 and isdefined("Form.Gcodigo") and Len(Trim(Form.Gcodigo)) NEQ 0 and isdefined("Form.rcursotipo") and (Form.rcursotipo EQ 0 or Form.rcursotipo EQ 2)>
	<cfset cod = ListToArray(Form.cbcursolectivo, "|")>
	<cfquery name="rsGruposGenerados" datasource="#Session.Edu.DSN#">
		set nocount on
		select count(*) as cantidad
		from Grupo
		where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		and Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
		and Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
		set nocount off
	</cfquery>
	
	<cfquery name="rsGruposGrado" datasource="#Session.Edu.DSN#">
		set nocount on
		select Gngrupos as cantidad, Gtiponum as numeracion
		from Grado
		where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
		set nocount off
	</cfquery>
	
	<cfif rsGruposGrado.cantidad GT rsGruposGenerados.cantidad>
		<!--- Generar Nuevos Grupos --->
		<cfloop index="i" from="#Val(rsGruposGenerados.cantidad+1)#" to="#rsGruposGrado.cantidad#">
			<cfquery name="rsCrearGrupos" datasource="#Session.Edu.DSN#">
				set nocount on
				insert into Grupo(PEcodigo, SPEcodigo, Ncodigo, Gcodigo, GRnombre)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">,
					<cfif rsGruposGrado.numeracion EQ "N">
						Gdescripcion <cfif rsGruposGrado.cantidad GT 1>+ ' ' + convert(varchar, <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">)</cfif>
					<cfelseif rsGruposGrado.numeracion EQ "A">
						Gdescripcion <cfif rsGruposGrado.cantidad GT 1>+ ' ' + char(64+<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">)</cfif>
					</cfif>
				from Grado
				where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
				set nocount off
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfquery name="rsCursos" datasource="#Session.Edu.DSN#">
		set nocount on
		select 0 as TipoCurso, convert(varchar, b.GRcodigo) as GRcodigo, b.GRnombre as Grupo, convert(varchar, a.Mconsecutivo) as CodCurso, a.Mnombre+' '+b.GRnombre as Curso,
			   '0' as CodProfesor, '' as Profesor, 0 as Matriculado, 0 as Horario, a.Melectiva as Modalidad
		from Materia a, Grupo b
		where a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
		and a.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
		<cfif Form.rcursotipo EQ 0>
		and a.Melectiva = 'R'
		<cfelseif Form.rcursotipo EQ 2>
		and (a.Melectiva = 'E' or a.Melectiva = 'C')
		</cfif>
		and a.Mactiva = 1
		and a.Ncodigo = b.Ncodigo
		and a.Gcodigo = b.Gcodigo
		and b.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		and b.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		and Mconsecutivo not in
		(select Mconsecutivo from Curso
		 where PEcodigo = b.PEcodigo
		   and SPEcodigo = b.SPEcodigo
		   and GRcodigo = b.GRcodigo)
		union
		select 1 as TipoCurso, convert(varchar, b.GRcodigo) as GRcodigo, b.GRnombre as Grupo, convert(varchar, c.Ccodigo) as CodCurso, a.Mnombre+' '+b.GRnombre as Curso,
			   convert(varchar, isnull(c.Splaza, 0)) as CodProfesor, 
			   ((case
				   when (rtrim(u.Papellido1) is not null) then u.Papellido1 + ' '
				   else null
			   end) +
			   (case
				   when (rtrim(u.Papellido2) is not null) then u.Papellido2 + ' '
				   else null
			   end) +
			   rtrim(u.Pnombre)) as Profesor,
			   (case a.Melectiva
			        when 'R' then (select count(*) from AlumnoCalificacionCurso where Ccodigo = c.Ccodigo) 
			        when 'C' then (select count(*) from AlumnoCalificacionCurso where Ccodigo = c.Ccodigo) 
					else (select count(*) from AlumnoCalificacionCurso where ACCelectiva = c.Ccodigo)
			   end) as Matriculado,
			   (select count(*) from HorarioGuia where Ccodigo = c.Ccodigo) as Horario,
			   a.Melectiva as Modalidad
		from Curso c, Materia a, Grupo b, Staff s, PersonaEducativo u
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		and c.Mconsecutivo = a.Mconsecutivo
		and a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
		and a.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
		<cfif Form.rcursotipo EQ 0>
		and a.Melectiva = 'R'
		<cfelseif Form.rcursotipo EQ 2>
		and (a.Melectiva = 'E' or a.Melectiva = 'C')
		</cfif>
		and c.GRcodigo = b.GRcodigo
		and b.PEcodigo = c.PEcodigo
		and b.SPEcodigo = c.SPEcodigo
		and a.Ncodigo = b.Ncodigo
		and a.Gcodigo = b.Gcodigo
		and c.Splaza *= s.Splaza
		and c.CEcodigo *= s.CEcodigo
		and s.persona *= u.persona
		order by 3, 5
		set nocount off
	</cfquery>
	<cfquery name="rshayCursos" dbtype="query">
		select 1 from rsCursos where TipoCurso = 0
	</cfquery>
	<cfset GenerarCursos = rshayCursos.recordCount GT 0>
	
<cfelseif isdefined("Form.cbcursolectivo") and Len(Trim(Form.cbcursolectivo)) NEQ 0 and isdefined("Form.rcursotipo") and Form.rcursotipo EQ 1>
	<cfset cod = ListToArray(Form.cbcursolectivo, "|")>
	<cfquery name="rsCursos" datasource="#Session.Edu.DSN#">
		set nocount on
		select 0 as TipoCurso, convert(varchar, a.Mconsecutivo) as CodCurso, a.Mnombre+'&nbsp; <input type=''text'' name=''sust_'+convert(varchar, a.Mconsecutivo)+''' size=''3'' maxlength=''2''>' as Curso,
			   '0' as CodProfesor, '' as Profesor, 0 as Matriculado, 0 as Horario, a.Melectiva as Modalidad
		from Materia a, MateriaTipo b
		where a.Melectiva = 'S'
		and a.Mactiva = 1
		and a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
		and a.MTcodigo = b.MTcodigo
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.Mconsecutivo not in
		(select x.Mconsecutivo from Curso x, Materia y
		 where x.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		   and x.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		   and x.Mconsecutivo = y.Mconsecutivo
		   and y.Melectiva = 'S'
		)
		and exists 
		(select 1 from Nivel c, Grado d, GradoSustitutivas e
		where b.CEcodigo = c.CEcodigo
		and c.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
		and c.Ncodigo = d.Ncodigo
		and d.Gcodigo = e.Gcodigo
		and a.Mconsecutivo = e.Mconsecutivo
		)
		union
		select 1 as TipoCurso, convert(varchar, c.Ccodigo) as CodCurso, c.Cnombre as Curso,
			   convert(varchar, isnull(c.Splaza, 0)) as CodProfesor, 
			   ((case
				   when (rtrim(u.Papellido1) is not null) then u.Papellido1 + ' '
				   else null
			   end) +
			   (case
				   when (rtrim(u.Papellido2) is not null) then u.Papellido2 + ' '
				   else null
			   end) +
			   rtrim(u.Pnombre)) as Profesor,
			   (select count(*) from AlumnoCalificacionCurso where Ccodigo = c.Ccodigo) as Matriculado,
			   (select count(*) from HorarioGuia where Ccodigo = c.Ccodigo) as Horario, 
			   a.Melectiva as Modalidad
		from Curso c, Materia a, Staff s, PersonaEducativo u
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		and c.Mconsecutivo = a.Mconsecutivo
		and a.Melectiva = 'S'
		and c.Splaza *= s.Splaza
		and c.CEcodigo *= s.CEcodigo
		and s.persona *= u.persona
		order by 1 desc, 3, 5
		set nocount off
	</cfquery>
	<cfquery name="rshayCursos" dbtype="query">
		select 1 from rsCursos where TipoCurso = 0
	</cfquery>
	<cfset GenerarCursos = rshayCursos.recordCount GT 0>

	<cfquery name="rsCursostoAdd" datasource="#Session.Edu.DSN#">
		set nocount on
		select distinct convert(varchar, a.Mconsecutivo) as Mconsecutivo, a.Mnombre as Curso
		from Curso c, Materia a, Staff s, PersonaEducativo u
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
		and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
		and c.Mconsecutivo = a.Mconsecutivo
		and a.Melectiva = 'S'
		and a.Mactiva = 1
		and c.Splaza *= s.Splaza
		and c.CEcodigo *= s.CEcodigo
		and s.persona *= u.persona
		order by Curso
		set nocount off
	</cfquery>
	
	<!--- 
	1. Preguntar si la cantidad de grupos coincide con la cantidad del grado seleccionado
	si la cantidad del grado es mayor hay que crear más grupos
	2. Averiguar si hay nuevas materias para generar. Si lo hay habilitar el boton de Generacion
	
	--->
</cfif>

<cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
	set nocount on
	select convert(varchar, a.Ncodigo) + '|' + convert(varchar, b.PEcodigo) + '|' + convert(varchar, c.SPEcodigo) as Codigo,
		   a.Ndescripcion + ' : ' + b.PEdescripcion + ' : ' + c.SPEdescripcion as Descripcion
	from Nivel a, PeriodoEscolar b, SubPeriodoEscolar c, PeriodoVigente d
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and a.Ncodigo = b.Ncodigo
	and b.PEcodigo = c.PEcodigo
	and a.Ncodigo = d.Ncodigo
	and b.PEcodigo = d.PEcodigo
	and c.SPEcodigo = d.SPEcodigo
	order by a.Norden
	set nocount off
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
	set nocount on
	select convert(varchar, b.Ncodigo)
		   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
		   convert(varchar, b.Gcodigo) as Gcodigo, 
		   b.Gdescripcion
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and a.Ncodigo = b.Ncodigo 
	order by a.Norden, b.Gorden
	set nocount off
</cfquery>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
		if (popUpWin) {
			if (!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisProfes(Curso) {
		popUpWindow("conlisProfesores.cfm?form=form1&id=Splaza"+Curso+"&desc=Profesor"+Curso+"&Curso="+Curso,200,200,500,350);
	}

	function mostrarGenerar(c) {
		var a = document.getElementById("divGenerar");
		if (c.checked) {
			a.style.display = "";
		} else {
			a.style.display = "none";
		}
	}

	<cfif isdefined("Form.rcursotipo") and isdefined("Form.cbcursolectivo") and Len(Trim(Form.cbcursolectivo)) NEQ 0 and isdefined("Form.Gcodigo") and Len(Trim(Form.Gcodigo)) NEQ 0>
	function doConlisHorarios(Curso) {
		location.href = "HorarioCurso.cfm?Ccodigo="+Curso
		              + "&RegresarURL=Cursos.cfm"
					  + "<cfoutput>#UrlEncodedFormat('?')#</cfoutput>"+"cbcursolectivo="+"<cfoutput>#Form.cbcursolectivo#</cfoutput>"
					  + "<cfoutput>#UrlEncodedFormat('&')#</cfoutput>"+"Gcodigo="+"<cfoutput>#Form.Gcodigo#</cfoutput>"
					  + "<cfoutput>#UrlEncodedFormat('&')#</cfoutput>"+"rcursotipo="+"<cfoutput>#Form.rcursotipo#</cfoutput>";
	}
	</cfif>

	function EliminarCurso(Curso) {
		if (confirm('Está seguro de que desea eliminar '+EliminarCurso.arguments[1]+'?')) {
			document.form1.ECurso.value = Curso;
			document.form1.action = 'SQLEliminarCurso.cfm';
			document.form1.submit();	
		}
	}

	function Recalendarizar(Curso) {
		if (confirm('Va a proceder a recalendarizar los temarios y evaluaciones del curso '+Recalendarizar.arguments[1]+'?')) {
			document.form1.UpdTyE.value = Curso;
			document.form1.action = 'SQLRecalendarizar.cfm';
			document.form1.submit();	
		}
	}

	function ActualizarTyE(Curso) {
		if (confirm('Va a proceder a actualizar los temarios y evaluaciones del curso '+ActualizarTyE.arguments[1]+'. Este proceso elimina todos los temarios y evaluaciones ya existentes para este curso. Está seguro de que desea continuar?')) {
			document.form1.InsTyE.value = Curso;
			document.form1.action = 'SQLActualizarTyE.cfm';
			document.form1.submit();	
		}
	}

	var gradostext = new Array();
	var grados = new Array();
	var niveles = new Array();

	// Esta función únicamente debe ejecutarlo una vez
	function obtenerGrados(f) {
		for(i=0; i<f.Gcodigo.length; i++) {
			var s = f.Gcodigo.options[i].value.split("|");
			// Códigos de los detalles
			niveles[i]= s[0];
			grados[i] = s[1];
			gradostext[i] = f.Gcodigo.options[i].text;
		}
	}
	
	function cargarGrados(csource, ctarget, vdefault){
		// Limpiar Combo
		for (var i=ctarget.length-1; i >=0; i--) {
			ctarget.options[i]=null;
		}
		var arry = csource.value.split('|');
		var k = arry[0];
		var j = 0;

		for (var i=0; i<grados.length; i++) {
			if (niveles[i] == k) {
				nuevaOpcion = new Option(gradostext[i],grados[i]);
				ctarget.options[j]=nuevaOpcion;
				if (vdefault != null && grados[i] == vdefault) {
					ctarget.selectedIndex = j;
				}
				j++;
			}
		}
		var j = ctarget.length;
		nuevaOpcion = new Option("-------------------","");
		ctarget.options[j++]=nuevaOpcion;
		nuevaOpcion = new Option("Crear Nuevo ...","0");
		ctarget.options[j]=nuevaOpcion;
	}

	function crearNuevoGrado(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='/cfmx/edu/ced/plan/Grado.cfm?RegresarURL=/cfmx/edu/ced/cursolectivo/Cursos.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function hideGrados(val) {
		var a = document.getElementById("divGrado");
		if (val == "1") a.style.display = "none";
		else a.style.display = "";
	}

</script>

<form name="form1" action="Cursos.cfm" method="post">
  <input type="hidden" name="ECurso" value="">
  <input type="hidden" name="UpdTyE" value="">
  <input type="hidden" name="InsTyE" value="">
  <table width="100%" border="0" cellspacing="0" cellpadding="5" class="areaFiltro">
    <cfif rsCursoLectivo.recordCount GT 0>
		<tr> 
		  <td colspan="3" valign="middle" nowrap>Curso Lectivo: 
			<select name="cbcursolectivo" id="cbcursolectivo" onChange="javascript: cargarGrados(this, this.form.Gcodigo, '')">
			  <cfoutput query="rsCursoLectivo"> 
				<option value="#Codigo#" <cfif isdefined("Form.cbcursolectivo") and Form.cbcursolectivo EQ rsCursoLectivo.Codigo>selected</cfif>>#Descripcion#</option>
			  </cfoutput> 
			</select>
		  </td>
		</tr>
	<cfelse>
		<tr>
			<td>Usted no tiene Tipos de Curso Lectivo creados o no tiene Cursos Lectivos creados o no ha establecido un Periodo Vigente</td>
		</tr>
	</cfif>
    <tr> 
      <td width="40%" nowrap> 
        <input type="radio" name="rcursotipo" value="0" class="areaFiltro" onClick="javascript: hideGrados(this.value);" <cfif isdefined("Form.rcursotipo") and Form.rcursotipo EQ 0>checked<cfelseif not isdefined("Form.rcursotipo")>checked</cfif>>
        Cursos Regulares<br>
        <input type="radio" name="rcursotipo" value="1" class="areaFiltro" onClick="javascript: hideGrados(this.value);" <cfif isdefined("Form.rcursotipo") and Form.rcursotipo EQ 1>checked</cfif>>
        Cursos Sustitutivas<br>
        <input type="radio" name="rcursotipo" value="2" class="areaFiltro" onClick="javascript: hideGrados(this.value);" <cfif isdefined("Form.rcursotipo") and Form.rcursotipo EQ 2>checked</cfif>>
        Cursos Electivas y Complementarias<br>
	  </td>
      <td width="40%" nowrap>
	  	<div id="divGrado">
			Grados 
			<select name="Gcodigo" id="Gcodigo" onChange="javascript: crearNuevoGrado(this);">
			  <cfoutput query="rsGrado"> 
				<option value="#Codigo#">#Gdescripcion#</option>
			  </cfoutput> 
			</select>
		</div>
      </td>
      <td width="20%" align="center" nowrap>
        <input name="btnCursos" type="submit" id="btnCursos" value="Ver Cursos">
      </td>
    </tr>
  </table>
<cfif isdefined("Form.rcursotipo") and (Form.rcursotipo EQ 0 OR Form.rcursotipo EQ 2)>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfset GrupoCorte = "">
				<cfoutput><cfloop query="rsCursos">
					<cfif rsCursos.Grupo NEQ GrupoCorte>
						<cfset GrupoCorte = rsCursos.Grupo>
						<tr>
							<td width="1%" nowrap class="tituloListas">&nbsp;</td>
							<td width="33%" nowrap class="tituloListas">#GrupoCorte#</td>
							<td width="32%" nowrap class="tituloListas">Profesor</td>
							<td width="32%" nowrap class="tituloListas">Horario</td>
							<td width="1%" nowrap class="tituloListas">&nbsp;</td>
							<td width="1%" nowrap class="tituloListas">&nbsp;</td>
						</tr>
					</cfif>
					<tr>
						<td width="1%" valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>"> 
							<cfif TipoCurso EQ 0><img src="../../Imagenes/completa.gif" border="0" align="center" alt="Curso a Generar"><cfelseif TipoCurso EQ 1 and Matriculado EQ 0><a href="javascript: EliminarCurso('#CodCurso#','#Curso#');"><img src="../../Imagenes/Cferror.gif" border="0" align="center" alt="Eliminar Curso"></a><cfelse>&nbsp;</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" <cfif TipoCurso EQ 0>style="font-weight: bold;"</cfif>>#Curso#</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif Modalidad EQ 'R' or Modalidad EQ 'S'>
								<cfif CodProfesor NEQ 0 and TipoCurso EQ 1>
									<input type="hidden" name="Splaza#CodCurso#" value="#CodProfesor#">
									<input type="text" name="Profesor#CodCurso#" size="40" value="#Profesor#" readonly="readonly">
									<a href="javascript: doConlisProfes('#CodCurso#');"><img src="../../Imagenes/Description.gif" alt="Lista de Profesores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a> 
								<cfelseif TipoCurso EQ 1>
									<input type="hidden" name="Splaza#CodCurso#" value="#CodProfesor#">
									<input type="text" name="Profesor#CodCurso#" size="40" value="--Profesor sin Asignar--" readonly="readonly">
									<a href="javascript: doConlisProfes('#CodCurso#');"><img src="../../Imagenes/Description.gif" alt="Lista de Profesores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a> 
								<cfelse>
									&nbsp;
								</cfif>
							<cfelse>
								N/A
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif Modalidad EQ 'R' or Modalidad EQ 'S'>
								<cfif TipoCurso EQ 1>
									<input type="button" name="btnHorarios" value="<cfif Horario EQ 0>Agregar Horario<cfelse>Modificar Horario</cfif>" onClick="javascript: doConlisHorarios('#CodCurso#');">
									<cfif Horario GT 0>
										<cfquery name="rshorario" datasource="#Session.Edu.DSN#">
											set nocount on
											select case b.HRdia 
												   when '0' then 'L' 
												   when '1' then 'K' 
												   when '2' then 'M' 
												   when '3' then 'J' 
												   when '4' then 'V' 
												   when '5' then 'S' 
												   when '6' then 'D' 
												   else '' end as Dia,
												   convert(varchar, c.Hentrada)+'-'+convert(varchar, c.Hsalida) + ': ' + c.Hbloquenombre as Horario,
												   '<b>Aula:</b> ' + rtrim(Rcodigo) as Recurso 
											from Curso a, HorarioGuia b, Horario c, Recurso d
											where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
											  and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodCurso#">
											  and a.Ccodigo = b.Ccodigo
											  and b.Hcodigo = c.Hcodigo
											  and b.Hbloque = c.Hbloque 
											  and b.Rconsecutivo = d.Rconsecutivo
											  order by b.HRdia, c.Hentrada, c.Hsalida, Rcodigo
											set nocount off
										</cfquery>
										<table border="0" width="100%">
											<cfloop query="rshorario">
												<tr>
													<td width="4%" nowrap><strong>#Dia#</strong></td>
													<td width="40%" nowrap>#Horario#</td>
													<td width="56%" nowrap>#Recurso#</td>
												</tr>
											</cfloop>
										</table>
									</cfif>
								<cfelse>
									&nbsp;
								</cfif>
							<cfelse>
								N/A
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif (Modalidad EQ 'R' or Modalidad EQ 'S') and TipoCurso EQ 1>
								<a href="javascript: ActualizarTyE('#CodCurso#','#Curso#');"><img src="../../Imagenes/Template.gif" border="0" align="center" alt="Actualizar temarios y evaluaciones"></a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif (Modalidad EQ 'R' or Modalidad EQ 'S') and TipoCurso EQ 1 and Horario GT 0>
								<a href="javascript: Recalendarizar('#CodCurso#','#Curso#');"><img src="../../Imagenes/DynamicTable.gif" border="0" align="center" alt="Recalendarizar temarios y evaluaciones generados"></a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</cfloop></cfoutput>
			</table>
		  </td>
		</tr>
		<tr align="center"> 
		  <td>
			<cfif isdefined("btnCursos") and GenerarCursos>
				<br>
				<input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" onClick="javascript: this.form.action = 'SQLCursos.cfm';">
			</cfif>
		  </td>
		</tr>
	  </table>
	  
<cfelseif isdefined("Form.rcursotipo") and Form.rcursotipo EQ 1>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%" nowrap class="tituloListas">&nbsp;</td>
					<td width="33%" nowrap class="tituloListas">Electivas</td>
					<td width="32%" nowrap class="tituloListas">Profesor</td>
					<td width="32%" nowrap class="tituloListas">Horario</td>
					<td width="1%" nowrap class="tituloListas">&nbsp;</td>
					<td width="1%" nowrap class="tituloListas">&nbsp;</td>
				</tr>
				<cfoutput><cfloop query="rsCursos">
					<tr>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>"> <cfif TipoCurso EQ 0><img src="../../Imagenes/completa.gif" border="0" align="center" alt="Curso a Generar"><cfelseif TipoCurso EQ 1 and Matriculado EQ 0><a href="javascript: EliminarCurso('#CodCurso#','#Curso#');"><img src="../../Imagenes/Cferror.gif" border="0" align="center" alt="Eliminar Curso"></a><cfelse>&nbsp;</cfif></td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" <cfif TipoCurso EQ 0>style="font-weight: bold;"</cfif>>#Curso#</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif CodProfesor NEQ 0 and TipoCurso EQ 1>
								<input type="hidden" name="Splaza#CodCurso#" value="#CodProfesor#">
								<input type="text" name="Profesor#CodCurso#" size="40" value="#Profesor#" readonly="readonly">
								<a href="javascript: doConlisProfes('#CodCurso#');"><img src="../../Imagenes/Description.gif" alt="Lista de Profesores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a> 
							<cfelseif TipoCurso EQ 1>
								<input type="hidden" name="Splaza#CodCurso#" value="#CodProfesor#">
								<input type="text" name="Profesor#CodCurso#" size="40" value="--Profesor sin Asignar--" readonly="readonly">
								<a href="javascript: doConlisProfes('#CodCurso#');"><img src="../../Imagenes/Description.gif" alt="Lista de Profesores" name="imagen" width="18" height="14" border="0" align="absmiddle"></a> 
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif TipoCurso EQ 1>
								<input type="button" name="btnHorarios" value="<cfif Horario EQ 0>Agregar Horario<cfelse>Modificar Horario</cfif>" onClick="javascript: doConlisHorarios('#CodCurso#');">
								<cfif Horario GT 0>
									<cfquery name="rshorario" datasource="#Session.Edu.DSN#">
										set nocount on
										select case b.HRdia 
											   when '0' then 'L' 
											   when '1' then 'K' 
											   when '2' then 'M' 
											   when '3' then 'J' 
											   when '4' then 'V' 
											   when '5' then 'S' 
											   when '6' then 'D' 
											   else '' end as Dia,
											   convert(varchar, c.Hentrada)+'-'+convert(varchar, c.Hsalida) + ': ' + c.Hbloquenombre as Horario,
											   '<b>Aula:</b> ' + rtrim(Rcodigo) as Recurso 
										from Curso a, HorarioGuia b, Horario c, Recurso d
										where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
										  and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodCurso#">
										  and a.Ccodigo = b.Ccodigo
										  and b.Hcodigo = c.Hcodigo
										  and b.Hbloque = c.Hbloque 
										  and b.Rconsecutivo = d.Rconsecutivo
										  order by b.HRdia, c.Hentrada, c.Hsalida, Rcodigo
										set nocount off
									</cfquery>
									<table border="0" width="100%">
										<cfloop query="rshorario">
											<tr>
												<td width="4%" nowrap><strong>#Dia#</strong></td>
												<td width="40%" nowrap>#Horario#</td>
												<td width="56%" nowrap>#Recurso#</td>
											</tr>
										</cfloop>
									</table>
								</cfif>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif (Modalidad EQ 'R' or Modalidad EQ 'S') and TipoCurso EQ 1>
								<a href="javascript: ActualizarTyE('#CodCurso#','#Curso#');"><img src="../../Imagenes/Template.gif" border="0" align="center" alt="Actualizar temarios y evaluaciones"></a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td valign="top" nowrap class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>">
							<cfif (Modalidad EQ 'R' or Modalidad EQ 'S') and TipoCurso EQ 1 and Horario GT 0>
								<a href="javascript: Recalendarizar('#CodCurso#','#Curso#');"><img src="../../Imagenes/DynamicTable.gif" border="0" align="center" alt="Recalendarizar temarios y evaluaciones generados"></a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</cfloop></cfoutput>
			</table>
		  </td>
		</tr>
		<cfif isdefined("rsCursostoAdd") and rsCursostoAdd.recordCount GT 0>
		<tr>
			<td style="padding-left: 10px">
				<input type="checkbox" name="masCursos" <cfif not GenerarCursos>onClick="javascript: mostrarGenerar(this);"</cfif>>
				Agregar un Curso Adicional
				<select id="CursoAdicional" name="CursoAdicional">
					<cfoutput query="rsCursostoAdd">
						<option value="#Mconsecutivo#">#Curso#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		</cfif>
		<tr align="center">
		  <td>
			<cfif isdefined("btnCursos")>
			<div id="divGenerar" align="center" <cfif not GenerarCursos>style="display: none;"</cfif>>
				<br>
				<input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" onClick="javascript: this.form.action = 'SQLCursos.cfm';">
			</div>
			</cfif>
		  </td>
		</tr>
	  </table>
</cfif>
</form>
<script language="JavaScript" type="text/javascript">
	obtenerGrados(document.form1);
	cargarGrados(document.form1.cbcursolectivo, document.form1.Gcodigo, '<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>');
	if (document.form1.rcursotipo[1].checked) hideGrados("1");
	else hideGrados("0");
</script>
