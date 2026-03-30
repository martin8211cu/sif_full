<cfset mensajeDep="ERROR">

<cfif isdefined("form.AltaDep")>
	<cfquery name="busca" datasource="#session.dsn#">
		 select count(1) as cantidad from GASTOE_Deposito
		 where 
		 TESDepo_referencia= <cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#"> 
		 and CBid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CBid#">
	</cfquery>
	
		<cfif busca.cantidad neq 0>
			<cflocation url=                                                                            "LiquidacionAnticipos.cfm?ID_liquidacion=#URLEncodedFormat(LvarID_liquidacion)#&tab=3&MensajeDep=mensajeDep"> 
			</cfif>
	
	<cfquery name="insertadep" datasource="#session.dsn#">
			insert into GASTOE_Deposito		
			(Ecodigo,
			BMUsucodigo,
			Mcodigo,
			CBid,
			TESDepo_fecha,
			TESDepo_tipoCambio,
			ID_liquidacion,
			TESDepo_CuentaBanco,
			TESDepo_referencia,
			TESDepo_monto)
				values(
						#session.Ecodigo#,
						#session.usucodigo#,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.McodigoD#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CBid#">,
						<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#form.fechaDep#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.tipoCambio#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.ID_liquidacion#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CBid#">,
						<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.montodep#">
							)					
					</cfquery>	
			<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#form.ID_liquidacion#&tab=3">
</cfif>

<cfif isdefined("form.NuevoDep")>
<!---<cfinclude template="LiquidacionAnticipos.cfm">--->
<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#URLEncodedFormat(LvarID_liquidacion)#&tab=3">
	<!---<html>
	<body>
	<cfoutput>
	<form name="xxx" method="post" action="LiquidacionAnticipos.cfm">
		<input type="hidden" name="ID_liquidacion" value="#LvarID_liquidacion#"  />
		<input type="hidden" name="tab" value="3" />
	</form>
	</cfoutput>
	</body>
	</html>
<script>


	<cfoutput>
		document.xxx.submit();
	</cfoutput>
</script>--->

</cfif>

<cfif isdefined("form.BajaDep")>
		<cfquery name="eliminaDep" datasource="#session.dsn#">
			delete from GASTOE_Deposito where TESDepo_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDepo_id#">
		</cfquery>
	<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#URLEncodedFormat(LvarID_liquidacion)#&tab=3">
</cfif>

<cfif isdefined("form.CambioDep")>
		<cfquery name="cambioDep" datasource="#session.dsn#">
			update GASTOE_Deposito set 
			TESDepo_CuentaBanco=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CBid#">,
			TESDepo_referencia=<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
			TESDepo_monto=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,
			TESDepo_fecha=<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#form.fechaDep#">,
			Mcodigo=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">,
			TESDepo_tipoCambio=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.tipoCambio#">
			where
			TESDepo_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDepo_id#">
		</cfquery>
	<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#URLEncodedFormat(LvarID_liquidacion)#&tab=3">
</cfif>




<!---Actualizar el campo que suma los depositos--->
<cffunction name="sbUpdateDeposito" output="false" access="private">
	<cfquery datasource="#session.dsn#">
		update GASTOE_Eliquidacion
 		   set MT_Depositos = 
					coalesce(
					( 
						select sum(TESDepo_monto)
						  from GASTOE_Deposito
						 where ID_liquidacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_liquidacion#">
					)
					, 0)
		 where ID_liquidacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_liquidacion#">
	</cfquery>
</cffunction>
