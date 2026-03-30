<cfset modo = "ALTA">

<cfif isdefined("form.Alta")>
	<cfquery name="rsPlanDocumentacion" datasource="#session.DSN#">
		select (max(isnull(PDOsecuencia,0)) +1) as PDOsecuencia
		from PlanDocumentacion
		where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
	</cfquery>
	<cfif isdefined('rsPlanDocumentacion') and rsPlanDocumentacion.recordCount GT 0 and rsPlanDocumentacion.PDOsecuencia NEQ ''>
		<cfset varPDOsecuencia = rsPlanDocumentacion.PDOsecuencia>
	<cfelse>
		<cfset varPDOsecuencia = 1>	
	</cfif>	
</cfif>
	
<cfif not isdefined("form.Nuevo")>
	<cftry>	
		<cfquery name="abc_planestudio" datasource="#session.DSN#">
			set nocount on
			<cfif isdefined("form.Alta")>				
				insert PlanDocumentacion 
				(PEScodigo, PDOsecuencia, PDOtitulo, PDOdescripcion)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#varPDOsecuencia#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PDOtitulo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PDOdescripcion#">)

				<cfset modo = "CAMBIO">
			<cfelseif isdefined("form.Cambio")>
				update PlanDocumentacion	set 
					PDOtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PDOtitulo#">,
					PDOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PDOdescripcion#">
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
					and PDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PDOcodigo#">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  

				<cfset modo = "CAMBIO">
			<cfelseif isdefined("form.Baja")>
				delete PlanDocumentacion 
				where PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
					and PDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PDOcodigo#">
					
				<cfset modo = "CAMBIO">						
			</cfif>
			set nocount off
		</cfquery>
		<cfcatch type="any">
			<cfinclude template="../../errorpages/BDerror.cfm">		
			<cfabort>
		</cfcatch>
	</cftry>	
</cfif>

<cfoutput>
<form action="CarrerasPlanes.cfm" method="post" name="sql">
	<cfif isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
		<input type="hidden" name="EScodigo" value="#Form.EScodigo#">
	</cfif>
	<cfif isdefined("Form.CARcodigo") and Len(Trim(Form.CARcodigo)) NEQ 0>
		<input type="hidden" name="CARcodigo" value="#Form.CARcodigo#">
	</cfif>
	<cfif isdefined("Form.tabsPlan") and Len(Trim(Form.tabsPlan)) NEQ 0>
		<input type="hidden" name="tabsPlan" id="tabsPlan" value="#form.tabsPlan#">
	</cfif>
	<input type="hidden" name="PEScodigo" value="#Form.PEScodigo#">
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
	<input name="PDOcodigo" type="hidden" value="<cfif isdefined("form.PDOcodigo") and form.PDOcodigo NEQ ''>#form.PDOcodigo#</cfif>">		
	<input type="hidden" name="modo" value="#modo#">
	<input type="hidden" name="nivel" value="<cfif isdefined("form.nivel") and form.nivel NEQ 'ALTA'>#form.nivel#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

