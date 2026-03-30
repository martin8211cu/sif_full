<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.ECurso") and Len(Trim(Form.ECurso)) NEQ 0>
			<cfquery name="deleteCurso" datasource="#Session.Edu.DSN#">
				set nocount on
				delete CursoPrograma
				from Curso a
				where CursoPrograma.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECurso#">

				delete EvaluacionCurso
				from Curso a
				where EvaluacionCurso.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECurso#">
				
				delete EvaluacionConceptoCurso
				from Curso a
				where EvaluacionConceptoCurso.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECurso#">
			
				delete HorarioGuia
				from Curso a
				where HorarioGuia.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECurso#">
				
				delete Curso
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECurso#">
				set nocount off
			</cfquery>
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
