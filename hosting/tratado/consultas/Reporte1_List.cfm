<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr bgcolor="#CCCCCC" class="style6">
        <td width="40%" colspan="2"><B><cf_translate key="LB_Persona">Persona</cf_translate></B></td>
        <td width="60%" colspan="2"><B><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></B></td>
    </tr>
	<cfoutput>
	<cfset Persona ="">
    <cfloop query="rsReporte">
        <cfif Persona neq rsReporte.TLCPcedula>
            <tr>
                <td colspan="4" align="center">&nbsp;</td>
            </tr> 
            <tr class="style6">
                <td colspan="2"><B>#rsReporte.TLCPnombre#&nbsp;#rsReporte.TLCPapellido1#&nbsp;#rsReporte.TLCPapellido2#</B></td>
                <td colspan="2"><B>#rsReporte.TLCPcedula#</B></td>
            </tr>
            <cfset Persona =  rsReporte.TLCPcedula>
        </cfif>
        <tr class="style6">
            <td colspan="4">
            	<table width="60%" border="0" cellpadding="0" cellspacing="0">
                    <tr class="style6">
                        <td width="75">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td width="400" nowrap="nowrap" align="left">#rsReporte.ETLCnomPatrono#</td>
                        <td width="100" nowrap="nowrap" align="right">#rsReporte.ETLCreferencia# :</td>
                        <td width="150" nowrap="nowrap" align="left">#rsReporte.TLCSreferencia#</td>
                     </tr>
                </table>    
            </td>
        </tr>    
    </cfloop>
    </cfoutput>
    <tr>
        <td colspan="4" align="center">&nbsp;</td>
    </tr>
    <tr class="style2">
        <td colspan="4" align="center">-------------------------------<cf_translate key="LB_Empresa">&Uacute;ltima L&iacute;nea</cf_translate>-------------------------------</td>
    </tr>
</table>
