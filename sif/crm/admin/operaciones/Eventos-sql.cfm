<!--- Modo de regreso al Form --->
<cfset MODO = "ALTA">
<cfif not isdefined("Form.Nuevo") >
  <cftry>
	<cfquery name="ABC" datasource="crm">
		set nocount on
		<cfif isdefined("Form.ALTA")>
			Insert CRMEventos
			(CEcodigo, Ecodigo, CRMEid, CRMEidrel, CRMEidres, CRMTEVid, CRMEVfecha, CRMEVdescripcion, Usucodigo, Ulocalizacion, CRMEVestado)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEid#">, 
				<cfif (isDefined("Form.CRMEidrel")) and (len(trim(Form.CRMEidrel)))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidrel#"><cfelse>null</cfif>, 
				<cfif (isDefined("Form.CRMEidres")) and (len(trim(Form.CRMEidres)))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidres#"><cfelse>null</cfif>, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMTEVid#">, 
				convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEVfecha#">, 103),
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRMEVdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
				0
			)
			
			select CRMEVid = @@identity
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("Form.CAMBIO") >
			Update CRMEventos
			set CRMEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEid#">, 
			CRMEidrel=<cfif (isDefined("Form.CRMEidrel")) and (len(trim(Form.CRMEidrel)))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidrel#"><cfelse>null</cfif>, 
			CRMEidres=<cfif (isDefined("Form.CRMEidres")) and (len(trim(Form.CRMEidres)))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidres#"><cfelse>null</cfif>, 
			CRMTEVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMTEVid#">, 
			CRMEVfecha=convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEVfecha#">, 103), 
			CRMEVdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRMEVdescripcion#">, 
			Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			Where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CRMEVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEVid#">
			
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("Form.BAJA")>	
			Delete from CRMEventos
			Where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CRMEVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEVid#">
			<cfset modo = "BAJA"><!---MODO BAJA VUELVE A LA LISTA --->
		<cfelseif isdefined("Form.btnAgregarOtraEntidad")>
			Insert CRMEventos
			(CEcodigo, Ecodigo, CRMEVid2, CRMEid, CRMEidrel, CRMEidres, CRMTEVid, CRMEVfecha, CRMEVdescripcion, Usucodigo, Ulocalizacion, CRMEVestado)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEVid2#">, 				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidrel2#">, 
				<cfif (isDefined("Form.CRMEidres")) and (len(trim(Form.CRMEidres)))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEidres#"><cfelse>null</cfif>, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMTEVid#">, 
				convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEVfecha#">, 103),
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRMEVdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
				0
			)
			
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("Form.btnEliminarOtraEntidad.X")>
			Delete from CRMEventos
			Where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CRMEVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Dato#">
			
			<cfset modo = "CAMBIO">
		</cfif>
		set nocount off
	</cfquery>
  <cfcatch type="any">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
  </cfcatch>
  </cftry>
</cfif>

<cfoutput>
<Form action="Eventos.cfm" method="post" name="formSql">
	<cfif MODO NEQ "BAJA">
		<input type="hidden" name="MODO" value="#MODO#">
	</cfif>
	<cfif MODO EQ "CAMBIO">
		<input type="hidden" name="CRMEVid" value="<cfif (isDefined("ABC.CRMEVid"))>#ABC.CRMEVid#<cfelse>#Form.CRMEVid#</cfif>">
	</cfif>
</Form>
</cfoutput>

<HTML>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.formSql.submit();</script>
	</body>
</HTML>