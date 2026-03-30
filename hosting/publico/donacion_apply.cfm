<cfparam name="form.MEDimporte" type="numeric" default="0">
<cfparam name="form.MEDproyecto" type="numeric">

<cfif not isdefined("form.Nuevo") and form.MEDimporte NEQ 0>

	<cfif isdefined("form.Alta")>
		<cfif isdefined("form.MEEid") and len(trim(form.MEEid)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsCompromisos">
				select MEDcompromiso
				from MEDCompromiso
				where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
					and MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#">
					and getdate() between MEDfechaini and isnull(MEDfechafin,'61000101')
			</cfquery>
		</cfif>
		<cfif not isdefined("form.tarjeta")>
			<cfquery datasource="#session.dsn#" name="insert_tc">
				set nocount on
				insert MEDTarjetas( MEpersona, MEDnombre, MEDtctipo, MEDtcnumero, MEDtcvence, MEDtcnombre, MEDtcdigito, 
									MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, MEDtcpais, MEDtczip, BMUsucodigo, 
									BMUlocalizacion, BMUsulogin, BMfechamod )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnombre#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtctipo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcnumero#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcvence#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnombre#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdigito#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion2#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcciudad#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcestado#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcpais#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtczip#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						 getdate()
					   )
				select @@identity as tarjeta
				set nocount off
			</cfquery>
			<cfset form.tarjeta = insert_tc.tarjeta>
		</cfif>
		
		
		<cf_tarjeta_cobro
			monto="#Replace(form.MEDimporte,',','','all')#" tarjeta="#form.MEDtcnumero#"
			nombre="#form.MEDtcnombre#" vence="#form.MEDtcvence#"
			moneda="#form.MEDmoneda#"
			cvc="#form.MEDtcdigito#">
		
		<!---
		<cfset cf_tarjeta_cobro.error = 0>
		<cfset cf_tarjeta_cobro.autorizador = "XXX007">
		<cfset cf_tarjeta_cobro.autorizacion = "XXX007">
		<cfset cf_tarjeta_cobro.respuesta = "XXX007">
		--->
		
		<cfif cf_tarjeta_cobro.error NEQ 0>
			<cflocation url="tarjeta_rechazada.cfm?tarjeta=#form.tarjeta
				#&monto=#URLEncodedFormat(form.MEDimporte)
				#&moneda=#URLEncodedFormat(form.MEDmoneda)#">
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="rsInsert">
			insert MEDDonacion ( MEDproyecto, MEDfecha, MEDmoneda, MEDimporte, MEDforma_pago, MEDchbanco, MEDchcuenta, MEDchnumero, 
			                     MEDtctipo, MEDtcnumero, MEDtcvence, MEDdescripcion, MEDcompromiso, MEpersona, MEDtcnombre, MEDtcdigito, 
								 MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, MEDtcpais, BMUsucodigo, BMUlocalizacion, 
								 BMUsulogin, BMfechamod, MEDtczip,
								 MEDaut_autorizador, MEDaut_num, MEDaut_resp, MEDaut_fecha)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">,
					 getdate(),
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDmoneda#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MEDimporte,',','','all')#">,
					 'T',
					 null, 
					 null, 
					 null,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtctipo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcnumero#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcvence#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDdescripcion#">,
					 null,
					 <cfif isdefined("anonimo")>null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#"></cfif>,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnombre#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdigito#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion1#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion2#">,
 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcciudad#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcestado#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcpais#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					 getdate(),
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtczip#">,
					 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizador#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizacion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.respuesta#">,
					 getdate()
				   )
			select @@identity as donacion
			
			set nocount off
		</cfquery>
		
	</cfif>
	<!---
	<cfcatch>
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cfif>
<cfif isdefined("rsInsert.donacion")>
	<cflocation url="donacion_resumen.cfm?MEDdonacion=#rsInsert.donacion#">
<cfelse>
	<cflocation url="donacion_resumen.cfm">
</cfif>