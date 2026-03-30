<cfset form.CcodigoD = 5812>
<cfset form.PEcodigo_IN = 40>

<cfset form.CcodigoDest = 6190>
<cfset form.PEcodigo_OUT = 41>

<cfquery name="rsActividades" datasource="educativo">
	select convert(varchar, CPcodigo) as Codigo, 
		   convert(varchar, PEcodigo) as PEcodigo, 
		   convert(varchar, Ccodigo) as Curso,
		   CPfecha,
		   CPnombre,  CPdescripcion,  CPcubierto,  CPfecha,  CPorden,  CPduracion  
	from CursoPrograma
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
	and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
	order by CPfecha, CPorden, CPnombre
</cfquery>
<!--- <cfdump var="#rsActividades#"> --->
<cfset LvarLeccionesN = 100>
<cfquery datasource="educativo" name="rsCalendario">
	set nocount on
	select convert(varchar, Ccodigo) as Ccodigo
	from CentroEducativo 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	set nocount off
</cfquery>
<cfquery datasource="educativo" name="qryLimitesPeriodoOrigen">
	set nocount on
	select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
	  from PeriodoOcurrencia p, Curso c
	 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
	   and p.PEcodigo     = c.PEcodigo 
	   and p.SPEcodigo    = c.SPEcodigo 
	   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
	set nocount off
</cfquery>
<cfdump var="#qryLimitesPeriodoOrigen#">
<cfquery datasource="educativo" name="qryLimitesPeriodo">
	set nocount on
	select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
	  from PeriodoOcurrencia p, Curso c
	 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	   and p.PEcodigo     = c.PEcodigo 
	   and p.SPEcodigo    = c.SPEcodigo 
	   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
	set nocount off
</cfquery>
<cfdump var="#qryLimitesPeriodo#">
<cfquery datasource="SDC" name="qryFeriadosOrigen">
	set nocount on
	select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
	and CDferiado = 1 
	and CDabsoluto = 1
	and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodoOrigen.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodoOrigen.Final#"> ,101) 
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodoOrigen.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	and CDferiado = 1 
	and CDabsoluto = 0
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodoOrigen.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
	and CDferiado = 1 
	and CDabsoluto = 0
	set nocount off
</cfquery>
<cfquery datasource="SDC" name="qryFeriados">
	set nocount on
	select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	and CDferiado = 1 
	and CDabsoluto = 1
	and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	and CDferiado = 1 
	and CDabsoluto = 0
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	and CDferiado = 1 
	and CDabsoluto = 0
	set nocount off
</cfquery>
<cffunction name="fnEsFeriadoOrigen" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfquery name="qryFeriadoOrigen" dbtype="query">
		select 1 as cuenta from qryFeriadosOrigen 
		where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
	<cfreturn (qryFeriadosOrigen.recordCount GT 0)>
</cffunction>
<cffunction name="fnEsFeriado" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfquery name="qryFeriado" dbtype="query">
		select 1 as cuenta from qryFeriados 
		where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
	<cfreturn (qryFeriado.recordCount GT 0)>
</cffunction>
<cffunction name="fnEsLeccionOrigen" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfargument name="LprmHorarios" required="true" type="string">
	<cfset LvarDW = datepart("w", LprmFecha)>
	<cfreturn ((Find("*" & LvarDW & "*", LprmHorarios) neq 0) and (not fnEsFeriadoOrigen(LprmFecha)))>
</cffunction>

<cffunction name="fnEsLeccion" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfargument name="LprmHorarios" required="true" type="string">
	<cfset LvarDW = datepart("w", LprmFecha)>
	<cfreturn ((Find("*" & LvarDW & "*", LprmHorarios) neq 0) and (not fnEsFeriado(LprmFecha)))>
</cffunction>
<cfquery datasource="educativo" name="qryHorariosOrigen">
	set nocount on
	select distinct convert(int,HRdia)+2 as HRdia
	from HorarioGuia
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
	set nocount off
</cfquery>
<cfquery datasource="educativo" name="qryHorarios">
	set nocount on
	select distinct convert(int,HRdia)+2 as HRdia
	from HorarioGuia
	where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
	set nocount off
</cfquery>

<cfset GvarHorariosOrigen="*">
<cfloop query="qryHorariosOrigen">
	<cfif HRdia eq 8>
		<cfset GvarHorariosOrigen = GvarHorariosOrigen & "1*">
	<cfelse>
		<cfset GvarHorariosOrigen = GvarHorariosOrigen & HRdia & "*">
	</cfif>
</cfloop>
<cfset LvarFechasOrigen = ArrayNew(1)>

<cfset LvarFechaOrig=DateAdd("d",0,qryLimitesPeriodoOrigen.Inicial)>
<cfloop index="LvarLec" from="1" to="#LvarLeccionesN#">
	<cfloop condition="LvarFechaOrig lt qryLimitesPeriodoOrigen.Final and not fnEsLeccionOrigen(LvarFechaOrig, GvarHorariosOrigen)">
		<cfset LvarFechaOrig=DateAdd("d", 1, LvarFechaOrig)>
	</cfloop>
	<cfset LvarFechasOrigen[LvarLec] = LvarFechaOrig>
	<cfif LvarFechaOrig lt qryLimitesPeriodoOrigen.Final>
		<cfset LvarFechaOrig=DateAdd("d", 1, LvarFechaOrig)>
	</cfif>
</cfloop>
<!--- <cfdump var="#LvarFechasOrigen#"> --->


<cfset GvarHorarios="*">
<cfloop query="qryHorarios">
	<cfif HRdia eq 8>
		<cfset GvarHorarios = GvarHorarios & "1*">
	<cfelse>
		<cfset GvarHorarios = GvarHorarios & HRdia & "*">
	</cfif>
</cfloop>
<cfset LvarFechasEquiv = ArrayNew(1)>

<cfset LvarFecha=DateAdd("d",0,qryLimitesPeriodo.Inicial)>
<cfloop index="LvarLec" from="1" to="#LvarLeccionesN#">
	<cfloop condition="LvarFecha lt qryLimitesPeriodo.Final and not fnEsLeccion(LvarFecha, GvarHorarios)">
		<cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
	</cfloop>
	<cfset LvarFechasEquiv[LvarLec] = LvarFecha>
	<cfif LvarFecha lt qryLimitesPeriodo.Final>
		<cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
	</cfif>
</cfloop>
<cfdump var="#LvarFechasEquiv#"> 
<cfabort>


<cfset iLeccion = 0>
<cfset NuevaFecha = "">
<cfquery name="ABC_CopiaTemaEval" datasource="#Session.DSN#">
	delete CursoPrograma 
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
		and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
</cfquery>
	 
<cfloop query="rsActividades">
	<cfquery name="ABC_CopiaTemaEval" datasource="#Session.DSN#">
		set nocount on
		<cfloop index="Lvar" from="1" to="#LvarLeccionesN#">
			<cfif LvarFechasOrigen[Lvar] EQ rsActividades.CPfecha>
				insert CursoPrograma (Ccodigo, PEcodigo,  CPnombre,  CPdescripcion,  CPcubierto,  CPfecha,  CPorden,  CPduracion,  CPleccion)
				values  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">,
						'#rsActividades.CPnombre#',  '#rsActividades.CPdescripcion#',  'N',  <cfoutput>#LvarFechasEquiv[Lvar]#</cfoutput>,  #rsActividades.CPorden#, #rsActividades.CPduracion#,  <cfoutput>#Lvar#</cfoutput>)
				<cfbreak>
			</cfif>
		</cfloop>
		set nocount off					
	</cfquery>
</cfloop>

