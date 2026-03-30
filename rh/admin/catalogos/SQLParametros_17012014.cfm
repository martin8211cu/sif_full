<cfif isDefined("Form.btnAceptar")>

	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="datos" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">
		<cfargument name="empresa" type="string" required="false" default="#session.Ecodigo#">
		
		
		<cfset cpdescripcion = mid(#pdescripcion#,1,80)>
		
		<cfquery name="checkExists" datasource="#Session.DSN#">
			select 1
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
		</cfquery>
		<!--- Update --->
		<cfif checkExists.recordCount GT 0>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				update RHParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pvalor)#" null="#len(trim(pvalor)) EQ 0#">,
					Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cpdescripcion)#">
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			</cfquery>
		<!--- Insert --->
		<cfelse>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">, 
				    <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cpdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pvalor)#" null="#len(trim(pvalor)) EQ 0#">
				)
			</cfquery>
		</cfif>
		
		<!--- esto lo hace siempre que no existan los parametros 200,210 --->
		<cfquery name="checkParam200" datasource="#Session.DSN#">
			select Pvalor 
			from RHParametros 
			where Pcodigo = 200 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif checkParam200.recordCount EQ 0>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				    200, 
					'Número de Planilla', 
					NULL
				)
			</cfquery>
		</cfif>
		

		<cfquery name="checkParam210" datasource="#Session.DSN#">
			select Pvalor 
			from RHParametros 
			where Pcodigo = 210 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif checkParam210.recordCount EQ 0>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				    210, 
					'Consecutivo de Archivo de Planilla', 
					'0'
				)
			</cfquery>
		</cfif>

		<!---
		<cfquery name="checkParam220" datasource="#Session.DSN#">
			select Pvalor 
			from RHParametros 
			where Pcodigo = 220 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif checkParam220.recordCount EQ 0>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, k, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				    220, 
					'Tipo de Acción para Aumentos Masivos', 
					NULL
				)
			</cfquery>
		</cfif>
		--->
		<cfreturn true>
	</cffunction>
	
	<!--- AGENDA MEDICA: Fuera de la transaccion, pues el componente maneja su propia transaccion --->
	<cftransaction>
		<!--- 1. Parametrizacion --->
		<cfset datos(5, 'Parametrización ya Definida', '0' ) >

		<!--- 2. Interfaz Contable  --->
		<cfif isdefined("form.IContable") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(20, 'Interfaz con Contabilidad', dato) >

		<cfif isdefined("form.CHK_ControlPresupuestoNominas") AND dato EQ 1>
				<cfset datos(541, 'Control de Presupuesto en Nomina', 1)>
		<cfelse>
				<cfset datos(541, 'Control de Presupuesto en Nomina', 0)>
		</cfif>
		
		<!--- 2.1 Asiento Contable Unificado --->
		<cfif isdefined("form.ACUnificado") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(25, 'Asiento Contable Unificado', dato) >
	
		<!--- 3. Tabla de Renta --->
		<cfset datos(30, 'Tabla de Impuesto de Renta', form.IRcodigo ) >
		
		<!--- 3.1 Indicador de Calculo de renta retroactivo ljimenez --->
		
		<cfif isdefined("form.CalculoRentaRetroactivo") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(31, 'Indicador Calcula Renta Retroactivo',dato ) > 
		
		<!--- 3.2 Componente de Renta ljimenez--->
		<cfset datos(2020, 'Componente a usar en calculo de Renta', form.ComponenteRenta) >
		

		<!--- 4. Salario Minino General Zona A --->
		<cfif isdefined ("form.RHSMGA")>
			<cfset temp	=	form.RHSMGA> 
		<cfelse>
			<cfset temp	=	"0"> 
		</cfif>
		<cfset datos(2024, 'Salario Minimo General Zona A', temp) >
		
		
		<!--- 4.1 Saber si aplica para mexico si utiliza SBC--->
		<cfif isdefined ("form.RHEsmexico")>
			<cfset temp="1"> 
		<cfelse>
			<cfset temp="0"> 
		</cfif>
		<cfset datos(2025, 'Utiliza SBC', temp) >
		
		
		<!---4.2 Si habilita salario minimo por zona--->
		<cfif isdefined ("form.RHSalarioMinimoZona")>
			<cfset temp="1"> 
		<cfelse>
			<cfset temp="0"> 
		</cfif>
		<cfset datos(2028, 'Habilitar Salario Mínimo por Zona', temp) >
		
		<!--- 4.3 Saber si se desea hacer ajuste de salario negativo  --->
		<cfif isdefined ("form.RHAjusteSalario")>
			<cfset temp="1"> 
		<cfelse>
			<cfset temp="0"> 
		</cfif>
		<cfset datos(2026, 'Ajuste Salario Negativo', temp) >
		
		<!--- 4.4 Si se marca el check de Salario negativo se da la opcion de elegir un concepto de pago por qle cual se manejara el ajuste de salario negativo--->
		<cfif isdefined ("form.CIidB") and len(trim(form.CIidB))>
			<cfset temp = form.CIidB>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2027, 'Deduccion Ajuste', temp) >
		
		
		<!--- 4.5 Si se marca el check de Salario negativo se da la opcion de elegir un concepto de pago por qle cual se manejara el ajuste de salario negativo--->
		<cfif isdefined ("form.RHModificarSDI") and len(trim(form.RHModificarSDI))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2030, 'Permite modificar el SDI en expediente empleado (mexico)', temp) >
		
		
		<!--- Concepto Pago Vacaciones --->
		<!---<cfif isdefined("Form.CIidVac")>
			<cfset datos(2031, 'Concepto Pago Vacaciones', #form.CIidVac#) >
		</cfif>--->
        
        <!---SML. Modificacion para que considere mas conceptos de Prima Vacacional y contemplarlas en la busqueda de incidencias ya pagadas--->
        <cfif (isdefined('Form.CIidVac') and LEN(TRIM(Form.CIidVac))) or (isdefined('form.chkLCIncidentes') and LEN(TRIM(form.chkLCIncidentes)))>
			<cfset Lvar_lista = ''>
			<cfif isdefined('form.CIidVac') and LEN(TRIM(form.CIidVac))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.CIidVac)>
			</cfif>
			<cfif isdefined('form.chkLCIncidentes') and LEN(TRIM(form.chkLCIncidentes))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.chkLCIncidentes)>
			</cfif>
			<cfset datos(2031, 'Concepto Pago Vacaciones', Lvar_lista) >
		<cfelse>
			<cfset datos(2031, 'Concepto Pago Vacaciones', '') >
		</cfif>
       <!--- SML.--->
		

		<!--- 4.7 Concepto Pago subsidio salario --->
		<cfif isdefined("Form.TDid")>
			<cfset datos(2033, 'Deduccion Subsidio salario', #form.TDid#) >
		</cfif>
		
		<!--- Monto Seguro Infonavit --->
		<cfif isdefined("Form.MtoSeguro")>
			<cfset datos(2034, 'Monto Seguro Infonavit', #form.MtoSeguro#)>
		</cfif>
        
       	<!---Activa la utilizacion de Tablas de renta segun tipo de nomina--->		
		<cfif isdefined("Form.RentaTipoNomina")>
			<cfset datos(2035, 'Activa la utilizacion de Tablas de renta segun tipo de nomina',1) >
		<cfelse>
			<cfset datos(2035, 'Activa la utilizacion de Tablas de renta segun tipo de nomina',0) >
		</cfif>
		
		
		
		
		<!--- Salario promedio con meses --->		
		<cfif isdefined("Form.RHSPMes")>
			<cfset datos(2037, 'Tomar en cuenta en Salario Promedio las incapacidades',1) >
		<cfelse>
			<cfset datos(2037, 'Tomar en cuenta en Salario Promedio las incapacidades',0) >
		</cfif>
		
		<!--- Salario promedio con retroactivos --->
		<cfif isdefined("Form.RHSPRetroactivo")>
			<cfset datos(2038, 'Tomar en salario promedio los retroactivos distribuidos por mes', 1) >
		<cfelse>
			<cfset datos(2038, 'Tomar en salario promedio los retroactivos distribuidos por mes', 0) >
		</cfif>
		<!--- Salario promedio con retroactivos --->
		<cfif isdefined("Form.RHTidCP")>
			<cfset datos(2039, 'Tipo Acción para Asignacion de componente de Carrera Profesional', form.RHTidCP) >
		</cfif>
		<cfif isdefined ('form.LvarCuotas')>
			<cfset datos(2108,'	Cantidad de cuotas por curso perdido', form.LvarCuotas)>
		</cfif>


		<!--- 4.10. Codigo de Importador Incapacidades SUA Mexico --->
		<cfif not isdefined("form.impINC")>
			<cfset vImpINC = '' >
		<cfelse>
			<cfset vImpINC = form.impINC>
		</cfif>
		<cfset datos(2036, 'Script de exportación Datos Incapacidades SUA', Trim(vImpINC))>

		
		
		<!--- 5. Dias en Pago Semanal --->
		<cfif len(trim(form.TPSemanal)) gt 0><cfset TPsemanal = form.TPSemanal><cfelse><cfset TPsemanal = 7 ></cfif>
		<cfset datos(40, 'Cantidad de días máximo para Tipo de Pago Semanal', #TPsemanal# ) >

		<!--- 6. Dias en Pago Bisemanal --->
		<cfif len(trim(form.TPBisemanal)) gt 0><cfset TPbisemanal = form.TPBisemanal><cfelse><cfset TPbisemanal = 14 ></cfif>
		<cfset datos(50, 'Cantidad de días máximo para Tipo de Pago Bisemanal', #TPbisemanal# ) >
		
		<!--- 7. Dias en Pago Quincenal --->
		<cfif len(trim(form.TPQuincenal)) gt 0><cfset TPquincenal = form.TPQuincenal><cfelse><cfset TPquincenal = 15 ></cfif>
		<cfset datos(60, 'Cantidad de días máximo para Tipo de Pago Quincenal', #TPquincenal# ) >
		
		<!--- 8. Dias en Pago Mensual --->
		<cfif len(trim(form.TPMensual)) gt 0><cfset TPmensual = form.TPMensual><cfelse><cfset TPmensual = 30 ></cfif>
		<cfset datos(70, 'Cantidad de días máximo para Tipo de Pago Mensual', #TPmensual# ) >

		<!--- 9. Dias en Calculo Mensual --->
		<cfif len(trim(form.CNMensual)) gt 0><cfset CNmensual = replace(form.CNMensual, ',','','all')><cfelse><cfset CNmensual = 30 ></cfif>
		<cfset datos(80, 'Cantidad de días para Cálculo de Nómina Mensual', #CNmensual# ) >

		<!--- 10. Indicador Dias de no pago --->
		<cfif len(trim(form.DiasTipoNomina)) gt 0><cfset DiasTipoNomina = form.DiasTipoNomina><cfelse><cfset DiasTipoNomina = 15 ></cfif>
		<cfset datos(90, 'Indicador de Días de No Pago por Tipo de Nómina', DiasTipoNomina ) >

		<!--- 11. Redondeo a monto --->
		<cfif len(trim(form.RedondeoMonto)) gt 0><cfset RedondeoMonto = form.RedondeoMonto><cfelse><cfset RedondeoMonto = 0.00 ></cfif>
		<cfset datos(110, 'Redondeo a Monto', RedondeoMonto ) >
		
		<!--- 12. Configuración de Pago de nómina  --->
		<cfset datos(7, 'Configuración de Pago de Nómina', #form.PagoNomina#) >

		<!--- 13. Tipo de Redondeo --->
		<cfif len(trim(form.TipoRedondeo)) gt 0><cfset TipoRedondeo = form.TipoRedondeo><cfelse><cfset TipoRedondeo = 1></cfif>
		<cfset datos(120, 'Tipo de Redondeo', TipoRedondeo) >

		<!--- 14. Salario mínimo mensual --->
		<cfif len(trim(form.SMmensual)) gt 0><cfset SMmensual = form.SMmensual><cfelse><cfset SMmensual = 0></cfif>
		<cfset datos(130, 'Salario mínimo mensual', SMmensual) >

		<!--- 15. Cuenta Contable de Renta --->
		<cfif len(trim(form.CuentaRenta)) gt 0><cfset CuentaRenta = form.CuentaRenta><cfelse><cfset CuentaRenta = '' ></cfif>
		<cfset datos(140, 'Cuenta Contable de Renta', CuentaRenta) >

		<!--- 16. Cuenta Contable de Pagos no realizados  --->
		<cfif len(trim(form.CuentaPagos)) gt 0><cfset CuentaPagos = form.CuentaPagos><cfelse><cfset CuentaPagos = '' ></cfif>
		<cfset datos(150, 'Cuenta Contable de Pagos no Realizados', CuentaPagos) >

		<!--- 17. Cantidad de Periodos para Calculo Salario Promedio --->
		<cfif len(trim(form.SPDPeriodos)) gt 0><cfset SPDPeriodos = form.SPDPeriodos><cfelse><cfset SPDPeriodos = 0 ></cfif>
		<cfset datos(160, 'Cantidad de Periodos para Calculo Salario Promedio', SPDPeriodos) >
		
	    <!--- Tipos de periodo --->
		<cfset datos(161, 'Tipo de periodo', #form.mesesoperiodos# ) >


		<!--- 18. Enviar correo de boleta de pago al administrador --->
		<cfif isdefined("form.CorreoPago") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(170, 'Enviar Correo de Boleta de Pago al Administrador', dato) >
		
		<!--- 19. Usuario Administrador --->
		<cfif len(trim(form.Adm_Usucodigo)) gt 0><cfset Adm_Usucodigo = form.Adm_Usucodigo><cfelse><cfset Adm_Usucodigo = '' ></cfif>
		<cfset datos(180, 'Usuario Administrador', Adm_Usucodigo) >
		
		<!--- 20. Cuenta de Correo (DE:) en boleta de Pago --->
		<cfif len(trim(form.CorreoBoleta)) gt 0><cfset CorreoBoleta = form.CorreoBoleta><cfelse><cfset CorreoBoleta = ''></cfif>
		<cfset datos(190, 'Cuenta de Correo (DE:) en boleta de Pago', CorreoBoleta) >

		<!--- 21. Agenda Medica --->
		<cfset datos(220, 'Agenda Médica', Trim(form.agenda_medica)) >

		<!--- 22. Tipo de Evaluacion de Desempeño --->
		<cfif isdefined("Form.tipo_evaluacion") and form.tipo_evaluacion eq 'T'>
			<cfset valor = '' >
			<cfif isdefined("form.RHtabla")>
				<cfset valor = form.RHtabla >
			</cfif>
			<cfset datos(230, 'Tipo de Evaluación de Desempeño', valor) >
		<cfelse>
			<cfset datos(230, 'Tipo de Evaluación de Desempeño', '') >
		</cfif>			


		<!--- 31. Incidencia para rebajo  --->
		<cfif isdefined("form.RHTipoCalculoRenta") and isdefined("form.RHTipoCalculoRenta") >
			<cfset tipocalulorenta = form.RHTipoCalculoRenta >
		<cfelse>
			<cfset tipocalulorenta = '' >
		</cfif>
		<cfset datos(255, 'Tipo de Cálculo de Renta', tipocalulorenta) >

		<!--- 23. Días antes para asignar Vacaciones --->
		<cfset datos(260, 'Días antes para asignar Vacaciones', Trim(form.RHDiasAntesVac)) >

		<!--- 24. Procesa Dias de Enfermedad --->
		<cfif isdefined("form.RHProcesaEnf") ><cfset procesa = 'S' ><cfelse><cfset procesa = 'N' ></cfif>
		<cfset datos(270, 'Procesa Días de Enfermedad', Trim(procesa)) >

		<!--- 25. Fecha de &uacute;ltima corrida del proceso de asignacion de Vacaciones --->
		<cfif len(Trim(form.RHFechaUltimaCorridaVac)) lte 0 ><cfset fechavac = LSDateFormat(Now(),'dd/mm/yyyy') ><cfelse><cfset fechavac = form.RHFechaUltimaCorridaVac ></cfif>
		<cfset datos(280, 'Fecha de última corrida del proceso de asignación de Vacaciones', Trim(form.RHFechaUltimaCorridaVac)) >

		<!--- 26. Parametro de Script de Importación de Marcas de Reloj --->
		<cfset datos(290, 'Script de Importación de Marcas de Reloj', Trim(Form.MarcasScript))>

		<!--- 27. Número Patronal para reporte Seguro Social --->
		<cfset datos(300, 'Número Patronal para reporte Seguro Social', Trim(form.RHNumeroPatronal))>

		<!--- 28. Codigo de Importador archivo de Seguro Social --->
		<cfif not isdefined("form.impSeguroSocial")>
			<cfset vImpSeguroSocial = '' >
		<cfelse>
			<cfset vImpSeguroSocial = form.impSeguroSocial >
		</cfif>
		<cfset datos(310, 'Script de exportación del Seguro Social', Trim(vImpSeguroSocial))>
		
		<!--- 28.1 utilizar # poliza de Datos Empleado --->
		<cfif isdefined("form.PolizaDE") ><cfset procesa = 'S' ><cfelse><cfset procesa = 'N' ></cfif>
		<cfset datos(311, 'Utilizar numero poliza de Datos Empledo', Trim(procesa)) >
		
		
		<!--- 29. Codigo de Importador archivo del INS --->
		<cfif not isdefined("form.impINS")>
			<cfset vImpINS = '' >
		<cfelse>
			<cfset vImpINS = form.impINS>
		</cfif>
		<cfset datos(320, 'Script de exportación del Instituto Nacional de Seguros', Trim(vImpINS))>

		<!--- 30. Calcula Comision  --->
		<cfif isdefined("form.CalculaComision") ><cfset comision = 1 ><cfelse><cfset comision = 0 ></cfif>
		<cfset datos(330, 'Calcular comisiones con salario base', comision) >
		
		<!--- 30.1 Calcula Comision Completa ljimenez 2010-04-09 --->
		<cfif isdefined("form.CalculaComisionC") ><cfset comisionC = 1 ><cfelse><cfset comisionC = 0 ></cfif>
		<cfset datos(331, 'Calcular comisiones completas con salario base', comisionC) >
	
		<!--- 31. Incidencia para rebajo  --->
		<cfif (isdefined("form.CalculaComision") or isdefined("form.CalculaComisionC")) and isdefined("form.RHrebajo") >
			<cfset rebajo = form.RHrebajo >
		<cfelse>
			<cfset rebajo = '' >
		</cfif>
		<cfset datos(340, 'Incidencia para rebajo de salario por calculo de comisiones', rebajo) >

		<!--- 32. Incidencia para salario base  --->
		<cfif (isdefined("form.CalculaComision") or isdefined("form.CalculaComisionC")) and isdefined("form.RHincidencia") >
			<cfset incidencia = form.RHincidencia >
		<cfelse>
			<cfset incidencia = '' >
		</cfif>
		<cfset datos(350, 'Incidencia para salario base', incidencia) >

		<!--- 33. Incidencia para salario base  --->
		<cfif (isdefined("form.CalculaComision") or isdefined("form.CalculaComisionC")) and isdefined("form.RHajuste") >
			<cfset ajuste = form.RHajuste >
		<cfelse>
			<cfset ajuste = '' >
		</cfif>
		<cfset datos(360, 'Incidencia para ajuste de salario base', ajuste) >

		<!--- 34. Codigo de Importador archivo de Comisiones --->
		<cfif not isdefined("form.impComision")>
			<cfset vImpComision = '' >
		<cfelse>
			<cfset vImpComision = form.impComision>
		</cfif>
		<cfset datos(370, 'Script de importación de Comisiones', Trim(vImpComision))>
		
		<!--- 35. Contabiliza en modulo de Recepcion de Pagos  --->
		<cfif isdefined("form.CIid") and len(trim(form.CIid)) >
			<cfset vCIid = form.CIid >
		<cfelse>
			<cfset vCIid = '' >
		</cfif>
		<cfset datos(380, 'Incidencia por Salarios Recibidos', vCIid) >
		
		<!--- 36. Codigo de Exportador de Pago de Nomina --->
		<cfif not isdefined("form.ScriptPagoNomina")>
			<cfset vScriptPagoNomina = '' >
		<cfelse>
			<cfset vScriptPagoNomina = form.ScriptPagoNomina >
		</cfif>
		<cfset datos(390, 'Script de exportación de registro de Pago de Nómina', Trim(vScriptPagoNomina))>
		<!--- 37. Recquiere Centro Funcional de Contabilización --->
		<cfif not isdefined("form.RequiereCF")>
			<cfset vRequiereCF = 0 >
		<cfelse>
			<cfset vRequiereCF = 1 >
		</cfif>
		<cfset datos(400, 'Requerir Centro Funcional de Contrabilización', Trim(vRequiereCF))>
		<cfset datos(410, 'Sucursal Adscrita CCSS', Trim(form.RHSucursalAdscrita))>
		<cfset datos(420, 'Número de Póliza del INS', Trim(form.RHPolizaINS))>
		
		<!--- LIQUIDACIONES --->
		<cfif Len(Trim(Form.RHProtecTrabajador))>
			<cfset datos(430, 'Fecha de Corte en Cálculo de Cesantía (Boleta)', Trim(form.RHProtecTrabajador))>
		</cfif>
		<cfif Len(Trim(Form.RHPeriodosLiq))>
			<cfset datos(440, 'Cantidad de Períodos para Cálculo de Salario Promedio (Boleta)', Trim(form.RHPeriodosLiq))>
		</cfif>

		<cfif isdefined("Form.benziger")>
			<cfset datos(450, 'Activar Benziger', 1)>
		<cfelse>
			<cfset datos(450, 'Activar Benziger', 0)>
		</cfif>

		<cfif isdefined("Form.accionNomb") and len(trim(Form.accionNomb)) >
			<cfset datos(460, 'Acción de Nombramiento para Reclutamiento y Selección', Form.accionNomb )>
		<cfelse>
			<cfset datos(460, 'Acción de Nombramiento para Reclutamiento y Selección', '')>
		</cfif>

		<cfif isdefined("Form.accionCambio") and len(trim(Form.accionCambio)) >
			<cfset datos(470, 'Acción de Cambio para Reclutamiento y Selección', Form.accionCambio )>
		<cfelse>
			<cfset datos(470, 'Acción de Cambio para Reclutamiento y Selección', '')>
		</cfif>
		
		<cfif isdefined("Form.AutorizaMarcas")>
			<cfset datos(480, 'Autorización de Marcas', 1)>
		<cfelse>
			<cfset datos(480, 'Autorización de Marcas', 0)>
		</cfif>

		<!--- Check para Contabilización de Gastos por Mes --->
		<cfif isdefined("Form.ContaGastosMes")>
			<cfset datos(490, 'Contabilización de Gastos por Mes', 1)>
			<cfif isdefined("Form.DistCargasPat")>
				<cfset datos(1080, 'Distribución de Cargas Patronales por Mes', 1)>
			<cfelse>
				<cfset datos(1080, 'Distribución de Cargas Patronales por Mes', 0)>
			</cfif>	
			
			<cfif isdefined("Form.DistCargasEmp")>
				<cfset datos(1100, 'Distribución de Cargas Empleado por Mes', 1)>
			<cfelse>
				<cfset datos(1100, 'Distribución de Cargas Empleado por Mes', 0)>
			</cfif>	
			<!--- Cuenta Contable de Pasivo para Contabilización de Gastos por Mes --->
			<cfif len(trim(form.CuentaPasivo)) gt 0>
				<cfset CuentaPasivo = form.CuentaPasivo>
			<cfelse>
				<cfset CuentaPasivo = '' >
			</cfif>
			<cfset datos(500, 'Cuenta de Pasivo para Contabilización de Gastos por Mes', CuentaPasivo)>
		<cfelse>
			<cfset datos(490, 'Contabilización de Gastos por Mes', 0)>
			<cfset datos(1080, 'Distribución de Cargas Patronales por Mes', 0)>
			<cfset datos(1100, 'Distribución de Cargas Empleado por Mes', 0)>
			<cfset datos(500, 'Cuenta de Pasivo para Contabilización de Gastos por Mes', '')>
		</cfif>

		
		<cfif isdefined("Form.DetalleInconsistencias")>
			<cfset datos(510, 'Detallar Inconsistencias', 1)>
		<cfelse>
			<cfset datos(510, 'Detallar Inconsistencias', 0)>
		</cfif>

		<cfif isdefined("Form.CentroCostos")>
			<cfset datos(520, 'CentroCostos equivale a Centro Funcional', 1)>
		<cfelse>
			<cfset datos(520, 'CentroCostos equivale a Centro Funcional', 0)>
		</cfif>

		<cfif isdefined("Form.sincroniza")>
			<cfset datos(530, 'Sincroniza Componentes Salariales con Conceptos de Pago', 1)>
		<cfelse>
			<cfset datos(530, 'Sincroniza Componentes Salariales con Conceptos de Pago', 0)>
		</cfif>

		<cfif isdefined("Form.validapp")>
			<cfset datos(540, 'Validar Planilla Presupuestaria', 1)>
		<cfelse>
			<cfset datos(540, 'Validar Planilla Presupuestaria', 0)>
		</cfif>
		
		<cfif isdefined("Form.validaagc")>
			<cfset datos(2029, 'Aprobador genera concurso', 1)>
		<cfelse>
			<cfset datos(2029, 'Aprobador genera concurso', 0)>
		</cfif>

		<cfif isdefined("Form.verIncidencias")>
			<cfset datos(550, 'Mostrar Desgloce de Incidencias en Boleta de Pago', 1)>
		<cfelse>
			<cfset datos(550, 'Mostrar Desgloce de Incidencias en Boleta de Pago', 0)>
		</cfif>	
		<cfif isdefined("Form.modifDEAuto")>
			<cfset datos(560, 'Permite modificar Datos de Empleado en Autogestión', 1)>
		<cfelse>
			<cfset datos(560, 'Permite modificar Datos de Empleado en Autogestión', 0)>
		</cfif>	
		<cfif isdefined("Form.RejorMarcador")>
			<cfset datos(570, 'Requerir Contraseña en Reloj Marcador', 1)>
		<cfelse>
			<cfset datos(570, 'Requerir Contraseña en Reloj Marcador', 0)>
		</cfif>	

		<cfif isdefined("Form.decimales")>
			<cfset datos(600, 'Mostrar sin decimales el saldo de vacaciones', 1)>
		<cfelse>
			<cfset datos(600, 'Mostrar sin decimales el saldo de vacaciones', 0)>
		</cfif>	
		
		<!--- PARAMETRO : MARCAS : Cantidad de horas para diferenciar Entrada \ Salida para el proceso
		de agrupamiento de marcas (Validado de 4 a 12 horas) --->
		<cfparam name="Form.cantidadHorasMarcas" default="0" type="numeric">
		<cfset datos(610, 'Cantidad de horas para diferencias E\S proceso agrupamiento marcas', Form.cantidadHorasMarcas)>
		
		<cfparam name="Form.horasSem" default="0" type="numeric">
		<cfset datos(2040, 'Cantidad de horas extra máxima por semana', Form.horasSem)>
		
		<cfparam name="Form.horasMes" default="0" type="numeric">
		<cfset datos(2041, 'Cantidad de horas extra máxima por mes', Form.horasMes)>
		
		<cfif isdefined("Form.RHCalculoHEX")>
			<cfset datos(2042, 'Calcular horas extra por medio de registro de marcas',1) >
		<cfelse>
			<cfset datos(2042, 'Calcular horas extra por medio de registro de marcas',0) >
		</cfif>
		
		<cfif isdefined ('form.IndRep')>
			<cfset datos(2044,'Indicador del Reporte para Magisterio', form.IndRep)>
		</cfif>
		<cfif isdefined ('form.DClinea')>
			<cfset datos(2043,'Carga para Magisterio',form.DClinea)>
		</cfif>

		<!--- Evaluacion y desempeño,% de distribucion y cf fijo--->
		<cfif isdefined ("form.chkPorc_dist") and len(trim(form.chkPorc_dist))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2106, 'Utiliza porcentaje de distribucion de jefatura', temp) >
		
		<cfif isdefined ("form.chkPcf_fijo") and len(trim(form.chkPcf_fijo))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2107, 'Centro Funcional fijo en evaluación', temp) >
		
		<!---Capacitación y Desarrollo--->
		<cfif isdefined ("form.chkDisponibles") and len(trim(form.chkDisponibles))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2112, 'Utilizar consecutivo en Concursos', temp) >
		
		
		<cfif isdefined ('form.LvarCons') and len(trim(form.LvarCons)) gt 0>
			<cfset datos(2113, 'Inicio de Consecutivo', #form.LvarCons#) >
		</cfif>
		
		<cfif isdefined ('form.LvarNotas') and len(trim(form.LvarNotas)) gt 0>
			<cfset datos(2114, 'Nota minima para aprobar concurso', #form.LvarNotas#) >
		</cfif>
		
		<cfif isdefined ("form.chkplazasA") and len(trim(form.chkplazasA))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2115, 'Utilizar plazas activas en Concursos', temp) >
		
		<cfif isdefined ("form.chkdirigido") and len(trim(form.chkdirigido))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2116, 'Activar el campo "Dirigido a" en cursos', temp) >
		
		<cfif isdefined ("form.chkApruebaMat") and len(trim(form.chkApruebaMat))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2109, 'Activar la aprobación de matricula', temp) >
		
		<cfif isdefined ("form.chkfiltros") and len(trim(form.chkfiltros))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2117, 'Activar los filtros de selecci&oacute;n de empleados en cursos', temp) >
		
		<cfif isdefined ('form.LvarAuse') and len(trim(form.LvarAuse)) gt 0>
			<cfset datos(2118, 'Porcentaje m&aacute;ximo de ausencia', #form.LvarAuse#) >
		</cfif>
		
		<cfif isdefined ("form.chkadjP") and len(trim(form.chkadjP))>
			<cfset temp = '1'>
		<cfelse>
			<cfset temp = '0'>
		</cfif>
		<cfset datos(2119, 'Adjudicar la misma plaza a varios concursantes', temp) >

		<cfif isdefined ('form.TDid2') and len(trim(form.TDid2)) gt 0>
			<cfset datos(2111, 'Deducci&oacute;n asociada a la perdida de un curso', #form.TDid2#) >
		</cfif>
		<!--- PARAMETROS : EVALUACION DEL DESEMPEÑO
			PESO DE INDICADORES DE EVALUACION DEL DESEMPEÑO
			AREAS DE EVALUACION: 
				REQUIERE MEJORA, 
				CUMPLE PARCIALMENTE LAS ESPECTATIVAS, 
				CUMPLE SATISFACTORIAMENTE LAS ESPECTATIVAS,
				EXCEDE LAS ESPECTATIVAS
		 --->
		<cfparam name="Form.PesoIndicadores" default="0" type="numeric">
		<cfset datos(620, 'Peso de Indicadores de Evaluacion del Desempeño', Form.PesoIndicadores)>

		<cfparam name="Form.RequiereMejora" default="0" type="numeric">
		<cfset datos(630, 'Area de Evaluacion Requiere Mejora', Form.RequiereMejora)>
		<cfparam name="Form.ParcialEspec" default="0" type="numeric">
		<cfset datos(640, 'Area de Evaluacion Cumple Parcialmente las Espectativas', Form.ParcialEspec)>
		<cfparam name="Form.SatisfacEspec" default="0" type="numeric">
		<cfset datos(650, 'Area de Evaluacion Cumple Satisfactoriamente las Espectativas', Form.SatisfacEspec)>
		<cfparam name="Form.ExcedeEspec" default="0" type="numeric">
		<cfset datos(660, 'Area de Evaluacion Excede las Espectativas', Form.ExcedeEspec)>
		
		<!--- Cantidad de días para anular antigüedad de empleados inactivos --->
		<cfif trim(form.RHCantDiasAnularAntiguedad) gt 0><cfset RHCantDiasAnularAntiguedad = form.RHCantDiasAnularAntiguedad><cfelse><cfset RHCantDiasAnularAntiguedad = 15 ></cfif>
		<cfset datos(670, 'Cantidad de días para anular antigüedad de empleados inactivos', RHCantDiasAnularAntiguedad) >

		<!--- INDICADOR PARA ACTIVAR LOS GRADOS PARA VALORACION DE PUESTOS --->
		<cfset Lvar_ActivaGrados = Isdefined("Form.chkActivaGrados")>
		<cfset datos(675, 'Activar grados para el proceso de valoración de puestos', Lvar_ActivaGrados)>

		<!--- tipo de Progresión para Clasificacion Y Valoracion De Puestos  --->
		<cfset datos(680, 'tipo de Progresión para Clasificacion Y Valoracion De Puestos', #form.progresion#) >
		
		<!--- tipo de aprobación para el descriptivo del puesto  --->
		<cfset datos(690, 'tipo de aprobación para el descriptivo del puesto', #form.Aprobacion#) >

		<!--- Encargado aprobacion final (Centro funcional)  --->
		<cfset datos(700, 'Encargado aprobacion final (Centro funcional)', #form.CFid#) >

		<!--- Encargado aprobacion final (Centro funcional)  --->
		<cfset datos(710, 'Indica si el encargado del centro funcional puede modificar los valores del perfil', #form.ModificaPuesto#) >

		<!--- Tipo boleta de pago  --->
		<cfset datos(720, 'Tipo boleta de pago a utilizar', #form.RHTipoBoleta#) >
		<!--- Concepto de Pago para Anticipo de Salario --->
		<cfif isdefined("Form.CIidA")>
			<cfset datos(730, 'Concepto de Pago para Anticipo de Salario', #form.CIidA#) >
		</cfif>
		<!----=============== Datos Séptimo y Q250 ====================---->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250" 
				returnvariable="Lvar_PagaQ250">
		<cfif Lvar_PagaQ250>
			<cfset datos(740, 'Componente Salarial de Bonificación de Ley(Q250)', #form.CSidq250#) >
			
		</cfif>
		<cfif Lvar_PagaQ250>
			<cfset datos(740, 'Componente Salarial de Bonificación de Ley(Q250)', #form.CSidq250#) >
		</cfif>
		
		<cfif Lvar_PagaSeptimo>
			<cfset datos(750, 'Concepto Incidente de Séptimo', #form.CIidsep#) >
		</cfif>
        
        <cfset Lvar_SalDiaHisSal = Isdefined("Form.cbSalDiaHisSal")>
		<cfset datos(760, 'Mostrar Salario Diario En Historicos Salariales', Lvar_SalDiaHisSal)>
		
		<!--- FUENTES PARA EL PROCESO DE LIQUIDACION DE RENTA --->
		<cfset datos(770, 'Fuente para el proceso de liquidación de renta', URLPLiqu)>
		<cfset datos(775, 'Fuente para el  reporte de liquidacion de renta', URLPLiquRep)>
		
		<!--- INDICADOR PARA UNIFICAR O NO EL SALARIO BRUTO CON LAS INCIDENCIAS --->
		<cfset Lvar_UnificaSalBruto = Isdefined("Form.chkUnificaSalBruto")>
		<cfset datos(785, 'Unificar Salario Bruto e Incidencias en un s&oacute;lo rubro en Boleta de Pago.', Lvar_UnificaSalBruto)>
		
		<cfset Lvar_LiquidaIntereses = Isdefined("Form.chkLiquidaIntereses")>
		<cfset datos(810, 'Paga Cesantía con Intereses al Liquidar', Lvar_LiquidaIntereses)>

		<!--- Incidencia para salario liquidacion de cesantia --->
		<cfif isdefined("form.RHCesantiaLiquidacion") and isdefined("form.RHCesantiaLiquidacion") >
			<cfset incidencia = form.RHCesantiaLiquidacion >
		<cfelse>
			<cfset incidencia = '' >
		</cfif>
		<cfset datos(820, 'Incidencia cálculo de liquidación de cesantía', incidencia) >

		<!--- Competencia a valorar en todos los puestos  --->
		<cfif isdefined("form.RHHid") and len(trim(form.RHHid))>
			<cfset datos(830, 'Competencia a valorar en todos los puestos', #form.RHHid#) >
		</cfif>
		
		<!--- Importador de Deducciones  --->
		<cfif isdefined("form.RHTipoImport") and len(trim(form.RHTipoImport))>
			<cfset datos(840, 'Importador de deducciones ', #form.RHTipoImport#) >
		</cfif>
        
        <!--- Porcentaje para el segundo ajuste en el proceso de dispersión  --->
		<cfif isdefined("form.AJUSTE1") and len(trim(form.AJUSTE1))>
			<cfset datos(850, 'Porcentaje para el segundo ajuste en el proceso de dispersión ', #form.AJUSTE1#) >
		</cfif>
        
        <!--- Porcentaje para el tercer ajuste en el proceso de dispersión  --->
		<cfif isdefined("form.AJUSTE2") and len(trim(form.AJUSTE2))>
			<cfset datos(860, 'Porcentaje para el tercer ajuste en el proceso de dispersión ', #form.AJUSTE2#) >
		</cfif>
        
        <!--- Cuenta Contable Resumen De Acumulacion de Cesantia --->
		<cfif isdefined("form.CuentaResCesantia") and len(trim(form.CuentaResCesantia)) gt 0><cfset CuentaResCesantia = form.CuentaResCesantia><cfelse><cfset CuentaResCesantia = '' ></cfif>
		<cfset datos(870, 'Cuenta Contable Resumen De Acumulacion de Cesantia', CuentaResCesantia)>

        <!--- Cuenta Contable de Intereses de Cesantia --->
		<cfif isdefined("form.CuentaIntCesantia") and len(trim(form.CuentaIntCesantia)) gt 0><cfset CuentaIntCesantia = form.CuentaIntCesantia><cfelse><cfset CuentaIntCesantia = '' ></cfif>
		<cfset datos(880, 'Cuenta Contable de Intereses de Cesantia', CuentaIntCesantia)>
		
		<!---  Mostrar Saldo Al Corte --->
		<cfif isdefined("form.RHMostrarSaldoAlCorte")><cfset MostrarSaldoAlCorte = 1><cfelse><cfset MostrarSaldoAlCorte = 0 ></cfif>
		<cfset datos(890, 'Mostrar Saldo Al Corte(Saldo de vacaciones acumulado al ultimo mes cumplido de antiguedad)', MostrarSaldoAlCorte)>

        <!--- Cuenta Contable de Intereses de Cesantia --->
		<cfif isdefined("form.CuentaBancoCesantia") and len(trim(form.CuentaBancoCesantia)) gt 0><cfset CuentaBancoCesantia = form.CuentaBancoCesantia><cfelse><cfset CuentaBancoCesantia = '' ></cfif>
		<cfset datos(900, 'Cuenta Contable de Bancos para Cesantia', CuentaBancoCesantia)>
		
        
        <!--- Esto no se puede descomentar hasta que este creado el parche de Clasificación y valoración de Puestos  --->
        
		<!--- <cfif form.progresion  neq form.progresionActual>
				<cfquery name="rsFactores" datasource="#session.DSN#">
					select RHFid from RHFactores
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset listaFactores ="">
				<cfif rsFactores.recordCount GT 0>
					<cfloop query="rsFactores">
						<cfset listaFactores = listaFactores & rsFactores.RHFid & ','>
					</cfloop>
					<cfset listaFactores = listaFactores & '-1'> 
				</cfif>
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHGrados
					set RHGporcvalorfactor  = 0
					where RHFid in (#listaFactores#)
				</cfquery>
				<cfinvoke
					Component= "rh.Componentes.RH_CalculoGrados"
					method="CalculoGrados">
				</cfinvoke>
		</cfif> ---> 

		<cfif isdefined("Form.traducir")>
			<cfset datos(17, 'Usar funcionalidad de traducción de etiquetas', 1)>
		<cfelse>
			<cfset datos(17, 'Usar funcionalidad de traducción de etiquetas', 0)>
		</cfif>	

		<cfif isdefined("Form.idtarjeta")>
			<cfset datos(910, 'Usar Id de Tarjeta de empleado (si no lo marca, por defecto usa la identificacion)', 1)>
			<cfset session.tagempleados.tarjeta = true >
		<cfelse>
			<cfset datos(910, 'Usar Id de Tarjeta de empleado (si no lo marca, por defecto usa la identificacion)', 0)>
			<cfset session.tagempleados.tarjeta = false >
		</cfif>	
		
		<!--- 920. Tipo de Expediente Medico--->
		<cfif isdefined("form.tipoExpediente") and len(trim(form.tipoExpediente))>
			<cfset vTipoExpediente = form.tipoExpediente >
		<cfelse>
			<cfset vTipoExpediente = '' >
		</cfif>
		<cfset datos(920, 'Tipo de Expediente por defecto para Medicina de Empresa', Trim(vTipoExpediente))>

		<!--- 930. Tipo de Formatos de Expediente Medico--->
		<cfif isdefined("form.tipoFormato") and len(trim(form.tipoFormato))>
			<cfset vtipoFormato = form.tipoFormato >
		<cfelse>
			<cfset vtipoFormato = '' >
		</cfif>
		<cfset datos(930, 'Tipo de Formato por defecto para Medicina de Empresa', Trim(vtipoFormato))>

		<!----======== Incidencia para calculo de cesantia por renuncia (940)===========---->
		<cfif isdefined("form.RHIncidenciaRenuncia") and isdefined("form.RHIncidenciaRenuncia") >
			<cfset incidencia = form.RHIncidenciaRenuncia >
		<cfelse>
			<cfset incidencia = '' >
		</cfif>
		<cfset datos(940, 'Concepto de Pago para cálculo de Cesantía por Renuncia', incidencia) >

		<!----======== Tipo de accion para calculo de cesantia por renuncia (950)===========---->
		<cfif isdefined("form.RHTipoAccionRenuncia") and isdefined("form.RHTipoAccionRenuncia") >
			<cfset TipoAccion = form.RHTipoAccionRenuncia >
		<cfelse>
			<cfset TipoAccion = '' >
		</cfif>
		<cfset datos(950, 'Tipo de Acción para cálculo de Cesantía por Renuncia', TipoAccion) >

		<!--- Procesa Dias de Enfermedad (desarrollo HDC panama ) --->
		<cfif isdefined("form.RHAplicaDiasEnf") ><cfset procesa = 1 ><cfelse><cfset procesa = 0 ></cfif>
		<cfset datos(960, 'Procesa Días de Enfermedad', Trim(procesa)) >

		<cfset datos(970, 'Tope de días de enfermedad', Trim(form.RHTopesDiasEnf)) >
		<cfset datos(980, 'Cantidad de días para activar proceso de días de enfermedad', Trim(form.RHCantidadDiasEnfermedad)) >
		<cfset datos(990, 'Cantidad de días por asignar si cumple requisitos de días de enfermedad', Trim(form.RHDiasEnfermedadAsignar)) >
		
		<!---  Afecta costo hora extra --->
		<cfif isdefined("form.AfectaCostoHE")><cfset AfectaCostoHE = 1><cfelse><cfset AfectaCostoHE = 0 ></cfif>
		<cfset datos(1000, 'Incidencias tipo importe afectan horas extraordinarias', AfectaCostoHE)>
		
		<!--- Requiere aprobacion de Incidencias --->		
		<cfif isdefined("Form.apruebaIncidencias")>
			<cfset datos(1010, 'Requiere aprobacion de Incidencias', 1)>
		<cfelse>
			<cfset datos(1010, 'Requiere aprobacion de Incidencias', 0)>
		</cfif>
		
		<cfif not isdefined("form.PvalorPorcionSubcidioMexico")><cfset form.PvalorPorcionSubcidioMexico = ''></cfif>
		<cfset datos(2000, 'Porci&oacute;n Subcidio', form.PvalorPorcionSubcidioMexico)>
		
			
		<!--- Consecutivo de aprobacion de incidencias --->		
		<cfquery name="rs_consecutivo" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 1020
		</cfquery>
		<cfif not len(trim(rs_consecutivo.Pvalor))>
			<cfset datos(1020, 'Consecutivo de aprobación de incidencias', 0)>
		</cfif>
		
		<!--- =========================================================================================== --->
		<!--- =========================================================================================== --->
		<!--- El parametro de replicacion solo se usa cuando no hay sido definido, cuando esta nulo. 
			  Una vez que se ha definido (0 ó 1), ya no se modifica más.	
		--->
		<!--- Estos dos parametros se definen para todas las empresas de la corporacion --->
		<cfquery name="rsEmpresas" datasource="#session.DSN#">
			select Ecodigo, Edescripcion
			from Empresas
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
		<cfif isdefined("form.existeReplicacion") and form.existeReplicacion eq 0 >
			<cfloop query="rsEmpresas">
				<cfif isdefined("Form.replicacion")>
					<cfset datos(580, 'Establecer Replicación de Empleados entre Empresas', 1, rsEmpresas.Ecodigo )>
					<cfset datos(590, 'Establecer Empresa Origen para movimiento de Incidencias entre Empresas', Trim(form.repEmpresaOrigen), rsEmpresas.Ecodigo )>				
				<cfelse>
					<cfset datos(580, 'Establecer Replicación de Empleados entre Empresas', 0, rsEmpresas.Ecodigo )>
					<cfset datos(590, 'Establecer Empresa Origen para movimiento de Incidencias entre Empresas', '', rsEmpresas.Ecodigo )>
				</cfif>	
			</cfloop>
		</cfif>
		<!--- =========================================================================================== --->
		<!--- =========================================================================================== --->
		<cfif isdefined("Form.AutoevalTalento")>
			<cfset datos(1030, 'Tomar en cuenta la autoevaluacion para la ponderacion de notas (Eval.Talento y Obj)', 1)>
		<cfelse>
			<cfset datos(1030, 'Tomar en cuenta la autoevaluacion para la ponderacion de notas (Eval.Talento y Obj)', 0)>
		</cfif>
		
		<!--- Mostrar Salario Según el Tipo de Nómina --->
		<cfif isdefined("form.cbSalDiaTpoNomina") >
			<cfset datos(1040, 'Mostrar Salario Nominal en Boletas y Acciones de Personal', 1) >	
		<cfelse>
			<cfset datos(1040, 'Mostrar Salario Nominal en Boletas y Acciones de Personal', 0) >	
		</cfif>
		
		<!--- Conceptos de Pago para el calculo de Septimo --->		
		<cfif Lvar_PagaQ250>
			<cfset Lvar_lista = ''>
			<cfif isdefined('form.chkListaSep') and LEN(TRIM(form.chkListaSep))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.chkListaSep)>
			</cfif>
			<cfif isdefined('form.CIid7') and LEN(TRIM(form.CIid7))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.CIid7)>
			</cfif>
			<cfif isdefined('form.chkLista7') and LEN(TRIM(form.chkLista7))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.chkLista7)>
			</cfif>
			<cfset datos(1050, 'Conceptos de Pago para Cálculo de Séptimo', #Lvar_lista#) >
		</cfif>
		<!--- Requiere aprobacion de Incidencias calculo --->		
		<cfif isdefined("Form.apruebaIncidenciasCalc")>
			<cfset datos(1060, 'Requiere aprobacion de Incidencias de tipo cálculo', 1)>
		<cfelse>
			<cfset datos(1060, 'Requiere aprobacion de Incidencias de tipo cálculo', 0)>
		</cfif>
		
		<!----Parametro 1070 (Mes de inicio para reporte de aguinaldo acumulado (mensual)---->
		<cfif isdefined("form.mesinicialrepaguimensual") and len(trim(form.mesinicialrepaguimensual))>
			<cfset datos(1070, 'Mes de inicio para reporte de aguinaldo acumulado (mensual)', form.mesinicialrepaguimensual)> 
		</cfif>
		<!--- Indicador de Calculo de Renta Manual, es decir por medio de Deducción. --->		
		<cfif isdefined("Form.RentaManual")>
			<cfset datos(1090, 'Activar C&aacute;lculo de Renta por medio de Deducci&oacute;n tipo Renta', 1)>
		<cfelse>
			<cfset datos(1090, 'Activar C&aacute;lculo de Renta por medio de Deducci&oacute;n tipo Renta', 0)>
		</cfif>
		
		<!----1110 Monto de salario minimo diario del ins (Solo para Cefa)----->
		<cfif isdefined("Form.salminimoins")>
			<cfset datos(1110, 'Monto de salario minimo diario del INS', replace(Form.salminimoins, ',','','all'))>
		<cfelse>
			<cfset datos(1110, 'Monto de salario minimo diario del INS', 0.00)>
		</cfif>

		<!--- ljimenez (TEC) Tome en cuenta salario retroactivo para reporte de la CCSS. --->
		<cfif isdefined("Form.RetroativoSS")>
			<cfset datos(305, 'No toma en cuenta los retroactivos para el reporte del S.S.', 'S') >
		<cfelse>
			<cfset datos(305, 'No toma en cuenta los retroactivos para el reporte del S.S.', 'N') >
		</cfif>
		
		<!--- Mostrar Saldo Asignado en Consulta de Vacaciones Autogestión --->
		
		<cfif isdefined("Form.MuestraAsignado")>
			<cfset datos(1120, 'Mostrar Saldo Asignado en Consulta de Vacaciones Autogestión', 'S') >
		<cfelse>
			<cfset datos(1120, 'Mostrar Saldo Asignado en Consulta de Vacaciones Autogestión', 'N') >

		</cfif>

		<!--- PARAMETRO PARA INDICAR SI SE QUIERE HABILITAR EN LOS CATALOGOS CON LA INTERFAZ DE SAP (OE) --->	
		<cfif isdefined("Form.chkInterfazCatSAP")>
			<cfset datos(2010, 'Habilitar Interfaz en Catalogos con SAP (OE)', 1)>
		<cfelse>
			<cfset datos(2010, 'Habilitar Interfaz en Catalogos con SAP (OE)', 0)>
		</cfif>
		
		<cfif isdefined("Form.chkVerificacionContable")>
			<cfset datos(2500, 'Verificaci&oacute;n Contable de Centros Funcionales (Pagos Ordinarios)', 1)>
		<cfelse>
			<cfset datos(2500, 'Verificaci&oacute;n Contable de Centros Funcionales (Pagos Ordinarios)', 0)>
		</cfif>
		
		<cfif isdefined("form.EIcodigo") and len(trim(form.EIcodigo))>
			<cfset datos(2050, 'Muestra el Exportador para el reporte de asientos', #form.EIcodigo#)>
		</cfif>
		
		<cfif isdefined("form.RHEquivPlazasComp") and len(trim(form.RHEquivPlazasComp))>
			<cfset datos(2100, 'Estructura de equivalencia de plazas con componentes', 1) >
		<cfelse>
			<cfset datos(2100, 'Estructura de equivalencia de plazas con componentes', 0) >
		</cfif>

		<cfif isdefined("form.RHPorcOcupPlazaEmpleado") and len(trim(form.RHPorcOcupPlazaEmpleado))>
			<cfset datos(2102, 'Porcentaje ocupacion por plaza de cada empleado', #form.RHPorcOcupPlazaEmpleado#) >
		</cfif>
		
		<cfif isdefined("form.ECid") and len(trim(form.ECid))>
			<cfset datos(2103, 'Cargas a Mostrar', #form.ECid#) >
		</cfif> 
	
		<cfif isdefined("form.RHConseptoPagoRecargo") and len(trim(form.RHConseptoPagoRecargo))>
			<cfset datos(2104, 'Concepto asociado a los recargos por plaza', #form.RHConseptoPagoRecargo#) >
		</cfif>

		<cfif isdefined("form.cargarIncidencias") and len(trim(form.cargarIncidencias))>
			<cfset datos(2105, 'Cargar CF de Servicio en Registro Incidencias', 1) >
		<cfelse>
			<cfset datos(2105, 'Cargar CF de Servicio en Registro Incidencias', 0) >
		</cfif>
		
		<cfif isdefined("Form.IDautomatico")>
			<!---Empleado existen con tipo de identitificador General (G) pero que incluyen otros caracteres adicionales a numericos en DEidentificador --->
			<cfquery name="rsNoValidoC" datasource="#session.dsn#">
				select count(1) as NoValido
				from DatosEmpleado
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and NTIcodigo = 'G'
					and DEidentificacion like '%[^0-9]%'
			</cfquery>
			
			<cfif (isdefined('rsNoValidoC') and rsNoValidoC.NoValido NEQ 0)>
				<cf_throw message="Usar Identificaci&oacute;n Autom&aacute;tica NO permitido existen ID alfanumericos ya registrados" errorcode=9999>
			</cfif>	
			
			<!---Empleado existen con otro tipo de identitificador diferente al General (G)--->
			<cfquery name="rsNoValidoT" datasource="#session.dsn#">
				select count(1) as NoValido
				from DatosEmpleado
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and NTIcodigo <> 'G'
			</cfquery>
			<cfif (isdefined('rsNoValidoT') and rsNoValidoT.NoValido NEQ 0)>
				<cf_throw message="Usar Identificaci&oacute;n Autom&aacute;tica NO permitido existen empleados asociados a otro tipo de identificador" errorcode=9999>
			</cfif>	
			
			<cfset datos(2045, 'Usa Id General Automatico para empleado', 1)>
		<cfelse>
			<cfset datos(2045, 'Usa Id General Automatico para empleado', 0)>
		</cfif>	
		<!---►►►►►►Cargas del IGSS(ISRR)◄◄◄◄◄◄◄--->
        	<cfset LSigss = "">
        <cfif isdefined('form.chk')>
        	<cfset LSigss = LSigss & "#form.chk#">
        </cfif>
        <cfif isdefined('form.DClineaCOP') and LEN(TRIM(form.DClineaCOP)) and ListFind(LSigss,form.DClineaCOP) EQ 0>
			<cfset LSigss = ListAppend(LSigss,form.DClineaCOP)>
        </cfif>
		
		<cfset datos(2120, 'Cargas del IGSS(ISRR)', '#LSigss#' ) >
			
		<cfif (isdefined('form.TDid1') and LEN(TRIM(form.TDid1))) or (isdefined('form.chkLDeduciones') and LEN(TRIM(form.chkLDeduciones)))>
			<cfset Lvar_lista = ''>
			<cfif isdefined('form.TDid1') and LEN(TRIM(form.TDid1))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.TDid1)>
			</cfif>
			<cfif isdefined('form.chkLDeduciones') and LEN(TRIM(form.chkLDeduciones))>
				<cfset Lvar_lista = ListAppend(Lvar_lista,form.chkLDeduciones)>
			</cfif>
			<cfset datos(2110, 'Conceptos de Deduciones para Infonaví', Lvar_lista) >
		<cfelse>
			<cfset datos(2110, 'Conceptos de Deduciones para Infonaví', '') >
		</cfif>

		<cfif isdefined("Form.RHSPNomEsp")>
			<cfset datos(2501, 'Tomar en cuenta nominas especiales para calculo de Salario Promedio', 1)>
		<cfelse>
			<cfset datos(2501, 'Tomar en cuenta nominas especiales para calculo de Salario Promedio', 0)>
		</cfif>
        
        <!--- Controla vacaciones por periodo --->
		<cfif isdefined("Form.ContralaVacacionesPorPeriodo")>
			<cfset datos(2505, 'Controla vacaciones por periodo', 1)>
		<cfelse>
			<cfset datos(2505, 'Controla vacaciones por periodo', 0)>
		</cfif>
		
		<!--- Concepto de Pago para Subcidio de Incapacidades (Cuando la accion de personal no escribe en la linea del tiempo) --->
		<cfif isdefined("form.CIidPSI") and len(trim(form.CIidPSI))>
			<cfset datos(2525, 'Concepto de Pago para Subcidio de Incapacidades', #form.CIidPSI#) >
		<cfelse>
			<cfset datos(2525, 'Concepto de Pago para Subcidio de Incapacidades', '') >
		</cfif>
		
		<!--- Prohibir Incluir Insumos a la Nomina --->
		<cfif isdefined("form.ProhibirAcceso") ><cfset ProhibirAcceso = 1 ><cfelse><cfset ProhibirAcceso = 0 ></cfif>
		<cfset datos(2526, 'Prohibir Incluir Insumos a la Nomina', ProhibirAcceso) >
				
		<!--- Requiere aprobacion de Incidencias por el Jefe del Centro Funcional--->		
		<cfif isdefined("Form.apruebaIncidenciaJefeCF")>
			<cfset datos(2540, 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional', 1)>
		<cfelse>
			<cfset datos(2540, 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional', 0)>
		</cfif>
		
		<!--- Observacion y ckeck de incluir monto/porcentaje de Aumento en las Relaciones de Aumento --->
		<cfif isdefined("form.AumentoSalarialObser") and len(trim(form.AumentoSalarialObser)) GT 0>
			<cfset datos(2541, 'Observacion en Relacion de Aumento', #form.AumentoSalarialObser#) >
		<cfelse>
			<cfset datos(2541, 'Observacion en Relacion de Aumento', '') >
		</cfif>
		
		<cfif isdefined("form.AumentoSalarialCheck") ><cfset AumentoSalarialCheck = 1 ><cfelse><cfset AumentoSalarialCheck = 0 ></cfif>
		<cfset datos(2542, 'Incluir el monto/porcentaje de Aumento en Observacion', AumentoSalarialCheck) >
		
		<cfif isdefined("form.CK_ConsecutivoTarjeta") ><cfset ConsecutivoTarjeta = 1 ><cfelse><cfset ConsecutivoTarjeta = 0 ></cfif>
		<cfset datos(2046, 'Sugerir Consecutivo de ID Tarjeta', ConsecutivoTarjeta,session.Ecodigo) >
		
		<cfif isdefined("form.Check_DistribuyeCargas") ><cfset DistribuirCargasPat = 1 ><cfelse><cfset DistribuirCargasPat = 0 ></cfif>
		<cfset datos(2550, 'Distribuir Cargas Patronales según gasto por Centro Funcional ', DistribuirCargasPat,session.Ecodigo) >
		
        <!---SML. Modificacion para Agregar lo de Fondo de Ahorro en la Boleta de Pago--->
        <cfif isdefined("form.CHK_RHFOA") ><cfset FondoAhorro = 1 ><cfelse><cfset FondoAhorro = 0 ></cfif>
		<cfset datos(721, 'Fondo de Ahorro en Boleta de Pago', FondoAhorro,session.Ecodigo) >

		
	</cftransaction>		
</cfif>

<cflocation url="Parametros.cfm?tab=#form.tab#">
