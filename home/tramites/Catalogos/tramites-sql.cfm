
<cfparam name="modo" default="ALTA">
<cfset tab = '1'>
<!--- ************************************ ALTA  ******************************* --->
<cfif isdefined("form.Agregar")>
	<cftransaction>
	<cfquery datasource="#session.tramites.dsn#" name="ABC_Fucn">
		insert into TPTramite(id_inst, id_tipotramite, codigo_tramite, nombre_tramite,descripcion_tramite, 
							  id_documento_generado,BMUsucodigo, BMfechamod)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipotramite#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_tramite)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tramite#">,
				null,				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#" null="#Len(Trim(form.id_documento)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_Fucn">
	<cfset Form.id_tramite = ABC_Fucn.identity>
	<cfset modo="CAMBIO">
	<cfset tab = '1'>
	
	<cfif isdefined("Form.tipoiden")>
		<cfset arreglo = listtoarray(form.tipoiden,",")>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">
				insert into TPTipoIdentTramite (id_tramite,
											id_tipoident, 
											BMUsucodigo,
											BMfechamod 
				)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_tramite#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arreglo[i]#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
			</cfquery>
		</cfloop>
	</cfif>	
	
	<cfinvoke component="home.tramites.componentes.tramites"
		method="dar_permiso"
		tipo_sujeto="F"
		id_sujeto="#session.tramites.id_funcionario#"
		tipo_objeto="T"
		id_objeto="#form.id_tramite#" />
	
	</cftransaction>
	<!--- ************************************ INFORMACION ADICIONAL  ******************************* --->
	<cfelseif isdefined("Form.Informacion")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTramite"
			redirect="tramites.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tramite" 
			type1="numeric" 
			value1="#form.id_tramite#" >
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			update TPTramite 
			set descripcion_tramite = <cfif isdefined("form.descripcion_tramite") and len(trim(form.descripcion_tramite))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.descripcion_tramite#"><cfelse>null</cfif>,
				BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 				
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tramite#">
		</cfquery>
		<cfset modo="CAMBIO">		
		<cfset tab = '2'>
<!--- ************************************ CAMBIO  ******************************* --->
<cfelseif isdefined("form.Modificar")>
	<cftransaction>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTramite"
			redirect="tramites.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tramite" 
			type1="numeric" 
			value1="#form.id_tramite#" >

	<cfquery datasource="#session.tramites.dsn#">
		update TPTramite
		set codigo_tramite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_tramite)#">, 
		    nombre_tramite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tramite#">,
			id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">, 
		    id_tipotramite=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_tipotramite#">,
			id_documento_generado= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#" null="#Len(Trim(form.id_documento)) EQ 0#">
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
	
	<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">			
		delete TPTipoIdentTramite
		where  id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tramite#">				  
	</cfquery>				
	<cfif isdefined("Form.tipoiden")>
		<cfset arreglo = listtoarray(form.tipoiden,",")>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">
				insert into TPTipoIdentTramite (id_tramite,
											id_tipoident, 
											BMUsucodigo,
											BMfechamod 
				)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_tramite#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arreglo[i]#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
			</cfquery>
		</cfloop>
	</cfif>
	</cftransaction>
	<cfset modo="CAMBIO">
	<cfset tab = '1'>

<!--- ************************************ BAJA  ******************************* --->
<cfelseif isdefined("form.Eliminar")>
	<cftransaction>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPRReqTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
	</cfquery>	
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tramite#">
	</cfquery>
	</cftransaction>
	<cfset modo="ALTA">
	<cfset tab = '1'>
</cfif>

<form action="tramites.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="id_tramite" type="hidden" value="<cfif isdefined("Form.id_tramite")><cfoutput>#Form.id_tramite#</cfoutput></cfif>">
	</cfif>
	<input type="hidden" name="tab" value="<cfoutput>#tab#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


