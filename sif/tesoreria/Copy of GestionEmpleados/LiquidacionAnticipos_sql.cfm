<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">

<cfif IsDefined("form.CalcularViaticos")>
	<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GELid=#form.GELid#&CFid=#form.CFid#&GELfecha=#form.GELfecha#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
</cfif>
<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

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

<cfif isdefined ('form.btnRegresar')>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Nuevo=1">
</cfif>

<cfif isdefined ('form.RegresarDet')>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">
</cfif>

<cfif isdefined ('form.btnLista')>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm">
</cfif>

<cfif isdefined ('form.Anticipos')>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Anti=1">
</cfif>

<cfif isdefined ('form.AgregarD')>
	<cfquery name="inDevoluciones" datasource="#session.dsn#">
		update GEliquidacion set GELtotalDevoluciones=#replace(form.montoD,',','','ALL')# where GELid=#form.GELid#
	</cfquery>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3">
</cfif>

<!---Beneficiario/Empleado--->
<cfif IsDefined("form.Alta") or isdefined("form.Cambio")>

	<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
				method="Empleado_to_Beneficiario" 
				DEid = "#form.DEid#" 		
				returnvariable="form.TESBid">
</cfif>
	
<!---Agregar desde las listas--->
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
				GEAtipoviatico
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
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAmanual#">,	
				<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">,
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCCHid#" null="#LvarCCHid EQ ''#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGELtipoP#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAviatico#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAtipoviatico#">
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
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(LvarID_liquidacion)#">
</cfif>


<!---AGREGAR--->
<cfif IsDefined("form.Alta")>
	<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0 and form.FormaPago gt 0>
		<cfquery name="rsValid" datasource="#session.dsn#">
			select c.CCHid, c.Mcodigo, f.CFid
			  from CCHica c
				inner join Monedas m
					 on m.Mcodigo=c.Mcodigo
					--and m.Mcodigo=#form.McodigoE#
				left join CCHicaCF f
					 on f.CCHid=c.CCHid
					and f.CFid=#form.cboCFid#
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
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="form.GELid">
		<cfset form.IDliqui=#form.GELid#>

		<cfset sbVerificaCF_Moneda()>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#">
</cfif>

<!---Modifica--->
<cfif IsDefined("form.Cambio")>
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
		
	<cfset sbVerificaCF_Moneda()>
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
				<cfelse>
					GELtipoCambio = 0,
				</cfif>
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				GELdescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.GELdescripcion)#"	null="#rtrim(form.GELdescripcion) EQ ""#">
				<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0>	
					,CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">,
					GELtipoP=0
				<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
					,CCHid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					GELtipoP=1
				</cfif>
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfquery name="ActualizaDet" datasource="#session.dsn#">
			update GEliquidacionGasto 
			   set  TESid = #session.Tesoreria.TESid#
					, CFid = #session.Tesoreria.CFid#
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Gastos"
		/>
	</cftransaction>
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(GELid)#&tab=1">
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
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm">
</cfif>

<!---Ir a lista--->
<cfif IsDefined("form.irLista")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm">
</cfif>

<!---Nuevo--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Nuevo=1">
</cfif>

<!---Enviar a aprobar---> 
<cfif IsDefined("form.AAprobar")>	<!---Envia la liquidacion Al proceso de Aprobacion--->

	<!---Validaciones antes del proceso de Validacion--->	
	<cfquery name="rsValida" datasource="#session.dsn#">
		select count(1) as cantidad from GEliquidacion where GELid=#form.GELid# and GELestado not in(0,3)
	</cfquery>
	<cfif rsValida.cantidad gt 0>
		<cf_errorCode	code = "51702" msg = "Esta liquidación se encuentra en un estado diferente de 'En preparación' por lo tanto no se puede enviar a aprobar o ser aprobada">
	</cfif>
	
	<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="LiqDirAnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>
	
	<!---Si es viatico e interior --->
	<cfif #rsInfoLiq.GEAviatico# eq 1 and #rsInfoLiq.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos al interior definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoInt">
			<cfinvokeargument name="DEid"  			value="#form.DEid#">
			<cfinvokeargument name="MontoAnt"  		value="#form.GELtotalGastos#">
			<cfinvokeargument name="GELid"  		value="#form.GELid#">
		</cfinvoke>	
	</cfif>
	
	<cfset sbVerificaCF_Moneda()>

	<cfquery name="Busqueda" datasource="#session.dsn#">
		select TESBid,Mcodigo,Ecodigo,GELreembolso 
		  from GEliquidacion
		 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

	<cfif Busqueda.GELreembolso GT 0><!----- DEBE SER 4=Pagado--->		
			<cfquery name="rsAnticipos" datasource="#session.dsn#">
				select 
				a.GEAestado,
				a.TESBid,
				t.TESBeneficiario,
				a.GEAid,
				a.GEAnumero,  
				sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) as SaldoSinLiquidar,
				e.GELnumero,
				case e.GELestado
					when 0 then 'En Preparación'
					when 1 then 'En Aprobación'
					else '-'
				end as estado
					from GEanticipo a
						inner join GEanticipoDet b
							left join GEliquidacionAnts c 
								inner join GEliquidacion e
								on e.GELid  = c.GELid
								and e.GELestado  in (0,1)
							on  c.GEADid = b.GEADid
						on b.GEAid = a.GEAid
						inner join TESbeneficiario t
						on t.TESBid=a.TESBid
				where a.TESBid            = #Busqueda.TESBid#
					  and a.GEAestado      = 4  
					  and a.Mcodigo        = #Busqueda.Mcodigo#
					  and a.Ecodigo        = #Busqueda.Ecodigo#
                      <!--- and c.GELid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> Melissa eliminó este filtro en la versión 20679 del 20 de mayo del 2009, la cual se necesita en el BNValores. Hay que ver si es necesario ponerlo de nuevo --->
				group by a.GEAid,a.GEAnumero,a.TESBid,t.TESBeneficiario,a.GEAestado,e.GELnumero,e.GELestado
				having sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) > 0
			</cfquery>
			
<!---		<cfif rsAnticipos.recordcount gt 0>
			<cf_web_portlet_start border="true" titulo="Errores al Aplicar" skin="#Session.Preferences.Skin#">
				<cfoutput>
					<table width="100%">
						<tr>
							<td align="center" style="font-style:italic">
							El empleado tiene Anticipos Pagados sin Liquidar que debe Liquidar antes de poder reintegrarle dinero.
							</td>
						</tr>
					</table>
					<table border="0" width="100%" bordercolor="333399">
						<tr class="tituloListas">
							<td align="center">
							<strong>	NumeroAnticipo</strong>
							</td>				
							<td align="center">
							<strong>Saldo a Liquidar</strong>
							</td>	
							<td align="center">
							<strong>Num.Liquidación</strong>
							</td>	
							<td align="center">
							<strong>Estado Liquidación</strong>
							</td>						
						</tr>
						<cfloop query="rsAnticipos">
							<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td>#rsAnticipos.GEAnumero#</td>
								<td>#rsAnticipos.SaldoSinLiquidar#</td>
								<cfif len(trim(rsAnticipos.GELnumero)) gt 0>
								<td>#rsAnticipos.GELnumero#</td>					
								<cfelse>
									<td>No ha liquidado aun este anticipo</td>
								</cfif>	
								<td>#rsAnticipos.estado#</td>	
							</tr>
						</cfloop>
					</table>	
				</cfoutput>
			<cf_web_portlet_end>
			<cfabort>		
		<cfelse>--->
			<cfset LvarTipo='GASTO'><!---Envia La Liquidacion al Proceso de Aprobacion--->
			<cftransaction>
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
						<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
						<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
						<cfinvokeargument name="CCHTmonto"	 		value="#replace(form.GELtotalGastos,',','','ALL')#"/>
						<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
						<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
				</cfinvoke>				
				<!--- Actulización del estado Liquidacion--->
				<cfquery name="ActualizaDet" datasource="#session.dsn#">
						update GEliquidacionGasto 
						set  GELGestado = 1
						where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
				</cfquery>
				<cfquery name="rsActualiza" datasource="#session.DSN#">
					update GEliquidacion set 
							GELestado =1,
							CCHTid=#LvarCCHTidProc#
					where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
					and Ecodigo=#session.Ecodigo#
				</cfquery>
			</cftransaction>
			<cf_SP_imprimir location="LiquidacionAnticipos#url.tipo#.cfm">
	<!---	</cfif>--->
	<cfelse>
		<cfset LvarTipo='GASTO'>
			
		<!---Envia La Liquidacion al Proceso de Aprobacion--->
		<cftransaction>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
					<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
					<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
					<cfinvokeargument name="CCHTmonto"	 		value="#replace(form.GELtotalGastos,',','','ALL')#"/>
					<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
					<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
					<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
					<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
					<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
						<cfinvokeargument name="CCHid"   value="#form.CCHid#"/>
					</cfif>
			</cfinvoke>
			
		<!--- Actulización del estado Liquidacion--->
			<cfquery name="ActualizaDet" datasource="#session.dsn#">
					update GEliquidacionGasto 
					set  GELGestado = 1
					where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
			</cfquery>
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update GEliquidacion set 
						GELestado =1,
						CCHTid=#LvarCCHTidProc#
				where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		</cftransaction>
		<cf_SP_imprimir location="LiquidacionAnticipos#url.tipo#.cfm">
	</cfif>
</cfif>	


<!---                                                                Aprueba la Liquidacion                                                   --->

<cfif isdefined ('form.Aprobar')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select count(1) as cantidad from GEliquidacion where GELid=#form.GELid# and GELestado not in(0,3)
	</cfquery>
	<cfif rsValida.cantidad gt 0>
		<cf_errorCode	code = "51702" msg = "Esta liquidación se encuentra en un estado diferente de 'En preparación' por lo tanto no se puede enviar a aprobar o ser aprobada">
	</cfif>
	<cfset sbVerificaCF_Moneda()>
	<cfset montoG=#replace(form.GELtotalGastos,',','','ALL')#*#form.GELtipoCambio#>
	<cfquery name="rsCajaChica" datasource="#session.dsn#">
		select CCHid,CCHresponsable
		from CCHica 
		where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">
		and		Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="LiqDirAnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>
	
	<!---Si es viatico e interior --->
	<cfif #rsInfoLiq.GEAviatico# eq 1 and #rsInfoLiq.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos al interior definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoInt">
			<cfinvokeargument name="DEid"  			value="#form.DEid#">
			<cfinvokeargument name="MontoAnt"  		value="#form.GELtotalGastos#">
			<cfinvokeargument name="GELid"  		value="#form.GELid#">
		</cfinvoke>	
	</cfif>

	<!---Valida que el Usuario sea Aprobado para ese Centro Funcional--->
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
	
	<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
	<cfif LvarEsAprobadorSP>
	<!---Validaciones para Aprobacion--->	
		<cfquery name="Busqueda" datasource="#session.dsn#">
			select TESBid,Mcodigo,Ecodigo,GELreembolso from GEliquidacion
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>

		<cfif Busqueda.GELreembolso GT 0><!----- DEBE SER 4=Pagado--->		
			<cfquery name="rsAnticipos" datasource="#session.dsn#">
				select 
				a.GEAestado,
				a.TESBid,
				t.TESBeneficiario,
				a.GEAid,
				a.GEAnumero,  
				sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) as SaldoSinLiquidar,
				e.GELnumero,
				case e.GELestado
					when 0 then 'En Preparación'
					when 1 then 'En Aprobación'
					else '-'
				end as estado
					from GEanticipo a
						inner join GEanticipoDet b
							left join GEliquidacionAnts c 
								inner join GEliquidacion e
								on e.GELid  = c.GELid
								and e.GELestado  in (0,1)
							on <!---c.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
							and---> c.GEADid = b.GEADid
						on b.GEAid = a.GEAid
						inner join TESbeneficiario t
						on t.TESBid=a.TESBid
				where a.TESBid            = #Busqueda.TESBid#
					  and a.GEAestado      = 4  
					  and a.Mcodigo        = #Busqueda.Mcodigo#
					  and a.Ecodigo        = #Busqueda.Ecodigo#
				group by a.GEAid,a.GEAnumero,a.TESBid,t.TESBeneficiario,a.GEAestado,e.GELnumero,e.GELestado
				having sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) > 0
			</cfquery>				

<!---		<cfif rsAnticipos.recordcount gt 0>
			<cf_web_portlet_start border="true" titulo="Errores al Aplicar" skin="#Session.Preferences.Skin#">
				<cfoutput>
					<table width="100%">
						<tr>
							<td align="center" style="font-style:italic">
							El empleado tiene Anticipos Pagados sin Liquidar que debe Liquidar antes de poder reintegrarle dinero.
							</td>
						</tr>
					</table>
					<table border="0" width="100%" bordercolor="333399">
						<tr class="tituloListas">
							<td align="center">
							<strong>	NumeroAnticipo</strong>
							</td>				
							<td align="center">
							<strong>Saldo a Liquidar</strong>
							</td>	
							<td align="center">
							<strong>Num.Liquidación</strong>
							</td>	
							<td align="center">
							<strong>Estado Liquidación</strong>
							</td>						
						</tr>
						<cfloop query="rsAnticipos">
							<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td>#rsAnticipos.GEAnumero#</td>
								<td>#rsAnticipos.SaldoSinLiquidar#</td>
								<cfif len(trim(rsAnticipos.GELnumero)) gt 0>
								<td>#rsAnticipos.GELnumero#</td>					
								<cfelse>
									<td>No ha liquidado aun este anticipo</td>
								</cfif>	
								<td>#rsAnticipos.estado#</td>	
							</tr>
						</cfloop>
					</table>	
				</cfoutput>
			<cf_web_portlet_end>

					<cfabort>
			
				<!---Fin Validaciones Aprobacion--->		
			<cfelse>--->
				<cfif isdefined ('form.FormaPago') and form.FormaPago eq 0>
		
					<!--- Pago por Tesoreria--->
					<cfset LvarTipo='GASTO'>
					<!---Liquidacion Aprobacion--->
					<cftransaction>
					
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
								<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
								<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
								<cfinvokeargument name="CCHTmonto"	 		value="#montoG#"/>
								<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
								<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
								<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
								<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						</cfinvoke>
						<!--- Actulización del estado Liquidacion--->
						<cfquery name="ActualizaDet" datasource="#session.dsn#">
								update GEliquidacionGasto 
								set  GELGestado = 1
								where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						</cfquery>
						<cfquery name="rsActualiza" datasource="#session.DSN#">
							update GEliquidacion set 
									GELestado =1,
									CCHTid=#LvarCCHTidProc#
							where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
					<!---Proceso Aprobacion Tesoreria--->
						<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
						<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
						<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
						<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALTESORERIA">
							<cfinvokeargument name="GELid" 			value="#form.GELid#"/>
						</cfinvoke>
					</cftransaction>
					<cf_SP_imprimir location="LiquidacionAnticipos#url.tipo#.cfm">
				<cfelseif isdefined ('form.FormaPago') and FormaPago NEQ 0>
				 <!---Pago por Caja Chica--->	
					<cfset LvarTipo='GASTO'>
					<!---Liquidacion Aprobacion--->
					<cftransaction>
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
								<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
								<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
								<cfinvokeargument name="CCHTmonto"	 		value="#montoG#"/>
								<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
								<cfinvokeargument name="CCHidCustodio" 	value="#rsCajaChica.CCHresponsable#"/>
								<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
								<cfinvokeargument name="CCHid" 				value="#rsCajaChica.CCHid#"/>
								<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
								<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						</cfinvoke>
						
						<!--- Actulización del estado Liquidacion--->
						<cfquery name="ActualizaDet" datasource="#session.dsn#">
								update GEliquidacionGasto 
								set  GELGestado = 1
								where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						</cfquery>
						<cfquery name="rsActualiza" datasource="#session.DSN#">
							update GEliquidacion set 
									GELestado =1,
									CCHTid=#LvarCCHTidProc#
							where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						<!---Proceso Aprobacion Caja Chica--->
						<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALCAJACHICA">
							<cfinvokeargument name="GELid" 				value="#form.GELid#"/>
							<cfinvokeargument name="CCHid" 				value="#rsCajaChica.CCHid#"/>
						</cfinvoke>
					</cftransaction>
					<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
						<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&tipo=#url.tipo#">					
					</cfif>
				</cfif>
		<!---	</cfif>--->
		<cfelse>
			<cfif isdefined ('form.FormaPago') and form.FormaPago eq 0>
					<!--- Pago por Tesoreria--->
					<cfset LvarTipo='GASTO'>
					<!---Liquidacion Aprobacion--->
					<cftransaction>
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
								<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
								<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
								<cfinvokeargument name="CCHTmonto"	 		value="#montoG#"/>
								<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
								<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
								<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
								<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						</cfinvoke>
						
						<!--- Actulización del estado Liquidacion--->
						<cfquery name="ActualizaDet" datasource="#session.dsn#">
								update GEliquidacionGasto 
								set  GELGestado = 1
								where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						</cfquery>
						<cfquery name="rsActualiza" datasource="#session.DSN#">
							update GEliquidacion set 
									GELestado =1,
									CCHTid=#LvarCCHTidProc#
							where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						<!---Proceso Aprobacion Tesoreria--->
						<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
						<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
						<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
						<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALTESORERIA">
							<cfinvokeargument name="GELid" 					value="#form.GELid#"/>
						</cfinvoke>
					</cftransaction>
					<cf_SP_imprimir location="LiquidacionAnticipos#url.tipo#.cfm">
			<cfelseif isdefined ('form.FormaPago') and FormaPago NEQ 0>
				 <!---Pago por Caja Chica--->	
					<cfset LvarTipo='GASTO'>
					<!---Liquidacion Aprobacion--->
				
					<cftransaction>
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
								<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#"/>
								<cfinvokeargument name="CCHTdescripcion" 	value="#form.GELdescripcion#"/>
								<cfinvokeargument name="CCHTmonto"	 		value="#montoG#"/>
								<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
								<cfinvokeargument name="CCHidCustodio" 	value="#rsCajaChica.CCHresponsable#"/>
								<cfinvokeargument name="CCHTtipo" 			value="#LvarTipo#"/>
								<cfinvokeargument name="CCHid" 				value="#rsCajaChica.CCHid#"/>
								<cfinvokeargument name="CCHTrelacionada"    value="#form.GELid#"/>
								<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						</cfinvoke>
						
						<!--- Actulización del estado Liquidacion--->
						<cfquery name="ActualizaDet" datasource="#session.dsn#">
								update GEliquidacionGasto 
								set  GELGestado = 1
								where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						</cfquery>
						<cfquery name="rsActualiza" datasource="#session.DSN#">
							update GEliquidacion set 
									GELestado =1,
									CCHTid=#LvarCCHTidProc#
							where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						
						<!---Proceso Aprobacion Caja Chica--->
						<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALCAJACHICA">
							<cfinvokeargument name="GELid" 				value="#form.GELid#"/>
							<cfinvokeargument name="CCHid" 				value="#rsCajaChica.CCHid#"/>
						</cfinvoke>	
							
					</cftransaction>
					<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
						<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&tipo=#url.tipo#">					
					</cfif>
			</cfif>
		</cfif>
	<cfelse>
		<cf_errorCode	code = "50743" msg = "El Usuario no puede Aprobar. ">
	</cfif>	

	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&url=#LvarSAporEmpleadoCFM#">					
	</cfif>	
	<!---<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&tipo=#url.tipo#">					
	</cfif>	--->
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm">
</cfif>


<!---                                                      DETALLES DE LA LIQUIDACIÓN                                         --->

<!--- AGREGAR --->
<cfif IsDefined ("form.AltaDet")>
<!---<cf_dump var="#form#">--->
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
<!---<cfif rsMDet.Mcodigo neq form.McodigoDet>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&error=1">
</cfif>
--->
<cfquery name="rsCF" datasource="#session.dsn#">
	select CFid from GEliquidacion where GELid=#form.GELid#
    </cfquery>
    <cfquery name="rsNombreSNegocio" datasource="#Session.DSN#">
        select SNnombre
            from SNegocios 
        where SNcodigo = #form.SNcodigo#
    </cfquery>

	<cfif isdefined('form.GELGtotalOri')>
		<cfset LvarMontoOri	= #replace(form.GELGmontoOri,',','','ALL')#>
		<cfset LvarTotalOri	= #replace(form.GELGtotalOri,',','','ALL')#>
	</cfif>
    <cfif isdefined('form.GELGtotal')>
    	<cfset LvarTotalLiq = #replace(form.GELGtotal,',','','ALL')#>
		<cfset LvarMontoLiq	= int(LvarMontoOri * LvarTotalLiq / LvarTotalOri * 100) / 100>
    </cfif>

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
					,GELGproveedor
					,GECid
					,Mcodigo
					,GELGtipoCambio
					,GELGmontoOri
					,GELGtotalOri
					,GELGmonto
					,GELGtotal
					,BMUsucodigo
					,TESid
					,SNcodigo
					,Rcodigo
					,GELGtotalRet
					,GELGtotalRetOri
					,Ecodigo
					,FPAEid
					,CFComplemento
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.CFid#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#LvarTipoDocumento#">,
					<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNombreSNegocio.SNnombre#">,
					<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ConceptoGasto#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">,
					<cfif isdefined('form.GELGtipoCambio') and len(trim(form.GELGtipoCambio))>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELGtipoCambio#">,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoOri#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalOri#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoLiq#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalLiq#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoRetencionAnti,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TotalRetenc,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					</cfif>
					<cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
					</cfif>
				)
			<cf_dbidentity1 datasource="#session.DSN#" name="insertDet">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertDet" returnvariable="LvarDetLiq">
		<cfset form.GELGid=LvarDetLiq>	
	
		<cfset ActualizaTCE(false)>
	
		<!---CREA CUENTA FINANCIERA--->		
		<!---Mascara para la cuenta financiera--->	
		
		<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
			<cfquery datasource="#session.DSN#">
				update GEliquidacionGasto 
				set CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				PCGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCGDid#">				
				where GELGid = #form.GELGid#
			</cfquery>
		<cfelse>
			<cfquery name="rsCtas" datasource="#session.DSN#">
				select Liq.CFid, LiqD.GECid, LiqD.CFComplemento
				from GEliquidacionGasto LiqD
					inner join GEliquidacion Liq
						on Liq.GELid = LiqD.GELid
				where LiqD.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				  and LiqD.GELGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
			</cfquery>
			<cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
				<cfinvokeargument name="CFid" 		value="#rsCtas.CFid#">
				<cfinvokeargument name="GECid" 		value="#rsCtas.GECid#">
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
				<cfthrow message="#LvarError#">
			</cfif>
			<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
			<cfquery datasource="#session.DSN#">
				update GEliquidacionGasto 
				set CFcuenta = #LvarCFcuenta#
				where GELGid = #form.GELGid#
			</cfquery>
		</cfif>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Gastos"
		/>
    </cftransaction>
    <cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det&GEGid=#LvarDetLiq#">
</cfif>

<!--- MODIFICACION DETALLE --->

<cfif IsDefined ("form.CambioDet")>
	<cfset sbVerificaCF_Moneda()>
	<cftransaction>
		<!---<cf_dump var="#form#">--->
		<cfquery name="rsNombreSNegocio" datasource="#Session.DSN#">
			select SNnombre
				from SNegocios 
			where SNcodigo = #form.SNcodigo#
 		</cfquery>

		<cfset LvarMontoOri	= #replace(form.GELGmontoOri,',','','ALL')#>
		<cfset LvarTotalOri	= #replace(form.GELGtotalOri,',','','ALL')#>
		<cfset LvarTotalLiq= #replace(form.GELGtotal,',','','ALL')#>
		<cfset LvarMontoLiq	= int(LvarMontoOri * LvarTotalLiq / LvarTotalOri * 100) / 100>
		
		<cfquery datasource="#session.dsn#" name="ActualizaDet">
			update GEliquidacionGasto 
			   set	
					GELGnumeroDoc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">,
					GELGfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_timestamp">,
					GELGdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGdescripcion#">,
					GELGproveedor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNombreSNegocio.SNnombre#">,
					Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">,
					GELGtipoCambio=
						<cfif isdefined('form.GELGtipoCambio') and len(trim(form.GELGtipoCambio))>
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.GELGtipoCambio#">,
						<cfelse>
							0,
						</cfif>
					GELGmontoOri=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoOri#">,
					GELGtotalOri=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalOri#">,
					GELGtotal=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalLiq#">,
					GELGmonto=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoLiq#">,
					SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
					Rcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Rcodigo#">,		
					GELGtotalRet=<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoRetencionAnti,',','','ALL')#">,
					GELGtotalRetOri=<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TotalRetenc,',','','ALL')#">,
                    FPAEid =
					<cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    CFComplemento =
                    <cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
                    </cfif>	
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
		<cfset ActualizaTCE(true)>
		<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
            <cfquery datasource="#session.DSN#">
                update GEliquidacionGasto 
                set CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
                PCGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCGDid#">				
                where GELGid = #form.GELGid#
            </cfquery>
        <cfelse>
            <cfquery name="rsCtas" datasource="#session.DSN#">
                select Liq.CFid, LiqD.GECid, LiqD.CFComplemento
                from GEliquidacion Liq
                    inner join GEliquidacionGasto LiqD
                        on LiqD.GELid = Liq.GELid
                where Liq.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
                   and LiqD.GELGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
            </cfquery>
            <cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
            	<cfinvokeargument name="CFid" 		value="#rsCtas.CFid#">
                <cfinvokeargument name="GECid" 		value="#rsCtas.GECid#">
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
                <cfthrow message="#LvarError#">
            </cfif>
            <cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
            <cfquery datasource="#session.DSN#">
                update GEliquidacionGasto 
                set CFcuenta = #LvarCFcuenta#
                where GELGid = #form.GELGid#
            </cfquery>
        </cfif>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Gastos"
		/>
	</cftransaction>
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">

</cfif>

<!--- ELIMINAR --->
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
	
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Gastos"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det">

</cfif>
<!--- IR A LISTA --->
<cfif IsDefined ("form.irLista")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm">
</cfif>

<!--- IMPRIMIR --->
<cfif isdefined ("form.Imprimir")>
	<cfinclude template="LiquidacionImpresion_form.cfm">
</cfif>

<!--- NUEVO --->
<cfif isdefined ("form.NuevoDet")>
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det&NuevoDet">
</cfif>

<cfif IsDefined("form.Nuevo")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Nuevo=1&tab=2">
<!---<cfelse>
	<cflocation url="LiquidacionAnticipos.cfm">--->
</cfif>

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
	
	<cfset form.GELTmontoOri	= replace(form.GELTmontoOri,",","","ALL")>
	<cfset form.GELTmonto    	= replace(form.GELTmonto   ,",","","ALL")>
	<cfset form.GELTmontoTCE	= replace(form.GELTmontoTCE,",","","ALL")>
	<cfset form.GELTtipoCambio	= replace(form.GELTtipoCambio,",","","ALL")>
	<cfset form.CBid_TCE		= listGetAt(form.CBid_TCE,1,"|")>
	
	
	<cfif Arguments.Actualizar>
		<cfquery datasource="#session.dsn#" name="rsTCE">
			update GEliquidacionTCE
			   set	
					CBid_TCE		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid_TCE#">,
					GELTreferencia	= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GELTreferencia#">,
					GELTmontoOri	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.GELTmontoOri#">, 
					GELTmonto		= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.GELTmonto#">, 
					GELTtipoCambio	= <cfqueryparam cfsqltype="cf_sql_float" 	value="#form.GELTtipoCambio#">, 
					GELTmontoTCE	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.GELTmontoTCE#">
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsTCE">
			insert into GEliquidacionTCE (
				GELid, GELGid, CBid_TCE, GELTreferencia, GELTmontoOri, GELTmonto, GELTtipoCambio, GELTmontoTCE
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GELid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GELGid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid_TCE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GELTreferencia#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.GELTmontoOri#">, 
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.GELTmonto#">, 
				<cfqueryparam cfsqltype="cf_sql_float" 		value="#form.GELTtipoCambio#">, 
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.GELTmontoTCE#">
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
			<cfthrow message="La moneda de la Caja no corresponde con la moneda de la Liquidación">
		</cfif>
	</cfif>
</cffunction>
