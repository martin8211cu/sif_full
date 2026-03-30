<cfcomponent>
<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarEsConPlanCompras = rsUsaPlanCuentas.Pvalor EQ 1>

<!--- 
	Aprobación de la Solicitud de Anticipo de Gasto Empleado
	Se debe Aplicar hasta Pagar el Anticipo
	
	Por Tesorería:		
		1) Aprobación Anticipo:	Se genera SP con estado Sin Aprobar
								Se aprueba SP 
									(Pres: genera Reserva Anticipo)
		2) Aplicación del Pago:	Se aplica el Anticipo en el PagoOP de SP=6 
									(Pres.CR: N/A, Pres.MX: Convierte Reserva a Pagado)

	Por Caja Especial:
		1) Aprobación Anticipo:	Se envía a la Caja
									(Pres: genera Reserva Anticipo)
		2) Pago en Efectivo:	Se registra la entrega
								Se genera SP con estado Sin Aprobar
								Se aplica SPsinOP (equivale al PagoOP de SP=6, se aplica el Anticipo)
									(Pres.CR: N/A, Pres.MX: Convierte Reserva a Pagado)
		3) Reintegro:			(Pres: N/A)

	Por Caja Chica:
		1) Aprobación Anticipo:	Se envía a la Caja
									(Pres: genera Reserva Anticipo)
		2) Pago en Efectivo:	Se registra la entrega
									(Pres: N/A)
		3) Reintegro:			(Pres: Reversa la Reserva Anticipo y movimientos de Liquidación)
 --->
<cffunction name="GEanticipo_aprobar" output="false" returntype="numeric" access="public">
	<cfargument name="GEAid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">
	<!--- CCHTid = -1 para agregar la transaccion --->
	<cfargument name="CCHTid"			type="numeric" default="-1">
	<cfargument name="GECid_comision"	type="numeric" default="-1">

	<cfset var LvarTESSPid = 0>

	<cfquery datasource="#session.dsn#">
		update GEanticipo 
		   set CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormaPago#" null="#Arguments.FormaPago EQ 0#">
		 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select 	coalesce(CCHid,0) as FormaPago, GEAdescripcion, GEAestado,
				TESBid, GEAnumero,
				CFid, 
				GEAtotalOri,CCHTid,
				GEAmanual, 
				Mcodigo, CFcuenta,
				GEAviatico, GEAtipoviatico,
				GEAdesde, GEAhasta,
				GECid as GECid_comision,
				(select DEid from TESbeneficiario where TESBid = a. TESBid) as DEid
		from GEanticipo a
		where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">	
	</cfquery>

	<!--- Valida Estado --->
	<cfif NOT listFind("0,1",rsAnticipo.GEAestado)>
		<cfthrow message="El anticipo no se puede Aprobar porque su estado es diferente de 'En Preparación' o 'En Aprobación'">
	</cfif>
	
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.CFid#">
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
	<cfif rsSPaprobador.RecordCount EQ 0>
		<cf_errorCode	code = "50743" msg = "El Usuario no puede Aprobar. ">
	</cfif>

	<cfif Arguments.GECid_comision NEQ -1>
		<cfquery name="rsComision" datasource="#session.dsn#">
			select a.GECnumero, GECdesdePlan, GEChastaPlan
			  from GEcomision a
			 where a.GECid=#Arguments.GECid_comision# 
		</cfquery>
		<cfif Arguments.GECid_comision NEQ rsAnticipo.GECid_comision>
			<cfthrow message="Anticipo Núm. #rsAnticipo.GEAnumero# no pertenece a Comisión Núm. #rsComision.GECnumero#">
		</cfif>
		<!--- Ajusta fechas planeadas aprobadas de la comisión --->
		<cfif rsComision.GECdesdePlan EQ "" OR rsComision.GECdesdePlan GT rsAnticipo.GEAdesde>
			<cfquery datasource="#session.dsn#">
				update GEcomision
				   set GECdesdePlan = <cfqueryparam cfsqltype="cf_sql_date" value="#rsAnticipo.GEAdesde#">
				 where GECid=#Arguments.GECid_comision#
			</cfquery>
		</cfif>
		<cfif rsComision.GEChastaPlan EQ "" OR rsComision.GEChastaPlan GT rsAnticipo.GEAhasta>
			<cfquery datasource="#session.dsn#">
				update GEcomision
				   set GEChastaPlan = <cfqueryparam cfsqltype="cf_sql_date" value="#rsAnticipo.GEAhasta#">
				 where GECid=#Arguments.GECid_comision# 
			</cfquery>
		</cfif>
	<cfelseif Arguments.GECid_comision EQ -1 AND rsAnticipo.GECid_comision NEQ "">
		<cfquery name="rsComision" datasource="#session.dsn#">
			select a.GECnumero
			  from GEcomision a
			 where a.GECid=#rsAnticipo.GECid_comision#
		</cfquery>
		<cfthrow message="Anticipo Núm. #rsAnticipo.GEAnumero# pertenece a Comisión Núm. #rsComision.GECnumero#, no se puede aprobar como Anticipo independiente">
	</cfif>

	<!---Valida anticipos sin liquidar del mismo tipo--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="AnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GEAid"  		value="#Arguments.GEAid#">
		<cfinvokeargument name="DEid"  			value="#rsAnticipo.DEid#">
	</cfinvoke>
	
	<!--- Valida monto viatico nacional --->
	<cfif rsAnticipo.GEAviatico EQ 1 AND rsAnticipo.GEAtipoviatico EQ 1>
		<!---Valida que no sobrepase el monto máximo de viáticos nacional definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoNacional">
			<cfinvokeargument name="DEid"  			value="#rsAnticipo.DEid#">
			<cfinvokeargument name="fechaIni"  		value="#rsAnticipo.GEAdesde#">
			<cfinvokeargument name="MontoAnt"  		value="#rsAnticipo.GEAtotalOri#">
		</cfinvoke>	
	</cfif>

	<!--- Valida Plan de Compras de Gobierno --->
	<cfif LvarEsConPlanCompras> 
		<cfquery name="rsSinNulos" datasource="#session.dsn#">
			select PCGDid from GEanticipoDet where GEAid=#Arguments.GEAid# and PCGDid is null 
		</cfquery>
		
		<cfif rsSinNulos.recordcount gt 0>
			<cf_errorCode	code = "51668" msg = "No se puede enviar a aprobar una solicitud con los campos del plan de compras en nulo">
		</cfif>			
	</cfif>

	<!--- Pone secuencia en todas las lineas del Anticipo --->
	<!--- Es de vital importancia porque corresponde a la linea de la SP y del NAP --->
	<cfquery datasource="#session.DSN#" name="Actualiza">
		update GEanticipoDet
		   set Linea = (select count(1) from GEanticipoDet d where d.GEADid <= GEanticipoDet.GEADid)
		 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>

	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
	<cftransaction>
		<!---CREAR SP si se selecciono a tesoreria como forma de pago--->
		<cfif rsAnticipo.FormaPago EQ 0>
			<cfif rsAnticipo.GEAtotalOri LTE 0>
				<cfthrow message="No se puede enviar a aprobar una solicitud con monto igual o menor que 0">
			<cfelse>
				<cfinvoke method="GEanticipo_aprobarConSP" returnVariable="LvarTESSPid">
					<cfinvokeargument name="GEAid"  			value="#Arguments.GEAid#">
					<cfinvokeargument name="GEAnumero" 			value="#rsAnticipo.GEAnumero#">
				</cfinvoke>
	
				<cfif Arguments.CCHTid EQ -1>
					<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
								method="TranProceso" 
								returnvariable="LvarCCHTidProc">
						<cfinvokeargument name="Mcodigo" 			value="#rsAnticipo.Mcodigo#"/>
						<cfif rsAnticipo.CFcuenta NEQ "">
							<cfinvokeargument name="CFcuenta" 			value="#rsAnticipo.CFcuenta#"/>
						</cfif>
						<cfinvokeargument name="CCHTdescripcion" 	value="#rsAnticipo.GEAdescripcion#"/>
						<cfinvokeargument name="CCHTmonto"	 		value="#rsAnticipo.GEAtotalOri#"/>
						<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
						<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#Arguments.GEAid#"/>
					</cfinvoke>
				<cfelse>
					<cfset LvarCCHTidProc = Arguments.CCHTid>

					<!--- En solicitudesAnticipo EnviarAprobar se incluyó en TransaccionesProceso como EN APROBACION CCH --->
					<!--- Modifica la Transacción en proceso y seguimiento: EN APROBACION CCH ==> EN APROBACION TES --->
					<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
								method="CambiaEstadoTP">
						<cfinvokeargument name="CCHTid"    			value="#Arguments.CCHTid#"/>
						<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
						<cfinvokeargument name="CCHtipo"    		value="ANTICIPO"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#Arguments.GEAid#"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
					</cfinvoke>
				</cfif>
			</cfif>
		<!---Genera las transacciones si se selecciono a Caja Chica o Caja Especial como forma de Pago--->
		<cfelse>
			<!--- Datos de la Caja Chica --->
			<cfquery name="rsCajaChica" datasource="#session.dsn#">
				select CCHid, Mcodigo
				  from CCHica 
				 where CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.FormaPago#">
				   and Ecodigo=#session.Ecodigo#
			</cfquery>
			
			<!--- Verifica la Moneda --->
			<cfif rsAnticipo.Mcodigo NEQ rsCajaChica.Mcodigo>
				<cfthrow message="La moneda de la Caja no corresponde con la moneda del Anticipo">
			</cfif>

			<!--- Verifica Disponible de la Caja--->
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="MDisponible">
				<cfinvokeargument name="CCHid"			value="#rsCajaChica.CCHid#">
				<cfinvokeargument name="monto"			value="#rsAnticipo.GEAtotalOri#">
			</cfinvoke>		
	
			<!--- No se porque se ajustaba al tipo de cambio del dia, dejo el monto original obonilla66 --->
			<cfset monto=rsAnticipo.GEAtotalOri>
	
			<!---Verificación de Presupuesto--->
			<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
						method="ApruebaImporte" 
						returnvariable="LvarImporte">
				<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
				<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO" > 
				<cfinvokeargument name="Id_anticipo"  		value="#Arguments.GEAid#"> 
				<cfinvokeargument name="ImporteA"      		value="#monto#" >  
			</cfinvoke>
			<cfif NOT LvarImporte>
				<cf_errorCode	code = "50726" msg = "No hay disponible en Caja.">
			</cfif>
	
			<cfif Arguments.CCHTid EQ -1>
				<!--- Componente que crea la Transacción en proceso y seguimiento--->
				<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
							method="TranProceso" 
							returnvariable="LvarCCHTidProc">
					<cfinvokeargument name="Mcodigo" 			value="#rsAnticipo.Mcodigo#"/>
					<cfinvokeargument name="CCHTdescripcion" 	value="#rsAnticipo.GEAdescripcion#"/>
					<cfinvokeargument name="CCHTmonto"	 		value="#monto#"/>
					<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
					<cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
					<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
					<cfinvokeargument name="CCHTrelacionada"    value="#Arguments.GEAid#"/>
				</cfinvoke>
			<cfelse>
				<cfset LvarCCHTidProc = Arguments.CCHTid>
				<!--- En solicitudesAnticipo EnviarAprobar ya se incluyó en TransaccionesProceso como EN APROBACION CCH --->
			</cfif>
	
			<cfinvoke method="GEanticipo_aprobarPorCCHoCEE">
				<cfinvokeargument name="GEAid"   	value="#Arguments.GEAid#"/>
				<cfinvokeargument name="CCHid"   	value="#rsAnticipo.FormaPago#"/>
				<cfinvokeargument name="CCHTidProc" value="#LvarCCHTidProc#"/>
				<cfinvokeargument name="monto"   	value="#monto#"/>
			</cfinvoke>
		</cfif>
        
		<!---Agrega el usuario que aprobo el anticipo--->
        <cfquery datasource="#session.dsn#">
            update GEanticipo 
               set UsucodigoAprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
             where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
        </cfquery>
       
	</cftransaction>
	
	<cfreturn LvarTESSPid>
</cffunction>

<!--- Aprobar por Tesorería --->
<cffunction name="GEanticipo_aprobarConSP" returntype="numeric" access="public">
	<cfargument name="GEAid"  			type="numeric"  required="yes"> 
	<cfargument name="GEAnumero"  		type="numeric"  required="yes"> 

	<cfset LvarTESSPid = GEanticipo_generaSP(Arguments.GEAid)>
	
	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
		<cfinvokeargument name="SPid" value="#LvarTESSPid#">
		<cfinvokeargument name="fechaPagoDMY" value="#LSDateFormat(rsAnticipo.GEAfechaPagar,'dd/mm/yyyy')#">
		<cfinvokeargument name="generarOP" value="false">
		<cfinvokeargument name="NAP" value="-1">
		
		<cfinvokeargument name="PRES_Origen" 		value="TEGE">
		<cfinvokeargument name="PRES_Documento" 	value="#rsAnticipo.GEAnumero#">
		<cfinvokeargument name="PRES_Referencia" 	value="GE.ANT,Aprobacion">
	</cfinvoke>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select NAP
		  from TESsolicitudPago
		 where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="NumNAP">
		update GEanticipo 
		   set 	CPNAPnum	= #rsSQL.NAP#,
				GEAestado	= 2,
				GEAtipoP	= 1
		 where GEAid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	
	<cfreturn LvarTESSPid>
</cffunction>

<!--- Por Caja Chica o Caja Especial de Efectivo --->
<cffunction name="GEanticipo_aprobarPorCCHoCEE" access="private">
	<cfargument name="GEAid" 		type="numeric" required="yes">
	<cfargument name="CCHid" 		type="numeric" required="yes">
	<cfargument name="CCHTidProc" 	type="numeric" required="yes">
	<cfargument name="monto" type="numeric" required="yes">

	<cfquery datasource="#session.dsn#" name="rsAnticipo">
			select 
					a.GEAid,
					a.GEAtotalOri,
					a.CCHTid, 
					a.CFid,
					a.Mcodigo,
					a.GEAdescripcion,
					a.GEAtotalOri
			from GEanticipo a
			where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">	
	</cfquery>
	
	<cfquery name="rsCajaChica" datasource="#session.dsn#">
			select 
					CCHid,
					CCHresponsable,
					CCHtipo
			from CCHica 
			where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHid#">
			and		Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfset LvarCCHTid=rsAnticipo.CCHTid>
	
	<!--- Invoka componente de Presupuesto--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" 
				method="ReservaAnticipo"
				returnVariable = "LvarNAP">
		<cfinvokeargument name="GEAid" value="#rsAnticipo.GEAid#"/>	
		<cfinvokeargument name="CCHtipoCaja" value="#rsCajaChica.CCHtipo#"/>	
	</cfinvoke>	
	
	<!---Inserta en transacciones Aplicadas.--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="TAplicadas">
		<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
		<cfinvokeargument name="Mcodigo" 				value="#rsAnticipo.Mcodigo#"/>
		<cfinvokeargument name="CCHTdescripcion"    	value="#rsAnticipo.GEAdescripcion#"/>
		<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
		<cfinvokeargument name="CCHTmonto"   			value="#arguments.monto#"/>
		<cfinvokeargument name="CCHTidCustodio"    		value="#rsCajaChica.CCHresponsable#"/>
		<cfinvokeargument name="Sufijo" 				value="ANTICIPO"/>
		<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTtipo"		    	value="ANTICIPO"/>
	</cfinvoke>	
	
	<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="CambiaEstadoTP">
		<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHtipo"    		value="ANTICIPO"/>
		<cfinvokeargument name="CCHTrelacionada"    value="#rsAnticipo.GEAid#"/>
		<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
	</cfinvoke>	
	
	<!--- Crea la transaccion del Custodio--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TESCustodio" 
				method="TranCustodioP" 
				returnvariable="LvarCCHTCid">
		<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHTtipo"       	value="ANTICIPO"/>
		<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
		<cfinvokeargument name="CCHTCrelacionada"   value="#arguments.GEAid#"/>
		<cfinvokeargument name="CCHTid"         	value="#arguments.CCHTidProc#"/>
	</cfinvoke>

	<!--- Actulización del estado del Anticipo: Aprobado--->
	<cfquery datasource="#session.DSN#">
		update GEanticipo
		   set	CPNAPnum	= #LvarNAP#,
				GEAestado	= 2, 
				GEAtipoP	= 0
		where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.GEAid#">
	</cfquery>
</cffunction>

<!--- 
	Aprobación de la Liquidacion de Gasto Empleado
	Se debe Aplicar en el momento de Aprobar (Excepto Caja Chica)
	
	Por Tesorería:		
		1) Aprobación Liquidacion:	
				Aplica la Liquidacion:
					Se Genera Contabilidad
					Se Genera SP de registro con estado Aprobado
					Se Genera Presupuesto
						Se Reversan los movimientos del Anticipo (unicamente los montos liquidados)
							CR: La Reserva de la Aprobacion del Anticipo
							MX: El Pagado=Ejecutado del Pago del Anticipo
						Se Genera el Ejecutado con base en la Poliza contable
						Se Genera el Pagado
							convertir el Ejecutado a Pagado con proporcion = MaximoPagado / TotalGastos, 
							donde el MaximoPagado es GELtotalAnticipos + GELtotalTCE + GELtotalRetenciones <= TotalGastos
					Se pone el estado de la Liquidacion en Finalizado
					Si hay pago adicional:
						Generar una SP manual con estado Sin Aprobar para el pago adicional: unicamente con la CxP empleado
							Si MaximoPagado < TotalGastos generar TESgastosPago:
								incluir el Ejecutado con proporcion = 1 - (MaximoPagado / TotalGastos)
						Aprobar SP de pago adicional:
							Presupuesto:
								CR: N/A
								MX: Genera Ejercido de TESgastosPago
											
		2) Aplicación OP del Pago Adicional:
					Contabilidad: CxP Empleado contra Bancos
					Presupuesto:  Genera Pagado de TESgastosPago
					
		3) Anulacion del Pago Adicional:
				No afecta la Liquidacion

	Por Caja Especial:
		1) Aprobación Liquidacion:	
				Aplica la Liquidacion (igual que en Tesoreria)
				Si hay pago adicional:
					Actualizar el estado de la SP a Enviado a Caja Especial
											
		2) Pago en Efectivo del Pago Adicional:
					Aprobar SPsinOP de la SP de Pago Adicional
						Contabilidad: CxP Empleado contra Cuenta de la Caja Especial
						Presupuesto:  Genera Pagado de TESgastosPago

		3) Reintegro:			(Pres: N/A)

	Por Caja Chica:
		1) Aprobación Liquidacion:	
					Si hay pago adicional: Se envía a la Caja
					Contabilidad : N/A
					Presupuesto:  
						Se Reversa la Reserva generada en la Aprobación del Anticipo (unicamente los montos liquidados)
						Se genera el Reservado de los Gastos Liquidados

		2) Pago en Efectivo:	
					Se registra la entrega
					Contabilidad y Presupuesto: N/A

		3) Reintegro:			
					Contabilidad: Movimientos Actuales de Liquidacion y Reintegro
					Presupuesto:  Movimientos Actuales para las Liquidaciones que se están Reintegrando:
						Se Reversa la Reserva generada en la Aprobación de la Liquidacion
						Se genera el Ejecutado de los Gastos Liquidados
						Se genera el Ejercido/Pagado de los Gastos Liquidados
 --->
<cffunction name="GEliquidacion_Aprobar" output="false" returntype="void" access="public">
	<cfargument name="GELid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">

	<cftransaction>
		<cfset sbTotalesLiquidacion(Arguments.GELid, "LIQUIDACION")>
	</cftransaction>

	<cfquery datasource="#session.dsn#" name="rsLiquidacion">
		select 	le.Ecodigo,GELestado,
				le.TESBid, be.DEid,
				GELnumero, GELdescripcion, GELfecha,
				le.Mcodigo, mo.Miso4217, le.GELtipoCambio,
				GELreembolso,GELtotalGastos,
				GELid, CCHTid, le.CFid, GEAviatico, GEAtipoviatico, 
				le.CFid, cf.Ocodigo,
				CCHid,
				case 
					when CCHid is null then 'TES'
					when (select CCHtipo from CCHica where CCHid = le.CCHid) = 2 then 'TES'
					else 'CCH'
				end as GELtipoPago,
					GELtotalGastos - GELtotalAnticipos
						- GELtotalTCE			- GELtotalRetenciones
						+ GELtotalDevoluciones	+ GELtotalDepositos 	+ GELtotalDepositosEfectivo
						- GELreembolso
					as Balance
		from GEliquidacion le
			inner join CFuncional cf
				on cf.CFid = le.CFid
			inner join Monedas mo
				on mo.Mcodigo = le.Mcodigo
			inner join TESbeneficiario be
				on be.TESBid = le.TESBid
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GELid#">	
	</cfquery>
	<cfif rsLiquidacion.Balance NEQ 0>
		<cfthrow message="Faltan Gastos o Devoluciones qué registrar">
	</cfif>
	<cfif not listfind("0,1",rsLiquidacion.GELestado)>
		<cf_errorCode	code = "51702" msg = "Esta liquidación se encuentra en un estado diferente de 'En preparación' por lo tanto no se puede enviar a aprobar o ser aprobada">
	<cfelseif rsLiquidacion.GELreembolso LT 0>
		<cfthrow message="No se puede aprobar una liquidacion con un Pago Adicional al Empleado negativo">
	<cfelseif rsLiquidacion.GELtipoPago EQ 'TES'>
		<!--- Cambia la Caja Especial de Efectivo --->
		<cfif rsLiquidacion.GELreembolso EQ 0>
			<!--- Asegura que no haya Aplicaciones por Caja Especial sin pago adicional, el proceso se va por Tesoreria --->
			<cfset arguments.FormaPago = 0>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update GEliquidacion
			   set CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FormaPago#" null="#arguments.FormaPago EQ 0#">
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GELid#">
		</cfquery>
	<cfelseif arguments.FormaPago NEQ rsLiquidacion.CCHid>
		<cfthrow message="No se puede cambiar la Caja Chica en la aprobacion">
	</cfif>

	<!---Valida que el Usuario sea Aprobado para ese Centro Funcional--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESUSPmontoMax, TESUSPcambiarTES
		  from TESusuarioSP
		 where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.CFid#">
		   and Usucodigo	= #session.Usucodigo#
		   and TESUSPaprobador = 1
	</cfquery>
	
	<cfif rsSQL.RecordCount EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CFcodigo
			  from CFuncional
			 where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.CFid#">
		</cfquery>
		<cfthrow message="El usuario #session.Usulogin# no está definido como Aprobador para el Centro Funcional #rsSQL.CFcodigo#">
	</cfif>
	
	<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="LiqDirAnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GELid"  		value="#arguments.GELid#">
	</cfinvoke>
	
	<!---Si es viatico y nacional --->
	<cfif #rsLiquidacion.GEAviatico# eq 1 and #rsLiquidacion.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos nacionales definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoNacional">
			<cfinvokeargument name="DEid"  			value="#rsLiquidacion.DEid#">
			<cfinvokeargument name="MontoAnt"  		value="#rsLiquidacion.GELtotalGastos#">
			<cfinvokeargument name="GELid"  		value="#arguments.GELid#">
		</cfinvoke>	
	</cfif>

	<!--- CON PAGO ADICIONAL AL EMPLEADO: caja chica o caja especial de Efectivo --->
	<cfif rsLiquidacion.GELreembolso GT 0>
		<!---Valida anticipos con saldos en contra del mismo tipo--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="AnticiposConSaldosContra">
			<cfinvokeargument name="GELid"  		value="#rsLiquidacion.GELid#">
			<cfinvokeargument name="TESBid"  		value="#rsLiquidacion.TESBid#">
			<cfinvokeargument name="Mcodigo"  		value="#rsLiquidacion.Mcodigo#">
			<cfinvokeargument name="Ecodigo"  		value="#rsLiquidacion.Ecodigo#">
		</cfinvoke>
	</cfif>

	<cfset LvarTipo='GASTO'>

	<cftransaction>
		<!--- Crea la nueva transaccion cuando se aprueba desde Pantalla de Preparación --->
		<cfset LvarCCHTidProc = rsLiquidacion.CCHTid>
		<cfif LvarCCHTidProc EQ "">
			<cfif arguments.FormaPago eq 0>
				<!--- Por Tesoreria (sin pago adicional con caja especial) --->
				<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
							method="TranProceso" 
							returnvariable="LvarCCHTidProc">
						<cfinvokeargument name="Mcodigo" 			value="#rsLiquidacion.Mcodigo#"/>
						<cfinvokeargument name="CCHTdescripcion" 	value="#rsLiquidacion.GELdescripcion#"/>
						<cfinvokeargument name="CCHTmonto"	 		value="#rsLiquidacion.GELtotalGastos#"/>
						<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
						<cfinvokeargument name="CCHTtipo" 			value="GASTO"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#arguments.GELid#"/>
				</cfinvoke>
			<cfelse>
				<!--- Por Caja Chica o Pago adicional por Caja Especial --->
				<cfquery name="rsCajaChica" datasource="#session.dsn#">
					select CCHid,CCHresponsable
					from CCHica 
					where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FormaPago#">
					and		Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
							method="TranProceso" 
							returnvariable="LvarCCHTidProc">
						<cfinvokeargument name="Mcodigo" 			value="#rsLiquidacion.Mcodigo#"/>
						<cfinvokeargument name="CCHTdescripcion" 	value="#rsLiquidacion.GELdescripcion#"/>
						<cfinvokeargument name="CCHTmonto"	 		value="#rsLiquidacion.GELtotalGastos#"/>
						<cfinvokeargument name="CCHTestado" 		value="EN APROBACION CCH"/>
						<cfinvokeargument name="CCHidCustodio" 		value="#rsCajaChica.CCHresponsable#"/>
						<cfinvokeargument name="CCHid" 				value="#rsCajaChica.CCHid#"/>
						<cfinvokeargument name="CCHTtipo" 			value="GASTO"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#arguments.GELid#"/>
				</cfinvoke>
			</cfif>

			<!--- Actualización del estado Liquidacion: En Aprobacion--->
			<cfquery name="ActualizaDet" datasource="#session.dsn#">
				update GEliquidacionGasto 
				   set  GELGestado = 1
				 where GELid = #arguments.GELid#
			</cfquery>
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update GEliquidacion 
				   set 	GELestado = 1,
						CCHTid=#LvarCCHTidProc#
				 where GELid = #arguments.GELid#
			</cfquery>
		</cfif>

		<cfset GEliquidacion_SecuenciarLineas(Arguments.GELid)>

		<cfif rsLiquidacion.GELtipoPago EQ 'TES'>
			<!--- Por Tesoreria o Caja Especial de Efectivo --->
			<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
			<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
			<cfset GEliquidacion_Aplicar(Arguments.GELid, arguments.FormaPago, rsLiquidacion.GELreembolso)>
			<cfif arguments.FormaPago eq 0>
				<!--- Solo por Tesorería sin Caja Especial porque se envía al proceso de CCH --->
				<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
							method="CambiaEstadoTP">
					<cfinvokeargument name="CCHTid"    			value="#LvarCCHTidProc#"/>
					<cfinvokeargument name="CCHTestado" 		value="EMITIDO"/>
					<cfinvokeargument name="CCHtipo"    		value="GASTO"/>
					<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
					<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
				</cfinvoke>
			</cfif>
		<cfelse>
			<!--- Actualización del estado Liquidacion: Aprobado--->
			<cfquery name="ActualizaDet" datasource="#session.dsn#">
				update GEliquidacionGasto 
				   set  GELGestado = 2
				 where GELid = #arguments.GELid#
			</cfquery>
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update GEliquidacion 
				   set 	GELestado = 2
				 where GELid = #arguments.GELid#
			</cfquery>
		</cfif>

		<cfif arguments.FormaPago NEQ 0>
			<!--- Por Caja Chica o Pago Adicional por Caja Especial de Efectivo --->
			<cfset GEliquidacion_Enviar_por_CCH_CEE (arguments.GELid, arguments.FormaPago)>
		</cfif>
		
		<!---Agrega el usuario que aprobo la liquidacion--->
        <cfquery datasource="#session.dsn#">
			update GEliquidacion
			   set UsucodigoAprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GELid#">
		</cfquery>
        
	</cftransaction>
</cffunction>

<!--- Por Caja Chica o con Pago Adicional por Caja Especial de Efectivo --->
<cffunction name="GEliquidacion_Enviar_por_CCH_CEE" access="private">
	<cfargument name="GELid" type="numeric" required="yes">
	<cfargument name="CCHid" type="numeric" required="yes">

	<!---Validaciones De la Liquidacion.--->
	<!---Interfas con Presupuesto--->
	<!---Llamado de Componenete--->
	<!---Actualizacion de Liquidaciones--->
	
	<!--- Valida que no cambia la caja chica--->
	<cfquery datasource="#session.dsn#" name="rsLiquidacion">
		select 	GELid,CCHTid, CFid,Mcodigo,GELdescripcion, CCHid,
				GELtotalGastos, GELtotalDepositos,GELtotalAnticipos, coalesce(GELtotalDevoluciones,0) as GELtotalDevoluciones
		  from GEliquidacion 
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">	
	</cfquery>
	
	<cfquery name="rsCajaChica" datasource="#session.dsn#">
		select 
				CCHid,
				CCHresponsable,
				CCHtipo
		from CCHica 
		where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.CCHid#">
		and		Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfset LvarCCHTid=LvarCCHTidProc>
	
	<cfset LvarTipo='GASTOS'>
	
	<!--- Validaciones Liquidaciones--->	
	<cfquery name="rsLiq" datasource="#session.dsn#">
		select TESBid,Mcodigo,Ecodigo,GELreembolso 
		  from GEliquidacion
		 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
	</cfquery>	

	<!---Verificación del Monto--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="ApruebaImporte" 
				returnvariable="LvarImporte">
		<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
		<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
		<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
		<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
		<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
		<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDevoluciones#"> 
	</cfinvoke>

	<cfif LvarImporte EQ 0>
		<cf_errorCode	code = "50726" msg = "No hay disponible en Caja.">
	</cfif>

	<cfif rsCajaChica.CCHtipo EQ 1>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" 
					method="PresupuestoLiquidacionCCh">
			<cfinvokeargument name="GELid" value="#rsLiquidacion.GELid#">
		</cfinvoke>
	</cfif>
	
	<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="CambiaEstadoTP">
		<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHtipo"    		value="GASTO"/>
		<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
		<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
	</cfinvoke>	

	<!---Inserta en transacciones Aplicadas.--->
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TAplicadas">
		<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
		<cfinvokeargument name="Mcodigo" 				value="#rsLiquidacion.Mcodigo#"/>
		<cfinvokeargument name="CCHTdescripcion"    	value="#rsLiquidacion.GELdescripcion#"/>
		<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
		<cfinvokeargument name="CCHTmonto"   			value="#rsLiquidacion.GELtotalGastos#"/>
		<cfinvokeargument name="CCHTidCustodio"    		value="#rsCajaChica.CCHresponsable#"/>
		<cfinvokeargument name="Sufijo" 				value="GASTO"/>
		<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTtipo"		    	value="GASTO"/>
	</cfinvoke>	
	
	<!--- Crea la transaccion del Custodio--->
	<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="TranCustodioP" returnvariable="LvarCCHTCid">
		<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHTtipo"       	value="#LvarTipo#"/>
		<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
		<cfinvokeargument name="CCHTCrelacionada"   value="#rsLiquidacion.GELid#"/>
		<cfinvokeargument name="CCHTid"         	value="#LvarCCHTid#"/>
	</cfinvoke>  
							
	<cfif rsCajaChica.CCHtipo EQ 1>
		<!---Crea Reintegro Automatico --->
		<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
					method="CreaReintegro" 
					returnvariable="LvarImporte">
			<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
			<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
			<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
			<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
			<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
			<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDepositos#"> 
		</cfinvoke>
	</cfif>
</cffunction>

<!---                               FUNCIONES DE ANTICIPOS A EMPLEADO                                                    --->
<!---GENERA SOLICITUD DE PAGO DE ANTICIPOS--->
<cffunction name="GEanticipo_generaSP" returntype="numeric" access="public">
	<cfargument name="GEAid"  			type="numeric"  required="yes"> 
	<cfargument name="PagoEfectivo"		type="string"	default=""> 

	<cfquery datasource="#session.dsn#" name="rsAnticipo">
		select
			a.GEAid,
			a.GECid as GECid_comision,
			a.GEAtipo,
			a.TESBid, (select rtrim(TESBeneficiarioId) from TESbeneficiario where TESBid=a.TESBid) as TESident,
			a.GEAfechaPagar,
			a.Mcodigo,
			a.GEAtotalOri,
			a.GEAnumero,
			a.CFid, (select Ocodigo from CFuncional where CFid = a.CFid) as OcodigoOri,
			a.CFcuenta,
			a.GEAdescripcion,
			a.GEAdesde,a.GEAhasta,
			a.GEAmanual,
			b.CFcuenta  as CFCU,
			b.GEADid,
			b.PCGDid
		from GEanticipo a
			left join GEanticipoDet b
				on a.GEAid=b.GEAid	
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
		and a.GEAtipo		= 6
	</cfquery>

	<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
	<cfif len(trim(#rsAnticipo.CFid#))>
		  <cfquery name="rsTESID" datasource="#session.dsn#">  <!----Tesoreria a la que pertenece el Centro Funcional----->
			Select 
			TESid 
			   from TEScentrosFuncionales 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.CFid#"> 
			 and  Ecodigo = #session.ecodigo#
		 </cfquery>
		 <cfif len(trim(#rsTESID.TESid#))>   <!---Asigno el TESid encontrado----->
			 <cfset LvarTESID = #rsTESID.TESid#> 
		 <cfelse>
			 <cfset LvarTESID = #session.Tesoreria.TESid#>			<!----En cualquier otra  condicion pongo el de la sesion----->   					     
		 </cfif>
	<cfelse>
         <cfset LvarTESID = #session.Tesoreria.TESid#>			   
	</cfif>
	
	<!---OBTENER EL TESSPnumero--->	
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">		
		<cfquery name="Solicitud" datasource="#session.dsn#">
			select coalesce(max(TESSPnumero),0) + 1 as id
			from TESsolicitudPago
			where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
			
		<!---ENVIO DE LA SOLICITUD A QUE SEA APROBADA EN ESTADO 1--->			
		<cfquery datasource="#session.dsn#" name="insSolApr">
			insert into TESsolicitudPago(
				TESid,
				CFid,
				EcodigoOri,
				TESSPnumero,
				TESSPtipoDocumento, 
				TESSPestado, 
				TESBid,
				TESSPfechaPagar, 
				McodigoOri, 
				TESSPtotalPagarOri, 
				TESSPfechaSolicitud,
				UsucodigoSolicitud, 
				BMUsucodigo,
				CBid,
				TESSPtipoCambioOriManual
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTESID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnticipo.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Solicitud.id#">,
				6, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="1">,  
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.TESBid#">,
				<cfqueryparam value="#LSparseDateTime(rsAnticipo.GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsAnticipo.GEAtotalOri#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(rsAnticipo.CFcuenta)#"	null="#rtrim(rsAnticipo.CFcuenta) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#rsAnticipo.GEAmanual#" null="#rtrim(rsAnticipo.GEAmanual) EQ ""#">
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="insSolApr" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion="false">
	</cflock>				
	<!---OBTENCION DEL TESSPid DE LA NUEVA SOLICITUD, PARA REFERENCIAR EL DETALLE--->	
	<!---SELECCION DEL CODIGO DE LA OFICINA--->
	<cfquery name="CFuncional" datasource="#session.dsn#">
		select Ocodigo from CFuncional where CFid=#CFid#
	</cfquery>
	<!---SELECCIONAR EL ISO DE LA MONEDA--->
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.Mcodigo#">
	</cfquery>
	<!--- Selecciona El concepto de Pagos a Terceros--->
	<cfquery name="rsCPT" datasource="#session.dsn#">
		select min (TESRPTCid) as TESRPTCid
		from TESRPTconcepto
		where CEcodigo= #session.CEcodigo#
		and TESRPTCdevoluciones=0			
	</cfquery>
	
	<cfset referencia='Anticipo a Empleado'>
	<cf_dbfunction name="to_char" args="a.GEAnumero" returnvariable="numero">
	<cfif rsAnticipo.GECid_comision NEQ "">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select GECnumero
			  from GEcomision
			 where GECid = #rsAnticipo.GECid_comision#
		</cfquery>
		<cfset numero  = "'(#rsSQL.GECnumero#) ' #_CAT# #numero#">
	</cfif>
	<cfset LvarDescripcion = "#rsAnticipo.GEAdescripcion#, EmpId:#rsAnticipo.TESident# (#DateFormat(rsAnticipo.GEAdesde,'dd/mm/yyyy')# - #DateFormat(rsAnticipo.GEAhasta,'dd/mm/yyyy')#)">
	<!--- DETALLE DE LA SOLICITUD DE PAGO EN ESTADO 1--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				TESDPtipoCambioSP,
				CFcuentaDB_SP				<!--- Reserva especial caso 1: sin NAPref_SP --->
				<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
				,PCGDid
				</cfif>
			)			
		select		1, 
					a.Ecodigo, 
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#LvarTESID#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#LvarTESSPid#">,
					6, a.GEAid,
					'TEGE',
					#preservesinglequotes(numero)#,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   	value="#referencia#" >,
					a.GEAfechaPagar,
					a.GEAfechaPagar,
					a.GEAfechaPagar,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" 	   	value="#sigMoneda.Miso4217#" >,
					b.GEADmonto,
					b.GEADmonto,
					b.GEADmonto,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarDescripcion#" voidNull>,
					a.CFcuenta,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsAnticipo.OcodigoOri#">,
					#rsCPT.TESRPTCid#,
					a.CFid,
					b.Linea,
					a.GEAmanual,
									<!--- 		1) Si NAPref_SP is NULL:	es Contabilidad + Reserva Standard + Reserva Especial: --->
									<!--- 										SP:      Reserva Standard a CFcuentaDB=CxC y Reserva Especial aCFcuentaDB_SP=CxGastos --->
									<!--- 										Emisión: DesReserva Standard. Se ignora la DesReserva Especial (queda viva) por lo que debe DesReservarse en SP de Liquidación --->
					b.CFcuenta as CuentaDeta
					<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
					,b.PCGDid
					</cfif>					
		 from GEanticipo a
			inner join GEanticipoDet b
			on a.GEAid=b.GEAid	
		where	a.GEAid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
		and 	a.Ecodigo		= #session.Ecodigo#
		and		a.GEAtipo		= 6
		and		b.GEADmonto		<> 0
	</cfquery>
	
	<cfif Arguments.PagoEfectivo NEQ "">
		<cfquery datasource="#session.dsn#">
			insert into TESdetallePago 
				(
					TESDPestado,
					EcodigoOri,
					TESid,
					TESSPid,
					TESDPtipoDocumento,
					TESDPidDocumento,
					TESDPmoduloOri,
					TESDPdocumentoOri,
					TESDPreferenciaOri,
					TESDPfechaVencimiento,
					TESDPfechaSolicitada,
					TESDPfechaAprobada,
					Miso4217Ori,
					TESDPmontoVencimientoOri,
					TESDPmontoSolicitadoOri,
					TESDPmontoAprobadoOri,
					TESDPdescripcion,
					CFcuentaDB,
					OcodigoOri,
					TESRPTCid,
					CFid,
					TESSPlinea,
					TESDPtipoCambioSP
				)			
			select		1, 
						a.Ecodigo, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#LvarTESID#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#LvarTESSPid#">,
						6, a.GEAid,
						'TEGE',
						
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   	value="#Arguments.PagoEfectivo#" >,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   	value="Entrega Efectivo" >,
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" 	   	value="#sigMoneda.Miso4217#" >,
						-a.GEAtotalOri,
						-a.GEAtotalOri,
						-a.GEAtotalOri,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="Pago con Caja Especial de Efectivo">,
						b.CFcuenta,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsAnticipo.OcodigoOri#">,
						#rsCPT.TESRPTCid#,
						a.CFid,

						0 as linea,
						a.GEAmanual
			 from GEanticipo a
				inner join CCHica b
				on a.CCHid=b.CCHid	
			where	a.GEAid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
			and 	a.Ecodigo		= #session.Ecodigo#
			and		a.GEAtipo		= 6
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago 
			   set TESSPtotalPagarOri = 0
			 where TESSPnumero=#Solicitud.id#
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsUpdate">
		update GEanticipo 
		   set 	TESSPid	= #LvarTESSPid#
		 where 	GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	
	<cfreturn LvarTESSPid>
</cffunction>
	
<!---                                            LIQUIDACIONES                                                       --->
<!---                                              Crea SP                                                           --->

<cffunction name="GEliquidacion_Aplicar" access="public">
	<cfargument name="GELid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">
	<cfargument name="PagoAdicional"	type="numeric" required="yes">

	<!--- Obtiene la CxP Empleado para el Pago Adicional Pcodigo=1212 --->
	<cfif Arguments.PagoAdicional GT 0>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo=#session.Ecodigo#
			   and Pcodigo=1212
		</cfquery>
		<cfif rsSQL.Pvalor eq "">
			<cfthrow message="Falta registrar la CxP a Empleado para Pago Adicional en los Parámetros de Gasto Empleados">
		</cfif>
		<cfset LvarCFcuentaCxP = rsSQL.Pvalor>
	<cfelse>
		<cfset LvarCFcuentaCxP = "-1">
	</cfif>
	<cfset GEliquidacion_GeneraContabilidad					(Arguments.GELid, Arguments.FormaPago, Arguments.PagoAdicional, LvarCFcuentaCxP)>
	<cfset LvarTESSPid	= GEliquidacion_GeneraSP			(Arguments.GELid, Arguments.FormaPago, Arguments.PagoAdicional, LvarCFcuentaCxP)>
	<cfset LvarNAP		= GEliquidacion_GeneraPresupuesto	(Arguments.GELid)>
	<cfset GEliquidacion_GeneraMovsDepositos				(Arguments.GELid)>
	<cfset GEliquidacion_GeneraMovsTCE						(Arguments.GELid)>


	<!--- 3) Ejecutar el Genera Asiento --->
	<cfset LvarDescripcion='GE.Liquidacion #rsLiquidacion.GELnumero#: #rsLiquidacion.GELdescripcion#'>
	<cfinvoke 	component="sif.Componentes.CG_GeneraAsiento" 
				method="GeneraAsiento"
				returnvariable="LvarIDcontable" 
		Oorigen 		= "TEGE"
		Eperiodo		= "#rsPresupuesto.AnoDocumento#"
		Emes			= "#rsPresupuesto.MesDocumento#"
		Efecha			= "#rsPresupuesto.FechaDocumento#"
		Edescripcion	= "#LvarDescripcion#"
		Edocbase		= "#rsPresupuesto.NumeroDocumento#"
		Ereferencia		= "#rsPresupuesto.NumeroReferencia#"
		usuario 		= "#session.Usucodigo#"
		Ocodigo 		= "#rsLiquidacion.Ocodigo#"
		Usucodigo 		= "#session.Usucodigo#"
		debug			= "false"
		NAP				= "#LvarNAP#"
	/>

	<cfquery datasource="#session.dsn#">
		update GEliquidacion
		   set CPNAPnum 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">
		     , TESSPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#" null="#LvarTESSPid EQ 0#">
		     , CFcuentaCxP	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaCxP#" null="#LvarCFcuentaCxP EQ "-1"#">
		 where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<!--- 3) Finaliza la Liquidacion y elementos asociados --->
	<cfset GEliquidacion_Estado(Arguments.GELid, false, false, false)>

	<!--- 3) Genera una SP manual si hay pago adicional --->
	<cfif Arguments.PagoAdicional GT 0>
		<cfset GEliquidacion_GeneraSP_PagoAdicional(Arguments.GELid, Arguments.FormaPago, Arguments.PagoAdicional, LvarCFcuentaCxP)>
	</cfif>
</cffunction>

<!--- 
	SP para Pago Adicional
	1) Genera detalle de Pago con CxP Empleado
	2) Genera TESgstosPago con Pagado Adicional
 --->
<cffunction name="GEliquidacion_GeneraSP_PagoAdicional" access="private" returntype="numeric">
	<cfargument name="GELid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">
	<cfargument name="PagoAdicional"	type="numeric" required="yes">
	<cfargument name="CFcuentaCxP"		type="numeric" required="yes">

	<!---====Periodo/Mes Contable Actual=====--->
	<cfif not isdefined("LvarAuxMes")>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxPeriodo = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
	</cfif>
	
	<!--- Selecciona El concepto de Pagos a Terceros--->
	<cfquery name="rsCPT" datasource="#session.dsn#">
		select min (TESRPTCid) as TESRPTCid
			from TESRPTconcepto
		where CEcodigo= #session.CEcodigo#
			and TESRPTCdevoluciones=0			
	</cfquery>

	<!---OBTENER EL TESSPnumero(ultimo numero de solicitud) --->			
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="SolicitudPago" datasource="#session.dsn#">
			select coalesce(max(TESSPnumero),0) + 1 as numero
				from TESsolicitudPago
			where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<!---ENVIO DE LA SOLICITUD A QUE SEA APROBADA EN ESTADO 1--->			
		<cfquery datasource="#session.dsn#" name="insSolApr">
			insert into TESsolicitudPago(
				TESid,
				CFid,
				EcodigoOri,
				TESSPnumero,
				TESSPtipoDocumento, 
				TESSPestado, 
				TESBid,
				TESSPfechaPagar, 
				McodigoOri, 
				TESSPtotalPagarOri, 
				TESSPfechaSolicitud,
				UsucodigoSolicitud, 
				BMUsucodigo,
				TESSPfechaAprobacion,
				UsucodigoAprobacion,
				TESSPtipoCambioOriManual
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLiquidacion.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#SolicitudPago.numero#">,
				0, 
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="1">,  
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLiquidacion.TESBid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#rsLiquidacion.GELfecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLiquidacion.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#rsLiquidacion.GELreembolso#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#rsLiquidacion.GELtipoCambio#">
			)		
			<cf_dbidentity1 datasource="#session.DSN#" name="insSolApr" verificar_transaccion="false" returnvariable="LvarTESSPid">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion="false">
	</cflock>

	<!--- Debito a la CxP Empleado --->
	<cfquery datasource="#session.dsn#">
		insert INTO TESdetallePago (
			 TESid, OcodigoOri, 
			 TESDPestado, EcodigoOri, TESSPid, TESSPlinea,
			 TESDPtipoDocumento, TESDPidDocumento,
			 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
			 TESDPdescripcion, 
			 TESRPTCid,
			 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada, 

			 CFcuentaDB,
			 Miso4217Ori, 
			 TESDPtipoCambioSP,
			 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri 
		)
		values (
			#session.Tesoreria.TESid#, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLiquidacion.Ocodigo#">,
			1, #session.Ecodigo#, #LvarTESSPid#, 1,

			0, #LvarTESSPid#,
			'TEGE', '#rsLiquidacion.GELnumero#', 'GE.Liquidacion',
			<cfqueryparam cfsqltype="cf_sql_varchar"		value="Pago Adicional al Empleado: ">,
			#rsCPT.TESRPTCid#,

			 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,
			 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,
			 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,

			#Arguments.CFcuentaCxP#,
			<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsLiquidacion.Miso4217#">,
			<cfqueryparam cfsqltype="cf_sql_float"			value="#rsLiquidacion.GELtipoCambio#">,
			<cfqueryparam cfsqltype="cf_sql_money"			value="#Arguments.PagoAdicional#">,
			<cfqueryparam cfsqltype="cf_sql_money"			value="#Arguments.PagoAdicional#">,
			<cfqueryparam cfsqltype="cf_sql_money"			value="#Arguments.PagoAdicional#">
		)
	</cfquery>
	
	<!--- Credito a la Cuenta de la Caja de Efectivo --->
	<cfif Arguments.FormaPago NEQ 0>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select CFcuenta
			  from CCHica
			 where CCHid = #Arguments.FormaPAgo#
		</cfquery>
		<cfset LvarCFcuentaCCH = rsSQL.CFcuenta>

		<cfquery datasource="#session.dsn#">
			insert INTO TESdetallePago (
				 TESid, OcodigoOri, 
				 TESDPestado, EcodigoOri, TESSPid, TESSPlinea,
				 TESDPtipoDocumento, TESDPidDocumento,
				 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
				 TESDPdescripcion, 
				 TESRPTCid,
				 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada, 
	
				 CFcuentaDB,
				 Miso4217Ori, 
				 TESDPtipoCambioSP,
				 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri 
			)
			values (
				#session.Tesoreria.TESid#, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLiquidacion.Ocodigo#">,
				1, #session.Ecodigo#, #LvarTESSPid#, 1,
	
				0, #LvarTESSPid#,
				'TEGE', '#rsLiquidacion.GELnumero#', 'GE.Liquidacion',
				<cfqueryparam cfsqltype="cf_sql_varchar"		value="Pago con Caja Especial de Efectivo">,
				#rsCPT.TESRPTCid#,
	
				 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,
				 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,
				 <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#now()#">,
	
				#LvarCFcuentaCCH#,
				<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsLiquidacion.Miso4217#">,
				<cfqueryparam cfsqltype="cf_sql_float"			value="#rsLiquidacion.GELtipoCambio#">,
				<cfqueryparam cfsqltype="cf_sql_money"			value="#-Arguments.PagoAdicional#">,
				<cfqueryparam cfsqltype="cf_sql_money"			value="#-Arguments.PagoAdicional#">,
				<cfqueryparam cfsqltype="cf_sql_money"			value="#-Arguments.PagoAdicional#">
			)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago 
			   set TESSPtotalPagarOri = 0
			 where TESSPnumero=#LvarTESSPid#
		</cfquery>
	</cfif>

	<!--- Determina el signo de los montos de DB/CR a Reservar --->
	<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
				method				= "fnSignoDB_CR" 	
				returnvariable		= "LvarSignoDB_CR"
				
				INTTIP				= "ejecutado.MontoOrigen"
				INTTIPxMonto		= "true"
				Ctipo				= "m.Ctipo"
				CPresupuestoAlias	= "cp"
				
				Ecodigo				= "#session.Ecodigo#"
				AnoDocumento		= "#LvarAuxPeriodo#"
				MesDocumento		= "#LvarAuxMes#"
	/>
	<!--- Generar el Pagado de Gastos Liquidados Adicional a los Anticipos+TCE+Retenciones de la Liquidacion --->
	<!--- Recordar que todavía está en intPresupuesto el Pagado de la Liquidacion, y hay que generar lo que falta por pagar --->
	<cfquery datasource="#session.dsn#">
		insert into TESgastosPago (
			TESSPid,
			EcodigoOri,
			OcodigoOri,
			TESGPdescripcion,
			TESGPmovimiento,
			CFcuenta,
			Miso4217Ori,
			TESGPmontoOri,
			TESGPtipoCambio,
			TESGPmonto
		)
		select 
			#LvarTESSPid#,
			#session.Ecodigo#,
			ejecutado.Ocodigo,
			'Pago Adicional',
			case when #PreserveSingleQuotes(LvarSignoDB_CR)# < 0 then 'C' else 'D' end,
			ejecutado.CFcuenta,
			mo.Miso4217,
			abs(ejecutado.MontoOrigen - coalesce(pagado.MontoOrigen,0)),
			ejecutado.TipoCambio,
			round(abs(ejecutado.MontoOrigen - coalesce(pagado.MontoOrigen,0))*ejecutado.TipoCambio,2)
		  from #request.intPresupuesto# ejecutado
			left join #request.intPresupuesto# pagado
				on pagado.NumeroLinea = ejecutado.NumeroLinea
			   and pagado.TipoMovimiento = 'P'
			inner join CFinanciera cf
				left join CPresupuesto cp
				   on cp.CPcuenta = cf.CPcuenta
				inner join CtasMayor m
					 on m.Ecodigo	= cf.Ecodigo
					and m.Cmayor	= cf.Cmayor
				  on cf.CFcuenta = ejecutado.CFcuenta
			inner join Monedas mo
				on mo.Mcodigo = ejecutado.Mcodigo
		 where ejecutado.TipoMovimiento = 'E'
		   and (ejecutado.MontoOrigen - coalesce(pagado.MontoOrigen,0)) <> 0
	</cfquery>
		
	<!--- Aplica la SP generada: este proceso genera Asiento y NAP independiente --->
	<cfquery datasource="#session.dsn#">
		delete from #request.intarc#
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from #request.intPresupuesto#
	</cfquery>
	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
		<cfinvokeargument name="SPid" 				value="#LvarTESSPid#">
		<cfinvokeargument name="fechaPagoDMY" 		value="#LSDateFormat(now(),'dd/mm/yyyy')#">
		<cfinvokeargument name="generarOP" 			value="false">
		
		<cfinvokeargument name="PRES_Origen" 		value="TEGE">
		<cfinvokeargument name="PRES_Documento" 	value="#rsLiquidacion.GELnumero#">
		<cfinvokeargument name="PRES_Referencia" 	value="GE.LIQ,SP.Pago Adicional">
	</cfinvoke>

	<!--- Si es SP para Caja Especial Efectivo se modifica el TESSPestado --->
	<cfif Arguments.FormaPago NEQ 0>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set TESSPestado = 302
			 where TESSPid = #LvarTESSPid#
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update GEliquidacion
		   set TESSPid_Adicional = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
		 where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<cfreturn LvarTESSPid>
</cffunction>

<cffunction name="GEliquidacion_GeneraSP" output="true" access="private">
	<cfargument name="GELid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">
	<cfargument name="PagoAdicional"	type="numeric" required="yes">
	<cfargument name="CFcuentaCxP"		type="numeric" required="yes">

<cfreturn 0>
	<cfif Estado NEQ 1 AND Estado NEQ 212>
		<cfthrow message="Estado sólo puede ser 1=En Aprobación o 212=Aplicada sin OP">
	</cfif>

Si PagoAdicional > 0 incluir linea a la LvarCFcuentaCxP
si FormaPago NEQ 0 Tomar en cuenta la Caja Espcial de Pago

	<!--- Cuando la liquidación se aprueba sin orden de pago, el "banco de pago" se determina con base en --->
	<!---   el Banco original de los Anticipos, con mayor Monto Liquidado de Anticipos en la Liquidación --->
	<!---   el "Tipo de Cambio de Pago" es el TC de la Liquidacion --->
	<cfset LvarEcodigoPago_212 = "">
	<cfif Estado EQ 212>
		<cfquery name="rsSQL" datasource="#session.DSN#" >
			select op.CBidPago, op.EcodigoPago, 
					sum(coalesce(l.GELAtotal,0)*coalesce(a.GEAmanual,1)) as monto, 
					count(1) as cantidad,
					sum(TESOPtipoCambioPago) as TCpagoTotal
			  from GEliquidacionAnts l
				inner join GEanticipo a
				   on a.GEAid=l.GEAid	
				inner join TESdetallePago dp
					inner join TESordenPago op
					   on op.TESOPid = dp.TESOPid
				   on dp.TESDPtipoDocumento = 6
				  and dp.TESDPidDocumento	= a.GEAid 
			 where l.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			 group by op.CBidPago, op.EcodigoPago
			 order by 3 desc, 1 asc
		</cfquery>
		
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarEcodigoPago_212 = rsSQL.EcodigoPago>
			<cfset LvarTCpago_212 = rsSQL.TCpagoTotal / rsSQL.cantidad>
			<cfquery datasource="#session.dsn#">
				update 	GEliquidacion
				   set 	CBidAnts = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.CBidPago#">
				 where  GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			</cfquery>
		</cfif>
	</cfif>

	<!---Obtener datos de la Liquidacion--->
	<cfquery name="rsLiquida" datasource="#session.dsn#">
		select 	a.GELid,a.CFid,a.GELtipo,a.TESBid,a.GELfecha,a.GELreembolso,a.GELtipoCambio,
				a.Mcodigo,ml.Miso4217
		  from GEliquidacion a
		  	inner join Monedas ml on ml.Mcodigo = a.Mcodigo
		 where a.GELid=#Arguments.GELid#
	</cfquery>

	<!--- Selecciona El concepto de Pagos a Terceros--->
	<cfquery name="rsCPT" datasource="#session.dsn#">
		select min (TESRPTCid) as TESRPTCid
			from TESRPTconcepto
		where CEcodigo= #session.CEcodigo#
			and TESRPTCdevoluciones=0			
	</cfquery>

	<!---OBTENER EL TESSPnumero(ultimo numero de solicitud) --->			
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="SolicitudPago" datasource="#session.dsn#">
			select coalesce(max(TESSPnumero),0) + 1 as numero
				from TESsolicitudPago
			where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<!---ENVIO DE LA SOLICITUD A QUE SEA APROBADA EN ESTADO 1--->			
		<cfquery datasource="#session.dsn#" name="insSolApr">
			insert into TESsolicitudPago(
				TESid,
				CFid,
				EcodigoOri,
				TESSPnumero,
				TESSPtipoDocumento, 
				TESSPestado, 
				TESBid,
				TESSPfechaPagar, 
				McodigoOri, 
				TESSPtotalPagarOri, 
				TESSPfechaSolicitud,
				UsucodigoSolicitud, 
				BMUsucodigo,
				TESSPfechaAprobacion,
				UsucodigoAprobacion,
				TESSPtipoCambioOriManual
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquida.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#SolicitudPago.numero#">,
				7, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Estado#">,  
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquida.TESBid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsLiquida.GELfecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquida.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsLiquida.GELreembolso#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsLiquida.GELtipoCambio#">
			)		
				<cf_dbidentity1 datasource="#session.DSN#" name="insSolApr" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion="false">
	</cflock>

	<!---SELECCION DEL CODIGO DE LA OFICINA--->
	<cfquery name="CFuncional" datasource="#session.dsn#">
		select Ocodigo from CFuncional where CFid=#rsLiquida.CFid#
	</cfquery>

	<!---Obtener la relacion entre la tabla de Anticipo y la de Liquidacion--->
	<cfquery name="rsOcodigo" datasource="#session.dsn#">
		select a.GELid,a.CFid, cf.Ocodigo
		from GEliquidacion a
			inner join CFuncional cf
				on a.CFid = cf.CFid
		where a.GELid=#Arguments.GELid#
	</cfquery>
	
	<!---Agregar Detalle Anticipos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPtipoCambioSP,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				CFcuentaDB_SP, NAPref_SP, LINref_SP			<!--- DesReserva especial caso 2: con NAPref_SP y con CFcuentaDB_SP --->
			<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
				,PCGDid
			</cfif>
			<cfif LvarEcodigoPago_212 NEQ "">
				, TESDPtipoCambioOri
				, TESDPmontoAprobadoLocal
				, EcodigoPago
				, TESDPfechaPago
				, TESDPmontoPago
				, TESDPfactorConversion
				, TESDPmontoPagoLocal
			</cfif>
			)			
		select	#Arguments.Estado#, 
				a.Ecodigo, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#session.Tesoreria.TESid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#LvarTESSPid#">,
				7, l.GELid,
				'TEGE',
				<cf_dbfunction name="to_char" args="a.GEAnumero">,
				'Liquidacion Anticipo',
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<!--- Los Anticipos sólo están en la moneda y tc de la Liquidacion --->
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 	   	value="#rsLiquida.Miso4217#" >,		
				<cf_jdbcquery_param cfsqltype="cf_sql_float" 	   	value="#rsLiquida.GELtipoCambio#" >,		
				-l.GELAtotal,
				-l.GELAtotal,
				-l.GELAtotal,
				a.GEAdescripcion,
				a.CFcuenta as CxC,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsOcodigo.Ocodigo#">,
				#rsCPT.TESRPTCid#,
				a.CFid,
				l.Linea,
								<!--- 		2) Si CFcuentaDB_SP <> -1:	es Contabilidad + DesReserva Especial (Se DesReserva CFcuentaDB_SP) --->
								<!--- 			SP:      Ignorar la Reserva Standard. DesReserva Especial CFcuentaDB_SP referenciando el NAP de la Reserva Especial del Anticipo (linea < 0) --->
								<!--- 		Elimina la Reserva que había quedado viva del Anticipo porque luego se va a crear la Reserva del Gasto Real --->
				b.CFcuenta,	a.CPNAPnum, -b.Linea		
			<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
				,b.PCGDid
			</cfif>	
			<cfif LvarEcodigoPago_212 NEQ "">
				, <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsLiquida.GELtipoCambio#">		
				, round(-l.GELAtotal * <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsLiquida.GELtipoCambio#">,2)
				, #LvarEcodigoPago_212#
				, <cf_dbfunction name="today">
				, round(-l.GELAtotal * <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsLiquida.GELtipoCambio/LvarTCpago_212#">,2)
				, <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsLiquida.GELtipoCambio/LvarTCpago_212#">
				, round(-l.GELAtotal * <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsLiquida.GELtipoCambio#">,2)
			</cfif>
		 from GEliquidacionAnts l
			inner join GEanticipo a
			on a.GEAid=l.GEAid	
			inner join GEanticipoDet b
			on b.GEADid=l.GEADid	
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and l.GELid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		and l.GELAtotal		<> 0	
	</cfquery>	
				
	<!---Agregar Detalle Gastos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPtipoCambioSP,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea
			<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
				,PCGDid
			</cfif>
			<cfif LvarEcodigoPago_212 NEQ "">
				, TESDPtipoCambioOri
				, TESDPmontoAprobadoLocal
				, EcodigoPago
				, TESDPfechaPago
				, TESDPmontoPago
				, TESDPfactorConversion
				, TESDPmontoPagoLocal
			</cfif>
			)
		select  
				#Arguments.Estado#,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#session.Tesoreria.TESid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">,
				7, a.GELid,
				'TEGE',
				<cf_dbfunction name="to_char" args="a.GELnumero">,
				'Liquidacion Gasto',
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<!--- GELG tiene: moneda y tipo de cambio --->
				mg.Miso4217,
				b.GELGtipoCambio,
				b.GELGtotalOri,
				b.GELGtotalOri,
				b.GELGtotalOri,
				b.GELGdescripcion,
				b.CFcuenta,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
				#rsCPT.TESRPTCid#,
				a.CFid,
				b.Linea
			<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
				,b.PCGDid
			</cfif>
			<cfif LvarEcodigoPago_212 NEQ "">
				, b.GELGtipoCambio
				, round(b.GELGtotalOri * b.GELGtipoCambio,2)
				, #LvarEcodigoPago_212#
				, <cf_dbfunction name="today">
				, round(b.GELGtotalOri * b.GELGtipoCambio / <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#LvarTCpago_212#">,2)
				, b.GELGtipoCambio / <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#LvarTCpago_212#">
				, round(b.GELGtotalOri * b.GELGtipoCambio,2)
			</cfif>
			from GEliquidacion a
				inner join GEliquidacionGasto b
					inner join Monedas mg on mg.Mcodigo = b.Mcodigo
					on a.GELid=b.GELid
					and b.GELid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			where a.Ecodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.GELid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			and b.GELGtotalOri	<> 0
	</cfquery>				
	
	<!---Agregar Detalle Depositos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPtipoCambioSP,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea
			<cfif LvarEcodigoPago_212 NEQ "">
				, TESDPtipoCambioOri
				, TESDPmontoAprobadoLocal
				, EcodigoPago
				, TESDPfechaPago
				, TESDPmontoPago
				, TESDPfactorConversion
				, TESDPmontoPagoLocal
			</cfif>
			)
		select  
				#Arguments.Estado#,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#session.Tesoreria.TESid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">,
				7, a.GELid,
				'TEGE',
				<cf_dbfunction name="to_char" args="b.GELDreferencia">,
				'Liquidacion Deposito',
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
				<!--- GELD tiene: moneda y tipo de cambio --->
				md.Miso4217, 
				b.GELDtipoCambio,
				b.GELDtotalOri,
				b.GELDtotalOri,
				b.GELDtotalOri,
				c.CBcodigo,
				(
					select min(CFcuenta) from CFinanciera where Ccuenta = c.Ccuenta
				),
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
				#rsCPT.TESRPTCid#,
				a.CFid,
				b.Linea
			<cfif LvarEcodigoPago_212 NEQ "">
				, b.GELDtipoCambio
				, round(b.GELDtotalOri * b.GELDtipoCambio,2)
				, #LvarEcodigoPago_212#
				, <cf_dbfunction name="today">
				, round(b.GELDtotalOri * b.GELDtipoCambio / <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#LvarTCpago_212#">,2)
				, b.GELDtipoCambio / <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#LvarTCpago_212#">
				, round(b.GELDtotalOri * b.GELDtipoCambio,2)
			</cfif>
			from GEliquidacion a
				inner join GEliquidacionDeps b
					inner join Monedas md on md.Mcodigo = b.Mcodigo
					inner join CuentasBancos c
						on c.CBid = b.CBid
					on a.GELid=b.GELid
					and b.GELid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			where a.Ecodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.GELid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			and b.GELDtotalOri	<> 0
            and c.CBesTCE = <cf_jdbcquery_param value="0" cfsqltype="cf_sql_bit">
    </cfquery>				

	<cfset varReturn=#LvarTESSPid#>
</cffunction>

<!---
	CONTABILIDAD DE LA LIQUIDACION 
	0) CxP por Pago Adicional al Empleado 
	1) CxC Anticipos
	2) Gastos Autorizados 
		Gastos Decucibles y Normales 
		Gastos No Decucibles + Impuesto Credito Fiscal No Deducible 
		Impuesto Credito Fiscal Deducible y Normal 
		Retenciones 
	3) Pagos con TCE 
	4) Depósitos Bancarios 
	5) Depósitos en Efectivo 
--->
<cffunction name="GEliquidacion_GeneraContabilidad"  access="public">
	<cfargument name="GELid"			type="numeric" required="yes">
	<cfargument name="FormaPago"		type="numeric" required="yes">
	<cfargument name="PagoAdicional"	type="numeric" required="yes">
	<cfargument name="CFcuentaCxP"		type="numeric" required="yes">
	
	<cfset INTARC= request.intarc>
	<!---====Periodo/Mes Contable Actual=====--->
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 50
	</cfquery>
	<cfset LvarAuxPeriodo = rsSQL.Pvalor>
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarAuxMes = rsSQL.Pvalor>
	<!---====Cuenta Contable de Retenciones====--->
	<cfquery name="rsCuentaRetencion" datasource="#session.DSN#">
		select Pvalor as Ccuenta
		from Parametros
		where Ecodigo	= #session.Ecodigo# 
		  and Pcodigo	= 150
	</cfquery>
	<cfif rsCuentaRetencion.Ccuenta EQ "">
		<cfthrow detail="La empresa no tiene definida una Cuenta Contable de Retenciones">
	</cfif>
	<!---====Cuenta contable multimoneda=====--->
	<cfquery name="rsCuentaPuente" datasource="#session.DSN#">
		select Pvalor as CuentaPuente
		from Parametros
		where Ecodigo	= #session.Ecodigo# 
		  and Pcodigo	= 200
	</cfquery>
	<cfif rsCuentaPuente.recordcount EQ 0>
		<cfthrow detail="La empresa no tiene definida una Cuenta Contable Multimoneda">
	</cfif>
	<!---====Moneda local de la Empresa========--->
	<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
		select Mcodigo
		  from Empresas
		 where Ecodigo = #session.Ecodigo# 
	</cfquery>
	
	<!--- INTMON2 = INTMOE * TC sin redondear --->
	<!--- INTMON  = round(INTMOE * TC,2) --->

	<!--- 0) CxP por Pago Adicional al Empleado --->
	<cfif Arguments.PagoAdicional GT 0>
		<cfset LvarSinRedondeo = "le.GELreembolso*le.GELtipoCambio">
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
				( 
					INTORI,INTREL,
					INTDOC,INTREF,
					Periodo, Mes, INTFEC,
					Ocodigo,
					INTTIP, INTDES, 
					CFcuenta, Ccuenta, 
	
					Mcodigo, 
					INTMOE,  INTCAM, 
					INTMON2, INTMON
				)
			select 
					'TEGE',1,
					<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
					#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
					cf.Ocodigo,
					'C',
					<cf_dbfunction name="spart" args="'GE.LIQ CxP por Pago Adicional al Empleado';1;50" delimiters=";">,
	
					#Arguments.CFcuentaCxP#, 0, 
	
					le.Mcodigo, 
					le.GELreembolso, 
					le.GELtipoCambio, 
					#LvarSinRedondeo#, round(le.GELreembolso*le.GELtipoCambio,2)
			  from GEliquidacion le
			  	inner join CFuncional cf
					on cf.CFid = le.CFid
			 where le.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		</cfquery>
	</cfif>
	
	<!---1) CxC Anticipos--->
	<!---   Los Anticipos son en la misma moneda que la liquidación --->
	<cfset LvarSinRedondeo = "la.GELAtotal*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON,
				
				LIN_IDREF
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'C',
				<cf_dbfunction name="to_char" args="ae.GEAnumero" returnvariable="LvarNumero">
				<cf_dbfunction name="spart" args="'GE.LIQ Anticipo ' #_Cat# #preserveSingleQuotes(LvarNumero)# #_Cat# ': ' #_Cat# cg.GECdescripcion;1;50" delimiters=";">,

				ae.CFcuenta, 0, 

				ae.Mcodigo, 
				la.GELAtotal, 
				le.GELtipoCambio, 
				#LvarSinRedondeo#,round(la.GELAtotal*le.GELtipoCambio,2),
				
				(le.GELnumero*10000+case when la.Linea<0 then -la.Linea else la.Linea end)
		  from GEliquidacion le
			inner join GEliquidacionAnts la
				on la.GELid=le.GELid
			inner join GEanticipoDet ad
				inner join GEconceptoGasto cg
					on cg.GECid = ad.GECid
				on ad.GEADid=la.GEADid
			inner join GEanticipo ae
				inner join CFuncional cf
					on cf.CFid = ae.CFid
				on ae.GEAid = ad.GEAid	
		 where le.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<!---2) Gastos Autorizados --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from GEliquidacionGasto
		 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and CFcuenta2 IS NOT NULL
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfset LvarGastoDeducible = " Deducible">
		<cfset LvarMontoDeducible = "(lg.GELGtotalOri - lg.GELGnoDeducMonto)">
	<cfelse>
		<cfset LvarGastoDeducible = "">
		<cfset LvarMontoDeducible = "lg.GELGtotalOri">
	</cfif>
	<cfset LvarSinRedondeo = "#LvarMontoDeducible#*lg.GELGtipoCambio">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<!--- Gastos Normales o deducibles --->
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'D',
				<cf_dbfunction name="spart" args="'GE.LIQ Gasto#LvarGastoDeducible# Doc. ' #_Cat# rtrim(lg.GELGnumeroDoc) #_Cat# ': ' #_Cat# lg.GELGdescripcion;1;50" delimiters=";">,

				lg.CFcuenta, 0, 

				lg.Mcodigo, 
				#preserveSingleQuotes(LvarMontoDeducible)#, 
				lg.GELGtipoCambio, 
				#LvarSinRedondeo#, round(#preserveSingleQuotes(LvarMontoDeducible)#*lg.GELGtipoCambio,2)
		  from GEliquidacion le
			inner join GEliquidacionGasto lg
				on lg.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = lg.CFid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and lg.Icodigo IS NULL
		   and #preserveSingleQuotes(LvarMontoDeducible)# <> 0
	</cfquery>
	<!--- Gastos NO deducibles más impuesto no deducible --->
	<cfset LvarSinRedondeo = "(lg.GELGnoDeducMonto + lg.GELGnoDeducImpuesto)*lg.GELGtipoCambio">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'D',
				<cf_dbfunction name="spart" args="'GE.LIQ Gasto No deducible Doc.' #_Cat# rtrim(lg.GELGnumeroDoc) #_Cat# ': ' #_Cat# lg.GELGdescripcion;1;50" delimiters=";">,

				lg.CFcuenta2, 0,

				lg.Mcodigo, 
				(lg.GELGnoDeducMonto + lg.GELGnoDeducImpuesto), 
				lg.GELGtipoCambio, 
				#LvarSinRedondeo#, round((lg.GELGnoDeducMonto + lg.GELGnoDeducImpuesto)*lg.GELGtipoCambio,2)
		  from GEliquidacion le
			inner join GEliquidacionGasto lg
				on lg.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = lg.CFid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and lg.Icodigo IS NULL
		   and lg.CFcuenta2 IS NOT NULL
		   and (lg.GELGnoDeducMonto + lg.GELGnoDeducImpuesto) <> 0
	</cfquery>

	<!--- Impuesto Credito Fiscal Deducible/Normal a la cuenta Acreditable o a la del Impuesto --->
	<cfset LvarImpuestoMontoOri = "round(#LvarMontoDeducible# * case when i.Iporcentaje = 0 then 0 else (coalesce(di.DIporcentaje, i.Iporcentaje) / i.Iporcentaje) end ,2)">

	<cfset LvarImpuestoMoneda	= "case when i.CcuentaCxPAcred is not null then #rsMonedaLocal.Mcodigo# else lg.Mcodigo end">
	<cfset LvarImpuestoMontoLoc2	= "#LvarImpuestoMontoOri#*lg.GELGtipoCambio">
	<cfset LvarImpuestoMontoLoc		= "round(#LvarImpuestoMontoLoc2#,2)">
	<cfset LvarImpuestoMonto		= "case when i.CcuentaCxPAcred is not null then #LvarImpuestoMontoLoc# else #LvarImpuestoMontoOri# end">
	<cfset LvarImpuesto_TC			= "case when i.CcuentaCxPAcred is not null then 1 else lg.GELGtipoCambio end">
									
	<cfset LvarSinRedondeo = "(#LvarImpuestoMontoOri#*lg.GELGtipoCambio)">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'D',
				<cf_dbfunction name="spart" args="'GE.LIQ Impuesto Crédito Fiscal#LvarGastoDeducible# Doc. ' #_Cat# rtrim(lg.GELGnumeroDoc) #_Cat# ':' #_Cat# coalesce(di.DIdescripcion, i.Idescripcion);1;50" delimiters=";">,

				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, coalesce(i.CcuentaCxPAcred, di.Ccuenta, i.Ccuenta), 

				#preserveSingleQuotes(LvarImpuestoMoneda)#,
				#preserveSingleQuotes(LvarImpuestoMonto)#,
				#preserveSingleQuotes(LvarImpuesto_TC)#,
				#LvarSinRedondeo#, #LvarImpuestoMonto#
		  from GEliquidacion le
			inner join GEliquidacionGasto lg
				inner join Impuestos  i
					left join DImpuestos di
						 on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					 on i.Ecodigo 	= lg.Ecodigo
					and i.Icodigo 	= lg.Icodigo
				on lg.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = lg.CFid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and lg.Icodigo IS NOT NULL
		   and #preserveSingleQuotes(LvarImpuestoMonto)# <> 0
		   and i.Icreditofiscal = 1
	</cfquery>

	<!--- Retenciones --->
	<cfset LvarRetencionMontoOri	= "round(lg.GELGtotalRetOri * coalesce(rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje,2)">

	<cfset LvarRetencionMoneda		= "case when r.Conta_MonOri = 1 then #rsMonedaLocal.Mcodigo# else lg.Mcodigo end">
	<cfset LvarRetencionMontoLoc2	= "#LvarRetencionMontoOri#*lg.GELGtipoCambio">
	<cfset LvarRetencionMontoLoc	= "round(#LvarRetencionMontoLoc2#,2)">
	<cfset LvarRetencionMonto		= "case when r.Conta_MonOri = 1 then #LvarRetencionMontoLoc# else #LvarRetencionMontoOri# end">
	<cfset LvarRetencion_TC			= "case when r.Conta_MonOri = 1 then 1 else lg.GELGtipoCambio end">
									
	<cfset LvarSinRedondeo = LvarRetencionMontoLoc2>
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'C',
				<cf_dbfunction name="spart" args="'GE.LIQ Retención Doc. ' #_Cat# rtrim(lg.GELGnumeroDoc) #_Cat# ':' #_Cat# coalesce(rd.Rdescripcion, r.Rdescripcion);1;50" delimiters=";">,

				coalesce(rd.Ccuentaretp, r.Ccuentaretp, #rsCuentaRetencion.Ccuenta#), 

				#preserveSingleQuotes(LvarRetencionMoneda)#,
				#preserveSingleQuotes(LvarRetencionMonto)#,
				#preserveSingleQuotes(LvarRetencion_TC)#,
				#LvarSinRedondeo#, #preserveSingleQuotes(LvarRetencionMontoLoc)#
		  from GEliquidacion le
			inner join GEliquidacionGasto lg
				inner join Retenciones r 				<!--- retencion documento (simple/comp) --->
					left outer join RetencionesComp rc
						left join Retenciones rd 		<!--- retencion hija --->
							on rd.Ecodigo = rc.Ecodigo
							and rd.Rcodigo = rc.RcodigoDet
						on rc.Ecodigo = r.Ecodigo
						and rc.Rcodigo = r.Rcodigo
					 on r.Ecodigo = lg.Ecodigo
					and r.Rcodigo = lg.Rcodigo
				on lg.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = lg.CFid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and lg.Rcodigo IS NOT NULL
		   and #preserveSingleQuotes(LvarRetencionMonto)# <> 0
	</cfquery>
							
	<!--- 4) Pagos con TCE --->
	<cfset LvarSinRedondeo = "lt.GELTmontoOri*lg.GELGtipoCambio">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'C',
				<cf_dbfunction name="spart" args="'GE.LIQ Pagos con TCE: ' #_Cat# c.CBcodigo #_Cat# ' - ' #_Cat# rtrim(lt.GELTreferencia);1;50" delimiters=";">,

				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,c.Ccuenta,

				c.Mcodigo, 
				lt.GELTmontoTCE, 
				lt.GELTtipoCambio, 
				#LvarSinRedondeo#, round(lt.GELTmontoTCE*lt.GELTtipoCambio,2)		
		  from GEliquidacion le
			inner join GEliquidacionTCE lt
				on lt.GELid=le.GELid
			inner join GEliquidacionGasto lg
				on lg.GELGid=lt.GELGid
			inner join CFuncional cf
				on cf.CFid = le.CFid
			inner join CuentasBancos c
				on c.CBid = lt.CBid_TCE
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<!--- 5) Depósitos Bancarios --->
	<cfset LvarSinRedondeo = "ld.GELDtotalOri*ld.GELDtipoCambio">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'D',
				<cf_dbfunction name="spart" args="'GE.LIQ Deposito Banco: ' #_Cat# rtrim(b.Bcodigo) #_Cat# ' - ' #_Cat# rtrim(c.CBcodigo) #_Cat# ' - ' #_Cat# rtrim(ld.GELDreferencia);1;50" delimiters=";">,

				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,c.Ccuenta,

				c.Mcodigo, 
				ld.GELDtotalOri, 
				ld.GELDtipoCambio, 
				#LvarSinRedondeo#, round(ld.GELDtotalOri*ld.GELDtipoCambio,2)		
		  from GEliquidacion le
			inner join GEliquidacionDeps ld
				on ld.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = le.CFid
			inner join CuentasBancos c
				on c.CBid = ld.CBid
			inner join Bancos b
				on b.Bid = c.Bid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<!--- 4) Depósitos en Efectivo --->
	<cfset LvarSinRedondeo = "ld.GELDtotalOri*ld.GELDtipoCambio">
	<cfset LvarSinRedondeo = "round(#LvarSinRedondeo#/le.GELtipoCambio,2)*le.GELtipoCambio">
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				Periodo, Mes, INTFEC,
				Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, 
				INTMOE,  INTCAM, 
				INTMON2, INTMON
			)
		select 
				'TEGE',1,
				<cf_dbfunction name="to_char" args="le.GELnumero">, 'GE.Liquidacion',
				#LvarAuxPeriodo#, #LvarAuxMes#, '#DateFormat(now(),"YYYYMMDD")#', 
				cf.Ocodigo,
				'D',
				<cf_dbfunction name="spart" args="'GE.LIQ Deposito Caja Efectivo: ' #_Cat# c.CCHcodigo #_Cat# ' - ' #_Cat# rtrim(ld.GELDreferencia);1;50" delimiters=";">,

				c.CFcuentaRecepcion, 0,

				c.Mcodigo, 
				ld.GELDtotalOri, 
				ld.GELDtipoCambio, 
				#LvarSinRedondeo#, round(ld.GELDtotalOri*ld.GELDtipoCambio,2)		
		  from GEliquidacion le
			inner join GEliquidacionDepsEfectivo ld
				on ld.GELid=le.GELid
			inner join CCHica c
				on c.CCHid = ld.CCHid
			inner join CFuncional cf
				on cf.CFid = c.CFid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	<cfinvoke 	component="TESaplicacion" 
				method="sbBAL_MonedaExtranjeraPorOficina"
				Ecodigo="#session.Ecodigo#" 
				
	>

</cffunction>

<!---
	PRESUPUESTO DE LA LIQUIDACION 
	1) Reversar los movimientos del Anticipo (unicamente los montos liquidados)
		Normal: Reserva especial generados durante la Aprobacion del Anticipo
		Mexico: Pagado, Ejercido, Ejecutado generados durante el Pago del Anticipo
	2) Generar el Ejecutado a partir del Asiento ya generado
	3) Generar el Pagado: convertir el Ejecutado a Pagado con proporcion MaximoPagado / TotalGastos, 
	   donde el MaximoPagado es GELtotalAnticipos + GELtotalTCE + GELtotalRetenciones <= TotalGastos
--->
<cffunction name="GEliquidacion_GeneraPresupuesto"  access="private" returntype="numeric">
<cfargument name="GELid" type="numeric" required="yes">

	
	<!--- 1) Reversar la parte liquidada que generó el pago del anticipo --->
	<!--- Generar Contabilidad Presupuestaria --->
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 1140
	</cfquery>
	<cfset LvarContaPresupuestaria = (rsSQL.Pvalor EQ "S")>

	<cfif LvarContaPresupuestaria>
		<!--- 'EJ/P:PAGADO' --->
		<cfset LvarNAP_Anticipo = "ae.CPNAPnum_Pago">
		<cfset LvarLIN_Anticipo = "(ae.CPNAPnum * 10000 + ad.Linea)">
		<cfset LvarReversar = "P,EJ,E">
		<cfset LvarLineaID = 10>
	<cfelse>
		<cfset LvarNAP_Anticipo = "ae.CPNAPnum">
		<cfset LvarLIN_Anticipo = "-ad.Linea">
		<cfset LvarReversar = "RC">
		<cfset LvarLineaID = 10>
	</cfif>
	
	<cfloop list="#LvarReversar#" index="LvarMov">
		<cfquery datasource="#session.dsn#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					DocumentoPagado,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					NumeroLineaID, 
					Ocodigo,

					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,

					TipoMovimiento,
					CFcuenta, 
					NAPreferencia,	LINreferencia
					
				<cfif LvarEsConPlanCompras> <!---si es plan de compras--->
					,PCGDid
				</cfif>
				)
			select  'TEGE',
					<cf_dbfunction name="to_char" args="le.GELnumero">, 
					'GE.Liquidacion',
					<cf_dbfunction name="to_char" args="ae.GEAnumero" returnvariable="LvarNumero">
					<cf_dbfunction name="spart" args="'GE.LIQ Anticipo ' #_Cat# #preserveSingleQuotes(LvarNumero)# #_Cat# ': ' #_Cat# cg.GECdescripcion;1;50" delimiters=";">,
					'#DateFormat(now(),"YYYYMMDD")#', 
					#LvarAuxPeriodo#, 
					#LvarAuxMes#, 

					-(select INTLIN from #INTARC# where LIN_IDREF = (le.GELnumero*10000+la.Linea)),
					#LvarLineaID#, 
					cf.Ocodigo,

					ae.Mcodigo, 
					-la.GELAtotal, 
					ae.GEAmanual, 
					-round(la.GELAtotal*ae.GEAmanual,2),

					'#LvarMov#',
					ad.CFcuenta,
					#LvarNAP_Anticipo#, #LvarLIN_Anticipo#
				<cfif LvarEsConPlanCompras>
					,ad.PCGDid
				</cfif>					
			  from GEliquidacion le
				inner join GEliquidacionAnts la
					on la.GELid=le.GELid
				inner join GEanticipoDet ad
					inner join GEconceptoGasto cg
						on cg.GECid = ad.GECid
					on ad.GEADid=la.GEADid
				inner join GEanticipo ae
					inner join CFuncional cf
						on cf.CFid = ae.CFid
					on ae.GEAid = ad.GEAid	
			 where le.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		</cfquery>

		<cfset LvarLineaID = LvarLineaID + 1>
	</cfloop>

	<!--- 2) Generar Ejecuciones a partir del Asiento ya generado --->

	<!--- Determina el signo de los montos de DB/CR a Ejecutar --->
	<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
				method				= "fnSignoDB_CR" 	
				returnvariable		= "LvarSignoDB_CR"

				INTTIP				= "i.INTTIP"
				Ctipo				= "m.Ctipo"
				CPresupuestoAlias	= "cp"
				
				Ecodigo				= "#session.Ecodigo#"
				AnoDocumento		= "#LvarAuxPeriodo#"
				MesDocumento		= "#LvarAuxMes#"
	/>
	<cfquery name="rs" datasource="#session.dsn#">
		insert into #request.intPresupuesto#
			(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				NumeroLinea, 
				Ccuenta,
				CFcuenta,
				CPcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				PCGDid,
				PCGDcantidad
			)
		select
				INTORI,
				INTDOC,
				INTREF,
				<cf_dbfunction name="today">,
				i.Periodo,
				i.Mes,
				INTLIN,
				i.Ccuenta,
				i.CFcuenta,
				cp.CPcuenta,
				i.Ocodigo,
				i.Mcodigo,
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen, 
				INTCAM,
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto, 
				'E',
				PCGDid,
				#PreserveSingleQuotes(LvarSignoDB_CR)# * coalesce(DDcantidad,0)
		  from  #INTARC# i
			inner join CFinanciera cf
				left join CPresupuesto cp
				   on cp.CPcuenta = cf.CPcuenta
				inner join CtasMayor m
				   on m.Ecodigo	= cf.Ecodigo
				  and m.Cmayor	= cf.Cmayor
			   on cf.CFcuenta = i.CFcuenta
	</cfquery>	

	<!--- 3) Generar el Pagado como proporcion Maximo/TotalGastos, 
			 donde el Maximo es mayor entre  TotalGastos y GELtotalAnticipos + GELtotalTCE + GELtotalRetenciones
	--->
	<cfquery name="rsTotal" datasource="#session.dsn#">
		select 	GELtotalAnticipos + GELtotalTCE + GELtotalRetenciones as Pagado,
				GELtotalGastos as Gastos
		  from GEliquidacion a
		 where GELid = #arguments.GELid#
	</cfquery>
	<cfif rsTotal.Gastos EQ 0>
		<cfset LvarProporcion = 0>
	<cfelseif rsTotal.Pagado GTE rsTotal.Gastos>
		<cfset LvarProporcion = 1>
	<cfelse>
		<cfset LvarProporcion = rsTotal.Pagado / rsTotal.Gastos>
	</cfif>

	<cfinvoke 	component		= "sif.Componentes.PRES_Presupuesto"	
				method			= "GenerarEjecucionConPago" 	

				Conexion		= "#session.DSN#"
				Ecodigo			= "#session.Ecodigo#"
				Proporcion		= "#LvarProporcion#"
				SoloPositivas	= "true"
	/>

	<cfobject component="sif.Componentes.PRES_Presupuesto" name="LobjControl">	
	
	<!--- 2) Ejecutar el Control de Presupuesto: Crea NAP --->
	<cfquery name="rsPresupuesto" datasource="#session.DSN#" >
		select	ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento
		from #request.intPresupuesto#
	</cfquery>
	<cfset LvarNAP = LobjControl.ControlPresupuestario	
		(	
			rsPresupuesto.ModuloOrigen,
			rsPresupuesto.NumeroDocumento,
			"GE.LIQ,Aprobacion",
			rsPresupuesto.FechaDocumento,
			rsPresupuesto.AnoDocumento,
			rsPresupuesto.MesDocumento,
			session.DSN,
			session.Ecodigo
		)
	>
			
	<cfif LvarNAP LT 0>
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
	</cfif>

	<cfreturn LvarNAP>
</cffunction>

<!---                                                     Movimientos                                                    --->
<!---
	Genera los Movimientos en MLibros de los Depositos Bancario
--->
<cffunction name="GEliquidacion_GeneraMovsDepositos" access="private" >
	<cfargument name="GELid" type="numeric" required="yes">
	
	<!---====Periodo/Mes Contable Actual=====--->
	<cfif not isdefined("LvarAuxMes")>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxPeriodo = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
	</cfif>
	
	<cf_dbfunction name="to_char"	returnvariable="LvarGELnumero"		args="le.GELnumero">
	<cf_dbfunction name="concat" 	returnvariable="LvarReferencia"		args="'GE.LIQ:' ° #LvarGELnumero#" delimiters="°">
	<cf_dbfunction name="concat" 	returnvariable="LvarMLdescripcion"	args="'GE.Liquidacion ' ° #LvarGELnumero# ° ' : por ' ° rtrim(be.TESBeneficiario)" delimiters="°">
	<cf_dbfunction name="sPart" 	returnvariable="LvarMLdescripcion"	args="#LvarMLdescripcion#°1°75" delimiters="°">
	<cfquery name="rsDEPs" datasource="#session.dsn#">
		select
				ld.Ecodigo, 
				cb.Bid ,
				ld.CBid, 
				ld.BTid,
				ld.GELDreferencia as MLdocumento, 					

				#preservesinglequotes(LvarReferencia)# as MLreferencia,
				#preservesinglequotes(LvarMLdescripcion)# as MLdescripcion,
				ld.GELDfecha,
				cb.Mcodigo,  
				ld.GELDtipoCambio as MLtipocambio, 
				ld.GELDtotalOri as MLmonto,
				round(ld.GELDtipoCambio * ld.GELDtotalOri, 2) as MLmontoloc
		  from GEliquidacion le
			inner join GEliquidacionDeps ld
				on ld.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = le.CFid
			inner join CuentasBancos cb
				on cb.CBid = ld.CBid
			inner join Bancos b
				on b.Bid = cb.Bid
			inner join TESbeneficiario be
				on be.TESBid = le.TESBid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and cb.CBesTCE = 0
	</cfquery>

	<cfif rsDEPs.recordCount EQ 0>
		<cfreturn>
	</cfif>
	
	<cfset LvarMLids = "">

	<cfloop query="rsDEPs">
		<cfset LvarBTid = fnVerificaMLibrosTraeBT (rsDEPs.Ecodigo, rsDEPs.CBid,rsDEPs.MLdocumento,rsDEPs.BTid)>

		<cfquery datasource="#session.dsn#" name="insert">
			insert into	MLibros
				(
					Ecodigo, 
					Bid, 
					CBid, 
					BTid, 
					MLdocumento, 

					MLreferencia, 
					MLdescripcion, 
					MLperiodo, 
					MLmes, 
					MLfechamov, 
					MLfecha, 
					MLconciliado, MLtipomov, 

					Mcodigo, 
					MLmonto, 
					MLtipocambio, 
					MLmontoloc, 
					MLusuario
				)
			VALUES(
				<cf_jdbcQuery_param cfsqltype="cf_sql_integer" scale="0" 	value="#rsDEPs.Ecodigo#"          	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsDEPs.Bid#"                	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsDEPs.CBid#"             	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsDEPs.BTid#"          		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  	value="#rsDEPs.MLdocumento#"       	voidNull>,

				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  	value="#rsDEPs.MLreferencia#"       	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="50"  	value="#rsDEPs.MLdescripcion#"     	voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 				value="#LvarAuxPeriodo#" 				voidNull> , 
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 				value="#LvarAuxMes#" 					voidNull> , 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 			value="#now()#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 				value="#rsDEPs.GELDfecha#" 				voidNull>,
				'N', 'D',

				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsDEPs.Mcodigo#"            	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_money"            	value="#rsDEPs.MLmonto#"       		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#rsDEPs.MLtipocambio#"  		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_money"            	value="#rsDEPs.MLmontoloc#"    		voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 				value="#session.Usulogin#"				voidNull> 							
			)	
			<cf_dbidentity1 datasource="#session.DSN#" name="insert" verificar_transaccion="no">
		</cfquery>		
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" verificar_transaccion="no" returnvariable="LvarMLid">
		<cfset LvarMLids = listAppend(LvarMLids,LvarMLid)>
	</cfloop>
</cffunction>

<!---
	Genera los Movimientos en MLibros de los Pagos por TCE
--->
<cffunction name="GEliquidacion_GeneraMovsTCE" access="private" >
	<cfargument name="GELid" type="numeric" required="yes">
	
	<cf_dbfunction name="to_char"	returnvariable="LvarGELnumero"		args="le.GELnumero">
	<cf_dbfunction name="concat" 	returnvariable="LvarReferencia"		args="'GE.LIQ:' ° #LvarGELnumero#" delimiters="°">
	<cf_dbfunction name="concat" 	returnvariable="LvarMLdescripcion"	args="'GE.Liquidacion ' ° #LvarGELnumero# ° ' : por ' ° rtrim(be.TESBeneficiario)" delimiters="°">
	<cf_dbfunction name="sPart" 	returnvariable="LvarMLdescripcion"	args="#LvarMLdescripcion#°1°75" delimiters="°">
	<cfquery name="rsTCEs" datasource="#session.dsn#">
		select
				le.Ecodigo, 
				cb.Bid ,
				lt.CBid_TCE, 
				lt.GELTreferencia as MLdocumento, 					

				#preservesinglequotes(LvarReferencia)# as MLreferencia,
				#preservesinglequotes(LvarMLdescripcion)# as MLdescripcion,
				lt.GELTfecha,
				cb.Mcodigo,  
				lt.GELTtipoCambio as MLtipocambio, 
				lt.GELTmontoOri as MLmonto,
				round(lt.GELTtipoCambio * lt.GELTmontoOri, 2) as MLmontoloc
		  from GEliquidacion le
			inner join GEliquidacionTCE lt
				on lt.GELid=le.GELid
			inner join CFuncional cf
				on cf.CFid = le.CFid
			inner join CuentasBancos cb
				on cb.CBid = lt.CBid_TCE
			inner join Bancos b
				on b.Bid = cb.Bid
			inner join TESbeneficiario be
				on be.TESBid = le.TESBid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and cb.CBesTCE = 1
	</cfquery>

	<cfif rsTCEs.recordCount EQ 0>
		<cfreturn>
	</cfif>
	
	<cfparam name="LvarMLids" default="">

	<cfloop query="rsTCEs">
		<cfset LvarBTid = fnVerificaMLibrosTraeBT (rsTCEs.Ecodigo, rsTCEs.CBid_TCE, rsTCEs.MLdocumento,0,'P8')>

		<cfquery datasource="#session.dsn#" name="insert">
			insert into	MLibros
				(
					Ecodigo, 
					Bid, 
					CBid, 
					BTid, 
					MLdocumento, 

					MLreferencia, 
					MLdescripcion, 
					MLperiodo, 
					MLmes, 
					MLfechamov, 
					MLfecha, 
					MLconciliado, MLtipomov, 

					Mcodigo, 
					MLmonto, 
					MLtipocambio, 
					MLmontoloc, 
					MLusuario
				)
			VALUES(
				<cf_jdbcQuery_param cfsqltype="cf_sql_integer" scale="0" 	value="#rsTCEs.Ecodigo#"          	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsTCEs.Bid#"                	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsTCEs.CBid_TCE#"          	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#LvarBTid#"          		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  	value="#rsTCEs.MLdocumento#"       	voidNull>,

				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  	value="#rsTCEs.MLreferencia#"       	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="50"  	value="#rsTCEs.MLdescripcion#"     	voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 				value="#LvarAuxPeriodo#" 				voidNull> , 
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 				value="#LvarAuxMes#" 					voidNull> , 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 			value="#now()#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 				value="#rsTCEs.GELTfecha#" 				voidNull>,
				'N', 'C',

				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#rsTCEs.Mcodigo#"            	voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_money"            	value="#rsTCEs.MLmonto#"       		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#rsTCEs.MLtipocambio#"  		voidNull>,
				<cf_jdbcQuery_param cfsqltype="cf_sql_money"            	value="#rsTCEs.MLmontoloc#"    		voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 				value="#session.Usulogin#"				voidNull> 							
			)	
			<cf_dbidentity1 datasource="#session.DSN#" name="insert" verificar_transaccion="no">
		</cfquery>		
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" verificar_transaccion="no" returnvariable="LvarMLid">
		<cfset LvarMLids = listAppend(LvarMLids,LvarMLid)>
	</cfloop>
</cffunction>

<cffunction name="fnVerificaMLibrosTraeBT" output="false" access="private" returntype="numeric">
	<cfargument name="Ecodigo"  type="numeric"	required="yes">
	<cfargument name="CBid"     type="numeric"	required="yes">
	<cfargument name="MLdoc"    type="string"	required="yes">
	<cfargument name="BTid"     type="numeric"	required="yes">
	<cfargument name="BTcodigo" type="string"	default="">
	
	<cfinvoke 	component		= "TESaplicacion" 
				method			= "fnVerificaMLibrosTraeBT"
				returnvariable	= "LvarBTid"
				
				Ecodigo 		= "#Arguments.Ecodigo#"
				CBid			= "#Arguments.CBid#"
				MLdoc			= "#Arguments.MLdoc#"
				BTid			= "#Arguments.BTid#"
				BTcodigo		= "#Arguments.BTcodigo#"
	>
	<cfreturn LvarBTid>
</cffunction>

<!---                                                     Emision de Cheque                                              --->
<!---
1)-Desreservar el gasto
2)-Desreservar el deposito
3)Llamar a la funcion sbEjecutaLiquidacionGasto
4)Llamar a la funcion sbEjecutaLiquidacionDeposito
Contabilidad
Bancos
--->


<!---**********************************************************************************************************************--->
<!---                                        EMISION DE ORDENES DE PAGO                                                   --->
<cffunction name="sbOP_MovimientosAnticiposGE" output="true" access="package">
	<cfargument name="TESOPid" 		type="numeric" 	required="yes">
	<cfargument name="AnulacionOP" 	type="boolean" 	required="yes">
	<cfargument name="AnulacionSP" 	type="boolean" 	required="yes">
	<cfargument name="TESSPid" 		type="numeric" 	default="-1">

	<cfif Arguments.AnulacionOP or Arguments.AnulacionSP>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from GEanticipo g
				inner join GEanticipoDet gd
					 on gd.GEAid = g.GEAid
				 inner join TESdetallePago dp
					 on dp.TESid				= #session.Tesoreria.TESid#
				<cfif arguments.TESOPid EQ -1>
				    and dp.TESSPid	= #arguments.TESSPid#
				<cfelse>
				    and dp.TESOPid	= #arguments.TESOPid#
				</cfif>
					and dp.TESDPtipoDocumento 	= 6
					and dp.TESDPidDocumento		= g.GEAid
				where gd.GEADutilizado <> 0
		</cfquery>

		<cfif rsSQL.cantidad gt 0>
			<cf_errorCode	code = "51632" msg = "El Anticipo no se puede anular porque ya ha sido liquidado">
		</cfif>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update GEanticipo
	<cfif Arguments.AnulacionSP>
			<!--- Si se anula la SP se anula el Anticipo --->
		   set GEAestado = 3
	<cfelseif Arguments.AnulacionOP>
			<!--- Si solo se anula la OP vuelve a Aprobado --->
		   set GEAestado = 2
	<cfelse>
			<!--- Pagado sin liquidar --->
		   set GEAestado = 4
	</cfif>
		 where exists
			(
				select 1
				  from TESdetallePago dp
				 where dp.TESid		= #session.Tesoreria.TESid#
			<cfif arguments.TESOPid EQ -1>
				   and dp.TESSPid	= #arguments.TESSPid#
			<cfelse>
				   and dp.TESOPid	= #arguments.TESOPid#
			</cfif>
				   and dp.TESDPtipoDocumento 	= 6
				   and dp.TESDPidDocumento		= GEanticipo.GEAid
			)
	</cfquery>
</cffunction>

<!--- Obsoleta si se invoca desde la Aplicacion de OP TESSPtipoDocumento = 7 = Liquidacion.  --->
<!--- Si se invoca en una anulación de Documento de Pago no toca el estado de la Liquidacion: solo para Liquidaciones viejas --->
<!--- Si se invoca en una anulación de SP anula la Liquidacion: solo para Liquidaciones viejas --->
<cffunction name="sbOP_MovimientosLiquidacionGE" output="true" access="package">
	<cfargument name="TESOPid" 		type="numeric" 	required="yes">
	<cfargument name="AnulacionOP" 	type="boolean" 	required="yes">
	<cfargument name="AnulacionSP" 	type="boolean" 	required="yes">
	<cfargument name="TESSPid" 		type="numeric" 	default="-1">

	<cfif Arguments.AnulacionOP>
		<cfreturn>
	</cfif>
	
	<cfquery name="rsLIQs" datasource="#session.dsn#">
		select l.GELid, GELestado
		  from TESsolicitudPago p 
			inner join GEliquidacion l
			on l.TESSPid=p.TESSPid
	<cfif arguments.TESOPid EQ -1>
		where p.TESSPid=#arguments.TESSPid#
	<cfelse>
		where p.TESOPid=#arguments.TESOPid#
	</cfif>
	</cfquery>

	<cfloop query="rsLIQs">
		<!--- Finaliza la Liquidacion y elementos asociados (con banderas de tesoreria) --->
		<cfset GEliquidacion_Estado(#rsLIQs.GELid#, true, false, Arguments.AnulacionSP)>

		<!--- Procesa los Deposito --->
		<cfif rsLIQs.GELestado LT 3>
			<cfset GEliquidacion_GeneraMovsDepositos(#rsLIQs.GELid#)>
		</cfif>
	</cfloop>
</cffunction>

<!--- Finaliza la Liquidacion y elementos asociados --->
<cffunction name="GEliquidacion_Estado" output="true" access="public">
	<cfargument name="GELid" 		type="numeric" 	required="yes">
	<cfargument name="Desde_OP" 	type="boolean" 	default="no">
	<cfargument name="Es_CCH" 		type="boolean" 	default="no">
	<cfargument name="Anulacion" 	type="boolean" 	default="no">

	<!--- Estado de la Liquidacion --->
	<cfquery datasource="#session.dsn#">
		update GEliquidacion
		<cfif Arguments.Anulacion>
		   set GELestado = 3		<!--- Anulado --->
		<cfelseif Arguments.Es_CCH>
		   set GELestado = 5		<!--- Por Reintegrar: falta contabilizacion --->
		<cfelse>
		   set GELestado = 4		<!--- Finalizado --->
		</cfif>
		 where GELid= #Arguments.GELid#
	</cfquery>

	<cfquery name="ActualizaDet" datasource="#session.dsn#">
		update GEliquidacionGasto 
		<cfif Arguments.Anulacion>
		   set GELGestado = 3		<!--- Anulado --->
		<cfelseif Arguments.Es_CCH>
		   set GELGestado = 5		<!--- Por Reintegrar: falta contabilizacion --->
		<cfelse>
		   set GELGestado = 4		<!--- Finalizado --->
		</cfif>
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<!--- Actualiza el Utilizado de Detalle de Anticipos con la parte liquidada --->
	<cfquery name="upMontos" datasource="#session.dsn#">
		update GEanticipoDet
		   set  GEADutilizado = GEADutilizado
				<cfif Arguments.Anulacion>
				   -
				<cfelse>
				   +
				</cfif>
					(
						select sum(GELAtotal)
						  from GEliquidacionAnts
						 where GELid	= #Arguments.GELid#
						   and GEADid	= GEanticipoDet.GEADid
					)
			<!--- Obsoleto TESSPtipoDocumento = 7 --->
			<cfif Arguments.Desde_OP>
			 ,	TESDPaprobadopendiente = TESDPaprobadopendiente
				<cfif Arguments.Anulacion>
				   +
				<cfelse>
				   -
				</cfif>
					(
						select sum(GELAtotal)
						  from GEliquidacionAnts
						 where GELid	= #Arguments.GELid#
						   and GEADid	= GEanticipoDet.GEADid
					)
			</cfif>
		 where 
				(
					select count(1)
						from GEliquidacionAnts
					where GELid		= #Arguments.GELid#
					  and GEADid	= GEanticipoDet.GEADid
				) > 0
	</cfquery>

	<!--- Actualiza el Estado de los Anticipos involucrados --->
	<cfquery datasource="#session.dsn#">
		update GEanticipo
		   set GEAestado = 
			<cfif Arguments.Anulacion>
				case
					when
						(
							select count(1)
							  from GEanticipoDet
							 where GEAid = GEanticipo.GEAid
							   and round(GEADutilizado,2) > 0
						) = 0
					then 4		<!--- Sólo Pagado:       No hay ninguno utilizado --->
					else 5		<!--- Liquidado Parcial: Hay Detalles ya utilizados --->
				end
			<cfelse>
				case
					when
						(
							select count(1)
							  from GEanticipoDet
							 where GEAid = GEanticipo.GEAid
							   and round(GEADmonto - GEADutilizado,2) > 0
						) > 0
					then 5		<!--- Liquidado Parcial: Todavia hay Detalles con Saldo --->
					else 6		<!--- Liquidado Total:   No hay Detalles con Saldo --->
				end
			</cfif>
		 where (
				select count(1)
				  from GEliquidacionAnts
				 where GEliquidacionAnts.GELid	= #Arguments.GELid#
				   and GEliquidacionAnts.GEAid	= GEanticipo.GEAid
				) > 0
	</cfquery>

	<!--- Actualiza el Estado de las Comisiones involucrados --->
	<!--- La Comision se Finaliza cuando no hay anticipos vivos --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select le.GECid as GECid_comision, count(1) as cantidad
		  from GEliquidacion le
			inner join GEanticipo ae
				on ae.GECid = le.GECid
		  where GELid = #Arguments.GELid#
		    and GEAestado NOT in (3,6)	<!--- Vivos = cualquier estado menos Cancelado y Liquidado Total --->
		  group by le.GECid
	</cfquery>
	<cfif rsSQL.GECid_comision NEQ "" AND rsSQL.cantidad EQ 0>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select GECid as GECid_comision, GECnumero, GECestado
			  from GEcomision
			 where GECid=#rsSQL.GECid_comision# 
		</cfquery>
		<cfif rsSQL.GECestado EQ 3>
			<cfthrow type="toUser" message="La comisión numero #rsSQL.GECnumero# está cancelada">
		</cfif>
		<cfquery datasource="#session.DSN#">
			update GEcomision
			   set  GECestado = 4
			 where GECid=#rsSQL.GECid_comision# 
		</cfquery>
	</cfif>

	<!--- Actualiza los Depósitos en Efectivo --->
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select CCHid, GELDreferencia
		  from GEliquidacionDepsEfectivo
		 where GELid = #Arguments.GELid#
	</cfquery>
	<cfloop query="rsSQL">
		<cfquery datasource="#session.DSN#">
			update CCHespecialMovs
			   set  CCHEMfuso	= <cf_dbfunction name="now">,
					GELid		= #Arguments.GELid#
			 where CCHid		= #rsSQL.CCHid#
			   and CCHEMtipo	= 'E'
			   and CCHEMnumero	= #rsSQL.GELDreferencia#
		</cfquery>
	</cfloop>
</cffunction>

<cffunction name="sbCalcularMonedaLiq" output="false" access="public">
	<cfargument name="GELid"		type="numeric">

	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
			inner join Empresas e on e.Ecodigo=a.Ecodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<cfset LvarTC = "case when Mcodigo = #rsLiq.McodigoLocal# then 1 else #rsLiq.GELtipoCambio# end">
	<cfquery datasource="#session.dsn#">
		update GEliquidacion
		   set GELtipoCambio = #LvarTC#
		 where GELid=#Arguments.GELid#
	</cfquery>

	<cfset LvarTC = "case when Mcodigo = #rsLiq.McodigoLocal# then 1 when Mcodigo = #rsLiq.Mcodigo# then #rsLiq.GELtipoCambio# else GELGtipoCambio end">
	<cfset LvarFC = "#LvarTC# / #rsLiq.GELtipoCambio#">
	<cfquery datasource="#session.dsn#">
		update GEliquidacionGasto
		   set GELGtotal	= round(GELGtotalOri * #LvarFC#,2)
			 , GELGmonto	= round(GELGmontoOri * #LvarFC#,2)
			 , GELGtotalRet = round(GELGtotalRetOri * #LvarFC#,2)
			 , GELGtipoCambio = #LvarTC#
		 where GELid=#Arguments.GELid#
	</cfquery>

	<cfset LvarTCdoc	= "(select GELGtipoCambio from GEliquidacionGasto where GELGid = GEliquidacionTCE.GELGid)">
	<cfset LvarFCdoc	= "#LvarTCdoc# / #rsLiq.GELtipoCambio#">
	<cfset LvarTC  		= "(select case when Mcodigo = #rsLiq.McodigoLocal# then 1 when Mcodigo = #rsLiq.Mcodigo# then #rsLiq.GELtipoCambio# else GEliquidacionTCE.GELTtipoCambio end from CuentasBancos where CBid = GEliquidacionTCE.CBid_TCE)">
	<cfset LvarFC  		= "#LvarTCdoc# /#LvarTC#">">
	<cfquery datasource="#session.dsn#">
		update GEliquidacionTCE
		   set GELTmonto	= round(GELTmontoOri * #LvarFCdoc#,2)
		     , GELTmontoTCE	= round(GELTmontoOri * #LvarFC#,2)
			 , GELTtipoCambio = #LvarTC#
		 where GELid=#Arguments.GELid#
	</cfquery>

	<cfset LvarTC = "case when Mcodigo = #rsLiq.McodigoLocal# then 1 when Mcodigo = #rsLiq.Mcodigo# then #rsLiq.GELtipoCambio# else GELDtipoCambio end">
	<cfset LvarFC = "#LvarTC# / #rsLiq.GELtipoCambio#">
	<cfquery datasource="#session.dsn#">
		update GEliquidacionDeps
		   set GELDtotal = round(GELDtotalOri * #LvarFC#,2)
			 , GELDtipoCambio = #LvarTC#
		 where GELid=#Arguments.GELid#
	</cfquery>

	<cfset LvarTC = "case when Mcodigo = #rsLiq.McodigoLocal# then 1 when Mcodigo = #rsLiq.Mcodigo# then #rsLiq.GELtipoCambio# else GELDtipoCambio end">
	<cfset LvarFC = "#LvarTC# / #rsLiq.GELtipoCambio#">
	<cfquery datasource="#session.dsn#">
		update GEliquidacionDepsEfectivo
		   set GELDtotal = round(GELDtotalOri * #LvarFC#,2)
			 , GELDtipoCambio = #LvarTC#
		 where GELid=#Arguments.GELid#
	</cfquery>
</cffunction>

<cffunction name="sbTotalesLiquidacion" output="false" access="public">
	<cfargument name="GELid"		type="numeric">
	<cfargument name="tipo" 		type="string">
	<cfargument name="cambiarTC"	default="no">

	<cfset sbCalcularMonedaLiq(Arguments.GELid)>
	
	<cfif Arguments.Tipo EQ "Gastos">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select distinct GELGnumeroDoc
			  from GEliquidacion le
				inner join GEliquidacionGasto lg
					 on lg.GELid = le.GELid
					and (lg.GELGfecha < le.GELdesde OR lg.GELGfecha > le.GELhasta)
			 where le.GELid=#Arguments.GELid#
			   and le.GECid IS NOT NULL
		</cfquery>
		<cfif rsSQL.GELGnumeroDoc NEQ "">
			<cfthrow type="toUser" message="Existen documentos con fechas que no corresponden con la Fechas Reales registradas en la Liquidación: #valueList(rsSQL.GELGnumeroDoc)#">
		</cfif>

		<cfset sbCalcularDeducibles(Arguments.GELid)>

		<cfquery datasource="#session.dsn#" name="rsTCEs">
			select GELid, GELGnumeroDoc, GELGproveedor, GELGproveedorId, totalPagado,
						coalesce(
							(
								select sum(lt.GELTmontoOri)
								  from GEliquidacionGasto lg 
									inner join GEliquidacionTCE lt
										on lt.GELGid = lg.GELGid
								 where lg.GELid			= ld.GELid 
								   and lg.GELGnumeroDoc = ld.GELGnumeroDoc 
								   and lg.GELGproveedor = ld.GELGproveedor 
								   and coalesce(lg.GELGproveedorId,'*') = coalesce(ld.GELGproveedorId,'*')
							)
						,0) as totalPagadoTCE
			from (
				select lf.GELid, lf.GELGnumeroDoc, lf.GELGproveedor, GELGproveedorId, 
						coalesce(sum(lf.GELGmontoOri - lf.GELGtotalRetOri),0) as totalPagado
				  from GEliquidacionGasto lf
				 where lf.GELid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GELid#">
				 group by lf.GELid, lf.GELGnumeroDoc, lf.GELGproveedor, GELGproveedorId
			) as ld
			where totalPagado < 
						coalesce(
							(
								select sum(lt.GELTmontoOri)
								  from GEliquidacionGasto lg 
									inner join GEliquidacionTCE lt
										on lt.GELGid = lg.GELGid
								 where lg.GELid			= ld.GELid 
								   and lg.GELGnumeroDoc = ld.GELGnumeroDoc 
								   and lg.GELGproveedor = ld.GELGproveedor 
								   and coalesce(lg.GELGproveedorId,'*') = coalesce(ld.GELGproveedorId,'*')
							)
						,0)
		</cfquery>

		<cfif rsTCEs.recordCount GT 0>
			<cfthrow message="Existen pagos con TCE mayores que montos de factura: Documento #rsTCEs.GELGnumeroDoc#, total factura=#numberformat(rsTCEs.totalPagado,",9.00")#, total TCE=#numberformat(rsTCEs.totalPagadoTCE,",9.00")#">
		</cfif>
		
		<cfquery datasource="#session.dsn#">
			update GEliquidacion 
			   set GELtotalGastos =
						coalesce(
							( select sum(GELGtotal)
								from GEliquidacionGasto
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,GELtotalDocumentos =
						coalesce(
							( select sum(round(GELGmonto,2))
								from GEliquidacionGasto
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,GELtotalRetenciones =
						coalesce(
							( select sum(GELGtotalRet)
								from GEliquidacionGasto
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,GELtotalTCE =
						coalesce(
							( select sum(GELTmonto)
								from GEliquidacionTCE
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,BMUsucodigo = #session.usucodigo#
			 where GELid=#Arguments.GELid#
		</cfquery>
	<cfelseif Arguments.Tipo EQ "Ants">
		<cfquery datasource="#session.dsn#">
			update GEliquidacion 
			   set GELtotalAnticipos =
						coalesce(
							( select sum(GELAtotal)
								from GEliquidacionAnts
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			 where GELid=#Arguments.GELid#
		</cfquery>
	<cfelseif Arguments.Tipo EQ "Deps">
		<cfquery datasource="#session.dsn#">
			update GEliquidacion 
			   set GELtotalDepositos =
						coalesce(
							( select sum(GELDtotal)
								from GEliquidacionDeps
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,BMUsucodigo = #session.usucodigo#
			 where GELid=#Arguments.GELid#
		</cfquery>
	<cfelseif Arguments.Tipo EQ "DepsE">
		<cfquery datasource="#session.dsn#">
			update GEliquidacion 
			   set GELtotalDepositosEfectivo = 
						coalesce(
							( select sum(GELDtotal)
								from GEliquidacionDepsEfectivo
							   where GELid = #Arguments.GELid#
							)
						, 0)
				  ,BMUsucodigo = #session.usucodigo#
			 where GELid=#Arguments.GELid#
		</cfquery>
	<cfelseif Arguments.Tipo EQ "LIQUIDACION">
		<cfset sbTotalesLiquidacion(Arguments.GELid, "Gastos")>
		<cfset sbTotalesLiquidacion(Arguments.GELid, "Ants")>
		<cfset sbTotalesLiquidacion(Arguments.GELid, "Deps")>
		<cfset sbTotalesLiquidacion(Arguments.GELid, "DepsE")>
	<cfelse>
		<cfthrow message="Tipo incorrecto">
	</cfif>
					  
	<cfquery name="rsTot" datasource="#session.dsn#">
		update GEliquidacion 
		   set GELtotalDocumentos 			= coalesce(round(GELtotalDocumentos, 2), 0),
			   GELtotalGastos 				= coalesce(round(GELtotalGastos, 2), 0),
			   GELtotalTCE 					= coalesce(round(GELtotalTCE, 2), 0),
			   GELtotalRetenciones 			= coalesce(round(GELtotalRetenciones, 2), 0),
			   
			   GELtotalAnticipos 			= coalesce(round(GELtotalAnticipos, 2), 0),
			   
			   GELtotalDepositos 			= coalesce(round(GELtotalDepositos, 2), 0),
			   GELtotalDepositosEfectivo	= coalesce(round(GELtotalDepositosEfectivo, 2), 0),
			   GELtotalDevoluciones 		= coalesce(round(GELtotalDevoluciones, 2), 0),
			   
			   GELreembolso 				= 0
		 where GELid=#Arguments.GELid#
	</cfquery>

	<cfquery name="rsTot" datasource="#session.dsn#">
		update GEliquidacion 
		   set GELreembolso = 
				GELtotalGastos - GELtotalAnticipos
					- GELtotalTCE			- GELtotalRetenciones
					+ GELtotalDevoluciones	+ GELtotalDepositos 	+ GELtotalDepositosEfectivo
		 where GELid=#Arguments.GELid#
		   and 	GELtotalGastos - GELtotalAnticipos 	
					- GELtotalTCE  			- GELtotalRetenciones
					+ GELtotalDevoluciones	+ GELtotalDepositos 	+ GELtotalDepositosEfectivo
				> 0	
	</cfquery>
</cffunction>

<cffunction name="sbCalcularDeducibles" access="public">
	<cfargument name="GELid" type="numeric" required="yes">
	<cfargument name="calcular" default="false">

	<!--- TODO EL IMPUESTO SE HACE DEDUCIBLE, y se eliminan los no deducibles --->
	<cfquery name="rsLiq" datasource="#session.dsn#">
		update GEliquidacionGasto
		   set GELGnoDeducMonto = 0
			 , GELGnoDeducImpuesto = 0
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>	

	<!--- Calcula IMPUESTO autorizado: proporcion de gastos autorizados contra gastos totales del mismo documento --->
	<cfset LvarImpuestoAutorizado = "
		   			coalesce(
						round(
							GELGmontoOri 
								* (select sum(GELGtotalOri) from GEliquidacionGasto s where GELid = GEliquidacionGasto.GELid and GELGnumeroDoc=GEliquidacionGasto.GELGnumeroDoc and GELGproveedor=GEliquidacionGasto.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(GEliquidacionGasto.GELGproveedorId,'*') and Icodigo is null)
								/ (select sum(GELGmontoOri) from GEliquidacionGasto s where GELid = GEliquidacionGasto.GELid and GELGnumeroDoc=GEliquidacionGasto.GELGnumeroDoc and GELGproveedor=GEliquidacionGasto.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(GEliquidacionGasto.GELGproveedorId,'*') and Icodigo is null)
						,2)
					, GELGmontoOri)
	">
	<cfquery datasource="#session.dsn#">
		update GEliquidacionGasto
		   set GELGtotalOri	= #preserveSingleQuotes(LvarImpuestoAutorizado)#
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and Icodigo IS NOT NULL
	</cfquery>

	<!--- Calcula Moneda Liquidacion de todos los detalles --->
	<cfquery datasource="#session.dsn#">
		update GEliquidacionGasto
		   set GELGtotal = round(GELGtotalOri*GELGtipoCambio/(select GELtipoCambio from GEliquidacion where GELid = GEliquidacionGasto.GELid),2)
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select GECid as GECid_comision
		  from GEliquidacion
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>	
	<cfif rsSQL.GECid_comision EQ "">
		<cfreturn>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from GEliquidacion liq
		  	inner join GEliquidacionGasto lg 	on lg.GELid = liq.GELid
			inner join GEconceptoGasto cg 		on cg.GECid = lg.GECid
		 where liq.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and cg.GECcomplemento2	is not null
	</cfquery>	
	<cfif rsSQL.cantidad EQ 0>
		<cfreturn>
	</cfif>

	<cfif 1 EQ 2>
		<!--- En Moneda Liquidacion --->
		<cfset LvarGELGmonto	= "GELGtotal">
		<cfset LvarGELGfc		= "GELtipoCambio">
	<cfelse>
		<!--- En Moneda Ori=Documento --->
		<cfset LvarGELGmonto	= "GELGtotalOri">
		<cfset LvarGELGfc		= "GELGtipoCambio">
	</cfif>
	
	<cf_dbtemp name="PDEDUC_V1" returnvariable="DEDUCIBLE" datasource="#session.DSN#">
		 <cf_dbtempcol name="GELid"					type="numeric" 	mandatory="yes">
		 <cf_dbtempcol name="GELGid"				type="numeric" 	mandatory="yes">
		 <cf_dbtempcol name="MINGid"				type="numeric" 	mandatory="yes">
		 <cf_dbtempcol name="GECid" 				type="numeric" 	mandatory="no">
		 <cf_dbtempcol name="Ecodigo"				type="integer" 	mandatory="no">
		 <cf_dbtempcol name="Icodigo"				type="char(5)" 	mandatory="no">
		 <cf_dbtempcol name="Autorizado"			type="float" 	default="0">
		 <cf_dbtempcol name="AutorizadoTOT"			type="float" 	default="0">
		 <cf_dbtempcol name="ImpuestoTOT"			type="float" 	default="0">
		 <cf_dbtempcol name="AutorizadoACUM"		type="float" 	default="0">
		 <cf_dbtempcol name="DeducibleDIAS"			type="float" 	default="0">
		 <cf_dbtempcol name="Deducible"				type="float" 	default="0">
		 <cf_dbtempcol name="NoDeducible"			type="float" 	default="0">
		 <cf_dbtempcol name="NoDeducibleTOT"		type="float" 	default="0">
		 <cf_dbtempcol name="NoDeducibleIMP"		type="float" 	default="0">
	</cf_dbtemp> 
	
	<cf_dbfunction name="datediff" 	args="l.GELdesde,l.GELhasta" returnvariable="LvarDias">
	<cfset LvarDias = "(#LvarDias# + 1)">
	<cfquery datasource="#session.dsn#">
		insert into #DEDUCIBLE# (
			GELid, GELGid, MINGid, GECid, Ecodigo, Icodigo, Autorizado, AutorizadoTOT, AutorizadoACUM, DeducibleDIAS, ImpuestoTOT
		)
		select 	lg.GELid, GELGid, 
				(select min(GELGid) from GEliquidacionGasto s where GELid = lg.GELid and GELGnumeroDoc=lg.GELGnumeroDoc and GELGproveedor=lg.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(lg.GELGproveedorId,'*')), 
				lg.GECid, lg.Ecodigo, Icodigo, 
				#LvarGELGmonto#, 
				(select sum(#LvarGELGmonto#) from GEliquidacionGasto s where GELid = lg.GELid and GELGnumeroDoc=lg.GELGnumeroDoc and GELGproveedor=lg.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(lg.GELGproveedorId,'*') and Icodigo IS NULL), 
				<!--- Autorizado Acumulado por el mismo Concepto de Gasto de cualquier factura en la misma Liquidacion --->
				(select sum(#LvarGELGmonto#) from GEliquidacionGasto s where GELid = lg.GELid and GECid = lg.GECid and GELGid<=lg.GELGid), 
				case when cg.GECcomplemento2 is not null then cg.GECmontoDeducibleDia*#preserveSingleQuotes(Lvardias)#/#LvarGELGfc# end,
				(select sum(#LvarGELGmonto#) from GEliquidacionGasto s where GELid = lg.GELid and GELGnumeroDoc=lg.GELGnumeroDoc and GELGproveedor=lg.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(lg.GELGproveedorId,'*') and Icodigo IS NOT NULL)
		  from GEliquidacionGasto lg
		  	inner join GEliquidacion l			on l.GELid = lg.GELid
			inner join GEconceptoGasto cg 		on cg.GECid = lg.GECid
		 where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		UNION
		select 	GELid, GELGid, 
				(select min(GELGid) from GEliquidacionGasto where GELid = lg.GELid and GELGnumeroDoc=lg.GELGnumeroDoc and GELGproveedor=lg.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(lg.GELGproveedorId,'*')), 
				lg.GECid, Ecodigo, Icodigo, 
				#LvarGELGmonto#, 
				(select sum(#LvarGELGmonto#) from GEliquidacionGasto s where GELid = lg.GELid and GELGnumeroDoc=lg.GELGnumeroDoc and GELGproveedor=lg.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(lg.GELGproveedorId,'*') and Icodigo IS NULL), 
				0, 
				0,
				#LvarGELGmonto#
		  from GEliquidacionGasto lg
		 where lg.GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and Icodigo is not null
		 order by 2
	</cfquery>	
	<cfquery datasource="#session.dsn#">
		update #DEDUCIBLE#
		   set 	Deducible = 
		   			case 
						when DeducibleDIAS IS NULL then Autorizado
						when AutorizadoACUM <= DeducibleDIAS then Autorizado
						when AutorizadoACUM - Autorizado <= DeducibleDIAS then Autorizado - (AutorizadoACUM - DeducibleDIAS)
						else 0
					end
		     ,	NoDeducible = 
		   			case 
						when DeducibleDIAS IS NULL then 0
						when AutorizadoACUM <= DeducibleDIAS then 0
						when AutorizadoACUM - Autorizado <= DeducibleDIAS then AutorizadoACUM - DeducibleDIAS
						else Autorizado
					end
		 where Icodigo is null
	</cfquery>	
	<cfquery datasource="#session.dsn#">
		update #DEDUCIBLE#
		   set 	NoDeducibleTOT = (select sum(NoDeducible) from #DEDUCIBLE# s where MINGid = #DEDUCIBLE#.MINGid and Icodigo IS NULL)
	</cfquery>	
	<cfquery datasource="#session.dsn#">
		update #DEDUCIBLE#
		   set 	NoDeducibleIMP =
		   			coalesce(
						case when Icodigo is not null then NoDeducibleTOT else NoDeducible end
						* ImpuestoTOT  / AutorizadoTOT
					, 0)
	</cfquery>	

	<cfquery datasource="#session.dsn#">
		update GEliquidacionGasto
		   set GELGnoDeducMonto =
					round(
						coalesce(
							case 
								when Icodigo is not null then 
									(select NoDeducibleIMP from #DEDUCIBLE# s where GELGid = GEliquidacionGasto.GELGid)
								else 
									(select NoDeducible from #DEDUCIBLE# s where GELGid = GEliquidacionGasto.GELGid)
								end
						, 0)
					, 2)
			 , GELGnoDeducImpuesto =
					round(
						coalesce(
							(select NoDeducibleIMP from #DEDUCIBLE# s where GELGid = GEliquidacionGasto.GELGid and Icodigo IS NULL)
						, 0)
					, 2)
		 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		   and (select count(1) from #DEDUCIBLE# s where GELGid = GEliquidacionGasto.GELGid) > 0
	</cfquery>	
</cffunction>

<cffunction name="Empleado_to_Beneficiario" access="public" returntype="numeric">
	<cfargument name="DEid"		type="numeric">

	<!--- TESbeneficiario.DEid : Asocia el TESbeneficiario que equivale a un empleado --->
	<cfquery name="rsBENEFICIARIO" datasource="#session.dsn#">
		select TESBid
		  from TESbeneficiario 
		 where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#Arguments.DEid#">
	</cfquery>
    
	<cfif rsBENEFICIARIO.TESBid EQ "">
		<cfquery name="rsEMPLEADO" datasource="#session.dsn#">
			select DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEtelefono1,DEemail 
			  from DatosEmpleado 
			 where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		
        <cfquery name="rsBENEFICIARIO" datasource="#session.dsn#">
        	select TESBid
              from TESbeneficiario 
             where CEcodigo			 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
               and TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMPLEADO.DEidentificacion#">
        </cfquery>
        
        <cfif rsBENEFICIARIO.TESBid NEQ "">
            <cfquery name="inserta" datasource="#session.dsn#">
                update TESbeneficiario
                   set 	DEid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
				   		TESBtipoId		= 'F',
						TESBeneficiario	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMPLEADO.DEnombre# #rsEMPLEADO.DEapellido1# #rsEMPLEADO.DEapellido2#">,
						TESBtelefono	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMPLEADO.DEtelefono1#">,
						TESBemail		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMPLEADO.DEemail#">,
						TESBactivo		= 1
                 where TESBid = #rsBENEFICIARIO.TESBid#
            </cfquery>
        <cfelse>
			<cfquery name="inserta" datasource="#session.dsn#">
				insert into TESbeneficiario (
					CEcodigo,
					TESBtipoId,
					TESBeneficiarioId,
					TESBeneficiario,
					TESBtelefono,
					TESBemail,
					TESBactivo,
					DEid,
					BMUsucodigo
				)
				values (
					<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#session.CEcodigo#">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="F">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#rsEMPLEADO.DEidentificacion#">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#rsEMPLEADO.DEnombre# #rsEMPLEADO.DEapellido1# #rsEMPLEADO.DEapellido2#"    voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#rsEMPLEADO.DEtelefono1#"  voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsEMPLEADO.DEemail#"      voidNull>,
					1,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
					#session.Usucodigo#
				)
			</cfquery>

			<cfquery name="rsBENEFICIARIO" datasource="#session.dsn#">
				select TESBid
				  from TESbeneficiario 
				 where CEcodigo			 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				   and TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMPLEADO.DEidentificacion#">
			</cfquery>
        </cfif>    
	</cfif>
	<cfreturn rsBENEFICIARIO.TESBid>
</cffunction>

<!--- Pone secuencia en todas las lineas de la Liquidacion --->
<!--- No tiene mayor transendencia más que para la impresión --->
<cffunction name="GEliquidacion_SecuenciarLineas" access="public">
	<cfargument name="GELid" type="numeric" required="yes">
	<cfset LvarLineaSec = 1>

	<!--- Anticipos --->
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select GEADid 
		  from GEliquidacionAnts
		 where GELid = #Arguments.GELid#
		 order by 1
	</cfquery>
	
	<cfloop query="rsSQL">
		<cfquery datasource="#session.dsn#">
			update GEliquidacionAnts 
			   set Linea	= #LvarLineaSec#
			 where GEADid	= #rsSQL.GEADid#
		</cfquery>
		<cfset LvarLineaSec = LvarLineaSec + 1>
	</cfloop>
	
	<!--- Gastos --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select GELGid 
		  from GEliquidacionGasto
		 where GELid = #Arguments.GELid#
		 order by 1
	</cfquery>
	
	<cfloop query="rsSQL">
		<cfquery datasource="#session.dsn#">
			update GEliquidacionGasto 
			   set Linea	= #LvarLineaSec#
			 where GELGid	= #rsSQL.GELGid#
		</cfquery>
		<cfset LvarLineaSec = LvarLineaSec + 1>
	</cfloop>
	
	<!--- Pagos por TCE --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select GELGid 
		  from GEliquidacionTCE
		 where GELid = #Arguments.GELid#
		 order by 1
	</cfquery>	
	
	<cfloop query="rsSQL">
		<cfquery datasource="#session.dsn#">
			update GEliquidacionTCE
			   set Linea	= #LvarLineaSec#
			 where GELGid	= #rsSQL.GELGid#
		</cfquery>
		<cfset LvarLineaSec = LvarLineaSec + 1>
	</cfloop>

	<!--- Depositos Bancarios --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select GELDid 
		  from GEliquidacionDeps
		 where GELid = #Arguments.GELid#
		 order by 1
	</cfquery>	
	
	<cfloop query="rsSQL">
		<cfquery datasource="#session.dsn#">
			update GEliquidacionDeps 
			   set Linea	= #LvarLineaSec#
			 where GELDid	= #rsSQL.GELDid#
		</cfquery>
		<cfset LvarLineaSec = LvarLineaSec + 1>
	</cfloop>

	<!--- Depositos en Efectivo --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select GELDEid 
		  from GEliquidacionDepsEfectivo
		 where GELid = #Arguments.GELid#
		 order by 1
	</cfquery>	
	
	<cfloop query="rsSQL">
		<cfquery datasource="#session.dsn#">
			update GEliquidacionDepsEfectivo
			   set Linea	= #LvarLineaSec#
			 where GELDEid	= #rsSQL.GELDEid#
		</cfquery>
		<cfset LvarLineaSec = LvarLineaSec + 1>
	</cfloop>
</cffunction>			


<cffunction name="sbImprimirResultadoLiquidacion" output="true" access="public" returntype="struct">
	<cfargument name="rsLiquidacion"	type="query" 	required="yes">
	<cfargument name="Custodio"			type="boolean"  default="no">

	<cfquery name="rsViaticos" datasource="#session.dsn#">
		select coalesce(sum (GELVmonto),0) as total 
			from GEliquidacionViaticos
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
	</cfquery>
	<tr>
		<td colspan="2" valign="top" align="center" nowrap="nowrap" style="font-size:6px">&nbsp;
			
		</td>			    
	</tr>
	<tr>
		<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC;border-bottom:solid 2px ##CCCCCC;">
			<strong>LIQUIDACION DE GASTOS DEL EMPLEADO EN #rsLiquidacion.Miso4217#s</strong>	
		</td>			    
	</tr>
	#sbImpSubtotalesLiq("GA","Total Viáticos",					rsViaticos.total,"",True,0)#
	<cfif rsLiquidacion.GELtotalGastos EQ rsLiquidacion.GELtotalDocumentos>
		#sbImpSubtotalesLiq("GA","Total Gastos a Liquidar",		rsLiquidacion.GELtotalGastos,"+",True,0)#
	<cfelse>
		#sbImpSubtotalesLiq("GA","Total Gastos Autorizados",	rsLiquidacion.GELtotalGastos,"+",True,2)#
		#sbImpSubtotalesLiq("GA_1","Total Documentos",			rsLiquidacion.GELtotalDocumentos)#
		#sbImpSubtotalesLiq("GA_2","Gastos No Autorizados",		rsLiquidacion.GELtotalDocumentos - rsLiquidacion.GELtotalGastos,"-")#
	</cfif>
	#sbImpSubtotalesLiq("AN","Total Anticipos a Liquidar",		rsLiquidacion.GELtotalAnticipos,"-",True,0)#
	#sbImpSubtotalesLiq("RET","Total Retenciones",				rsLiquidacion.GELtotalRetenciones,"-",True,0)#
	#sbImpSubtotalesLiq("TCE","Pagos con TCE",					rsLiquidacion.GELtotalTCE,"-",True,0)#
	#sbImpSubtotalesLiq("DE","Devoluciones",					rsLiquidacion.GELtotalDevoluciones+rsLiquidacion.GELtotalDepositos+rsLiquidacion.GELtotalDepositosEfectivo,"+",True,3)#
	#sbImpSubtotalesLiq("DE_1","Devolución a la Caja Chica",	rsLiquidacion.GELtotalDevoluciones)#
	#sbImpSubtotalesLiq("DE_2","Depósitos Bancarios",			rsLiquidacion.GELtotalDepositos)#
	#sbImpSubtotalesLiq("DE_3","Depósitos en Efectivo",			rsLiquidacion.GELtotalDepositosEfectivo)#
	<cfif rsLiquidacion.GELreembolso GT 0>
	#sbImpSubtotalesLiq("PA","PAGO ADICIONAL AL EMPLEADO",		rsLiquidacion.GELreembolso,"=",True,0)#
	</cfif>

	<cfset LvarDevoluciones = rsLiquidacion.GELtotalDepositos + rsLiquidacion.GELtotalDepositosEfectivo + rsLiquidacion.GELtotalDevoluciones>
	<cfset LvarTotal = rsLiquidacion.GELtotalGastos 
					 - rsLiquidacion.GELtotalRetenciones - rsLiquidacion.GELtotalAnticipos - rsLiquidacion.GELtotalTCE 
					 + LvarDevoluciones
					 - rsLiquidacion.GELreembolso
	>
	<cfset LvarVacia = rsLiquidacion.GELtotalGastos EQ 0 and rsLiquidacion.GELtotalAnticipos EQ 0 and LvarDevoluciones EQ 0 and rsLiquidacion.GELtotalTCE EQ 0>
	<cfif LvarVacia>
		<tr>
			<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
				<strong>LIQUIDACION VACIA</strong>
			</td>			    
		</tr>
	<cfelseif LvarTotal GT 0.001>
		#sbImpSubtotalesLiq("FA","<font color='##FF0000'>FALTANTE POR REEMBOLSAR</font>",LvarTotal,"=",True,0)#
	<cfelseif LvarTotal LT -0.001>
		#sbImpSubtotalesLiq("FA","<font color='##FF0000'>FALTANTE POR LIQUIDAR O DEVOLVER</font>",-LvarTotal,"=",True,0)#
	<cfelseif rsViaticos.total GT rsLiquidacion.GELtotalGastos>
		<!--- 
				sum (GELVmonto) as total se supone debe ser IGUAL a GELtotalGastos, 
				(es el total de viaticos real gastado)
				pero se convierte en mínimo porque puede haber facturas que corresponden 
				a gastos que no son viaticos 
		--->
		#sbImpSubtotalesLiq("FA","<font color='##FF0000'>FALTANTE DE GASTOS POR VIATICOS</font>",rsViaticos.total - rsLiquidacion.GELtotalGastos,"=",True,0)#
	<cfelse>
		<cfif rsLiquidacion.GELreembolso EQ 0>
			<tr>
				<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
					<font color='##0033FF'><strong>NO HAY PAGO ADICIONAL AL EMPLEADO</strong></font>
				</td>			    
			</tr>
		<cfelseif Arguments.Custodio>
			<tr>
				<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
					<font color='##0033FF'><strong>TOTAL PAGO EN EFECTIVO: #numberformat(rsLiquidacion.GELreembolso,",0.00")# #rsLiquidacion.Mnombre#</strong></font>
				</td>			    
			</tr>
		</cfif>
		<cfif NOT Arguments.Custodio>
		<tr>
			<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
				<font color='##0033FF'><strong>LIQUIDACION OK</strong></font>
			</td>			    
		</tr>
		</cfif>
	</cfif>
	<script language="JavaScript" type="text/JavaScript">
	function sbVerDetalle(id, n)
	{
		var LvarDsp = "*";
		for(var i=1; i<=n; i++)
			if(document.getElementById(id+"_"+i))
			{
				if (LvarDsp == "*")
				{
					LvarDsp = document.getElementById(id+"_"+i).style.display;
					if (LvarDsp == "")
					  LvarDsp = "none";
					else
					  LvarDsp = "";
				}
				document.getElementById(id+"_"+i).style.display = LvarDsp;
			}
	}
	</script>	
	<cfset LvarResult = structNew()>
	<cfset LvarResult.Vacia 		= LvarVacia>
	<cfset LvarResult.Total 		= LvarTotal>
	<cfset LvarResult.Devoluciones 	= LvarDevoluciones>
	<cfset LvarResult.rsViaticos	= rsViaticos>
	<cfreturn LvarResult>
</cffunction>

<cffunction name="sbImpSubtotalesLiq" output="true" access="private">
	<cfargument name="id">
	<cfargument name="Descripcion">
	<cfargument name="Monto">
	<cfargument name="Signo" default="+">
	<cfargument name="Principal" default="false">
	<cfargument name="N" default="0">
	
	<cfif Arguments.Monto NEQ 0>
		<cfoutput>
		<cfif Arguments.Principal>
			<tr>
				<td rowspan="1" valign="top" align="left" nowrap>
					<strong>#Arguments.Descripcion#:&nbsp;</strong>
					<img 	src="/cfmx/sif/imagenes/findsmall.gif" 
							style="cursor:pointer;<cfif Arguments.N EQ 0>visibility:hidden;</cfif>"
							onclick="sbVerDetalle('#Arguments.id#',#Arguments.N#);"
					/>
					
				</td>
				<td valign="top" align="left" nowrap>
					<span style="width:20px; text-align:center">
					#Arguments.signo#
					</span>
					<cf_inputNumber name="ff" value="#Arguments.Monto#" size="20" enteros="15" decimales="2" readonly="yes">
					&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		<cfelse>
			<tr id="#Arguments.id#" style="display:none;">
				<td rowspan="1" valign="top" align="left" nowrap>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>#Arguments.Descripcion#:&nbsp;</strong>
				</td>
				<td valign="top" align="left" nowrap>
					&nbsp;&nbsp;&nbsp;
					<span style="width:20px; text-align:center">
					#Arguments.signo#
					</span>
					<cf_inputNumber name="ff" value="#Arguments.Monto#" size="20" enteros="15" decimales="2" readonly="yes">
				</td>
			</tr>
		</cfif>
		</cfoutput>
	</cfif>
</cffunction>
</cfcomponent>



