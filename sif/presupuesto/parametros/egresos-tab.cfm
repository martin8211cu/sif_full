<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >		

<cfoutput>           
	<cfloop query="rsTiposMovimientos">
    	<cfif #rsTiposMovimientos.CPTMorden2# eq 0>
        	<tr>
                <td>&nbsp;</td>
                <td colspan="2" bgcolor="##FAFAFA" align="center">
                    <hr size="0"><font size="2" color="##000000"><strong>#rsTiposMovimientos.CPTMdescripcion#</strong></font>			
                </td>
                <td>&nbsp;</td>
            </tr>
        <cfelse>
            <tr>
                <td align="right" nowrap>&nbsp;</td>
                <td align="right" nowrap>#rsTiposMovimientos.CPTMdescripcion#:&nbsp;</td>
                <td>
                	<cfset LvarTipo = "E_#trim(rsTiposMovimientos.CPTMtipoMov)#">
                    <input type="hidden" name="CPTMid" id="CPTMid" value="Cmayor_#LvarTipo#">
					<cfset ctamayor = "">
					<cfif len(trim(#rsTiposMovimientos.Cmayor#)) gt 0>
                        <cfset ctamayor = #rsTiposMovimientos.Cmayor#>
                    </cfif>
                    <cf_sifCuentasMayor form="form1" Cmayor="Cmayor_#LvarTipo#" Cdescripcion="Cdescripcion_#LvarTipo#"  idquery="#ctamayor#" tabindex="2" Ctipos="O">
                </td>
                <td>&nbsp;</td>
            </tr>
		</cfif>            
    </cfloop> 
    <tr><td colspan="4">&nbsp;</td></tr>

    <tr>
        <td colspan="4" align="center">
        	<input type="submit" name="btnAceptar" value="Guardar" tabindex="4">			
        </td>
    </tr> 
</cfoutput>  
</table>