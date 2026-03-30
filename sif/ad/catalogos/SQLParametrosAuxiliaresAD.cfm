<!---►►Pantalla de mantenimiento de parametros Adicionales◄◄--->

<!--- Si el combo de requisición viene con -1 es que es vació --->
<cfif isDefined("Form.TipoRequisicion") and Compare(Trim(Form.TipoRequisicion),"-1") EQ 0>
	<cfset Form.TipoRequisicion = "">
</cfif>

<cfif isDefined("Form.Aceptar")>

	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertCuenta" >
		<cfargument name="pcodigo"      type="numeric" required="true">
		<cfargument name="mcodigo"      type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor"       type="string" required="true">
		
		<cfquery name="rsParamRev" datasource="#Session.DSN#">
			select 1
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
		
		<cfif isdefined('rsParamRev') and rsParamRev.recordCount EQ 0>
			<cfquery datasource="#Session.DSN#">
				insert INTO Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor,BMUsucodigo)
				values (
					#Session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#" len="2">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#" len="100">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100" voidNull>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.usucodigo#">
					)
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				update Parametros
					set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100"  voidNull>,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				where Ecodigo = #Session.Ecodigo#
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
			</cfquery>
		</cfif>

		<cfreturn true>
	</cffunction>

	<!--- Actualiza la cuenta contable según el pcodigo --->
	<cffunction name="updateCuenta" >
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pvalor" type="string" required="true">

		<cfquery datasource="#Session.DSN#">
			update Parametros set
				Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>

		<cfreturn true>
	</cffunction>

	<cftransaction>
	<cftry>
<!--- 		<cfquery name="ParametrosCuentasCG" datasource="#Session.DSN#"> --->

			<cfparam name="form.chkPlanCtasDescAlterna" default="0">
			<cfif isdefined("form.hayPlanCtasDescAlterna") and form.hayPlanCtasDescAlterna eq 1 >
				<cfset a = updateCuenta(99,form.chkPlanCtasDescAlterna)>
			<cfelse>
				<cfset b = insertCuenta(99,'CG','Utilizar Descripción Alterna de Valores de Catálogos Corporativos al Generar Cuentas Financieras',form.chkPlanCtasDescAlterna)>
			</cfif>

			<cfif isDefined("form.hayCuentaEstimacion")>
				<cfif isdefined("form.hayCuentaEstimacion") and form.hayCuentaEstimacion eq 1 >
					<cfset a = updateCuenta(980,form.CFcuenta_CCuentaEstimacion)>
 				<cfelse>
					<cfset b = insertCuenta(980,'CG','Cuenta contable de balance para reversión de estimación',form.CFcuenta_CCuentaEstimacion)>
				</cfif>
			</cfif>

            <!--- recordar formulario --->
			<cfif isDefined("form.recordarFormAC")>
                <cfquery name="rsParam" datasource="#Session.DSN#">
                    select 1
                    from Parametros
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and Pcodigo = 15410
                </cfquery>
				<cfif isdefined("form.chkrecordarFormAC") and form.chkrecordarFormAC EQ 1 and rsParam.RecordCount GT 0>
					<cfset a = updateCuenta(15410,form.chkrecordarFormAC)><!--- desactivar --->
 				<cfelseif isdefined("form.chkrecordarFormAC") and form.chkrecordarFormAC EQ 1>
                	<cfset b = insertCuenta(15410,'CG','Utilizar Datos Anteriores al Llenar los Asientos, Es Decir, no limpiar el formulario',1)>
                <cfelse>
					<cfset b = insertCuenta(15410,'CG','Utilizar Datos Anteriores al Llenar los Asientos, Es Decir, no limpiar el formulario',form.recordarFormAC)>
				</cfif>
			</cfif>

			<!--- 981. Agregar descripción de cuenta en consulta Pólizas Contables --->
			<cfif isDefined("Form.hayAgregarDesc") and Len(Trim(form.hayAgregarDesc)) GT 0>
				<cfif isdefined("form.chkAgregarDesc")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayAgregarDesc EQ "1">
					<cfset a = updateCuenta(981,valor)>
 				<cfelseif Form.hayAgregarDesc EQ "0">
					<cfset b = insertCuenta(981,'CG','Agregar descripción de cuenta en consulta Pólizas Contables',valor)>
				</cfif>
			</cfif>

            <!--- 982. Importar Asientos Contables con Centro Funcional --->
			<cfif isDefined("Form.hayImportaConCF") and Len(Trim(form.hayImportaConCF)) GT 0>
				<cfif isdefined("form.chkImportaConCF")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayImportaConCF EQ "1">
					<cfset a = updateCuenta(982,valor)>
 				<cfelseif Form.hayImportaConCF EQ "0">
					<cfset b = insertCuenta(982,'CG','Importar Asientos Contables con Centro Funcional',valor)>
				</cfif>
			</cfif>

            <!--- 2210.  --->
			<cfif isDefined("Form.hayMBAsientoDifCam") and Len(Trim(form.hayMBAsientoDifCam)) GT 0>
				<cfif isdefined("form.chkMBAsientoDifCam")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayMBAsientoDifCam EQ "1">
					<cfset a = updateCuenta(2210,valor)>
 				<cfelseif Form.hayMBAsientoDifCam EQ "0">
					<cfset b = insertCuenta(2210,'CG','Cierre de auxiliares no genera en Bancos asientos de diferencial cambiario',valor)>
				</cfif>
			</cfif>

			<cfif isDefined("form.McodigoValuacionIV")>
				<cfset b = insertCuenta(441,'IV','Moneda de Valuación para Inventarios',form.McodigoValuacionIV)>
			</cfif>

			<cfif isDefined("form.CCuentaBalanceAsi")>
				<cfif isdefined("form.hayCuentaBalAsi") and form.hayCuentaBalAsi eq 1 >
					<cfset a = updateCuenta(25,form.CFcuenta_CCuentaBalanceAsi)>
 				<cfelse>
					<cfset b = insertCuenta(25,'CG','Cuenta Contable para Balance de Asiento',form.CFcuenta_CCuentaBalanceAsi)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento1") and Len(Trim(hayVencimiento1)) GT 0>
				<cfif Form.hayVencimiento1 EQ "1">
					<cfset a = updateCuenta(310,Form.vencimiento1)>
 				<cfelseif Form.hayVencimiento1 EQ "0">
					<cfset b = insertCuenta(310,'GN','Primer Vencimiento en Días',Form.vencimiento1)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento2") and Len(Trim(hayVencimiento2)) GT 0>
				<cfif Form.hayVencimiento2 EQ "1">
					<cfset a = updateCuenta(320,Form.vencimiento2)>
 				<cfelseif Form.hayVencimiento2 EQ "0">
					<cfset b = insertCuenta(320,'GN','Segundo Vencimiento en Días',Form.vencimiento2)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento3") and Len(Trim(hayVencimiento3)) GT 0>
				<cfif Form.hayVencimiento3 EQ "1">
					<cfset a = updateCuenta(330,Form.vencimiento3)>
 				<cfelseif Form.hayVencimiento3 EQ "0">
					<cfset b = insertCuenta(330,'GN','Tercer Vencimiento en Días',Form.vencimiento3)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento4") and Len(Trim(hayVencimiento4)) GT 0>
				<cfif Form.hayVencimiento4 EQ "1">
					<cfset a = updateCuenta(340,Form.vencimiento4)>
 				<cfelseif Form.hayVencimiento4 EQ "0">
					<cfset b = insertCuenta(340,'GN','Cuarto Vencimiento en Días',Form.vencimiento4)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayTipoRequisicion") and Len(Trim(hayTipoRequisicion)) GT 0>
				<cfif Form.hayTipoRequisicion EQ "1">
					<cfset a = updateCuenta(360,Form.TipoRequisicion)>
 				<cfelseif Form.hayTipoRequisicion EQ "0" and Len(Trim(Form.TipoRequisicion)) GT 0>
					<cfset b = insertCuenta(360,'IV','Requisición Default',Form.TipoRequisicion)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.haySolicitante") and Len(Trim(haySolicitante)) GT 0>
				<cfif Form.haySolicitante EQ "1">
					<cfset a = updateCuenta(370,Form.CMSid)>
 				<cfelseif Form.haySolicitante EQ "0" >
					<cfset b = insertCuenta(370,'IV','Solicitante Default',Form.CMSid)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayAutorizacion") and Len(Trim(form.hayAutorizacion)) GT 0>
				<cfif isdefined("form.chkAutorizar")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayAutorizacion EQ "1">
					<cfset a = updateCuenta(410,valor)>
 				<cfelseif Form.hayAutorizacion EQ "0">
					<cfset b = insertCuenta(410,'CM','Requiere aprobación de Solicitudes de Compra',valor)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayClienteContado") and Len(Trim(form.hayClienteContado)) GT 0>
				<cfif form.hayClienteContado EQ "1">
					<cfset a = updateCuenta(435,Form.SNcodigo)>
 				<cfelseif Form.hayClienteContado EQ "0">
					<cfset b = insertCuenta(435,'FA','Cliente de Contado',Form.SNcodigo)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayVendedorCxC") and Len(Trim(form.hayVendedorCxC)) GT 0>
                <cfif isdefined("form.chkVendedorCxC")>
				    <cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
            	<cfif form.hayVendedorCxC EQ "1">
					<cfset a = updateCuenta(15834,valor)>
 				<cfelseif Form.hayVendedorCxC EQ "0">
					<cfset b = insertCuenta(15834,'FA','Usa Catalogo vendedores de CxC',valor)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayControlInventarios") and Len(Trim(form.hayControlInventarios)) GT 0>
                <cfif isdefined("form.chkControlInventarios")>
				    <cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayControlInventarios EQ "1">
					<cfset a = updateCuenta(15835,valor)>
 				<cfelseif Form.hayControlInventarios EQ "0">
					<cfset b = insertCuenta(15835,'FA','Controla Inventarios en facturacion',valor)>
				</cfif>
			</cfif>
			<!----VERSION CFDI--->
			<cfset valorVersion = 0>

			<cfif isDefined("Form.cbxhayVersion") and Len(Trim(form.cbxhayVersion)) GT 0>
				<cfset valorVersion = #Form.cbxhayVersion#>
			</cfif>

			<cfif isDefined("Form.hayVersion") and Trim(form.hayVersion) GT 0>
				<cfset a = updateCuenta(17200,valorVersion)>
			<cfelse>
			    <cfset b = insertCuenta(17200,'FA','Version que se utiliza',valorVersion)>	
			</cfif>
			<!----Decimales Valor Unitario--->
			<cfset valorDec = 0>

			<cfif isDefined("Form.cbxDecimalesFac")>
				<cfset valorDec = "#Form.cbxDecimalesFac#">
			</cfif>
		

			<cfif isDefined("Form.cbxDecimalesFac") and Trim(form.hayDeciFac) GT 0>
				<cfset a = updateCuenta(17300,valorDec)>
			<cfelse>
			    <cfset b = insertCuenta(17300,'FA','Numero de decimales a utilizar',valorDec)>	
			</cfif>

			<!--- Ruta de Guardado --->
			<cfset RutaG = "">
			<cfif isDefined("Form.ruta")>
				<cfset RutaG = "#Form.ruta#">
			</cfif>
			<cfif isDefined("Form.ruta") and Trim(form.ruta) GT 0>
				<cfset a = updateCuenta(17400,RutaG)>
			<cfelse>
			    <cfset b = insertCuenta(17400,'FA','Ruta de Guardado de Documentos Timbrados',RutaG)>	
			</cfif>

			<!--- Zona Horaria de timbrado --->
			<cfset Zona = "">
			<cfset Verano = "">
			<cfif isDefined("Form.cbxZonahoraria")>
				<cfset Zona = "#listfirst(Form.cbxZonahoraria)#">
				<cfset Verano = "#listrest(Form.cbxZonahoraria)#">
			</cfif>
			<cfif form.hayCVerano  EQ 1>
				<cfset a = updateCuenta(17500,Zona)>
			<cfelse>
			    <cfset b = insertCuenta(17500,'FA','Zona Horaria de Timbrado',Zona)>	
			</cfif>

			<!--- Horario de Verano --->
			<cfif form.hayCVerano  EQ 1>
				<cfset a = updateCuenta(17600,Verano)>
			<cfelse>
				<cfset a = insertCuenta(17600,'FA','Horario de Verano',Verano)>
			</cfif>
            

			<cfif isDefined("Form.hayCuentadedescuentosFact")>
                <cfif isdefined("form.hayCuentadedescuentosFact") and Len(Trim(form.hayCuentadedescuentosFact)) GT 0 >
				    <cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif valor EQ "1">
					<cfset a = updateCuenta(1401,#form.cuentaDescuentoDetallesFac#)>
 				<cfelseif valor EQ "0">
					<cfset b = insertCuenta(1401,'FA','Cuenta para descuentos en detalles de facturacion',#form.cuentaDescuentoDetallesFac#)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.consecutivoRE")>
                <cfif isdefined("form.consecutivoRE") and Len(Trim(form.consecutivoRE)) GT 0  and form.consecutivoRE eq 1>
				    <cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
                <cfif valor EQ "1">
					<!---<cfset a = updateCuenta(16200,#form.faConsecutivoRE#)>--->
 				<cfelseif valor EQ "0">
					<cfset b = insertCuenta(16200,'FA','Consecutivo Recibos de pagos',#form.faConsecutivoRE#)>
				</cfif>
			</cfif>
			<!--- caja default para notas de credito sin refactura y para notas de credito con refactura de tipo Credito --->
			<cfif isDefined("Form.hayrepCajaAsignado") and Len(Trim(form.hayrepCajaAsignado)) GT 0>
				<cfif Form.hayrepCajaAsignado EQ 1>
					<cfset a = updateCuenta(16305, Form.repCajasDefault)>
 				<cfelse>
					<cfset b = insertCuenta(16305, 'FA', 'Caja Default para Notas de Credito sin Re-Factura, o con Refactura de tipo credito', Form.repCajasDefault)>
				</cfif>
			</cfif>
			<!--- Utilizar vencimiento para facturas por por vencimiento de socio de negocio, si no es asi se usa el vencimiento de CCTransacciones --->
			<cfif isDefined('form.hayrepVencimientoSocio') and Len(Trim(form.hayrepVencimientoSocio)) GT 0>
				<cfif isDefined('form.chkVencimientoSocio')>
					<cfset _repVencimientoSocio = '1'>
					<cfelse>
					<cfset _repVencimientoSocio = '0'>
				</cfif>
				<cfif form.hayrepVencimientoSocio EQ 1>
					<cfset a = updateCuenta(16306,_repVencimientoSocio)>
					<cfelse>
					<cfset a = insertCuenta(16306,'FA','Utilizar Vencimiento por Socio de negocio',_repVencimientoSocio)>
				</cfif>
			</cfif>
			<!--- codigo 16307: Lista de Codigos de empresa origen que no permiten refacturar --->
			<cfif isDefined('form.hayConsecutivoCodEmpOrigen') and Len(Trim(form.hayConsecutivoCodEmpOrigen)) GT 0>
				<cfif form.hayConsecutivoCodEmpOrigen EQ '1'>
					<cfset updateCuenta(16307,form.faConsecutivoCodEmpOrigen)>
				<cfelse>
					<cfset insertCuenta(16307,'FA','Códigos de Sistemas Origen que no permiten Re-Facturacion(separados por ,). Guardados en FAERecuperacion.CodSistema',form.faConsecutivoCodEmpOrigen)>
				</cfif>
			</cfif>
			<!----- Monto Maximo para devolucion en cajas  Pcodigo: 16039 --->
            <cfif isDefined("Form.faMontoMaximoVuelto")>
                <cfif isdefined("form.faMontoMaximoVuelto") and Len(Trim(form.faMontoMaximoVuelto)) GT 0  and form.faMontoMaximoVuelto eq 1>
				    <cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
                <cfif valor EQ "1">
					<cfset a = updateCuenta(16039,#form.faMontoMaximoVuelto#)>
 				<cfelseif valor EQ "0">
					<cfset b = insertCuenta(16039,'FA','Monto maximo para generacion de vuelto',#form.faMontoMaximoVuelto#)>
				</cfif>
			</cfif>
			<!----- Centro funcional para remesas  Pcodigo: 16309 --->
            <cfif isDefined("Form.CFParaRemesas")>
                <cfif isdefined("form.CFParaRemesas") and Len(Trim(form.CFParaRemesas)) GT 0  and form.hayCFRemesas eq 1>
				    <cfset a = updateCuenta(16309,#form.CFParaRemesas#)>
				<cfelse>
					<cfset b = insertCuenta(16309,'FA','Centro funcional para Remesas',#form.CFParaRemesas#)>
				</cfif>
		   </cfif>
		   <!--- 16317. Si este bit esta encendido, entonces agrega los registros en la bitácora de envíos electrónicos. --->
			<cfif isDefined('form.hayintegraFacturaDigital') and Len(Trim(form.hayintegraFacturaDigital)) GT 0>
				<cfif isDefined('form.chkintegraFacturaDigital')>
					<cfset _integraFacturaDigital = '1'>
				<cfelse>
					<cfset _integraFacturaDigital = '0'>
				</cfif>
				<cfif form.hayintegraFacturaDigital EQ 1>
					<cfset a = updateCuenta(16317,_integraFacturaDigital)>
				<cfelse>
					<cfset a = insertCuenta(16317,'FA','Integración con facturación digital',_integraFacturaDigital)>
				</cfif>
			</cfif>
			<!--- 16371. Dato del proveedor de factruación digital. --->
			<cfif isDefined('form.hayProveedorFacturaDigital') and Len(Trim(form.hayProveedorFacturaDigital)) GT 0>
				<cfif isDefined('form.ProveedorFE')>
					<cfset _ProveedorFacturaDigital = form.ProveedorFE>
				</cfif>
				<cfif form.hayProveedorFacturaDigital EQ 1>
					<cfset a = updateCuenta(16371,_ProveedorFacturaDigital)>
				<cfelse>
					<cfset a = insertCuenta(16371,'FA','Proveedor facturación digital',_ProveedorFacturaDigital)>
				</cfif>
			</cfif>
			<!--- 16318 - Activar la interfaz de conexión para SGA --->
		   	<cfif isdefined("form.hayInterfazSGA")>
		   		<cfset valor = 0>
            	<cfif isdefined("form.chkInterfazSGA")>
					<cfset valor = 1>
            	</cfif>
            	<cfif form.hayInterfazSGA eq 1>
					<cfset a = updateCuenta(16318,valor)>
				<cfelse>
					<cfset b = insertCuenta(16318,'FA','Activar la interfaz de conexión para SGA',valor)>
            	</cfif>
            </cfif>
			<!--- 16372 - Activar la interfaz de conexión para SGA --->
		   	<cfif isdefined("form.hayContabilizarAplicarTransa")>
		   		<cfset valor = 0>
            	<cfif isdefined("form.chkContabilizarAplicarTransa")>
					<cfset valor = 1>
            	</cfif>
            	<cfif form.hayContabilizarAplicarTransa eq 1>
					<cfset a = updateCuenta(16372,valor)>
				<cfelse>
					<cfset b = insertCuenta(16372,'FA','Contabilizar transacciones al aplicar',valor)>
            	</cfif>
            </cfif>
			<!--- 16373 - Validar correo y telefono en pantalla--->
		   	<cfif isdefined("form.hayValidacionCorreoYtelefono")>
		   		<cfset valor = 0>
            	<cfif isdefined("form.chkValidarCorreoTelefono")>
					<cfset valor = 1>
            	</cfif>
            	<cfif form.hayValidacionCorreoYtelefono eq 1>
					<cfset a = updateCuenta(16373,valor)>
				<cfelse>
					<cfset b = insertCuenta(16373,'FA','Validar correo y telefono al registrar la factura.',valor)>
            	</cfif>
            </cfif>
            <!--- 17000 - Plantilla Factura Electronica--->
		   	<cfif isdefined("form.plantillaFE")>
		   		<cfif isDefined('form.plantillaFE')>
					<cfset _plantillaFE = form.plantillaFE>
				</cfif>
				<cfif form.plantillaFE NEQ '' and isDefined("hayValidarPlantillaFE") and hayValidarPlantillaFE EQ 1>
					<cfset a = updateCuenta(17000,form.plantillaFE)>
				<cfelseif form.plantillaFE NEQ ''>
					<cfset a = insertCuenta(17000,'FA','Plantilla Factura Electronica ',form.plantillaFE)>
				</cfif>
            </cfif>
            <!--- 17100 - Validacion Timbre Fiscal UUID--->
		   	<cfif isdefined("form.hayTFiscal")>
		   		<cfset valor = 0>
            	<cfif isdefined("form.chkTFiscal")>
					<cfset valor = 1>
            	</cfif>
				<cfif form.hayTFiscal  EQ 1>
					<cfset a = updateCuenta(17100,valor)>
				<cfelse>
					<cfset a = insertCuenta(17100,'FA','Validacion Timbre Fiscal UUID',valor)>
				</cfif>
            </cfif>


			<!---361. Consecutivos separados para las requisiciones--->
			<cfif isDefined("Form.hayConsReq") and Len(Trim(form.hayConsReq)) GT 0>
				<cfif isdefined("form.chkConsReq")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayConsReq EQ "1">
					<cfset a = updateCuenta(361,valor)>
 				<cfelseif Form.hayConsReq EQ "0">
					<cfset b = insertCuenta(361,'IV','Consecutivos separados para las requisiciones',valor)>
				</cfif>
			</cfif>

			<!--- 420. Forma de cálculo de Impuesto en CxC --->
			<cfif isDefined("Form.haycalculoImp") and Len(Trim(haycalculoImp)) GT 0>
				<cfif Form.haycalculoImp EQ "1">
					<cfset a = updateCuenta(420,Form.calculoImp)>
					<cfquery datasource="#Session.DSN#">
						update Parametros set
							Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.calculoImp)#">,
							BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							Pdescripcion = 'Manejo del Descuento a nivel de Doc (0: Desc/Imp, 1: Imp/Desc.)'
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="420">
					</cfquery>
 				<cfelseif Form.haycalculoImp EQ "0" >
					<cfset b = insertCuenta(420,'FA','Manejo del Descuento a nivel de Doc (0: Desc/Imp, 1: Imp/Desc.)',Form.calculoImp)>
				</cfif>
			</cfif>

			<!--- 421. Forma de cálculo de Impuesto en CxC --->
			<cfif isDefined("Form.haydescDoc") and Len(Trim(Form.haydescDoc)) GT 0>
				<cfif Form.haydescDoc EQ "1">
					<cfset a = updateCuenta(421,Form.descDoc)>
 				<cfelseif Form.haydescDoc EQ "0" >
					<cfset b = insertCuenta(421,'FA','Forma de Contabilizar Descuento Documento CxC (D=Cta Descuento, I=Diminuye Ingreso)',Form.descDoc)>
				</cfif>
			</cfif>

			<!--- 70. Forma de cálculo de Impuesto en CxC --->
			<cfif isDefined("Form.haycuentaDescuentos") and Len(Trim(Form.haycuentaDescuentos)) GT 0>
				<cfif Form.haycuentaDescuentos EQ "1">
					<cfset a = updateCuenta(70,Form.CDescuentos)>
 				<cfelseif Form.haycuentaDescuentos EQ "0" >
					<cfset b = insertCuenta(70,'FA','Cuenta Descuentos CxC)',Form.CDescuentos)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.haySupervisor") and Len(Trim(form.haySupervisor)) GT 0>
				<cfif form.haySupervisor EQ "1">
					<cfset a = updateCuenta(430,Form.FASupervisor)>
 				<cfelseif Form.haySupervisor EQ "0">
					<cfset b = insertCuenta(430,'FA','Supervisor de Cierre de Cajas',Form.FASupervisor)>
				</cfif>
			</cfif>


			<cfif isDefined("form.hayCierreCaja")>
				<cfif isdefined("form.chkCierreCaja")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif isdefined("form.hayCierreCaja") and form.hayCierreCaja eq 1 >
					<cfset a = updateCuenta(500,valor)>
 				<cfelse>
					<cfset b = insertCuenta(500,'FA','Usa Cierre de Cajas',valor)>
				</cfif>
			</cfif>

		<!---- Poliza Complementaria --ALG--->			
			<cfif isDefined("form.chkPolCIn")>	

				<cfif isdefined("form.chkPolCompl") and form.chkPolCompl eq 1>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif isdefined("form.chkPolCompl") and form.chkPolCIn eq 1>
					<cfset a = updateCuenta(11100801,valor)>
 				<cfelse>
					<cfset b = insertCuenta(11100801,'CG','Aplica póliza complementaria',valor)>
				</cfif>
			</cfif>

		<!---- Calcula la retencion en Cobros de documentos --ALG--->			
			<cfif isDefined("form.chkCalcRetHC")>	

				<cfif isdefined("form.chkCalcRetC") and form.chkCalcRetC eq 1>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif isdefined("form.chkCalcRetC") and form.chkCalcRetHC eq 1>
					<cfset a = updateCuenta(10600801,valor)>
 				<cfelse>
					<cfset b = insertCuenta(10600801,'CC','Calcula Retención',valor)>
				</cfif>
			</cfif>

		<!---- Calcula la retencion en Pago de documentos --ALG--->			
			<cfif isDefined("form.chkCalcRetHP")>	

				<cfif isdefined("form.chkCalcRetP") and form.chkCalcRetP eq 1>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif isdefined("form.chkCalcRetP") and form.chkCalcRetHP eq 1>
					<cfset a = updateCuenta(11700801,valor)>
 				<cfelse>
					<cfset b = insertCuenta(11700801,'CP','Calcula Retención',valor)>
				</cfif>
			</cfif>			

			<cfif isDefined("form.hayAumentaConsecutivo")>
				<cfif isdefined("form.chkAumentaConsecutivo")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif isdefined("form.hayAumentaConsecutivo") and form.hayAumentaConsecutivo eq 1 >
					<cfset a = updateCuenta(510,valor)>
 				<cfelse>
					<cfset b = insertCuenta(510,'FA','Modifica número de factura al reimprimir',valor)>
				</cfif>
			</cfif>

			<!---►►Parametro 5306: Indicar Cuentas Manualmente◄◄--->
		    <cfset insertDato(5306,'CG','Permitir indicar Cuentas para Servicio',fnChk("form.chkCuentaManual"))>

        <!---►►Parametro 5307: Descripción Alterna Requerida◄◄--->
		    <cfset insertDato(5307,'CM','Descripción Alterna Requerida',fnChk("form.chkDescripcionAR"))>

		<!---►►Parametro 15652: Habilitar validacion de campos obligatorios  del catalogo de Actividad de Tracking , esto para
										 el formulario de la poliza, y cierre de la poliza. En caso de que se deje habilitada la validacion
										 se deben agregar las actividades faltantes si el mensaje aparece en rojo  señalando cuales son,
										 de lo contrario no se va a poder cerrar la poliza◄◄--->
		    <cfset insertDato(15652,'CM','Validar campos obligatorios del seguimiento de Tracking',fnChk("form.chkValidaCamposTrack"))>

<!---
			<cfif isDefined("form.hayPlanCuentas") and Len(Trim(form.hayPlanCuentas)) GT 0>
				<cfif isdefined("form.chkPlanCuentas")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayPlanCuentas EQ "1">
					<cfset a = updateCuenta(1,valor)>
 				<cfelseif Form.hayPlanCuentas EQ "0">
					<cfset b = insertCuenta(1,'AD','Usa Plan de Cuentas',valor)>
				</cfif>
			</cfif>
--->

			<!----- Centro funcional para remesas  Pcodigo: 16309 --->
            <cfif isDefined("Form.CFParaRemesas")>
                <cfif isdefined("form.CFParaRemesas") and Len(Trim(form.CFParaRemesas)) GT 0  and form.hayCFRemesas eq 1>
				    <cfset a = updateCuenta(16309,#form.CFParaRemesas#)>
				<cfelse>
					<cfset b = insertCuenta(16309,'FA','Centro funcional para Remesas',#form.CFParaRemesas#)>
				</cfif>
		   </cfif>


			<!--- 490. Valida Producción antes que Ventas o Mantener Costo de Ventas Pendiente--->
			<cfif isDefined("form.hayValidaProduccion") and Len(Trim(form.hayValidaProduccion)) GT 0>
				<cfif isdefined("form.chkValidaProduccion")><cfset valor = '1'><cfelse><cfset valor = '0'></cfif>
				<cfif form.hayValidaProduccion EQ "1">
					<cfset a = updateCuenta(490,valor)>
 				<cfelseif Form.hayValidaProduccion EQ "0">
					<cfset b = insertCuenta(490,'IV','Mantener Costo de Ventas Pendiente',valor)>
				</cfif>
			</cfif>

			<!--- 450. Socio de Importacion --->
			<cfif isDefined("form.haySocioImportacion") and Len(Trim(form.haySocioImportacion)) GT 0>
				<cfif form.haySocioImportacion EQ "1">
					<cfset a = updateCuenta(450,form.SocioImportacion)>
 				<cfelseif Form.haySocioImportacion EQ "0">
					<cfset b = insertCuenta(450,'IV','Socio de Importación',form.SocioImportacion)>
				</cfif>
			</cfif>

			<!--- 455. Socio de Importacion Compras--->
			<cfif isDefined("form.haySocioImportacionC") and Len(Trim(form.haySocioImportacionC)) GT 0>
				<cfif form.haySocioImportacionC EQ "1">
					<cfset a = updateCuenta(455,form.sncodigo)>
 				<cfelseif Form.haySocioImportacionC EQ "0">
					<cfset b = insertCuenta(455,'IV','Socio de Importación Compras',form.sncodigo)>
				</cfif>
			</cfif>

			<!--- 740. Valida No contabiliza Costo de Ventas ni Ajustes --->
			<cfif isDefined("form.hayNoContaCosto") and Len(Trim(form.hayNoContaCosto)) GT 0>
				<cfif isdefined("form.chkValorNoContaCosto")><cfset valor = '1'><cfelse><cfset valor = '0'></cfif>
				<cfif form.hayNoContaCosto EQ "1">
					<cfset a = updateCuenta(740,valor)>
 				<cfelseif Form.hayNoContaCosto EQ "0">
					<cfset b = insertCuenta(740,'IV','No contabiliza el Costo de Ventas ni Ajustes',valor)>
				</cfif>
			</cfif>

        	<!--- 741. Verifica Grupo de cuentas en el catalogo de articulos--->
			<cfif isDefined("form.hayVerGruCtas") and Len(Trim(form.hayVerGruCtas)) GT 0>
				<cfif isdefined("form.chkVerGruCtas")><cfset valor = '1'><cfelse><cfset valor = '0'></cfif>
				<cfif form.hayVerGruCtas EQ "1">
					<cfset a = updateCuenta(741,valor)>
 				<cfelseif Form.hayVerGruCtas EQ "0">
					<cfset b = insertCuenta(741,'IV','Verifica la cuenta contable del almacen final en los movimientos interalmacen',valor)>
				</cfif>
			</cfif>

            <!--- 5300. Máscara de Código de Articulos --->
			<cfset CodigoArt = '' >
			<cfif isDefined("form.mascaraCodArt") and Len(Trim(form.mascaraCodArt)) GT 0>
				<cfset CodigoArt = Form.mascaraCodArt >
            </cfif>
            <cfif isDefined("Form.hayCodigoArt") and Len(Trim(form.hayCodigoArt)) GT 0>
				<cfif form.hayCodigoArt EQ "1">
					<cfset a = updateCuenta(5300,CodigoArt)>
 				<cfelseif Form.hayCodigoArt EQ "0" and Len(Trim(CodigoArt)) GT 0>
					<cfset b = insertCuenta(5300,'CA','Máscara de Código de Articulos',CodigoArt)>
				</cfif>
            </cfif>

			<!--- 460. Tipo de Transacciones CP par Importaciones --->
			<cfset TransaccionCP = '' >
			<cfif isdefined("Form.TransaccionCP") and Len(Trim(Form.TransaccionCP)) GT 0>
				<cfset TransaccionCP = Form.TransaccionCP >
			</cfif>
			<cfif isDefined("Form.hayTransaccionCP") and Len(Trim(form.hayTransaccionCP)) GT 0>
				<cfif Form.hayTransaccionCP EQ "1">
					<cfset a = updateCuenta(460,TransaccionCP)>
 				<cfelseif Form.hayTransaccionCP EQ "0" and Len(Trim(TransaccionCP)) GT 0>
					<cfset b = insertCuenta(460,'CP','Tipo de Transaccion CxP para Importaciones',TransaccionCP)>
				</cfif>
			</cfif>

			<!--- 470. Codigo de IMpuesto para Transacciones --->
			<cfif isDefined("Form.hayImpuestos") and Len(Trim(form.hayImpuestos)) GT 0>
				<cfif isdefined("form.Icodigo")>
					<cfset icodigo = form.Icodigo>
				<cfelse>
					<cfset icodigo = ''>
				</cfif>
				<cfif Form.hayImpuestos EQ "1">
					<cfset a = updateCuenta(470,icodigo)>
 				<cfelseif Form.hayImpuestos EQ "0" and Len(Trim(icodigo)) GT 0>
					<cfset b = insertCuenta(470,'CP','Código de Impuesto para Importaciones',Form.Icodigo)>
				</cfif>
			</cfif>

			<!--- 480. Tipo de Transacciones CC par Importaciones --->
			<cfset transaccionCC = ''>
			<cfif isdefined("form.TransaccionCC") and Len(Trim(Form.TransaccionCC))>
				<cfset transaccionCC = form.TransaccionCC>
			</cfif>
			<cfif isDefined("Form.hayTransaccionCC") and Len(Trim(form.hayTransaccionCC)) GT 0>
				<cfif Form.hayTransaccionCC EQ "1">
					<cfset a = updateCuenta(480,transaccionCC)>
 				<cfelseif Form.hayTransaccionCC EQ "0" and Len(Trim(transaccionCC)) GT 0>
					<cfset b = insertCuenta(480,'CC','Tipo de Transaccion CxC para Importaciones',Form.TransaccionCC)>
				</cfif>
			</cfif>


			<!--- 3500. Tramites: forma de determinar el CF de un Usuario --->
			<cfif isDefined("Form.hayWS_CFusuario") and Len(Trim(form.hayWS_CFusuario)) GT 0>
				<cfset valor = form.WS_CFusuario>
				<cfif form.hayWS_CFusuario eq "1">
					<cfset a = updateCuenta(3500,valor)>
 				<cfelseif Form.hayWS_CFusuario eq "0">
					<cfset b = insertCuenta(3500,'TR','Determinacion de Centro Funcional de un Usuario',valor)>
				</cfif>
				<cfset sbLlenarUsuarioCFuncional(valor)>
			</cfif>

			<!--- 549. Permitir Traslados de Presupuesto con Cuentas de Control Abierto --->
			<cfif isDefined("Form.hayTrasladosAbierto") and Len(Trim(form.hayTrasladosAbierto)) GT 0>
				<cfif isdefined("form.chkTrasladosAbierto")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayTrasladosAbierto eq "1">
					<cfset a = updateCuenta(549,valor)>
 				<cfelseif Form.hayTrasladosAbierto eq "0">
					<cfset b = insertCuenta(549,'CM','Permitir Cuentas con Control Abierto en Traslados de Presupuesto',valor)>
				</cfif>
			</cfif>

			<!--- 544. Modificacion de Identificador de Proyecto--->
			<cfquery name="Existe" datasource="#Session.dsn#">
				select Pcodigo from Parametros 
				where Pcodigo = 544
				and Ecodigo = #Session.Ecodigo#
			</cfquery>
			<cfset existeV = Existe.Pcodigo>

			<cfif existeV eq ''>
				<cfset b = insertCuenta(544,'CM','Habilitar edición del identificador del proyecto',valor)>
			</cfif>

			<cfif isDefined("Form.hayIdentificador") and Len(Trim(form.hayIdentificador)) GT 0>
				<cfif isdefined("form.chkIdentificador")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif valor eq "1">
					<cfset a = updateCuenta(544,valor)>
 				<cfelseif valor eq "0">
					<cfset b = insertCuenta(544,'CM','Habilitar edición de del identificador del proyecto',valor)>
				</cfif>
			</cfif>

			<!--- 541. Permitir Traslados de Presupuesto con Cuentas de Control Abierto --->
			<cfif isDefined("Form.hayCPresupuestoDeVersion") and Len(Trim(form.hayCPresupuestoDeVersion)) GT 0>
				<cfif isdefined("form.chkCPresupuestoDeVersion")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayCPresupuestoDeVersion eq "1">
					<cfset a = updateCuenta(541,valor)>
 				<cfelseif Form.hayCPresupuestoDeVersion eq "0">
					<cfset b = insertCuenta(541,'CM','Crear Cuentas de Presupuesto en la Versión de Formulación',valor)>
				</cfif>
			</cfif>

			<!--- Inicia:Permitir Formulación para cuentas de control abiertas negativas para meses anteriores--->
            <!---Cambio Realizado  Por: ***RVD, APH*** Fecha: 12/06/2013--->
			<cfif isDefined("Form.aceptaNeg") and Len(Trim(form.aceptaNeg)) GT 0>
				<cfif isdefined("form.chkCtasAbierNegat")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.aceptaNeg eq "1">
					<cfset a = updateCuenta(542,valor)>
 				<cfelseif Form.aceptaNeg eq "0">
					<cfset b = insertCuenta(542,'CP','Permitir Formulación Para Cuentas de Control Abierto Negativas para Meses Anteriores',valor)>
				</cfif>
			</cfif>
 			<!--- Termina: Permitir Formulación para cuentas de control abiertas negativas para meses anteriores--->

			<!--- Inicia: Validar Compromiso por Cuenta Presupuestal--->
            <!---Cambio Realizado  Por: ***RVD, APH*** Fecha: 12/06/2013--->
			<cfif isDefined("Form.validaXCP") and Len(Trim(form.validaXCP)) GT 0>
				<cfif isdefined("form.chkValidaXCPVal")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.validaXCP eq "1">
					<cfset a = updateCuenta(1131,valor)>
 				<cfelseif Form.validaXCP eq "0">
					<cfset b = insertCuenta(1131,'CP','Validar Compromiso por Agrupación de Cuentas Presupuestales',valor)>
				</cfif>
			</cfif>
 			<!--- Termina: Validar Compromiso por Cuenta Presupuestal--->

			<!--- Megs: Se agregan nuevo parámetros para Presupuesto --->
			<!--- Fecha: 10/08/2022 --->
			<!--- Inicia: Cuenta de Diferencial Cambiario para Multimoneda Ingreso--->
			<cfif isDefined("Form.hayCuentaDifCamMultiIngreso") and Len(Trim(form.hayCuentaDifCamMultiIngreso)) GT 0>
				<cfif form.hayCuentaDifCamMultiIngreso eq "1">
					<cfset a = updateCuenta(13600301,form.CFcuenta_CCuentaMultimonIngreso)>
 				<cfelseif Form.hayCuentaDifCamMultiIngreso eq "0">
					<cfset b = insertCuenta(13600301,'CP','Cuenta de Diferencial Cambiario para Multimoneda Ingreso',form.CFcuenta_CCuentaMultimonIngreso)>
				</cfif>
			</cfif>
 			<!--- Termina: Cuenta de Diferencial Cambiario para Multimoneda Ingreso--->
			
			<!--- Inicia: Cuenta de Diferencial Cambiario para Multimoneda Egreso--->
			<cfif isDefined("Form.hayCuentaDifCamMultiEgreso") and Len(Trim(form.hayCuentaDifCamMultiEgreso)) GT 0>
				<cfif form.hayCuentaDifCamMultiEgreso eq "1">
					<cfset a = updateCuenta(13600101,form.CFcuenta_CCuentaMultimonEgreso)>
 				<cfelseif Form.hayCuentaDifCamMultiEgreso eq "0">
					<cfset b = insertCuenta(13600101,'CP','Cuenta de Diferencial Cambiario para Multimoneda Egreso',form.CFcuenta_CCuentaMultimonEgreso)>
				</cfif>
			</cfif>
 			<!--- Termina: Cuenta de Diferencial Cambiario para Multimoneda Egreso--->

			<!--- Inicia: Cuenta de Diferencial Cambiario para Multimoneda Costo--->
			<cfif isDefined("Form.hayCuentaDifCamMultiCosto") and Len(Trim(form.hayCuentaDifCamMultiCosto)) GT 0>
				<cfif form.hayCuentaDifCamMultiCosto eq "1">
					<cfset a = updateCuenta(13600202,form.CFcuenta_CCuentaMultimonCosto)>
 				<cfelseif Form.hayCuentaDifCamMultiCosto eq "0">
					<cfset b = insertCuenta(13600202,'CP','Cuenta de Diferencial Cambiario para Multimoneda Costo',form.CFcuenta_CCuentaMultimonEgreso)>
				</cfif>
			</cfif>
 			<!--- Termina: Cuenta de Diferencial Cambiario para Multimoneda Egreso--->

			<!--- 1120. Permitir Cuentas con Tipo de Control Restringido y aprobación de NRPs--->
			<cfif isDefined("Form.hayCTCRestringigo") and Len(Trim(form.hayCTCRestringigo)) GT 0>
				<cfif isdefined("form.chkCTCRestringigo")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayCTCRestringigo eq "1">
					<cfset a = updateCuenta(1120,valor)>
 				<cfelseif Form.hayCTCRestringigo eq "0">
					<cfset b = insertCuenta(1120,'CP','Permitir Cuentas con Tipo de Control Restringido y aprobación de NRPs',valor)>
				</cfif>
			</cfif>

			<!--- 1121. Permitir Cuentas con Tipo de Control Restringido y aprobación de NRPs--->
			<cfif isDefined("Form.hayCPFnegativo") and Len(Trim(form.hayCPFnegativo)) GT 0>
				<cfif isdefined("form.chkCPFnegativo")>
					<cfset valor = ' '>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayCPFnegativo eq "1">
					<cfset a = updateCuenta(1121,valor)>
 				<cfelseif Form.hayCPFnegativo eq "0">
					<cfset b = insertCuenta(1121,'CP','Permitir Formulaciones Negativas',valor)>
				</cfif>
			</cfif>

        	<!---1130. Control Especial de Presupuesto para Asientos Retroactivos en el Período Contable inmediato Anterior ya Cerrados--->
			<cfif isDefined("Form.hayCPcontrolEspecial") and Len(Trim(form.hayCPcontrolEspecial)) GT 0>
				<cfparam name="form.cboCPcontrolEspecial" default="0">
				<cfif form.hayCPcontrolEspecial eq "1">
					<cfset a = updateCuenta(1130,form.cboCPcontrolEspecial)>
 				<cfelse>
					<cfset b = insertCuenta(1130,'CP','Control Especial de Presupuesto para Período Contable inmediato Anterior ya Cerrado',"0")>
				</cfif>
			</cfif>

        	<!---1132. Ejecutado No Contable: Excesos del Pagado contra el Ejecutado Contable --->
			<cfif isDefined("Form.hayCPCejecutadoNC") and Len(Trim(form.hayCPCejecutadoNC)) GT 0>
				<cfparam name="form.cboCPCejecutadoNC" default="0">
				<cfif form.hayCPCejecutadoNC eq "1">
					<cfset a = updateCuenta(1132,form.cboCPCejecutadoNC)>
 				<cfelse>
					<cfset b = insertCuenta(1132,'CP','Ejecutado No Contable',"0")>
				</cfif>
			</cfif>

            <!--- 1140. Genera contabilidad presupuestaria solo para México --->
			<cfif isDefined("Form.hayGCONpresupuestaria") and Len(Trim(form.hayGCONpresupuestaria)) GT 0>
				<cfif isdefined("form.chkGCONpresupuestaria")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayGCONpresupuestaria eq "1">
					<cfset a = updateCuenta(1140,valor)>
 				<cfelseif Form.hayGCONpresupuestaria eq "0">
					<cfset b = insertCuenta(1140,'CM','Generar Contabilidad Presupuestaria',valor)>
				</cfif>
			</cfif>

			<!--- 1150. Utilizar tipo de cambio de conversion para presupuesto --->
			<cfif isDefined("Form.hayTCPresupuesto") and Len(Trim(form.hayTCPresupuesto)) GT 0>
				<cfif isdefined("form.chkTCPresupuesto")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayTCPresupuesto eq "1">
					<cfset a = updateCuenta(1150,valor)>
 				<cfelseif Form.hayTCPresupuesto eq "0">
					<cfset b = insertCuenta(1150,'CP','Utilizar tipo de cambio para conversion en presupuesto',valor)>
				</cfif>
			</cfif>


			<!--- 520. Interfqz con RH --->
			<cfif isDefined("Form.hayNomina") and Len(Trim(form.hayNomina)) GT 0>
				<cfif isdefined("form.chkNomina")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayNomina eq "1">
					<cfset a = updateCuenta(520,valor)>
 				<cfelseif Form.hayNomina eq "0">
					<cfset b = insertCuenta(520,'CM','Integración con Recursos Humanos',valor)>
				</cfif>
			</cfif>

			<!--- 530. Nivel máximo de Clasificaciones de Artículos --->
			<cfif len(trim(Form.MaxNivelA)) eq 0><cfset nivelA = 1><cfelse><cfset nivelA = Form.MaxNivelA ></cfif>
			<cfif Form.hayNivelA EQ 1 >
				<cfset a = updateCuenta(530,nivelA)>
			<cfelse>
				<cfset b = insertCuenta(530,'CM','Nivel máximo de Clasificaciones de Artículos', nivelA)>
			</cfif>


			<!--- 535. Cantidad máxima de Proveedores a invitar al proceso de compra --->
			<cfif len(trim(Form.MaxCantPPC)) eq 0><cfset CantPPC = 1><cfelse><cfset CantPPC = Form.MaxCantPPC></cfif>
			<cfif Form.hayCantPPC EQ 1 >
				<cfset a = updateCuenta(535,CantPPC)>
			<cfelse>
				<cfset b = insertCuenta(535,'CM','Cantidad máxima de Proveedores a invitar al Proceso de Compra', CantPPC)>
			</cfif>


			<!--- 540. Nivel máximo de Clasificaciones de Servicios --->
			<cfif len(trim(Form.MaxNivelS)) eq 0><cfset nivelS = 1><cfelse><cfset nivelS = Form.MaxNivelS ></cfif>
			<cfif Form.hayNivelS EQ 1 >
				<cfset a = updateCuenta(540,nivelS)>
			<cfelse>
				<cfset b = insertCuenta(540,'CM','Nivel máximo de Clasificaciones de Servicios', nivelS)>
			</cfif>

			<!--- 545. Número Decimales para Precio Unitario --->
			<cfif isDefined("form.PrecioUdec")>
				<cfif isdefined("form.hayPrecioUdec") and form.hayPrecioUdec eq 1 >
					<cfset a = updateCuenta(545,form.PrecioUdec)>
 				<cfelse>
					<cfset b = insertCuenta(545,'CM','Número Decimales para Precio Unitario',form.PrecioUdec)>
				</cfif>
			</cfif>
			<!--- 546. Número Decimales del Precio Unitario visualizado en los reportes --->
			<cfif isDefined("form.PrecioUdecRPT")>
				<cfif isdefined("form.hayPrecioUdecRPT") and form.hayPrecioUdecRPT eq 1 >
					<cfset a = updateCuenta(546,form.PrecioUdecRPT)>
 				<cfelse>
					<cfset b = insertCuenta(546,'CM','Decimales de Precio Unitario en Reportes',form.PrecioUdecRPT)>
				</cfif>
			</cfif>
			<!--- 548. Tipo Control de Presupuesto en Compras: default Controlar el Consumo --->
			<cfif isDefined("form.CPcompras")>
				<cfif isdefined("form.hayCPcompras") and form.hayCPcompras eq 1 >
					<cfset a = updateCuenta(548,form.CPcompras)>
 				<cfelse>
					<cfset b = insertCuenta(548,'CM','Tipo Control Presupueto en Compras',form.CPcompras)>
				</cfif>
			</cfif>

			<!--- 550. Cuenta Contable de Intereses Corrientes --->
			<cfif Form.hayCorrientes eq 1>
				<cfset a = updateCuenta(550,form.CCorrientes)>
			<cfelse>
				<cfset b = insertCuenta(550,'CG','Cuenta Contables de Intereses Corrientes', form.CCorrientes)>
			</cfif>

            <!--- 555. Cuenta por Pagar a Notas de Credito --->
			<cfif Form.hayCNCredito eq 1>
				<cfset a = updateCuenta(555,form.CNCredito)>
			<cfelse>
				<cfset b = insertCuenta(555,'CN','Cuenta por Pagar a Notas de Credito', form.CNCredito)>
			</cfif>

			<!--- 560. Cuenta Contable de  de Intereses Moratorios --->
			<cfif Form.hayMoratorios eq 1>
				<cfset a = updateCuenta(560,form.CMoratorios)>
			<cfelse>
				<cfset b = insertCuenta(560,'CG','Cuenta Contables de Intereses Moratorios', form.CMoratorios)>
			</cfif>

            <!--- 565. Cuenta Transitoria para facturacion  --->
			<cfif Form.hayTransitoria eq 1>
				<cfset a = updateCuenta(565,form.CTransitoria)>
			<cfelse>
				<cfset b = insertCuenta(565,'CG','Cuenta Transitoria Comun para Facturacion', form.CTransitoria)>
			</cfif>

			<!--- 570. Publicacion de Cotizaciones --->
			<cfif isDefined("Form.hayPublicacion") and Len(Trim(form.hayPublicacion)) GT 0>
				<cfif isdefined("form.chkPublicar")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayPublicacion EQ "1">
					<cfset a = updateCuenta(570,valor)>
 				<cfelseif Form.hayPublicacion EQ "0">
					<cfset b = insertCuenta(570,'CM','Publicar Procesos de Compra',valor)>
				</cfif>
			</cfif>

            <!--- 575. Transaccion de Notas de Credito de Clientes  --->
			<cfif Form.hayTNCredito eq 1>
				<cfset a = updateCuenta(575,form.NC_CCTcodigo)>
			<cfelse>
				<cfset b = insertCuenta(575,'TN','Transaccion de Notas de Credito de Clientes', form.NC_CCTcodigo)>
			</cfif>

			<!--- 580. Jerarquia para aprobar  --->
			<cfif isDefined("Form.hayJerarquia") and Len(Trim(form.hayJerarquia)) GT 0>
				<cfif isdefined("form.chkJerarquia")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayJerarquia EQ "1">
					<cfset a = updateCuenta(580,valor)>
 				<cfelseif Form.hayJerarquia EQ "0">
					<cfset b = insertCuenta(580,'CM','Utiliza jerarquía para aprobar',valor)>
				</cfif>
			</cfif>

			<!--- 710. Validar para compras directas bienes en contratos --->
			<!--- Al estar activo impide la aplicacion de todas las solicitudes de
				  compra directa que incluyan bienes contenidos en un contrato vigente --->
			<cfif isDefined("Form.hayValidarCDC") and Len(Trim(form.hayValidarCDC)) GT 0>
				<cfif isdefined("form.chkValidarCDC")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayValidarCDC EQ "1">
					<cfset a = updateCuenta(710,valor)>
 				<cfelseif Form.hayValidarCDC EQ "0">
					<cfset b = insertCuenta(710,'CM','Validar para compras directas bienes en contratos',valor)>
				</cfif>
			</cfif>

			<!--- 4320. Utilizar Trámites para contratos de compra --->
			<!--- Al estar activo manda los contratos a los procesos de trámite --->
			<cfif isDefined("Form.hayTramitesContratos") and Len(Trim(form.hayTramitesContratos)) GT 0>
				<cfif isdefined("form.chkTramitesContratos")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayTramitesContratos EQ "1">
					<cfset a = updateCuenta(4320,valor)>
 				<cfelseif Form.hayTramitesContratos EQ "0">
					<cfset b = insertCuenta(4320,'CM','Utilizar Trámites para contratos de compra',valor)>
				</cfif>
			</cfif>

			<!--- 760. Habilitar la Aprobación de Excesos de Tolerancia para Documentos de Recepción --->
			<!--- Al estar activo, los documentos de recepción que tienen exceso por tolerancia
				  deben ser aprobados --->
			<cfif isDefined("Form.hayAprobarTolerancia") and Len(Trim(form.hayAprobarTolerancia)) GT 0>
				<cfif isdefined("form.chkAprobarTolerancia")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayAprobarTolerancia EQ "1">
					<cfset a = updateCuenta(760,valor)>
 				<cfelseif Form.hayAprobarTolerancia EQ "0">
					<cfset b = insertCuenta(760,'CM','Aprobación de Excesos de Tolerancia para Documentos de Recepción',valor)>
				</cfif>
			</cfif>

            <!--- 15651. Habilitar validacion para no permitir excesos para los Documentos de Recepción --->
			<!--- Al estar activo, los documentos de recepción validaran que la cantidad recibida no sea superior
					a la cantidad de la factura --->
			<cfif isDefined("Form.hayValidacionExcesos") and Len(Trim(form.hayValidacionExcesos)) GT 0>
				<cfif isdefined("form.chkNoExcesos")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayValidacionExcesos EQ "1">
					<cfset a = updateCuenta(15651,valor)>
 				<cfelseif Form.hayValidacionExcesos EQ "0">
					 <cfset b = insertCuenta(15651,'CM','Habilitar validacion para no permitir excesos en los Documentos de Recepcion',valor)>
				</cfif>
			</cfif>

			<!--- 770. Habilitar la Funcionalidad de Agrupación de Ordenes de Compra --->
			<cfif isDefined("Form.hayAgrupacionOrdenes") and Len(Trim(Form.hayAgrupacionOrdenes)) GT 0>
				<cfif isdefined("Form.chkAgrupacionOrdenes")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif Form.hayAgrupacionOrdenes EQ "1">
					<cfset a = updateCuenta(770, valor)>
 				<cfelseif Form.hayAgrupacionOrdenes EQ "0">
					<cfset b = insertCuenta(770, 'CM', 'Funcionalidad de Agrupación de Ordenes de Compra', valor)>
				</cfif>
			</cfif>

			<!--- 780. Frecuencia con la cual se realizará el proceso de agrupación de Ordenes de Compra --->
			<cfif isDefined("Form.hayFrecAgrupOC") and Len(Trim(Form.hayFrecAgrupOC)) GT 0>
				<cfif Form.hayFrecAgrupOC EQ "1">
					<cfset a = updateCuenta(780, Form.selFrecAgrupOC)>
 				<cfelseif Form.hayFrecAgrupOC EQ "0">
					<cfset b = insertCuenta(780,'CM','Frecuencia con la que se agruparán las OCs', Form.selFrecAgrupOC)>
				</cfif>
			</cfif>

			<!--- 790. Días de la semana en los cuales se ejecutará el proceso de agrupación de OCs, si el parámetro 780 es semanalmente --->
			<cfif isDefined("Form.hayDiasSemanaAgrupOC") and Len(Trim(Form.hayDiasSemanaAgrupOC)) GT 0>
				<cfset valor = ''>
				<cfif isDefined("Form.chkAgruparD")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparL")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparK")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparM")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparJ")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparV")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>
				<cfif isDefined("Form.chkAgruparS")>
					<cfset valor = valor & '1'>
				<cfelse>
					<cfset valor = valor & '0'>
				</cfif>

				<cfif Form.hayDiasSemanaAgrupOC EQ "1">
					<cfset a = updateCuenta(790, valor)>
 				<cfelseif Form.hayDiasSemanaAgrupOC EQ "0">
					<cfset b = insertCuenta(790,'CM','Días de la semana en que se agruparán las OCs', valor)>
				</cfif>
			</cfif>

			<!--- 800. Día del mes en el cual se ejecutará el proceso de agrupación de OCs, si el parámetro 780 es mensualmente --->
			<cfif isDefined("Form.hayDiaMesAgrupOC") and Len(Trim(Form.hayDiaMesAgrupOC)) GT 0>
				<cfif Form.hayDiaMesAgrupOC EQ "1">
					<cfset a = updateCuenta(800, Form.txtDiaMesAgrupOC)>
 				<cfelseif Form.hayDiaMesAgrupOC EQ "0">
					<cfset b = insertCuenta(800,'CM','Día del mes en que se agruparán las OCs', Form.txtDiaMesAgrupOC)>
				</cfif>
			</cfif>
			<!--- 810. Cuenta de diferencial cambiario --->
			<cfif isDefined("form.CCuentaDifCambAsi")>
				<cfif isdefined("form.hayCuentaDifCambAsi") and form.hayCuentaDifCambAsi eq 1 >
					<cfset a = updateCuenta(810,form.CFcuenta_CCuentaDifCambAsi)>
 				<cfelse>
					<cfset b = insertCuenta(810,'CG','Cuenta de diferencial cambiario',form.CFcuenta_CCuentaDifCambAsi)>
				</cfif>
			</cfif>
			<!--- 4500 Cuenta de diferencial cambiario para segunda conversión de estados --->
			<cfif isDefined("form.CCuentaDifCamb2")>
				<cfif isdefined("form.hayCuentaDifCamb2") and form.hayCuentaDifCamb2 eq 1 >
					<cfset a = updateCuenta(4500,form.CFcuenta_CCuentaDifCamb2)>
 				<cfelse>
					<cfset b = insertCuenta(4500,'CG','Cuenta de diferencial cambiario 2a Conversion',form.CFcuenta_CCuentaDifCamb2)>
				</cfif>
			</cfif>



			<!--- 720.  --->
			<!--- Al estar activo va a ser requerido ingresar un numero
				que va a ser la cantidad maxima de digitos permitidos para el campo de numero de los documentos de Recepcion --->
			<cfquery name="rsParamRevision" datasource="#Session.DSN#">
				select 1
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="720">
			</cfquery>

			<cfif isDefined("Form.chkRCDND")>
				<cfif isdefined("rsParamRevision") and rsParamRevision.recordCount GT 0>
					<cfset a = updateCuenta(720,form.RCDND)>
				<cfelse>
					<cfset b = insertCuenta(720,'CM','Restringir Cantidad de Dígitos en Número de Documentos de Compra',form.RCDND)>
				</cfif>
			<cfelse>
				<cfquery name="rsParamRevision" datasource="#Session.DSN#">
					update Parametros set Pvalor = null,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="720">
				</cfquery>
			</cfif>

			<!--- 730.  --->
			<!--- Al estar activo 	 --->
			<cfquery name="rsParamRevision" datasource="#Session.DSN#">
				select 1
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="730">
			</cfquery>

			<cfif isDefined("Form.chkmultiples")>
				<cfif isdefined("rsParamRevision") and rsParamRevision.recordCount GT 0>
					<cfset a = updateCuenta(730,form.chkmultiples)>
				<cfelse>
					<cfset b = insertCuenta(730,'CM','Multiples contratos simultaneamente para articulos o servicios',form.chkmultiples)>
				</cfif>
			<cfelse>
				<cfquery name="rsParamRevision" datasource="#Session.DSN#">
					update Parametros set Pvalor = null,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="730">
				</cfquery>
			</cfif>

			<!--- 590. Código de Transacción CxP a utilizar por Default --->
			<cfset CPTransInterfaz = '' >
			<cfif isdefined("Form.CPTransInterfaz") and Len(Trim(Form.CPTransInterfaz)) GT 0>
				<cfset CPTransInterfaz = Form.CPTransInterfaz >
			</cfif>
			<cfif isDefined("Form.hayTransaccionCPInterfaz") and Len(Trim(form.hayTransaccionCPInterfaz)) GT 0>
				<cfif Form.hayTransaccionCPInterfaz EQ "1">
					<cfset a = updateCuenta(590,CPTransInterfaz)>
 				<cfelseif Form.hayTransaccionCPInterfaz EQ "0" and Len(Trim(CPTransInterfaz)) GT 0>
					<cfset b = insertCuenta(590,'CP','Tipo de Transaccion CxP para Interfaces',CPTransInterfaz)>
				</cfif>
			</cfif>

			<!--- 600. Código de Transacción CxP a utilizar por Default --->
			<cfset CCTransInterfaz = '' >
			<cfif isdefined("Form.CCTransInterfaz") and Len(Trim(Form.CCTransInterfaz)) GT 0>
				<cfset CCTransInterfaz = Form.CCTransInterfaz >
			</cfif>
			<cfif isDefined("Form.hayTransaccionCCInterfaz") and Len(Trim(form.hayTransaccionCCInterfaz)) GT 0>
				<cfif Form.hayTransaccionCCInterfaz EQ "1">
					<cfset a = updateCuenta(600,CCTransInterfaz)>
 				<cfelseif Form.hayTransaccionCCInterfaz EQ "0" and Len(Trim(TransaccionCC)) GT 0>
					<cfset b = insertCuenta(600,'CC','Tipo de Transaccion CxC para Interfaces',CCTransInterfaz)>
				</cfif>
			</cfif>

			<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC --->

			<!--- 620.Formato de Cedula Juridica de Socio de Negocio --->
			<cfif isDefined("Form.hayFormatoCedulaJuridica") and Len(Trim(hayFormatoCedulaJuridica)) GT 0>
				<cfif isdefined('Form.NoModificar') and NoModificar EQ '0'>
					<cfif Form.hayFormatoCedulaJuridica EQ "1">
						<cfset a = updateCuenta(620,Form.mascaraCedJ)>
					<cfelseif Form.hayFormatoCedulaJuridica EQ "0">
						<cfset b = insertCuenta(620,'CC','Formato de Cedula Juridica de Socio de Negocio',Form.mascaraCedJ)>
					</cfif>
				</cfif>
			</cfif>

			<!--- 630.Formato de Cedula Fisica de Socio de Negocio --->
			<cfif isDefined("Form.hayFormatoCedulaFisica") and Len(Trim(hayFormatoCedulaFisica)) GT 0>
				<cfif isdefined('Form.NoModificar') and NoModificar EQ '0'>
					<cfif Form.hayFormatoCedulaFisica EQ "1">
						<cfset a = updateCuenta(630,Form.mascaraCedF)>
					<cfelseif Form.hayFormatoCedulaFisica EQ "0">
						<cfset b = insertCuenta(630,'CC','Formato de Cedula Fisica de Socio de Negocio',Form.mascaraCedF)>
					</cfif>
				</cfif>
			</cfif>

			<!--- 640.Formato de Cedula Extranjera de Socio de Negocio --->
			<cfif isDefined("Form.hayFormatoCedulaExtranjero") and Len(Trim(hayFormatoCedulaExtranjero)) GT 0>
				<cfif isdefined('Form.NoModificar') and NoModificar EQ '0'>
					<cfif Form.hayFormatoCedulaExtranjero EQ "1">
						<cfset a = updateCuenta(5600,Form.mascaraCedE)>
					<cfelseif Form.hayFormatoCedulaExtranjero EQ "0">
						<cfset b = insertCuenta(5600,'CC','Formato de Cedula Extranjera de Socio de Negocio',Form.mascaraCedE)>
					</cfif>
				</cfif>
			</cfif>

			<!--- 670.Fecha de Cierre de Contabilidad --->
			<cfif isDefined("Form.fechacierreConta") and Len(Trim(Form.hayFechaCierreConta)) GT 0>
				<cfif Form.hayFechaCierreConta EQ "1">
					<cfset a = updateCuenta(670,Form.fechacierreConta)>
				<cfelseif Form.hayFechaCierreConta EQ "0">
					<cfset b = insertCuenta(670,'CG','Fecha de Cierre de Contabilidad',Form.fechacierreConta)>
				</cfif>
			</cfif>

			<!--- 695.Fecha de Cierre de Contabilidad --->
			<cfif isDefined("Form.SNCEid") and Len(Trim(Form.SNCEid)) GT 0>
				<cfset cic = insertCuenta(695,'CC','Clasificación Reporte Consolidado Contable',Form.SNCEid)>
			</cfif>

			<!--- 700. Chequear Fecha de Cierre de Contabilidad --->
			<cfif Len(Trim(Form.hayCierreConta)) GT 0>
				<cfif isDefined("Form.chkcierreConta")>
					<cfset valor = "S">
				<cfelse>
					<cfset valor = "N">
				</cfif>
				<cfset a = insertCuenta(700,'CG','Validar Fecha de Asientos contra Periodo y Mes antes de Generar o Aplicar',valor)>
			</cfif>

			<!--- 680.Ver Clasificación Cuentas por Cobrar --->

			<cfif  isdefined("form.VerClasificaCC")>
				<cfif Form.hayVerClasifCC EQ 1>
					<cfset a = updateCuenta(680,1)>
				<cfelse>
					<cfset b = insertCuenta(680,'CC','Mostrar Clasificacion Cuentas por Cobrar',1)>
				</cfif>
			<cfelse>
				<cfif Form.hayVerClasifCC EQ 1>
					<cfset a = updateCuenta(680,0)>
				<cfelse>
					<cfset b = insertCuenta(680,'CC','Mostrar Clasificacion Cuentas por Cobrar',0)>
				</cfif>
			</cfif>


			<!--- 680.Ver Clasificación Cuentas por Pagar --->

			<cfif  isdefined("form.VerClasificaCP")>
				<cfset a = updateCuenta(690,1)>
			<cfelse>
				<cfset b = insertCuenta(690,'CP','Mostrar Clasificacion Cuentas por Pagar',0)>
			</cfif>

			<cfparam name="Form.origenmb" default="" >
			<cfif isDefined("Form.hayMBOrigen") and Len(Trim(form.hayMBOrigen)) GT 0>
				<cfif Form.hayMBOrigen EQ "1">
					<cfset a = updateCuenta(160,Form.origenmb)>
 				<cfelseif Form.hayMBOrigen EQ "0" and Len(Trim(Form.origenmb)) GT 0>
					<cfset b = insertCuenta(160,'MB','Tipo de movimiento origen para transferencias bancarias',Form.origenmb)>
				</cfif>
			</cfif>

			<cfparam name="Form.destinomb" default="" >
			<cfif isDefined("Form.hayMBDestino") and Len(Trim(form.hayMBdestino)) GT 0>
				<cfif Form.hayMBdestino EQ "1">
					<cfset a = updateCuenta(170,Form.destinomb)>
 				<cfelseif Form.hayMBdestino EQ "0" and Len(Trim(Form.destinomb)) GT 0>
					<cfset b = insertCuenta(170,'MB','Tipo de movimiento destino para transferencias bancarias',Form.destinomb)>
				</cfif>
			</cfif>

			<!--- 13600801.  --->
			<cfif isDefined("Form.PresMultCHK")>		

				<cfif isdefined("form.PresMultim") and Len(Trim(form.PresMultim)) GT 0>			
					<cfset valor = '1'>
				<cfelse>					
					<cfset valor = '0'>
				</cfif>				
				<cfif isdefined("form.PresMultCHK") and  form.PresMultCHK GT 0>						
					<cfset a = updateCuenta(13600801,valor)>
 				<cfelseif Form.PresMultCHK EQ "0" and valor eq 1>
					<cfset b = insertCuenta(13600801,'PRE','IE928 PresMultimoneda',valor)>
				</cfif>
			</cfif>

			<!--- 14200801.  ALG--->
			<cfif isDefined("Form.ECOrdenCHK")>		

				<cfif isdefined("form.ECOrden") and Len(Trim(form.ECOrden)) GT 0>			
					<cfset valor = '1'>
				<cfelse>					
					<cfset valor = '0'>
				</cfif>				
				<cfif isdefined("form.ECOrdenCHK") and  form.ECOrdenCHK GT 0>						
					<cfset a = updateCuenta(14200801,valor)>
 				<cfelseif Form.ECOrdenCHK EQ "0" and valor eq 1>
					<cfset b = insertCuenta(14200801,'TES','Emision/Cancelación de Ordenes de Pago',valor)>
				</cfif>
			</cfif>

			<!--- 14200802  ALG (Parametro para fuentes tesaplicacion y pres_presupuesto de cim--->
			<cfif isDefined("Form.ParamCimCHK")>		

				<cfif isdefined("form.ParamCim") and Len(Trim(form.ParamCim)) GT 0>			
					<cfset valor = '1'>
				<cfelse>					
					<cfset valor = '0'>
				</cfif>				
				<cfif isdefined("form.ParamCimCHK") and  form.ParamCimCHK GT 0>						
					<cfset a = updateCuenta(14200802,valor)>
 				<cfelseif Form.ParamCimCHK EQ "0" and valor eq 1>
					<cfset b = insertCuenta(14200802,'TES','Parametro CIM TES',valor)>
				</cfif>
			</cfif>

            <!----1360 UTILIZAR LA CUENTA DE GASTO POR DEPRECIACION CONFIGURADA EN LA CLASIFICACIÓN DE ACTIVO---->
			<cfif not isdefined("Form.UtilCtaTrans")>
				<cfset UtilCtaTrans = ''>
			<cfelse>
				<cfset UtilCtaTrans = Form.UtilCtaTrans >
			</cfif>
			<cfif UtilCtaTrans NEQ ''>
				<cfset a = insertCuenta(200030,'MB','Utilizar cuenta en Transacción del Socio de Negocios para Movimientos Bancarios', 1)>
			<cfelse>
				<cfset a = insertCuenta(200030,'MB','Utilizar cuenta en Transacción del Socio de Negocios para Movimientos Bancarios', 0)>
			</cfif>

 		 <!---Movimientos Bancarios con Flujo de Efecto--->
			<cfif not isdefined("Form.MovFlujoEfectivo")>
				<cfset MovFlujoEfectivo = ''>
			<cfelse>
				<cfset MovFlujoEfectivo = Form.MovFlujoEfectivo >
			</cfif>
			<cfif MovFlujoEfectivo NEQ ''>
				<cfset a = insertCuenta(200035,'MB','Movimientos Bancarios con Flujo de Efectivo', 1)>
			<cfelse>
				<cfset a = insertCuenta(200035,'MB','Movimientos Bancarios con Flujo de Efectivo', 0)>
			</cfif>
			<!--- ================================================================================================================== --->
			<!--- Parametros de reportes de Compras --->
			<!--- ================================================================================================================== --->
			<cfif isDefined("Form.hayRepCotProveedoresLocal") and Len(Trim(form.hayRepCotProveedoresLocal)) GT 0>
				<cfif Form.hayRepCotProveedoresLocal EQ 1>
					<cfset a = updateCuenta(820, Form.repCotTipo1)>
 				<cfelse>
					<cfset b = insertCuenta(820, 'CM', 'Imprimir cotización de proveedores local', Form.repCotTipo1)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayRepCotProveedoresImportacion") and Len(Trim(form.hayRepCotProveedoresImportacion)) GT 0>
				<cfif Form.hayRepCotProveedoresImportacion EQ 1>
					<cfset a = updateCuenta(830, Form.repCotTipo2)>
 				<cfelse>
					<cfset b = insertCuenta(830, 'CM', 'Imprimir cotización de proveedores importacion', Form.repCotTipo2)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayRepCotProcesoLocal") and Len(Trim(form.hayRepCotProcesoLocal)) GT 0>
				<cfif Form.hayRepCotProcesoLocal EQ 1>
					<cfset a = updateCuenta(840, Form.repCotTipo3)>
 				<cfelse>
					<cfset b = insertCuenta(840, 'CM', 'Imprimir cotización del proceso local', Form.repCotTipo3)>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayRepCotProcesoImportacion") and Len(Trim(form.hayRepCotProcesoImportacion)) GT 0>
				<cfif Form.hayRepCotProcesoImportacion EQ 1>
					<cfset a = updateCuenta(850, Form.repCotTipo4)>
 				<cfelse>
					<cfset b = insertCuenta(850, 'CM', 'Imprimir cotización del proceso importación', Form.repCotTipo4)>
				</cfif>
			</cfif>
			<!--- ================================================================================================================== --->
			<!--- ================================================================================================================== --->

			<!--- Parametros de Compras  --->
			<cfif isDefined("Form.hayRolSolic") and Len(Trim(form.hayRolSolic)) GT 0>
				<cfif isdefined("Form.rolsolic")>
					<cfif Form.hayRolSolic EQ 1>
						<cfset a = updateCuenta(860, Form.rolsolic)>
					<cfelse>
						<cfset b = insertCuenta(860, 'CM', 'Rol default para Solicitantes', Form.rolsolic)>
					</cfif>
				</cfif>
			</cfif>
			<cfif isDefined("Form.hayRolComprador") and Len(Trim(form.hayRolComprador)) GT 0>
				<cfif isdefined("Form.rolcomprador")>
					<cfif Form.hayRolComprador EQ 1>
						<cfset a = updateCuenta(870, Form.rolcomprador)>
					<cfelse>
						<cfset b = insertCuenta(870, 'CM', 'Rol default para Compradores', Form.rolcomprador)>
					</cfif>
				</cfif>
			</cfif>

			<cfif isdefined("form.chkCorreoAprobador")>
				<cfset valor = '1'>
			<cfelse>
				<cfset valor = '0'>
			</cfif>
			<cfset a = insertCuenta(735,'CM','Envio de correo al aprobador (traslado de Presupuesto)',valor)>

			<!--- 880. Permitir el mismo documento recurrente para varias facturas en un mismo período y mes --->
			<cfif isdefined("Form.chkRecurrentes")>
				<cfset valor = '1'>
			<cfelse>
				<cfset valor = '0'>
			</cfif>
			<cfif Form.hayRecurrentes EQ "1">
				<cfset a = updateCuenta(880, valor)>
			<cfelseif Form.hayRecurrentes EQ "0">
				<cfset b = insertCuenta(880, 'CP', 'No permitir el mismo doc. recurrente para varias fac. en un mismo período y mes', valor)>
			</cfif>


            <!--- 891. Mostrar Cuenta Contable en Detalles de Registro Factura --->
			<cfif isdefined("Form.chkCCRegistroFacturas")>
				<cfset valor = '1'>
			<cfelse>
				<cfset valor = '0'>
			</cfif>
			<cfset a = insertCuenta(891, 'CP', 'Mostrar Cuenta Contable en Detalles de Registro Factura', valor)>


			<!--- 900 --->
			<!--- no se actualiza--->

			<!--- 910 --->
			<cfif isdefined("form.p910") and len(trim(form.p910)) gt 0>
			<cfset insertCuenta(910,'AF','Tipo de Documento para Vales de Adqusición',form.p910)>
			</cfif>

			<!--- 920.Leyenda para Balance General y Estado de Resultados --->
			<cfif isDefined("Form.hayLeyenda") and Len(Trim(hayLeyenda)) GT 0>
				<cfif Form.hayLeyenda EQ "1">
					<cfset a = updateCuenta(920,Form.verLeyenda)>
				<cfelseif Form.hayLeyenda EQ "0">
					<cfset b = insertCuenta(920,'CG','Leyenda para Balance General y Estado de Resultados',Form.verLeyenda)>
				</cfif>
			</cfif>

            <!--- 921.Leyenda para Estados de Cuenta de CxC --->
			<cfif isDefined("Form.hayLeyendaCxC") and Len(Trim(hayLeyendaCxC)) GT 0>
				<cfif Form.hayLeyendaCxC EQ "1">
					<cfset a = updateCuenta(921,Form.verLeyendaCxC)>
				<cfelseif Form.hayLeyendaCxC EQ "0">
					<cfset b = insertCuenta(921,'CC','Leyenda para Estados de Cuenta de CxC',Form.verLeyendaCxC)>
				</cfif>
			</cfif>

			<!--- 2930.Transaccion de Pago para Cancelacion de Documentos --->
			<cfif isDefined("Form.hayTPCancelacion") and Len(Trim(hayTPCancelacion)) GT 0>
				<cfif Form.hayTPCancelacion EQ 1>
					<cfset a = updateCuenta(2930,Form.TPC_CCTcodigo)>
				<cfelseif Form.hayTPCancelacion EQ 0>
					<cfset b = insertCuenta(2930,'CC','Transaccion de Pago para Cancelacion de Documentos',Form.TPC_CCTcodigo)>
				</cfif>
			</cfif>

			<!--- 930.Mostrar el Asiento de depreciación detallado --->

			<cfif  isdefined("form.VerAstDet")>
				<cfset a = updateCuenta(930,1)>
			<cfelse>
				<cfset b = insertCuenta(930,'AF','Mostrar el Asiento de depreciación detallado',0)>
			</cfif>

			<!--- 940.Meses para calcular Fecha de Inicio de Depresiación --->
			<cfif isdefined("form.cbomesesdep")>
				<cfset insertCuenta(940,'AF','Meses para calcular Fecha de Inicio de Depresiacion',form.cbomesesdep)>
			</cfif>

			<!--- 950.Meses para calcular Fecha de Inicio de Revaluación --->
			<cfif isdefined("form.cbomesesrev")>
				<cfset insertCuenta(950,'AF','Meses para calcular Fecha de Inicio de Revaluacion',form.cbomesesrev)>
			</cfif>

			<!--- 930.Mostrar el Asiento de depreciación detallado --->

			<cfif  isdefined("form.RetAuto")>
				<cfset a = updateCuenta(960,1)>
			<cfelse>
				<cfset b = insertCuenta(960,'AF','Aplicar Retiros de forma automática',0)>
			</cfif>

			<!--- 990.Traspasos de documentos en autogestion autorizados por el jefe del Centro de Custodia --->

			<cfif  isdefined("form.AutorizacionCustodia")>
				<cfset a = updateCuenta(990,1)>
			<cfelse>
				<cfset b = insertCuenta(990,'AF','Traspasos de documentos en autogestion autorizados por el jefe del Centro de Cus',0)>
			</cfif>

			<!--- 1110.Etiqueta "Origen" de los Vales --->
			<cfif len(trim(Form.Origen)) eq 0><cfset OrigenA = ''><cfelse><cfset OrigenA = Form.Origen ></cfif>
			<cfif Form.Origen NEQ '' >
				<cfset a = updateCuenta(1110,OrigenA)>
			<cfelse>
				<cfset b = insertCuenta(1110,'AF','Etiqueta Origen de los Vales', OrigenA)>
			</cfif>

			<!--- 1300.NO Permitir Vales por Mejora de Activos Fijos --->

			<cfif not isdefined("Form.ValesMejora")>
				<cfset ValesMejora = ''>
			<cfelse>
				<cfset ValesMejora = Form.ValesMejora >
			</cfif>
			<cfif ValesMejora NEQ '' >
				<cfset a = insertCuenta(1300,'AF','NO Permitir Vales por Mejora de Activos Fijos', 1)>
			<cfelse>
				<cfset b = insertCuenta(1300,'AF','NO Permitir Vales por Mejora de Activos Fijos', 0)>
			</cfif>
<!---Control de Evento Inicia--->
            <!--- 1350. Habilita Control de Evento --->
			<cfif isDefined("Form.hayControlEvento") and len(trim(form.hayControlEvento)) GT 0>
				<cfif isdefined("form.chkControlEvento")>
					<cfset valor = 'S'>
				<cfelse>
					<cfset valor = 'N'>
				</cfif>
				<cfif form.hayControlEvento eq 1>
					<cfset a = updateCuenta(1350,valor)>
 				<cfelseif Form.hayControlEvento eq 0>
					<cfset b = insertCuenta(1350,'EV','Habilitar Control Evento',valor)>
				</cfif>
			</cfif>
<!---Control de Evento Fin--->
			<!--- 3800.Usar Boletas de Traslado --->

			<cfif not isdefined("Form.BoletaTras")>
				<cfset BoletaTras = ''>
			<cfelse>
				<cfset BoletaTras = Form.BoletaTras >
			</cfif>
			<cfif BoletaTras NEQ '' >
				<cfset a = insertCuenta(3800,'AF','Usar Boleta de traslado', 1)>
			<cfelse>
				<cfset b = insertCuenta(3800,'AF','Usar Boleta de traslado', 0)>
			</cfif>

            <!--- 3805.Fecha de Adquisición igual a la fecha del encabezado de la factura de CxP --->

			<cfif not isdefined("Form.FechaAdquisicion")>
				<cfset FechaAdquisicion = ''>
			<cfelse>
				<cfset FechaAdquisicion = Form.FechaAdquisicion>
			</cfif>
			<cfif FechaAdquisicion NEQ '' >
				<cfset a = insertCuenta(3805,'AF','Fecha de Adquisición igual a la fecha del encabezado de la factura de CxP', 1)>
			<cfelse>
				<cfset b = insertCuenta(3805,'AF','Fecha de Adquisición igual a la fecha del encabezado de la factura de CxP', 0)>
			</cfif>

			<!--- 4400.Realiza traslado directo si el empleado que traslada es el encargado --->

			<cfif not isdefined("Form.TraslDirecto")>
				<cfset TraslDirecto = ''>
			<cfelse>
				<cfset TraslDirecto = Form.TraslDirecto>
			</cfif>
			<cfif TraslDirecto NEQ '' >
				<cfset a = insertCuenta(4400,'AF','Realiza traslado directo si el empleado que traslada es el encargado de Centro de Custodia (Autogesti&oacute;n)', 1)>
			<cfelse>
				<cfset b = insertCuenta(4400,'AF','Realiza traslado directo si el empleado que traslada es el encargado de Centro de Custodia (Autogesti&oacute;n)', 0)>
			</cfif>


            <!--- 4401.Formato de Cedula Fisica de Catalo de Activos Fijos --->
			<cfif isDefined("Form.hayFormatoCedulaActFijo") and Len(Trim(hayFormatoCedulaActFijo)) GT 0>
				<!---<cfif isdefined('Form.NoModificar') and NoModificar EQ '0'>--->
					<cfif Form.hayFormatoCedulaActFijo EQ "1">
						<cfset a = updateCuenta(4401,Form.mascaraCedActFijo)>
					<cfelseif Form.hayFormatoCedulaActFijo EQ "0">
						<cfset b = insertCuenta(4401,'AF','Formato de Cedula de Catálogo de AF',Form.mascaraCedActFijo)>
					</cfif>
				<!---</cfif>--->
			</cfif>

            <!----200020 CUENTA DE IMPUESTOS PARA RETIRO DE ACTIVOS---->
			<cfif not isdefined("Form.cboImpuestoTipo")>
				<cfset ImpuestoTipo = 1>
			<cfelse>
				<cfset ImpuestoTipo = Form.cboImpuestoTipo>
			</cfif>
			<cfif ImpuestoTipo NEQ '' >
				<cfset a = insertCuenta(200020,'AF','Cuenta de Impuesto para Retiro de Activos', Form.cboImpuestoTipo)>
			<cfelse>
				<cfset a = insertCuenta(200020,'AF','Cuenta de Impuesto para Retiro de Activos', 1)>
			</cfif>

            <!---200050 GENERAR MASCARA AUTOMATICA SML 25/02/2014--->
            <cfif isdefined("Form.chkAFconsecutivo")>
				<cfset PlacaAut = 1>
			<cfelse>
				<cfset PlacaAut = 0>
			</cfif>
			<cfset a = insertCuenta(200050,'AF','Generar Placa Automatico', PlacaAut)>

            <!---200060 GENERAR PLACA AUTOMATICA SML 25/02/2014--->
           <!--- <cf_dump var = "#form#">--->
            <cfif isdefined("Form.hdTipoPlaca") and Form.hdTipoPlaca NEQ ''>
				<cfset TipoPlaca = #Form.hdTipoPlaca#>
                <cfset a = insertCuenta(200060,'AF','Generar Placa Automatico Por', TipoPlaca)>
			<cfelse>
				<cfset b = insertCuenta(200060,'AF','Generar Placa Automatico Por', null) >
			</cfif>

			<!--- Activo Fijo Genera Polisa en el importador del AF  --->

			<cfif not isdefined("Form.chkPoliIAF")>
				<cfset chkPoliIAF = ''>
			<cfelse>
				<cfset chkPoliIAF = Form.chkPoliIAF>
			</cfif>

			<cfif chkPoliIAF NEQ '' >
				<cfset a = insertCuenta(200070,'AF','Genera poliza en el importador de Activo Fijo', 1)>
			<cfelse>
				<cfset b = insertCuenta(200070,'AF','Genera poliza en el importador de Activo Fijo', 0)>
			</cfif>

			<!---- Registro de Activo Fijo por Moneda Origen --->
			<cfif not isdefined("Form.chkAFMO")>
				<cfset chkAFMO = ''>
			<cfelse>
				<cfset chkAFMO = Form.chkAFMO>
			</cfif>

			<cfif chkAFMO NEQ '' >
				<cfset a = insertCuenta(4403,'AF','Registro de Activo Fijo por Moneda Origen', 1)>
			<cfelse>
				<cfset b = insertCuenta(4403,'AF','Registro de Activo Fijo por Moneda Origen', 0)>
			</cfif>

			<!--- 4402.Realiza traslado directo si el empleado que traslada es el encargado desde Control de Responsables--->

			<cfif not isdefined("Form.TraslDirectoCR")>
				<cfset TraslDirectoCR = ''>
			<cfelse>
				<cfset TraslDirectoCR = Form.TraslDirectoCR >
			</cfif>
			<cfif TraslDirectoCR NEQ '' >
				<cfset a = insertCuenta(4402,'AF','Realiza traslado directo si el empleado que traslada es el encargado de Centro de Custodia (Control de Responsables)', 1)>
			<cfelse>
				<cfset b = insertCuenta(4402,'AF','Realiza traslado directo si el empleado que traslada es el encargado de Centro de Custodia (Control de Responsables)', 0)>
			</cfif>

            <!----1360 UTILIZAR LA CUENTA DE GASTO POR DEPRECIACION CONFIGURADA EN LA CLASIFICACIÓN DE ACTIVO---->
			<cfif not isdefined("Form.UtilCtaGastoDep")>
				<cfset UtilCtaGastoDep = ''>
			<cfelse>
				<cfset UtilCtaGastoDep = Form.UtilCtaGastoDep >
			</cfif>
			<cfif UtilCtaGastoDep NEQ '' >
				<cfset a = insertCuenta(1360,'AF','Utilizar la cuenta de Gasto por Depreciación configurada en la Clasificación de Activo', 1)>
			<cfelse>
				<cfset b = insertCuenta(1360,'AF','Utilizar la cuenta de Gasto por Depreciación configurada en la Clasificación de Activo:', 0)>
			</cfif>

			<!----1370 COMPLEMENTO DEFAULT DEL SOCIO DE NEGOCIO---->
			<cfif not isdefined("Form.ComplemSN")>
				<cfset ComDefaultSN = ''>
			<cfelse>
				<cfset ComDefaultSN = Form.ComplemSN >
			</cfif>

			<cfset a = insertCuenta(1370,'CP','Complemento Default para el Socio de Negocio', ComDefaultSN)>

			<!----1380 CLASIFICACIÓN DE GASTO PARA CUENTAS DE ORDEN---->
			<cfif not isdefined("Form.PCEcatid")>
				<cfset PCEcatid = ''>
			<cfelse>
				<cfset PCEcatid = Form.PCEcatid >
			</cfif>

			<cfset a = insertCuenta(1380,'CP','Clasificador de Gasto para Cuentas de Orden', PCEcatid)>

			<!----13600201 Catalogo para Proyecto---->
			<cfif not isdefined("Form.PCEcatid")>
				<cfset PCEcatidP = ''>
			<cfelse>
				<cfset PCEcatidP = Form.PCEcatidP >
			</cfif>

			<cfset a = insertCuenta(13600201,'CP','Clasificador de Proyecto', PCEcatidP)>
			
			<!----1381 URL WebService Lista Negra ---->			
			<cfif not isdefined("Form.urlLN")>
				<cfset urlLN = ''>
			<cfelse>
				<cfset urlLN = Form.urlLN >
			</cfif>

			<cfset insertCuenta(1381,'CP','Web Service Lista Negra',urlLN)>

			<!----1382 RFC Cliente Konesh ---->			
			<cfif not isdefined("Form.RFCCK")>
				<cfset RFCCK = ''>
			<cfelse>
				<cfset RFCCK = Form.RFCCK >
			</cfif>

			<cfset insertCuenta(1382,'CP','RFC Cliente Konesh',RFCCK)>

			<cfparam name="form.chkListaNegra" default="0" >
			<cfset insertCuenta(1383,'CP','Función de Lista Negra.',form.chkListaNegra)>

			<!---PARAMETRO 1600: CONSIDERAR TRASLADOS, RETIROS Y REVALUACIÓNES DEL ÚLTIMO PERIODO PARA LA REVALUACIÓN--->
			<cfif not isdefined("Form.ProRev")>
				<cfset a = insertCuenta(1600,'AF','Considerar traslados, retiros y Revaluaciónes del último periodo para la Revaluación', 0)>
			<cfelse>
				<cfset b = insertCuenta(1600,'AF','Considerar traslados, retiros y Revaluaciónes del último periodo para la Revaluación', 1)>
			</cfif>

            <!--- 447 --->
			<cfif isdefined("form.p447") and len(trim(form.p447)) gt 0>
			<cfset insertCuenta(447,'QP','Moneda de la Cuenta de Saldos',form.p447)>
			</cfif>

			<!--- 1800 Peaje, Tipo de transacción bancaria para los depósitos de Peaje --->
			<cfif isdefined("form.BTid") and len(trim(form.BTid)) gt 0>
				<cfif isdefined("form.hayValorTipoTransPeaje")  and len(trim(form.hayValorTipoTransPeaje)) gt 0>
					<cfset a = updateCuenta(1800, form.BTid)>
				<cfelse>
					<cfset b = insertCuenta(1800,'PE', 'Tipo de transacción bancaria para los depósitos de Peaje', form.BTid)>
				</cfif>
			</cfif>

			<!--- 1801 Actividad Empresarial --->
			<cfif isdefined("form.CFCOMPLEMENTO_ALLID") and len(trim(form.CFCOMPLEMENTO_ALLID)) gt 0>
				<cfif isdefined("form.hayValorActividadEmpresarial")  and len(trim(form.hayValorActividadEmpresarial)) gt 0>
					<cfset a = updateCuenta(1801, form.CFCOMPLEMENTO_ALLID)>
				<cfelse>
					<cfset b = insertCuenta(1801,'PE', 'Actividad Empresarial', form.CFCOMPLEMENTO_ALLID)>
				</cfif>
			</cfif>

			<!--- 1804 Cuenta de peaje para movimientos --->
			<cfif isdefined("form.CBid") and len(trim(form.CBid)) gt 0>
				<cfif isdefined("form.hayCuentaMovPeaje")  and len(trim(form.hayCuentaMovPeaje)) gt 0>
					<cfset a = updateCuenta(1804, form.CBid)>
				<cfelse>
					<cfset b = insertCuenta(1804,'PE', 'Cuenta bancaria para movimientos de peaje', form.CBid)>
				</cfif>
			</cfif>

			<!--- 1803 Actividad Empresarial - Formato --->
			<cfif isdefined("form.CFCOMPLEMENTO_ALL") and len(trim(form.CFCOMPLEMENTO_ALL)) gt 0>
				<cfif isdefined("form.hayValorActividadEmpresarialFormato")  and len(trim(form.hayValorActividadEmpresarialFormato)) gt 0>
					<cfset a = updateCuenta(1803, form.CFCOMPLEMENTO_ALLID)>
				<cfelse>
					<cfset b = insertCuenta(1803,'PE', 'Actividad Empresarial Formato', form.CFCOMPLEMENTO_ALL)>
				</cfif>
			</cfif>

			<!--- 1802 Concepto de Ingreso --->
			<cfif isdefined("form.FPCID_ALL") and len(trim(form.FPCID_ALL)) gt 0>
				<cfif isdefined("form.hayValorConceptoIngreso")  and len(trim(form.hayValorConceptoIngreso)) gt 0>
					<cfset a = updateCuenta(1802, form.FPCID_ALL)>
				<cfelse>
					<cfset b = insertCuenta(1802,'PE', 'Concepto de Ingreso', form.FPCID_ALL)>
				</cfif>
			</cfif>

			<!--- 4200 Categoría Informática --->
			<cfif isdefined("form.ACcodigo_ALL") <!---and len(trim(form.ACcodigo_ALL)) gt 0--->>
				<cfif isdefined("form.hayCategoria")  and len(trim(form.hayCategoria)) gt 0>
					<cfset a = updateCuenta(4200, form.FPCID_ALL)>
				<cfelse>
					<cfset b = insertCuenta(4200,'CI', 'Categoría Informática', form.ACcodigo_ALL)>
				</cfif>
			</cfif>

            <!--- 1810 Garantía: Transacción Depósito  --->
			<cfif isdefined("form.BTidGarantia") and len(trim(form.BTidGarantia)) gt 0>
            	<!--- Solo se invoca la funcion de insertar ya que esta verifica si ya existe el parametro, si ya exite lo actualiza y si no lo inserta --->
				<cfset LvarBTidGarantia = insertCuenta(1810,'GA', 'Transacción bancaria para los depósitos de Garantía', form.BTidGarantia)>
			</cfif>


			<!--- 2000  Tipo de Movimiento Bancario Pago de Renta--->
			<cfif isdefined("form.BTidPR") and len(trim(form.BTidPR)) gt 0>
				<cfif isdefined("form.hayValorTipoMovPagoRenta")  and len(trim(form.hayValorTipoMovPagoRenta)) gt 0>
					<cfset a = updateCuenta(2000, form.BTidPR)>
				<cfelse>
					<cfset b = insertCuenta(2000,'PR', 'Tipo de Movimiento Bancario Pago Renta', form.BTidPR)>
				</cfif>
			</cfif>

		<!--- 2400 Aplicar Asientos Importados Automáticamente--->
		   <cfif  isdefined("form.AsientosAutom")>
				<cfset a = updateCuenta(2400,1)>
			<cfelse>
				<cfset b = insertCuenta(2400,'CG','Aplicar Asientos Importados Automáticamente',0)>
			</cfif>

		<!--- 2500.Orden de las cuentas para Anticipos(CXP/CXC) --->

		<!--- 2600.Cuenta de ingreso por Financiamiento --->
			<cfif isdefined("form.CFcuentaFinanciamiento")>
				<cfset insertCuenta(2600,'PC','Cuenta de Ingreso por Financiamiento',form.CFcuentaFinanciamiento)>
			</cfif>

		<!--- 2800.Cuenta de Egresos por Amortización de préstamos --->
			<cfif isdefined("form.CFcuentacAmortizacion")>
				<cfset insertCuenta(2800,'PC','Cuenta de Egresos por Amortización de Préstamos',form.CFcuentacAmortizacion)>
			</cfif>

		<!---Codigo 2920: Incluir el Socio de Negocios en las Lineas de la Poliza Contable para CXC y CXP--->
			<cfparam name="form.SNPoliza" default="0" >
			<cfset insertCuenta(2920,'CC','Incluir Socio de Negocios en las líneas de la póliza Contable',form.SNPoliza)>


			<!--- 2900  Oficina para estimación interfaz 307--->
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo)) gt 0>
				<cfif isdefined("form.hayValorOficina")  and len(trim(form.hayValorOficina)) gt 0>
					<cfset a = updateCuenta(2900, form.Ocodigo)>
				<cfelse>
					<cfset b = insertCuenta(2900,'OF', 'Oficina', form.Ocodigo)>
				</cfif>
			</cfif>

			<!--- 2910  Tipo de Transacción para Estimación de Avance--->
			<cfif isdefined("form.Transaccion") and len(trim(form.Transaccion)) gt 0>
				<cfif isdefined("form.hayValorTransaccion")  and len(trim(form.hayValorTransaccion)) gt 0>
					<cfset a = updateCuenta(2910, form.Transaccion)>
				<cfelse>
					<cfset b = insertCuenta(2910,'TR', 'Transaccion', form.Transaccion)>
				</cfif>
			</cfif>

			<cfparam name="form.configNoMej" default="0" >
			<cfset insertCuenta(3100,'AF','Activar Configuración "No permite mejoras o adiciones"',form.configNoMej)>

            <cfset insertCuenta(3600,'CG','Cuenta de Diferencial Cambiario Primera conversión de estados B15',form.CFcuenta_B15PCcuenta)>
            <cfset insertCuenta(3700,'CG','Cuenta de Diferencial Cambiario segunda conversión de estados B15',form.CFcuenta_B15SCcuenta)>

            <cfset insertCuenta(4000,'CG','Cuenta de Fluctuación Cambiaria',form.Cmayor)>

			<!--- SML Inicia 14032016 Cuenta especial de comportamiento “tipo multimoneda” --->
			<cfset insertCuenta(4900,'CG','Cuenta tipo multimoneda',form.CmayorTipoMoneda)>

            <cfparam name="form.chkContExisSol" default="0" >
			<cfset insertCuenta(4100,'CM','Controlar existencias de artículos en solicitudes de requisición',form.chkContExisSol)>

            <cfparam name="form.chkUtilAuto" default="0" >
			<cfset insertCuenta(15500,'TR','Utiliza Gestión de Autorizaciones',form.chkUtilAuto)>

			<cfparam name="form.chkDesReservSC" default="0" >
			<cfset insertCuenta(4300,'CM','Desreservar Presupuesto si la Orden de Compra no cubre el total de la Solicitud (Plan Compras)',form.chkDesReservSC)>

            <cfparam name="form.chkEmpresaRequis" default="0" >
			<cfset insertCuenta(5310,'IV',' Agregar Identificación Representante de la empresa a las requisiciones cuando se usa Proveeduría Corporativa',form.chkEmpresaRequis)>

			<!--- 4310.Modifica Orden de Compra x Solicitud de Compra Directa o Proceso de Compra--->
			<cfif not isdefined("Form.ModOC")>
            	<cfset ModOC = ''>
			<cfelse>
				<cfset ModOC = Form.ModOC >
			</cfif>
			<cfif ModOC NEQ '' >
				<cfset a = insertCuenta(4310,'CM','Modifica Orden de Compra x Solicitud de Compra Directa o Proceso de Compra', 1)>
			<cfelse>
				<cfset b = insertCuenta(4310,'CM','Modifica Orden de Compra x Solicitud de Compra Directa o Proceso de Compra', 0)>
			</cfif>
            <!--- 200005 Descripcion de Cuentas Financieras en el Idioma de la Empresa --->
            <cfparam name="form.chkGenDescCtasFinI" default="0" >
			<cfset insertCuenta(200005,'CG','Generar la Descripción de Cuentas Financieras en el Idioma de la Empresa',form.chkGenDescCtasFinI)>
            <!--- 200010 Presentar la descripción de las Cuentas según el idioma del Usuario --->
            <cfparam name="form.chkDescIUsuario" default="0" >
			<cfset insertCuenta(200010,'CG','Presentar la descripción de las Cuentas según el idioma del Usuario',form.chkDescIUsuario)>

            <cfparam name="form.chkB15Historico" default="0" >
			<cfset insertCuenta(200011,'CG','Utilizar conversión N B-15 Historico',form.chkB15Historico)>

            <cfparam name="form.chkCtasOrden" default="0" >
			<cfset insertCuenta(200012,'CG','Considerar cuentas de orden para Conversión',form.chkCtasOrden)>

            <cfparam name="form.chkPolizaIntercompany" default="0" >
			<cfset insertCuenta(200013,'CG','Intercompañias en carga de polizas',form.chkPolizaIntercompany)>
<!---            	<cfparam name="form.chkCtas2aConV2" default="0" >
			<cfset insertCuenta(200014,'CG','Utilizar conversión de Estados Financiero versión 2.0',form.chkCtas2aConV2)> --->
			<cfif isdefined("form.MCExcepNIC21V2") and len(trim(form.MCExcepNIC21V2)) GT 0>
            	<cfset formato = form.MCExcepNIC21V2>
				<cfif isdefined ("form.Cformato") and len(trim(form.Cformato)) GT 0>
                	<cfset formato = formato &'-'& form.Cformato>
                    <cfset formato = #Replace(formato, '?','_','ALL')#>
                </cfif>
                <cfif isdefined("form.hayCtaExcepNIC21V2")  and len(trim(form.hayCtaExcepNIC21V2)) gt 0>
					<cfset a = updateCuenta(4600, formato)>
				<cfelse>
					<cfset b = insertCuenta(4600,'CG','Cuenta de Excepcion de conversión NIC 21 V2.0',formato)>
				</cfif>
            <cfelse>
            	  <cfset a = updateCuenta(4600, '')>
			</cfif>

            <!--- 5001  Tesoreria: Emitir pago de cheques en la impresión o en la entrega --->
	<!---		<cfif isdefined("form.TESemitPag") and form.TESemitPag eq 1>
				<cfthrow message = 'entra 1 #form.TESemitPag#'>
			    <cfset a = updateCuenta(5001, form.TESemitPag)>
            <cfelseif isdefined("form.TESemitPag") and form.TESemitPag eq ''>
			<cfthrow message = 'entra 2'>
			    <cfset a = updateCuenta(5001, form.TESemitPag)>
	--->	<cfif form.EmitPago eq 0>
				<cfset b = insertCuenta(5001,'TS', 'Emitir pago de cheques en la impresión o en la entrega', '')>
			<cfelseif form.EmitPago eq 1>
				<cfset a = updateCuenta(5001, form.TESemitPag)>
			</cfif>

			<!--- OPARRALES 2017-10-25 --->

			<cfif IsDefined('form.chkTGE')>
				<cfset insertCuenta(14200701,'TS','Filtrar Tipo de Gasto por Empleado',1)>
			<cfelse>
				<cfset insertCuenta(14200701,'TS','Filtrar Tipo de Gasto por Empleado',0)>
			</cfif>
			<!--- TIPO DE CUENTA PARA DISPERSIÓN DE PAGOS --->

			<cfif isdefined("form.lVarExistCta") AND form.lVarExistCta eq 1>
				<cfset b = insertCuenta(5002,'TS', 'Tipo de cuenta para Dispersion de pagos (Bancomer)', form.cboValorTipoCta)>
			<cfelse>
				<cfset a = updateCuenta(5002, form.cboValorTipoCta)>
			</cfif>
			<!--- Valida facturas antes del pago --->
			<cfif isdefined("form.lVarExistValidaUUID") AND form.lVarExistValidaUUID eq 1>
				<cfset b = insertCuenta(5003,'TS', 'Validar Facturas antes del pago', form.cboValidaUUID)>
			<cfelse>
				<cfset a = updateCuenta(5003, form.cboValidaUUID)>
			</cfif>

            <!--- 5305 No Validar Moneda en Contratos --->
            <cfif isdefined('form.ValidarMoneda')>
           		<cfset form.ValidarMoneda = 1>
            </cfif>
            <cfparam name="form.ValidarMoneda" default="0" >
			<cfset insertCuenta(5305,'CM','No Validar Moneda en Contratos',form.ValidarMoneda)>

            <cfparam name="form.chkPostAdqAF" default="0" >
			<cfset insertCuenta(15600,'CP','Realizar adquisición de activos fijos, posterior a la aplición de facturas',form.chkPostAdqAF)>

            <cfparam name="form.chkDETCXP" default="0" >
			<cfset insertCuenta(15650,'CP','Realizar cambios en los item y cuentas de los detalles de las facturas de CxP',form.chkDETCXP)>

			<!--- Eduardo González (27-02-2018): Omitir validacion de fecha de arribo --->
			<cfparam name="form.chkOmitirValFechaArribo" default="0" >
			<cfset insertCuenta(00190401,'CP','Omitir validacion de fecha de arribo.',form.chkOmitirValFechaArribo)>

			<!--- Parametros para consumir el servicio de portal de proveedores en SIC --->
			<cfparam name="form.urlBase" default="" >
			<cfset insertCuenta(191001,'CP','URL Base Servicio de Portal de Proveedores SIC',form.urlBase)>

			<cfparam name="form.userWS" default="" >
			<cfset insertCuenta(191002,'CP','Usuario Servicio de Portal de Proveedores SIC',form.userWS)>

			<cfparam name="form.passwordWS" default="" >
			<cfset insertCuenta(191003,'CP','Contraseña Servicio de Portal de Proveedores SIC',form.passwordWS)>

			<cfparam name="form.apiKeyWS" default="" >
			<cfset insertCuenta(191004,'CP','Apikey Servicio de Portal de Proveedores SIC',form.apiKeyWS)>

			<cfparam name="form.apd_enc" default="" >
			<cfset insertCuenta(191005,'CP','Aplicación de Documentos Transacciones Encabezado',form.apd_enc)>
			<cfparam name="form.apd_det" default="" >
			<cfset insertCuenta(191006,'CP','Aplicación de Documentos Transacciones Detalle',form.apd_det)>
			<cfif isdefined("form.rolCancelaCxP")>
				<cfset b = insertCuenta(5004,'CP', 'Rol para la Cancelacion de Documentos CxP', form.rolCancelaCxP)>
			</cfif>
			<cfif isdefined("form.montoComPago")>
				<cfset b = insertCuenta(5005,'CP', 'Tolerancia para agregar un Complemento de Pago', form.montoComPago)>
			</cfif>		

			<cfparam name="form.chkRemision" default="0" >
			<cfset insertCuenta(1711,'CP', 'Activar uso de remisiones', form.chkRemision)>

		
				   <!---NO ASOCIAR BENEFICIARIO CON BANCO--->
			       <!--- 5900. No asociar al TESbeneficiario la informaci&oacute;n del Banco o Emisor de TCE --->
			<cfif Len(Trim(Form.hayTESbeneTCE)) GT 0>
				<cfif isDefined("Form.chkTESbenTCE")>
					<cfset valor = "S">
				<cfelse>
					<cfset valor = "N">
				</cfif>
				<cfset a = insertCuenta(5900,'TC','No asociar al TESbeneficiario la informacion del Banco o Emisor de TCE',valor)>
			</cfif>
			<!--- Parametro 20040 Moneda extranjera para TCE--->
            <cfif isdefined("form.cboMonedaExt") and len(trim(form.cboMonedaExt)) GT 0>
 				<cfset a = insertCuenta(200040,'TC','Moneda Extranjera para las TCE',form.cboMonedaExt)>
            <cfelse>
            	<cfset b = insertCuenta(200040,'TC','Moneda Extranjera para las TCE','X')>
            </cfif>
            
            <!--- INVENTARIOS --->
			<!--- Aplicador de Movimientos de Inventario InterAlmacén  200090--->
			<cfif isDefined("form.hayRolAplicadorInventario")>
				<!--- <cfif isdefined("form.hayRolAplicadorInventario") and form.hayRolAplicadorInventario eq 1 >
					<cfset a = updateCuenta(200090,form.SScodigo&':'&form.SRcodigo)>
 				<cfelse>
					<cfset b = insertCuenta(200090,'IV','Rol para aplicar Movimientos de Inventario InterAlmacen',form.SScodigo&':'&form.SRcodigo)>
				</cfif> --->
			</cfif>

			<!--- SOCIOS DE NEGOCIO --->
			<!--- Autorizar modificaciones a los Socios de Negocio  00030401--->
			<cfif isDefined("form.chkAutorizadorSN")>
				<cfset LvarCheckSN = 1>
			<cfelse>
				<cfset LvarCheckSN = 0>
			</cfif>
			<cfif isDefined("form.hayAutorizadorSNCheck") AND #form.hayAutorizadorSNCheck# EQ 1>
				<cfset a = updateCuenta(00030401,LvarCheckSN)>
			<cfelse>
				<cfset b = insertCuenta(00030401,'AD','Autorizar modificaciones a los Socios de Negocio',LvarCheckSN)>
			</cfif>

			<!--- Rol para Autorizar Modificaciones a los Socios de Negocio  00030402--->
			<cfif isDefined("form.hayRolAutorizadorSN")>
				<cfif isdefined("form.hayRolAutorizadorSN") and form.hayRolAutorizadorSN eq 1 >
					<cfset a = updateCuenta(00030402,form.SRcodigoSN)>
 				<cfelse>
					<cfset b = insertCuenta(00030402,'AD','Rol para Autorizar Modificaciones a los Socios de Negocio',form.SRcodigoSN)>
				</cfif>
			</cfif>

            <!--- TESORERIA --->
			<!--- Autorizar Modificaciones a Cuentas Destino para Pago  00380401--->
			<cfif isDefined("form.chkAutorizadorTcd")>
				<cfset LvarCheckTcd = 1>
			<cfelse>
				<cfset LvarCheckTcd = 0>
			</cfif>
			<cfif isDefined("form.hayAutorizadorTcdCheck") AND #form.hayAutorizadorTcdCheck# EQ 1>
				<cfset a = updateCuenta(00380401,LvarCheckTcd)>
			<cfelse>
				<cfset b = insertCuenta(00380401,'TES','Autorizar Modificaciones a Cuentas Destino para Pago',LvarCheckSN)>
			</cfif>

			<!--- Rol para Autorizar Modificaciones a Cuentas Destino para Pago  00380402--->				
			<cfif isDefined("form.hayRolAutorizadorTcd")>
				<cfif isdefined("form.hayRolAutorizadorTcd") and form.hayRolAutorizadorTcd eq 1 >
					<cfset a = updateCuenta(00380402,form.SRcodigoTcd)>
 				<cfelse>
					<cfset b = insertCuenta(00380402,'TES','Rol para Autorizar Modificaciones a Cuentas Destino para Pago',form.SRcodigoTcd)>
				</cfif>
			</cfif>


			<!---
			**********************************************************************************************
			******************************************* ADVERTENCIA **************************************
			Se reserva el parametro 660 para La Moneda de Conversión para Estados Financieros
			NO USAR POR FAVOR
			**********************************************************************************************
			**********************************************************************************************
			--->

		<!--- </cfquery> --->
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<form action="ParametrosAuxiliaresAD.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


<!--- Llena la tabla UsuarioCFuncional cuando:
	1. el método de determinación del CF por Usuario es con Usuarios x CF
	2. la tabla está vacía
--->
<cffunction name="sbLlenarUsuarioCFuncional" output="false" access="private" returntype="void">
	<cfargument name="valor">

	<cfif Arguments.valor NEQ "USU">
		<cfreturn>
	</cfif>

	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select count(1) as Cantidad
		  from UsuarioCFuncional
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfreturn>
	</cfif>

	<cf_dbfunction name="to_number" args="llave" returnvariable="LvarToNumber">
	<cf_dbfunction name="now" returnvariable="LvarNow">
	<!--- CMSolicitantes: CM - Solicitantes de Compras --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select e.Ecodigo, ue.Usucodigo, min(sc.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from CMSolicitantes sc
			inner join Empresas e
				on e.Ecodigo = sc.Ecodigo
			inner join UsuarioReferencia ue
				on ue.Ecodigo = e.EcodigoSDC and ue.STabla = 'CMSolicitantes' and #preserveSingleQuotes(LvarToNumber)# = sc.CMSid
		where sc.CMSestado = 1
		  and sc.CFid is not null
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = e.Ecodigo
			   and Usucodigo = ue.Usucodigo
			) = 0
		group by e.Ecodigo, ue.Usucodigo
	</cfquery>

	<!--- EmpleadoCFuncional: AF - Responsables y Encargados de Activos Fijos --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select e.Ecodigo, ue.Usucodigo, min(eaf.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from EmpleadoCFuncional eaf
			inner join Empresas e
				on e.Ecodigo = eaf.Ecodigo
			inner join UsuarioReferencia ue
				on ue.Ecodigo = e.EcodigoSDC and ue.STabla = 'DatosEmpleado' and #preserveSingleQuotes(LvarToNumber)# = eaf.DEid
		 where #preserveSingleQuotes(LvarNow)# between ECFdesde and ECFhasta
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = e.Ecodigo
			   and Usucodigo = ue.Usucodigo
			) = 0
		group by e.Ecodigo, ue.Usucodigo
	</cfquery>

	<!--- CFuncional.CFuresponsable: Responsables del Centro Funcional --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select cf.Ecodigo, cf.CFuresponsable, min(cf.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from CFuncional cf
		where (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = cf.Ecodigo
			   and Usucodigo = cf.CFuresponsable
			) = 0
		and cf.CFuresponsable is not null
		group by cf.Ecodigo, cf.CFuresponsable
	</cfquery>

	<!--- CFautoriza: Autorizadores de Centro Funcional para Recursos Humanos y Compras --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select cfa.Ecodigo, cfa.Usucodigo, min(cfa.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from CFautoriza cfa
		where (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = cfa.Ecodigo
			   and Usucodigo = cfa.Usucodigo
			) = 0
		group by cfa.Ecodigo, cfa.Usucodigo
	</cfquery>

	<!--- CPSeguridadUsuario: Seguridad de Presupuesto --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select u.Ecodigo, u.Usucodigo, min(u.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from CPSeguridadUsuario u
		 where (CPSUaprobacion = 1 OR CPSUtraslados = 1 OR CPSUreservas = 1 OR CPSUformulacion = 1)
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = u.Ecodigo
			   and Usucodigo = u.Usucodigo
			) = 0
		group by u.Ecodigo, u.Usucodigo
	</cfquery>

	<!--- TESusuarioSP: Seguridad de Tesoreria --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select u.Ecodigo, u.Usucodigo, min(u.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from TESusuarioSP u
		 where (TESUSPaprobador = 1 OR TESUSPsolicitante=1)
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = u.Ecodigo
			   and Usucodigo = u.Usucodigo
			) = 0
		group by u.Ecodigo, u.Usucodigo
	</cfquery>

	<!--- TESusuarioGE: Seguridad Gasto Empleados --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select u.Ecodigo, u.Usucodigo, min(u.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from TESusuarioGE u
		 where (TESUGEaprobador = 1 OR TESUGEsolicitante=1)
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = u.Ecodigo
			   and Usucodigo = u.Usucodigo
			) = 0
		group by u.Ecodigo, u.Usucodigo
	</cfquery>

	<!--- FPSeguridadUsuario: Seguridad Plan de Compras Gobierno --->
	<cfquery datasource="#Session.DSN#">
		insert into UsuarioCFuncional (Ecodigo, Usucodigo, CFid, BMfalta, BMUsucodigo)
		select u.Ecodigo, u.Usucodigo, min(u.CFid), #preserveSingleQuotes(LvarNow)#,1
		  from FPSeguridadUsuario u
		 where (FPSUestimar = 1)
		   and (
			select count(1)
			  from UsuarioCFuncional
			where Ecodigo = u.Ecodigo
			   and Usucodigo = u.Usucodigo
			) = 0
		group by u.Ecodigo, u.Usucodigo
	</cfquery>
</cffunction>

<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >
	<cfargument name="pcodigo" 		type="numeric" required="true">
	<cfargument name="mcodigo" 		type="string"  required="true">
	<cfargument name="pdescripcion" type="string"  required="true">
	<cfargument name="pvalor" 		type="string"  required="true">

	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>

	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
				)
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			update Parametros set
            	Pvalor 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pdescripcion)#">
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
	</cfif>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="fnChk" returntype="string">
	<cfargument name="nombre" type="string" required="true">
	<cfif isdefined(Arguments.nombre)>
		<cfreturn "S">
	<cfelse>
		<cfreturn "N">
	</cfif>
</cffunction>


<!---SML 25/02/2014. Eliminar Parametro --->
<cffunction name="eliminarDato" >
	<cfargument name="pcodigo" 		type="numeric" required="true">

	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>

	<cfif rsCheck.cantidad eq 1>
		<cfquery name="rsCheck" datasource="#session.DSN#">
			delete from Parametros
			where Ecodigo = #session.Ecodigo#
		  		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
	</cfif>
	<cfreturn true>
</cffunction>