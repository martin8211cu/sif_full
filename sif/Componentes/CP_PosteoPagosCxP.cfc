<cfcomponent>
	<cffunction name="PosteoPagos" access="public" returntype="string" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false'>
		<cfargument name='PintaAsiento' type="boolean" 	required='false' default='false'>

		<!--- Definicion de variables ---->
		<cfset var lin = 0>
		<cfset var Periodo = 0>
		<cfset var Mes = 0>
		<cfset var Fecha = ''>
		<cfset var EPfecha = ''>
		<cfset var descripcion =''>
		<cfset var Monloc =0>

		<cfset var Ocodigo =0>
		<cfset var EPdocumento =''>
		<cfset var CPTcodigo =''>
		<cfset var IDcontable =0>
		<cfset var CuentaRet =0>
		<cfset var error =0>
		<cfset var EPtotal =0>
		<cfset var EPtipocambio =0>
		<cfset var MontoEnc =0.00>
		<cfset var MontoDet =0.00>
		<cfset var CuentaPuente =0>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

		<cfset LvarPintar = Arguments.PintaAsiento>

		<cfset LvarFechaLinea = "#dateformat(now(), "YYYYMMDD")#">
		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
		<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoEncabezado" returnvariable="rsPagos">
			<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
			<cfinvokeargument name="IDpago"       	value="#Arguments.IDpago#">
		</cfinvoke>

<!---==================VALIDACIONES ANTES DE INICIAR=================================--->

<!---Valida que el Anticipo no exista en en Histórico de Documentos de CxP, busca por HEDocumentosCP_AK01 (SNcodigo, Ddocumento, CPTcodigo, Ecodigo)--->
		<cfquery name="rsValidaH" datasource="#Arguments.Conexion#">
			select Anti.NC_CPTcodigo, Anti.NC_Ddocumento
			 from EPagosCxP a
				inner join APagosCxP Anti
					on a.IDpago = Anti.IDpago
				inner join HEDocumentosCP b
					 on b.SNcodigo   = a.SNcodigo
					and b.Ddocumento = Anti.NC_Ddocumento
					and b.CPTcodigo  = Anti.NC_CPTcodigo
					and b.Ecodigo  	 = a.Ecodigo
			 where a.IDpago = #Arguments.IDpago#
		</cfquery>
		<cfif isdefined("rsValidaH") and rsValidaH.recordcount gt 0>
				<cfset ErrorAnti = ''>
			<cfloop query="rsValidaH">
				<cfset ErrorAnti &= rsValidaH.NC_CPTcodigo &' '& rsValidaH.NC_Ddocumento &','>
			</cfloop>
				<cfthrow message="Los siguiente Anticipos ya existen en el histórico de Documentos de CxP(HEDocumentosCP):<br>" detail="#mid(ErrorAnti,1,len(ErrorAnti)-1)#">
		</cfif>
<!---Valida que el Anticipo no exista en los Documentos de CxP, busca por EDocumentosCP_AK01  SNcodigo, Ddocumento, CPTcodigo, Ecodigo--->
		<cfquery name="rsValida" datasource="#Arguments.Conexion#">
			select Anti.NC_CPTcodigo, Anti.NC_Ddocumento
			 from EPagosCxP a
				inner join APagosCxP Anti
					on a.IDpago = Anti.IDpago
				inner join EDocumentosCP b
					 on b.SNcodigo   = a.SNcodigo
					and b.Ddocumento = Anti.NC_Ddocumento
					and b.CPTcodigo  = Anti.NC_CPTcodigo
					and b.Ecodigo  	 = a.Ecodigo
			 where a.IDpago = #Arguments.IDpago#
		</cfquery>
		<cfif isdefined("rsValida") and rsValida.recordcount gt 0>
				<cfset ErrorAnti = ''>
			<cfloop query="rsValida">
				<cfset ErrorAnti &= rsValida.NC_CPTcodigo &' '& rsValida.NC_Ddocumento &','>
			</cfloop>
				<cfthrow message="Los siguiente Anticipos ya existen en los Documentos CxP(EDocumentosCP):<br>" detail="#mid(ErrorAnti,1,len(ErrorAnti)-1)#">
		</cfif>
<!---=======Valida que exista el Encabezado del Pago=======--->
		<cfquery name="ExistePagoE" datasource="#Arguments.Conexion#">
			select 1
			from EPagosCxP
			where IDpago =#Arguments.IDpago#
			and Ecodigo  =  #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("ExistePagoE") and ExistePagoE.RecordCount EQ 0>
			<cf_errorCode	code = "51166" msg = "El documento de pago indicado no existe! Proceso Cancelado!">
		</cfif>

<!---=======Valida que Exista la moneda local de la empresa=======--->
		<cfquery name="rsMonloc" datasource="#Arguments.Conexion#">
			select Mcodigo
			from Empresas
			where Ecodigo =  #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("rsMonloc") and rsMonloc.RecordCount GT 0>
			<cfset Monloc =  rsMonloc.Mcodigo>
		<cfelse>
			<cf_errorCode	code = "51167" msg = "Error en CP_PosteoPagosCxP. No se ha definido la Moneda de la Empresa. Proceso Cancelado!">
		</cfif>

<!----=======Valida que exista el Periodo Auxiliar=======--->
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
			from Parametros
			Where Ecodigo =  #Arguments.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 50
		</cfquery>
		<cfif isdefined("rsPeriodo") and rsPeriodo.RecordCount GT 0>
			<cfset Periodo =  rsPeriodo.Periodo>
		<cfelse>
			<cfthrow message="La empresa no tiene definido un Periodo Auxiliar">
		</cfif>

<!----=======Valida que exista el Mes Auxiliar=======--->
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
			from Parametros
			Where Ecodigo =  #Arguments.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 60
		</cfquery>
		<cfif isdefined("rsMes") and rsMes.RecordCount GT 0>
			<cfset Mes =  rsMes.Mes>
		<cfelse>
			<cfthrow message="La empresa no tiene definido un Mes Auxiliar">
		</cfif>
<!---=======Valida que este balancedo (Monto Total Pago = Monto de las lineas + monto de Anticipos)=======--->
		<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoTotales" returnvariable="rsDisponible">
			<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
			<cfinvokeargument name="IDpago"       	value="#Arguments.IDpago#">
		</cfinvoke>
		<cfif isdefined('rsDisponible') and rsDisponible.DisponibleAnticipos NEQ 0.00>
			<cf_errorCode	code = "51169" msg = "El Recibo de Pago no está Balanceado! Proceso Cancelado!">
		</cfif>

		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>
		<cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#Arguments.Conexion#"></cfinvoke>

		<!----======= valida si hay que concatenar el Socio de Negocio a las polizas  =======--->
		<cfquery name="rsConcatenar" datasource="#Arguments.Conexion#">
			select coalesce(Pvalor,'0') as valor
			from Parametros
			Where Ecodigo =  #Arguments.Ecodigo#
				and Pcodigo = 2920
		</cfquery>
		<cfif rsConcatenar.valor eq '1'>
			<cfset LvarSocioNegocio ="-SN:#rsPagos.SNnumero#">
		<cfelse>
			<cfset LvarSocioNegocio ="">
		</cfif>

		<!--- Si existe configurado un Repositorio de CFDIs --->
		<cfquery name="getContE" datasource="#Session.DSN#">
			select ERepositorio from Empresa
			where Ereferencia = #Session.Ecodigo#
		</cfquery>

		<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
			<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
			<cfset request.repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>
			<cfset request.repodbname = "">
		<cfelse>
			<cfset request.repodbname = "">
		</cfif>

		<cftransaction>
			<!--- Carga de Variables>	---->
			<cfset lin = 1>
            <cfset error = 0>
            <cfset Fecha = Now()>
            <cfset MontoEnc = 0.00>
            <cfset MontoDet = 0.00>

            <!---- Carga de la  CuentaRet --->
            <cfquery name="rsCuentaRet" datasource="#Arguments.Conexion#">
                select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaRet
                from Parametros
                where Ecodigo =  #Arguments.Ecodigo#
                  and Pcodigo = 150
                  and Mcodigo = 'GN'
            </cfquery>
            <cfif isdefined("rsCuentaRet") and rsCuentaRet.RecordCount GT 0>
                <cfset CuentaRet =  rsCuentaRet.CuentaRet>
            </cfif>

            <!---- Carga de la  CuentaPuente --->
            <cfquery name="rsCuentaPuente" datasource="#Arguments.Conexion#">
                select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaPuente
                from Parametros
                where Ecodigo =  #Arguments.Ecodigo#
                  and Pcodigo = 200
                  and Mcodigo = 'CG'
            </cfquery>
            <cfif isdefined("rsCuentaPuente") and rsCuentaPuente.RecordCount GT 0>
                <cfset CuentaPuente =  rsCuentaPuente.CuentaPuente>
            </cfif>

            <!---- Carga de las variables --->
            <cfquery name="rsEPagosCxP" datasource="#Arguments.Conexion#">
                select
                    a.EPfecha,
                    a.Ocodigo,
                    a.Mcodigo,
                    <cf_dbfunction name="concat" args="'Pagos CxP: ', a.EPdocumento"> as Pagos,
                    a.CPTcodigo,
                    a.EPdocumento,
                    round(a.EPtotal * a.EPtipocambio,2) as Conversion,
                    a.EPtipocambio,
                    a.EPtotal
                from EPagosCxP a
                where a.IDpago =#Arguments.IDpago#
            </cfquery>
            <cfif isdefined("rsEPagosCxP") and rsEPagosCxP.RecordCount GT 0>
                <cfset EPfecha 		= rsEPagosCxP.EPfecha>
                <cfset Ocodigo 		= rsEPagosCxP.Ocodigo>

                <cfset descripcion 	= "Pagos CxP: "&rsPagos.CPTcodigo&" "&rsPagos.EPdocumento>
                <cfset CPTcodigo 	= rsEPagosCxP.CPTcodigo>
                <cfset EPdocumento 	= rsEPagosCxP.EPdocumento>
                <cfset EPtotal 		= rsEPagosCxP.Conversion>
                <cfset EPtipocambio = rsEPagosCxP.EPtipocambio>
                <cfif len(rsEPagosCxP.EPtotal) and rsEPagosCxP.EPtotal NEQ 0.00>
                    <cfset MontoEnc = rsEPagosCxP.EPtotal>
                </cfif>

            </cfif>

            <!---- Carga de el  MontoDet --->
            <cfquery name="rsMontoDet" datasource="#Arguments.Conexion#">
                select sum(DPtotal) as DPtotal
                from DPagosCxP
                where Ecodigo =  #Arguments.Ecodigo#
                and IDpago    =#Arguments.IDpago#
            </cfquery>
            <cfif rsMontoDet.recordcount and len(rsMontoDet.DPtotal) and rsMontoDet.DPtotal neq 0.00>
                <cfset MontoDet =  rsMontoDet.DPtotal>
            </cfif>

			<!--- Control de Evento---->

            <cfinvoke component="sif.Componentes.CG_ControlEvento"
                method	 ="ValidaEvento"
                Origen	 ="CPRE"
                Transaccion="#rsEPagosCxP.CPTcodigo#"
                Conexion	="#Arguments.conexion#"
                Ecodigo		="#Arguments.Ecodigo#"
                returnvariable	= "varValidaEvento"
            />
            <cfset varNumeroEvento = "">
            <cfif varValidaEvento GT 0>
                <cfinvoke component="sif.Componentes.CG_ControlEvento"
                    method		= "CG_GeneraEvento"
                    Origen		= "CPRE"
                    Transaccion	= "#rsEPagosCxP.CPTcodigo#"
                    Documento 	= "#rsEPagosCxP.EPdocumento#"
                    Conexion	= "#Arguments.Conexion#"
                    Ecodigo		= "#Arguments.Ecodigo#"
                    returnvariable	= "arNumeroEvento"
                />
                <cfif arNumeroEvento[3] EQ "">
                    <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                </cfif>
                <cfset varNumeroEvento = arNumeroEvento[3]>
				<cfset varIDEvento = arNumeroEvento[4]>
            	<!--- Genera la relacion con las Facturas Aplicadas --->
                <cfquery name="rsDocumentoPago" datasource="#Arguments.Conexion#">
                	select a.IDpago, a.IDLinea, a.Ecodigo, b.CPTcodigo, b.Ddocumento, b.SNcodigo
                    from DPagosCxP a
                    inner join DDocumentosCP b
                    on a.Ecodigo = b.Ecodigo and a.IDdocumento = b.IDdocumento
                    where a.IDpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
                </cfquery>
                <cfloop query="rsDocumentoPago">
                    <cfinvoke component="sif.Componentes.CG_ControlEvento"
                        method="CG_RelacionaEvento"
                        IDNEvento="#varIDEvento#"
                        Origen="CPFC"
                        Transaccion="#rsDocumentoPago.CPTcodigo#"
                        Documento="#rsDocumentoPago.Ddocumento#"
                        SocioCodigo="#rsDocumentoPago.SNcodigo#"
                        Conexion="#Arguments.Conexion#"
                        Ecodigo="#Arguments.Ecodigo#"
                        returnvariable="arRelacionEvento"
                    />
                    <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
						<cfset varNumeroEventoDP = arRelacionEvento[4]>
                    <cfelse>
                        <cfset varNumeroEventoDP = varNumeroEvento>
                    </cfif>
                    <cfquery datasource="#Arguments.Conexion#">
                    	update DPagosCxP
                        set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
                        where IDpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumentoPago.IDpago#">
                        and IDLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumentoPago.IDLinea#">
                    </cfquery>
            	</cfloop>
            </cfif>

				<!--- ****************************************************** --->
				<!---   Inserta monto pagado por intereses                   --->
				<!---   en la tabla ImpDocumentosCxPMov y ImpIEPSDocumentosCxPMov --->
				<!--- *********************************************************** --->
				<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="CP_Pago_InsertaImp">
					<cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="IDpago"		value="#Arguments.IDpago#"/>
					<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#"/>
					<cfinvokeargument name="EPeriodo" 	value="#Periodo#"/>
					<cfinvokeargument name="EMes" 		value="#Mes#"/>
				</cfinvoke>


				<!--- ****************************************************** --->
				<!---   DIFERENCIAL CAMBIARIO                                --->
				<!--- ****************************************************** --->
				<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="FN_DiferencialCambiario">
					<cfinvokeargument name="Ecodigo"   value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="IDpago"	   value="#arguments.IDpago#"/>
					<cfinvokeargument name="debug" 	   value="#arguments.debug#"/>
					<cfinvokeargument name="Conexion"  value="#arguments.Conexion#"/>
					<cfinvokeargument name="Periodo"   value="#Periodo#"/>
					<cfinvokeargument name="Mes" 	   value="#Mes#"/>
					<cfinvokeargument name="INTARC"    value="#INTARC#"/>
					<cfinvokeargument name="Monloc"    value="#Monloc#"/>
                    <cfinvokeargument name="NumeroEvento" value="#varNumeroEvento#"/>
				</cfinvoke>


				<!--- *************************************************************************************** --->
				<!---   traslado de monto de la cuenta (Facturas Cliente ) a (Facturas Cliente Acreditadas)    --->
				<!--- *************************************************************************************** --->
				<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="FN_trasladoCuenta_IVA">
					<cfinvokeargument name="Ecodigo" 	value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="IDpago"		value="#arguments.IDpago#"/>
					<cfinvokeargument name="debug" 		value="#arguments.debug#"/>
					<cfinvokeargument name="Conexion" 	value="#arguments.Conexion#"/>
					<cfinvokeargument name="Periodo" 	value="#Periodo#"/>
					<cfinvokeargument name="Mes" 		value="#Mes#"/>
					<cfinvokeargument name="INTARC" 	value="#INTARC#"/>
					<cfinvokeargument name="Monloc" 	value="#Monloc#"/>
                    <cfinvokeargument name="NumeroEvento" value="#varNumeroEvento#"/>
				</cfinvoke>

				<!---Actuliza el monto pagado del documento--->
				<cfquery name="DPagosCxP" datasource="#Arguments.Conexion#">
					select Ecodigo,IDdocumento,a.DPmontodoc, a.DPmontoretdoc
					from  DPagosCxP  a
					where a.Ecodigo =  #Arguments.Ecodigo#
					and a.IDpago    =#Arguments.IDpago#
				</cfquery>
				<cfloop query="DPagosCxP">
					<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="CP_Pago_ActualizaImp">
						<cfinvokeargument name="IDdocumento"	value="#DPagosCxP.IDdocumento#"/>
						<cfinvokeargument name="Ecodigo" 		value="#DPagosCxP.Ecodigo#"/>
						<cfinvokeargument name="MontoDoc"		value="#DPagosCxP.DPmontodoc#"/>
						<cfinvokeargument name="RetDoc" 		value="#DPagosCxP.DPmontoretdoc#"/>
						<cfinvokeargument name="Conexion" 		value="#arguments.Conexion#"/>
					</cfinvoke>
				</cfloop>

					<!--- 2) Asiento Contable: Crédito: Bancos --->
					<cf_dbfunction name="sPart" args="b.CBcodigo,1,50"	returnvariable="CBcodigo">
					<cfquery name="rsInsertAsientoContBancos" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
							select
									'CPRE',
									1,
									<cf_dbfunction name="sPart"	args="a.EPdocumento,1,20">,
									<cf_dbfunction name="sPart"	args="a.CPTcodigo,1,2">,
									round(a.EPtotal * a.EPtipocambio,2),
									'C',
									<cf_dbfunction name="concat" args="'CxP: Bancos  ' + #CBcodigo#+'#LvarSocioNegocio#'" delimiters="+">,
									'#LvarFechaLinea#',
									a.EPtipocambio,
									#Periodo#,
									#Mes#,
									a.Ccuenta,
									a.Mcodigo,
									a.Ocodigo,
									a.EPtotal,
									'#varNumeroEvento#',a.CFid
								from EPagosCxP a
									inner join CuentasBancos b
										on b.CBid = a.CBid
								where a.IDpago = #Arguments.IDpago#
                                	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
					</cfquery>

    				<!--- 2b) Crédito : Cálculo de la Retención x Documento
						RET.COMP.: Aplico un factor de rd2.Rporcentaje / r.Rporcentaje sobre INTMON/INTMOE para distriguir las retenciones compuestas.
						N.B. Que en este insert no se redondea a dos dígitos INTMON/INTMOE, sino que está en un update posterior
					--->
					<cfquery name="antes_ret" datasource="#Arguments.Conexion#">
						select max(INTLIN) as INTLIN from #INTARC#
					</cfquery>
					<cf_dbfunction name="sPart" args="c.CPTcodigo,1,2"   returnvariable="CPTcodigo_sql">
					<cf_dbfunction name="sPart" args="c.Ddocumento,1,20" returnvariable="Ddocumento">

					<cfset LvarTCdoc = "
								case when round(a.DPmontodoc + a.DPmontoretdoc,2)!=0.00
									then
										round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * b.EPtipocambio,2)
										/round(a.DPmontodoc + a.DPmontoretdoc,2)
									else 1
								end "
					>

					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF,
												INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
												Mcodigo, INTCAM, INTMOE, INTMON, NumeroEvento,CFid
												)
						select
							'CPRE',
							1,
							#Ddocumento#,
							#CPTcodigo_sql#,

							'C',
							<cf_dbfunction name="concat"	args="'CxP: Retención Documento ' + #CPTcodigo_sql# + '-' + #Ddocumento#" delimiters="+">,
							'#LvarFechaLinea#',

							#Periodo#,
							#Mes#,
							coalesce(rd.Ccuentaretp, r.Ccuentaretp, #CuentaRet#),

							c.Ocodigo,

							<!--- Mcodigo, INTCAM, INTMOE, INTMON--->
							case
								when coalesce(r.Conta_MonOri,0) = 1
								then c.Mcodigo
								else #Monloc#
							end as Mcodigo,

							case
								when coalesce(r.Conta_MonOri,0) = 1
								then #LvarTCdoc#
								else 1
							end as INTCAM,

							round(
								case
									when coalesce(r.Conta_MonOri,0) = 1
									then
										a.DPmontoretdoc
									else
										round(a.DPmontoretdoc * #LvarTCdoc#,2)
									<!---RETENCION COMPUESTA--->
								end * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
							,2) as INTMOE,

							round(
							 	round(a.DPmontoretdoc * #LvarTCdoc#,2)
								 <!---RETENCION COMPUESTA--->
								 * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
							,2) as INTMON,
                            a.NumeroEvento,b.CFid

						from DPagosCxP a
							inner join EPagosCxP b
								on b.IDpago = a.IDpago
							inner join EDocumentosCP c
								on c.IDdocumento = a.IDdocumento
							inner join Retenciones r 		<!--- retencion documento (simple/comp) --->
								on r.Ecodigo = c.Ecodigo
								and r.Rcodigo = c.Rcodigo
							left outer join RetencionesComp rc
								on rc.Ecodigo = r.Ecodigo
								and rc.Rcodigo = r.Rcodigo
							left outer join Retenciones rd 	<!--- retencion hija --->
								on rd.Ecodigo = rc.Ecodigo
								and rd.Rcodigo = rc.RcodigoDet
						where b.IDpago =#Arguments.IDpago#
						  and b.Ecodigo =  #Arguments.Ecodigo#
					</cfquery>


					<cfquery name="despues_ret" datasource="#Arguments.Conexion#">
						select max(INTLIN) as INTLIN from #INTARC#
					</cfquery>

					<cfif antes_ret.INTLIN NEQ despues_ret.INTLIN>
						<!--- Ejecutar solamente si hubo retención
							El siguiente UPDATE modifica INTMON/INTMOE para redondearlo a dos dígitos, asumiendo la diferencia el primero de ellos.
							Para esto se utilizan subqueries sobre INTARC con el numero de linea INTLIN en el rango de insertados y el mismo INTDOC/INTREF.
						--->
						<cfquery datasource="#Arguments.Conexion#">
							update #INTARC#
							set INTMON = (round(INTMON,2) +
									round (case when exists (
										select 1 from #INTARC# c
										where c.INTLIN > #antes_ret.INTLIN#
										  and c.INTLIN <= #despues_ret.INTLIN#
										  and c.INTDOC = #INTARC#.INTDOC  <!--- mismo documento   --->
										  and c.INTREF = #INTARC#.INTREF  <!--- mismo tipo doc    --->
										  and c.INTLIN < #INTARC#.INTLIN) <!--- no es el primero  --->
									then
										0 <!--- no es el primero, no aplico redondeos --->
									else
										(select SUM(INTMON) - SUM(round(INTMON,2))
											from #INTARC# b
											where b.INTLIN > #antes_ret.INTLIN#
											  and b.INTLIN <= #despues_ret.INTLIN#
											  and b.INTDOC = #INTARC#.INTDOC  <!--- mismo documento   --->
											  and b.INTREF = #INTARC#.INTREF) <!--- mismo tipo doc    --->
									end, 2)),
							    INTMOE = (round(INTMOE,2) +
									round (case when exists (
										select 1 from #INTARC# c
										where c.INTLIN > #antes_ret.INTLIN#
										  and c.INTLIN <= #despues_ret.INTLIN#
										  and c.INTDOC = #INTARC#.INTDOC  <!--- mismo documento   --->
										  and c.INTREF = #INTARC#.INTREF  <!--- mismo tipo doc    --->
										  and c.INTLIN < #INTARC#.INTLIN) <!--- no es el primero  --->
									then
										0 <!--- no es el primero, no aplico redondeos --->
									else
										(select SUM(INTMOE) - SUM(round(INTMOE,2))
											from #INTARC# b
											where b.INTLIN > #antes_ret.INTLIN#
											  and b.INTLIN <= #despues_ret.INTLIN#
											  and b.INTDOC = #INTARC#.INTDOC  <!--- mismo documento   --->
											  and b.INTREF = #INTARC#.INTREF) <!--- mismo tipo doc    --->
									end, 2))
							where INTLIN >  #antes_ret.INTLIN#
							  and INTLIN <= #despues_ret.INTLIN#
						</cfquery>
					</cfif>
					<cf_dbfunction name="sPart"	args="b.Ddocumento,1,20" returnvariable="Ddocumento">

					<!---  2c) Débito: Documentos Afectados --->
					<cfquery name="rsInsertAsientoDocsAfectados" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
						select
							'CPRE',
							1,
							<cf_dbfunction name="sPart"	args="b.Ddocumento,1,20">,
							<cf_dbfunction name="sPart"	args="b.CPTcodigo,1,2">,
							case when coalesce(a.DPmontoretdoc,0.00) != 0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * c.EPtipocambio,2) else round(a.DPtotal * c.EPtipocambio,2) end,
							'D',
							<cf_dbfunction name="concat" args="'CxP: Pago Documento ' + ' ' + b.CPTcodigo + '-' + #Ddocumento#+'#LvarSocioNegocio#'" delimiters="+">,
							'#LvarFechaLinea#',
							case when round(a.DPmontodoc + a.DPmontoretdoc,2)!=0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * c.EPtipocambio,2)/round(a.DPmontodoc + a.DPmontoretdoc,2) else 1 end,
							#Periodo#,
							#Mes#,
							a.Ccuenta,
							b.Mcodigo,
							b.Ocodigo,
							round(a.DPmontodoc + a.DPmontoretdoc,2),
                            a.NumeroEvento, c.CFid
						from DPagosCxP a
							inner join EPagosCxP c
								on c.IDpago = a.IDpago
							inner join EDocumentosCP b
								on b.IDdocumento = a.IDdocumento
						where c.IDpago = #Arguments.IDpago#
					</cfquery>


					<!--- 2d) Débito: Anticipos --->
						<cfquery name="rsInsertAsientoAnticipos" datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta,  Ocodigo,Mcodigo,INTCAM,INTMON,INTMOE, NumeroEvento,CFid)
							select
								'CPRE',
								1,
								<cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20">,
								<cf_dbfunction name="sPart"	args="Anti.NC_CPTcodigo,1,2">,
								'D',
								<cf_dbfunction name="concat" args="'CxP:',Anti.NC_CPTcodigo,'-',Anti.NC_Ddocumento,'-',c.EPdocumento">,
								'#LvarFechaLinea#',
								#Periodo#,
								#Mes#,
								coalesce(Anti.NC_Ccuenta, <cf_dbfunction name="to_number" args="d.Pvalor">),
								c.Ocodigo,
								c.Mcodigo,
								case when c.Mcodigo != #Monloc# then c.EPtipocambio else 1 end,
								round(Anti.NC_total * c.EPtipocambio,2),
								Anti.NC_total,
                                '#varNumeroEvento#',c.CFid
							from EPagosCxP c
								inner join Parametros d
									on d.Ecodigo = c.Ecodigo
								inner join APagosCxP Anti
									on Anti.IDpago = c.IDpago
							where coalesce(Anti.NC_total,0.00) != 0.00
							  and c.IDpago = #Arguments.IDpago#
							  and c.Ecodigo =  #Arguments.Ecodigo#
							  and d.Pcodigo = 190
						</cfquery>

                    <!--- 4) Balance por Moneda --->
						<cfset LvarBalancear = true>
						<cfquery name="rsBalXMonedaOficina" datasource="#arguments.conexion#">
							select 	sum(case when INTTIP = 'D' then INTMON else -INTMON end) 	as DIF,
									sum(0.005) 													as PERMIT,  <!--- 0.005 --->
									sum(case when INTTIP = 'D' then INTMON end) 				as DBS,
									sum(case when INTTIP = 'C' then INTMON end) 				as CRS
							  from #request.INTARC#
						</cfquery>
						<cfif rsBalXMonedaOficina.PERMIT EQ "" or rsBalXMonedaOficina.PERMIT EQ 0 >
						   <cf_errorCode	code = "51078" msg = "El Asiento Generado está vacío. Proceso Cancelado!">
						</cfif>

						<cfif abs(rsBalXMonedaOficina.DIF) GT rsBalXMonedaOficina.PERMIT>
							<cfif not LvarPintar>
								<cf_errorCode	code = "51079"
											msg  = "El Asiento Generado no está balanceado en Moneda Local. Debitos=@errorDat_1@, Creditos=@errorDat_2@. Proceso Cancelado!"
											errorDat_1="#numberFormat(rsBalXMonedaOficina.DBS,",9.00")#"
											errorDat_2="#numberFormat(rsBalXMonedaOficina.CRS,",9.00")#"
								>
							</cfif>
							<cfset LvarBalancear = false>
						</cfif>

						<cfif LvarBalancear>
							<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
								select EPdocumento, CPTcodigo
								  from EPagosCxP
								 where Ecodigo	=  #Arguments.Ecodigo#
								   and IDpago	=#Arguments.IDpago#
							</cfquery>

							<cfquery name="rsBalanceMon" datasource="#Arguments.Conexion#">
								insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTCAM, INTMOE, INTMON, NumeroEvento,CFid)
								select
									'CPRE',
									1,
									'#rsSQL.EPdocumento#',
									'#rsSQL.CPTcodigo#',
									'C',
									'Balance por Moneda',
									<CF_jdbcquery_param cfsqltype="cf_sql_char" value="#Year(now())##RepeatString('0',2-Len(Month(now())))##Month(now())##RepeatString('0',2-Len(Day(now())))##Day(now())#">,
									#Periodo#,
									#Mes#,
									#CuentaPuente#,
									Mcodigo,
									Ocodigo,
									abs(sum(round(case when INTTIP = 'D' then INTMON else -INTMON end,2))/sum(round(case when INTTIP = 'D' then INTMOE else -INTMOE end,2))),
									sum(round(case when INTTIP = 'D' then INTMOE else -INTMOE end,2)),
									sum(round(case when INTTIP = 'D' then INTMON else -INTMON end,2)),
                                    '#varNumeroEvento#',CFid
								 from #INTARC#
								 group by Mcodigo, Ocodigo,CFid
								 having sum(round(case when INTTIP = 'D' then INTMOE else -INTMOE end,2)) <> 0
							</cfquery>

						</cfif>

						<cfif  Arguments.debug EQ "S">
							<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
								select INTDES,INTDOC,INTREF,INTMON,INTCAM,Mcodigo,INTMOE, Ccuenta,INTTIP
								from #Intarc#
								order by Mcodigo,INTTIP
							</cfquery>
								<br>INTARC<br>
								<cf_dump var="#rs_revisa_Intarc#">
						</cfif>

						<cfset sbAfectacionIETU(
									Arguments.IDpago,
									Arguments.Ecodigo, "CPRE",
									EPfecha, Periodo, Mes,
									Arguments.conexion)>

						<cfset LvarNAP = sbControlPresupuesto_PagosCxP (
									Arguments.IDpago,
									Arguments.Ecodigo, "CPRE", EPdocumento, CPTcodigo,
									EPfecha, Periodo, Mes,
									Arguments.conexion, "#varNumeroEvento#")>


						<!--- 5) Ejecutar el Genera Asiento --->
						<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
							<cfinvokeargument name="Ecodigo" 		value="#arguments.Ecodigo#"/>
							<cfinvokeargument name="Oorigen" 		value="CPRE"/>
							<cfinvokeargument name="Eperiodo" 		value="#Periodo#"/>
							<cfinvokeargument name="Emes" 			value="#Mes#"/>
							<cfinvokeargument name="Efecha" 		value="#EPfecha#"/>  <!--- Preguntar a Mauricio Esquivel por que no se puede utilizar la fecha NOW y por que se tiene que utilizar la fecha del documento --->
							<cfinvokeargument name="Edescripcion" 	value="#descripcion#"/>
							<cfinvokeargument name="Edocbase" 		value="#EPdocumento#"/>
							<cfinvokeargument name="Ereferencia" 	value="#CPTcodigo#"/>
							<cfinvokeargument name="Ocodigo" 		value="#Ocodigo#"/>
							<cfinvokeargument name="Usucodigo" 		value="#Session.Usucodigo#"/>
							<cfinvokeargument name="NAP" 			value="#LvarNAP#"/>
							<cfinvokeargument name="conexion"		value="#Arguments.Conexion#">
							<cfinvokeargument name="debug" 			value="no"/>
							<cfinvokeargument name="PintaAsiento"	value="#LvarPintar#"/>
<!--- Control Evento Inicia --->
        					<cfinvokeargument name="NumeroEvento"	value="#varNumeroEvento#">
<!--- Control Evento Fin --->

						</cfinvoke>

						<cfinvoke component="IETU" method="IETU_ActualizaIDcontable" >
							<cfinvokeargument name="IDcontable"	value="#IDcontable#">
							<cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
						</cfinvoke>

						<!---SML. 04/11/2014. Inicio Modificacion para agregar la informacion Bancaria para las Polizas del SAT--->
										<cfquery name="getContE" datasource="#Session.DSN#">
											select ERepositorio from Empresa
											where Ereferencia = #Session.Ecodigo#
										</cfquery>

										<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
                        <cfquery name="insInfoBancaria" datasource="#session.DSN#">
                        	 INSERT INTO CEInfoBancariaSAT(IDcontable,Dlinea,
 													  TESTMPtipo,IBSATdocumento,ClaveSAT,
											          CBcodigo,TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
                                                      IBSAClaveSATtran,IBSATctadestinotran)
                             SELECT dco.IDcontable, dco.Dlinea,
                             	    CASE WHEN cpt.CPTcktr = 'C' THEN 'CHK'
                                         WHEN cpt.CPTcktr = 'T' THEN 'TRM'
                                    END AS TESTMPtipo,a.EPdocumento, ceb.Clave, cb.CBcodigo,a.EPfecha, a.EPtotal,sn.SNnombre,sn.SNidentificacion,
                                    CASE WHEN cpt.CPTcktr = 'T'
                                         THEN tranp.Clave
                                    END as TESTPClave,
                                    CASE WHEN cpt.CPTcktr = 'T'
                                         THEN tranp.TESTPcuenta
                                    END as TESTPcuenta
                             FROM EPagosCxP a
                                 INNER JOIN CuentasBancos cb ON cb.CBid = a.CBid and cb.Ecodigo = a.Ecodigo
                                 INNER JOIN Bancos ban ON ban.Bid = cb.Bid
                                 LEFT JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
                                 LEFT JOIN DContables dco ON dco.Ccuenta = cb.Ccuenta
                				 	  AND dco.IDcontable = #IDcontable# AND dco.Ddocumento = a.EPdocumento
                                 INNER JOIN CPTransacciones cpt ON cpt.Ecodigo = a.Ecodigo and cpt.CPTcodigo = a.CPTcodigo
                                 LEFT JOIN SNegocios sn ON sn.SNcodigo = a.SNcodigo and sn.Ecodigo = a.Ecodigo
                                 LEFT JOIN (SELECT distinct testp.Bid,ceba.Clave,testp.TESTPcuenta,SNidP
                                            FROM TEStransferenciaP testp
                                                 INNER JOIN Bancos b ON b.Bid = testp.Bid
                                                 INNER JOIN CuentasBancos cb ON b.Bid = cb.Bid
												 INNER JOIN EPagosCxP epcp ON cb.CBid = epcp.CBid
                                                 LEFT JOIN CEBancos ceba ON ceba.Id_Banco = b.CEBSid
                                            WHERE SNidP is not null and epcp.IDpago = #Arguments.IDpago#) as tranp
                                     ON tranp.SNidP = sn.SNid
                             WHERE a.IDpago = #Arguments.IDpago#
                        </cfquery>
                    </cfif>
                        <!---SML. 04/11/2014. Fin Modificacion para agregar la informacion Bancaria para las Polizas del SAT--->

						<!--- 6) Insertar en el Histórico de CxP --->
						<cfquery name="rsBMovimientosCxP" datasource="#arguments.conexion#">
							insert into BMovimientosCxP (
								Ecodigo,
								CPTcodigo,
								Ddocumento,
								CPTRcodigo,
								DRdocumento,
								BMfecha,
								Ccuenta,
								Ocodigo,
								SNcodigo,
								Mcodigo,
								Dtipocambio,
								Dtotal, 			<!--- Monto Pagado en Moneda Pago --->
								BMmontoretori, 		<!--- Monto Retención en Moneda Doc --->
								BMmontoref, 		<!--- Monto Aplicado en Moneda Doc (Monto Pagado + Monto Retencion en Moneda Doc) --->
								Dfecha,
								Dvencimiento,
								BMperiodo,
								BMmes,
								BMusuario,
								BMfactor,
								Mcodigoref,
								IDcontable)
							select
								 b.Ecodigo,
								 c.CPTcodigo,
								'#EPdocumento#',
								<cf_dbfunction name="sPart"	args="a.CPTcodigo,1,2">,
								<cf_dbfunction name="sPart"	args="a.Ddocumento,1,20">,
								<CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Fecha#">,
								a.Ccuenta,
								c.Ocodigo,
								a.SNcodigo,
								c.Mcodigo,
								c.EPtipocambio,
								b.DPtotal,
								(b.DPmontoretdoc),
								b.DPmontodoc + b.DPmontoretdoc,
								c.EPfecha,
								c.EPfecha,
								#Periodo#,
								#Mes#,
								'#Arguments.usuario#',
								b.DPtipocambio,
								a.Mcodigo,
								#IDcontable#
							from DPagosCxP b
								inner join EDocumentosCP a
									on a.IDdocumento = b.IDdocumento
								inner join EPagosCxP c
									on c.IDpago = b.IDpago
							where c.IDpago =#Arguments.IDpago#
						</cfquery>
						<cfquery name="rsValidaSaldos" datasource="#arguments.conexion#">
							select CPTcodigo #_Cat# Ddocumento Doc
								from EDocumentosCP
							where exists (
									select 1
									from DPagosCxP c
									where c.IDpago = #Arguments.IDpago#
									  and EDocumentosCP.IDdocumento = c.IDdocumento
								)
							and (EDsaldo - coalesce(
													(select sum(abs(c.DPmontodoc + c.DPmontoretdoc))
													  from DPagosCxP c
													 where c.IDdocumento = EDocumentosCP.IDdocumento
													), 0.00)
								) < 0
						</cfquery>
						<cfif rsValidaSaldos.recordcount NEQ 0>
							<cfset DOCs = "">
							<cfloop query="rsValidaSaldos">
								<cfset 	DOCs &= rsValidaSaldos.Doc & ','>
							</cfloop>
							<cfthrow message="La aplicación del Pago Causa que los siguientes Documentos queden con saldo Negativo:#mid(DOCs,1,LEN(DOCs)-1)#">
						</cfif>
						<cftry>
						<!--- Actualizar el saldo de los documentos que se estan pagando --->
						<cfquery name="rsupdateEDocumentosCP" datasource="#arguments.conexion#">
							update EDocumentosCP
								set
									EDsaldo = EDsaldo
											- coalesce(
														(select sum(abs(c.DPmontodoc + c.DPmontoretdoc))
														  from DPagosCxP c
														where c.IDdocumento = EDocumentosCP.IDdocumento
														), 0.00)
													,
									EDretporigen = coalesce(EDretporigen,0.00)
												+ coalesce(
														(select sum(abs(c.DPmontoretdoc))
														  from DPagosCxP c
														where c.IDdocumento = EDocumentosCP.IDdocumento
														), 0.00)
								where exists (
									select 1
									from DPagosCxP c
									where c.IDpago = #Arguments.IDpago#
									  and EDocumentosCP.IDdocumento = c.IDdocumento
								)

						</cfquery>

						<cfcatch type="any"><!--- if @@error!=0 begin --->
							<cf_errorCode	code = "51170" msg = "No se pudo actualizar el saldo del documento! (Tabla:EDocumentosCP)">
						</cfcatch>
						</cftry>

						<!--- Inserta en Libros --->
						<cfquery name="rsInsMLibros" datasource="#arguments.conexion#">
							insert into	MLibros (Ecodigo,
											Bid,
											BTid,
											CBid,
											Mcodigo,
											MLfecha,
											MLdescripcion,
											MLdocumento,
											MLreferencia,
											MLconciliado,
											MLtipocambio,
											IDcontable,
											MLmonto,
											MLmontoloc,
											MLperiodo,
											MLmes,
											MLtipomov,
											MLusuario)
							select #Arguments.Ecodigo#,
									b.Bid,
									a.BTid,
									a.CBid,
									a.Mcodigo,
									a.EPfecha,
									'Pago de CxP',
									<cf_dbfunction name="sPart"	args="a.EPdocumento,1,20">,
									<cf_dbfunction name="sPart"	args="a.CPTcodigo,1,2">,
									'N',
									a.EPtipocambio,
									#IDcontable#,
									a.EPtotal,
									round(a.EPtipocambio * a.EPtotal,2),
									#Periodo#,
									#Mes#,
									'C',
									'#Arguments.usuario#'
							from EPagosCxP a
								inner join CuentasBancos b
									on a.CBid = b.CBid
									and a.Ecodigo = b.Ecodigo
								inner join CPTransacciones c
									on c.CPTcodigo = a.CPTcodigo
								  	and c.Ecodigo = a.Ecodigo
							where a.Ecodigo = #Arguments.Ecodigo#
							  and a.IDpago = #Arguments.IDpago#
                              and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
						</cfquery>

   						<cfif Arguments.debug EQ "S">
							<br>MLibros <br>
							<cfquery name="rsdebugMLibros" datasource="#arguments.conexion#">
								select MLid,
								Ecodigo,
								Bid,
								BTid,
								CBid,
								Mcodigo,
								MLfecha,
								MLdescripcion,
								MLdocumento,
								MLreferencia,
								MLconciliado,
								MLtipocambio,
								MLmonto,
								MLmontoloc,
								MLperiodo,
								MLmes,
								MLtipomov,
								MLusuario,
								IDcontable,
								CDLgrupo,
								MLfechamov,
								ts_rversion
								from MLibros
								where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
							</cfquery>
							<cfdump var="#rsdebugMlibros#">
						</cfif>

						<!--- 8) Grabar el Documento del Anticipo Generado (si aplica) --->
							<cftry>
								<cfquery name="rsInsEDocumentosCP" datasource="#arguments.conexion#">
									insert into EDocumentosCP (Ecodigo,
															   CPTcodigo,
															   Ddocumento,
															   SNcodigo,
															   Mcodigo,
															   Ocodigo,
															   Ccuenta,
															   Rcodigo,
															   Dtipocambio,
															   Dtotal,
															   EDsaldo,
															   Dfecha,
															   Dfechavenc,
															   EDtcultrev,
															   EDtref,
															   EDdocref,
															   EDmontoretori,
															   EDretporigen,
															   EDusuario,
															   Icodigo,
															   id_direccion,
															   TESRPTCid,
															   TESRPTCietu)
									select   #Arguments.Ecodigo#,
										<cf_dbfunction name="sPart"	args="Anti.NC_CPTcodigo,1,2">,
										<cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20">,
										a.SNcodigo,
										a.Mcodigo,
										a.Ocodigo,
										Anti.NC_Ccuenta,
										<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
										a.EPtipocambio,
										Anti.NC_total,
										Anti.NC_total,
										a.EPfecha,
										a.EPfecha,
										a.EPtipocambio,
										a.CPTcodigo,
										<cf_dbfunction name="sPart"	args="EPdocumento,1,20">,
										<CF_jdbcquery_param cfsqltype="cf_sql_money" value="null">,
										<CF_jdbcquery_param cfsqltype="cf_sql_money" value="null">,
										'#Arguments.usuario#',
										<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
										Anti.id_direccion,
										Anti.NC_RPTCid,
										Anti.NC_RPTCietu
									from EPagosCxP a
										inner join APagosCxP Anti
											on a.IDpago = Anti.IDpago
									where a.Ecodigo 	=  #Arguments.Ecodigo#
									  and a.CPTcodigo 	=  <cfqueryparam cfsqltype="cf_sql_char" value="#CPTcodigo#">
									  and a.IDpago 		=  #Arguments.IDpago#
								 </cfquery>

								<cfcatch type="any"><!--- if @@error!=0 begin --->
									<cfrethrow>
									<cf_errorCode	code = "51172" msg = "No se pudo Generar el Anticipo ! (Tabla:EDocumentosCP)">
								</cfcatch>
							</cftry>
							<cftry>
								<cfquery name="rsInsEDocumentosCP" datasource="#arguments.conexion#">
									insert into HEDocumentosCP (
										IDdocumento, CFid, id_direccion, Ecodigo,
										CPTcodigo, Ddocumento, SNcodigo, Mcodigo,
										Ocodigo, Ccuenta, Rcodigo, Icodigo, Dtipocambio,
										Dtotal, EDsaldo, Dfecha, Dfechavenc, EDtcultrev,
										EDtref, EDdocref, EDmontoretori, EDretporigen, Dfechaarribo,
										EDusuario, BMUsucodigo,
										NAP, NRP, EDtipocambioVal, EDtipocambioFecha,
										EDrecurrente, HEDfechaultuso, HEDfechaultaplic
									   	,TESRPTCid,TESRPTCietu,EDretencionVariable
									   )
									select
										d.IDdocumento, d.CFid, d.id_direccion, d.Ecodigo,
										d.CPTcodigo, d.Ddocumento, d.SNcodigo, d.Mcodigo,
										d.Ocodigo, d.Ccuenta, d.Rcodigo, d.Icodigo, d.Dtipocambio,
										d.Dtotal, d.EDsaldo, d.Dfecha, d.Dfechavenc, d.EDtcultrev,
										d.EDtref, d.EDdocref, d.EDmontoretori, d.EDretporigen, d.Dfechaarribo,
										d.EDusuario, d.BMUsucodigo,
										d.NAP, d.NRP, d.EDtipocambioVal, d.EDtipocambioFecha,
										0, <CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
										<CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
										d.TESRPTCid,d.TESRPTCietu,d.EDretencionVariable
									from APagosCxP a
										inner join EPagosCxP c
											on c.IDpago = a.IDpago
										inner join EDocumentosCP d
											 on d.Ecodigo 	 = c.Ecodigo
											and d.CPTcodigo  = <cf_dbfunction name="sPart"	args="a.NC_CPTcodigo, 1, 2">
											and d.Ddocumento = <cf_dbfunction name="sPart"	args="a.NC_Ddocumento,1,20">
											and d.SNcodigo   = c.SNcodigo
									where c.Ecodigo 	=  #Arguments.Ecodigo#
									  and c.CPTcodigo 	=  <cfqueryparam cfsqltype="cf_sql_char" value="#CPTcodigo#">
									  and c.IDpago		=  #Arguments.IDpago#
								</cfquery>
							  <cfcatch type="any">
									<cfthrow message="No se pudo Generar el Anticipo ! (Tabla:HEDocumentosCP)" detail="#cfcatch.Detail#">
							  </cfcatch>
							</cftry>

							<cftry>
								<cfquery name="rsInsBMovimientosCxP2" datasource="#arguments.conexion#">
									insert into BMovimientosCxP (Ecodigo,
																CPTcodigo,
																Ddocumento,
																CPTRcodigo,
																DRdocumento,
																BMfecha,
																Ocodigo,
																SNcodigo,
																Mcodigo,
																Rcodigo,
																Ccuenta,
																Dtipocambio,
																Dtotal,
																Dfecha,
																Dvencimiento,
																BMperiodo,
																BMmes,
																EDtcultrev,
																BMtref,
																BMdocref,
																BMmontoretori,
																BMusuario,
																IDcontable,
																Icodigo)
									select  a.Ecodigo,
											<cf_dbfunction name="sPart"	args="Anti.NC_CPTcodigo,1,2">,
											<cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20">,
											a.CPTcodigo,
											<cf_dbfunction name="sPart"	args="a.EPdocumento,1,20">,
											<CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Fecha#">,
											a.Ocodigo,
											a.SNcodigo,
											a.Mcodigo,
											<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
											Anti.NC_Ccuenta,
											a.EPtipocambio,
											Anti.NC_total,
											a.EPfecha,
											a.EPfecha,
											#Periodo#,
											#Mes#,
											a.EPtipocambio,
											a.CPTcodigo,
											<cf_dbfunction name="sPart"	args="a.EPdocumento,1,20">,
											<CF_jdbcquery_param cfsqltype="cf_sql_money" value="null">,
											'#Arguments.usuario#',
											<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
											<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">
									from EPagosCxP a
										inner join APagosCxP Anti
											on Anti.IDpago = a.IDpago
									where a.Ecodigo 	=  #Arguments.Ecodigo#
									  and a.CPTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#CPTcodigo#">
									  and a.IDpago 		= #Arguments.IDpago#
								</cfquery>

								<cfcatch type="any">
									<cfthrow message="No se pudo Generar el Anticipo ! (Tabla:BMovimientosCxP)" detail="#cfcatch.Detail#">
								</cfcatch>
							</cftry>


							<!--- MEG 05/11/2014 --->
						<!--- Envía al Repositorio de  CFDI --->

						<!--- Si existe configurado un Repositorio de CFDIs --->
						<cfquery name="getContE" datasource="#Session.DSN#">
							select ERepositorio from Empresa
							where Ereferencia = #Session.Ecodigo#
						</cfquery>

					<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">

						<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="FN_getInfoBancaria" returnVariable = "rsInfoBancaria">
							<cfinvokeargument name="IDpago"	   value="#Arguments.IDpago#"/>
							<cfinvokeargument name='IDcontable'		value="#IDcontable#"/>
						</cfinvoke>

						<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="FN_insertaRepositorio">
							<cfinvokeargument name='IDcontable'		value="#IDcontable#"/>
							<cfinvokeargument name='IDpago' 		value="#Arguments.IDpago#"/>
							<cfinvokeargument name='Dlinea' 		value="#rsInfoBancaria.Dlinea#"/>
							<cfinvokeargument name='TESTMPtipo' 	value="#rsInfoBancaria.TESTMPtipo#"/>
						</cfinvoke>

					</cfif>
						<!--- MEG 05/11/2014 --->

                            <cfif varValidaEvento GT 0>
								<cfset varANevento = AnticipoEvento(CPTcodigo = #CPTcodigo#, IDpago = #Arguments.IDpago#, Ecodigo = #Arguments.Ecodigo#, Conexion = #Arguments.Conexion#)>
                            </cfif>

							<cfif Arguments.debug EQ "S">

								<cfquery name="rsdebug2" datasource="#arguments.conexion#">
									select
									'Doc Anticipo.',
									a.IDdocumento,
									a.Ecodigo,
									a.CPTcodigo,
									a.Ddocumento,
									a.SNcodigo,
									a.Mcodigo,
									a.Ocodigo,
									a.Ccuenta,
									a.Rcodigo,
									a.Dtipocambio,
									a.Dtotal,
									a.EDsaldo,
									a.Dfecha,
									a.Dfechavenc,
									a.EDtcultrev,
									a.EDtref,
									a.EDdocref,
									a.EDmontoretori,
									a.EDretporigen,
									a.EDusuario,
									a.Icodigo,
									a.ts_rversion
									from EDocumentosCP a
									 	inner join APagosCxP Anti
											 on Anti.Ecodigo 		= a.Ecodigo
										  	and Anti.NC_Ddocumento  = a.Ddocumento
										  	and Anti.NC_CPTcodigo 	= a.CPTcodigo
										inner join EPagosCxP b
											on b.IDpago = Anti.IDpago
									where a.Ecodigo 	= #Arguments.Ecodigo#
									  and b.IDpago 		= #Arguments.IDpago#
									  and b.CPTcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#CPTcodigo#">
								 </cfquery>
								 <cfdump var="#rsdebug2#">
							</cfif>

   						<!--- 9) Eliminar el Pago de las Estructuras Transaccionales --->
						<cftry>
							<cfquery name="rsdebug2" datasource="#arguments.conexion#">
								delete from DPagosCxP
								where IDpago =#Arguments.IDpago#
							</cfquery>
							<cfcatch type="any"><!--- if @@error!=0 begin --->
								<cf_errorCode	code = "51175" msg = "No se pudo eliminar el detalle del Pago de CxP! (Tabla: DPagosCxP) Proceso Cancelado!">
							</cfcatch>
						</cftry>
						<cftry>
							<!---Elimina los Anticipos del Pago--->
							<cfquery datasource="#arguments.conexion#">
								delete from APagosCxP
								where IDpago =#Arguments.IDpago#
							</cfquery>
							<cfquery name="rsdebug2" datasource="#arguments.conexion#">
								delete from EPagosCxP
								where IDpago =#Arguments.IDpago#
							</cfquery>
							<cfcatch type="any"><!--- if @@error!=0 begin --->
								<cf_errorCode	code = "51176" msg = "No se pudo eliminar el Encabezado del Pago de CxP! (Tabla: EPagosCxP) Proceso Cancelado!">
							</cfcatch>
						</cftry>

					<cfif arguments.debug EQ 'S'>
						<cf_abort errorInterfaz="">
					<cfelse>
						<cftransaction action="commit"/>
					</cfif>
		</cftransaction>
	</cffunction>

	<cffunction name="FN_getInfoBancaria" access="public" returntype="query">
		<cfargument name='IDpago' 		type='numeric' 	required='true'>
		<cfargument name='IDcontable' 		type='numeric' 	required='true'>

		<cfquery name="rsInfoBancaria" datasource="#session.DSN#">
           	 SELECT dco.IDcontable, dco.Dlinea,
                	    CASE WHEN cpt.CPTcktr = 'C' THEN 'CHK'
                            WHEN cpt.CPTcktr = 'T' THEN 'TRM'
                       END AS TESTMPtipo,a.EPdocumento, ceb.Clave, cb.CBcodigo,a.EPfecha, a.EPtotal,sn.SNnombre,sn.SNidentificacion,
                       CASE WHEN cpt.CPTcktr = 'T'
                            THEN tranp.Clave
                       END as TESTPClave,
                       CASE WHEN cpt.CPTcktr = 'T'
                            THEN tranp.TESTPcuenta
                       END as TESTPcuenta
                FROM EPagosCxP a
                    INNER JOIN CuentasBancos cb ON cb.CBid = a.CBid and cb.Ecodigo = a.Ecodigo
                    INNER JOIN Bancos ban ON ban.Bid = cb.Bid
                    LEFT JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
                    LEFT JOIN DContables dco ON dco.Ccuenta = cb.Ccuenta
   				 	  AND dco.IDcontable = #Arguments.IDcontable# AND dco.Ddocumento = a.EPdocumento
                    INNER JOIN CPTransacciones cpt ON cpt.Ecodigo = a.Ecodigo and cpt.CPTcodigo = a.CPTcodigo
                    LEFT JOIN SNegocios sn ON sn.SNcodigo = a.SNcodigo and sn.Ecodigo = a.Ecodigo
                    LEFT JOIN (SELECT distinct testp.Bid,ceba.Clave,testp.TESTPcuenta,SNidP
                               FROM TEStransferenciaP testp
                                    INNER JOIN Bancos b ON b.Bid = testp.Bid
                                    INNER JOIN CuentasBancos cb ON b.Bid = cb.Bid
				INNER JOIN EPagosCxP epcp ON cb.CBid = epcp.CBid
                                    LEFT JOIN CEBancos ceba ON ceba.Id_Banco = b.CEBSid
                               WHERE SNidP is not null and epcp.IDpago = #Arguments.IDpago#) as tranp
                        ON tranp.SNidP = sn.SNid
               WHERE a.IDpago = #Arguments.IDpago#
          </cfquery>
		<cfreturn #rsInfoBancaria#>
	</cffunction>

	<cffunction name="FN_insertaRepositorio" access="public"  output="false">
		<cfargument name='IDcontable' 		type='numeric' 	required='true'>
		<cfargument name='IDpago' 			type='numeric' 	required='true'>
		<cfargument name='Dlinea' 			type='numeric' 	required='true'>
		<cfargument name='TESTMPtipo' 		type='string' 	required='true'>


		<cfquery name="rsDetallesBancos" datasource="#session.DSN#">
			SELECT  #IDcontable# IDContable, min(dco.Dlinea) Dlinea,op.IDdocumento,op.Ddocumento,op.CPTcodigo,
				op.SNcodigo, sn.SNidentificacion, op.Dtotal, op.Dtipocambio, op.Mcodigo
			FROM EPagosCxP a
			inner join DPagosCxP b
				on a.IDpago = b.IDpago
			inner join HEDocumentosCP op
				on b.IDdocumento = op.IDdocumento
			INNER JOIN HDDocumentosCP dp
			    on dp.IDdocumento	= op.IDdocumento
			INNER JOIN SNegocios sn
			    on op.SNcodigo = sn.SNcodigo
			    and op.Ecodigo = sn.Ecodigo
			INNER JOIN DContables dco
			    ON dco.Ccuenta = sn.SNcuentacxp
			    and dco.IDcontable = #IDcontable#
			    and dco.Ddocumento = op.Ddocumento
			where a.IDpago = #Arguments.IDpago#
				and a.Ecodigo = #Session.Ecodigo#
				and dco.Ecodigo = #Session.Ecodigo#
			group by op.IDdocumento,op.Ddocumento,op.CPTcodigo,
				op.SNcodigo, sn.SNidentificacion, op.Dtotal, op.Dtipocambio, op.Mcodigo
		</cfquery>

		<cfloop query="rsDetallesBancos">
			<cfset varNumDoc = #Ddocumento#>
			<cfquery name="rsRepo" datasource="#session.DSN#">
				insert into #request.repodbname#CERepositorio(IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
			archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
					TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
					CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
				select top 1
					#IDcontable#,#IDdocumento#,'#Ddocumento#',
					'CPRE', #Arguments.Dlinea#, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
	     	rep.extension, #session.Ecodigo#,#session.Usucodigo#,
	     	rep.TipoComprobante,rep.Serie,
	     	rep.Mcodigo,
	     	rep.TipoCambio,
	     	<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TESTMPtipo#" null="#Len(trim(Arguments.TESTMPtipo)) Is 0#">,
	     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetallesBancos.SNidentificacion#" null="#Len(trim(rsDetallesBancos.SNidentificacion)) Is 0#">,
	     	round(#rsDetallesBancos.Dtotal#,2),
					rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
				from #request.repodbname#CERepositorio  rep
				where ltrim(rtrim(rep.CEdocumentoOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ddocumento)#">
					<!--- and ltrim(rtrim(rep.CEtranOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(CPTcodigo)#"> --->
					and rep.CESNB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(SNcodigo)#">
					and rep.Ecodigo = #Session.Ecodigo#
					and rep.origen = 'CPFC'
			</cfquery>
		</cfloop>

		<cfquery name="rsDetalles" datasource="#session.DSN#">
			SELECT distinct  #Arguments.IDcontable#, dco.Dlinea,op.IDdocumento,op.Ddocumento,op.CPTcodigo,
				op.SNcodigo, sn.SNidentificacion, op.Dtotal, op.Dtipocambio, op.Mcodigo
			FROM EPagosCxP a
			inner join DPagosCxP b
				on a.IDpago = b.IDpago
			inner join HEDocumentosCP op
				on b.IDdocumento = op.IDdocumento
			INNER JOIN HDDocumentosCP dp
			    on dp.IDdocumento	= op.IDdocumento
			INNER JOIN SNegocios sn
			    on op.SNcodigo = sn.SNcodigo
			    and op.Ecodigo = sn.Ecodigo
			INNER JOIN DContables dco
			    ON dco.Ccuenta = sn.SNcuentacxp
			    and dco.IDcontable = #IDcontable#
			    and dco.Ddocumento = op.Ddocumento
			where a.IDpago = #Arguments.IDpago#
				and a.Ecodigo = #Session.Ecodigo#
				and dco.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfloop query="rsDetalles">
			<cfset varNumDoc = #Ddocumento#>
			<cfquery name="rsRepo" datasource="#session.DSN#">
				insert into CERepositorio(IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
               					archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
									TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
									CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
				select top 1
					#Arguments.IDcontable#,#IDdocumento#,'#Ddocumento#',
					'CPRE', #Arguments.Dlinea#, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
                    	rep.extension, #session.Ecodigo#,#session.Usucodigo#,
                    	rep.TipoComprobante,rep.Serie,
                    	#rsDetalles.Mcodigo#,
                    	#rsDetalles.Dtipocambio#,
                    	<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TESTMPtipo#" null="#Len(trim(Arguments.TESTMPtipo)) Is 0#">,
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalles.SNidentificacion#" null="#Len(trim(rsDetalles.SNidentificacion)) Is 0#">,
			                     	round(#rsDetalles.Dtotal#,2),
									rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
								from CERepositorio  rep
				where ltrim(rtrim(rep.CEdocumentoOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ddocumento)#">
					<!--- and ltrim(rtrim(rep.CEtranOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(CPTcodigo)#"> --->
					and rep.CESNB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(SNcodigo)#">
					and rep.Ecodigo = #Session.Ecodigo#
					and rep.origen = 'CPFC'
			</cfquery>
		</cfloop>

	</cffunction>

	<cffunction name="FN_DiferencialCambiario" access="public"  output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 			<!--- Codigo empresa ---->
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 			<!--- Codigo del movimiento---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	<!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false'>
		<cfargument name='INTARC' 	    type='string' 	required='true'>
		<cfargument name='Periodo' 	     type='numeric' 	required='true'>
		<cfargument name='Mes' 	         type='numeric' 	required='true'>
		<cfargument name='Monloc' 	     type='numeric' 	required='true'>
        <cfargument name="NumeroEvento" type="string"   required="no" default="">

		<cfset LvarFechaLinea = "#dateformat(now(), "YYYYMMDD")#">
		<!--- ****************************************************** --->
		<!---   DIFERENCIAL CAMBIARIO                                --->
		<!--- ****************************************************** --->

		<!---- Carga de la  CuentaIngDifCam --->
		<cfquery name="rsCuentaIngDifCam" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaIngDifCam
			from Parametros
			where Ecodigo =  #Arguments.Ecodigo#
			  and Pcodigo = 130
		</cfquery>
		<cfif isdefined("rsCuentaIngDifCam") and rsCuentaIngDifCam.RecordCount GT 0>
			<cfset CuentaIngDifCam =  rsCuentaIngDifCam.CuentaIngDifCam>
		</cfif>

		<!---- Carga de la  CuentaGasDifCam--->
		<cfquery name="rsCuentaGasDifCam" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaGasDifCam
			from Parametros
			where Ecodigo =  #Arguments.Ecodigo#
			  and Pcodigo = 140
		</cfquery>

		<cfif isdefined("rsCuentaGasDifCam") and rsCuentaGasDifCam.RecordCount GT 0>
			<cfset CuentaGasDifCam =  rsCuentaGasDifCam.CuentaGasDifCam>
		</cfif>

		<!--- Cambio de Valor de Documento en la moneda local, por diferencial en el tipo de cambio --->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# (
				INTORI, INTREL, INTDOC, INTREF,
				INTMON, INTTIP, INTDES, INTFEC,
				INTCAM, Periodo, Mes, Ccuenta,
				Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPRE',	1,	c.Ddocumento, c.CPTcodigo ,
				round( ( det.DPmontodoc + coalesce(det.DPmontoretdoc, 0) ) * ((a.EPtipocambio / det.DPtipocambio)  - c.EDtcultrev) , 2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="'Ajuste Diferencial Cambiario : ', c.CPTcodigo, ' ', c.Ddocumento">,
				'#LvarFechaLinea#',
				1,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				c.Ccuenta,
				c.Mcodigo,
				c.Ocodigo,
				0,
                det.NumeroEvento,a.CFid
			from EPagosCxP  a
				inner join DPagosCxP det
					inner join EDocumentosCP c
						inner join CPTransacciones d
							on  d.CPTcodigo = c.CPTcodigo
							and d.Ecodigo   = c.Ecodigo
					 on c.IDdocumento = det.IDdocumento
				 on  det.IDpago =  a.IDpago
				 and det.Ecodigo = a.Ecodigo
			where a.IDpago =#Arguments.IDpago#
			  and a.Ecodigo =  #Arguments.Ecodigo#
			  and c.Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Monloc#">
			  and round( ( det.DPmontodoc + coalesce(det.DPmontoretdoc, 0) ) * ((a.EPtipocambio / det.DPtipocambio)  - c.EDtcultrev) , 2) <> 0
		</cfquery>

		<!---  IMPUESTO. Revaluación del monto de impuesto por el diferencial cambiario --->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPRE',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				round(
						  ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculado / b.TotalFac)
						* (
							( det.DPtotal / det.DPmontodoc * a.EPtipocambio )
							-
							c.EDtcultrev
						   )
					 , 2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat"	args="'Ajuste Diferencial Cambiario : ', i.Idescripcion">,
				'#LvarFechaLinea#',
				1,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				CcuentaImp,
				c.Mcodigo,
				c.Ocodigo,
				0,
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
				inner join DPagosCxP det
					inner join ImpDocumentosCxP b
							inner join Impuestos i
							on b.Ecodigo = i.Ecodigo
							and b.Icodigo = i.Icodigo
							and i.CcuentaCxPAcred is not null

					on  det.Ecodigo     = b.Ecodigo
					and det.IDdocumento = b.IDdocumento

					inner join EDocumentosCP c
							inner join CPTransacciones d
							on c.Ecodigo = d.Ecodigo
							and c.CPTcodigo = d.CPTcodigo
					on det.Ecodigo = c.Ecodigo
					and det.IDdocumento = c.IDdocumento


				on a.Ecodigo = det.Ecodigo
				and a.IDpago = det.IDpago

			where a.Ecodigo    =  #Arguments.Ecodigo#
			and a.IDpago       =#Arguments.IDpago#
			and c.Mcodigo      <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Monloc#">
			and b.TotalFac     <> 0
			and det.DPmontodoc <> 0
		</cfquery>

		<cfquery name="rsINTARC" datasource="#session.DSN#">
			select Mcodigo, Ocodigo, sum(INTMON * case when INTTIP = 'C' then 1 else -1 end) as GastoDifCambiario
			from #Arguments.INTARC#
			group by Mcodigo, Ocodigo
			having sum(INTMON * case when INTTIP = 'D' then 1 else -1 end) <> 0.00
		</cfquery>

		<cfif isdefined("rsINTARC") and rsINTARC.Recordcount GT 0>
			<cfloop query="rsINTARC">

				<cfset LvarGastoDifCambiario = rsINTARC.GastoDifCambiario>
				<cfset LvarMcodigo = rsINTARC.Mcodigo>
				<cfset LvarOcodigo = rsINTARC.Ocodigo>

				<cfif LvarGastoDifCambiario GT 0>
					<cfset LvarDescripcion = "Gasto Diferencial Cambiario">
					<cfset LvarCcuenta = CuentaGasDifCam>
					<cfset LvarINTTIP = "D">
				<cfelse>
					<cfset LvarDescripcion = "Ingreso Diferencial Cambiario">
					<cfset LvarCcuenta =  CuentaIngDifCam>
					<cfset LvarINTTIP = "C">
					<cfset LvarGastoDifCambiario = -LvarGastoDifCambiario>
				</cfif>

				<!--- Registro de la cuenta de Gasto o Ingreso por la revaluación del documento.  Diferencia entre el Monto del Documento y el monto de Impuesto  --->
				<cfquery name="rsINTARC" datasource="#session.DSN#">
					insert into #Arguments.INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTMON, INTTIP, INTDES, INTFEC,
						INTCAM, Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
					select
						'CPRE',	1,	a.EPdocumento, a.CPTcodigo,
						round(#LvarGastoDifCambiario#, 2),
						'#LvarINTTIP#',
						'#LvarDescripcion#',
						'#LvarFechaLinea#',
						1,
						#Arguments.Periodo#,
						#Arguments.Mes#,
						#LvarCcuenta#,
						#LvarMcodigo#,
						#LvarOcodigo#,
						0
                        ,'#Arguments.NumeroEvento#',a.CFid
					from EPagosCxP  a
					where a.IDpago =#Arguments.IDpago#
					  and a.Ecodigo =  #Arguments.Ecodigo#
					  and round(#LvarGastoDifCambiario#, 2) <> 0
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="FN_trasladoCuenta_IVA" access="public"  output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 			<!--- Codigo empresa ---->
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 			<!--- Codigo del movimiento---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	<!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false'>
		<cfargument name='INTARC' 	    type='string' 	required='true'>
		<cfargument name='Periodo' 	     type='numeric' 	required='true'>
		<cfargument name='Mes' 	         type='numeric' 	required='true'>
		<cfargument name='Monloc' 	     type='numeric' 	required='true'>
        <cfargument name="NumeroEvento" type="string"   required="no" default="">

		<cfset LvarFechaLinea = "#dateformat(now(), "YYYYMMDD")#">

		<cfquery name="rsCbalance" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Cuentabalancemultimoneda
			from Parametros
			where Ecodigo =  #Arguments.Ecodigo#
			and Pcodigo = 200
		</cfquery>

		<cfif isdefined("rsCbalance") and rsCbalance.RecordCount GT 0>
			<cfset Cuentabalancemultimoneda =  rsCbalance.Cuentabalancemultimoneda>
		</cfif>

		<cfquery name="q_porcentajesParciales" datasource="#Arguments.Conexion#">
			select distinct (c.EDsaldo) as Saldo
				<!--- sum(case b.iporcentaje when 0 then 
					(b.MontoBaseCalc*(1+(b.Iporcentaje/100)))
				else 
					(b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado)))
				end) as CurrentTotal,
				b.iporcentaje --->
				from  EPagosCxP  a
				inner join DPagosCxP det
					inner join ImpDocumentosCxP b
							inner join Impuestos i
								on i.Ecodigo = b.Ecodigo
							and i.Icodigo = b.Icodigo
							and i.CcuentaCxPAcred is not null
						on b.Ecodigo     = det.Ecodigo
					and b.IDdocumento = det.IDdocumento
					inner join EDocumentosCP c
						inner join CPTransacciones d
							on d.Ecodigo   = c.Ecodigo
						and d.CPTcodigo = c.CPTcodigo
						on c.Ecodigo     = det.Ecodigo
					and c.IDdocumento = det.IDdocumento
					on det.Ecodigo = a.Ecodigo
				and det.IDpago  = a.IDpago
				and a.Ecodigo =  #Arguments.Ecodigo#
				and a.IDpago  = #Arguments.IDpago#
				and b.TotalFac <> 0
				and det.DPmontodoc <> 0
				<!--- group by b.Iporcentaje --->
		</cfquery>
		<cfset TotalLineasParcial = q_porcentajesParciales.Saldo>
		<!---
			INTMOE:  round(( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculado)/b.TotalFac,2)
			INTCAM:  round( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio),4)
			INTMON = round(INTMOE * INTCAM , 2 )
		--->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert 	into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPRE',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!---
				round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2),--->
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				d.CPTtipo,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento">,
				'#LvarFechaLinea#',
				round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio),4),
				#Arguments.Periodo#,
				#Arguments.Mes#,
				CcuentaImp,
				c.Mcodigo,
				c.Ocodigo,
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				<!---round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac,2),--->
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpDocumentosCxP b
						inner join Impuestos i
							on i.Ecodigo = b.Ecodigo
						   and i.Icodigo = b.Icodigo
						   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo     = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago  = #Arguments.IDpago#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>
		
		<!--- insercion del ieps ---->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert 	into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPRE',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!--- round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
				d.CPTtipo,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento">,
				'#LvarFechaLinea#',
				round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio),4),
				#Arguments.Periodo#,
				#Arguments.Mes#,
				CcuentaImpIeps,
				c.Mcodigo,
				c.Ocodigo,
				<!--- round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac,2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpIEPSDocumentosCxP b
						inner join Impuestos i
							on i.Ecodigo = b.Ecodigo
						   and i.Icodigo = b.codIEPS
						   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo     = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago  = #Arguments.IDpago#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>

		<!---- Fin de la prueba del ieps ---->

		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento,CFid)
			select
				'CPRE',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!---
				round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2),--->
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento , '(Cuenta balance multimoneda)'">,
				'#LvarFechaLinea#',
				round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4),
				#Arguments.Periodo#,
				#Arguments.Mes#,
				#Cuentabalancemultimoneda#,
				c.Mcodigo,
				c.Ocodigo,
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				<!---round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac,2),--->
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.Icodigo
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo     = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo  =  #Arguments.Ecodigo#
			and a.IDpago   = #Arguments.IDpago#
			and c.Mcodigo != #Arguments.Monloc#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>

		<!--- insercion del ieps 2 ---->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento,CFid)
			select
				'CPRE',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!--- round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento , '(Cuenta balance multimoneda)'">,
				'#LvarFechaLinea#',
				round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4),
				#Arguments.Periodo#,
				#Arguments.Mes#,
				#Cuentabalancemultimoneda#,
				c.Mcodigo,
				c.Ocodigo,
				<!--- round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac,2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpIEPSDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.codIEPS
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo     = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo  =  #Arguments.Ecodigo#
			and a.IDpago   = #Arguments.IDpago#
			and c.Mcodigo != #Arguments.Monloc#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>
		<!---- fin de la segunda insercion ---->

		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPFC',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!---
				round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2),--->
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento, '(Acreditado)'">,
				'#LvarFechaLinea#',
				1.00,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				i.CcuentaCxPAcred,
				#Arguments.Monloc#,
				c.Ocodigo,
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				<!---round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac,2),--->
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.Icodigo
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo 	 = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago  = #Arguments.IDpago#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>

		<!--- tercer insercion al ieps ---->
		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPFC',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!--- round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', c.Ddocumento, '(Acreditado)'">,
				'#LvarFechaLinea#',
				1.00,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				i.CcuentaCxPAcred,
				#Arguments.Monloc#,
				c.Ocodigo,
				<!--- round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac,2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
                det.NumeroEvento,a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpIEPSDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.codIEPS
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo     = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo 	 = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago  = #Arguments.IDpago#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>
		<!--- Fin del tercer ieps ----->

		<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPFC',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!---
				round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2),--->
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				d.CPTtipo,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', RTrim(c.Ddocumento), '(Acreditado Cuenta balance multimoneda)'">,
				'#LvarFechaLinea#',
				1.00,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				#Cuentabalancemultimoneda#,
				#Arguments.Monloc#,
				c.Ocodigo,
				case b.iporcentaje when 0 then  0 else 
					round(((
							((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagado/(b.MontoCalculado+b.MontoPagado))))
								/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
							*(b.Iporcentaje/100)
						),2) end,
				<!---round( ( (det.DPmontodoc + det.DPmontoretdoc) * (b.MontoCalculado + b.MontoPagado)) / b.TotalFac,2),--->
                det.NumeroEvento, a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.Icodigo
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo 	 = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo 	 = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago = #Arguments.IDpago#
			and c.Mcodigo != #Arguments.Monloc#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>

<!----- cuarta insercion de ieps ---->
<cfquery name="rsINTARC" datasource="#session.DSN#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
			select
				'CPFC',
				1,
				c.Ddocumento,
				c.CPTcodigo ,
				<!--- round(
					round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac, 2 )
					*
					round( ( ( det.DPtotal / det.DPmontodoc ) * a.EPtipocambio ), 4)
				, 2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
				d.CPTtipo,
				<cf_dbfunction name="concat"	args="i.Idescripcion, ' ', RTrim(c.Ddocumento), '(Acreditado Cuenta balance multimoneda)'">,
				'#LvarFechaLinea#',
				1.00,
				#Arguments.Periodo#,
				#Arguments.Mes#,
				#Cuentabalancemultimoneda#,
				#Arguments.Monloc#,
				c.Ocodigo,
				<!--- round( ( (det.DPmontodoc + det.DPmontoretdoc) * b.MontoCalculadoIeps) / b.TotalFac,2), --->
				round(((
						((((b.MontoBaseCalc*(1+(b.Iporcentaje/100)))*(1 - (b.MontoPagadoIeps/(b.MontoCalculadoIeps+b.MontoPagadoIeps))))
							/#TotalLineasParcial#) * ( det.dpmontodoc + det.dpmontoretdoc ))/(1+(b.Iporcentaje/100)))
						*(b.Iporcentaje/100)
					),2),
                det.NumeroEvento, a.CFid
			from  EPagosCxP  a
			inner join DPagosCxP det
				inner join ImpIEPSDocumentosCxP b
					inner join Impuestos i
						on i.Ecodigo = b.Ecodigo
					   and i.Icodigo = b.codIEPS
					   and i.CcuentaCxPAcred is not null
					on b.Ecodigo 	 = det.Ecodigo
				   and b.IDdocumento = det.IDdocumento
				inner join EDocumentosCP c
					inner join CPTransacciones d
						on d.Ecodigo   = c.Ecodigo
					   and d.CPTcodigo = c.CPTcodigo
					on c.Ecodigo 	 = det.Ecodigo
				   and c.IDdocumento = det.IDdocumento
				on det.Ecodigo = a.Ecodigo
			   and det.IDpago  = a.IDpago
			and a.Ecodigo =  #Arguments.Ecodigo#
			and a.IDpago = #Arguments.IDpago#
			and c.Mcodigo != #Arguments.Monloc#
			and b.TotalFac <> 0
			and det.DPmontodoc <> 0
		</cfquery>
<!---Fin del la cuart insercion ---->

	</cffunction>

	<cffunction name="sbAfectacionIETU" access="public"  output="false">
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 <!--- Codigo del movimiento ---->
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="Oorigen"		type="string"	required="yes" >
		<cfargument name="Efecha"		type="date"	required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name='Conexion' 	type='string' 	required='true'>

		<!---  1) Documentos de Pago --->
		<cfquery name="PreIETUpago" datasource="#Arguments.Conexion#">
			select e.Ecodigo,
					<cf_dbfunction name="sPart"	args="e.CPTcodigo,1,2"> CPTcodigo,
					<cf_dbfunction name="sPart"	args="e.EPdocumento,1,20"> EPdocumento,
					e.EPfecha,
					sn.SNid,
					e.Mcodigo,
					e.EPtotal,
					round(e.EPtotal * e.EPtipocambio,2) MontoPagoLocal
				from EPagosCxP e
				  inner join SNegocios sn
					 on sn.Ecodigo  = e.Ecodigo
				    and sn.SNcodigo = e.SNcodigo
				where e.IDpago =#Arguments.IDpago#
		</cfquery>
		<cfquery name="rsIETUpago" datasource="#Arguments.Conexion#">
			insert into #request.IETUpago# (
					EcodigoPago,TipoPago,ReferenciaPago,DocumentoPago,
					FechaPago,SNid,
					McodigoPago,MontoPago,MontoPagoLocal,
					ReversarCreacion
				)
			values(
				   #PreIETUpago.Ecodigo#,
					2, 	<!--- CxP --->
					'#PreIETUpago.CPTcodigo#',
					'#PreIETUpago.EPdocumento#',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#PreIETUpago.EPfecha#">,
					#PreIETUpago.SNid#,
					#PreIETUpago.Mcodigo#,
					#PreIETUpago.EPtotal#,
					#PreIETUpago.MontoPagoLocal#,
					0
				  )
			<cf_dbidentity1 name="rsIETUpago" datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 name="rsIETUpago" datasource="#Arguments.Conexion#" returnvariable="ID_IETU">

		<!---  2) Documentos Afectados --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.IETUdocs# (
					ID,
					EcodigoDoc,TipoDoc,ReferenciaDoc,DocumentoDoc,
					OcodigoDoc,FechaDoc,
					TipoAfectacion,
					McodigoDoc,MontoAplicadoDoc,MontoBaseDoc,MontoBasePago,MontoBaseLocal,
					TESRPTCid,
					ReversarEnAplicacion
				)
			select 	#ID_IETU#,
					doc.Ecodigo,
					2,	<!--- CxP --->
					<cf_dbfunction name="sPart"	args="doc.CPTcodigo,1,2">,
					<cf_dbfunction name="sPart"	args="doc.Ddocumento,1,20">,
					doc.Ocodigo,
					doc.Dfecha,

					-1,	<!--- Pago por Compra: Disminuye IETU --->

					doc.Mcodigo,
					round(d.DPmontodoc + d.DPmontoretdoc,2),

					<!---
						Proporcion aplicado al documento sobre el (Total - ImpuestosCF):
							MontoAplicado / Total * (Total-ImpuestosCF)
					--->
					round((d.DPmontodoc + d.DPmontoretdoc)	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = d.IDdocumento
							)
						, 1)
					,2),
					round((d.DPmontodoc + d.DPmontoretdoc)	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = d.IDdocumento
							)
						, 1) / d.DPtipocambio
					,2),
					round((d.DPmontodoc + d.DPmontoretdoc)	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = d.IDdocumento
							)
						, 1) / d.DPtipocambio * e.EPtipocambio
					,2),

					coalesce(doc.TESRPTCid,
						(
							select min(TESRPTCid) from TESRPTconcepto where CEcodigo=#session.CEcodigo# and TESRPTCcxp=1
						)
					),
					0
			from EPagosCxP e
				inner join DPagosCxP d
					inner join EDocumentosCP doc
					 on doc.IDdocumento = d.IDdocumento
				 on d.IDpago = e.IDpago
			where e.IDpago =#Arguments.IDpago#
		</cfquery>

		<!---  3) Generación de Anticipo de afectación Inmediata --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.IETUdocs# (
						ID,
						EcodigoDoc,TipoDoc,ReferenciaDoc,DocumentoDoc,
						OcodigoDoc,FechaDoc,
						TipoAfectacion,
						McodigoDoc,MontoAplicadoDoc,MontoBaseDoc,MontoBasePago,MontoBaseLocal,
						TESRPTCid,
						ReversarEnAplicacion
					)
				select 	#ID_IETU#,
						c.Ecodigo,
						2,	<!--- CxP --->
						<cf_dbfunction name="sPart"	args="Anti.NC_CPTcodigo,1,2">,
						<cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20">,
						c.Ocodigo,
						c.EPfecha,
						-1,	<!--- Anticipo por Compra: Disminuye IETU --->
						c.Mcodigo,
						Anti.NC_total,
						Anti.NC_total,
						Anti.NC_total,
						round(Anti.NC_total * c.EPtipocambio,2),
						Anti.NC_RPTCid,
						1
				from EPagosCxP c
					inner join APagosCxP Anti
						on c.IDpago = Anti.IDpago
				where c.IDpago =#Arguments.IDpago#
				  and Anti.NC_RPTCietu = 3
			</cfquery>
		<cfinvoke component="IETU" method="IETU_Afectacion" >
			<cfinvokeargument name="Ecodigo"	value="#Arguments.Ecodigo#">
			<cfinvokeargument name="Oorigen"	value="#Arguments.Oorigen#">
			<cfinvokeargument name="Efecha"		value="#Arguments.Efecha#">
			<cfinvokeargument name="Eperiodo"	value="#Arguments.Eperiodo#">
			<cfinvokeargument name="Emes"		value="#Arguments.Emes#">
			<cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
		</cfinvoke>
	</cffunction>

	<cffunction name="CP_Pago_InsertaImp" access="public"  output="false">
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 <!--- Codigo del movimiento ---->
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name='Conexion' 	type='string' 	required='true'>
			<!--- ************************************************************--->
			<!---   Inserta monto pagado por intereses                   --->
			<!---   en la tabla ImpDocumentosCxPMov y ImpIEPSDocumentosCxPMov --->
			<!--- *********************************************************** --->
			<cfquery name="rsImpDocumentosCxPMov" datasource="#Arguments.Conexion#">
				insert into ImpDocumentosCxPMov (
					IDdocumento,
					Icodigo,
					Ecodigo,
					Fecha,
					MontoPagado,
					CPTcodigo,
					Ddocumento,
					CPTpago,
					Periodo,
					Mes,
					CcuentaAC,
					BMUsucodigo,
					BMFecha,
					TpoCambio,
					MontoPagadoLocal
				)
				select
					a.IDdocumento,
					b.Icodigo,
					b.Ecodigo,
					x.EPfecha,
					round( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * b.MontoCalculado, 2),
					x.CPTcodigo,
					x.EPdocumento,
					d.CPTpago,
					#Arguments.EPeriodo#,
					#Arguments.EMes#,
					i.CcuentaCxPAcred,
					b.BMUsucodigo,
					<cf_dbfunction name="now">,
					a.DPtotal / a.DPmontodoc * x.EPtipocambio,
					round(  round( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * b.MontoCalculado, 2) * (a.DPtotal / a.DPmontodoc * x.EPtipocambio),2)
				from  DPagosCxP  a
				inner join EPagosCxP x
					on a.IDpago = x.IDpago
				inner join ImpDocumentosCxP b
					on a.Ecodigo = b.Ecodigo
					and a.IDdocumento = b.IDdocumento
				inner join EDocumentosCP c
					on a.Ecodigo = c.Ecodigo
					and a.IDdocumento = c.IDdocumento
				inner join CPTransacciones d
					on c.Ecodigo = d.Ecodigo
					and c.CPTcodigo = d.CPTcodigo
				inner join Impuestos i
					on b.Ecodigo = i.Ecodigo
					and b.Icodigo = i.Icodigo
				where a.Ecodigo = #Arguments.Ecodigo#
				and a.IDpago = #Arguments.IDpago#
			</cfquery>

		<!---inserta en  tabla ieps ---->


			<cfquery name="ImpIEPSDocumentosCxPMov" datasource="#Arguments.Conexion#">
				insert into ImpIEPSDocumentosCxPMov (
					IDdocumento,
					codIEPS,
					Ecodigo,
					Fecha,
					MontoPagadoIeps,
					CPTcodigo,
					Ddocumento,
					CPTpago,
					Periodo,
					Mes,
					CcuentaACIeps,
					BMUsucodigo,
					BMFecha,
					TpoCambio,
					MontoPagadoLocalIeps
				)
				select
					a.IDdocumento,
					b.codIEPS,
					b.Ecodigo,
					x.EPfecha,
					round( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * b.MontoCalculadoIeps, 2),
					x.CPTcodigo,
					x.EPdocumento,
					d.CPTpago,
					#Arguments.EPeriodo#,
					#Arguments.EMes#,
					ie.CcuentaCxPAcred,
					b.BMUsucodigo,
					<cf_dbfunction name="now">,
					a.DPtotal / a.DPmontodoc * x.EPtipocambio,
					round(  round( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * coalesce(b.MontoCalculadoIeps,0), 2) * (a.DPtotal / a.DPmontodoc * x.EPtipocambio),2)
				from  DPagosCxP  a
				inner join EPagosCxP x
					on a.IDpago = x.IDpago
				inner join ImpIEPSDocumentosCxP b
					on a.Ecodigo = b.Ecodigo
					and a.IDdocumento = b.IDdocumento
				inner join EDocumentosCP c
					on a.Ecodigo = c.Ecodigo
					and a.IDdocumento = c.IDdocumento
				inner join CPTransacciones d
					on c.Ecodigo = d.Ecodigo
					and c.CPTcodigo = d.CPTcodigo
				inner join Impuestos ie
					on b.Ecodigo = ie.Ecodigo
					and b.codIEPS = ie.Icodigo
				where a.Ecodigo =  #Arguments.Ecodigo#
				and a.IDpago    =#Arguments.IDpago#
			</cfquery>
	</cffunction>

	<cffunction name="CP_Pago_ActualizaImp" access="public"  output="false">
		<cfargument name='IDdocumento'	type="numeric" 	required='true'>
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name='MontoDoc'		type="numeric" 	required='true'>
		<cfargument name='RetDoc'		type="numeric" 	required='true'>
		<cfargument name='Conexion' 	type="string" 	required='true'>

			<!---
			<cfquery name="sel1" datasource="#Arguments.Conexion#">
				select Icodigo, TotalFac,SubTotalFac,MontoBaseCalc,MontoCalculado,MontoPagado,Iporcentaje from ImpDocumentosCxP where IDdocumento = #Arguments.IDdocumento#;
			</cfquery>
			<cfdump var="#sel1#"> --->
			<cfquery name="rsUPImpDocumentosCxP" datasource="#Arguments.Conexion#">
				update Imp
				set MontoPagado = case iporcentaje when 0 then  0 else 
					IsNull(MontoPagado,0) + round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)/ed.EDSaldo)*Imp.MontoCalculado,2)
					end
				from ImpDocumentosCxP Imp 
					inner join EDocumentosCP ed
						on ed.IDdocumento = Imp.IDdocumento
				where Imp.Ecodigo = #Arguments.Ecodigo#
				and Imp.IDdocumento = #Arguments.IDdocumento#
			</cfquery>

			<cfquery name="rsUPImpDocumentosCxP" datasource="#Arguments.Conexion#">
				update ImpDocumentosCxP
				set MontoCalculado = case iporcentaje when 0 then  0 else 
					round(((MontoBaseCalc*(Iporcentaje/100)) - IsNull(MontoPagado,0)),2)
					end
				where Ecodigo = #Arguments.Ecodigo#
				and IDdocumento = #Arguments.IDdocumento#
			</cfquery>
			
			<!---
			<cfquery name="sel1" datasource="#Arguments.Conexion#">
				select Icodigo, TotalFac,SubTotalFac,MontoBaseCalc,MontoCalculado,MontoPagado,Iporcentaje from ImpDocumentosCxP where IDdocumento = #Arguments.IDdocumento#;
			</cfquery>
			<cfdump var="#sel1#" abort> --->

			<cfquery datasource="#Arguments.Conexion#">
				update a1
				   set OIVAPagado = coalesce(OIVAPagado,0) + round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)
				       * (a1.OIVAAcreditable + a1.OIVAPagado))/a2.Dtotal,2),
				   	   OIVAAcreditable = OIVAAcreditable - round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)
				       * (a1.OIVAAcreditable + a1.OIVAPagado))/a2.Dtotal,2),
				   	   LIVAPagado = LIVAPagado + (round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)
				       * (a1.OIVAAcreditable + a1.OIVAPagado))/a2.Dtotal,2) * a1.TipoCambioIVA),
				       LIVAAcreditable = LIVAAcreditable - (round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)
				       * (a1.OIVAAcreditable + a1.OIVAPagado))/a2.Dtotal,2) * a1.TipoCambioIVA),
				       BMUsucodigo = #session.Usucodigo#,
				   	   ts_rversion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					   Pagado = 1
				 from DIOT_Control a1
				   inner join EDocumentosCP a2
				   on a2.IDdocumento = a1.CampoId
				 where a1.Ecodigo = #Arguments.Ecodigo#
				   and a1.CampoId  = #Arguments.IDdocumento#
			</cfquery>
			<!---
			<cfquery name="sel2" datasource="#Arguments.Conexion#">
				select codIEPS,TotalFac,SubTotalFac,MontoBaseCalc,MontoCalculadoIeps,MontoPagadoIeps from ImpIEPSDocumentosCxP where IDdocumento = #Arguments.IDdocumento#;
			</cfquery>
			<cfdump var="#sel2#" > --->

			<!--- cambio en tabla ieps --->
			<cfquery name="rsUPImpDocumentosCxP2" datasource="#Arguments.Conexion#">
				update Imp
				set MontoPagadoIeps =  IsNull(MontoPagadoIeps,0) + round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)/ed.EDSaldo)*Imp.MontoCalculadoIeps,2),
					MontoCalculadoIeps = IsNull(MontoCalculadoIeps,0) - round(((#Arguments.MontoDoc# + #Arguments.RetDoc#)/ed.EDSaldo)*Imp.MontoCalculadoIeps,2)
				from ImpIEPSDocumentosCxP Imp 
					inner join EDocumentosCP ed
						on ed.IDdocumento = Imp.IDdocumento
				where Imp.Ecodigo = #Arguments.Ecodigo#
				and Imp.IDdocumento = #Arguments.IDdocumento#
			</cfquery>
			<!---
			<cfquery name="sel2" datasource="#Arguments.Conexion#">
				select codIEPS,TotalFac,SubTotalFac,MontoBaseCalc,MontoCalculadoIeps,MontoPagadoIeps from ImpIEPSDocumentosCxP where IDdocumento = #Arguments.IDdocumento#;
			</cfquery>
			<cfdump var="#sel2#" abort> --->
	</cffunction>

	<cffunction name="sbControlPresupuesto_PagosCxP" access="private">
		<cfargument name='IDpago' 		type='numeric' 	required='true'>	 <!--- Codigo del movimiento ---->
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="Oorigen"		type="string"	required="yes" >
		<cfargument name="Edocbase"		type="string"	required="yes" >
		<cfargument name="Ereferencia"	type="string"	required="yes" >
		<cfargument name="Efecha"		type="date"		required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name='Conexion' 	type='string' 	required='true'>
<!--- Control Evento Inicia --->
    	<cfargument name='NumeroEvento' type='string'	required='false' default="">
<!--- Control Evento Fin --->
		<!--- Genera los movimientos de Presupuesto en Efectivo (EJERCIDO Y PAGADO) a partir del NAP de las facturas pagadas --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1140
		</cfquery>

		<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>
		<cfif LvarGenerarEjercido>
			<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
			<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Oorigen,Arguments.IDpago,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'EJ')>
			<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Oorigen,Arguments.IDpago,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>


		<cfelse>
			<!--- Movimientos de PAGADO: Presupuesto normal --->
			<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Oorigen,Arguments.IDpago,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>
		</cfif>

		<cfquery name="rsNAP" datasource="#session.DSN#">
			select  distinct cp.NAP as NAP
				from EPagosCxP e
					inner join DPagosCxP d
						 on d.IDpago = e.IDpago
					inner join HEDocumentosCP cp
						 on cp.IDdocumento = d.IDdocumento
						and coalesce(cp.NAP, 0) <> 0
					inner join CPNAPdetalle nap
						  on nap.Ecodigo		= e.Ecodigo
						 and nap.CPNAPnum		= cp.NAP
						 and nap.CPNAPDtipoMov = 'E'
				where e.IDpago =#Arguments.IDpago#
		</cfquery>

	<cfif rsNAP.recordcount gt 0>
        <cfquery name ="rsNAPsAnosAnteriores" datasource="#Arguments.Conexion#">
			select  top 1 (d.CPNAPnum) from EDocumentosCP cxp
				inner join CPNAP n
					 on n.Ecodigo	= cxp.Ecodigo
					and n.CPNAPnum	= cxp.NAP
                    and n.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
				inner join CPNAPdetalle d
					 on d.Ecodigo		= n.Ecodigo
					and d.CPNAPnum		= n.CPNAPnum
					and d.CPNAPDtipoMov	in ('E','E2')
			where cxp.Ecodigo		= #Arguments.Ecodigo#
			  and cxp.EDsaldo		> 0
			  and cxp.Dtotal		> 0
			  and coalesce(cxp.NAP,0) <> 0
              and d.CPNAPnum = #rsNAP.NAP#
              group by d.CPNAPnum
		</cfquery>
	</cfif>

		<cfif rsNAP.recordcount gt 0 and rsNAPsAnosAnteriores.recordcount GTE 1>
        	<cfset varCPCPagado_Anterior = "1">
        <cfelse>
        	<cfset varCPCPagado_Anterior = "0">
        </cfif>

		<!--- Genera las ejecuciones del Pago a partir del Asiento contable generado --->
		<cfinvoke component	= "PRES_Presupuesto" method= "ControlPresupuestarioINTARC" returnvariable	= "LvarIC">
					<cfinvokeargument name="ModuloOrigen"  		value="#Arguments.Oorigen#"/>
					<cfinvokeargument name="NumeroDocumento" 	value="#Arguments.Edocbase#"/>
					<cfinvokeargument name="NumeroReferencia" 	value="#Arguments.Ereferencia#"/>
					<cfinvokeargument name="FechaDocumento" 	value="#Arguments.Efecha#"/>
					<cfinvokeargument name="AnoDocumento"		value="#Arguments.Eperiodo#"/>
					<cfinvokeargument name="MesDocumento"		value="#Arguments.Emes#"/>
					<cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Intercompany" 		value="no"/>
					<cfinvokeargument name="BorrarIntPres" 		value="no"/>
<!--- Control Evento Inicia --->
        			<cfinvokeargument name='NumeroEvento' 		value="#Arguments.NumeroEvento#"/>
<!--- Control Evento Fin --->
<!--- Inicio PagoAñoAnteriores--->
        			<cfinvokeargument name='PagoAnoAnteriores' 		value="#varCPCPagado_Anterior#"/>
<!--- Fin PagoAñoAnteriores --->
		</cfinvoke>


		<cfset LvarNAP = LvarIC.NAP>
		<cfif LvarNAP LT 0>
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>
		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="sbPresupuestoAntsEfectivo_CxP" access="private">
		<cfargument name="Origen">
		<cfargument name="IDpago">
		<cfargument name="Fecha">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Anulacion">
		<cfargument name="TipoMov">



		<!--- Convierte las Ejecuciones del NAP de CxP a Pagado --->
		<!--- OJO, cuando se implemente Contabilizacion en Recepcion, hay que tomar en cuenta el NAP de la Recepción --->
		<cfquery datasource="#session.DSN#">
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
					CFcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,	LINreferencia,
					PCGDid,
					PCGDcantidad
				)
			<!--- 'EJ/P:PAGADO' --->
			select  '#Arguments.Origen#',
					e.EPdocumento,
					e.CPTcodigo,
					<cf_dbfunction name="concat" args="'CxP: ';cp.CPTcodigo;'-';rtrim(cp.Ddocumento)" delimiters=";">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,

					coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
					<cfif Arguments.TipoMov NEQ 'P'>-</cfif>nap.CPNAPnum*100000+nap.CPNAPDlinea as NumeroLineaID,
					nap.CFcuenta,																				<!--- CFuenta --->
					nap.Ocodigo,																				<!--- Oficina --->

					nap.Mcodigo,																				<!--- Mcodigo --->
					<cfif Arguments.Anulacion>-</cfif>round((d.DPmontodoc + d.DPmontoretdoc) / cp.Dtotal * nap.CPNAPDmontoOri,2) as MontoOrigen,
					case when round(d.DPmontodoc + d.DPmontoretdoc,2)!=0.00 then round((d.DPmontodoc + d.DPmontoretdoc) / d.DPtipocambio * e.EPtipocambio,2)/round(d.DPmontodoc + d.DPmontoretdoc,2) else 1 end as TC,
					round(
					<cfif Arguments.Anulacion>-</cfif>round((d.DPmontodoc + d.DPmontoretdoc) / cp.Dtotal * nap.CPNAPDmontoOri,2)
						* case when round(d.DPmontodoc + d.DPmontoretdoc,2)!=0.00 then round((d.DPmontodoc + d.DPmontoretdoc) / d.DPtipocambio * e.EPtipocambio,2)/round(d.DPmontodoc + d.DPmontoretdoc,2) else 1 end
					,2) as MontoLocal,

					'#Arguments.TipoMov#' as Tipo,
					nap.CPNAPnum, nap.CPNAPDlinea,
					nap.PCGDid,
					<cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
				from EPagosCxP e
					inner join DPagosCxP d
						 on d.IDpago = e.IDpago
					inner join HEDocumentosCP cp
						 on cp.IDdocumento = d.IDdocumento
						and coalesce(cp.NAP, 0) <> 0
					inner join CPNAPdetalle nap
						  on nap.Ecodigo		= e.Ecodigo
						 and nap.CPNAPnum		= cp.NAP
						 and nap.CPNAPDtipoMov = 'E'
				where e.IDpago =#Arguments.IDpago#
		</cfquery>

	</cffunction>

    <cffunction name="AnticipoEvento" output="no">
        <cfargument name="CPTcodigo"	type="string" 	required="yes">
        <cfargument name="IDpago"		type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
        <cfargument name="Conexion" 	type="string" 	default="#session.DSN#">

        <!--- Genera el Numero de Evento para el Anticipo --->
        <cfquery name="rsAnticipoEV" datasource="#arguments.conexion#">
            select <cf_dbfunction name="sPart"	args="Anti.NC_CPTcodigo,1,2"> as NC_CPTcodigo,
                <cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20"> as NC_Ddocumento,
                a.SNcodigo
            from EPagosCxP a
                    inner join APagosCxP Anti
                        on a.IDpago = Anti.IDpago
                where a.Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.CPTcodigo 	=  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CPTcodigo#">
                  and a.IDpago 		=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
        </cfquery>

        <cfif rsAnticipoEV.recordcount GT 0 and rsAnticipoEV.NC_Ddocumento NEQ "">
            <cfinvoke component="sif.Componentes.CG_ControlEvento"
                method		= "CG_GeneraEvento"
                Origen		= "CPFC"
                Transaccion	= "#rsAnticipoEV.NC_CPTcodigo#"
                Documento 	= "#rsAnticipoEV.NC_Ddocumento#"
                SocioCodigo = "#rsAnticipoEV.SNcodigo#"
                Conexion	= "#Arguments.Conexion#"
                Ecodigo		= "#Arguments.Ecodigo#"
                returnvariable	= "arNumeroEventoAN"
            />
            <cfif arNumeroEventoAN[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
        </cfif>
    </cffunction>
</cfcomponent>
