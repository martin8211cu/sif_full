<cfcomponent output="false">

	<cffunction name="creaTransaccion" access="public" return="numeric">

		<!--- ARGUMENTOS REQUERIDOS --->
		<cfargument name="Monto" required="yes">
		<cfargument name="Parcialidades" required="yes">
		<cfargument name="Tipo_Producto" required="yes">
		<cfargument name="Num_Producto" required="yes">
		<cfargument name="Num_Ticket" required="yes">
		<cfargument name="Fecha_Inicio_Pago" required="yes">
		<cfargument name="Fecha_Transaccion" required="yes">
		<cfargument name="Codigo_Transaccion" required="yes">

		<!--- ARGUMENTOS OPCIONALES --->
		<cfargument name="ID_Tienda" 			default='' 			type="string">
		<cfargument name="Cliente" 				default='' 			type="string">
		<cfargument name="Observaciones" 		default='' 			type="string">
		<cfargument name="DSN" 					default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 				default="#Session.Ecodigo#" type="string">
		<cfargument name="ID_SocioNegocio" 		default=0 			type="numeric">
		<cfargument name="CURP" 				default='' 			type="string">
		<!--- ARGUMENTOS INTERNOS --->
		<cfargument name="infoCuenta" default=''>


		<cfset arguments.Fecha_Inicio_Pago = replace(arguments.Fecha_Inicio_Pago,"'",'',"all")>
		<cfset arguments.Fecha_Inicio_Pago = replace(arguments.Fecha_Inicio_Pago,'"','',"all")>

		<cfif arguments.Ecodigo eq 0><cfthrow type="TransaccionException" message = "Ecodigo CERO - No ha iniciado sesion"> </cfif>

		<!--- VALIDACION MONTO MAYOR A CERO --->
		<cfif arguments.Monto eq 0> <cfreturn 'Monto CERO'> </cfif>

		<!--- VALIDACION TICKET REPETIDO --->
		<cfquery name="q_Unique" datasource="#arguments.DSN#">
			Select id from CRCTransaccion where Ticket = #arguments.Num_Ticket# and Ecodigo = '#arguments.Ecodigo#';
		</cfquery>

		<cfif q_Unique.recordcount neq 0>
			<cfreturn 'ticket repetido'>
		</cfif>

		<!--- DEFINICION DE COMPONENTE D,TC,TM --->
		<cfset num_Folio = ''>
		<cfset num_Tarjeta_id = ''>

		<cfset VC_Externo = 0>


		<!--- VALIDACION EXISTENCIA DE PRODUCTO --->
		<cfquery name="q_Unique" datasource="#arguments.DSN#">
			select distinct(tipo) tipo from CRCCuentas;
		</cfquery>

		<cfset tipoProductoErroneo = true>
		<cfloop query = 'q_Unique'>
			<cfif trim(q_Unique.tipo) eq trim(arguments.Tipo_Producto)>
				<cfset tipoProductoErroneo = false>
			</cfif>
		</cfloop>
		<cfif tipoProductoErroneo>
			<cfreturn 'no existe el producto'>
		</cfif>

		<cfif arguments.Tipo_Producto eq 'D'>
			<cfset componentPath = "crc.Componentes.CRCFolios">
			<cfset num_Folio = arguments.Num_Producto>
		<cfelseif arguments.Tipo_Producto eq 'TC' || arguments.Tipo_Producto eq 'TM'>
			<cfset componentPath = "crc.Componentes.CRCTarjetas">
			<cfquery name="q_Tarjeta" datasource="#arguments.DSN#">
				select id from CRCTarjeta where Numero = '#arguments.Num_Producto#';
			</cfquery>
			<cfset num_Tarjeta_id = QueryGetRow(q_Tarjeta, 1).id>
		<cfelse>
			<cfset componentPath = "crc.Componentes.CRCExterno">
			<cfset num_Folio = arguments.Num_Producto>
			<cfset VC_Externo = 1>
		</cfif>

		<!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
		<cfquery name="q_TipoTransaccion" datasource="#arguments.DSN#">
			select id, TipoMov from CRCTipoTransaccion where Codigo = '#arguments.Codigo_Transaccion#';
		</cfquery>
		<cfif q_TipoTransaccion.recordcount eq 0>
			<cfthrow type="TransaccionException" message = "Codigo de Transaccion [#trim(arguments.Codigo_Transaccion)#] No Existe">
		</cfif>

		<!--- ANALISIS DE DISPONIBILIDAD EN CUENTA Y VALIDACION DE FOLIO/TARJETA--->

		<cfset objCuenta = createObject("component","#componentPath#")>
		<cfif arguments.infoCuenta eq ''>
			<cfset arguments.infoCuenta = objCuenta.ValidarNumero(
				  Monto = #arguments.Monto#
				, Num_Producto = #arguments.Num_Producto#
				, DSN = #arguments.DSN#
				, Ecodigo = #arguments.Ecodigo#
				, SocioNegocioID = #ID_SocioNegocio#
				, TipoProducto = '#arguments.Tipo_Producto#'
				, TipoTransac = "#QueryGetRow(q_TipoTransaccion, 1).TipoMov#"
				, TiendaID = #ID_Tienda#
			)>
		</cfif>


		<!--- INICIO NUEVA TRANSACCION --->
		<cfif arguments.infoCuenta>
			<cfset idTransaccion = 0>

			<!--- INSERTA TRANSACCION --->
			<cftry>
				<cfquery name="q_Transaccion" datasource="#arguments.DSN#">
					insert into CRCTransaccion (
					 CRCCuentasid,
					 CRCTipoTransaccionid,
					 TipoTransaccion,
					 CRCTarjetaid,
					 Folio,
					 Fecha,
					 Tienda,
					 Ticket,
					 Monto,
					 Cliente,
					 Parciales,
					 FechaInicioPago,
					 Observaciones,
					 Ecodigo,
					 Usucrea,
					 Usumodif,
					 createdat,
					 CURP
					 )
					values (
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.infoCuenta#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#QueryGetRow(q_TipoTransaccion, 1).id#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Codigo_Transaccion#">,
					 <cfif num_Tarjeta_id eq ''>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
					 <cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#num_Tarjeta_id#">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#num_Folio#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha_Transaccion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID_Tienda#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Num_Ticket#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Cliente#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Parcialidades#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha_Inicio_Pago#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">,	
					 <cfqueryparam cfsqltype="cf_sql_numeric" null="yes">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" null="yes">,
					 CURRENT_TIMESTAMP,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CURP#">
					)
					;
					<cf_dbidentity1 datasource="#arguments.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.DSN#" name="q_Transaccion">	
				<cfset idTransaccion = q_Transaccion.identity>
				<cfcatch>
					<cfreturn 'falla insert transaction'>
				</cfcatch>
			</cftry>



			<!--- GENERAR PARCIALIDADES --->

			<cftry>
				<cfif idTransaccion eq 0> <cfreturn 'no hay transaccion para generar'> </cfif>
				<cfset componentPath = "crc.Componentes.CRCMovimientos">
				<cfset objCuenta = createObject("component","#componentPath#")>
				<cfset result = objCuenta.creaMovimientoCuenta(
						TransaccionID = #idTransaccion#
					,	CuentaID = #arguments.infoCuenta#
					,	Monto = #arguments.Monto#
					,	Parcialidades = "#arguments.Parcialidades#"
					,	Fecha_Inicio_Pago = "#arguments.Fecha_Inicio_Pago#"
					,	Codigo_Transaccion = "#arguments.Codigo_Transaccion#"
					,	Tipo_Producto = "#arguments.Tipo_Producto#"
					,	Observaciones = "#arguments.Observaciones#"
					,	DSN = #arguments.DSN#
					, 	Ecodigo = #arguments.Ecodigo#
				)>
				<cfoutput> <cfdump var="#result#"></cfoutput>
				<cfcatch>
					<cfreturn 'falla Generar Parcialidades'>
				</cfcatch>
			</cftry>


			<!--- AFECTAR A LA CUENTA --->

			<!--- <cftry> --->
				<cfif idTransaccion eq 0> <cfreturn 'no hay transaccion para afectar'> </cfif>
				<cfset componentPath = "crc.Componentes.CRCCuentas">
				<cfset objCuenta = createObject("component","#componentPath#")>
				<cfset result = objCuenta.afectarCuenta(
						Monto = #arguments.Monto#
					,	CuentaID = #arguments.infoCuenta#
					,	CodigoTipoTransaccion = "#arguments.Codigo_Transaccion#"
					,	DSN = #arguments.DSN#
					, 	Ecodigo = #arguments.Ecodigo#
				)>
				<cfreturn 'OK'>
			<!--- <cfcatch>
					<cfreturn 'Falla afectar cuenta'>
				</cfcatch>
			</cftry> --->

		</cfif>

		<cfreturn 'Sin Disponibilidad'>


	</cffunction>


</cfcomponent>