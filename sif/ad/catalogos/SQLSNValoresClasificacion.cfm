
<cfset params = "&SNCEid="&form.SNCEid>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="rsInsertClas" datasource="#Session.DSN#">
				insert into SNClasificacionD 
					(SNCEid, SNCDvalor, SNCDdescripcion, SNCDactivo, PCDcatid, UsucodigoInclusion, BMUsucodigo) 
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDvalor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDdescripcion#">,
					<cfif isdefined("Form.SNCDactivo")>1<cfelse>0</cfif>,
					<cfif isdefined('Form.PCDcatid')>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rsInsertClas">		
		</cftransaction>
		<cfset params=params&"&SNCDid="&rsInsertClas.identity>	
		<cfquery name="rsSNClasificacionD" datasource="#session.dsn#">
			select 1 from SNClasificacionD
			where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
		</cfquery>
		<cfset form.pagina = ceiling(rsSNClasificacionD.recordcount / form.maxrows)>
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
		delete from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCDid#">
		  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
		</cfquery>
		<cfset form.pagina = 1>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="SNClasificacionD"
				redirect="formSNValoresClasificacion.cfm"
				timestamp="#form.ts_rversion#"
				field1="SNCDid" 
				type1="numeric" 
				value1="#form.SNCDid#">
		<cfquery name="rsUpdateClas" datasource="#session.DSN#">
			update SNClasificacionD set
				SNCDvalor 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDvalor#">,
				SNCDdescripcion   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNCDdescripcion#">,
				SNCDactivo 		  = <cfif isdefined("Form.SNCDactivo")>1<cfelse>0</cfif>,
				PCDcatid 		=
				<cfif isdefined('Form.PCDcatid')>
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">,
				<cfelse>
				null,
				</cfif>
				UsucodigoInclusion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				BMUsucodigo 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where SNCDid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCDid#">
			  and SNCEid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
		 </cfquery>
		<cfset params=params&"&SNCDid="&form.SNCDid>	
	</cfif>			
</cfif>
<cfif isdefined('form.PCEcatid')>
	<cfset params = params&"&PCEcatid="&form.PCEcatid>
</cfif>
<cflocation url="SNValoresClasificacion.cfm?Pagina=#Form.Pagina##params#">
