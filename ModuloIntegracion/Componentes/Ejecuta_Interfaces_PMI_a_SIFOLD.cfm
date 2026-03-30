<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LOS PROCESOS DE TRANSFORMACIÓN. ------------->
<!---   Autor :  Maria de los Angeles Blanco López      29/12/2009                          --->

<cfsetting  requesttimeout="3600">
		
<!--- Encolamiento de Procesos de Compras 
<cfquery datasource="sifinterfaces">
	update ESIFLD_Facturas_Compra
    	set Estatus = 99
    where Estatus = 1 
	and Clas_Compra in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))    
</cfquery>
<cfquery name="rsCompras" datasource="sifinterfaces">
	select count(1) as Registros from ESIFLD_Facturas_Compra 
	where Estatus = 99 
	and Clas_Compra in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
</cfquery>
<cfif rsCompras.Registros GT 0>	
	<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
	<cfinvoke component="PMI_Integracion_Compra" method="Ejecuta"/> 
<cfelse>

	<!--- Encolamiento de Procesos de Gastos --->
    <cfquery datasource="sifinterfaces">
        update ESIFLD_Facturas_Compra
            set Estatus = 99
        where Estatus = 1 
        and Clas_Compra in ('GAFC', 'GANF')
        and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))
    </cfquery>
    <cfquery name="rsGastos" datasource="sifinterfaces">
        select count (1) as Registros from ESIFLD_Facturas_Compra 
        where Estatus = 99
        and Clas_Compra in ('GAFC', 'GANF')
        and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
    </cfquery>
    <cfif rsGastos.Registros GT 0>
        <!--- Ejecucion de Interfaz de Cuentas por Pagar (Gastos) --->
        <cfinvoke component="PMI_Integracion_Gastos" method="Ejecuta"/> 
    <cfelse>

		<!--- Encolamiento de Procesos de Polizas Contables --->
        <cfquery datasource="sifinterfaces">
            update ESIFLD_Facturas_Compra
                set Estatus = 100
            where Estatus = 4
            and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))
        </cfquery> 
        <cfquery name="rsPolizas" datasource="sifinterfaces">
            select count (1) as Registros from  ESIFLD_Facturas_Compra 
            where Estatus = 100
            and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11)) 
        </cfquery>
        <cfif rsPolizas.Registros GT 0>
            <!--- Ejecucion de Interfaz de Polizas Contables (Contabilidad) --->
            <cfinvoke component="PMI_Polizas_Contables" method="Ejecuta"/>
        <cfelse>

			<!--- Encolamiento de Procesos de Venta --->
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Venta 
                    set Estatus = 99
                where Estatus = 1 
                and	Clas_Venta in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100))    	
            </cfquery>
            <cfquery name="rsVentas" datasource="sifinterfaces">
                select count (1) as Registros from ESIFLD_Facturas_Venta 
                where Estatus = 99 
                and	Clas_Venta in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
            </cfquery>
            <cfif rsVentas.Registros GT 0>
				<!--- Ejecucion de Interfaz de Cuentas por Cobrar (Ventas) --->
                <cfinvoke component="PMI_Integracion_Ventas" method="Ejecuta"/> 
            <cfelse>
            

				<!--- Encolamiento de Procesos de Otros Ingresos --->
                <cfquery datasource="sifinterfaces">
                    update ESIFLD_Facturas_Venta 
                        set Estatus = 99
                    where Estatus = 1 
                    and Clas_Venta in ('OICO', 'OISO')
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100))    	
                </cfquery>            
                <cfquery name="rsIngresos" datasource="sifinterfaces">
                    select count(1) as Registros from ESIFLD_Facturas_Venta 
                    where Estatus = 99
                    and Clas_Venta in ('OICO', 'OISO')
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
                </cfquery>
                <cfif rsIngresos.Registros GT 0>
                    <!--- Ejecucion de Interfaz de Cuentas por Cobrar (Otros Ingresos) --->
                    <cfinvoke component="PMI_Integracion_Ingresos" method="Ejecuta"/> 
                <cfelse>

					<!--- Encolamiento de Procesos de Inventarios --->
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Movimientos_Inventario 
                            set Estatus = 99
                        where Estatus = 1 
                        and Tipo_Movimiento in ('EP', 'SF', 'SV', 'TO', 'TR', 'IC', 'CM', 'AL')
                        and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11, 94, 92, 99, 100))
                    </cfquery>
                    <cfquery name="rsInventarios" datasource="sifinterfaces">
                        select count (1) as Registros from ESIFLD_Movimientos_Inventario 
                        where Estatus = 99 
                        and Tipo_Movimiento in ('EP', 'SF', 'SV', 'TO', 'TR', 'IC', 'CM', 'AL')
                        and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11))
                    </cfquery>
                    <cfif rsInventarios.Registros GT 0>
                        <!--- Ejecucion de Interfaz de Movimientos de Inventario (Contabilidad) --->
                        <cfinvoke component="PMI_Inventarios" method="Ejecuta"/>
                    <cfelse>

						<!--- Encolamiento de Procesos de CV --->
                        <cfquery datasource="sifinterfaces">
                            update SIFLD_Costo_Venta 
                                set Estatus = 99
                            where Estatus = 1 
                            and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11, 94, 92, 99, 100))
                        </cfquery>
                        <cfquery name="rsCostoVenta" datasource="sifinterfaces">
                            select count (1) as Registros from SIFLD_Costo_Venta 
                            where Estatus = 99 
                            and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11))
                        </cfquery>
                        <cfif rsCostoVenta.Registros GT 0>
                            <!--- Ejecucion de Interfaz de Costo de Ventas (Contabilidad) --->
                            <cfinvoke component="PMI_Costo_Venta" method="Ejecuta"/>
                        <cfelse>

							<!--- Encolamiento de Procesos de Futuros --->
                            <cfquery datasource="sifinterfaces">
                                update ESIFLD_Facturas_Compra 
                                    set Estatus = 99
                                where Estatus = 1 
                                and Tipo_Documento = 'FU'  and Clas_Compra in ('AB','CE')
                                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100)) 
                            </cfquery>
                            <cfquery datasource="sifinterfaces">
                                update ESIFLD_Facturas_Venta 
                                    set Estatus = 99
                                where Estatus = 1 
                                and Tipo_Documento = 'FU'  and Clas_Venta in ('AB','CE')
                                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100)) 
                            </cfquery>
                            <cfquery name="rsFuturosC" datasource="sifinterfaces">
                                select count (1) as Registros from ESIFLD_Facturas_Compra 
                                where Estatus = 99
                                and Tipo_Documento = 'FU'  and Clas_Compra in ('AB','CE')
                                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11)) 
                            </cfquery>
                            <cfquery name="rsFuturosV" datasource="sifinterfaces">
                                select count (1) as Registros from ESIFLD_Facturas_Venta 
                                where Estatus = 99 
                                and Tipo_Documento = 'FU'  and Clas_Venta in ('AB','CE')
                                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11)) 
                            </cfquery>
                            <cfif rsFuturosC.Registros GT 0 OR rsFuturosV.Registros GT 0>
                                <!--- Ejecucion de Interfaz de Futuros --->
                                <cfinvoke component="PMI_Futuros" method="Ejecuta"/>
                            <cfelse>						

                                <cfquery datasource="sifinterfaces">
                                    update ESIFLD_Facturas_Compra 
                                        set Estatus = 99
                                    where Estatus = 1 
                                        and Clas_Compra in ('CE','AB','AC') and Tipo_Documento <> 'FU'
                                        and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))
                                </cfquery>
                                <cfquery datasource="sifinterfaces">
                                    update ESIFLD_Facturas_Venta
                                        set Estatus = 99
                                    where Estatus = 1 
                                        and Clas_Venta in ('CE','AB','AC') and Tipo_Documento <> 'FU'
                                        and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100))
                                </cfquery>
                                <cfquery name="rsSWAPSC" datasource="sifinterfaces">
                                    select count (1) as Registros from ESIFLD_Facturas_Compra 
                                    where Estatus = 99 
                                    and Clas_Compra in ('CE','AB','AC') and Tipo_Documento <> 'FU'
                                    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
                                </cfquery>
                                    <cfquery name="rsSWAPSV" datasource="sifinterfaces">
                                    select count (1) as Registros from ESIFLD_Facturas_Venta 
                                    where Estatus = 99 
                                    and Clas_Venta in ('CE','AB','AC') and Tipo_Documento <> 'FU'
                                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
                                </cfquery>
                                <cfif rsSWAPSC.Registros GT 0 OR rsSWAPSV.Registros GT 0>
                                    <!--- Ejecucion de Interfaz de SWAPS --->
                                    <cfinvoke component="PMI_SWAPS" method="Ejecuta"/>
                                </cfif>
							</cfif>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
     	</cfif>
    </cfif>
</cfif>--->