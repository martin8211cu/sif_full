<!---General
<cf_dump var="#form#">--->
<cfset mensaje="ERROR">
	<cfif isdefined ("form.GEADid") and len(trim(form.GEADid)) and isdefined('form.GEAid') and len(trim(form.GEAid)) >
			<cfquery name="id" datasource="#session.dsn#">
				select count(1) as cantidad from GEanticipo where
				Ecodigo		= #session.Ecodigo#
				and GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
			</cfquery>
			
			<cfquery name="selectAnti" datasource="#session.dsn#">
				select TESDPaprobadopendiente from
				GEanticipoDet  where
				GEADid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GEADid#">
			</cfquery>
	</cfif>

<cfif isdefined ("form.viatico") and #form.viatico# eq '1'>

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
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.GELid#">,
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
</cfif>

<cfif isdefined('form.Lista') >
	<!--- 
		Insertar Lneas de Anticipos Liquidables:
			Todas lneas de anticipos con saldo, que no estn en proceso de pago
	--->
	<cftransaction>
		<cfquery datasource="#session.DSN#">
			insert into GEliquidacionAnts (GELid, GEAid, GEADid, GELAtotal)
			select 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.GELid#">, 
					GEAid, GEADid, 
					GEADmonto - GEADutilizado - TESDPaprobadopendiente
			  from GEanticipoDet a
			 where GEAid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.GEAid#">
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
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Ants"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=1">
</cfif>
	
<!---BUSQUEDA--->
<cfif isdefined("Form.BuscarAnt")>
	<cfset modo="BuscarAnt">
	<cfset form.NumAnticipo=#form.NumAnticipo#>
	<cfset form.GELid=#form.GELid#>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?NumAnticipo=#form.NumAnticipo#">
</cfif>

<!---LIMPIAR--->
<cfif isdefined ("Form.Limpiar")>
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#">
</cfif>

<!---ELIMINAR--->
<cfif isdefined ("Form.BajaAnt")>
	<cftransaction>
		<cfquery name="elimina" datasource="#session.dsn#">
				delete from GEliquidacionAnts where 
				GELid=#form.GELid#
				and GEADid=#form.GEADid#
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Ants"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=1">
</cfif>

<!---MODIFICAR--->
<cfif isdefined("Form.CambioAnt")>
	<cfquery name="verifica" datasource="#session.dsn#">
		select
			GEADmonto,GEADutilizado,TESDPaprobadopendiente
		from
			GEanticipoDet
		where
			GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">				
	</cfquery>
			
	<cfset monto=0>
	<cfset total=verifica.GEADmonto>
	<cfset pendiente=verifica.TESDPaprobadopendiente>
	<cfset utilizado= verifica.GEADutilizado>
	<cfset anticipo=#form.MontoAnticipo#>
	<cfif #utilizado# gt 0 or #pendiente# gt 0>
		<cfset monto= total-(anticipo+utilizado+pendiente)>
	<cfelse>	
		<cfset monto= total-anticipo>
	</cfif>
	<cfif monto LT 0>					
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&Mensaje=#mensaje#&GEADid=#form.GEADid#&tab=1">
	<cfelse>
		<cftransaction>
			<cfquery name="modificaant" datasource="#session.dsn#">
				update GEliquidacionAnts set
				GELAtotal=<cfqueryparam 	cfsqltype="cf_sql_money" value="#form.MontoAnticipo#">
				where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				and
				GEADid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GEADid#">	
			</cfquery>
		
			<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
						method="sbTotalesLiquidacion" 
						GELid = "#form.GELid#" 		
						tipo  = "Ants"
			/>
		</cftransaction>
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&GEADid=#GEADid#&tab=1"> 
	</cfif>
</cfif>

<!---NUEVO--->
<cfif isdefined ("Form.NuevoAnt")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=1">
</cfif>

