<cfset LvarIrARPRegisEstaCtasMasiveFrame="RPRegistroEstadosCtasMasivo-frame.cfm">
<cfset LvarCBesTCE= 0>
<cfif isdefined("LvarTCERPRegisEstaCtasMasive") and LvarTCERPRegisEstaCtasMasive eq 1>
	<cfset LvarIrARPRegisEstaCtasMasiveFrame="TCERPRegistroEstadosCtasMasivo-frame.cfm">
<cfset LvarCBesTCE= 1>    
</cfif>
  
<cfif isdefined("form.lista") and  not isdefined("url.lista")>
	<cfset form.lista = form.lista>
</cfif>
<cfif not isdefined("form.lista") and  isdefined("url.lista")>
	<cfset form.lista = url.lista>
</cfif>



<form name="form1" method = "post">
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong>Visualizar en formato:</strong></td>
	<cfif LvarCBesTCE neq 1>    
    	<td>
			<select name="formato">
				<option value="flashpaper">FLASHPAPER</option>
				<option value="pdf">PDF</option>
				<option value="excel">EXCEL</option>
			</select>
		</td> 
    </cfif>       
    <cfif LvarCBesTCE eq 1>    
        <td>
           <select name="detallado"> 
            <option value="0">Resumido</option>
            <option value="1">Detallado</option>
           </select>
        </td>     
    </cfif> 
    </tr>
    <tr align="center">
    	<td colspan="2"><input name="visualiza" type="submit" value="Generar"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<cfoutput>
<cfif not isdefined('form.formato')>
	<cfset form.formato = 'flashpaper'>    
</cfif>
<cfif not isdefined('form.detallado')>
	<cfset form.detallado = 0>    
</cfif>

<iframe id="frReporteMovimientos" frameborder="0" width="100%" height="100%" src="<cfoutput>#LvarIrARPRegisEstaCtasMasiveFrame#</cfoutput>?lista=#form.lista#&detallado=#form.detallado#<cfif isdefined('form.Formato')>&formato=#form.formato#</cfif>&CBesTCE=#LvarCBesTCE#"></iframe></cfoutput>
