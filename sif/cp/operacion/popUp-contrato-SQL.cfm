<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->
<cfset request.error.backs = 1>
<!--- <cfdump var="#url#">--->
<!---<cf_dump var="#form#">--->
<cfif isdefined ('url.Icodigo') and len(trim(#url.Icodigo#))>
	<cfset Icodigo =#url.Icodigo#>
</cfif>
<cfif isdefined("Form.btnAgregar")>
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

        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <cfset CON_REQUISICION_AL_GASTO	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 1 where sc.ESidsolicitud = a.ESidsolicitud) is NOT NULL">
        <cfset CUENTA_ALMACEN			= "(select min(cf.CFcuenta) from Existencias e inner join IAContables c inner join CFinanciera cf on cf.Ccuenta=c.IACinventario on c.Ecodigo = e.Ecodigo and c.IACcodigo = e.IACcodigo where e.Ecodigo = a.Ecodigo and e.Aid = a.Aid and e.Alm_Aid = a.Alm_Aid)">


        <!---Recorre cada detalle de los contratos seleccionados para ir insertando--->
        <cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
            <cfset LvarDet 			= #ListToArray(LvarLin, "|")#>
            <cfset LvarCPDDid 		= LvarDet[1]>
            <cfset LvarLlave 		= LvarDet[2]>
            <cfset LvarModulo 		= LvarDet[3]>
            <cfset LvarPos2DOlinea 	= LvarDet[4]>

            <cftransaction>
                <cfquery name="rsDatos" datasource="#session.dsn#">
                    select d.CTDCont,d.Cid, d.ACcodigo, d.ACid, isnull(c.Cdescripcion,ca.ACdescripcion) as Cdescripcion, d.CFid,
                        round(isnull(d.CTDCmontoTotal,0) - isnull(d.CTDCmontoConsumido,0),2) as CPDDsaldo,
                        d.CTDCconsecutivo,dep.Dcodigo, e.SNid, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Icodigo#"> Icodigo, null Ucodigo<!--- d.Ucodigo --->,d.CPDCid,
                        CPDDid, CTCnumContrato CPDEnumeroDocumento, d.CPCano, d.CPCmes, d.CMtipo, e.CTfecha
                    from CTContrato e
                        inner join CTDetContrato d
                            on d.CTContid = e.CTContid
                        left join CFuncional cf
                            on cf.CFid = d.CFid
                            and cf.Ecodigo = d.Ecodigo
                        left join Departamentos dep
                            on dep.Dcodigo = cf.Dcodigo
                            and dep.Ecodigo = cf.Ecodigo
                        left join Conceptos c
                            on c.Cid=d.Cid
                        left join ACategoria ca on
                            ca.ACcodigo = d.ACcodigo
                        left join AClasificacion cl
                            on cl.ACid = d.ACid
                    where e.Ecodigo=#session.Ecodigo#
                    and d.CTDCont=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPDDid#">
                </cfquery>

                <!---Si se definio un monto a distribuir aqui se saca el peso de cada detalle--->
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

                <cfset form.CMtipo = rsDatos.CMtipo>

                <!---Cuando es Factura--->
                <cfif LvarModulo eq 'CxP'>
                    <cfquery name="rsCxP" datasource="#session.dsn#">
                        select  EDdocumento, EDtipocambio EOtc, IDdocumento
                        from EDocumentosCxP
                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                    </cfquery>

                    <!---Inserta linea de detalle--->
                    <cfif rsCxP.EOtc NEQ "0" and rsCxP.EOtc NEQ "1">
                        <cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsCxP.EOtc)>
                    <cfelse>
                        <cfset LvarSaldoSuf = LvarSaldo>
                    </cfif>

                    <!--- verificando si ya se agrego la linea de contrato a la orden de compra --->
                    <cfquery name="getCxP" datasource="#session.dsn#">
                        select top 1 *
                        from DDocumentosCxP
                        where IDdocumento = #rsCxP.IDdocumento#
                        and CTDContid = #LvarCPDDid#
                    </cfquery>

                    <cfif getCxP.recordCount GT 0>
                        <cfset LvarSaldoSuf = LvarSaldoSuf + getCxP.DDtotallinea>
                            <!--- si el detalle viene de un contrato --->
                            <cfif getCxP.CTDContid NEQ ''>
								<cfquery name="rstcCxp" datasource="#session.dsn#">
									select Mcodigo,EDtipocambio from EDocumentosCxP where IDdocumento = #rsCxP.IDdocumento#
								</cfquery>
								<cfset tcCxP = #rstcCxp.EDtipocambio#>
                                <cfquery name="updDetContrato" datasource="#session.dsn#">
                                    update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) - #getCxP.DDtotallinea*tcCxP#,2)
                                    where CTDCont = #getCxP.CTDContid#
                                </cfquery>
                            </cfif>
                            <cfquery name="delete" datasource="#session.DSN#">
                                delete from DDocumentosCxP
                                where Linea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#getCxP.Linea#">
                                  and IDdocumento =  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCxP.IDdocumento#">
                            </cfquery>
                    </cfif>

                        <!--- obteniendo cuenta financiera --->
                        <cfif NOT LEN(TRIM(rsDatos.SNid))>
                            <cfset rsDatos.SNid = -1>
                        </cfif>
                        <!--- <cf_dump var="#Arguments.EcodigoAlterno#, #rsDatos.CFid#, #rsDatos.SNid#, #rsDatos.CMtipo#, #rsDatos.Aid#, #rsDatos.Cid#, #rsDatos.ACcodigo#, #rsDatos.ACid#,#rsDatos.actEmpresarial#"> --->
                        <!---►►Se sustituyen los "?" por el Objeto de gasto configurado en el Auxiliar y "_" por el complemento de la Actividad Empresarial◄◄--->
                        <cfset LvarFormatoCuenta = mascara.fnComplementoItem(#session.Ecodigo#, rsDatos.CFid, rsDatos.SNid, rsDatos.CMtipo,'', rsDatos.Cid, rsDatos.ACcodigo, rsDatos.ACid,'')>

                        <!--- Obtener Cuenta --->
                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
                            <cfinvokeargument name="Lprm_fecha" 			value="#rsDatos.CTfecha#"/>
                            <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                            <cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
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
                                select CFcuenta, Ccuenta
                                from CFinanciera a
                                    inner join CPVigencia b
                                        on b.CPVid = a.CPVid
                                where a.Ecodigo   = #session.Ecodigo#
                                  and a.CFformato = '#LvarFormatoCuenta#'
                                  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.CTfecha#"> between b.CPVdesde and b.CPVhasta
                            </cfquery>
                        </cfif>
                        <cfset LvarCuentaFinanciera = rsTraeCuenta.CFcuenta>
                        <cfset LvarCuentaContable = rsTraeCuenta.Ccuenta>

                        <cfquery name="rsInsert" datasource="#Session.DSN#">
                            insert into DDocumentosCxP (IDdocumento, DOlinea, Cid, Ecodigo, Dcodigo, Ccuenta, CFcuenta, CFid, Aid, DDdescripcion, DDdescalterna,
                                        DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo, Ucodigo, FPAEid, CFComplemento, PCGDid, OBOid,
                                        CPDCid, CTDContid)
                            values(#LvarLlave#,null,<cfif len(trim(#rsDatos.Cid#))>#rsDatos.Cid#<cfelse>null</cfif>,#session.Ecodigo#,#rsDatos.Dcodigo#,
                                        <!--- Debe escoger la Ccuenta correspondiente a la CFcuenta --->
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaContable#">,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaFinanciera#">,
                                        #rsDatos.CFid#,
                                        NULL,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Cdescripcion#">,
                                        NULL,
                                        1,
                                        #LvarSaldoSuf#,
                                        0,
                                        0,
                                        #LvarSaldoSuf#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CMtipo#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Ucodigo#">,
                                        NULL,
                                        NULL,
                                        NULL,
                                        NULL,
                                        <!---JMRV. Inicio del Cambio. 30/04/2014 --->
                                        <cfif len(trim(#rsDatos.CPDCid#))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CPDCid#"><cfelse>NULL</cfif>,
                                        <!---JMRV. Fin del Cambio. 30/04/2014 --->
                                        #rsDatos.CTDCont#
                                    )
                        </cfquery>

                        <!--- Elimina el descuento si es mayor que el total linea --->
                        <cfquery datasource="#session.DSN#">
                            update DDocumentosCxP
                               set DDdesclinea		= 0
                                 , DDporcdesclin	= 0
                            where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                              and DOlinea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
                              and DDdesclinea 	> DDcantidad * DDpreciou
                        </cfquery>


                        <!--- Calcula el total linea --->
                        <cfquery datasource="#session.DSN#">
                            update DDocumentosCxP
                               set DDtotallinea		= round((DDcantidad * DDpreciou)- DDdesclinea,2)
                            where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                              and DOlinea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
                        </cfquery>

                        <!------>
                        <cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
                            select coalesce(sum(b.DDtotallinea * d.DIporcentaje / 100.00),0.00) as TotalImpuesto
                            from EDocumentosCxP a left outer join DDocumentosCxP b
                              on a.IDdocumento = b.IDdocumento and
                                 a.Ecodigo = b.Ecodigo left outer join Impuestos c
                              on a.Ecodigo = c.Ecodigo and
                                 b.Icodigo = c.Icodigo left outer join DImpuestos d
                              on c.Ecodigo = d.Ecodigo and
                                 b.Icodigo = d.Icodigo
                            where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                              and  c.Icompuesto = 1
                        </cfquery>
                        <cfquery name="rsTotalImpuesto1" datasource="#session.DSN#">
                            select coalesce(sum(b.DDtotallinea * c.Iporcentaje / 100.00),0.00) as TotalImpuesto
                            from EDocumentosCxP a left outer join DDocumentosCxP b
                              on a.Ecodigo = b.Ecodigo and
                                 a.IDdocumento = b.IDdocumento left outer join Impuestos c
                              on b.Ecodigo = c.Ecodigo and
                                 b.Icodigo = c.Icodigo
                            where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                              and c.Icompuesto = 0
                        </cfquery>
                        <cfquery name="rsTotal" datasource="#session.DSN#">
                            select coalesce(sum(a.DDtotallinea),0.00) as Total
                            from DDocumentosCxP a inner join EDocumentosCxP b
                              on a.IDdocumento = b.IDdocumento
                              and a.Ecodigo = b.Ecodigo
                            where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                        </cfquery>
                        <!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
                        <cfquery name="rsUpdateE" datasource="#session.DSN#">
                                update EDocumentosCxP
                                set EDimpuesto = round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
                                           ,EDtotal = #rsTotal.Total#
                                                      + round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
                                                      -  EDdescuento
                               where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
                                 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        </cfquery>

					<cfquery name="rstcCxp" datasource="#session.dsn#">
						select Mcodigo,EDtipocambio from EDocumentosCxP where IDdocumento = #LvarLlave#
					</cfquery>
					<cfset tcCxP = #rstcCxp.EDtipocambio#>

                    <cfquery name="vDetContrato" datasource="#session.dsn#">
                        select CTDCmontoTotal,isnull(CTDCmontoConsumido,0) + #LvarSaldoSuf*tcCxP# as CTDCmontoConsumido from CTDetContrato
                        where CTDCont = #rsDatos.CTDCont#
                    </cfquery>
                    <cfif  vDetContrato.CTDCmontoConsumido GT vDetContrato.CTDCmontoTotal>
                        <cfthrow message="El monto consumido es mayor que el monto del Contrato">
                    </cfif>

                            <cfquery name="updDetContrato" datasource="#session.dsn#">
                                update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) + #LvarSaldoSuf*tcCxP#,2)
                                where CTDCont = #LvarCPDDid#
                            </cfquery>
                        <!--- </cfif> --->

                </cfif>
            </cftransaction>
        </cfloop>

        <script language="JavaScript" type="text/javascript">
            if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
            window.close();
        </script>

    <cfelse>
        <cflocation url="popUp-contrato.cfm?IDdocumento=#form.llave#">
    </cfif>
<cfelse>
<cflocation url="popUp-contrato-clas.cfm?IDdocumento=#form.llave#&Contid=#form.CPDDid#">

</cfif>
<cffunction name="fnRedondear" returntype="numeric">
	<cfargument name="Numero" type="numeric">
	<cfreturn round(Numero*100)/100>
</cffunction>