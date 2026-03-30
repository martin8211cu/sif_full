<cfparam name="action" default="listaEvaluacionPlan.cfm">

<cfif not isdefined("form.btnNuevoD")>

	<cftry>
		<cfquery name="ABC_EvaluacionPlan" datasource="#session.DSN#">
			
			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("Form.btnAgregarE")>

				set nocount on
				insert EvaluacionPlan ( CEcodigo, EPnombre )
							 values ( <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#form.EPnombre#"    cfsqltype="cf_sql_varchar">
									)
				select @@identity as id
				set nocount off				

				<cfset modo="CAMBIO">
				<cfset action = "EvaluacionPlan.cfm">
				
			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarE")>
				
				delete EvaluacionPlanConcepto
				where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
				
				delete EvaluacionPlan
				where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">

				  <cfset modo="ALTA">
				  
			<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
			
				insert EvaluacionPlanConcepto ( EPcodigo, ECcodigo, EPCnombre,  EPCporcentaje )
							 values ( <cfqueryparam value="#form.EPcodigo#"      cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#form.ECcodigo#"      cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#form.EPCnombre#"     cfsqltype="cf_sql_varchar">,
									  <cfqueryparam value="#form.EPCporcentaje#" cfsqltype="cf_sql_smallint">
									)

				<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
				update EvaluacionPlan
				set EPnombre = <cfqueryparam value="#form.EPnombre#"   cfsqltype="cf_sql_varchar">
				where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">

				<cfset modo="CAMBIO">
				<cfset action = "EvaluacionPlan.cfm">

			<!--- Caso 4: Modificar Detalle de Plan y opcionalmente modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>

				update EvaluacionPlanConcepto
				set ECcodigo  = <cfqueryparam value="#form.ECcodigo#"      cfsqltype="cf_sql_numeric">, 
				EPCnombre     = <cfqueryparam value="#form.EPCnombre#"     cfsqltype="cf_sql_varchar">,
				EPCporcentaje = <cfqueryparam value="#form.EPCporcentaje#" cfsqltype="cf_sql_smallint">
				where EPCcodigo = <cfqueryparam value="#form.EPCcodigo#"   cfsqltype="cf_sql_numeric">
				  and EPcodigo  = <cfqueryparam value="#form.EPcodigo#"    cfsqltype="cf_sql_numeric">

				update EvaluacionPlan
				set EPnombre = <cfqueryparam value="#form.EPnombre#"   cfsqltype="cf_sql_varchar">
				where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">

				<cfset modo="CAMBIO">
				<cfset action = "EvaluacionPlan.cfm">
				
			<!--- Caso 5: Borrar detalle de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarD")>
	
	
				delete EvaluacionPlanConcepto
				where EPCcodigo = <cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
				  and EPcodigo  = <cfqueryparam value="#form.EPcodigo#"  cfsqltype="cf_sql_numeric">
				  
			  	delete EvaluacionPlan
				where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">

	
				<cfset modo="CAMBIO">
				<cfset action = "EvaluacionPlan.cfm">

			</cfif>
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "EvaluacionPlan.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>	

<cfif isdefined("form.EPcodigo") AND form.EPcodigo EQ "" >
	<cfset form.EPcodigo = "#ABC_EvaluacionPlan.id#">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"      type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EPcodigo"  type="hidden" value="<cfif isdefined("Form.EPcodigo")>#form.EPcodigo#</cfif>">
	<input name="Pagina"    type="hidden" value="<cfif isdefined("Form.Pagina")>#form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>