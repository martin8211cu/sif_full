<cfif IsDefined("form.Cambio")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from TEScontrolFormulariosT
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			and TESCFTnumInicial	<> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
			and (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
					between TESCFTnumInicial and TESCFTnumFinal
				OR
				 TESCFTnumInicial between
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
					and
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumFinal#">
				)
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cf_errorCode	code = "50780" msg = "No se permite traslapar consecutivos de diferentes bloques">
	</cfif>

	<cf_dbtimestamp datasource="#session.dsn#"
			table="TEScontrolFormulariosT"
			redirect="controlFormulariosT.cfm"
			timestamp="#form.ts_rversion#"

			field1="TESid"
			type1="numeric"
			value1="#session.Tesoreria.TESid#"

			field2="CBid"
			type2="numeric"
			value2="#form.CBid#"

			field3="TESMPcodigo"
			type3="varchar"
			value3="#form.TESMPcodigo#"

			field4="TESCFTnumInicial"
			type4="integer"
			value4="#form.TESCFTnumInicial#"
	>
	<cfquery datasource="#session.dsn#">
		update TEScontrolFormulariosT
			set TESCFTnumFinal	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumFinal#">
			  , TESCFTultimo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTultimo#">
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
	</cfquery>
	<cflocation url="controlFormulariosT.cfm?CBid=#form.CBid#&TESMPcodigo=#form.TESMPcodigo#&TESCFTnumInicial=#form.TESCFTnumInicial#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TEScontrolFormulariosT
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from TEScontrolFormulariosT
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			and TESCFTnumInicial	<> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
			and (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
					between TESCFTnumInicial and TESCFTnumFinal
				OR
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumFinal#">
					between TESCFTnumInicial and TESCFTnumFinal
				)
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cf_errorCode	code = "50780" msg = "No se permite traslapar consecutivos de diferentes bloques">
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into TEScontrolFormulariosT
			(TESid, CBid, TESMPcodigo, TESCFTnumInicial, TESCFTnumFinal)
		values
			(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumFinal#">
			)
	</cfquery>
<cfelseif IsDefined("form.btnDividir")>
	<cfif 	TESCFTultimo NEQ 0 AND 
			form.TESCFThastaNuevo GT form.TESCFTultimo AND
			form.TESCFThastaNuevo LT form.TESCFTnumFinal AND
			form.TESCFThastaNuevo EQ form.TESCFTdesdeNuevo - 1
	>
		<cftransaction>
			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosT
					(TESid, CBid, TESMPcodigo, TESCFTnumInicial, TESCFTnumFinal)
				select TESid, CBid, TESMPcodigo
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTdesdeNuevo#">
						, TESCFTnumFinal
				  from TEScontrolFormulariosT
				 where TESid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosT
				   set TESCFTnumFinal	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFThastaNuevo#">
				 where TESid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
				   and TESCFTnumFinal	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumFinal#">
			</cfquery>
		</cftransaction>
	</cfif>
<cfelseif IsDefined("form.Nuevo")>
<cfelse>
</cfif>

<cflocation url="controlFormulariosT.cfm?CBid=#form.CBid#&TESMPcodigo=#form.TESMPcodigo#">


