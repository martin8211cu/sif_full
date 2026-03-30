<cfset LvarLeccionesN = 30> <!--- Debe ser ceil(max(NumeroLeccion + Duracion)) --->
<!--- <cfset LvarCcodigo = 4891> --->
<cfset LvarCcodigo = 4885>
<cfset LvarPEcodigo = 128>   <!--- Periodo de Evaluacion --->

<cfquery datasource="#Session.DSN#" name="rsCalendario">
	select Ccodigo 
	from CentroEducativo 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryLimitesPeriodo">
	select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
	  from PeriodoOcurrencia p, Curso c
	 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcodigo#">
	   and p.PEcodigo     = c.PEcodigo 
	   and p.SPEcodigo    = c.SPEcodigo 
	   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPEcodigo#">
</cfquery>

<cfquery datasource="SDC" name="qryFeriados">
	select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion
	from sdc..CalendarioDia 
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
	and CDferiado = 1 
	and CDabsoluto = 1
	and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
	from sdc..CalendarioDia 
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
	and CDferiado = 1 
	and CDabsoluto = 0
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
	from sdc..CalendarioDia 
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
	and CDferiado = 1 
	and CDabsoluto = 0
</cfquery>

<cffunction name="fnEsFeriado" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
    <cfquery name="qryFeriado" dbtype="query">
		select 1 as cuenta from qryFeriados 
		where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
    <cfreturn (qryFeriado.recordCount GT 0)>
</cffunction>

<cfquery datasource="#Session.DSN#" name="qryHorarios">
	select distinct convert(int,HRdia)+2 as HRdia
	from HorarioGuia
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcodigo#">
</cfquery>
<cfset GvarHorarios="*">
<cfloop query="qryHorarios">
	<cfif HRdia eq 8>
		<cfset GvarHorarios = GvarHorarios & "1*">
	<cfelse>
		<cfset GvarHorarios = GvarHorarios & HRdia & "*">
	</cfif>
</cfloop>

<cffunction name="fnEsLeccion" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfargument name="LprmHorarios" required="true" type="string">
	<cfset LvarDW = datepart("w", LprmFecha)>
	<cfreturn ((Find("*" & LvarDW & "*", LprmHorarios) neq 0) and (not fnEsFeriado(LprmFecha)))>
</cffunction>

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

<cfdump var="#qryLimitesPeriodo#">
<cfdump var="#qryFeriados#">
<cfdump var="#qryHorarios#">
<cfdump var="#LvarFechasEquiv#">



<!---

				<cfdump var="#rsEvaluaciones#">
				<cfif rsEvaluaciones.recordCount GT 0>

					<cfquery name="rsLecciones" dbtype="query">
						select max(EMleccion) as Lecciones
						from rsEvaluaciones
					</cfquery>
					<cfset LvarLeccionesN = rsLecciones.Lecciones>

					<cfquery datasource="#Session.DSN#" name="rsCalendario">
						select convert(varchar, Ccodigo) as Ccodigo
						from CentroEducativo 
						where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					</cfquery>
					
					<cfset LvarCcodigo = 0>
					<cfset LvarPEcodigo = 0>

					<cfloop query="rsEvaluaciones">
						<cfif LvarPEcodigo NEQ PEcodigo>
							<cfset LvarPEcodigo = PEcodigo>
							<cfset LvarCcodigo = 0>
						</cfif>

						<cfif LvarCcodigo NEQ Ccodigo>
							<cfset LvarCcodigo = Ccodigo>
							<cfquery datasource="#Session.DSN#" name="qryLimitesPeriodo">
								select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
								  from PeriodoOcurrencia p, Curso c
								 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcodigo#">
								   and p.PEcodigo     = c.PEcodigo 
								   and p.SPEcodigo    = c.SPEcodigo 
								   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPEcodigo#">
							</cfquery>

							<cfquery datasource="SDC" name="qryFeriados">
								select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion
								from sdc..CalendarioDia 
								where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
								and CDferiado = 1 
								and CDabsoluto = 1
								and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
								union
								select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
								from sdc..CalendarioDia 
								where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
								and CDferiado = 1 
								and CDabsoluto = 0
								union
								select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
								from sdc..CalendarioDia 
								where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
								and CDferiado = 1 
								and CDabsoluto = 0
							</cfquery>
							

						</cfif>
					</cfloop>
				</cfif>
				<cfabort>

--->