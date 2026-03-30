<cfset LvarNL = chr(13) & chr(10)>

<cfset fnAgregarClasificacion ('AC', 'Actividad')>
<cfset fnAgregarClasificacion ('AR', 'Area de Responsabilidad')>
<cfset fnAgregarClasificacion ('CG', 'Clase de Gastos')>
<cfset fnAgregarClasificacion ('OG', 'Objeto de Gasto')>
<cfset fnAgregarClasificacion ('TI', 'Tipo de Inversion')>
<cfset fnAgregarClasificacion ('CI', 'Clase de Inversion')>
<cfset fnAgregarClasificacion ('VN', 'Ventas Netas por Localizacion')>


<!--- 
	<cfquery name="rsReporte" datasource="#session.dsn#">
		delete from CPReportes
	</cfquery>
	<cfquery name="rsReporte" datasource="#session.dsn#">
		delete from CPReportesDef
	</cfquery>
	<cfset structDelete(session.Presupuesto, "CPRDtipo")>
--->

<cfset fnComunes ("*")>
<cfset fnDosPinos ("dospinos")>
<cfset fnRicardoPerez ("gcp - Ricardo Perez")>
<cfset fnTEC ("ITCR")>
<cfset fnLaNacion ("GN")>

<!--- DEFINICION DE REPORTES PARA LA NACION --->
<cffunction name="fnLaNacion">
	<cfargument name="CPRDtipo"	type="string" required="yes">

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-1n",
			"Control de Presupuesto Mensual",
			"CONTROL DE SALDOS MENSUALES DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·7·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦PARA EL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·U#LvarNL#" &
		"1·Presupuesto Ordinario·[A]¦1·Presupuesto Extraordinario·[M]¦1·Variaciones Cambiarias·[VC]¦1·Traslados Presupuestarios·[T]+[TE]¦1·Excesos Autorizados·[ME]¦1·PRESUPUESTO AUTORIZADO·*[C1]+[C2]+[C3]+[C4]+[C5]¦1·Provisión Presupuestaria·[RP]¦1·Reservas·[*RT]¦1·Compromisos·[*CT]¦1·Ejecuciones·[ET]¦1·PRESUPUESTO CONSUMIDO·*[C7]+[C8]+[C9]+[C10]¦1·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])¦1·Disminuciones Pendientes·[NP]¦1·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])+[C13]¦1·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C10])¦#LvarNL#" &
		"3·0·[]·1·S·[]¦1·0·[]·2·N·[]"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-2n",
			"Control de Presupuesto Acumulado",
			"CONTROL DE SALDOS ACUMULADOS DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·7·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·U#LvarNL#" &
		"2·Presupuesto Ordinario·[A]¦2·Presupuesto Extraordinario·[M]¦2·Variaciones Cambiarias·[VC]¦2·Traslados Presupuestarios·[T]+[TE]¦2·Excesos Autorizados·[ME]¦2·PRESUPUESTO AUTORIZADO·*[C1]+[C2]+[C3]+[C4]+[C5]¦2·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Compromisos·[*CT]¦2·Ejecuciones·[ET]¦2·PRESUPUESTO CONSUMIDO·*[C7]+[C8]+[C9]+[C10]¦2·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])¦2·Disminuciones Pendientes·[NP]¦2·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])+[C13]¦2·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C10])¦#LvarNL#" &
		"3·0·[]·1·S·[]¦1·0·[]·2·N·[]"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"Usuarios",
			"Reporte para usuarios",
			"",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·9·bold·50¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·10·bold·10¦Corte3·10·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦5·CC¦1·U#LvarNL#" &
		"1·[TIPODATO-1]·[DATO-1]¦1·[TIPODATO-2]·[DATO-2]¦1·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C1]-[C2]¦1·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%(([C1]/[C2])-1)¦2·[TIPODATO-1]·[DATO-1]¦2·[TIPODATO-2]·[DATO-2]¦2·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C5]-[C6]¦2·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%(([C5]/[C6])-1)¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦6·1·[ET]·[]·[]·[]¦6·2·[*PF]·[]·[]·[]¦7·0·[]·[]·S·[]¦3·0·[]·1·S·[]¦1·0·[]·2·N·[]¦5·0·0·0·0·0"
		,65,'LH'
	)>
</cffunction>

<!--- DEFINICION DE REPORTES PARA EL TECNOLÓGICO --->
<cffunction name="fnTEC">
	<cfargument name="CPRDtipo"	type="string" required="yes">

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"EGRESOS",
			"Ejecución de Egresos para Contraloría",
			"EJECUCION DE EGRESOS DETALLADO PARA CONTRALORÍA",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Corte4·8·none·30¦Corte5·7·none·40¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO PRESUPUESTARIO DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦EJECUCIONES DE [MESINIMAY] A [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·1#LvarNL#" &
		"3·Presupuesto Ordinario·[A]¦3·Presupuesto Extraordinario·[M]¦3·Modicaciones Formales·[TE]¦3·TOTAL PRESUPUESTO·*[C1]+[C2]+[C3]¦7·Egresos<BR>[RANGO_ANT]·*[C7]-[C6]¦7·Egresos<BR>[RANGO_FEC]·[ET]¦2·TOTAL EGRESOS EFECTIVO·[ET]¦2·Compromisos·[CC]¦2·TOTAL GENERAL EGRESOS·*[C7]+[C8]¦3·Provisiones·[RP]¦3·MONTO SUB/SOBRE EJECUTADO·*[C1]+[C2]+[C3]-([C7]+[C8])¦3·% EJECUTADO·%([C7]+[C8])/([C1]+[C2]+[C3])¦#LvarNL#" &
		"3·0·[]·2·S·[]¦8·1·[]·[]·S·[]¦1·0·[]·2·N·[]¦4·2·U,1,2,3,4,5,6,7,8,9,10·0·0·0"
		,65,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INGRESOS",
			"Ejecución de INGRESOS para Contraloría",
			"EJECUCION DE INGRESOS DETALLADO PARA CONTRALORÍA",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Corte4·8·none·30¦Corte5·7·none·40¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO PRESUPUESTARIO DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦EJECUCIONES DE [MESINIMAY] A [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·1#LvarNL#" &
		"3·Presupuesto Ordinario·[A]¦3·Presupuesto Extraordinario·[M]¦3·TOTAL PRESUPUESTO·*[C1]+[C2]¦7·Ingresos<BR>[RANGO_ANT]·*[C6]-[C5]¦7·Ingresos<BR>[RANGO_FEC]·[ET]¦2·TOTAL INGRESOS·[ET]¦3·MONTO SUB/SOBRE EJECUTADO·*[C1]+[C2]-([C6])¦3·% EJECUTADO·%([C6])/([C1]+[C2])¦#LvarNL#" &
		"3·0·[]·2·S·[]¦8·1·[]·[]·S·[]¦1·0·[]·2·N·[]¦4·2·U,1,2,3,4,5,6,7,8,9,10·0·0·0"
		,65,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"SALDOS-1a",
			"Saldos Planeados y Consumidos",
			"REPORTE DE SALDOS DE PRESUPUESTO PLANEADO Y CONSUMIDO [TEMPORAL]<BR>PARA CUENTAS DE [TIPOCUENTAMAY]",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·0¦1·U#LvarNL#" &
		"0·Presupuesto Ordinario·[A]¦0·Presupuesto Extraordinario·[M]¦0·Traslados Internos·[T]¦0·Traslados Externos·[TE]¦0·PRESUPUESTO PLANEADO·[*PP]¦0·Presupuesto Reservado·[RC]¦0·Presupuesto Comprometido·[CC]¦0·Presupuesto Ejecutado·[ET]¦0·Provisiones Presupuestarias·[RP]¦0·PRESUPUESTO CONSUMIDO·[*PC]¦0·DISPONIBLE NETO·[*DN]¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦7·0·[]·[]·S·[]¦3·0·[]·3·S·[]¦1·0·[]·2·N·[]¦4·3·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>
</cffunction>

<!--- DEFINICION DE REPORTES PARA CUALQUIER CLIENTE --->
<cffunction name="fnComunes">
	<cfargument name="CPRDtipo"	type="string" required="yes">

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"SALDOS-1",
			"Todos los Saldos en Dimensión Temporal",
			"REPORTE DE TODOS LOS SALDOS DE CONTROL DE PRESUPUESTO [TEMPORAL]<BR>PARA CUENTAS DE [TIPOCUENTAMAY]",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·0¦1·U#LvarNL#" &
		"0·Presupuesto Ordinario·[A]¦0·Presupuesto Extraordinario·[M]¦0·PRESUPUESTO FORMULADO·*[*PF]¦0·Traslados Internos·[T]¦0·Traslados Externos·[TE]¦0·Variaciones Cambiarias·[VC]¦0·PRESUPUESTO PLANEADO·*[*PP]¦0·Excesos Autorizados·[ME]¦0·PRESUPUESTO AUTORIZADO·*[*PA]¦0·Presupuesto Reservado Per.Anterior·[RA]¦0·Presupuesto Comprometido Per.Anterior·[CA]¦0·Presupuesto Reservado·[RC]¦0·Presupuesto Comprometido·[CC]¦0·Presupuesto Ejecutado·[ET]¦0·CONSUMO AUXILIARES Y CONTABILIDAD·*[*PCA]¦0·Provisiones Presupuestarias·[RP]¦0·PRESUPUESTO CONSUMIDO·*[*PC]¦0·NRPs&nbsp;Aprobados Pendientes de Aplicar·[NP]¦0·DISPONIBLE NETO·*[*DN]¦0·DIFERENCIA (FORMULADO- EJECUTADO)·*[*DEF]¦0·PORCENTAJE (EJECUTADO/ FORMULADO)·%[ET]/[*PF]¦0·DIFERENCIA (PLANEADO- EJECUTADO)·[*DEP]¦0·PORCENTAJE (EJECUTADO/ PLANEADO)·%[ET]/[*PP]¦0·DIFERENCIA (AUTORIZADO- EJECUTADO)·[*DEA]¦0·PORCENTAJE (EJECUTADO/ AUTORIZADO)·%[ET]/[*PA]¦0·DIFERENCIA (FORMULADO- CONSUMIDO)·[*DCF]¦0·PORCENTAJE (CONSUMIDO/ FORMULADO)·%[*PC]/[*PF]¦0·DIFERENCIA (PLANEADO- CONSUMIDO)·[*DCP]¦0·PORCENTAJE (CONSUMIDO/ PLANEADO)·%[*PC]/[*PP]¦0·DIFERENCIA (AUTORIZADO- CONSUMIDO)·[*DCA]¦0·PORCENTAJE (CONSUMIDO/ AUTORIZADO)·%[*PC]/[*PA]¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦7·0·[]·[]·S·[]¦3·0·[]·3·S·[]¦1·0·[]·2·N·[]¦4·3·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"SALDOS-2",
			"Un sólo Saldo por Mes",
			"REPORTE DE SALDOS DE [TIPODATOMAY-1] POR MES<BR>PARA CUENTAS DE [TIPOCUENTAMAY]",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·0¦1·U¦3·H#LvarNL#" &
		"1·[TIPODATOMAY] ACUMULADO A [MESMAY]·[A]¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦6·1·[]·[]·[]·[]¦7·0·[]·[]·S·[]¦3·0·[]·1·S·[]¦1·0·[]·2·N·[]¦4·3·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"SALDOS-3",
			"Un Saldo por Mes VS. otro Acumulado",
			"REPORTE DE SALDOS DE [TIPODATOMAY-1] POR MES<BR>VS. [TIPODATOMAY-2] [TEMPORAL]<BR>PARA CUENTAS DE [TIPOCUENTAMAY]",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·0¦1·U¦3·H#LvarNL#" &
		"1·[TIPODATOMAY] ACUMULADO A [MESMAY]·[A]¦0·[TIPODATO]·[A]¦0·Diferencia ([TIPODATO-2]- [TIPODATO-1])·*[C2]-[T1]¦0·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[T1]/[C2]¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦6·1·[]·[]·[]·[]¦6·2·[]·[]·[]·[]¦7·0·[]·[]·S·[]¦3·0·2,3·3·S·[]¦1·0·[]·2·N·[]¦4·3·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"SALDOS-4",
			"Comparativo de dos Saldos en el Tiempo",
			"REPORTE COMPARATIVO DE SALDOS DE [TIPODATOMAY-1] CONTRA [TIPODATOMAY-2]<BR>PARA CUENTAS DE [TIPOCUENTAMAY]",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·9·bold·20¦Datos·9·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦A [MESMAY] DE [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·0¦1·U#LvarNL#" &
		"1·[TIPODATO]·[A]¦1·[TIPODATO]·[A]¦1·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C1]-[C2]¦1·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C1]/[C2]¦2·[TIPODATO-1]·[DATO-1]¦2·[TIPODATO-2]·[DATO-2]¦2·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C5]-[C6]¦2·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C5]/[C6]¦3·[TIPODATO-1]·[DATO-1]¦3·[TIPODATO-2]·[DATO-2]¦3·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C9]-[C10]¦3·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C9]/[C10]¦4·[TIPODATO-1]·[DATO-1]¦4·[TIPODATO-2]·[DATO-2]¦4·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C13]-[C14]¦4·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C13]/[C14]¦5·[TIPODATO-1]·[DATO-1]¦5·[TIPODATO-2]·[DATO-2]¦5·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C17]-[C18]¦5·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C17]/[C18]¦6·[TIPODATO-1]·[DATO-1]¦6·[TIPODATO-2]·[DATO-2]¦6·Diferencia ([TIPODATO-1]- [TIPODATO-2])·*[C21]-[C22]¦6·Porcentaje ([TIPODATO-1]/ [TIPODATO-2])·%[C21]/[C22]¦#LvarNL#" &
		"8·1·[]·[]·S·[]¦6·1·[]·[]·[]·[]¦6·2·[]·[]·[]·[]¦7·0·[]·[]·S·[]¦3·0·[]·1·S·[]¦1·0·[]·2·N·[]¦4·3·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>
</cffunction>

<!--- DEFINICION DE REPORTES PARA DOS PINOS --->
<cffunction name="fnDosPinos">
	<cfargument name="CPRDtipo"	type="string" required="yes">

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-1",
			"Control de Presupuesto Mensual",
			"CONTROL DE SALDOS MENSUALES DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·7·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦PARA EL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·U#LvarNL#" &
		"1·Presupuesto Ordinario·[A]¦1·Presupuesto Extraordinario·[M]¦1·Variaciones Cambiarias·[VC]¦1·Traslados Presupuestarios·[T]+[TE]¦1·Excesos Autorizados·[ME]¦1·PRESUPUESTO AUTORIZADO·*[C1]+[C2]+[C3]+[C4]+[C5]¦1·Provisión Presupuestaria·[RP]¦1·Reservas·[*RT]¦1·Compromisos·[*CT]¦1·Ejecuciones·[ET]¦1·PRESUPUESTO CONSUMIDO·*[C7]+[C8]+[C9]+[C10]¦1·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])¦1·Disminuciones Pendientes·[NP]¦1·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])+[C13]¦1·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C10])¦#LvarNL#" &
		"3·0·[]·1·S·[]¦1·0·[]·2·N·[]"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-2",
			"Control de Presupuesto Acumulado",
			"CONTROL DE SALDOS ACUMULADOS DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·7·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·U#LvarNL#" &
		"2·Presupuesto Ordinario·[A]¦2·Presupuesto Extraordinario·[M]¦2·Variaciones Cambiarias·[VC]¦2·Traslados Presupuestarios·[T]+[TE]¦2·Excesos Autorizados·[ME]¦2·PRESUPUESTO AUTORIZADO·*[C1]+[C2]+[C3]+[C4]+[C5]¦2·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Compromisos·[*CT]¦2·Ejecuciones·[ET]¦2·PRESUPUESTO CONSUMIDO·*[C7]+[C8]+[C9]+[C10]¦2·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])¦2·Disminuciones Pendientes·[NP]¦2·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])+[C13]¦2·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C10])¦#LvarNL#" &
		"3·0·[]·1·S·[]¦1·0·[]·2·N·[]"
		,65,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-3",
			"Control de Presupuesto Anual",
			"CONTROL DE SALDOS ANUALES DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·7·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESFINMAY] [ANOFIN]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦1·U#LvarNL#" &
		"3·Presupuesto Ordinario·[A]¦3·Presupuesto Extraordinario·[M]¦3·Variaciones Cambiarias·[VC]¦3·Traslados Presupuestarios·[T]+[TE]¦3·Excesos Autorizados·[ME]¦3·PRESUPUESTO AUTORIZADO·*[C1]+[C2]+[C3]+[C4]+[C5]¦3·Provisión Presupuestaria·[RP]¦3·Reservas·[*RT]¦3·Compromisos·[*CT]¦3·Ejecuciones·[ET]¦3·PRESUPUESTO CONSUMIDO·*[C7]+[C8]+[C9]+[C10]¦3·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])¦3·Disminuciones Pendientes·[NP]¦3·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]+[C5]-([C7]+[C8]+[C9]+[C10])+[C13]¦3·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C10])¦#LvarNL#" &
		"1·0·[]·2·N·[]"
		,65,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"FORMUL-1",
			"Formulacion aprobada por Cuenta",
			"FORMULACION APROBADA POR MES",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·8·bold·10¦Corte3·8·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"1·1¦1·U¦3·H#LvarNL#" &
		"1·Total Formulacion·[A]+[M]+[VC]#LvarNL#" &
		"1·0·[]·2·N·[]"
		,55,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"FORMUL-2",
			"Formulacion aprobada por Oficina y Cta",
			"FORMULACION APROBADA POR OFICINA Y MES",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·11·bold·10¦Corte3·8·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"1·1¦4·[]¦1·U¦3·H#LvarNL#" &
		"1·Total Formulacion·[A]+[M]+[VC]#LvarNL#" &
		"1·0·[]·2·N·[]"
		,55,'LH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"FORMUL-3",
			"Formulacion aprobada por Cta y Oficina",
			"FORMULACION APROBADA POR OFICINA Y MES",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·11·bold·10¦Corte3·8·bold·20¦Corte4·10·none·30¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"1·1¦1·U¦4·[]¦3·H#LvarNL#" &
		"1·Total Formulacion·[A]+[M]+[VC]#LvarNL#" &
		"1·0·[]·2·N·[]"
		,55,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INVERS-1",
			"Reporte de Inversiones 1",
			"INVERSIONES POR AREA DE RESPONSABILIDAD Y TIPO DE INVERSION",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·10·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·10·bold·10¦Corte3·10·none·20¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE INVERSIONES DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AR¦1·1#LvarNL#" &
		"3·Plan Anual·[A]+[M]¦3·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Comprometido·[*CT]¦2·Ejecutado·[ET]¦2·DISPONIBLE·*[C1]-[C2]-[C3]-[C4]-[C5]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AR·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·F·[TIPOCTA]='A'"
		,44,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INVERS-2",
			"Reporte de Inversiones 2",
			"INVERSIONES POR AREA DE RESPONSABILIDAD, TIPO Y CLASE DE INVERSION ",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·10·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·10·bold·10¦Corte3·10·none·20¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE INVERSIONES DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AR¦1·1¦1·5#LvarNL#" &
		"3·Plan Anual·[A]+[M]¦3·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Comprometido·[*CT]¦2·Ejecutado·[ET]¦2·DISPONIBLE·*[C1]-[C2]-[C3]-[C4]-[C5]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AR·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·F·[TIPOCTA]='A'"
		,44,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INVERS-3",
			"Reporte de Inversiones 3",
			"INVERSIONES POR TIPO DE INVERSION Y AREA DE RESPONSABILIDAD",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·10·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·10·none·10¦Corte3·10·none·20¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE INVERSIONES DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"1·1¦2·AR#LvarNL#" &
		"3·Plan Anual·[A]+[M]¦3·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Comprometido·[*CT]¦2·Ejecutado·[ET]¦2·DISPONIBLE·*[C1]-[C2]-[C3]-[C4]-[C5]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·2·AR·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·F·[TIPOCTA]='A'"
		,44,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INVERS-4",
			"Reporte de Inversiones 4",
			"INVERSIONES POR TIPO DE INVERSION, AREA DE RESPONSABILIDAD Y CLASE DE INVERSION",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·10·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·10·bold·10¦Corte3·10·none·20¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE INVERSIONES DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦ACUMULADO AL MES DE [MESMAY] [ANO]#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"1·1¦2·AR¦1·5#LvarNL#" &
		"3·Plan Anual·[A]+[M]¦3·Provisión Presupuestaria·[RP]¦2·Reservas·[*RT]¦2·Comprometido·[*CT]¦2·Ejecutado·[ET]¦2·DISPONIBLE·*[C1]-[C2]-[C3]-[C4]-[C5]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·2·AR·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·F·[TIPOCTA]='A'"
		,44,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"INGRESOS-1",
			"Reporte de Ingresos",
			"DETALLE DE VENTAS POR LOCALIZACION",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE VENTAS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·VN¦1·4#LvarNL#" &
		"1·Real·[SGCR]*[ET]¦1·Meta Planeada·[SGCR]*([A]+[M]+[VC]+[T]+[TE])¦1·Variación·*[C1]-[C2]¦2·Real·[SGCR]*[ET]¦2·Meta Planeada·[SGCR]*([A]+[M]+[VC]+[T]+[TE])¦2·Variacion·*[C4]-[C5]¦5·Real·[SGCR]*[ET]¦5·Variacion·*[C4]-[C7]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·VN·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='I'"
		,45,'LH'
	)>
	
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"GASTOS-1",
			"Reporte de Gastos 1",
			"REPORTE DE GASTOS TOTALES POR AREA DE RESPONSABILIDAD, DEPARTAMENTO Y SECCION",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·12·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE GASTOS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AR¦1·1¦1·2¦1·3#LvarNL#" &
		"1·Real·[ET]¦1·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦1·Diferencia·*[C1]-[C2]¦2·Real·[ET]¦2·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦2·Diferencia·*[C4]-[C5]¦5·Real·[ET]¦5·Diferencia·*[C4]-[C7]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AR·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='G'"
		,45,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"GASTOS-2",
			"Reporte de Gastos 2",
			"DETALLE DE OBJETOS DE GASTOS POR AREA DE RESPONSABILIDAD",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·10·none·10¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE GASTOS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AR¦2·OG#LvarNL#" &
		"1·Real·[ET]¦1·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦1·Diferencia·*[C1]-[C2]¦2·Real·[ET]¦2·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦2·Diferencia·*[C4]-[C5]¦5·Real·[ET]¦5·Diferencia·*[C4]-[C7]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AR·2·N·[]¦2·2·OG·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='G'"
		,45,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"GASTOS-3",
			"Reporte de Gastos 3",
			"DETALLE DE OBJETOS DE GASTOS POR AREA DE RESPONSABILIDAD, DEPARTAMENTO Y SECCION",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·12·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE GASTOS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AR¦1·2¦1·3¦2·OG#LvarNL#" &
		"1·Real·[ET]¦1·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦1·Diferencia·*[C1]-[C2]¦2·Real·[ET]¦2·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦2·Diferencia·*[C4]-[C5]¦5·Real·[ET]¦5·Diferencia·*[C4]-[C7]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AR·2·N·[]¦2·4·OG·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='G'"
		,45,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"GASTOS-4",
			"Reporte de Gastos 4",
			"REPORTE RESUMEN DE GASTOS POR CLASE DE GASTOS",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·14·bold·0¦Corte2·10·none·10¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE GASTOS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·CG¦2·OG#LvarNL#" &
		"1·Real·[ET]¦1·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦1·Diferencia·*[C1]-[C2]¦2·Real·[ET]¦2·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦2·Diferencia·*[C4]-[C5]¦5·Real·[ET]¦5·Diferencia·*[C4]-[C7]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·CG·2·N·[]¦2·2·OG·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='G'"
		,45,'CH'
	)>
	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"GASTOS-4T",
			"Reporte de Gastos 4T",
			"REPORTE DE RESUMEN DE GASTOS TOTALES",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·12·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·10·none·0¦Datos·10·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PLAN ANUAL DE GASTOS DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦AL MES DE [MESMAY] [ANO], ACUMULADO Y ACUMULADO AÑO ANTERIOR#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·OG#LvarNL#" &
		"1·Real·[ET]¦1·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦1·Diferencia·*[C1]-[C2]¦2·Real·[ET]¦2·Presup. Planeado·[A]+[M]+[VC]+[T]+[TE]¦2·Diferencia·*[C4]-[C5]¦5·Real·[ET]¦5·Diferencia·*[C4]-[C7]#LvarNL#" &
	
		"3·0·[]·1·S·[]¦2·1·OG·2·N·[]¦1·0·[]·2·N·[]¦0·[]·[]·[]·[]·[TIPOCTA]='G'"
		,45,'CH'
	)>

</cffunction>

<!--- DEFINICION DE REPORTES PARA RICARDO PEREZ - PANAMA --->
<cffunction name="fnRicardoPerez">
	<cfargument name="CPRDtipo"	type="string" required="yes">
	<cfquery name="rsCE" datasource="asp">
		select CEaliaslogin
		  from CuentaEmpresarial
		 where CEcodigo = #session.CEcodigo#
	</cfquery>
	<cfif rsCE.CEaliaslogin EQ "soin">
		<cfset LvarCAT = "PRJ:Proy">
	<cfelse>
		<cfset LvarCAT = "001">
	</cfif>
		

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"CONTROL-4",
			"Control de Saldos de Presupuesto",
			"CONTROL DE SALDOS [TEMPORAL] DE PRESUPUESTO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·10·bold·20¦Corte4·9·none·30¦Corte5·8·none·40¦Corte6·7·none·50¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦PARA EL MES DE [MESMAY] [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AC¦5·#LvarCAT#¦4·[]¦1·0¦2·OG¦1·U#LvarNL#" &
		"0·Presupuesto Ordinario·[A]¦0·Presupuesto Extraordinario·[M]¦0·Variaciones Cambiarias·[VC]¦0·Traslados Presupuestarios·[T]+[TE]¦0·PRESUPUESTO PLANEADO·*[C1]+[C2]+[C3]+[C4]¦0·Provisión Presupuestaria·[RP]¦0·Reservas·[*RT]¦0·Compromisos·[*CT]¦0·Ejecuciones·[ET]¦0·PRESUPUESTO CONSUMIDO·*[C6]+[C7]+[C8]+[C9]¦0·DISPONIBLE·*[C1]+[C2]+[C3]+[C4]-([C6]+[C7]+[C8]+[C9])¦0·Excesos Autorizados·[ME]¦0·NRPs&nbsp;Aprobados Pendientes de Aplicar·[NP]¦0·DISPONIBLE NETO·*[C1]+[C2]+[C3]+[C4]-([C6]+[C7]+[C8]+[C9])+[C12]+[C13]¦0·VARIACION (PLANEADO-EJECUTADO)·*[C1]+[C2]+[C3]+[C4]-([C9])¦0·RELACION (EJECUTADO/ PLANEADO)·%[C9]/([C1]+[C2]+[C3]+[C4])¦#LvarNL#" &
		"3·0·[]·3·S·[]¦2·1·AC·1·N·[]¦2·5·OG·1·N·[]¦1·0·[]·2·N·[]¦4·6·U,1,2·0·0·0¦5·0·0·0·0·0"
		,65,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"EJECUCI-4",
			"Control de Ejecuciones Mensuales",
			"HISTÓRICO DE EJECUCIONES MENSUALES VS PRESUPUESTO PLANEADO",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·11·bold·0¦Corte2·10·bold·10¦Corte3·10·bold·20¦Corte4·9·none·30¦Corte5·8·none·40¦Corte6·7·none·50¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PERIODO DE PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦HASTA EL MES DE [MESMAY] DEL [ANO]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"2·AC¦4·[]¦5·#LvarCAT#¦1·0¦2·OG¦1·U¦3·H#LvarNL#" &
		"1·Ejecucion Acumulada a [MESMIN]·[ET]¦2·Presupuesto Planeado a [MESMIN]·[*PP]¦2·VARIACION (PLANEADO- EJECUTADO)·*[C2]-[T1]#LvarNL#" &
		"3·0·[]·1·S·[]¦2·1·AC·1·N·[]¦2·5·OG·1·N·[]¦1·0·[]·2·N·[]¦4·6·U,1,2·0·0·0¦5·0·0·0·0·0"
		,55,'LH'
	)>

	<cfset fnAgregarDefinicion (
			Arguments.CPRDtipo,
			"FORMUL-4",
			"Formulacion aprobada por Mes",
			"FORMULACION APROBADA POR MES",
			
		"Arial, Helvetica, sans-serif¦.¦,0#LvarNL#" &
		"ColHeader·7·bold·0¦Header·12·bold·0·text-align·center¦Header1·14·bold·0¦Header2·14·bold·0¦Corte1·12·bold·0¦Corte2·11·bold·10¦Corte3·10·bold·20¦Corte4·10·none·30¦Corte5·9·none·30¦Corte6·8·none·40¦Datos·7·none·0#LvarNL#" &
		"[EMPMAY]¦[DES]¦PRESUPUESTO ANUAL DE [MESINIMAY] [ANOINI] A [MESFINMAY] [ANOFIN]¦([CF])#LvarNL#" &
		"[]#LvarNL#" &
		"[]#LvarNL#" &
		"4·[]¦5·#LvarCAT#¦1·0¦1·U¦3·H#LvarNL#" &
		"1·Total Formulado·[A]+[M]+[VC]#LvarNL#" &
		"1·0·[]·2·N·[]¦4·4·U,1,2·0·0·0¦5·0·0·0·0·0"
		,55,'LH'
	)>
</cffunction>

<cffunction name="fnAgregarDefinicion">
	<cfargument name="CPRDtipo"		type="string" required="yes">
	<cfargument name="Codigo" 		type="string" required="yes">
	<cfargument name="Nombre" 		type="string" required="yes">
	<cfargument name="Descripcion" 	type="string" required="yes">
	<cfargument name="Definicion" 	type="string" required="yes">
	<cfargument name="LineasPagina" type="numeric" required="yes">
	<cfargument name="TipoPagina"	type="string" required="yes">
	
	<cfquery name="rsReporte" datasource="#session.dsn#">
		select 	count(1) as cantidad from CPReportes
		 where	CPRcodigo		= '#Arguments.Codigo#'
	</cfquery>
	<cfif rsReporte.Cantidad EQ 0>
		<cfquery name="rsReporte" datasource="#session.dsn#">
			insert into CPReportes
				(
					CPRcodigo
				,	CPRnombre
				,	CPRdescripcion
				,	CPRdefinicion
				<cfif Arguments.LineasPagina NEQ 0>
				,	CPRlineasPagina
				</cfif>
				<cfif Arguments.TipoPagina NEQ "">
				,	CPRtipoPagina
				</cfif>
				,	CPRDtipo
				)
			values(
		 			'#Arguments.Codigo#'
				,	'#Arguments.Nombre#'
				,	'#Arguments.Descripcion#'
				,	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.Definicion#">
				<cfif Arguments.LineasPagina NEQ 0>
				,	#Arguments.LineasPagina#
				</cfif>
				<cfif Arguments.TipoPagina NEQ "">
				,	'#Arguments.TipoPagina#'
				</cfif>
				,	'#Arguments.CPRDtipo#'
			)
		</cfquery>
	<cfelse>
		<cfquery name="rsReporte" datasource="#session.dsn#">
			update CPReportes
				set
					CPRnombre		= '#Arguments.Nombre#'
				,	CPRdescripcion	= '#Arguments.Descripcion#'
				,	CPRdefinicion	= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.Definicion#">
				<cfif Arguments.LineasPagina NEQ 0>
				,	CPRlineasPagina = #Arguments.LineasPagina#
				</cfif>
				<cfif Arguments.TipoPagina NEQ "">
				,	CPRtipoPagina	= '#Arguments.TipoPagina#'
				</cfif>
				,	CPRDtipo		= '#Arguments.CPRDtipo#'
			 where	CPRcodigo		= '#Arguments.Codigo#'
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnAgregarClasificacion">
	<cfargument name="Codigo" 		type="string" required="yes">
	<cfargument name="Descripcion"	type="string" required="yes">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 1 from PCClasificacionE
		where PCCEcodigo = '#Arguments.Codigo#'
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into PCClasificacionE
				(CEcodigo, PCCEcodigo,PCCEdescripcion, PCCEempresa, PCCEactivo)
				values (#session.CEcodigo#, '#Arguments.Codigo#', '#Arguments.Descripcion#', 0, 1)
		</cfquery>
	</cfif>
</cffunction>
