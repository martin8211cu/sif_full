<cfif isdefined("Session.RolActual") and Session.RolActual EQ 11>
	<cfset action = "/cfmx/edu/asistencia/utilitarios/copiaTemaEval.cfm">
<cfelse>
	<cfset action = "/cfmx/edu/docencia/utilitarios/copiaTemaEval.cfm">
</cfif>

<cfif isdefined("form.btnCopiar")>
	<cftry>
	<!--- Sección  de funciones --->
			<cfset LvarLeccionesN = 100>
			<cfquery datasource="#Session.Edu.DSN#" name="rsCalendario">
				set nocount on
				select convert(varchar, Ccodigo) as Ccodigo
				from CentroEducativo 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				set nocount off
			</cfquery>
			<cfquery datasource="#Session.Edu.DSN#" name="qryLimitesPeriodoOrigen">
				set nocount on
				select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
				  from PeriodoOcurrencia p, Curso c
				 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
				   and p.PEcodigo     = c.PEcodigo 
				   and p.SPEcodigo    = c.SPEcodigo 
				   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
				set nocount off
			</cfquery>
			<cfquery datasource="#Session.Edu.DSN#" name="qryLimitesPeriodo">
				set nocount on
				select convert(varchar, POfechainicio, 101) as Inicial, convert(varchar, POfechafin, 101) as Final
				  from PeriodoOcurrencia p, Curso c
				 where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
				   and p.PEcodigo     = c.PEcodigo 
				   and p.SPEcodigo    = c.SPEcodigo 
				   and p.PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
				set nocount off
			</cfquery>
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
			<cfquery datasource="#Session.Edu.DSN#" name="qryHorariosOrigen">
				set nocount on
				select distinct convert(int,HRdia)+2 as HRdia
				from HorarioGuia
				where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
				set nocount off
			</cfquery>
			<!-- Buscar si tiene el Curso Origen Horario asignado -->
			<!-- Rodolfo Jimenez Jara, Soluciones INtegrales S.A., SOIN, America Central, 11/09/2003 -->
			<cfif qryHorariosOrigen.RecordCount EQ 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=El curso de Origen no tiene horario asignado. Por favor asigne un horario al curso e intente luego." addtoken="no">
				<cfabort> 
			</cfif>

			<cfquery datasource="#Session.Edu.DSN#" name="qryHorarios">
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
			
			<!--- Arreglo de las fechas de las lecciones del curso origen --->
			<cfset LvarFechaOrig=DateAdd("d",0,qryLimitesPeriodoOrigen.Inicial)>
			<cfloop index="LvarLec" from="1" to="#LvarLeccionesN#">
				<cfloop condition="LvarFechaOrig lt qryLimitesPeriodoOrigen.Final and not fnEsLeccionOrigen(LvarFechaOrig, GvarHorariosOrigen)">
					<cfset LvarFechaOrig=DateAdd("d", 1, LvarFechaOrig)>
				</cfloop>
				<cfset LvarFechasOrigen[LvarLec] = LvarFechaOrig>
				<!--- <cfdump var="#LvarFechasOrigen[LvarLec]#"> <br> --->
				<cfif LvarFechaOrig lt qryLimitesPeriodoOrigen.Final>
					<cfset LvarFechaOrig=DateAdd("d", 1, LvarFechaOrig)>
				</cfif>
			</cfloop>
			<cfset GvarHorarios="*">
			<cfloop query="qryHorarios">
				<cfif HRdia eq 8>
					<cfset GvarHorarios = GvarHorarios & "1*">
				<cfelse>
					<cfset GvarHorarios = GvarHorarios & HRdia & "*">
				</cfif>
			</cfloop>
			
			
			<cfset LvarFechasEquiv = ArrayNew(1)>
				
			<!--- Arreglo de las fechas de las lecciones del curso destino --->
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

		<cfif isdefined("Form.Temario")>
		 <!-- Rodolfo Jimenez Jara, Soluciones INtegrales S.A., SOIN, America Central, 01/07/2003 -->
			<cfquery name="rsActividades" datasource="#Session.Edu.DSN#">
				select convert(varchar, CPcodigo) as Codigo, 
					   convert(varchar, PEcodigo) as PEcodigo, 
					   convert(varchar, Ccodigo) as Curso,
					   convert(varchar,CPfecha,103) as CPfecha,
					   CPnombre,  CPdescripcion,  CPcubierto, CPfecha as fecha, CPorden,  CPduracion  
				from CursoPrograma
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
				order by fecha, CPorden, CPnombre
			</cfquery>
		</cfif>
		<cfif isdefined("Form.evaluacion")>
		 	<cfquery name="rsEvaluacionConceptoCurso" datasource="#Session.Edu.DSN#">
				select convert(varchar, ECcodigo) as ECcodigo, ECCporcentaje
				from EvaluacionConceptoCurso 
				where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
					and  PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
			</cfquery>
			
			<cfquery name="rsEvaluacionCurso" datasource="#Session.Edu.DSN#">
				select convert(varchar, EVTcodigo) as EVTcodigo, 
				       convert(varchar, ECcodigo) as ECcodigo, 
					   ECporcentaje, 
					   ECplaneada, 
					   ECreal, 
					   ECnombre, 
					   ECenunciado, 
					   ECduracion, 
					   ECorden, 
					   ECleccion, 
					   ECtipoPorcentaje 
				from EvaluacionCurso 
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
					and  PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#"> 
			</cfquery>

		</cfif> 
			<!--- Copiar --->
			<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., SOIN, America Central, 01/07/2003 --->			
			<cfif isdefined("Form.btnCopiar")>
				<cfif isdefined("Form.temario")>
					<cfquery name="ABC_CopiaTemaEval" datasource="#Session.Edu.DSN#">
						set nocount on
						delete CursoPrograma 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
							and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
						set nocount off					
					</cfquery>
					
					<cfloop query="rsActividades">
						<cfloop index="Lvar" from="1" to="#LvarLeccionesN#">
							<cfset FechaItem = ListToArray(rsActividades.CPfecha, '/')>
							<cfif LvarFechasOrigen[Lvar] EQ CreateDate(FechaItem[3],FechaItem[2],FechaItem[1])>
								<cfquery name="ABC_CopiaTemaEval" datasource="#Session.Edu.DSN#">
									set nocount on
									insert CursoPrograma (Ccodigo, PEcodigo,  CPnombre,  CPdescripcion,  CPcubierto,  CPfecha,  CPorden,  CPduracion,  CPleccion)
									values  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsActividades.CPnombre#">, 
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsActividades.CPdescripcion#">, 
											<cfqueryparam cfsqltype="cf_sql_char" value="N">,
											#LvarFechasEquiv[Lvar]#, 
											<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsActividades.CPorden#">,
											<cfqueryparam cfsqltype="cf_sql_float" value="#rsActividades.CPduracion#">, 
											#Lvar#
										)
									set nocount off					
								</cfquery>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfloop>
				</cfif>
				<cfif isdefined('form.evaluacion')>
					<cfquery name="ABC_CopiaTemaEval" datasource="#Session.Edu.DSN#">
						set nocount on
						delete EvaluacionTemaCurso 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">							
						delete EvaluacionCurso 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
							and  PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
						delete from EvaluacionConceptoCurso 
						where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">
							and  PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">
		
						insert EvaluacionConceptoCurso (ECcodigo, Ccodigo, PEcodigo, ECCporcentaje)
						select ECcodigo,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">, ECCporcentaje
						from EvaluacionConceptoCurso 
						where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoD#">
							and  PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_IN#">
							
						set nocount off					
					</cfquery>
    
					<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., SOIN, America Central, 01/07/2003 --->
					<cfloop query="rsEvaluacionCurso">
						<cfloop index="Lvar" from="1" to="#LvarLeccionesN#">
							<cfif LvarFechasOrigen[Lvar] EQ rsEvaluacionCurso.ECplaneada>
								<cfquery name="ABC_CopiaTemaEval" datasource="#Session.Edu.DSN#">
									set nocount on
									insert EvaluacionCurso (EVTcodigo, ECcodigo, Ccodigo, PEcodigo, ECporcentaje, ECplaneada,  ECreal, ECnombre, ECenunciado, ECduracion, ECevaluado, ECorden, ECleccion, ECtipoPorcentaje)
									values  (
										<cfif len(trim(rsEvaluacionCurso.EVTcodigo)) NEQ 0>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluacionCurso.EVTcodigo#">, 
										<cfelse>
											null,	
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluacionCurso.ECcodigo#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CcodigoDest#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo_OUT#">,
										<cfqueryparam cfsqltype="cf_sql_float" value="#rsEvaluacionCurso.ECporcentaje#">, 
										#LvarFechasEquiv[Lvar]#,  
										#LvarFechasEquiv[Lvar]#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEvaluacionCurso.ECnombre#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEvaluacionCurso.ECenunciado#">,
										<cfqueryparam cfsqltype="cf_sql_float" value="#rsEvaluacionCurso.ECduracion#">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="N">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsEvaluacionCurso.ECorden#">,
										 #Lvar#,
										<cfqueryparam cfsqltype="cf_sql_char" value="#rsEvaluacionCurso.ECtipoPorcentaje#">
										 )
									set nocount off					
								</cfquery>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfloop>
	
				</cfif>

				<cfset modo="ALTA">
				<cfif isdefined("Session.RolActual") and Session.RolActual EQ 11>
					<cfset action = "/cfmx/edu/asistencia/utilitarios/copiaTemaEval.cfm">
				<cfelse>
					<cfset action = "/cfmx/edu/docencia/utilitarios/copiaTemaEval.cfm">
				</cfif>
			</cfif>
			

	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelse> 
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 11>
		<cfset action = "/cfmx/edu/asistencia/utilitarios/copiaTemaEval.cfm">
	<cfelse>
		<cfset action = "/cfmx/edu/docencia/utilitarios/copiaTemaEval.cfm">
	</cfif>
	<cfset modo   = "ALTA" >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>