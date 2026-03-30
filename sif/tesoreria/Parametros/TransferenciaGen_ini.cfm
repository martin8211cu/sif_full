<cf_navegacion name="TESTGid">
<cfif isdefined("url.OP") and isdefined("url.id")>
	<cfif url.OP EQ	 "chk">
		<cfquery datasource="#session.dsn#" name="lista">
			update TEStransferenciaG
			   set TESTGactivo = case when TESTGactivo = 0 then 1 else 0 end
			 where TESTGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		</cfquery>
		<script language="javascript">
			location.href="TransferenciaGen.cfm?TESTGid=<cfoutput>#url.id#</cfoutput>";
		</script>
	</cfif>
<cfelseif isdefined("form.OP") and form.OP EQ "Modificar">
	<cfloop collection="#form#" item="campo">
		<cfquery datasource="#session.dsn#" name="lista">
			update TEStransferenciaG2
			   set TESTGvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form[campo]#">
			 where TESTGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTGid#">
			   and upper(TESTGdato) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#campo#">
		</cfquery>
	</cfloop>
</cfif>


<cfset sbAgregaTipoTRE	(10, 'HSBC_ACH', 'HSBC-ACH (Panama)', 	0, 0, 1,0)>

<cfset sbAgregaTipoTRE	(11, 'HACIENDA', 'Hacienda (C.R.)', 	0, 3, 1, 1)>
<cfset sbAgregaDato		(11, 'Identificacion',	'Cédula de la Empresa', 'E', 1)>
<cfset sbAgregaDato		(11, 'Nombre Empresa',	'Nombre de la Empresa', 'E', 2)>
<cfset sbAgregaDato		(11, 'Servicio Pagos',	'Servicio para TRE de pagos', 'E', 3)>
<cfset sbAgregaDato		(11, 'Servicio Ctas',	'Servicio para TRE entre cuentas', 'E', 4)>
<cfset sbAgregaDato		(11, 'CentroCosto',		'93', 'E', 5)>
<cfset sbAgregaDato		(11, 'Consecutivo',		'93', 'L', 1)>

<cfset sbAgregaTipoTRE	(12, 'BACinterno', 'Banco San Jose C.R.(Interno)', 	0, 1, 1, 0)>
<cfset sbAgregaDato		(12, 'Numero plan colones',	'364', 'E', 1)>
<cfset sbAgregaDato		(12, 'Numero plan dolares',	'1500', 'E', 2)>
<cfset sbAgregaDato		(12, 'Consecutivo Colones',		'1', 'L', 1)>
<cfset sbAgregaDato		(12, 'Consecutivo Dolares',		'1', 'L', 2)>

<cfset sbAgregaTipoTRE	(13, 'BCRinterno', 'Banco de Costa Rica(Interno)', 	0, 1, 1, 0)>
<cfset sbAgregaDato		(13, 'Consecutivo Colones',		'1', 'L', 1)>
<cfset sbAgregaDato		(13, 'Consecutivo Dolares',		'1', 'L', 2)>

<cfset sbAgregaTipoTRE	(14, 'BNCRinterno', 'Banco Nacional de Costa Rica(Interno)', 	0, 1, 1, 0)>
<cfset sbAgregaDato		(14, 'Consecutivo',		'1', 'L', 1)>

<cfset sbAgregaTipoTRE	(15, 'HSBCinterno', 'HSBC Nacion(Interno)', 	0, 1, 2, 0)>

<cffunction name="sbAgregaTipoTRE" output="no" returntype="void">
	<cfargument name="TESTGid"		type="numeric">
	<cfargument name="TESTGcfc">
	<cfargument name="TESTGdescripcion">
	<cfargument name="TESTGcodigoTipo"		type="numeric">
	<cfargument name="TESTGtipoCtas"		type="numeric">
	<cfargument name="TESTGtipoConfirma"	type="numeric">
	<cfargument name="TESTGbancaria"		type="numeric">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESTGid
		  from TEStransferenciaG
		 where TESTGid = #Arguments.TESTGid#
	</cfquery>
	<cfif rsSQL.TESTGid EQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into TEStransferenciaG
				(TESTGid, TESTGcfc, TESTGdescripcion, TESTGcodigoTipo, TESTGtipoCtas, TESTGtipoConfirma, TESTGbancaria, TESTGactivo, BMUsucodigo)
			values (
				#arguments.TESTGid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGcfc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdescripcion#">,
				#Arguments.TESTGcodigoTipo#, #Arguments.TESTGtipoCtas#, #Arguments.TESTGtipoConfirma#,#Arguments.TESTGbancaria#,
				0, #session.usucodigo#
			)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update TEStransferenciaG
			   set 	TESTGcfc			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGcfc#">,
					TESTGdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdescripcion#">,
					TESTGcodigoTipo		= #Arguments.TESTGcodigoTipo#, 
					TESTGtipoCtas		= #Arguments.TESTGtipoCtas#, 
					TESTGtipoConfirma	= #Arguments.TESTGtipoConfirma#,
					TESTGbancaria		= #Arguments.TESTGbancaria#
			 where TESTGid = #Arguments.TESTGid#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESmedioPago
			   set 	TESTGcodigoTipo		= #Arguments.TESTGcodigoTipo#, 
					TESTGtipoCtas		= #Arguments.TESTGtipoCtas#, 
					TESTGtipoConfirma	= #Arguments.TESTGtipoConfirma#
			 where TESTGid = #Arguments.TESTGid#
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="sbAgregaDato" output="no" returntype="void">
	<cfargument name="TESTGid"		type="numeric">
	<cfargument name="TESTGdato">
	<cfargument name="TESTGvalor">
	<cfargument name="TESTGtipo">
	<cfargument name="TESTGsec"		type="numeric">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESTGid
		  from TEStransferenciaG2
		 where TESTGid		= #Arguments.TESTGid#
		   and Ecodigo		= #session.Ecodigo#
		   and TESTGdato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdato#">
	</cfquery>
	<cfif rsSQL.TESTGid EQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into TEStransferenciaG2
				(TESTGid, Ecodigo, TESTGdato, TESTGvalor, TESTGtipo, TESTGsec, BMUsucodigo)
			values (
				#Arguments.TESTGid#,
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdato#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGvalor#">,
				'#Arguments.TESTGtipo#', #Arguments.TESTGsec#, #session.usucodigo#
			)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update TEStransferenciaG2
			   set 	TESTGsec	= #Arguments.TESTGsec#
			 where TESTGid		= #Arguments.TESTGid#
			   and Ecodigo		= #session.Ecodigo#
			   and TESTGdato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdato#">
		</cfquery>
	</cfif>
</cffunction>
