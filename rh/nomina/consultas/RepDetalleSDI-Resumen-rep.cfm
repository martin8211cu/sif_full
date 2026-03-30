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
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDICalculado" 			Default="SDI Calculado" 				returnvariable="LB_SDICalculado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDITopado" 				Default="Nuevo SDI Topado" 				returnvariable="LB_SDITopado"/>
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
			<td class="LBColumna"><b>#LB_SDICalculado#</b></td>
			<td class="LBColumna"><b>#LB_SDITopado#</b></td>
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
                <tr><td align="center"  colspan="18">
                    <cf_EncReporte 
                    	Titulo="#LB_ReporteSalarioDiarioIntegradoBimestre# #vBimestre# #form.Periodo#"
                        filtro1="#LB_Tipo_de_Nomina#:#rsTnomina.Tcodigo# - #rsTnomina.Tdescripcion# "
                    >
                </td></tr>
                <tr><td align="center" colspan="18">
                    <table border="1" cellpadding="2" cellspacing="2" width="100%">
                    	<tr><td align="center"  colspan="18">
                            #ENCABEZADO_IMP#
                        </td></tr>
                        <cfif isdefined('rsDatosEmpleado') and rsDatosEmpleado.RecordCount GT 0>
                            <cfloop query="rsDatosEmpleado">
                            	<tr>
                                	<td class="LBColumnaText" align="left">#rsDatosEmpleado.DEidentificacion#</td>
                                    <td class="LBColumnaText" align="left">#rsDatosEmpleado.Nombre#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSDICalculado ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSDITopado ,'none')#</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                                <tr><td colspan="18" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
                        </cfif>
                        <tr><td colspan="18" align="center"><b>----- #LB_UltimaLinea# -----</b></td></tr>
					</table>
                </td></tr>
			</td>
		</tr>
	</table>
</cfoutput>

