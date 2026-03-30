<cfscript>
	bcheck0 = false; // Chequeo de Existencia de Movimiento
	bcheck1 = false; // Chequeo de la existencia la Moneda
	bcheck2 = false; // Chequeo del Periodo
	bcheck3 = false; // Chequeo del Mes
	bcheck4 = false; // Chequeo de la Naturaleza
	bcheck5 = false; // Chequeo del Tipo de Documento
	bcheck6 = false; // Chequeo del Tipo de Operación
</cfscript>

<!---Importador de Movimientos adicionales de Utilidad Bruta Realizado por Rosalba Vargas Díaz APH 18/Abr/2013 --->


<!---Se revisa que no exista algun movimiento igual --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0
	from #table_name# a
	where exists (select 1 
			       	from ImportVtasCost b
			        where a.fltPeriodo = b.fltPeriodo
			        and a.fltMes = b.fltMes
                    and a.fltOperacion = b.fltOperacion
                    and a.fltNaturaleza = a.fltNaturaleza
                    and a.Contrato = b.Contrato
                    and a.fltTipoDoc = b.fltTipoDoc) 
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>

<!---Verifica que exista la Moneda del Movimiento--->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists
	    (
			select 1 
        	from Monedas b
	        where b.Miso4217 = a.fltMoneda 
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	    ) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>

<!--- Verifica el Periodo--->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2 
            from #table_name# a
            where not exists
            (
            select 1 from sif_interfaces..ESIFLD_HFacturas_Venta E
            inner join sif_interfaces..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
			where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and a.fltPeriodo = E.Periodo
            )
   </cfquery>
    <cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>


<!--- Verifica el Mes --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select <cf_dbfunction args="c.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, c.VSdesc
			from Idiomas b, VSidioma c	
			where b.Icodigo = '#Session.Idioma#'
			and b.Iid = b.Iid
			and c.VSgrupo = 1
            and a.fltMes = c.VSvalor
		)
   </cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>





<!--- Verifica la naturaleza --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists
        (
			select  a.fltNaturaleza
            from #table_name# a
            where a.fltNaturaleza in ('P','N')
		)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<!---Verifica Tipo de Documento--->
<cfif bcheck4>
	<cfquery name="rsCheck5" datasource="#Session.DSN#">
		select count(1) as check5
		from #table_name# a
		where not exists
        (
			select a.fltTipoDoc
            from #table_name# a
            where a.fltTipoDoc in ('PRFC','PRNF')
		)
	</cfquery>
	<cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<!---Verifica Tipo de Documento--->
<cfif bcheck5>
    <cfquery name="rsCheck6" datasource="#Session.DSN#">
		select count(1) as check6
		from #table_name# a
		where not exists
        (
        	select a.fltOperacion
        	from #table_name# a
        	where a.fltOperacion in ('I','C')
        )
	</cfquery>
	<cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>


<!---Inserta Movimientos--->
<cfif bcheck6>
	<cfquery  datasource="#Session.DSN#">
    	insert ImportVtasCost(fltPeriodo,fltMes,fltOperacion,fltNaturaleza,Importe,Contrato,Poliza,fltMoneda,fltTipoDoc,Observaciones)
        select t.fltPeriodo,t.fltMes,t.fltOperacion,t.fltNaturaleza,t.Importe,t.Contrato,t.Poliza,t.fltMoneda,t.fltTipoDoc,t.Observaciones
        from #table_name# t
	</cfquery>
</cfif>


<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
		select distinct 'Ya existe este Movimiento' as MSG, a.Contrato, a.fltOperacion,a.fltNaturaleza
		from #table_name# a
		where exists (
        			select 1 
			       	from ImportVtasCost b
			        where a.fltPeriodo = b.fltPeriodo
			        and a.fltMes = b.fltMes
                    and a.fltOperacion = b.fltOperacion
                    and a.fltNaturaleza = b.fltNaturaleza
                    and a.Contrato = b.Contrato
                    and a.fltTipoDoc = b.fltTipoDoc
                    )                     
        </cfquery>
        
 <!--- Fallo Check1 ---> 
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Moneda No Valida' as MSG, a.fltMoneda as CODIGO_MONEDA
			from #table_name# a
			where not exists(
				select 1
				from Monedas b
				where b.Miso4217 = a.fltMoneda
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			)
	</cfquery>


<!--- Fallo Check2 --->      
	 <cfelseif not bcheck2>        
       	<cfquery name="ERR" datasource="#session.DSN#">
        	select distinct 'Periodo Invalido' as MSG, a.fltPeriodo as Periodo
            from #table_name# a
            where not exists(
            select 1 from sif_interfaces..ESIFLD_HFacturas_Venta E
            inner join sif_interfaces..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
			where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and a.fltPeriodo = E.Periodo
            )
	</cfquery>
    
<!--- Fallo Check3 --->
 		
		<cfelseif not bcheck3>  
        <cfquery name="ERR" datasource="#session.DSN#">
       		select distinct 'Mes Invalido' as MSG, a.fltMes as Mes
            from #table_name# a
            where not exists 
            (
            select <cf_dbfunction args="c.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, c.VSdesc
			from Idiomas b, VSidioma c	
			where b.Icodigo = '#Session.Idioma#'
			and b.Iid = b.Iid
			and c.VSgrupo = 1
            and a.fltMes = c.VSvalor
            )
            
		</cfquery>
    
<!--- Fallo Check4 --->    
	   <cfelseif not bcheck4>  
        
       <cfquery name="ERR" datasource="#session.DSN#">
		select distinct 'Naturaleza Invalida' as MSG, a.fltNaturaleza
		from #table_name# a
		where not exists
        (
			select  a.fltNaturaleza
            from #table_name# a
            where a.fltNaturaleza in ('P','N')
		)
		</cfquery>

<!--- Fallo Check5 --->
		<cfelseif not bcheck5>          
       <cfquery name="ERR" datasource="#session.DSN#">
       	select distinct 'Tipo de Documento Invalido' as MSG, a.fltTipoDoc
		from #table_name# a
		where not exists
        (
			select a.fltTipoDoc
            from #table_name# a
            where a.fltTipoDoc in ('PRFC','PRNF')
		)
    	</cfquery>

<!--- Fallo Check6 --->
	  <cfelseif not bcheck6>          
       <cfquery name="ERR" datasource="#session.DSN#">
        select distinct 'Tipo de Operación Invalida' as MSG, a.fltOperacion
		from #table_name# a
		where not exists
        (	
       		select a.fltOperacion
            from #table_name# a
            where a.fltOperacion  in ('I','C')
         )
		</cfquery>
        
</cfif>








