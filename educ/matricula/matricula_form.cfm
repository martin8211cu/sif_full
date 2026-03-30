<cfparam name="Url.TPer" default="A">
<cfparam name="Form.TPer" default="#Url.TPer#">
<cfset TipoPersona = form.TPer>
<!--- 
<cfif isdefined("Url.TPer") and not isdefined("Form.TPer")>
	<cfparam name="Form.TPer" default="#Url.TPer#">
</cfif>
	
<cfif isdefined("form.TPer") and Len(form.TPer)>
	<cfset TipoPersona = form.TPer>
<cfelse>
	<cfset TipoPersona = "A">
</cfif>
 --->
<cfset autorizacion = false>
<cfquery name="rsPermProc" datasource="asp">
	Select *
	from vUsuarioProcesos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
		<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
			and rtrim(SPcodigo)='SE_001'
		<cfelseif TipoPersona EQ 'G'>	<!--- Profesor Guia --->
			and rtrim(SPcodigo)='PG_001'
		<cfelseif TipoPersona EQ 'TA'>	<!--- Administrativo --->			
			and rtrim(SPcodigo) = 'TA_005'
		</cfif>
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfif isdefined('rsPermProc') and rsPermProc.recordCount GT 0>
	<cfif TipoPersona NEQ 'TA'>
		<cfquery name="rsUsuario" datasource="#Session.DSN#">
			<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
				Select convert(varchar,Apersona) as Apersona from Alumno
				where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				  and Ecodigo=#session.Ecodigo#
			<cfelseif TipoPersona EQ 'G'>	<!--- Profesor Guia --->
				Select convert(varchar,PGpersona) as Apersona from ProfesorGuia
				where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				  and Ecodigo=#session.Ecodigo#
			</cfif>
		</cfquery>
		<cfif isdefined('rsUsuario') and rsUsuario.recordCount GT 0>
			<cfset autorizacion = true>
		</cfif>
	<cfelse>
		<cfset autorizacion = true>
	</cfif>
</cfif>

<cfparam name="form.Apersona" default="">
<cfparam name="form.Pid" default="">
<cfparam name="form.Mcodigo" default="">
<cfparam name="form.Mcodificacion" default="">
<cfparam name="form.PMcodigo" default="">
<cfparam name="form.VerHorario" default="0">
<cfparam name="form.PMCcodigo_cambiar" default="">
<cfset form.Mcodificacion=ucase(form.Mcodificacion)>
<cfset LvarCcodigo_cambiar = "">
<cfparam name="form.F1" default="">
<cfparam name="form.F2" default="">
<cfparam name="form.F3" default="">
<cfparam name="form.F4" default="">
<cfparam name="form.F5" default="">

<!--- 
Combo de Períodos de Matricula vigentes
 --->

<cfquery name="rsPeriodoMatricula" datasource="#Session.DSN#">
	select 	convert(varchar,a.PMcodigo) as PMcodigo,
			convert(varchar,a.PLcodigo) as PLcodigo,
			convert(varchar,a.PEcodigo) as PEcodigo,
			a.PMtipo,
			case when a.PEcodigo is not null
				then c.PEnombre + ' ' + b.PLcorto
				else b.PLnombre
			end 
			+ ' ' +
			case a.PMtipo
				when '1' then 'Matricula Ordinaria'
				when '2' then 'Matricula Extraordinaria'
				when '3' then 'Retiro Justificado'
				else 'Retiro Injustificado'
			end as Nombre
	from PeriodoMatricula a, PeriodoLectivo b, PeriodoEvaluacion c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and PMinicio <= getdate()
	  and convert(varchar,getdate(),112) between convert(varchar,PMinicio,112) and convert(varchar,PMfinal,112)
	  and a.PLcodigo = b.PLcodigo
	  and a.PEcodigo *= c.PEcodigo
</cfquery>
<cfif NOT autorizacion>
	<cfthrow message="No tiene autorizacion para matricular en este momento">
<cfelseif rsPeriodoMatricula.recordCount EQ 0>
	<div align="center">
		<strong>No existen Períodos de Matricula en este momento</strong>
	</div>
	<cfexit>
</cfif>

<!--- 
Estudiante
 --->
<cfset LvarEstudiante = "">
<cfif form.Apersona NEQ "" or form.Pid NEQ "">
	<cfquery name="rsEstudiante" datasource="#Session.DSN#">
		select 	Pid + ' ' + (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as PnombreCompleto
				, Apersona
		from Alumno
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		<cfif form.Apersona neq "">
		  and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
		<cfelse>
		  and Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">
		</cfif>
	</cfquery>
	<cfif rsEstudiante.recordCount EQ 0>
		<cfset session.matricula.Apersona = "">
		<cfset form.Apersona = "">
		<cfset LvarEstudiante = form.Pid & " no existe.">
	<cfelse>
		<cfset session.matricula.Apersona = rsEstudiante.Apersona>
		<cfset form.Apersona = rsEstudiante.Apersona>
		<cfset LvarEstudiante = rsEstudiante.PnombreCompleto>
	</cfif>
</cfif>
<!--- 
Cursos Matriculados del Estudiante
 --->
 <cfif form.Apersona NEQ "">
	<cfquery name="rsPeriodos" dbtype="query">
		select PLcodigo, PEcodigo
		  from rsPeriodoMatricula
		 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PMcodigo#">
	</cfquery>
	
	<cfif isdefined('rsPeriodos') and rsPeriodos.recordCount GT 0>
		<cfquery name="rsMatriculados" datasource="#Session.DSN#">
			select 	a.PMCcodigo,
					a.PMCtipo,
					c.Ccodigo,
					c.Mcodigo,
					m.Mcodificacion,
					m.Mnombre,
					m.Mcreditos,
					m.Mrequisitos,
					c.Csecuencia,
					s.Scodificacion,
					case 
						when c.DOpersona is null then '(Profesor no asignado)'
						else d.Pnombre + ' ' + d.Papellido1 + ' ' + d.Papellido2 
					end as Profesor
			  from 	MatriculaAlumnoCurso a,
					Curso c,
					Materia m,
					Sede s,
					Docente d
			 where exists (select * from PeriodoMatricula b
							where b.PMcodigo = a.PMcodigo
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodos.PLcodigo#">
							<cfif rsPeriodos.PEcodigo NEQ "">
							  and b.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodos.PEcodigo#">
							</cfif>
							  and convert(varchar,getdate(),112) between convert(varchar,PMinicio,112) and convert(varchar,PMfinal,112)							
							)
			   and a.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
			   and a.Ccodigo = c.Ccodigo
			   and c.Mcodigo = m.Mcodigo
			   and c.Scodigo = s.Scodigo
			   and c.DOpersona *= d.DOpersona
			   and a.PMCmodificado = 0
		</cfquery>
	</cfif>
	<cfif isdefined('rsMatriculados') and rsMatriculados.recordCount EQ 0>
		<cfset form.PMCcodigo_cambiar="">
	</cfif>
<cfelse>
	<cfset form.PMCcodigo_cambiar="">
</cfif>
<!--- 
Materia
 --->
<cfset LvarMateria = "">
<cfif form.Mcodigo NEQ "" or form.Mcodificacion NEQ "">
	<cfquery name="rsMateria" datasource="#Session.DSN#">
		select 	Mcodificacion + ' ' + Mnombre as Mnombre
				, Mcodificacion
				, Mcodigo
				, Mcreditos
				, 	case
						when isnull(Mrequisitos,'') = '' then '--'
						else Mrequisitos
					end as Mrequisitos
		from Materia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		<cfif form.Mcodigo neq "">
		  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		<cfelse>
		  and upper(Mcodificacion) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mcodificacion#">
		</cfif>
	</cfquery>
	<cfif rsMateria.recordCount EQ 0>
		<cfset form.Mcodigo = "">
		<cfset LvarMateria = form.Mcodificacion & " no existe.">
	<cfelse>
		<cfset form.Mcodigo = rsMateria.Mcodigo>
		<cfset LvarMateria = rsMateria.Mnombre>
	</cfif>

	<cfif form.Mcodigo EQ "">
		<cfset GvarMcodigo_Matriculada = false>
	<cfelse>
		<cfquery name="rsRequisitos" datasource="#Session.DSN#">
			select m.Mcodificacion,
				   r.Rresultado
			  from vRequisitosAlumnos r, Materia m
			 where r.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
			   and r.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			   and m.Mcodigo = r.McodigoRequisito
 		</cfquery>

		<cfquery name="rsRequisitosFaltantes" dbtype="query">
			select *
			  from rsRequisitos
			 where Rresultado = 'N'
		</cfquery>
		<cfquery name="rsRequisitosPendientes" dbtype="query">
			select *
			  from rsRequisitos
			 where Rresultado = 'P'
		</cfquery>
		<cfif isdefined("rsMatriculados")>
			<cfquery  name="rsMat" dbtype="query">
				select 1 from rsMatriculados
				where Mcodigo = #form.Mcodigo#
				  and PMCtipo = 'M'
			</cfquery>
			<cfif rsMat.recordCount EQ 0>
				<cfset GvarMcodigo_Matriculada = false>
			<cfelse>
				<cfset GvarMcodigo_Matriculada = true>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<!--- 
Cursos Disponibles de la Materia
 --->
<cfif form.Mcodigo NEQ "">
	<cfquery name="rsDisponibles" datasource="#Session.DSN#">
		select 	convert(varchar,c.Ccodigo) as Ccodigo,
				c.Csecuencia,
				s.Scodificacion,
				case
					when c.DOpersona is null then '(Profesor no asignado)'
					else d.Pnombre + ' ' + d.Papellido1 + ' ' + d.Papellido2 
				end as Profesor,
				c.Cestado,
				case
					when c.Cestado = 0 then 'Curso Inactivo'
					when c.Cestado = 1 then 'Curso Activo'
					when c.Cestado = 2 then 'Curso Cerrado'
					else 'Estado desconocido'
				end as Estado,
				c.CsolicitudMaxima as Cupo,
				c.CsolicitudMaxima - c.Csolicitados as Disponible
		  from Curso c, Sede s, Docente d
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
 		  and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		  <cfif TipoPersona EQ 'A'>
		  	and Cestado <> 0
		  </cfif>
		  and c.Scodigo = s.Scodigo
		  and c.DOpersona *= d.DOpersona
		  and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodos.PLcodigo#">
		<cfif rsPeriodos.PEcodigo NEQ "">
		  and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodos.PEcodigo#">
		</cfif>
	</cfquery>
</cfif>
<style type="text/css">
<!--
.clsLinea75 {
	font-size: 7.5pt;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
.clsLinea {
	font-size: 12px;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
.clsFrame {
	position: absolute;
	visibility: visible;
	left: 500px;
	top: 0px;
	width:500;
	height:290;
	margin: 0px;
	padding: 0px;
}
-->
</style>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript">
	var GvarColorAnterior;
	function sbMouseOver(e,obj)
	{
		if (obj != GvarCambiar_TR)
		{
			GvarColorAnterior=obj.style.backgroundColor;
			obj.style.backgroundColor="#91D2FF";
		}
	}

	function sbMouseOut(e,obj)
	{
		if (obj != GvarCambiar_TR)
			obj.style.backgroundColor=GvarColorAnterior;
	}

	var GvarHorario;
	function sbHorario(pAbrir)
	{
		var LvarIframe = document.getElementById("ifrHorario");
		if (pAbrir)
		{
			LvarIframe.style.display = "";
			LvarIframe.style.left = screen.width - 510;
		}
		else
			LvarIframe.style.display = "none";
	}

	function fnCambioEstudiante(){
	 	<cfif autorizacion EQ true>
			if(document.formMatricula.PMcodigo.value != ''){
				document.formMatricula.Apersona.value = "";
				if (document.formMatricula.Mcodigo)
				{
					document.formMatricula.Mcodigo.value = "";
					document.formMatricula.Mcodificacion.value = "";
				}

				if (document.formMatricula.Pid.value == "")
					window.open('alumno_conlis.cfm?TPer=<cfoutput>#TipoPersona#</cfoutput>','Alumno','left=100,top=100,width=800,height=550,scrollbars=yes,toolbar=no,menubar=no,resizable=yes');
				else
					document.formMatricula.submit();		
			}else{
				alert('Error, el Período de Matrícula es requerido');
				document.formMatricula.PMcodigo.focus();
			}
	  	<cfelse>
			alert('Disculpe, pero usted no esta autorizado a realizar esta acción');		
			document.location.href='/cfmx/home/menu/index.cfm';
		</cfif>
	}

	function fnCambioPerMatricula(){
		<cfif TipoPersona EQ 'A'>
			inicioAlumno();
		<cfelse>
			if (document.formMatricula.Mcodigo)
			{
				document.formMatricula.Mcodigo.value = "";
				document.formMatricula.Mcodificacion.value = "";
			}

			if(document.formMatricula.Apersona.value != ''){
				document.formMatricula.submit();
			}else{
				fnCambioEstudiante();
			}
		</cfif>
	}
	
	function fnAlumno_conlis(Apersona){
		document.formMatricula.Apersona.value = Apersona;
		document.formMatricula.submit();
	}

	function fnCambioMateria(){
	
		document.formMatricula.Mcodigo.value = "";
		if (document.formMatricula.Mcodificacion.value == "")
			<cfoutput>
			window.open('materia_conlis.cfm?PM=#form.PMcodigo#&Apersona=' + document.formMatricula.Apersona.value + '&Tper=#TipoPersona#&F1=#form.F1#&F2=#form.F2#&F3=#form.F3#&F4=#form.F4#&F5=#form.F5#','Materia','left=100,top=100,width=800,height=500,scrollbars=yes,toolbar=no,menubar=no,resizable=yes');
			</cfoutput>
		else
			document.formMatricula.submit();
	}
	function fnMateria_conlis(Mcodigo)
	{
		document.formMatricula.Mcodigo.value = Mcodigo;
		document.formMatricula.submit();
	}
	function fnMateria_conlis_filtros(F1,F2,F3,F4,F5)
	{
		document.formMatricula.F1.value = F1;
		document.formMatricula.F2.value = F2;
		document.formMatricula.F3.value = F3;
		document.formMatricula.F4.value = F4;
		document.formMatricula.F5.value = F5;
	}


	function fnMatricular(Ccodigo)
	{
		<cfif isdefined("GvarMcodigo_Matriculada") AND GvarMcodigo_Matriculada>
		if(document.formMatricula.PMCcodigo_retiro.value == "")
		{
			alert ("La Materia ya está Matriculada");
			return false;
		}
		else if (GvarCambiar_Ccodigo == Ccodigo)
		{
			alert ("Está sustituyendo el mismo Curso");
			return false;
		}
		</cfif>

		if (fnChoqueHorario(Ccodigo))
			return false;
			
		document.formMatricula.Mcodigo.value = "";
		document.formMatricula.Mcodificacion.value = "";
		document.formMatricula.Ccodigo.value = Ccodigo;
		document.formMatricula.action = "matricula_SQL.cfm";
		return true;
	}

	var GvarHorarioMatriculado = new Array();
	var GvarHorarioAMatricular = new Array();
	function fnChoqueHorario(Ccodigo)
	{
		var LvarIndx = -1;
		for (var i=0; i<GvarHorarioAMatricular.length; i++)
		{
			if (GvarHorarioAMatricular[i].Ccodigo == Ccodigo)
			{
				LvarIndx = i;
				break;
			}
		}
		if (LvarIndx == -1)
			return false;
		
		for (var i=LvarIndx; i<GvarHorarioAMatricular.length; i++)
		{
			if (GvarHorarioAMatricular[i].Ccodigo != Ccodigo)
				return false;
			
			for (var j=0; j<GvarHorarioMatriculado.length; j++)
			{
				if (GvarHorarioAMatricular[i].Dia == GvarHorarioMatriculado[j].Dia)
					if (	(GvarHorarioAMatricular[i].Fin > GvarHorarioMatriculado[j].Ini && GvarHorarioAMatricular[i].Fin <= GvarHorarioMatriculado[j].Fin) ||
							(GvarHorarioMatriculado[j].Fin > GvarHorarioAMatricular[i].Ini && GvarHorarioMatriculado[j].Fin <= GvarHorarioAMatricular[i].Fin)	)
					{
						if (confirm ("El horario del Curso choca con la materia '"+GvarHorarioMatriculado[j].Mcodigo+"' Grupo '"+GvarHorarioMatriculado[j].Gcodigo+"'. \n¿Desea Matricular el Curso?"))
							return false;
						else
							return true;
					}
			}
		}

		return false;
	}
	
	function fnRetirar(PMCcodigo)
	{
		document.formMatricula.Mcodigo.value = "";
		document.formMatricula.Mcodificacion.value = "";
		document.formMatricula.Ccodigo.value = "";
		document.formMatricula.PMCcodigo_retiro.value = PMCcodigo;
		document.formMatricula.action = "matricula_SQL.cfm";
	}

	var GvarCambiar_TR="";
	var GvarCambiar_color="";
	var GvarCambiar_Ccodigo="";
	function fnCambiar(btn, PMCcodigo, Ccodigo, Brincar)
	{
		if (document.formMatricula.PMCcodigo_retiro.value != "")
		{
			GvarCambiar_TR.style.backgroundColor = GvarCambiar_color;
			GvarColorAnterior=GvarCambiar_color;
		}
		if (document.formMatricula.PMCcodigo_retiro.value == PMCcodigo)
		{
			document.formMatricula.PMCcodigo_retiro.value = "";
			document.formMatricula.PMCcodigo_cambiar.value = "";
			GvarCambiar_Ccodigo="";
		}
		else
		{
			document.formMatricula.PMCcodigo_retiro.value = PMCcodigo;
			document.formMatricula.PMCcodigo_cambiar.value = PMCcodigo;
			GvarCambiar_Ccodigo=Ccodigo;
			GvarCambiar_TR = btn.parentNode.parentNode;
			GvarCambiar_color = GvarColorAnterior;
			GvarCambiar_TR.style.backgroundColor = "#FF0000";
			if (!Brincar)
				alert("Matricule de los Cursos Disponible el que sustituirá al Actual, o presione nuevamente el ícono de Cambio de Curso para cancelar el cambio");
		}
	}
	function inicioAlumno(){
		<cfif autorizacion EQ true and isdefined('rsUsuario') and rsUsuario.recordCount GT 0>
			fnAlumno_conlis("<cfoutput>#rsUsuario.Apersona#</cfoutput>");
		<cfelse>
			alert('Disculpe, pero usted no esta autorizado a realizar esta acción');		
			document.location.href='/cfmx/home/menu/index.cfm';
		</cfif>	
	}
	function inicioProfGuia(){
		<cfif autorizacion NEQ true>
			alert('Disculpe, pero usted no esta autorizado a realizar esta acción');		
			document.location.href='/cfmx/home/menu/index.cfm';
		</cfif>		
	}
</script>
<cfoutput>

<form name="formMatricula" method="post" action="" style="margin: 0;">
	<input type="hidden" name="TPer" value="#form.TPer#">
	<table width="875" border="0" cellspacing="0" cellpadding="1">
		<tr>
		  <td colspan="2">&nbsp;</td>
		</tr>
		<tr> 
		  <td width="175" align="right" nowrap class="fileLabel">
		  	<font size="2">Período de Matrícula:</font>
		  </td>
		  <td width="700" nowrap> 
			<select name="PMcodigo" onChange="javascript: fnCambioPerMatricula()">
			  <cfloop query="rsPeriodoMatricula">
				<option value="#rsPeriodoMatricula.PMcodigo#" <cfif isdefined("Form.PMcodigo") and Form.PMcodigo EQ rsPeriodoMatricula.PMcodigo>selected</cfif>>#rsPeriodoMatricula.Nombre#</option>
			  </cfloop>
			</select>
			<input type="hidden" name="Apersona" value="#form.Apersona#">		
			</td>
		</tr>
		<cfif TipoPersona NEQ 'A'>
			<tr> 
			  <td align="right" valign="top" nowrap>
			  	<font size="1">	Digite la Identificación del&nbsp;&nbsp;&nbsp;<br>
	 							Estudiante a Matricular:&nbsp;&nbsp;</font>
			  </td>
			  <td nowrap valign="bottom"> 
				<input type="text" name="Pid" value="" onKeyPress="if (Key(event) == 13) {this.form.btnEstudiante.click(); return false;}">
				<input type="button" name="btnEstudiante" value="Buscar Estudiante"
						 onClick="javascript:fnCambioEstudiante();">
			  </td>
			</tr>	
		</cfif>
		<tr> 
	        <td align="right" class="fileLabel" nowrap><font size="2">Estudiante:</font></td>
	        <td align="left" class="fileLabel" nowrap><font size="2">#LvarEstudiante#</font></td>
		</tr>
	</table>
<br>	
	<cfif form.Apersona EQ "">
	  </form>
		<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
			<script language="JavaScript" type="text/javascript">
				inicioAlumno();
			</script>
		<cfelseif TipoPersona EQ 'G' or TipoPersona EQ 'TA'>	<!--- Profesor Guia o Administrativo--->
			<script language="JavaScript" type="text/javascript">
				inicioProfGuia();
			</script>
		</cfif>
		<cfexit>
	</cfif>

	<table width="865" border="0" cellpadding="0" cellspacing="0" style="border:1px solid ##999999;border-top:1px solid ##999999;border-bottom:1px solid ##999999" >
    	<tr style="height:1px;"> 
			<td width=35></td>
			<td width=60></td>
			<td width=200></td>
			<td width=50></td>
			<td width=125></td>
			<td width=20></td>
			<td width=60></td>
			<td width=85></td>
			<td width=60></td>
			<td width=170></td>
    	</tr>
    	<tr> 
			<td colspan="10">
				<font size="3"><strong>CURSOS MATRICULADOS</strong></font>
				<input type="hidden" name="Ccodigo" value="">
				<input type="hidden" name="PMCcodigo_retiro" value="">
				<input type="hidden" name="PMCcodigo_cambiar" value="#form.PMCcodigo_cambiar#">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<img src="/cfmx/educ/imagenes/iconos/leave_del.gif">=Retirar Curso&nbsp;&nbsp;
				<img src="/cfmx/educ/imagenes/iconos/leave_rcy.gif">=Cambio de Curso&nbsp;&nbsp;
				<font color="##FF0000"><strong>RET</strong></font>=Curso Retirado o Cambiado
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="VerHorario" id="VerHorario" value="1" <cfif form.VerHorario EQ 1>checked</cfif> ONCLICK="javascript:sbHorario(this.checked);">
				Ver Horario
			</td>
		</tr>
		<tr class="tituloListas"> 
			<td rowspan="2">&nbsp;</td>
			<td rowspan="2">Codigo</td>
			<td rowspan="2">Materia</td>
			<td rowspan="2">#session.parametros.Creditos#</td>
			<td rowspan="2">Requisitos</td>
			<td colspan="5" align="center" style="border-bottom:1px solid ##CCCCCC;">CURSOS</td>
		</tr>
		<tr class="tituloListas"> 
			<td>GR.</td>
			<td>Sede</td>
			<td>Horario</td>
			<td>Aula</td>
			<td align="center">Profesor</td>
		</tr>

	<cfset GvarHor1 = 0>
	<cfset GvarHorario1 = arraynew (1)>
	<cfif isdefined('rsMatriculados') and rsMatriculados.recordCount GT 0>
		<cfloop query="rsMatriculados">
		<tr <cfif rsMatriculados.currentRow MOD 2 EQ 1>bgcolor="##DEDEDE"</cfif><cfif form.PMCcodigo_cambiar EQ rsMatriculados.PMCcodigo>id="TR_cambiar"</cfif>
		<cfif rsMatriculados.PMCtipo eq "M">
	  		onMouseOver="javascript:sbMouseOver(event,this);" 
			onMouseOut="javascript:sbMouseOut(event,this);"</cfif>>
			<td nowrap align="center">
				<cfif rsMatriculados.PMCtipo eq "M">
				<input name="btnRetirar" type="image" src="/cfmx/educ/imagenes/iconos/leave_del.gif" title="Retirar Curso" onClick="javascript:if (confirm('¿Desea Retirar el Curso #rsMatriculados.Mcodificacion#?')) fnRetirar(#rsMatriculados.PMCcodigo#); else return false;"><input 
						name="btnCambio" type="image" src="/cfmx/educ/imagenes/iconos/leave_rcy.gif" title="Cambio de Curso" 
						onClick="javascript:fnCambiar(this, #rsMatriculados.PMCcodigo#, #rsMatriculados.Ccodigo#);return false;" 
						<cfif form.PMCcodigo_cambiar EQ rsMatriculados.PMCcodigo><cfset LvarCcodigo_cambiar = rsMatriculados.Ccodigo>id="IMG_cambiar"</cfif>
					<cfif form.Mcodigo EQ "">
					style="display:none;"
					</cfif>
					>
				<cfelse>
				<font color="##FF0000"><strong>RET</strong></font>
				</cfif>
			</td>
			<td class="clsLinea75" nowrap>#rsMatriculados.Mcodificacion#</td>
			<td class="clsLinea75" nowrap>#rsMatriculados.Mnombre#</td>
			<td class="clsLinea75" align="center">#rsMatriculados.Mcreditos#</td>
			<td class="clsLinea75">#rsMatriculados.Mrequisitos#</td>
			<td align="center" class="clsLinea75">#numberformat(rsMatriculados.Csecuencia,"00")#</td>
			<td class="clsLinea75">#rsMatriculados.Scodificacion#</td>
			<td class="clsLinea75" colspan="2" nowrap>
			<cfquery name="rsHorario" datasource="#Session.DSN#">
				select (case a.HOdia when 1 then 'D' when 2 then 'L' when 3 then 'K' when 4 then 'M' when 5 then 'J' when 6 then 'V' when 7 then 'S' else '' end) as Dia, 
					 a.HOinicio, 
					 a.HOfinal, 
					 case when a.AUcodigo is null then '(No asig)' else b.AUcodificacion end as AUcodificacion
				from Horario a, Aula b
				where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMatriculados.Ccodigo#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.AUcodigo *= b.AUcodigo
				order by a.HOdia, a.HOinicio, a.HOfinal
			</cfquery>
			<cfif rsHorario.recordCount GT 0>
				<table border="0" cellpadding="0" cellspacing="0">
				<cfset LvarPMCtipo = rsMatriculados.PMCtipo>
				<cfset LvarCcodigo = rsMatriculados.Ccodigo>
				<cfset LvarMcodificacion = rsMatriculados.Mcodificacion>
				<cfset LvarCsecuencia = rsMatriculados.Csecuencia>
				<cfloop query="rsHorario">
					<cfif LvarPMCtipo eq "M">
						<cfset GvarHor1 = GvarHor1 + 1>
						<cfset GvarHorario1[GvarHor1] = structNew()>
						<cfset GvarHorario1[GvarHor1].Ccodigo = LvarCcodigo>
						<cfset GvarHorario1[GvarHor1].Mcodificacion = LvarMcodificacion>
						<cfset GvarHorario1[GvarHor1].Csecuencia = LvarCsecuencia>
						<cfset GvarHorario1[GvarHor1].Dia = rsHorario.Dia>
						<cfset GvarHorario1[GvarHor1].HOinicio = rsHorario.HOinicio>
						<cfset GvarHorario1[GvarHor1].HOfinal = rsHorario.HOfinal>
					</cfif>
					<tr> 
					  <td class="clsLinea75" width=85 nowrap>#rsHorario.Dia# #rsHorario.HOinicio#-#rsHorario.HOfinal#</td>
					  <td class="clsLinea75" width=60 nowrap>#rsHorario.AUcodificacion#</td>
					</tr>
				</cfloop>
				</table>
			<cfelse>
				(Horario no asignado)
			</cfif>
			</td>
			<td class="clsLinea75">#rsMatriculados.Profesor#</td>
		</tr>
		</cfloop>
	<cfelse>
		<tr><td colspan="5">No se han matriculado cursos</td></tr>
	</cfif>
    </table>
	<br>

	<iframe id="ifrHorario" class="clsFrame" style="display:none;" src="matricula_horario.cfm?A=#form.Apersona#&PM=#form.PMcodigo#">
	</iframe>
<script language="JavaScript">
	<cfif form.VerHorario EQ 1>
	sbHorario(true);
	</cfif>
<cfif form.PMCcodigo_cambiar NEQ "">
	sbMouseOver(null,document.getElementById("TR_cambiar"));
	fnCambiar(document.getElementById("IMG_cambiar"), #form.PMCcodigo_cambiar#, #LvarCcodigo_cambiar#,true);
</cfif>
</script>

	
  <table width="865" border="0" cellspacing="0" cellpadding="2">
    <tr> 
      <td width="165" align="right">
			<font size="1">Digite el C&oacute;digo de la&nbsp;&nbsp;&nbsp;<br>
							Materia a Matricular:&nbsp;&nbsp;
			</font>		
	  </td>
      <td width="700" nowrap valign="bottom"> 
	  	<input type="hidden" name="Mcodigo" value="#form.Mcodigo#"> 
        <input type="text" name="Mcodificacion" onKeyPress="if (Key(event) == 13) {this.form.btnFiltroMateria.click(); return false;} window.all ? event.which : event.keyCode = (String.fromCharCode(Key(event)).toUpperCase().charCodeAt(0));"> 
        <input type="button" name="btnFiltroMateria" value="Buscar Materia"																	
					 onClick="javascript:fnCambioMateria();"> <input name="F1" type="hidden" value="#form.F1#"> 
        <input name="F2" type="hidden" value="#form.F2#"> 
        <input name="F3" type="hidden" value="#form.F3#"> 
        <input name="F4" type="hidden" value="#form.F4#"> 
        <input name="F5" type="hidden" value="#form.F5#"> 
      </td>
    </tr>
    <tr> 
		<td align="right" class="fileLabel" nowrap>
			<font size="2">Materia:</font>
		</td>
      	<td class="fileLabel" nowrap>
			<font size="2">
			#LvarMateria# 
			<cfif form.Mcodigo NEQ "">
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #session.parametros.Creditos#:&nbsp;&nbsp;&nbsp;#rsMateria.Mcreditos# 
			</cfif>
			</font>
		</td>
    </tr>
<cfif form.Mcodigo EQ "">
  </table>
	</form>
	<cfexit>
</cfif>
		
  <tr> 
		<td class="fileLabel" nowrap align="right">
			<font size="2">Requisitos:</font>
		</td>
		<td class="fileLabel" nowrap>
			<font size="2">
			#rsMateria.Mrequisitos# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<cfif rsRequisitosFaltantes.recordCount GT 0>
			<font color="##FF0000"><strong>(Faltan Requisitos por Aprobar)</strong></font> 
			<cfelseif rsRequisitosPendientes.recordCount GT 0>
			<font color="##D9D900"><strong>(Existen Requisitos Cursando Actualmente)</strong></font> 
			</cfif>
			</font>
		</td>
	</tr>
</table>
	<table border="0" cellpadding="0" cellspacing="0" align="center">
		<tr style="height:1px;"> 
			<td width=20></td>
			<td width=20></td>
			<td width=60></td>
			<td width=100></td>
			<td width=80></td>
			<td width=170></td>
			<td width=40></td>
			<td width=80 colspan="2"></td>
		</tr>
		<tr> 
			<td colspan="9">
				<strong><font size="3">CURSOS DISPONIBLES</font></strong>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<img src="/cfmx/educ/imagenes/iconos/leave_add.gif">=Matricular Curso&nbsp;&nbsp;
				<cfif TipoPersona NEQ 'A'>
					<font color="##FF0000"><strong>IN</strong></font>=Curso Inactivo&nbsp;&nbsp;
				</cfif>
				<font color="##FF0000"><strong>CE</strong></font>=Curso Cerrado&nbsp;&nbsp;
			</td>
		</tr>
		
		<tr class="tituloListas"> 
			<td>&nbsp;</td>
			<td>Grupo </td>
			<td>Sede</td>
			<td>Horario</td>
			<td>Aula</td>
			<td align="center">Profesor</td>
			<td align="right">Cupo</td>
			<td colspan="2">&nbsp;Disponibles</td>
		</tr>
	<cfset GvarHor2 = 0>
	<cfset GvarHorario2 = arraynew (1)>
	<cfloop query="rsDisponibles">
		<tr <cfif rsDisponibles.currentRow MOD 2 EQ 1>bgcolor="##DEDEDE"</cfif>
		<cfif rsDisponibles.Cestado EQ 1>
	  		onMouseOver="javascript:sbMouseOver(event,this);" 
			onMouseOut="javascript:sbMouseOut(event,this);" 
		</cfif>> 
			<td nowrap>
				<cfif rsDisponibles.Cestado EQ 0>
				<font color="##FF0000"><strong>IN</strong></font>
				<cfelseif rsDisponibles.Cestado EQ 1>
				<input name="btnMatricular" type="image" src="/cfmx/educ/imagenes/iconos/leave_add.gif" title="Matricular el Curso"
						onClick="javascript:<cfif rsDisponibles.Disponible GT 0>return fnMatricular(#rsDisponibles.Ccodigo#);<cfelse>alert('El Curso no tiene Cupo Disponible');return false;</cfif>">
				<cfelseif rsDisponibles.Cestado EQ 2>
				<font color="##FF0000"><strong>CE</strong></font>
				<cfelse>
				<font color="##FF0000"><strong>??</strong></font>
				</cfif>
			</td>
			<td align="center" class="clsLinea">#numberformat(rsDisponibles.Csecuencia,"00")#</td>
			<td class="clsLinea">#rsDisponibles.Scodificacion#</td>
			<td class="clsLinea" colspan="2" nowrap>
			<cfquery name="rsHorario" datasource="#Session.DSN#">
				select (case a.HOdia when 1 then 'D' when 2 then 'L' when 3 then 'K' when 4 then 'M' when 5 then 'J' when 6 then 'V' when 7 then 'S' else '' end) as Dia, 
					 a.HOinicio, 
					 a.HOfinal, 
					 case when a.AUcodigo is null then '(No asig)' else b.AUcodificacion end as AUcodificacion
				from Horario a, Aula b
				where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDisponibles.Ccodigo#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.AUcodigo *= b.AUcodigo
				order by a.HOdia, a.HOinicio, a.HOfinal
			</cfquery>
			<cfif rsHorario.recordCount GT 0>
				<table border="0" cellpadding="0" cellspacing="0">
				<cfset LvarCcodigo = rsDisponibles.Ccodigo>
				<cfset LvarCestado = rsDisponibles.Cestado>
				<cfset LvarCsecuencia = rsDisponibles.Csecuencia>
				<cfloop query="rsHorario">
					<cfif LvarCestado EQ 1>
						<cfset GvarHor2 = GvarHor2 + 1>
						<cfset GvarHorario2[GvarHor2] = structNew()>
						<cfset GvarHorario2[GvarHor2].Ccodigo = LvarCcodigo>
						<cfset GvarHorario2[GvarHor2].Mcodificacion = rsMateria.Mcodificacion>
						<cfset GvarHorario2[GvarHor2].Csecuencia = LvarCsecuencia>
						<cfset GvarHorario2[GvarHor2].Dia = rsHorario.Dia>
						<cfset GvarHorario2[GvarHor2].HOinicio = rsHorario.HOinicio>
						<cfset GvarHorario2[GvarHor2].HOfinal = rsHorario.HOfinal>
					</cfif>
					<tr> 
					  <td class="clsLinea" width=100 nowrap>#rsHorario.Dia# #rsHorario.HOinicio#-#rsHorario.HOfinal#</td>
					  <td class="clsLinea" width=80 nowrap>#rsHorario.AUcodificacion#</td>
					</tr>
				</cfloop>
				</table>
			<cfelse>
				(Horario no asignado)
			</cfif>
			</td>
			<td class="clsLinea" nowrap>#rsDisponibles.Profesor#</td>
 			<td class="clsLinea" align="right">#rsDisponibles.Cupo#</td>
 			<cfif rsDisponibles.Cestado NEQ -1>
			<td class="clsLinea" align="right">#rsDisponibles.Disponible#</td>
			<cfelse>
			<td class="clsLinea" align="right">--</td>
			</cfif>
			<td class="clsLinea">&nbsp;</td>
 		  </tr>
		</cfloop>
	</table>
</form>
	<cfif isdefined("GvarHor1") and isdefined("GvarHor2")>
		<script language="JavaScript">
			function objCurso(Ccodigo, Mcodigo, Gcodigo, Dia, Ini, Fin)
			{
				this.Ccodigo = Ccodigo;
				this.Mcodigo = Mcodigo;
				this.Gcodigo = Gcodigo;
				this.Dia = Dia;
				this.Ini = Ini;
				this.Fin = Fin;
			}
		
			var GvarHorarioMatriculado = new Array (
			<cfloop index="i" from="1" to="#GvarHor1#">
				<cfif i GT 1>,<cfelse> </cfif> new objCurso("#GvarHorario1[i].Ccodigo#","#GvarHorario1[i].Mcodificacion#","#GvarHorario1[i].Csecuencia#","#GvarHorario1[i].Dia#",#GvarHorario1[i].HOinicio#,#GvarHorario1[i].HOfinal#)
			</cfloop>
				)
			var GvarHorarioAMatricular = new Array (
			<cfloop index="i" from="1" to="#GvarHor2#">
				<cfif i GT 1>,<cfelse> </cfif> new objCurso("#GvarHorario2[i].Ccodigo#","#rsMateria.Mcodificacion#","#GvarHorario2[i].Csecuencia#","#GvarHorario2[i].Dia#",#GvarHorario2[i].HOinicio#,#GvarHorario2[i].HOfinal#)
			</cfloop>
				)
		</script>
	</cfif>
</cfoutput>
