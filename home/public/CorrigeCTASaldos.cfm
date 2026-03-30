<!--- Buscar todos los tags con venta aceptada, donde la cuenta saldo de la venta no es igual a la ventasaldo del movimiento y que la cuausa no sea de venta --->
<cfquery name="rs" datasource="minisif">
    select 
        a.QPTPAN, 
        a.QPTidTag, 
        a.QPctaSaldosid as ctamala, 
        b.QPctaSaldosid as ctabuena,
        a.QPMCid as MovCuentaID,
        a.QPCid as CausaID,
        c.QPCdescripcion as Causa,
        a.QPMCMonto,
        a.QPMCMontoLoc --, a.*
    from QPMovCuenta a
        inner join QPventaTags b
          on b.QPTidTag = a.QPTidTag
         and b.QPcteid     = a.QPcteid
        inner join QPCausa c
          on c.QPCid = a.QPCid 
    where b.QPvtaEstado = 1 <!--- solo las ventas aceptadas en COBIS --->
    and b.QPctaSaldosid <> a.QPctaSaldosid
    and c.QPCtipo <> 4 <!--- filtra las ventas--->
    order by a.QPMCid, a.QPTidTag, b.QPctaSaldosid
</cfquery>

<cfif isdefined("url.ver")>
	<cfdump var="#rs#">
</cfif>

<cftransaction action="begin">
	<cfloop query="rs">
    	<!--- Actualiza la cuentaSaldo mala con la correcta de la venta --->
    	<cfquery datasource="minisif">
    		update QPMovCuenta
            	set QPctaSaldosid = #rs.ctabuena#
            where QPMCid =#rs.MovCuentaID#
	    </cfquery>
        
        <!--- Actualiza los saldos en 0 tanto de las cuentas buenas como de las malas--->
        <cfquery datasource="minisif">
    		update QPcuentaSaldos
            	set QPctaSaldosSaldo = 0
            where QPctaSaldosid =#rs.ctabuena#
	    </cfquery>
        
        <cfquery datasource="minisif">
    		update QPcuentaSaldos
            	set QPctaSaldosSaldo = 0
            where QPctaSaldosid =#rs.ctamala#
	    </cfquery>
        
        <!--- prepara los movimientos para que sean tomados en cuenta en la afectación de los saldos --->
        <cfquery datasource="minisif">
        	update QPMovCuenta
            set QPMCFProcesa = null,
                QPMCFAfectacion = null,
                QPMCMontoLoc = 0,
                QPMCSaldoMonedaLocal = 0
            where QPMCid = #rs.MovCuentaID#
        </cfquery>
    </cfloop>

    <!--- Actualiza el parámetro para que recalcule el saldo desde el primer registro solo los que tiene la fecha de procesamiento en nulo --->
    <cfquery datasource="minisif">
    	update QPParametros
        set Pvalor = '0'
        where Ecodigo = 0
          and Pcodigo = 9999
    </cfquery>

    <cfquery name="rs" datasource="minisif">
        select 
            a.QPTPAN, 
            a.QPTidTag, 
            a.QPctaSaldosid as ctamala, 
            b.QPctaSaldosid as ctabuena,
            a.QPMCid as MovCuentaID,
            a.QPCid as CausaID,
            c.QPCdescripcion as Causa,
            a.QPMCMonto,
            a.QPMCMontoLoc --, a.*
        from QPMovCuenta a
            inner join QPventaTags b
              on b.QPTidTag = a.QPTidTag
             and b.QPcteid     = a.QPcteid
            inner join QPCausa c
              on c.QPCid = a.QPCid 
        where b.QPvtaEstado = 1 <!--- solo las ventas aceptadas en COBIS --->
        and b.QPctaSaldosid <> a.QPctaSaldosid
        and c.QPCtipo <> 4 <!--- filtra las ventas--->
        order by a.QPMCid, a.QPTidTag, b.QPctaSaldosid
    </cfquery>	

    <cfif isdefined("url.ver")>
	    <cfdump var="#rs#">
    <cfelse>
    	 <cfquery name="rs1" datasource="minisif">
            select 
               	a.QPTPAN, 
                a.QPTidTag, 
                a.QPctaSaldosid as ctamala, 
                b.QPctaSaldosid as ctabuena,
                a.QPMCid as MovCuentaID,
                a.QPCid as CausaID,
                c.QPCdescripcion as Causa,
                a.QPMCMonto,
                a.QPMCMontoLoc
            from QPMovCuenta a
                inner join QPventaTags b
                  on b.QPTidTag = a.QPTidTag
                 and b.QPcteid     = a.QPcteid
                inner join QPCausa c
                  on c.QPCid = a.QPCid 
            where b.QPvtaEstado = 1 <!--- solo las ventas aceptadas en COBIS --->
            and b.QPctaSaldosid <> a.QPctaSaldosid
            and c.QPCtipo <> 4 <!--- filtra las ventas--->
            order by a.QPMCid, a.QPTidTag, b.QPctaSaldosid
        </cfquery>
        <cfoutput>
			<cfdump var="#rs1#">
		</cfoutput>
    </cfif>
    
    <cfquery name="rs" datasource="minisif">
        select count(1) as cantidad from QPMovCuenta where QPMCFProcesa is null
    </cfquery>
    <cfoutput>
		#rs.cantidad# registros con QPMCFProcesa en null<br />
	</cfoutput>
    
    <cfquery name="rs" datasource="minisif">
        select * from QPMovCuenta where QPMCFProcesa is null
    </cfquery>
    <cfif isdefined("url.ver")>
	    <cfdump var="#rs#">
    </cfif>
    
    
	<cftransaction action="rollback"/>
    <cfoutput>Fin del proceso con rollback tran</cfoutput>
</cftransaction>
<!--- <cfoutput>Fin del proceso</cfoutput> --->