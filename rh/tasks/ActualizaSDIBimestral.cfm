<!---ljimenez Aculizacion del SDI bimensual para los empleados
((Salario / FactorDiasMensual) * ((365 + diasgratifica + diasprima)/365))
+
(incidencias afectan SBC del Bimestre anterior / Cantidad de dias del bimestre)
--->

<!---
<cfset fechacorrida = createdate(2010,03,01)>
--->

<cfset fechacorrida = now()>

<!---<cfset fechacorrida = createdate(2011,11,01)>--->

<cfswitch expression="#month(fechacorrida)#">
    <cfcase value = "1">
		<cfset vBimestreRige = 1>
        <cfset BimestreCalc = 12>
        <cfset MesInicio 	= 11>
    </cfcase>
    <cfcase value = "2">
		<cfset vBimestreRige = 1>
        <cfset BimestreCalc = 12>
        <cfset MesInicio 	= 11>
    </cfcase>
   	<cfcase value = "3">
		<cfset vBimestreRige = 2>
        <cfset BimestreCalc = 2>
        <cfset MesInicio 	= 1>
    </cfcase>
    <cfcase value = "4">
		<cfset vBimestreRige = 2>
        <cfset BimestreCalc = 2>
        <cfset MesInicio 	= 1>
    </cfcase>
    <cfcase value = "5">
		<cfset vBimestreRige = 3>
        <cfset BimestreCalc = 4>
        <cfset MesInicio 	= 3>
    </cfcase>
    <cfcase value = "6">
		<cfset vBimestreRige = 3>
        <cfset BimestreCalc = 4>
        <cfset MesInicio 	= 3>
    </cfcase>
    <cfcase value = "7">
		<cfset vBimestreRige = 4>
        <cfset BimestreCalc = 7>
        <cfset MesInicio 	= 5>
    </cfcase>
    <cfcase value = "8">
		<cfset vBimestreRige = 4>
        <cfset BimestreCalc = 6>
        <cfset MesInicio 	= 5>
    </cfcase>
    <cfcase value = "9">
		<cfset vBimestreRige = 5>
        <cfset BimestreCalc = 8>
        <cfset MesInicio 	= 7>
    </cfcase>
    <cfcase value = "10">
		<cfset vBimestreRige = 5>
        <cfset BimestreCalc = 8>
        <cfset MesInicio 	= 7>
    </cfcase>
    <cfcase value = "11">
		<cfset vBimestreRige = 6>
        <cfset BimestreCalc = 10>
        <cfset MesInicio 	= 9>
    </cfcase>
    <cfcase value = "12">
		<cfset vBimestreRige = 6>
        <cfset BimestreCalc = 10>
        <cfset MesInicio 	= 9>
    </cfcase>
</cfswitch>

<!---
	fuente:
		0 indefinido
		1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento
		2 Manual (SDI Bimestral)
		3 SDI por Aniversario
		4 Accion de Aumento (comportamiento = 6)
 --->
<cfparam name="fuente" default="1">

<!---Verifica que estemos en un mes valido, los meses de calculo validos son: 2,4,6,8,10,12--->
<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnVerifica" returnvariable="rsVerifica">
	<cfinvokeargument name="Fecha" value="#fechacorrida#"/>
    <cfinvokeargument name="Bimestre" value="#BimestreCalc#"/>
    <cfinvokeargument name="BimestreRige" value="#vBimestreRige#"/>
</cfinvoke>


<cfif rsVerifica.Aplica>

	<cfset fechacalculo = createdate(#rsVerifica.Periodo#,#rsVerifica.Mes#,01)>
	<cfset fechafin = dateAdd("d", -1, dateAdd("m", 2, fechacalculo))>

    <cfset FechaInicior 	=  createdate(datePart('yyyy', fechacorrida),datePart('m', fechacorrida),01)>
    <cfset FechaFinalr 	=  dateadd('m',2,#FechaInicior#-1)>
    <cfinvoke component="rh.Componentes.RH_ReporteCalculoSDI" method="CargarDatos" returnvariable="rsDatosEmpleado">
        <cfinvokeargument name="FInicio" value="#FechaInicior#"/>
        <cfinvokeargument name="FFinal" value="#FechaFinalr#"/>
        <cfinvokeargument name="MesInic" value="#MesInicio#"/>
    </cfinvoke>

    <cftransaction action="begin">
        <cfloop query="rsDatosEmpleado"> <!---actuliazamos el DEsdi segun  el calculo usamos el tope o no 25 VSMGA--->

            <!---CarolRS, guarda en bitacora--->
            <cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="AddBitacoraSDI" returnvariable="AddBitacoraSDI">
                <cfinvokeargument name="DEid" 			value="#rsDatosEmpleado.DEid#"/>
                <cfinvokeargument name="Fecha" 			value="#fechacalculo#"/>
                <cfinvokeargument name="BMFecha" 		value="#fechacorrida#"/>
                <cfinvokeargument name="RHHmonto" 		value="#rsDatosEmpleado.MtoSDITopado#"/>
                <cfinvokeargument name="RHHfuente" 		value="#fuente#"/>
                <cfinvokeargument name="Periodo"		value="#rsVerifica.PeriodoCalculo#"/>
                <cfinvokeargument name="Mes"			value="#rsVerifica.MesCalculo#"/>
            </cfinvoke>
        </cfloop>
        <!---<cftransaction action="rollback">--->
    </cftransaction>
</cfif>
