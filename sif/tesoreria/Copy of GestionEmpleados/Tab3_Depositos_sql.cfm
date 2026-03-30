<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfset mensajeDep="ERROR">

<cfif isdefined("form.AltaDep")>
	<cfquery name="my" datasource="#session.dsn#">
		select count(1) as cantidad from MLibros where BTid =#form.BTid# and CBid=#listgetat(form.CBid, 1, '|')# and MLdocumento='#form.referencia#'
	</cfquery>

	<cfquery name="busca" datasource="#session.dsn#">
		 select count(1) as cantidad from GEliquidacionDeps
		 where 
		 GELDreferencia= <cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#"> 
		 and CBid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 1, '|')#">
	</cfquery>

	<cfif busca.cantidad neq 0 or my.cantidad neq 0>
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&MensajeDep=mensajeDep"> 
	</cfif>
	
	<cftransaction>
		<cfquery name="insertadep" datasource="#session.dsn#">
				insert into GEliquidacionDeps		
				(Ecodigo,			
				BMUsucodigo,
				Mcodigo,
				CBid,
				GELDfecha,
				GELDtipoCambio,
				GELid,
				GELDreferencia,
				GELDtotalOri,
				BTid,
				GELDtotal)
					values(
							#session.Ecodigo#,
							#session.usucodigo#,
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 2, '|')#">,
							<cfqueryparam  	cfsqltype="cf_sql_numeric" value="#listgetat(form.CBid, 1, '|')#">,
							<cfqueryparam value="#LSparseDateTime(form.fechaDep)#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.tipoCambio#">,
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GELid#">,
							<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
							<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,
							<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.BTid#">,
							<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.liqui#">
								)					
		</cfquery>	
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Deps"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3">
</cfif>

<cfif isdefined("form.NuevoDep")>
<!---<cfinclude template="LiquidacionAnticipos.cfm">--->
<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Det">
	<!---<html>
	<body>
	<cfoutput>
	<form name="xxx" method="post" action="LiquidacionAnticipos.cfm">
		<input type="hidden" name="GELid" value="#LvarID_liquidacion#"  />
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
	<cftransaction>
		<cfquery name="eliminaDep" datasource="#session.dsn#">
			delete from GEliquidacionDeps where GELDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Deps"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Det">
</cfif>

<cfif isdefined("form.CambioDep")>
	<cftransaction>
		<cfquery name="cambioDep" datasource="#session.dsn#">
			update GEliquidacionDeps set 
			CBid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 1, '|')#">,
			GELDreferencia=<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
			GELDtotalOri=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,
			GELDfecha=<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#form.fechaDep#">,
			Mcodigo=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 2, '|')#">,
			GELDtipoCambio=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.tipoCambio#">,
			GELDtotal=<cfqueryparam cfsqltype="cf_sql_money" value="#form.liqui#">,
			BTid=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.BTid#">
			where
			GELDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Deps"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Dep=#form.GELDid#">
</cfif>
