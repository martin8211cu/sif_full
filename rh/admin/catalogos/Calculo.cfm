<!--- Se debe de utilizar el componente de la calculadora 
	
	ruta:
	rh.Componentes.RH_Calculadora
	
	Se debe de llamar de la siguiente manera
	
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
	<cfset presets_text = RH_Calculadora.get_presets()>
	<cfset values = RH_Calculadoracalculate( presets_text & ";" & form.formulas)>
	<cfset RH_Calculadora.validate_result( values )>
	
	Se crearon 2 mwtodos para llamar a las variables utilizadas:
	
	<cfset calc_error = RH_Calculadora.getCalc_error()>
	<cfset preset_descr = RH_Calculadora.getPreset_descr()>
	
--->
<cfthrow message="El fuente esta obsoleto, se debde de utilizar rh.Componentes.RH_Calculadora">
<!---
<cfsetting requesttimeout="1800">

<cfinclude template="/rh/Utiles/funciones.cfm">

<!--- traduccion de los mensajes que van a salir al definir la formula del concepto --->
<cfinclude template="calculadora/Calculo-traduccion.cfm">

<!--- 	RESULTADO: 
		Retorna el numero de dias entre dos fechas usando como base un calendario de 30 dias por mes y 360 dias en el anno.
		Formula:
			(Y2-Y1) x 360 + (M2-M1) x 30 + (D2-D1)	
		Especifiaciones:
			if D1 is 31 then it is changed to 30 and if D2 is 31, it is changed to 30 only if D1 is 30 or 31. 
			For the special case of February, '1' in the above formula is replaced by 'the number of days in the month'
--->
<cffunction name="funcDias360" access="public" returntype="numeric" >
	<cfargument name="fecha1" type="date" required="yes">
	<cfargument name="fecha2" type="date" required="yes">	
	
	<cfset vfecha1 = arguments.fecha1 >
	<cfset vfecha2 = arguments.fecha2 >
	<cfset y1 = year(vfecha1) >
	<cfset m1 = month(vfecha1)>
	<cfset d1 = day(vfecha1)>
	<cfset y2 = year(vfecha2) >
	<cfset m2 = month(vfecha2)>
	<cfset d2 = day(vfecha2)>
	
	<cfif m1 eq 2 >
		<cfif d1 eq daysinmonth(vfecha1) >
			<cfset d1 = 30 >
		</cfif>
	<cfelse>
		<cfif d1 eq 31 >
			<cfset d1 = 30 >
		</cfif>
	</cfif>
	<cfif m2 eq 2 >
		<cfif d2 eq daysinmonth(vfecha2) and d1 eq 30 >
			<cfset d2 = 30 >
		</cfif>
	<cfelse>
		<cfif d2 eq 31 and d1 eq 30 >
			<cfset d2 = 30 >
		</cfif>
	</cfif>
	<cfset resultado = ((Y2-Y1) * 360) + ((M2-M1) * 30) + (D2-D1) >
	<cfreturn abs(resultado) >
</cffunction>
<!--- Funciones de Calculo --->
<cfscript>
	function calculate ( input_text ) {
		var rdr = "";
		var parser = "";
		var m = "";
		calc_error = "";
		try {
			rdr = CreateObject("java", "java.io.StringReader");
			parser = CreateObject("java", "com.soin.rh.calculo.Calculator");
			rdr.init(input_text);
			parser.init(rdr);
			parser.parse();
			return parser.getSymbolTable();
		}
		catch(java.lang.Throwable excpt) {
			calc_error = excpt.Message;
		}
	}
	function validate_result ( symt ) {
		if (Len(calc_error) EQ 0) {
			try {
				symt.get("cantidad");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "<cfoutput>#MSG_CalculoCantidad#</cfoutput>";
			}
			try {		
				symt.get("importe");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "<cfoutput>#MSG_CalculoImporte#</cfoutput>";
			}
			try {
				symt.get("resultado");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "<cfoutput>#MSG_CalculoResultado#</cfoutput>";
			}
		}
	}
</cfscript>

<!--- Parámetros:
		Fecha1_Accion: Fecha de inicio de la acción
		Fecha2_Accion: Fecha de fin de la acción
		CIcantidad:    Cantidad de periodos (dias, semanas, meses o años) parametrizada en la tabla de conceptos de pago (CIncidentes)
		CItipo:        Tipo de periodos (dias, semanas, meses o años) parametrizada en la tabla de conceptos de pago (CIncidentes). d|w|m|y.
		DEid:          Código del empleado
		RHTid:         Código del tipo de acción --->
<cffunction access="public" name="get_presets" returntype="string" output="false">
	<cfargument name="Fecha1_Accion" 	type="date"    required="true" 	default="#DateAdd('d',  7, Now())#"><!--- CreateDate(2003,10,20)  --->
	<cfargument name="Fecha2_Accion" 	type="date"    required="true" 	default="#DateAdd('d', 14, Now())#">
	<cfargument name="CIcantidad"    	type="numeric" required="true" 	default="12">
	<cfargument name="CIrango"       	type="string"  required="true" 	default=""><!--- numero pero acepta nulos --->
	<cfargument name="CItipo"        	type="string"  required="true" 	default="m" >
	<cfargument name="DEid"          	type="numeric" required="true" 	default="0">
	<cfargument name="RHJid"         	type="numeric" required="true" 	default="1">
	<cfargument name="Ecodigo"       	type="numeric" required="true" 	default="#session.Ecodigo#">
	<cfargument name="RHTid"         	type="numeric" required="true" 	default="10">
	<cfargument name="RHAlinea"      	type="numeric" required="true" 	default="0">
	<cfargument name="CIdia"         	type="string"  required="true" 	default="">
	<cfargument name="CImes"         	type="string"  required="true" 	default="">
	<cfargument name="Tcodigo"       	type="string"  required="true" 	default="">
	<cfargument name="calc_promedio" 	type="boolean" required="true" 	default="yes">
	<cfargument name="masivo" 		 	type="boolean" required="false" default="false">
	<cfargument name="tablaTemporal" 	type="string"  required="false" default="">
	<cfargument name="calc_diasnomina" 	type="boolean" required="false" default="false" >
	<cfargument name="cantidad"		 	type="numeric" required="false" default="0">
	<cfargument name="origen"		 	type="string"  required="false" default="RHAcciones">	<!--- Indicador para ejecutar los queries sobre RHAcciones en DLaboralesEmpleado, solo si el valor de este parametro es DLaboralesEmpleado (Recalculo de Liquidacion de Personal) --->	
	<cfargument name="CIsprango"	 	type="string"  required="false" default=""> <!---ljimenez Parametro Concepto Pago tipo calculo meses/periodos calculo de salario promedio--->
	<cfargument name="CIspcantidad"	 	type="numeric" required="false" default="0"><!---ljimenez Parametro Concepto Pago tipo calculo cantidad meses/periodos calculo de salario promedio--->
	<cfargument name="CImescompleto" 	type="numeric" required="false" default="0"><!---ljimenez si usa meses completos para el calculo de salario promedio--->
	<cfargument name="FijarVariable" 	type="struct"  required="false">
    
	<cfset lvarmasivo 		 = Arguments.masivo>	
	<cfset tbl_PagosEmpleado = Arguments.tablaTemporal>
	<cfset lvarRHAlinea 	 = Arguments.RHAlinea>
	
	<!--- 	Porque se separo en 3 archivos este fuente: 
			Porque da problemas en Coldfusion 8 un archivo tan grande como este(?? excede los  N bytes disponibles).
			La ejecucion en cf8 se caia, se decidio con aprobacion de Marcel hacer archivos separados de los tres savecontents que estaban
			en este fuente e incluirlos aca.  Esto no da problemas. No es le solucion mas elegante, pero de momento sirve.
			El orden de los includes se hizo igual a como estaban los savecontents inicialmente (presets_ret, presets_ret3, presets_ret2), 
			no cambiar este orden por si se usan variables de un savecontent a otro.
	--->

	<!--- 	Include del archivo PRESETS_RET
			Variables que calcula:
				importacion_cantidad
				Fecha1_Accion
				Fecha2_Accion
				Dias
				Dias360
				Dias_habiles
				Fecha1_ultima_accion
				Fecha2_ultima_accion
				Fecha_Ingreso
				Antigüedad
				Fecha_Ultima_Liquidacion
				Porcentaje_Cesantia
				Antiguedad360
				Periodos_teorico
				Fecha1_Accion_2
				Fecha_Salarios
				Fecha_Salarios_Final
				Periodos_real
				SumaSalario
				SumaCS
				PorcentajeOcupacion
				SumaIncidencia
				SumaIncidencia_[codigo]
				Carga_[codigo]
				SalarioActual
				Porcentaje_Salario
				Salario_[CScodigo]
				DiasVacaciones
				DiasVacacionesPag
				SalarioPromedio
				SalarioPromedioVacLiq
				SalarioContratacion
				Dias_Faltas
				Dias_Incapacidad
			Crea el savecontent presets_ret
	--->
	<cfinclude template="calculadora/presets_ret.cfm">

	<!--- 	Include del archivo PRESETS_RET3
			Variables que calcula:
				DiasRealesCalculoNomina
				Dias_Incapacidad
				Fecha1_Incapacidad
				Dias_Incapacidad
				Saldo_Vacaciones
				DiasPagoLiq
				TipoPago
				FactorDiasSalario
				DiasVacacionesAcum
				SalarioPromedioVacLiq
				VacacionesPeriodo
				SMG
				SMGA
				SDI
			Crea el savecontent presets_ret3
	--->
	<cfinclude template="calculadora/presets_ret3.cfm">
	
	<!---	Include del archivo PRESETS_RET2
			Variables que calcula:
			HorasDiarias
				Destajo
				Jornada_Hnormales
				Jornada_Hextras
				Jornada_factorN
				Jornada_factorA
				SalarioPromedioLiq
				Saldo_VacacionesM
				SumaPagosAccion_[RHTcodigo]
				SaldoDiasEnfermedad
				DiasEnfermedadRebajar
				diasNoLaborados
				diasNominaPagados
				HorasSemanalJornada
				DiasSemanalJornada
				HorasDiariasJornada
			Crea el savecontent presets_ret2
	--->
	<cfinclude template="calculadora/presets_ret2.cfm">
	
	<cfreturn presets_ret & presets_ret3 & presets_ret2>
</cffunction>
--->