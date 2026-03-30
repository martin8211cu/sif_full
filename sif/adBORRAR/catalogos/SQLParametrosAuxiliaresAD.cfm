<!--- 
	Modificado por: Ana Villavicencio Rosales
	Fecha: 05 de Setiembre del 2005
	Motivo: Se agregó el parámetro 750 Indicador del idioma en letras. Se colocó en un nuevo apartado Invetarios. 
	
	Modificado por:Ana Villavincencio
	Fecha: 13 de setiembre del 2005
	Motivo: Eliminar el apartado de inventarios para el idioma del monto en letras para facturas.  Parametro 750.
--->

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
				insert INTO Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values (
					#Session.Ecodigo#, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#" len="2">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#" len="100">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100" voidNull> 
					)
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				update Parametros 
					set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100"  voidNull>
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
				Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#" len="100">
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
			
			<!--- 740. Valida No contabiliza Costo de Ventas ni Ajustes --->
			<cfif isDefined("form.hayNoContaCosto") and Len(Trim(form.hayNoContaCosto)) GT 0>
				<cfif isdefined("form.chkValorNoContaCosto")><cfset valor = '1'><cfelse><cfset valor = '0'></cfif>
				<cfif form.hayNoContaCosto EQ "1">
					<cfset a = updateCuenta(740,valor)>
 				<cfelseif Form.hayNoContaCosto EQ "0">
					<cfset b = insertCuenta(740,'IV','No contabiliza el Costo de Ventas ni Ajustes',valor)>
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

			<!--- 560. Cuenta Contable de  de Intereses Moratorios --->
			<cfif Form.hayMoratorios eq 1>
				<cfset a = updateCuenta(560,form.CMoratorios)>
			<cfelse>
				<cfset b = insertCuenta(560,'CG','Cuenta Contables de Intereses Moratorios', form.CMoratorios)>
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
					update Parametros set Pvalor = null
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
					update Parametros set Pvalor = null
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
            
            <cfparam name="form.chkContExisSol" default="0" >
			<cfset insertCuenta(4100,'CM','Controlar existencias de artículos en solicitudes de requisición',form.chkContExisSol)>
            
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
