<!---
	Creado por Gustavo Fonseca Hernández.
	Fecha: 10-6-2005.
	Motivo: Creación del Mantenimiento de Instrucciones de Pago de Socios de Negocios.
 --->
<!--- <cf_dump var="#form#"> --->
<cfif form.TIPO EQ "SN">
	<cfset LvarTipoId = "SNidP">
<cfelseif form.TIPO EQ "SNC">
	<cfset LvarTipoId = "SNidP">
<cfelseif form.TIPO EQ "BT">
	<cfset LvarTipoId = "TESBid">
<cfelseif form.TIPO EQ "CD">
	<cfset LvarTipoId = "CDCcodigo">
</cfif>
<cfparam name="form.TESTPtipoCtaPropia" default="0">
<cfif IsDefined("form.Bid") and form.Bid NEQ "">
	<cfquery name="rsBancos" datasource="#session.DSN#">
		select 	Bdescripcion	as TESTPbanco,
				Bdireccion		as TESTPdireccion,
				Btelefon		as TESTPtelefono,
			<cfif form.TESTPcodigoTipo EQ "0">
				BcodigoACH
			<cfelseif form.TESTPcodigoTipo EQ "1">
				Iaba
			<cfelseif form.TESTPcodigoTipo EQ "2">
				BcodigoSWIFT
			<cfelseif form.TESTPcodigoTipo EQ "3">
				BcodigoIBAN
			<cfelse>
				BcodigoOtro
			</cfif>
								as TESTPcodigo
		  from Bancos
		 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and Bid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
	</cfquery>
	<cfparam name="form.TESTPcodigo"	default="#rsBancos.TESTPcodigo#">
	<cfparam name="form.TESTPbanco"		default="#rsBancos.TESTPbanco#">
	<cfparam name="form.TESTPdireccion"	default="#rsBancos.TESTPdireccion#">
	<cfparam name="form.TESTPtelefono"	default="#rsBancos.TESTPtelefono#">
</cfif>
<cfif IsDefined("form.Cambio")>
	<!--- *INICIA* SE ACTUALIZA LA CUENTA ORIGEN EN EL SOCIO DE NEGOCIO --->
	<!--- CUENTA BANCARIA --->
	<cfif isdefined("form.CBidPago") AND #form.CBidPago# NEQ "">
		<cfset arrCbId = listToArray (#form.CBidPago#, ",",false,true)>
		<cfif ArrayLen(arrCbId) EQ 4>
			<cfquery name="updateCtaOriSN" datasource="#session.DSN#">
				<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
					UPDATE SNegocios
				<cfelseif form.TIPO EQ "BT">
					UPDATE TESbeneficiario
				</cfif>
				SET SNCBidPago_Origen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrCbId[1]#">
				<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
					WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				<cfelseif form.TIPO EQ "BT">
					WHERE TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
				</cfif>
			</cfquery>
		</cfif>
	</cfif>
	<!--- MEDIO DE PAGO --->
	<cfif isdefined("form.TESMPcodigo") AND #form.TESMPcodigo# NEQ "">
		<cfquery name="updateCtaOriSN" datasource="#session.DSN#">
			<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
				UPDATE SNegocios
			<cfelseif form.TIPO EQ "BT">
				UPDATE TESbeneficiario
			</cfif>
			SET SNMedPago_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
				WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfelseif form.TIPO EQ "BT">
				WHERE TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			</cfif>
		</cfquery>
	</cfif>
	<!--- *FINALIZA* SE ACTUALIZA LA CUENTA ORIGEN EN EL SOCIO DE NEGOCIO --->

	<cftransaction>
		<!--- Si vine el chk (Default)entra. --->
		<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
			<!--- Quita cualquier default para que este quede como default--->
			<cfquery name="rsUpdateEstado" datasource="#session.DSN#">
				update TEStransferenciaP
					set TESTPestado = 0 <!--- Activo --->
				  where TESid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
					and	#LvarTipoId# 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
					and TESTPid			<> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
					and TESTPestado <> 2 <!---No Borrado--->
			</cfquery>
		</cfif>

		<!---
			Si se CAMBIA una Cuenta Destino utilizada en una TESordenPago ya emitida:
				se debe mantener la anterior para efectos históricos, se actualiza a estado = 2 (Inactivo)
				y se inserta la modificación como uno nuevo, y se actualiza todas las TESordenPago en proceso con la nueva
		--->
		<cfquery name="rsTESordenPagoCambio" datasource="#session.DSN#">
			select count(1) as resultado
			  from TESordenPago
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
			   and TESOPestado in (12,13)
		</cfquery>

		<cfif rsTESordenPagoCambio.resultado GT 0>
			<cf_dbtimestamp
			datasource="#session.DSN#"
			table="TEStransferenciaP"
			redirect="InstruccionesPagos.cfm"
			timestamp="#form.ts_rversion#"
			field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
			field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">

			<cfquery datasource="#session.dsn#">
				update TEStransferenciaP
				   set TESTPestado = 2
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
				   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
			</cfquery>
			
			<cfquery name="rsinsertCambio" datasource="#session.dsn#">
				insert into TEStransferenciaP
					(
						TESid,
						#LvarTipoId#,
						TESTPcuenta,
						Miso4217,
						TESTPtipo,
						Bid,
						TESTPcodigoTipo,
						TESTPcodigo,
						TESTPtipoCtaPropia,
						TESTPbanco,
						TESTPbancoID,
						TESTPdireccion,
						TESTPciudad,
						Ppais,
						TESTPtelefono,
						TESTPinstruccion,
						TESTPestado,
						UsucodigoAlta,
						TESTPfechaAlta,
                        TESTPtipoDet
					)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESTPcuentab)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Miso4217)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPtipo#"	null="#form.TESTPtipo EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#"			null="#form.Bid EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.TESTPtipoCtaPropia#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbancoID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">,
						<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
							1,
						<cfelse>
							0,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESTPtipoDet#" voidNull>
					)
					<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="rsinsertCambio">
			<cfset LvarTESTPid = rsinsertCambio.identity>
			<cfquery datasource="#session.DSN#">
				update TESordenPago
				   set TESTPid = #LvarTESTPid#
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
				   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
				   and TESOPestado NOT IN (12,13)
			</cfquery>
		<cfelse>
		<!--- Si no se usa en TESordenPago actualiza normal (Preguntarle a OzKaR) --->
			<cf_dbtimestamp
			datasource="#session.DSN#"
			table="TEStransferenciaP"
			redirect="InstruccionesPagos.cfm"
			timestamp="#form.ts_rversion#"
			field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
			field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">
			
			<cfquery datasource="#session.dsn#">
				update TEStransferenciaP
				   set
						TESTPcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcuentab#">,
						Miso4217 = 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.Miso4217#">,
						Bid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#"		null="#form.Bid EQ ""#">,
						TESTPbanco = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
						TESTPbancoID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbancoID#">,
						TESTPtipo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPtipo#"	null="#form.TESTPtipo EQ ""#">,
						TESTPcodigoTipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
						TESTPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
						TESTPtipoCtaPropia = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.TESTPtipoCtaPropia#">,
						TESTPdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
						TESTPciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
						Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
						TESTPtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
						<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
							TESTPestado = 1,
						<cfelse>
							TESTPestado = 0,
						</cfif>
						TESTPinstruccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">,
                        TESTPtipoDet=<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESTPtipoDet#" voidNull>
				 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
				   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
			</cfquery>

		</cfif>
	</cftransaction>
	<cfif isdefined("LvarTESTPid") and len(trim(LvarTESTPid))>
		<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#&TESTPid=#URLEncodedFormat(LvarTESTPid)#">
	<cfelse>
		<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#&TESTPid=#URLEncodedFormat(form.TESTPid)#">
	</cfif>
<cfelseif IsDefined("form.Baja")>
	<!--- Si se utiliza en TESordenPago se actualiza estado = 2 (Inactivo) --->
	<cfquery name="rsTESordenPagoBaja" datasource="#session.DSN#">
		select count(1) as resultado
		  from TESordenPago
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and #LvarTipoId# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
		   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESOPestado in (12,13)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update TESordenPago
		   set TESTPid = null
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and #LvarTipoId# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
		   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESOPestado in (10,11)
	</cfquery>

	<cfif rsTESordenPagoBaja.resultado gt 0>
		<cf_dbtimestamp
		datasource="#session.DSN#"
		table="TEStransferenciaP"
		redirect="InstruccionesPagos.cfm"
		timestamp="#form.ts_rversion#"
		field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#"
		field2="TESTPid" type2="numeric" value2="#Form.TESTPid#">

		<cfquery datasource="#session.dsn#">
			update TEStransferenciaP
			   set TESTPestado = 2, <!--- Borrado --->
				   UsucodigoBaja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				   TESTPfechaBaja = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			delete from TEStransferenciaP
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			   and TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric"value="#form.TESTPid#">
		</cfquery>
	</cfif>

<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#">

<cfelseif IsDefined("form.Alta")>

	<!--- *INICIA* SE ACTUALIZA LA CUENTA ORIGEN EN EL SOCIO DE NEGOCIO --->
	<!--- CUENTA BANCARIA --->
	<cfif isdefined("form.CBidPago") AND #form.CBidPago# NEQ "">
		<cfset arrCbId = listToArray (#form.CBidPago#, ",",false,true)>
		<cfif ArrayLen(arrCbId) EQ 4>
			<cfquery name="updateCtaOriSN" datasource="#session.DSN#">
				<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
					UPDATE SNegocios
				<cfelseif form.TIPO EQ "BT">
					UPDATE TESbeneficiario
				</cfif>
				SET SNCBidPago_Origen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrCbId[1]#">
				<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
					WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
				  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				<cfelseif form.TIPO EQ "BT">
					WHERE TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
				</cfif>
			</cfquery>
		</cfif>
	</cfif>
	<!--- MEDIO DE PAGO --->
	<cfif isdefined("form.TESMPcodigo") AND #form.TESMPcodigo# NEQ "">
		<cfquery name="updateCtaOriSN" datasource="#session.DSN#">
			<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
				UPDATE SNegocios
			<cfelseif form.TIPO EQ "BT">
				UPDATE TESbeneficiario
			</cfif>
			SET SNMedPago_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
				WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfelseif form.TIPO EQ "BT">
				WHERE TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			</cfif>
		</cfquery>
	</cfif>
	<!--- *FINALIZA* SE ACTUALIZA LA CUENTA ORIGEN EN EL SOCIO DE NEGOCIO --->

	<!--- Si vine el chk (Default)entra. --->
	<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
		<!--- Busca si ya hay registros en default --->
		<cfquery name="rsBuscaDefault" datasource="#session.DSN#">
			select TESTPid, TESid, #LvarTipoId#
			from  TEStransferenciaP
			where TESTPestado = 1 <!--- el Default --->
			and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
			and #LvarTipoId# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
		</cfquery>
		<!--- Si hay registros con default los actualiza a 0 (Activo) --->
		<cfif rsBuscaDefault.recordcount gt 0>
			<cfloop query="rsBuscaDefault">
				<cfquery name="rsUpdateEstado" datasource="#session.DSN#">
					update TEStransferenciaP
						set TESTPestado = 0 <!--- Activo --->
					where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESTPid#">
						and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault.TESid#">
						and #LvarTipoId# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaDefault[LvarTipoId]#">
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="rsInsertAlta">
			insert into TEStransferenciaP
			(TESid,
			 #LvarTipoId#,
			 TESTPcuenta,
			 Miso4217,
			 Bid,
			 TESTPbanco,
			 TESTPbancoID,
			 TESTPcodigoTipo,
			 TESTPcodigo,
			 TESTPdireccion,
			 TESTPciudad,
			 Ppais,
			 TESTPtelefono,
			 TESTPinstruccion,
			 TESTPestado,
			 UsucodigoAlta,
			 TESTPfechaAlta,
             TESTPtipoDet,
             TESTPtipoCtaPropia,
             TESTPtipo
			)

			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESTPcuentab)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Miso4217)#">,

					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#"		null="#form.Bid EQ ""#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbanco#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPbancoID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTPcodigoTipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPciudad#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPtelefono#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTPinstruccion#">,

					<cfif isdefined("form.chkTESTPestado") and len(trim(form.chkTESTPestado))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.chkTESTPestado#">,
					<cfelse>
						0,
					</cfif>

					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESTPtipoDet#" voidNull>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.TESTPtipoCtaPropia#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPtipo#"	null="#form.TESTPtipo EQ ""#">

				)
				<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="rsInsertAlta">
		<cfset LvarTESTPid = rsInsertAlta.identity>
	</cftransaction>
	<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#">
<cfelse>
	<!--- ??? --->
</cfif>

<cfif isdefined("LvarTESTPid") and len(trim(LvarTESTPid))>
	<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#&TESTPid=#URLEncodedFormat(LvarTESTPid)#">
<cfelse>
	<cflocation url="InstruccionesPagos.cfm?ID=#URLEncodedFormat(form.ID)#&TIPO=#form.TIPO#">
</cfif>