<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
  <form name="frmActividades" method="POST" action="" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
    <br>
      
    <table width="100%" border="0" cellpading="0" cellspacing="0" style="background-color: #E6E6E6;">
    <tr>
		<td valign="top">
      <cfoutput>
      </cfoutput>
    </td>
    
    <td width="20" valign="top" class="HdrNormal" style="background-color: #E6E6E6;">
      <div style="border-top:1px solid #FFFFFF;">
      <div class="CeldaHdr" style="border-right:0px;border-top:1px solid #E6E6E6;">&nbsp;</div></div><br>
    </td>
    
    <td valign="top" class="HdrNormal" style="background-color: #E6E6E6;">
	<cfoutput>
    <div style="border-top:1px solid ##FFFFFF;">
    <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">LISTA DE ACTIVIDADES</div></div><br>
	</cfoutput>
    <div style="width:250px;">&nbsp;</div>
    <cfif form.hdnFecha neq "">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
        <cfset LvarFecha=lsParseDatetime(form.hdnFecha)>

	    <cfif form.hdnFechaFinal neq "">
          <cfset LvarFechaFin=lsParseDatetime(form.hdnFechaFinal)>
		<cfelse>
		  <cfset LvarFechaFin = LvarFecha>
		</cfif>
	    <cfquery datasource="#Session.DTSeducativo#" name="qryActividades">
		  <cfset LvarFechaI = LvarFecha>
		  <cfloop condition="lsDateFormat(LvarFechaI,'YYYYMMDD') lte lsDateFormat(LvarFechaFin,'YYYYMMDD')">
			select convert(datetime,'#lsDateFormat(LvarFechaI,"YYYYMMDD")#') as Fecha,
			       c.Ccodigo     as Curso,
				   m.Mnombre     as CursoNombre,
				   'HORARIO'     as Tipo, 
				   'H'           as TipoOperacion, 
				   0             as Codigo,
				   'de ' + str(Hentrada,5,2) + ' a ' + str(Hsalida,5,2) as Nombre,
				   ''            as Realizado,
				   1             as Orden
              from HorarioGuia h, Horario hh, Curso c, Materia m
             where h.Hcodigo = hh.Hcodigo
	           and h.Hbloque = hh.Hbloque
	           and #fnCursoEscogido("h.Ccodigo")#
	           and h.Ccodigo = c.Ccodigo
			   and m.Mconsecutivo = c.Mconsecutivo
               <cfset LvarDW = datepart("w", LvarFechaI)-2>
               <cfif LvarDW eq -1><cfset LvarDW = 8></cfif>
               and convert(int,h.HRdia) = #LvarDW#
		    <cfset LvarFechaI = dateadd("D",1,LvarFechaI)>
		  UNION
		  </cfloop>
		  <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "E">
			select ECplaneada,
			       c.Ccodigo,
				   m.Mnombre,
				   'EVALUACION', 
				   'E', 
				   ECcomponente,
				   ECnombre,
				   isnull((select str(n.ACnota,6,2) from AlumnoCalificacion n 
				     where n.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
				       and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					   and n.Ccodigo = ec.Ccodigo
					   and n.ECcomponente = ec.ECcomponente),
				     isnull(ECevaluado,'N')),
				   2
			  from EvaluacionCurso ec, Curso c, Materia m
			 where ec.Ccodigo = c.Ccodigo
			   and m.Mconsecutivo = c.Mconsecutivo
			   and #fnCursoEscogido("ec.Ccodigo")#
			   and ec.PEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			   and ECplaneada <cfif LvarFechaFin eq "">= '#lsDateFormat(LvarFecha,"YYYYMMDD")#'
			   <cfelse>between '#lsDateFormat(LvarFecha,"YYYYMMDD")#' and '#lsDateFormat(LvarFechaFin,"YYYYMMDD")#'
			   </cfif>
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "">
		  UNION
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "T">
			select CPfecha,
			       c.Ccodigo,
				   m.Mnombre,
				   'TEMA', 
				   'T', 
				   CPcodigo,
				   CPnombre,
				   CPcubierto,
				   3
			  from CursoPrograma cp, Curso c, Materia m
			 where cp.Ccodigo = c.Ccodigo
			   and m.Mconsecutivo = c.Mconsecutivo
			   and #fnCursoEscogido("cp.Ccodigo")#
			   and cp.PEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			   and CPfecha <cfif LvarFechaFin eq "">= '#lsDateFormat(LvarFecha,"YYYYMMDD")#'
			   <cfelse>between '#lsDateFormat(LvarFecha,"YYYYMMDD")#' and '#lsDateFormat(LvarFechaFin,"YYYYMMDD")#'</cfif>
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "">
		  UNION
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "O">
			select ACOfecha,
			       c.Ccodigo,
				   m.Mnombre,
				   'OBSERVACION', 
				   'O', 
				   ACOcodigo,
				   case ACOtipo when 'A' then 'Advertencia' when 'P' then 'Reforzamiento' else 'Llamada Atención' end,
				   'N',
				   4
			  from AlumnoCursoObservacion ao, Curso c, Materia m
			 where ao.Ccodigo = c.Ccodigo
			   and m.Mconsecutivo = c.Mconsecutivo
			   and #fnCursoEscogido("ao.Ccodigo")#
			   and ao.PEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			   and ACOfecha <cfif LvarFechaFin eq "">= '#lsDateFormat(LvarFecha,"YYYYMMDD")#'
			   <cfelse>between '#lsDateFormat(LvarFecha,"YYYYMMDD")#' and '#lsDateFormat(LvarFechaFin,"YYYYMMDD")#'</cfif>
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "">
		  UNION
		  </cfif>
		  <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "A">
			select ACAfecha,
			       c.Ccodigo,
				   m.Mnombre,
				   'ASISTENCIA', 
				   'A', 
				   ACAcodigo,
				   case ACAtipo when 'A' then 'Ausencia' when 'T' then 'Llegada Tardía' else 'Salida Temprano' end
				   + case when ACAjustificado='S' then ' Justificada' else ' Injustificada' end,
				   'N',
				   5
			  from AlumnoCursoAsistencia aa, Curso c, Materia m
			 where aa.Ccodigo = c.Ccodigo
			   and m.Mconsecutivo = c.Mconsecutivo
			   and #fnCursoEscogido("aa.Ccodigo")#
			   and aa.PEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			   and ACAfecha <cfif LvarFechaFin eq "">= '#lsDateFormat(LvarFecha,"YYYYMMDD")#'
			   <cfelse>between '#lsDateFormat(LvarFecha,"YYYYMMDD")#' and '#lsDateFormat(LvarFechaFin,"YYYYMMDD")#'</cfif>
		  </cfif>
		  order by Fecha, Curso, Orden
		</cfquery>
		<cfset LvarFecha = "">
		<cfset LvarCurso = "">
		<cfset LvarLinPar = "Impar">
		<cfoutput query="qryActividades">
		  <cfif LvarFecha neq Fecha>
		    <cfset LvarFecha = Fecha>
		    <cfset LvarCurso = "">
		    <cfif currentRow gt 1>
		  <tr><td>&nbsp;</td></tr>
		    </cfif>
		    <cfset LvarFeriado = fnEsFeriado(Fecha)>
		  <tr>
			<td colspan="3" class=<cfif LvarFeriado>"CeldaFeriado" style="border=0px"<cfelse>"LinPar"</cfif> style="font-size:16"><b>#lsDateFormat(Fecha,"Long")#</b></td>
		  </tr>
		    <cfif Fecha eq qryLimitePeriodo.Inicial>
		  <tr>
			<td colspan="3" class="CeldaFeriado" style="border=0px">INICIO DEL PERIODO EVALUACION</td>
		  </tr>
			</cfif>
		    <cfif Fecha eq qryLimitePeriodo.Final>
		  <tr>
			<td colspan="3" class="CeldaFeriado" style="border=0px">FINAL DEL PERIODO EVALUACION</td>
		  </tr>
			</cfif>
		    <cfif LvarFeriado>
		  <tr>
			<td colspan="3" class="CeldaFeriado" style="border=0px">DIA FERIADO</td>
		  </tr>
			</cfif>
			<cfloop query="qryCalendarioDia">
		  <tr>
		    <td>CALENDARIO ESCOLAR</td>
		    <td>#Descripcion#</td>
		  </tr>
			</cfloop>
		  </cfif>
		  <cfif LvarCurso neq Curso and not (LvarFeriado and TipoOperacion eq "H")>
		    <cfset LvarCurso = Curso>
		    <cfset LvarLinPar = "Impar">
			<cfset LvarHorario = "Horario">
		  <tr>
			<td class="CeldaHdr" colspan="3"><a href="javascript:fnConsultarCurso('C',#Curso#);" class="CeldaHdr" style="border:0px">#CursoNombre#</a></td>
		  </tr>
		  </cfif>
		  <cfif not (LvarFeriado and TipoOperacion eq "H")>
		  <cfif LvarLinPar neq "Par"><cfset LvarLinPar="Par"><cfelse><cfset LvarLinPar="Impar"></cfif>
		  <tr class="Lin#LvarLinPar#">
		    <cfif TipoOperacion eq "H">
			<td style="text-align:center;" width="100">#LvarHorario#</td><cfset LvarHorario="">
			<td>#Nombre#</td>
			<td></td>
			<cfelse>
			<td align="center" width="100"><a href="javascript:fnConsultarCurso('#TipoOperacion#',#Codigo#);" class="Lin#LvarLinPar#">#Tipo#</a></td>
			<td><a href="javascript:fnConsultarCurso('#TipoOperacion#',#Codigo#);" class="Lin#LvarLinPar#">#Nombre#</a></td>
			<td align="center"><cfif Realizado eq "S"><img src="realizado.gif"><cfelseif Realizado neq "N">#Realizado#</cfif></td>
			</cfif>
		  </tr>
		  </cfif>
	    </cfoutput>
		</table>
	</cfif>
            
    </td></tr>
    </table>
	<cfoutput>
	<input type="hidden" name="hdnFecha"         value="#Form.hdnFecha#">
	<input type="hidden" name="hdnFechaFinal"    value="#Form.hdnFechaFinal#">
	<input type="hidden" name="hdnTipoOperacion" value="#Form.hdnTipoOperacion#">
	<input type="hidden" name="hdnTipoActividad" value="#Form.hdnTipoActividad#">
	<input type="hidden" name="hdnCodigo"        value="#Form.hdnCodigo#">
	</cfoutput>
  </form>

</body>
</html>
