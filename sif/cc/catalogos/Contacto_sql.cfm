<!---  <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfset params = "">
<cfif isdefined("form.Alta")>
	<cfset LvarSNidPadre = ''>
	<cfset LvarSNidCorporativo = ''>
	<cfquery name="rsCorpPadre" datasource="#session.DSN#">
		select 
			SNidCorporativo,
			SNidPadre
		from SNegocios
		where SNid = #form.SNid#
	</cfquery>
	<cfif isdefined("rsCorpPadre") and len(trim(rsCorpPadre.SNidPadre))>
		<cfset LvarSNidPadre = rsCorpPadre.SNidPadre>
	</cfif>
	<cfif isdefined("rsCorpPadre") and len(trim(rsCorpPadre.SNidCorporativo))>
		<cfset LvarSNidCorporativo = rsCorpPadre.SNidCorporativo>
	</cfif>
	<cftransaction action="begin">
		<cfquery name="rs" datasource="#session.dsn#">
			insert into ContactoSocioE (
				Ecodigo, 
				SNidCorporativo,
				SNidPadre,
				SNid, 
				id_direccion, 
				HDid, 
				Usucodigo, 
				CSEFecha, 
				CSEFechaSolucion, 
				CSEEstatus, 
				CSEDetalleContacto, 
				TCid, 
				CSEnombreContacto, 
				BMUsucodigo)
			values (
				#session.Ecodigo#,
				<cfif isdefined("LvarSNidCorporativo") and len(trim(LvarSNidCorporativo))>
					#LvarSNidCorporativo#,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("LvarSNidPadre") and len(trim(LvarSNidPadre))>
					#LvarSNidPadre#,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
				<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion)) and form.id_direccion NEQ -1>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.HDid") and len(trim(form.HDid))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HDid#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				null,
				#form.CSEEstatus#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEDetalleContacto#">,
				#form.TCid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEnombreContacto#">,
				#session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rs" returnvariable="LvarCSEid">
	
		<cfquery datasource="#session.dsn#">
			insert into ContactoSocioS (
				CSEid, 
				Ecodigo, 
				Usucodigo, 
				BMUsucodigo, 
				BMfecha, 
				CSEFecha, 
				CSEFechaSolucion, 
				CSEEstatus, 
				CSEDetalleContacto, 
				TCid, 
				CSEnombreContacto
				)
			values (
				#LvarCSEid#,
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				null,
				#form.CSEEstatus#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEDetalleContacto#">,
				#form.TCid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEnombreContacto#">
			)
		</cfquery>
		<cftransaction action="commit"/>
	</cftransaction>
	<cfset params = "&SNcodigo=#form.SNcodigo#&SNid=#form.SNid#&CSEid=#LvarCSEid#">
<cfelseif isdefined("form.Cambio")>

	<cfquery name="rsCorpPadre" datasource="#session.DSN#">
		select 
			SNidCorporativo,
			SNidPadre
		from SNegocios
		where SNid = #form.SNid#
	</cfquery>
	<cfif isdefined("rsCorpPadre") and len(trim(rsCorpPadre.SNidCorporativo))>
		<cfset LvarSNidCorporativo = rsCorpPadre.SNidCorporativo>
	</cfif>
	<cfif isdefined("rsCorpPadre") and len(trim(rsCorpPadre.SNidPadre))>
		<cfset LvarSNidPadre = rsCorpPadre.SNidPadre>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update ContactoSocioE 
			set 
				<cfif isdefined("LvarSNidCorporativo") and len(trim(LvarSNidCorporativo))>
					SNidCorporativo = #LvarSNidCorporativo#,
				</cfif>
				<cfif isdefined("LvarSNidPadre") and len(trim(LvarSNidPadre))>
					SNidPadre 		= #LvarSNidPadre#,
				</cfif>
				<cfif isdefined("form.HDid") and len(trim(form.HDid))>
					HDid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HDid#">,
				</cfif> 
				SNid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
				id_direccion 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
				Usucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">, 
				CSEFecha 			= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfif CSEEstatus eq 0>
					CSEFechaSolucion 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				</cfif>
				CSEEstatus 			= #form.CSEEstatus#, 
				CSEDetalleContacto 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEDetalleContacto#">, 
				TCid 				= #form.TCid#, 
				CSEnombreContacto 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEnombreContacto#">,
				BMUsucodigo 		= #session.Usucodigo#
		where CSEid 		 		= #form.CSEid#
	</cfquery>
	<cfquery datasource="#session.dsn#">
		insert into ContactoSocioS (
			CSEid, 
			Ecodigo, 
			Usucodigo, 
			BMUsucodigo, 
			BMfecha, 
			CSEFecha, 
			CSEFechaSolucion, 
			CSEEstatus, 
			CSEDetalleContacto, 
			TCid, 
			CSEnombreContacto
			)
		values (
			#form.CSEid#,
			#session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			<cfif isdefined("form.CSEFechaSolucion") and len(trim(form.CSEFechaSolucion))>
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.CSEFechaSolucion#">,
			<cfelse>
				null,
			</cfif>
			#form.CSEEstatus#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEDetalleContacto#">,
			#form.TCid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSEnombreContacto#">
		)
	</cfquery>
	<cfset params = "&SNcodigo=#form.SNcodigo#&SNid=#form.SNid#&CSEid=#form.CSEid#">
	<!--- Para este este mantenimiento no exite el modo Baja --->
	<cfelseif isdefined("form.Nuevo")>
		<cfset params = "&SNcodigo=#form.SNcodigo#&SNid=#form.SNid#">
</cfif>

<cflocation url="Contacto.cfm?1=1#params#" addtoken="no">