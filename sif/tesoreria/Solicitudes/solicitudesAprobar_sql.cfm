<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfparam name="form.cboCambioTESid" default="">
<cfif IsDefined("form.chk")>
	<cfoutput>
	<cfloop index="LvarSPid" list="#form.chk#">
		<cfset LvarError 			= "">
		<cfset LvarEsAprobadorSP	= false>

		<cfquery name="rsForm" datasource="#session.dsn#">
			select CFid, TESSPnumero, TESSPtipoCambioOriManual, McodigoOri, TESSPtotalPagarOri
			  from TESsolicitudPago
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSPid#">
			   and EcodigoOri = #session.Ecodigo#
		</cfquery>
		<cfif session.Tesoreria.CFid_subordinados EQ 0>
			<cfset LvarCFid		= rsForm.CFid>
		<cfelse>
			<cfset LvarCFid		= session.Tesoreria.CFid_padre>			
		</cfif>
		
		<cfif LvarCFid EQ "">
			<cfset LvarEsAprobadorSP = true>
		<cfelse>
			<cfquery name="rsSPaprobador" datasource="#session.dsn#">
				Select TESUSPmontoMax
				  from TESusuarioSP
				 where CFid 		= #LvarCFid#
				   and Usucodigo	= #session.Usucodigo#
				   and TESUSPaprobador = 1
			</cfquery>

			<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>

			<!--- Verifica monto maximo aprobar --->
			<cfif LvarEsAprobadorSP AND rsSPaprobador.TESUSPmontoMax NEQ 0>
				<cfquery name="TCsug" datasource="#Session.DSN#">
					select Mcodigo
					  from Empresas
					 where Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfif TCsug.Mcodigo EQ rsForm.McodigoOri>
					<cfset LvarTC = 1>
				<cfelseif isdefined("rsForm.TESSPtipoCambioOriManual") AND isnumeric(rsForm.TESSPtipoCambioOriManual)>
					<cfset LvarTC = rsForm.TESSPtipoCambioOriManual>
				<cfelse>
					<cfquery name="TCsug" datasource="#Session.DSN#">
						select tc.Hfecha, tc.TCcompra, tc.TCventa
						  from Htipocambio tc
						 where tc.Ecodigo = #Session.Ecodigo#
						   and tc.Mcodigo = #rsForm.McodigoOri#
						   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					</cfquery>
					
					<cfif TCsug.Hfecha EQ "" OR datediff("d",TCsug.Hfecha,now()) GT 30>
						<cfquery name="TCsug" datasource="#Session.DSN#">
							select Miso4217
							  from Monedas
							 where Ecodigo = #Session.Ecodigo#
							   and Mcodigo = #rsForm.McodigoOri#
						</cfquery>
						<cfset LvarError = "El documento esta en moneda '#TCsug.Miso4217#' y no hay tipo de cambio histórico para los últimos 30 días">
						<cfset LvarEsAprobadorSP = false>
						<cfset LvarTC = -1>
					<cfelse>
						<cfset LvarTC = TCsug.TCcompra>
					</cfif>
				</cfif>
				<cfif LvarEsAprobadorSP AND rsSPaprobador.TESUSPmontoMax LT rsForm.TESSPtotalPagarOri*LvarTC>
					<cfset LvarError = "El Total de Pago Solicitado es mayor al Monto Máximo autorizado de Aprobación">
					<cfset LvarEsAprobadorSP = false>
				</cfif>
			</cfif>
		</cfif>

		<cfif LvarEsAprobadorSP>
			<cfset sbAprobar (LvarSPid)>
		<cfelseif LvarError EQ "">
			<script>
				alert("No se puede Aprobar la Solicitud de Pago No. #rsForm.TESSPnumero#");
			</script>
		<cfelse>
			<script>
				alert("No se puede Aprobar la Solicitud de Pago No. #rsForm.TESSPnumero#:\n\n#JSStringFormat(LvarError)#");
			</script>
		</cfif>
	</cfloop>
	<script>
		location.href="#Session.Tesoreria.solicitudesCFM#";
	</script>
	</cfoutput>
	<cfabort>
<cfelseif IsDefined("form.Aprobar")>
	<cfset LvarTESOPid = -1>
	<cfset sbAprobar (form.TESSPid)>
	<cf_SP_imprimir location="#Session.Tesoreria.solicitudesCFM#">
<cfelseif IsDefined("form.GenerarOP")>
	<cfset LvarTESOPid = -1>
	<cfif form.cboCambioTESid NEQ "">
		<cfset LvarTESidDestino = form.cboCambioTESid>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select sp.TESid
			  from TESsolicitudPago sp
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and EcodigoOri = #session.Ecodigo#
		</cfquery>
		<cfset LvarTESidDestino = rsSQL.TESid>
	</cfif>

	<cfquery name="rsPermisos" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from TESusuarioOP
		 where TESid 		= #LvarTESidDestino#
		   and Usucodigo	= #session.Usucodigo#
		   and TESUOPpreparador = 1
	</cfquery>
	<cfif rsPermisos.cantidad EQ 0>
		<cf_errorCode	code = "50795" msg = "El Usuario no tiene permiso para generar Órdenes de Pago en la Tesorería Destino">
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select EcodigoAdm
		  from Tesoreria t
		 where t.TESid = #LvarTESidDestino#
	</cfquery>

	<cfif rsSQL.EcodigoAdm NEQ #session.Ecodigo#>
		<cf_errorCode	code = "50796" msg = "No se puede generar una Orden de Pago en una Tesorería administrada por otra Empresa">
	</cfif>

	<cfset session.Tesoreria.TESid = LvarTESidDestino>
	<cfset sbAprobar (form.TESSPid)>
	<cf_SP_imprimir location="#Session.Tesoreria.solicitudesCFM#?TESOPid=#LvarTESOPid#">
<cfelseif IsDefined("form.Rechazar")>
	<cfinvoke 	component		= "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbRechazarSPsinAprobar"
				
				DSN				= "#session.dsn#"
				Ecodigo			= "#session.Ecodigo#"
				TESSPid			= "#form.TESSPid#"
				TESSPmsgRechazo	= "#form.TESSPmsgRechazo#"
	>

	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="#Session.Tesoreria.solicitudesCFM#">
<cfelseif IsDefined("form.Nuevo")>
	<!--- Tratar como form.nuevo --->
	<cfset form.PASO = 0>
<!--- Comunes --->
<cfelseif IsDefined("form.btnLista_Solicitudes")>
	<cfset form.PASO = 0>
</cfif>

<cflocation url="solicitudesAprobar.cfm">

<cffunction name="sbAprobar" access="private" output="false">
	<cfargument name="LvarSPid">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESSPnumero
		  from TESsolicitudPago
		 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSPid#">
		   and EcodigoOri = #session.Ecodigo#
	</cfquery>

	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn,false,false,true)/>

	<cftransaction>
		<cfinvoke 	component		= "sif.tesoreria.Componentes.TESaplicacion"
					method			= "sbAprobarSP"
					
					SPid 			= "#LvarSPid#"
					fechaPagoDMY	= "#form.TESSPfechaPagar#"
					generarOP		= "#IsDefined("form.GenerarOP")#"
					PRES_Origen		= "TESP"
					PRES_Documento	= "#rsSQL.TESSPnumero#"
					PRES_Referencia	= "SP,APROBACION"
		>
	</cftransaction>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESOPid
		  from TESsolicitudPago
		 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSPid#">
		   and EcodigoOri = #session.Ecodigo#
	</cfquery>
	<cfset LvarTESOPid = rsSQL.TESOPid>
</cffunction>


