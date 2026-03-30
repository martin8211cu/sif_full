<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
<cfset LvarSAporEmpleadoCFM = "solicitudes#url.tipo#.cfm">

<!-------------------------------------------------- Ir a otras opciones -------------------------------------------->
<cfif IsDefined("form.CalcularViaticos")>
	<cflocation url="SolAntViatico_sql.cfm?GEAid=#form.GEAid#&calcular=true&CFid=#form.CFid#&GEAfechaPagar=#form.GEAfechaPagar#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
<cfelseif IsDefined("form.CalcularTC")>
	<cflocation url="SolAntViaticoTC_form.cfm?GEAid=#form.GEAid#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
<cfelseif IsDefined("form.IrLista")>
	<cflocation url="solicitudes#url.tipo#.cfm">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo">
<cfelseif IsDefined("form.NuevaSA")>
	<cflocation url="#LvarSAporEmpleadoCFM#?Nuevo&GECid_comision=#form.GECid_comision#">
<cfelseif IsDefined("form.ImprimirC")>
	<cflocation url="imprSolicAnticipoCOM.cfm?GEAid=0&GECid=#form.GECid_comision#&url=#LvarSAporEmpleadoCFM#">
</cfif>

<cfset LvarTipoDocumento = 6>
<cfset LvarSufijoForm = "Anticipo">

<cfparam name="form.GEAviatico" default="0">
<cfparam name="form.GEAtipoviatico" default="0">
<cfparam name="form.GECusaTCE" default="0">

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<!---Formulado por en parametros generales--->
<cfquery name="rsSQL" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras=rsSQL.Pvalor EQ "1"> <!---1 equivale a plan de compras en parametros generales--->

<!---INICIALIZAR CENTRO FUNCIONAL--->
<cfif isdefined ('form.modo')>
	<cfif form.modo EQ 'ALTA' and IsDefined("form.Aprobar")>
		<cfset form.Alta=true>
	</cfif>

	<cfif	form.modo EQ 'CAMBIO' and IsDefined("form.Aprobar")>
		<cfset form.Cambio=true>
	</cfif>
</cfif>
<cf_cboCFid soloInicializar="true">

<!----------------------------- Mantenimiento al Encabezado del Anticipo y/o Comision ----------------------------->

<cfif IsDefined("form.Alta") or IsDefined("form.AltaC") or isdefined("form.Cambio") or isdefined("form.CambioC")>
	<!--- CxC al Empleados por tipo Comision Nacional, Comision Exterior, No Comision --->
	<cfif isdefined("form.GECid_comision")>
		<cfif form.GECtipo EQ 1>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
					select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1210
			</cfquery>
          	<cfif rsSQL.Pvalor EQ "">
				<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Nacionales en la opción Parámetros de Gastos de Empleado">
			</cfif>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1211
			</cfquery>
			<cfif rsSQL.Pvalor EQ "">
				<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Extranjeras en la opción Parámetros de Gastos de Empleado">
			</cfif>
		</cfif>
	<cfelse>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1200
		</cfquery>
		<cfif rsSQL.Pvalor EQ "">
			<cf_errorCode	code = "50746" msg = "Falta definir la Cuenta por Cobrar para la gestión de Anticipos a Empleados en la opción Parámetros de Gastos de Empleado">
		</cfif>
	</cfif>

	<cfif isdefined("form.GECDid") and form.GECDid EQ "">
		<cfthrow type="toUser" message="Debe definir la categoría destino de la comisión">
	</cfif>

    <cfif find("!",rsSQL.Pvalor) >   <!---Inicia: Cambio para agregar Comodin en Viáticos por Comisión Nacional y al Exterior RVD 16/01/2014--->
      	<cfset Comodin = '!'>
     	<cfquery name="CFuncional" datasource="#Session.DSN#">
   			 select  case LEN(CFcodigo)
						WHEN 1 THEN '000'+CFcodigo
						WHEN 2 THEN '00'+CFcodigo
						WHEN 3 THEN '0'+CFcodigo
						else +CFcodigo end as CFcodigo
                        from CFuncional
			 where  Ecodigo = #session.Ecodigo#
			 and CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">
		</cfquery>

                  	<cfinvoke component="sif.Componentes.AplicarMascara" method="AplicarMascara" returnvariable="Cuenta">
					<cfinvokeargument name="cuenta" value= "#rsSQL.Pvalor#">
					<cfinvokeargument name="valor"   value="#CFuncional.CFcodigo#">
					<cfinvokeargument name="sustitucion" value="#Comodin#"> </cfinvoke>


			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
						method="fnGeneraCuentaFinanciera"
						returnvariable="Lvar_MsgError">
						<cfinvokeargument name="Lprm_CFformato"	value="#cuenta#"/>
						<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
						<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
						<cfinvokeargument name="Lprm_NoCrear" value="false"/>
						<cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
						<cfinvokeargument name="Lprm_debug" value="false"/>
						<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_DSN" value="#Session.DSN#">
			</cfinvoke>



			<cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
				<cfthrow message="Error: #Lvar_MsgError#" />
			<cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>

            			<cfquery name="rsCFCuenta" datasource="#Session.DSN#">
							select CFcuenta, Ccuenta,CPcuenta,CFformato from CFinanciera where Ecodigo =
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Cuenta#">
						</cfquery>
						<cfif rsCFCuenta.recordcount gt 0>
							<cfset LvarCxC_Empleados = #rsCFCuenta.CFcuenta#>
						</cfif> <!---Termina: Cambio para agregar Comodin en Viáticos por Comisión Nacional y al Exterior RVD 16/01/2014--->

    </cfif>


     <cfelse>

		<cfif find("-",rsSQL.Pvalor)>
        	<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFcuenta
		  	from CFinanciera
		 	where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Pvalor#">
			and Ecodigo = #session.Ecodigo#
		</cfquery>
      <cfelse>
        <cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFcuenta
		  	from CFinanciera 
		 	where CFcuenta = #rsSQL.Pvalor#
                        and Ecodigo = #session.Ecodigo#
		</cfquery>
      </cfif>  
      	<cfset LvarCxC_Empleados = rsSQL.CFcuenta>            						
    </cfif>

	<!---verificar si el empleado es un beneficiario--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado"
				method="Empleado_to_Beneficiario"
				DEid = "#form.DEid#"
				returnvariable="LvarTESBid">


</cfif>


<!--- ALTA ANTICIPO O COMISION --->
<cfif IsDefined("form.Alta") OR IsDefined("form.AltaC")>

	<cfif not isdefined("form.GEAdescripcion") or form.GEAdescripcion eq ''>
		<cf_errorCode code = "50741" msg = "No se ha definido una descripci&oacuten.">
	</cfif>

	<cfif not isdefined("form.MontoDetA") or form.MontoDetA lte 0>
		<cf_errorCode code = "50741" msg = "El monto debe ser mayor que CERO">
	</cfif>
	
	<cfif not isdefined("session.Tesoreria.TESid")>
			<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
	</cfif>

	<cfif not isdefined("form.DEidentificacion") or form.DEidentificacion eq ''>
		<cf_errorCode code = "50741" msg = "No se ha definido el empleado.">
	</cfif>
	
	<cfif not isdefined("form.CFcodigo") or form.CFcodigo eq ''>
		<cf_errorCode code = "50741" msg = "No se ha definido el centro funcional.">
	</cfif>

	<!--- Fernando Alcaraz Cristobal. 03/11/2017 --->
	<cfif isdefined("form.Concepto") and form.Concepto eq ''>
		<cf_errorCode	code = "50741" msg = "No se ha definido ningun concepto.">
	</cfif>
	
	<cftransaction>
		<cfif isdefined("form.GECid_comision") AND form.GECid_comision EQ 0>
			<cfquery name="rsNewC" datasource="#session.dsn#">
				select coalesce(max(GECnumero),0) + 1 as new
				  from GEcomision
				 where Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfquery datasource="#session.dsn#" name="insertar">
				insert GEcomision (
					TESid,
					TESBid,
					CFid,
					Ecodigo,
					GECnumero,
					GECdescripcion,

					GECfechaPagar,
					GECdesde,
					GEChoraini,
					GEChasta,
					GEChorafin,

					GECautomovil,
					GEChotel,
					GECavion,
                    GEInternet,
					GECobservaciones,
					GECobservacionesArrend,
					GECusaTCE,
					GECtipo,
					UsucodigoSolicitud,
                    GECdestino,
                    GECDid
				) values (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
					#session.Ecodigo#,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#rsNewC.new#">,
					<cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,

					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhoraini#" null="#Trim(form.GEAhoraini) eq '00:00'#">,
					<cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhorafin#" null="#Trim(form.GEAhorafin) eq '00:00'#">,

					<cfparam name="form.GECautomovil" default="0">
					<cfparam name="form.GEChotel" default="0">
					<cfparam name="form.GECavion" default="0">
                    <cfparam name="form.GEInternet" default="0">
					#form.GECautomovil#,#form.GEChotel#,#form.GECavion#,#form.GEInternet#,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones#"  len="255" null="#trim(form.GECobservaciones) EQ ""#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservacionesArrend#" len="255" null="#trim(form.GECobservacionesArrend) EQ ""#">,
					<cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECusaTCE#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECtipo#">,
					#session.Usucodigo#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GECdestino#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECDid#" null="#form.GECDid EQ ""#">
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertar" returnvariable="LvarGECid_comision">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertar" returnvariable="LvarGECid_comision">
			<cfset form.GEAtipoviatico = form.GECtipo>
		<!--- Control Evento Inicia --->
            <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "ValidaEvento"
                Origen			= "GECM"
                Transaccion		= "COM"
                Conexion		= "#session.dsn#"
                Ecodigo			= "#session.Ecodigo#"
                returnvariable	= "varValidaEvento"
                />
            <cfset varNumeroEvento = "">
            <cfif varValidaEvento GT 0>
                <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_GeneraEvento"
                Origen			= "GECM"
                Transaccion		= "COM"
                Documento 		= "#rsNewC.new#"
                Conexion		= "#session.dsn#"
                Ecodigo			= "#session.Ecodigo#"
                returnvariable	= "arNumeroEvento"
                />
                <cfif arNumeroEvento[3] EQ "">
                    <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                </cfif>
                <cfset varNumeroEvento = arNumeroEvento[3]>
            </cfif>
		<!--- Control Evento Fin --->
		<cfelseif isdefined("form.GECid_comision") AND form.GECid_comision NEQ "">
			<cfset LvarGECid_comision = form.GECid_comision>
			<cfset form.GEAtipoviatico = form.GECtipo>
		<cfelse>
			<cfset LvarGECid_comision = "">
		</cfif>

		<cfif IsDefined("form.AltaC")>
			<cftransaction action="commit" />
			<cfparam name="form.GEAid" default="0">
			<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GECid_comision=#LvarGECid_comision#">
		</cfif>
		<cfquery name="rsNew" datasource="#session.dsn#">
			select coalesce(max(GEAnumero),0) + 1 as new
			from GEanticipo
			where Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery datasource="#session.dsn#" name="insertar">
			insert into GEanticipo
				(CFcuenta,
				TESid,
				CFid,
				CCHid,
				GEAtipoP,
				Ecodigo,
				GEAnumero,
				GEAtipo,
				GEAestado,
				Mcodigo,
				GEAdescripcion,
				GEAfechaSolicitud,
				UsucodigoSolicitud,
				TESBid,
				GEAhasta,
				GEAdesde,
				GEAtotalOri,
				GEAfechaPagar,
				BMUsucodigo,
				GEAmanual,
				GEAviatico,
				GEAtipoviatico,
				GEAhoraini,
				GEAhorafin
			<cfif LvarGECid_comision NEQ "">
				,GECid
			</cfif>
			)values(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCxC_Empleados#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				0,
				#session.Ecodigo#,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#rsNew.new#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTipoDocumento#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="0">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#form.McodigoOri#">,
					<cfif isdefined('form.GEAdescripcion') and len(trim(form.GEAdescripcion))>
						<cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
					</cfif>
				<cf_jdbcquery_param 	cfsqltype="cf_sql_timestamp"  value="#Now()#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
				0,
				<cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				<cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cfif isdefined('form.GEAmanual') and len(trim(form.GEAmanual)) AND form.GEAmanual NEQ 0>
					<cf_jdbcquery_param 	cfsqltype="cf_sql_money" 	value="#form.GEAmanual#">
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="1">
				</cfif>,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.GEAviatico#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEAhoraini#" null="#Trim(form.GEAhoraini) eq '00:00'#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhorafin#" null="#Trim(form.GEAhorafin) eq '00:00'#">
			<cfif LvarGECid_comision NEQ "">
				,#LvarGECid_comision#
			</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insertar">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertar" returnvariable="LvarTESSAid">
		<cfset #form.GEAid#=#LvarTESSAid#>

		<cfif NOT LvarConPlanCompras>
			<cfquery datasource="#session.dsn#" name="insertadetalle">
				insert into GEanticipoDet (
					GEAid,
					GECid,
					BMUsucodigo,
					GEADmonto,
					GEADmontoviatico,
					GEADtipocambio,
					McodigoPlantilla,
					Linea,
					FPAEid,
                    CFComplemento)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoDetA,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.MontoDetA,',','','ALL')#">,
					<cfif isdefined('form.GEAmanual') and len(trim(form.GEAmanual)) AND form.GEAmanual NEQ 0>
						<cf_jdbcquery_param 	cfsqltype="cf_sql_money" 	value="#form.GEAmanual#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="1">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
					0,
                    <cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    <cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
                    </cfif>)
					<cf_dbidentity1 datasource="#session.DSN#" name="insertadetalle">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertadetalle" returnvariable="LvarTESSADid">

			<cfset sbArmaCFcuenta(form.GEAid, LvarTESSADid)>
		</cfif>

		<cfset sbUpdateTotal(false)>
	</cftransaction>
	<cfif Not isdefined("form.Aprobar")>
		<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
	</cfif>
</cfif>

<!--- BAJA ANTICIPO --->
<cfif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#" name="eliminarDetalle">
		delete from GEanticipoDet where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="eliminar">
		delete from GEanticipo where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!--- CAMBIO COMISION --->
<cfif IsDefined("form.CambioC")>
	<cfset sbUpdateComision (0)>
	<cfparam name="form.GEAid" default="0">
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GECid_comision=#form.GECid_comision#">
</cfif>

<cfif IsDefined("form.CancelarC")>
	<cfquery datasource="#session.DSN#">
		update GEcomision
		   set  GECestado = 3
		 where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!---CAMBIO DE COMISIÓN A FINALIZADA--->
<cfif IsDefined("form.FinalizarC")>
	<cfquery datasource="#session.DSN#" name="rsAnti">
		select C.GECnumero, A.GEAestado, A.GEAnumero, A.GEAid
		from GEcomision C
		inner join GEanticipo A on C.GECid = A.GECid
     	where C.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
		and GEAestado != 6
		and C.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsAnti.recordcount GT 0>
		<cfthrow message="El Anticipo #rsAnti.GEANumero# no ha sido comprobado">
	</cfif>

	<cfquery datasource="#session.DSN#" name="rsLiquiaciones">
		select C.GECnumero, L.GELestado, L.GELnumero, L.GELid
		from GEcomision C
		inner join GEliquidacion L on C.GECid = L.GECid
     	where C.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
		and GELestado != 4
		and C.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsLiquiaciones.recordcount GT 0>
		<cfthrow message="La liquidación #rsLiquiaciones.GELnumero# no ha sido concluida">
	</cfif>

	<cfquery datasource="#session.DSN#">
		update GEcomision
		   set  GECestado = 5 <!----Comisión Finalizada---->
		 where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>

	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!--- CAMBIO ANTICIPO --->
<cfif IsDefined("form.Cambio")>
	<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select GEAviatico, GEAmanual
		  from GEanticipo
		 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
	</cfquery>
	
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="actualizar">
			update GEanticipo set
            	CFcuenta = 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCxC_Empleados#">,
				TESBid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESBid#">,
				CFid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				Mcodigo	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
			<cfif isdefined('form.GEAmanual') and len(trim(form.GEAmanual)) and form.GEAmanual NEQ 0>
				GEAmanual=<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAmanual#">,
			<cfelse>
				<cfset form.GEAmanual = 1>
				GEAmanual=<cfqueryparam cfsqltype="cf_sql_money" value="1">,
			</cfif>
			<cfif isdefined ('form.FormaPago') and form.FormaPago EQ "">
				CCHid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				GEAtipoP=0,	<!--- Caja Chica sin escoger caja --->
			<cfelseif isdefined ('form.FormaPago') and form.FormaPago NEQ 0>
				CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">,
				GEAtipoP=0, <!--- Caja Chica --->
			<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
				CCHid=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				GEAtipoP=1, <!--- Tesoreria --->
			</cfif>
				GEAfechaPagar	=<cfqueryparam value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				GEAdescripcion	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAdescripcion#">,
				GEAdesde		=<cfqueryparam value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
				GEAhasta		=<cfqueryparam value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				<cfif #rsAnticipo.GEAviatico# eq 0>
				GEAviatico		=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAviatico#">,
				GEAtipoviatico	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAtipoviatico#">,
				</cfif>
				GEAhoraini		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhoraini#" null="#Trim(form.GEAhoraini) eq '00:00' or Trim(form.GEAhoraini) eq ''#">,
				GEAhorafin		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhorafin#" null="#Trim(form.GEAhorafin) eq '00:00' or Trim(form.GEAhorafin) eq ''#">
			where GEAid 	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
		</cfquery>

		<cfset sbUpdateTotal(form.GEAmanual NEQ rsAnticipo.GEAmanual)>
		<cfset sbUpdateComision (form.GEAid)>
	</cftransaction>

	<cfif Not isdefined("form.Aprobar")>
		<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
	</cfif>

</cfif>

<!---IMPRIMIR--->
<cfif isdefined("form.Imprimir")>
	<cf_navegacion name="TESSPid" default="#rs#">
	<cf_SP_imprimir location="solicitudes#url.tipo#.cfm">
</cfif>

<!--- DUPLICAR ANTICIPO --->
<cfif isdefined("form.Duplicar")>
	<cfquery name="rsNewID" datasource="#session.dsn#">
			select coalesce(max(GEAnumero),0) + 1 as newSolid
			from GEanticipo
			where Ecodigo=#session.Ecodigo#
	</cfquery>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="selecInser">
			select
				TESid,
				GEAtipo,
				GEAfechaPagar,
				Mcodigo,
				GEAmanual,
				CFid,
				GEAtotalOri,
				GEAdescripcion,
				CFcuenta,
				TESBid,
				GEAdesde,
				GEAhasta,
				GEAviatico,
				GEAtipoviatico,
				GEAhoraini,
				GEAhorafin,
				GECid
			 from GEanticipo
			 where Ecodigo = #session.Ecodigo#
			   and GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>

		<cfquery datasource="#session.dsn#" name="Duplicado">
			insert into GEanticipo (
				TESid,
				GEAnumero,
				GEAtipo,
				GEAestado,
				GEAfechaPagar,
				Mcodigo,
				GEAmanual,
				CFid,
				GEAtotalOri,
				GEAdescripcion,
				GEAfechaSolicitud,
				UsucodigoSolicitud,
				CFcuenta,
				Ecodigo,
				TESBid,
				BMUsucodigo,
				GEAdesde,
				GEAhasta,
				GEAviatico,
				GEAtipoviatico,
				GEAhoraini,
				GEAhorafin,

				GECid	<!--- GECid_comision --->
				)
			VALUES(
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.TESid#"              voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsNewID.newSolid#"          	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selecInser.GEAtipo#"            voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0">,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAfechaPagar#"      voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.Mcodigo#"            voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selecInser.GEAmanual#"          voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.CFid#"               voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selecInser.GEAtotalOri#"        voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="350" value="#selecInser.GEAdescripcion#"     voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
				#session.Usucodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.CFcuenta#"           voidNull>,
			   #session.Ecodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.TESBid#"             voidNull>,
				#session.Usucodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAdesde#"           voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selecInser.GEAhasta#"           voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selecInser.GEAviatico#"         voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selecInser.GEAtipoviatico#"     voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.GEAhoraini#"         voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.GEAhorafin#"         voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selecInser.GECid#"         		voidNull>
			)

			<cf_dbidentity1 datasource="#session.DSN#" name="Duplicado">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="Duplicado" returnvariable="idDumpli">

		<cfquery datasource="#session.dsn#" name="saveDupli">
				update GEanticipo
				set GEAidDuplicado	= <cfqueryparam cfsqltype="cf_sql_integer" value="#idDumpli#">
				where GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>

		<!---Muestra los Detalles de los anticipos duplicados --->
		<cfquery name="BuscaDetalle" datasource="#session.dsn#">
			select * from GEanticipoDet where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>

		<cfloop query="BuscaDetalle">
			<cfquery name="selectPrueba" datasource="#session.dsn#">
				select
					#idDumpli# as GEAid,
					CFcuenta,
					TESDPaprobadopendiente,
					GEADutilizado,
					GEADmonto,
					GECid,
					GEPVid,
					BMUsucodigo,
					GEADfechaini,
					GEADfechafin,
					GEADhoraini,
					GEADhorafin,
					GEADmontoviatico,
					GEADtipocambio,
					McodigoPlantilla,
					PCGDid,
					FPAEid,
					CFComplemento
					from GEanticipoDet
					where GEADid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#BuscaDetalle.GEADid#">
			</cfquery>

			<cfquery name="prueba" datasource="#session.dsn#">
				insert INTO GEanticipoDet
				(
				GEAid,
				CFcuenta,
				TESDPaprobadopendiente,
				GEADutilizado,
				GEADmonto,
				GECid,
				GEPVid,
				BMUsucodigo,
				GEADfechaini,
				GEADfechafin,
				GEADhoraini,
				GEADhorafin,
				GEADmontoviatico,
				GEADtipocambio,
				McodigoPlantilla,
				PCGDid,
				FPAEid,
				CFComplemento
				)
			VALUES(
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEAid#"                  voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.CFcuenta#"               voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.TESDPaprobadopendiente#" voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADutilizado#"          voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADmonto#"              voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GECid#"                  voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEPVid#"                 voidNull>,
					#session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectPrueba.GEADfechaini#"           voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectPrueba.GEADfechafin#"           voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEADhoraini#"            voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.GEADhorafin#"            voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADmontoviatico#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectPrueba.GEADtipocambio#"         voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.McodigoPlantilla#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.PCGDid#"                 voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectPrueba.FPAEid#"                 voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#selectPrueba.CFComplemento#"          voidNull>

			)
				<cf_dbidentity1 datasource="#session.DSN#" name="prueba">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="prueba" returnvariable="LvarTESSADid">
		</cfloop>
	</cftransaction>

	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!------------------------------------------ Enviar al proceso de aprobación ---------------------------------------->

<!--- A aprobar Comisión: Envía TODOS los anticipos pertenecientes a la Comision --->
<cfif IsDefined("form.AAprobarC")>
	<cfquery name="rsAnts" datasource="#session.dsn#">
		select GEAid, GEAdesde,GEAtotalOri, GEAviatico, GEAtipoviatico
		  from GEanticipo a
		 where GECid=#form.GECid_comision#
		   and GEAestado in (0,3)
	</cfquery>

	<cfif rsAnts.recordcount EQ 0>
		<cfthrow message="La Comisión no se puede Enviar a Aprobar o Aprobar porque no tiene Anticipos 'En Preparación'">
	</cfif>

	<cfset LvarTipo='COMISION'>
	<cfquery name="rsComision" datasource="#session.dsn#">
		select a.GECdescripcion, e.Mcodigo as McodigoLocal,
				(
				select sum(round(GEAtotalOri*GEAmanual,2))
				  from GEanticipo
				 where GECid=a.GECid
				   and GEAestado in (0,3)
				) as GEAtotalLocal
		  from GEcomision a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		 where a.GECid=#form.GECid_comision#
	</cfquery>

	<cftransaction>
		<!--- Se envian los montos en moneda local porque hay diferentes monedas --->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" 			value="#rsComision.McodigoLocal#"/>
				<cfinvokeargument name="CCHTdescripcion" 	value="#rsComision.GECdescripcion#"/>
				<cfinvokeargument name="CCHTmonto"	 		value="#rsComision.GEAtotalLocal#"/>
				<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHTtipo" 			value="COMISION"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="COMISION"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#form.GECid_comision#"/>
		</cfinvoke>
		<!--- Actulización del estado del Anticipo--->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEanticipo set
					GEAestado =1
			 where GECid=#form.GECid_comision#
			   and GEAestado = 0
		</cfquery>
		<!--- Actulización del estado de la Comision: Activa --->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEcomision
			   set  GECestado = 2
			 where GECid = #form.GECid_comision#
			   and GECestado in (1,3)
		</cfquery>
	</cftransaction>
	<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="imprSolicAnticipoCOM.cfm?GEAid=#form.GEAid#&GECid=#form.GECid_comision#&url=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
<!--- A aprobar Anticipo: Envía sólo el anticipo actual --->
<cfelseif isdefined ('form.AAprobar')>
    <cfquery name="rsValida" datasource="#session.dsn#">
		select count(1) as cantidad from GEanticipo where GEAid=#form.GEAid# and GEAestado not in (0,3)
	</cfquery>

	<cfif rsValida.cantidad gt 0>
		<cfthrow message="El anticipo no se puede Enviar a Aprobar o Aprobar porque su estado es diferente de 'En Preparación'">
	</cfif>

	<cfif not isdefined('form.FormaPago') or form.FormaPago eq ''>
		<cfthrow message="La forma de pago no se ha definido.">
	</cfif>

	<!---Se buscan anticipos sin liquidar del mismo tipo--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="AnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
		<cfinvokeargument name="DEid"  			value="#form.DEid#">
	</cfinvoke>

	<!---Si es viatico y nacional --->
	<cfif #form.GEAviatico# eq 1 and #form.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos nacionales definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoNacional">
			<cfinvokeargument name="DEid"  			value=#form.DEid#>
			<cfinvokeargument name="fechaIni"  		value="#form.GEAdesde#">
			<cfinvokeargument name="MontoAnt"  		value=#val(replace(form.GEAtotalOri,',','','all'))#>
		</cfinvoke>
	</cfif>

	<cftransaction>
		<cfparam name="form.FormaPago" default="0">
		<cfquery datasource="#session.dsn#">
			update GEanticipo
			   set CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#" null="#form.FormaPago EQ 0#">
			 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" 			value="#form.McodigoOri#"/>
				<!---<cfinvokeargument name="CFcuenta" 			value="#form.CxC_Anticipo#">--->
				<cfinvokeargument name="CCHTdescripcion" 	value="#GEAdescripcion#"/>
				<cfinvokeargument name="CCHTmonto"	 		value="#replace(form.GEAtotalOri,',','','ALL')#"/>
				<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#form.GEAid#"/>
		</cfinvoke>
		<!--- Actualización del estado del Anticipo--->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEanticipo set
					GEAestado =1
			where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>


		<!---Consulta en parametros de GE si envia correos al aprobador--->
        <cfquery name="rsEnviaEmail" datasource="#Session.DSN#">
        	select coalesce(Pvalor,'0') as Pvalor
		  	from Parametros
		 	where Ecodigo = #session.Ecodigo#
		   	and Pcodigo = 1217
        </cfquery>
         <cfquery name="rsPvalor" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo = 15500
        </cfquery>
        <cfif rsEnviaEmail.Pvalor eq 1 >
			<cfset LvarMonto=#replace(form.GEAtotalOri,',','','ALL')#>

        	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
            <cfquery name="rsAprobadores" datasource="#Session.DSN#">
                select
                        u.Usulogin
                        , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                        , cf.CFcodigo, cf.CFdescripcion
                        ,coalesce(Pemail1,Pemail2) as email
                from TESusuarioSP tu
                    inner join Usuario u
                        inner join DatosPersonales dp
                           on dp.datos_personales = u.datos_personales
                        on u.Usucodigo = tu.Usucodigo
                    inner join CFuncional cf
                        on cf.CFid = tu.CFid
                where tu.CFid 		= #form.CFid#
                and tu.TESUSPaprobador = 1
                and (TESUSPmontoMax=0 or TESUSPmontoMax>= #LvarMonto#)
            </cfquery>


            <!---Mails--->
            <cfloop query="rsAprobadores">
                <cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">

                <cfsavecontent variable="contenido">
                	<cfoutput>
                    <p>
                    Señor(a) #rsAprobadores.Usunombre#
                    <br /><br />
                    Se realizo la solicitud del anticipo numero #form.GEAnumero# para su aprobacion.
                    <br /><br />
                    <!---se hace la pregunta para saber cual link usar--->
					<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                    Para ver el anticipo <a href="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/cfmx/proyecto7/gastosEmpleados.cfm">Firmese aqui</a>
                    <cfelse>
                    Para ver el anticipo <a href="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/cfmx/sif/tesoreria/GestionEmpleados/solicitudesAnticipo.cfm">Firmese aqui</a>
                    </cfif>
                    </cfoutput>
                </cfsavecontent>

				<cfif len(trim(rsAprobadores.email))>
                    <cfquery name="rsInserta" datasource="#Session.DSN#">
                        insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto,
                                                SMTPtexto, 		SMTPintentos, 		SMTPcreado,
                                                SMTPenviado, 	SMTPhtml, 			BMUsucodigo )
                        values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#enviadoPor#">, <!---agarra el nombre y apellidos de session--->
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsAprobadores.email#">, <!---#rsAprobadores.email#--->
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="Aprobacion del anticipo numero:#form.GEAnumero#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#contenido#">,
                                0,	#now()#,	#now()#,	1,
                                #Session.Usucodigo#
                                )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>

	<!---</cftransaction>--->
	<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
</cfif>

<!------------------------------------------ Proceso de aprobación ---------------------------------------->
<cfif IsDefined("form.AprobarC")>
<!--- Aprobacion Comision: se deber realizar en Transacciones Empleado --->
	<cfthrow message="No se ha implementado la Aprobación de Comisiones">
<cfelseif IsDefined("form.Aprobar")>
<!--- Aprobacion Anticipo--->
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEanticipo_Aprobar" returnvariable="LvarTESSPid">
		<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
		<!--- Crea nueva transacción de caja --->
		<cfinvokeargument name="CCHTid"  		value="-1">
	</cfinvoke>
	<cfif isdefined ('form.chkImprimir')>
		<!--- <cf_SP_imprimir location="AprobarTrans.cfm"> --->
		<cfif isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
			<cfif form.FormaPago EQ 0>
				<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#&TESSPid=#LvarTESSPid#">
			<cfelse>
				<cflocation url="imprSolicAnticipoCCH.cfm?GEAid=#form.GEAid#&url=#LvarSAporEmpleadoCFM#">
			</cfif>
		</cfif>
	</cfif>
	<cflocation url="#LvarSAporEmpleadoCFM#">
 </cfif>

<!-------------------------------------- Mantenimiento al Detalle del Anticipo --------------------------------------->

<!---NUEVO DETALLE--->
<cfif isdefined('form.NuevoDet')>
	<cflocation url="solicitudes#url.tipo#.cfm?GEAid=#form.GEAid#">
</cfif>

<!---ALTA DETALLE--->
<cfif isdefined('form.AltaDet')>
	<!---Si no es por plan de compras verifica que el concepto no se ingrese mas de una vez--->
	<cfif NOT LvarConPlanCompras>
		<cfquery name="verificaDetalle" datasource="#session.dsn#">
			select
				count(1) as cantidad
			from
				GEanticipoDet
			where
				GEAid=#form.GEAid#
				and GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">
		</cfquery>

		<cfif #verificaDetalle.cantidad# gt 0>
			<cf_errorCode	code = "50747" msg = "Ese Concepto ya se ingreso">
		</cfif>
	</cfif>

	<cfset fnCalculaMontoDet()>
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insertadetalle">
			insert into GEanticipoDet (
				GEAid,
				GECid,
				BMUsucodigo,
				GEADmonto,
				GEADtipocambio,
				GEADmontoviatico,
				McodigoPlantilla,
				<cfif LvarConPlanCompras>
					PCGDid,
					CFcuenta,
				</cfif>
				Linea,
                FPAEid,
                CFComplemento)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GEAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.concepto#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.MontoDetCalculado#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.GEAmanualDet#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#form.MontoDet#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.McodigoOriD#">,
				<cfif LvarConPlanCompras>
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PCGDid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFcuenta#">,
				</cfif>
				0,
                <cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
                <cfelse>
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                </cfif>
                <cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">
                <cfelse>
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
                </cfif>)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertadetalle">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertadetalle" returnvariable="LvarTESSADid1">
		<cfset #form.GEADid#=#LvarTESSADid1#>

		<cfset sbArmaCFcuenta(form.GEAid, LvarTESSADid1)>
		<cfset sbUpdateTotal(false)>
	</cftransaction>
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
</cfif>

<!---CAMBIO DETALLE--->
<cfif isdefined('form.CambioDet')>
	<cfset fnCalculaMontoDet()>

	<cftransaction>
		<cfquery datasource="#session.dsn#" name="actualizadetalle">
			update GEanticipoDet set
				GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">,
				<cfif LvarConPlanCompras>
					PCGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCGDid#">,
				</cfif>
				CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				GEADmonto=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoDetCalculado#">,
				GEADtipocambio=<cfqueryparam cfsqltype="cf_sql_money" value="#form.GEAmanualDet#">,
				GEADmontoviatico=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoDet#">,
				McodigoPlantilla=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOriD#">
			where
				GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
		</cfquery>
		<cfset sbUpdateTotal(false)>
	</cftransaction>

	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#&GEADid=#form.GEADid#">
</cfif>

<!---BAJA DETALLE--->
<cfif isdefined('form.BajaDet')>
	<cfquery datasource="#session.dsn#" name="eliminaDetalle">
		delete from GEanticipoDet where GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
	</cfquery>
	<cfset sbUpdateTotal(false)>
	<cflocation url="#LvarSAporEmpleadoCFM#?GEAid=#form.GEAid#">
</cfif>

<!-------------------------------------------- FUNCIONES ---------------------------------------------->

<cffunction name="sbUpdateTotal" output="false" access="private">
	<cfargument name="CambioTC" type="boolean">

	<cfif Arguments.CambioTC>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select GEAmanual
			  from GEanticipo
			 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update GEanticipoDet
			   set GEADmonto = GEADmontoviatico * GEADtipocambio / #rsAnticipo.GEAmanual#
			 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update GEanticipo
 		   set GEAtotalOri =
					coalesce(
					(
						select sum(GEADmonto)
						  from GEanticipoDet
						 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
					)
					, 0)
		  where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#" null="#Len(form.GEAid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="sbUpdateComision" output="false" access="private">
	<cfargument name="GEAid" type="boolean">
	<cfif NOT (isdefined("form.GECid_comision") AND form.GECid_comision NEQ "" AND form.GECid_comision NEQ "0")>
		<cfreturn>
	</cfif>
	<cfquery datasource="#session.dsn#" name="insertar">
		update GEcomision
		   set
				TESBid				= <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#LvarTESBid#">,
				CFid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
				GECdescripcion		= <cf_jdbcquery_param 	cfsqltype="cf_sql_char" 	value="#form.GEAdescripcion#">,
				GECfechaPagar		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				UsucodigoSolicitud	= #session.Usucodigo#,

				GECdesde		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
				GEChoraini		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhoraini#" null="#Trim(form.GEAhoraini) eq '00:00'#">,
				GEChasta		= <cf_jdbcquery_param value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
				GEChorafin		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhorafin#" null="#Trim(form.GEAhorafin) eq '00:00'#">,

				<cfparam name="form.GECautomovil" default="0">
				<cfparam name="form.GEChotel" default="0">
				<cfparam name="form.GECavion" default="0">
                <cfparam name="form.GEInternet" default="0">
				GECautomovil	= #form.GECautomovil#,
				GEChotel		= #form.GEChotel#,
				GECavion		= #form.GECavion#,
				GEInternet		= #form.GEInternet#,
				GECobservaciones	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservaciones#"  len="255" null="#trim(form.GECobservaciones) EQ ""#">,
				GECobservacionesArrend	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.GECobservacionesArrend#" len="255" null="#trim(form.GECobservacionesArrend) EQ ""#">,
				GECusaTCE			= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.GECusaTCE#">,
				GECtipo				= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECtipo#">,

                GECdestino			= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GECdestino#">,
                GECDid				= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GECDid#" NULL="#form.GECDid EQ ""#">
		 where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="actualizar">
		update GEanticipo set
           	CFcuenta = 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCxC_Empleados#">,
			TESBid			=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESBid#">,
			CFid			=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.CFid#">,
			GEAfechaPagar	=<cfqueryparam value="#LSparseDateTime(form.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
			GEAdescripcion	=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEAdescripcion#">,
			UsucodigoSolicitud	= #session.Usucodigo#,
			GEAdesde		=<cfqueryparam value="#LSparseDateTime(form.GEAdesde)#" cfsqltype="cf_sql_timestamp">,
			GEAhasta		=<cfqueryparam value="#LSparseDateTime(form.GEAhasta)#" cfsqltype="cf_sql_timestamp">,
			GEAhoraini		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhoraini#" null="#Trim(form.GEAhoraini) eq '00:00'#">,
			GEAhorafin		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAhorafin#" null="#Trim(form.GEAhorafin) eq '00:00'#">,
			GEAtipoviatico	=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GECtipo#">

		  where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
		    and GEAid <><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
			and GEAestado = 0
	</cfquery>
</cffunction>

<cffunction name="sbArmaCFcuenta" output="false" access="private">
	<cfargument name="GEAid">
	<cfargument name="GEADid">

	<cfif NOT LvarConPlanCompras>
		<cfquery name="rsCtas" datasource="#session.DSN#">
			select sad.GEADid, sa.CFid, sad.GECid, sad.CFComplemento, sa.GECid as Com, cg.Cid
			from GEanticipo sa
				inner join GEanticipoDet sad
                <cfif NOT isdefined("LvarGECid_comision") OR LvarGECid_comision EQ "">
                    inner join GEconceptoGasto cg
                	on sad.GECid = cg.GECid
                </cfif>
					on sad.GEAid = sa.GEAid
                <cfif isdefined("LvarGECid_comision") and LvarGECid_comision NEQ "">
                	inner join GEconceptoGasto cg
                	on sa.GECid = cg.GECid
                </cfif>
			where sa.GEAid		= #Arguments.GEAid#
			  and sad.GEADid	= #Arguments.GEADid#
		</cfquery>
		<cfloop query="rsCtas">
        	<cfset varTipoItem = 'S'>
			<cfif isdefined("rsCtas.Com") and rsCtas.Com NEQ ''>
                <cfset varTipoItem = 'G'>
            </cfif>
			<cfinvoke 	component="sif.Componentes.AplicarMascara"
						method="fnComplementoItem"
						returnvariable="LvarCFformato">
                <cfinvokeargument name="CFid" 		value="#rsCtas.CFid#">
                <cfinvokeargument name="GECid" 		value="#rsCtas.GECid#">
                <cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#">
                <cfinvokeargument name="tipoItem" 	value="#varTipoItem#">
                <cfinvokeargument name="SNid" 		value="-1">
                <cfinvokeargument name="Aid" 		value="">
                <cfinvokeargument name="Cid" 		value="#rsCtas.Cid#">
                <cfinvokeargument name="ACcodigo" 	value="">
                <cfinvokeargument name="ACid" 		value="">
                <cfinvokeargument name="ActEcono" 	value="#rsCtas.CFComplemento#">
            </cfinvoke>
			<cfinvoke 	component="sif.Componentes.PC_GeneraCuentaFinanciera"
						method="fnGeneraCuentaFinanciera"
						returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" value="#trim(LvarCFformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#session.dsn#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfthrow message="#LvarError#">
			</cfif>
			<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
			<cfquery datasource="#session.DSN#">
				update GEanticipoDet
				   set CFcuenta = #LvarCFcuenta#
				 where GEADid 	= #rsCtas.GEADid#
			</cfquery>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="fnCalculaMontoDet">
	<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select a.Mcodigo, a.GEAmanual, e.Mcodigo as McodigoLocal
		  from GEanticipo a
		  	inner join Empresas e on e.Ecodigo=a.Ecodigo
		 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
	<cfif form.McodigoOriD EQ rsAnticipo.Mcodigo>
		<cfset form.MontoDetCalculado = form.MontoDet>
		<cfset form.GEAmanualDet = rsAnticipo.GEAmanual>
	<cfelseif form.McodigoOriD EQ rsAnticipo.McodigoLocal>
		<cfset form.GEAmanualDet = 1>
		<cfset form.MontoDetCalculado = round(form.MontoDet / rsAnticipo.GEAmanual*100)/100>
	<cfelse>
		<cfset form.MontoDetCalculado = round(form.MontoDet * form.GEAmanualDet / rsAnticipo.GEAmanual *100)/100>
	</cfif>
</cffunction>
