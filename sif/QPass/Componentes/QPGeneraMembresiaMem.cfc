<cfcomponent output="no">
	<!--- Proceso de generación de Montos por Membresía para modulo de Telepeaje --->
	
	<!---
		Documentación:
			El proceso ejecuta por un tiempo máximo de 30 minutos.
			Se dispara mediante una tarea programada automática que debe de ejecutarse fuera del horario de operación
			definido para la entidad bancaria o entidad administradora de los dispositivos.
			
			Si transcurridos 30 minutos el proceso no ha terminado, automáticamente se "sale" del proceso
			para permitir que otro proceso automático inicie su funcionamiento.
			

	--->
	
	<cffunction name="fnGeneraRegistrosMembresia" access="public" returntype="boolean" output="yes">
		<cfargument name="Conexion" type="string" required="yes">

        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

		<cfsetting requesttimeout="3600">

		<cfquery name="rsConvenio" datasource="#Arguments.Conexion#">
			select QPvtaConvid, Ecodigo, QPvtaConvFrecuencia
			from QPventaConvenio
		</cfquery>

		<cfloop query="rsConvenio">
			<cfset LvarQPvtaConvid 				= rsConvenio.QPvtaConvid>
			<cfset LvarEcodigo 					= rsConvenio.Ecodigo>
			<cfset LvarQPvtaConvFrecuencia		= rsConvenio.QPvtaConvFrecuencia>
			
			<cfset LvarR = fnGeneraRegistrosMembresiaPrivate(Conexion, LvarQPvtaConvid, LvarEcodigo, LvarQPvtaConvFrecuencia)>
		</cfloop>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="fnGeneraRegistrosMembresiaPrivate" access="public" output="yes" returntype="numeric">
		<cfargument name="Conexion" 			type="string" required="yes">
		<cfargument name="QPvtaConvid" 			type="numeric" required="yes">
		<cfargument name="Ecodigo" 				type="numeric" required="yes">
		<cfargument name="QPvtaConvFrecuencia" 	type="numeric" required="yes">
	
    		<!--- <cf_dump var="#Arguments.QPvtaConvFrecuencia#"><cfabort> --->
		<cfswitch expression="#Arguments.QPvtaConvFrecuencia#">
			<cfcase value="1">
				<!--- Mensual --->
				<cfset LvarFechaControl = dateadd("m", -1, createdate(year(now()), month(now()), day(now())))>
				<cfset LvarCantidadMeses = 1>
			</cfcase>
			<cfcase value="2">
				<!--- BiMensual --->
				<cfset LvarFechaControl = dateadd("m", -2, createdate(year(now()), month(now()), day(now())))>
				<cfset LvarCantidadMeses = 2>
			</cfcase>
			<cfcase value="3">
				<!--- Trimestral --->
				<cfset LvarFechaControl = dateadd("m", -3, createdate(year(now()), month(now()), day(now())))>
				<cfset LvarCantidadMeses = 3>
			</cfcase>
			<cfcase value="4">
				<!--- Semestral --->
				<cfset LvarFechaControl = dateadd("m", -6, createdate(year(now()), month(now()), day(now())))>
				<cfset LvarCantidadMeses = 6>
			</cfcase>
			<cfcase value="5">
				<!--- Anual --->
				<cfset LvarFechaControl = dateadd("m", -12, createdate(year(now()), month(now()), day(now())))>
				<cfset LvarCantidadMeses = 12>
			</cfcase>
			<cfdefaultcase>
				<cfset LvarFechaControl = createdate(year(now())+1, month(now()), day(now()))>
				<cfset LvarCantidadMeses = 0>
			</cfdefaultcase>
		</cfswitch>

		<!--- Sumar segundos para garantizar que la fecha incluye cualquier fecha hasta el final del dia seleccionado --->
		<cfset LvarFechaControlSegundos = dateadd("s", 86399, LvarFechaControl)>
		<!---<cfdump var="#LvarFechaControl#">
		<cfdump var="#LvarFechaControlSegundos#"><cfabort>--->

		<!--- Inicializar las fechas para los registros de venta que estén en nulo y que correspondan con ventas aprobadas--->
		<cfquery datasource="#Arguments.Conexion#">
			update QPventaTags
			set QPvtaFCobroUltMem = QPvtaTagFecha
			where QPvtaConvid = #Arguments.QPvtaConvid#
			  and QPvtaEstado = 1
			  and QPvtaFCobroUltMem is null
		</cfquery>

		<!--- Obtener la causa y el monto correspondiente a la membresia --->
		<cfquery name="rsRubroMembresia" datasource="#Arguments.Conexion#">
        	select min(a.QPCid) as QPCid
            from QPCausaxConvenio a
            	inner join QPCausa b
                on b.QPCid = a.QPCid
            where a.QPvtaConvid = #Arguments.QPvtaConvid#
              and b.QPCtipo = 3
        </cfquery>
		<cfif rsRubroMembresia.recordcount EQ 0 or len(trim(rsRubroMembresia.QPCid)) EQ 0>
        	<cfreturn -1>
        </cfif>
		<cfset LvarQPCidMembresia = rsRubroMembresia.QPCid>
        
        <cfquery name="rsMembresia" datasource="#Arguments.Conexion#">
        	select QPCmonto, Mcodigo
            from QPCausa
            where QPCid = #LvarQPCidMembresia#
        </cfquery>
        <cfset LvarMontoMembresia = rsMembresia.QPCmonto>
        <cfset LvarMcodigoMembresia = rsMembresia.Mcodigo>
		<cfset LvarMontoCargar = LvarMontoMembresia *  LvarCantidadMeses>

		<!--- Obtener los registros que deben de procesarse porque la fecha de ultima actualización de membresia es menor que la fecha maxima --->
		<cfquery name="membresias" datasource="#Arguments.Conexion#">
			select a.QPvtaTagid, a.QPTidTag, a.QPctaSaldosid, a.QPcteid, a.QPvtaFCobroUltMem
			from QPventaTags a
            	inner join QPassTag b
                    inner join QPassEstado c
                    on c.QPidEstado = b.QPidEstado
                on b.QPTidTag = a.QPTidTag
			where a.QPvtaConvid = #Arguments.QPvtaConvid#
			 and a.QPvtaEstado = 1
			 and a.QPvtaFCobroUltMem <= #LvarFechaControlSegundos#
             and c.QPEdisponibleVenta = 1 <!--- Solo cobra membresía a los tags marcados como "disponibles para la venta (QPEdisponibleVenta = 1)" solicitado por Kenneth Lopez el 21/01/2010 --->
		</cfquery><!---<cf_dump var="#membresias#"><cfabort>--->

		<cfloop query="membresias">
			<cfset LvarQPvtaTagid = membresias.QPvtaTagid>

			<cftransaction>
				<!--- 1. Bloquear el registro de la venta para evitar que se procese dos veces --->
				<cfquery datasource="#Arguments.Conexion#">
					update QPventaTags
					set QPvtaFCobroUltMem = QPvtaFCobroUltMem
					where QPvtaTagid = #LvarQPvtaTagid#
				</cfquery>
				
				<!--- 2. Lectura de los datos para asegurar que no se está duplicando --->
				<cfquery name="Infomembresia" datasource="#Arguments.Conexion#">
					select a.QPvtaTagid, a.QPTidTag, a.QPctaSaldosid, a.QPcteid, a.QPvtaFCobroUltMem, t.QPTPAN
					from QPventaTags a
                    	inner join QPassTag t
                        on t.QPTidTag = a.QPTidTag
					where QPvtaTagid = #LvarQPvtaTagid#
					  and QPvtaConvid = #Arguments.QPvtaConvid#
					  and QPvtaEstado = 1
					  and QPvtaFCobroUltMem <= #LvarFechaControlSegundos#
				</cfquery>
				<cfif InfoMembresia.recordcount GT 0>

					<!--- 3. Calcular la fecha en que se debió de cobrar la membresia --->

					<cfset LvarFechaUltimaMembresia = InfoMembresia.QPvtaFCobroUltMem>
					<cfset LvarNuevaFechaMembresia = dateadd("m", LvarCantidadMeses, createdate(year(LvarFechaUltimaMembresia), month(LvarFechaUltimaMembresia), day(LvarFechaUltimaMembresia)))>

					<!--- 4. Generar el registro en la tabla de movimientos --->
                    <cf_dbfunction name="op_concat" datasource="asp" returnvariable="_Cat">
					<cfquery datasource="#Arguments.Conexion#">
                        insert into QPMovCuenta ( 
                        		QPCid, QPctaSaldosid, QPcteid, QPMovid, 
                                QPTidTag, QPTPAN, QPMCFInclusion, Mcodigo, 
                                QPMCMonto, QPMCMontoLoc, QPMCdescripcion, BMFecha)
                        values ( 
                        		#LvarQPCidMembresia#, #Infomembresia.QPctaSaldosid#, #Infomembresia.QPcteid#, null, 
                                #Infomembresia.QPTidTag#, '#Infomembresia.QPTPAN#', #LvarNuevaFechaMembresia#, #LvarMcodigoMembresia#, 
                                #NumberFormat(LvarMontoCargar * -1, "9.00")#, 
                                0, 
                                'Membresia: ' #_Cat# '#Dateformat(LvarNuevaFechaMembresia, "DD/MM/YYYY")#' #_Cat# ' #Infomembresia.QPTPAN#'
                                , #Now()#
                        )
                    </cfquery>

					<!--- 5. Grabar la fecha de la membresia en la tabla de ventas --->
					<cfquery datasource="#Arguments.Conexion#">
						update QPventaTags
						set QPvtaFCobroUltMem = #LvarNuevaFechaMembresia#
						where QPvtaTagid = #LvarQPvtaTagid#
					</cfquery>
				</cfif>
			</cftransaction>
		</cfloop>
        <cfreturn 1>
	</cffunction>
	
</cfcomponent>

