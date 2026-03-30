<cfparam name="modoreq2" default="ALTA">
<cfif isdefined("form.Agregar")>
	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#"  name="RS_TPDatoRequisito">
			insert TPDatoRequisito( id_requisito, 
								  codigo_dato, 
								  nombre_dato, 
								  lista_valores, 
								  tipo_dato, 
								  BMUsucodigo, 
								  BMfechamod)
	
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_dato)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_dato#">,
					<cfif isdefined("form.tipo_dato") and len(trim(form.tipo_dato)) AND form.tipo_dato EQ 'B'>
						'Sí,No',									
					<cfelse>
						<cfif isdefined("form.lista_valores") and len(trim(form.lista_valores))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lista_valores#"><cfelse>null</cfif>,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_dato#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="RS_TPDatoRequisito">
		<cfset Form.id_dato = RS_TPDatoRequisito.identity>
		<cfif isdefined("form.operador") and len(trim(form.operador)) and isdefined("form.valor") and len(trim(form.valor))>
			<cfquery datasource="#session.tramites.dsn#"  name="RS_TPDatoRequisito">
				insert TPCriterioAprobacion( id_requisito, 
									  id_dato, 
									  operador, 
									  valor, 
									  BMUsucodigo, 
									  BMfechamod)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.operador#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
		</cfif>
	</cftransaction>
	<cfset modoreq2="ALTA">
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPDatoRequisito"
			redirect="Tp_Requisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_dato" 
			type1="numeric" 
			value1="#form.id_dato#">
			
	<cfquery datasource="#session.tramites.dsn#">
		update TPDatoRequisito
		set codigo_dato 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_dato)#">, 
		    nombre_dato 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_dato#">,
			tipo_dato 		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_dato#">,
		    lista_valores	= <cfif isdefined("form.lista_valores") and len(trim(form.lista_valores))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lista_valores#"><cfelse>null</cfif>,
			BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod 		= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> 
		where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>
	<cfquery name="rsDatos2" datasource="#session.tramites.dsn#">
		select * 
		from TPCriterioAprobacion
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
		and id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>	
	 <cfif rsDatos2.recordcount eq 0>
		<cfif isdefined("form.operador") and len(trim(form.operador)) and isdefined("form.valor") and len(trim(form.valor))>
			<cfquery datasource="#session.tramites.dsn#"  name="RS_TPDatoRequisito">
				insert TPCriterioAprobacion( id_requisito, 
									  id_dato, 
									  operador, 
									  valor, 
									  BMUsucodigo, 
									  BMfechamod)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.operador#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
		</cfif>
	 <cfelse>
		<cfif isdefined("form.operador") and len(trim(form.operador)) and isdefined("form.valor") and len(trim(form.valor))>
			<cfquery datasource="#session.tramites.dsn#"  name="RS_TPDatoRequisito">
				update TPCriterioAprobacion
				set operador 	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.operador#">, 
					valor    	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor#">,
					BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechamod 		= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> 
				where id_dato    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
				and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
			</cfquery>
		</cfif>
	 </cfif>
	<cfset modoreq2="CAMBIO">

<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPCriterioAprobacion
		where id_dato  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>			
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPDatoRequisito
		where id_dato  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>			
	<cfset modoreq2="ALTA">
</cfif>

<form action="Tp_Requisitos.cfm" method="post" name="sql">
	<input name="modoreq2" type="hidden" value="<cfif isdefined("modoreq2")><cfoutput>#modoreq2#</cfoutput></cfif>">
	<input name="modo" type="hidden" value="CAMBIO">
	<cfif modoreq2 neq 'ALTA'>
		<input name="id_dato" type="hidden" value="<cfif isdefined("Form.id_dato")><cfoutput>#Form.id_dato#</cfoutput></cfif>">
	</cfif>
	<input name="id_requisito" type="hidden" value="<cfif isdefined("Form.id_requisito")><cfoutput>#Form.id_requisito#</cfoutput></cfif>">
	<input type="hidden" name="tab" value="4">
</form>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
