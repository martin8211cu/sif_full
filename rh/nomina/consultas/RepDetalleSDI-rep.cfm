<style type="text/css">
<!--
.encabezado {
    font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
	font-size:11px;
}
.encabezadotext {
    font-family: Arial, Helvetica, sans-serif;
    font-size:11px;
}
.LBColumna {
    font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
	font-size:11px;
	background-color:#E1E1E1;
	border-bottom: 1px solid #000000;
}
.LBColumnaText {
    font-family: Arial, Helvetica, sans-serif;
    font-size:11px;
}


-->
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NumeroTrabajador" 		Default="N&uacute;m.Trabajador" 		returnvariable="LB_NumeroTrabajador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NombreTrabajador" 		Default="Nomb.Trabajador" 				returnvariable="LB_NombreTrabajador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaIngreso" 			Default="Fecha Ingreso" 				returnvariable="LB_FechaIngreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AnosAntiguedad" 			Default="A&ntilde;os Antiguedad"		returnvariable="LB_AnosAntiguedad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FactorIntegracion"		Default="Factor de Integraci&oacute;n"	returnvariable="LB_FactorIntegracion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasBimestre" 			Default="D&iacute;as Bimestre" 			returnvariable="LB_DiasBimestre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLaboradosBimestre" 	Default="D&iacute;as Laborados en Bimestre"	returnvariable="LB_DiasLaboradosBimestre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ausentismo" 				Default="Ausentismo" 					returnvariable="LB_Ausentismo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Incapacidades" 			Default="Incapacidades" 				returnvariable="LB_Incapacidades"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PosBimestre" 			Default="D&iacute;as Posteriores Bimestre" 	returnvariable="LB_PosBimestre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SueldoDiario" 			Default="Sueldo Diario" 				returnvariable="LB_SueldoDiario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ParteFija"    			Default="Parte Fija"     				returnvariable="LB_ParteFija"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptosAcumIMSS" 		Default="Conceptos Acum IMSS" 			returnvariable="LB_ConceptosAcumIMSS"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ImpDiasPagadosPeriodo" 	Default="Importe Dias Pagados Peri&oacute;do"returnvariable="LB_ImpDiasPagadosPeriodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SueldoGravDiario" 		Default="Sueldo Gravable Diario" 		returnvariable="LB_SueldoGravDiario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDICalculado" 			Default="SDI Calculado" 				returnvariable="LB_SDICalculado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDIAnterior" 			Default="SDI Anterior" 					returnvariable="LB_SDIAnterior"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_25VSMG" 					Default="25 UMA" 						returnvariable="LB_25VSMG"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDITopado" 				Default="Nuevo SDI Topado" 				returnvariable="LB_SDITopado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Diferencias" 			Default="Diferencia" 					returnvariable="LB_Diferencias"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_UltimaLinea" 			Default="- - - Ultima Linea - - -" 		returnvariable="LB_UltimaLinea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_Nomina" Default="Tipo de N&oacute;mina" returnvariable="LB_Tipo_de_Nomina"/>

<cfset vBimestre = ''>

<cfswitch expression="#form.Mes#">
	<cfcase value="1">  <cfset vBimestre = ' Enero - Febrero '> </cfcase>
    <cfcase value="3">  <cfset vBimestre = ' Marzo - Abril '> </cfcase>
    <cfcase value="5">  <cfset vBimestre = ' Mayo - Junio '> </cfcase>
    <cfcase value="7">  <cfset vBimestre = ' Julios - Agosto '> </cfcase>
    <cfcase value="9">  <cfset vBimestre = ' Septiembre - Octubre '> </cfcase>
    <cfcase value="11"> <cfset vBimestre = ' Noviembre - Diciembre '> </cfcase>
</cfswitch>

<cfoutput>		

	<!---Emcabezados de las columnas--->
	
	<cfsavecontent variable="ENCABEZADO_IMP">
	<tr class="LBColumna">
			<td class="LBColumna"><b>#LB_NumeroTrabajador#</b></td>	
			<td class="LBColumna"><b>#LB_NombreTrabajador#</b></td>
			<td class="LBColumna" align="center"><b>#LB_FechaIngreso#</b></td>
            <td class="LBColumna"><b>#LB_AnosAntiguedad#</b></td>
            <td class="LBColumna"><b>#LB_FactorIntegracion#</b></td>
            <td class="LBColumna"><b>#LB_DiasBimestre#</b></td>
            <td class="LBColumna"><b>#LB_DiasLaboradosBimestre#</b></td>
            <td class="LBColumna"><b>#LB_Ausentismo#</b></td>
            <td class="LBColumna"><b>#LB_Incapacidades#</b></td>
            <td class="LBColumna"><b>#LB_PosBimestre#</b></td>
            <td class="LBColumna"><b>#LB_SueldoDiario#</b></td>
            <td class="LBColumna"><b>#LB_ParteFija#</b></td>
            <td class="LBColumna"><b>#LB_ConceptosAcumIMSS#</b></td>
            <td class="LBColumna"><b>#LB_ImpDiasPagadosPeriodo#</b></td>
            <td class="LBColumna"><b>#LB_SueldoGravDiario#</b></td>
            <td class="LBColumna"><b>#LB_SDICalculado#</b></td>
            <td class="LBColumna"><b>#LB_SDIAnterior#</b></td>
            <td class="LBColumna"><b>#LB_25VSMG#</b></td>
            <td class="LBColumna"><b>#LB_Diferencias#</b></td>
	</tr>
	</cfsavecontent>

	
	<cfset LvarFileName = "DetalleSDIBimestre#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr><td align="center">
            <cf_htmlReportsHeaders 
            title= "#LB_ReporteSalarioDiarioIntegradoBimestre#"
            filename="#LvarFileName#"
            irA="RepDetalleSDI-filtro.cfm">
        </td></tr>
        
        <tr>
			<td align="center">
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="1">
                <tr><td align="center"  colspan="19">
                    <cf_EncReporte Titulo="#LB_ReporteSalarioDiarioIntegradoBimestre# #vBimestre# #form.Periodo#"
                     filtro1="#LB_Tipo_de_Nomina#:#rsTnomina.Tcodigo# - #rsTnomina.Tdescripcion# "
                    >
                </td></tr>
                <tr><td align="center" colspan="19">
                    <table border="1" cellpadding="2" cellspacing="2" width="100%">
                    	<tr><td align="center"  colspan="19">
                            #ENCABEZADO_IMP#
                        </td></tr>
                        <cfif isdefined('rsDatosEmpleado') and rsDatosEmpleado.RecordCount GT 0>
                            <cfloop query="rsDatosEmpleado">
                            	<tr>
                                	<td class="LBColumnaText" align="left">#rsDatosEmpleado.DEidentificacion#</td>
                                    <td class="LBColumnaText" align="left">#rsDatosEmpleado.Nombre#</td>
                                    <td class="LBColumnaText" align="center">#lsdateformat(rsDatosEmpleado.ingreso,"dd-mm-yyyy")#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.AnnosAntiguedad ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#rsDatosEmpleado.MtoFactorIntegra#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.DiasBimestre ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.DiasBimestreLabor ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.DiasBimestreFalta ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.DiasBimestreIncap ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.DiasPosBimestre ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.SueldoDiario ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoparteFija ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoIncidenciasIMSS ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoDiasLaborados ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoGravDiario ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSDICalculado ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSDIAnterior ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSMGV ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.Diferencias ,'none')#</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                                <tr><td colspan="19" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
                        </cfif>
                        <tr><td colspan="19" align="center"><b>----- #LB_UltimaLinea# -----</b></td></tr>
					</table>
                </td></tr>
			</td>
		</tr>
	</table>
</cfoutput>

