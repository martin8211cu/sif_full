<cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
	<cfset monitoreo_modulo="EDU EST">
	<cfinclude template="../monitoreo.cfm">
<cfelseif isdefined("Session.RolActual") and Session.RolActual eq 7>
	<cfset monitoreo_modulo="EDU RES">
	<cfinclude template="../monitoreo.cfm">
</cfif>
<cfinclude template="commonDocencia.cfm">
<cfif isdefined("url.E")>
  <cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
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
		
	  <cfquery name="rsEstSel" datasource="#Session.Edu.DSN#">
	  	 select convert(varchar, Ecodigo) as Ecodigo
		 from Estudiante
		 where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  </cfquery>
	  <cfif rsEstSel.recordCount GT 0>
		  <cfset Form.cboAlumno = rsEstSel.Ecodigo>
	  <cfelse>
		  <cfset Form.cboAlumno = "0">
	  </cfif>
  <cfelse>
	  <cfset Form.cboAlumno = url.E>
  </cfif>
  <cfset sbInitFromSession("cboAlumno", "-999",false)>
<cfelse>
  <cfset sbInitFromSession("cboAlumno", "-999",true)>
</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="qryAlumno">
  select distinct convert(varchar,a.Ecodigo) as Codigo,  
  	Pnombre+' '+Papellido1+' '+Papellido2 as Nombre
    from Alumnos a, PersonaEducativo pe
   where a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and pe.persona  = a.persona
     and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
  order by 2
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryPerActual">
  select PEdescripcion
    from PeriodoEvaluacion
   where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsDatosEstud">
	select c.Ndescripcion, d.Gdescripcion, e.SPEdescripcion, f.GRnombre,
	convert(varchar,f.GRcodigo) as GRcodigo, 
	convert(varchar,e.SPEcodigo) as SPEcodigo,
	convert(varchar,e.PEcodigo) as PEcodigo
	from Alumnos a, Promocion b, Nivel c, Grado d, SubPeriodoEscolar e, Grupo f 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
		and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.PRcodigo = b.PRcodigo and b.Ncodigo = c.Ncodigo and b.Ncodigo = d.Ncodigo 
		and b.Gcodigo = d.Gcodigo and b.PEcodigo = e.PEcodigo and b.SPEcodigo = e.SPEcodigo 
		and b.Ncodigo = f.Ncodigo and b.Gcodigo = f.Gcodigo and b.PEcodigo = f.PEcodigo 
		and b.SPEcodigo = f.SPEcodigo 
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="qryPublicacionNotas">
	if not exists ( select 1 from PublicacionNotas 
		where SPEcodigo = <cfqueryparam value="#rsDatosEstud.SPEcodigo#" cfsqltype="cf_sql_numeric">
		  and PEcodigo = <cfqueryparam value="#rsDatosEstud.PEcodigo#" cfsqltype="cf_sql_numeric">
		  and convert(datetime, convert(varchar, getdate(), 103), 103) between PNfechaInicio and PNfechaFin 
	)
	begin
		select 0 as Encontrado
	end	
	else 
		select 1 as Encontrado
 </cfquery>

<cfoutput>
<cfset GvarCurso = "-999">
<cffunction name="sbConsultarCurso">
  <cfargument name="LprmCcodigo" type="string" required="true" default="-1">
    <cfset GvarCurso = LprmCcodigo>
        <cfquery datasource="#Session.Edu.DSN#" name="qryCurso">
          select c.Ccodigo, m.Mnombre as NombreCurso, 
		         p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreProfesor, c.Splaza
            from Curso c, Staff pl, PersonaEducativo p, Materia m
           where c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmCcodigo#">
		     and c.Splaza = pl.Splaza
			 and pl.persona = p.persona
			 and c.Mconsecutivo = m.Mconsecutivo
        </cfquery>
        <cfquery datasource="#Session.Edu.DSN#" name="qryHorario">
			select substring('LKMJVSD',convert(int,HRdia)+1,1) + ': ' + str(Hentrada,5,2) + ' - ' + str(Hsalida,5,2) + ' en ' + r.Rcodigo as Hora
              from HorarioGuia h, Horario hh, Recurso r
             where h.Hcodigo = hh.Hcodigo
	           and h.Hbloque = hh.Hbloque
	           and h.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmCcodigo#">
			   and h.Rconsecutivo = r.Rconsecutivo
			  order by HRdia, Hentrada
        </cfquery>
  
<div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">#qryCurso.NombreCurso#</div>
  <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	<tr>
	  <td>
	    <table border="0" cellpading="0" cellspacing="0" class="TxtNormal">
		  <tr> 
			<td width="80">Profesor:</td>
			<td>#qryCurso.NombreProfesor#</td>
		  </tr>
		  <tr> 
			<td width="80">Alumno:</td>
			<td>#qryAlumno.Nombre#</td>
		  </tr>
		  <tr>
			<td width="80">Per&iacute;odo de Evaluaci&oacute;n: </td>
			<td>#qryPerActual.PEdescripcion#</td>
		  </tr>
		  <cfloop query="qryHorario">
		  <tr>
			<td width="80"><cfif currentRow eq 1>Horario:</cfif></td>
			<td>#hora#</td>
		  </tr>
		  </cfloop> 
		</table>
	  </td>
	  <td align="center">
		<a href="consultarCurso.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=T<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/tema.gif" border="0" title="Temario del Curso"></a>&nbsp;&nbsp;
		<cfif qryPublicacionNotas.Encontrado NEQ 1>
			<a href="consultarCurso.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=E<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/evaluaciones.gif" border="0" title="Plan de Evaluaciones del Curso"></a>&nbsp;&nbsp;
			<a href="javascript:a=window.open('reporteProgreso.cfm?N=3&E=#trim(qryAlumno.Codigo)#&C=#trim(LprmCcodigo)#&P=#trim(url.Periodo)#', 'ReporteProgreso','left=50,top=10,scrollbars=yes,resiable=yes,width=700,height=550,alwaysRaised=yes');a.focus();"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Reporte de Progreso del Curso"></a>&nbsp;&nbsp;
		</cfif>
		<a href="consultarCurso.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=O<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/observaciones.gif" border="0" title="Observaciones y Anotaciones del Curso"></a>&nbsp;&nbsp;
		<a href="consultarCurso.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=A<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/asistencia.gif" border="0" title="Control de Asistencia del Curso"></a>&nbsp;&nbsp;
		<a href="consultarCurso.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=M<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/comunicado.gif" border="0" title="Comunicado al profesor"></a>&nbsp;&nbsp;
	  </td>
	</tr>
  </table>
  <br>
  <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
    <tr>
      <cfif url.Tipo neq "C"><td valign="top"></cfif>
</cffunction>
</cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Consultar Curso</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.TxtNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
}
.BoxNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
    background-color: #E6E6E6;
}
.HdrNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 0px;
    border: 0px solid;
}
.CeldaTxt {
    text-indent: -9;
    margin-left: 12;
    margin-right: -4;
    margin-top: 0;
    margin-bottom: 0;
}
.CeldaHdr {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14;
    font-weight:bold;
    color: #E6E6E6;
    background-color: #666666;
    vertical-align: middle;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
    text-align: center;
}
.CeldaNoCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaFeriado {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: normal;
    background-color: #E6E6E6;
	vertical-align: top;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 1px;
	color: #CC0000;
}
.CeldaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 10px;
    font-weight: normal;
}
.CeldaFechaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 11px;
    font-weight: normal;
}
.LinPar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
.LinImpar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
-->
</style>

</head>

<body style="background-color: #E6E6E6">
<cfoutput>
<cfif isdefined("url.AllC")>
	<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
		select convert(varchar,c.Ccodigo) as Codigo, (case m.Melectiva when 'R' then m.Mnombre else c.Cnombre end) as Descripcion
		  from Curso c, Materia m, Grupo g, PeriodoVigente v, AlumnoCalificacionCurso a
		 where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		   and c.Mconsecutivo = m.Mconsecutivo
		   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
		   and c.GRcodigo *= g.GRcodigo
		   and m.Ncodigo = v.Ncodigo
		   and c.PEcodigo = v.PEcodigo
		   and c.SPEcodigo = v.SPEcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboAlumno#">
		   and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		   and a.Ccodigo = c.Ccodigo
		 order by m.Morden, Descripcion
	</cfquery>
  <p class="areaFiltro">
  Curso:
  <select name="cboCurso" 
	style="font:10px Verdana, Arial, Helvetica, sans-serif;"
	onChange="javascript: location.href= 'consultarCurso.cfm?Tipo=#url.Tipo#&Codigo='+this.value+'&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#&AllC=1';">
	<cfloop query="qryCursos"> 
	  <option value="#Codigo#"<cfif isdefined("url.Codigo") and url.Codigo eq qryCursos.Codigo> selected</cfif>>#Descripcion#</option>
	</cfloop> 
  </select>
  </p>
  <cfif url.Codigo EQ "-1">
  	<cfset url.Codigo = qryCursos.Codigo>
  </cfif>
</cfif>
<cfif isdefined("url.Codigo") and url.Codigo neq "">
  <!--- EVENTO A CONSULTAR --->
  <cfif url.Tipo eq "C">
    <cfset sbConsultarCurso(url.Codigo)>
  <cfelseif url.Tipo eq "T">
        <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
          select convert(varchar,CPcodigo) as Codigo, 
		         CPnombre as Nombre, 
				 CPdescripcion as Descripcion, 
		         CPfecha as Fecha, 
				 str(CPduracion,4,2) as Duracion, 
                 isnull(CPcubierto,'N') as Realizado,
                 CPnombre as ECnombreC,
				 convert(varchar,c.Ccodigo)  as Ccodigo,
				 convert(varchar,c.Mconsecutivo) as Mconsecutivo,
				 t.PEcodigo as PEcodigo
            from CursoPrograma t, Curso c
           where CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
		     and t.Ccodigo = c.Ccodigo
        </cfquery>
  <cfset sbConsultarCurso(qryActividad.Ccodigo)>
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	  <tr> 
	    <td colspan="2">
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">TEMA</div>
	    </td>
	  </tr>
	  <tr> 
	    <td>Fecha</td>
	    <td><cfif qryActividad.Fecha neq "">#lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
	  </tr>
	  <tr> 
	    <td width="80">Tema:</td>
	    <td style="font:bold 12">#qryActividad.Nombre#</td>
	  </tr> 
	  <tr> 
	    <td width="80"></td>
	    <td>
		  #qryActividad.Descripcion#<br><br>
	    </td>
	  </tr>
	  <tr> 
	    <td width="80">Status</td>
	    <td><cfif #qryActividad.Realizado# eq 'S'>Realizado<cfelse>Planeado</cfif></td>
	  </tr>
    </table>
  <cfelseif url.Tipo eq "E">
        <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
          select convert(varchar,cec.ECcomponente) as Codigo, 
		         cec.ECnombre as Nombre, 
				 cec.ECenunciado as Descripcion, 
		         cec.ECplaneada as Fecha, 
                 str(cec.ECduracion,4,2) as Duracion, 
				 isnull(cec.ECevaluado,'N') as Realizado,
                 ec.ECnombre as ECnombreC,
				 convert(varchar,cec.Ccodigo) as Ccodigo,
				 str(ecc.ECCporcentaje*cec.ECporcentaje/100.0,6,2)+'% = ' +
				 str(cec.ECporcentaje,6,2)+'% de ' +
				 str(ecc.ECCporcentaje,6,2)+ '%' as Porcentaje,
				 (select str(ACnota,6,2) from AlumnoCalificacion n 
				   where n.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
				     and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					 and n.Ccodigo = ecc.Ccodigo
					 and n.ECcomponente = cec.ECcomponente) as Nota
            from EvaluacionCurso cec, EvaluacionConcepto ec, EvaluacionConceptoCurso ecc
           where cec.ECcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
             and cec.ECcodigo     = ec.ECcodigo
			 and cec.ECcodigo = ecc.ECcodigo
			 and cec.Ccodigo  = ecc.Ccodigo
			 and cec.PEcodigo = ecc.PEcodigo
        </cfquery>
    <cfset sbConsultarCurso(qryActividad.Ccodigo)>
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	  <tr> 
	    <td colspan="2">
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">EVALUACION</div>
	    </td>
	  </tr>
	  <tr> 
	    <td width="80">Fecha</td>
		<td><cfif qryActividad.Fecha neq "">#lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
	  </tr>
	  <tr> 
	    <td width="80">Evaluación:</td>
		<td style="font:bold 12">#qryActividad.Nombre#</td>
	  </tr> 
	  <tr> 
	    <td width="80"></td>
		<td>#qryActividad.Descripcion#<br><br></td>
	  </tr>
	  <tr> 
		<td width="80">Compone</td>
		<td>#qryActividad.ECnombreC#</td>
	  </tr> 
	  <cfif qryPublicacionNotas.Encontrado NEQ 1>
		  <tr> 
			<td width="80">Porcentaje</td>
			<td>#qryActividad.Porcentaje#</td>
		  </tr> 
	  </cfif>
	  <tr> 
		<td>Status</td>
		<td><cfif #qryActividad.Realizado# eq 'S'>Realizado<cfelse>Planeado</cfif></td>
	  </tr>
	  <cfif qryPublicacionNotas.Encontrado NEQ 1 and qryActividad.Nota neq "">
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td>Nota</td>
		<td>#qryActividad.Nota#</td>
	  </tr>
	  </cfif>
	</table>
    <cfelseif url.Tipo eq "A">
        <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
          select case ACAtipo when 'A' then 'Ausencia' when 'T' then 'Llegada Tardía' else 'Salida Temprano' end
				 + case when ACAjustificado='S' then ' Justificada' else ' Injustificada' end
                   as Nombre,
				 ACAjustificado Justificado,
				 ACAjustificador Justificador,
				 ACAjustificacion as Descripcion, 
		         ACAfecha as Fecha,
				 Ccodigo
            from AlumnoCursoAsistencia 
           where ACAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
		      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
        </cfquery>
    <cfset sbConsultarCurso(qryActividad.Ccodigo)>
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	  <tr> 
	    <td colspan="2">
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">CONTROL DE ASISTENCIA</div>
	    </td>
	  </tr>
	  <tr> 
	    <td width="80">Fecha</td>
		<td><cfif qryActividad.Fecha neq "">#lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
	  </tr>
	  <tr> 
		<td width="80">Control de:</td>
		<td style="font:bold 12">#qryActividad.Nombre#</td>
	  </tr> 
	  <tr> 
		<td width="80"></td>
		<td>#qryActividad.Descripcion#<BR><BR></td>
	  </tr>
		<cfif qryActividad.Justificado eq "S">
		<tr> 
		  <td>Justificado por</td>
		  <td>#qryActividad.Justificador#</td>
		</tr>
		</cfif>
	</table>
  <cfelseif url.Tipo eq "O">
        <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
          select case ACOtipo when 'A' then 'Advertencia' when 'P' then 'Reforzamiento' else 'Llamada Atención' end as Nombre,
				 ACOobservacion as Descripcion, 
		         ACOfecha as Fecha,
				 Ccodigo
            from AlumnoCursoObservacion
           where ACOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
		    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
        </cfquery>
    <cfset sbConsultarCurso(qryActividad.Ccodigo)>
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	  <tr> 
	    <td colspan="2">
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">OBSERVACION</div>
	    </td>
	  </tr>
	  <tr> 
	    <td width="80">Fecha</td>
		<td><cfif qryActividad.Fecha neq "">#lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
	  </tr>
	  <tr> 
		<td width="80">Observacion de:</td>
		<td style="font:bold 12">#qryActividad.Nombre#</td>
	  </tr> 
	  <tr> 
		<td width="80"></td>
		<td>#qryActividad.Descripcion#<br><br></td>
	  </tr>
	</table>
  </cfif>
  <!--- LISTA DE EVENTOS A DESPLEGAR --->
  <cfif isdefined("url.TipoLista")>
	<cfif url.Tipo neq "C">
    </td><td width="20">&nbsp;</td>
	</cfif>
    <td valign="top" width="50%">
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
	  <tr> 
	    <td colspan="3">
    <cfif url.TipoLista eq "T">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
          select convert(varchar,CPcodigo) as Codigo, 
		         CPfecha as Fecha, 
		         CPnombre as Nombre, 
                 isnull(CPcubierto,'N') as Realizado
            from CursoPrograma t
           where t.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
		     and t.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
		order by Fecha
	  </cfquery>
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">TEMARIO DEL CURSO</div>
	    </td>
    <cfelseif url.TipoLista eq "E">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
          select convert(varchar,ECcomponente) as Codigo, 
		         ECplaneada as Fecha, 
		         ECnombre as Nombre,
				 isnull((select str(ACnota,6,2) from AlumnoCalificacion n 
				   where n.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
				     and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					 and n.Ccodigo = t.Ccodigo
					 and n.ECcomponente = t.ECcomponente),
				 isnull(ECevaluado,'N')) as Realizado
            from EvaluacionCurso t
           where t.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
		     and t.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
        UNION
          select null, 
		         null, 
		         ec.ECnombre + ' (' + isnull(convert(varchar, (
				   select count(*) from EvaluacionCurso ecc where ecc.ECcodigo=t.ECcodigo and ecc.Ccodigo=t.Ccodigo and ecc.PEcodigo=t.PEcodigo
					 )), 'no planeado') + ')',
                 str(t.ECCporcentaje,6,2) + '%'
            from EvaluacionConceptoCurso t, EvaluacionConcepto ec
           where t.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
		     and t.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
			 and t.ECcodigo = ec.ECcodigo
		order by Fecha
	  </cfquery>
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">PLAN DE EVALUACION</div>
	    </td>
    <cfelseif url.TipoLista eq "P">
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">REPORTE DE PROGRESO</div>
	    </td>
		</tr><tr><td colspan="3">OPCION NO ESTA DISPONIBLE</td></tr>
		<cfset qryLista=QueryNew("Codigo")>
    <cfelseif url.TipoLista eq "O">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
          select convert(varchar,ACOcodigo) as Codigo, 
		         ACOfecha as Fecha, 
		         case ACOtipo when 'A' then 'Advertencia' when 'P' then 'Reforzamiento' else 'Llamada Atención' end as Nombre,
                 'N' as Realizado
            from AlumnoCursoObservacion
           where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
		     and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
		order by Fecha
	  </cfquery>
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">OBSERVACIONES Y ANOTACIONES</div>
	    </td>
    <cfelseif url.TipoLista eq "A">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
          select convert(varchar,ACAcodigo) as Codigo, 
		         ACAfecha as Fecha, 
		         case ACAtipo when 'A' then 'Ausencia' when 'T' then 'Llegada Tardía' else 'Salida Temprano' end
				 + case when ACAjustificado='S' then ' Justificada' else ' Injustificada' end
                   as Nombre,
                 'N' as Realizado
            from AlumnoCursoAsistencia 
           where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
		     and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
		order by Fecha
	  </cfquery>
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">CONTROL DE ASISTENCIA</div>
	    </td>
    <cfelseif url.TipoLista eq "M">
		<cfinclude template="comunicadoAlProfesor.cfm"> 
		<cfset qryLista=QueryNew("Codigo")>
	</cfif>
		</tr>
		<cfset LvarLinPar="Impar">
		<cfloop query="qryLista">
		  <cfif LvarLinPar neq "Par"><cfset LvarLinPar="Par"><cfelse><cfset LvarLinPar="Impar"></cfif>
		<tr class="Lin#LvarLinPar#">
		<cfif #Codigo# neq "">
		  <td width="75"><a href="consultarCurso.cfm?Tipo=#url.TipoLista#&Codigo=#Codigo#&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#" class="Lin#LvarLinPar#">#lsDateFormat(Fecha,"DD/MM/YYYY")#</a></td>
		  <td width="100%"><a href="consultarCurso.cfm?Tipo=#url.TipoLista#&Codigo=#Codigo#&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#" class="Lin#LvarLinPar#">#Nombre#</a></td>
		  <td align="center"><cfif Realizado eq "S"><img src="/cfmx/edu/responsable/realizado.gif"><cfelseif Realizado neq "N">#Realizado#</cfif></td>
		<cfelse>
		  <td width="75"></td>
		  <td width="100%">#Nombre#</td>
		  <td>#Realizado#</td>
		</cfif>
		</tr>
		</cfloop>
	</table>  
  </cfif>
	</td></tr>
  </table>
</cfif>
</cfoutput>
</body>
</html>
