<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.UpdTyE") and Len(Trim(Form.UpdTyE)) NEQ 0>
			<!--- Recalendarizar Evaluaciones --->
			<cfquery name="rsActividades" datasource="#Session.Edu.DSN#">
				set nocount on
				select 0 as Tipo, convert(varchar, ec.ECcomponente) as Codigo, convert(varchar, ec.PEcodigo) as PEcodigo, em.EMleccion as Leccion, convert(varchar, em.EMcomponente) as CodPadre, 1 as Duracion
				from Curso c, Materia m, EvaluacionCurso ec, EvaluacionMateria em
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.UpdTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and c.Ccodigo = ec.Ccodigo
				and ec.EMcomponente = em.EMcomponente
				union
				select 1 as Tipo, convert(varchar, cp.CPcodigo) as Codigo, convert(varchar, cp.PEcodigo) as PEcodigo, mp.MPleccion as Leccion, convert(varchar, mp.MPcodigo) as CodPadre, ceiling(mp.MPduracion) as Duracion
				from Curso c, Materia m, CursoPrograma cp, MateriaPrograma mp
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.UpdTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and c.Ccodigo = cp.Ccodigo
				and cp.MPcodigo = mp.MPcodigo
				order by 3, 4, 1, 5, 2 
				set nocount off
			</cfquery>
			<cfquery name="rsLecciones" dbtype="query">
				select (max(Leccion) + max(Duracion)) as Lecciones
				from rsActividades
			</cfquery>
			<cfset LvarLeccionesN = rsLecciones.Lecciones>
			<cfquery datasource="#Session.Edu.DSN#" name="rsCalendario">
				set nocount on
				select convert(varchar, Ccodigo) as Ccodigo
				from CentroEducativo 
				where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				set nocount off
			</cfquery>
			<cfset LvarCcodigo = Form.UpdTyE>
			<cfset LvarPEcodigo = 0>
			<cfset iLeccion = 0>
			<cfset iPadre = 0>
			<cfloop query="rsActividades">
				<cfif LvarPEcodigo NEQ rsActividades.PEcodigo>
					<cfset LvarPEcodigo = rsActividades.PEcodigo>
					<cfquery datasource="#Session.Edu.DSN#" name="qryLimitesPeriodo">
						set nocount on
						select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
						  from PeriodoOcurrencia p, Curso c
						 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcodigo#">
						   and p.PEcodigo     = c.PEcodigo 
						   and p.SPEcodigo    = c.SPEcodigo 
						   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPEcodigo#">
						set nocount off
					</cfquery>
					<cfquery datasource="SDC" name="qryFeriados">
						set nocount on
						select convert(datetime, convert(varchar,CDfecha,112)) as Fecha, CDtitulo as Descripcion
						from CalendarioDia 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
						and CDferiado = 1 
						and CDabsoluto = 1
						and CDfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101) and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#"> ,101) 
						union
						select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Inicial#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
						from CalendarioDia 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalendario.Ccodigo#">
						and CDferiado = 1 
						and CDabsoluto = 0
						union
						select convert(datetime, substring(convert(varchar,convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryLimitesPeriodo.Final#">, 101),112),1,4) + substring(convert(varchar,CDfecha,112),5,8)), CDtitulo
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
					
					<cfquery datasource="#Session.Edu.DSN#" name="qryHorarios">
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
				</cfif>
				<!--- Aplica para los temarios que duran varios dias. Actualiza la lección a la siguiente --->
				<cfif iPadre NEQ CodPadre>
					<cfset iLeccion = Leccion>
					<cfset iPadre = CodPadre>
				<cfelse>
					<cfset iLeccion = iLeccion + 1>
				</cfif>
				<cfif Tipo EQ 0>
					<cfquery name="recalEval" datasource="#Session.Edu.DSN#">
						set nocount on
						update EvaluacionCurso
						   set ECplaneada = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechasEquiv[iLeccion]#">
						where ECcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Codigo#">
						set nocount off
					</cfquery>
				<cfelseif Tipo EQ 1>
					<cfquery name="recalTem" datasource="#Session.Edu.DSN#">
						set nocount on
						update CursoPrograma
						   set CPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechasEquiv[iLeccion]#">
						where CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Codigo#">
						set nocount off
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Cursos.cfm" method="post" name="sql">
	<input name="cbcursolectivo" type="hidden" value="<cfif isdefined("Form.cbcursolectivo")><cfoutput>#Form.cbcursolectivo#</cfoutput></cfif>">
	<input name="rcursotipo" type="hidden" value="<cfif isdefined("Form.rcursotipo")><cfoutput>#Form.rcursotipo#</cfoutput></cfif>">
	<input name="Gcodigo" type="hidden" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
	<input name="btnCursos" type="hidden" value="">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
