
<cfset Gvar_action = "PlanEvaluacion.cfm">
<cfset Gvar_params = "">

<cffunction access="private" description="Agregar parmetros para enviar por get." name="ParamsAppend">
	<cfargument name="name" required="yes" type="string">
	<cfargument name="value" required="yes" type="string">
	<cfif len(trim(Gvar_params)) eq 0>
		<cfset Gvar_params = ListAppend(Gvar_params, "?sql=1", "&")>
	</cfif>
	<cfset Gvar_params = ListAppend(Gvar_params, name&"="&value, "&")>
</cffunction>

<cffunction access="private" description="Cambiar Action del SQL" name="SetAction">
	<cfargument name="action" required="yes" type="string">
	<cfset Gvar_action = action>
</cffunction>

<cfif isdefined("Form.Alta")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
		insert EvaluacionPlan (CEcodigo, EPnombre)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EPnombre#">)
		<cf_dbidentity1 conexion="#Session.Edu.DSN#">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsInsert">
	</cftransaction>
	<cfset ParamsAppend("EPcodigo", rsInsert.Identity)>

<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
		update EvaluacionPlan
		set EPnombre = <cfqueryparam value="#form.EPnombre#" cfsqltype="cf_sql_varchar">
		where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset ParamsAppend("EPcodigo", form.EPcodigo)>

<cfelseif isdefined("Form.Baja")>
	<cftransaction>
		<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
			delete EvaluacionPlanConcepto 
			where EPcodigo=<cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">				
		</cfquery>
		<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
			delete EvaluacionPlan
			where EPcodigo=<cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cftransaction>
	<cfset setAction("listaEvaluacionPlan.cfm")>

<cfelseif isdefined("Form.AltaDet")>
	<cftransaction>
		<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
			update EvaluacionPlan
			set EPnombre = <cfqueryparam value="#form.EPnombre#" cfsqltype="cf_sql_varchar">
			where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">	
			insert EvaluacionPlanConcepto 
			(EPcodigo, EVTcodigo, ECcodigo, EPCnombre, EPCporcentaje)
			values (<cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">,
					<cfif #Form.EVTcodigo# NEQ -1>
						<cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">,
					<cfelse>
						null,	
					</cfif>
					<cfqueryparam value="#form.ECcodigo#" cfsqltype="cf_sql_numeric">,	
					<cfqueryparam value="#form.EPCnombre#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#form.EPCporcentaje#" cfsqltype="cf_sql_numeric">)
			<cf_dbidentity1 conexion="#Session.Edu.DSN#">
		</cfquery>
		<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsInsert">
	</cftransaction>
	<cfset ParamsAppend("EPcodigo", form.EPcodigo)>
	<cfset ParamsAppend("EPCcodigo", rsInsert.identity)>
	<cfquery name="rsPagina2" datasource="#Session.Edu.DSN#">
		SELECT count(1) as Cont
		FROM EvaluacionPlanConcepto 
		WHERE EPcodigo = #form.EPcodigo#
	</cfquery>
	<cfset Form.pagina2 = Ceiling(rsPagina2.Cont / form.MaxRows2)>
	
<cfelseif isdefined("Form.CambioDet")>
	<cftransaction>
		<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
			update EvaluacionPlan
			set EPnombre = <cfqueryparam value="#form.EPnombre#" cfsqltype="cf_sql_varchar">
			where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
			update EvaluacionPlanConcepto
			set EPcodigo  	= <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">,
				<cfif Form.EVTcodigo NEQ -1 >
					EVTcodigo  	= <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">,
				<cfelse>
					EVTcodigo  	= null,	
				</cfif>
				ECcodigo  	= <cfqueryparam value="#form.ECcodigo#" cfsqltype="cf_sql_numeric">,					
				EPCnombre  	= <cfqueryparam value="#form.EPCnombre#" cfsqltype="cf_sql_varchar">,					
				EPCporcentaje  = <cfqueryparam value="#form.EPCporcentaje#" cfsqltype="cf_sql_numeric">
			where EPCcodigo     = <cfqueryparam value="#form.EPCcodigo#"    cfsqltype="cf_sql_numeric">
		</cfquery>
	</cftransaction>
	<cfset ParamsAppend("EPcodigo", form.EPcodigo)>
	<cfset ParamsAppend("EPCcodigo", form.EPCcodigo)>

<cfelseif isdefined("Form.BajaDet")>
	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		delete EvaluacionPlanConcepto 
		where EPCcodigo = <cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfset ParamsAppend("EPcodigo", form.EPcodigo)>

<cfelseif isdefined("Form.NuevoDet")>
	<cfset ParamsAppend("EPcodigo", form.EPcodigo)>
	
<cfelseif isdefined("Form.Lista")>
	<cfset setAction("listaEvaluacionPlan.cfm")>
	
</cfif>

<cfset ParamsAppend("Pagina", form.Pagina)>
<cfset ParamsAppend("Filtro_EPnombre", form.Filtro_EPnombre)>
<cfset ParamsAppend("Filtro_EPCporcentaje", form.Filtro_EPCporcentaje)>

<cfset ParamsAppend("Pagina2", form.Pagina2)>
<cfset ParamsAppend("Filtro_ECnombre", form.Filtro_ECnombre)>
<cfset ParamsAppend("Filtro_EVTnombre", form.Filtro_EVTnombre)>
<cfset ParamsAppend("Filtro_EPCnombre", form.Filtro_EPCnombre)>
<cfset ParamsAppend("Filtro_Porcentaje", form.Filtro_Porcentaje)>

<cflocation url="#Gvar_action##Gvar_params#">