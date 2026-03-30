
<cfset params="">
<cfif isdefined("form.ALTA")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into TESRPTconcepto (TESRPTCCid ,CEcodigo, TESRPTCcodigo, TESRPTCdescripcion, BMUsucodigo,TESRPTCcxc,TESRPTCcxp)
			values(
				#form.TESRPTCCid#
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				,<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESRPTCcodigo#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCdescripcion#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			<cfif isdefined('form.Cobros')>	
				,#form.Cobros#
			<cfelse>
				,0
			</cfif>
			<cfif isdefined ('form.Pagos')>
				,#form.Pagos#
			<cfelse>
				,0
			</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnvariable="TESRPTCid">
	</cftransaction>		
	<cfset params = params & "TESRPTCid=#rsInsert.identity#">
<cfelseif isdefined("form.Para_Devoluciones")>
		<cfquery datasource="#session.DSN#">
			update TESRPTconcepto
			set TESRPTCdevoluciones = 
					case when TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
						then 1
						else 0
					end,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where CEcodigo = #session.CEcodigo#
		</cfquery>
	<cfset params = params & "TESRPTCid=#form.TESRPTCid#">
<cfelseif isdefined("form.CAMBIO")>
		<cfquery datasource="#session.DSN#">
			update TESRPTconcepto
			set 
				TESRPTCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCcodigo#">,
				TESRPTCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCdescripcion#">,
				TESRPTCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCCid#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			<cfif isdefined ('form.Cobros')>
				,TESRPTCcxc=#form.Cobros#
			<cfelse>
				,TESRPTCcxc=0
			</cfif>
			<cfif isdefined ('form.Pagos')>
				,TESRPTCcxp=#form.Pagos#
			<cfelse>
				,TESRPTCcxp=0
			</cfif>
			where TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
		</cfquery>
	<cfset params = params & "TESRPTCid=#form.TESRPTCid#">
<cfelseif isdefined("form.BAJA")>
		<cfquery datasource="#session.DSN#">
			delete from TESRPTCietu
			where TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery datasource="#session.DSN#">
			delete from TESRPTconcepto
			where TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
		</cfquery>
	<cflocation url="ConceptoPagosTerceros.cfm">
<cfelseif isdefined("form.NUEVO")>
	<cflocation url="ConceptoPagosTerceros_Form.cfm?#params#">
<!--- Detalles de los concepto--->

<cfelseif isdefined("form.AltaDet")>

	<cftransaction>
		<cfquery name="inserta" datasource="#session.dsn#">
			insert into TESRPTCietu 
				(
					TESRPTCid,
					Ecodigo,
					TESRPTCfecha,
					TESRPTCietu,
					TESRPTCietuP,
					CFcuentaDB,
					CFcuentaCR,
					BMUsucodigo
				)
			values
			   (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
					,#session.Ecodigo#
					,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESRPTCfecha)#">
				<cfif isdefined ('form.chkIFE') and form.chkIFE eq 1>
					,#form.chkIFE#
					,#form.TESRPTCietuP#
					,#form.CFcuentaDB#
					,#form.CFcuentaCR#
				<cfelse>
					,0
					,0
					,null
					,null
				</cfif>
				,#session.Usucodigo#
				)
		</cfquery>
	</cftransaction>
	<cfset params = params & "TESRPTCid=#form.TESRPTCid#">
<cfelseif isdefined("form.CambioDet")>
	<cftransaction>
		<cfquery name="rsactual" datasource="#session.dsn#">
			update TESRPTCietu
				set 
					TESRPTCfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESRPTCfecha)#">
				<cfif isdefined ('form.chkIFE')>
					,TESRPTCietu=1
					,TESRPTCietuP=#form.TESRPTCietuP#
					,CFcuentaDB=#form.CFcuentaDB#
					,CFcuentaCR=#form.CFcuentaCR#
				<cfelse>
					,TESRPTCietu=0
					,TESRPTCietuP=0
					,CFcuentaDB=null
					,CFcuentaCR=null
				</cfif>
			where TESRPTCid=#form.TESRPTCid#
			  and Ecodigo=#session.Ecodigo#
			  and TESRPTCfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESRPTCfecha)#">
		</cfquery>
	</cftransaction>
<cfset params = params & "TESRPTCid=#form.TESRPTCid#">
<cfelseif isdefined("form.BajaDet")>
	<cfquery datasource="#session.DSN#">
		delete from TESRPTCietu
		where TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
		and Ecodigo=#session.Ecodigo#
		and TESRPTCfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESRPTCfecha)#">
	</cfquery>
	<cfset params = params & "TESRPTCid=#form.TESRPTCid#&ND=yes">
</cfif>
<cfif isdefined ("form.NuevoDet")>
	<cfset params = params & "TESRPTCid=#form.TESRPTCid#&ND=yes">
	<cflocation url="ConceptoPagosTerceros_Form.cfm?#params#">
</cfif>
<cflocation url="ConceptoPagosTerceros_Form.cfm?#params#">