<cfset LvarIrARPRegistroEstadosCtasFr = "RPRegistroEstadosCtas-frame.cfm">
<cfset LvarCBesTCE= 0>
<cfif isdefined("LvarTCERPRegistroEstadosCtas") and LvarTCERPRegistroEstadosCtas eq 1>
	<cfset LvarIrARPRegistroEstadosCtasFr = "RPRegistroEstadosCtasTCE-frame.cfm">
 <cfset LvarCBesTCE= 1>
</cfif>

<cfif not isdefined("form.ECid") and  isdefined("url.ECid")>
	<cfset form.ECid = url.ECid>
</cfif>

<form name="form1" method   = "post">
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<cfif LvarCBesTCE neq 1>   
        <td><strong>Visualizar en formato:</strong></td>		 
            <td>
                <select name="formato">
                    <option value="flashpaper">FLASHPAPER</option>
                    <option value="pdf">PDF</option>
                    <option value="excel">EXCEL</option>
                </select>
            </td>           
        
		<td><input name="visualiza" type="submit" value="Generar"></td>
        </cfif> 
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<cfoutput>
<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'flashpaper'>
</cfif>
<cfif not isdefined('form.detallado')>
	<cfset form.detallado = 0>    
</cfif>
<!---Llamado del Frame del reporte con TCE o desde Bancos--->
<iframe id="frReporteMovimientos" frameborder="0" width="100%" 
height="85%" src="<cfoutput>#LvarIrARPRegistroEstadosCtasFr#</cfoutput>?ECid=#form.ECid#&detallado=#form.detallado#&CBesTCE=#LvarCBesTCE#<cfif isdefined('form.Formato')>&formato=#form.formato#</cfif>"></iframe></cfoutput>
