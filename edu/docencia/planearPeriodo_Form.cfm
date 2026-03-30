<cfinclude template="/edu/docencia/commonDocencia.cfm">

<cfset GvarBuscarFeriados=true>
<cffunction name="fnEsLeccion" returntype="boolean">
           <cfargument name="LprmFecha" required="true" type="date">
           <cfargument name="LprmBuscarFeriados" required="true" type="boolean" default="true">
  <cfset LvarDW = datepart("w", LprmFecha)>
  <cfquery dbtype="query" name="qryActividadEscolar">
	  select Descripcion, Fecha, Feriado
	    from qryCalendarioEscolar 
	   where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' 
	      or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
 	   order by Feriado desc
  </cfquery>
  <cfif Find("*" & LvarDW & "*", GvarHorarios) eq 0>
    <cfreturn false>
  <cfelse>
    <cfif LprmBuscarFeriados>
	  <cfreturn (not fnEsFeriado(LprmFecha))>
    <cfelse>
	  <cfreturn true>
	</cfif>
  </cfif>
</cffunction>
<cffunction name="fnEsFeriado" returntype="boolean">
    <cfargument name="LprmFecha" required="true" type="date">
    <cfquery dbtype="query" name="qryFeriado">
	  select Descripcion, Fecha 
	    from qryActividadEscolar 
	   where Feriado = 1
	</cfquery>
    <cfquery dbtype="query" name="qryNoFeriado">
	  select Descripcion, Fecha 
	    from qryActividadEscolar 
	   where Feriado = 0
	</cfquery>
    <cfreturn (qryFeriado.Fecha neq "")>
</cffunction>

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar"));
</cfscript>
<cfparam name="form.hdnTipoOperacion" default="">
<cfparam name="form.hdnCodigo" default="">
<cfparam name="form.hdnFecha" default="">
<cfparam name="form.chkTodos" default="">


<cfinclude template="/edu/docencia/qrysProfesorCursoPeriodo.cfm">

<cfif not (#form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999")>
	<cfquery datasource="#Session.Edu.DSN#" name="qryPeriodoCerrado">
      set nocount on
	  select isnull(max(ACPEcerrado),'0') as Cerrado 
		from AlumnoCalificacionPerEval ac, Alumnos alu
	   where ac.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		 and ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		 and alu.CEcodigo = ac.CEcodigo
		 and alu.Ecodigo = ac.Ecodigo
		 and alu.Aretirado  = 0
      set nocount off
	</cfquery>
  <cfquery datasource="#Session.Edu.DSN#" name="qryHorarios">
    set nocount on
    select distinct convert(int,HRdia)+2 as HRdia
      from HorarioGuia
     where Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
    set nocount off
  </cfquery>
  <cfset GvarHorarios="*">
  <cfloop query="qryHorarios">
    <cfif HRdia eq 8>
      <cfset GvarHorarios = GvarHorarios & "1*">
    <cfelse>
      <cfset GvarHorarios = GvarHorarios & HRdia & "*">
    </cfif>
  </cfloop>
  <cfquery datasource="#Session.Edu.DSN#" name="qryLimitesPeriodoEventos">
    set nocount on
    select 'E' as Tipo, min(e.ECplaneada) as Inicial, max(e.ECplaneada) as Final
      from EvaluacionCurso e
     where e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'T', min(t.CPfecha), max(t.CPfecha)
      from CursoPrograma t
     where t.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and t.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'P', POfechainicio, POfechafin
      from PeriodoOcurrencia p, Curso c
     where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and p.PEcodigo     = c.PEcodigo 
       and p.SPEcodigo    = c.SPEcodigo 
       and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
    set nocount off
  </cfquery>
</cfif>

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
-->
</style>
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js" type="text/javascript"></script>
<script language="JavaScript" src="/cfmx/edu/docencia/planearPeriodo1_00.js" type="text/javascript"></script>
  
<form name="frmPlan" method="POST" action=""
        style="font:10px Verdana, Arial, Helvetica, sans-serif;">
  <br>
<table>
  <tr>
    <td>
  Profesor: 
  <select name="cboProfesor" 
            style="font:10px Verdana, Arial, Helvetica, sans-serif;"
            onChange='if (this.value != "-999") fnReLoad();'>
    <cfif isdefined("RolActual") and RolActual EQ 11>
      <option value="-999"></option>
    </cfif>
    <cfset LvarSelected="0">
    <cfoutput query="qryProfesores"> 
      <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
    </cfoutput> 
    <cfif #LvarSelected# eq "0">
      <cfset form.cboProfesor="-999">
    </cfif>
  </select>
  Curso: 
  <select name="cboCurso" 
            style="font:10px Verdana, Arial, Helvetica, sans-serif;"
            onChange='if (this.value != "-999") fnReLoad();'>
    <option value="-999"></option>
    <cfset LvarSelected="0">
    <cfoutput query="qryCursos"> 
      <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
    </cfoutput> 
    <cfif #LvarSelected# eq "0">
      <cfset form.cboCurso="-999">
    </cfif>
  </select>

  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
  <cfelse>

	  <cfquery dbtype="query" name="qryLimite">
		select min(Inicial) as Inicial, max(Final) as Final
		  from qryLimitesPeriodoEventos
	  </cfquery>
	  <cfquery dbtype="query" name="qryLimitePeriodo">
		select Inicial, Final
		  from qryLimitesPeriodoEventos
		 where Tipo='P'
	  </cfquery>
	  <cfif GvarBuscarFeriados or (isDefined("form.btnRecalendarizar") and form.cboTipoRecal eq "Correr")>
		<cfquery datasource="#Session.Edu.DSN#" name="qryCalendario">
		  set nocount on
		  select convert(varchar,Ccodigo) as Ccodigo
			from CentroEducativo 
		   where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  set nocount off
		</cfquery>
		<cfquery datasource="#Session.DTSsdc#" name="qryCalendarioEscolar">
		  set nocount on
		  select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, 
				 CDtitulo  as Descripcion,
				 CDferiado as Feriado
			from CalendarioDia 
		   where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCalendario.Ccodigo#">
			 and CDabsoluto=1
			 and CDfecha between '#lsDateFormat(qryLimite.Inicial,"YYYYMMDD")#' and '#lsDateFormat(qryLimite.Final,"YYYYMMDD")#'
		UNION
		  select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimite.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), 
				 CDtitulo,
				 CDferiado 
			from CalendarioDia 
		   where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCalendario.Ccodigo#">
			 and CDabsoluto=0
		  set nocount off
		</cfquery>
	  </cfif>
	
	  <cfinclude template="/edu/docencia/planearPeriodo_Grabar.cfm">
	
	  <cfif form.hdnTipoOperacion eq "R">
	  <cfquery datasource="#Session.Edu.DSN#" name="qryLimitesPeriodoEventos">
		set nocount on
		select 'E' as Tipo, min(e.ECplaneada) as Inicial, max(e.ECplaneada) as Final
		  from EvaluacionCurso e
		 where e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	  UNION
		select 'T', min(t.CPfecha), max(t.CPfecha)
		  from CursoPrograma t
		 where t.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and t.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	  UNION
		select 'P', POfechainicio, POfechafin
		  from PeriodoOcurrencia p, Curso c
		 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and p.PEcodigo     = c.PEcodigo 
		   and p.SPEcodigo    = c.SPEcodigo 
		   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		set nocount off
	  </cfquery>
	
	  <cfquery dbtype="query" name="qryLimite">
		select min(Inicial) as Inicial, max(Final) as Final
		  from qryLimitesPeriodoEventos
	  </cfquery>
	  <cfquery dbtype="query" name="qryLimitePeriodo">
		select Inicial, Final
		  from qryLimitesPeriodoEventos
		 where Tipo='P'
	  </cfquery>
	  </cfif>
	  <cfquery datasource="#Session.Edu.DSN#" name="qryPlanes">
		set nocount on
		select 'E' as tipo, convert(varchar,e.Ccodigo) as curso, 
			   convert(varchar,e.ECcomponente) as codigo, e.ECnombre as nombre, 
			   e.ECplaneada as fecha, ECevaluado as cubierto, ECorden as orden
		  from EvaluacionCurso e
		 where e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	  UNION
		select 'T', convert(varchar,t.Ccodigo) as curso, 
			   convert(varchar,t.CPcodigo) as codigo, t.CPnombre, 
			   t.CPfecha, t.CPcubierto, CPorden
		  from CursoPrograma t
		 where t.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and t.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	  order by fecha, orden
		set nocount off
	  </cfquery>
	
	  <cfset LvarIni=qryLimite.Inicial>
	  <cfset LvarFin=qryLimite.Final>
	
	<script language="JavaScript">
	<!--
		 <cfif isdefined("qryLimite.Final") and qryLimite.Final neq "">
		   <cfoutput>
		   var GvarFechaInicial = '#lsDateFormat(qryLimite.Inicial,"YYYYMMDD")#';
		   var GvarFechaFinal = '#lsDateFormat(dateadd("d",30,qryLimite.Final),"YYYYMMDD")#';
		   </cfoutput>
		 </cfif>
	-->
	</script>
	  <br>
	  <br>
	  Per&iacute;odo: 
	  <select name="cboPeriodo" 
				style="font:10px Verdana, Arial, Helvetica, sans-serif;"
				onChange="fnReLoad();">
		<cfoutput query="qryPeriodos"> 
		  <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
		</cfoutput> 
	  </select>

  </cfif>
  
	</td>
	<td align="center">
	  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
	  <cfelse>
		<cfif RolActual eq 5>
		  <cfoutput>
			<a href="consultas/ListaTemariosEvalXProf.cfm?C=#trim(form.cboCurso)#&P=#trim(form.cboPeriodo)#"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Listado de Temarios y Evaluaciones del Curso"></a>&nbsp;&nbsp;
		  </cfoutput>
		</cfif>
	  </cfif>
	</td>
  </tr>
</table>

  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
    <cfexit>
  </cfif>

  <br>
  <br><table width="100%" border="0" cellpading="0" cellspacing="0" style="background-color: #E6E6E6;"> <tr><td valign="top">
  <cfoutput> 
    <table width="100%" border="0" cellpading="-1" cellspacing="-1" style="border-bottom: 1px solid ##FFFFFF;">
      <tr> 
        <td class="CeldaHdr"><div style="width:20px;font:9px;">Semana&nbsp;</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Domingo</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Lunes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Martes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Miercoles</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Jueves</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Viernes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Sabado</div></td>
      </tr>
      <cfset LvarSem = 1>
      <tr> 
        <td class="CeldaHdr">1</td>
        <!--- Llena las celdas anteriores al inicio --->
        <cfset LvarDW = datepart("w", LvarIni)-1>
        <cfloop from="1" to="#LvarDW#" index="LvarCol">
          <td class="CeldaNoCurso">&nbsp;</td>
        </cfloop>
        <!--- Llena la primera celda anteriores al inicio --->
        <cfset LvarFeriado=False>
        <cfif fnEsLeccion(LvarIni, false)>
          <cfif fnEsFeriado(LvarIni)>
            <cfset LvarCeldaCurso="CeldaNoCurso">
            <cfset LvarFeriado=True>
            <cfelse>
            <cfset LvarCeldaCurso="CeldaCurso">
          </cfif>
          <cfelse>
          <cfset LvarCeldaCurso="CeldaNoCurso">
        </cfif>
        <cfset LvarFecha=LvarIni>
        <td class="#LvarCeldaCurso#"> <a href="javascript:fnCopiarFecha('#lsdateformat(LvarFecha,'DD/MM/YYYY')#');" class="CeldaFechaRef"> 
          <div style="width:100%; cursor:hand;"> <a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef"><b>#lsdateformat(LvarFecha,"D MMM YY")#</b></a> <span style="cursor:default">&nbsp;</span> </div></a> 
          <cfif LvarFecha eq qryLimitePeriodo.Inicial>
            <div class="celdaHdr" style="text-align:left; border:0px; font:11px">
			 INICIO PERIODO</div>
          </cfif> 
		  <cfloop query="qryActividadEscolar">
            <div class=<cfif Feriado eq 1>"CeldaFeriado"<cfelse>"LvarCeldaCurso"</cfif>
			     style="border:0px; text-indent: -5; margin-left: 5;">
				 - #Descripcion#</div>
          </cfloop> 
          <!--- Recorre todos los eventos ---><cfloop query="qryPlanes">
          <!--- Llena las celdas anteriores al siguiente evento ---><cfloop condition="LvarFecha lt Fecha"> 
          <cfif LvarFecha eq qryLimitePeriodo.Final>
            <p class="CeldaTxt" align="right">
			  <span class="CeldaHdr" style="border:0px; font:11px">
			  FINAL PERIODO&nbsp;</span></p>
          </cfif> </td>
        <cfset LvarFecha = dateadd("D",1,LvarFecha)>
        <cfset LvarDW = datepart("w",LvarFecha)><cfif LvarDW eq 1>
        <cfset LvarSem = LvarSem + 1 >
      </tr>
      <tr> 
        <td class="CeldaHdr">#LvarSem#</td></cfif>
        <cfset LvarFeriado=False>
        <cfif fnEsLeccion(LvarFecha, false)>
          <cfif fnEsFeriado(LvarFecha)>
            <cfset LvarCeldaCurso="CeldaNoCurso">
            <cfset LvarFeriado=True>
            <cfelse>
            <cfset LvarCeldaCurso="CeldaCurso">
          </cfif>
          <cfelse>
          <cfset LvarCeldaCurso="CeldaNoCurso">
        </cfif>
        <td class="#LvarCeldaCurso#"> <a href="javascript:fnCopiarFecha('#lsdateformat(LvarFecha,'DD/MM/YYYY')#');" class="CeldaFechaRef"> 
          <div style="width:100%;cursor:hand;"> <a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef"> 
            <cfif datepart("d",LvarFecha) eq 1>
              <B>#lsdateformat(LvarFecha,"D MMM YY")#</B> 
              <cfelse>
              #lsdateformat(LvarFecha,"D")# 
            </cfif></a>
            <span style="cursor:default">&nbsp;</span> </div></a>
          <cfif LvarFecha eq qryLimitePeriodo.Inicial>
            <div class="celdaHdr" style="text-align:left; border:0px; font:11px">
			 INICIO PERIODO</div>
		  </cfif> 
		  <cfloop query="qryActividadEscolar">
            <div class=<cfif Feriado eq 1>"CeldaFeriado"<cfelse>"LvarCeldaCurso"</cfif>
			     style="border:0px; text-indent: -5; margin-left: 5;">
				 - #Descripcion#</div>
          </cfloop> </cfloop> <cfif Fecha eq LvarFecha>
            <p class="CeldaTxt"><img src="/cfmx/edu/docencia/planea<cfif Tipo eq "T"><cfif Cubierto neq "N">TC<cfelse>TA</cfif><cfelse><cfif Cubierto neq "N">EC<cfelse>EA</cfif></cfif>.gif"><a href="javascript:fnTrabajarConEvento('<cfif Tipo eq "T">T<cfelse>E</cfif>','#lsdateformat(LvarFecha,"YYYYMMDD")#','#Codigo#');" class="celdaRef">#Nombre#</a></p>
          </cfif> </cfloop> 
          <!--- Llena las celdas anteriores al final (en caso de que el final del periodo sea posterior al ultimo evento) ---><cfloop condition="LvarFecha lt LvarFin"> 
          <cfif LvarFecha eq qryLimitePeriodo.Final>
            <p class="CeldaTxt" align="right"><span class="CeldaHdr" style="border:0px; font:11px">FINAL 
              PERIODO&nbsp;</span></p>
          </cfif> <cfset LvarFecha = dateadd("d",1,LvarFecha)> <cfset LvarDW = datepart("w",LvarFecha)> <cfif LvarDW eq "1"> 
          <cfset LvarSem = LvarSem + 1 > </td>
      </tr>
      <tr> 
        <td class="CeldaHdr">#LvarSem#</td></cfif>
        <cfset LvarFeriado=False>
        <cfif fnEsLeccion(LvarFecha, false)>
          <cfif fnEsFeriado(LvarFecha)>
            <cfset LvarCeldaCurso="CeldaNoCurso">
            <cfset LvarFeriado=True>
            <cfelse>
            <cfset LvarCeldaCurso="CeldaCurso">
          </cfif>
          <cfelse>
          <cfset LvarCeldaCurso="CeldaNoCurso">
        </cfif>
        <td class="#LvarCeldaCurso#"> <a href="javascript:fnCopiarFecha('#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef"> 
          <div style="width:100%;cursor:hand;"> <a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef"> 
            <cfif lsdateformat(LvarFecha,"DD") eq "1">
              <B>#lsdateformat(LvarFecha,"D MMM YY")#</B> 
              <cfelse>
              #lsdateformat(LvarFecha,"D")# 
            </cfif></a>
            <span style="cursor:default">&nbsp;</span></div></a>
          <cfif LvarFecha eq qryLimitePeriodo.Inicial>
            <div class="celdaHdr" style="text-align:left; border:0px; font:11px">
			  INICIO PERIODO</div>
		  </cfif> 
		  <cfloop query="qryActividadEscolar">
            <div class=<cfif Feriado eq 1>"CeldaFeriado"<cfelse>"LvarCeldaCurso"</cfif>
			     style="border:0px; text-indent: -5; margin-left: 5;">
				 - #Descripcion#</div>
          </cfloop> 
		  </cfloop> 
		  <cfset LvarDW = datepart("w",LvarFin)+1> 
		  <cfif LvarFecha eq qryLimitePeriodo.Final>
            <p class="CeldaTxt" align="right"><span class="CeldaHdr" style="border:0px; font:11px">FINAL 
              PERIODO&nbsp;</span></p>
          </cfif> </td>
        <!--- Llena las celdas posteriores al final --->
        <cfloop from="#LvarDW#" to="7" index="LvarCol">
          <td class="CeldaNoCurso">&nbsp;</td>
        </cfloop></td></tr>
    </table>
  </cfoutput> </td> 
  <td width="20" valign="top" class="HdrNormal" style="background-color: #E6E6E6;"> 
    <div style="border-top:1px solid #FFFFFF;"> 
      <div class="CeldaHdr" style="border-right:0px;border-top:1px solid #E6E6E6;">&nbsp;</div>
    </div>
    <br> </td><td valign="top" class="HdrNormal" style="background-color: #E6E6E6;">
  <cfif qryPeriodoCerrado.Cerrado>
    <cfset LvarCodigo="">
    <cfset LvarFecha=form.txtFecha>
    <div style="border-top:1px solid #FFFFFF;"> 
      <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">PERIODO CERRADO</div>
    </div>
    <br>
    <p align="center">No se puede modificar la planeaci n del curso porque el 
      Perodo est  cerrado, para abrirlo utilice la opcin calificar per odo</p>
    <cfelseif form.hdnTipoOperacion eq "R">
    <cfset LvarCodigo="">
    <cfset LvarFecha=form.txtFecha>
    <cfset LvarOrden=form.txtOrden>
    <div style="border-top:1px solid #FFFFFF;"> 
      <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">Recalendarizar 
        Eventos</div>
    </div>
    <br>
    <input type="checkbox" name="chkTemas" class="boxNormal" value="1" checked>
    <strong><font color="#0066CC">Temas</font></strong><br>
    <input type="checkbox" name="chkEvaluaciones" class="boxNormal" value="1" checked>
    <strong> <font color="#FF8000">Evaluaciones</font></strong><br>
    <br>
    <table border="0" cellpadding="0" cellspacing="0" class="TxtNormal">
      <tr> 
        <td> <select name="cboTipoRecal" class="TxtNormal" size="1"
				         onChange="if (document.frmPlan.cboTipoRecal.value=='Correr')
						           { document.getElementById('txtLecciones').style.display='';document.getElementById('txtAlaFecha').style.display='none';}
								   else
						           { document.getElementById('txtLecciones').style.display='none';document.getElementById('txtAlaFecha').style.display='';}">
            <option value="Correr">A partir del</option>
            <option value="Pasar">Las del da</option>
          </select> </td>
        <td><cf_txtFecha name="txtFecha" class="TxtNormal" value="#LvarFecha#"></td>
      </tr>
    </table>
    A partir de la Sec. 
    <input type="text" name="txtOrden" class="TxtNormal" style="width:20px;" value="<cfoutput>#LvarOrden#</cfoutput>"  onKeyPress="return fnKeyPressNum(this, event);" onBlur="this.value=fnFormat(this.value,0)">
    <br>
    <br>
    <table id="txtLecciones" border="0" cellpadding="0" cellspacing="0" class="TxtNormal">
      <tr> 
        <td> <select name="cboTipoCorrer" class="TxtNormal" size="1">
            <option value="+">Incluir</option>
            <option value="-">Eliminar</option>
          </select> </td>
        <td valign="middle"><input type="text" name="txtDuracion" class="TxtNormal" style="width:20px;" value=""></td>
        <td valign="middle">&nbsp;dias lectivos en blanco</td>
      </tr>
    </table>
    <table id="txtAlaFecha" border="0" cellpadding="0" cellspacing="0" class="TxtNormal" style="display:none;">
      <tr> 
        <td>A la fecha&nbsp;</td>
        <td><cf_txtFecha name="txtAlaFecha" class="TxtNormal"></td>
      </tr>
    </table>
    <br>
    <p align="center"> 
      <input name="btnRecalendarizar" type="submit" class="boxNormal" value="Recalendarizar" onClick="return fnVerificarDatos();">
    <cfif isdefined("LvarMSG") and LvarMSG neq "">
      <br>
      <br>
      <cfoutput> 
        <p><font color="##FF3300">#LvarMSG#</font></p>
      </cfoutput> 
    </cfif></p>
    <cfelseif form.hdnTipoOperacion eq "CE">
    <div style="border-top:1px solid #FFFFFF;"> 
      <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">Trabajar con 
        Conceptos de Evaluaci n</div>
    </div>
    <br>
    <cfquery datasource="#Session.Edu.DSN#" name="qryEvaluacionConcepto">
    set nocount on 
	select convert(varchar,ec.ECcodigo) as ECcodigo, ec.ECnombre, 
    	str(ecc.ECCporcentaje, 6,2) as ECCporcentaje, 
		(select count(*) from EvaluacionCurso p
    		where p.ECcodigo = ecc.ECcodigo 
			and p.Ccodigo = ecc.Ccodigo 
			and p.PEcodigo = ecc.PEcodigo ) as ECCplaneados 
	from EvaluacionConceptoCurso ecc, EvaluacionConcepto ec
    where ec.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
    and ecc.ECcodigo =* ec.ECcodigo and ecc.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
    and ecc.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
    order by ec.ECorden
 	set nocount off 
    </cfquery>
    <cfset LvarTipo="">
    <cfset LvarCodigo="">
    <cfset LvarNombre="">
    <cfset LvarDescripcion="">
    <cfset LvarFecha=form.hdnFecha>
    <cfif form.hdnFecha neq "" and find("{", form.hdnFecha) gt 0>
      <cfset LvarFecha=lsDateFormat(CreateODBCDate(form.hdnFecha),"DD/MM/YYYY")>
    </cfif>
    <cfset LvarDuracion="">
    <cfset LvarOrden="">
    <cfset LvarCubierto="">
    <cfset LvarTabla="">
    <cfset LvarPorcentaje="">
    <cfset LvarTipoPorcentaje="A">
    <br>
    <input name="chkTodos" type="checkbox" value="1" class="CeldaNoCurso"  style="border:0px; height:15px;" 
	         <cfif form.chkTodos eq "1">checked</cfif>
	         onClick="document.frmPlan.submit();">
    Incluir todos los conceptos 
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr class="CeldaHdr"> 
        <td style="display:none">Codigo</td>
        <td align="left">Concepto</td>
        <td>Eval.</td>
        <td width="50">Porcentaje</td>
        <td class="CeldaNoCurso" style="border:0px;width:15px">&nbsp;</td>
      </tr>
      <cfset LvarCelda="CeldaNoCurso">
      <cfset LvarTotal=0>
      <cfset LvarCurrentRow=0>
      <cfoutput query="qryEvaluacionConcepto"> 
        <cfif form.chkTodos eq "1" or ECCporcentaje neq "">
          <cfset LvarTotal=LvarTotal + val(ECCporcentaje)>
          <cfset LvarCurrentRow=LvarCurrentRow+1>
          <cfif LvarCelda neq "CeldaCurso">
            <cfset LvarCelda="CeldaCurso">
            <cfelse>
            <cfset LvarCelda="CeldaNoCurso">
          </cfif>
          <tr class="#LvarCelda#"> 
            <td style="display:none"><input type="text" name="txtECcod#LvarCurrentRow#" value="#ECcodigo#"></td>
            <td>#ECnombre#</td>
            <td><input type="checkbox" name="chkECcmp#LvarCurrentRow#" class="#LvarCelda#" style="border:0px; height:15px;" disabled <cfif ECCplaneados gt 0>checked</cfif>></td>
            <td><input type="text" name="txtECprc#LvarCurrentRow#" class="#LvarCelda#" style="height:15px; width:50px;text-align:right" 
		             value="#ECCporcentaje#"
		             onFocus="this.select();"
		             onKeyPress="return fnKeyPressNum(this,event);"
					 onBlur="fnCalcularTotal(this,event);"></td>
            <td class="CeldaNoCurso" style="border:0px;width:15px">&nbsp;</td>
          </tr>
        </cfif>
      </cfoutput> 
      <tr class="CeldaHdr"> 
        <td style="display:none"><input name="txtCantidad" value=<cfoutput>"#LvarCurrentRow#"</cfoutput>></td>
        <td align="left">PORCENTAJE TOTAL</td>
        <td></td>
        <td width="50"><input name="txtTotal" id="txtTotal" class="CeldaHdr" style="font-size:12px; border:0px; width:50px;" readonly value=<cfoutput>"#NumberFormat(LvarTotal,"9.00")#%"</cfoutput></td> 
        <td class="CeldaNoCurso" style="border:0px;width:15px">&nbsp;</td>
      </tr>
    </table>
    <p align="center"> 
      <input name="btnGrabarConceptos" type="submit" class="boxNormal" value="Grabar" onClick="return fnVerificarDatos();">
    </p>
    <cfelse>
    <cfif form.hdnTipoOperacion eq "">
      <cfquery datasource="#Session.Edu.DSN#" name="qryMateria">
      set nocount on select convert(varchar,EVTcodigo) as EVTcodigo, convert(varchar,m.Mconsecutivo) 
      as Mconsecutivo from Curso c, Materia m where c.CEcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
      and c.Ccodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
      and c.Mconsecutivo = m.Mconsecutivo set nocount off 
      </cfquery>
      <cfquery datasource="#Session.Edu.DSN#" name="qryConceptos">
		  set nocount on 
		  select convert(varchar,ec.ECcodigo) as Codigo, ec.ECnombre 
		  as Descripcion from Curso c, EvaluacionConceptoCurso ecc, EvaluacionConcepto ec 
		  where c.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			and ecc.Ccodigo  = c.Ccodigo 
			and ecc.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			and ec.CEcodigo  = c.CEcodigo 
			and ec.ECcodigo  = ecc.ECcodigo 
		  order by ec.ECorden 
		  set nocount off 
      </cfquery>
      <cfset LvarTipo="">
      <cfset LvarCodigo="">
      <cfset LvarNombre="">
      <cfset LvarDescripcion="">
      <cfset LvarFecha=form.hdnFecha>
      <cfif form.hdnFecha neq "" and find("{", form.hdnFecha) gt 0>
        <cfset LvarFecha=lsDateFormat(CreateODBCDate(form.hdnFecha),"DD/MM/YYYY")>
      </cfif>
      <cfset LvarDuracion="">
      <cfset LvarOrden="">
      <cfset LvarCubierto="">
      <cfset LvarTabla=qryMateria.EVTcodigo>
      <cfset LvarPorcentaje="">
      <cfset LvarTipoPorcentaje="A">
      <div style="border-top:1px solid #FFFFFF;"> 
        <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">Agregar Nuevo 
          Evento</div>
      </div>
      <br>
      <input type="radio" name="optTipo" value="1" class="boxNormal" onClick="document.getElementById('hdnTipoOperacion').value = 'T';document.getElementById('spnEvaluacion').style.display='none';document.getElementById('spnECcodigo').style.display='none';">
      <strong><font color="#0066CC">Tema</font></strong><br>
      <input type="radio" name="optTipo" value="0" class="boxNormal" onClick="document.getElementById('hdnTipoOperacion').value = 'E'; document.getElementById('spnEvaluacion').style.display='';document.getElementById('spnECcodigo').style.display='';">
      <strong> <font color="#FF8000">Evaluacion:</font></strong> 
	  <span id="spnECcodigo" class="TxtNormal" style="display:none;"> 
	  <BR><font class="TxtNormal">Pertenece a:</font>
      <select class="TxtNormal" size="1" name="cboECcodigo">
        <cfoutput query="qryConceptos"> 
          <option value="#Codigo#">#Descripcion#</option>
        </cfoutput> 
      </select>
      </span> <br>
    <cfelseif form.hdnTipoOperacion eq "T">
      <cfquery datasource="#Session.Edu.DSN#" name="qryEvento">
      set nocount on select convert(varchar,CPcodigo) as CPcodigo, CPnombre, CPdescripcion, 
      CPfecha, str(CPduracion,4,2) as CPduracion, isnull(CPcubierto,'N') as CPcubierto, 
      CPorden, convert(varchar,MPcodigo) as MPcodigo, convert(varchar,CPusucodigo) 
      as CPusucodigo from CursoPrograma where Ccodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
      and CPcodigo = 
      <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
      set nocount off 
      </cfquery>
      <cfset LvarTipo="T">
      <cfset LvarCodigo=qryEvento.CPcodigo>
      <cfset LvarNombre=qryEvento.CPnombre>
      <cfset LvarDescripcion=qryEvento.CPdescripcion>
      <cfset LvarFecha=lsdateformat(qryEvento.CPfecha,"DD/MM/YYYY")>
      <cfset LvarDuracion=qryEvento.CPduracion>
      <cfset LvarOrden=qryEvento.CPorden>
      <cfset LvarCubierto=qryEvento.CPcubierto>
      <cfset LvarTabla="">
      <cfset LvarPorcentaje="">
      <cfset LvarTipoPorcentaje="A">
      <div style="border-top:1px solid #FFFFFF;"> 
        <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">Trabajar con 
          Evento</div>
      </div>
      <br>
      <input type="radio" name="optTipo" value="1" class="boxNormal" checked>
      <strong><font color="#0066CC">Tema</font></strong><br>
    <cfelse>
      <cfquery datasource="#Session.Edu.DSN#" name="qryEvento">
      set nocount on 
	  select convert(varchar,cec.ECcomponente) as ECcomponente, 
        cec.ECnombre, cec.ECenunciado, cec.ECplaneada, str(cec.ECduracion,4,2) as 
        ECduracion, isnull(cec.ECevaluado,'N') as ECevaluado, cec.ECorden, convert(varchar,cec.EVTcodigo) 
        as EVTcodigo, convert(varchar,ecc.ECcodigo) as ECcodigoC, ecc.ECnombre as 
        ECnombreC, 
	    str(cec.ECporcentaje,6,2) as ECporcentaje, ECtipoPorcentaje as ECtipoPorcentaje 
      from EvaluacionCurso cec, EvaluacionConcepto ecc 
	  where cec.ECcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
        and cec.ECcodigo = ecc.ECcodigo 
	  set nocount off 
      </cfquery>
	  
	  <!--- Rutina para buscar evaluaciones calificadas --->
		<cfquery datasource="#Session.Edu.DSN#" name="qryEvalCalificadas">
			set nocount on 
				select count(Ecodigo) as Calificado
				from AlumnoCalificacion 
				where ECcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
				
			set nocount off 
		</cfquery>
	  	<input type="hidden" name="hdnCalificado" value="<cfif qryEvalCalificadas.RecordCount NEQ 0><cfoutput>#qryEvalCalificadas.Calificado#</cfoutput></cfif>">
	  
	  
	  
      <cfquery datasource="#Session.Edu.DSN#" name="qryConceptos">
		  set nocount on 
		  select convert(varchar,ec.ECcodigo) as Codigo, ec.ECnombre 
		  as Descripcion from Curso c, EvaluacionConceptoCurso ecc, EvaluacionConcepto ec 
		  where c.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			and ecc.Ccodigo  = c.Ccodigo 
			and ecc.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			and ec.CEcodigo  = c.CEcodigo 
			and ec.ECcodigo  = ecc.ECcodigo 
		  order by ec.ECorden 
		  set nocount off 
      </cfquery>
      <cfset LvarTipo="E">
      <cfset LvarCodigo=qryEvento.ECcomponente>
      <cfset LvarNombre=qryEvento.ECnombre>
      <cfset LvarDescripcion=qryEvento.ECenunciado>
      <cfset LvarFecha=lsdateformat(qryEvento.ECplaneada,"DD/MM/YYYY")>
      <cfset LvarDuracion=qryEvento.ECduracion>
      <cfset LvarOrden=qryEvento.ECorden>
      <cfset LvarCubierto=qryEvento.ECevaluado>
      <cfset LvarTabla=qryEvento.EVTcodigo>
      <cfset LvarPorcentaje=qryEvento.ECporcentaje>
      <cfset LvarTipoPorcentaje=qryEvento.ECtipoPorcentaje>
      <div style="border-top:1px solid #FFFFFF;"> 
        <div class="CeldaHdr" style="border-top:1px solid #E6E6E6;">Trabajar con 
          Evento</div>
      </div>
      <br>
      <input type="radio" name="optTipo" value="0" class="boxNormal" checked>
      <strong> <font color="#FF8000">Evaluacion:</font></strong>&nbsp; 
      <input type="hidden" name="hdnECcodigoAnt" value="<cfoutput>#qryEvento.ECcodigoC#</cfoutput>">
	  
	  <BR><font class="TxtNormal">Pertenece a:</font>
      <select  name="cboECcodigo" class="TxtNormal" size="1">
        <cfoutput query="qryConceptos"> 
          <option value="#Codigo#" <cfif Codigo eq qryEvento.ECcodigoC>selected</cfif>>#Descripcion#</option>
        </cfoutput> 
      </select>
      <br>
    </cfif>
    <cfoutput> <br>
      <table border="0" cellpading="0" cellspacing="0" class="TxtNormal">
        <tbody>
          <tr> 
            <td width="85">Nombre:</td>
            <td width="253"><input type="text" name="txtNombre" class="TxtNormal" size="20" value="#LvarNombre#"></td>
          </tr>
          <tr> 
            <td colspan="2"> <textarea name="txtDescripcion" class="TxtNormal" style="width:100%;" rows="4" cols="39">#LvarDescripcion#</textarea> 
            </td>
          </tr>
          <tr> 
            <td>Planeado para el</td>
            <td> <table border="0" cellpadding="0" cellspacing="0" class="HdrNormal">
                <tr> 
                  <td> <cf_txtFecha name="txtFecha" class="TxtNormal" value="#LvarFecha#"> 
                    <input type="hidden" name="hdnFechaAnt" value="#LvarFecha#"> 
                  </td>
                  <td nowrap>&nbsp;&nbsp;Sec.&nbsp; <input type="text" name="txtOrden" class="TxtNormal" style="width:20px;" value="#LvarOrden#"  onKeyPress="return fnKeyPressNum(this, event);" onBlur="this.value=fnFormat(this.value,0)"> 
                    <input type="hidden" name="hdnOrden" value="<cfoutput>#LvarOrden#</cfoutput>"> 
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>Duraci&oacute;n</td>
            <td><input type="text" name="txtDuracion" class="TxtNormal" size="3" value="#LvarDuracion#" onKeyPress="return fnKeyPressNum(this, event);" onBlur="this.value=fnFormat(this.value,2)">
              dias lectivos</td>
          </tr>
        </tbody>
        <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "E">
          <cfquery datasource="#Session.Edu.DSN#" name="qryTablas">
          set nocount on select EVTcodigo as Codigo, EVTnombre as Descripcion 
          from EvaluacionValoresTabla where CEcodigo = 
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
          set nocount off 
          </cfquery>
          <tbody id="spnEvaluacion"<cfif form.hdnTipoOperacion eq ""> style="display:none"</cfif>>
            <tr> 
              <td>Tipo 
                Calificacion</td>
              <td> 
                <select class="TxtNormal" size="1" name="cboEVTcodigo">
                  <option value="null" <cfif LvarTabla eq "">selected</cfif>>[Digitar 
                  Porcentaje]</option>
                  <cfloop query="qryTablas">
                    <option value="#Codigo#" <cfif LvarTabla eq Codigo>selected</cfif>>#Descripcion#</option>
                  </cfloop>
                </select> </td>
            </tr>
            <tr> 
              <td>Porcentaje</td>
              <td> 
                <select class="TxtNormal" size="1" name="cboTipoPorcentaje" 
			          onChange="LvarPrc = document.frmPlan.txtPorcentaje; if (this.value=='M') LvarPrc.disabled = false; else {LvarPrc.disabled = true; LvarPrc.value = '';}">
                  <option value="A" <cfif LvarTipoPorcentaje eq "A">selected</cfif>>Automatico</option>
                  <option value="M" <cfif LvarTipoPorcentaje eq "M">selected</cfif>>Manual</option>
                  <!--- 
				!--->
                </select> <input type="text" name="txtPorcentaje" class="TxtNormal" size="3" value="#LvarPorcentaje#" onKeyPress="return fnKeyPressNum(this, event);" onBlur="this.value=fnFormat(this.value,2)" <cfif LvarTipoPorcentaje eq "A">disabled</cfif>>
                % </td>
            </tr>
          </tbody>
        </cfif>
        <tbody>
          <tr> 
            <td>Evento Realizado</td>
            <td><input type="checkbox" name="chkCubierto" class="boxNormal" value="S" <cfif LvarCubierto neq "N" and LvarCubierto neq "">checked</cfif>></td>
          </tr>
        </tbody>
      </table>
    </cfoutput> 
    <p align="center"> 
      <cfif form.hdnTipoOperacion eq "">
        <input name="btnAgregar" type="submit" class="boxNormal" value="Agregar" onClick="return fnVerificarDatos();">
        &nbsp; 
        <cfelse>
        <input type="submit" class="boxNormal" name="btnCambiar" value="Cambiar" onClick="return fnVerificarDatos();">
        &nbsp; 
        <input type="submit" class="boxNormal" name="btnBorrar" value="Borrar" onClick="return fnHayDatosCalificados();">
        &nbsp; 
      </cfif>
      <input name="btnRecal" type="submit" class="boxNormal" value="Recalendarizar" onClick="document.getElementById('hdnTipoOperacion').value = 'R';">
    </p>
  </cfif>
  <cfoutput> 
    <input type="hidden" id="hdnTipoOperacion" name="hdnTipoOperacion"  value="#form.hdnTipoOperacion#">
    <input type="hidden" id="hdnCodigo" name="hdnCodigo" value="#LvarCodigo#">
    <input type="hidden" id="hdnFecha" name="hdnFecha" value="#LvarFecha#">
  </cfoutput> 
  <cfquery datasource="#Session.Edu.DSN#" name="qryNoPlaneados">
  set nocount on 
  select ec.ECnombre from EvaluacionConceptoCurso ecc, EvaluacionConcepto ec 
  where ec.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
  and ecc.ECcodigo = ec.ECcodigo 
  and ecc.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
  and ecc.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  and not exists (select * from EvaluacionCurso p 
  							where p.ECcodigo = ecc.ECcodigo 
  							and p.Ccodigo = ecc.Ccodigo and p.PEcodigo = ecc.PEcodigo ) 
  order by ec.ECorden 
  set nocount off 
  </cfquery>
  <cfif qryNoPlaneados.recordCount gt 0>
  <BR>
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr class="CeldaHdr"> 
      <td align="center">EL CURSO NO SE HA TERMINADO DE PLANEAR</td>
    </tr>
<!---
    <tr class="CeldaHdr"> 
      <td align="left">Conceptos sin Evaluaciones planeadas</td>
    </tr>
    <cfset LvarCelda="CeldaNoCurso">
    <cfoutput query="qryNoPlaneados"> 
      <cfif LvarCelda neq "CeldaCurso">
        <cfset LvarCelda="CeldaCurso">
        <cfelse>
        <cfset LvarCelda="CeldaNoCurso">
      </cfif>
      <tr class="#LvarCelda#"> 
        <td>#ECnombre#</td>
      </tr>
    </cfoutput> 
!--->
  </table>
  </cfif>
  <cfquery datasource="#Session.Edu.DSN#" name="qryPlanEvaluacion">
    set nocount on 
	select convert(varchar,ec.ECcodigo) as ECcodigo, 
		ec.ECnombre as ECnombre, 
    	str(ecc.ECCporcentaje, 6,2) as ECCporcentaje, 
		e.ECcomponente,
		e.ECnombre as nom2, 
		e.ECplaneada, e.ECtipoPorcentaje,
		str(e.ECporcentaje, 6,2) as ECporcentaje,
		str(e.ECporcentaje*ecc.ECCporcentaje/100, 6,2) as Eporcentaje
	from EvaluacionConcepto ec, EvaluacionConceptoCurso ecc, EvaluacionCurso e
    where ec.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
    and ecc.ECcodigo *= ec.ECcodigo 
	and ecc.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
    and ecc.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
    and e.ECcodigo =* ecc.ECcodigo 
    and e.Ccodigo  =* ecc.Ccodigo 
    and e.PEcodigo =* ecc.PEcodigo
    order by ec.ECorden
 	set nocount off 
  </cfquery>
 <cfif qryPlanEvaluacion.recordCount eq 0>
  <BR>
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr class="CeldaHdr"> 
      <td align="center">EL CURSO NO HA SIDO PLANEADO</td>
    </tr>
    <tr class="CeldaHdr"> 
      <td align="center">No posee ningn Concepto de Evaluacion</td>
    </tr>
 <cfelse>
  <cfparam name="form.chkPlanEvaluaciones" default="">
  <input name="chkPlanEvaluaciones" type="checkbox" value="1" class="BoxNormal"
         <cfif form.chkPlanEvaluaciones eq "1">checked</cfif>
		 onClick="document.frmPlan.hdnTipoOperacion.value='<cfoutput>#form.hdnTipoOperacion#</cfoutput>' ;document.frmPlan.submit();">
  Plan Evaluaciones&nbsp;&nbsp;&nbsp;
      <input type="submit" class="boxNormal" name="btnEvaluacion" style="height: 20px; font-size:10px; margin-top:3px; margin-bottom:3px;" value="<cfif form.hdnTipoOperacion eq 'CE'>Eventos<cfelse>Conceptos</cfif>" title="Trabajar con Conceptos de Evaluacion" 
		       onClick="document.getElementById('hdnTipoOperacion').value = <cfif form.hdnTipoOperacion eq 'CE'>''<cfelse>'CE'</cfif>;">
  <cfif form.chkPlanEvaluaciones eq "1">
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr class="CeldaHdr"> 
      <td colspan="5" align="center">PLAN DE EVALUACIONES</td>
    </tr>
    <cfset LvarAnt="CeldaNoCurso">
    <cfset LvarCelda="CeldaNoCurso">
    <cfoutput query="qryPlanEvaluacion"> 
      <cfif LvarAnt neq qryPlanEvaluacion.ECcodigo>
      <cfif LvarCelda neq "CeldaCurso">
        <cfset LvarCelda="CeldaCurso">
        <cfelse>
        <cfset LvarCelda="CeldaNoCurso">
      </cfif>
        <cfset LvarAnt = qryPlanEvaluacion.ECcodigo>
      <tr class="#LvarCelda#"> 
        <td colspan="3" style="font-size:10;font-weight:bold;border-top:1px solid ##666666;">#ECnombre#</td>
        <td style="font-size:10;font-weight:bold;border-top:1px solid ##666666;">&nbsp;</td>
        <td style="font-size:10;font-weight:bold;text-align:right;border-top:1px solid ##666666;">#ECCporcentaje#</td>
      </tr>
	  </cfif>
      <cfif LvarCelda neq "CeldaCurso">
        <cfset LvarCelda="CeldaCurso">
        <cfelse>
        <cfset LvarCelda="CeldaNoCurso">
      </cfif>
      <cfif qryPlanEvaluacion.nom2 eq "">
      <tr class="#LvarCelda#"> 
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td colspan="2" style="color: ##CC0000">SIN EVALUACIONES</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
	  <cfelse>
      <tr class="#LvarCelda#"> 
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td><a href="javascript:fnTrabajarConEvento('E','#lsdateformat(qryPlanEvaluacion.ECplaneada,"YYYYMMDD")#','#ECcomponente#');" class="celdaRef">#nom2#</a></td>
        <td>#qryPlanEvaluacion.ECtipoPorcentaje#</td>
        <td style="text-align:right">#ECporcentaje#</td>
        <td style="text-align:right">#Eporcentaje#</td>
      </tr>
	  </cfif>
    </cfoutput> 
  </table>
  </cfif>
  </cfif>
    <BR></td></tr>
  </table>
</form>
