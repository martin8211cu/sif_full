<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfset mensajeDep="ERROR">

<cfif isdefined("form.AltaDep")>
	<cfquery name="my" datasource="#session.dsn#">
		select count(1) as cantidad from MLibros where BTid =#form.BTid# and CCHid=#listgetat(form.CCHid, 1, '|')# and MLdocumento='#form.referencia#'
	</cfquery>

	<cfquery name="busca" datasource="#session.dsn#">
		 select count(1) as cantidad from GEliquidacionDepsEfectivo
		 where 
		 GELDreferencia= <cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#"> 
		 and CCHid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CCHid, 1, '|')#">
	</cfquery>

	<cfif busca.cantidad neq 0 or my.cantidad neq 0>
		<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&MensajeDep=mensajeDep"> 
	</cfif>
	
	<cfset sbVerificaMLibros(listgetat(form.CCHid, 1, '|'),form.referencia,form.BTid)>
	<cftransaction>
		<cfquery name="insertadep" datasource="#session.dsn#">
				insert into GEliquidacionDepsEfectivo		
				(Ecodigo,			
				BMUsucodigo,
				Mcodigo,
				CCHid,
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
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CCHid, 2, '|')#">,
							<cfqueryparam  	cfsqltype="cf_sql_numeric" value="#listgetat(form.CCHid, 1, '|')#">,
							<cfqueryparam value="#LSparseDateTime(form.fechaDep)#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.tipoCambio#">,
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GELid#">,
							<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
							round(<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,2),
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
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Det">
</cfif>

<cfif isdefined("form.BajaDep")>
	<cftransaction>
		<cfquery name="eliminaDep" datasource="#session.dsn#">
			delete from GEliquidacionDepsEfectivo where GELDEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDEid#">
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
	<cfset sbVerificaMLibros(listgetat(form.CCHid, 1, '|'),form.referencia,form.BTid)>
	<cftransaction>
		<cfquery name="cambioDep" datasource="#session.dsn#">
			update GEliquidacionDepsEfectivo set 
				CCHid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CCHid, 1, '|')#">,
				BTid=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.BTid#">,
				GELDreferencia=<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
				GELDtotalOri=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,
				GELDfecha=<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#form.fechaDep#">,
				Mcodigo=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CCHid, 2, '|')#">,
				GELDtipoCambio=<cfqueryparam 	cfsqltype="cf_sql_float" 	value="#form.tipoCambio#">,
				GELDtotal=round(<cfqueryparam cfsqltype="cf_sql_money" value="#form.liqui#">,2)
			where GELDEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDEid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Deps"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Dep=#form.GELDEid#">
</cfif>

<cffunction name="sbVerificaMLibros" output="false" access="private">
	<cfargument name="CCHid"     type="numeric" required="yes">
	<cfargument name="MLdoc"    type="string" required="yes">
	<cfargument name="BTid"     type="numeric" required="yes">
	
	<cfquery name="rsMLibros" datasource="#session.dsn#">
		select count(1) as cantidad
		  from MLibros
		 where MLdocumento 	= '#Arguments.MLdoc#'
		   and BTid			= #Arguments.BTid#
		   and CCHid 		= #Arguments.CCHid#
	</cfquery>
	
	<cfif rsMLibros.cantidad GT 0>
		<cfquery name="rsBTran" datasource="#session.dsn#">
			select BTcodigo, BTdescripcion
			  from BTransacciones 
			 where BTid = #Arguments.BTid#
		</cfquery>
		<cf_errorCode	code = "51604"
						msg  = "El Documento '@errorDat_1@' con Transacción '@errorDat_2@=@errorDat_3@' ya está registrado en Libros Bancarios"
						errorDat_1="#Arguments.MLdoc#"
						errorDat_2="#rsBTran.BTcodigo#"
						errorDat_3="#rsBTran.BTdescripcion#"
		>
	</cfif>

	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

	<cfparam name="form.tipoCambio" default="">
	<cfif listgetat(form.CCHid, 2, '|') EQ rsLiq.McodigoLocal>
		<!--- Moneda Local o NULL --->
		<cfset form.tipoCambio = 1>
		<cfset LvarFC = 1 / rsLiq.GELtipoCambio>
	<cfelseif listgetat(form.CCHid, 2, '|') EQ rsLiq.Mcodigo>
		<!--- Moneda Liquidacion --->
		<cfset form.tipoCambio = rsLiq.GELtipoCambio>
		<cfset LvarFC = 1>
	<cfelse>
		<!--- Otra Moneda --->
		<cfif  form.tipoCambio EQ "">
			<cfset form.tipoCambio = 1>
		</cfif>
		<cfset form.tipoCambio = replace(form.tipoCambio,',','','ALL')>
		<cfset LvarFC = form.tipoCambio / rsLiq.GELtipoCambio>
	</cfif>

	<cfset form.montodep	= replace(form.montodep,',','','ALL')>
	<cfset form.liqui		= int(form.montodep * #numberFormat(LvarFC,"9.999999999")# * 100) / 100>
</cffunction>

