<cfparam name="modoreq" default="ALTA">
<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert TPRReqTramite( id_requisito, 
							  id_tramite, 
							  id_paso, 
							  numero_paso, 
							  vigencia_requerida, 
							  costo_requisito, 
							  moneda,
							  es_obligatorio,
							  modo_flujo,
							  id_requisito_flujo,
							  BMUsucodigo, 
							  BMfechamod )

		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_paso#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.numero_paso#">,
				<cfif len(trim(form.vigencia_requerida))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.vigencia_requerida#"><cfelse>0</cfif>,
				<cfif isdefined("form.valores_predeterminados") and len(trim(form.valores_predeterminados)) and valores_predeterminados eq 0>
					null,				
					'none',
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.costo_requisito,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#">,
				</cfif>
				<cfif isdefined("form.es_obligatorio")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.modo_flujo#">,
				<cfif isdefined("form.id_requisito_flujo") and len(trim(form.id_requisito_flujo)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
	</cfquery>
	<cfif isdefined("form.prerequisitos") and len(trim(form.prerequisitos)) >
		<cfset arreglo = listtoarray(form.prerequisitos,",")>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfquery datasource="#session.tramites.dsn#" name="validareq">
				select id_requisito from TPRReqTramite
				where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
				and numero_paso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
			</cfquery>
			<cfif validareq.recordcount gt 0>
				<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
					insert TPRPrerrequisito ( id_prerrequisito,
											  id_tramite,
											  id_requisito, 
											  BMUsucodigo,
											  BMfechamod)							
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#validareq.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
				</cfquery>

			</cfif>
		</cfloop>
	</cfif>
	<cfset modoreq="ALTA">
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRReqTramite"
			redirect="tramites.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tramite" 
			type1="numeric" 
			value1="#form.id_tramite#"
			field2="id_requisito" 
			type2="numeric" 
			value2="#form.id_requisito#" >
	<cfquery datasource="#session.tramites.dsn#">
		update TPRReqTramite
		set numero_paso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.numero_paso#">,
			vigencia_requerida = <cfif len(trim(form.vigencia_requerida))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.vigencia_requerida#"><cfelse>0</cfif>,
			<cfif isdefined("form.valores_predeterminados") and len(trim(form.valores_predeterminados)) and valores_predeterminados eq 0>
				costo_requisito = null,				
				moneda = 'none',
			<cfelse>
				costo_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.costo_requisito,',','','all')#">,
				moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#">,
			</cfif>
			es_obligatorio = <cfif isdefined("form.es_obligatorio")>1<cfelse>0</cfif>,
			modo_flujo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.modo_flujo#">,
			id_paso = <cfqueryparam cfsqltype="cf_sql_char" value="#form.id_paso#">,
			id_requisito_flujo = <cfif isdefined("form.id_requisito_flujo") and len(trim(form.id_requisito_flujo)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#"><cfelse>null</cfif>

		  where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
		  and id_requisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">
	</cfquery>
	<cfif isdefined("form.prerequisitos") and len(trim(form.prerequisitos))>
		<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
			delete TPRPrerrequisito
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
			and id_requisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">
		</cfquery>	
		<cfset arreglo = listtoarray(form.prerequisitos,",")>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfquery datasource="#session.tramites.dsn#" name="validareq">
				select id_requisito from TPRReqTramite
				where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
				and numero_paso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
			</cfquery>
			<cfif validareq.recordcount gt 0>
				<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
					insert TPRPrerrequisito ( id_prerrequisito,
											  id_tramite,
											  id_requisito, 
											  BMUsucodigo,
											  BMfechamod)							
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#validareq.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfset modoreq="CAMBIO">
<cfelseif isdefined("form.Eliminar") or isdefined("form.eliminar.x") >
	<cftry>
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPRPrerrequisito
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
		and id_requisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">
	</cfquery>			
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPRPrerrequisito
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
		and id_prerrequisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">
	</cfquery>			
	<cfquery datasource="#session.tramites.dsn#">
		delete TPRReqTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
		  and id_requisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_requisito#">
	</cfquery>
	<cfcatch type="any">
		REVISANDO!!!	
		<cfdump var="#form#">
		<cfabort>
	</cfcatch>
	</cftry>

	<cfset modoreq="ALTA">
</cfif>

<cfif isdefined("form.eliminar.x")>
	<cflocation url="tramites.cfm?id_tramite=#form.id_tramite#&tab=3">
<cfelse>
	<form action="trabajar-requisito.cfm" method="post" name="sql">
		<input name="modoreq" type="hidden" value="<cfif isdefined("modoreq")><cfoutput>#modoreq#</cfoutput></cfif>">
		<input name="modo" type="hidden" value="CAMBIO">
		<input type="hidden" name="tab" value="3">
		<cfif modoreq neq 'ALTA'>
			<input name="id_requisito" type="hidden" value="<cfif isdefined("Form.id_requisito")><cfoutput>#Form.id_requisito#</cfoutput></cfif>">
		</cfif>
			<input name="id_tramite" type="hidden" value="<cfif isdefined("Form.id_tramite")><cfoutput>#Form.id_tramite#</cfoutput></cfif>">
			<input name="id_paso" type="hidden" value="<cfif isdefined("Form.id_paso")><cfoutput>#Form.id_paso#</cfoutput></cfif>">
	</form>
	
	<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>
		<script language="JavaScript1.2" type="text/javascript">
			window.opener.document.form3.submit();
			document.forms[0].submit();
			window.close();
		</script>
	</body></HTML>
</cfif>

