<cfquery name="rsActividades" datasource="educativo">
	select 1 as Tipo, 
	       convert(varchar, cp.CPcodigo) as Codigo, 
		   convert(varchar, cp.PEcodigo) as PEcodigo, 
		   mp.MPleccion as Leccion, 
		   convert(varchar, mp.MPcodigo) as CodPadre, 
		   ceiling(mp.MPduracion) as Duracion,
		   convert(varchar, c.Ccodigo) as Curso
	from Curso c, Materia m, CursoPrograma cp, MateriaPrograma mp, PeriodoVigente p
	where c.CEcodigo = 3
	and c.Mconsecutivo = m.Mconsecutivo
	and c.PEcodigo = p.PEcodigo
	and c.SPEcodigo = p.SPEcodigo
	and (m.Melectiva = 'R' or m.Melectiva = 'S')
	and c.Ccodigo = cp.Ccodigo
	and m.Gcodigo = 79
	and cp.MPcodigo = mp.MPcodigo
	order by 3, 6, 4, 1, 5, 2 
</cfquery>
<cfquery name="rsLecciones" dbtype="query">
	select (max(Leccion) + max(Duracion)) as Lecciones
	from rsActividades
</cfquery>
<cfset LvarLeccionesN = rsLecciones.Lecciones>
<cfquery datasource="educativo" name="rsCalendario">
	set nocount on
	select convert(varchar, Ccodigo) as Ccodigo
	from CentroEducativo 
	where CEcodigo = 3
	set nocount off
</cfquery>
<cfset LvarPEcodigo = 0>
<cfset LvarCcodigo = 0>
<cfloop query="rsActividades" >

<cfoutput>Procesando : #rsActividades.CurrentRow#</cfoutput>
<cfflush interval="10"><br>

	<cfif LvarPEcodigo NEQ rsActividades.PEcodigo>
		<cfset LvarPEcodigo = rsActividades.PEcodigo>
		<cfset iLeccion = 0>
		<cfset iPadre = 0>
		<cfquery datasource="educativo" name="qryLimitesPeriodo">
			set nocount on
			select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
			  from PeriodoOcurrencia p, Curso c
			 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActividades.Curso#">
			   and p.PEcodigo     = c.PEcodigo 
			   and p.SPEcodigo    = c.SPEcodigo 
			   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPEcodigo#">
			set nocount off
		</cfquery>
		<cfquery datasource="SDC" name="qryFeriados">
			set nocount on
			select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion, CDferiado as Feriado
			from CalendarioDia 
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
			and CDferiado = 1 
			and CDabsoluto = 1
			and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
			union
			select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
			from CalendarioDia 
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
			and CDferiado = 1 
			and CDabsoluto = 0
			union
			select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo, CDferiado as Feriado
			from CalendarioDia 
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
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
	</cfif>
	<cfif LvarCcodigo NEQ rsActividades.Curso>
		<cfset LvarCcodigo = rsActividades.Curso>
		<cfset iLeccion = 0>
		<cfset iPadre = 0>
		<cfquery datasource="educativo" name="qryHorarios">
			set nocount on
			select distinct convert(int,HRdia)+2 as HRdia
			from HorarioGuia
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcodigo#">
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
	</cfif>
	<!--- Aplica para los temarios que duran varios dias. Actualiza la lección a la siguiente --->
	<cfif iPadre NEQ CodPadre>
		<cfset iLeccion = Leccion>
		<cfset iPadre = CodPadre>
	<cfelse>
		<cfset iLeccion = iLeccion + 1>
	</cfif>
	<cfquery name="recalTem" datasource="educativo">
		update CursoPrograma
		   set CPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechasEquiv[iLeccion]#">
		where CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Codigo#">
	</cfquery>
</cfloop>
<cfoutput>Temino Recalendarizacion</cfoutput>