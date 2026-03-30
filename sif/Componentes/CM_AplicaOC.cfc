<cfcomponent>

	<cffunction name="fnAplicaOC" access="public" output="no" returntype="numeric">
		<cfargument name="EOidorden" 			type="numeric">
		<cfargument name="CMCid" 				type="numeric">
        <cfargument name="TransaccionActiva" 	type="boolean" default="false">
        <cfargument name="Ecodigo" 				type="numeric" required="no">
        <cfargument name="EcodigoAlterno" 		type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

        <cfif Arguments.TransaccionActiva>
        	<cfinvoke method="fnAplicaOCPrivate" returnvariable="NAP">
            	<cfinvokeargument name="EOidorden" value="#Arguments.EOidorden#">
                <cfinvokeargument name="CMCid" value="#Arguments.CMCid#">
                <cfinvokeargument name="EcodigoAlterno" value="#Arguments.EcodigoAlterno#">
            </cfinvoke>
        <cfelse>
        	<cftransaction>
                <cfinvoke method="fnAplicaOCPrivate" returnvariable="NAP">
                    <cfinvokeargument name="EOidorden" value="#Arguments.EOidorden#">
                    <cfinvokeargument name="CMCid" value="#Arguments.CMCid#">
                    <cfinvokeargument name="EcodigoAlterno" value="#Arguments.EcodigoAlterno#">
                </cfinvoke>
            </cftransaction>
        </cfif>
        <cfreturn NAP>
     </cffunction>

     <cffunction name="fnAplicaOCPrivate" access="private" output="no" returntype="numeric">
		<cfargument name="EOidorden" 			type="numeric">
		<cfargument name="CMCid" 				type="numeric">
        <cfargument name="TransaccionActiva" 	type="boolean" default="false">
        <cfargument name="Ecodigo" 				type="numeric" required="no">
        <cfargument name="EcodigoAlterno" 		type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>

	  	<cfquery datasource="#session.dsn#" name="MonedaLocal">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.EcodigoAlterno#
		</cfquery>

		<cfset GvarMcodigoLocal = MonedaLocal.Mcodigo>

		<cfset puedeComprar = fnValidaMontoOrdenComprador(Arguments.EOidorden, Arguments.CMCid, Arguments.Ecodigo, Arguments.EcodigoAlterno)>

		<cfquery name="rsComprador" datasource="#session.DSN#">
			select CMCestado
			  from CMCompradores
			 where CMCid	= #Arguments.CMCid#
		</cfquery>

		<cfif (not puedeComprar) or (rsComprador.CMCestado eq 0)>

			<cfset fnVerificaJerarquiaComprador(Arguments.EOidorden, Arguments.CMCid, Arguments.Ecodigo, Arguments.EcodigoAlterno)>  <!--- no tiene monto autorizado para el monto de la Orden de Compra --->
		</cfif>

		<cfquery name="dataCuentaF" datasource="#session.DSN#">
			select  a.CFid, a.CMtipo, a.Aid, a.Cid, a.ACcodigo, a.ACid,a.CTDContid,
					(select SNid from SNegocios where Ecodigo = b.Ecodigo and SNcodigo = b.SNcodigo) as SNid,
					b.EOfecha as fecha, 	a.DOlinea,	a.ESidsolicitud,	a.Ecodigo,
					a.DSlinea,	a.DOconsecutivo, a.PCGDid
                    ,a.CFComplemento as actEmpresarial
			from DOrdenCM a
				inner join EOrdenCM b
					on  a.EOidorden = b.EOidorden
			where a.EOidorden = #Arguments.EOidorden#
		</cfquery>
		<!--- <cf_dump var="#dataCuentaF#"> --->
        <cfif NOT dataCuentaF.RecordCount>
        	<cfthrow message="No se encontro la Orden de Compra o la misma no posse lineas de Detalle">
        </cfif>

        <cf_cboFormaPago TESOPFPtipoId="2" TESOPFPid="#Arguments.EOidorden#" Ecodigo="#Arguments.Ecodigo#" SQL="aplicacion">

		<!----- Verifico si la OC es de un proceso de Compras y si se puede eliminar el residuo de la SC ------>
			<!---- Consulto si la OC esta ligada a un Proceso de Compras ---->
			<cfquery name="rsLineasProceso" datasource="#session.dsn#">
			Select count(1) as cantidad
            from EOrdenCM a
				inner join DOrdenCM b
			        on a.EOidorden = b.EOidorden
				inner join CMLineasProceso c
				    on c.DSlinea = b.DSlinea
			where a.EOidorden =  #Arguments.EOidorden#
			</cfquery>
			<!-----Consulto el parametro de si elimino el sobrante de la Solicitud de Compra cuando la OC es menor en cantidad------>
			<cfquery name="rsValorP" datasource="#session.dsn#">
	    	select Pvalor
				from Parametros
				where Ecodigo = #Arguments.EcodigoAlterno#
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="4300">
			</cfquery>

			<!----   Activo Plan de Compras  ---->
			<cfquery name="rsPlanCompras" datasource="#session.dsn#">
	    	select Pvalor
				from Parametros
				where Ecodigo = #Arguments.EcodigoAlterno#
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2300">
			</cfquery>

			<cfif rsLineasProceso.cantidad gt 0 and rsValorP.Pvalor eq 1 and rsPlanCompras.Pvalor eq 1>
			   <cfloop query="dataCuentaF">
			       <cfquery name="rsUpdate" datasource="#session.dsn#">
				    update DSolicitudCompraCM set DScantsurt = (select DOcantidad  from DOrdenCM do
					                                                      where do.DSlinea = DSolicitudCompraCM.DSlinea
																		   and do.EOidorden = #Arguments.EOidorden#
																		   and do.DSlinea = #dataCuentaF.DSlinea#
																		   and do.DOcantidad  > 0
																		   and do.DOcantidad < DSolicitudCompraCM.DScant)
                      where  exists ( select 1 from  DOrdenCM do
					  				  where do.DSlinea = DSolicitudCompraCM.DSlinea
										and do.EOidorden = #Arguments.EOidorden#
										and do.DSlinea = #dataCuentaF.DSlinea#
										and do.DOcantidad  > 0
										and do.DOcantidad < DSolicitudCompraCM.DScant )
				   </cfquery>

				    <cfquery name="ObtCantCancelar" datasource="#session.dsn#">
				       select  DScant - DScantsurt  as CantCancelar
					      from  DSolicitudCompraCM
						  where DSlinea = #dataCuentaF.DSlinea#
						    and DScantsurt > 0
				   </cfquery>

				   <cfif ObtCantCancelar.CantCancelar gt 0 >

						<cfinvoke component="sif.Componentes.CM_CancelaSolicitud" method="CM_CancelaLineasSolicitud"
							returnvariable="NAPcancel">
							  <cfinvokeargument name="ESidsolicitud" value="#dataCuentaF.ESidsolicitud#">
							  <cfinvokeargument name="ESjustificacion" value="Cancelacion SC x OC">
							  <cfinvokeargument name="DSlinea" value="#dataCuentaF.DSlinea#">
							  <cfinvokeargument name="DScantcancel" value = "#ObtCantCancelar.CantCancelar#">
                              <cfinvokeargument name="EcodigoAlterno" value = "#Arguments.EcodigoAlterno#">
							  <cfinvokeargument name="TransaccionActiva"	value = "true">
						</cfinvoke>
					</cfif>
					<cfquery name="rsUpdate" datasource="#session.dsn#">
				    	update DSolicitudCompraCM set DScantsurt =  DScantsurt - (select DOcantidad  from DOrdenCM do
					                                                      where do.DSlinea = DSolicitudCompraCM.DSlinea
																		   and do.EOidorden = #Arguments.EOidorden#
																		   and do.DSlinea = #dataCuentaF.DSlinea#
																		   and do.DOcantidad  > 0
																		   and do.DOcantidad <= DSolicitudCompraCM.DScant)
                      		where  exists ( select 1 from  DOrdenCM do
					  				  where do.DSlinea = DSolicitudCompraCM.DSlinea
										and do.EOidorden = #Arguments.EOidorden#
										and do.DSlinea = #dataCuentaF.DSlinea#
										and do.DOcantidad  > 0
										and do.DOcantidad <= DSolicitudCompraCM.DScant )
				   </cfquery>
				</cfloop>
			</cfif>
		<!----------------------------------------------------------------------------------------------------->


		<cfloop query="dataCuentaF">
			<cfset continuarUpdCFinanciera = true>
			<cfset LvarCuentaFinanciera = "">
			<cfset LvarFormatoCuenta = "">
				<cfif Len(Trim(dataCuentaF.DSlinea))>

					<!---
						Chequear si la solicitud está utilizando su propia cuenta financiera
						en lugar de la cuenta financiera del centro funcional
					--->

					<cfquery name="checkEspecifica" datasource="#Session.DSN#">
						select DSespecificacuenta, CFidespecifica, DSformatocuenta, CFcuenta, PCGDid
						from DSolicitudCompraCM
						where Ecodigo        = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#dataCuentaF.Ecodigo#">
						and   ESidsolicitud  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#dataCuentaF.ESidsolicitud#">
						and   DSlinea        = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#dataCuentaF.DSlinea#">
					</cfquery>

						<cfparam name="porPlanCompras" default="false">
					<cfif checkEspecifica.recordCount and LEN(TRIM(checkEspecifica.CFcuenta)) and LEN(TRIM(checkEspecifica.PCGDid))>
						<cfset porPlanCompras = true>
					<cfelseif checkEspecifica.recordCount and checkEspecifica.DSespecificacuenta EQ 1 and Len(Trim(checkEspecifica.CFidespecifica))>
						<!---
								Cuenta Financiera Específica
						--->
						<cfset LvarCuentaFinanciera = checkEspecifica.CFidespecifica>
						<cfset LvarFormatoCuenta = checkEspecifica.DSformatocuenta>

						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                            <cfinvokeargument name="Lprm_fecha" 			value="#dataCuentaF.fecha#"/>
                            <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                            <cfinvokeargument name="Lprm_Ecodigo" 			value="#dataCuentaF.Ecodigo#"/>
						</cfinvoke>

						<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
							<cftransaction action="rollback"/>
							<cf_errorCode	code = "50314"
											msg  = "@errorDat_1@ [@errorDat_2@]"
											errorDat_1="#LvarError#"
											errorDat_2="#LvarFormatoCuenta#"
							>
						<cfelse>
							<!--- trae el id de la cuenta financiera --->
							<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
								select CFcuenta
								from CFinanciera a
                                	inner join CPVigencia b
                                 		on b.CPVid = a.CPVid
								where a.Ecodigo   = #Arguments.EcodigoAlterno#
								  and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormatoCuenta#">
								  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dataCuentaF.fecha#"> between b.CPVdesde and b.CPVhasta
							</cfquery>
						</cfif>

						<cfif LvarCuentaFinanciera NEQ rsTraeCuenta.CFcuenta>
							<cfset continuarUpdCFinanciera = false>
						</cfif>

					<cfelse>
						<!--- Cuenta Financiera obtenido de la Solicitud --->
						<cfset LvarCuentaFinanciera = checkEspecifica.CFcuenta>
						<cfset LvarFormatoCuenta    = checkEspecifica.DSformatocuenta>

						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                                <cfinvokeargument name="Lprm_fecha" 			value="#dataCuentaF.fecha#"/>
                                <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                                <cfinvokeargument name="Lprm_Ecodigo" 			value="#dataCuentaF.Ecodigo#"/>
						</cfinvoke>

						<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
							<cftransaction action="rollback"/>
							<cf_errorCode	code = "50314"
											msg  = "@errorDat_1@ [@errorDat_2@]"
											errorDat_1="#LvarError#"
											errorDat_2="#LvarFormatoCuenta#"
							>
						<cfelse>
							<!--- trae el id de la cuenta financiera --->
							<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
								select CFcuenta
								from CFinanciera a
                                	inner join CPVigencia b
                                    	on b.CPVid = a.CPVid
								where a.Ecodigo   = #Arguments.EcodigoAlterno#
								  and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormatoCuenta#">
								  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dataCuentaF.fecha#"> between b.CPVdesde and b.CPVhasta
							</cfquery>
						</cfif>
						<cfif LvarCuentaFinanciera NEQ rsTraeCuenta.CFcuenta>
							<cfset continuarUpdCFinanciera = false>
						</cfif>
					</cfif>
				<!---►►Orden de Compra Manual: Hay que obtener la cuenta financiera del centro funcional◄◄--->
                <cfelse>

                	<cfif NOT LEN(TRIM(dataCuentaF.SNid))>
            			<cfset dataCuentaF.SNid = -1>
            		</cfif>
					<!--- <cf_dump var="#Arguments.EcodigoAlterno#, #dataCuentaF.CFid#, #dataCuentaF.SNid#, #dataCuentaF.CMtipo#, #dataCuentaF.Aid#, #dataCuentaF.Cid#, #dataCuentaF.ACcodigo#, #dataCuentaF.ACid#,#dataCuentaF.actEmpresarial#"> --->
					<!---►►Se sustituyen los "?" por el Objeto de gasto configurado en el Auxiliar y "_" por el complemento de la Actividad Empresarial◄◄--->
					<cfset LvarFormatoCuenta = mascara.fnComplementoItem(Arguments.EcodigoAlterno, dataCuentaF.CFid, dataCuentaF.SNid, dataCuentaF.CMtipo, dataCuentaF.Aid, dataCuentaF.Cid, dataCuentaF.ACcodigo, dataCuentaF.ACid,dataCuentaF.actEmpresarial)>

					<!--- Obtener Cuenta --->
					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                        <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                        <cfinvokeargument name="Lprm_fecha" 			value="#dataCuentaF.fecha#"/>
                        <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                        <cfinvokeargument name="Lprm_Ecodigo" 			value="#dataCuentaF.Ecodigo#"/>
					</cfinvoke>

					<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
						<cftransaction action="rollback"/>
						<cf_errorCode	code = "50314"
										msg  = "@errorDat_1@ [@errorDat_2@]"
										errorDat_1="#LvarError#"
										errorDat_2="#LvarFormatoCuenta#"
						>
					<cfelse>
						<!--- trae el id de la cuenta financiera --->
						<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
							select CFcuenta
							from CFinanciera a
                            	inner join CPVigencia b
                                	on b.CPVid = a.CPVid
							where a.Ecodigo   = #Arguments.EcodigoAlterno#
							  and a.CFformato = '#LvarFormatoCuenta#'
							  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dataCuentaF.fecha#"> between b.CPVdesde and b.CPVhasta
						</cfquery>
					</cfif>
					<cfset LvarCuentaFinanciera = rsTraeCuenta.CFcuenta>

				</cfif>

				<cfif continuarUpdCFinanciera and Len(Trim(LvarCuentaFinanciera))>
					<cfquery name="updateSolicitud" datasource="#session.DSN#">
						update DOrdenCM
						   set CFcuenta  = #LvarCuentaFinanciera#
						where  DOlinea = #dataCuentaF.DOlinea#
					</cfquery>
				<cfelseif NOT porPlanCompras>
					<cftransaction action="rollback"/>
					<cf_errorCode	code = "50315"
									msg  = "No se pudo obtener correctamente la cuenta financiera para la linea @errorDat_1@ de la orden"
									errorDat_1="#dataCuentaF.DOconsecutivo#"
					>
				</cfif>
		</cfloop>
		<!--- INTERFAZ CON PRESUPUESTO --->
		<cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>

		<cfquery name="data" datasource="#session.DSN#">
			select EOidorden, EOnumero, EOfecha, CMTOcodigo
			from EOrdenCM
			where EOidorden = #Arguments.EOidorden#
		</cfquery>
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.EcodigoAlterno#
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>

		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.EcodigoAlterno#
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>
			<cfinvoke component="sif.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion"
				Ecodigo			= "#Arguments.EcodigoAlterno#"
				tipo 			= "P"
				ID		= "#Arguments.EOidorden#"
			/>

			<cfset LvarEOidorden = Arguments.EOidorden>

			<cfif NOT esMultiperiodo()>
				<cfquery name="update" datasource="#session.DSN#">
					update EOrdenCM
					set EOestado    = 10,
						fechamod    = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        EOFechaAplica   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEOidorden#">
				</cfquery>
                <cfquery name="rsEnviaEmail" datasource="#session.DSN#">
					select case when count(1) > 0 then 1 else 0 end as Envia
                    from EOrdenCM eo
                    	inner join DOrdenCM do
                        	on do.EOidorden = eo.EOidorden
                       	inner join CMLineasProceso lp
                        	on lp.ESidsolicitud = do.ESidsolicitud  and lp.DSlinea = do.DSlinea
                      	inner join DCotizacionesCM dc
                        	on dc.DSlinea = lp.DSlinea
                    where eo.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEOidorden#">
               	</cfquery>
                <cfif rsEnviaEmail.Envia>
                	<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
                	<cfquery name="rsCotizaciones" datasource="#session.DSN#">
                        select sn.SNid, sn.SNemail, lp.DSlinea, dc.DClinea, ec.ECid, eo.CMPid, eo.CMPid,
                       		case when re.CMRseleccionado = 1 or (re.CMRsugerido = 1 and (select count(1) from CMResultadoEval sre where sre.Ecodigo = re.Ecodigo and sre.CMPid = re.CMPid and sre.DSlinea = re.DSlinea and sre.CMRseleccionado = 1) = 0) then 1 else 0 end  as Ganadora
                        from EOrdenCM eo
                            inner join DOrdenCM do
                                on do.EOidorden = eo.EOidorden
                            inner join CMLineasProceso lp
                                on lp.ESidsolicitud = do.ESidsolicitud  and lp.DSlinea = do.DSlinea  and lp.CMPid = eo.CMPid
                            inner join DCotizacionesCM dc
                                on dc.DSlinea = lp.DSlinea and dc.CMPid = lp.CMPid
                           	inner join CMResultadoEval re
                            	on re.DClinea = dc.DClinea and re.ECid = dc.ECid and re.CMPid = dc.CMPid and re.DSlinea = dc.DSlinea
                            inner join ECotizacionesCM ec
                            	on ec.ECid = dc.ECid
                           	inner join SNegocios sn
                            	on sn.SNcodigo = ec.SNcodigo and sn.Ecodigo = ec.Ecodigo
                        where eo.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEOidorden#">
                    </cfquery>

                    <cfquery name="rsSocios" dbtype="query">
                        select distinct SNid, SNemail from rsCotizaciones
                    </cfquery>
					<cfloop query="rsSocios">
                    	<cfif len(trim(rsSocios.SNemail)) gt 0>

                            <cfquery name="rsDetalles" dbtype="query">
                                select DSlinea, DClinea, ECid, CMPid, Ganadora
                                from rsCotizaciones
                                where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
                                order by Ganadora, ECid
                            </cfquery>
                            <cfset _mailBody = fnMailBody(rsSocios.SNid, rsCotizaciones.CMPid, rsDetalles)>
                            <cfquery datasource="#session.dsn#">
                                insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                                values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                                         <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsSocios.SNemail#">,
                                         'Estado de Cotizaciones para Orden de Compra',
                                         <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                            </cfquery>
                      	</cfif>
                    </cfloop>
                </cfif>
			</cfif>
            <cfquery name="rsDatosEO" datasource="#session.dsn#">
			select
					'CMOC',
					<cf_dbfunction name="to_char" args="b.EOnumero" >,
					b.CMTOcodigo,
					b.EOfecha,
					#rsPeriodoAuxiliar.Pvalor#,
					#rsMesAuxiliar.Pvalor#,
					a.DOconsecutivo,
					a.CFcuenta,
					c.Ocodigo,
					d.Oficodigo,
					b.Mcodigo,
						round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
					as MtoOrigen,
					b.EOtc,  <!---TipoCambio--->
					round(
						round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						* b.EOtc
					, 2) as Monto,
					'CC', <!---TipoMovimiento--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
					a.PCGDid, a.DOcantidad
				from DOrdenCM a
					inner join EOrdenCM b
					on b.EOidorden = a.EOidorden

					inner join CFuncional c
					on c.CFid = a.CFid

					inner join Oficinas d
					on d.Ocodigo = c.Ocodigo
					and d.Ecodigo = c.Ecodigo

					inner join Impuestos e
					on e.Icodigo = a.Icodigo
					and e.Ecodigo = a.Ecodigo

				where a.EOidorden =  #LvarEOidorden#
			</cfquery>

			<!---
				Proceso de Control de Presupuesto para Compras:
					Reserva,Compromete y Ejecuta a la misma cuenta que viene arrastrada desde la SC:
					Cuenta Especificada o
						Artículo de Inventario:	Centro Funcional Cuenta de Inventario	+ Clasificación Artículo
						Activos Fijos:			Centro Funcional Cuenta de Inversión	+ Tipo Concepto Servicio
						Servicios:				Centro Funcional Cuenta de Gasto		+ Categoria y Clasificación del Activo
						(Servicios se debe Ejecutar la cuenta de la factura)
					Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario:
						Parámetro 548 = 0: Controla el Consumo del Artículo y se hace una Compra de Inventario sin Consumo (SC sin Requisición)
						Parámetro 548 = 1: Controla la Compra  del Artículo y se hace una Compra de Inventario con Requisición y se genera un Consumo y no una Compra (SC con Requisición sin proceso de compra)
			--->
			<cfset SIN_REQUISICION			= "(select sc.TRcodigo from ESolicitudCompraCM sc where sc.ESidsolicitud = a.ESidsolicitud) is NULL">
			<cfset CON_REQUISICION 			= "(select sc.TRcodigo from ESolicitudCompraCM sc where sc.ESidsolicitud = a.ESidsolicitud) is NOT NULL">
			<cfset CON_REQUISICION_AL_GASTO	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 1 where sc.ESidsolicitud = a.ESidsolicitud) is NOT NULL">
			<cfset CON_REQUISICION_ALMACEN	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 2 where sc.ESidsolicitud = a.ESidsolicitud) is NOT NULL">

			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor
				  from Parametros
				 where Ecodigo	= #Arguments.EcodigoAlterno#
				   and Pcodigo	= 548
			</cfquery>
			<cfset LvarCPconsumoInventario = rsSQL.Pvalor NEQ 1>
			<cfset LvarCPcomprasInventario = NOT LvarCPconsumoInventario>

			<cfquery name="rsPreComp" datasource="#session.dsn#">
				select Pvalor from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 1390
			</cfquery>

            <!---  Genera el  Precompromiso  cuando  la Orden  de Compra no es Directa Momentos = 1 --->
            <!--- Valida si viene de una SC --->
            <cfquery name="rsOCD" datasource="#session.DSN#">
            	select COUNT(1) reg from EOrdenCM eoc
				inner join DOrdenCM doc on doc.EOidorden=eoc.EOidorden
				inner join DSolicitudCompraCM dsc on dsc.ESidsolicitud = doc.ESidsolicitud
				where eoc.EOidorden = #LvarEOidorden#
                and eoc.Ecodigo = #session.Ecodigo#
            </cfquery>

            <cfset Momentos=0>
            <cfif rsOCD.reg GT 0>
               <cfset Momentos=1>
            </cfif>

            <!--- Valida si viene de una Suficiencia --->
            <cfquery name="rsOCD1" datasource="#session.dsn#">
            	select COUNT(1) as reg from EOrdenCM eoc inner join DOrdenCM doc on doc.EOidorden=eoc.EOidorden
				inner join CPDocumentoD ds on ds.CPDDid = doc.CPDDid
				where eoc.EOidorden = #LvarEOidorden#
                and eoc.Ecodigo = #session.Ecodigo#
            </cfquery>
            <cfif rsOCD1.reg GT 0>
               <cfset Momentos=1>
            </cfif>


<!----JMRV. inicio--->

		<!--- Compromiso de la OC --->

		<!---- Inserta las lineas que no son articulos o que son articulos sin discribucion --->
			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CFcuenta,
					Ocodigo,
					CodigoOficina,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,
					PCGDid,
					PCGDcantidad)
				select
					'CMOC',
					<cf_dbfunction name="to_char" args="b.EOnumero" >,
					b.CMTOcodigo,
					b.EOfecha,
					#rsPeriodoAuxiliar.Pvalor#,
					#rsMesAuxiliar.Pvalor#,
					a.DOconsecutivo,
					a.CFcuenta,
					c.Ocodigo,
					d.Oficodigo,
					b.Mcodigo,
						case
						<!--- Cuando viene de una SC --->
						when a.ESidsolicitud is not null then
										case
											<!--- Cuando SC < OC entonces se hace un CC por el monto en la SC--->
											when a.DOtotal > (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea)
												then round( (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea) - a.DOmontodesc + a.DOimpuestoCosto, 2)
											else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
										end
						else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						end
					as MtoOrigen,
					b.EOtc,  <!---TipoCambio--->
					round(
						case
						when a.ESidsolicitud is not null then
										case
											when a.DOtotal > (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea)
												then round( (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea) - a.DOmontodesc + a.DOimpuestoCosto, 2)
											else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
										end
						else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						end
						* b.EOtc
					, 2) as Monto,
					'CC', <!---TipoMovimiento--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
					a.PCGDid,
					a.DOcantidad

				from DOrdenCM a
					inner join EOrdenCM b
					on b.EOidorden = a.EOidorden

					inner join CFuncional c
					on c.CFid = a.CFid

					inner join Oficinas d
					on d.Ocodigo = c.Ocodigo
					and d.Ecodigo = c.Ecodigo

					inner join Impuestos e
					on e.Icodigo = a.Icodigo
					and e.Ecodigo = a.Ecodigo

				where a.EOidorden =  #LvarEOidorden#
					and (a.CMtipo <> 'A'
						or (a.CMtipo = 'A' and ( a.CPDCid is null or a.CPDCid < 1)))
					<!--- and a.CPDCid =
							case
								when a.CMtipo = 'A' and a.CPDCid is not null then 0
								else a.CPDCid
							end --->
				<!--- MSEG excluyendo las lineas de contratos --->
					and a.CTDContid is null
				<!--- MSEG --->
				<!--- No se Controla Presupuesto si Parámetro Control Presupuesto para Compras de Inventario es para CONSUMO y la compra no es para consumo, o sea la SC es SIN Requisición --->
				<cfif LvarCPconsumoInventario>
				  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>


		<!---- Trae las lineas que son articulos con discribucion --->
			<cfquery name="rsLineasConDistribucion" datasource="#session.DSN#">
				select
					'CMOC' as ModuloOrigen,
					<cf_dbfunction name="to_char" args="b.EOnumero" > as NumeroDocumento,
					b.CMTOcodigo as NumeroReferencia,
					b.EOfecha as FechaDocumento,
					#rsPeriodoAuxiliar.Pvalor# as AnoDocumento,
					#rsMesAuxiliar.Pvalor# as MesDocumento,
					a.DOconsecutivo,
					c.Ocodigo as Ocodigo,
					d.Oficodigo as CodigoOficina,
					b.Mcodigo as Mcodigo,
					round(
						case
						when a.ESidsolicitud is not null then
										case
											when a.DOtotal > (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea)
												then round( (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea) - a.DOmontodesc + a.DOimpuestoCosto, 2)
											else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
										end
						else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						end
						* b.EOtc
					, 2) as Monto,
					'CC' as TipoMovimiento,
					a.PCGDid,
					a.DOcantidad as cant,
					a.DOmontodesc as LineaDeDescuento,
					a.Aid,
					a.CMtipo as Tipoitem,
					a.CPDCid,
					a.DOlinea,
					a.CTDContid,
					case
						when a.ESidsolicitud is not null then a.ESidsolicitud
						else 0
					end as ESidsolicitud,
					case
						when a.ESidsolicitud is not null then (select DScant from DSolicitudCompraCM where DSlinea = a.DSlinea)
						else 0
					end as DScant,
					case
						when a.ESidsolicitud is not null then (select DScantsurt from DSolicitudCompraCM where DSlinea = a.DSlinea)
						else 0
					end as DScantsurt,
					case
						when a.ESidsolicitud is not null then (select NAP from ESolicitudCompraCM where ESidsolicitud = a.ESidsolicitud)
						else 0
					end as CPNAPnum,
					case
						when a.ESidsolicitud is not null then (select DSconsecutivo from DSolicitudCompraCM where DSlinea = a.DSlinea)
						else 0
					end as DSconsecutivo

				from DOrdenCM a
					inner join EOrdenCM b
					on b.EOidorden = a.EOidorden

					inner join CFuncional c
					on c.CFid = a.CFid

					inner join Oficinas d
					on d.Ocodigo = c.Ocodigo
					and d.Ecodigo = c.Ecodigo

					inner join Impuestos e
					on e.Icodigo = a.Icodigo
					and e.Ecodigo = a.Ecodigo

				where a.EOidorden =  #LvarEOidorden#
				and a.CMtipo = 'A'
				and (a.CPDCid is not null and a.CPDCid > 0)
				<cfif LvarCPconsumoInventario>
				  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>


	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">

		<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion"
				method="GenerarDistribucion"
				Cid="0"
 				Aid="#rsLineasConDistribucion.Aid#"
				CPDCid="#rsLineasConDistribucion.CPDCid#"
		  		Tipo="#rsLineasConDistribucion.Tipoitem#"
		        Aplica="1"
				cantidad="#rsLineasConDistribucion.cant#"
				monto="#rsLineasConDistribucion.Monto#"
				descuento="#rsLineasConDistribucion.LineaDeDescuento#"
			returnVariable="rsDistribucion">

		<!--- Almacena la distribucion de linea en la tabla --->
			<cfloop query="rsDistribucion">
				<cfinvoke
				component="sif.Componentes.PRES_Distribucion"
				method="insertaDistribucionOC"
				DOlinea="#rsLineasConDistribucion.DOlinea#"
				NumeroLineaReferencia="#rsLineasConDistribucion.DOconsecutivo#"
				TipoMovimiento="#rsLineasConDistribucion.TipoMovimiento#"
				LineaDistribucion="#rsDistribucion.NumLineaDistribucion#"
				CFid="#rsDistribucion.CFid#"
				rsDistribucionCuenta="#rsDistribucion.cuenta#">
			</cfloop>

			<!--- no se genera movimiento presupuestal para las lineas que vienen de contratos --->
			<cfif rsLineasConDistribucion.CTDContid EQ ''>
				<!--- Inserta cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

						<cfquery name="rs" datasource="#session.DSN#">
							insert into #request.intPresupuesto#(
								ModuloOrigen,
								NumeroDocumento,
								NumeroReferencia,
								FechaDocumento,
								AnoDocumento,
								MesDocumento,
								NumeroLinea,
								CFcuenta,
								Ocodigo,
								CodigoOficina,
								Mcodigo,
								MontoOrigen,
								TipoCambio,
								Monto,
								TipoMovimiento,
								NAPreferencia,
								LINreferencia,
								PCGDid,
								PCGDcantidad)

					values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
							    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
								#rsLineasConDistribucion.AnoDocumento#,
								#rsLineasConDistribucion.MesDocumento#,
								(#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#,
								(select CFcuenta from CFinanciera
	   							 where CFformato = '#rsDistribucion.cuenta#'),
								#rsLineasConDistribucion.Ocodigo#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
								#rsLineasConDistribucion.Mcodigo#,
								case
									when #rsLineasConDistribucion.ESidsolicitud# <> 0 then
										case
											when #rsLineasConDistribucion.DScant# = #rsLineasConDistribucion.DScantsurt# + #rsDistribucion.cantidad# and #rsLineasConDistribucion.DScantsurt# <> 0
													then (select (CPNAPDmonto - CPNAPDutilizado) from CPNAPdetalle where CPNAPnum = #rsLineasConDistribucion.CPNAPnum# and CPNAPDlinea = (#rsLineasConDistribucion.DSconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#)
											else #rsDistribucion.Monto#
										end
									else #rsDistribucion.Monto#
								end,
								1,
								case
									when #rsLineasConDistribucion.ESidsolicitud# <> 0 then
										case
											when #rsLineasConDistribucion.DScant# = #rsLineasConDistribucion.DScantsurt# + #rsDistribucion.cantidad# and #rsLineasConDistribucion.DScantsurt# <> 0
													then (select (CPNAPDmonto - CPNAPDutilizado) from CPNAPdetalle where CPNAPnum = #rsLineasConDistribucion.CPNAPnum# and CPNAPDlinea = (#rsLineasConDistribucion.DSconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#)
											else #rsDistribucion.Monto#
										end
									else #rsDistribucion.Monto#
								end,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
								<cfif rsLineasConDistribucion.PCGDid eq "">
									null,
								<cfelse>
									#rsLineasConDistribucion.PCGDid#,
								</cfif>
								#rsDistribucion.cantidad#
							)
						</cfquery>
					</cfloop> <!--- rsDistribucion --->
			</cfif>
		</cfloop> <!--- rsLineasConDistribucion --->




		<!--- Compromiso para las lineas que vienen de una SC y se cumple que SC < OC
				el compromiso que se genera a continuacion es de (OC - SC) --->

		<!---- Para las lineas que no son articulos o que son articulos sin discribucion --->
			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CFcuenta,
					Ocodigo,
					CodigoOficina,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,
					PCGDid,
					PCGDcantidad)
				select
					'CMOC',
					<cf_dbfunction name="to_char" args="b.EOnumero" >,
					b.CMTOcodigo,
					b.EOfecha,
					#rsPeriodoAuxiliar.Pvalor#,
					#rsMesAuxiliar.Pvalor#,
					9000 + a.DOconsecutivo,
					a.CFcuenta,
					c.Ocodigo,
					d.Oficodigo,
					b.Mcodigo,
						round(
						a.DOtotal
						- (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea), 2)
					as MtoOrigen,
					b.EOtc,  <!---TipoCambio--->
					round(
						round(
						a.DOtotal
						- (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea), 2)
						* b.EOtc
					, 2) as Monto,
					'CC', <!---TipoMovimiento--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
					a.PCGDid,
					a.DOcantidad

				from DOrdenCM a
					inner join EOrdenCM b
					on b.EOidorden = a.EOidorden

					inner join CFuncional c
					on c.CFid = a.CFid

					inner join Oficinas d
					on d.Ocodigo = c.Ocodigo
					and d.Ecodigo = c.Ecodigo

					inner join Impuestos e
					on e.Icodigo = a.Icodigo
					and e.Ecodigo = a.Ecodigo

				where a.EOidorden =  #LvarEOidorden#

				<!--- Condiciones para que venga de una SC y que SC < OC --->
				and a.ESidsolicitud is not null
				and a.DSlinea is not null
				and a.DOtotal > (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea)

				<!--- Condicion para que sean lineas que no son articulos o que sean articulos sin distribucion --->
				and (a.CMtipo <> 'A'
						or (a.CMtipo = 'A' and ( a.CPDCid is null or a.CPDCid < 1)))
				<!--- and a.CPDCid =
							case
								when a.CMtipo = 'A' and a.CPDCid is not null then 0
								else a.CPDCid
							end --->

				<!--- No se Controla Presupuesto si Parámetro Control Presupuesto para Compras de Inventario es para CONSUMO y la compra no es para consumo, o sea la SC es SIN Requisición --->
				<cfif LvarCPconsumoInventario>
				  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>




		<!---- Para las lineas que son articulos con discribucion --->
			<cfquery name="rsLineasConDistribucion" datasource="#session.DSN#">
				select
					'CMOC' as ModuloOrigen,
					<cf_dbfunction name="to_char" args="b.EOnumero" > as NumeroDocumento,
					b.CMTOcodigo as NumeroReferencia,
					b.EOfecha as FechaDocumento,
					#rsPeriodoAuxiliar.Pvalor# as AnoDocumento,
					#rsMesAuxiliar.Pvalor# as MesDocumento,
					9000 + a.DOconsecutivo as DOconsecutivo,
					c.Ocodigo as Ocodigo,
					d.Oficodigo as CodigoOficina,
					b.Mcodigo as Mcodigo,
					round(
						round(
						a.DOtotal
						- (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea), 2)
						* b.EOtc
					, 2) as Monto,
					'CC' as TipoMovimiento,
					a.PCGDid,
					a.DOcantidad as cant,
					a.DOmontodesc as LineaDeDescuento,
					a.Aid,
					a.CMtipo as Tipoitem,
					a.CPDCid,
					a.DOlinea

				from DOrdenCM a
					inner join EOrdenCM b
					on b.EOidorden = a.EOidorden

					inner join CFuncional c
					on c.CFid = a.CFid

					inner join Oficinas d
					on d.Ocodigo = c.Ocodigo
					and d.Ecodigo = c.Ecodigo

					inner join Impuestos e
					on e.Icodigo = a.Icodigo
					and e.Ecodigo = a.Ecodigo

				where a.EOidorden =  #LvarEOidorden#
				and a.ESidsolicitud is not null
				and a.DSlinea is not null
				and a.DOtotal > (select DStotallinest from DSolicitudCompraCM where ESidsolicitud = a.ESidsolicitud and DSlinea = a.DSlinea)

				<!--- Condicion para que sean articulos con distribucion --->
				and a.CMtipo = 'A'
				and (a.CPDCid is not null
					 and
					 a.CPDCid <> 0)

				<cfif LvarCPconsumoInventario>
				  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>



	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">

		<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion"
				method="GenerarDistribucion"
				Cid="0"
 				Aid="#rsLineasConDistribucion.Aid#"
				CPDCid="#rsLineasConDistribucion.CPDCid#"
		  		Tipo="#rsLineasConDistribucion.Tipoitem#"
		        Aplica="1"
				cantidad="#rsLineasConDistribucion.cant#"
				monto="#rsLineasConDistribucion.Monto#"
				descuento="#rsLineasConDistribucion.LineaDeDescuento#"
			returnVariable="rsDistribucion">

		<!--- Almacena la distribucion de linea en la tabla --->
			<cfloop query="rsDistribucion">
				<cfinvoke
				component="sif.Componentes.PRES_Distribucion"
				method="insertaDistribucionOC"
				DOlinea="#rsLineasConDistribucion.DOlinea#"
				NumeroLineaReferencia="#rsLineasConDistribucion.DOconsecutivo#"
				TipoMovimiento="#rsLineasConDistribucion.TipoMovimiento#"
				LineaDistribucion="#rsDistribucion.NumLineaDistribucion#"
				CFid="#rsDistribucion.CFid#"
				rsDistribucionCuenta="#rsDistribucion.cuenta#">
			</cfloop>


		<!--- Inserta cada linea de la distribucion --->
			<cfloop query="rsDistribucion">

					<cfquery name="rs" datasource="#session.DSN#">
						insert into #request.intPresupuesto#(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							NumeroLinea,
							CFcuenta,
							Ocodigo,
							CodigoOficina,
							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,
							TipoMovimiento,
							NAPreferencia,
							LINreferencia,
							PCGDid,
							PCGDcantidad)

				values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
						    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
							#rsLineasConDistribucion.AnoDocumento#,
							#rsLineasConDistribucion.MesDocumento#,
							(#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#,
							(select CFcuenta from CFinanciera
   							 where CFformato = '#rsDistribucion.cuenta#'),
							#rsLineasConDistribucion.Ocodigo#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
							#rsLineasConDistribucion.Mcodigo#,
							#rsDistribucion.Monto#,
							1,
							#rsDistribucion.Monto#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
							<cfif rsLineasConDistribucion.PCGDid eq "">
								null,
							<cfelse>
								#rsLineasConDistribucion.PCGDid#,
							</cfif>
							#rsDistribucion.cantidad#
						)
				</cfquery>
			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->



			<cfif Momentos EQ 1>
            <!---
			Cuando el Monto de la OC es mayor al  Monto  de la SC
			1.- Genera el Precompromiso  de la diferencia entre la OC y la SC
			2.- Genera el Compromiso del Monto de la OC
			--->
			<cfif rsPreComp.Pvalor NEQ "S">

			<!---- Para las lineas que no son articulos o que son articulos pero sin discribucion --->
				<cfquery name="insPRCO" datasource="#session.DSN#">
					insert into #request.intPresupuesto#(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						NumeroLinea,
						CFcuenta,
						Ocodigo,
						CodigoOficina,
						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,
						TipoMovimiento,
						NAPreferencia,
						LINreferencia,
						PCGDid,
						PCGDcantidad)
					select
						'CMOC',
						<cf_dbfunction name="to_char" args="b.EOnumero" >,
						b.CMTOcodigo,
						b.EOfecha,
						#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
						- a.DOconsecutivo +( 1000000 * b.EOnumero),
						a.CFcuenta,
						c.Ocodigo,
						d.Oficodigo,
						b.Mcodigo,
                	    case
						when a.DOtotal > g.DStotallinest
                        	then   a.DOtotal -  g.DStotallinest
            	            else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2 )end
						as MtoOrigen,
						b.EOtc,  <!---TipoCambio--->
						case
						when a.DOtotal > g.DStotallinest
							then   round((a.DOtotal -  g.DStotallinest) * b.EOtc,2)
                    		else round(round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * b.EOtc, 2) end as Monto,
						'RC', <!---TipoMovimiento--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
						a.PCGDid,
						a.DOcantidad

					from DOrdenCM a
						inner join EOrdenCM b
						on b.EOidorden = a.EOidorden

            	        inner join DSolicitudCompraCM g
        	            on g.ESidsolicitud = a.ESidsolicitud
						and g.DSconsecutivo = a.DOconsecutivo

    	                inner join CFuncional c
						on c.CFid = a.CFid

						inner join Oficinas d
						on d.Ocodigo = c.Ocodigo
						and d.Ecodigo = c.Ecodigo

						inner join Impuestos e
						on e.Icodigo = a.Icodigo
						and e.Ecodigo = a.Ecodigo

					where a.EOidorden =  #LvarEOidorden#
	                and a.DOtotal > g.DStotallinest
	                and (a.CMtipo <> 'A'
						or (a.CMtipo = 'A' and ( a.CPDCid is null or a.CPDCid < 1)))
	                <!--- and a.CPDCid =
							case
								when a.CMtipo = 'A' and a.CPDCid is not null then 0
								else a.CPDCid
							end --->

					<!--- No se Controla Presupuesto si Parámetro Control Presupuesto para Compras de Inventario es para CONSUMO y la compra no es para consumo, o sea la SC es SIN Requisición --->
					<cfif LvarCPconsumoInventario>
					  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
					</cfif>
				</cfquery>


		<!---- Trae las lineas que son articulos con discribucion --->
			<cfquery name="rsLineasConDistribucion" datasource="#session.DSN#">
					select
						'CMOC' as ModuloOrigen,
						<cf_dbfunction name="to_char" args="b.EOnumero" > as NumeroDocumento,
						b.CMTOcodigo as NumeroReferencia,
						b.EOfecha as FechaDocumento,
						#rsPeriodoAuxiliar.Pvalor# as AnoDocumento,
						#rsMesAuxiliar.Pvalor# as MesDocumento,
						- a.DOconsecutivo + ( 1000000 * b.EOnumero) as DOconsecutivo,
						c.Ocodigo as Ocodigo,
						d.Oficodigo as CodigoOficina,
						b.Mcodigo as Mcodigo,
                	    case
						when a.DOtotal > g.DStotallinest
                        	then   a.DOtotal -  g.DStotallinest
            	            else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2 )end
						as MontoOrigen,
						b.EOtc as TipoCambio,
						case
						when a.DOtotal > g.DStotallinest
								then   round((a.DOtotal -  g.DStotallinest) * b.EOtc,2)
                    		    else round(round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * b.EOtc, 2) end as Monto,
						'RC' as TipoMovimiento,
						a.PCGDid,
						a.DOcantidad as cant,
						a.DOmontodesc as LineaDeDescuento,
						a.Aid,
						a.CMtipo as Tipoitem,
						a.CPDCid,
						a.DOlinea

					from DOrdenCM a
						inner join EOrdenCM b
						on b.EOidorden = a.EOidorden

            	        inner join DSolicitudCompraCM g
        	            on g.ESidsolicitud = a.ESidsolicitud
						and g.DSconsecutivo = a.DOconsecutivo

    	                inner join CFuncional c
						on c.CFid = a.CFid

						inner join Oficinas d
						on d.Ocodigo = c.Ocodigo
						and d.Ecodigo = c.Ecodigo

						inner join Impuestos e
						on e.Icodigo = a.Icodigo
						and e.Ecodigo = a.Ecodigo

					where a.EOidorden =  #LvarEOidorden#
	                and a.DOtotal > g.DStotallinest

	                and a.CMtipo = 'A'
					and (a.CPDCid is not null
					 	 and
					 	 a.CPDCid <> 0)

					<!--- No se Controla Presupuesto si Parámetro Control Presupuesto para Compras de Inventario es para CONSUMO y la compra no es para consumo, o sea la SC es SIN Requisición --->
					<cfif LvarCPconsumoInventario>
					  and NOT (a.CMtipo = 'A' AND #SIN_REQUISICION#)
					</cfif>
				</cfquery>


	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">

			<!--- Obtiene la distribucion --->
				<cfinvoke component="sif.Componentes.PRES_Distribucion"
						method="GenerarDistribucion"
						Cid="0"
		 				Aid="#rsLineasConDistribucion.Aid#"
						CPDCid="#rsLineasConDistribucion.CPDCid#"
				  		Tipo="#rsLineasConDistribucion.Tipoitem#"
				        	Aplica="1"
						cantidad="#rsLineasConDistribucion.cant#"
						monto="#rsLineasConDistribucion.Monto#"
						descuento="0"
					returnVariable="rsDistribucion">


			<!--- Inserta cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

					<cfquery name="rs" datasource="#session.DSN#">
						insert into #request.intPresupuesto#(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							NumeroLinea,
							CFcuenta,
							Ocodigo,
							CodigoOficina,
							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,
							TipoMovimiento,
							NAPreferencia,
							LINreferencia,
							PCGDid,
							PCGDcantidad)

				values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
						    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
							#rsLineasConDistribucion.AnoDocumento#,
							#rsLineasConDistribucion.MesDocumento#,
							(#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#,
							(select CFcuenta from CFinanciera
   							 where CFformato = '#rsDistribucion.cuenta#'),
							#rsLineasConDistribucion.Ocodigo#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
							#rsLineasConDistribucion.Mcodigo#,
							#rsDistribucion.Monto#,
							1,
							#rsDistribucion.Monto#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,    <!---LINreferencia--->
							<cfif rsLineasConDistribucion.PCGDid eq "">
								null,
							<cfelse>
								#rsLineasConDistribucion.PCGDid#,
							</cfif>
							#rsDistribucion.cantidad#
						)
				</cfquery>

			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->

 </cfif><!--- Precompromiso --->


		<!--- DesReserva de la OC referenciando a la SC --->

			<!---- Para las lineas que no son articulos o que son articulos pero sin discribucion --->
				<cfquery name="rs" datasource="#session.DSN#">
					insert into #request.intPresupuesto#(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						NumeroLinea,
						CFcuenta,
						Ocodigo,
						CodigoOficina,
						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,
						TipoMovimiento,
						NAPreferencia,
						LINreferencia,
						PCGDid,
                	    PCGDcantidad)
					select
						'CMOC',
						<cf_dbfunction name="to_char" args="b.EOnumero" >,
						b.CMTOcodigo,
						b.EOfecha,
						#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
						-(a.DOconsecutivo),
						<!--- Proporción ordenada OC con respecto a la cantidad SC original: --->
							<!--- Prop. Cant. ordenada:   CANTIDAD_ORDENADA / CANTIDAD_ORIGINAL --->
							<!--- CANTIDAD_ORDENADA =     a.DOcantidad --->
							<!--- CANTIDAD_ORIGINAL =     a.DScantidadNAP --->
							<!--- Prop. Cant. ordenada:   (a.DOcantidad) / a.DScantidadNAP --->
							<!---
									Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto)
									porque en algunos lugares se recalculaMontos:
										DStotallinest = round(DScant * DSmontoest,2)
									El máximo a DesReservar es el Monto No Utilizado de la Reserva
							--->
						napSC.CFcuenta,
						napSC.Ocodigo,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						napSC.Mcodigo,
						-case
							<!--- Cuando no se controla cantidad en PCG se DesReserva el 100% --->
							when DScontrolCantidad = 0 then
								napSC.CPNAPDmontoOri
							<!--- Se pregunta en moneda local (CPNAPDmonto) porque CPNAPDutilizado sólo está en moneda local --->
							when napSC.CPNAPDmonto-napSC.CPNAPDutilizado < napSC.CPNAPDmonto * a.DOcantidad / g.DScantidadNAP then
								round((napSC.CPNAPDmonto-napSC.CPNAPDutilizado) / napSC.CPNAPDtipoCambio,2)
   	                    	when a.DOtotal < napSC.CPNAPDmontoOri and a.DOcantidad = g.DScantidadNAP
                            	then   napSC.CPNAPDmontoOri
						else
								round( napSC.CPNAPDmontoOri * a.DOcantidad / g.DScantidadNAP,2)
						end,
						napSC.CPNAPDtipoCambio,

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							-case
								when DScontrolCantidad = 0 then
									napSC.CPNAPDmontoOri
								when napSC.CPNAPDmonto-napSC.CPNAPDutilizado < napSC.CPNAPDmonto * a.DOcantidad / g.DScantidadNAP then
									round((napSC.CPNAPDmonto-napSC.CPNAPDutilizado) / napSC.CPNAPDtipoCambio,2)
   	                         	when a.DOtotal < napSC.CPNAPDmontoOri and a.DOcantidad = g.DScantidadNAP then
                                	napSC.CPNAPDmontoOri
								else
									round( napSC.CPNAPDmontoOri * a.DOcantidad / g.DScantidadNAP,2)

							end
						*napSC.CPNAPDtipoCambio, 2),
						'RC',
						f.NAP,
						g.DSconsecutivo,
						a.PCGDid,
						-a.DOcantidad

					from DOrdenCM a
						inner join EOrdenCM b
						 on b.EOidorden = a.EOidorden

						inner join ESolicitudCompraCM f
						 on f.ESidsolicitud = a.ESidsolicitud

						inner join DSolicitudCompraCM g
						 on g.ESidsolicitud = a.ESidsolicitud
						and g.DSlinea = a.DSlinea

						inner join CPNAPdetalle napSC
						 on napSC.Ecodigo		= f.Ecodigo
						and napSC.CPNAPnum		= f.NAP
						and napSC.CPNAPDlinea	= g.DSconsecutivo

					where b.EOidorden = #LvarEOidorden#
					 and (a.CMtipo <> 'A'
						or (a.CMtipo = 'A' and ( a.CPDCid is null or a.CPDCid < 1)))
					 <!--- and a.CPDCid =
							case
								when a.CMtipo = 'A' and a.CPDCid is not null then 0
								else a.CPDCid
							end --->
   	                <!---and a.DOtotal < napSC.CPNAPDmonto--->
				</cfquery>



	<!---- Para las lineas son articulos con distribucion --->

			<!---- Encontramos cada una de las lineas --->
				<cfquery name="rsLineasConDistribucion" datasource="#session.DSN#">
					select
						'CMOC' as ModuloOrigen,
						<cf_dbfunction name="to_char" args="b.EOnumero" > as NumeroDocumento,
						b.CMTOcodigo as NumeroReferencia,
						b.EOfecha as FechaDocumento,
						#rsPeriodoAuxiliar.Pvalor# as AnoDocumento,
						#rsMesAuxiliar.Pvalor# as MesDocumento,
						a.DOconsecutivo as DOconsecutivo,
						round(case
							when round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) > g.DStotallinest then g.DStotallinest
							when a.DOcantidad = g.DScant and a.DOtotal < g.DStotallinest then g.DStotallinest
							else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						end * b.EOtc,2) as Monto,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null"> as CodigoOficina,
						'RC' as TipoMovimiento,
						f.NAP as NAP,
						a.PCGDid as PCGDid,
						a.DOcantidad as cant,
						a.CPDCid as CPDCid,
						a.Aid as Aid,
						a.CMtipo as Tipoitem,
						g.ESidsolicitud,
						g.DSconsecutivo,
						g.DScant,
						g.DScantsurt

					from DOrdenCM a
						inner join EOrdenCM b
						 on b.EOidorden = a.EOidorden

						inner join ESolicitudCompraCM f
						 on f.ESidsolicitud = a.ESidsolicitud

						inner join DSolicitudCompraCM g
						 on g.ESidsolicitud = a.ESidsolicitud
						and g.DSlinea = a.DSlinea

					where b.EOidorden = #LvarEOidorden#
					and a.CMtipo = 'A'
					and (a.CPDCid is not null
					 	 and
					 	 a.CPDCid <> 0)
				</cfquery>


			<!----Para cada una de las lineas --->
				<cfloop query="rsLineasConDistribucion">

					<!--- Obtiene la distribucion --->
					<cfinvoke component="sif.Componentes.PRES_Distribucion"
						method="GenerarDistribucion"
						Cid="0"
		 				Aid="#rsLineasConDistribucion.Aid#"
						CPDCid="#rsLineasConDistribucion.CPDCid#"
				  		Tipo="#rsLineasConDistribucion.Tipoitem#"
				        Aplica="1"
						cantidad="#rsLineasConDistribucion.cant#"
						monto="#rsLineasConDistribucion.Monto#"
						descuento="0"
					returnVariable="rsDistribucion">


			<!--- Para cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

				<!--- Obtiene los datos de NAP --->
					<cfquery name="DatosNAP" datasource="#session.DSN#">
						select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
						from CPNAPdetalle
						where CPNAPnum	= #rsLineasConDistribucion.NAP#
						and CPNAPDlinea	= (#rsLineasConDistribucion.DSconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#
					</cfquery>


			<!--- Inserta la linea de la distribucion --->
					<cfquery name="rs" datasource="#session.DSN#">
						insert into #request.intPresupuesto#(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							NumeroLinea,
							CFcuenta,
							Ocodigo,
							CodigoOficina,
							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,
							TipoMovimiento,
							NAPreferencia,
							LINreferencia,
							PCGDid,
							PCGDcantidad)

				values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
						    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
							#rsLineasConDistribucion.AnoDocumento#,
							#rsLineasConDistribucion.MesDocumento#,
							- ((#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#),
							(select CFcuenta from CFinanciera
   							 where CFformato = '#rsDistribucion.cuenta#'),
							#DatosNAP.Ocodigo#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
							#DatosNAP.Mcodigo#,
							case
								when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) - #rsDistribucion.Monto# < 0
									 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
								when #rsLineasConDistribucion.DScantsurt# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DScant# and #rsLineasConDistribucion.DScantsurt# <> 0
									 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
								else - #rsDistribucion.Monto#
							end,
							1,
							case
								when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) - #rsDistribucion.Monto# < 0
									 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
								when #rsLineasConDistribucion.DScantsurt# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DScant# and #rsLineasConDistribucion.DScantsurt# <> 0
									 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
								else - #rsDistribucion.Monto#
							end,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
							#rsLineasConDistribucion.NAP#, 	<!---NAPreferencia--->
							#DatosNAP.CPNAPDlinea#,    		<!---LINreferencia--->
							<cfif rsLineasConDistribucion.PCGDid eq "">
								null,
							<cfelse>
								#rsLineasConDistribucion.PCGDid#,
							</cfif>
							- #rsDistribucion.cantidad#
						)
				</cfquery>

			</cfloop> <!--- rsDistribucion --->
		</cfloop><!--- rsLineasConDistribucion --->

<!--- JMRV Fin --->


			<!--- DesReserva de la PROVISION referenciando a la Suficiencia --->

			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPcuenta,
					Ocodigo,
					CodigoOficina,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,
					PCGDid, PCGDcantidad)
				select
					'CMOC',
					<cf_dbfunction name="to_char" args="b.EOnumero" >,
					b.CMTOcodigo,
					b.EOfecha,
					#rsPeriodoAuxiliar.Pvalor#,
					#rsMesAuxiliar.Pvalor#,
					-(a.DOconsecutivo),
					<!--- La suficiencia se hace a nivel de Cuenta de Presupuesto --->
					napSC.CPcuenta,
					napSC.Ocodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,

					<!--- El monto es el monto de la OC pero en moneda local tipo cambio 1 --->
					b.Mcodigo,
					- round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2 ),
                    	<!---case
							when a.DOtotal < g.CPDDmonto then  g.CPDDmonto - a.DOtotal
                            else round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2 )end,--->
					b.EOtc,
					- round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * b.EOtc, 2 ),

					<!---case when a.DOtotal < g.CPDDmonto then  g.CPDDmonto - a.DOtotal
                    	else round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
						* b.EOtc
					, 2 )end--->

					'RP',
					f.NAP,
					g.CPDDlinea,
					a.PCGDid, -a.DOcantidad
				from DOrdenCM a
					inner join EOrdenCM b
					 on b.EOidorden = a.EOidorden

					inner join CPDocumentoD g
					 on g.CPDDid = a.CPDDid

					inner join CPDocumentoE f
					 on f.CPDEid = g.CPDEid

					inner join CPNAPdetalle napSC
					 on napSC.Ecodigo		= f.Ecodigo
					and napSC.CPNAPnum		= f.NAP
					and napSC.CPNAPDlinea	= g.CPDDlinea
				where b.EOidorden = #LvarEOidorden#
					and a.CTDContid is null
               <!--- and a.DOtotal < g.CPDDmonto--->
			</cfquery>
			</cfif>

			<cfquery name="rs" datasource="#session.DSN#">
				select count(1) as cantidad
                  from #request.intPresupuesto#
            </cfquery>

			<!--- <cfquery name="myRs" datasource="#session.DSN#">
				select * from #request.intPresupuesto#
			</cfquery>
			<cf_dump var="#myRs#"> --->

            <cfif rs.cantidad EQ 0>
            	<cfset LvarNAP = 0>
            <cfelse>
				<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMOC",
                            data.EOnumero,
                            data.CMTOcodigo,
                            data.EOfecha,
                            rsPeriodoAuxiliar.Pvalor,
                            rsMesAuxiliar.Pvalor,
							session.DSN,
							Arguments.EcodigoAlterno,
							Momentos) >
			</cfif>

			<cfif LvarNAP GTE 0>
				<!--- Actualiza la Suficiencia --->
				<cfquery datasource="#Session.DSN#">
					update CPDocumentoD
					   set CPDDsaldo = CPDDsaldo -
								(
								 select sum(
											round(
												round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2)
												* b.EOtc
											, 2)
											)
								   from DOrdenCM a
								   		inner join EOrdenCM b
											on b.EOidorden=a.EOidorden
								  where a.EOidorden = #LvarEOidorden#
								    and a.CPDDid 	= CPDocumentoD.CPDDid
								)
					 where Ecodigo = #Arguments.EcodigoAlterno#
					   and (
							 select count(1)
							   from DOrdenCM
							  where EOidorden = #LvarEOidorden#
								and CPDDid = CPDocumentoD.CPDDid
							) > 0
				</cfquery>

				<cfquery name="rsDOrdenCM" datasource="#session.DSN#">
					select ESidsolicitud, DSlinea, sum(DOcantidad) as DOcantidad
					from DOrdenCM
					where EOidorden = #Arguments.EOidorden#
					  and ESidsolicitud is not null
					  and DSlinea is not null
					group by ESidsolicitud, DSlinea, Ecodigo
				</cfquery>
				<cfloop query="rsDOrdenCM">
					<cfquery datasource="#session.DSN#">
						update DSolicitudCompraCM
							set DScantsurt =
									<!--- Cuando no se controla cantidad en PCG se surte el 100% --->
									case when DScontrolCantidad = 0 then
										1
									else
										DScantsurt + #rsDOrdenCM.DOcantidad#
									end
						where DSolicitudCompraCM.ESidsolicitud = #rsDOrdenCM.ESidsolicitud#
						  and DSolicitudCompraCM.DSlinea       = #rsDOrdenCM.DSlinea#
					</cfquery>
				</cfloop>

				<cfquery name="rsCantidadSinSurtir" datasource="#session.DSN#">
					select count(1) as Cantidad
					from DOrdenCM
						inner join DSolicitudCompraCM
						on  DOrdenCM.ESidsolicitud = DSolicitudCompraCM.ESidsolicitud
						and DOrdenCM.Ecodigo       = DSolicitudCompraCM.Ecodigo
					where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
					  and DScant > DScantsurt
				</cfquery>

				<cfquery name="rsDOrdenCM" datasource="#session.DSN#">
					select distinct ESidsolicitud
					from DOrdenCM
					where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
					  and ESidsolicitud is not null
				</cfquery>

				<cfif rsCantidadSinSurtir.Cantidad GT 0>
					<cfset LvarESestado = 40>
				<cfelse>
					<cfset LvarESestado = 50>
				</cfif>

				<cfif rsDOrdenCM.recordCount EQ 1>
					<cfset LvarCondicion = "where ESidsolicitud = #rsDOrdenCM.ESidsolicitud#">
				<cfelse>
					<cfset LvarCondicion = "where ESidsolicitud in (#ValueList(rsDOrdenCM.ESidsolicitud, ',')#)">
				</cfif>


				<cfif isdefined('rsDOrdenCM') and rsDOrdenCM.recordCount GT 0 and rsDOrdenCM.ESidsolicitud NEQ ''>
					<cfquery datasource="#session.DSN#">
						update ESolicitudCompraCM
							set	ESestado = #LvarESestado#
						#LvarCondicion#
					</cfquery>
				</cfif>

				<cfquery name="update" datasource="#session.DSN#">
					update EOrdenCM
					set NAP         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">,
					UsucodigoAplica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					EOFechaAplica   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEOidorden#">
				</cfquery>
			</cfif>
		<cfreturn LvarNap>
	</cffunction>
	<cffunction name="fnVerificaJerarquiaComprador" access="private" output="no">
		<cfargument name="EOidorden" 	type="numeric">
		<cfargument name="CMCid" 		type="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="EcodigoAlterno" 	type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

		<cfoutput>
        <cftransaction action="rollback" />
		<cfquery name="rsProcesoAutoriza" datasource="#session.DSN#">
			select 1
			from CMAutorizaOrdenes
			where EOidorden = #Arguments.EOidorden#
		</cfquery>
		<cfif rsProcesoAutoriza.RecordCount gt 0>

			<!---
				ESTA EN PROCESO
				Consulta el estado del proceso.
				Permite continuar o aborta el proceso
			--->

			<cfquery name="rsAutorizado" datasource="#session.DSN#">
				select coalesce(CMAestado,0) as CMAestado, coalesce(CMAestadoproceso,0) as CMAestadoproceso
				from CMAutorizaOrdenes
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
				and CMAestado = 2
				and Nivel = ( select max(Nivel)
							  from CMAutorizaOrdenes
							  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
								and CMAestado <> 1 )
			</cfquery>

			<cfif rsAutorizado.RecordCount lte 0 >

				  <cfquery name="rsDelAutorizaciones" datasource="#session.DSN#">
				  	Delete CMAutorizaOrdenes
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
				  </cfquery>

				  <script language="javascript1.1">
					 alert("Usted excedió el monto máximo que tiene definido para comprar y el proceso de autorización de la orden fue rechazado. Proceso Cancelado!");
					 window.location="../operacion/listaOrdenCM.cfm";
				 </script>
				 <cfabort>

				 <!---<cfset Request.Error.Backs = "">
						<cf_errorCode	code = "50311" msg = "Usted excedió el monto máximo que tiene definido para comprar y el proceso de autorización de la orden fue rechazado. Proceso Cancelado!">--->
			</cfif>
		<cfelse> <!--- ESTA EN PROCESO --->
			<cfquery name="dataJerarquia" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.EcodigoAlterno#
				  and Pcodigo = 580
			</cfquery>

			<cfset vJerarquia = obtenerJerarquia(Arguments.CMCid,Arguments.Ecodigo) >
			<cfset vArrayJerarquia = ListToArray(vJerarquia) >

			<cfset nivel = 0 >
			<cfloop from="1" to="#Arraylen(vArrayJerarquia)#" index="i">
				<!---
				  Este proceso se encarga de recorrer la jerarquia de compradores, si el monto del comprador
				  supera el monto de la orden y además el comprador se encuentra activo (primera condición),
				  el proceso finaliza, por lo tanto la orden de compra es aplicada
				--->

				<cfset LMontoComprador = obtenerMontoComprador( vArrayJerarquia[i],Arguments.Ecodigo,Arguments.EcodigoAlterno) >

				<cfquery name="dataNivel" datasource="#session.DSN#">
					select coalesce(CMCnivel,0) as CMCnivel, CMCestado
					from CMCompradores
					where CMCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vArrayJerarquia[i]#">
				</cfquery>

				<cfset continuar = false >
				<cfif len(LMontoComprador) and LMontoComprador gt LMontoOrdenCompra and dataNivel.CMCestado neq 0>
					<cfset autorizaOrdenes(Arguments.EOidorden,vArrayJerarquia[i],0,0,nivel,Arguments.EcodigoAlterno) >
					<cfset continuar = true > <!--- este comprador tiene monto para comprar --->
					<cfbreak>
				<cfelse>
					<cfif i neq 1>
						<cfif dataJerarquia.RecordCount gt 0 and len(trim(dataJerarquia.Pvalor)) and trim(dataJerarquia.Pvalor) eq 1>
							<cfset autorizaOrdenes(Arguments.EOidorden,vArrayJerarquia[i],0,0,nivel,Arguments.EcodigoAlterno) >
							<cfset nivel = nivel + 1 >
						</cfif>
					<cfelse>
						<cfset autorizaOrdenes(Arguments.EOidorden,vArrayJerarquia[i],2,0,nivel,Arguments.EcodigoAlterno) >
						<cfset nivel = nivel + 1 >
					</cfif>
				</cfif>
			</cfloop>

			<!--- ninguno de los compradores tiene monto para comprar --->
			<cfif not continuar >
				<!---<cf_errorCode	code = "50312" msg = "Usted excedió el monto máximo que tiene definido para comprar y no se ha encontrado ningún comprador, según la jerarquía de compradores, que tenga un monto de compra mayor ó igual al monto de la orden y que esté activo. Proceso Cancelado!">--->

				  <cfquery name="rsDelAutorizaciones" datasource="#session.DSN#">
				  	Delete CMAutorizaOrdenes
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
				  </cfquery>

				<script language="javascript1.1">
      		    	alert("Usted excedió el monto máximo que tiene definido para comprar y el proceso de autorización de la orden fue rechazado. Proceso Cancelado!");
		       		window.location="../operacion/listaOrdenCM.cfm";
		    	</script>
				<cfabort>
			<cfelse>
				<cfquery name="dataAutorizador" datasource="#session.DSN#">
					select CMCid
					from CMAutorizaOrdenes
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
					  and Nivel=1
				</cfquery>
				<cfif dataAutorizador.recordCount gt 0 and len(trim(dataAutorizador.CMCid)) >
                	 <cfquery name="rsComprador" datasource="#session.dsn#">
                        select cm.CMCnombre, coalesce(dec.DEemail, dpc.Pemail1, dpc.Pemail2) as Email1
                        from CMCompradores cm
                            left outer join DatosEmpleado dec
                                on dec.DEid = cm.DEid
                            inner join Usuario uc
                                left outer join DatosPersonales dpc
                                    on dpc.datos_personales = uc.datos_personales
                                on uc.Usucodigo = cm.Usucodigo
                            where cm.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataAutorizador.CMCid#">
                  	</cfquery>
					<cfif rsComprador.recordCount gt 0 and len(trim(rsComprador.Email1))>
						<cfset LvarBody = fnEmailAutorizacion(Arguments.EOidorden)>
						<cfquery datasource="#session.DSN#">
							insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
							values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.email1#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComprador.Email1#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Aprobación de Orden de Compra #dataOrden.EOnumero#.">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarBody#">,
									 1 )
						</cfquery>
					</cfif>
				</cfif>
			</cfif>

			<cfquery name="update" datasource="#session.DSN#">
				update EOrdenCM
				set EOestado = -7
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>
            <cftransaction action="commit" />
         <script language="javascript1.1">
		    alert("Usted excedió el monto máximo que tiene definido para comprar. Se ha generado una jerarquía de autorización para esta orden. Para ver la jerarquía generada, puede ir a la opción Autorizar órdenes de Compra.");
		<!---	<cf_errorCode	code = "50313" msg = "Usted excedió el monto máximo que tiene definido para comprar. Se ha generado una jerarquía de autorización para esta orden. Para ver la jerarquía generada, puede ir a la opción Autorizar órdenes de Compra.">--->
			window.location="../operacion/listaOrdenCM.cfm";
			</script>
			<cfabort>
		</cfif> <!--- ESTA EN PROCESO --->
		</cfoutput>
	</cffunction>

	<cffunction name="fnEmailAutorizacion" access="private" returntype="string">
		<cfargument name="EOidorden" 	type="numeric">

		<cfquery name="dataOrden" datasource="#session.DSN#">
			select a.EOnumero, a.Observaciones, coalesce(a.EOtotal,0) as EOtotal, a.Mcodigo, a.EOfecha, b.Mnombre, c.CMCnombre
			  from EOrdenCM a
				inner join Monedas b
				 on a.Mcodigo=b.Mcodigo
				and a.Ecodigo=b.Ecodigo
				inner join CMCompradores c
				 on a.CMCid=c.CMCid
			where a.EOidorden	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>

		<cfoutput>
		<cfsavecontent variable="_body">
			<HTML>
				<head>
					<style type="text/css">
						.tituloIndicacion {
							font-size: 10pt;
							font-variant: small-caps;
							background-color: ##CCCCCC;
						}
						.tituloListas {
							font-weight: bolder;
							vertical-align: middle;
							padding: 2px;
							background-color: ##F5F5F5;
						}
						.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
						.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
						body,td {
							font-size: 12px;
							background-color: ##f8f8f8;
							font-family: Verdana, Arial, Helvetica, sans-serif;
						}
					</style>
				</head>

				<body>
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr><td colspan="2" class="tituloAlterno"><strong>Sistema de Compras. <cfif isdefined("autorizada") and autorizada >La siguiente orden de compra ha sido autorizada.<cfelse>La siguiente Orden de Compra requiere de su aprobaci&oacute;n.</cfif></strong></td></tr>
						<tr>
							<td style="padding-left:10px;" width="1%"><strong>Orden:&nbsp;</strong></td>
							<td>#dataOrden.EOnumero#</td>
						</tr>
						<tr>
							<td style="padding-left:10px;" width="1%"><strong>Observaciones:&nbsp;</strong></td>
							<td>#dataOrden.Observaciones#</td>
						</tr>
						<tr>
							<td style="padding-left:10px;" width="1%" nowrap><strong>Fecha de la Orden:&nbsp;</strong></td>
							<td>#LSDateFormat(dataOrden.EOfecha,'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td style="padding-left:10px;" width="1%"><strong>Comprador:&nbsp;</strong></td>
							<td>#dataOrden.CMCnombre#</td>
						</tr>
						<tr>
							<td style="padding-left:10px;" width="1%"><strong>Moneda:&nbsp;</strong></td>
							<td>#dataOrden.Mnombre#</td>
						</tr>
						<tr>
							<td style="padding-left:10px;" width="1%"><strong>Monto:&nbsp;</strong></td>
							<td>#LSNumberFormat(dataOrden.EOtotal, ',9.00')#</td>
						</tr>
						<tr><td colspan="2"><hr size="1" color="##CCCCCC"></td></tr>
					</table>
				</body>
			</HTML>
		</cfsavecontent>
		</cfoutput>
		<cfreturn _body>
	</cffunction>

	<cffunction name="fnValidaMontoOrdenComprador" access="private" output="no" returntype="boolean">
		<cfargument name="EOidorden" 	type="numeric">
		<cfargument name="CMCid" 		type="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="EcodigoAlterno" type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

		<!---
				Valida si el comprador puede hacer una orden de compra por el monto de la orden de compra
				Deben compararse los 2 montos en Moneda Local
					Monto 1: Monto Máximo Permitido para el Comprador MONEDA LOCAL
					Monto 2: Monto de la Orden de Compra en la Moneda LOCAL
		--->

        <cfquery name="rsProvCorp" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Arguments.Ecodigo#
            and Pcodigo=5100
        </cfquery>
        <cfset lvarProvCorp = false>
        <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
        	<cfset lvarProvCorp = true>
        </cfif>

		<cfquery datasource="#session.dsn#" name="Comprador">
			select <cfif lvarProvCorp>mS.Mcodigo<cfelse>cm.Mcodigo</cfif>, cm.CMCmontomax
			from CMCompradores cm
            	<cfif lvarProvCorp>
                	inner join Monedas mA
                    	on mA.Mcodigo = cm.Mcodigo
                   	inner join Monedas mS
                    	on mS.Miso4217 = mA.Miso4217 and mS.Ecodigo = #Arguments.EcodigoAlterno#
                </cfif>
			where cm.CMCid   = #Arguments.CMCid#
		</cfquery>

		<cfset LMonedaComprador = Comprador.Mcodigo>
		<cfset LMontoComprador = Comprador.CMCmontomax>
		<cfif LMonedaComprador NEQ GvarMcodigoLocal>
			<cfquery datasource="#session.dsn#" name="Htipocambio">
				select TCventa
				from Htipocambio
				where Mcodigo = #LMonedaComprador#
				  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between Hfecha and Hfechah
			</cfquery>
			<cfif Htipocambio.RecordCount and len(Htipocambio.TCventa)>
				<cfset LTCventa = Htipocambio.TCventa>
			<cfelse>
				<cf_errorCode	code = "50310" msg = "No está definido el tipo de cambio para la moneda de compra del comprador para la fecha de hoy. Proceso Cancelado!">
			</cfif>
			<cfset LMontoComprador = LMontoComprador * LTCventa>
		</cfif>

		<!--- Monto 2: Monto de la OC MONEDA LOCAL --->
		<cfquery datasource="#session.dsn#" name="EOrdenCM">
			select round(EOtc * EOtotal,2) as MontoOrdenCompra
			from EOrdenCM
			where EOidorden = #Arguments.EOidorden#
		</cfquery>
		<cfset LMontoOrdenCompra = EOrdenCM.MontoOrdenCompra>

		<!--- Comparación de Montos --->
		<cfif len(LMontoComprador) and LMontoOrdenCompra gt LMontoComprador>
			<cfreturn false >
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="obtenerJerarquia" returntype="string" output="no" access="private">
		<cfargument name="CMCid" 		type="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

		<cfset LvarCMCid = arguments.CMCid >
		<cfset LvarJerarquia = '' >

		<!--- Componente de Seguridad --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

		<cfloop condition="len(trim(LvarCMCid)) neq 0">
			<cfquery name="dataJefe" datasource="#session.DSN#">
				select CMCid, CMCjefe, CMCnombre
				from CMCompradores
				where CMCid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCMCid#">
			</cfquery>
			<cfif len(trim(dataJefe.CMCjefe))>
				<cfset rsJefe = sec.getUsuarioByCod (dataJefe.CMCjefe, session.EcodigoSDC, 'CMCompradores') >
				<cfset LvarJerarquia = LvarJerarquia & "," & dataJefe.CMCid >
				<cfset LvarCMCid = rsJefe.llave >
			<cfelse>
				<cfset LvarJerarquia = LvarJerarquia & "," & dataJefe.CMCid >
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif len(trim(LvarJerarquia))>
			<cfset LvarJerarquia = mid(LvarJerarquia,2,len(LvarJerarquia)) >
		</cfif>

		<cfreturn LvarJerarquia >
	</cffunction>

	<cffunction name="obtenerMontoComprador" returntype="string" output="no" access="private">
		<cfargument name="CMCid" 		type="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="EcodigoAlterno" type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

        <cfquery name="rsProvCorp" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Arguments.Ecodigo#
            and Pcodigo=5100
        </cfquery>
        <cfset lvarProvCorp = false>
        <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
        	<cfset lvarProvCorp = true>
        </cfif>

		<cfquery datasource="#session.dsn#" name="Comprador">
			select <cfif lvarProvCorp>mS.Mcodigo<cfelse>cm.Mcodigo</cfif>, cm.CMCmontomax
			from CMCompradores cm
            	<cfif lvarProvCorp>
                	inner join Monedas mA
                    	on mA.Mcodigo = cm.Mcodigo
                   	inner join Monedas mS
                    	on mS.Miso4217 = mA.Miso4217 and mS.Ecodigo = #Arguments.EcodigoAlterno#
                </cfif>
			where cm.CMCid   = #Arguments.CMCid#
		</cfquery>
		<cfset LMonedaComprador = Comprador.Mcodigo>
		<cfset LMontoComprador = Comprador.CMCmontomax>
		<cfif LMonedaComprador NEQ GvarMcodigoLocal>
			<!--- declare @TCventa money, @maxdate datetime --->
			<cfquery datasource="#session.dsn#" name="Htipocambio">
				select max(Hfecha) as maxdate
				from Htipocambio
				where Mcodigo = #LMonedaComprador#
					and Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			</cfquery>
			<cfif Htipocambio.RecordCount and len(Htipocambio.maxdate)>
				<cfset Lmaxdate = Htipocambio.maxdate>
				<cfquery datasource="#session.dsn#" name="Htipocambio">
					select TCventa
					from Htipocambio
					where Mcodigo = #LMonedaComprador#
						and Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lmaxdate#">
				</cfquery>
				<cfif Htipocambio.RecordCount and len(Htipocambio.TCventa)>
					<cfset LTCventa = Htipocambio.TCventa>
				</cfif>
			</cfif>
			<cfif not isdefined("LTCventa")>
				<cf_errorCode	code = "50310" msg = "No está definido el tipo de cambio para la moneda de compra del comprador para la fecha de hoy. Proceso Cancelado!">
			</cfif>
			<cfset LMontoComprador = LMontoComprador * LTCventa>
		</cfif>
		<cfreturn LMontoComprador >
	</cffunction>

	<cffunction name="autorizaOrdenes" access="private" output="no">
		<cfargument name="EOidorden" type="string" required="yes" default="#vnCMCid#">
		<cfargument name="CMCid" required="yes" type="numeric" >
		<cfargument name="Estado" type="numeric" required="yes" >
		<cfargument name="EstadoProceso" required="yes" type="numeric" >
		<cfargument name="Nivel" required="yes" type="numeric" >
        <cfargument name="Ecodigo" 		type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

		<cfquery datasource="#session.DSN#">
			insert into CMAutorizaOrdenes(EOidorden, CMCid, Ecodigo, CMAestado, CMAestadoproceso, Nivel, CMAfecha, BMUsucodigo, fechaalta)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EOidorden#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CMCid#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Estado#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EstadoProceso#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Nivel#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
		</cfquery>
	</cffunction>

	<cffunction name="insert_EOrdenCM" access="public" output="no" returntype="numeric">
		<cfargument name="Ecodigo" 			default="#session.Ecodigo#" 	type="numeric">
		<cfargument name="SNcodigo" 		default="-1"  					type="numeric">
		<cfargument name="CMCid" 			default="-1"  					type="numeric">
		<cfargument name="Mcodigo" 			default="-1"  					type="numeric">
		<cfargument name="Rcodigo" 			default="-1"  					type="string">
		<cfargument name="CMTOcodigo" 		default=""  					type="string">
		<cfargument name="EOfecha"			default=""  					type="string">
		<cfargument name="Observaciones"	default="" 						type="string">
		<cfargument name="EOtc"				default="-1"	  				type="string">
		<cfargument name="EOrefcot"         default="-1"                    type="string">
		<cfargument name="Impuesto"			default="-1"  					type="string">
		<cfargument name="EOdesc"			default="-1"			 		type="string">
		<cfargument name="EOtotal"			default="-1"  					type="numeric">
		<cfargument name="EOplazo"			default="-1"	 				type="numeric">
		<cfargument name="EOhabiles"		default="0"	 				    type="numeric">
		<cfargument name="EOporcanticipo"	default="0"	 					type="string">
		<cfargument name="CMFPid"			default="-1"					type="numeric">
		<cfargument name="CMIid"			default="-1"					type="numeric">
		<cfargument name="EOdiasEntrega"	default="0"						type="string">
		<cfargument name="EOtipotransporte"	default=""						type="string">
		<cfargument name="EOlugarentrega"	default=""						type="string">
		<cfargument name="CRid"				default="-1"					type="numeric">

			<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
			<cflock name="LCK_EOrdenCM#Arguments.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
				<!--- Calculo de Consecutivo: ultimo + 1 --->
                <cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
                    select coalesce(max(EOnumero), 0) + 1 as EOnumero
                      from EOrdenCM
                     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                </cfquery>
                <cfquery datasource="#Session.DSN#">
                    update EOrdenCM
                       set EOnumero = EOnumero
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                      and EOnumero = #rsConsecutivoOrden.EOnumero-1#
                </cfquery>

				<!--- Guardar el numero del encabezado de Orden de Compra --->
				<cfset numero = rsConsecutivoOrden.EOnumero>

				<cfquery name="insert" datasource="#session.DSN#">
					insert into EOrdenCM ( Ecodigo, EOnumero, SNcodigo, CMTOcodigo, CMCid, Mcodigo, Rcodigo, EOfecha, Observaciones, EOtc, EOrefcot, Impuesto, EOdesc, EOtotal, Usucodigo, EOplazo, EOhabiles, EOfalta, EOporcanticipo, CMFPid, CMIid, EOdiasEntrega, EOtipotransporte, EOlugarentrega, CRid)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#numero#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CMTOcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CMCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
						<cfif Arguments.Rcodigo neq '-1' ><cfqueryparam cfsqltype="cf_sql_char"	value="#Arguments.Rcodigo#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.EOfecha)#">,
						<cfif len(trim(Arguments.Observaciones)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Observaciones#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#Arguments.EOtc#">,
						<cfif Arguments.EOrefcot neq -1 ><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Arguments.EOrefcot#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.Impuesto#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.EOdesc#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.EOtotal#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.EOplazo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.EOhabiles#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
						<cfif isdefined("Arguments.EOporcanticipo") and Len(Trim(Arguments.EOporcanticipo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOporcanticipo#" scale="2"><cfelse>null</cfif>,
						<cfif isdefined("Arguments.CMFPid") and Len(Trim(Arguments.CMFPid)) and Arguments.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMFPid#"><cfelse>null</cfif>,
						<cfif isdefined("Arguments.CMIid") and Len(Trim(Arguments.CMIid)) and Arguments.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMIid#"><cfelse>null</cfif>,
						<cfif isdefined("Arguments.EOdiasEntrega") and Len(Trim(Arguments.EOdiasEntrega))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOdiasEntrega#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EOtipotransporte#" null="#Len(Trim(Arguments.EOtipotransporte)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EOlugarentrega#" null="#Len(Trim(Arguments.EOlugarentrega)) EQ 0#">,
						<cfif isdefined("Arguments.CRid") and Len(Trim(Arguments.CRid)) and Arguments.CRid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRid#"><cfelse>null</cfif>
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			</cflock>
		<cfset Request.key = insert.identity >
		<cfreturn Request.key>
	</cffunction>

	<cffunction name="update_EOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 			default="#session.Ecodigo#" 	type="numeric">
		<cfargument name="EOidorden" 		default="-1"  					type="numeric">
		<cfargument name="EOnumero" 		default="-1"  					type="numeric">
		<cfargument name="SNcodigo" 		default="-1"  					type="numeric">
		<cfargument name="CMCid" 			default="-1"  					type="numeric">
		<cfargument name="Mcodigo" 			default="-1"  					type="numeric">
		<cfargument name="Rcodigo" 			default="-1"  					type="string">
		<cfargument name="CMTOcodigo" 		default=""  					type="string">
		<cfargument name="EOfecha"			default=""  					type="string">
		<cfargument name="Observaciones"	default="" 						type="string">
		<cfargument name="EOtc"				default="-1"	  				type="numeric">
		<cfargument name="Impuesto"			default="-1"  					type="numeric">
		<cfargument name="EOdesc"			default="-1"			 		type="numeric">
		<cfargument name="EOtotal"			default="-1"  					type="numeric">
		<cfargument name="EOplazo"			default="-1"	 				type="numeric">
		<cfargument name="EOhabiles"		default="0" 	 				type="numeric">
		<cfargument name="EOporcanticipo"	default="0"	 					type="numeric">
		<cfargument name="CMFPid"			default="-1"					type="numeric">
		<cfargument name="CMIid"			default="-1"					type="numeric">
		<cfargument name="EOdiasEntrega"	default="0"						type="numeric">
		<cfargument name="EOtipotransporte"	default=""						type="string">
		<cfargument name="EOlugarentrega"	default=""						type="string">
		<cfargument name="CRid"				default="-1"					type="numeric">
		<cfargument name="EOrefcot"			default="-1"  					type="numeric">
		<cfargument name="Ieps"			default="-1"  					type="numeric">

		<cfquery name="update" datasource="#session.DSN#">
			update EOrdenCM
			set SNcodigo  		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">,
				CMTOcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CMTOcodigo#">,
				CMCid     		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CMCid#">,
				Mcodigo   		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
				EOfecha   		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.EOfecha)#">,
				EOtc      		= <cfqueryparam cfsqltype="cf_sql_float"	value="#Arguments.EOtc#">,
				<!--- EOtotal, EOdesc, Impuestos son sum() de las lineas y se calculan con calculaTotalesEOrdenCM --->
				Impuesto  		= <cfif isdefined("Arguments.Impuesto") and Len(Trim(Arguments.Impuesto))><cfqueryparam cfsqltype="cf_sql_money"	value="#Arguments.Impuesto#"><cfelse>0</cfif>,
				EOTiEPS  		= <cfif isdefined("Arguments.Ieps") and Len(Trim(Arguments.Ieps))><cfqueryparam cfsqltype="cf_sql_money"	value="#Arguments.Ieps#"><cfelse>0</cfif>,
				EOdesc    		= <cfif isdefined("Arguments.EOdesc") and Len(Trim(Arguments.EOdesc))><cfqueryparam cfsqltype="cf_sql_money"	value="#Arguments.EOdesc#"><cfelse>0</cfif>,
				EOtotal   		= <cfif isdefined("Arguments.EOtotal") and Len(Trim(Arguments.EOtotal))><cfqueryparam cfsqltype="cf_sql_money"	value="#Arguments.EOtotal#"><cfelse>0</cfif>,
				Usucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				EOplazo			= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.EOplazo#">,
				EOhabiles		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.EOhabiles#">,
				Rcodigo   		= <cfif Arguments.Rcodigo neq '-1' ><cfqueryparam cfsqltype="cf_sql_char"	value="#Arguments.Rcodigo#"><cfelse>null</cfif>,
				Observaciones 	= <cfif len(trim(Arguments.Observaciones)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar"  value="#Arguments.Observaciones#"><cfelse>null</cfif>,
				EOrefcot  		= <cfif Arguments.EOrefcot neq -1 ><cfqueryparam cfsqltype="cf_sql_numeric"		value="#Arguments.EOrefcot#"><cfelse>null</cfif>,
				EOporcanticipo = <cfif isdefined("Arguments.EOporcanticipo") and Len(Trim(Arguments.EOporcanticipo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOporcanticipo#" scale="2"><cfelse>null</cfif>,
				CMFPid = <cfif isdefined("Arguments.CMFPid") and Len(Trim(Arguments.CMFPid)) and Arguments.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMFPid#"><cfelse>null</cfif>,
				CMIid = <cfif isdefined("Arguments.CMIid") and Len(Trim(Arguments.CMIid)) and Arguments.CMIid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMIid#"><cfelse>null</cfif>,
				EOdiasEntrega = <cfif isdefined("Arguments.EOdiasEntrega") and Len(Trim(Arguments.EOdiasEntrega))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOdiasEntrega#"><cfelse>null</cfif>,
				EOtipotransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EOtipotransporte#" null="#Len(Trim(Arguments.EOtipotransporte)) EQ 0#">,
				EOlugarentrega = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EOlugarentrega#" null="#Len(Trim(Arguments.EOlugarentrega)) EQ 0#">,
				CRid = <cfif isdefined("Arguments.CRid") and Len(Trim(Arguments.CRid)) and Arguments.CRid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRid#"><cfelse>null</cfif>
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>
	</cffunction>

	<cffunction name="delete_EOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 			default="#session.Ecodigo#" 	type="numeric">
		<cfargument name="EOidorden" 		default="-1"  					type="numeric">

		<!---SML. Cancelar NRP y Eliminar la autorizacion de Orden de Compra 11/06/2014--->
        <cfquery name="rsNRP" datasource="#session.DSN#">
        	select NRP
			from EOrdenCM
			where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
        </cfquery>

		<cftransaction>
        	<cfif isdefined('rsNRP') and len(rsNRP.NRP) GT 0>
				<cfquery name="ABC_DocsReserva" datasource="#Session.DSN#">
					select; CPNRPtipoCancela
			  		from CPNRP
			 		where Ecodigo = #Session.Ecodigo#
			   			and CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNRP.NRP#">
				</cfquery>
				<cfif ABC_DocsReserva.CPNRPtipoCancela EQ "0">
					<cfquery name="ABC_DocsReserva" datasource="#Session.DSN#">
						update CPNRP
				   		set CPNRPtipoCancela = 1,
					   	UsucodigoCancela = #session.usucodigo#,
					   	CPNRPfechaCancela = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where Ecodigo = #session.Ecodigo#
							and CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNRP.NRP#">
					</cfquery>
					<cfinvoke
			 			component="sif.Componentes.PRES_Presupuesto"
			 			method="sbCancelaPendientesNrp">
						<cfinvokeargument name="NRP" value="#rsNRP.NRP#"/>
						<cfinvokeargument name="Conexion" value="#session.dsn#"/>
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
					</cfinvoke>
				</cfif>
            </cfif>

		<cfquery name="delete" datasource="#session.DSN#">
				delete from CMAutorizaOrdenes
				where EOidorden	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
			</cfquery>

            <cfquery name="delete" datasource="#session.DSN#">
				delete from EOrdenCM
				where EOidorden	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
			</cfquery>
       </cftransaction>
	</cffunction>

	<cffunction name="insert_DOrdenCM" access="public" output="no" returntype="numeric">
		<cfargument name="Ecodigo" 			    required="no" 			    type="numeric">
		<cfargument name="EOidorden" 			default="-1"  				type="numeric">
		<cfargument name="EOnumero" 			default="-1"  				type="numeric">
		<cfargument name="CMtipo" 				default=""  				type="string">
		<cfargument name="ESidsolicitud"		default="-1"  				type="numeric">
		<cfargument name="DSlinea"	 			default="-1"  				type="numeric">
		<cfargument name="Cid" 					default="-1"  				type="string">
		<cfargument name="Aid" 					default="-1"  				type="string">
		<cfargument name="Alm_Aid" 				default="-1"				type="string">
		<cfargument name="ACcodigo"				default="-1"				type="string">
		<cfargument name="ACid"					default="-1"  				type="string">
		<cfargument name="DOdescripcion"		default=""  				type="string">
		<cfargument name="DOobservaciones"		default=""  				type="string">
		<cfargument name="DOalterna"			default=""  				type="string">
		<cfargument name="DOcantidad"			default="0"	  				type="numeric">
		<cfargument name="DOcantsurtida"		default="0"  				type="numeric">
		<cfargument name="DOpreciou"			default="0"			 		type="numeric">
		<cfargument name="DOfechaes"			default=""  				type="string">
		<cfargument name="DOgarantia"			default="0"  				type="numeric">
		<cfargument name="CFid"					default="-1"  				type="numeric">
		<cfargument name="Icodigo"				default="-1"  				type="string">
		<cfargument name="Ucodigo"				default="-1"  				type="string">
		<cfargument name="DOfechareq"			default="-1"  				type="string">
		<cfargument name="Ppais"				default=""  				type="string">
		<cfargument name="tipo"					default=""					type="string">
		<cfargument name="DOmontodesc"			default="0"					type="string">
		<cfargument name="DOporcdesc"			default="0"					type="string">
		<cfargument name="PCGDid"	     		default=""					type="string">
        <cfargument name="CPDDid"				default=""  				type="string">
        <cfargument name="FPAEid"			    default="-1" 				type="numeric" hint="Id de la Actividad Empresarial">
        <cfargument name="CFComplemento"	    default="" 				    type="string"  hint="Complemento de la Actividad Empresarial">
		<cfargument name="codIEPS"				default=""  				type="string">
		<!---JMRV. Inicio de cambio. 30/04/2014--->
		<cfargument name="PlantillaDistribucion" default="0"				type="string">
		<cfargument name="CheckDistribucionHidden" 	default="0"				type="numeric">
		<!---JMRV. Fin de cambio. 08/08/2014--->
		<!---MSEG. Inicio de cambio. 30/04/2014 id detalle de Contrato--->
		<cfargument name="CTDContid" 				default=""					type="string">
        <!---MSEG. Fin de cambio. 08/08/2014--->

        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfif LEN(TRIM(Arguments.DOfechareq))>
        	<cfset Arguments.DOfechareq = LSParseDateTime(Arguments.DOfechareq)>
        </cfif>

		<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
		<cfset Arguments.DOpreciou = LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)>
		<cfset DOtotal = Arguments.DOcantidad * Arguments.DOpreciou>

		<cfquery name="consecutivo" datasource="#session.DSN#">
			select max(DOconsecutivo) as linea
			from DOrdenCM
			where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>
		<cfset dlinea = 1 >
		<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
			<cfset dlinea = consecutivo.linea + 1>
		</cfif>

        <cfif len(TRIM(Arguments.CTDContid))>
			<cfquery name="rsOrdenTC" datasource="#session.dsn#">
				select Mcodigo,EOtc from EOrdenCM where EOidorden = #EOidorden#
			</cfquery>
			<cfset tcidorden = #rsOrdenTC.EOtc#>
            <cfquery name="vDetContrato" datasource="#session.dsn#">
                    select CTDCmontoTotal,isnull(CTDCmontoConsumido,0) + #DOtotal*tcidorden# as CTDCmontoConsumido from CTDetContrato
                    where CTDCont = #Arguments.CTDContid#
            </cfquery>
            <cfif  vDetContrato.CTDCmontoConsumido GT vDetContrato.CTDCmontoTotal>
                <cfthrow message="El monto consumido es mayor que el monto del Contrato">
            </cfif>
        </cfif>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into DOrdenCM ( Ecodigo, EOidorden, EOnumero, DOconsecutivo, ESidsolicitud, DSlinea,
								   CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, DOdescripcion, DOobservaciones, DOalterna,
								   DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOfechaes, DOgarantia,
								   CFid, Icodigo, Ucodigo, DOfechareq, Ppais, DOmontodesc, DOporcdesc, PCGDid, CPDDid,
                                   FPAEid,CFComplemento,codIEPS,CPDCid,CTDContid)
					 values (   <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.EOidorden,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.EOnumero,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#dlinea#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.ESidsolicitud,',','','all')#" voidnull null="#Arguments.ESidsolicitud EQ -1#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Replace(Arguments.DSlinea,',','','all')#" voidnull null="#Arguments.DSlinea EQ -1#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.CMtipo#">,
								<cfif Arguments.CMtipo eq "S" and ( len(trim(Arguments.Cid)) gt 0 and Arguments.Cid neq "-1")><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Cid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACcodigo,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACid,',','','all')#"><cfelse>null</cfif>,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.DOdescripcion#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.DOobservaciones#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DOalterna#" voidnull>,
                                <cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantidad,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantsurtida,',','','all')#">,
								#LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)#,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Arguments.DOfechaes)#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_integer"		value="#Replace(Arguments.DOgarantia,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.CFid#" null="#NOT LEN(TRIM(Arguments.CFid))#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(Arguments.Icodigo)#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(Arguments.Ucodigo)#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_timestamp"	value="#Arguments.DOfechareq#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"	    	value="#Arguments.Ppais#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(Arguments.DOmontodesc,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOporcdesc,',','','all')#" voidnull>,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Replace(Arguments.PCGDid,',','','all')#" null = "#NOT LEN(TRIM(Arguments.PCGDid))#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Replace(Arguments.CPDDid,',','','all')#" null = "#NOT LEN(TRIM(Arguments.CPDDid))#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPAEid#" 		  null="#Arguments.FPAEid EQ -1#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.CFComplemento#" null="#NOT LEN(TRIM(Arguments.CFComplemento))#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(Arguments.codIEPS)#" voidnull>,
								<!---JMRV. Inicio de cambio. 30/04/2014--->
								<cfif Arguments.CMtipo eq "A" and Arguments.CheckDistribucionHidden eq 1>
                                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PlantillaDistribucion#" null = "#Arguments.PlantillaDistribucion LTE 0#">,
                                <cfelse>
                                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PlantillaDistribucion#" null = "#not len(trim(Arguments.PlantillaDistribucion))#">,
                                </cfif>
								<!---JMRV. Fin de cambio. 30/04/2014--->
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Replace(Arguments.CTDContid,',','','all')#" null = "#NOT len(TRIM(Arguments.CTDContid))#">
                            )
		</cfquery>

		<!--- si se esta agregando un detalle de contrato --->
		<cfif len(TRIM(Arguments.CTDContid))>
			<cfquery name="rsOrdenTC" datasource="#session.dsn#">
				select Mcodigo,EOtc from EOrdenCM where EOidorden = #EOidorden#
			</cfquery>
			<cfset tcidorden = #rsOrdenTC.EOtc#>
            <cfquery name="updDetContrato" datasource="#session.dsn#">
				update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) + #DOtotal*tcidorden#,2)
				where CTDCont = #Arguments.CTDContid#
			</cfquery>
		</cfif>
        <cfreturn 0>
	</cffunction>

	<cffunction name="update_DOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 			    required="no" 				type="numeric">
		<cfargument name="EOidorden" 			default="-1"  				type="numeric">
		<cfargument name="DOlinea" 				default="-1"  				type="numeric">
		<cfargument name="EOnumero" 			default="-1"  				type="numeric">
		<cfargument name="ESidsolicitud"		default="-1"  				type="numeric">
		<cfargument name="DSlinea"	 			default="-1"  				type="numeric">
		<cfargument name="CMtipo" 				default=""  				type="string">
		<cfargument name="Cid" 					default="-1"  				type="string">
		<cfargument name="Aid" 					default="-1"  				type="string">
		<cfargument name="Alm_Aid" 				default="-1"				type="string">
		<cfargument name="ACcodigo"				default="-1"				type="string">
		<cfargument name="ACid"					default="-1"  				type="string">
		<cfargument name="DOdescripcion"		default=""  				type="string">
		<cfargument name="DOobservaciones"		default=""  				type="string">
		<cfargument name="DOalterna"			default=""  				type="string">
		<cfargument name="DOcantidad"			default="0"	  				type="numeric">
		<cfargument name="DOcantsurtida"		default="0"  				type="numeric">
		<cfargument name="DOpreciou"			default="0"			 		type="numeric">
		<cfargument name="DOfechaes"			default=""  				type="string">
		<cfargument name="DOgarantia"			default="0"  				type="numeric">
		<cfargument name="CFid"					default="-1"  				type="numeric">
		<cfargument name="Icodigo"				default="-1"  				type="string">
		<cfargument name="Ucodigo"				default="-1"  				type="string">
		<cfargument name="DOfechareq"			default="-1"  				type="string">
		<cfargument name="Ppais"				default="CR"  				type="string">
		<cfargument name="DOmontodesc"			default="0"					type="string">
		<cfargument name="DOporcdesc"			default="0"					type="string">
        <cfargument name="FPAEid"			    default="-1" 				type="numeric" hint="Id de la Actividad Empresarial">
        <cfargument name="CFComplemento"	    default="" 				    type="string"  hint="Complemento de la Actividad Empresarial">
		<!---JMRV. Inicio de cambio. 30/04/2014--->
		<cfargument name="PlantillaDistribucion" default="0"				type="numeric">
		<cfargument name="CheckDistribucionHidden" 	default="0"				type="numeric">
		<!---JMRV. Fin de cambio. 30/04/2014--->

        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>

		<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
		<cfset Arguments.DOpreciou = LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)>
		<cfset DOtotal = Arguments.DOcantidad * Arguments.DOpreciou>

		<!--- obteniendo la orden antes del cambio --->
		<cfquery name="getOrden" datasource="#session.DSN#">
			select * from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>

        <cfif getOrden.CTDContid NEQ ''>
			<cfquery name="rsOrdenTC" datasource="#session.dsn#">
				select Mcodigo,EOtc from EOrdenCM where EOidorden = #EOidorden#
			</cfquery>
			<cfset tcidorden = #rsOrdenTC.EOtc#>
            <cfquery name="vDetContrato" datasource="#session.dsn#">
                    select CTDCmontoTotal,isnull(CTDCmontoConsumido,0) - #getOrden.DOtotal*tcidorden# + <cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">   as CTDCmontoConsumido
                    from CTDetContrato
                    where CTDCont = #getOrden.CTDContid#
            </cfquery>
            <cfif  vDetContrato.CTDCmontoConsumido GT vDetContrato.CTDCmontoTotal>
                <cfthrow message="El monto consumido es mayor que el monto del Contrato">
            </cfif>
        </cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update DOrdenCM set
                    EOnumero        = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Arguments.EOnumero,',','','all')#">,

                    CMtipo          = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.CMtipo#">,
                    Cid             = <cfif Arguments.CMtipo eq "S" and ( len(trim(Arguments.Cid)) gt 0 and Arguments.Cid neq "-1")><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Cid,',','','all')#"><cfelse>null</cfif>,
                    Aid             = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Aid,',','','all')#"><cfelse>null</cfif>,
                    Alm_Aid         = <cfif CMtipo eq "A"><cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
                    ACcodigo        = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACcodigo,',','','all')#"><cfelse>null</cfif>,
                    ACid            = <cfif CMtipo eq "F"><cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACid,',','','all')#"><cfelse>null</cfif>,
                    DOdescripcion   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOdescripcion#">,
                    DOobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOobservaciones#">,
                    DOalterna       = <cfif len(trim(Arguments.DOalterna)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.DOalterna#"><cfelse>null</cfif>,
                    DOcantidad      = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantidad,',','','all')#">,
                    DOcantsurtida   = <cfqueryparam cfsqltype="cf_sql_float" 		value="#Replace(Arguments.DOcantsurtida,',','','all')#">,
                    DOpreciou       = #LvarOBJ_PrecioU.enCF(Arguments.DOpreciou)#,
                    DOtotal         = <cfqueryparam cfsqltype="cf_sql_money" 		value="#Replace(DOtotal,',','','all')#">,
                    DOfechaes       = <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Arguments.DOfechaes)#">,
                    DOgarantia      = <cfqueryparam cfsqltype="cf_sql_integer"	value="#Replace(Arguments.DOgarantia,',','','all')#">,
                    CFid	        = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.CFid,',','','all')#">,
                    Icodigo	        = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.Icodigo)#">,
                    Ucodigo	        = <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.Ucodigo)#">,
                    DOfechareq      = <cfif len(trim(Arguments.DOfechareq)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(Arguments.DOfechareq)#"><cfelse>null</cfif>,
                    Ppais	        = <cfqueryparam cfsqltype="cf_sql_char"	    value="#Arguments.Ppais#">,
                    DOmontodesc     = <cfqueryparam cfsqltype="cf_sql_money"	    value="#Replace(Arguments.DOmontodesc,',','','all')#">,
                    DOporcdesc      = <cfqueryparam cfsqltype="cf_sql_float"	    value="#Replace(Arguments.DOporcdesc,',','','all')#">,
                    FPAEid	   	    = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#" 		  null="#Arguments.FPAEid EQ -1#">,
                    CFComplemento   = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CFComplemento#" null="#NOT LEN(TRIM(Arguments.CFComplemento))#">
                <cfif Arguments.DSlinea NEQ -1 and LEN(TRIM(Arguments.DSlinea))>
                    ,DSlinea        = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Replace(Arguments.DSlinea,',','','all')#">
                </cfif>
                <cfif Arguments.ESidsolicitud NEQ -1 AND LEN(TRIM(Arguments.ESidsolicitud))>
                    ,ESidsolicitud   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.ESidsolicitud,',','','all')#">
                </cfif>
                <!---JMRV. Inicio de cambio. 30/04/2014--->
                <cfif Arguments.CheckDistribucionHidden eq 1 and  Arguments.PlantillaDistribucion NEQ 0>
                    ,CPDCid			= <cfif Arguments.CMtipo eq "A" and Arguments.CheckDistribucionHidden eq 1><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PlantillaDistribucion#"><cfelse>0</cfif>
                </cfif>
				<!---JMRV. Fin de cambio. 30/04/2014--->
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.DOlinea,',','','all')#">
			  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.EOidorden,',','','all')#">
		</cfquery>

		<cfif getOrden.recordCount GT 0 >
			<!--- si el detalle viene de un contrato --->
			<cfif getOrden.CTDContid NEQ ''>
				<cfquery name="rsOrdenTC" datasource="#session.dsn#">
					select Mcodigo,EOtc from EOrdenCM where EOidorden = #Arguments.EOidorden#
				</cfquery>
				<cfset tcidorden = #rsOrdenTC.EOtc#>
                <cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round((CTDCmontoConsumido - #getOrden.DOtotal#) + #LSParseNumber(DOtotal)*tcidorden#,2)
					where CTDCont = #getOrden.CTDContid#
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="delete_DOrdenCM" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 				default="#session.Ecodigo#" type="numeric">
		<cfargument name="EOidorden" 			default="-1"  				type="numeric">
		<cfargument name="DOlinea" 				default="-1"  				type="numeric">

        <cfquery name="getOrden" datasource="#session.DSN#">
			select * from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
        </cfquery>
        <cftransaction>
        <cfif getOrden.recordCount GT 0 >
			<!--- si el detalle viene de un contrato --->
			<cfif getOrden.CTDContid NEQ ''>
				<cfquery name="rsOrdenTC" datasource="#session.dsn#">
					select Mcodigo,EOtc from EOrdenCM where EOidorden = #Arguments.EOidorden#
				</cfquery>
				<cfset tcidorden = #rsOrdenTC.EOtc#>
                <cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) - #getOrden.DOtotal*tcidorden#,2)
					where CTDCont = #getOrden.CTDContid#
				</cfquery>
			</cfif>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from DOrdenCM
			where DOlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DOlinea#">
			  and EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.EOidorden#">
		</cfquery>
		</cfif>
        </cftransaction>
	</cffunction>

	<cffunction name="calculaTotalesEOrdenCM" access="public" output="no">
		<cfargument name="EOidorden" 			required="yes" 	type="numeric">
		<cfargument name="Ecodigo" 				required="no" 	type="numeric" default="#session.Ecodigo#">
		<cfargument name="CalcularSinImpuestos" required="no" 	type="boolean" default="false">

		<!---►►Valida si existen lineas de detalle en la Orden de Compra◄◄--->
        <cfquery datasource="#session.DSN#" name="Lineas">
			select count(1) cantidad
            	from DOrdenCM
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
        <!---►►Si NO existen lineas en la OC, se Actualiza el total, el impuesto y descuento del encabezado en cero◄◄--->
        <cfif NOT Lineas.cantidad>
        	 <cfquery name="updateMonto" datasource="#Session.DSN#">
                    update EOrdenCM set
                     	EOtotal	 = 0,
                        Impuesto = 0,
                        EOdesc	 = 0
                    where EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>
        <!---►►Si existen lineas en la OC, se Actualiza el total, el impuesto y descuento del encabezado con el calculo correspondiente◄◄--->
       <cfelse>
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOmontodesc = 0
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			   and DOmontodesc IS NULL
		</cfquery>

		<!---
			Si se ha mandado DOtotal con Impuesto Incluido, se recalcula sin impuestos
		--->
		<cfif Arguments.CalcularSinImpuestos>
			<cfquery datasource="#session.DSN#">
				update DOrdenCM
				   set DOtotal = DOtotal / (1-DOporcdesc/100) /
				   				( 1 +
										coalesce((
											select i.Iporcentaje/100
											  from Impuestos i
											 where i.Ecodigo = DOrdenCM.Ecodigo
											   and i.Icodigo = DOrdenCM.Icodigo
											   and i.Icompuesto = 0
											   and i.Icreditofiscal = 0
										),0)
										+
										coalesce((
											select di.DIporcentaje/100
											  from DOrdenCM d
												inner join Impuestos i
												 on i.Ecodigo = d.Ecodigo
												and i.Icodigo = d.Icodigo
												inner join DImpuestos di
												 on di.Ecodigo	= i.Ecodigo
												and di.Icodigo	= i.Icodigo
											 where d.Ecodigo	= DOrdenCM.Ecodigo
											   and d.EOidorden	= DOrdenCM.EOidorden
											   and i.Icompuesto	= 1
											   and di.DIcreditofiscal	= 0
										),0)
								)
				 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update DOrdenCM
				   set DOpreciou	= DOtotal / DOcantidad
				   	 , DOmontodesc 	= round(DOtotal * DOporcdesc/100,2)
				 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>
		</cfif>

		<!---
			Calcula y separa los impuestos asignados al Costo y los de Credito Fiscal
		--->
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOimpuestoCosto =
				coalesce((
			select
			  case when (DOrdenCM.CMtipo = 'S' or DOrdenCM.CMtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			     round( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * i.Iporcentaje/100,2)
			  else
			     round((round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) + round(ROUND(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * COALESCE(d.ValorCalculo/100,0),2)) * i.Iporcentaje/100,2)
			  end as baseIVA
					  from Impuestos i
					  left join Impuestos d
						on  DOrdenCM.Ecodigo=d.Ecodigo
					    and DOrdenCM.codIEPS=d.Icodigo
					  left join Conceptos e
						on e.Cid = DOrdenCM.Cid
					  left join Articulos f
						on f.Aid= DOrdenCM.Aid
					 where i.Ecodigo = DOrdenCM.Ecodigo
					   and i.Icodigo = DOrdenCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 0
				),0)
				+
				coalesce((
				  select
					sum(case when (d.CMtipo = 'S' or d.CMtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
					     round( round(d.DOtotal-d.DOmontodesc,2) * di.DIporcentaje/100,2)
					else
					     round((round(d.DOtotal-d.DOmontodesc,2) + round(ROUND(d.DOtotal-d.DOmontodesc,2) * COALESCE(dp.ValorCalculo/100,0),2)) * di.DIporcentaje/100,2)
					end) as baseIVA
					  from DOrdenCM d
						inner join Impuestos i
						 on i.Ecodigo = d.Ecodigo
						and i.Icodigo = d.Icodigo
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
						left join Impuestos dp
						 on  d.Ecodigo=dp.Ecodigo
					     and d.codIEPS=dp.Icodigo
					    left join Conceptos e
						 on e.Cid = d.Cid
					  	left join Articulos f
						 on f.Aid= d.Aid
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal	= 0
				),0)
				 , DOimpuestoCF =
				coalesce((
					select
					 case when (DOrdenCM.CMtipo = 'S' or DOrdenCM.CMtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
					    round( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * i.Iporcentaje/100,2)
					 else
					    round((round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) + round(ROUND(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * COALESCE(d.ValorCalculo/100,0),2)) * i.Iporcentaje/100,2)
					 end as baseIVA
					  from Impuestos i
					  left join Impuestos d
						on  DOrdenCM.Ecodigo=d.Ecodigo
					    and DOrdenCM.codIEPS=d.Icodigo
					  left join Conceptos e
						on e.Cid = DOrdenCM.Cid
					  left join Articulos f
						on f.Aid= DOrdenCM.Aid
					 where i.Ecodigo = DOrdenCM.Ecodigo
					   and i.Icodigo = DOrdenCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 1
				),0)
				+
				coalesce((
					select
					  sum(case when (d.CMtipo = 'S' or d.CMtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
						    round( round(d.DOtotal-d.DOmontodesc,2) * di.DIporcentaje/100,2)
					  else
						    round((round(d.DOtotal-d.DOmontodesc,2) + round(ROUND(d.DOtotal-d.DOmontodesc,2) * COALESCE(dp.ValorCalculo/100,0),2)) * di.DIporcentaje/100,2)
					  end) as baseIVA
					  from DOrdenCM d
						inner join Impuestos i
						 on i.Ecodigo = d.Ecodigo
						and i.Icodigo = d.Icodigo
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
						left join Impuestos dp
						 on  d.Ecodigo=dp.Ecodigo
					     and d.codIEPS=dp.Icodigo
					    left join Conceptos e
						 on e.Cid = d.Cid
					  	left join Articulos f
						 on f.Aid= d.Aid
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal	= 1
				),0)
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>

		<!---
			Calcula el valor del ieps
		--->
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOMontIeps =
				coalesce((
			select
			     round((round(ROUND(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * COALESCE(d.ValorCalculo/100,0),2)),2)
					 from Impuestos d
					 where d.Ecodigo = DOrdenCM.Ecodigo
					   and d.Icodigo = DOrdenCM.codIEPS
					   and d.Icompuesto = 0
					   and d.Icreditofiscal = 0
				),0)
				+
				coalesce((
				  select
					sum(round((round(ROUND(d.DOtotal-d.DOmontodesc,2) * COALESCE(i.ValorCalculo/100,0),2)),2))
					  from DOrdenCM d
						inner join Impuestos i
						 on  i.Ecodigo = d.Ecodigo
						 and i.Icodigo = d.codIEPS
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal = 0
				),0)
				,DOMontIepsCF =
				coalesce((
					select
					    round((round(ROUND(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * COALESCE(d.ValorCalculo/100,0),2)),2)
					  from Impuestos d
					 where d.Ecodigo = DOrdenCM.Ecodigo
					   and d.Icodigo = DOrdenCM.codIEPS
					   and d.Icompuesto = 0
					   and d.Icreditofiscal = 1
				),0)
				+
				coalesce((
					select
					  sum(round((round(ROUND(d.DOtotal-d.DOmontodesc,2) * COALESCE(i.ValorCalculo/100,0),2)),2))
					  from DOrdenCM d
						inner join Impuestos i
						 on i.Ecodigo = d.Ecodigo
						and i.Icodigo = d.codIEPS
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal	= 1
				),0)
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			 and Ecodigo=#session.ecodigo#
		</cfquery>

		<!---
			Ajusta Impuesto por redondeo
		--->
		<cfquery name="rsRedondeoOC" datasource="#session.DSN#">
			select 	round(sum(DOrdenCM.DOimpuestoCosto),2)	as DOimpuestoCosto,
					sum(round(DOrdenCM.DOimpuestoCosto,2))	as DOimpuestoCosto2,

					round(sum(DOrdenCM.DOimpuestoCF),2)		as DOimpuestoCF,
					sum(round(DOrdenCM.DOimpuestoCF,2))		as DOimpuestoCF2,

					max(coalesce(DOrdenCM.DOimpuestoCosto,0)+coalesce(DOrdenCM.DOimpuestoCF,0))	as MaxImpuesto
			 from DOrdenCM
			where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select coalesce(min(DOlinea),0) as DOlinea
			  from DOrdenCM
			 where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			   and coalesce(DOrdenCM.DOimpuestoCosto,0)+coalesce(DOrdenCM.DOimpuestoCF,0) = #rsRedondeoOC.MaxImpuesto#
		</cfquery>
		<cfset LvarAjusteICosto = round((rsRedondeoOC.DOimpuestoCosto - rsRedondeoOC.DOimpuestoCosto2)*100)/100>
		<cfset LvarAjusteICF = round((rsRedondeoOC.DOimpuestoCF - rsRedondeoOC.DOimpuestoCF2)*100)/100>
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOimpuestoCosto =
						round(DOimpuestoCosto,2)
					<cfif LvarAjusteICosto NEQ 0>
						+ case when DOlinea = #rsSQL.DOlinea# then
							#LvarAjusteICosto#
							else 0
						  end
					</cfif>
					,DOimpuestoCF =
						round(DOimpuestoCF,2)
					<cfif LvarAjusteICF NEQ 0>
						+ case when DOlinea = #rsSQL.DOlinea# then
							#LvarAjusteICF#
							else 0
						  end
					</cfif>
			 where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>


		<!---
			Se calcula los Totales de la orden
		--->
		<cfquery name="rsTotalesOC" datasource="#session.DSN#">
			select 	coalesce(sum( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) ),0)	as TotalLineas,
					coalesce(sum(DOrdenCM.DOimpuestoCosto + DOrdenCM.DOimpuestoCF),0)	as TotalImpuestos,
					coalesce(sum(round(DOrdenCM.DOMontIeps + DOrdenCM.DOMontIepsCF,2)),0) as TotalIeps,
					coalesce(sum(coalesce(DOmontodesc,0)),0) 							as TotalDescuentos
			 from DOrdenCM
			where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
		<cfquery name="updateMonto" datasource="#Session.DSN#">
			update EOrdenCM
			   set EOtotal	= #rsTotalesOC.TotalLineas# + #rsTotalesOC.TotalImpuestos# + #rsTotalesOC.TotalIeps#,
				   Impuesto	= #rsTotalesOC.TotalImpuestos#,
				   EOTiEPS  = #rsTotalesOC.TotalIeps#,
				   EOdesc	= #rsTotalesOC.TotalDescuentos#
			where EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
     </cfif>
	</cffunction>

	<cffunction name="esMultiperiodo" access="private" output="no" returntype="boolean">
		<!--- En LvarEOidorden viene la OC padre, si es multiperiodo se debe colocar la hija para seguir el proceso --->

		<!----Consulto si en los detalles de la orden de compra son de plan de compra------>
		<cfquery name="rsDatosOrdenCM" datasource="#session.DSN#">
				Select count(1) as CantLineas
				  from  DOrdenCM d
					inner join PCGDplanComprasMultiperiodo m
					on m.PCGDid = d.PCGDid
				 where d.EOidorden = #LvarEOidorden#
				   and m.PCGDautorizadoFuturos > 0
		</cfquery>
		<cfif rsDatosOrdenCM.CantLineas EQ 0>
			<cfreturn false>
		</cfif>

		<!------Pongo el estado 101 especial de "Aprobado Multiperiodo" a la orden Completa------>
		<cfquery name="rsLinea" datasource="#session.DSN#">
			update EOrdenCM
			set EOestado    = 101,
				fechamod    = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where EOidorden = #LvarEOidorden#
		</cfquery>

		<cfquery name="rsCMEorden" datasource="#session.DSN#">
			select
			   EOidorden,
			   Ecodigo,
			   EOnumero,
			   SNcodigo,
			   CMCid,
			   Mcodigo,
			   Rcodigo,
			   CMTOcodigo,
			   CMFPid,
			   CMIid,
			   EOfecha,
			   Observaciones,
			   EOtc,
			   EOrefcot,
			   Impuesto,
			   EOdesc,
			   EOtotal,
			   Usucodigo,
			   EOfalta,
			   Usucodigomod,
			   fechamod,
			   EOplazo,
			   NAP,
			   NRP,
			   NAPcancel,
			   EOporcanticipo,
			   EOestado,
			   EOImpresion,
			   ETidtracking,
			   EOjustificacion,
			   CRid,
			   EOtipotransporte,
			   EOlugarentrega,
			   EOdiasEntrega
			  from EOrdenCM
			 where EOidorden = #LvarEOidorden#
		</cfquery>
		<!---------Envio a insertar la copia (hija) del encabezado-------------->

		<cfset LvarSecuenciaAno1 = 1>

		<cfquery name="insert" datasource="#session.DSN#">
			insert into EOrdenCM ( 	Ecodigo, EOnumero, EOsecuencia,
									SNcodigo, CMTOcodigo, CMCid, Mcodigo, Rcodigo, EOfecha, Observaciones, EOtc, EOrefcot,
									Usucodigo, EOplazo, EOfalta, EOporcanticipo,EOestado, CMFPid, CMIid, EOdiasEntrega, EOtipotransporte, EOlugarentrega, CRid, BMUsucodigo,
									EOtotal, EOdesc, Impuesto
									)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsCMEorden.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCMEorden.EOnumero#">,
				#LvarSecuenciaAno1#,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsCMEorden.SNcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsCMEorden.CMTOcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCMEorden.CMCid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCMEorden.Mcodigo#">,
				<cfif rsCMEorden.Rcodigo neq '-1' and len(trim(rsCMEorden.Rcodigo)) ><cfqueryparam cfsqltype="cf_sql_char"	value="#rsCMEorden.Rcodigo#"><cfelse>null</cfif>,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCMEorden.EOfecha#">,
				<cfif len(trim(rsCMEorden.Observaciones)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCMEorden.Observaciones#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_float" 		value="#rsCMEorden.EOtc#">,
				<cfif len(trim(rsCMEorden.EOrefcot)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsCMEorden.EOrefcot#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsCMEorden.EOplazo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
				<cfif isdefined("rsCMEorden.EOporcanticipo") and Len(Trim(rsCMEorden.EOporcanticipo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMEorden.EOporcanticipo#" scale="2"><cfelse>null</cfif>,
				10,<!---- Estado= Aprobado ----->
				<cfif isdefined("rsCMEorden.CMFPid") and Len(Trim(rsCMEorden.CMFPid)) and rsCMEorden.CMFPid NEQ -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMEorden.CMFPid#"><cfelse>null</cfif>,
				<cfif  Len(Trim(rsCMEorden.CMIid)) gt 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMEorden.CMIid#"><cfelse>null</cfif>,
				<cfif Len(Trim(rsCMEorden.EOdiasEntrega)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMEorden.EOdiasEntrega#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCMEorden.EOtipotransporte#" null="#Len(Trim(rsCMEorden.EOtipotransporte)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCMEorden.EOlugarentrega#" null="#Len(Trim(rsCMEorden.EOlugarentrega)) EQ 0#">,
				<cfif Len(Trim(rsCMEorden.CRid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMEorden.CRid#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				0,0,0
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfset LvarEOrdenPeriodo = insert.identity >


		<!---- Insercion de los detalles de la OC hija  ----->
		<cfquery  name="rsDOrdenCM" datasource="#Session.DSN#">
			update DOrdenCM
			   set DOporcdesc = 0
			 where EOidorden = #LvarEOidorden#
			   and DOporcdesc IS NULL
		</cfquery>
		<cfquery  name="rsDOrdenCM" datasource="#Session.DSN#">
			Select
					Ecodigo, EOidorden, EOnumero,
					DOconsecutivo, ESidsolicitud, DSlinea, CMtipo, Cid, Aid,
					Alm_Aid, ACcodigo,  ACid, CFid, Icodigo, Ucodigo, DClinea,
					CFcuenta, CAid, DOdescripcion, DOalterna, DOobservaciones,

					DOcantidad, DOcantsurtida,  DOpreciou, DOtotal,
					DOfechaes,
					DOgarantia, Ppais, DOfechareq, DOrefcot, ETidtracking,
					DOcantliq, DOjustificacionliq, Usucodigoliq, fechaliq,
					a.BMUsucodigo, DOmontodesc, DOporcdesc, numparte, DOcantexceso,
					DOimpuestoCosto, DOimpuestoCF, a.PCGDid, FPAEid, CFComplemento, OBOid,
					DOcontrolCantidad,DOmontoSurtido,

					m.PCGDid as Multiperiodo, m.PCGDcantidad, m.PCGDcostoOri
			from DOrdenCM a
				left join PCGDplanComprasMultiperiodo m
					on m.PCGDid = a.PCGDid
			  where EOidorden = #LvarEOidorden#
		</cfquery>

		<cfloop query="rsDOrdenCM">
			<cfquery name="InsertD" datasource="#Session.DSN#">
				insert into DOrdenCM (
					Ecodigo,
					EOidorden,
					EOnumero,
					EOsecuencia,
					DOconsecutivo,
					ESidsolicitud,
					DSlinea,
					CMtipo,
					Cid,
					Aid,
					Alm_Aid,
					ACcodigo,
					ACid,
					CFid,
					Icodigo,
					Ucodigo,
					DClinea,
					CFcuenta,
					CAid,
					DOdescripcion,
					DOalterna,
					DOobservaciones,
					DOcantsurtida,
					DOfechaes,
					DOgarantia,
					Ppais,
					DOfechareq,
					DOrefcot,
					ETidtracking,
					DOcantliq,
					DOjustificacionliq,
					Usucodigoliq,
					fechaliq,
					BMUsucodigo,
					numparte,
					DOcantexceso,
					PCGDid,
					FPAEid,
					CFComplemento,
					OBOid,
					DOcontrolCantidad,
					DOporcdesc,
					DOmontoSurtido,

					DOimpuestoCosto,
					DOimpuestoCF,

					DOtotal,
					DOcantidad,
					DOpreciou,
					DOmontodesc
				)
				values
				(
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#rsDOrdenCM.Ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#LvarEOrdenPeriodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.EOnumero#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LvarSecuenciaAno1#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#rsDOrdenCM.DOconsecutivo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.ESidsolicitud#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.DSlinea#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.CMtipo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.Cid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.Aid#" 	null="#rsDOrdenCM.Aid EQ ''#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.Alm_Aid#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#rsDOrdenCM.ACcodigo#" voidnull>,

					<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#rsDOrdenCM.ACid#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.CFid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.Icodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.Ucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.DClinea#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#rsDOrdenCM.CFcuenta#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.CAid#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.DOdescripcion#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.DOalterna#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.DOobservaciones#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_float"     value="#rsDOrdenCM.DOcantsurtida#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsDOrdenCM.DOfechaes#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#rsDOrdenCM.DOgarantia#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.Ppais#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsDOrdenCM.DOfechareq#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.DOrefcot#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.ETidtracking#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_float"     value="#rsDOrdenCM.DOcantliq#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.DOjustificacionliq#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.Usucodigoliq#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsDOrdenCM.fechaliq#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.BMUsucodigo#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.numparte#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_float"     value="#rsDOrdenCM.DOcantexceso#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.PCGDid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.FPAEid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsDOrdenCM.CFComplemento#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsDOrdenCM.OBOid#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_bit"       value="#rsDOrdenCM.DOcontrolCantidad#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_float"     value="#rsDOrdenCM.DOporcdesc#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsDOrdenCM.DOmontoSurtido#">,
					0,0,

					<!--- Se determina si recalcular multiperiodo o copiar uniperiodo --->
					<cfif rsDOrdenCM.Multiperiodo EQ "" OR rsDOrdenCM.PCGDcostoOri EQ 0 OR rsDOrdenCM.DOtotal LTE rsDOrdenCM.PCGDcostoOri>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDOrdenCM.DOtotal#" scale="2">,
						<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#rsDOrdenCM.DOcantidad#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#rsDOrdenCM.DOpreciou#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#rsDOrdenCM.DOmontodesc#">
					<cfelse>
						<cfif rsDOrdenCM.PCGDcantidad EQ 0>
							<cfset LvarCant = 1>
						<cfelse>
							<cfset LvarCant = rsDOrdenCM.PCGDcantidad>
						</cfif>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDOrdenCM.PCGDcostoOri#" scale="2">,
						<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#LvarCant#">,
						0,0
					</cfif>
				)
			</cfquery>
		</cfloop>

		<!---Calcula Impuestos por Linea y luego Totales de Encabezado: EOtotal, EOdescuento e Impuestos del Encabezado--->
		<cfset calculaTotalesEOrdenCM (LvarEOrdenPeriodo, session.Ecodigo, true)>

		<!---Se seguira usando el ID de la Orden Hija, lo que se va a usar para el periodo--->
		<cfset LvarEOidorden = LvarEOrdenPeriodo>

		<cfreturn true>
	</cffunction>

    <cffunction name="fnMailBody" access="private" output="yes" returntype="string">
        <cfargument name="SNid" 	type="numeric" required="yes">
        <cfargument name="CMPid" 	type="numeric" required="yes">
        <cfargument name="Lineas" 	type="query" required="yes">

        <cfset rsLinea = Arguments.Lineas>

        <cfquery name="rsProcesoCompra" datasource="#Session.DSN#">
            select CMPid, CMPdescripcion, CMPnumero
            from CMProcesoCompra
            where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CMPid#">
        </cfquery>

        <cfsavecontent variable="_mail_body">
            <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
            <html><head>
            <title>Estado de las cotizaciones del Proceso de compra</title>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <style type="text/css">
            <!--
            .style1 {
                font-size: 10px;
                font-family: "Times New Roman", Times, serif;
            }
            .style2 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                font-size: 14;
            }
            .style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
            .style8 {font-size: 14}

            .style9 {font-size: 13}
            -->
            </style>
            </head>
            <body>

            <cfquery name="rsPara" datasource="#session.DSN#">
                select SNnombre
                from SNegocios
                where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
            </cfquery>
              <table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
                <tr bgcolor="##003399">
                  <td colspan="2" height="24"></td>
                </tr>
                <tr bgcolor="##999999">
                  <td colspan="2"> <strong>Estado de las cotizaciones del Proceso de compra</strong> </td>
                </tr>
                <tr>
                  <td width="70">&nbsp;</td>
                  <td width="476">&nbsp;</td>
                </tr>
                <tr>
                  <td><span class="style2">De</span></td>
                  <td><span class="style7"><cfoutput>#session.Enombre#</cfoutput></span></td>
                </tr>

                <tr>
                  <td><span class="style7"><strong>Para</strong></span></td>
                  <td> <span class="style7"><cfoutput>#rsPara.SNnombre#</cfoutput></span></td>
                </tr>

                <tr>
                  <td><span class="style8"></span></td>
                  <td><span class="style8"></span></td>
                </tr>

                <tr>
                  <td><span class="style7"><strong>Asunto</strong></span></td>
                  <td>
                    <span class="style7">Estado de las cotizaciones del Proceso de compra.</span>
                  </td>
                </tr>

                <tr>
                  <td colspan="2">
                    <table border="0" width="100%" cellpadding="2" cellspacing="0" >
                        <tr>
                            <td width="1%" nowrap><span class="style8"><strong>Num. Proceso de Compra:&nbsp;</strong></span></td>
                            <td align="left"><span class="style8"><cfoutput>#rsProcesoCompra.CMPnumero#</cfoutput></span></td>
                        </tr>
                        <tr>
                            <td width="1%" nowrap><span class="style8"><strong>Descripci&oacute;n de Proceso de Compra:&nbsp;</strong></span></td>
                            <td align="left"><span class="style8"><cfoutput>#rsProcesoCompra.CMPdescripcion#</cfoutput></span></td>
                        </tr>
                        <cfoutput query="rsLinea" group="Ganadora">
                        	<cfoutput group="ECid">
                            	<cfquery name="rsCotizacion" datasource="#session.DSN#">
                                    select ECconsecutivo, ECdescprov
                                    from ECotizacionesCM
                                    where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.ECid#">
                               	</cfquery>
                                <tr>
                                    <td width="1%" nowrap><span class="style8"><strong>Consecutivo Cotizaci&oacute;n:&nbsp;</strong></span></td>
                                    <td align="left"><span class="style8">#rsCotizacion.ECconsecutivo#</span></td>
                                </tr>
                                <tr>
                                    <td width="1%" nowrap><span class="style8"><strong>Descripci&oacute;n Cotizaci&oacute;n:&nbsp;</strong></span></td>
                                    <td align="left"><span class="style8">#rsCotizacion.ECdescprov#</span></td>
                                </tr>
								<cfoutput>
                                	<tr><td colspan="2" nowrap><span class="style8"><strong><cfif rsLinea.Ganadora>Lineas Adjudicadas<cfelse>Lineas No Adjudicadas</cfif></strong></span></td></tr>
                                    <cfquery name="rsDetalleLinea" datasource="#session.DSN#">
                                        select case ds.DStipo
                                                when'A' then coalesce(ltrim(rtrim(a.Acodigo)) #_Cat# '-' #_Cat# a.Adescripcion,' ')
                                                when 'S' then coalesce(ltrim(rtrim(c.Ccodigo)) #_Cat# '-' #_Cat# c.Cdescripcion,' ')
                                                when 'F' then coalesce(ac.ACdescripcion #_Cat# '/' #_Cat# acl.ACdescripcion,' ')
                                            end as Descripcion
                                            from DCotizacionesCM dc
                                                inner join ECotizacionesCM ec
                                                    on ec.ECid = dc.ECid
                                                inner join DSolicitudCompraCM ds
                                                    on ds.DSlinea = dc.DSlinea
                                                left outer join Articulos a
                                                    on a.Aid = ds.Aid
                                                left outer join Conceptos c
                                                    on c.Cid = ds.Cid
                                                left outer join ACategoria ac
                                                    on ac.Ecodigo = ds.Ecodigo and ac.ACcodigo = ds.ACcodigo
                                                left outer join AClasificacion acl
                                                    on acl.Ecodigo = ac.Ecodigo and acl.ACcodigo = ac.ACcodigo and acl.ACid = ds.ACid
                                        where dc.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalles.DClinea#">
                                    </cfquery>
                                    <tr>
                                        <td colspan="2" nowrap><span class="style8"><strong>Item:</strong>&nbsp;#rsDetalleLinea.Descripcion#</span></td>
                                    </tr>
                                </cfoutput>
                          	</cfoutput>
                        </cfoutput>
                        <tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
                    </table>
                  </td>
                </tr>
                <cfset hostname = session.sitio.host>
                <cfset Usucodigo = session.Usucodigo>
                <cfset CEcodigo = session.CEcodigo>
               <!--- <cfoutput>
                <tr>
                  <td>&nbsp;</td>
                  <td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
                  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
                </tr>
                </cfoutput>--->
              </table>
            </body>
            </html>
        </cfsavecontent>

        <cfreturn _mail_body >
    </cffunction>
</cfcomponent>


