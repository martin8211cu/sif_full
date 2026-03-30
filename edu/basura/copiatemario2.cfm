<cfquery name="rsActividades" datasource="educativo">
	select 
	       convert(varchar, CPcodigo) as Codigo, 
		   convert(varchar, PEcodigo) as PEcodigo, 
		   convert(varchar, Ccodigo) as Curso,
		   convert(varchar, CPfecha, 103) as Fecha,
		   CPleccion
	from CursoPrograma
	where Ccodigo = 5988
	and PEcodigo = 57
	order by CPfecha, CPorden, CPnombre
</cfquery>

<!---------------------- *********************** ----------------------->
<cfdump var="#rsActividades#">
<cfset LvarLeccionesN = 100>
<cfquery datasource="educativo" name="rsCalendario">
	set nocount on
	select convert(varchar, Ccodigo) as Ccodigo
	from CentroEducativo 
	where CEcodigo = 5
	set nocount off
</cfquery>
<cfquery datasource="educativo" name="qryLimitesPeriodo">
	set nocount on
	select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
	  from PeriodoOcurrencia p, Curso c
	 where c.Ccodigo      = 5988
	   and p.PEcodigo     = c.PEcodigo 
	   and p.SPEcodigo    = c.SPEcodigo 
	   and p.PEevaluacion = 57
	set nocount off
</cfquery>
<cfquery datasource="SDC" name="qryFeriados">
	set nocount on
	select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo = 5988
	and CDferiado = 1 
	and CDabsoluto = 1
	and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo = 5988
	and CDferiado = 1 
	and CDabsoluto = 0
	union
	select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
	from CalendarioDia 
	where Ccodigo = 5988
	and CDferiado = 1 
	and CDabsoluto = 0
	set nocount off
</cfquery>
<cffunction name="fnEsFeriado" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfquery name="qryFeriado" dbtype="query">
		select 1 as cuenta from qryFeriados 
		where Fecha = '#datepart("yyyy",LprmFecha)#-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#' or Fecha = '2000-#datepart("m",LprmFecha)#-#datepart("d",LprmFecha)#'
	</cfquery>
	<cfreturn (qryFeriado.recordCount GT 0)>
</cffunction>
<cffunction name="fnEsLeccion" returntype="boolean">
	<cfargument name="LprmFecha" required="true" type="date">
	<cfargument name="LprmHorarios" required="true" type="string">
	<cfset LvarDW = datepart("w", LprmFecha)>
	<cfreturn ((Find("*" & LvarDW & "*", LprmHorarios) neq 0) and (not fnEsFeriado(LprmFecha)))>
</cffunction>
<cfquery datasource="educativo" name="qryHorarios">
	set nocount on
	select distinct convert(int,HRdia)+2 as HRdia
	from HorarioGuia
	where Ccodigo = 5988
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
<!--- <cfabort> --->
<!---------------------- *********************** ----------------------->
<cfloop query="rsActividades">
	<cfoutput>Procesando : #rsActividades.CurrentRow#</cfoutput>
	<cfflush interval="10"><br>
	<cfloop index="i" from="1" to="100">
		<cfif rsActividades.Fecha EQ LSDateFormat(LvarFechasEquiv[i],"dd/mm/yyyy")>
			<cfquery name="rsUpdate" datasource="educativo">
				update CursoPrograma
				set CPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#i#">
				where CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActividades.Codigo#">
			</cfquery>
			<cfbreak>
		</cfif>
	</cfloop>
</cfloop>
