<cfinclude template="commonDocencia.cfm"> 

<cfset GvarBuscarFeriados=true>
<cffunction name="fnEsLeccion" returntype="boolean">
           <cfargument name="LprmFecha" required="true" type="date">
           <cfargument name="LprmBuscarFeriados" required="true" type="boolean" default="true">
  <cfset LvarDW = datepart("w", LprmFecha)>
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
    <cfquery dbtype="query" name="qryCalendarioDia">
	  select Descripcion, 
	         'LprmFecha' as Fecha, 
	         Feriado 
	    from qryCalendario 
	   where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' 
	      or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
    <cfquery dbtype="query" name="qryFeriado">
	  select Descripcion, 
	         Fecha
		from qryCalendarioDia 
	   where Feriado = 1
	</cfquery>
    <cfreturn (qryFeriado.Fecha neq "")>
</cffunction>

<cfscript>
  sbInitFromSession("cboAlumno", "-999",false);
  sbInitFromSession("cboCurso", "-1",false);
  sbInitFromSession("cboPeriodo", "-999",false);
</cfscript>
<cfparam name="form.hdnTipoOperacion" default="">
<cfparam name="form.hdnTipoActividad" default="">
<cfparam name="form.hdnCodigo" default="">
<cfparam name="form.hdnFecha" default="">
<cfparam name="form.hdnFechaFinal" default="">

<cfinclude template="qrysAlumnoCursoPeriodo.cfm">

<cfif not (#form.cboAlumno# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999")>
  <cfquery datasource="#Session.DSN#" name="qryHorarios">
    select distinct convert(int,HRdia)+2 as HRdia
      from HorarioGuia h
     where #fnCursoEscogido("h.Ccodigo")#
  </cfquery>
  <cfset GvarHorarios="*">
  <cfloop query="qryHorarios">
    <cfif HRdia eq 8>
      <cfset GvarHorarios = GvarHorarios & "1*">
    <cfelse>
      <cfset GvarHorarios = GvarHorarios & HRdia & "*">
    </cfif>
  </cfloop>
  <cfquery datasource="#Session.DSN#" name="qryLimitesPeriodoActividades">
    select 'E' as Tipo, min(e.ECplaneada) as Inicial, max(e.ECplaneada) as Final
      from EvaluacionCurso e
	 where #fnCursoEscogido("e.Ccodigo")#
       and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'T', min(t.CPfecha) as Inicial, max(t.CPfecha) as Final
      from CursoPrograma t
     where #fnCursoEscogido("t.Ccodigo")#
       and t.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'P', POfechainicio as Inicial, POfechafin as Final
      from PeriodoOcurrencia p, Curso c
     where #fnCursoEscogido("c.Ccodigo")#
       and p.PEcodigo     = c.PEcodigo 
       and p.SPEcodigo    = c.SPEcodigo 
       and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  </cfquery>

  <cfquery dbtype="query" name="qryLimite">
    select min(Inicial) as Inicial, max(Final) as Final
      from qryLimitesPeriodoActividades
  </cfquery>
  
  <cfquery dbtype="query" name="qryLimitePeriodo">
    select Inicial, Final
      from qryLimitesPeriodoActividades
	 where Tipo='P'
  </cfquery>
  <cfif GvarBuscarFeriados or (isDefined("form.btnRecalendarizar") and form.cboTipoRecal eq "Correr")>
    <cfquery datasource="#Session.DSN#" name="qryCalendarioCod">
      select Ccodigo
	    from CentroEducativo 
       where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
    </cfquery>
    <cfquery datasource="#Session.DTSsdc#" name="qryCalendario">
      select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, 
	         CDtitulo as Descripcion,
			 CDferiado as Feriado
	    from CalendarioDia 
       where Ccodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCalendarioCod.Ccodigo#">
         and CDabsoluto=0
         and CDfecha between '#lsDateFormat(qryLimite.Inicial,"YYYYMMDD")#' and '#lsDateFormat(qryLimite.Final,"YYYYMMDD")#'
    UNION
      select convert(datetime, '2000' + substring(convert(varchar,CDfecha,112),5,8)), 
	         CDtitulo,
			 CDferiado
	    from CalendarioDia 
       where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCalendarioCod.Ccodigo#">
         and CDabsoluto=1
    </cfquery>
  </cfif>

  <cfif form.hdnTipoOperacion eq "R">
  <cfquery datasource="#Session.DSN#" name="qryLimitesPeriodoActividades">
    select 'E' as Tipo, min(e.ECplaneada) as Inicial, max(e.ECplaneada) as Final
      from EvaluacionCurso e
     where #fnCursoEscogido("e.Ccodigo")#
       and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'T', min(t.CPfecha), max(t.CPfecha)
      from CursoPrograma t
     where #fnCursoEscogido("t.Ccodigo")#
       and t.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  UNION
    select 'P', POfechainicio, POfechafin
      from PeriodoOcurrencia p, Curso c
     where #fnCursoEscogido("c.Ccodigo")#
       and p.PEcodigo     = c.PEcodigo 
       and p.SPEcodigo    = c.SPEcodigo 
       and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
  </cfquery>

  <cfquery dbtype="query" name="qryLimite">
    select min(Inicial) as Inicial, max(Final) as Final
      from qryLimitesPeriodoActividades
  </cfquery>
  <cfquery dbtype="query" name="qryLimitePeriodo">
    select Inicial, Final
      from qryLimitesPeriodoActividades
	 where Tipo='P'
  </cfquery>
  </cfif>
  <cfquery datasource="#Session.DSN#" name="qryActividades">
    select 'Evaluaciones' as tipo, '2' as orden, 'E' as TipoOperacion, 
	       ECplaneada as fecha, count(*) as Cantidad
      from EvaluacionCurso e
     where PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and #fnCursoEscogido("e.Ccodigo")#
     group by ECplaneada
  UNION
    select 'Temas', '1', 'T', CPfecha, count(*)
      from CursoPrograma t
     where #fnCursoEscogido("t.Ccodigo")#
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     group by CPfecha
  UNION
    select 'Observaciones', '3', 'O', ACOfecha, count(*)
      from AlumnoCursoObservacion o
     where #fnCursoEscogido("o.Ccodigo")#
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     group by ACOfecha
  UNION
    select 'Asistencia', '4', 'A', ACAfecha, count(*)
      from AlumnoCursoAsistencia a
     where #fnCursoEscogido("a.Ccodigo")#
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     group by ACAfecha
  order by fecha, orden
  </cfquery>

  <cfset LvarIni=qryLimite.Inicial>
  <cfset LvarFin=qryLimite.Final>
</cfif>

<html><!-- InstanceBegin template="/Templates/LMenuENC.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" --> 
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
<script language="JavaScript" src="commonDocencia1_00.js"></script>
<script language="JavaScript" src="consultarActividades1_00.js"></script>
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
<script language="JavaScript" src="../../js/DHTMLMenu/stm31.js"></script>
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
		  	<cfset RolActual = 7>
			<cfset Session.RolActual = 7>
			<cfinclude template="../../portlets/pEmpresas2.cfm">
		  </td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
              Apoyo Familiar
			<!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../portlets/pminisitio.cfm">
		  </td>
          <td valign="top" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" --> 
      <!-- InstanceEndEditable -->	
		  </td>
        </tr>
      </table>
	</td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
		  	CONSULTA DE ACTIVIDADES DURANTE EL PERIODO DE EVALUACION
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->

<cfquery datasource="#Session.DSN#" name="rsDatosEstud">
	select c.Ndescripcion, d.Gdescripcion, e.SPEdescripcion, f.GRnombre 
	from Alumnos a, Promocion b, Nivel c, Grado d, SubPeriodoEscolar e, Grupo f
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboAlumno#">
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.PRcodigo = b.PRcodigo
	and b.Ncodigo = c.Ncodigo
	and b.Ncodigo = d.Ncodigo
	and b.Gcodigo = d.Gcodigo
	and b.PEcodigo = e.PEcodigo
	and b.SPEcodigo = e.SPEcodigo
	and b.Ncodigo = f.Ncodigo
	and b.Gcodigo = f.Gcodigo
	and b.PEcodigo = f.PEcodigo
	and b.SPEcodigo = f.SPEcodigo
</cfquery>

  <form name="frmActividades" method="POST" action="" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
    <br>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
  	<tr>
    <td width="75">Alumno:</td>
    <td width="100"><select name="cboAlumno"
                style="font:10px Verdana, Arial, Helvetica, sans-serif;"
                onChange="fnReLoad();">
    <cfset LvarSelected="0">
    <cfset LvarFirst="">
    <cfoutput query="qryAlumnos">
	  <cfif currentRow eq 1><cfset LvarFirst=Codigo><cfset LvarPersonaAlumno="#Persona#"></cfif>
      <option value="#Codigo#"
	  <cfif #form.cboAlumno# eq #Codigo#> selected<cfset LvarSelected="1"><cfset LvarPersonaAlumno="#Persona#">
	  </cfif>>#Descripcion#</option>
    </cfoutput>              
    <cfif #LvarSelected# eq "0">
	  <cfif LvarFirst neq "">
	    <cfset form.cboAlumno=LvarFirst>
	  <cfelse>
        <cfset form.cboAlumno="-999">
		<cfset LvarPersonaAlumno="-999">
	  </cfif>
      
    </cfif>
       </select>
	</td>
    <td width="100" rowspan="9" style="padding-left: 50px">
	  <cf_Educleerimagen Tabla="PersonaEducativo" ruta="/cfmx/edu/Utiles/sifleerimagencont.cfm" Campo="Pfoto" Condicion="persona=#LvarPersonaAlumno#" Conexion="#Session.DSN#" autosize="false" width="85" height="113">
	</td>
	<td nowrap valign="middle">
		<cfoutput>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td nowrap>
					<strong>Nivel:</strong> #rsDatosEstud.Ndescripcion#
				</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>Grado:</strong> #rsDatosEstud.Gdescripcion#
				</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>Grupo:</strong> #rsDatosEstud.GRnombre#
				</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>Curso Lectivo:</strong> #rsDatosEstud.SPEdescripcion#
				</td>
			</tr>
		</table>
		</cfoutput>
	</td>
  </tr>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
  <tr>
    <td width="75">Curso:</td>
    <td width="100"><select name="cboCurso" 
                style="font:10px Verdana, Arial, Helvetica, sans-serif;"
                onChange='if (this.value != "-999") fnReLoad();'>
        <option value="-1">* * TODOS LOS CURSOS * *</option>
    <cfset LvarSelected="0">
    <cfoutput query="qryCursos">
        <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
    </cfoutput>              
    <cfif #LvarSelected# eq "0" and form.cboCurso neq "-1">
      <cfset form.cboCurso="-1">
    </cfif>
      </select>
	</td>
    <td width="100">&nbsp;</td>
  </tr>
  
    <cfif #form.cboAlumno# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
      <cfabort>
    </cfif>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
  <tr>
    <td width="75">Período:</td>
    <td width="100"><select name="cboPeriodo" 
            style="font:10px Verdana, Arial, Helvetica, sans-serif;"
            onChange="fnReLoad();">
    <cfoutput query="qryPeriodos">
      <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
    </cfoutput>
    </select>
	</td>
    <td width="100">&nbsp;</td>
  </tr>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
  <tr><td width="75">&nbsp;</td><td width="100">&nbsp;</td><td width="100">&nbsp;</td></tr>
</table>
      
    <table width="100%" border="0" cellpading="0" cellspacing="0" style="background-color: #E6E6E6;">
    <tr><td valign="top">
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
          <td class="CeldaHdr">
            <cfset LvarDW = datepart("w", LvarIni)-1>
            <cfset LvarFecha1 = dateadd("D",-LvarDW,LvarIni)> 
            <cfset LvarFecha2 = dateadd("D",6,LvarFecha1)> 
            <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarIni,"DD/MM/YYYY")#','#lsdateformat(LvarFecha2,"DD/MM/YYYY")#');" class="CeldaHdr" style="border:0;">1</a>
		  </td>
        <!--- Llena las celdas anteriores al inicio --->
        <cfset LvarDW = datepart("w", LvarIni)-1>
        <cfloop from="1" to="#LvarDW#" index="LvarCol">
          <td class="CeldaNoCurso">&nbsp;</td>
        </cfloop>
        <!--- Llena la primera celda anteriores al inicio --->
        <cfif fnEsLeccion(LvarIni, false)>
          <cfif fnEsFeriado(LvarIni)>
            <cfset LvarCeldaCurso="CeldaFeriado">
		  <cfelse>
            <cfset LvarCeldaCurso="CeldaCurso">
		  </cfif>
        <cfelse>
          <cfset LvarCeldaCurso="CeldaNoCurso">
        </cfif>
        <cfset LvarFecha=LvarIni>
          <td class="#LvarCeldaCurso#">
            <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
			<div style="width=100%;cursor:hand;">
              <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
			    <b>#lsdateformat(LvarFecha,"D MMM YY")#</b>
			  </a>
            </div></a>
			<cfif LvarFecha eq qryLimitePeriodo.Inicial><span class="celdaHdr" style="text-align:left; border=0px; font:11px; cursor:default;">INICIO PERIODO</span></cfif>
            <cfif LvarCeldaCurso neq "CeldaNoCurso">
			  <cfloop query="qryCalendarioDia">
			    <span>#Descripcion#</span>
			  </cfloop>
			</cfif>
        <!--- Recorre todos las Actividades --->
        <cfloop query="qryActividades"> 
          <!--- Llena las celdas anteriores al siguiente Actividad --->
          <cfloop condition="LvarFecha lt Fecha"> 
			<cfif LvarFecha eq qryLimitePeriodo.Final><p class="CeldaTxt" align="right"><span class="CeldaHdr" style="border=0px; font:11px; cursor:default;">FINAL PERIODO&nbsp;</span></p></cfif>
			</td>
            <cfset LvarFecha = dateadd("D",1,LvarFecha)> 
            <cfset LvarDW = datepart("w",LvarFecha)> 
            <cfif LvarDW eq 1>
              <cfset LvarSem = LvarSem + 1 >
			  </tr><tr><td class="CeldaHdr">
				<cfset LvarFecha2 = dateadd("D",6,LvarFecha)> 
				<a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#','#lsdateformat(LvarFecha2,"DD/MM/YYYY")#');" class="CeldaHdr" style="border:0;">#LvarSem#</a>
			  </td>
            </cfif>
            <cfif fnEsLeccion(LvarFecha, false)>
              <cfif fnEsFeriado(LvarFecha)>
                <cfset LvarCeldaCurso="CeldaFeriado">
              <cfelse>
                <cfset LvarCeldaCurso="CeldaCurso">
              </cfif>
            <cfelse>
              <cfset LvarCeldaCurso="CeldaNoCurso">
            </cfif>
            <td class="#LvarCeldaCurso#">
              <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
			  <div style="width=100%;cursor:hand;">
			    <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
				  <cfif datepart("d",LvarFecha) eq 1><B>#lsdateformat(LvarFecha,"D MMM YY")#</B><cfelse>#lsdateformat(LvarFecha,"D")#</cfif>
			    </a>
              </div></a>
			<cfif LvarFecha eq qryLimitePeriodo.Inicial><span class="celdaHdr" style="text-align:left; border=0px; font:11px; cursor:default;">INICIO PERIODO</span></cfif>
            <cfif LvarCeldaCurso neq "CeldaNoCurso">
			  <cfloop query="qryCalendarioDia">
			    <span>#Descripcion#</span>
			  </cfloop>
			</cfif>
          </cfloop>
          <cfif Fecha eq LvarFecha>
            <p class="CeldaTxt"><a href="javascript:fnConsultarActividades('#TipoOperacion#', '#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="celdaRef">
			  #Tipo#
			</a></p>
          </cfif>
        </cfloop> 
        <!--- Llena las celdas anteriores al final (en caso de que el final del periodo sea posterior al ultimo Actividad) --->
        <cfloop condition="LvarFecha lt LvarFin"> 
 	 	  <cfif LvarFecha eq qryLimitePeriodo.Final><p class="CeldaTxt" align="right"><span class="CeldaHdr" style="border=0px; font:11px; cursor:default;">FINAL PERIODO&nbsp;</span></p></cfif>
          <cfset LvarFecha = dateadd("d",1,LvarFecha)>
          <cfset LvarDW = datepart("w",LvarFecha)>
          <cfif LvarDW eq "1">
            <cfset LvarSem = LvarSem + 1 >
            </td></tr><tr><td class="CeldaHdr">#LvarSem#</td>
          </cfif>
          <cfif fnEsLeccion(LvarFecha, false)>
            <cfif fnEsFeriado(LvarFecha)>
              <cfset LvarCeldaCurso="CeldaFeriado">
            <cfelse>
              <cfset LvarCeldaCurso="CeldaCurso">
            </cfif>
          <cfelse>
            <cfset LvarCeldaCurso="CeldaNoCurso">
          </cfif>
          <td class="#LvarCeldaCurso#">
            <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
			<div style="width=100%;cursor:hand;">
		      <a href="javascript:fnConsultarActividades('','#lsdateformat(LvarFecha,"DD/MM/YYYY")#');" class="CeldaFechaRef">
			    <cfif lsdateformat(LvarFecha,"DD") eq "1"><B>#lsdateformat(LvarFecha,"D MMM YY")#</B><cfelse>#lsdateformat(LvarFecha,"D")#</cfif>
              </a>
            </div></a>
			<cfif LvarFecha eq qryLimitePeriodo.Inicial><span class="celdaHdr" style="text-align:left; border=0px; font:11px; cursor:default;">INICIO PERIODO</span></cfif>
            <cfif LvarCeldaCurso neq "CeldaNoCurso">
			  <cfloop query="qryCalendarioDia">
			    <span>#Descripcion#</span>
			  </cfloop>
			</cfif>
        </cfloop> 
        <cfset LvarDW = datepart("w",LvarFin)+1> 
		<cfif LvarFecha eq qryLimitePeriodo.Final><p class="CeldaTxt" align="right"><span class="CeldaHdr" style="border=0px; font:11px; cursor:default;">FINAL PERIODO&nbsp;</span></p></cfif>
        </td>
        <!--- Llena las celdas posteriores al final --->
        <cfloop from="#LvarDW#" to="7" index="LvarCol"> 
          <td class="CeldaNoCurso">&nbsp;</td>
        </cfloop></td></tr>
      </table>
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
	    <cfquery datasource="#Session.DSN#" name="qryActividades">
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
<!-- InstanceEndEditable -->
		  </td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table>
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
