<cfset params = "">
<cfif isdefined("Form.Alta")>
	<cfquery name="rsConsultaCorp" datasource="asp">
		select 1
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
	</cfquery>
	<cftransaction>
		<cfquery name="rsinsert" datasource="#Session.DSN#">
			insert into SNClasificacionE (Ecodigo, CEcodigo, SNCEcodigo, SNCEdescripcion, SNCEcorporativo, PCCEobligatorio, 
										  PCCEactivo, SNCEalertar, PCEcatid, UsucodigoInclusion, SNCtiposocio, BMUsucodigo)
			values (
				<cfif isdefined('session.Ecodigo') and 
						isdefined('session.Ecodigocorp') and
						session.Ecodigo NEQ session.Ecodigocorp and 
						rsConsultaCorp.RecordCount GT 0>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCEdescripcion#">, 
				<cfif isdefined("Form.SNCEcorporativo")>1<cfelse>0</cfif>,
				<cfif isdefined("Form.PCCEobligatorio")>1<cfelse>0</cfif>,
				<cfif isdefined("Form.PCCEactivo")>1<cfelse>0</cfif>,
				<cfif isdefined("Form.SNCEalertar")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#" null="#LEN(form.PCEcatid) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtiposocio#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsinsert">		
	</cftransaction>	
	<cfset params=params&"&SNCEid="&rsinsert.identity>	
	<cfif isdefined('session.Ecodigo') and 
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " and Ecodigo=#session.Ecodigo#">
	<cfelse>
		  <cfset filtro = " and Ecodigo is null">								  
	</cfif>
	<cfquery name="rsSNClasificacionE" datasource="#session.dsn#">
		select 1 from SNClasificacionE
		where CEcodigo=#session.CEcodigo# #filtro#
	</cfquery>
	<cfset form.pagina = ceiling(rsSNClasificacionE.recordcount / form.maxrows)>
<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsConsultaCorp" datasource="asp">
		select 1
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete from SNClasificacionE
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">				  
	</cfquery>
	<cfif isdefined('session.Ecodigo') and 
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " and Ecodigo=#session.Ecodigo#">
	<cfelse>
		  <cfset filtro = " and Ecodigo is null">								  
	</cfif>
	<cfquery name="rsSNClasificacionE" datasource="#session.dsn#">
		select 1 from SNClasificacionE
		where CEcodigo=#session.CEcodigo# #filtro#
	</cfquery>
	<cfset Lvar_pagina = ceiling(rsSNClasificacionE.recordcount / form.maxrows)>
	<cfif form.pagina gt Lvar_pagina>
		<cfset form.pagina = Lvar_pagina>
	</cfif>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="SNClasificacionE"
		redirect="formSNClasificaciones.cfm"
		timestamp="#form.ts_rversion#"
		field1="SNCEid" 
		type1="numeric" 
		value1="#form.SNCEid#"
	>
	<cfquery name="ABC_SNClasificacion" datasource="#Session.DSN#">
		update SNClasificacionE set 
			SNCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCEdescripcion#">, 
			SNCEcodigo 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCEcodigo#">, 
			SNCEcorporativo  = <cfif isdefined("Form.SNCEcorporativo")>1<cfelse>0</cfif>,
			PCCEobligatorio  = <cfif isdefined("Form.PCCEobligatorio")>1<cfelse>0</cfif>,
			PCCEactivo		 = <cfif isdefined("Form.PCCEactivo")>1<cfelse>0</cfif>, 
			SNCEalertar	 = <cfif isdefined("Form.SNCEalertar")>1<cfelse>0</cfif>, 
			PCEcatid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#" null="#LEN(form.PCEcatid) EQ 0#">,
			SNCtiposocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCtiposocio#">
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and SNCEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
	</cfquery>
	<cfset params=params&"&SNCEid="&form.SNCEid>	
</cfif>
<cflocation url="SNClasificaciones.cfm?Pagina=#Form.Pagina##params#">