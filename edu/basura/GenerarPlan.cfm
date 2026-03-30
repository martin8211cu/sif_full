<cfset LvarLeccionesN = 30> <!--- Debe ser ceil(max(NumeroLeccion + Duracion)) --->
<cfset LvarMcodigo = 514>
<cfset LvarCcodigo = 251>
<cfset LvarPEcodigo = 27>   <!--- Periodo de Evaluacion --->

<cfparam name="Session.DTSeducativo" default="Educativo">
<cfparam name="Session.DTSsdc" default="sdc">
<cfset GvarBuscarFeriados=true>
<cfoutput>
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
    <cfquery dbtype="query" name="qryFeriado">
	  select Descripcion, Fecha from qryFeriados where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
    <cfreturn (qryFeriado.Fecha neq "")>
</cffunction>

  <cfquery datasource="#Session.DTSeducativo#" name="qryHorarios">
    select distinct convert(int,HRdia)+2 as HRdia
      from HorarioGuia
     where Ccodigo = #LvarCcodigo#
  </cfquery>
  <cfset GvarHorarios="*">
  <cfloop query="qryHorarios">
    <cfif HRdia eq 8>
      <cfset GvarHorarios = GvarHorarios & "1*">
    <cfelse>
      <cfset GvarHorarios = GvarHorarios & HRdia & "*">
    </cfif>
  </cfloop>
  <cfquery datasource="#Session.DTSeducativo#" name="qryLimitesPeriodo">
    select POfechainicio Inicial, POfechafin Final
      from PeriodoOcurrencia p, Curso c
     where c.Ccodigo      = #LvarCcodigo#
       and p.PEcodigo     = c.PEcodigo 
       and p.SPEcodigo    = c.SPEcodigo 
       and p.PEevaluacion = #LvarPEcodigo#
  </cfquery>
  <cfquery datasource="#Session.DTSsdc#" name="qryFeriados">
      select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion
	    from CalendarioDia 
       where Ccodigo=#LvarCcodigo#
         and CDferiado=1 
         and CDabsoluto=0
         and CDfecha between '#lsDateFormat(qryLimitesPeriodo.Inicial,"YYYYMMDD")#' and '#lsDateFormat(qryLimitesPeriodo.Final,"YYYYMMDD")#'
    UNION
      select convert(datetime, '2000' + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
	    from CalendarioDia 
       where Ccodigo=#LvarCcodigo#
         and CDferiado=1 
         and CDabsoluto=1
    </cfquery>

<cfset LvarFechasEquiv = ArrayNew(1)>
<cfset LvarFecha=DateAdd("d",0,qryLimitesPeriodo.Inicial)>
<cfloop index="LvarLec" from="1" to="#LvarLeccionesN#">
  <cfloop condition="LvarFecha lt qryLimitesPeriodo.Final and not fnEsLeccion(LvarFecha, true)">
    <cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
  </cfloop>
  <cfset LvarFechasEquiv[LvarLec] = LvarFecha>
  <cfif LvarFecha lt qryLimitesPeriodo.Final>
    <cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
  </cfif>
</cfloop>


<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>INICIO PERIODO</td>
    <td>FINAL PERIODO</td>
  </tr>
  <tr>
    <td>#qryLimitesPeriodo.Inicial#</td>
    <td>#qryLimitesPeriodo.Final#</td>
  </tr>
  <tr>
    <td>Numero Leccion</td>
    <td>Fecha Equivalente</td>
  </tr>
<cfloop index="LvarLec" from="1" to="#LvarLeccionesN#">
  <tr>
    <td>#LvarLec#</td>
    <td>#LvarFechasEquiv[LvarLec]#</td>
  </tr>
</cfloop> 
</table>
<!---
<cfif LvarDuracion gt 1>
  <cfset LvarLec2 = LvarLec>
  <cfset LvarDuracion = LvarDuracion - 1>
  <cfloop condition="LvarDuracion gt 0">
      <cfset LvarLec2 = LvarLec2 + 1>
      <cfquery datasource="#Session.DTSeducativo#">
        insert into CursoPrograma
    	      (Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPfecha, CPduracion, CPcubierto, CPorden)
        select Ccodigo, PEcodigo, CPnombre, CPdescripcion, #LvarFechasEquiv[LvarLec2]#, <cfif LvarDuracion gt 1>1<cfelse>#LvarDuracion#</cfif>, 'N', CPorden+100
          from CursoPrograma
		 where Ccodigo = #form.cboCurso#
		   and CPcodigo = #form.hdnCodigo#
      </cfquery>
	  <cfset LvarDuracion = LvarDuracion -1>
	</cfif>
  </cfloop>
</cfif>
--->
</body>
</html>
</cfoutput>  
