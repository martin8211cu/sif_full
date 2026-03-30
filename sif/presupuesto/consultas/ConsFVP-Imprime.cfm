<cf_templateheader title="Consulta LOG de Version de Formulación Presupuestaria">
	<cf_web_portlet_start titulo="Consulta LOG de Version de Formulación Presupuestaria">
    
	<cfinclude template="ConsFVP-sql.cfm">
    
<cf_htmlReportsHeaders irA="ConsFVP-form.cfm" 
	FileName="LOGVFP-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
	title="Consulta LOG de Version de Formulación Presupuestaria">
        <table width="100%">
            <tr>
                <td width="100" align="center"><strong> Tipo Error </strong></td>
                <td width="100" align="center"><strong> Fecha </strong></td>
                <td width="100" align="center"><strong> Hora Inicio </strong></td>
                <td width="100" align="center"><strong> Hora Final </strong></td>
                <td width="650" align="center"><strong> Mensaje </strong></td>
            </tr>
			<cfoutput query="rsResult">
            <tr>
                <td align="left" width="100" style="width:100"> 
                    #rsResult.Tipo_Error# 
                </td>
                <td align="left" width="100" style="width:100"> 
                    #rsResult.Fecha#
                </td>
                <td align="left" width="100" style="width:100">
                    #rsResult.Hora# 
                </td>
                <td align="left" width="100" style="width:100"> 
                    #rsResult.Aplicacion#
                </td>
                <td align="left" width="650" style="width:700"> 
                    #rsResult.Mensaje#
                </td>
            </tr>
        	</cfoutput>
      	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
