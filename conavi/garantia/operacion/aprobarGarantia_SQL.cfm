<!---Estados
"1"  Estado Vigente 
"3"  Estado Aprobado 
"4"  Estado Rechazo 
"5"  Estado Ejecutada
"7"  Estado Liberado 
"8"  Estado Devuelta 
 ---->


<cfif isdefined('form.Aprobar_L')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select COEGid, COEGVersion
		from COLiberaGarantia
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="7" <!--- 'Liberada' --->
			returnvariable="LvarId"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_LIBERACION_GARANTIA_APRUEBA"
			COLGid="#form.COLGid#"
			COEGEstado="3" <!--- Liberacion aprobada --->
			FechaAprueba="#LSparsedatetime(form.fechaAp)#"
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaAprobarLiberacionGarantia.cfm">
<cfelseif isdefined('form.Rechazar_L')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select COEGid, COEGVersion
		from COLiberaGarantia
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="1" <!--- Vigente--->
			returnvariable="LvarId"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_LIBERACION_GARANTIA_RECHAZO"
			COLGid="#form.COLGid#"
			FechaRechazo="#now()#"
			COEGEstado="4" <!--- Rechazada--->
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaAprobarLiberacionGarantia.cfm">
<cfelseif isdefined('form.Aprobar_E')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select COEGid, COEGVersion
		from COLiberaGarantia
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
	
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="fnGenerarAsientoEjecucion"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			FechaGenAsiento="#LSparsedatetime(form.fecha)#"
			returnvariable="LvarId"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="4" <!--- En Ejecucion --->
			returnvariable="LvarId"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_LIBERACION_GARANTIA_APRUEBA"
			COLGid="#form.COLGid#"
			COEGEstado="3" <!--- Aprobada --->
			FechaAprueba="#LSparsedatetime(form.fecha)#"
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaAprobarEjecucionGarantia.cfm">
<cfelseif isdefined('form.Rechazar_E')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select COEGid, COEGVersion
		from COLiberaGarantia
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="1" <!--- Vigente--->
			returnvariable="LvarId"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_LIBERACION_GARANTIA_RECHAZO"
			COLGid="#form.COLGid#"
			FechaRechazo="#LSparsedatetime(form.fecha)#"
			COEGEstado="4" <!--- Rechazada--->
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaAprobarEjecucionGarantia.cfm">
<cfelseif isdefined('form.Aprobar_D')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select b.COEGid, b.COEGVersion, d.COTRGenDeposito
		from COLiberaGarantia a
			inner join COHEGarantia b
				inner join COHDGarantia c
					inner join COTipoRendicion d
						on d.COTRid = c.COTRid
					on c.COEGid = b.COEGid
				on b.COEGid = a.COEGid and b.COEGVersion = a.COEGVersion
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="fnGenerarAsientoDevolucion"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			FechaGenAsiento="#LSparsedatetime(form.fechaDE)#"
			returnvariable="LvarTESSPids"
		/>
		<cfquery name="rsConseEjecucionGarantia" datasource="#session.DSN#">
				select coalesce(max(COLGnumeroControl),0) + 1 as consecutivoControl 
				from COLiberaGarantia
				where COLGTipoMovimiento = 1 <!--- Liberacion --->
		  </cfquery>
   		 <cfset LvarConsecutivoControl = rsConseEjecucionGarantia.consecutivoControl>
   		<cfset FechaDev ="#LSparsedatetime(form.fechaDE)#">
		<cfquery name="ActNumDevolucion" datasource="#session.DSN#">
			update  COLiberaGarantia a
			   set  COLGnumeroControl = #LvarConsecutivoControl#
			     , COLGfechaDevolucion = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#FechaDev#">
			where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	     </cfquery>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA_DEVOLUCION"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="8" <!--- Devuelta --->
			COEGFechaDevOEjec="#LSparsedatetime(form.fechaDE)#"
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cfinclude template="popUpDevolucionGarantia.cfm">
<cfelseif isdefined('form.Finalizar')>
	<cfquery name="rsGarantia" datasource="#session.DSN#">
		select b.COEGid, b.COEGVersion, d.COTRGenDeposito
		from COLiberaGarantia a
			inner join COHEGarantia b
				inner join COHDGarantia c
					inner join COTipoRendicion d
						on d.COTRid = c.COTRid
					on c.COEGid = b.COEGid
				on b.COEGid = a.COEGid and b.COEGVersion = a.COEGVersion
		where COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
	</cfquery>
	<cftransaction>
		<cfinvoke component="conavi.Componentes.garantia"
			method="fnGenerarAsientoEjecutar"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			documento="#form.documento#"
			FechaGenAsiento="#LSparsedatetime(form.fechaDE)#"
			returnvariable="LvarTESSPids"
		/>
		<cfinvoke component="conavi.Componentes.garantia"
			method="CAMBIO_GARANTIA_EJECUCION"
			COEGid="#rsGarantia.COEGid#"
			COEGVersion="#rsGarantia.COEGVersion#"
			COEGEstado="5" <!--- Ejecutada --->
			COEGDocDevOEjec="#form.documento#"
			COEGFechaDevOEjec="#LSparsedatetime(form.fechaDE)#"
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaGarantiasEjecutadas.cfm">
</cfif>	