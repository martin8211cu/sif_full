<cfquery datasource="sifinterfaces">
	select * 
    into BASE2
    from ESIFLD_Facturas_Compra
    where Estatus = 1 
	and Clas_Compra in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11, 94, 92, 99, 100))    
</cfquery>
