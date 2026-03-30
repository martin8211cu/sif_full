
<!---<cfoutput>#form.id_requisito#</cfoutput>
<cfoutput>#url.id_requisito#</cfoutput>
<cfdump var="#form.id_requisito#">
<cfdump var="#form#"> 
<cfabort>--->

<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
</cfif>

<cfif isdefined("Form.esfecha")>
	<cfif #form.esfecha# EQ 0>
			<cfset valorTemp=#Form.valor1#>
	<cfelse>
			<cfset valorTemp=#Form.valor2#>	
	</cfif> 
</cfif>
<cfif IsDefined("form.Cambio")>
 	
	<!--- <cfif isdefined("Form.valor1") and len(trim(form.valor1))>
		<cfset valorTemp=#Form.valor1#>
	<cfelse>
		<cfset valorTemp=#Form.valor2#>	
	</cfif> 
	
	<cfoutput>#valorTemp#</cfoutput>
	<cfabort>--->
	<!--- Actualiza la tabla TPCriterioAprobacion --->
	<cfquery  name="idquery" datasource="#session.tramites.dsn#">
			update TPCriterioAprobacion  set
				id_campo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListRest(Form.campo)#" null="#ListFirst(Form.campo) NEQ 'C'#">,
				campo_fijo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(Form.campo)#" null="#ListFirst(Form.campo) NEQ 'F'#">,
				operador		= <cfqueryparam value="#Form.operador#" cfsqltype="cf_sql_char">,
				
				valor			= <cfqueryparam value="#valorTemp#" cfsqltype="cf_sql_char">,
				
				BMUsucodigo		= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				BMfechamod		= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where 	id_criterio = <cfqueryparam value="#Form.id_criterio#" cfsqltype="cf_sql_numeric">
	</cfquery>
																
	<cfset dir= "Tp_Requisitos.cfm?tab=8&id_requisito=#JSStringFormat(form.id_requisito)#">
	
<cfelseif IsDefined("form.Baja")>
	
	<!--- Elimina de la tabla TPCriterioAprobacion --->
	<cfquery datasource="#session.tramites.dsn#" name="idquery">
			delete TPCriterioAprobacion
			where 	id_criterio = <cfqueryparam value="#Form.id_criterio#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfset dir= "Tp_Requisitos.cfm?tab=8&id_requisito=#JSStringFormat(form.id_requisito)#">
	
<cfelseif IsDefined("form.Alta")>
	
	<!--- <cfif isdefined("Form.valor1") and len(trim(form.valor1))>
		<cfset valorTemp=#Form.valor1#>
	<cfelse>
		<cfset valorTemp=#Form.valor2#>	
	</cfif> --->
	
	<cfquery datasource="#session.tramites.dsn#" name="idquery">
		
		insert into TPCriterioAprobacion(id_requisito, id_campo, campo_fijo,
			 operador, valor, BMUsucodigo, BMfechamod)
		values( <cfqueryparam value="#Form.id_requisito#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#ListRest(Form.campo)#" null="#ListFirst(Form.campo) NEQ 'C'#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(Form.campo)#" null="#ListFirst(Form.campo) NEQ 'F'#">,

				<cfqueryparam value="#Form.operador#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#valorTemp#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">)
	
	</cfquery>
		
	<cfset dir= "Tp_Requisitos.cfm?tab=8&id_requisito=#JSStringFormat(form.id_requisito)#">
	
<cfelseif IsDefined("form.Nuevo")>
	
	<cfset dir= "Tp_Requisitos.cfm?tab=8&id_requisito=#JSStringFormat(form.id_requisito)#">
	
</cfif>

<!--- Tp_Requisitos.cfm?tab=8&id_requisito=<cfoutput>#JSStringFormat(form.id_requisito)#</cfoutput> --->
<form action='<cfoutput>#dir#</cfoutput>' method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="id_criterio" type="hidden" value="#form.id_criterio#"> 
		</cfif>
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
