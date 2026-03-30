<!---/-------------------------------------------------------------------------------------
-------------------------GUARDAR LIQUIDACION  DE RENTA ------------------------------------
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
	select a.EIRid, datepart(mm,a.EIRdesde) as mesDesde, datepart(yy,a.EIRdesde) as periodoDesde, 
		datepart(mm,a.EIRdesde)-1 as mesHasta, datepart(yy,a.EIRdesde)+1 as periodoHasta, b.IRcodigo, 
		b.IRdescripcion
	from EImpuestoRenta a
		inner join ImpuestoRenta b
		on a.IRcodigo = b.IRcodigo
	where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
</cfquery>
<cfset lvarEIRid = rsIR.EIRid>
<cfset lvarPeriodoDesde = rsIR.periodoDesde>
<cfset lvarPeriodoHasta = rsIR.periodoHasta>
<cfset lvarMesDesde = rsIR.mesDesde>
<cfset lvarMesHasta = rsIR.mesHasta>
<!---/-------------------------------------------------------------------------------------
-------------------------GUARDA LA LIQUIDACION DE LA RENTA CAPTURADA-----------------------
--------------------------------------------------------------------------------------/--->
<cffunction name="guardaLinea" access="private">
	<cfargument name="periodo" type="numeric" required="true">
	<cfargument name="mes" type="numeric" required="true">
	<cfquery name="rsplValidate" datasource="#session.dsn#">
		select 1 from RHLiquidacionRenta  where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
		and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
	<cfif rsplValidate.recordcount gt 0>
		<cfquery datasource="#session.dsn#">
			update RHLiquidacionRenta 
			set montootrospagos=<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('pagoOtros#arguments.periodo##arguments.mes#'),',','','all')#">
			, montootrasret=<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('retencionOtros#arguments.periodo##arguments.mes#'),',','','all')#">
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			  and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">
			  and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
			  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert RHLiquidacionRenta 
			(EIRid,DEid, Periodo, Mes,Tipo, Ecodigo, montopagoempresa, montootrospagos, 
				montodeduccionesf, montoretencion, montootrasret, BMUsucodigo, BMfechaalta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="L">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Evaluate('pagoEmpresa#arguments.periodo##arguments.mes#'),',','','all')#">, 
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Evaluate('pagoOtros#arguments.periodo##arguments.mes#'),',','','all')#">, 
			0.00,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('retencionEmpresa#arguments.periodo##arguments.mes#'),',','','all')#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('retencionOtros#arguments.periodo##arguments.mes#'),',','','all')#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
		</cfquery>
	</cfif>
</cffunction>
<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
	<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
		<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
			<cfset guardaLinea(lthisperiodo,lthismes)>
		</cfloop>
	<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
		<cfloop from="1" to="12" index="lthismes">
			<cfset guardaLinea(lthisperiodo,lthismes)>
		</cfloop>
	<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
		<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
			<cfset guardaLinea(lthisperiodo,lthismes)>
		</cfloop>
	</cfif>
</cfloop>
<cfif isdefined("form.btnAplicar")>
	<cfquery datasource="#session.dsn#">
		update RHLiquidacionRenta 
		set Estado = 10
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
		and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
	</cfquery>
	<cfset params = "">
<cfelse>
	<cfset params = "?EIRid=#lvarEIRid#">
</cfif>
<cflocation url="liquidacionRenta.cfm#params#">