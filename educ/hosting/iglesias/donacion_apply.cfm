<!--- <cfdump var="#form#">
<cfabort> --->
<cfparam name="form.MEDimporte" type="numeric" default="0">
<cfparam name="form.MEDproyecto" type="numeric">
<cfif not isdefined("form.Nuevo") and 
	(form.MEDimporte NEQ 0 or form.MEDforma_pago EQ 'S')>
	<!---
		No registrar donaciones en cero a menos que sean
		en especie
	<cftry>
	--->
	
	<cfif isdefined("form.Alta")>
		<cfif isdefined("form.MEEid") and len(trim(form.MEEid)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsCompromisos">
				select MEDcompromiso
				from MEDCompromiso
				where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
					and MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#">
					and getdate() between MEDfechaini and isnull(MEDfechafin,'61000101')
			</cfquery>
		</cfif>
		<cfquery datasource="#session.dsn#" name="insert">
			insert MEDDonacion (
				MEDproyecto, MEpersona, MEDfecha,
				MEDmoneda,  MEDimporte, MEDforma_pago,
				MEDchbanco, MEDchcuenta, MEDchnumero,
				MEDtctipo, MEDtcnumero, MEDtcvence,
				MEDdescripcion, MEDcompromiso)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#" null="#Len(form.MEEid) IS 0#">,
				convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfecha#">,103),
		
				<cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDimporte#">,
				<cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDforma_pago)#">,

				<cfif Ucase(Trim(form.MEDforma_pago)) eq "E">
					null,
					null,
					null,
					null,
					null,
					null,
					null,
				<cfelseif Ucase(Trim(form.MEDforma_pago)) eq "C">
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchbanco)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchcuenta)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchnumero)#">,
					null,
					null,
					null,
					null,
				<cfelseif Ucase(Trim(form.MEDforma_pago)) eq "T">
					null,
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtctipo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtcnumero)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtcvence)#">,
					null,
				<cfelseif Ucase(Trim(form.MEDforma_pago)) eq "S">
					null,
					null,
					null,
					null,
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDdescripcion)#">
				</cfif>
				<cfif isdefined("rsCompromisos") and rsCompromisos.RecordCount gt 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompromisos.MEDcompromiso#">
				<cfelse>
					null
				</cfif>
			)
			<cfif isdefined("rsCompromisos") and rsCompromisos.RecordCount gt 0>
				update MEDCompromiso
				set MEDultima = getdate(),
					MEDsiguiente = case MEDtipo_periodo
									when 'd' then dateadd(dd, MEDperiodo, MEDsiguiente)
									when 'w' then dateadd(dd, MEDperiodo*7, MEDsiguiente)
									when 'm' then dateadd(mm, MEDperiodo, MEDsiguiente)
									when 'y' then dateadd(yy, MEDperiodo, MEDsiguiente)
									end 
				where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompromisos.MEDcompromiso#">
			</cfif>
		</cfquery>
	<cfelseif isdefined("form.Cambio")>
		<cfif isdefined("form.MEEid") and len(trim(form.MEEid)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsCompromisos">
				select MEDcompromiso
				from MEDCompromiso
				where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
					and MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#">
					and getdate() between MEDfechaini and isnull(MEDfechafin,'61000101')
			</cfquery>
		</cfif>
		<cfquery datasource="#session.dsn#" name="update">
			update MEDDonacion 
			set MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">,
			MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#" null="#Len(form.MEEid) IS 0#">,
			MEDfecha = convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfecha#">,103),
			MEDmoneda = <cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">,
			MEDimporte = <cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDimporte#">,
			MEDforma_pago = <cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDforma_pago)#">,
			<cfif Ucase(Trim(form.MEDforma_pago)) eq "C">
				MEDchbanco = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchbanco)#">,
				MEDchcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchcuenta)#">,
				MEDchnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDchnumero)#">,
				MEDtctipo = null,
				MEDtcnumero = null,
				MEDtcvence = null,
				MEDdescripcion = null,
			<cfelseif Ucase(Trim(form.MEDforma_pago)) eq "T">
				MEDchbanco = null,
				MEDchcuenta = null,
				MEDchnumero = null,
				MEDtctipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtctipo)#">,
				MEDtcnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtcnumero)#">,
				MEDtcvence = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDtcvence)#">,
				MEDdescripcion = null,
			<cfelseif Ucase(Trim(form.MEDforma_pago)) eq "S">
				MEDchbanco = null,
				MEDchcuenta = null,
				MEDchnumero = null,
				MEDtctipo = null,
				MEDtcnumero = null,
				MEDtcvence = null,
				MEDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDdescripcion)#">,
			</cfif>
			<cfif isdefined("rsCompromisos") and rsCompromisos.RecordCount gt 0>
				MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompromisos.MEDcompromiso#">
			<cfelse>
				MEDcompromiso = null
			</cfif>
			where MEDdonacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDdonacion#">
			
			<cfif isdefined("rsCompromisos") and rsCompromisos.RecordCount gt 0>
				update MEDCompromiso
				set MEDultima = getdate(),
						MEDsiguiente = case MEDtipo_periodo
						when 'd' then dateadd(dd, MEDperiodo, MEDsiguiente)
						when 'w' then dateadd(dd, MEDperiodo*7, MEDsiguiente)
						when 'm' then dateadd(mm, MEDperiodo, MEDsiguiente)
						when 'y' then dateadd(yy, MEDperiodo, MEDsiguiente)
					end 
				where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompromisos.MEDcompromiso#">
			</cfif>
		</cfquery>
		
	<cfelseif isdefined("form.Baja")>
		<cfquery datasource="#session.dsn#" name="insert">
			delete MEDDonacion
			where MEDdonacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDdonacion#">
		</cfquery>
	
	</cfif>
	<!---
	<cfcatch>
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cfif>
<cflocation url="donacion_registro.cfm">