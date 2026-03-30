<cfcomponent>
	
	<!--- Método que obtiene el factor de conversion de una moneda a otra --->
	<cffunction name="obtenerFactorConversionMoneda" access="public" returntype="numeric" output="false">
		<cfargument name="Mcodigo" 			type="numeric" 	required="yes">
		<cfargument name="Mcodigoref" 		type="numeric" 	required="yes">
		<cfargument name="TipoCambio" 		type="numeric" 	required="yes">
		<cfargument name="TipoCambioRef" 	type="numeric" 	required="yes">
		<cfargument name="Fecha" 			type="date" 	required="yes">
		<cfargument name="UsarTCDoc" 		type="boolean" 	required="yes">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        
        <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		
		<cfif arguments.Mcodigo eq arguments.Mcodigoref>
			<cfset factorConversionMonedaFO = 1>
		<cfelse>
			<cfquery name="rsTipoCambio" datasource="#session.dsn#">
				select tc.TCventa
				from Htipocambio tc
				where tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
					and tc.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.Fecha#">
					and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.Fecha#">
			</cfquery>

			<cfif rsTipoCambio.RecordCount eq 0 or len(trim(rsTipoCambio.TCventa)) eq 0>
				<cfset TipoCambioOrigen = arguments.TipoCambio>
			<cfelseif not UsarTCDoc>
				<cfset TipoCambioOrigen = rsTipoCambio.TCventa>
			<cfelse>
				<cfset TipoCambioOrigen = arguments.TipoCambio>
			</cfif>
			
			<cfquery name="rsTipoCambioRef" datasource="#session.dsn#">
				select tc.TCventa
				from Htipocambio tc
				where tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigoref#">
					and tc.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.Fecha#">
					and tc.Hfecha  >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.Fecha#">
			</cfquery>
			
			<cfif rsTipoCambioRef.RecordCount eq 0 or len(trim(rsTipoCambioRef.TCventa)) eq 0>
				<cfset TipoCambioDestino = arguments.TipoCambioRef>
			<cfelse>
				<cfset TipoCambioDestino = rsTipoCambioRef.TCventa>
			</cfif>
			
			<cfset factorConversionMonedaFO = TipoCambioOrigen / TipoCambioDestino>

		</cfif>	
		
		<cfreturn factorConversionMonedaFO>
	</cffunction>

	<cffunction name="__randomString" access="public" returntype="string" output="false">
		<cfargument name="size" type="numeric" required="yes">
		<cfargument name="validChars" type="string" required="no" default="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789">

		<cfset var SALT_DIGITS = validChars.toCharArray()>
		<cfset ch = "">
		<cfloop from="1" to="#Arguments.size#" index="n">
			<cfset ch = ch & SALT_DIGITS[Rand() * ArrayLen(SALT_DIGITS) + 1] >
		</cfloop>
	  	<cfreturn ch>
	</cffunction>

	<!--- Función que actualiza los costos de un ítem por la aplicación de una nota de débito o crédito --->
	<cffunction name="actualizarCostoTrackingItem" access="public" output="false" returntype="boolean">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no">
		<cfargument name="Usucodigo" 			type="numeric" 	default="#session.Usucodigo#">
		<cfargument name="ETIiditem" 			type="numeric" 	required="yes">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Ucodigo" 				type="string" 	required="yes">
		<cfargument name="Ucodigoref" 			type="string" 	required="yes">
		<cfargument name="Mcodigo" 				type="numeric" 	required="yes">
		<cfargument name="Mcodigoref" 			type="numeric" 	required="no">
		<cfargument name="ETtipocambiofac" 		type="numeric" 	required="yes">
		<cfargument name="ETtipocambiofacref" 	type="numeric" 	required="no">
		<cfargument name="TipoDocumento" 		type="string" 	default="N">
		<cfargument name="DOlinea" 				type="numeric" 	required="yes">
		<cfargument name="ETIcantidad" 			type="numeric" 	required="yes">
		<cfargument name="ETcantfactura" 		type="numeric" 	required="yes">
		<cfargument name="FechaDocumento" 		type="date" 	required="yes">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
		<!--- 1. Verifica que en el tracking destino, el ítem tenga una unidad de medida asociada --->
		<cfif len(trim(Ucodigoref)) eq 0>
			<cfif TipoDocumento eq 'N'>
				<cf_errorCode	code = "51102" msg = "La nota de crédito no se puede aplicar porque un ítem en un tracking existente no tiene unidad de medida">
			<cfelse>
				<cf_errorCode	code = "51103" msg = "La nota de débito no se puede aplicar porque un ítem en un tracking existente no tiene unidad de medida">
			</cfif>
		<cfelse>
			<!--- 2. Obtiene el factor de conversión de las unidades del documento a las del tracking - ítem.
					 Notifica el error si no lo encuentra --->
			<cfquery name="conversionUnidades" datasource="#session.dsn#">
				select 	case when 	'#arguments.Ucodigo#' = 
									'#arguments.Ucodigoref#' then 1
							else 	coalesce(cu.CUfactor, cua.CUAfactor)
					   end as CUfactor
				from DOrdenCM do
					left outer join Articulos art
						on art.Aid = do.Aid
						
					left outer join ConversionUnidades cu
						 on cu.Ecodigo 		= art.Ecodigo  <!---Se usa el Ecodigo del Articulo, no el de la OC--->
						and cu.Ucodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">
						and cu.Ucodigoref 	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigoref#">
                        
					left outer join ConversionUnidadesArt cua
						  on cua.Aid      = do.Aid
                         and cua.Ecodigo  = art.Ecodigo
						 and art.Ucodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">
						 and cua.Ucodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigoref#">
						
				where do.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
			</cfquery>
			<cfif len(trim(conversionUnidades.CUfactor)) eq 0>
				<cf_errorCode	code = "51104"
								msg  = "No se encontró el factor de conversión de la unidad @errorDat_1@ a la unidad @errorDat_2@"
								errorDat_1="#arguments.Ucodigo#"
								errorDat_2="#arguments.Ucodigoref#"
				>
			</cfif>
		</cfif>
		
		<!--- 3. Calcula el factor de conversion de la moneda del documento a la local.
				 Ademés calcula el factor de conversion de la moneda del documento a
				 la original de la línea del tracking --->
		<cfif not isdefined("arguments.Mcodigoref")>
			<cf_errorCode	code = "51105" msg = "La moneda del ítem en el tracking destino no está definida">
		<cfelse>
			<cfset factorConversion = arguments.ETtipocambiofac>
			
			<!--- Factor de conversión de la moneda del documento a la original de la línea --->
			<cfinvoke method="obtenerFactorConversionMoneda"
			 returnvariable="factorConversionMonedaFO">
				<cfinvokeargument name="Mcodigo" value="#arguments.Mcodigo#"/>
				<cfinvokeargument name="Mcodigoref" value="#arguments.Mcodigoref#"/>
				<cfinvokeargument name="TipoCambio" value="#arguments.ETtipocambiofac#"/>
				<cfinvokeargument name="TipoCambioRef" value="#arguments.ETtipocambiofacref#"/>
				<cfinvokeargument name="Fecha" value="#arguments.FechaDocumento#"/>
				<cfinvokeargument name="UsarTCDoc" value="true"/>
			</cfinvoke>
		</cfif>

		<!--- 4. Actualiza los costos --->
		
		<cfif (arguments.ETIcantidad le 0 or arguments.ETcantfactura le 0) and arguments.Monto le 0.00>
			<cf_errorCode	code = "51106" msg = "Para actualizar un ítem por nota de crédito o débito, o la cantidad o el monto debe ser mayor a 0">
		</cfif>
		
		<!--- 4.1. Si es una nota de crédito, resta --->
		<cfif TipoDocumento eq 'N'>
			<cfquery name="rsUpdateDetalleItem" datasource="#session.dsn#">
				update ETrackingItems
				set ETIcantidad = ETIcantidad - <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * conversionUnidades.CUfactor#">,
					ETcostodirecto = ETcostodirecto - <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto * factorConversion#">,
					ETcantfactura = ETcantfactura - <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETcantfactura * conversionUnidades.CUfactor#">,
					ETcostodirectofacorig = ETcostodirectofacorig - <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto * factorConversionMonedaFO#">
				where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETIiditem#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
			</cfquery>
		
		<!--- 4.2. Si es una nota de débito, suma --->
		<cfelse>
			<cfquery name="rsUpdateDetalleItem" datasource="#session.dsn#">
				update ETrackingItems
				set ETIcantidad = ETIcantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * conversionUnidades.CUfactor#">,
					ETcostodirecto = ETcostodirecto + <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto * factorConversion#">,
					ETcantfactura = ETcantfactura + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETcantfactura * conversionUnidades.CUfactor#">,
					ETcostodirectofacorig = ETcostodirectofacorig + <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto * factorConversionMonedaFO#">
				where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETIiditem#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
			</cfquery>
		</cfif>
		<cfreturn true>
	</cffunction>

	<!--- Función que agrega un nuevo ítem a un tracking existente --->
	<cffunction name="addTrackingItem" access="public" output="false" returntype="boolean">
		<cfargument name="Ecodigo" 			type="numeric"  required="no">
		<cfargument name="Usucodigo" 		type="numeric" 	default="#Session.Usucodigo#">
		<cfargument name="ETidtracking" 	type="numeric" 	required="yes">
		<cfargument name="DOlinea" 			type="numeric" 	required="yes">
		<cfargument name="DOdescripcion" 	type="string" 	required="yes">
		<cfargument name="ETIcantidad" 		type="numeric" 	required="yes">
		<cfargument name="ETcantfactura" 	type="numeric" 	required="yes">
		<cfargument name="ETcostodirecto" 	type="numeric" 	required="yes">
		<cfargument name="Ucodigo" 			type="string" 	required="yes">
		<cfargument name="Mcodigo" 			type="numeric" 	required="yes">
		<cfargument name="ETtipocambiofac" 	type="numeric" 	required="yes">
		<cfargument name="FechaDocumento" 	type="date" 	required="yes">
		
        <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfset insertado = false>
		
		<!--- 1. Verifica si el item a insertar existe en el tracking destino (la misma línea de la misma orden de compra) --->
		<cfquery name="rsExisteEnTrackingDestino" datasource="#session.dsn#">
			select *
			from ETrackingItems
			  where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
				and DOlinea      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
				and ETIestado    = 0
		</cfquery>
		
		<!--- 2. Si existe, obtiene el factor de conversión de las unidades --->
		<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
		
			<!--- 2.1. Si en el tracking existente, el ítem no tiene unidad de medida, notifica el error --->
			<cfif Len(Trim(rsExisteEnTrackingDestino.Ucodigo)) eq 0>
				<cf_errorCode	code = "51107" msg = "El ítem a consolidar también está en el tracking indicado, y el que está en el tracking indicado no tiene unidad de medida asociada">
				
			<!--- 2.2. Obtiene el factor de conversión --->
			<cfelse>
				<cfquery name="conversionUnidades" datasource="#session.dsn#">
					select case when <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#"> = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#"> then 1
								else coalesce(cu.CUfactor, cua.CUAfactor)
						   end as CUfactor
					from DOrdenCM do
                    
						left outer join Articulos art
							on art.Aid = do.Aid
                            
						left outer join ConversionUnidades cu
							on cu.Ecodigo     = art.Ecodigo
							and cu.Ucodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">
							and cu.Ucodigoref = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#">
						
                        left outer join ConversionUnidadesArt cua
							 on cua.Aid 	= do.Aid
                            and cua.Ecodigo = art.Ecodigo
							and art.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">
							and cua.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#">
					where do.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
				</cfquery>
				
				<!--- 2.3. Si no encontró un factor de conversión, notifica el error --->
				<cfif len(trim(conversionUnidades.CUfactor)) eq 0>
					<cf_errorCode	code = "51104"
									msg  = "No se encontró el factor de conversión de la unidad @errorDat_1@ a la unidad @errorDat_2@"
									errorDat_1="#arguments.Ucodigo#"
									errorDat_2="#rsExisteEnTrackingDestino.Ucodigo#"
					>
				</cfif>
			</cfif>
			<cfset factorConversionUnidades = conversionUnidades.CUfactor>
		<cfelse>
			<cfset factorConversionUnidades = 1>
		</cfif>

		<!--- 3. Calcula el factor de conversion de las monedas (documento a local)
				 en caso de que el item a consolidar exista en el tracking destino.
				 Notifica un error si el destino no tiene moneda --->
		<cfif rsExisteEnTrackingDestino.RecordCount gt 0 and len(trim(rsExisteEnTrackingDestino.Mcodigo)) eq 0>
			<cf_errorCode	code = "51105" msg = "La moneda del ítem en el tracking destino no está definida">
		<cfelse>
			<cfset factorConversion = arguments.ETtipocambiofac>
			
			<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
				<cfinvoke method="obtenerFactorConversionMoneda" returnvariable="factorConversionMonedaFO">
					<cfinvokeargument name="Mcodigo" 		value="#arguments.Mcodigo#"/>
					<cfinvokeargument name="Mcodigoref" 	value="#rsExisteEnTrackingDestino.Mcodigo#"/>
					<cfinvokeargument name="TipoCambio" 	value="#arguments.ETtipocambiofac#"/>
					<cfinvokeargument name="TipoCambioRef" 	value="#rsExisteEnTrackingDestino.ETtipocambiofac#"/>
					<cfinvokeargument name="Fecha" 			value="#arguments.FechaDocumento#"/>
					<cfinvokeargument name="UsarTCDoc" 		value="true"/>
				</cfinvoke>
			<cfelse>
				<cfset factorConversionMonedaFO = 1>
			</cfif>
		</cfif>

		<!--- 4. Agrega el ítem --->

		<!--- 4.1. Si el ítem existe en el tracking destino, actualiza los valores --->
		<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
			<cfif arguments.ETIcantidad le 0 and arguments.ETcostodirecto le 0>
				<cf_errorCode	code = "51109" msg = "No se puede agregar un ítem con cantidad y costo 0 a un tracking donde la misma línea de la orden de compra existe">
			</cfif>
			
			<cfquery name="rsUpdateDetalleItem" datasource="#session.dsn#">
				update ETrackingItems
				set ETIcantidad = ETIcantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * factorConversionUnidades#">,
					ETcostodirecto = ETcostodirecto + <cfqueryparam cfsqltype="cf_sql_money" value="#factorConversion * arguments.ETcostodirecto#">,
					ETcantfactura = ETcantfactura + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETcantfactura * factorConversionUnidades#">,
					ETcostodirectofacorig = ETcostodirectofacorig + <cfqueryparam cfsqltype="cf_sql_money" value="#factorConversionMonedaFO * arguments.ETcostodirecto#">
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					and ETIestado = 0
			</cfquery>

		<!--- 4.2. Si no existe en el tracking destino, inserta el ítem --->
		<cfelse>
			<cfif arguments.ETIcantidad le 0 or arguments.ETcostodirecto le 0.00>
				<cf_errorCode	code = "51110" msg = "Para agregar un ítem nuevo, la cantidad y el costo deben ser mayores a 0">
			</cfif>
			
			<cfquery name="rsInsertDetalleItem" datasource="#session.dsn#">
			insert into ETrackingItems (ETidtracking, DOlinea, Ecodigo, CEcodigo, EcodigoASP,
										cncache, ETIcantidad, ETIdescripcion, Usucodigo,
										ETcostodirecto, ETcantfactura, Mcodigo, ETtipocambiofac,
										Ucodigo, BMUsucodigo, ETcostodirectofacorig,
										ETcostoindfletesfacorig, ETcostoindsegfacorig)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.dsn#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#factorConversion * arguments.ETcostodirecto#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETcantfactura#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETtipocambiofac#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.ETcostodirecto#">,
				0.00, 0.00
			)
			</cfquery>
		</cfif>
		
		<cfset insertado = true>
		
		<!--- 5. Actualizar el Código de Tracking en la Linea de la Orden --->
		<cfquery name="updDOrden" datasource="#session.dsn#">
			update DOrdenCM
			 set ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
			where DOlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
		</cfquery>

		<cfreturn insertado>
	</cffunction>
	
	<!--- Función que consolida total o parcialmente una línea de un tracking a otro --->
	<cffunction name="updTrackingItem" access="public" output="false" returntype="boolean">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="Usucodigo" 		type="numeric" 	default="#Session.Usucodigo#">
		<cfargument name="ETidtracking" 	type="numeric" 	required="yes">
		<cfargument name="DOlinea" 			type="numeric" 	required="yes">
		<cfargument name="ETIcantidad" 		type="numeric" 	required="yes">
		<cfargument name="ETidtracking_new" type="numeric" 	required="no">
		<cfargument name="cncache" 			type="string" 	default="#Session.DSN#" required="yes">

	    <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfset resultUpdTracking = true>
		
		<cfif arguments.ETidtracking eq arguments.ETidtracking_new>
			<cf_errorCode	code = "51111" msg = "No se puede consolidar al mismo tracking">
		</cfif>
		
		<!--- Obtiene los datos del tracking original --->
		<cfquery name="datosTracking" datasource="#arguments.cncache#">
			select ETidtracking, ETnumtracking, ETconsecutivo, CEcodigo, EcodigoASP, Ecodigo, ETcodigo, cncache, EOidorden, 
				   ETnumreferencia, CRid, ETfechagenerado, ETfechaestimada, ETfechaentrega, ETfechasalida, 
				   ETnumembarque, ETrecibidopor, ETmediotransporte,
				   BMUsucodigo, ETestado, ETcampousuario, ETcampopwd
			from ETracking
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
		</cfquery>

		<!--- Obtiene los detalles del ítem a cambiar --->
		<cfquery name="rsDetalleItem" datasource="#arguments.cncache#">
			select *
			from ETrackingItems
			where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
				and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
				and ETIestado = 0
		</cfquery>

		<!--- Verifica si el item actual existe en el tracking destino (La misma línea de la misma orden de compra) --->
		<cfquery name="rsExisteEnTrackingDestino" datasource="#arguments.cncache#">
			select *
			from ETrackingItems
			where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking_new#">
				and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
				and ETIestado = 0
		</cfquery>
		
		<!--- Valida tengan las unidades definidas
			  y que exista un factor de conversion si la línea existe en el destino --->
		<cfif rsDetalleItem.RecordCount eq 0>
			<cf_errorCode	code = "51112" msg = "El ítem indicado no se encuentra en el tracking actual">
		</cfif>
		
		<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
			<cfif Len(Trim(rsDetalleItem.Ucodigo)) eq 0>
				<cf_errorCode	code = "51113" msg = "El ítem indicado no tiene unidad de medida asociada">
			<cfelseif Len(Trim(rsExisteEnTrackingDestino.Ucodigo)) eq 0>
				<cf_errorCode	code = "51107" msg = "El ítem a consolidar también está en el tracking indicado, y el que está en el tracking indicado no tiene unidad de medida asociada">
			<cfelse>
				<cfquery name="conversionUnidades" datasource="#arguments.cncache#">
					select case when <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleItem.Ucodigo#"> = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#"> then 1
								else coalesce(cu.CUfactor, cua.CUAfactor)
						   end as CUfactor
					from ETrackingItems eti
                    
						inner join DOrdenCM do
							on do.DOlinea = eti.DOlinea
                            
						left outer join Articulos art
							on art.Aid = do.Aid
							
						left outer join ConversionUnidades cu
							on cu.Ecodigo     = eti.Ecodigo
							and cu.Ucodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleItem.Ucodigo#">
							and cu.Ucodigoref = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#">
						left outer join ConversionUnidadesArt cua
							 on cua.Aid       = do.Aid
                             and cua.Ecodigo  = art.Ecodigo
							 and art.Ucodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleItem.Ucodigo#">
							 and cua.Ucodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#rsExisteEnTrackingDestino.Ucodigo#">
							
					where eti.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleItem.DOlinea#">
						and eti.ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleItem.ETIiditem#">
				</cfquery>
				<cfif len(trim(conversionUnidades.CUfactor)) eq 0>
					<cf_errorCode	code = "51104"
									msg  = "No se encontró el factor de conversión de la unidad @errorDat_1@ a la unidad @errorDat_2@"
									errorDat_1="#rsDetalleItem.Ucodigo#"
									errorDat_2="#rsExisteEnTrackingDestino.Ucodigo#"
					>
				</cfif>
			</cfif>
			<cfset factorConversionUnidades = conversionUnidades.CUfactor>
		<cfelse>
			<cfset factorConversionUnidades = 1>
		</cfif>
		
		<!--- Verifica que las monedas existan --->
		<cfif not Len(Trim(rsDetalleItem.Mcodigo))>
			<cf_errorCode	code = "51115" msg = "La moneda no está definida para el ítem a consolidar">
		<cfelseif rsExisteEnTrackingDestino.RecordCount gt 0 and not Len(Trim(rsExisteEnTrackingDestino.Mcodigo))>
			<cf_errorCode	code = "51105" msg = "La moneda del ítem en el tracking destino no está definida">
		<cfelseif rsExisteEnTrackingDestino.RecordCount gt 0>
			<cfinvoke method="obtenerFactorConversionMoneda" returnvariable="factorConversionMonedaFO">
				<cfinvokeargument name="Mcodigo" 		value="#rsDetalleItem.Mcodigo#"/>
				<cfinvokeargument name="Mcodigoref" 	value="#rsExisteEnTrackingDestino.Mcodigo#"/>
				<cfinvokeargument name="TipoCambio" 	value="#rsDetalleItem.ETtipocambiofac#"/>
				<cfinvokeargument name="TipoCambioRef" 	value="#rsExisteEnTrackingDestino.ETtipocambiofac#"/>
				<cfinvokeargument name="Fecha" 			value="#Now()#"/>
				<cfinvokeargument name="UsarTCDoc" 		value="false"/>
			</cfinvoke>
		<cfelse>
			<cfset factorConversionMonedaFO = 1>
		</cfif>

		<!--- Si la cantidad a consolidar es igual a la cantidad actual en el tracking (Consolidación total) y no se ha desalmacenado nada --->
		<cfif arguments.ETIcantidad eq rsDetalleItem.ETIcantidad and rsDetalleItem.ETcantrecibida eq 0>
			<!--- Si existe en el tracking destino --->
			<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
				<cfquery name="rsUpdateDetalleItem" datasource="#arguments.cncache#">
					update ETrackingItems
					set ETIcantidad 			= ETIcantidad 				+ <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * factorConversionUnidades#">,
						ETcostodirecto 			= ETcostodirecto			+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostodirecto#">,
						ETcostoindfletes 		= ETcostoindfletes			+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindfletes#">,
						ETcostoindseg 			= ETcostoindseg 			+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindseg#">,
						ETcantfactura 			= ETcantfactura 			+ <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * factorConversionUnidades#">,
						ETcostodirectofacorig 	= ETcostodirectofacorig 	+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostodirectofacorig#">,
						ETcostoindfletesfacorig = ETcostoindfletesfacorig 	+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindfletesfacorig#">,
						ETcostoindsegfacorig 	= ETcostoindsegfacorig 		+ <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindsegfacorig#">
					where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking_new#">
					  and DOlinea 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					  and ETIestado    = 0
				</cfquery>
				<cfquery name="rsDeleteDetalleOriginal" datasource="#arguments.cncache#">
					delete from ETrackingItems
					 where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
					   and DOlinea      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					   and ETIestado    = 0
				</cfquery>
				
			<!--- Si no existe en el tracking destino --->
			<cfelse>
				<cfquery name="rsUpdateDetalleItem" datasource="#arguments.cncache#">
					update ETrackingItems
					set ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking_new#">
					 where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
					   and DOlinea 	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					   and ETIestado 	= 0
				</cfquery>
			</cfif>
			
		<!--- Si es una consolidación parcial --->
		<cfelse>
		
			<!--- Se calcula el porcentaje de lo que se va a consolidar --->
			<cfset porcentaje = arguments.ETIcantidad / rsDetalleItem.ETIcantidad>
			<!--- Calcula la cantidad de factura que se va a pasar y la que va a quedar --->
			<cfset cantFacturaTN = arguments.ETIcantidad * factorConversionUnidades>
			<cfset cantFacturaTO = rsDetalleItem.ETcantfactura - arguments.ETIcantidad>
			
			<!--- Si existe en el tracking destino --->
			<cfif rsExisteEnTrackingDestino.RecordCount gt 0>
				<cfquery name="rsUpdateDetalleItem" datasource="#arguments.cncache#">
					update ETrackingItems
					set ETIcantidad 			= ETIcantidad 			  + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad * factorConversionUnidades#">,
						ETcostodirecto 			= ETcostodirecto 		  + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostodirecto - rsDetalleItem.ETcostodirectorec)#">,
						ETcostoindfletes 		= ETcostoindfletes 		  + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostoindfletes - rsDetalleItem.ETcostoindfletesrec)#">,
						ETcostoindseg 			= ETcostoindseg 		  + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostoindseg - rsDetalleItem.ETcostoindsegrec)#">,
						ETcantfactura 			= ETcantfactura 		  + <cfqueryparam cfsqltype="cf_sql_float" value="#cantFacturaTN#">,
						ETcostodirectofacorig   = ETcostodirectofacorig   + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostodirectofacorig#">,
						ETcostoindfletesfacorig = ETcostoindfletesfacorig + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostoindfletesfacorig#">,
						ETcostoindsegfacorig 	= ETcostoindsegfacorig    + <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostoindsegfacorig#">
					where ETidtracking 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking_new#">
					  and DOlinea 	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					  and ETIestado 	= 0
				</cfquery>

			<!--- Si no existe en el tracking destino --->
			<cfelse>
				<cfquery name="rsInsertDetalleItem" datasource="#arguments.cncache#">
					insert into ETrackingItems (ETidtracking, DOlinea, Ecodigo, CEcodigo, EcodigoASP, cncache,
												ETIcantidad, ETIdescripcion, Usucodigo, ETcostodirecto,
												ETcostoindfletes, ETcostoindseg, ETcostoindsegpropio,
												ETcostoindgastos, ETcostoindimp, ETcostorecibido, ETcantfactura,
												ETcantrecibida, Mcodigo, ETtipocambiofac, BMUsucodigo, Ucodigo,
												ETcostodirectofacorig, ETcostoindfletesfacorig, ETcostoindsegfacorig)
					select
						#arguments.ETidtracking_new#,
						DOlinea,
						Ecodigo, 
						CEcodigo, 
						EcodigoASP, 
						cncache, 
						#arguments.ETIcantidad#,
						ETIdescripcion,
						#arguments.Usucodigo#,
						#porcentaje * (rsDetalleItem.ETcostodirecto - rsDetalleItem.ETcostodirectorec)#,
						#porcentaje * (rsDetalleItem.ETcostoindfletes - rsDetalleItem.ETcostoindfletesrec)#,
						#porcentaje * (rsDetalleItem.ETcostoindseg - rsDetalleItem.ETcostoindsegrec)#,
						0.00,
						0.00,
						0.00,
						0.00,
						#cantFacturaTN#,
						0.00,
						Mcodigo,
						ETtipocambiofac,
						#session.Usucodigo#,
						Ucodigo,
						#porcentaje * rsDetalleItem.ETcostodirectofacorig#,
						#porcentaje * rsDetalleItem.ETcostoindfletesfacorig#,
						#porcentaje * rsDetalleItem.ETcostoindsegfacorig#
					from ETrackingItems
					where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
						and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
						and ETIestado = 0
				</cfquery>
			</cfif>
			
			<cfquery name="rsUpdateDetalleItem" datasource="#arguments.cncache#">
				update ETrackingItems
				set ETIcantidad = ETIcantidad - <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ETIcantidad#">,
					ETcostodirecto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostodirecto#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostodirecto - rsDetalleItem.ETcostodirectorec)#">,
					ETcostoindfletes = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindfletes#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostoindfletes - rsDetalleItem.ETcostoindfletesrec)#">,
					ETcostoindseg = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindseg#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * (rsDetalleItem.ETcostoindseg - rsDetalleItem.ETcostoindsegrec)#">,
					ETcantfactura = <cfqueryparam cfsqltype="cf_sql_float" value="#cantFacturaTO#">,
					ETcostodirectofacorig = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostodirectofacorig#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostodirectofacorig#">,
					ETcostoindfletesfacorig = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindfletesfacorig#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostoindfletesfacorig#">,
					ETcostoindsegfacorig = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleItem.ETcostoindsegfacorig#"> - <cfqueryparam cfsqltype="cf_sql_money" value="#porcentaje * rsDetalleItem.ETcostoindsegfacorig#">
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
					and ETIestado = 0
			</cfquery>
		</cfif>
				
		<!--- Actualizar el Código de Tracking en la Linea de la Orden --->
		<cfif isdefined("arguments.ETidtracking_new") and Len(Trim(arguments.ETidtracking_new)) and arguments.ETidtracking NEQ arguments.ETidtracking_new>
			<cfquery name="updDOrden" datasource="#arguments.cncache#">
				update DOrdenCM
				 set ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking_new#">
				where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
			</cfquery>
		</cfif>

		<cfreturn resultUpdTracking>
	</cffunction>

	<!--- Función que genera un nuevo tracking de embarque --->
	<cffunction name="generarNumTracking" access="public" output="false" returntype="numeric">
		<cfargument name="CEcodigo" 			type="numeric" 	required="yes"	default="#Session.CEcodigo#">
		<cfargument name="EcodigoASP" 			type="numeric" 	required="yes" 	default="#Session.EcodigoSDC#">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no">
		<cfargument name="Usucodigo" 			type="numeric" 	required="yes" 	default="#Session.Usucodigo#">
		<cfargument name="cncache" 				type="string" 	required="yes" 	default="#Session.DSN#">
		<cfargument name="EOidorden" 			type="numeric" 	required="yes">
		<cfargument name="ETfechasalida" 		type="string" 	required="no">
		<cfargument name="ETfechaestimada" 		type="string" 	required="no">
		<cfargument name="ETfechaentrega" 		type="string" 	required="no">
		<cfargument name="ETnumreferencia" 		type="string" 	required="no" 	default="">
		<cfargument name="CRid" 				type="numeric" 	required="no" 	default="-1">
		<cfargument name="ETnumembarque" 		type="string" 	required="no" 	default="">
		<cfargument name="ETrecibidopor" 		type="string" 	required="no" 	default="">
		<cfargument name="ETmediotransporte" 	type="numeric" 	required="no" 	default="0"> <!--- El medio por defecto es 0: Tierra --->
		<cfargument name="ETcampousuario" 		type="string" 	required="no"	default="">
		<cfargument name="ETcampopwd" 			type="string" 	required="no" 	default="">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<!--- 1. Averiguar si existe el Estado 0 (Inicio) en las tablas de EstadosTracking, si no existe hay que generarlo --->
		<cfquery name="existsEstados" datasource="#arguments.cncache#">
			select 1 from EstadosTracking 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and ETcodigo = 0
		</cfquery>
		
		<!--- 2. Agregar Estado 0 a tabla de Estados de Tracking si no existe --->
		<cfif existsEstados.recordCount EQ 0>
			<cfquery name="rsInsertEstado" datasource="#arguments.cncache#">
				insert into EstadosTracking (Ecodigo, ETcodigo, EcodigoASP, CEcodigo, ETdescripcion, Usucodigo, fechaalta, ETorden)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EcodigoASP#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CEcodigo#">, 
					'Inicio',
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					1
				)
			</cfquery>
		</cfif>
				
		<cfset generar = true>
		<!--- 3. Insertar el Tracking --->
		<cfloop condition="generar">
			<cfset track = this.__randomString(20)>
			<cfquery name="checkExists" datasource="#arguments.cncache#">
				select 1
				from ETracking
				where ETnumtracking = <cfqueryparam cfsqltype="cf_sql_char" value="#track#">
			</cfquery>
			<cfif checkExists.recordCount EQ 0>
				<cfquery name="rsConsecutivo" datasource="#arguments.cncache#">
					select coalesce(max(ETconsecutivo), 0) + 1 as consecutivo
					from ETracking
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>

				<cfquery name="rsObtenerIdentityInicio" datasource="#arguments.cncache#">
					select max(ETidtracking) as ETidtracking
					from ETracking
				</cfquery>
				
				<!--- Insercion de Tracking --->
				<cfquery name="rsInsertEncabezado" datasource="#arguments.cncache#">
					insert into ETracking (ETnumtracking, ETconsecutivo, CEcodigo, EcodigoASP, Ecodigo, ETcodigo, cncache, EOidorden, ETfechagenerado, ETfechasalida, ETfechaestimada, ETfechaentrega, ETnumreferencia, CRid, ETnumembarque, ETrecibidopor, ETmediotransporte, ETcampousuario, ETcampopwd, BMUsucodigo, ETestado)
					values (
						<cfqueryparam cfsqltype="cf_sql_char" value="#track#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivo.consecutivo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CEcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EcodigoASP#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
						0, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cncache#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EOidorden#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfif isdefined("arguments.ETfechasalida") and Len(Trim(arguments.ETfechasalida)) NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechasalida)#">, 
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("arguments.ETfechaestimada") and Len(Trim(arguments.ETfechaestimada)) NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechaestimada)#">, 
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("arguments.ETfechaentrega") and Len(Trim(arguments.ETfechaentrega)) NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechaentrega)#">, 
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETnumreferencia#" null="#Len(Trim(arguments.ETnumreferencia)) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CRid#" null="#arguments.CRid EQ -1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETnumembarque#" null="#Len(Trim(arguments.ETnumembarque)) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETrecibidopor#" null="#Len(Trim(arguments.ETrecibidopor)) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ETmediotransporte#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETcampousuario#" null="#Len(Trim(arguments.ETcampousuario)) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETcampopwd#" null="#Len(Trim(arguments.ETcampopwd)) EQ 0#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
						'P'
					)
					<!---cf_dbidentity1 datasource="#arguments.cncache#" verificar_transaccion="false"--->
				</cfquery>
				<!---cf_dbidentity2 datasource="#arguments.cncache#" name="rsInsertEncabezado" verificar_transaccion="false"--->
				<!---cfset idtracking = rsInsertEncabezado.identity--->
				
				<!--- Se utiliza el max por el momento, porque el dbidentity para vistas en oracle no sirve --->
				<cfquery name="rsObtenerIdentityFin" datasource="#arguments.cncache#">
					select max(ETidtracking) as ETidtracking
					from ETracking
				</cfquery>
				
				<cfif rsObtenerIdentityFin.RecordCount eq 0 or (rsObtenerIdentityInicio.RecordCount gt 0 and rsObtenerIdentityInicio.ETidtracking eq rsObtenerIdentityFin.ETidtracking)>
					<cfset idtracking = 0>
				<cfelse>
					<cfset idtracking = rsObtenerIdentityFin.ETidtracking>
				</cfif>
			
				<cfset generar = false>
			</cfif>
		</cfloop>

		<!--- 4. Retorna el Tracking generado si el proceso fue exitoso, si no fue exitoso, retorna un 0 (cero) --->
		<cfif isdefined("idtracking") and len(trim(idtracking)) gt 0>
			<cfreturn idtracking>
		</cfif>
		<cfreturn 0>
	</cffunction>

	<cffunction name="init">
		<cfreturn This>
		
	</cffunction>

	<!--- Función que actualiza los datos de un tracking (encabezado) --->
	<cffunction name="updNumTracking" access="public" output="false">
		<cfargument name="Ecodigo" 				type="numeric"	required="no">
		<cfargument name="Usucodigo"	 		type="numeric" 	default="#Session.Usucodigo#" required="yes">
		<cfargument name="ETidtracking" 		type="numeric" 	required="yes">
		<cfargument name="ETestado" 			type="string" 	required="yes">
		<cfargument name="ETfechasalida" 		type="string" 	required="no">
		<cfargument name="ETfechaestimada" 		type="string" 	required="no">
		<cfargument name="ETfechaentrega" 		type="string" 	required="no">
		<cfargument name="ETnumreferencia" 		type="string" 	required="no" default="">
		<cfargument name="CRid" 				type="numeric" 	required="no" default="-1">
		<cfargument name="ETnumembarque" 		type="string" 	required="no" default="">
		<cfargument name="ETrecibidopor" 		type="string" 	required="no" default="">
		<cfargument name="ETmediotransporte" 	type="numeric" 	required="no" default="-1">
		<cfargument name="ETcampousuario" 		type="string" 	required="no" default="">
		<cfargument name="ETcampopwd" 			type="string" 	required="no" default="">
		
        <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
		<cfquery name="rsUpdateEncabezado" datasource="sifpublica">
			update ETracking set
				<cfif isdefined("arguments.ETfechasalida") and Len(Trim(arguments.ETfechasalida)) NEQ 0>
					ETfechasalida = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechasalida)#">, 
				<cfelse>
					ETfechasalida = null,
				</cfif>
				<cfif isdefined("arguments.ETfechaestimada") and Len(Trim(arguments.ETfechaestimada)) NEQ 0>
					ETfechaestimada = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechaestimada)#">, 
				<cfelse>
					ETfechaestimada = null,
				</cfif>
				<cfif isdefined("arguments.ETfechaentrega") and Len(Trim(arguments.ETfechaentrega)) NEQ 0>
					ETfechaentrega = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.ETfechaentrega)#">, 
				<cfelse>
					ETfechaentrega = null,
				</cfif>
				ETnumreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETnumreferencia#" null="#Len(Trim(arguments.ETnumreferencia)) EQ 0#">, 
				CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CRid#" null="#arguments.CRid EQ -1#">, 
				ETnumembarque = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETnumembarque#" null="#Len(Trim(arguments.ETnumembarque)) EQ 0#">, 
				ETrecibidopor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETrecibidopor#" null="#Len(Trim(arguments.ETrecibidopor)) EQ 0#">, 
				ETmediotransporte = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ETmediotransporte#">, 
				ETcampousuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETcampousuario#" null="#Len(Trim(arguments.ETcampousuario)) EQ 0#">, 
				ETcampopwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ETcampopwd#" null="#Len(Trim(arguments.ETcampopwd)) EQ 0#">, 
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
				ETestado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ETestado#">
			where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETidtracking#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
	</cffunction>

</cfcomponent>


