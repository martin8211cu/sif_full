<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LOS PROCESOS DE TRANSFORMACIÓN. ------------->
<!---   Autor :  Maria de los Angeles Blanco López      30/06/2009                          --->

<cfsetting  requesttimeout="3600">
		
<!--- Encolamiento de Procesos de Compras --->
<cfquery datasource="sifinterfaces">
	update ESIFLD_Facturas_Compra
    	set Estatus = 99
    where Estatus = 1 
	and Clas_Compra in ('CCFC', 'CCNF')
    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))    
</cfquery>
<cfquery name="rsCompras" datasource="sifinterfaces">
	select count(1) as Registros from ESIFLD_Facturas_Compra 
	where Estatus = 99 
	and Clas_Compra in ('CCFC', 'CCNF')
    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
</cfquery>
<cfif rsCompras.Registros GT 0>	
	<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
	<cfinvoke component="PMI_Interfaz_Compra" method="Ejecuta"/> 
<cfelse>

	<!--- Encolamiento de Procesos de Gastos --->
    <cfquery datasource="sifinterfaces">
        update ESIFLD_Facturas_Compra
            set Estatus = 99
        where Estatus = 1 
        and Clas_Compra in ('GCFC', 'GCNF')
        and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))
    </cfquery>
    <cfquery name="rsGastos" datasource="sifinterfaces">
        select count (1) as Registros from ESIFLD_Facturas_Compra 
        where Estatus = 99
        and Clas_Compra in ('GCFC', 'GCNF')
        and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
    </cfquery>
    <cfif rsGastos.Registros GT 0>
        <!--- Ejecucion de Interfaz de Cuentas por Pagar (Gastos) --->
        <cfinvoke component="PMI_Interfaz_Gastos" method="Ejecuta"/> 
    <cfelse>

		<!--- Encolamiento de Procesos de Venta --->
        <cfquery datasource="sifinterfaces">
        	update ESIFLD_Facturas_Venta 
            	set Estatus = 99
	            where Estatus = 1 
     	        and	Clas_Venta in ('VCFC', 'VCNF')
                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100))    	
            </cfquery>
            <cfquery name="rsVentas" datasource="sifinterfaces">
                select count (1) as Registros from ESIFLD_Facturas_Venta 
                where Estatus = 99 
                and	Clas_Venta in ('VCFC', 'VCNF')
                and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
            </cfquery>
            <cfif rsVentas.Registros GT 0>
				<!--- Ejecucion de Interfaz de Cuentas por Cobrar (Ventas) --->
                <cfinvoke component="PMI_Interfaz_Ventas" method="Ejecuta"/> 
            <cfelse>
            	<!--- Encolamiento de Procesos de Otros Ingresos --->
                <cfquery datasource="sifinterfaces">
                    update ESIFLD_Facturas_Venta 
                        set Estatus = 99
                    where Estatus = 1 
                    and Clas_Venta in ('ICFC', 'ICNF')
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11, 94, 92, 99, 100))    	
                </cfquery>            
                <cfquery name="rsIngresos" datasource="sifinterfaces">
                    select count(1) as Registros from ESIFLD_Facturas_Venta 
                    where Estatus = 99
                    and Clas_Venta in ('ICFC', 'ICNF')
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
                </cfquery>
                <cfif rsIngresos.Registros GT 0>
                    <!--- Ejecucion de Interfaz de Cuentas por Cobrar (Otros Ingresos) --->
                    <cfinvoke component="PMI_Interfaz_OIngresos" method="Ejecuta"/> 
          		</cfif>
     	  </cfif>
    </cfif>
</cfif>

