<cfset modo = "ALTA">

<!-----Modo alta---->
<cfif isdefined("Form.Alta")>	
	<cftransaction>				
		<cfquery name="ALTAtipoMov" datasource="#session.dsn#">
			insert RHTipoMovimiento 
				(Ecodigo, RHTMcodigo, RHTMdescripcion, id_tramite
					, modtabla
					, modcategoria
					, modestadoplaza
					, modcfuncional
					, modcentrocostos
					, modcomponentes
					, modindicador
					, modpuesto
					, modfechahasta
					, RHTMcomportamiento
					, RHTid 
					, BMfecha
					, BMUsucodigo )
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHTMcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHTMdescripcion#">
				<cfif isdefined('form.id_tramite') and form.id_tramite NEQ '-1'>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
				<cfelse>
					, null
				</cfif>
				<cfif isdefined('form.ckTabla')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckCategoria')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckEstadoPlaza')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckCF')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckCF')>, 1<cfelse>, 0</cfif>								
				<cfif isdefined('form.ckComponente')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckIndicador')>, 1<cfelse>, 0</cfif>				
				<cfif isdefined('form.ckPuesto')>, 1<cfelse>, 0</cfif>
				<cfif isdefined('form.ckFechaHasta')>, 1<cfelse>, 0</cfif>				
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHTMcomportamiento#">
				, <cfif form.RHTMcomportamiento neq 10 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#" null="#isdefined('form.RHTid') and len(trim(form.RHTid)) is 0#"><cfelse>null</cfif>
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		  <cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>					
		<cf_dbidentity2 datasource="#Session.DSN#" name="ALTAtipoMov">
	</cftransaction>
	
	<cfset form.RHTMid = ALTAtipoMov.identity>
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHUsuariosTipoMovCF
		where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTMid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
	<cfquery datasource="#session.dsn#">
		delete from RHTipoMovimiento
		where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTMid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
<!----Modo CAMBIO----->
<cfelseif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="RHTipoMovimiento"
		redirect="RHtabsTipoMov.cfm"
		timestamp="#form.ts_rversion#"
		field1="RHTMid"
		type1="numeric"
		value1="#form.RHTMid#">
	
	<cfquery datasource="#session.dsn#">
		update 	RHTipoMovimiento set
			RHTMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHTMcodigo#">
			, RHTMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHTMdescripcion#">
			<cfif isdefined('form.id_tramite') and form.id_tramite NEQ '-1'>
				, id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
			<cfelse>
				, id_tramite = null
			</cfif>
			, modtabla = <cfif isdefined('form.ckTabla')> 1<cfelse> 0</cfif>				
			, modcategoria = <cfif isdefined('form.ckCategoria')> 1<cfelse> 0</cfif>				
			, modestadoplaza = <cfif isdefined('form.ckEstadoPlaza')> 1<cfelse> 0</cfif>				
			, modcfuncional = <cfif isdefined('form.ckCF')> 1<cfelse> 0</cfif>				
			, modcentrocostos = <cfif isdefined('form.ckCF')> 1<cfelse> 0</cfif>
			, modcomponentes = <cfif isdefined('form.ckComponente')> 1<cfelse> 0</cfif>				
			, modindicador = <cfif isdefined('form.ckIndicador')> 1<cfelse> 0</cfif>				
			, modpuesto = <cfif isdefined('form.ckPuesto')> 1<cfelse> 0</cfif>
			, modfechahasta = <cfif isdefined('form.ckFechaHasta')> 1<cfelse> 0</cfif>				
			, RHTMcomportamiento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHTMcomportamiento#">
			, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			, RHTid = <cfif form.RHTMcomportamiento neq 10 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#" null="#isdefined('form.RHTid') and len(trim(form.RHTid)) is 0#"><cfelse>null</cfif>
		where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTMid#">
			and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfoutput>
<form action="RHtabsTipoMov.cfm" method="post" name="sql">
	<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
		<cfif not isdefined('form.Baja') and (isdefined('form.RHTMid') and form.RHTMid NEQ '')>
			<input name="RHTMid" type="hidden" value="#form.RHTMid#"> 
		</cfif>
	<cfelseif isdefined('form.Nuevo')>
		<input name="btnNuevo" type="hidden" value="btnNuevo"> 
	</cfif>
</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>



