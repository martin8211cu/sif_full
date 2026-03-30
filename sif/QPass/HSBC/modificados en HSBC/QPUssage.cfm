<!---
	Importador de USO de TAGS para QPass
	
	Campos del Archivo:

	Tipo de Registro		2 caracteres
		00:					Encabezado
		10:					Detalle ( Cargo )
		11:					Detalle ( Abono )
		90:					Total
	
	Encabezado - Registro 00
		Tipo Registro		2
		Relleno				7
		Fecha				6 (ddmmyy)
		Origen				8 - no se usa -
		Numero Sesion		7 - no se usa -
		Comercio			9 - no se usa -
		Tipo Moneda			2 - se asume la moneda local -
		Relleno				79
		
	Detalle - Registro 10 y 11
		Tipo Registro		2
		PAN					16
		Relleno				6  - no se usa
		Fecha Caducidad		4  - no se usa
		Importe				9 - Siete enteros + 2 decimales sin coma decimal
		Dia					2
		Mes					2
		Año					2
		Hora				2
		Minuto				2
		Relleno1			6
		Relleno2			10
		Identificacion		9
		Localizador			9
		Recorrido			25
		% IVA				3  - 2 enteros + 1 decimal
		Relleno				11
	
	Total
		Tipo Registro		2
		Relleno1			4
		Relleno2			3
		Fecha				6 - DDMMAA
		Origen				8
		Numero Operaciones	7 - Contador de numero de registros de detalle
		Importe Total		13 - 11 Enteros + 2 decimales
		Relleno				77

--->
<cfsetting requesttimeout="3600">
<cfflush interval="16">
<cfset session.Importador.SubTipo = "1">

<cfquery name="rsVerifica1" datasource="#session.dsn#">
	select count(1) as Cantidad
	from #table_name#
	where Registro like '1%'
</cfquery>

<cfquery name="rsVerifica2" datasource="#session.dsn#">
	select Registro
	from #table_name#
	where Registro like '90%'
</cfquery>

<cfset LvarCantidadTeorica = mid(rsVerifica2.Registro, 24, 7)>
<cfset LvarCantidadRecibida = rsVerifica1.Cantidad>

<cfif LvarCantidadTeorica NEQ lvarCantidadRecibida>
	<cfquery name="Err" datasource="#session.dsn#">
		select #LvarCantidadTeorica# as Teoricos, #LvarCantidadRecibida# as Recibidos, 'Se esperan #numberformat(LvarCantidadTeorica,"9")# registros seg&uacute;n el registro de totales, pero los Registros de Detalle son #LvarCantidadRecibida#' as Error
		from dual
	</cfquery>
<cfelse>

	<cfset session.Importador.SubTipo = "2">
    
    <cfquery name="rsImportador" datasource="#session.dsn#">
        select Registro
        from #table_name#
        order by Registro
    </cfquery>

    <!--- Obtiene la categoría marcada para la importación de movimientos de Autopostas del Sol (ADS) --->
    <cfquery name="rsCausaparaImportacion" datasource="#session.DSN#">
        select min(QPCid) as QPCid
        from QPCausa
        where Ecodigo = #session.Ecodigo#
        and QPCtipo = 2 <!--- indica si la causa es la que se usa en la importación de movimientos de Autopostas del Sol (ADS) --->
    </cfquery>
    <cfif rsCausaparaImportacion.recordcount eq 0 or len(trim(rsCausaparaImportacion.QPCid)) eq 0>
        <cfthrow message="No se ha marcado una causa de Movimiento de Uso. " detail="Esto se define en el cat&aacute;logo de causas en el check Movimiento por Uso (ADS)">
        <cfabort>
    </cfif>
    <cfset LvarQPCid = rsCausaparaImportacion.QPCid>
    
    <!--- Obtiene el movimiento que contiene la categoría marcada para la importación de movimientos de Autopostas del Sol (ADS) --->
    <cfquery name="rsMovimientoImportacion" datasource="#session.DSN#">
        select min(QPMovid) as QPMovid
        from QPCausaxMovimiento
        where Ecodigo = #session.Ecodigo#
        and QPCid = #LvarQPCid# <!--- indica si la causa es la que se usa en la importación de movimientos de Autopostas del Sol (ADS) --->
    </cfquery>
    <cfif rsMovimientoImportacion.recordcount eq 0 or len(trim(rsMovimientoImportacion.QPMovid)) eq 0>
        <cfthrow message="No existe un movimiento que contenga la causa marcada para Movimiento por Uso (ADS). " detail="Esto se define en el cat&aacute;logo de Movimientos.">
        <cfabort>
    </cfif>
    <cfset LvarQPMovid = rsMovimientoImportacion.QPMovid>
    
    <!--- Obtiene la moneda --->
    <cfquery name="rsMoneda" datasource="#session.DSN#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    <cfset LvarMcodigo = rsMoneda.Mcodigo>
    
    <cfset LvarCantidadDetalles = 0>
    <cfset LvarRegistrosCorrectos = 0>
    <cfset LvarRegistrosError = 0>

    <cftransaction>
        <cfloop query="rsImportador">
            <cfset LvarQPTidTag = 0>
            <cfset LvarQPctaSaldosid = 0>
            <cfset LvarQPcteid = 0>
            <cfif left(Registro, 2) EQ "00">
                <!--- Obtiene la Fecha del Encabezado --->
                <cfset LvarYear = "20" & mid(rsImportador.Registro, 14,2)>
                <cfset LvarFechaEncabezado = createdate(LvarYear,mid(rsImportador.Registro, 12,2), mid(rsImportador.Registro, 10,2))>
            <cfelseif left(Registro, 2) NEQ "90">
                <!--- Procesa los registros del detalle --->
                <cfset LvarCantidadDetalles = LvarCantidadDetalles + 1>
                <cfset LvarImporte = mid(rsImportador.Registro, 29,9) / 100>
                <cfif left(Registro, 2) EQ '10'>
                    <cfset LvarImporte = LvarImporte * -1.00>
                </cfif>
                <cfset LvarFecha = createdatetime("20" & mid(rsImportador.Registro, 42,2), mid(rsImportador.Registro, 40,2), mid(rsImportador.Registro, 38,2), mid(rsImportador.Registro, 44,2), mid(rsImportador.Registro, 46,2), 0)>
                
                <!--- Obtiene el id del TAG
					Documentacion de Campo:  Estado de Dispositivo ( QPTEstadoActivacion )
						1: En Banco / Almacen o Sucursal, 
						2:  Recuperado ( En poder del banco por recuperacion )
						3:  En proceso de Venta ( Asignado a Cliente pero no Activado )
						4. Vendido y Activo
						5: Vendido e Inactivo
						6:  Vendido y Retirado
						7: Robado o Extraviado
						8: En traslado sucurcal/PuntoVenta
						9: Asignado a Promotor
						90: Eliminado
				---->
    
                <cfquery  name="rsObtieneTag" datasource="#session.dsn#">
                    select min(QPTidTag) as QPTidTag
                    from QPassTag a
                    where a.Ecodigo = #Session.Ecodigo#
                      and a.QPTPAN   = '#mid(rsImportador.Registro, 3, 16)#'
                      and a.QPTEstadoActivacion in (4,5,6) 
                </cfquery>
                <cfif rsObtieneTag.recordcount GT 0 and len(trim(rsObtieneTag.QPTidTag)) GT 0 and isnumeric(rsObtieneTag.QPTidTag) and rsObtieneTag.QPTidTag GT 0>
    
                    <cfset LvarQPTidTag = rsObtieneTag.QPTidTag>
    
                    <!--- Obtener la cuenta de saldos del TAG de esta forma se puede saber los registros con error --->
                    <cfquery name = "rs" datasource="#session.dsn#">
                        select max(QPctaSaldosid) as QPctaSaldosid
                        from QPventaTags a
                        where a.QPTidTag   = #LvarQPTidTag#
                    </cfquery>
                    <cfif rs.RecordCount EQ 1>
                        <cfset LvarQPctaSaldosid = rs.QPctaSaldosid>
                    </cfif>
    
                    <!--- actualizar la cuenta de saldos de la tabla temporal - de esta forma se puede saber los registros con error --->
                    <cfquery name = "rs" datasource="#session.dsn#">
                        select max(QPcteid) as QPcteid
                        from QPventaTags a
                        where a.QPctaSaldosid   = #LvarQPctaSaldosid#
                    </cfquery>
                    <cfif rs.RecordCount EQ 1>
                        <cfset LvarQPcteid = rs.QPcteid>
                    </cfif>
                </cfif>
                
                <cfif LvarQPTidTag NEQ 0 and LvarQPctaSaldosid NEQ 0 and LvarQPcteid NEQ 0>
                    <cfquery datasource="#session.dsn#">
                        insert into QPMovCuenta ( 
                        		QPCid, QPctaSaldosid, QPcteid, QPMovid, 
                                QPTidTag, QPTPAN, QPMCFInclusion, Mcodigo, 
                                QPMCMonto, QPMCMontoLoc, QPMCdescripcion, BMFecha)
                        select 
                        		#LvarQPCid#, #LvarQPctaSaldosid#, #LvarQPcteid#, #LvarQPMovid#, 
                                #LvarQPTidTag#, '#mid(rsImportador.Registro, 3, 16)#', #LvarFecha#, #LvarMcodigo#, 
                                #NumberFormat(LvarImporte, "9.00")#, #NumberFormat(LvarImporte, "9.00")#, '#mid(rsImportador.Registro, 82,25)#', #Now()#
                        from dual
                    </cfquery>
                <cfelse>
                    <cfquery datasource="#session.dsn#">
                        insert into QPMovInconsistente (
                        		Ecodigo, QPTPAN, QPMCFInclusion, QPMCMonto, 
                                QPMCdescripcion, BMFecha,QPMestado,BMusucodigo,
                                QPMCFechaM)
                        select 
                        		#session.Ecodigo#, '#mid(rsImportador.Registro, 3, 16)#', #LvarFecha#, #NumberFormat(LvarImporte, "9.00")#, 
                                '#mid(rsImportador.Registro, 82,25)#', #Now()#, 0, #session.Usucodigo#, #Now()#
                        from dual
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
    </cftransaction>
</cfif>
