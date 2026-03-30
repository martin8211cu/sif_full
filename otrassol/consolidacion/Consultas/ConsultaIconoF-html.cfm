<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cf_PleaseWait SERVER_NAME="/cfmx/otrassol/Consolidacion/consultas/ConsultaIconoF_SQL.cfm" >
<cfif isdefined("rsReporte") and rsReporte.recordcount gt 15000 and url.formato NEQ "HTML">
	<cf_errorCode	code = "50239" msg = "Se han generado mas de 15000 registros para este reporte.">
	<cfabort>
</cfif>

<cfset strMes = "">
<cfswitch expression="#url.mes#">
	<cfcase value="1"><cfset strMes = "Enero"></cfcase>
	<cfcase value="2"><cfset strMes = "Febrero"></cfcase>
	<cfcase value="3"><cfset strMes = "Marzo"></cfcase>
	<cfcase value="4"><cfset strMes = "Abril"></cfcase>
	<cfcase value="5"><cfset strMes = "Mayo"></cfcase>
	<cfcase value="6"><cfset strMes = "Junio"></cfcase>
	<cfcase value="7"><cfset strMes = "Julio"></cfcase>
	<cfcase value="8"><cfset strMes = "Agosto"></cfcase>
	<cfcase value="9"><cfset strMes = "Setiembre"></cfcase>
	<cfcase value="10"><cfset strMes = "Octubre"></cfcase>
	<cfcase value="11"><cfset strMes = "Noviembre"></cfcase>										
	<cfcase value="12"><cfset strMes = "Diciembre"></cfcase>
</cfswitch>

	<cfoutput>
        <cf_htmlreportsheaders
            title="#request.LvarTitle#" 
            filename="#LvarFile#-#Session.Usucodigo#.xls" 
            ira="#LvarIrA#">
        <cfif not isdefined("btnDownload")>  
            <cf_templatecss>
        </cfif>	
    </cfoutput>
    <cfflush interval="20">
	<cfoutput>

        <style type="text/css" >
            .corte {
                font-weight:bold; 
            }
        </style>

        <table width="173%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
            <tr>
                <td colspan="2">&nbsp;</td>
                <td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
            </tr>					
            <tr>
                <td style="font-size:16px" align="center" colspan="3">
                <strong>#rsGE.Edescripcion#</strong>	
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="3">
                    <strong> Icono F Consolidado </strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="3"><strong>Confidencial</strong></td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="3" nowrap="nowrap">
                <strong>Mes:&nbsp;#strMes# &nbsp;&nbsp; Periodo:&nbsp;#url.periodo#</strong>
                </td>
            </tr>
            <tr>
                <td colspan="3">&nbsp;</td>
            </tr>
        </table>
        
        <table width="173%">
            <tr>
                <td nowrap><strong>Sociedad</strong></td>
                <td nowrap><strong>Soc_Asoc</strong></td>
                <td nowrap ><strong>Ejercicio_Periodo</strong></td>
                <td nowrap ><strong>Cuenta_Consolidaci&oacute;n</strong></td>
                <td nowrap ><strong>Referencia_I</strong></td>
                <td nowrap ><strong>Referencia_II</strong></td>
                <td nowrap ><strong>Descripci&oacute;n</strong></td>
                <td nowrap ><strong>Monto</strong></td>
                <td nowrap ><strong>Moneda</strong></td>
                <td nowrap ><strong>Monto_Debe</strong></td>
                <td nowrap ><strong>Monto_Haber</strong></td>
                <td nowrap ><strong>Moneda_Contabilizaci&oacute;n</strong></td>
            </tr>
            <tr><td colspan="12">&nbsp;</td></tr>
        
            <cfloop query="rsReporte">
            	<tr>                   
                    <td nowrap >#rsReporte.Sociedad#</td>
                    <td nowrap >#rsReporte.Soc_Asoc#</td>
                    <td nowrap >#rsReporte.Ejercicio_periodo#</td>
                    <td nowrap >#rsReporte.Cuenta_consolidacion#</td>
                    <td nowrap >#rsReporte.Referencia_I#</td>
                    <td nowrap >#rsReporte.Referencia_II#</td>
                    <td nowrap >#rsReporte.Descripcion#</td>
                    <td nowrap >#numberformat(rsReporte.Monto, ",9.00")#</td>
                    <td nowrap >#rsReporte.Moneda#</td>
                    <td nowrap >#numberformat(rsReporte.Monto_Debe, ",9.00")#</td>
                    <td nowrap >#numberformat(rsReporte.Monto_Haber, ",9.00")#</td>
                    <td nowrap >#rsReporte.Moneda_Contabilizacion#</td>
                </tr>
        	</cfloop>
    	</table>          
	</cfoutput>
</body>
</html>