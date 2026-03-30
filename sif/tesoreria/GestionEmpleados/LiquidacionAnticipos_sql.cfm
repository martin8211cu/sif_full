<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticipos#url.tipo#.cfm">

<!-------------------------------------------------- Ir a otras opciones -------------------------------------------->
<cfif IsDefined("form.CalcularViaticos")>
	<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GELid=#form.GELid#&CFid=#form.CFid#&GELfecha=#form.GELfecha#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
<cfelseif IsDefined("form.irLista")>
	<cflocation url="#LvarSAporEmpleadoCFM#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo=1">
<cfelseif isdefined ('form.btnRegresar')>
	<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo=1">
<cfelseif isdefined ('form.RegresarDet')>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">
<cfelseif isdefined ('form.btnLista')>
	<cflocation url="#LvarSAporEmpleadoCFM#">
<cfelseif isdefined ('form.Anticipos')>
	<cflocation url="#LvarSAporEmpleadoCFM#?Anti=1">
</cfif>

<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras = (rsUsaPlanCuentas.Pvalor EQ 1)>

<cfif isdefined ('form.GELid') and len(trim(#form.GELid#))>
	<cfquery name="rsInfoLiq" datasource="#Session.DSN#">
		select GEAviatico,GEAtipoviatico
			  from GEliquidacion a
				where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
</cfif>

<cfif isdefined ('form.GECid_comision') and len(trim(#form.GECid_comision#))>
	<cfquery name="rsGEcomision" datasource="#Session.DSN#">
		select CFid, TESBid
		  from GEcomision
		 where GECid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
	<cfset session.Tesoreria.CFid = rsGEcomision.CFid>
	<cfset session.Tesoreria.GECid = form.GECid_comision>
</cfif>

<cfset LvarTipoDocumento = 7>
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<!----------------------------------------- Alta desde la lista de Anticipos ---------------------------------------->
<cfif isdefined ('url.Anticipos')>
	<!---tesoreria--->
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
	</cfif>

	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CCHid, CCHtipo
			  from CCHica
			 where CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">
		</cfquery>
		<cfif rsSQL.CCHtipo EQ 2 OR rsSQL.CCHid EQ "">
			<cfset LvarGELtipoP = 1>
			<cfset LvarCCHid = rsSQL.CCHid>
		<cfelse>
			<cfset LvarGELtipoP = 0>
			<cfset LvarCCHid = rsSQL.CCHid>
		</cfif>
	<cfelse>
		<cfset LvarGELtipoP = 1>
		<cfset LvarCCHid = "">
	</cfif>

	<cftransaction>
		<cfquery name="rsNewLiq" datasource="#session.dsn#">
			select coalesce(max(GELnumero),0) + 1 as newLiq
			  from GEliquidacion
			 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfquery datasource="#session.dsn#" name="insert">
			insert into GEliquidacion (
				TESid,
				CFid,
				Ecodigo,
				GELnumero,
				GELtipo,
				GELestado,
				Mcodigo,
				GELtotalAnticipos,
				GELtotalGastos,GELtotalDepositos,GELreembolso,
				GELfecha,
				UsucodigoSolicitud,
				BMUsucodigo,
				TESBid,
				GELdescripcion,
				GELtipoCambio,
				CCHid,
				GELtipoP,
				GEAviatico,
				GEAtipoviatico,
				GELdesde, GELhasta
			<cfif isdefined("form.GECid_comision")>
				,GECid
			</cfif>
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewLiq.newLiq#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTipoDocumento#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="0">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAtotalOri#">,
				0,0,0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.GEAdescripcion)#"null="#rtrim(form.GEAdescripcion) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.GEAmanual#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCCHid#" null="#LvarCCHid EQ ''#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGELtipoP#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAviatico#" null="#form.GEAviatico EQ ''#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAtipoviatico#" null="#form.GEAtipoviatico EQ ''#">,
				<cfqueryparam cfsqltype="cf_sql_date"	value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_date"	value="#now()#">
			<cfif isdefined("form.GECid_comision")>
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
			</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarID_liquidacion">

		<cfset form.IDliqui=#LvarID_liquidacion#>

		<cfquery datasource="#session.DSN#">
			insert into GEliquidacionAnts (GELid, GEAid, GEADid, GELAtotal)
			select
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.IDliqui#">,
				GEAid,
				GEADid,
				GEADmonto - GEADutilizado - TESDPaprobadopendiente
			  from GEanticipoDet a
			 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
				and GEADmonto - GEADutilizado - TESDPaprobadopendiente > 0
				and (
					select count(1)
					  from GEliquidacionAnts d
						inner join GEliquidacion e
						 on e.GELid 		= d.GELid
						and e.GELestado 	in (0,1,2)
					 where d.GEADid = a.GEADid
				) = 0
		</cfquery>


		<!---Agregar desde las listas pero cuando es viatico--->
		<cfif isdefined ('form.GEAviatico') and #form.GEAviatico# eq '1'>

			<cfquery name="rsGELid" datasource="#session.dsn#">
				select max(GELid)  as GELid
				from GEliquidacion
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>


			<cfquery name="rsPlantillas" datasource="#session.dsn#">
					  select
					  	ged.GEADid,
						ged.GEADfechaini,
						ged.GEADfechafin,
						ged.GEADhoraini,
						ged.GEADhorafin,
						ged.GEADmonto,
						ged.GEADtipocambio,
						ged.GEPVid,
						ged.GEADmontoviatico,
						ged.GECid

						from GEanticipoDet ged

						where ged.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
				</cfquery>
				<cfloop query="rsPlantillas">
						<cfquery datasource="#session.dsn#" name="insertadetalle">
							insert into GEliquidacionViaticos (
								GELid,
								GEPVid,
								GEAid,
								GEADid,
								GECid,
								GELVmontoOri,
								GEPVmontoGastMV,
								GELVtipoCambio,
								GELVmonto,
								GELVfechaIni,
								GELVfechaFin,
								GELVhoraIni,
								GELVhorafin,
								BMUsucodigo
								)
							values(
								#rsGELid.GELid#,
								<cfif len(trim(#GEPVid#)) gt 0 and len(trim(#GECid#)) >
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GEPVid#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
								</cfif>
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.GEAid#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GEADid#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GECid#">,
								<cfif len(trim(#GEADmontoviatico#))>
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADmontoviatico#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADmontoviatico#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADtipocambio#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADmonto#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADmonto#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_money" value="1">,
								</cfif>
								<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#GEADmonto#">,
								<cfif len(trim(#GEADfechaini#))>
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#GEADfechaini#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#GEADfechafin#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
									<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
								</cfif>
								<cfif len(trim(#GEADhoraini#))>
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GEADhoraini#">,
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GEADhorafin#">,
								<cfelse>
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
									<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
								</cfif>
								#session.Usucodigo#
								)
								<cf_dbidentity1 datasource="#session.dsn#" name="insertadetalle">
						</cfquery>
							<cf_dbidentity2 datasource="#session.dsn#" name="insertadetalle" returnvariable="LvarTESSADid1">
							<cfset #GELVid#=#LvarTESSADid1#>
				</cfloop>

				<cfquery datasource="#session.DSN#">
					insert into GEliquidacionAnts (GELid, GEAid, GEADid, GELAtotal)
					select
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#GELVid#">,
						GEAid,
						GEADid,
						GEADmonto - GEADutilizado - TESDPaprobadopendiente
					  from GEanticipoDet a
					 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
						and GEADmonto - GEADutilizado - TESDPaprobadopendiente > 0
						and (
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (0,1,2)
							 where d.GEADid = a.GEADid
						) = 0
				</cfquery>
		</cfif>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(LvarID_liquidacion)#">
</cfif>

<!---------------------------------- Mantenimiento al Encabezado de la Liquidación --------------------------------->

<!---AGREGAR--->
<cfif IsDefined("form.Alta")>
	<!---Beneficiario/Empleado--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
				method="Empleado_to_Beneficiario"
				DEid = "#form.DEid#"
				returnvariable="form.TESBid">

	<cfif isdefined ('form.CFid') and isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0 and form.FormaPago gt 0>
		<cfquery name="rsValid" datasource="#session.dsn#">
			select c.CCHid, c.Mcodigo, f.CFid
			  from CCHica c
				inner join Monedas m
					 on m.Mcodigo=c.Mcodigo
				left join CCHicaCF f
					 on f.CCHid=c.CCHid
					and f.CFid=#form.CFid#
			  where c.CCHid=#form.FormaPago#
		</cfquery>
		<cfif rsValid.CCHid eq "">
			<cfthrow message="No existe la Caja id=[#form.FormaPago#]">
			<cf_errorCode	code = "50742" msg = "No se puede insertar la liquidación porque no existe concordancia entre el Centro Funcional, la moneda y la caja chica">
		<cfelseif rsValid.CFid EQ "">
			<cfthrow message="La Caja no está definida para el Centro Funcional indicado">
		<cfelseif rsValid.Mcodigo Neq form.McodigoE>
			<cfthrow message="La moneda de la Caja no corresponde con la moneda de la Liquidación">
		</cfif>
	</cfif>
	<!---tesoreria--->
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
	</cfif>

	<cfif isdefined ('form.formaPago') and len(trim(form.formaPago)) gt 0 and form.formaPago NEQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CCHid, CCHtipo
			  from CCHica
			 where CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.formaPago#">
		</cfquery>
		<cfif rsSQL.CCHtipo EQ 2 OR rsSQL.CCHid EQ "">
			<cfset LvarGELtipoP = 1>
			<cfset LvarCCHid = rsSQL.CCHid>
		<cfelse>
			<cfset LvarGELtipoP = 0>
			<cfset LvarCCHid = rsSQL.CCHid>
		</cfif>
	<cfelse>
		<cfset LvarGELtipoP = 1>
		<cfset LvarCCHid = "">
	</cfif>

	<cftransaction>
		<cfquery name="rsNewLiq" datasource="#session.dsn#">
			select coalesce(max(GELnumero),0) + 1 as newLiq
			from GEliquidacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="beneficiario" datasource="#session.dsn#">
			select TESBid as benef
			from TESbeneficiario
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="insert">
			insert into GEliquidacion (
				TESid,
				CFid,
				Ecodigo,
				GELnumero,
				GELtipo,
				GELestado,
				Mcodigo,
				GELtotalGastos,	GELtotalAnticipos, GELtotalDepositos, GELreembolso,
				UsucodigoSolicitud,
				BMUsucodigo,
				TESBid,
				GELdescripcion,
				GELtipoCambio,
				CCHid,
				GELtipoP,
				GEAviatico,
				GEAtipoviatico,
			<cfif isdefined("form.GECid_comision")>
				GECid,
			</cfif>
				GELdesde, GELhasta,
				GELfecha
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewLiq.newLiq#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTipoDocumento#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="0">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoE#">,
				0,0,0,0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#beneficiario.benef#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.GELdescripcion)#"null="#rtrim(form.GELdescripcion) EQ ""#">,
				<cfif isdefined('form.GELtipoCambio') and len(trim(form.GELtipoCambio))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtipoCambio#">,
				<cfelse>
					0,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCCHid#" null="#LvarCCHid EQ ''#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGELtipoP#">,
				<cfif isdefined ('form.GEAviatico')>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAviatico#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">,
				<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
				</cfif>
			<cfif isdefined("form.GECid_comision")>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">,
			</cfif>
				<cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDatetime(form.GELdesde)#" null="#form.GELdesde EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDatetime(form.GELhasta)#" null="#form.GELhasta EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="form.GELid">
		<cfset form.IDliqui=#form.GELid#>

		<cfset sbVerificaCF_Moneda()>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#">
</cfif>

<!---Modifica--->
<cfif IsDefined("form.Cambio")>
	<!---Beneficiario/Empleado--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
				method="Empleado_to_Beneficiario"
				DEid = "#form.DEid#"
				returnvariable="form.TESBid">

	<cf_cboCFid>

	<cf_dbtimestamp datasource="#session.dsn#"
		table="GEliquidacion"
		redirect="metadata.code.cfm"
		timestamp="#form.ts_rversion#"
		field1="GELid"
		type1="numeric"
		value1="#form.GELid#">

	<cfquery name="beneficiario" datasource="#session.dsn#">
		select TESBid as benef
		from TESbeneficiario
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>

	<cfquery name="rsLiq" datasource="#session.dsn#">
		select Mcodigo, GELtipoCambio
		  from GEliquidacion
		 where GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">
	</cfquery>

	<cftransaction>
		<cfquery name="ActualizaEnc" datasource="#session.dsn#">
			update GEliquidacion
				set TESid = #session.Tesoreria.TESid#,
				CFid = #session.Tesoreria.CFid#,
				TESBid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#beneficiario.benef#">,
				<cfif isdefined('form.McodigoE') and len(trim(form.McodigoE))>
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				</cfif>
				<cfif isdefined('form.GELtipoCambio') and len(trim(form.GELtipoCambio))>
					GELtipoCambio = <cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtipoCambio#">,
				</cfif>
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				GELdescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.GELdescripcion)#"	null="#rtrim(form.GELdescripcion) EQ ""#">
				<cfif form.GELdesde EQ "">
				 , GELdesde	= null
				 , GELhasta	= null
				<cfelse>
				 , GELdesde	= <cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDatetime(form.GELdesde)#">
				<cfif LSParseDatetime(form.GELdesde) GT LSParseDatetime(form.GELhasta)>
				 	<cfset form.GELhasta = form.GELdesde>
				</cfif>
				 , GELhasta	= <cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDatetime(form.GELhasta)#">
				</cfif>
				<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0>
					,CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">
					,GELtipoP=0
				<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
					,CCHid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					,GELtipoP=1
				</cfif>
				<cfif isdefined ('form.GEAviatico')>
					,GEAviatico = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAviatico#">
					,GEAtipoviatico = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">
				</cfif>
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfset sbVerificaCF_Moneda()>
		<cfquery name="ActualizaDet" datasource="#session.dsn#">
			update GEliquidacionGasto
			   set  TESid = #session.Tesoreria.TESid#
					, CFid = #session.Tesoreria.CFid#
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>

		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
					method="sbTotalesLiquidacion"
					GELid = "#form.GELid#"
					tipo  = "LIQUIDACION"
					cambiarTC = "#numberFormat(rsLiq.GELtipoCambio,"9.9999") NEQ numberFormat(form.GELtipoCambio,"9.9999")#"
		/>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(GELid)#&tab=1">
</cfif>

<!---Eliminar--->
<cfif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery name="ElimianaDepo" datasource="#session.DSN#">
			delete from GEliquidacionDeps
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			delete from GEliquidacionTCE
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

		<cfquery name="EliminaDet" datasource="#session.dsn#">
			delete from GEliquidacionGasto
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

       <!---SML 16/01/2015. Inicio Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->

       	<cfquery name="EliminaDet" datasource="#session.dsn#">
			delete from CERepoTMP
			where ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

       <!---SML 16/01/2015. Fin Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->
		<cfquery name="LiberaAnticipos" datasource="#session.DSN#">
			select
					a.GEAid,
					a.GEADid,
					a.TESDPaprobadopendiente,
					b.GEAid,
					b.GEADid,
					b.GELAtotal
			from
				 GEanticipoDet a
				 inner join GEliquidacionAnts b
				on a.GEAid = b.GEAid
				and a.GEADid = b.GEADid
			where b.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

		<cfquery name="ElimianaDepo" datasource="#session.DSN#">
			delete from GEliquidacionDeps
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

		<cfquery name="AntiXLiquidar" datasource="#session.dsn#">
			delete from  GEliquidacionAnts
			where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

        <cfquery name="EliminaViaticos" datasource="#session.dsn#">
			delete from  GEliquidacionViaticos
			where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>


		<cfquery name="EliminaEnc" datasource="#session.dsn#">
			delete from GEliquidacion
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!------------------------------------------ Enviar al proceso de aprobación ---------------------------------------->

<cfif IsDefined("form.CerrarVacia")>	<!---Envia la liquidacion Al proceso de Aprobacion--->
	<!--- La Comision se Finaliza cuando no hay anticipos vivos --->
	<cfquery datasource="#session.dsn#" name="rsLiquidacion">
		Select
			GELnumero,
			GECid as GECid_comision,
			GELtotalGastos,
			GELtotalAnticipos,
			GELtotalDevoluciones,
			GELtotalTCE,
			GELtotalDepositos,
			GELtotalDepositosEfectivo
		  from GEliquidacion
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfset LvarVacia = rsLiquidacion.GELtotalGastos EQ 0 and rsLiquidacion.GELtotalAnticipos EQ 0 and rsLiquidacion.GELtotalTCE EQ 0 and rsLiquidacion.GELtotalDepositos EQ 0 and rsLiquidacion.GELtotalDepositosEfectivo EQ 0>
	<cfif NOT LvarVacia>
		<cfthrow type="toUser" message="La Liquidación ## #rsLiquidacion.GELnumero# no está vacía">
	</cfif>
	<cfquery name="rsGEC" datasource="#session.DSN#">
		select GECid as GECid_comision, GECnumero, GECestado
		  from GEcomision
		 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
	<cfif rsLiquidacion.GECid_comision NEQ rsGEC.GECid_comision>
		<cfthrow type="toUser" message="La Liquidación ## #rsLiquidacion.GELnumero# no pertenece a la Comisión ## #rsGEC.GECnumero#">
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad, min(GEAestado) as GEAestado
		  from GEanticipo ae
		 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
		   and GEAestado NOT in (3,6)	<!--- Vivos = cualquier estado menos Cancelado y Liquidado Total --->
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<!--- 0=En Preparacion,1=En Aprobacion,2=Aprobada sin pagar,3=Rechazada,4=Pagada sin liquidar,5=Liquidada parcialmente,6=Terminado --->
		<cfif rsSQL.GEAestado EQ 0>
			<cfthrow type="toUser" message="Existen Anticipos en Preparación para la Comisión ## #rsGEC.GECnumero#">
		<cfelseif rsSQL.GEAestado EQ 1>
			<cfthrow type="toUser" message="Existen Anticipos en Aprobación para la Comisión ## #rsGEC.GECnumero#">
		<cfelseif rsSQL.GEAestado EQ 2>
			<cfthrow type="toUser" message="Existen Anticipos Aprobados sin Pagar para la Comisión ## #rsGEC.GECnumero#">
		<cfelse>
			<cfthrow type="toUser" message="Todavía existen Anticipos sin Liquidar #rsSQL.GEAestado# para la Comisión ## #rsGEC.GECnumero#">
		</cfif>
	</cfif>
	<cfif rsGEC.GECestado EQ 3>
		<cfthrow type="toUser" message="La comisión ## #rsGEC.GECnumero# está cancelada">
	</cfif>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update GEliquidacion
			   set GELestado = 4		<!--- Finalizado --->
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update GEcomision
			   set  GECestado = 4		<!--- Terminada --->
			 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
		</cfquery>
	</cftransaction>
	<cf_SP_imprimir location="#LvarSAporEmpleadoCFM#">
</cfif>

<cfif IsDefined("form.AAprobar")>	<!---Envia la liquidacion Al proceso de Aprobacion--->
	<cfset sbVerificaCF_Moneda()>

	<!---Validaciones antes del proceso de Validacion--->
	<cfquery datasource="#session.dsn#" name="rsLiquidacion">
		select 	TESBid,Mcodigo,Ecodigo,GELreembolso,GELtotalGastos,GELestado,
				GELid, CCHTid, CFid,GEAviatico,GEAtipoviatico, CCHid,
				case
					when a.CCHid is null then 'TES'
					when (select CCHtipo from CCHica where CCHid = a.CCHid) = 2 then 'TES'
					else 'CCH'
				end as GELtipoPago
		from GEliquidacion a
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfif not listfind("0,3",rsLiquidacion.GELestado)>
		<cf_errorCode	code = "51702" msg = "Esta liquidación se encuentra en un estado diferente de 'En preparación' por lo tanto no se puede enviar a aprobar o ser aprobada">
	<cfelseif rsLiquidacion.GELtipoPago EQ 'TES'>
		<!--- Cambia la Caja Especial de Efectivo --->
		<cfif rsLiquidacion.GELreembolso EQ 0>
			<!--- Asegura que si no hay pago adicional al empleado, el proceso se vaya por Tesoreria --->
			<cfset form.formaPago = 0>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update GEliquidacion
			   set CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#" null="#form.FormaPago EQ 0#">
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>
	<cfelse>
		<cfset form.FormaPago = rsLiquidacion.CCHid>
	</cfif>

	<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="LiqDirAnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>

	<!---Si es viatico y nacional --->
	<cfif #rsInfoLiq.GEAviatico# eq 1 and #rsInfoLiq.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos nacionales definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoNacional">
			<cfinvokeargument name="DEid"  			value="#form.DEid#">
			<cfinvokeargument name="MontoAnt"  		value="#rsLiquidacion.GELtotalGastos#">
			<cfinvokeargument name="GELid"  		value="#form.GELid#">
		</cfinvoke>
	</cfif>

	<!---Envia La Liquidacion al Proceso de Aprobacion--->
	<cftransaction>
		<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica"
					method="TranProceso"
					returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
				<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
				<cfinvokeargument name="CCHTmonto"	 		value="#rsLiquidacion.GELtotalGastos#"/>
				<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHTtipo" 			value="GASTO"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
		</cfinvoke>

		<!--- Actulización del estado Liquidacion--->
		<cfquery name="ActualizaDet" datasource="#session.dsn#">
				update GEliquidacionGasto
				set  GELGestado = 1
				where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEliquidacion set
					GELestado =1
			where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>

        <!---Consulta en parametros de GE si envia correos al aprobador--->
        <cfquery name="rsEnviaEmail" datasource="#Session.DSN#">
        	select coalesce(Pvalor,'0') as Pvalor
		  	from Parametros
		 	where Ecodigo = #session.Ecodigo#
		   	and Pcodigo = 1217
        </cfquery>
     <cfquery name="rsPvalor" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Pcodigo = 15500
    </cfquery>
        <cfif rsEnviaEmail.Pvalor eq 1 >
        	<cfset LvarMonto=#rsLiquidacion.GELtotalGastos#>
        	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
            <cfquery name="rsAprobadores" datasource="#Session.DSN#">
                select
                        u.Usulogin
                        , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                        , cf.CFcodigo, cf.CFdescripcion
                        ,coalesce(Pemail1,Pemail2) as email
                from TESusuarioSP tu
                    inner join Usuario u
                        inner join DatosPersonales dp
                           on dp.datos_personales = u.datos_personales
                        on u.Usucodigo = tu.Usucodigo
                    inner join CFuncional cf
                        on cf.CFid = tu.CFid
                where tu.CFid 		= #form.CFid#
                and tu.TESUSPaprobador = 1
                and (TESUSPmontoMax=0 or TESUSPmontoMax>= #LvarMonto#)
            </cfquery>


            <!---Mails--->
            <cfloop query="rsAprobadores">
                <cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">

                <cfsavecontent variable="contenido">
                	<cfoutput>
                    <p>
                    Señor(a) #rsAprobadores.Usunombre#
                    <br /><br />
                    Se realizo la solicitud de la liquidación numero #form.GELnumero# para su aprobacion.
                    <br /><br />
                    Para ver el anticipo
                      <!---se hace la pregunta para saber cual link usar--->
						<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                            <a href="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/cfmx/proyecto7/gastosEmpleados.cfm">Firmese aqui</a>
                        <cfelse>
                            <a href="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/cfmx/sif/tesoreria/GestionEmpleados/LiquidacionAnticipos.cfm">Firmese aqui</a>
                        </cfif>
                    </cfoutput>
                </cfsavecontent>

				<cfif len(trim(rsAprobadores.email))>
                    <cfquery name="rsInserta" datasource="#Session.DSN#">
                        insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto,
                                                SMTPtexto, 		SMTPintentos, 		SMTPcreado,
                                                SMTPenviado, 	SMTPhtml, 			BMUsucodigo )
                        values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#enviadoPor#">, <!---agarra el nombre y apellidos de session--->
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsAprobadores.email#">, <!---#rsAprobadores.email#--->
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="Aprobacion de la liquidación numero:#form.GELnumero#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#contenido#">,
                                0,	#now()#,	#now()#,	1,
                                #Session.Usucodigo#
                                )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>

	</cftransaction>
	<cf_SP_imprimir location="#LvarSAporEmpleadoCFM#">
</cfif>


<!---                                                                Aprueba la Liquidacion                                                   --->

<cfif isdefined ('form.Aprobar')>
	<cfset sbVerificaCF_Moneda()>
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEliquidacion_Aprobar">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
	</cfinvoke>

	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cf_SP_imprimir location="#LvarSAporEmpleadoCFM#">
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&tipo=#url.tipo#">
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImpresion_form.cfm?GELid=#form.GELid#&url=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>


<!--------------------------- Mantenimiento a los diferentes detalles de la liquidacion ----------------------------->

<!--- Tab 2: NUEVO Gastos --->
<cfif isdefined ("form.NuevoDet")>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det&NuevoDet">
</cfif>

<!--- Tab 2: ALTA Gastos --->
<cfif IsDefined ("form.AltaDet")>
	<cfset sbVerificaCF_Moneda()>
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217,Mcodigo
		from Monedas
		where Ecodigo = #session.Ecodigo#
		and Mcodigo	  =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">
	</cfquery>

	<cfquery name="rsMDet" datasource="#session.dsn#">
		select Mcodigo from GEliquidacion where GELid=#form.GELid#
	</cfquery>
	<cfquery name="rsCF" datasource="#session.dsn#">
		select CFid from GEliquidacion where GELid=#form.GELid#
    </cfquery>
    <cfquery name="rsProveedor" datasource="#Session.DSN#">
		<cfif form.TipoProveedor EQ "SN">
			select SNidentificacion as id, SNnombre as nom
				from SNegocios
			where Ecodigo  = #session.Ecodigo#
			  and SNcodigo = #form.SNcodigo#
		<cfelse>
			select TESBeneficiarioId as id, TESBeneficiario as nom
				from TESbeneficiario
			where TESBid = #form.TESBid#
		</cfif>
    </cfquery>

	<cfset sbCalculaMontosDet()>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insertDet">
			insert INTO GEliquidacionGasto
				(
					GELid
					,CFid
					,GELGestado
					,GELGnumeroDoc
					,GELGtipo
					,GELGfecha
					,GELGdescripcion
					,GECid, Icodigo
					,Mcodigo

					,GELGimpNCFOri
					,GELGtipoCambio
					,GELGmontoOri 	,GELGmonto
					,GELGtotalOri 	,GELGtotal
					,GELGtotalRetOri,GELGtotalRet

					,BMUsucodigo
					,TESid
					,SNcodigo, TESBid
					,GELGproveedorId
					,GELGproveedor
					,Rcodigo
					,Ecodigo
					,FPAEid
					,CFComplemento
                    ,GELGreferencia
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.CFid#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#LvarTipoDocumento#">,
					<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_date">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGdescripcion#">,
					<cfif form.Tipo EQ -1>
						null, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Concepto#">,
					<cfelseif LvarConPlanCompras>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ConceptoGasto#">, null,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">, null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.GELGimpNCFOri,",","","ALL")#">,

						<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTC#">,

						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarMontoOri#">,2),


						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarMontoLiq#">,2),


						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalOri#">,2),
						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalLiq#">,2),
						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalRetOri#">,2),
						round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalRetLiq#">,2),

					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
					<cfif form.TipoProveedor EQ "SN">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">, null,
					<cfelse>
						null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rcodigo#" null="#form.Rcodigo EQ -1#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					</cfif>
					<cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
					</cfif>
                    <cfif isdefined("form.GELGreferencia") and len(trim(form.GELGreferencia))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGreferencia#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="" voidnull>
					</cfif>
				)
			<cf_dbidentity1 datasource="#session.DSN#" name="insertDet">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertDet" returnvariable="LvarDetLiq">
		<cfset form.GELGid=LvarDetLiq>

		<cfset ActualizaTCE(false)>
		<cfset sbAjusteFactura()>

		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
					method="sbTotalesLiquidacion"
					GELid = "#form.GELid#"
                    GELGid ="#form.GELGid#"
					tipo  = "Gastos"
		/>
		<cfset sbObtieneCFcuentas(form.Tipo)>
		<!--- Se asocia el CFDI --->
			<cfif isdefined("form.ce_nombre_xTMP") and form.ce_nombre_xTMP NEQ "">
				<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
					<cfinvokeargument name="Documento" 		value="#form.GELGnumeroDoc#">
					<cfinvokeargument name="idDocumento" 	value="#form.GELid#">
					<cfinvokeargument name="idLinea" 		value="#LvarDetLiq#">
					<cfinvokeargument name="cod" 			value="#form.ce_nombre_xTMP#">
					<!--- <cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#"> --->
					<cfinvokeargument name="origen"			value="#form.ce_origen#">
				</cfinvoke>
			</cfif>


    </cftransaction>
    <!--- <cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det&NuevoDet&GEGid=#LvarDetLiq#&modoD=CAMBIO"> --->
	<!--- <cflocation url="LiquidacionAnticipos.cfm?tab=2&GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&modoN=N"> --->
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">
</cfif>

<!--- Tab 2: CAMBIO Gastos --->
<cfif IsDefined ("form.CambioDet")>
	<cfset sbVerificaCF_Moneda()>
    <cfquery name="rsProveedor" datasource="#Session.DSN#">
		<cfif form.TipoProveedor EQ "SN">
			select SNidentificacion as id, SNnombre as nom
				from SNegocios
			where Ecodigo  = #session.Ecodigo#
			  and SNcodigo = #form.SNcodigo#
		<cfelse>
			select TESBeneficiarioId as id, TESBeneficiario as nom
				from TESbeneficiario
			where TESBid = #form.TESBid#
		</cfif>
    </cfquery>

	<cfset sbCalculaMontosDet()>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="ActualizaDet">
			update GEliquidacionGasto
			   set
					GELGnumeroDoc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">,
					GELGfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_date">,
					GELGdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGdescripcion#">,
					Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">,
					GELGimpNCFOri = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.GELGimpNCFOri,",","","ALL")#">,

						GELGtipoCambio = <cfqueryparam cfsqltype="cf_sql_float" value="#LvarTC#">,

						GELGmontoOri	= round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarMontoOri#">,2),
						GELGmonto		= round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarMontoLiq#">,2),
						GELGtotalOri 	= round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalOri#">,2),
						GELGtotal		= round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalLiq#">,2),
						GELGtotalRetOri = round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalRetOri#">,2),
						GELGtotalRet	= round(<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTotalRetLiq#">,2),
					<cfif form.TipoProveedor EQ "SN">
						SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
						TESBid=null,
					<cfelse>
						SNcodigo=null,
						TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
					</cfif>
					GELGproveedorId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.id#">,
					GELGproveedor =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">,

					Rcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Rcodigo#" null="#form.Rcodigo EQ -1#">,
                    FPAEid =
					<cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    CFComplemento =
                    <cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">,
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
                    GELGreferencia =
                    <cfif isdefined("form.GELGreferencia") and len(trim(form.GELGreferencia))>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGreferencia#">
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="" voidnull>
                    </cfif>
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
		<cfset ActualizaTCE(true)>
		<cfset sbAjusteFactura()>
		<!--- Se asocia el CFDI --->
		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
			<cfinvokeargument name="idDocumento" 	value="#form.GELid#">
			<cfinvokeargument name="idLinea" 		value="#form.GELGid#">
			<!--- <cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#"> --->
			<cfinvokeargument name="origen"			value="TSGS">
		</cfinvoke>
        </cftransaction>
<!---<cf_dumptofile select = "select * from GEliquidacionGasto dl where dl.GELid=782
      and dl.GELGid= 5454">--->
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
					method="sbTotalesLiquidacion"
					GELid = "#form.GELid#"
					tipo  = "Gastos"
		/>
        <!---<cfquery name="rsVerif" datasource="#session.dsn#">
        	select *
            from GEliquidacionTCE
            where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
        </cfquery>
        <cf_dump var="#rsVerif#">--->

		<cfset sbObtieneCFcuentas(Form.GETid)>
<!---	</cftransaction>--->

    <!---YA APARECE CAMBIADO--->
<!---<cf_dumptofile select = "select * from GEliquidacionGasto dl where dl.GELid=782
      and dl.GELGid= 5454">--->


	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">
	<!--- <cflocation url="LiquidacionAnticipos.cfm?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&modoN=N"> --->
</cfif>

<!--- Tab 2: BAJA Gastos --->
<cfif IsDefined ("form.BajaDet")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from GEliquidacionTCE
			where GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>

		<cfquery datasource="#session.dsn#" name="EliminaDeta">
			delete from GEliquidacionGasto
			where GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>

        <!---SML 16/01/2015. Inicio Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->

       	<cfquery name="EliminaDet" datasource="#session.dsn#">
			delete from CERepoTMP
			where ID_Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>

       <!---SML 16/01/2015. Fin Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->

		<cfset sbAjusteFactura()>

		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
					method="sbTotalesLiquidacion"
					GELid = "#form.GELid#"
					tipo  = "Gastos"
		/>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det">

</cfif>

<!--- Tab 4: Devoluciones --->
<cfif isdefined ('form.AgregarD')>
	<cfquery name="inDevoluciones" datasource="#session.dsn#">
		update GEliquidacion set GELtotalDevoluciones=#replace(form.montoD,',','','ALL')# where GELid=#form.GELid#
	</cfquery>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#form.GELid#&tab=4">
</cfif>

<!--- Tab 6: Datos Comision --->
<cfif isdefined ('form.btnDatosComision')>
	<cfparam name="form.GECautomovil" default="0">
	<cfparam name="form.GEChotel" default="0">
	<cfparam name="form.GECavion" default="0">
	<cfquery datasource="#session.dsn#">
		update GEcomision
		   set GECdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GECdescripcion#">
			 , GECautomovil	= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECautomovil#">
			 , GEChotel		= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GEChotel#">
			 , GECavion		= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECavion#">
			 , GECobservacionesLiq		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservacionesliq#"  		len="255" voidNull>
			 , GECobservacionesResultado= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservacionesResultado#"  	len="255" voidNull>
			 , GECobservacionesExceso	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservacionesExceso#"  		len="255" voidNull>
		 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
	<cflocation url="#LvarSAporEmpleadoCFM#?GELid=#form.GELid#&tab=6">
</cfif>

<!--- IMPRIMIR --->
<cfif isdefined ("form.Imprimir")>
	<cfinclude template="LiquidacionImpresion_form.cfm">
</cfif>

<!-------------------------------------------- FUNCIONES ---------------------------------------------->

<!---Update Montos Totales Liquidacion --->
<cffunction name="ActualizaTCE">
	<cfargument name="Actualizar">

	<cfif Arguments.Actualizar>
		<cfif form.CBid_TCE EQ "-1">
			<cfquery datasource="#session.dsn#" name="rsTCE">
				delete from GEliquidacionTCE
				 where GELid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				   and GELGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
			</cfquery>
			<cfreturn>
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsTCE">
			select count(1) as cantidad
			  from GEliquidacionTCE
			 where GELid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
		<cfset Arguments.Actualizar = rsTCE.cantidad GT 0>
	<cfelseif form.CBid_TCE EQ "-1">
		<cfreturn>
	</cfif>

	<cfif Arguments.Actualizar>
		<cfquery datasource="#session.dsn#" name="rsTCE">
			update GEliquidacionTCE
			   set
					CBid_TCE		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid_TCE#">,
					GELTreferencia	= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GELTreferencia#">,
					GELTmontoOri	= round(<cfqueryparam cfsqltype="cf_sql_float" 	value="#form.GELTmontoOri#">,2),
					GELTmonto		= round(<cfqueryparam cfsqltype="cf_sql_float" 	value="#form.GELTmonto#">,2),
					GELTtipoCambio	= <cfqueryparam cfsqltype="cf_sql_float" 	value="#form.GELTtipoCambio#">,
					GELTmontoTCE	= round(<cfqueryparam cfsqltype="cf_sql_float" 	value="#form.GELTmontoTCE#">,2),
					GELTfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_date">
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsTCE">
			insert into GEliquidacionTCE (
				GELid, GELGid, CBid_TCE, GELTreferencia, GELTmontoOri, GELTmonto, GELTtipoCambio, GELTmontoTCE,
				GELTfecha
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GELid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GELGid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid_TCE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GELTreferencia#">,
				round(<cfqueryparam cfsqltype="cf_sql_float" 		value="#form.GELTmontoOri#">,2),

				round(<cfqueryparam cfsqltype="cf_sql_float" 		value="#form.GELTmonto#">,2),

				<cfqueryparam cfsqltype="cf_sql_float" 		value="#form.GELTtipoCambio#">,
				round(<cfqueryparam cfsqltype="cf_sql_float" 		value="#form.GELTmontoTCE#">,2),
				<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_date">
			)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="sbVerificaCF_Moneda" output="false" returntype="void">
	<cfquery name="rsF" datasource="#session.dsn#">
		select GELtipoP,CFid,CCHid,Mcodigo from GEliquidacion where GELid=#form.GELid#
	</cfquery>

	<cfif rsF.CCHid NEQ "">
		<cfquery name="rsValid" datasource="#session.dsn#">
			select c.CCHid, c.Mcodigo, f.CFid
			  from CCHica c
				left join CCHicaCF f
					 on f.CCHid=c.CCHid
					and f.CFid=#rsF.CFid#
			where c.CCHid=#rsF.CCHid#
		</cfquery>
		<cfif rsValid.CCHid eq "">
			<cfthrow message="No existe la Caja id=[#rsF.CCHid#]">
			<cf_errorCode	code = "50742" msg = "No se puede insertar la liquidación porque no existe concordancia entre el Centro Funcional, la moneda y la caja chica">
		<cfelseif rsValid.CFid EQ "">
			<cfthrow message="La Caja no está definida para el Centro Funcional indicado">
		<cfelseif rsValid.Mcodigo NEQ rsF.Mcodigo>
			<cfthrow message="La moneda de la Caja #rsF.CCHid# no corresponde con la moneda de la Liquidación">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="sbCalculaMontosDet">
	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		where a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

    <cfset TpoCambio = rsLiq.GELtipoCambio>

	<cfparam name="form.GELGtipoCambio" default="">

	<cfif form.McodigoDet EQ rsLiq.McodigoLocal>
		<!--- Moneda Local o NULL --->
		<cfset LvarTC = 1>
		<cfset LvarFC = 1 / rsLiq.GELtipoCambio>   <!---OK No cambia el Monto TCE--->

	<cfelseif form.McodigoDet EQ rsLiq.Mcodigo>
		<!--- Moneda Liquidacion --->
		<cfset LvarTC = rsLiq.GELtipoCambio>

		<!---<cfset LvarTC = replace(form.GELGtipoCambio,',','','ALL')>  OK Puede cambiar el Monto TCE--->
        <cfset LvarFC = 1>
        <!---<cfset LvarFC = LvarTC / TpoCambio>--->

	<cfelse>
		<!--- Otra Moneda --->
		<cfif form.GELGtipoCambio EQ "">
			<cfset form.GELGtipoCambio = 1>
		</cfif>
		<cfset LvarTC = replace(form.GELGtipoCambio,',','','ALL')> <!---OK Puede cambiar el Monto TCE--->

		<!---<cfset LvarFC = LvarTC / rsLiq.GELtipoCambio>--->

        <cfset LvarFC = 1 / rsLiq.GELtipoCambio>

	</cfif>

	<cfset LvarMontoOri	= replace(form.GELGmontoOri,',','','ALL')>
	<cfset LvarTotalOri	= replace(form.GELGtotalOri,',','','ALL')>
	<cfif isdefined('form.TotalRetenc') and len(trim(form.TotalRetenc))>
		<cfset LvarTotalRetOri	= replace(form.TotalRetenc,',','','ALL')>
	<cfelse>
		<cfset LvarTotalRetOri	= 0>
	</cfif>

	<cfset LvarMontoLiq	= 	(LvarMontoOri * LvarFC * 100) / 100>			<!---int  ACA CAMBIE--->

	<cfset LvarTotalLiq = 	(LvarTotalOri * LvarFC * 100) / 100>			<!---int  ACA CAMBIE--->

	<cfset LvarTotalRetLiq	= 	(LvarTotalRetOri * LvarFC * 100) / 100>	<!---int  ACA CAMBIE--->

	<cfif form.CBid_TCE NEQ "-1">
		<!--- 1=CBid, 2=Mcodigo, 3=Miso4217, 4=TC --->
		<cfset LvarMcodigoTCE		= listGetAt(form.CBid_TCE,2,"|")>
		<cfset form.CBid_TCE		= listGetAt(form.CBid_TCE,1,"|")>

		<cfparam name="form.GELTtipoCambio" default="">
		<cfif LvarMcodigoTCE EQ rsLiq.McodigoLocal OR form.GELTtipoCambio EQ "">
			<!--- Moneda Local o NULL --->
			<cfset LvarTC_TCE = 1>
            <cfif form.GELTtipoCambio NEQ "">
            	<cfset LvarTC = replace(form.GELGtipoCambio,',','','ALL')>  <!---OK Puede cambiar el Monto TCE--->
            </cfif>
			<cfset LvarFC_TCE = LvarTC_TCE / LvarTC>

		<cfelseif LvarMcodigoTCE EQ rsLiq.Mcodigo>
			<!--- Moneda Liquidacion --->
			<cfset LvarTC_TCE = rsLiq.GELtipoCambio>
			<cfset LvarTC = replace(form.GELGtipoCambio,',','','ALL')>  <!---OK Puede cambiar el Monto TCE--->

			<cfset LvarFC_TCE = LvarTC_TCE / LvarTC>

		<cfelseif LvarMcodigoTCE EQ form.McodigoDet>
			<!--- Moneda Documento --->
			<cfset LvarTC_TCE = LvarTC>
			<cfset LvarFC_TCE = LvarFC>
		<cfelse>
			<!--- Otra Moneda --->
			<cfset LvarTC_TCE = replace(form.GELTtipoCambio,",","","ALL")>

			<cfset LvarFC_TCE = LvarTC_TCE / LvarTC>

		</cfif>

		<cfset form.GELTtipoCambio	= LvarTC_TCE>

		<cfset form.GELTmontoOri	= replace(form.GELTmontoOri,",","","ALL")>
		<cfset form.GELTmonto	   	= replace(form.GELTmonto,",","","ALL")> <!---(form.GELTmontoOri * LvarFC * 100) / 100>--->
		<cfset form.GELTmontoTCE	= replace(form.GELTmontoTCE,",","","ALL")> <!---(form.GELTmontoOri / LvarFC_TCE * 100) / 100 >--->
	</cfif>


</cffunction>

<cffunction name="sbAjusteFactura">
	<!--- Ajusta datos de encabezado de factura: Fecha, Socio/Beneficiario, Moneda, TC Doc, Retencion --->
	<cfif IsDefined ("form.BajaDet")>
		<cfquery datasource="#session.dsn#" name="rsFacs">
			select GELGnumeroDoc, GELGproveedor
			  from GEliquidacionGasto
			 where GELid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELGid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
		<cfset form.GELGnumeroDoc	= rsFacs.GELGnumeroDoc>
		<cfset rsProveedor.nom		= rsFacs.GELGproveedor>
	</cfif>
	<cfquery datasource="#session.dsn#" name="rsFacs">
		select 	count(1) as cantidad
		  from GEliquidacionGasto g
		 where GELid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		   and GELGid		 <><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		   and GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
		   and GELGproveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">
	</cfquery>
	<cfif rsFacs.cantidad GT 0>
		<cfquery datasource="#session.dsn#" name="rsFacs">
			select 	count(distinct GELGtipoCambio) as TCs,
					coalesce(sum(g.GELGmonto - g.GELGtotalRet),0) as totalPagado
			  from GEliquidacionGasto g
			 where GELid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
			   and GELGproveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsTCEs">
			select 	count(1) as cantidad,
					coalesce(sum(lt.GELTmonto),0) as totalPagado
			  from GEliquidacionGasto lg
					inner join GEliquidacionTCE lt
						on lt.GELGid = lg.GELGid
			 where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and lg.GELGid		<><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
			   and lg.GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
			   and lg.GELGproveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">
		</cfquery>
		<cfif rsTCEs.cantidad GT 0 and rsFacs.TCs GT 1>
			<cfthrow message="No se puede cambiar el tipo de cambio de una factura con varias líneas porque tiene pagos con TCE">
		<cfelseif rsTCEs.totalPagado GT rsFacs.totalPagado>
			<cfthrow message="Existen más pagos con TCE que monto de factura #rsTCEs.totalPagado# GT #rsFacs.totalPagado#">
		</cfif>

		<cfif IsDefined ("form.BajaDet")>
			<cfreturn>
		</cfif>
		<!---Se comento ya que modificaba el Rcodigo de los otros documentos
		 ,	Rcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Rcodigo#" null="#form.Rcodigo EQ -1#"> --->
		<cfquery datasource="#session.dsn#">
			update GEliquidacionGasto
			   set 	GELGfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_timestamp">
				 ,	GELGproveedorId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.id#">
				 ,	Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">
			<cfif rsFacs.TCs GT 1>
				<cfif form.McodigoDet EQ rsLiq.McodigoLocal>
					<cfset LvarTC = 1>
				<cfelseif form.McodigoDet EQ rsLiq.Mcodigo>
					<cfset LvarTC = rsLiq.GELtipoCambio>
				<cfelse>
					<cfset LvarTC = replace(form.GELGtipoCambio,',','','ALL')>
				</cfif>

				<cfset LvarFC = "1.0 * #LvarTC# / #rsLiq.GELtipoCambio#">

				 ,	GELGtipoCambio = #LvarTC#
				 ,  GELGtotal = round(GELGtotalOri * #LvarFC#,2)
				 ,  GELGmonto = round(GELGmontoOri * #LvarFC#,2)
				 ,  GELGtotalRet = round(GELGtotalRetOri * #LvarFC#,2)
			</cfif>
			 where GELid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELGid		 <><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
			   and GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
			   and GELGproveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">
		</cfquery>




		<cfquery datasource="#session.dsn#">
			update GEliquidacionTCE
			   set GELTfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_timestamp">
			<cfif rsFacs.TCs GT 1>
			</cfif>
			 where GELid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and (
			   		select count(1)
					  from GEliquidacionGasto
					 where GELid	= GEliquidacionTCE.GELid
					   and GELGid	= GEliquidacionTCE.GELGid
					   and GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
					   and GELGproveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProveedor.nom#">
					   and GELGid		 <><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
					) > 0
		</cfquery>
	</cfif>
</cffunction>


<!---CREA CUENTA FINANCIERA--->
<!---Mascara para la cuenta financiera--->
<cffunction name="sbObtieneCFcuentas">
	<cfargument name="tipo">

	<cfif LvarConPlanCompras>
		<cfquery datasource="#session.DSN#">
			update GEliquidacionGasto
			set CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
			PCGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCGDid#">
			where GELGid = #form.GELGid#
		</cfquery>
	<cfelseif Arguments.tipo NEQ -1>
		<cfquery name="rsCtas" datasource="#session.DSN#">
			select Liq.CFid, Liq.GECid as Com, LiqD.GECid, LiqD.CFComplemento, LiqD.GELGnoDeducMonto,
            	LiqCG.Cid, coalesce(LiqSN.SNid,-1) as SNid
			from GEliquidacionGasto LiqD
				inner join GEliquidacion Liq
					on Liq.GELid = LiqD.GELid
                inner join GEconceptoGasto LiqCG
                	on LiqD.GECid = LiqCG.GECid
                left join SNegocios LiqSN
                	on LiqD.Ecodigo = LiqSN.Ecodigo and LiqD.SNcodigo = LiqSN.SNcodigo
			where LiqD.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			  and LiqD.GELGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>

		<cfset varTipoItem = 'S'>
        <cfif isdefined("rsCtas.Com") and rsCtas.Com NEQ ''>
        	<cfset varTipoItem = 'G'>
        </cfif>

		<cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
			<cfinvokeargument name="CFid" 		value="#rsCtas.CFid#">
			<cfinvokeargument name="GECid" 		value="#rsCtas.GECid#">
			<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#">
			<cfinvokeargument name="tipoItem" 	value="#varTipoItem#">
			<cfinvokeargument name="SNid" 		value="#rsCtas.SNid#">
			<cfinvokeargument name="Aid" 		value="">
			<cfinvokeargument name="Cid" 		value="#rsCtas.Cid#">
			<cfinvokeargument name="ACcodigo" 	value="">
			<cfinvokeargument name="ACid" 		value="">
			<cfinvokeargument name="ActEcono" 	value="#rsCtas.CFComplemento#">
		</cfinvoke>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" value="#trim(LvarCFformato)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta de Gasto: #LvarError#">
		</cfif>
		<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
		<cfquery datasource="#session.DSN#">
			update GEliquidacionGasto
			set CFcuenta = #LvarCFcuenta#
			  , CFcuenta2 = null
			where GELGid = #form.GELGid#
		</cfquery>
		<cfif rsCtas.GELGnoDeducMonto GT 0>
			<cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
				<cfinvokeargument name="CFid" 		value="#rsCtas.CFid#">
				<cfinvokeargument name="GECid2" 	value="#rsCtas.GECid#">
				<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#">
				<cfinvokeargument name="tipoItem" 	value="G">
				<cfinvokeargument name="SNid" 		value="-1">
				<cfinvokeargument name="Aid" 		value="">
				<cfinvokeargument name="Cid" 		value="">
				<cfinvokeargument name="ACcodigo" 	value="">
				<cfinvokeargument name="ACid" 		value="">
				<cfinvokeargument name="ActEcono" 	value="#rsCtas.CFComplemento#">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" value="#trim(LvarCFformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#session.dsn#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfthrow message="Cuenta de Gasto No deducible: #LvarError#">
			</cfif>
			<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
			<cfquery datasource="#session.DSN#">
				update GEliquidacionGasto
				set CFcuenta2 = #LvarCFcuenta#
				where GELGid = #form.GELGid#
			</cfquery>
		</cfif>
	</cfif>
</cffunction>