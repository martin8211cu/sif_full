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
	
	<cfset sbVerificaMLibros(listgetat(form.CBid, 1, '|'),form.referencia,form.BTid)>
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
	<cfset sbVerificaMLibros(listgetat(form.CBid, 1, '|'),form.referencia,form.BTid)>
	<cftransaction>
		<cfquery name="cambioDep" datasource="#session.dsn#">
			update GEliquidacionDeps set 
				CBid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 1, '|')#">,
				BTid=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.BTid#">,
				GELDreferencia=<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
				GELDtotalOri=<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#form.montodep#">,
				GELDfecha=<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#form.fechaDep#">,
				Mcodigo=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#listgetat(form.CBid, 2, '|')#">,
				GELDtipoCambio=<cfqueryparam 	cfsqltype="cf_sql_float" 	value="#form.tipoCambio#">,
				GELDtotal=round(<cfqueryparam cfsqltype="cf_sql_money" value="#form.liqui#">,2)
			where GELDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Deps"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=3&Dep=#form.GELDid#">
</cfif>

<cffunction name="sbVerificaMLibros" output="false" access="private">
	<cfargument name="CBid"     type="numeric" required="yes">
	<cfargument name="MLdoc"    type="string" required="yes">
	<cfargument name="BTid"     type="numeric" required="yes">
	
	<cfquery name="rsMLibros" datasource="#session.dsn#">
		select count(1) as cantidad
		  from MLibros
		 where MLdocumento 	= '#Arguments.MLdoc#'
		   and BTid			= #Arguments.BTid#
		   and CBid 		= #Arguments.CBid#
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
	<cfif listgetat(form.CBid, 2, '|') EQ rsLiq.McodigoLocal>
		<!--- Moneda Local o NULL --->
		<cfset form.tipoCambio = 1>
		<cfset LvarFC = 1 / rsLiq.GELtipoCambio>
	<cfelseif listgetat(form.CBid, 2, '|') EQ rsLiq.Mcodigo>
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

<!------------------------------- DEPOSITOS EN EFECTIVO (no hay relacion con Depositos Bancarios ---------------------------------->
<cfif isdefined("form.AltaDepE")>
	<cfset sbVerificaGEmov()>
	<cftransaction>
		<cfquery name="insertadep" datasource="#session.dsn#">
				insert into GEliquidacionDepsEfectivo		
				(
					CCHid,
					GELDreferencia,
					GELDfecha,
					Mcodigo,
					GELDtotalOri,
					GELDtipoCambio,
					GELDtotal,
					GELid,

					Ecodigo,			
					BMUsucodigo
				)
				values (
			   		<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#LvarCCHid#">,
					<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
					<cfqueryparam 	cfsqltype="cf_sql_date" 	value="#LvarFecha#">,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#LvarMcodigo#">,
					<cfqueryparam 	cfsqltype="cf_sql_money" 	value="#LvarMontoDep#">,
					<cfqueryparam 	cfsqltype="cf_sql_float" 	value="#LvarTC#">,
					round(#LvarMontoDep#*#LvarTC#,2),

					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GELid#">,
					#session.Ecodigo#, #session.Usucodigo#
				)					
		</cfquery>	
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "DepsE"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=5">
</cfif>

<cfif isdefined("form.NuevoDepE")>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=5&Det">
</cfif>

<cfif isdefined("form.BajaDepE")>
	<cftransaction>
		<cfquery name="eliminaDep" datasource="#session.dsn#">
			delete from GEliquidacionDepsEfectivo 
			 where GELDEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDEid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "DepsE"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=5&Det">
</cfif>

<cfif isdefined("form.CambioDepE")>
	<cfset sbVerificaGEmov()>
	<cftransaction>
		<cfquery name="cambioDep" datasource="#session.dsn#">
			update GEliquidacionDepsEfectivo 
			   set 	CCHid			= <cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#LvarCCHid#">,
					GELDreferencia	= <cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#form.referencia#">,
					GELDfecha		= <cfqueryparam 	cfsqltype="cf_sql_date" 	value="#LvarFecha#">,
					Mcodigo			= <cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#LvarMcodigo#">,
					GELDtotalOri	= <cfqueryparam 	cfsqltype="cf_sql_money" 	value="#LvarMontoDep#">,
					GELDtipoCambio	= <cfqueryparam 	cfsqltype="cf_sql_float" 	value="#LvarTC#">,
					GELDtotal		= round(#LvarMontoDep#*#LvarTC#,2)
			  where GELDEid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDEid#">
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "DepsE"
		/>
	</cftransaction>
	<cflocation url="LiquidacionAnticipos#url.tipo#.cfm?GELid=#form.GELid#&tab=5&DepE=#form.GELDEid#">
</cfif>

<cffunction name="sbVerificaGEmov" output="false" access="private">
	
	<!--- Prepacion de datos --->
	<cfset LvarCCHid 	= listgetat(form.CCHid, 1, '|')>
	<cfset LvarFecha	= LSparseDateTime(form.fechaDep)>
	<cfset LvarMcodigo  = replace(listgetat(form.CCHid, 2, '|'),",","","ALL")>
	<cfset LvarMontoDep	= replace(form.montodepE,',','','ALL')>

	
	<cfif not isnumeric(form.referencia)>
		<cfthrow message="El Comprobante de Recepción de Efectivo no ha sido ingresado al sistema">
    </cfif>		

    <cfquery name="rsCEEmovs" datasource="#session.dsn#">
		select CCHEMid, GELid, CCHEMfecha, CCHEMmontoOri, CCHEMCancelado
		  from CCHespecialMovs
		 where CCHid		= #LvarCCHid#
		   and CCHEMtipo	= 'E'
		   and CCHEMnumero 	= #form.referencia#		  
	</cfquery>
	
	<cfquery name="rsCEE" datasource="#session.dsn#">
		select CCHtipo
		  from CCHica
		 where CCHid = #LvarCCHid#
	</cfquery>
	
	<cfif rsCEEmovs.CCHEMCancelado EQ 1>
		<cfthrow message="El deposito en efectivo ha sido cancelado.">
	</cfif>
	
	<cfif rsCEE.CCHtipo EQ 1>
		<!--- Caja Chica de Compras Menores: N/A --->
		<cfthrow message="Las Cajas Chicas de Compras Menores no pueden recibir Efectivo fuera de una Liquidación de Compras">
	<cfelseif rsCEE.CCHtipo EQ 2>
		<!--- Caja Especial de Recepción y Entrega de Efectivo: Debe existir el documento de Entrada y corresponder los datos digitados --->
		<cfif rsCEEmovs.CCHEMid EQ "">
			<cfthrow message="El Comprobante de Recepción de Efectivo no ha sido ingresado al sistema">
		<cfelseif dateFormat(rsCEEmovs.CCHEMfecha,"YYYYMMDD") NEQ dateFormat(LvarFecha,"YYYYMMDD")>
			<cfthrow message="El Comprobante de Recepción de Efectivo registrado no corresponde con la fecha indicada">
		<cfelseif rsCEEmovs.CCHEMmontoOri NEQ LvarMontoDep>
			<cfthrow message="El Comprobante de Recepción de Efectivo registrado no corresponde con el monto indicado">
		<cfelseif rsCEEmovs.GELid NEQ "">
			<cfthrow message="El Comprobante de Recepción de Efectivo ya fue utilizado en otra Liquidación">
		</cfif>		
	<cfelseif rsCEE.CCHtipo EQ 3>
		<cfif rsCEEmovs.CCHEMid NEQ "">
			<cfthrow message="El Comprobante de Recepción de Caja Externa ya fue ingresado al sistema">
		</cfif>		
	<cfelse>
		<cfthrow message="No se ha implementado este tipo de caja #rsCEE.CCHtipo#">
	</cfif>

	<!--- El documento no puede estar siendo usado en otra Liquidacion --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from GEliquidacionDepsEfectivo d
          	inner join GEliquidacion e
            	on e.GELid = d.GELid
		 where d.CCHid = #LvarCCHid#
		   and d.GELDreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">
		   and d.GELid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
           and e.GELestado <> 3
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfthrow message="El Comprobante de Recepcion de Efectivo está siendo utilizado en otra Liquidacion">
	</cfif>

	<!--- El documento no puede estar siendo usado 2 veces en la misma Liquidacion --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from GEliquidacionDepsEfectivo 
		 where CCHid = #LvarCCHid#
		   and GELDreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">
		   and GELid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0 and isdefined("form.AltaDepE") OR rsSQL.cantidad GT 1 and isdefined("form.CambioDepE")>
		<cfthrow message="El Comprobante de Recepcion de Efectivo ya está registrado en la Liquidacion">
	</cfif>

	<!--- Calculos de datos --->
	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

	<cfparam name="form.tipoCambio" default="1">
	<cfif LvarMcodigo EQ rsLiq.McodigoLocal OR form.tipoCambio EQ "" OR form.tipoCambio EQ 0>
		<!--- Moneda Local o NULL --->
		<cfset LvarTC = 1>
	<cfelseif LvarMcodigo EQ rsLiq.Mcodigo>
		<!--- Moneda Liquidacion --->
		<cfset LvarTC = rsLiq.GELtipoCambio>
	<cfelse>
		<!--- Otra moneda --->
		<cfset LvarTC = replace(form.tipoCambio,',','','ALL')>
	</cfif>
	<cfset LvarFC = LvarTC / rsLiq.GELtipoCambio>
	<cfset form.tipoCambio = LvarTC>
</cffunction>

