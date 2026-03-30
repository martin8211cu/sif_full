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

<cfset vBimestre = ''>
<cfset tNomina = "#form.Tcodigo#">

<cfif tNomina EQ '02'>
	<cfset periodoRpte ='100'>
<cfelse>
	<cfset periodoRpte ='200'>
</cfif>

<!---<cfswitch expression="#form.Mes#">
	<cfcase value="1">  <cfset vBimestre = ' Enero - Febrero '><cfset periodoRpte ='#periodoRpte#0103#form.periodo#'></cfcase>
    <cfcase value="3">  <cfset vBimestre = ' Marzo - Abril '><cfset periodoRpte = '#periodoRpte#0105#form.periodo#'> </cfcase>
    <cfcase value="5">  <cfset vBimestre = ' Mayo - Junio '><cfset periodoRpte = '#periodoRpte#0107#form.periodo#'>  </cfcase>
    <cfcase value="7">  <cfset vBimestre = ' Julios - Agosto '><cfset periodoRpte = '#periodoRpte#0109#form.periodo#'> </cfcase>
    <cfcase value="9">  <cfset vBimestre = ' Septiembre - Octubre '><cfset periodoRpte = '#periodoRpte#0111#form.periodo#'> </cfcase>
    <cfcase value="11"> <cfset vBimestre = ' Noviembre - Diciembre '><cfset periodoRpte = '#periodoRpte#0101#form.periodo#'> </cfcase>
</cfswitch>--->
<cfquery name="rsRegPatron" datasource="#session.dsn#">
	select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
</cfquery>
<cfset RegPatron=rsRegPatron.Pvalor>

<cfoutput>		

	<!---Emcabezados de las columnas--->
	<!---
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
	</cfsavecontent>--->

	
	<cfset LvarFileName = "Var_Sin#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr><td align="center">
            <cf_htmlReportsHeaders 
            title= "#LB_ReporteSalarioDiarioIntegradoBimestre#"
            filename="#LvarFileName#"
            irA="RepImpIDSE-filtro.cfm">
        </td></tr>
        
        
						<cfset hilera =''>
                         <cfset linea = 1>
                         <cfset sueldo=0>
                        <cfif isdefined('rsDatosEmpleado') and rsDatosEmpleado.RecordCount GT 0>
<!---                        <cfthrow message="#rsDatosEmpleado.RecordCount#">--->
                            <cfloop query="rsDatosEmpleado">
                            <cfif linea GT 1>
								<cfset hilera = hilera & '#chr(13)##chr(10)#'>
							</cfif>
                            	<cfset sueldo=rsDatosEmpleado.sdi>
                                <cfset tipNom=periodoRpte>
                                <cfset periodoRpte = '#periodoRpte##DateFormat(FechaInicio,"ddmmyyyy")#'>
                              
                                <cfset hilera = hilera & RepeatString("0",11-len(trim(RegPatron)))&'#RegPatron#'>
                                <cfset hilera = hilera & RepeatString("0",11-len(trim(NSS)))&'#NSS#'>
                                <cfset hilera = hilera & '#ApePat#' & RepeatString(" ",27-len(trim(ApePat)))>
                                <cfset hilera = hilera & '#ApeMat#' & RepeatString(" ",27-len(trim(ApeMat)))>
                                <cfset hilera = hilera & '#Nombres#' & RepeatString(" ",27-len(trim(Nombres)))>
                                <cfset linSdi = len(replace(LSCurrencyformat(sdi,'none'),'.',''))>
                                   
                                    
   							<cfset hilera = hilera & RepeatString("0",6-len(replace(LSCurrencyformat(sdi,'none'),'.',''))) & '#replace(LSCurrencyformat(sdi,'none'),'.','')#'>
<!---                          <cfif linea EQ 3>    <cfthrow message="#linSdi#-#replace(LSCurrencyformat(sueldo,'none'),'.','')#-"></cfif>--->
                                 <cfset hilera = hilera & RepeatString(" ",17-len(trim(periodoRpte))) & '#periodoRpte#' >
                                 <cfset hilera = hilera & '     0700000 ' & '#numEmp#' & '      '>
                                 <cfset hilera = hilera & '#CURP#' &  RepeatString(" ",18-len(trim(CURP))) & '9' >

					<!----Reemplazar caracteres no validos----->
								<cfset hilera = REReplaceNoCase(hilera,'Á','A',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Í','I',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")>
								<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")>
								<cfset hilera = Ucase(hilera)>
                                <cfset linea=linea+1>
                                <cfset periodoRpte=tipNom>
                                <cfset sueldo=0>
                            </cfloop>
                            <cfset linea = linea-1>
                            <cfset hilera = hilera & '#chr(13)##chr(10)#'>
                            <cfset hilera = hilera & '*************                                           '>
                            <cfset hilera = hilera & RepeatString("0",6-len('#linea#')) & '#linea#'>
                            <cfset hilera = hilera & '                                                                       00000                             9'>

                            <!---<cfthrow message="#hilera#">--->
							
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

