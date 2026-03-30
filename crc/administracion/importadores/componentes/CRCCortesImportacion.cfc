<cfcomponent output="false" displayname="CRCCortesImportacion"  >



	<cffunction name="init">
		<cfargument name="DSN" type="string">
		<cfargument name="Ecodigo" type="string">

			<cfset CRCCorteFactory = createObject( "component","crc.Componentes.cortes.CRCCorteFactory")> 

			<cfset This.CRCorteVales = CRCCorteFactory.obtenerCorte(TipoProducto='D',
															   conexion=#arguments.DSN#, 
															   Ecodigo=#arguments.ECodigo#)>
	 
			<cfset This.CRCorteTC = CRCCorteFactory.obtenerCorte(TipoProducto='TC',
															   conexion=#arguments.DSN#, 
															   Ecodigo=#arguments.ECodigo#)>

	        <cfset This.CRCorteTM = CRCCorteFactory.obtenerCorte(TipoProducto='TM',
															   conexion=#arguments.DSN#, 
															   Ecodigo=#arguments.ECodigo#)>		


	</cffunction>


	<cffunction name="process" hint="genera cortes dada la fecha y tipo de transaccion" returntype="string">
		<cfargument name="fecha" 		   type="string">
		<cfargument name="tipoTransaccion" type="string">
		<cfargument name="SNid" 		   type="numeric">
		<cfargument name="parcialidades"   type="numeric">
		<cfargument name="tipoProducto"    type="string">
 

		<cfif trim(arguments.tipoTransaccion) eq 'VC' or trim(arguments.tipoTransaccion) eq 'D'>
			<cfset oCorte = This.CRCorteVales>
		<cfelseif trim(arguments.tipoTransaccion) eq 'TC'>
			<cfset oCorte = This.CRCorteTC>
		<cfelseif trim(arguments.tipoTransaccion) eq 'PG'>
			<cfset oCorte = This.CRCorteTC>
		<cfelseif trim(arguments.tipoTransaccion) eq 'IN'>
			<cfset oCorte = This.CRCorteTC>
		<cfelseif trim(arguments.tipoTransaccion) eq 'GC'>
			<cfset oCorte = This.CRCorteTC>
		<cfelseif trim(arguments.tipoTransaccion) eq 'TM'>
			<cfset oCorte = This.CRCorteTM>
			<cfset oCorte.socioNegocioID = arguments.SNid>
		<cfelse>
			<cfthrow message="No se encontro un tipo de transaccion valido para procesar los cortes. valor recibido-->#arguments.tipoTransaccion#">
		</cfif>


		<cfset oCorte.vFechaActual = false>
		<cfset oCorte.desdeImportador = 1>

		<cfset oCorte.GetCorteCodigos(fecha='#arguments.fecha#',parcialidades=#arguments.parcialidades#, SNid=arguments.SNid)>

		<cfreturn oCorte.GetCorte(fecha=arguments.fecha, TipoCorte=arguments.tipoProducto, SNid=arguments.SNid)>


	</cffunction>

	<cffunction name="obtenerCorte" hint="devuelve un corte dado la fecha, tipo producto, se usa en calendario y resumen de pagos">
        <cfargument name="fecha" 		   type="string">
        <cfargument name="tipoProducto"    type="string">
        <cfargument name="SNid" 		   type="numeric">

        <cfif trim(arguments.tipoProducto) eq 'VC'>
        	<cfset arguments.tipoProducto = 'D'>
        </cfif>


		<cfif trim(arguments.tipoProducto) eq 'D'>
			<cfset oCorte = This.CRCorteVales>
		<cfelseif trim(arguments.tipoProducto) eq 'TC'>
			<cfset oCorte = This.CRCorteTC>
		<cfelseif trim(arguments.tipoProducto) eq 'TM'>
			<cfset oCorte = This.CRCorteTM>
			<cfset oCorte.socioNegocioID = arguments.SNid>
		<cfelse>
			<cfthrow message="No se encontro un tipo de transaccion valido para procesar los cortes. valor recibido-->#arguments.tipoTransaccion#">
		</cfif>        

		<cfreturn oCorte.GetCorte(fecha=arguments.fecha, TipoCorte=arguments.tipoProducto, SNid=arguments.SNid)>

	</cffunction>


	<cffunction name="updateCorteStatus">
		<cfargument name="corte" type="string" required="false" default="">

		<!--- actualizar status de los cortes--->
 		<cfset fechaACtual = CreateDate(DatePart('yyyy', now()), DatePart('m',now()),DatePart('d',now()))>
 		<cfquery  datasource="#session.dsn#">

			update corte 
			set corte.status = case when Tipo = 'TC' OR Tipo = 'D'
								then
								   case when <cfqueryparam value ="#fechaACtual#" cfsqltype="cf_sql_date"> >  FechaFinSV
								   then 3
								   else 
										case when <cfqueryparam value ="#fechaACtual#" cfsqltype="cf_sql_date"> between FechaInicioSV and FechaFinSV
										then 2
										else 
											case when <cfqueryparam value ="#fechaACtual#" cfsqltype="cf_sql_date"> > FechaFin
											then 1
											else 
												0
											end
										end
									end
								else
									case when Tipo = 'TM'
									then 
										case when <cfqueryparam value ="#fechaACtual#" cfsqltype="cf_sql_date"> between FechaInicio and FechaFin
										then 1
										else
											case when <cfqueryparam value ="#fechaACtual#" cfsqltype="cf_sql_date"> between FechaInicioSV and FechaFinSV
											then 2
											else 3
											end 
										end
									else
									0
									end  
								end
			from CRCCortes as  corte
			<cfif arguments.corte neq "">
			   where Codigo = '#arguments.corte#'
			</cfif>

 		</cfquery>
	</cffunction>


	<cffunction name="updateCorteCerrado">
		
		<cfquery datasource="#session.dsn#">

		update CRCCortes
		set Cerrado = 1
		where status <> '0'
		</cfquery>

	</cffunction>
</cfcomponent>