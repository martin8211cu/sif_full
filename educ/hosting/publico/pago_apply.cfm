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
			<cfquery datasource="#session.dsn#" name="rsInsertTarjeta">
				set nocount on
				insert MEDTarjetas( MEpersona, MEDnombre, MEDtctipo, MEDtcnumero, MEDtcvence, MEDtcnombre, MEDtcdigito, 
									MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, MEDtcpais, MEDtczip, BMUsucodigo, 
									BMUlocalizacion, BMUsulogin, BMfechamod )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsuarioRegistro.MEpersona#">,
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
						 0,
						 '00',
						 'registro',
						 getdate()
					   )
				select @@identity as tarjeta
				set nocount on
			</cfquery>
			<cfset form.tarjeta = rsInsertTarjeta.tarjeta>
		</cfif>	

		
		<!---
		<cfset cf_tarjeta_cobro.error = 0>
		<cfset cf_tarjeta_cobro.autorizador = "0">
		<cfset cf_tarjeta_cobro.autorizacion = "0">
		<cfset cf_tarjeta_cobro.respuesta = "0">
		--->
		
		<cf_tarjeta_cobro
			monto="#Replace(form.MEDimporte,',','','all')#" tarjeta="#form.MEDtcnumero#"
			nombre="#form.MEDtcnombre#" vence="#form.MEDtcvence#"
			moneda="#form.MEDmoneda#"
			cvc="#form.MEDtcdigito#">
		
		<cfif cf_tarjeta_cobro.error NEQ 0>
			<cflocation url="tarjeta_rechazada.cfm?tarjeta=#form.tarjeta
				#&monto=#URLEncodedFormat(form.MEDimporte)
				#&moneda=#URLEncodedFormat(form.MEDmoneda)#&redir=1">
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsInsert">
			set nocount on 
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
					 <cfif isdefined("anonimo")>null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsuarioRegistro.MEpersona#"></cfif>,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcnombre#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdigito#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion1#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcdireccion2#">,
 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcciudad#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtcestado#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtcpais#">,
					 0,
					 '00',
					 'registro',
					 getdate(),
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDtczip#">,

					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizador#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizacion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.respuesta#">,
					 getdate()
				   )
			select @@identity as donacion
			
			<!---
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
			--->

			set nocount off
		</cfquery>

		<!--- Probar --->
		<cfset form.Pemail1 = session.UsuarioRegistro.Pemail1 >
		<cfset Form.Ppassword = session.UsuarioRegistro.Ppassword>

		<cfinclude template="pago_activacion.cfm">
		<!--- fin --->

	</cfif>
	<!---
	<cfcatch>
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cfif>
<cfif isdefined("rsInsert.donacion")>
	<cflocation url="pago_resumen.cfm?MEDdonacion=#rsInsert.donacion#">
<cfelse>
	<cflocation url="pago_resumen.cfm">
</cfif>