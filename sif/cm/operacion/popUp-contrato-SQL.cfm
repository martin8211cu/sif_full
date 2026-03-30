<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->
<cfset request.error.backs = 1>
<!--- <cfdump var="#url#">
<cf_dump var="#form#"> --->
<cfif isdefined ('url.Icodigo') and len(trim(#url.Icodigo#))>
	<cfset Icodigo =#url.Icodigo#>
</cfif>


<cfif isdefined("Form.chk")>

    <!---Si se define un monto a distribuir entre las suficiencias--->
	<cfif isdefined("url.montoTotal") and trim(url.montoTotal) NEQ "" and url.montoTotal gt 0 >
        <cfset LvarCPDDids 	= "">
        <cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
        	<cfset LvarDet 		= #ListToArray(LvarLin, "|")#>
            <cfset LvarCPDDids 	= ListAppend(LvarCPDDids,LvarDet[1])>
        </cfloop>

        <cfquery name="rsSQL" datasource="#session.dsn#">
            select sum(isnull(d.CTDCmontoTotal,0) - isnull(d.CTDCmontoConsumido,0)) as SaldoTotal
            from CTContrato e
                inner join CTDetContrato d
                    on d.CTContid = e.CTContid
                left join Conceptos c
                    on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
            where e.Ecodigo=#session.Ecodigo#
            and d.CTDCont in (#LvarCPDDids#)
        </cfquery>
    	<cfset LvarMontoTotal = fnRedondear(url.montoTotal)>
        <cfset LvarSaldoTotal = fnRedondear(rsSQL.SaldoTotal)>
       	<cfif LvarMontoTotal GT LvarSaldoTotal>
        	<cfthrow message="El Monto indicado a Utilizar (#numberformat(LvarMontoTotal,9.99)#)es mayor al Saldo de los Contratos seleccionados (#numberformat(LvarSaldoTotal,9.99)#)">
		</cfif>
        <cfquery name="rsSQL" datasource="#session.dsn#">
            select sum(round(isnull(d.CTDCmontoTotal,0) * #LvarMontoTotal / LvarSaldoTotal#,2)) as DistribuidoTotal
            from CTContrato e
                inner join CTDetContrato d
                    on d.CTContid = e.CTContid
                left join Conceptos c
                    on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
            where e.Ecodigo=#session.Ecodigo#
            and d.CTDCont in (#LvarCPDDids#)
        </cfquery>
		<cfset LvarAjusteTotal = rsSQL.DistribuidoTotal - LvarMontoTotal>
    <cfelse>
    	<cfset LvarMontoTotal = -1>
        <cfset LvarSaldoTotal = 0>
	</cfif>

	<!---Recorre cada suficiencia seleccionada para irla insertando--->
	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
		<cfset LvarDet 		= #ListToArray(LvarLin, "|")#>
		<cfset LvarCPDDid 	= LvarDet[1]>
		<cfset LvarLlave 	= LvarDet[2]>
		<cfset LvarModulo 	= LvarDet[3]>

		<cftransaction>
			<cfquery name="rsDatos" datasource="#session.dsn#">
				select d.CTDCont,d.Cid, d.ACcodigo, d.ACid, isnull(c.Cdescripcion,ca.ACdescripcion) as Cdescripcion, d.CFid,
					round(isnull(d.CTDCmontoTotal,0) - isnull(d.CTDCmontoConsumido,0),2) as CPDDsaldo,
					CPDDid, CTCnumContrato CPDEnumeroDocumento, d.CPCano, d.CPCmes, d.CMtipo CPDDtipoItem,d.CPDCid
				from CTContrato e
	                inner join CTDetContrato d
	                    on d.CTContid = e.CTContid
					left join Conceptos c
						on c.Cid=d.Cid
					left join ACategoria ca on
						ca.ACcodigo = d.ACcodigo
					left join AClasificacion cl
						on cl.ACid = d.ACid
				where e.Ecodigo=#session.Ecodigo#
				and d.CTDCont=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPDDid#">
			</cfquery>

            <!---Si se definio un monto a distribuir aqui se saca el peso de cada suficiencia--->
			<cfif LvarMontoTotal EQ -1>
				<cfset LvarSaldo = rsDatos.CPDDsaldo>
            <cfelse>
				<cfset LvarSaldo = fnRedondear(LvarMontoTotal * rsDatos.CPDDsaldo / LvarSaldoTotal)>
				<cfif LvarAjusteTotal GT 0>
					<cfset LvarSaldo		= LvarSaldo - 0.01>
					<cfset LvarAjusteTotal	= LvarAjusteTotal - 0.01>
				<cfelseif LvarAjusteTotal LT 0>
					<cfset LvarSaldo		= LvarSaldo + 0.01>
					<cfset LvarAjusteTotal	= LvarAjusteTotal + 0.01>
				</cfif>
            </cfif>

            <cfquery name="rsUnidades" datasource="#session.dsn#">
                select Ucodigo   from Unidades
                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and upper(Ucodigo) like  upper('%UNI%')
            </cfquery>

            <cfif rsUnidades.recordcount eq 0 >
                <cfquery name="rsUnidades" datasource="#session.dsn#">
                    select min(Ucodigo)   from Unidades
                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
            </cfif>

            <cfset form.CMtipo = rsDatos.CPDDtipoItem>

            <!---Cuando es ORDEN DE COMPRA--->
			<cfif LvarModulo eq 'EO'>
                <cfquery name="rsOrdenCompra" datasource="#session.dsn#">
                    select  EOnumero, EOtc
                        from EOrdenCM
                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                        and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                </cfquery>

				<!---Inserta linea de detalle--->
				<cfif rsOrdenCompra.EOtc NEQ "" and rsOrdenCompra.EOtc NEQ "0" and rsOrdenCompra.EOtc NEQ "1">
					<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsOrdenCompra.EOtc)>
				<cfelse>
					<cfset LvarSaldoSuf = LvarSaldo>
				</cfif>

				<!--- verificando si ya se agrego la linea de contrato a la orden de compra --->
				<cfquery name="getOrden" datasource="#session.dsn#">
					select top 1 *
					from DOrdenCM
					where EOnumero = #rsOrdenCompra.EOnumero#
					and CTDContid = #LvarCPDDid#
				</cfquery>

				<cfif getOrden.recordCount GT 0>
					<cfset LvarSaldoSuf = LvarSaldoSuf + getOrden.DOtotal>
					<cfinvoke component="sif.Componentes.CM_AplicaOC" method="delete_DOrdenCM">
				        <cfinvokeargument name="dolinea" 		value="#getOrden.DOlinea#">
				        <cfinvokeargument name="eoidorden" 		value="#getOrden.EOidorden#">
				        <cfinvokeargument name="ecodigo" 		value="#Session.Ecodigo#">
					</cfinvoke>

				</cfif>
					<cfinvoke 	component	= "sif.Componentes.CM_AplicaOC"
                            method		= "insert_DOrdenCM"

                            eoidorden="#LvarLlave#"
                            CTDContid="#LvarCPDDid#"
                            eonumero="#rsOrdenCompra.EOnumero#"
                            ecodigo="#Session.Ecodigo#"
                            cmtipo="#form.CMtipo#"
                            cid="#rsDatos.Cid#"
                            dodescripcion="#rsDatos.Cdescripcion# (#rsDatos.CPCano#-#rsDatos.CPCmes#)"
                            docantidad="1"
                            dopreciou="#LvarSaldoSuf#"
                            dofechaes="#LSDateFormat(Now(),'dd/mm/yyyy')#"
                            cfid="#rsDatos.CFid#"
                            icodigo="#Icodigo#"
                            ucodigo="#rsUnidades.Ucodigo#"
                            dofechareq="#LSDateFormat(Now(),'dd/mm/yyyy')#"
							ACcodigo="#rsDatos.ACcodigo#"
							ACid="#rsDatos.ACid#"
                            PlantillaDistribucion="#rsDatos.CPDCid#"
					/>


                <!---calcula Monto--->
                <cfinvoke 	component	= "sif.Componentes.CM_AplicaOC"
                        method		= "calculaTotalesEOrdenCM"

                        ecodigo="#Session.Ecodigo#"
                        eoidorden="#LvarLlave#"
                />

            </cfif><!---Fin ORDEN DE COMPRA--->
            <!---*************************************************************************************--->
            <!---Cuando es SOLICITUD DE PAGO--->
			<cfif LvarModulo eq 'SPM' or LvarModulo eq 'SPM_CF'>

                <cfquery name="rsSP" datasource="#session.dsn#">
                    select TESid, TESSPnumero, TESSPfechaPagar, McodigoOri, coalesce(sn.SNid,-1) as SNid
                      from TESsolicitudPago sp
                      	left join SNegocios sn on sn.Ecodigo=sp.EcodigoOri and sn.SNcodigo=sp.SNcodigoOri
                     where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
                </cfquery>

                <cfquery name="sigMoneda" datasource="#session.dsn#">
                    select Miso4217
                    from Monedas
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.McodigoOri#">
                </cfquery>

                <cfquery name="rsSPCentrF" datasource="#session.dsn#">
                    select sp.CFid, cf.Ocodigo, cf.CFcodigo, sp.TESSPtipoCambioOriManual
                      from TESsolicitudPago sp
                        inner join CFuncional cf
                           on cf.CFid = sp.CFid
                     where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
                </cfquery>


                <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
				<cfset LvarCFformato = mascara.fnComplementoItem(session.Ecodigo, rsSPCentrF.CFid, rsSP.SNid, "S", "", rsDatos.Cid, "", "")>

                <!--- Obtener Cuenta --->
                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
                          method="fnGeneraCuentaFinanciera"
                          returnvariable="LvarError">
                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                            <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                </cfinvoke>

                <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                    <!--- trae el id de la cuenta financiera --->
                    <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                        select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                        from CFinanciera a
                            inner join CPVigencia b
                                 on a.CPVid     = b.CPVid
                                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.CPVdesde and b.CPVhasta
                        where a.Ecodigo   = #session.Ecodigo#
                          and a.CFformato = '#LvarCFformato#'
                    </cfquery>
                <cfelse>
                	<cfthrow message="#LvarError#">
                </cfif>


                <cfquery datasource="#session.dsn#">
                    insert INTO TESdetallePago
                        (
                            TESid, CFid, OcodigoOri,
                            TESDPestado, EcodigoOri, TESSPid, TESDPtipoDocumento, TESDPidDocumento,
                            TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                            SNcodigoOri, TESDPfechaVencimiento,
                            TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri,
                            TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
                            Cid, CPDDid,
                            TESDPdescripcion, CFcuentaDB,TESDPespecificacuenta
                        )
                    values (
                            #rsSP.TESid#, #rsDatos.CFid#, #rsSPCentrF.Ocodigo#,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">,
                            <cfif LvarModulo eq 'SPM_CF'>
                            	5,
                            <cfelse>
                            	0,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">,
                            'TESP',
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CPDEnumeroDocumento#">,
							'Suficiencia',
                            <cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
                            <cfqueryparam cfsqltype="cf_sql_char" value="#sigMoneda.Miso4217#">,
							<cfif rsSPCentrF.TESSPtipoCambioOriManual NEQ "" and rsSPCentrF.TESSPtipoCambioOriManual NEQ "0" and rsSPCentrF.TESSPtipoCambioOriManual NEQ "1">
								<cfset LvarSaldoSuf = LvarSaldo/rsSPCentrF.TESSPtipoCambioOriManual>
							<cfelse>
								<cfset LvarSaldoSuf = LvarSaldo>
							</cfif>
                            round(#LvarSaldoSuf#,2),
                            round(#LvarSaldoSuf#,2),
                            round(#LvarSaldoSuf#,2),
                            #rsDatos.Cid#,
                            #LvarCPDDid#,
                            <cfif isdefined('rsDatos.Cdescripcion') and len(trim(rsDatos.Cdescripcion))>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Cdescripcion# (#rsDatos.CPCano#-#rsDatos.CPCmes#)">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTraeCuenta.CFcuenta#">,
                            0 <!---espeficica cuenta--->
                        )
                </cfquery>

                <cfquery datasource="#session.dsn#">
                    update TESsolicitudPago
                        set TESSPtotalPagarOri =
                                coalesce(
                                ( select round(sum(TESDPmontoSolicitadoOri),2)
                                    from TESdetallePago
                                   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
                                )
                                , 0)
                            , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
                    where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
                </cfquery>
            </cfif>
		</cftransaction>
	</cfloop>

	<script language="JavaScript" type="text/javascript">

		<!---Cuando es ORDEN DE COMPRA--->
		<cfif LvarModulo eq 'EO'>
			//llama a la funcion de cambio de orden de compra
			if (window.opener.document.form1.Cambio)
				window.opener.document.form1.Cambio.click();
			else if (window.opener.document.form1.CambioDet)
				window.opener.document.form1.CambioDet.click();
		</cfif>

		<cfif LvarModulo eq 'SPM' or LvarModulo eq 'SPM_CF'>

			<!---if (window.opener.document.formDet.CambioDet)
				window.opener.document.formDet.CambioDet.click();
			else if (window.opener.document.formDet.AltaDet)
				window.opener.document.formDet.AltaDet.click();--->
				window.opener.location.reload();
		</cfif>
        window.close();
    </script>
<cfelse>
<cflocation url="popUp-contrato-clas.cfm?EOidorden=#form.llave#&Contid=#form.CPDDid#">

</cfif>
<cffunction name="fnRedondear" returntype="numeric">
	<cfargument name="Numero" type="numeric">
	<cfreturn round(Numero*100)/100>
</cffunction>