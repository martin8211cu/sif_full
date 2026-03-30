<cfcomponent>
	<cffunction name="CreaIdKardex" access="public" output="false" returntype="string">
		<cfargument name='Conexion' type='string' required='false'>
		<cfif (not isdefined("Arguments.Conexion"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>

		<cf_dbtemp name="IN_IDKARDEX_V2" returnvariable="IN_IN_PosteLin_IDKARDEX_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Kid"   		type="numeric"	  mandatory="yes">
			<cf_dbtempcol name="IDcontable" type="numeric"	  mandatory="no">
			<cf_dbtempkey cols="Kid">
		</cf_dbtemp>
		<cfset Request.idkardex = IN_IN_PosteLin_IDKARDEX_NAME>
		<cfreturn IN_IN_PosteLin_IDKARDEX_NAME>
	</cffunction>

	<cffunction name="IN_MonedaValuacion" access="public" output="false" returntype="struct">
		<!--- Parámetros requeridos del método --->
		<cfargument name="Ecodigo" 		required="true" 	type="numeric" 	hint="Empresa" >
		<cfargument name="tcFecha"		required="true" 	type="date" 	hint="Fecha de Consulta" >
		<cfargument name="Conexion" 	required="true"		type="string"	>
		<cfargument name="McodigoOrigen"required="false"  	type="numeric" 	default="-1" 		hint="Moneda Origen">
		<cfargument name="tcOrigen"		required="false" 	type="numeric"	default="-1" 		hint="Tipo Cambio Origen" >
		<cfargument name="tcValuacion"	required="false" 	type="numeric"	default="-1" 		hint="Tipo Cambio Valuacion" >

		<cfset LvarCOSTOS			= StructNew()>
		<cfset LvarCOSTOS.VALUACION	= StructNew()>
		<cfset LvarCOSTOS.LOCAL		= StructNew()>

		<cfset LvarCOSTOS.VALUACION.Costo	= 0>
		<cfset LvarCOSTOS.LOCAL.Costo		= 0>

		<cfset LvarCOSTOS.VALUACION.TC		= 0>
		<cfset LvarCOSTOS.LOCAL.TC			= 1>

		<!--- 2.5.2 Moneda Local de la Empresa --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select Mcodigo 
			  from Empresas
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarCOSTOS.LOCAL.Mcodigo = rs.Mcodigo>
	
		<!--- 2.5.3 Moneda de Valuación --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select Pvalor as Mcodigo 
			  from Parametros 
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			   and Pcodigo = 441
		</cfquery>
		<cfif rs.recordcount eq 0>
			<cf_errorCode	code = "51187" msg = "Error en IN_PosteoLin. No se ha definido la Moneda de Valuacion de Inventarios. Proceso Cancelado!">
		</cfif>
		
		<cfset LvarCOSTOS.VALUACION.Mcodigo = rs.Mcodigo>
	
		<!--- 2.5.5 Tipo de Cambio Histórico para la Moneda de Valuación --->
		<cfif LvarCOSTOS.VALUACION.Mcodigo EQ LvarCOSTOS.LOCAL.Mcodigo>
			<cfset LvarCOSTOS.VALUACION.TC = 1>
		<cfelseif LvarCOSTOS.VALUACION.Mcodigo EQ Arguments.McodigoOrigen>
			<cfif Arguments.tcOrigen EQ -1>
				<cf_errorCode	code = "51188" msg = "Error en IN_PosteoLin. La moneda de Valuación es igual a la moneda Origen pero no se envió Tipo de Cambio Origen. Proceso Cancelado!">
			<cfelseif Arguments.tcValuacion NEQ -1 and numberFormat(Arguments.tcValuacion,"9.9999999999") NEQ numberFormat(Arguments.tcOrigen,"9.9999999999")>
				<cf_errorCode	code = "51189"
								msg  = "Error en IN_PosteoLin. La moneda de Valuación es igual a la moneda Origen pero se envió Tipos Cambios diferentes: Valuacion=@errorDat_1@, Origen=@errorDat_2@. Proceso Cancelado!"
								errorDat_1="#numberFormat(Arguments.tcValuacion,"9.9999999999")#"
								errorDat_2="#numberFormat(Arguments.tcOrigen,"9.9999999999")#"
				>
			</cfif>
			<cfset LvarCOSTOS.VALUACION.TC = Arguments.tcOrigen>
		<cfelseif Arguments.tcValuacion NEQ -1>
			<cfset LvarCOSTOS.VALUACION.TC = Arguments.tcValuacion>
		<cfelse>
			<cfquery name="rs" datasource="#Session.DSN#">
				select tc.Hfecha, tc.TCcompra, tc.TCventa, tc.TCpromedio
				  from Htipocambio tc
				 where tc.Ecodigo =  #Arguments.Ecodigo#
				   and tc.Mcodigo =  #LvarCOSTOS.VALUACION.Mcodigo#
				   and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.tcFecha#">
				   and tc.Hfechah  >  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.tcFecha#">
			</cfquery>
			
			<cfif rs.Hfecha EQ "" OR datediff("d",rs.Hfecha,Arguments.tcFecha) GT 30>
				<cfquery name="rs" datasource="#Session.DSN#">
					select Miso4217
					  from Monedas
					 where Ecodigo = #Arguments.Ecodigo#
					   and Mcodigo = #LvarCOSTOS.VALUACION.Mcodigo#
				</cfquery>
				<cf_errorCode	code = "51190"
								msg  = "Error en IN_PosteoLin. La moneda de valuación de Inventarios '@errorDat_1@' no tiene tipo de cambio histórico para los últimos 30 días"
								errorDat_1="#rs.Miso4217#"
				>
			</cfif>
			<cfset LvarCOSTOS.VALUACION.TC = rs.TCpromedio>
		</cfif>

		<cfreturn LvarCOSTOS>
	</cffunction>

	<cffunction name="IN_CostoActual" access="public" output="false" returntype="struct">
		<cfargument name="Ecodigo" 		required="true"		type="numeric" 	hint="Empresa">
		<cfargument name="Aid" 			required="true"		type="numeric" 	hint="id del Artículo" >
		<cfargument name="Alm_Aid" 		required="true"		type="numeric"	hint="id del Almacén" >
		<cfargument name="Cantidad" 	required="true" 	type="numeric"	hint="Cantidad a Costear" >
		<cfargument name="tcFecha"		required="true" 	type="date" 	hint="Fecha de Consulta" >
		<cfargument name="Conexion" 	required="false"	type="string"	default="#Session.Dsn#">
		<cfargument name="McodigoOrigen"required="false"  	type="numeric" 	default="-1" 		hint="Moneda Origen">
		<cfargument name="tcOrigen"		required="false" 	type="numeric"	default="-1" 		hint="Tipo Cambio Valuacion" >
		<cfargument name="tcValuacion"	required="false" 	type="numeric"	default="-1" 		hint="Tipo Cambio Valuacion" >

		<cfset LvarCOSTOS			= IN_MonedaValuacion(Arguments.Ecodigo, Arguments.tcFecha, Arguments.Conexion, Arguments.McodigoOrigen, Arguments.tcOrigen, Arguments.tcValuacion)>
		<cfset LvarCOSTOS.Cantidad	= Arguments.Cantidad>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select round ( 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.Cantidad#">
						*
						case when Eexistencia <> 0 then coalesce(Ecostototal / Eexistencia,0) else coalesce(Ecostou, 0.00) end
					, 5) as CostoValuacion
			  from Existencias 
			 where Aid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			   and Alm_Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
			   and Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>

		<cfif rsSQL.recordcount GT 0>
			<cfset LvarCOSTOS.VALUACION.Costo = rsSQL.CostoValuacion>

			<cfif LvarCOSTOS.LOCAL.Mcodigo EQ LvarCOSTOS.VALUACION.Mcodigo>
				<cfset LvarCOSTOS.LOCAL.Costo = rsSQL.CostoValuacion>
			<cfelse>
				<cfset LvarCOSTOS.LOCAL.Costo = rsSQL.CostoValuacion * LvarCOSTOS.VALUACION.TC>
				<cfset LvarCOSTOS.LOCAL.Costo = round(LvarCOSTOS.LOCAL.Costo*100)/100>
			</cfif>
		</cfif>

		<cfreturn LvarCOSTOS>
	</cffunction>

	<cffunction name="IN_PosteoLin" access="public" returntype="struct">
		<!--- Parámetros requeridos del método --->
		<cfargument name="Aid" 		required="true" type="numeric" 	hint="id del Artículo" >
		<cfargument name="Alm_Aid" 	required="true" type="numeric"	hint="id del Almacén" >
		<cfargument name="Tipo_Mov" required="true" type="string"	hint="Tipo de Movimiento (E=Entrada, S=Salida, R=Requisicion, M=Movimiento Interalmacen, I=Inventario Físico, A=Ajuste)" >
		<cfargument name="Cantidad" required="true" type="numeric"	hint="Cantidad de Movimiento" >
		
		<!--- Parámetros nuevos para Valuación en Moneda Extranjera en lugar de Costo --->
		<!--- 
		<cfargument name="Costo" 				required="false" type="numeric" default="0.00" 		hint="Costo Total de la línea del Movimiento" >
		--->
		<cfargument name="ObtenerCosto" 		required="true"  type="boolean" 			 		hint="Obtener o modificar costo" >
		<cfargument name="McodigoOrigen"		required="true"  type="numeric" default="-1" 		hint="Moneda Origen">
		<cfargument name="CostoOrigen"			required="false" type="numeric" default="0.00"		hint="Costo Total de la línea del Movimiento en Moneda Origen">
		<cfargument name="CostoLocal"			required="false" type="numeric" default="0.00"		hint="Costo Total de la línea del Movimiento en Moneda Local">
		<cfargument name="tcOrigen"				required="false" type="numeric"	default="-1" 		hint="Tipo Cambio Origen" >
		<cfargument name="tcValuacion"			required="false" type="numeric"	default="-1" 		hint="Tipo Cambio Valuacion" >

		<!--- Parámetros no requeridos del método --->
		<cfargument name="Tipo_ES" 				required="false" type="string" 	default="E" 		hint="Tipo Entrada Salida (E=Entrada, S=Salida)" >
		<cfargument name="CFid" 				required="false" type="numeric" default="0" 		hint="id del Centro Funcional" >
		<cfargument name="Dcodigo" 				required="false" type="numeric" default="0" 		hint="id del Departamento" >
		<cfargument name="Ocodigo" 				required="false" type="numeric" default="0" 		hint="id del Oficina" >
		<cfargument name="TipoCambio" 			required="false" type="numeric" default="1" 		hint="Tipo de Cambio utilizado" >
		<cfargument name="TipoDoc" 				required="false" type="string" 	default="" 			hint="Tipo de Transacción CXC" >
		<cfargument name="Documento" 			required="false" type="string" 	default="" 			hint="Documento" >
		<cfargument name="FechaDoc" 			required="false" type="date" 	default="#Now()#" 	hint="Fecha del Documento" >
		<cfargument name="Referencia" 			required="false" type="string" 	default="" 			hint="Referencia" >
		<cfargument name="ERid" 				required="false" type="numeric" default="0" 		hint="Id del Histórico de Requisiciones" >
		<cfargument name="insertarEnKardex" 	required="false" type="boolean" default="true" 		hint="Insertar en el Kardex = AFECTAR INVENTARIO" >
		<cfargument name="verificaPositivo" 	required="false" type="boolean" default="false" 	hint="Verificar existencias y costos positivos" >
		<cfargument name="Conexion" 			required="false" type="string"						hint="Datasource" >
		<cfargument name="Ecodigo" 				required="false" type="numeric" 					hint="Empresa" >
		<cfargument name="EcodigoRequi"			required="false" type="numeric" 					hint="EmpresaIntercompany" >
		<cfargument name="Debug" 				required="false" type="boolean" default="false" 	hint="Debug" >
		<cfargument name="RollBack" 			required="false" type="boolean" default="false" 	hint="RollBack" >
		<cfargument name="TransaccionActiva" 	required="false" type="boolean" default="false" 	hint="TransaccionActiva" >
		<cfargument name="FPAEid" 				required="false" type="numeric" default="-1"	 	hint="ID de la Actividad empresarial">
		<cfargument name="CFComplemento" 		required="false" type="string"  default="" 			hint="Complemento de la Actividad empresarial">
		<cfargument name="DSlinea" 				required="no" 	 type="numeric" default="-1"		hint="Id de la Solicitud de Compra">
   		<cfargument name="CFcuenta" 			required="no" 	 type="numeric" default="-1"		hint="Cuenta Finaciera que se afecto en la requisicion">
		<cfargument name="Usucodigo"  		required="no" 	 type="numeric" 						hint="Usuario que realiza el Movimiento">
		<cfargument name="Ucodigo"  		required="no" 	 type="string" 	default=""					hint="Unidad de medida capturada en la solicitud de pago">

        
		<!--- Variables privadas del método --->
		<!--- Variables públicas creadas en el método --->
		<!--- Defaults para parámetros. No se pusieron en el cfargument porque cuando vienen porque no hay session, siempre ejecuta la sentencia del default y se cae. --->
		<cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.dsn')>
        	<CFSET Arguments.Conexion = Session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
		<cfif (not isdefined("Arguments.EcodigoRequi"))>
			<cfset Arguments.EcodigoRequi = Session.Ecodigo>
		</cfif>
		
		<cfset LvarCostoLocalSinRedondear = Arguments.CostoLocal>
		<cfset Arguments.CostoLocal = round(Arguments.CostoLocal*100)/100>
		
		<!--- Valida que exista IdKardex --->
		<cfif not isdefined("Request.idkardex")>
			<cf_errorCode	code = "51191" msg = "Error en IN_PosteoLin. La tabla temporal IdKardex no está definida. Proceso Cancelado!">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="IDKARDEX_count">
			select count(1) IDKARDEX_count from #Request.idkardex#
		</cfquery>
		
		<!--- Inicio *** --->
			
			<!--- 1 Validaciones --->
			<!--- 1.1 Validación de integridad del Artículo --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 from Articulos where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51192" msg = "Error en IN_PosteoLin. No existe el Artículo. Proceso Cancelado!">
			</cfif>
			<!--- 1.2 Validación de integridad del Almacén --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 from Almacen where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51193" msg = "Error en IN_PosteoLin. No existe el Almacén. Proceso Cancelado!">
			</cfif>
			<!--- 1.3 Validación de integridad del Tipo de Movimiento --->
			<!--- 
					E	Entrada
					S	Salida
					M	Movimiento Interalmacén
					R	Requisición
					I	Inventario Físico
					A	Ajuste
					P	Producción
			--->
			<cfif ListFindNoCase("E,S,M,R,I,A,P", Arguments.Tipo_Mov) eq 0>
				<cf_errorCode	code = "51194" msg = "Error en IN_PosteoLin. El Tipo de Movimiento es Incorrecto. Proceso Cancelado!">
			</cfif>
			<!--- 1.4 Validación de la Cantidad del Movimiento --->
			<!--- <cfif Arguments.Cantidad EQ 0>
				<cf_errorCode	code = "51195" msg = "Error en IN_PosteoLin. La Cantidad del Movimiento es Incorrecta. Proceso Cancelado!">
			</cfif> --->
			
			<!--- 1.6 Validación de integridad del Tipo de Entrada Salida --->
			<cfif ListFindNoCase("E,S", Arguments.Tipo_ES) eq 0>
				<cf_errorCode	code = "51196" msg = "Error en IN_PosteoLin. El Tipo de Entrada Salida es Incorrecto. Proceso Cancelado!">
			</cfif>
			<!--- 1.7 Validación de Integridad del Centro Funcional, el Departamento y la Oficina --->
			<cfif Arguments.CFid GT 0>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select 1 from CFuncional where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoRequi#">
				</cfquery>
				<cfif rs.recordcount eq 0>
					<cf_errorCode	code = "51197" msg = "Error en IN_PosteoLin. No existe el Centro Funcional. Proceso Cancelado!">
				</cfif>
			<cfelse>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select 1 from Oficinas where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoRequi#">
				</cfquery>
				<cfif rs.recordcount eq 0>
					<cf_errorCode	code = "51198" msg = "Error en IN_PosteoLin. No existe la Oficina. Proceso Cancelado!">
				</cfif>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select 1 from Departamentos where Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Dcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoRequi#">
				</cfquery>
				<cfif rs.recordcount eq 0>
					<cf_errorCode	code = "51199" msg = "Error en IN_PosteoLin. No existe el Departamento. Proceso Cancelado!">
				</cfif>
			</cfif>
			<!--- 1.8 Validación del Tipo de Cambio --->
			<cfif Arguments.TipoCambio LT 1>
				<cf_errorCode	code = "51200" msg = "Error en IN_PosteoLin. El Tipo de Cambio es Incorrecto. Proceso Cancelado!">
			</cfif>
			<!--- 1.9 Validación de Integridad del Tipo de Documento --->
			<cfif Len(Trim(Arguments.TipoDoc)) GT 0>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select 1 from CCTransacciones where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoDoc#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfif rs.recordcount eq 0>
					<cf_errorCode	code = "51201" msg = "Error en IN_PosteoLin. No existe el Tipo de Transacción de CXC. Proceso Cancelado!">
				</cfif>
			<cfelse>
				<cfset Arguments.TipoDoc = "">
			</cfif>
			<!--- 1.10 Validación de integridad del Histórico de Requisiciones
						*** 
							SE VALIDA EN LA TABLA ORIGINAL Y NO EN LA HISTÓRICA PORQUE A LA HORA DE LLAMAR ESTE MÉTODO TODAVÍA NO 
							HA LLENADO LA HISTÓRICA.
						***
			--->
			<cfif Arguments.ERid GT 0>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select 1 from ERequisicion where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ERid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfif rs.recordcount eq 0>
					<cf_errorCode	code = "51202" msg = "Error en IN_PosteoLin. No existe el Histórico de Requisiciones. Proceso Cancelado!">
				</cfif>
			<cfelse>
				<cfset Arguments.ERid = 0>
			</cfif>

			<!--- 2 Definiciones --->
			<!--- 2.1 Información del Artículo --->
			<cfquery name="rsArticulo" datasource="#Arguments.Conexion#">
				select Aid as id, Acodigo as codigo, Adescripcion as descripcion, Atipocosteo,Ucodigo
				  from Articulos 
				 where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 2.2 Información del Almacén --->
			<cfquery name="rsAlmacen" datasource="#Arguments.Conexion#">
				select Aid as id, Almcodigo as codigo, Bdescripcion as descripcion from Almacen where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 2.3 Periodo de Auxiliares --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as periodo from Parametros where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51203" msg = "Error en IN_PosteoLin. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.4 Mes de Auxiliares --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as mes from Parametros where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51204" msg = "Error en IN_PosteoLin. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
			</cfif>

			<!-------------
				2.5 Costo:
			-------------->

			<cfif rsArticulo.Atipocosteo NEQ 0>
				<cf_errorCode	code = "51205" msg = "Error en IN_PosteoLin. No se ha implementado el tipo de costeo UEPS o PEPS">
			</cfif>

			<!--- 2.5.1 Validación del Costo del Movimiento:
				Cantidad < 0:		Devolución: 
					Entrada:			Con Costo 0 o + y Cantidad 0 o +
					Devolución Entrada: Con Costo 0 o - y Cantidad 0 o -
					Salida:				Sin Costo: 
					Devolución Salida:  Con Costo -
					
					Costo Local y Origen deben tener el mismo signo (+, - ó 0)
					Cantidad y costo deben tener el mismo signo (+ ó -)
			--->
			<cfif Arguments.ObtenerCosto>
				<cfif (Arguments.CostoOrigen NEQ "0" OR Arguments.CostoLocal NEQ "0")>
					<cf_errorCode	code = "51206" msg = "Error en IN_PosteoLin. No se puede enviar Costo cuando es ObtenerCosto. Proceso Cancelado!">
				<cfelseif Arguments.McodigoOrigen NEQ -1 AND Arguments.tcOrigen EQ -1>
					<cf_errorCode	code = "51207" msg = "Error en IN_PosteoLin. Se envió Moneda Origen pero no se envió su Tipo Cambio (ObtenerCosto).">
				</cfif>
				<cfset LvarCOSTOS = IN_CostoActual (
										Arguments.Ecodigo,
										Arguments.Aid,
										Arguments.Alm_Aid,
										Arguments.Cantidad,
										Arguments.FechaDoc,
										Arguments.Conexion
										, Arguments.McodigoOrigen, Arguments.tcOrigen, Arguments.tcValuacion
								)>
					<cfif Arguments.McodigoOrigen EQ -1>
						<cfset Arguments.McodigoOrigen	= LvarCOSTOS.VALUACION.Mcodigo>
						<cfset Arguments.CostoOrigen 	= LvarCOSTOS.VALUACION.Costo>
						<cfset Arguments.TipoCambio		= LvarCOSTOS.VALUACION.TC>
				    </cfif>
			<cfelse>
				<cfif Arguments.McodigoOrigen EQ -1>
					<cf_errorCode	code = "51208" msg = "Error en IN_PosteoLin. No se envió Moneda Origen">
				<cfelseif Arguments.tcOrigen NEQ -1>
					<cf_errorCode	code = "51209" msg = "Error en IN_PosteoLin. El Tipo Cambio Origen solo se puede enviar cuando es ObtenerCosto">
				<cfelseif (Arguments.CostoOrigen GT 0 AND Arguments.CostoLocal LT 0) OR (Arguments.CostoOrigen LT 0 AND Arguments.CostoLocal GT 0)>
					<cf_errorCode	code = "51210" msg = "Error en IN_PosteoLin. Se envió CostoLocal y CostoOrigen con diferente signo">
				<cfelseif (Arguments.CostoOrigen EQ 0 AND Arguments.CostoLocal NEQ 0) OR (Arguments.CostoOrigen NEQ 0 AND Arguments.CostoLocal EQ 0)>
					<cf_errorCode	code = "51211" msg = "Error en IN_PosteoLin. Se envió CostoOrigen o CostoLocal diferente que cero">
				<cfelseif (Arguments.Cantidad GT 0 AND Arguments.CostoLocal LT 0) OR (Arguments.Cantidad LT 0 AND Arguments.CostoLocal GT 0)>
					<cf_errorCode	code = "51212" msg = "Error en IN_PosteoLin. Se envió Costo y Cantidad con diferente signo">
				<cfelseif (Arguments.Cantidad EQ 0 AND Arguments.CostoOrigen EQ 0)>
					<cf_errorCode	code = "51213" msg = "Error en IN_PosteoLin. Se envió Costo y Cantidad en cero">
				</cfif>
				<cfif Arguments.CostoOrigen EQ 0>
					<cfset Arguments.tcOrigen = 0>
				<cfelse>
					<cfset Arguments.tcOrigen = LvarCostoLocalSinRedondear / Arguments.CostoOrigen>
				</cfif>

				<cfset LvarCOSTOS = IN_MonedaValuacion(Arguments.Ecodigo, Arguments.FechaDoc, Arguments.Conexion, Arguments.McodigoOrigen, Arguments.tcOrigen, Arguments.tcValuacion)>

			
				<cfset Arguments.CostoOrigen	 = round(Arguments.CostoOrigen*100)/100>
				<cfset LvarCOSTOS.LOCAL.Costo	 = round(Arguments.CostoLocal*100)/100>
				
				<cfif Arguments.McodigoOrigen EQ LvarCOSTOS.LOCAL.Mcodigo AND LvarCOSTOS.LOCAL.Costo NEQ Arguments.CostoOrigen>
					<cf_errorCode	code = "51214" msg = "Error en IN_PosteoLin. Moneda Origen es Moneda Local pero Costo Origen es diferente a Costo Local. Proceso Cancelado!">
				<cfelseif LvarCOSTOS.VALUACION.Mcodigo EQ Arguments.McodigoOrigen>
					<cfset LvarCOSTOS.VALUACION.Costo = Arguments.CostoOrigen>
				<cfelseif LvarCOSTOS.VALUACION.Mcodigo EQ LvarCOSTOS.LOCAL.Mcodigo>
					<cfset LvarCOSTOS.VALUACION.Costo = LvarCOSTOS.LOCAL.Costo>
				<cfelse>
					<cfset LvarCOSTOS.VALUACION.Costo = LvarCOSTOS.LOCAL.Costo / LvarCOSTOS.VALUACION.TC>
					<cfset LvarCOSTOS.VALUACION.Costo = round(LvarCOSTOS.VALUACION.Costo*100)/100>
				</cfif>
			</cfif>

			<!--- 2.6 Cuando la Cantidad es negativa invierte el Tipo Entrada Salida --->
			<cfif Arguments.Cantidad LT 0 OR Arguments.CostoLocal LT 0>
				<cfif Arguments.Cantidad GT 0>
					<cf_errorCode	code = "51215" msg = "Error en IN_PosteoLin. Costo y Cantidad con diferente signo">
				</cfif>
				<cfif Arguments.Tipo_ES EQ "S">
					<cfset Arguments.Tipo_ES = "E">
				<cfelse>
					<cfset Arguments.Tipo_ES = "S">
				</cfif>
			</cfif>
			<!--- 2.7 Se Asegura que el signo del costo y la cantidad esten deacuerdo con el Tipo Entrada Salida --->
			<cfif Arguments.Tipo_ES EQ "S">
				<cfset LvarCOSTOS.VALUACION.Costo	= -Abs(LvarCOSTOS.VALUACION.Costo)>
				<cfset LvarCOSTOS.LOCAL.Costo		= -Abs(LvarCOSTOS.LOCAL.Costo)>
				<cfset Arguments.CostoOrigen		= -Abs(Arguments.CostoOrigen)>
				<cfset LvarCOSTOS.Cantidad			= -Abs(Arguments.Cantidad)>
			<cfelse>
				<cfset LvarCOSTOS.VALUACION.Costo	= Abs(LvarCOSTOS.VALUACION.Costo)>
				<cfset LvarCOSTOS.LOCAL.Costo		= Abs(LvarCOSTOS.LOCAL.Costo)>
				<cfset Arguments.CostoOrigen		= Abs(Arguments.CostoOrigen)>
				<cfset LvarCOSTOS.Cantidad			= Abs(Arguments.Cantidad)>
			</cfif>
			
			
			<!--- 2.8 --->
			<cfif Arguments.CFid GT 0>
				<cfquery name="rsCFcodigo" datasource="#Arguments.Conexion#">
					select Dcodigo,Ocodigo from CFuncional where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoRequi#">
				</cfquery>
				<cfset Arguments.Dcodigo = rsCFcodigo.Dcodigo>
				<cfset Arguments.Ocodigo = rsCFcodigo.Ocodigo>
			</cfif>
			
			<!--- Debug: Antes de las operaciones --->
			<cfif Arguments.Debug>
				<cfdump var="#Arguments#" label="Argumentos antes de las operaciones">
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfdump var="#rsDebug#" label="Existencias antes de las operaciones">
			</cfif>
			
			<cfif NOT Arguments.insertarEnKardex>
				<cfreturn LvarCOSTOS>
			</cfif>
			
			<!--- 3 Operaciones --->
			<cfif Arguments.TransaccionActiva>
				<cfset Arguments_Ret = LIN_PosteoLin(	Arguments.Aid,
														Arguments.Alm_Aid,
														Arguments.Tipo_Mov,

														<!--- Arguments.Costo, --->
														LvarCOSTOS.Cantidad,
														Arguments.McodigoOrigen,
														Arguments.CostoOrigen,
														LvarCOSTOS.LOCAL.Costo,
														LvarCOSTOS.VALUACION.Costo,

														Arguments.Tipo_ES,
														Arguments.CFid,
														Arguments.Dcodigo,
														Arguments.Ocodigo,
														Arguments.TipoCambio,
														Arguments.TipoDoc,
														Arguments.Documento,
														Arguments.FechaDoc,
														Arguments.Referencia,
														Arguments.ERid,
														Arguments.insertarEnKardex,
														Arguments.verificaPositivo,
														Arguments.Conexion,
														Arguments.Ecodigo,
														Arguments.EcodigoRequi,
														Arguments.Debug,
														Arguments.FPAEid,
														Arguments.CFComplemento,
														Arguments.DSlinea, 
														Arguments.CFcuenta,
														Arguments.Usucodigo,
														Arguments.Ucodigo)>
			<cfelse>
				<cftransaction>
					<cfset Arguments_Ret = LIN_PosteoLin(	Arguments.Aid,
														Arguments.Alm_Aid,
														Arguments.Tipo_Mov,

														<!--- Arguments.Costo, --->
														LvarCOSTOS.Cantidad,
														Arguments.McodigoOrigen,
														Arguments.CostoOrigen,
														LvarCOSTOS.LOCAL.Costo,
														LvarCOSTOS.VALUACION.Costo,

														Arguments.Tipo_ES,
														Arguments.CFid,
														Arguments.Dcodigo,
														Arguments.Ocodigo,
														Arguments.TipoCambio,
														Arguments.TipoDoc,
														Arguments.Documento,
														Arguments.FechaDoc,
														Arguments.Referencia,
														Arguments.ERid,
														Arguments.insertarEnKardex,
														Arguments.verificaPositivo,
														Arguments.Conexion,
														Arguments.Ecodigo,
														Arguments.EcodigoRequi,
														Arguments.Debug,
														Arguments.FPAEid,
														Arguments.CFComplemento,
														Arguments.DSlinea,
														Arguments.CFcuenta,
														Arguments.Usucodigo,
														Arguments.Ucodigo)>
					<!--- RollBack: Deshace todos los cambios --->
					<cfif Arguments.RollBack>
						<cftransaction action="rollback"/>
					</cfif>
				</cftransaction>
			</cfif>
			
		<!--- Fin	*** --->
		<!--- Retorno de Resultados --->
		<cfreturn LvarCOSTOS>
	</cffunction>
	
	<cffunction name="LIN_PosteoLin" 		access="private" returntype="struct">
		<cfargument name="Aid" 					required="true"  type="numeric">
		<cfargument name="Alm_Aid" 				required="true"  type="numeric">
		<cfargument name="Tipo_Mov" 			required="true"  type="string">
		<cfargument name="Cantidad" 			required="true"  type="numeric">

		<cfargument name="McodigoOrigen" 		required="true"  type="numeric">
		<cfargument name="CostoOrigen" 			required="true"  type="numeric">
		<cfargument name="CostoLocal" 			required="true"  type="numeric">
		<cfargument name="CostoValuacion"		required="true"  type="numeric">

		<cfargument name="Tipo_ES" 				required="true"  type="string">
		<cfargument name="CFid" 				required="true"  type="numeric">
		<cfargument name="Dcodigo" 				required="true"  type="numeric">
		<cfargument name="Ocodigo" 				required="true"  type="numeric">
		<cfargument name="TipoCambio" 			required="true"  type="numeric">
		<cfargument name="TipoDoc" 				required="true"  type="string">
		<cfargument name="Documento" 			required="true"  type="string">
		<cfargument name="FechaDoc" 			required="true"  type="date">
		<cfargument name="Referencia" 			required="true"  type="string">
		<cfargument name="ERid" 				required="true"  type="numeric">
		<cfargument name="insertarEnKardex" 	required="true"  type="boolean">
		<cfargument name="verificaPositivo" 	required="true"  type="boolean">
		<cfargument name="Conexion" 			required="no"    type="string"  				hint="Nombre del DataSource">
		<cfargument name="Ecodigo" 				required="no"  	 type="numeric" 				hint="Codigo de la empresa">
		<cfargument name="EcodigoRequi"			required="no" 	 type="numeric" 				hint="EmpresaIntercompany" >
        <cfargument name="Debug" 				required="no"  	 type="boolean" default="false" hint="Debug">
		<cfargument name="FPAEid" 				required="no" 	 type="numeric" default="-1"    hint="Id de la Actividad empresarial">
		<cfargument name="CFComplemento" 		required="no" 	 type="string"  default="" 		hint="Complemento de la Actividad empresarial">
   		<cfargument name="DSlinea" 				required="no" 	 type="numeric" default="-1"	hint="Id de la Solicitud de Compra">
	    <cfargument name="CFcuenta" 			required="no" 	 type="numeric" default="-1"	hint="Cuenta Finaciera(Detalle de SC requisiciones, cuenta de inventario Entradas)">
		<cfargument name="Usucodigo"  		required="no" 	 type="numeric" hint="Usuario que realiza el Movimiento">
		<cfargument name="Ucodigo"  		required="no" 	 type="string"  default = "" hint="Unidad de medida capturada desde la solicitud u orden de compra">
		
        
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.dsn')>
        	<CFSET Arguments.Conexion = Session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfif Arguments.FPAEid LTE 0>
        	<CFSET Arguments.FPAEid = -1>
        </cfif>
        

        <!---►►Obtencion de la cuenta de Inventario, en caso de que no se envie una Cuenta◄◄--->
        <cfif Arguments.CFcuenta EQ -1>
            <cfquery name="rsCuenta" datasource="#Arguments.Conexion#">
                select Coalesce(d.IACinventario, -1) as IACinventario
                from Articulos a
                  inner join Existencias c
                    on  c.Aid = a.Aid
                    and c.Ecodigo = a.Ecodigo
                  left outer join IAContables d
                     on d.Ecodigo = c.Ecodigo
                    and d.IACcodigo = c.IACcodigo       
                where a.Aid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
                  and c.Alm_Aid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
            </cfquery>
            <cfif rsCuenta.RecordCount and LEN(TRIM(rsCuenta.IACinventario))>
            	<cfset rsCuenta.CFcuenta = rsCuenta.IACinventario>
            </cfif>
        </cfif>
        
		<!--- 3.0 Se Asegura de que Exista el registro de las Existencias para el Almacen / Artículo --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select 1 
            	from Existencias 
            where Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rs.recordcount EQ 0>
			<cfquery datasource="#Arguments.Conexion#">
				insert into Existencias (Aid, Alm_Aid, Ecodigo, IACcodigo, Eexistencia, Ecostou, Epreciocompra, Ecostototal, Esalidas, Eestante, Ecasilla, Eexistmin, Eexistmax)
				select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">, Ecodigo, IACcodigo, 0.00, 0.00, 0.00, 0.00, 0.00, Eestante, Ecasilla, Eexistmin, Eexistmax
				from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				and Alm_Aid = (select min(Alm_Aid) from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">)
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
		</cfif>
		<!--- 3.1 Obtener existencias y costos antes del movimiento --->
		<cfquery name="rsAntes" datasource="#Arguments.Conexion#">
			select coalesce(Ecostototal,0.00) as Ecostototal, coalesce(Eexistencia,0) as Eexistencia, coalesce(Ecostou,0.00) as Ecostou
			from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rsAntes.recordcount EQ 0>
			<cf_errorCode	code = "51216"
							msg  = "Error en IN_PosteoLin. No existen existencias para al Artículo @errorDat_1@ - @errorDat_2@ en ningun Almacén. Proceso Cancelado!"
							errorDat_1="#rsArticulo.codigo#"
							errorDat_2="#rsArticulo.descripcion#"
			>
		</cfif>
		
		<!----ABL Hace la conversión de unidad--->		
		<cfquery name="rsFactorConversion" datasource="#Arguments.Conexion#">
			select a.Aid,a.Ucodigo, cu.Ucodigo as OriConversion, cu.Ucodigoref as DestConversion, isnull(cua.CUAfactor,CUfactor) as FactorConver
			from Articulos a
			inner join Unidades u  on u.Ucodigo = a.Ucodigo
			left join ConversionUnidades cu on u.Ucodigo = cu.Ucodigoref and cu.Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ucodigo#">
			left join ConversionUnidadesArt cua on a.Aid = cua.Aid
			where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>	
		
		<cfif isdefined("Arguments.Ucodigo") and Arguments.Ucodigo NEQ ''>					
			<cfif Arguments.Ucodigo NEQ rsFactorConversion.Ucodigo>
				<cfif isdefined("rsFactorConversion.FactorConver") and rsFactorConversion.DestConversion NEQ ''>			
					<cfset CantidadConver = 0>
					<cfset CConverValuacion = 0>
					<cfset CConverOrigen = 0>
					<cfset CConverLocal = 0>	
					<cfif Arguments.Ucodigo NEQ rsFactorConversion.Ucodigo and rsFactorConversion.DestConversion EQ rsFactorConversion.Ucodigo and rsFactorConversion.OriConversion EQ Arguments.Ucodigo>
						<cfset CantidadConver = #Arguments.Cantidad# * rsFactorConversion.FactorConver>
						<cfif CantidadConver LT 0>
							<cfset CConverValuacion = ((#CantidadConver#) * (#Arguments.CostoValuacion# / #CantidadConver#)) * -1>
						<cfelse>
							<cfset CConverValuacion = (#CantidadConver#) * (#Arguments.CostoValuacion# / #CantidadConver#)>
						</cfif>
						<cfset CConverOrigen = (#CantidadConver#) * (#Arguments.CostoValuacion# / #CantidadConver#)>
						<cfset CConverLocal = (#CantidadConver#) * (#Arguments.CostoValuacion# / #CantidadConver#)>
					</cfif>
				<cfelse>
						<cf_errorCode	code = "52000"
								msg  = "Error en IN_PosteoLin. Debe capturar el factor de conversion entre las unidades de #Arguments.Ucodigo# y #rsFactorConversion.Ucodigo#">
				</cfif>					
			</cfif>					
		</cfif>
		<!--- temina cambio ABL---->
		
			
		<!--- 3.2 Obtener existencias y costos después del movimiento --->
		<cfquery name="rsDespues" datasource="#Arguments.Conexion#">
			select round(coalesce(Ecostototal+<cfif isdefined("CConverValuacion")  and CConverValuacion GT 0> <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CConverValuacion#"><cfelse><cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Arguments.CostoValuacion#"></cfif>,0.00),6) as Ecostototal, 
				round(coalesce(Eexistencia+<cfif isdefined("CantidadConver")  and CantidadConver GT 0> <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CantidadConver#"><cfelse><cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Arguments.Cantidad#"></cfif>,0),6) as Eexistencia, 
				0.00 as Ecostou
			from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rsDespues.Eexistencia NEQ 0>
			<cfquery name="rsDespuesb" datasource="#Arguments.Conexion#">
				select round(coalesce(
						(Ecostototal+<cfif isdefined("CConverValuacion")  and CConverValuacion GT 0> <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CConverValuacion#"><cfelse><cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Arguments.CostoValuacion#"></cfif>) /
						(Eexistencia+<cfif isdefined("CantidadConver") and CantidadConver GT 0> <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CantidadConver#"><cfelse><cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Arguments.Cantidad#"></cfif>)
					,0.00),6) as Ecostou
				from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfset QuerySetCell(rsDespues,"Ecostou",rsDespuesb.Ecostou)>
		</cfif>
		<cfif Arguments.verificaPositivo>
			<!--- 3.3 Verifica catidad y costo positivos --->
			<cfif rsDespues.Eexistencia LT 0>
				<cf_errorCode	code = "51217"
								msg  = "Error en IN_PosteoLin. Las existencias quedarán negativas para al Artículo @errorDat_1@ - @errorDat_2@ en el Almacén @errorDat_3@ - @errorDat_4@. Proceso Cancelado!"
								errorDat_1="#rsArticulo.codigo#"
								errorDat_2="#rsArticulo.descripcion#"
								errorDat_3="#rsAlmacen.codigo#"
								errorDat_4="#rsAlmacen.descripcion#"
				>
			</cfif>
			<cfif rsDespues.Ecostototal LT 0>
				<cf_errorCode	code = "51218"
								msg  = "Error en IN_PosteoLin. El costo de las existencias quedará negativo para al Artículo @errorDat_1@ - @errorDat_2@ en el Almacén @errorDat_3@ - @errorDat_4@. Proceso Cancelado!"
								errorDat_1="#rsArticulo.codigo#"
								errorDat_2="#rsArticulo.descripcion#"
								errorDat_3="#rsAlmacen.codigo#"
								errorDat_4="#rsAlmacen.descripcion#"
				>
			</cfif>
		</cfif>
		<cfif insertarEnKardex>
			<!--- 3.4 Inserta en el Kardex --->
			<!--- 3.4.1 Inserta en la tabla de movimientos del Kardex --->
			<cfquery name="insertKardex" datasource="#Arguments.Conexion#">
				insert into Kardex(
					Aid,
					Alm_Aid,
					Ecodigo,
					Kfecha, 
<!---SNcodigo, --->
					Ocodigo, 
					Dcodigo, 
					Ktipo, 
					Kunidades, 

					McodigoOrigen,
					KcostoOrigen,
					KcostoLocal,
					Kcosto, 

					CCTcodigo, 
					Kdocumento, 
					Kreferencia, 
					KtipoES, 
					Kperiodo, 
					Kmes, 
					Kexistant, 
					Kcostoant,
					ERid,
					CFid,
					FPAEid,
					CFComplemento, 
                    DSlinea, 
                    CFcuenta,
                    BMUsucodigo
				)
				values(
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Aid#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Alm_Aid#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.EcodigoRequi#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.FechaDoc#">,
<!---null,--->
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ocodigo#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Dcodigo#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Tipo_Mov#">,
					<cfif isdefined("CantidadConver") and CantidadConver NEQ 0>
						<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CantidadConver#">,
					<cfelse>
						<CF_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.Cantidad#">,
					</cfif>
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.McodigoOrigen#">,
					<cfif isdefined("CConverOrigen") and CConverOrigen NEQ 0>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#CConverOrigen#">,
					<cfelse>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#Arguments.CostoOrigen#">,
					</cfif>
					<cfif isdefined("CConverLocal") and CConverLocal NEQ 0>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#CConverLocal#">,
					<cfelse>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#Arguments.CostoLocal#">,
					</cfif>
					<cfif isdefined("CConverValuacion") and CConverValuacion GT 0>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#CConverValuacion#">,
					<cfelse>
						<CF_jdbcquery_param cfsqltype="cf_sql_money"	value="#Arguments.CostoValuacion#">,
					</cfif>
					<cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.TipoDoc#" null="#len(Arguments.TipoDoc) EQ 0#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.Documento#">, <!--- El campo en la BD no permite nulos entonces se quita: 'null="#len(Arguments.Documento) EQ 0#"' del queryparam --->
					<CF_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.Referencia#" null="#len(Arguments.Referencia) EQ 0#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Tipo_ES#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#rsPeriodo.periodo#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#rsMes.mes#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_money" 	value="#rsAntes.Eexistencia#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_money" 	value="#rsAntes.Ecostototal#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.ERid#" 		  voidnull null="#Arguments.ERid EQ 0#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#" 		  voidnull null="#Arguments.CFid EQ 0#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#" 		  voidnull null="#Arguments.FPAEid EQ -1#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CFComplemento#" voidnull null="#len(trim(Arguments.CFComplemento)) EQ 0#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.DSlinea#"       voidnull null="#Arguments.DSlinea EQ -1#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFcuenta#"      voidnull null="#Arguments.CFcuenta EQ -1#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#"><!--- Usuario --->
					)
				<cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 name="insertKardex" datasource="#Arguments.Conexion#" verificar_transaccion="false">
			<!--- 3.4.2 Inserta en la tabla temporal IdKardex --->
			
<!---			<cf_dumpToFile select="select * from Kardex where Kid = #insertKardex.identity#">
			
			<cfthrow message="no salio">
--->			<cfquery datasource="#Arguments.Conexion#">
				insert into #Request.IdKardex# (Kid) values (#insertKardex.identity#)
			</cfquery>
			
			<!---<cf_dumptoFile select = "select * from Kardex where Kid = #insertKardex.identity#">--->

			<!--- 3.5 Actualiza existencias y costos en Almacén --->
			<cfquery datasource="#Arguments.Conexion#">
				update Existencias 
				set Ecostototal = Ecostototal + <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CostoValuacion#">, 
					Eexistencia = Eexistencia + <cfif isdefined("CantidadConver")> <cfqueryparam cfsqltype="cf_sql_money" value="#CantidadConver#"><cfelse><cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Cantidad#"></cfif>, 
					Ecostou = <cfqueryparam cfsqltype="cf_sql_money" value="#rsDespues.Ecostou#">
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<!--- Debug: Después de las operaciones --->
			<cfif Arguments.Debug>
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from Kardex where Kid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertKardex.identity#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfdump var="#rsDebug#" label="Kardex">
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from #Request.IdKardex#
				</cfquery>
				<cfdump var="#rsDebug#" label="IdKardex">
	
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from Existencias where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfdump var="#rsDebug#" label="Existencias después de las operaciones">
			</cfif>			
		</cfif>
		
		<cfreturn Arguments>
	</cffunction>
</cfcomponent>