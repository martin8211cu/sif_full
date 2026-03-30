<cfset modo = "CAMBIO">
	<cftry>			
		<cfif isdefined("Form.btnAgregarPlanEst") and form.btnAgregarPlanEst EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					insert PlanEstudiosAlumno 
						(Apersona, PEScodigo, PEAfecha)
					values (
						<cfqueryparam value="#form.Apersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.PEScodigoPlanEst#" cfsqltype="cf_sql_numeric">
						, getDate())
						
					insert PlanEstudiosAlumnoHistorico 
					(Apersona, PEScodigo, PESHfecha, PESHtipo, Usucodigo)
					values (
						<cfqueryparam value="#form.Apersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.PEScodigoPlanEst#" cfsqltype="cf_sql_numeric">
						, getDate()
						, 'N'
						, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)						
				set nocount off
			</cfquery>
		<cfelseif isdefined("Form.btnDesactPlanEst") and form.btnDesactPlanEst EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on			
					update PlanEstudiosAlumno set
						PEAactivo=0
						, PEAfecha = getDate()
					where PEScodigo = <cfqueryparam value="#Form.IdPlanEstDesact#"   cfsqltype="cf_sql_numeric">

					insert PlanEstudiosAlumnoHistorico 
					(Apersona, PEScodigo, PESHfecha, PESHtipo, Usucodigo)
					values (
						<cfqueryparam value="#form.Apersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.IdPlanEstDesact#" cfsqltype="cf_sql_numeric">
						, getDate()
						, 'I'
						, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)						
				set nocount off	
			</cfquery>						
		<cfelseif isdefined("Form.btnActPlanEst") and form.btnActPlanEst EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on			
					update PlanEstudiosAlumno set
						PEAactivo=1
						, PEAfecha = getDate()
					where PEScodigo = <cfqueryparam value="#Form.IdPlanEstAct#"   cfsqltype="cf_sql_numeric">
					
					insert PlanEstudiosAlumnoHistorico 
					(Apersona, PEScodigo, PESHfecha, PESHtipo, Usucodigo)
					values (
						<cfqueryparam value="#form.Apersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.IdPlanEstAct#" cfsqltype="cf_sql_numeric">
						, getDate()
						, 'A'
						, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)											
				set nocount off	
			</cfquery>						
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<form action="alumno.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="Apersona" type="hidden" value="<cfif isdefined("Form.Apersona") and form.Apersona NEQ ''>#Form.Apersona#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="TP" type="hidden" value="A">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>