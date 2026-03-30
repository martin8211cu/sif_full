<cfif isdefined('url.temp') and len(trim(url.temp)) GT 0>
	<cfif FileExists(#url.temp#)>
		<cfset _LvarFileName = '#session.Usulogin##dateformat(now(), "hhmmss")#.xls'>
		<cfheader name="Content-Disposition"	value="attachment;filename=#_LvarFileName#">
        <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
        <cfcontent type="application/msexcel" reset="yes" file="#url.temp#" deletefile="yes">
    <cfelse>
        <cf_templatecss>
        <cf_templateheader>
        <form name="formArchivos" action="SaldoActivos.cfm" method="post">
            <p>El Archivo temporal no existe.  Presione Regresar para volver al reporte</p>
                <p><input type="submit" name="Regresar" value="Regresar" /></p>
        </form>
        <cf_templatefooter>
    </cfif>
	<cfabort>
</cfif>
<!--- Obtención de Archivo Excel disponibles en el Servidor --->
<cfdirectory action="list" name="archivos" directory="#GetTempDirectory()#" filter="SaldoActivos*.xls">

<cfflush interval="32">
<cf_templatecss>
<cf_templateheader>
<form name="formArchivos" action="SaldoActivos.cfm" method="post">
	<p align="left">Los archivos generados disponibles en el Servidor son los que se muestran en la siguiente lista.</p>
	<p align="left">Seleccione el nombre del archivo que desea restaurar.</p>
	<table cellpadding="0" cellspacing="0">
		<tr bgcolor="#CCCCCC">
			<strong>
			<td>&nbsp;&nbsp;Archivo</td>
			<td align="right">Fecha&nbsp;&nbsp;</td>
			<td align="right">Tamaño</td>
			</strong>
		</tr>
		<cfoutput query="archivos">
			<tr>
				<td align="left">&nbsp;&nbsp;<a href="SaldoActivosArchivos.cfm?temp=#archivos.DiRECTORY#/#NAME#">#NAME#</a>&nbsp;&nbsp;</td>
				<td align="right">&nbsp;#dateformat(DATELASTMODIFIED, "DD/MM/YYYY HH:mm:ss")#&nbsp;&nbsp;</td>
				<td align="right">&nbsp;&nbsp;#NumberFormat(SIZE, ",9")# bytes</td>
			</tr>
		</cfoutput>
	</table>
	<p align="center"><input type="submit" name="Regresar" value="Regresar" /></p>
</form>