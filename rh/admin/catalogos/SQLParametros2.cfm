<cfif isDefined("Form.btnAceptar")>
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="datos" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">
		<cfquery name="checkExists" datasource="#Session.DSN#">
			select 1
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
		</cfquery>
		<!--- Update --->
		<cfif checkExists.recordCount GT 0>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				update RHParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pvalor)#" null="#len(trim(pvalor)) EQ 0#">,
					Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pdescripcion)#">
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		<!--- Insert --->
		<cfelse>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				    <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pdescripcion)#">, 
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
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
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

		<!--- 2.1 Asiento Contable Unificado --->
		<cfif isdefined("form.ACUnificado") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(25, 'Asiento Contable Unificado', dato) >
	
		<!--- 3. Tabla de Renta --->
		<cfset datos(30, 'Tabla de Impuesto de Renta', form.IRcodigo ) >
		
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
		<cfif len(trim(form.CNMensual)) gt 0><cfset CNmensual = form.CNMensual><cfelse><cfset CNmensual = 30 ></cfif>
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
	
		<!--- 31. Incidencia para rebajo  --->
		<cfif isdefined("form.CalculaComision") and isdefined("form.RHrebajo") >
			<cfset rebajo = form.RHrebajo >
		<cfelse>
			<cfset rebajo = '' >
		</cfif>
		<cfset datos(340, 'Incidencia para rebajo de salario por calculo de comisiones', rebajo) >

		<!--- 32. Incidencia para salario base  --->
		<cfif isdefined("form.CalculaComision") and isdefined("form.RHincidencia") >
			<cfset incidencia = form.RHincidencia >
		<cfelse>
			<cfset incidencia = '' >
		</cfif>
		<cfset datos(350, 'Incidencia para salario base', incidencia) >

		<!--- 33. Incidencia para salario base  --->
		<cfif isdefined("form.CalculaComision") and isdefined("form.RHajuste") >
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


	</cftransaction>		
</cfif>
<cflocation url="Parametros.cfm">
<!---
<form action="Parametros.cfm" method="post" name="sql"></form>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
--->