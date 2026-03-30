<cfset modo="ALTA">
<cfif isdefined('form.MensPara') and form.MensPara EQ 1 and isdefined('form.cboDirector') and form.cboDirector EQ '-999'>	<!--- Directores --->
	<cfquery datasource="#Session.Edu.DSN#" name="qryDestino_Directores">
		select distinct dn.Dcodigo, Usucodigo, Ulocalizacion
		from 	DirectorNivel dn, 
				Director d
		where dn.Dcodigo=d.Dcodigo
			and dn.Ncodigo in (
				select g.Ncodigo
				from Encargado e, 
					EncargadoEstudiante ee, 
					Alumnos a, 
					GrupoAlumno ga,
					Grupo g,
					PeriodoVigente pv
				where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
					and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
					and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">			
					and e.EEcodigo=ee.EEcodigo
					and ee.CEcodigo=a.CEcodigo
					and ee.Ecodigo=a.Ecodigo
					and a.Ecodigo=ga.Ecodigo
					and a.CEcodigo=ga.CEcodigo
					and ga.GRcodigo=g.GRcodigo
					and g.PEcodigo=pv.PEcodigo
					and g.SPEcodigo=pv.SPEcodigo
			)
		order by nombreDir
	</cfquery>
<cfelseif isdefined('form.MensPara') and form.MensPara EQ 2 and isdefined('form.cboHijo') and form.cboHijo EQ '-999'>	<!--- Todos los Hijos --->
	<cfquery datasource="#Session.Edu.DSN#" name="qryDestino_Hijos">
		select ee.Ecodigo, es.Usucodigo, es.Ulocalizacion
		from Encargado e, 
			EncargadoEstudiante ee, 
			Alumnos a, 
			Estudiante es,
			PersonaEducativo pe, 
			GrupoAlumno ga,
			Grupo g,
			PeriodoVigente pv
		where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
			and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and e.EEcodigo=ee.EEcodigo
			and ee.CEcodigo=a.CEcodigo
			and ee.Ecodigo=a.Ecodigo
			and a.Ecodigo=es.Ecodigo
			and a.persona=es.persona
			and es.persona=pe.persona
			and a.CEcodigo=pe.CEcodigo
			and a.Ecodigo=ga.Ecodigo
			and a.CEcodigo=ga.CEcodigo
			and ga.GRcodigo=g.GRcodigo
			and g.PEcodigo=pv.PEcodigo
			and g.SPEcodigo=pv.SPEcodigo
	</cfquery>			
</cfif>

	<cftransaction>
		<cftry>
			<cfquery name="ABC_Docum" datasource="#Session.Edu.DSN#">
				set nocount on
				<cfif isdefined("Form.btnEnviar") and not isdefined('qryDestino_Directores') and not isdefined('qryDestino_Hijos')>
					insert Buzon 
					(Ulocalizacion, Usucodigo, Bmensaje, Btitulo, Borigen, Btipo, Bfecha)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.UlocalizacionDest#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoDest#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtMSG#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtAsunto#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombreOrigen#">, 
						'4', 
						getDate())				
						
	<!--- 					select @ultComunicado = @@identity --->	
						
						
					  <cfset modo="ALTA">
				</cfif>
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>	

<form action="comunicados.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
