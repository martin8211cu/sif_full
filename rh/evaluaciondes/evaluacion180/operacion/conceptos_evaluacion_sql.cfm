<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_Este_Concepto_ya_fue_agregado"
	Default="Este Concepto ya fue agregado"
	returnvariable="MG_Este_Concepto_ya_fue_agregado"/> 

<cfset params = '?REid=#form.REid#'>
<cfif isdefined("form.Alta")>
	<cftransaction>
		<cfquery name="existe" datasource="#Session.DSN#">
			select * from RHIndicadoresRegistroE 
			where REid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			and  IAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#"> 
		</cfquery>
		<cfif existe.recordcount gt 0>
			<cf_throw  message="#MG_Este_Concepto_ya_fue_agregado#" errorcode="8015">
		<cfelse>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHIndicadoresRegistroE (
					Ecodigo, 
					REid, 
					IAEid, 
					TEcodigo, 
					IREsobrecien, 
					IREpesop, 
					IREpesojefe,
					IREevaluajefe, 
					IREevaluasubjefe, 
					BMfechaalta, 
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#" null="#len(trim(form.IAEid)) eq 0#">, 
					<cfif isdefined('form.TEcodigo')>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#len(trim(form.TEcodigo)) eq 0#">
					<cfelse>null</cfif>, 
					<cfif isdefined('form.IREsobrecien')>1<cfelse>0</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.IREpesop#" null="#len(trim(form.IREpesop)) eq 0#">,  
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.IREpesojefe#" null="#len(trim(form.IREpesojefe)) eq 0#">, 
					<cfif isdefined('form.IREevaluajefe')>1<cfelse>0</cfif>, 
					<cfif isdefined('form.IREevaluasubjefe')>1<cfelse>0</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<!--- 	<cfset params = params & '&IREid=#insert.identity#&SEL=3'>	 --->
			<cfset params = params & '&SEL=3'>	
		</cfif>
	</cftransaction>
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#Session.DSN#">
		update RHIndicadoresRegistroE set
			IAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#" null="#len(trim(form.IAEid)) eq 0#">,
			TEcodigo = 
			<cfif isdefined('form.TEcodigo')>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#len(trim(form.TEcodigo)) eq 0#">
			<cfelse>null</cfif>,
			IREsobrecien = <cfif isdefined('form.IREsobrecien')>1<cfelse>0</cfif>,
			IREpesop    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IREpesop#" null="#len(trim(form.IREpesop)) eq 0#">,
			IREpesojefe = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IREpesojefe#" null="#len(trim(form.IREpesojefe)) eq 0#">,
			IREevaluajefe = <cfif isdefined('form.IREevaluajefe')>1<cfelse>0</cfif>,
			IREevaluasubjefe = <cfif isdefined('form.IREevaluasubjefe')>1<cfelse>0</cfif>,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where IREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IREid#">
	</cfquery>

	<cfset params = params & '&IREid=#form.IREid#&SEL=3'>
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#Session.DSN#">
		delete from RHIndicadoresRegistroE		
		where IREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IREid#">
	</cfquery>
	<cfset params = params & '&SEL=3'>
<cfelseif isdefined("form.Nuevo")>
	<cfset params = params & '&SEL=3'>
<cfelseif isdefined("form.Siguiente")>
	<cfset params = params & '&SEL=4'>
<cfelseif isdefined("form.Anterior")>
	<cfset params = params & '&SEL=2'>	
</cfif>
<cfset params = params & '&Estado=#form.Estado#'>

<cflocation url="registro_evaluacion.cfm#params#">
