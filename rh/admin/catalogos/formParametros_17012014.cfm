<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_SePresentaronLosSiguientesErroresElParametroDeEmpresaOrigenParaReplicacionDeIncidenciasEsRequerido" default="Se presentaron los siguientes errores:\n - El parámetro de empresa origen para replicación de incidencias es requerido" returnvariable="MSG_SePresentaronLosSiguientesErroresElParametroDeEmpresaOrigenParaReplicacionDeIncidenciasEsRequerido" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_CantidadDeHorasParaDiferenciasEntradaSalidaParaElProcesoDeAgrupamientoDeMarcas" default="Se presentaron los siguientes errores:\n - La Cantidad de horas para diferencias Entrada \ Salida para el proceso de agrupamiento de marcas debe estar entre 4 y 12" returnvariable="MSG_CantidadDeHorasParaDiferenciasEntradaSalidaParaElProcesoDeAgrupamientoDeMarcas" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ElPesoDeLosIndicadoresDeEvaluacionDebeEstarEntre0Y100" default="El peso de los Indicadores de Evaluación debe estar entre 0 y 100" returnvariable="MSG_ElPesoDeLosIndicadoresDeEvaluacionDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ElAreaDeEvalucionRequiereMejoraDebeEstarEntre0Y100" default="El Area de evalución Requiere Mejora debe estar entre 0 y 100" returnvariable="MSG_ElAreaDeEvalucionRequiereMejoraDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ElAreaDeEvalucionCumpleSatisfactoriamenteLasEspectativasDebeEstarEntre0Y100" default="El Area de evalución Cumple Satisfactoria las Espectativas debe estar entre 0 y 100" returnvariable="MSG_ElAreaDeEvalucionCumpleSatisfactoriaLasEspectativasDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ElAreaDeEvalucionCumpleParcialmenteLasEspectativasDebeEstarEntre0Y100" default="El Area de evalución Cumple Parcialmente las Espectativas debe estar entre 0 y 100" returnvariable="MSG_ElAreaDeEvalucionCumpleParcialmenteLasEspectativasDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml" />
<cfinvoke key="MSG_ElAreaDeEvalucionExcedeLasEspectativasDebeEstarEntre0Y100" default="El Area de evalución Excede las Espectativas debe estar entre 0 y 100" returnvariable="MSG_ElAreaDeEvalucionExcedeLasEspectativasDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_LaSumaDeLasAreasDeEvaluacionDebenSumar100" default="La Suma de las Areas de Evaluación deben sumar 100" returnvariable="MSG_LaSumaDeLasAreasDeEvaluacionDebenSumar100" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="TAB_Contabilizacion" default="Contabilizaci&oacute;n" returnvariable="TAB_Contabilizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="TAB_NOMINA" default="N&oacute;mina" returnvariable="TAB_NOMINA" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="TAB_AccionesDePersonal" default="Acciones de Personal" returnvariable="TAB_AccionesDePersonal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="TAB_Modulos" default="M&oacute;dulos" returnvariable="TAB_Modulos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="TAB_Legislacion" default="Legislaci&oacute;n" returnvariable="TAB_Legislacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="TAB_Otros" default="Otros" returnvariable="TAB_Otros" component="sif.Componentes.Translate" method="Translate"/>						
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
<cfif IsDefined('url.tab')>
	<cfset form.tab = url.tab>
<cfelse>
	<cfparam name="form.tab" default="1">
</cfif>
<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab) )>
	<cfset form.tab = 1 >
</cfif>
	
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doImpuestoRenta() {
		popUpWindow("ConlisIRenta.cfm?form=form1&id=CMSid&nombre=CMSnombre",250,200,650,350);
	}
	
	function asignar(obj, tipo){
		if (trim(obj.value) == '') {
			switch (tipo){
				case 'S' :
					obj.value = 7;
				break;
				case 'B' :
					obj.value = 14;
				break;
				case 'Q' :
					obj.value = 15;
				break;
				case 'M' :
					obj.value = 30;
				break;
			}
		}
		return;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function validar(){
		document.form1.RedondeoMonto.value = qf(document.form1.RedondeoMonto);
		document.form1.SMmensual.value = qf(document.form1.SMmensual);
		
		<cfif isdefined("form.tab") and form.tab eq 2 >
			if ( document.form1.replicacion.checked ){
				if ( document.form1.repEmpresaOrigen.value == '' ){
					alert('<cfoutput>#MSG_SePresentaronLosSiguientesErroresElParametroDeEmpresaOrigenParaReplicacionDeIncidenciasEsRequerido#</cfoutput>.');
					return false;
				}
			}
		</cfif>
		<cfif isdefined("form.tab") and form.tab eq 4 >
			if ( parseInt(document.form1.cantidadHorasMarcas.value) < 4
				|| parseInt(document.form1.cantidadHorasMarcas.value) > 12 ){
					alert('<cfoutput>#MSG_CantidadDeHorasParaDiferenciasEntradaSalidaParaElProcesoDeAgrupamientoDeMarcas#</cfoutput>.');
					return false;
			}
			if  ( parseInt(document.form1.PesoIndicadores.value) < 0
					|| parseInt(document.form1.PesoIndicadores.value) > 100){
					alert('<cfoutput>#MSG_ElPesoDeLosIndicadoresDeEvaluacionDebeEstarEntre0Y100#</cfoutput>.');
					return false;
			}
			if  ( parseInt(document.form1.RequiereMejora.value) < 0
					|| parseInt(document.form1.RequiereMejora.value) > 100){
					alert('<cfoutput>#MSG_ElAreaDeEvalucionRequiereMejoraDebeEstarEntre0Y100#</cfoutput>.');
					return false;
			}
			if  ( parseInt(document.form1.ParcialEspec.value) < 0
					|| parseInt(document.form1.ParcialEspec.value) > 100){
					alert('<cfoutput>#MSG_ElAreaDeEvalucionCumpleParcialmenteLasEspectativasDebeEstarEntre0Y100#</cfoutput>.');
					return false;
			}
			if  ( parseInt(document.form1.SatisfacEspec.value) < 0
					|| parseInt(document.form1.SatisfacEspec.value) > 100){
					alert('<cfoutput>#MSG_ElAreaDeEvalucionCumpleSatisfactoriaLasEspectativasDebeEstarEntre0Y100#</cfoutput>.');
					return false;
			}
			if  ( parseInt(document.form1.ExcedeEspec.value) < 0
					|| parseInt(document.form1.ExcedeEspec.value) > 100){
					alert('<cfoutput>#MSG_ElAreaDeEvalucionExcedeLasEspectativasDebeEstarEntre0Y100#</cfoutput>.');
					return false;
			}
			if ((parseInt(document.form1.RequiereMejora.value)+parseInt(document.form1.ParcialEspec.value)+parseInt(document.form1.SatisfacEspec.value)+parseInt(document.form1.ExcedeEspec.value))>100){
				alert('<cfoutput>#MSG_LaSumaDeLasAreasDeEvaluacionDebenSumar100#</cfoutput>.');
				return false;
							
			}		
		</cfif>
		
		return true;
	}

</script>

 <!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select Pvalor 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- obtiene los datos,  si ya existen --->
<cfset definidos              		= ObtenerDato(5)>	<!--- Parametrizacion Definida --->
<cfset PvalorPagoNomina       		= ObtenerDato(7)>	<!--- RH, Banco Virtual --->
<cfset PvalorIContable        		= ObtenerDato(20)>	<!--- Interfaz contable --->
<cfset PvalorACUnificado      		= ObtenerDato(25)>	<!--- Asiento Contable Unificado --->
<cfset PvalorIRenta           		= ObtenerDato(30)>	<!--- Impuesto Renta --->
<cfset PvalorCalculoRentaRetroactivo= ObtenerDato(31)>	<!--- Indicador de calculo de renta retroativo TEC 2010-05-26 ljimenez --->
<cfset PvalorTPSemanal        		= ObtenerDato(40)>	<!--- Tipo Pago Semanal --->
<cfset PvalorTPBisemanal      		= ObtenerDato(50)>	<!--- Tipo Pago Bisemanal --->
<cfset PvalorTPQuincenal      		= ObtenerDato(60)>	<!--- Tipo Pago Quincenal --->
<cfset PvalorTPMensual        		= ObtenerDato(70)>	<!--- Tipo Pago Mensual --->
<cfset PvalorCNMensual        		= ObtenerDato(80)>	<!--- Calculo Mensual --->
<cfset PvalorDiasTipoNomina   		= ObtenerDato(90)>	<!--- Calculo Quincenal --->
<cfset PvalorRedondeoMonto    		= ObtenerDato(110)>	<!--- Redondeo a monto --->
<cfset PvalorTipoRedondeo     		= ObtenerDato(120)>	<!--- Tipo de Redondeo --->
<cfset PvalorSMmensual        		= ObtenerDato(130)>	<!--- Salario minimo mensual --->
<cfset PvalorCuentaRenta      		= ObtenerDato(140)>	<!--- Cuenta Contable de renta --->
<cfset PvalorCuentaPagos      		= ObtenerDato(150)>	<!--- Cuenta Contable de pagos no Realizados --->
<cfset PvalorPeriodos         		= ObtenerDato(160)>	<!--- Cantidad de Periodos para Calculo Salario Promedio --->
<cfset PvalorTiposDePeriodos        = ObtenerDato(161)>	<!--- indica el tipo de periodos  --->
<cfset TiposDePeriodos= '0'>


<cfif PvalorTiposDePeriodos.RecordCount GT 0 >
	<cfset TiposDePeriodos= PvalorTiposDePeriodos.Pvalor>
</cfif>
<cfset PvalorCorreoPago       		= ObtenerDato(170)>	<!--- Manda correo de boleta de pago --->
<cfset PvalorAdministrador    		= ObtenerDato(180)>	<!--- Administrador --->
<cfset PvalorCorreoBoleta     		= ObtenerDato(190)>	<!--- Cuenta de Correo (DE:) en boleta de Pago  --->
<cfset PvalorAgendaMedica     		= ObtenerDato(220)>	<!--- Codigo de Agenda Medica --->
<cfset PvalorTipoEvaluacion   		= ObtenerDato(230)>	<!--- Tipo de evaluacion del desempeño  --->
<cfset PvalorTipoCalculoRenta  		= ObtenerDato(255)>	<!--- Cantidad de Dias antes para asignar Vacaciones  --->
<cfset PvalorDiasAntesVac     		= ObtenerDato(260)>	<!--- Cantidad de Dias antes para asignar Vacaciones  --->
<cfset PvalorProcesaEnf       		= ObtenerDato(270)>	<!--- Procesa dias de enfermedad --->
<cfset PvalorUltimaCorridaVac 		= ObtenerDato(280)>	<!--- Ultima fecha de coorida de vacaciones --->
<cfset PvalorScriptMarcas 	  		= ObtenerDato(290)> <!--- Nombre del Script de Importacion de Marcas de Reloj --->
<cfset PvalorNumeroPatronal   		= ObtenerDato(300)> <!--- Numero Patronal para reporte Seguro Social --->
<cfset PvalorRetroativoSS   		= ObtenerDato(305)> <!--- No toma en cuenta el los retroactivos en para el reporte de la CCSS  --->
<cfset PvalorImpSeguroSocial  		= ObtenerDato(310)> <!--- Importador para archivo de Seguro Social --->
<cfset PvalorPolizaDE       		= ObtenerDato(311)>	<!--- Procesa dias de enfermedad --->
<cfset PvalorImpINS  		  		= ObtenerDato(320)> <!--- Importador para archivo del INS --->
<cfset PvalorCalculaComisionSB  	= ObtenerDato(330)> <!--- Calcula comision con Salario Base --->
<cfset PvalorCalculaComisionCSB  	= ObtenerDato(331)> <!--- Calcula comision completa con Salario Base  ljimenez 2010-09-04 --->

<cfset PvalorIncidenciaRebajoSB		= ObtenerDato(340)> <!--- Incidencia para Rebajo para salario por calculo de comisiones  --->
<cfset PvalorIncidenciaSB 			= ObtenerDato(350)> <!--- Incidencia para Salario Base --->
<cfset PvalorIncidenciaAjusteSB		= ObtenerDato(360)> <!--- Incidencia para ajuste de salario base --->
<cfset PvalorScriptComisiones		= ObtenerDato(370)> <!--- Script de Importacion de Comisiones --->
<cfset PvalorIncidenciasSalRec		= ObtenerDato(380)> <!--- Incidencias por salario recibido --->
<cfset PvalorScriptPagoNomina		= ObtenerDato(390)> <!--- Script de Exportacion de Pago de Nomina --->
<cfset PvalorRequiereCFConta		= ObtenerDato(400)> <!--- Requerir Centro Funcional de Contabilizacion --->
<cfset PvalorRequiereSucAds			= ObtenerDato(410)> <!--- Requerir Sucursal Adscrita CCSS --->
<cfset PvalorRequierePolIns			= ObtenerDato(420)> <!--- Requerir Numero de Poliza del Ins --->
<cfset PvalorProteccionTrab			= ObtenerDato(430)> <!--- Fecha de Corte en Cálculo de Cesantia (Boleta) --->
<cfset PvalorPeriodosLiq			= ObtenerDato(440)> <!--- Cantidad de Periodos para Cálculo de Salario Promedio (Boleta)--->
<cfset PvalorBenziger		    	= ObtenerDato(450)> <!--- Usa test de Bezinger --->
<cfset PvalorAccionNombramiento 	= ObtenerDato(460)> <!--- Accion Nombramiento --->
<cfset PvalorAccionCambio			= ObtenerDato(470)> <!--- Accion Cambio --->
<cfset PvalorAutorizaMarcas     	= ObtenerDato(480)> <!--- Autorización de Marcas para RH--->
<cfset PvalorContabilizaMes     	= ObtenerDato(490)> <!--- Contabilización de Gastos por Mes --->
<cfset PvalorDistribucionCargasPatronales  	= ObtenerDato(1080)> <!--- Distribución de Cargas Patronales --->
<cfset PvalorDistribucionCargasEmpleado  	= ObtenerDato(1100)> <!--- Distribución de Cargas Empleado --->

<cfset PvalorCuentaPasivo     		= ObtenerDato(500)> <!--- Cuenta de Pasivo para Contabilización de Gastos por Mes --->
<cfset PvalorDetalleInconsistencias = ObtenerDato(510)> <!--- Autoriza Detalle de Inconsistencias de la tabla RHInconsistencias --->
<cfset PvalorCentroCosto     		= ObtenerDato(520)> <!--- Centro Funcional equivalente a Centro de Costos --->
<cfset PvalorSincroniza     		= ObtenerDato(530)> <!--- Centro Funcional equivalente a Centro de Costos --->
<cfset PvalorValidaPP     			= ObtenerDato(540)> <!--- Centro Funcional equivalente a Centro de Costos --->
<cfset PvalorValidaControlPresupuestoNomina	= ObtenerDato(541)> <!--- Control de Presupuesto en Nómina --->
<cfset PvalorVerIncidencias			= ObtenerDato(550)> <!--- Mostrar desgloce de Incidencias en Boleta de Pago --->
<cfset PvalorDatosEmplado			= ObtenerDato(560)> <!--- Modificar los Datos de Empleados en Autogestión --->
<cfset PvalorRelojMarcador			= ObtenerDato(570)> <!--- Requerir contraseña en Reloj Marcador en Autogestión --->
<cfset PvalorReplicacion			= ObtenerDato(580)> <!--- Establecer Replicación de Empleados entre Empresas 0/1 --->
<cfset PvalorEmpresaOrigen			= ObtenerDato(590)> <!--- Empresa Origen de Incidencias --->
<cfset PvalorDecimales				= ObtenerDato(600)> <!--- Muestra decimales en saldos de vacaciones --->
<cfset PvalorCantidadHorasMarcas 	= ObtenerDato(610)> <!--- Cantidad de horas para diferenciar Entrada \ Salida para el proceso de agrupamiento de marcas (Validado de 4 a 12 horas) --->
<cfset PvalorTraducir				= ObtenerDato(17)>  <!--- Traducir o no etiquetas  --->
<cfset PvalorPesoIndicadoresED		= ObtenerDato(620)> <!--- Peso de Indicadores de Evaluacion del Desempeño  --->
<cfset PvalorAreaEvalReqMejora		= ObtenerDato(630)> <!--- Porcentaje Area de Evaluación Requiere Mejora  --->
<cfset PvalorAreaEvalCumplePar		= ObtenerDato(640)> <!--- Porcentaje Area de Evaluación Cumple Parcialmente las Espectativas  --->
<cfset PvalorAreaEvalCumpleSat		= ObtenerDato(650)> <!--- Porcentaje Area de Evaluación Cumple Satisfactoriamente las Espectativas  --->
<cfset PvalorAreaEvalExcedeEsp		= ObtenerDato(660)> <!--- Porcentaje Area de Evaluación Excede las Espectativas  --->
<cfset PvalorCantDiasAnularAntig	= ObtenerDato(670)>	<!--- Cantidad de días para anular antigüedad de empleados inactivos --->
<cfset PvalorActivarGradosVal		= ObtenerDato(675)>	<!--- Activa los grados para la valoración de Puestos --->
<cfset Pvalorprogresion				= ObtenerDato(680)> <!--- tipo de Progresión para Clasificacion Y Valoracion De Puestos --->
<cfset PvalorAprobacion				= ObtenerDato(690)> <!--- tipo de aprobacion para el descriptivo del puesto--->
<cfset PvalorAprobacionFinal		= ObtenerDato(700)> <!--- Ultimo usuario en aprobar el descriptivo del puesto--->
<cfset PvalorModificaPuesto 		= ObtenerDato(710)> <!--- Indica si el encargado del centro funcional puede modificar los valores del perfil --->
<cfset PvalorTipoBoletaPago  		= ObtenerDato(720)>	<!--- Tipo de boleta de pago a utilizar  --->
<cfset PvalorMostarFOABoletaPago  	= ObtenerDato(721)>	<!--- SML. Mostrar Fondo de Ahorro en Boleta de Pago  --->
<cfset PvalorCPagoAnticipos  		= ObtenerDato(730)>	<!--- Concepto de Pago para Anticipos  --->
<cfset PvalorSalDiaHisSal	  		= ObtenerDato(760)>	<!--- Mostrar Salario Diario En Historicos Salariales --->
<cfset PvalorProcesoLiqRenta  		= ObtenerDato(770)>	<!--- Mostrar Salario Diario En Historicos Salariales --->
<cfset PvalorRepProcesoLiqRenta		= ObtenerDato(775)>	<!--- Mostrar Salario Diario En Historicos Salariales --->
<cfset PvalorUnificaSalBruto		= ObtenerDato(785)>	<!--- Unifica el salario bruto y las incidencias en un solo rubro (despliegue) --->



<cfset PLiquidaIntereses	  		= ObtenerDato(810)>	<!--- Paga Cesantía con Intereses al Liquidar --->
<cfset PvalorIncidenciaLiquidacion	= ObtenerDato(820)> <!--- Incidencia para calculo de liquidacion de cesantia  --->
<cfset PvalorCompetencia  			= ObtenerDato(830)>	<!--- Competencia a valorar en todas los puestos (acepta nullos) --->
<cfset PvalorTipoImport  			= ObtenerDato(840)>	<!--- Importador de deducciones --->
<cfset Pvalorajuste1				= ObtenerDato(850)> <!--- Porcentaje para el segundo ajuste en el proceso de dispersión --->
<cfset Pvalorajuste2				= ObtenerDato(860)> <!--- Porcentaje para el tercer ajuste en el proceso de dispersión --->
<cfset PvalorCtaResCesantia			= ObtenerDato(870)> <!--- Cuenta Contable Resumen de Acumulacion de Cesantia --->
<cfset PvalorCtaIntCesantia			= ObtenerDato(880)> <!--- Cuenta Contable Intereses de Cesantia --->
<cfset PvalorMostrarSaldoAlCorte	= ObtenerDato(890)> <!--- Mostrar Saldo Al Corte --->
<cfset PvalorCtaBancoCesantia	    = ObtenerDato(900)> <!--- Cuenta Contable Bancos para Cesantia --->
<cfset PvalorIDTarjeta				= ObtenerDato(910)> <!--- Usar identificacion o ID de tarjeta  --->
<cfset PvalorTipoExp				= ObtenerDato(920)> <!--- Tipo de Expediente para medicina de empresa --->
<cfset PvalorTipoFormatoExp			= ObtenerDato(930)> <!--- Tipo de formato de Exp. para medicina de empresa --->
<cfset PvalorIncidenciaRenuncia		= ObtenerDato(940)> <!--- Incidencia para calculo de cesantia por renuncia --->
<cfset PvalorTipoAccionRenuncia		= ObtenerDato(950)> <!--- Tipo de accion para calculo de cesantia por renuncia --->
<cfset PvalorAplicaDiasEnfermedad	= ObtenerDato(960)> <!--- Usa opcion de dias de Enfermedad --->
<cfset PvalorTopeDiasEnfermedad		= ObtenerDato(970)> <!--- Tope dias de enfermedad  --->
<cfset PvalorCantidadDiasEnfermedad = ObtenerDato(980)> <!--- Cantidad de dias laborales para activar proceso de dias de enfermedad --->
<cfset PvalorDiasEnfermedadAsignar	= ObtenerDato(990)> <!--- Cantidad de dias por asignar si cumple requisitos por dias de enfermedad --->
<cfset PvalorAfectaCostoHE			= ObtenerDato(1000)> <!--- Bit de si Las incidencias de hora extra afectan el costo--->
<cfset PvalorApruebaIncidencias		= ObtenerDato(1010)> <!--- Requiere aprobacion de incidencias --->
<cfset PvalorNumConsecutivo			= ObtenerDato(1020)> <!--- numero de consecutivo de aprobacion de incidencias --->
<cfset PvalorAutoevalTalento		= ObtenerDato(1030)> <!--- Bit para indicar si toma o no en cuenta la autevaluacion en la ponderacion de notas en el modulo de adm. del talento y objetivos--->
<cfset PvalorSalTipoNomina	  		= ObtenerDato(1040)><!--- Mostrar Salario nominal en boletas y acciones de personal --->
<cfset PvalorConceptosCalSept 		= ObtenerDato(1050)> <!--- Lista de Conceptos de Pago para el calculo de Séptimo--->
<cfset PvalorApruebaIncidenciasCalc = ObtenerDato(1060)> <!--- Requiere aprobacion de incidencias tipo Calculo--->
<cfset PvalorOrdenAguinaldoMensual	= ObtenerDato(1070)> <!--- Mes de inicio para el pintado del reporte de aguinaldo por mes en autogestion--->
<cfset PvalorRentaManual			= ObtenerDato(1090)> <!--- Indicador para manejo Manual de Calculo de Renta--->
<cfset PvalorSalMinimoINS			= ObtenerDato(1110)> <!--- Salario minimo aceptado por el INS para el exportador de riesgos del trabajo--->
<cfset PvalorMuestraAsignado		= ObtenerDato(1120)> <!--- Mostrar Saldo Asignado en Consulta de Vacaciones Autogestión--->

<cfset PvalorPorcionSubcidioMexico  = ObtenerDato(2000)> <!--- Porsion de subsidio Mexico --->
<cfset PInterfazCatSAP	  			= ObtenerDato(2010)> <!--- Indicador de Interfaz en los Catalogos con SAP (OE) --->
<cfset PvalorComponenteRenta		= ObtenerDato(2020)> <!--- Selecciona el col componente de renta que vamos a utilizar default RH_CalculoNominaRentaCRC --->

<!--- Parametros incluidos Legislacion MEXICO --->
<cfset PvalorSMGA		            = ObtenerDato(2024)> <!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
<cfset PvalorEsmexico	            = ObtenerDato(2025)> <!--- MEX - Usa opcion para definir si estamos en mexico --->
<cfset PvalorAjusteSalarioNegativo	= ObtenerDato(2026)> <!--- MEX - Si se desea hacer ajuste en caso de salarios negativos --->
<cfset PvalorDeduccionAjuste  		= ObtenerDato(2027)> <!--- MEX - Concepto de Pago por el que se va a manejar el ajuste salarial negativo --->
<cfset PvalorSalarioMinimoZona 		= ObtenerDato(2028)> <!--- MEX - Activar el uso de salario minimo general (SMG) --->
<cfset PAprobadorGeneraConcuro		= ObtenerDato(2029)> <!--- MEX - Únicamente para planilla presupuestaria, indica si el aprobador de planilla presupuestaria puede generar concursos cuando se aprueba una solicitud de plaza realizada por autogestión--->
<cfset PvalorModificaSDI            = ObtenerDato(2030)> <!--- MEX - Activa la modificacion del SDI en el expediente empleado (mexico) --->
<cfset PvalorCPagoVacaciones  		= ObtenerDato(2031)> <!--- MEX - Concepto de Pago para Vacaciones  --->
<cfset PvalorImpAfiliatorios  		= ObtenerDato(2032)> <!--- MEX - Concepto de Pago para Afiliatorios SUA  --->
<cfset PvalorCPagoSubsidio  		= ObtenerDato(2033)> <!--- MEX - Concepto de Pago para Subsidio salario  --->
<cfset PvalorMtoSeguro		 		= ObtenerDato(2034)> <!--- MEX - Monto a que se rebaja por seguro en la deduccion de infonavit 2011-07-29 --->

<cfset PvalorRentaTipoNomina		= ObtenerDato(2035)> <!--- MEX - Activa la utilizacion de Tablas de renta segun tipo de nomina --->

<cfset PvalorImpIncapacidades 		= ObtenerDato(2036)> <!--- MEX - Concepto de Pago para Incapacidades SUA  --->
<cfset PvalorSPIncapacidad 			= ObtenerDato(2037)> <!--- TEC - Parametro que indica si el salario promedio toma en cuenta las incapacidades---> 
<cfset PvalorSPRetroactivos			= ObtenerDato(2038)> <!--- TEC - Parametro que indica si el salario promedio toma en cuenta los retroactivos---> 
<cfset PvalorCPTipoAccion			= ObtenerDato(2039)> <!--- TEC - Tipo de Accion para Carrera Profesional---> 
<cfset PhorasMaxSemana 				= ObtenerDato(2040)> <!--- Máximo horas extra por semana  --->
<cfset PhorasMaxMes 				= ObtenerDato(2041)> <!--- Máximo horas extra por mes  --->
<cfset PcalcularHEX 				= ObtenerDato(2042)> <!--- Permite el calculo de horas extras cuando no se paga por horas trabajadas  --->
<cfset Pcargas 		        		= ObtenerDato(2043)> <!--- Permite el calculo de horas extras cuando no se paga por horas trabajadas  --->
<cfset Pletra_cargas 				= ObtenerDato(2044)> <!--- Permite el calculo de horas extras cuando no se paga por horas trabajadas  --->
<cfset PvalorIDautomatico 			= ObtenerDato(2045)> <!--- MEX Habilita el uso de Identificador del empleado automatico  --->
<cfset PvalorSugerirConsecutivoTarjeta	= ObtenerDato(2046)> <!--- Sugerir Consecutivo de Tarjeta de Empleado  --->

<cfset PExportadorReporteAsiento	= ObtenerDato(2050)> <!--- Para guardar el expotador para los reportes de asiento--->






<!----------------------------------------------->


<cfset PequivalenciaPlazasComponentes	= ObtenerDato(2100)> <!--- Parametro para saber si vamos a utilizar la estructura de equivalencia de plazas con componentes--->
<!--- <cfset PporcentajeOcupacionPlaza	= ObtenerDato(2101)> Parametro para restringir el porcentaje de ocupacion máximo para cada plaza--->
<cfset PporcentajeOcupacionPlazaEmpleado= ObtenerDato(2102)> <!--- Parametro para restringir el porcentaje de ocupacion máximo por plaza por empleado--->
<cfset PcargasMostrar	                = ObtenerDato(2103)> <!--- Parametro para agregar las Cargas --->
<cfset PvalorConseptoPagoRecargo 		= ObtenerDato(2104)> <!--- Parametro para el concepto que se asociara a los componentes de recargo de plaza---> 
<cfset PmuestraCC           		    = ObtenerDato(2105)> <!--- Indica si se debe desplegar la cuenta contable en el reporte de Consulta de Estructura Organizacional  --->
<cfset PvalorCargarIncidencias			= ObtenerDato(2105)> <!--- Parametro que indica si se debe cargar automaticamente el CF de Servicio en Registro de Incidencias ---> 
<cfset Pporc_distr    					= ObtenerDato(2106)> <!--- Permite el calculo de horas extras cuando no se paga por horas trabajadas  --->
<cfset Pcf_fijo 				    	= ObtenerDato(2107)> <!--- Permite el calculo de horas extras cuando no se paga por horas trabajadas  --->
<cfset Pcuotas   				    	= ObtenerDato(2108)> <!--- Cantidad de quincenas que se rebajara los cursos que el empleado pierde  --->
<cfset PapruebaMat      		    	= ObtenerDato(2109)> <!--- Indica si la matricula debe de pasar por un proceso de aprobación  --->

<cfset PtipoDed         		    	= ObtenerDato(2111)> <!--- Tipo de deducción asociada a la perdida de un curso  --->
<cfset PConsActivar						= ObtenerDato(2112)> <!--- Indica si se usa el consecutivo en los concursos  --->
<cfset PConsecutivo						= ObtenerDato(2113)> <!--- Numero por el que inicia el consecutivo  --->
<cfset PNotaMinima				    	= ObtenerDato(2114)> <!--- Nota minima por la que se da aprobado el concurso  --->
<cfset PactivaC 				    	= ObtenerDato(2115)> <!--- Indica si se toma en cuenta las plazas activas en el concurso --->
<cfset Pdirigido 				    	= ObtenerDato(2116)> <!--- Indica si se toma en cuenta las plazas activas en el concurso --->
<cfset Pfiltros 				    	= ObtenerDato(2117)> <!--- Indica si se toma en cuenta las plazas activas en el concurso --->
<cfset PporcAus         		    	= ObtenerDato(2118)> <!--- Indica si se toma en cuenta las plazas activas en el concurso --->
<cfset PvariasPlazas    		    	= ObtenerDato(2119)> <!--- Indica si se toma en cuenta las plazas activas en el concurso --->
<cfset rsListaCargasIGSS				= ObtenerDato(2120)> <!---Cargas del IGSS(ISRR)--->


<cfset PvalorVerificaCFConta				= ObtenerDato(2500)> <!--- Verificación Contable de Centros Funcionales (Pagos Ordinarios) --->
<cfset PvalorSPnominasEspeciales			= ObtenerDato(2501)> <!--- Tomar en cuenta nóminas especiales para el cálculo del salario promedio --->

<cfset PvalorControlaVacacionesPorPeriodo	= ObtenerDato(2505)> <!--- Controla vacaciones por periodo --->

<cfset PvalorConceptoSubsidioIncapacidad	= ObtenerDato(2525)> <!--- Concepto de Pago para Subcidio de Incapacidades (Cuando la accion de personal no escribe en la linea del tiempo) --->

<cfset PvalorValidaAcceso					= ObtenerDato(2526)> <!--- Prohibir Incluir Insumos a la Nomina --->

<cfset PvalorApruebaIncidenciasJefeCF 		= ObtenerDato(2540)> <!--- Requiere aprobacion de incidencias  del Jefe del Centro Funcional--->

<cfset PvalorAumentoSalarialObser 		= ObtenerDato(2541)> <!--- Observación Predefinida para las Acciones de Aumento Salarial Masivo--->
<cfset PvalorAumentoSalarialCheck 		= ObtenerDato(2542)> <!--- Incluir el monto/porcentaje de Aumento en Observación--->

<cfset PvalorCheckDistribuyeCargasIncidencias 		= ObtenerDato(2550)> <!--- check de Distribuir Cargas Patronales según gasto por Centro Funcional ,  1 = distribuye cargas, 0 =  No distribuye--->

<!--- valida la existencia de los datos --->
<cfif PvalorPagoNomina.RecordCount GT 0 >
<!--- Usa RH, banco virtual --->
<cfset existePagoNomina = true><cfelse><cfset existePagoNomina = false ></cfif>		
<!--- Progresión para Clasificacion Y Valoracion De Puestos --->
<cfif Pvalorprogresion.RecordCount GT 0 ><cfset existeprogresion = true><cfelse><cfset existeprogresion = false ></cfif>				

<cfif PvalorAprobacion.RecordCount GT 0 ><cfset existeAprobacion = true><cfelse><cfset existeAprobacion = false ></cfif>		

<cfif PvalorMuestraAsignado.RecordCount GT 0 ><cfset existeMuestraAsignado = true><cfelse><cfset existeMuestraAsignado = false ></cfif>			

<cfif PvalorAprobacionFinal.RecordCount GT 0 and len(trim(PvalorAprobacionFinal.Pvalor)) gt 0><cfset existeAprobadorFinal = true><cfelse><cfset existeAprobadorFinal = false ></cfif>				

<cfif PvalorCompetencia.RecordCount GT 0 and len(trim(PvalorCompetencia.Pvalor)) gt 0>
	<cfset Competencia = PvalorCompetencia.Pvalor>
<cfelse>
	<cfset Competencia = "">
</cfif>				

<!---Consultas y Reportes mostrar Cuenta contable--->
<cfif PmuestraCC.RecordCount GT 0 ><cfset CountPmuestraCC = true><cfelse><cfset CountPmuestraCC = false ></cfif>		


<cfif PvalorModificaPuesto.RecordCount GT 0 and len(trim(PvalorModificaPuesto.Pvalor)) gt 0><cfset existeModificaPuesto = true><cfelse><cfset existeModificaPuesto = false ></cfif>				


<!--- Usa Interfaz Contable --->
<cfif PvalorIContable.RecordCount GT 0 ><cfset existeIContable = 1><cfelse><cfset existeIContable = 0 ></cfif>				
<!--- Impuesto de Renta--->	
<cfif PvalorIRenta.RecordCount GT 0 ><cfset existeIRenta = 1><cfelse><cfset existeIRenta = 0 ></cfif>
<!--- Dias para Calculo de nomina Quincenal --->
<cfif PvalorDiasTipoNomina.RecordCount GT 0 ><cfset existeDiasTipoNomina = 1><cfelse><cfset existeDiasTipoNomina = 0 ></cfif>	
<!--- Cuenta Contable de Renta --->
<cfif PvalorCuentaRenta.RecordCount GT 0 ><cfset existeCuentaRenta = 1><cfelse><cfset existeCuentaRenta = 0 ></cfif>		
<!--- Cuenta Contable de pagos no realizados --->
<cfif PvalorCuentaPagos.RecordCount GT 0 ><cfset existeCuentaPagos = 1><cfelse><cfset existeCuentapagos = 0 ></cfif>		
<!--- Manda correo de boleta de pago --->
<cfif PvalorCorreoPago.RecordCount GT 0 ><cfset existeCorreoPago = 1 ><cfelse><cfset existeCorreoPago = 0 ></cfif>		
<!--- Usuario Administrador --->		
<cfif PvalorAdministrador.RecordCount GT 0 and len(trim(PvalorAdministrador.Pvalor)) GT 0><cfset existeAdministrador = 1 ><cfelse><cfset existeAdministrador = 0 ></cfif>
<!--- Cuenta de Pasivo --->
<cfif PvalorCuentaPasivo.RecordCount GT 0 and len(trim(PvalorCuentaPasivo.Pvalor)) GT 0><cfset existeCuentaPasivo = 1 ><cfelse><cfset existeCuentaPasivo = 0 ></cfif>
<!--- Cuenta Contable Resumen de Acumulacion de Cesantia --->
<cfif PvalorCtaResCesantia.RecordCount GT 0 ><cfset existeCuentaResCesantia = 1><cfelse><cfset existeCuentaResCesantia = 0 ></cfif>		
<!--- Cuenta Contable Intereses de Cesantia --->
<cfif PvalorCtaIntCesantia.RecordCount GT 0 ><cfset existeCuentaIntCesantia = 1><cfelse><cfset existeCuentaIntCesantia = 0 ></cfif>
<cfif PvalorCtaBancoCesantia.RecordCount GT 0 ><cfset existeCuentaBancoCesantia = 1><cfelse><cfset existeCuentaBancoCesantia = 0 ></cfif>
<!---Monto de salario minimo aceptado por INS (SOLO PARA CEFA ) ---->
<cfif PvalorSalMinimoINS.RecordCount GT 0 ><cfset vn_PvalorSalMinimoINS = PvalorSalMinimoINS.Pvalor><cfelse><cfset vn_PvalorSalMinimoINS = 0 ></cfif>



		<table width="100%" cellpadding="2" cellspacing="0" style="vertical-align:top; ">
			<tr><td valign="top">
			<form style="margin:0; " action="SQLParametros.cfm" method="post" name="form1" onsubmit="javascript: return validar();" >			
			<input type="hidden" name="tab" value="<cfif isdefined('form.tab') and form.tab NEQ ''><cfoutput>#form.tab#</cfoutput><cfelse>1</cfif>">
			<cf_tabs width="100%" onclick="tab_set_current_param">
			
				<cf_tab text="<cfoutput>#TAB_Contabilizacion#</cfoutput>" id="1" selected="#form.tab is '1'#">
					<cfinclude template="contabilidad-tab.cfm">
				</cf_tab>

				<cf_tab text="<cfoutput>#TAB_NOMINA#</cfoutput>" id="2" selected="#form.tab is '2'#">
					<cfinclude template="nomina-tab.cfm">
				</cf_tab>
				<cf_tab text="<cfoutput>#TAB_AccionesDePersonal#</cfoutput>" id="3" selected="#form.tab is '3'#">
					<cfinclude template="acciones-tab.cfm">
				</cf_tab>
				<cf_tab text="<cfoutput>#TAB_Modulos#</cfoutput>" id="4" selected="#form.tab is '4'#">
					<cfinclude template="modulos-tab.cfm">
				</cf_tab>
				<cf_tab text="<cfoutput>#TAB_Otros#</cfoutput>" id="5" selected="#form.tab is '5'#">				
					<cfinclude template="otros-tab.cfm">
				</cf_tab>
				<cf_tab text="<cfoutput>#TAB_Legislacion#</cfoutput>" id="6" selected="#form.tab is '6'#">				
					<cfinclude template="legislacion-tab.cfm">
				</cf_tab> 
			</cf_tabs>
			</form>
			</td></tr>
		</table>

<script language="javascript1.2" type="text/javascript">
	function doAdministrador() {
		popUpWindow("ConlisUsuarios2.cfm",250,200,650,350);
	}
	
	function mostrar_tabla(tipo){
		document.getElementById('id_tabla').style.visibility = tipo;
	}
	
	function salario_base(valor){
		var f = document.form1;
		if ( valor ){
			f['CalculaComisionC'].checked = 0;
		}
		IncComision(document.form1.CalculaComision.checked)
	}
	
	function salario_baseC(valor){
		var f = document.form1;
		if ( valor ){
			f['CalculaComision'].checked = 0;
		}
		IncComision(document.form1.CalculaComisionC.checked)
	}
	
	function IncComision(valor){
		var f = document.form1;
		if ( valor ){
			f['RHrebajo'].disabled 		= false;
			f['RHincidencia'].disabled 	= false;
			f['RHajuste'].disabled 		= false;
			f['impComision'].disabled 	= false;
		}
		else{
			f['RHrebajo'].disabled 		= true;
			f['RHincidencia'].disabled 	= true;
			f['RHajuste'].disabled 		= true;
			f['impComision'].disabled 	= true;
		}
	}
	
	if ((document.form1.CalculaComision.checked) || (document.form1.CalculaComisionC.checked)) {
		IncComision(1)
	}
	else {
		IncComision(0)
	}

	function tab_set_current_param (n){
		location.href='Parametros.cfm?tab='+escape(n);
	}
	
	function ShowDeduccionAjuste(obj){
		var objDA = document.getElementById('trDA');
		if(obj.checked){
			objDA.style.display = '';
		}
		else{
			objDA.style.display = 'none';
		}	
	}			
	
</script>
