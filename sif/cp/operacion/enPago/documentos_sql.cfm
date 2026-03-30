<cfset LvarRoot = form.root>
<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="CPCesion"
			redirect="#LvarRoot#"
			timestamp="#form.ts_rversion#"

			field1="CPCid"
			type1="numeric"
			value1="#form.CPCid#"
	>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select SNid
		  from SNegocios
		 where Ecodigo = #session.Ecodigo#
		   and SNcodigo = #form.SNcodigoOri#
	</cfquery>
	<cfset LvarSNidOrigen = rsSQL.SNid>
	
	<cfif form.CPCtipo EQ "M">
		<cfset LvarSNidDestino = "null">
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select SNid
			  from SNegocios
			 where Ecodigo = #session.Ecodigo#
			   and SNcodigo = #form.SNcodigoDst#
		</cfquery>
		<cfset LvarSNidDestino = rsSQL.SNid>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update CPCesion
			set CPCtipo			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.CPCtipo#">,
				CPCdocumento	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.CPCdocumento#">,
				CPCdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.CPCdescripcion#">,
				CPCfecha		= <cfqueryparam cfsqltype="cf_sql_date"		value="#LSparseDatetime(form.CPCfecha)#">,
				CPCnivel		= <cfqueryparam cfsqltype="cf_sql_char"		value="#form.CPCnivel#">,
				SNidOrigen		= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarSNidOrigen#">,

				<cfparam name="form.IDdocumento" default="">
				<cfparam name="form.EOidorden" default="">
				IDdocumento			= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.IDdocumento#"			null="#form.CPCnivel NEQ "D"#">,
				EOidorden		= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.EOidorden#"	null="#form.CPCnivel NEQ "O"#">,
				SNidDestino		= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarSNidDestino#"	null="#form.CPCtipo EQ "M"#">,

			<cfif form.CPCnivel EQ "S">
				Mcodigo			= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.Mcodigo#">,
			<cfelse>
				Mcodigo			= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.McodigoDoc#">,
			</cfif>
				CPCmonto		= <cfqueryparam cfsqltype="cf_sql_money"	value="#replace(form.CPCmonto,",","","ALL")#">,
				CPCdetalle		= <cfqueryparam cfsqltype="cf_sql_longvarchar"	value="#form.CPCdetalle#">

		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
	</cfquery>
	<cflocation url="#LvarRoot#?CPCid=#form.CPCid#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from CPCesion
		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select SNid
		  from SNegocios
		 where Ecodigo = #session.Ecodigo#
		   and SNcodigo = #form.SNcodigoOri#
	</cfquery>
	<cfset LvarSNidOrigen = rsSQL.SNid>
	
	<cfif form.CPCtipo EQ "M">
		<cfset LvarSNidDestino = "null">
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select SNid
			  from SNegocios
			 where Ecodigo = #session.Ecodigo#
			   and SNcodigo = #form.SNcodigoDst#
		</cfquery>
		<cfset LvarSNidDestino = rsSQL.SNid>
	</cfif>

	<cfquery name="rsInsert" datasource="#session.dsn#">
		insert into CPCesion (
				Ecodigo,CPCtipo,CPCdocumento,CPCdescripcion,CPCfecha,CPCnivel,SNidOrigen,IDdocumento,EOidorden,SNidDestino,Mcodigo,CPCmonto,CPCdetalle
			)
		values
			(
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.CPCtipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.CPCdocumento#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#form.CPCdescripcion#" len="50">,
				<cfqueryparam cfsqltype="cf_sql_date"		value="#LSparseDatetime(form.CPCfecha)#">,
				<cfqueryparam cfsqltype="cf_sql_char"		value="#form.CPCnivel#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarSNidOrigen#">,
				<cfparam name="form.IDdocumento" default="">
				<cfparam name="form.EOidorden" default="">
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.IDdocumento#"			null="#form.CPCnivel NEQ "D"#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.EOidorden#"	null="#form.CPCnivel NEQ "O"#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarSNidDestino#"	null="#form.CPCtipo EQ "M"#">,
			<cfif form.CPCnivel EQ "S">
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.Mcodigo#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.McodigoDoc#">,
			</cfif>
				<cfqueryparam cfsqltype="cf_sql_money"		value="#replace(form.CPCmonto,",","","ALL")#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar"	value="#form.CPCdetalle#">
			)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnVariable="LvarID"> 
	<cflocation url="#LvarRoot#?CPCid=#LvarID#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="#LvarRoot#?Nuevo">

<cfelseif IsDefined("form.A_Aprobar")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="CPCesion"
			redirect="#LvarRoot#"
			timestamp="#form.ts_rversion#"

			field1="CPCid"
			type1="numeric"
			value1="#form.CPCid#"
	>
	<cfquery datasource="#session.dsn#">
		update CPCesion
			set CPCestado			= 1,
				UsucodigoSolicita 	= #session.Usucodigo#,
				CPCfechaSolicita	= <cf_dbfunction name="now">
		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
			and CPCestado		= 0
				
	</cfquery>
	<cflocation url="#LvarRoot#">
<cfelseif IsDefined("form.Aprobar")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="CPCesion"
			redirect="#LvarRoot#"
			timestamp="#form.ts_rversion#"

			field1="CPCid"
			type1="numeric"
			value1="#form.CPCid#"
	>
	<cfquery datasource="#session.dsn#">
		update CPCesion
			set CPCestado			= 3,
				UsucodigoAprueba 	= #session.Usucodigo#,
				CPCfechaAprueba	= <cf_dbfunction name="now">
		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
			and CPCestado		= 1
	</cfquery>
	<cflocation url="#LvarRoot#">
<cfelseif IsDefined("form.Rechazar")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="CPCesion"
			redirect="#LvarRoot#"
			timestamp="#form.ts_rversion#"

			field1="CPCid"
			type1="numeric"
			value1="#form.CPCid#"
	>
	<cfquery datasource="#session.dsn#">
		update CPCesion
			set CPCestado			= 4,
				UsucodigoAprueba 	= #session.Usucodigo#,
				CPCfechaAprueba		= <cf_dbfunction name="now">,
				CPCmotivoRechazo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPCmotivoRechazo#">
		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
			and CPCestado		= 1
	</cfquery>
	<cflocation url="#LvarRoot#">
<cfelseif IsDefined("form.Anular")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="CPCesion"
			redirect="#LvarRoot#"
			timestamp="#form.ts_rversion#"

			field1="CPCid"
			type1="numeric"
			value1="#form.CPCid#"
	>
	<cfquery datasource="#session.dsn#">
		update CPCesion
			set CPCestado			= 5,
				UsucodigoCancela 	= #session.Usucodigo#,
				CPCfechaCancela		= <cf_dbfunction name="now">,
				CPCmotivoRechazo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPCmotivoRechazo#">
		 where 	Ecodigo			= #session.Ecodigo#
			and CPCid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
			and CPCestado		= 3
	</cfquery>
	<cflocation url="#LvarRoot#">
</cfif>

<cflocation url="#LvarRoot#">
