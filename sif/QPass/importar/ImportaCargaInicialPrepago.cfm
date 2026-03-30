<!---
	Importador de Cargas iniciales para Quick Pass tipos Prepago
--->
<cfsetting requesttimeout="1800">
<cfflush interval="16">
<cfset session.Importador.SubTipo = "1">

<cf_dbtemp name="Errores" returnvariable="TableErr" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	 <cf_dbtempcol name="Valor"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cf_dbfunction name="OP_concat"	returnvariable="_cat">

<!--- Valida que la causa exista --->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'La causa por importar no existe en el sistema o no es tipo Recarga', a.QPCcodigo 
    from #table_name# a
    where ( select count(1)
            from QPCausa b
            where b.QPCcodigo = a.QPCcodigo
              and b.Ecodigo = #session.Ecodigo#
              and b.QPCtipo = 5 <!--- 5=Recarga --->
            ) = 0
    group by a.QPCcodigo
</cfquery>

<!--- Valida que el tag exista y que esté vendido y sea tipo prepago --->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'El tag no existe', a.QPTPAN
    from #table_name# a
    where ( select count(1)
            from QPassTag b
            where b.QPTPAN  = a.QPTPAN
               and b.Ecodigo = #session.Ecodigo#
            ) = 0
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'El tag existe pero no ha sido vendido', a.QPTPAN 
    from #table_name# a
    where (
          	select count(1)
            from QPassTag b
            where b.QPTPAN  = a.QPTPAN
               and b.Ecodigo = #session.Ecodigo#
          ) > 0
        and 
          ( select count(1)
            from QPassTag b
            	inner join QPventaTags c
                	on c.QPTidTag = b.QPTidTag
          	where b.QPTPAN  = a.QPTPAN
              and b.Ecodigo = #session.Ecodigo#
          ) = 0
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'El tag se vendió pero la venta no ha sido aceptada', a.QPTPAN 
    from #table_name# a
    where ( select count(1)
            from QPassTag b
            	inner join QPventaTags c
                	on c.QPTidTag = b.QPTidTag
          	where b.QPTPAN  = a.QPTPAN
              and b.Ecodigo = #session.Ecodigo#
              and c.QPvtaEstado = 0  <!--- 0 = En proceso, 1 = Aplicada, 2 = Anulada antes de Aplicar, 3 = Anulada despues de Aplicar --->
          ) > 0
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'El tag se vendió, la venta está aceptada pero es un postpago', a.QPTPAN 
    from #table_name# a
    where ( select count(1)
            from QPassTag b
            	inner join QPventaTags c
                	on c.QPTidTag = b.QPTidTag
                inner join QPcuentaSaldos d
                	on d.QPctaSaldosid = c.QPctaSaldosid
          	where b.QPTPAN  = a.QPTPAN
              and b.Ecodigo = #session.Ecodigo#
              and c.QPvtaEstado = 1  <!--- 0 = En proceso, 1 = Aplicada, 2 = Anulada antes de Aplicar, 3 = Anulada despues de Aplicar --->
              and d.QPctaSaldosTipo <> 2 <!--- 1=PostPago, 2=Prepago --->
          ) > 0
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
    select 'La venta de este tag fue anulada', a.QPTPAN 
    from #table_name# a
    where ( select count(1)
            from QPassTag b
            	inner join QPventaTags c
                	on c.QPTidTag = b.QPTidTag
          	where b.QPTPAN  = a.QPTPAN
	      and b.Ecodigo =1
              and c.QPvtaEstado > 1  --<!--- 0 = En proceso, 1 = Aplicada, 2 = Anulada antes de Aplicar, 3 = Anulada despues de Aplicar --->
	      and  
            (select count(1)
            from QPventaTags m
			inner join QPassTag bb
				on bb.QPTidTag = m.QPTidTag
            where bb.QPTPAN  = a.QPTPAN
            and m.QPvtaEstado = 1)  = 0 
          ) > 0
</cfquery>






<!--- Valida que la moneda exista --->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
	select 'La Moneda no existe en el sistema', a.Miso4217
    from #table_name# a
    where ( select count(1)
	        from Monedas b
            where b.Miso4217 = a.Miso4217
              and b.Ecodigo = #session.Ecodigo#
           ) = 0
</cfquery>

<cfquery name="Errores" datasource="#session.dsn#">
	select count(1) as cantidad 
	  from #TableErr#
</cfquery>

<cfif Errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.dsn#">
		select Error, Valor
		  from #TableErr#
	</cfquery>	
<cfelse>
	<cfset session.Importador.SubTipo = "2">
	<cfquery name="rsProcesar" datasource="#session.DSN#">
		select
        	QPCcodigo,
            rtrim(ltrim(QPTPAN)) as QPTPAN,
            QPMCFInclusion,
            Miso4217,
            QPMCMonto,
            QPMCMontoLoc,
            QPMCSaldoMonedaLocal,
            QPMCdescripcion
		from #table_name#
    </cfquery>
    <cftransaction> <!--- si por alguna razón falla el insert: que no importe nada --->

        <cfloop query="rsProcesar">
	    <cfset LvarQPTPAN = #rsProcesar.QPTPAN#>
            <!--- Obtiene el ID de la Venta con el # de Tag --->
            <cfquery name="rsIDVenta" datasource="#session.DSN#">
                select 
                    max(c.QPvtaTagid) as QPvtaTagid <!--- se pone max por si se da el caso de anulación y luego venta del mismo tag --->
                from QPassTag b  
                    inner join QPventaTags c
                        on c.QPTidTag = b.QPTidTag
                where b.QPTPAN  = '#LvarQPTPAN#'
                  and b.Ecodigo = #session.Ecodigo#
                  and c.QPvtaEstado = 1
            </cfquery>
            
            <cfset LvarQPvtaTagid = rsIDVenta.QPvtaTagid>
            
            <!--- Obtiene el id de la cuenta de saldos, id del cliente ligado a la venta --->
            <cfquery name="rsVenta" datasource="#session.DSN#">
                select 
                    c.QPctaSaldosid,
                    c.QPcteid,
                    c.QPTidTag
                from #table_name# a
                    inner join QPassTag b
                        on b.QPTPAN  = a.QPTPAN
                       and b.Ecodigo = #session.Ecodigo#
                    inner join QPventaTags c
                        on c.QPTidTag = b.QPTidTag
                where c.QPvtaTagid = #LvarQPvtaTagid#
            </cfquery>

            <cfset LvarQPctaSaldosid = rsVenta.QPctaSaldosid>
            <cfset LvarQPcteid = rsVenta.QPcteid>
            <cfset LvarQPTidTag = rsVenta.QPTidTag>
            
            <!--- Obtiene el id de la causa --->
            <cfquery name="rsCausa" datasource="#session.DSN#">
                select 
                    b.QPCid
                from #table_name# a
                    inner join QPCausa b
                        on b.QPCcodigo = a.QPCcodigo
                        and b.Ecodigo = #session.Ecodigo#
            </cfquery>
            <cfset LvarQPCid = rsCausa.QPCid>
            
            <!--- Obtiene el id de la moneda --->
            <cfquery name="rsMoneda" datasource="#session.DSN#">
                select 
                    b.Mcodigo
                from #table_name# a
                    inner join Monedas b
                        on b.Miso4217 = a.Miso4217
                       and b.Ecodigo = #session.Ecodigo#
            </cfquery>
            <cfset LvarMcodigo = rsMoneda.Mcodigo>
            
            <!--- Inserta el movimiento de carga inicial en la tabla QPMovCuenta --->
            <cfquery datasource="#session.DSN#">
                insert into QPMovCuenta
                    (
                     QPCid, 
                     QPctaSaldosid, 
                     QPcteid, 
                     QPTidTag, 
                     QPTPAN, 
                     QPMCFInclusion, 
                     Mcodigo, 
                     QPMCMonto, 
                     QPMCMontoLoc, 
                     QPMCSaldoMonedaLocal, 
                     QPMCdescripcion,
                     BMFecha
                    )
                values 
                    (
                     #LvarQPCid#, 
                     #LvarQPctaSaldosid#, 
                     #LvarQPcteid#, 
                     #LvarQPTidTag#, 
                     '#rsProcesar.QPTPAN#', 
                     '#rsProcesar.QPMCFInclusion#', 
                     #LvarMcodigo#, 
                     #rsProcesar.QPMCMonto#, 
                     #rsProcesar.QPMCMontoLoc#, 
                     #rsProcesar.QPMCSaldoMonedaLocal#, 
                     '#rsProcesar.QPMCdescripcion#',
                     #now()#
                    )
            </cfquery>
        </cfloop> 
        <cftransaction action="commit"/>
	</cftransaction>
</cfif>