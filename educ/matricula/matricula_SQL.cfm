<cfset LvarOnLine = true>
<cfparam name="form.PMcodigo" default="">
<cfparam name="form.Apersona" default="">
<cfparam name="form.Ccodigo" default="">
<cfparam name="form.VerHorario" default="0">
<cfparam name="form.PMCcodigo_retiro" default="">

<cftransaction>
	<cftry>
		<cfquery name="ABC_Matricula" datasource="#Session.DSN#">
			declare @PMCcodigo numeric
			<cfif form.PMcodigo NEQ "" and form.Apersona NEQ "" and form.PMCcodigo_retiro NEQ "">
				declare @Ccodigo numeric
				
				select @Ccodigo = Ccodigo
				  from MatriculaAlumnoCurso
				 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
				   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
				   and PMCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMCcodigo_retiro#">

				insert MatriculaAlumnoCurso(PMcodigo, Apersona, Ccodigo, PMCfecha, PMCtipo, PMCcodigo_retiro, PMCmodificado, Usucodigo, PMCprocesado, PMCpagado)
				values
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
					,@Ccodigo
					,getDate()
					,'R'
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMCcodigo_retiro#">
					,0
					,#session.Usucodigo#
					,0
					,0
					)
				select @PMCcodigo = @@identity
				update MatriculaAlumnoCurso
				   set PMCmodificado = 1
				 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
				   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
				   and PMCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMCcodigo_retiro#">

				update Curso
				   set Csolicitados = Csolicitados - 1
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				   and Ccodigo = @Ccodigo

				<cfif LvarOnLine>
					if exists 
							(select * from CursoAlumno
							  where Ccodigo = @Ccodigo
							    and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
								and CAestado < 10 
							)
					BEGIN
						update CursoAlumno
						   set CAestado = 10	<!--- Retirado --->
						 where Ccodigo = @Ccodigo
						   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">

						update Curso
						   set Cmatriculados = Cmatriculados - 1
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						   and Ccodigo = @Ccodigo

						update MatriculaAlumnoCurso
						   set PMCprocesado = 1
						 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
						   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
						   and PMCcodigo = @PMCcodigo
					END
				</cfif>
			</cfif>
			<cfif form.PMcodigo NEQ "" and form.Apersona NEQ "" and form.Ccodigo NEQ "">
				insert MatriculaAlumnoCurso(PMcodigo, Apersona, Ccodigo, PMCfecha, PMCtipo, PMCcodigo_retiro, PMCmodificado, Usucodigo, PMCprocesado, PMCpagado)
				values
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
					,getDate()
					,'M'
					<cfif form.PMCcodigo_retiro eq "">
					,null
					<cfelse>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMCcodigo_retiro#">
					</cfif>
					,0
					,#session.Usucodigo#
					,0
					,0
					)
				select @PMCcodigo = @@identity
				update Curso
				   set Csolicitados = Csolicitados + 1
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				   and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
				<cfif LvarOnLine>
					if not exists
								(select 1
								   from CursoAlumno
								  where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
								    and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
								)
						insert CursoAlumno(Ccodigo, Apersona, CAestado)
						values
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
							,0)  <!--- Matriculado --->
					else
						update CursoAlumno
						   set CAestado = 0
						 where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
						   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
					update Curso
					   set Cmatriculados = Cmatriculados + 1
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					   and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
					update MatriculaAlumnoCurso
					   set PMCprocesado = 1
					 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
					   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Apersona#">
					   and PMCcodigo = @PMCcodigo
				</cfif>
			</cfif>
			</cfquery>
	<cfcatch type="xxx">
		<cfinclude template="/educ/errorpages/BDerror.cfm">
		<cftransaction action="rollback">
		<cfabort>
		
	</cfcatch>
	</cftry>

</cftransaction>
<cfoutput>
<form action="matricula.cfm" method="post">
	<input name="F1" type="hidden" value="#form.F1#">
	<input name="F2" type="hidden" value="#form.F2#">
	<input name="F3" type="hidden" value="#form.F3#">
	<input name="F4" type="hidden" value="#form.F4#">
	<input name="F5" type="hidden" value="#form.F5#">
	<input type="hidden" name="VerHorario" value="#Form.VerHorario#">
	<input type="hidden" name="PMcodigo" value="#Form.PMcodigo#">
	<input type="hidden" name="TPer" value="#form.TPer#">
	<input type="hidden" name="Apersona" value="#Form.Apersona#">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
