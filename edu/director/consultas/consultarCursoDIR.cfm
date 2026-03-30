<cfinclude template="commonDocenciaDIR.cfm">
<cfif isdefined("url.P")>
	<cfset Form.cboProfesor = url.P>
	<cfset sbInitFromSession("cboProfesor", "-999",false)>
<cfelse>
  <cfset sbInitFromSession("cboProfesor", "-999",true)>
</cfif>
<cfif isdefined("url.Nivel")>
	<cfset Form.Ncodigo = url.Nivel>
	<cfset sbInitFromSession("Ncodigo", "url.Nivel",false)>
<cfelse>
  <cfset sbInitFromSession("Ncodigo", "url.Nivel",true)>
</cfif>
<cfif isdefined("url.Codigo")>
	<cfset Form.cboCurso = url.Codigo>
	<cfset sbInitFromSession("cboCurso", "-999",false)>
<cfelse>
  <cfset sbInitFromSession("cboCurso", "-999",true)>
</cfif>
<cfif isdefined("url.Periodo")>
	<cfset Form.cboPeriodo = url.Periodo>
	<cfset sbInitFromSession("cboPeriodo", "Url.Periodo",false)>
<cfelse>
  <cfset sbInitFromSession("cboPeriodo", "Url.Periodo",true)>
</cfif>


<cfquery datasource="#Session.Edu.DSN#" name="qryPerActual">
  select PEdescripcion
    from PeriodoEvaluacion
   where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
</cfquery>

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

<cfquery datasource="#Session.Edu.DSN#" name="qryNivelDirector">
	select convert(varchar,DN.Ncodigo) as Ncodigo
	 from Director D, DirectorNivel DN, Nivel n
	where D.Dcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and D.Dcodigo = DN.Dcodigo
	  and DN.Ncodigo = n.Ncodigo
	  and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>
<cfset NivelesDir = ValueList(qryNivelDirector.Ncodigo,',')>

<cfoutput>
<cfset GvarCurso = "-999">
<cffunction name="sbConsultarCurso">
  <cfargument name="LprmCcodigo" type="string" required="true" default="-1">
    <cfset GvarCurso = LprmCcodigo>
        <cfquery datasource="#Session.Edu.DSN#" name="qryCurso">
          select c.Ccodigo, case m.Melectiva when 'S' then c.Cnombre else m.Mnombre + ' ' + g.GRnombre end as NombreCurso, 
		         p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreProfesor, c.Splaza
            from Curso c, Staff pl, PersonaEducativo p, Materia m, Grupo g
           where c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmCcodigo#">
			  <cfif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
				 and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">      
			  <cfelseif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
				  and m.Ncodigo in (#NivelesDir#)
			  </cfif>   
		     and c.Splaza = pl.Splaza
			 and pl.persona = p.persona
			 and c.Mconsecutivo = m.Mconsecutivo
			 and c.GRcodigo *= g.GRcodigo
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
		<!---   <tr> 
			<td width="80">Alumno:</td>
			<td>#qryAlumno.Nombre#</td>
		  </tr> --->
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
		<a href="consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Nivel=#Form.Ncodigo#&P=#trim(Form.cboProfesor)#&Periodo=#url.Periodo#&TipoLista=T<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/tema.gif" border="0" title="Temario del Curso"></a>&nbsp;&nbsp;
		<a href="consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Nivel=#Form.Ncodigo#&P=#trim(Form.cboProfesor)#&Periodo=#url.Periodo#&TipoLista=E<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/evaluaciones.gif" border="0" title="Plan de Evaluaciones del Curso"></a>&nbsp;&nbsp;
		<a href="javascript:a=window.open('ConlisReporteProgresoDIR.cfm?N=3&C=#trim(LprmCcodigo)#&P=#trim(Form.cboProfesor)#', 'ReporteProgreso','left=50,top=10,scrollbars=yes,resiable=yes,width=700,height=550,alwaysRaised=yes','Reporte de Progreso');a.focus();"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Reporte de Progreso del Curso"></a>&nbsp;&nbsp;
		<a href="formIncidenciasDIR.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&Nivel=#Form.Ncodigo#&P=#Form.cboProfesor#<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/observaciones.gif" border="0" title="Observaciones y Anotaciones del Curso"></a>&nbsp;&nbsp;
<!--- 		<a href="consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=A<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/asistencia.gif" border="0" title="Control de Asistencia del Curso"></a>&nbsp;&nbsp;
		<a href="consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo=#url.Codigo#&Periodo=#url.Periodo#&TipoLista=M<cfif isdefined("url.AllC")>&AllC=1</cfif>"><img src="/cfmx/edu/Imagenes/comunicado.gif" border="0" title="Comunicado al profesor"></a>&nbsp;&nbsp;
 --->	  </td>
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
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
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
    <cfif #form.cboProfesor# neq "0">
      select convert(varchar,Ccodigo) as Codigo, 
	  case m.Melectiva when 'S' then c.Cnombre else m.Mnombre + ' ' + g.GRnombre end as Descripcion 
	  from Curso c, Materia m, Grupo g, PeriodoVigente v, Nivel n, Grado gra 
	  where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
      <cfif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
        and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
        <cfelseif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
        and m.Ncodigo in (#NivelesDir#) 
      </cfif>
      and m.Melectiva not in ('E','C') -- Que no sea un curso ni Electivo ni Complementario 
      and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
      and c.Mconsecutivo = m.Mconsecutivo and c.GRcodigo *= g.GRcodigo and m.Ncodigo 
      = v.Ncodigo and c.PEcodigo = v.PEcodigo and c.SPEcodigo = v.SPEcodigo and 
      m.Ncodigo = n.Ncodigo and m.Gcodigo *= gra.Gcodigo order by n.Norden,isnull(gra.Gorden,9999), 
      m.Morden 
      <cfelse>
      select convert(varchar,Ccodigo) as Codigo, Ndescripcion+': '+Cnombre as 
      Descripcion from Curso c, Materia m, PeriodoVigente v, Nivel n, Grado gra 
      where c.CEcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
      <cfif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
        and m.Ncodigo = 
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
        <cfelseif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
        and m.Ncodigo in (#NivelesDir#) 
      </cfif>
      and m.Melectiva not in ('E','C') -- Que no sea un curso ni Electivo ni Complementario 
      and c.Splaza is null and c.Mconsecutivo = m.Mconsecutivo and m.Ncodigo = 
      v.Ncodigo and c.PEcodigo = v.PEcodigo and c.SPEcodigo = v.SPEcodigo and 
      m.Ncodigo = n.Ncodigo and m.Gcodigo *= gra.Gcodigo order by n.Norden,isnull(gra.Gorden,9999), 
      m.Morden 
    </cfif>
    </cfquery>
	  <cfif not isdefined("qryPeriodos")> 
		  <cfquery datasource="#Session.Edu.DSN#" name="qryPeriodos">
			set nocount on
			select distinct convert(varchar,p.PEcodigo) as Codigo,
			<cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
			  p.PEdescripcion  + ' - (' + n.Ndescripcion + ')' as Descripcion, 
			<cfelseif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>  
			  p.PEdescripcion  as Descripcion, 
			</cfif>
			  convert(varchar,PEevaluacion) as Actual
			  from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v, Nivel n
			 where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  	<cfif form.cboCurso EQ -1>
			   		and  c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCursos.Codigo#">		
				<cfelse>	
					and  c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			   	</cfif>

			   	<cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
					and p.Ncodigo in (#NivelesDir#)
			   	<cfelseif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
					and p.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
			   	</cfif>
			   and c.Mconsecutivo = m.Mconsecutivo
			   and m.Ncodigo      = p.Ncodigo
			   and v.Ncodigo   = m.Ncodigo
			   and v.PEcodigo  = c.PEcodigo
			   and v.SPEcodigo = c.SPEcodigo
			   and m.Ncodigo  = n.Ncodigo
			order by n.Norden, p.PEorden
			set nocount off
		  </cfquery>
		</cfif>
	
		<cfset PeriodoEncontrado = false>
		<cfloop query="qryPeriodos">
		  <cfif #Url.Periodo# eq #qryPeriodos.Codigo#>
				<cfset PeriodoEncontrado = true>
				<cfbreak>
		  </cfif>
		</cfloop>
		<cfif NOT PeriodoEncontrado>
			<cfset url.Periodo = #qryPeriodos.Codigo#>
			<cfset form.cboPeriodo= #qryPeriodos.Codigo#>
		</cfif>
	<cfset sbInitFromSession("cboPeriodo", "Url.Periodo",false)>

    <p class="areaFiltro"> Curso: 
      <select name="cboCurso" 
	style="font:10px Verdana, Arial, Helvetica, sans-serif;"
	onChange="javascript: location.href= 'consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo='+this.value+'&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#&AllC=#url.AllC#&Nivel=#url.Nivel#&P=#url.P#';">
        <cfloop query="qryCursos">
          <option value="#Codigo#"<cfif isdefined("url.Codigo") and url.Codigo eq qryCursos.Codigo> selected</cfif>>#Descripcion#</option>
        </cfloop>
      </select>
      Período : 
      <select name="cboPeriodo" 
            style="font:10px Verdana, Arial, Helvetica, sans-serif;"
             onChange="javascript: location.href= 'consultarCursoDIR.cfm?Tipo=#url.Tipo#&Codigo=#Url.Codigo#&Periodo='+this.value+'&TipoLista=#url.TipoLista#&AllC=#url.AllC#&Nivel=#url.Nivel#&P=#url.P#';">
			 <cfloop query="qryPeriodos"> 
		        <option value="#qryPeriodos.Codigo#"<cfif isdefined("url.Periodo") and url.Periodo eq qryPeriodos.Codigo > selected<cfset LvarSelected="1"></cfif>>#qryPeriodos.Descripcion#</option>
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
      select convert(varchar,CPcodigo) as Codigo, CPnombre as Nombre, CPdescripcion 
      as Descripcion, CPfecha as Fecha, str(CPduracion,4,2) as Duracion, isnull(CPcubierto,'N') 
      as Realizado, CPnombre as ECnombreC, convert(varchar,c.Ccodigo) as Ccodigo, 
      convert(varchar,c.Mconsecutivo) as Mconsecutivo, t.PEcodigo as PEcodigo 
      from CursoPrograma t, Curso c where CPcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
      and t.Ccodigo = c.Ccodigo 
      </cfquery>

      <cfset sbConsultarCurso(qryActividad.Ccodigo)>
      <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
        <tr> 
          <td colspan="2"> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">TEMA</div></td>
        </tr>
        <tr> 
          <td>Fecha</td>
          <td><cfif qryActividad.Fecha neq "">
              #lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
        </tr>
        <tr> 
          <td width="80">Tema:</td>
          <td style="font:bold 12">#qryActividad.Nombre#</td>
        </tr>
        <tr> 
          <td width="80"></td>
          <td> #qryActividad.Descripcion#<br>
            <br> </td>
        </tr>
        <tr> 
          <td width="80">Status</td>
          <td><cfif #qryActividad.Realizado# eq 'S'>
              Realizado
              <cfelse>
              Planeado</cfif></td>
        </tr>
      </table>
      <cfelseif url.Tipo eq "E">
      <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
      select convert(varchar,cec.ECcomponente) as Codigo, cec.ECnombre as Nombre, 
      cec.ECenunciado as Descripcion, cec.ECplaneada as Fecha, str(cec.ECduracion,4,2) 
      as Duracion, isnull(cec.ECevaluado,'N') as Realizado, ec.ECnombre as ECnombreC, 
      convert(varchar,cec.Ccodigo) as Ccodigo, str(ecc.ECCporcentaje*cec.ECporcentaje/100.0,6,2)+'% 
      = ' + str(cec.ECporcentaje,6,2)+'% de ' + str(ecc.ECCporcentaje,6,2)+ '%' 
      as Porcentaje, '' as Nota from EvaluacionCurso cec, EvaluacionConcepto ec, 
      EvaluacionConceptoCurso ecc where cec.ECcomponente = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
      and cec.ECcodigo = ec.ECcodigo and cec.ECcodigo = ecc.ECcodigo and cec.Ccodigo 
      = ecc.Ccodigo and cec.PEcodigo = ecc.PEcodigo 
      </cfquery>
      <cfset sbConsultarCurso(qryActividad.Ccodigo)>
      <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
        <tr> 
          <td colspan="2"> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">EVALUACION</div></td>
        </tr>
        <tr> 
          <td width="80">Fecha</td>
          <td><cfif qryActividad.Fecha neq "">
              #lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
        </tr>
        <tr> 
          <td width="80">Evaluación:</td>
          <td style="font:bold 12">#qryActividad.Nombre#</td>
        </tr>
        <tr> 
          <td width="80"></td>
          <td>#qryActividad.Descripcion#<br>
            <br></td>
        </tr>
        <tr> 
          <td width="80">Compone</td>
          <td>#qryActividad.ECnombreC#</td>
        </tr>
        <tr> 
          <td width="80">Porcentaje</td>
          <td>#qryActividad.Porcentaje#</td>
        </tr>
        <tr> 
          <td>Status</td>
          <td><cfif #qryActividad.Realizado# eq 'S'>
              Realizado
              <cfelse>
              Planeado</cfif></td>
        </tr>
        <cfif #qryActividad.Nota# neq "">
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>#qryActividad.Nota#</td>
          </tr>
        </cfif>
      </table>
      <cfelseif url.Tipo eq "A">
      <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
      select case ACAtipo when 'A' then 'Ausencia' when 'T' then 'Llegada Tardía' 
      else 'Salida Temprano' end + case when ACAjustificado='S' then ' Justificada' 
      else ' Injustificada' end as Nombre, ACAjustificado Justificado, ACAjustificador 
      Justificador, ACAjustificacion as Descripcion, ACAfecha as Fecha, Ccodigo 
      from AlumnoCursoAsistencia where ACAcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
      </cfquery>
      <cfset sbConsultarCurso(qryActividad.Ccodigo)>
      <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
        <tr> 
          <td colspan="2"> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">CONTROL 
              DE ASISTENCIA</div></td>
        </tr>
        <tr> 
          <td width="80">Fecha</td>
          <td><cfif qryActividad.Fecha neq "">
              #lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
        </tr>
        <tr> 
          <td width="80">Control de:</td>
          <td style="font:bold 12">#qryActividad.Nombre#</td>
        </tr>
        <tr> 
          <td width="80"></td>
          <td>#qryActividad.Descripcion#<BR>
            <BR></td>
        </tr>
        <cfif qryActividad.Justificado eq "S">
          <tr> 
            <td>Justificado 
              por</td>
            <td>#qryActividad.Justificador#</td>
          </tr>
        </cfif>
      </table>
      <cfelseif url.Tipo eq "O">
      <cfquery datasource="#Session.Edu.DSN#" name="qryActividad">
      select case ACOtipo when 'A' then 'Advertencia' when 'P' then 'Reforzamiento' 
      else 'Llamada Atención' end as Nombre, ACOobservacion as Descripcion, ACOfecha 
      as Fecha, Ccodigo from AlumnoCursoObservacion where ACOcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Codigo#">
      </cfquery>
      <cfset sbConsultarCurso(qryActividad.Ccodigo)>
      <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
        <tr> 
          <td colspan="2"> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">OBSERVACION</div></td>
        </tr>
        <tr> 
          <td width="80">Fecha</td>
          <td><cfif qryActividad.Fecha neq "">
              #lsDateFormat(qryActividad.Fecha,"DD/MM/YYYY")#</cfif></td>
        </tr>
        <tr> 
          <td width="80">Observacion de:</td>
          <td style="font:bold 12">#qryActividad.Nombre#</td>
        </tr>
        <tr> 
          <td width="80"></td>
          <td>#qryActividad.Descripcion#<br>
            <br></td>
        </tr>
      </table>
    </cfif>
    <!--- LISTA DE EVENTOS A DESPLEGAR ---><cfif isdefined("url.TipoLista")>
    <cfif url.Tipo neq "C"></td> 
      <td width="20">&nbsp;</td>
    </cfif><td valign="top" width="50%">
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
      <tr> 
        <td colspan="3"> <cfif url.TipoLista eq "T"> <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
          select convert(varchar,CPcodigo) as Codigo, CPfecha as Fecha, CPnombre 
          as Nombre, isnull(CPcubierto,'N') as Realizado from CursoPrograma t 
          where t.Ccodigo = 
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
          and t.PEcodigo = 
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
          order by Fecha </cfquery> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">TEMARIO 
            DEL CURSO</div></td>
        <cfelseif url.TipoLista eq "E">
        <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
        select convert(varchar,ECcomponente) as Codigo, ECplaneada as Fecha, ECnombre 
        as Nombre, isnull(ECevaluado,'N') as Realizado from EvaluacionCurso t 
        where t.Ccodigo = 
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
        and t.PEcodigo = 
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
        UNION select null, null, ec.ECnombre + ' (' + isnull(convert(varchar, 
        ( select count(*) from EvaluacionCurso ecc where ecc.ECcodigo=t.ECcodigo 
        and ecc.Ccodigo=t.Ccodigo and ecc.PEcodigo=t.PEcodigo )), 'no planeado') 
        + ')', str(t.ECCporcentaje,6,2) + '%' from EvaluacionConceptoCurso t, 
        EvaluacionConcepto ec where t.Ccodigo = 
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
        and t.PEcodigo = 
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
        and t.ECcodigo = ec.ECcodigo order by Fecha 
        </cfquery>
        <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">PLAN DE EVALUACION</div></td>
      <cfelseif url.TipoLista eq "P">
      <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">REPORTE DE 
        PROGRESO</div></td></tr>
      <tr>
        <td colspan="3">OPCION 
          NO ESTA DISPONIBLE</td>
      </tr>
      <cfset qryLista=QueryNew("Codigo")>
      <cfelseif url.TipoLista eq "O">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
      select convert(varchar,ACOcodigo) as Codigo, ACOfecha as Fecha, case ACOtipo 
      when 'A' then 'Advertencia' when 'P' then 'Reforzamiento' else 'Llamada 
      Atención' end as Nombre, 'N' as Realizado from AlumnoCursoObservacion where 
      Ccodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
      and PEcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
      order by Fecha 
      </cfquery>
      <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">OBSERVACIONES 
        Y ANOTACIONES</div></td>
      <cfelseif url.TipoLista eq "A">
      <cfquery datasource="#Session.Edu.DSN#" name="qryLista">
      select convert(varchar,ACAcodigo) as Codigo, ACAfecha as Fecha, case ACAtipo 
      when 'A' then 'Ausencia' when 'T' then 'Llegada Tardía' else 'Salida Temprano' 
      end + case when ACAjustificado='S' then ' Justificada' else ' Injustificada' 
      end as Nombre, 'N' as Realizado from AlumnoCursoAsistencia where Ccodigo 
      = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarCurso#">
      and PEcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Periodo#">
      order by Fecha 
      </cfquery>
      <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">CONTROL DE 
        ASISTENCIA</div></td>
      <cfelseif url.TipoLista eq "M">
      <!--- <cfinclude template="../../responsable/comunicadoAlProfesor.cfm">  --->
      <cfset qryLista=QueryNew("Codigo")></cfif></tr>
      <cfset LvarLinPar="Impar">
      <cfloop query="qryLista">
        <cfif LvarLinPar neq "Par">
          <cfset LvarLinPar="Par">
          <cfelse>
          <cfset LvarLinPar="Impar">
        </cfif>
        <tr class="Lin#LvarLinPar#"> 
          <cfif #Codigo# neq "">
            <td width="75"><a href="consultarCursoDIR.cfm?Tipo=#url.TipoLista#&Codigo=#Codigo#&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#" class="Lin#LvarLinPar#">#lsDateFormat(Fecha,"DD/MM/YYYY")#</a></td>
            <td width="100%"><a href="consultarCursoDIR.cfm?Tipo=#url.TipoLista#&Codigo=#Codigo#&Periodo=#url.Periodo#&TipoLista=#url.TipoLista#" class="Lin#LvarLinPar#">#Nombre#</a></td>
            <td align="center"><cfif Realizado eq "S">
                <img src="/cfmx/edu/responsable/realizado.gif">
                <cfelseif Realizado neq "N">
                #Realizado#</cfif></td>
            <cfelse>
            <td width="75"></td>
            <td width="100%">#Nombre#</td>
            <td>#Realizado#</td>
          </cfif>
        </tr>
      </cfloop>
    </table>
  </cfif></td></tr>
  </table> </cfif> </cfoutput> 
</body>
</html>
