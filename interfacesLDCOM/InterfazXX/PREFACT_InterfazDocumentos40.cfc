<!---
	Interfaz 20: Interfaz de Intercambio de Información de Documentos Prefactura
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: Gabriel E. Sanchez Huerta - Application Hosting
	Creacion (03/04/2009)
--->

<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarEcodigoSDC= Session.EcodigoSDC>
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarCuentaManual = true>
	<cfquery name="rsGvarCuentaManual" datasource="#session.DSN#">
		select Pvalor from Parametros where Pcodigo = 2 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsGvarCuentaManual.recordcount and rsGvarCuentaManual.Pvalor EQ "N">
		<cfset GvarCuentaManual = false>
	</cfif>


	<!--- Process: Procesamiento de la información de la Interfaz 20 debe ser llamada de la siguiente manera:
		<cfinvoke component="interfacesSoin.Componentes.PREFACT_InterfazDocumentos" method="process" returnvariable="MSG" query="#readInterfaz19#"/>
		Argumentos:
			MSG = Mensaje de Resultados de la operación.
			Query = Consulta de la Interfaz 20 (Encabezado y Detalles).
	 --->
  <cffunction name="process" access="public" returntype="string" output="yes">
    <!--- Argumentos --->
    <cfargument name="query" required="yes" type="query">
    <cfargument name="ModuloOrigen" required="no" type="any" default="Interfaz 22">
    <cfset GvarModO = Arguments.ModuloOrigen>
		<!--- Procesamiento de Encabezado de la Interfaz 20  --->
<!--- Hace todas las validaciones en el query del importador  --->
	<cfif ModuloOrigen eq 'Importador de Prefacturas'>
  			<cfloop query="query">
			    <cfset Valid_SNcodigo     = getValidSNcodigo(query.NumeroSocio, query.CodigoDireccionFacturacion, '')>
			    <cfset Valid_CCTcodigo    = getValidCCTcodigo(query.CodigoTransaccion)>
			    <cfset Valid_EDdocumento  = getValidCCEDdocumento(query.Documento,Valid_CCTcodigo.PFTcodigo)>
			    <cfset Valid_Mcodigo    = getValidMcodigo(query.CodigoMoneda)>
			    <cfset Valid_Ocodigo    = getValidOcodigo(query.CodigoOficina)>
			    <cfset Valid_FechaDocumento   = getValidFechaDocumento(query.FechaDocumento)>
			    <cfset Valid_FechaVencimiento   = getValidFechaVencimiento(query.FechaDocumento, query.FechaVencimiento, query.DiasVigencia)>
			    <cfset Valid_TipoItem     = getValidTipoItem(query.TipoItem)>
			    <cfif Valid_TipoItem EQ "A" >
			        <cfset Valid_Aid_struct     = getValidAid(query.CodigoItem)>
			    </cfif>
			    <cfset Valid_AlmAid   = getValidAlmAid(query.CodigoAlmacen)>
			    <cfset Valid_Cid_struct      = getValidCid(query.CodigoItem)>
			    <cfset Valid_CFid = getValidCFid(query.CentroFuncional, Valid_Ocodigo)>
			    <cfset Valid_ImporteTotal = 0>
			    <cfif len(trim(query.PrecioTotal)) gt 0>
			        <cfset Valid_ImporteTotal = query.PrecioTotal >
			    <cfelseif (Valid_CantidadTotal * Valid_PrecioUnitario) GT 0.00>
			        <cfset Valid_ImporteTotal = (Valid_CantidadTotal * Valid_PrecioUnitario) - Valid_ImporteDescuento >
			    </cfif>
			    <cfif query.CodigoImpuesto EQ "">
			        <cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,0,Valid_ImporteTotal)>
			    <cfelse>
			        <cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,-1,Valid_ImporteTotal)>
			    </cfif>
				<cfset Valid_Exportacion = getValidExportacion(query.Exportacion)>

			</cfloop>
		</cfif>




		<cfoutput query="query" group="ID">
			<!--- Variables Validadas de Prefacturacion --->

<!-------------------------------------------------------------------------------------------------------    --->

			<cfset Valid_Modulo 		= "CC">
			<cfset Valid_SNcodigo 		= getValidSNcodigo(query.NumeroSocio, query.CodigoDireccionFacturacion, '')>
            <cfset Valid_CCTcodigo 		= getValidCCTcodigo(query.CodigoTransaccion)>
			<cfset Valid_EDdocumento 	= getValidCCEDdocumento(query.Documento,Valid_CCTcodigo.PFTcodigo)>
 			<cfset Valid_Mcodigo 		= getValidMcodigo(query.CodigoMoneda)>
            <cfset Valid_Ocodigo 		= getValidOcodigo(query.CodigoOficina)>
			<cfset Valid_FechaDocumento  	= getValidFechaDocumento(query.FechaDocumento)>
			<cfset Valid_FechaVencimiento 	= getValidFechaVencimiento(query.FechaDocumento, query.FechaVencimiento, query.DiasVigencia)>
			<cfset Valid_Exportacion 		= getValidExportacion(query.Exportacion)>
			<cfif len(query.TipoCambio) eq 0>
        	<cfset Valid_TipoCambio 	= getValidTipoCambio(Valid_Mcodigo,Valid_FechaTipoCambio,'CXC')>
      		<cfelse>
        		<cfset Valid_TipoCambio  	= query.TipoCambio>
      		</cfif>

      		<cfif #Valid_SNcodigo.SNcodigo# EQ 9999>
        		<cfset estatusPF = 'R'>
      		<cfelse>
        		<cfset estatusPF = 'P'>
      		</cfif>

			<!--- Inicia Transacción --->
			<cftransaction>

						<cfset Total = 0.00>
                        <cfset Descu = 0.00>
                        <cfset Impue = 0.00>
						<cfset Valid_CCTcodigo 		= getValidCCTcodigo(query.CodigoTransaccion)>

			<cftry>
						<!--- Inserta Documento en tablas de Prefacturacion --->
						<cfquery name="rsInsert" datasource="#GvarConexion#">
							insert into FAPrefacturaE(
	                                Ecodigo,
                                    PFDocumento,
                                    SNcodigo,
                                    id_direccion,
                                    Mcodigo,
                                    Ocodigo,
                                    FAX04CVD,
                                    FechaCot,
                                    FechaVen,
                                    PFTcodigo,
                                    TipoPago, Estatus, DdocumentoREF, CCTcodigoREF, TipoDocumentoREF,
                                    Descuento,
                                    Impuesto,
                                    Total,
                                    Observaciones,
                                    TipoCambio,
                                    BMUsucodigo,
                                    fechaalta,
                                    Fecha_doc,
                                    vencimiento,
                                    NumOrdenCompra,
                                    NumOrdenServicio,
									IdExportacion)

                                    values (<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
                                    		<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">,
                                    		<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_SNcodigo.SNcodigo#">,
                                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.id_direccion_fact#" null="#Valid_SNcodigo.id_direccion_fact eq 0#">
                                            ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">,
                                    		' ',
											<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">,
											<cfqueryparam cfsqltype="cf_sql_date"    value="#Valid_FechaVencimiento#">,
                                            <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.PFTcodigo#">,
                                            0, '#estatusPF#', null, null, 1,
											<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                    		<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Observaciones#" null="#len(query.Observaciones) eq 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_float" value="#Valid_TipoCambio#">,
                                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
											<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">,
                                            null,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#query.DiasVigencia#" null="#len(query.DiasVigencia) eq 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_char" value="#query.NumeroOrdenCompra#" null="#len(query.NumeroOrdenCompra) eq 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_char" value="#query.Ordendeservicio#" null="#len(query.Ordendeservicio) eq 0#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#Valid_Exportacion#">
											)

							<cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion="false">
						</cfquery>
				<cfcatch type="any">
					<cfset error = #cfcatch.message# & " - " & #cfcatch.detail#>
					<cfthrow message = "#error# ">
				</cfcatch>
			</cftry>
			<cf_dbidentity2 datasource="#GvarConexion#" verificar_transaccion="false" name="rsInsert">

<!---------------------------- Detalle ---------------------------------------------------------------------------------------------------------------------->
				<!--- Procesamiento de Detalles de la Interfaz 20 --->
				<!--- NOTA: A PARTIR DE ESTE PUNTO ITERA POR TODOS LOS DETALLES DEL DOCUMENTO --->
				     <cfset NumLineaDet = 0>

				<cfoutput>
					<!--- Variables Validadas de los Detalles de Prefacturacion --->
					<cfset Valid_TipoItem 		= getValidTipoItem(query.TipoItem)>
					<cfset Valid_Descripcion 	= #query.Descripcion#>
          <cfset Valid_Descripcion_Alt  = #query.Descripcion_Alt#>

<!------------------------------------------------ Tipo Artículo   ---------------------------------------------------------------------------------->

					<cfif Valid_TipoItem EQ "A" >
						  <cfset Valid_Aid_struct		 	= getValidAid(query.CodigoItem)>
                          <cfset Valid_Cid_struct.Cid 	 	= "">
                          <cfset Valid_Cid_struct.Ccodigo	= "">
                          <cfif len(Valid_Descripcion) eq 0>
								<cfset Valid_Descripcion = Valid_Aid_struct.Adescripcion>
                          </cfif>
                          <cfset Valid_AlmAid 	= getValidAlmAid(query.CodigoAlmacen)>


                    <!--- Tipo Concepto   --->
					<cfelseif Valid_TipoItem EQ "S" >
						  <cfset Valid_Aid_struct.Aid 	 = "">
                          <cfset Valid_Cid_struct	     = getValidCid(query.CodigoItem)>

                          <cfif len(Valid_Descripcion) eq 0>
								<cfset Valid_Descripcion = Valid_Cid_struct.Cdescripcion>
                          </cfif>

                          <cfset Valid_AlmAid  		= "">
                    </cfif>

<!--------------------------------------------------- Termina Tipo Articulo ----------------------------------------------------------------------------------------->

					<cfset Valid_CFid = getValidCFid(query.CentroFuncional, Valid_Ocodigo)>

					<!--- Manejo de Montos Impuestos Descuentos --->
					<cfset Valid_ImporteDescuento = 0 >
					<cfif len(trim(query.ImporteDescuento)) gt 0 and query.ImporteDescuento gt 0>
						  <cfset Valid_ImporteDescuento = query.ImporteDescuento >
					</cfif>

					<cfset Valid_CantidadTotal = 0 >
					<cfif len(trim(query.CantidadTotal)) gt 0 and query.CantidadTotal gt 0>
						  <cfset Valid_CantidadTotal = query.CantidadTotal >
					</cfif>

					<cfset Valid_PrecioUnitario = 0 >
					<cfif len(trim(query.PrecioUnitario)) gt 0>
						  <cfset Valid_PrecioUnitario = query.PrecioUnitario >
					</cfif>

					<cfset Valid_ImporteTotal = 0>
					<cfset Valid_ImporteTotal = (Valid_CantidadTotal * Valid_PrecioUnitario) - Valid_ImporteDescuento >

					<!--- Calcula impuesto --->
                    <cfset Valid_ImporteImpuesto = 0>

					<cfif query.CodigoImpuesto EQ "">
                        <cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,0,Valid_ImporteTotal)>
                    <cfelse>
                        <cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,-1,Valid_ImporteTotal)>
                    </cfif>
                    <cfif len(trim(Valid_Icodigo))>
                        <cfquery name="queryImpuesto" datasource="#GvarConexion#">
                            select coalesce(Iporcentaje,0) as Iporcentaje
                            from Impuestos
                            where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Valid_Icodigo)#">
                              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
                        </cfquery>
                        <cfset Valid_ImporteImpuesto =  (Valid_ImporteTotal*queryImpuesto.Iporcentaje)/100 >
                    </cfif>

<!---------------------------------------------------------------------------------------------------->

					<cfif Valid_ImporteTotal EQ 0>
                          <cfset Valid_ImporteDescuento = 0>
					</cfif>
					<cfset Valid_ObjImpuesto = getValidObjImpuesto(query.ObjImpuesto,query.Documento,query.ID,query.CodigoImpuesto)>

					<!--- Extraccion de Cuenta Contable --->
					<cfif len(trim(query.CuentaFinancieraDet))>
						  <cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>

                    <cfelseif GvarCuentaManual>
						  <cfif Valid_TipoItem EQ "A">
								<cfif Valid_CCTcodigo.CCTafectacostoventas EQ 1>
                                <cfthrow message="CCTafectacostoventas no aplica en Prefacturacion">
                          </cfif>

                          <cfset Valid_DCcuenta = obtieneCuentaArticulo_CformatoIngresos( Valid_Aid_struct.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo) >

                          <cfelseif Valid_TipoItem EQ "S">
								<cfset Valid_DCcuenta = obtieneCuentaConceptoServicio_Gasto_Ingreso( Valid_Cid_struct.Cid, Valid_Cid_struct.Ccodigo, Valid_SNcodigo.SNcodigo,
                                                          Valid_Modulo)>
                          </cfif>
                    <cfelse>
                          <cfinvoke returnvariable="Valid_DCcuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                          Oorigen = "CCFC"
                          Ecodigo = "#GvarEcodigo#"
                          Conexion = "#GvarConexion#"
                          SNegocios = "#Valid_SNcodigo.SNcodigo#"
                          Oficinas = "#Valid_Ocodigo#"
                          Monedas =  "#Valid_Mcodigo#"
                          Almacen = "#Valid_AlmAid#"
                          Articulos = "#Valid_Aid_struct.Aid#"
                          Conceptos = "#Valid_Cid_struct.Cid#"
                          CConceptos = "#Valid_Cid_struct.Cid#"
                          Clasificaciones = ""
                          CCTransacciones = "#Valid_CCTcodigo.CCTcodigo#"
                          CFuncional = "#Valid_CFid#"/>
                    </cfif>

                    <cfset NumLineaDet = NumLineaDet + 1>

                     <!--- Insertar Detalle de Documento de Prefacturacion --->
                    <cfquery datasource="#GvarConexion#">
                          insert FAPreFacturaD (
                                IDPrefactura,
                                Linea,
                                Ecodigo,
                                Cantidad,
                                TipoLinea,
                                Aid,
                                Alm_Aid,
                                Icodigo,
                                Cid,
                                CFid,
                                Descripcion,
                                Descripcion_Alt,
                                PrecioUnitario,
                                DescuentoLinea,
                                TotalLinea,
                                BMUsucodigo,
                                FechaAlta,
                                CCuenta,
								IdImpuesto)
                          values (
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#NumLineaDet#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
                                <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_CantidadTotal#">,
                                <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_TipoItem#">,

								<cfif Valid_TipoItem EQ "A" >
                                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid_struct.Aid#">,
                                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">,
			   					<cfelseif Valid_TipoItem EQ "S">
                                      null,
                                      null,
                                </cfif>

                                <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Icodigo#">,

                                <cfif Valid_TipoItem EQ "A" >
                                      null,
			   					<cfelseif Valid_TipoItem EQ "S">
                                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid_struct.Cid#">,
                                </cfif>

								<cfif Valid_CFid eq 0>
                                      null,
                                <cfelse>
                                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_CFid#">,
                                </cfif>

                                <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">,
                                <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion_Alt#">,
                                <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PrecioUnitario#">,
                                <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteDescuento#">,
                                <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
                                getdate(),
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Valid_ObjImpuesto#">
                          )
                    </cfquery>

     			 	<!---  suma Totales por Cabecera del Registro --------------->
                      <cfset Total = Total + #Valid_ImporteTotal#>
                      <cfset Descu = Descu + #Valid_ImporteDescuento#>
                      <cfset Impue = Impue + #Valid_ImporteImpuesto#>

				</cfoutput>
                	<!--- Actualiza Totales en Cabecera de la Prefactura -------->
                      <cfquery datasource="#GvarConexion#">
                      update FAPrefacturaE
                      		set Descuento = <cfqueryparam cfsqltype="cf_sql_money" value="#Descu#">,
                                Impuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Impue#">,
                                Total = <cfqueryparam cfsqltype="cf_sql_money" value="#Total#"> + <cfqueryparam cfsqltype="cf_sql_money" value="#Impue#">
                      where IDpreFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
                     			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
                      </cfquery>

<!------------------------------------------------------------------------------------------------------------------------------------------------------------>

        </cftransaction>
		</cfoutput>
		<cfreturn "OK">
	</cffunction>


<!------------------------------------------------------------------------------------------------------------------------------------------------------------>
<!---   codigo de prueba ----------------------------        Comienzan las Funciones de Validacion      ------------------------------------------------------>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------>

	<!---
		Metodo:
			getValidSNcodigo
		Resultado:
			Devuelve el id asociado al codigo de socio de negocios dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->

	<cffunction access="private" name="getValidSNcodigo" output="no" returntype="query">
		<cfargument name="NumeroSocio" required="yes" type="string">
		<cfargument name="CodigoDireccionEnvio" required="yes" type="string">
		<cfargument name="CodigoDireccionFact" required="yes" type="string">
		<cfset var Lvar_SNid = 0>
		<cfset var Lvar_SNcodigo = 0>
		<cfset var Lvar_id_direccion_envio = 0>
		<cfset var Lvar_id_direccion_fact = 0>
		<!--- 	Consulta Dirección de Envío
				Cuendo Viene la Dirección de Envío, se toma el Socio de la Dirección de Envío como el Socio de Negocios,
				omitiendo el valor del Argumento NumeroSocio.
		--->
		<cfif len(trim(Arguments.CodigoDireccionEnvio))>
			<!--- Busca la Direccion por SNcodigoext  --->
			<cfquery name="query1" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionEnvio#">
				  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNDenvio    = 1
			</cfquery>
			<cfif query1.recordcount eq 0>
				<cfquery name="query1" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where SNDcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionEnvio#">
				      and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					and SNDenvio      = 1
				</cfquery>
			</cfif>
			<cfif query1.recordcount gt 0>
				<cfset Lvar_SNid               = query1.SNid>
				<cfset Lvar_SNcodigo           = query1.SNcodigo>
				<cfset Lvar_id_direccion_envio = query1.id_direccion>
			</cfif>
		</cfif>
		<!--- 	Consulta Dirección de Facturación
				Cuendo Viene la Dirección de Facturación, se toma el Socio de la Dirección de Facturación como el Socio de Negocios,
				omitiendo el valor del Argumento NumeroSocio, SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío.
		--->
		<cfif len(trim(Arguments.CodigoDireccionFact))>
			<!--- Busca la Direccion por SNcodigoext  --->
			<cfquery name="query2" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where SNcodigoext    = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionFact#">
				  and Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  <cfif Lvar_SNid NEQ 0>
					and SNid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNcodigo#">
				  </cfif>
				  and SNDfacturacion = 1
			</cfquery>
			<cfif query2.recordcount eq 0>
				<cfquery name="query2" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where SNDcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionFact#">
				      and Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					  <cfif Lvar_SNid NEQ 0>
					  	and SNid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNcodigo#">
					  </cfif>
					  and SNDfacturacion = 1
				</cfquery>
			</cfif>
			<cfif query2.recordcount gt 0>
				<cfif Lvar_SNid eq 0>
					<cfset Lvar_SNid     = query2.SNid>
					<cfset Lvar_SNcodigo = query2.SNcodigo>
				</cfif>
				<cfset Lvar_id_direccion_fact = query2.id_direccion>
			</cfif>
		</cfif>
		<!--- 	Consulta Socio de Negocios
				SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío, Ni por el de Facturación.
		--->
		<cfif Lvar_SNid eq 0 and len(trim(NumeroSocio)) gt 0>
			<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
				select SNid,SNcodigo,id_direccion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
			</cfquery>
			<cfif query3.recordcount eq 0>
				<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
					select SNid,SNcodigo,id_direccion
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
				</cfquery>
			</cfif>
      <cfif query3.recordcount eq 0>
        <cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
          select SNid,SNcodigo,id_direccion
          from SNegocios
          where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
            and SNCodigo = 9999
        </cfquery>
      </cfif>
			<cfif query3.recordcount gt 0>
				<cfset Lvar_SNid = query3.SNid>
				<cfset Lvar_SNcodigo = query3.SNcodigo>
				<!--- Valida que las direcciones existan en SNDirecciones --->
				<cfquery name="query4" datasource="#GvarConexion#">
					select id_direccion
					from SNDirecciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query3.id_direccion#">
					and SNDenvio = 1
				</cfquery>
				<cfquery name="query5" datasource="#GvarConexion#">
					select id_direccion
					from SNDirecciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query3.id_direccion#">
					and SNDfacturacion = 1
				</cfquery>
				<cfif query4.recordcount gt 0>
					<cfset Lvar_id_direccion_envio = query4.id_direccion>
				</cfif>
				<cfif query5.recordcount gt 0>
					<cfset Lvar_id_direccion_fact = query5.id_direccion>
				</cfif>
			</cfif>
		</cfif>
		<!--- Valida el Proceso --->
		<cfif Lvar_SNid lte 0 or len(trim(Lvar_SNcodigo)) lte 0>
			<cfthrow message="Error en #GvarModO#. NumeroSocio es inválido, La Dirección de Envío, Dirección de Facturación y El Numero de Socio no corresponden con ningún Socio de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>

		<cfquery name="rsverificaDireccion1" datasource="#GvarConexion#">
				select SNcodigo, SNid, id_direccion as id_direccion_envio
				from SNDirecciones
				where  Ecodigo       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and  SNcodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_SNcodigo#">
				  and  SNid          = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
				  and  id_direccion  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_id_direccion_envio#">
				  and  SNDenvio = 1
		</cfquery>

		<cfquery name="rsverificaDireccion2" datasource="#GvarConexion#">
				select SNcodigo, SNid, id_direccion as id_direccion_fact
				from SNDirecciones
				where  Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and  SNcodigo       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_SNcodigo#">
				  and  SNid           = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
				  and  id_direccion   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_id_direccion_fact#">
				  and  SNDfacturacion = 1
		</cfquery>

		<cfif not isdefined("rsverificaDireccion1") or not isdefined("rsverificaDireccion2") or rsverificaDireccion1.recordcount NEQ 1 or rsverificaDireccion2.recordcount NEQ 1>
			<cfset lvarMensajevalidacion = "Error en la Interfaz 10: ">
			<!--- Error en la obtención de los datos --->
			<cfif not isdefined("rsverificaDireccion1") or rsverificaDireccion1.recordcount NEQ 1>
				<cfset LvarMensajevalidacion = LvarMensajeValidacion & " La direccion: #Lvar_id_direccion_envio# no es de envio al socio: #Lvar_SNcodigo#, SNid: #Lvar_SNid#">
			</cfif>
			<cfif not isdefined("rsverificaDireccion2") or rsverificaDireccion2.recordcount NEQ 1>
				<cfset LvarMensajevalidacion = LvarMensajeValidacion & " La direccion: #Lvar_id_direccion_fact# no es de facturacion al socio: #Lvar_SNcodigo#, SNid: #Lvar_SNid#">
			</cfif>
			<cfset LvarMensajevalidacion & " de la Empresa #GvarEnombre#. Proceso Cancelado">
			<cfthrow message="#LvarMensajevalidacion#">
		</cfif>

		<cfquery name="Lvar_Query" datasource="#GvarConexion#">
			select #Lvar_SNid# as SNid,
				#Lvar_SNcodigo# as SNcodigo,
				#Lvar_id_direccion_envio# as id_direccion_envio,
				#Lvar_id_direccion_fact# as id_direccion_fact
			from dual
		</cfquery>
		<cfreturn Lvar_Query>
	</cffunction>

	<!---
		Metodo:
			getValidCCEDdocumento
		Resultado:
			Devuelve documento dado por la interfaz validado.
			Si se encuentra un registro para el documento aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCEDdocumento" output="no" returntype="string">
		<cfargument name="EDdocumento" required="yes" type="string">
		<cfargument name="CCTcodigo" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select 1
			from FaPrefacturaE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(ltrim(CCTcodigoREF)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			  and rtrim(ltrim(DdocumentoREF)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
		</cfquery>
    <cfif query.recordcount EQ 0>
    <cfquery name="query" datasource="#GvarConexion#">
      select 1
      from FaPrefacturaE
      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
        and rtrim(ltrim(PFTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
        and rtrim(ltrim(PFDocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
    </cfquery>
    </cfif>
		<cfif query.recordcount GT 0>
			<cfthrow message="Error en #GvarModO#. Documento #Arguments.EDdocumento# es inválido, El Documento ya existe en la Empresa #GvarEnombre# en el Módulo de Prefacturacion. Proceso
                             Cancelado!.">
		</cfif>
		<cfreturn Trim(Arguments.EDdocumento)>
	</cffunction>

	<!---
		Metodo:
			getValidCCTcodigo
		Resultado:
			Devuelve el id asociado al codigo de transaccion cc dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCTcodigo" output="no" returntype="query">
		<cfargument name="CCTvalor" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select PFTcodigo,  PFTtipo, case PFTtipo when 'C' then 'D' else 'C' end as PFTtipoinverso
			from FAPFTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(PFTcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTvalor)#">
		</cfquery>
		<cfif not query.recordcount>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select PFTcodigo, PFTtipo, case PFTtipo when 'C' then 'D' else 'C' end as PFTtipoinverso
				from FAPFTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and rtrim(PFTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTvalor)#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en #GvarModO#. CodigoTransaccion es inválido, El Código de Transacción no corresponde con ninguna Transacción de la Empresa #GvarEnombre#
            				 para el Módulo de Prefacturacion. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>


	<!---
		Metodo:
			getValidMcodigo
		Resultado:
			Devuelve el id asociado al codigo Miso de la moneda dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="no" returntype="numeric">
		<cfargument name="miso" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en #GvarModO#. CodigoMoneda es inválido, El Código de la Moneda no corresponde con ninguna moneda en la Empresa #GvarEnombre#. Proceso
            		 		Cancelado!.">
		</cfif>
		<cfreturn query.Mcodigo>
	</cffunction>

	<!---
		Metodo:
			getValidOCodigo
		Resultado:
			Devuelve el id asociado al codigo de Oficina dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidOCodigo" output="no" returntype="numeric">
		<cfargument name="Oficodigo" required="yes" type="string">
		<cfif len(Arguments.Oficodigo)>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(Ocodigo) as Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oficodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(Ocodigo) as Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0 or len(trim(query.Ocodigo)) eq 0>
			<cfthrow message="Error en #GvarModO#. CodigoOficina es inválido, El Código de Oficina #Arguments.Oficodigo# no corresponde con ninguna Oficina de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Ocodigo>
	</cffunction>


	<!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="no" returntype="numeric">
	  <cfargument name="Mcodigo" required="yes" type="numeric">
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
	  <cfargument name="origen" required="no" type="string" default="CXC">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#GvarConexion#">
		   select
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)

 	 </cfquery>
 	 <cfif isdefined('rsTC') and rsTC.recordCount GT 0>
		<cfif Arguments.origen eq 'CXC'>
			<cfset retTC = rsTC.TCcompra>
	 	<cfelseif Arguments.origen eq 'CXP'>
 		 	<cfset retTC = rsTC.TCventa>
	 	</cfif>
	 </cfif>
 	 <cfreturn retTC>
  </cffunction>


  	<!---
		Metodo:
			getValidFechaDocumento
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFechaDocumento" output="no" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en #GvarModO#. FechaDocumeno es inválido, La Fecha del Documento no es válida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn Arguments.Fecha>
	</cffunction>


	<!---
		Metodo:
			getValidFechaVencimiento
		Resultado:
			Devuelve una Fecha de Vencimiento Valida
	--->
	<cffunction access="private" name="getValidFechaVencimiento" output="no" returntype="date">
		<cfargument name="FechaDocumento" required="yes" type="date">
		<cfargument name="FechaVencimiento" required="yes" type="string">
		<cfargument name="DiasVencimiento" required="yes" type="numeric">
		<cfset var LvarFechaVencimiento = Arguments.FechaDocumento>
		<cfif Arguments.DiasVencimiento gt 0>
			<cfset LvarFechaVencimiento = DateAdd('d',Arguments.DiasVencimiento,Arguments.FechaDocumento)>
		<cfelseif Arguments.FechaVencimiento NEQ "">
			<cftry>
				<cfset LvarFechaVencimiento = ParseDateTime(Arguments.FechaVencimiento)>
			<cfcatch type="any">
				<cfthrow message="Error en #GvarModO#. FechaVencimiento es inválida '#Arguments.FechaVencimiento#'. Proceso Cancelado!.">
			</cfcatch>
			</cftry>
		</cfif>
		<cfif LvarFechaVencimiento lt Arguments.FechaDocumento>
			<cfthrow message="Error en #GvarModO#. FechaVencimiento es inválido, La Fecha del Vencimiento debe ser mayor o igual que la Fecha de Documento. Proceso Cancelado!.">
		</cfif>
		<cfreturn LvarFechaVencimiento>
	</cffunction>


	<!---
		Metodo:
			getValid_TipoItem
		Resultado:
			Devuelve el Tipo de Item Válidado, A=Articulo, S=Servicio , O = Transito con orden comercial.
	--->
	<cffunction name="getValidTipoItem" access="private" returntype="string" output="no">
		<cfargument name="TipoItem" required="true" type="string">
		<cfif Arguments.TipoItem neq "A" and Arguments.TipoItem neq "S" and Arguments.TipoItem neq "O">
			<cfthrow message="Error en #GvarModO#. TipoItem es Inválido, El Tipo de ?tem debe ser A=Articulo, S=Servicio,  O= Transito con orden comercial. Proceso Cancelado!.">
		</cfif>
		<cfreturn Trim(Arguments.TipoItem)>
	</cffunction>


	<!---
		Metodo:
			getValidAid
		Resultado:
			Devuelve el id asociado al codigo de articulo dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAid" output="no" returntype="query">
		<cfargument name="CodigoItem" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Aid, Adescripcion
			from Articulos
			where Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoItem)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select Aid, Adescripcion
				from Articulos
				where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoItem)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en #GvarModO#. CodigoItem #Arguments.CodigoItem# es inválido, El Código de Item no corresponde con ningún Artículo válido en la Empresa #GvarEnombre#. Proceso Cancelado!">
		</cfif>
		<cfreturn query>
	</cffunction>


	<!---
		Metodo:
			getValidAlmAid
		Resultado:
			Devuelve el id asociado al codigo de almacen dado por la interfaz.
			Si viene el Almacen lo valida y si no viene devuelve el primer almacen de la Tabla.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAlmAid" output="no" returntype="numeric">
		<cfargument name="CodigoAlmacen" required="yes" type="string">
		<cfif len(trim(Arguments.CodigoAlmacen))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Aid
				from Almacen
				where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoAlmacen)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select Aid
				from Almacen
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0>
			<cfthrow message="Error en #GvarModO#. CodigoAlmacen (#Arguments.CodigoAlmacen#) es inválido, El Código de Almacén no corresponde con ningún Almacén de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Aid>
	</cffunction>


	<!---
		Metodo:
			getValidCid
		Resultado:
			Devuelve el Id coresspondiente con el codigo de concepto dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCid" output="no" returntype="query">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Cid, Ccodigo, Cdescripcion
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			and upper(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
		</cfquery>
		<cfif query.recordcount EQ 0>
			<cfquery name="query" datasource="#GvarConexion#">
			select Cid, Ccodigo, Cdescripcion
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			and upper(rtrim(CcodigoAlterno)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
			</cfquery>
			<cfif query.recordcount EQ 0>
				<cfthrow message="Error en #GvarModO#. CodigoItem #Arguments.Ccodigo# es inválido, El Código de Item no corresponde con ningún Concepto de Servicio válido en la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
		</cfif>
		<cfreturn query>
	</cffunction>


	<!---
		Metodo:
			getValidCFid
		Resultado:
			Devuelve el Id coresspondiente con el código de Centro Funcional dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCFid" output="no" returntype="numeric">
		<cfargument name="CFcodigo" required="yes" type="string">
		<cfargument name="Ocodigo" required="yes" type="numeric">

		<cfif len(Arguments.CFcodigo) NEQ 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select CFid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				and upper(rtrim(CFcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CFcodigo))#">
			</cfquery>
			<cfif query.recordcount EQ 0 or len(trim(query.CFid)) eq 0>
				<cfthrow message="Error en Interfaz 10. CentroFuncional (#Arguments.CFcodigo#) es inválido, El Código de Centro Funcional no corresponde con ningún Centro Funcional de la Empresa #GvarEnombre#. Proceso Cancelado!.">
				<cfabort>
			</cfif>
			<cfreturn query.CFid>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(CFid) as CFid
				from CFuncional
				where Ecodigo = #GvarEcodigo#
				  and Ocodigo = #Arguments.Ocodigo#
			</cfquery>
			<cfif query.recordcount EQ 0 or len(trim(query.CFid)) eq 0>
				<cfthrow message="Error en #GvarModO#. No Existe ningún Centro Funcional definido en la Empresa #GvarEnombre#. Proceso Cancelado!.">
				<cfabort>
			</cfif>
			<cfreturn query.CFid>
		</cfif>
	</cffunction>


	<!---
		Metodo:
			getValidIcodigo
		Resultado
			1. Busca el Impuesto correspondiente con el Icodigo si este no está vacío.
			2. Si Icodigo está vacío busca el impuesto con el porcentaje correspondiente
			con el Monto de Impuesto en Relacion con el Monto Total de la Línea (incluyendo CERO = EXENTO).

			Si el monto del impuesto está vacío, busca un impuesto excento
	--->
	<cffunction access="private" name="getValidIcodigo" output="no" returntype="string">
		<cfargument name="Icodigo" 			required="yes" type="string">
		<cfargument name="ImporteImpuesto"	required="yes" type="numeric">
		<cfargument name="ImporteTotal" 	required="yes" type="numeric">

		<cfif len(trim(Arguments.Icodigo))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Icodigo, round(Iporcentaje*#Arguments.ImporteTotal#/100,2) as Impuesto
				from Impuestos
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
			<cfif query.recordcount eq 0>
      <cfquery name="query" datasource="#GvarConexion#">
        select Icodigo, round(Iporcentaje*#Arguments.ImporteTotal#/100,2) as Impuesto
        from Impuestos
        where IcodigoExt = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
      </cfquery>
      <cfif query.recordcount eq 0>
				<cfthrow message="Error en #GvarModO#. CodigoImpuesto (#Arguments.Icodigo#) es inválido. El Código de Impuesto no corresponde con ningún Impuesto de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			<cfelseif Arguments.ImporteImpuesto NEQ -1 AND abs(query.Impuesto - Arguments.ImporteImpuesto) GT 1>
				<cfthrow message="Error en #GvarModO#. PorcentajeImpuesto es inválido. El Monto de Impuesto (#NumberFormat(Arguments.ImporteImpuesto,'0.00')#) no corresponde (#NumberFormat(query.Impuesto,'0.00')#) según el porcentaje de Impuesto '#query.Icodigo#' aplicado al monto total de (#NumberFormat(Arguments.ImporteTotal,'0.00')#) de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
      </cfif>
		<cfelse>
        	<cfif ImporteTotal EQ 0>
            	<cfset PorcentajeImpuesto = 0>
            <cfelse>
				<cfset PorcentajeImpuesto = ImporteImpuesto / ImporteTotal * 100>
            </cfif>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(Icodigo) as Icodigo
				from Impuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and round(Iporcentaje,2) = round(<cfqueryparam cfsqltype="cf_sql_money" value="#PorcentajeImpuesto#">,2)
			</cfquery>
			<cfif query.recordcount EQ 0>
				<cfif ImporteImpuesto EQ 0>
					<cfthrow message="Error en #GvarModO#. ImporteImpuesto no válido. No existe Codigo de Impuesto Exento en la Empresa #GvarEnombre#. Proceso Cancelado!.">
                <cfelse>
					<cfthrow message="Error en #GvarModO#. ImporteImpuesto no válido. No existe Codigo de Impuesto con #numberFormat(PorcentajeImpuesto,",9.99")#% en la Empresa #GvarEnombre# (Impuesto=#numberFormat(ImporteImpuesto,",9.99")# / TotalLinea=#numberFormat(ImporteTotal,",9.99")#). Proceso Cancelado!.">
                </cfif>
			</cfif>
		</cfif>
		<cfreturn query.Icodigo>
	</cffunction>

<!---
	Metodo:
		getValid_DCcuenta
	Resultado:
		0.	Se valída la máscara enviada por el usuario de la interfaz.
	--->
	<cffunction access="private" name="getValid_DCcuenta" output="no" returntype="query">
		<cfargument name="CFormato" required="yes" type="string">
		<cfset var LvarCcuenta = 0>
		<!--- Lo trata de Obtener validando el formato --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(Arguments.CFormato,4)#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Arguments.CFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Error en #GvarModO#. Cuenta #Arguments.CFormato#: #LvarERROR#. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			from CFinanciera
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta))>
			<cfset LvarCcuenta = rsCuenta.Ccuenta>
		<cfelse>
			<cfthrow message="Error en #GvarModO#. Cuenta #Arguments.CFormato#: Cuenta Inválida! para la empresa #GvarEnombre#. Proceso Cancelado!">
		</cfif>
		<cfreturn rsCuenta>
	</cffunction>


	<!---
		Metodo:
			obtieneCuentaArticulo_Compras_Ingresos
		Resultado:
			Devuelve el id de cuenta contable de costo del Articulo
	--->
	<cffunction access="private" name="obtieneCuentaArticulo_CformatoIngresos" output="no" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfreturn obtieneCuentaArticulo_Compras_Ingresos (LparamAid, LparamAlm_Aid, LparamIDSocio, "CC")>
	</cffunction>


	<!---
		Metodo:
			obtieneCuentaConceptoServicio_Gasto_Ingreso
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio
	--->
	<cffunction access="private" name="obtieneCuentaConceptoServicio_Gasto_Ingreso" output="no" returntype="query">
		<cfargument name="LparamCid"   	   required="yes" type="string">
		<cfargument name="LparamCodCid"    required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfargument name="LparamModulo"   required="yes" type="string">
		<!--- 1. Obtiene el Formato --->
		<cfquery name="query" datasource="#GvarConexion#">
			select Cformato as Formato, Ctipo
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamCid#">
			and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LparamCodCid#">
		</cfquery>
		<cfif len(trim(query.Formato)) eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la Cuenta de Gasto para el concepto #arguments.LparamCodCid#. Proceso Cancelado!">
		<cfelseif LparamModulo EQ "CC" AND query.Ctipo NEQ "I">
			<cfthrow message="Error en Interfaz 10. El concepto #arguments.LparamCodCid# no es tipo Ingreso. Proceso Cancelado!">
		<cfelseif LparamModulo EQ "CP" AND query.Ctipo NEQ "G">
			<cfthrow message="Error en Interfaz 10. El concepto #arguments.LparamCodCid# no es tipo Gasto. Proceso Cancelado!">
		</cfif>

		<!--- 2. Obtiene el complemento del Socio --->
		<cfquery name="rsSocio" datasource="#GvarConexion#">
			select cuentac
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamIDSocio#">
		</cfquery>
		<!--- 3.Aplica Máscara --->
		<cfset LvarFormato = query.Formato>
		<cfif len(trim(rsSocio.cuentac))>
			<cfset LvarFormato = CGAplicarMascara(LvarFormato, rsSocio.cuentac)>
		</cfif>
		<cfif Find('?',LvarFormato) GT 0>
			<cfthrow message="Error! No se pudo determinar la contra cuenta contable! Proceso Cancelado!">
		</cfif>
		<!--- 4. Genera Cuenta Financiera --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta #LvarFormato#: #LvarERROR#">
		</cfif>
		<!--- 5. Obtiene la Cuenta Asociada al Formato de Cuenta Financiera --->
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			from CFinanciera
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta)) eq 0>
			<cfthrow message="Cuenta #LvarFormato#: Cuenta Inválida! Proceso Cancelado!">
		</cfif>
		<cfreturn rsCuenta>
	</cffunction>

	<!---
		Metodo:
			getValidExportacion
		Resultado:
			0.	Se valída el campo exportación enviada por el usuario de la interfaz.
	--->
	<cffunction access="private" name="getValidExportacion" output="no" returntype="string">
		<cfargument name="Exportacion" required="yes" type="string">
		<cfset Export = "#trim(Arguments.Exportacion)#">
		<cfquery name="queryExportacion" datasource="#GvarConexion#">
			select IdExportacion,CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus
        	from CSATExportacion 
			where  <!---BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
				and--->   CSATcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Exportacion)#">
		</cfquery>



		<cfif LEN(TRIM(queryExportacion.CSATcodigo)) GT 0>
			<cfquery name="queryExportacion" datasource="#GvarConexion#">
				select IdExportacion,CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus
        		from CSATExportacion 
				where <!---BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
				and--->   CSATcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Exportacion)#">
			</cfquery>

			<cfset CSATcodigo = queryExportacion.CSATcodigo>

		<cfelseif LEN(TRIM(Arguments.Exportacion)) EQ 0>
			<cfset CSATcodigo = Arguments.Exportacion>
		<cfelse>
			<cfthrow message="Error en #GvarModO#. El Código #Arguments.Exportacion# no se encuentra en el catálogo de Exportación en la empresa #GvarEnombre#. Proceso Cancelado!">
		</cfif>

		<cfreturn CSATcodigo>
	</cffunction>

	<!---
		Metodo:
			getValidObjImpuesto
		Resultado:
			0.	Se valída el campo Objeto de impuesto enviada por el usuario de la interfaz.
	--->
	<cffunction access="private" name="getValidObjImpuesto" output="no" returntype="string">
		<cfargument name="ObjImpuesto" required="yes" type="string">
		<cfargument name="Documento" required="yes" type="string">
		<cfargument name="ID" required="yes" type="string">
		<cfargument name="CodigoImpuesto" required="yes" type="string">

		<cfquery name="queryObjImpuesto" datasource="#GvarConexion#">
			select IdObjImp,CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus
        	from CSATObjImpuesto 
			where <!---BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
			and   --->CSATcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.ObjImpuesto)#">
		</cfquery>

		<cfif len(trim(queryObjImpuesto.CSATcodigo))>
			<cfquery name="queryObjImpuesto" datasource="#GvarConexion#">
				select IdObjImp,CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus
        		from CSATObjImpuesto 
				where <!---BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
				and   --->CSATcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.ObjImpuesto)#">
			</cfquery>

			<cfif isDefined("Arguments.CodigoImpuesto") and LEN(TRIM(Arguments.CodigoImpuesto)) GT 0>
			        <cfset CSATcodigo = "02">
			<cfelse>
			        <cfset CSATcodigo = queryObjImpuesto.CSATcodigo>
			</cfif>

		<cfelseif LEN(TRIM(Arguments.ObjImpuesto)) EQ 0>
			<cfthrow message="Error en #GvarModO#. No debe ser vacío el Objeto de Impuesto para el documento #Arguments.ID#)#Arguments.Documento#. Proceso Cancelado!">
		<cfelse>
			<cfthrow message="Error en #GvarModO#. El Código #Arguments.ObjImpuesto# no se encuentra en el catálogo de Objeto de Impuesto en la empresa #GvarEnombre#. Proceso Cancelado!">
		</cfif>
		<cfreturn CSATcodigo>
	</cffunction>

</cfcomponent>
