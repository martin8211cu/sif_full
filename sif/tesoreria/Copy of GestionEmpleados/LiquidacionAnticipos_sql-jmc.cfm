<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
<!---<cfdump var="#url#">
<cf_dump var="#form#">--->
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


<cfset LvarTipoDocumento = 7>
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfif isdefined ('form.btnRegresar')>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Nuevo=1">
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

	<cfquery name="empleado" datasource="#session.dsn#">
		select count(1) as cantidad 
		from TESbeneficiario 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.DEid#">
	</cfquery>
    
	<cfif empleado.cantidad EQ 0>
		<cfquery name="datos" datasource="#session.dsn#">
			select 
				DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEtelefono1,DEemail 
			from DatosEmpleado 
			where 
			DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		
		<cfset DEidenti = #datos.DEidentificacion#>
		<cfset DEnom=#datos.DEnombre#>
		<cfset DEtel=#datos.DEtelefono1#>
		<cfset DEema=#datos.DEemail#>
		<cfset DEid=#DEid#>
		<cfset DEape1=#datos.DEapellido1#>
		<cfset DEape2=#datos.DEapellido2#>
        
        <cfquery name="rsDuplicateKeyRow" datasource="#session.dsn#">
        	select count(1) as cantidad 
            from TESbeneficiario 
            where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
            and TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEidenti#">
        </cfquery>
        
        <cfif rsDuplicateKeyRow.cantidad EQ 0>
		
            <cfquery name="inserta" datasource="#session.dsn#">
                insert into TESbeneficiario(
                    CEcodigo,
                    TESBeneficiarioId,
                    TESBeneficiario,
                    TESBtelefono,
                    TESBemail,
                    DEid,
                    TESBactivo)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEidenti#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#DEnom# #DEape1# #DEape2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEtel#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEema#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">,
                    1)
            </cfquery>	
        </cfif>    
	</cfif>
</cfif>



<!---Agregar desde las listas--->
<cfif isdefined ('url.Anticipos')> 
	<!---tesoreria--->
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
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
				GELtotalGastos,
				GELtotalAnticipos,
				GELtotalDepositos,
				GELreembolso,
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
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewLiq.newLiq#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTipoDocumento#">, 
				<cfqueryparam  cfsqltype="cf_sql_integer" value="0">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfif isdefined('form.GELtotalGastos') and len(trim(form.GELtotalGastos))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtotalGastos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAtotalOri#">,
				<cfif isdefined('form.GELtotalDepositos') and len(trim(form.GELtotalDepositos))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtotalDepositos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfif isdefined('form.GELreembolso') and len(trim(form.GELreembolso))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELreembolso#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
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
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAtipoP#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAviatico#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAtipoviatico#">
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
			select count(1) as cantidad
			from CCHica c
			inner join Monedas m
			on m.Mcodigo=c.Mcodigo
			and m.Mcodigo=#form.McodigoE#
			inner join CCHicaCF f
			on f.CCHid=c.CCHid
			and f.CFid=#form.cboCFid#
			where c.CCHid=#form.FormaPago#
		</cfquery>
			<cfif rsValid.cantidad eq 0>
				<cf_errorCode	code = "50742" msg = "No se puede insertar la liquidación porque no existe concordancia entre el Centro Funcional, la moneda y la caja chica">
			</cfif>
	</cfif>
	<!---tesoreria--->
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
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
        <cfif beneficiario.recordcount eq 0>
        	<cfquery name="beneficiario" datasource="#session.dsn#">
                select TESBid as benef
                from TESbeneficiario
                where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
            	and TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DEidenti#">
			</cfquery>
        </cfif>
		<cfquery datasource="#session.dsn#" name="insert">
			insert into GEliquidacion (
				TESid, 
				CFid,
				Ecodigo, 
				GELnumero, 
				GELtipo, 
				GELestado, 
				Mcodigo,
				GELtotalGastos,
				GELtotalAnticipos,
				GELtotalDepositos,
				GELreembolso,
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
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewLiq.newLiq#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTipoDocumento#">, 
				<cfqueryparam  cfsqltype="cf_sql_integer" value="0">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoE#">,
				<cfif isdefined('form.GELtotalGastos') and len(trim(form.GELtotalGastos))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtotalGastos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfif isdefined('form.GELtotalAnticipos') and len(trim(form.GELtotalAnticipos))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtotalAnticipos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfif isdefined('form.GELtotalDepositos') and len(trim(form.GELtotalDepositos))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtotalDepositos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfif isdefined('form.GELreembolso') and len(trim(form.GELreembolso))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELreembolso#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#beneficiario.benef#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.GELdescripcion)#"null="#rtrim(form.GELdescripcion) EQ ""#">,
				<cfif isdefined('form.GELtipoCambio') and len(trim(form.GELtipoCambio))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELtipoCambio#">
				<cfelse>
					0
				</cfif>
				<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0>	
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">
					,0
				<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					,1
				</cfif>
				<cfif isdefined ('form.GEAviatico')> 
					,<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAviatico#">
					,<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">
				<cfelse>
						,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">
						,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">
				</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarID_liquidacion">
		<cfset form.IDliqui=#LvarID_liquidacion#>
	</cftransaction>
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(LvarID_liquidacion)#">
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
				GELtotalGastos = 
				coalesce(
				( select sum(GELGtotal)
				from GEliquidacionGasto g
				where g.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">),0),
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
		
		<cfquery name="EliminaDet" datasource="#session.dsn#">
			delete from GEliquidacionGasto
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
					<table border="1" width="100%" bordercolor="333399">
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
					<table border="1" width="100%" bordercolor="333399">
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
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217,Mcodigo
		from Monedas
		where Ecodigo = #session.Ecodigo#
		and Mcodigo	  =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">
	</cfquery>

<cfquery name="rsMDet" datasource="#session.dsn#">
	select Mcodigo from GEliquidacion where GELid=#form.GELid#
</cfquery>
<cfif rsMDet.Mcodigo neq form.McodigoDet>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&error=1">
</cfif>
<cfquery name="rsCF" datasource="#session.dsn#">
	select CFid from GEliquidacion where GELid=#form.GELid#
</cfquery>
<cftransaction>
<cfquery name="rsNombreSNegocio" datasource="#Session.DSN#">
	select SNnombre
		from SNegocios 
    where SNcodigo = #form.SNcodigo#
</cfquery>

        <cfif isdefined('form.GELGtotalOri')>
		        <cfset LvarMontoOri=  #replace(GELGtotalOri,',','','ALL')#>
		</cfif>
		<cfif isdefined('form.MontoAnti')>
		        <cfset LvarMontoAnti= #LSNumberFormat(form.MontoAnti,"0.00")#>
		 </cfif>

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
				,GELGtotalOri
				,GELGtotal
				,BMUsucodigo
				,TESid
				,SNcodigo
				,Rcodigo
				,GELGtotalRet
				,GELGtotalRetOri
				,Ecodigo
				
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
				<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoAnti#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoRetencionAnti#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.TotalRetenc#">,				
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertDet">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertDet" returnvariable="LvarDetLiq">
		<cfset #form.GELGid#=#LvarDetLiq#>	
		
</cftransaction>
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
			select LiqD.GELGid, cf.CFcuentac, cg.GECcomplemento
			from GEliquidacion Liq
				inner join CFuncional cf
				on cf.CFid = Liq.CFid
					inner join GEliquidacionGasto LiqD
					on LiqD.GELid = Liq.GELid
						inner join GEconceptoGasto cg
						on cg.GECid = LiqD.GECid
			where Liq.GELid = #form.GELid#
		</cfquery>
				
		<cfobject component="sif.Componentes.AplicarMascara" name="LvarOBJ">
				
		<cfloop query="rsCtas">
			<cfset LvarCFformato = LvarOBJ.AplicarMascara(rsCtas.CFcuentac, rsCtas.GECcomplemento)>
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" 
				method="fnGeneraCuentaFinanciera" 
				returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" value="#trim(LvarCFformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#session.dsn#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
				</cfinvoke>
					<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
					<cfset mensaje="ERROR">
						<cfquery name="borraDetalle" datasource="#session.dsn#">
							delete from GEliquidacionGasto where GELGid=#LvarDetLiq#
						</cfquery>	
						<cfthrow message="#LvarError#">
					</cfif>
			<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
				<cfquery datasource="#session.DSN#">
						update GEliquidacionGasto 
						set CFcuenta = #LvarCFcuenta#
						where GELGid = # rsCtas .GELGid#
				</cfquery>
		</cfloop>
	</cfif>
	
		<cfquery datasource="#session.dsn#" name="ActualizaEnca">
			update GEliquidacion
				set GELtotalGastos = 
						coalesce(
						( select sum(GELGtotal - GELGtotalRet)
							from GEliquidacionGasto
						   where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						)
						, 0)
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfset sbUpdate()>
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det&GEGid=#LvarDetLiq#">

</cfif>

<!--- MODIFICACION DETALLE --->

<cfif IsDefined ("form.CambioDet")>

<cfquery name="rsF" datasource="#session.dsn#">
	select GELtipoP,CFid,CCHid from GEliquidacion where GELid=#form.GELid#
</cfquery>

<cfif isdefined ('rsF.GELtipoP') and rsF.GELtipoP eq 0>
		<cfquery name="rsValid" datasource="#session.dsn#">
			select count(1) as cantidad
			from CCHica c
			inner join Monedas m
			on m.Mcodigo=c.Mcodigo
			and m.Mcodigo=#form.McodigoDet#
			inner join CCHicaCF f
			on f.CCHid=c.CCHid
			and f.CFid=#rsF.CFid#
			where c.CCHid=#rsF.CCHid#
		</cfquery>
	<cfif rsValid.cantidad eq 0>
		<cf_errorCode	code = "50742" msg = "No se puede insertar la liquidación porque no existe concordancia entre el Centro Funcional, la moneda y la caja chica">
	</cfif>
</cfif>
	<cftransaction>
		<!---<cf_dump var="#form#">--->
		<cfquery name="rsNombreSNegocio" datasource="#Session.DSN#">
			select SNnombre
				from SNegocios 
			where SNcodigo = #form.SNcodigo#
 		</cfquery>

		<cfif isdefined('form.GELGtotalOri')>
		        <cfset LvarMontoOri=  #replace(GELGtotalOri,',','','ALL')#>
		 <!---<cf_dump var= "#LvarMontoAnti#">--->
		</cfif>
		
		<cfif isdefined('form.MontoAnti')>
		        <cfset LvarMontoAnti= #LSNumberFormat(form.MontoAnti,"0.00")#>
		 <!---<cf_dump var= "#LvarMontoAnti#">--->
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="ActualizaDet">
			update GEliquidacionGasto 
			   set	
					GELGnumeroDoc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">,
					GELGfecha=<cfqueryparam value="#LSparseDateTime(form.GELGfecha)#" cfsqltype="cf_sql_timestamp">,
					GELGdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGdescripcion#">,
					GELGproveedor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNombreSNegocio.SNnombre#">,
					Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoDet#">,
					GELGtipoCambio=<cfif isdefined('form.GELGtipoCambio') and len(trim(form.GELGtipoCambio))>
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.GELGtipoCambio#">,
					<cfelse>
					0,
					</cfif>
					GELGtotalOri=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoOri#">,
					GELGtotal=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarMontoAnti#">,
					SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
					Rcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Rcodigo#">,		
					GELGtotalRet=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoRetencionAnti#">,
					GELGtotalRetOri=<cfqueryparam cfsqltype="cf_sql_money" value="#form.TotalRetenc#">				
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and   GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="ActualizaEnca">
			update GEliquidacion
				set GELtotalGastos = 
						coalesce(
						( select sum(GELGtotal-GELGtotalRet)
							from GEliquidacionGasto
						   where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
						)
						, 0)
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
	</cftransaction>
<cfset sbUpdate()>
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&GELGid=#URLEncodedFormat(form.GELGid)#&tab=2&Det">

</cfif>

<!--- ELIMINAR --->
<cfif IsDefined ("form.BajaDet")>
	<cfquery datasource="#session.dsn#" name="EliminaDeta">

		delete from GEliquidacionGasto
		where GELGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		update GEliquidacion
			set GELtotalGastos = 
					coalesce(
					( select sum(GELGtotal)
					    from GEliquidacionGasto
					   where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
					)
					, 0)
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
<cfset sbUpdate()>
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
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#URLEncodedFormat(form.GELid)#&tab=2&Det">
</cfif>

<cfif IsDefined("form.Nuevo")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?Nuevo=1&tab=2">
<!---<cfelse>
	<cflocation url="LiquidacionAnticipos.cfm">--->
</cfif>
<!---Update montos--->
<cffunction name="sbUpdate" output="false" access="private" >
	<cfif isdefined ('form.GELid') and #form.GELid# neq''>
<cfquery name="Resultados" datasource="#session.dsn#">
	select 
			GELtotalAnticipos,
			GELtotalDepositos,
			GELtotalGastos,
			GELreembolso
	from GEliquidacion 
	where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
</cfquery>
	<cfif #Resultados.GELtotalAnticipos# neq 0>
		<cfset anticipos=#Resultados.GELtotalAnticipos#>
	<cfelse>
		<cfset anticipos=0>
	</cfif>
	<cfif Resultados.GELtotalDepositos neq 0>
		<cfset depositos=Resultados.GELtotalDepositos>
	<cfelse>
		<cfset depositos=0>
	</cfif>
	<cfif Resultados.GELtotalGastos neq 0>
		<cfset gastos=#Resultados.GELtotalGastos#>
	<cfelse>
		<cfset gastos=0>
	</cfif>
	
	<cfset resultado=(gastos+depositos)- anticipos>
	<cfif #resultado# gte 0>
		<cfquery datasource="#session.dsn#" name="actu">
		update GEliquidacion set GELreembolso =#resultado#
		where GELid=#form.GELid#
		</cfquery>
		<cfelse>
		<cfquery datasource="#session.dsn#" name="actu">
		update GEliquidacion set GELreembolso =0.00
		where GELid=#form.GELid#
		</cfquery>
		
	</cfif>

</cfif>
</cffunction>





