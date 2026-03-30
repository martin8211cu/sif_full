<cftransaction>
	<cftry>
		<cfif isdefined("Form.btnCambiar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set CmatriculaMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Cupo#">,
					   CsolicitudMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Cupo#">,
					   DOpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DOpersona#">,
					   Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>
		<cfif isdefined("Form.btnGuardar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set TRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TRcodigo#">,
					   CtipoCalificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CtipoCalificacion#">,
					   <cfif form.CtipoCalificacion EQ '2'>
							CpuntosMax = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CpuntosMax#" scale="2">,
							CunidadMin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CunidadMin#" scale="2">,
							Credondeo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Credondeo#" scale="3">,
							TEcodigo = null,
					   <cfelseif form.CtipoCalificacion EQ '1'>
							CpuntosMax = <cfqueryparam cfsqltype="cf_sql_numeric" value="100" scale="2">,
							CunidadMin = <cfqueryparam cfsqltype="cf_sql_numeric" value="0.01" scale="2">,
							Credondeo = <cfqueryparam cfsqltype="cf_sql_numeric" value="0" scale="3">,
							TEcodigo = null,
					   <cfelseif form.CtipoCalificacion EQ 'T'>
							CpuntosMax = null,
							CunidadMin = null,
							Credondeo = null,
							TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEcodigo#">,
					   </cfif>
					   CmatriculaMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.CmatriculaMaxima#">,
					   CsolicitudMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.CmatriculaMaxima#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>
		<cfelseif isdefined("Form.btnActivar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set Cestado = 'A'
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>		

		<cfelseif isdefined("Form.btnCerrar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set Cestado = 'C'
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>
		</cfif>
	
	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfinclude template="../../errorpages/BDerror.cfm">
		<cfabort>
		
	</cfcatch>
	</cftry>

</cftransaction>

<cfoutput>
<form action="CursoMantenimiento.cfm" method="post">
	<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
		<input type="hidden" name="Ccodigo" value="#Form.Ccodigo#">
	</cfif>
	<input type="hidden" name="btnCursos" value="1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
