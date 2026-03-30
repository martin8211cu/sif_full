<!---/-------------------------------------------------------------------------------------
-------------------------GUARDAR LIQUIDACION  DE RENTA CON DETALLE.------------------------
--------------------------------------------------------------------------------------/--->
<!---/-------------------------------------------------------------------------------------
-------------------------SE REQUIERE 	EL EIRid-------------------------------------------
--------------------------------------------------------------------------------------/--->
<cfparam name="Form.EIRid" type="numeric">
<cfparam name="Form.DEid" type="numeric">
<cfset lvarDEid = Form.DEid>
<!---/-------------------------------------------------------------------------------------
-------------------------OBTIENE LA TABLA DE RENTA SELECCIONADA----------------------------
--------------------------------------------------------------------------------------/--->
<cfquery name="rsIR" datasource="sifcontrol">
	select a.EIRid, 
		<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde, 
		<cf_dbfunction name="date_part"   args="yyyy, a.EIRdesde"> as periodoDesde,
		<cf_dbfunction name="date_part"   args="mm, a.EIRhasta"> -1 as mesHasta,
		<cf_dbfunction name="date_part"   args="yyyy, a.EIRhasta"> +1 as periodoHasta, 
		b.IRcodigo, 
		b.IRdescripcion
	from EImpuestoRenta a
		inner join ImpuestoRenta b
		on a.IRcodigo = b.IRcodigo
	where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
</cfquery>
<cfset lvarEIRid = rsIR.EIRid>
<cfset lvarPeriodoDesde = rsIR.periodoDesde>
<cfset lvarPeriodoHasta = rsIR.periodoHasta>
<cfif rsIR.mesDesde EQ 0><cfset lvarMesDesde = 12><cfelse><cfset lvarMesDesde = rsIR.mesDesde></cfif>
<cfif rsIR.mesHasta EQ 13><cfset lvarMesHasta = 1><cfelse><cfset lvarMesHasta = rsIR.mesHasta></cfif>

<!---/-------------------------------------------------------------------------------------
------------GUARDA LA LIQUIDACION DE LA RENTA CAPTURADA PARA UN PERIODO MES----------------
--------------------------------------------------------------------------------------/--->
<cffunction name="guardaLinea" access="private">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfquery name="rsplValidate" datasource="#session.dsn#">
		select 1 
		from RHLiquidacionRenta  
		where EIRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		  and DEid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
		  and Mes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		insert into RHLiquidacionRenta 
		(EIRid,DEid, Periodo, Mes, Ecodigo, 
		montopagoempresa, montootrospagos, montodeduccionesf, montoretencion, montootrasret, 
		BMUsucodigo, BMfechaalta)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
		0.00, 
		0.00, 
		0.00,
		0.00, 
		0.00, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
	</cfquery>
</cffunction>

<!--- FUNCION QUE RETORNA EL TOTAL DE INGRESOS --->
<cffunction name="GetIngresos" access="private" returntype="numeric">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfargument name="DEid" type="numeric" required="true">
	<cfquery name="rsIngresos"  datasource="#session.dsn#">
		select coalesce(sum(SEsalariobruto) + sum(SEincidencias) - sum(SEinorenta),0.00) as totalIngresos
		from CalendarioPagos a
			inner join HSalarioEmpleado b
			on b.RCNid = a.CPid
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		where a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
		  and a.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
		group by CPperiodo,CPmes,DEid
	</cfquery>
	<cfif isdefined('rsIngresos') and rsIngresos.RecordCount>
		<cfreturn rsIngresos.totalIngresos>
	<cfelse>
		<cfreturn 0>	
	</cfif>
</cffunction> 
<!--- FUNCION QUE RETORNA EL TOTAL DE CARGAS --->
<cffunction name="GetCargas" access="private" returntype="numeric">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfargument name="DEid" type="numeric" required="true">
	<cfquery name="rsCargas"  datasource="#session.dsn#">
		select sum(b.CCvaloremp + b.CCvalorpat) as totalCargas
		from CalendarioPagos a
			inner join HCargasCalculo b
			on b.RCNid = a.CPid
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		where a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">
		  and a.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">
		group by CPperiodo,CPmes,DEid
	</cfquery>
	<cfif isdefined('rsCargas') and rsCargas.RecordCount>
		<cfreturn rsCargas.totalCargas>
	<cfelse>
		<cfreturn 0>	
	</cfif>
</cffunction> 
<!--- FUNCION QUE RETORNA EL TOTAL DE OTROS GASTOS --->
<cffunction name="GetOtrosGastos" access="private" returntype="numeric">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfargument name="DEid" type="numeric" required="true">
	<cfquery name="rsOtrosGastos" datasource="#session.DSN#">
		select sum(ICmontores) as totalOtrosGastos
		from CalendarioPagos a
			inner join HIncidenciasCalculo b
			on b.RCNid = a.CPid
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			and CIid in (#ICRenta#)
		where a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">
		  and a.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">
		group by CPperiodo,CPmes,DEid
	</cfquery>
	<cfif isdefined('rsOtrosGastos') and rsOtrosGastos.RecordCount>
		<cfreturn rsOtrosGastos.totalOtrosGastos>
	<cfelse>
		<cfreturn 0>	
	</cfif>
</cffunction> 
<!--- FUNCION QUE RETORNA EL MONTO DEDUCIBLE DE RENTA 
	MONTO QUE SE REGISTRA COMO DEDUCIBLE DENTRO DE LA TABLA DE RENTA --->
<cffunction name="GetDeducible" access="private" returntype="numeric">
	<cfargument name="EIRid" type="numeric" required="true">
	<cfargument name="IRcodigo" type="string" required="true">
	<cfquery name="rsMonto" datasource="#session.DSN#">
		select coalesce(sum(DCDvalor),0) as DCDvalor
		from ConceptoDeduc b
		inner join DConceptoDeduc c
			  on c.CDid = b.CDid
		where b.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.IRcodigo#">
		  and c.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
	</cfquery>
	<cfreturn rsMonto.DCDvalor>
</cffunction>
<!--- FUNCION QUE RETORNA EL MONTO DE RENTA RETENIDO --->
<cffunction name="GetRenta" access="private" returntype="numeric">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfargument name="DEid" type="numeric" required="true">
	<cfquery name="rsRenta"  datasource="#session.dsn#">
		select coalesce(sum(SErenta),0.00) as totalRenta
		from CalendarioPagos a
			inner join HSalarioEmpleado b
			on b.RCNid = a.CPid
		where a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
		  and a.CPmes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
		  and b.DEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		group by CPperiodo,CPmes,DEid
	</cfquery>
	<cfif isdefined('rsIngresos') and rsIngresos.RecordCount>
		<cfreturn rsRenta.totalRenta>
	<cfelse>
		<cfreturn 0>	
	</cfif>	

</cffunction>
<!---  FUNCION QUE RETORNA LOS DATOS RELACIONADOS CON LA TABLA DE RENTA	 --->
<!--- FUNCTION QUE GUARDA EL DETALLE DE LA LIQUIDACION --->
<cffunction name="guardaDLinea" access="private">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfquery name="rsDLRlinea" datasource="#session.DSN#">
		select DLRlinea
		from RHDLiquidacionRenta
		where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">
		  and Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">
	</cfquery>
	<cfif rsDLRlinea.RecordCount>
		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update RHDLiquidacionRenta
			set  DLRseguroVida = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MontoSeguro,',','')#">, 
					DLRgastosMedicos = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MontoGastosMedicos,',','')#">, 
					DLRpensiones = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.montoPensiones,',','')#">, 
					DLRporcentajeBase = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.porcBase,',','')#">, 
					DLRdeduccionBase = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.DeducBase,',','')#">,
					DLRimpuestoFijo = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.ImpuestoFijo,',','')#">,
					DLRcreditoIva = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CreditoIva,',','')#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">
			  and DLRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDLRlinea.DLRlinea#">
		</cfquery>
	<cfelse>
		<cfquery name="rsDLRlinea" datasource="#session.DSN#">
			select coalesce(max(DLRlinea),0)+1 as DLRlinea
			from RHDLiquidacionRenta
			where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">
		</cfquery>
		<cfif rsDLRlinea.RecordCount>
			<cfset lvarDLRlinea = rsDLRlinea.DLRlinea - 1>
		<cfelse>
			<cfset lvarDLRlinea = 1>
		</cfif>
		<!--- TOTAL DE INGRESOS --->
		<cfset totalIngresos = GetIngresos(lthisperiodo,lthismes,lvarDEid)>
		<!--- TOTAL DE CARGAS --->
		<cfset totalCargas = GetCargas(lthisperiodo,lthismes,lvarDEid)>
		<!--- TOTAL DE OTROS GASTOS --->
		<cfset totalOtrosGastos =  GetOtrosGastos(lthisperiodo,lthismes,lvarDEid)>
		<!--- MONTO DEDUCIBLE DE IMPUESTOS --->
		<cfset montoDeducible = GetDeducible(form.EIRid, rsIR.IRcodigo)>
		<!--- TOTAL DE RENTA --->
		<cfset totalRenta = GetRenta(lthisperiodo,lthismes,lvarDEid)>
		<cfquery name="rsInsertaDetalle" datasource="#session.DSN#">
			insert into RHDLiquidacionRenta 
					(EIRid,DEid, Periodo, Mes,DLRlinea,
					DLRingresos, 
					DLRdeduccionPersonal, 
					DLRigss, 
					DLRseguroVida, 
					DLRgastosMedicos, 
					DLRpensiones, 
					DLRotrosGastos,
					DLRporcentajeBase, 
					DLRdeduccionBase, 
					DLRimpuestoFijo, 
					DLRretenciones,
					DLRcreditoIva,
					BMUsucodigo, 
					BMfechaalta)
					
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lthisperiodo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lthismes#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#lvarDLRlinea#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#totalIngresos#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#montoDeducible#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#totalCargas#">,
					0,0,0,
					<cfqueryparam cfsqltype="cf_sql_money" value="#totalOtrosGastos#">,
					0,0,0,
					<cfqueryparam cfsqltype="cf_sql_money" value="#totalRenta#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
		</cfquery>
	</cfif>
</cffunction>

<!--- FUNCION QUE GUARDA EL ENCABEZADO DE LA LIQUIDACIN. --->
<cffunction name="guardaEncabezado" access="private">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select sum(DLRingresos) as Ingresos,sum(DLRretenciones) as Retenciones, 
			sum(DLRdeduccionPersonal+DLRigss+DLRseguroVida+DLRgastosMedicos+DLRpensiones+DLRotrosGastos) as otrospagos
		from RHDLiquidacionRenta
		where EIRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		  and DEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
		  and Mes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
	</cfquery>
	<cfquery name="UpdateEncab" datasource="#session.DSN#">
		update RHLiquidacionRenta
		set montopagoempresa = montopagoempresa + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.Ingresos#">,
			montootrospagos = montootrospagos + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.otrospagos#">,
			montoretencion = montoretencion + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.Retenciones#">
		where EIRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		  and DEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
		  and Mes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
	</cfquery>
</cffunction>
<cftransaction>
<cfif isdefined('form.btnGuardar')>
	<!--- GUARDA LOS DATOS DE LA RENTA --->
	<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
		<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="1" to="12" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
			<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		</cfif>
	</cfloop>
	<cfset params = "">
<cfelseif isdefined("form.btnAplicar")>
	<!--- GUARDA LOS DATOS DE LA RENTA --->
	<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
		<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="1" to="12" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
			<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
				<cfset guardaDLinea(lthisperiodo,lthismes)>
				<cfset guardaEncabezado(lthisperiodo,lthismes)>
			</cfloop>
		</cfif>
	</cfloop>
	<!--- APLICA LA LIQUIDACION DE RENTA --->
	<cfquery datasource="#session.dsn#">
		update RHLiquidacionRenta 
		set Estado = 10
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
	</cfquery>
	<cfset params = "">
<cfelseif isdefined('form.btnGenerar')>
	<!--- INSERTAR EL ENCABEZADO DE LA LIQUIDACION --->
	<!--- GENERAR LOS DATOS DEL DETALLE DE LA LIQUIDACION DE RENTA --->
	<cfquery name="rsIngresos"  datasource="#session.dsn#">
		select CPperiodo, CPmes, 
			sum(SEsalariobruto) + sum(SEincidencias) - sum(SEinorenta) as totalIngresos,
			DEid
		from CalendarioPagos a
			inner join HSalarioEmpleado b
			on b.RCNid = a.CPid
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		where a.CPperiodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
		group by CPperiodo,CPmes,DEid
	</cfquery>
    <!--- CONCEPTOS INCIDENTES PARA TOMAR EN CUENTA --->
   <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="770" default="" returnvariable="ICRenta"/>
    <cfif Not Len(ICRenta)>
		<cf_throw message="No se han definido los Conceptos de Pago para tomar en cuenta en la Lquidacion de Renta. Proceso Cancelado." errorcode="5055">
	</cfif> 
	<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
		<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
				<cfset guardaLinea(lthisperiodo,lthismes)>
				<cfset guardaDLinea(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
			<cfloop from="1" to="12" index="lthismes"><cfdump var="#lthismes#">
				<cfset guardaLinea(lthisperiodo,lthismes)>
				<cfset guardaDLinea(lthisperiodo,lthismes)>
			</cfloop>
		<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
			<cfloop from="1" to="#lvarMesHasta#" index="lthismes"><cfdump var="#lthismes#">
				<cfset guardaLinea(lthisperiodo,lthismes)>
				<cfset guardaDLinea(lthisperiodo,lthismes)>
			</cfloop>
		</cfif>
	</cfloop>
	<cfset params = "">
<cfelse>
	<cfset params = "?EIRid=#lvarEIRid#">
</cfif>
</cftransaction>
<cflocation url="liquidacionRenta.cfm#params#">