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
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SueldoDiario" 			Default="Sueldo Diario" 				returnvariable="LB_SueldoDiario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptosAcumIMSS" 		Default="Conceptos Acum IMSS" 			returnvariable="LB_ConceptosAcumIMSS"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ImpDiasPagadosPeriodo" 	Default="Importe Dias Pagados Peri&oacute;do"returnvariable="LB_ImpDiasPagadosPeriodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SueldoGravDiario" 		Default="Sueldo Gravable Diario" 		returnvariable="LB_SueldoGravDiario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDICalculado" 			Default="SDI Calculado" 				returnvariable="LB_SDICalculado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDIAnterior" 			Default="SDI Anterior" 					returnvariable="LB_SDIAnterior"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_25VSMG" 					Default="25 VSMG" 						returnvariable="LB_25VSMG"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDITopado" 				Default="Nuevo SDI Topado" 				returnvariable="LB_SDITopado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Diferencias" 			Default="Diferencia" 					returnvariable="LB_Diferencias"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_UltimaLinea" 			Default="- - - Ultima Linea - - -" 		returnvariable="LB_UltimaLinea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_Nomina" Default="Tipo de N&oacute;mina" returnvariable="LB_Tipo_de_Nomina"/>

<cfset vBimestre = ''>
<cfset tNomina = "#form.Tcodigo#">

<cfif tNomina EQ '02'>
	<cfset periodoRpte ='100'>
<cfelse>
	<cfset periodoRpte ='200'>
</cfif>

<cfswitch expression="#form.Mes#">
	<cfcase value="1">  <cfset vBimestre = ' Enero - Febrero '><cfset periodoRpte ='#periodoRpte#0103#form.periodo#'></cfcase>
    <cfcase value="3">  <cfset vBimestre = ' Marzo - Abril '><cfset periodoRpte = '#periodoRpte#0105#form.periodo#'> </cfcase>
    <cfcase value="5">  <cfset vBimestre = ' Mayo - Junio '><cfset periodoRpte = '#periodoRpte#0107#form.periodo#'>  </cfcase>
    <cfcase value="7">  <cfset vBimestre = ' Julio - Agosto '><cfset periodoRpte = '#periodoRpte#0109#form.periodo#'> </cfcase>
    <cfcase value="9">  <cfset vBimestre = ' Septiembre - Octubre '><cfset periodoRpte = '#periodoRpte#0111#form.periodo#'> </cfcase>
    <cfcase value="11"> <cfset vBimestre = ' Noviembre - Diciembre '><cfset periodoRpte = '#periodoRpte#0101#form.periodo#'> </cfcase>
</cfswitch>


<cfoutput>		

	<!---Emcabezados de las columnas--->
	
	<cfsavecontent variable="ENCABEZADO_IMP">
	<tr class="LBColumna">
    		<td class="LBColumna"><b>Reg. Patronal</b></td>	
    		<td class="LBColumna"><b>Num. Seg. Social</b></td>	            
			<td class="LBColumna"><b>#LB_NombreTrabajador#</b></td>
            <td class="LBColumna"><b>SDI</b></td>
            <td class="LBColumna"><b>Periodo Reporte</b></td>
            <td class="LBColumna"><b>Tipo Movimiento</b></td>
            <td class="LBColumna"><b>#LB_NumeroTrabajador#</b></td>
            <td class="LBColumna"><b>CURP</b></td>            
	</tr>
	</cfsavecontent>

	
	<cfset LvarFileName = "Var_Sin#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr><td align="center">
            <cf_htmlReportsHeaders 
            title= "#LB_ReporteSalarioDiarioIntegradoBimestre#"
            filename="#LvarFileName#"
            irA="RepImpIDSE-filtro.cfm">
        </td></tr>
        
        <tr>
			<td align="center">
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="1">
                <tr><td align="center"  colspan="18">
                    <cf_EncReporte Titulo="#LB_ReporteSalarioDiarioIntegradoBimestre# #vBimestre# #form.Periodo#"
                     filtro1="#LB_Tipo_de_Nomina#:#rsTnomina.Tcodigo# - #rsTnomina.Tdescripcion# "
                    >
                </td></tr>
                <tr><td align="center" colspan="18">
                    <table border="1" cellpadding="2" cellspacing="2" width="100%">
                    	<tr><td align="center"  colspan="18">
                            #ENCABEZADO_IMP#
                        </td></tr>
						<cfset hilera =''>
                         <cfset linea = 1>
                        <cfif isdefined('rsDatosEmpleado') and rsDatosEmpleado.RecordCount GT 0>
                            <cfloop query="rsDatosEmpleado">
                            <cfif linea GT 1>
								<cfset hilera = hilera & '#chr(13)##chr(10)#'>
							</cfif>
                            	<tr>
                                	<td class="LBColumnaText" align="left">#rsDatosEmpleado.RegPatron#</td>
                                    <td class="LBColumnaText" align="left">#rsDatosEmpleado.NSS#</td>
                                    <td class="LBColumnaText" align="left">#rsDatosEmpleado.NombreCompleto#</td>
                                    <td class="LBColumnaText" align="right">#LSCurrencyformat(rsDatosEmpleado.MtoSDICalculado ,'none')#</td>
                                    <td class="LBColumnaText" align="right">#periodoRpte##rsDatosEmpleado.Fechadesde#</td>
                                    <td class="LBColumnaText" align="right">0700000</td>
                                	<td class="LBColumnaText" align="left">#rsDatosEmpleado.DEidentificacion#</td>
                                    <td class="LBColumnaText" align="right">#rsDatosEmpleado.CURP#</td>                                    
                                </tr>
                                <!---<cfset tipNom=periodoRpte>
                                <cfset periodoRpte = '#periodoRpte##DateFormat(rsDatosEmpleado.Fechadesde,"ddmmyyyy")#'>--->
                              
                                <cfset hilera = hilera & RepeatString("0",11-len(trim(RegPatron)))&'#RegPatron#'>
                                <cfset hilera = hilera & RepeatString("0",11-len(trim(NSS)))&'#NSS#'>
                                <cfset hilera = hilera & '#ApePat#' & RepeatString(" ",27-len(trim(ApePat)))>
                                <cfset hilera = hilera & '#ApeMat#' & RepeatString(" ",27-len(trim(ApeMat)))>
                                <cfset hilera = hilera & '#Nombres#' & RepeatString(" ",27-len(trim(Nombres)))>
                                <cfset SDICalculado = replace(LSCurrencyformat(MtoSDICalculado,'none'),'.','')>
                                <cfset hilera = hilera & RepeatString("0",6-len(replace(SDICalculado,',',''))) & '#replace(SDICalculado,',','')#'>
                              <!---   <cfset lonline = len(periodoRpte)><cfthrow message="#lonline#-#periodoRpte#-">--->
                                 <cfset hilera = hilera & RepeatString(" ",17-len(trim(periodoRpte))) & '#periodoRpte#' >
                                 <cfset hilera = hilera & '     0700000' & RepeatString(" ",5-len(trim(DEidentificacion))) & '#DEidentificacion#' & '      '>
                                 <cfset hilera = hilera & '#CURP#' &  RepeatString(" ",18-len(trim(CURP))) & '9' >                                
                                 
<!---                                 <cfset lonline = len(ApePat)> <cfthrow message="-#NSS#--#ApePat#-">--->
					<!----Reemplazar caracteres no validos----->
								<cfset hilera = REReplaceNoCase(hilera,'Á','A',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Í','I',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")>
								<cfset hilera = Ucase(hilera)>
                                <cfset linea=linea + 1>
                               <!--- <cfset periodoRpte=tipNom>--->
                            </cfloop>
                            <cfset linea = linea - 1>
                            <cfset hilera = hilera & '#chr(13)##chr(10)#'>
                            <cfset hilera = hilera & '*************                                           '>
                            <cfset hilera = hilera & RepeatString("0",6-len('#linea#')) & '#linea#'>
                            
                            <cfset hilera = hilera & '                                                                       00000                             9'>

                           <!--- <cfthrow message="#hilera#">--->
							
                            <cfset archivo = "#year(now())##month(now())##day(now())# #hour(now())##minute(now())##second(now())#">
							<cfset txtfile = GetTempFile(getTempDirectory(), 'VAR')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output ="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=VAR#archivo#.dat">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
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

