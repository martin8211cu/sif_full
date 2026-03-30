<table width="100%" border="0" cellpadding="2" cellspacing="0">
	 <cfloop query="rsEmpresas">
        <tr class="style6">
            <td width="15%" colspan="<cfoutput>#colspan#</cfoutput>"><B><cfoutput>(#rsEmpresas.posicion#)&nbsp;#rsEmpresas.Nombre#&nbsp;&nbsp;<cf_translate key="LB_Referencia">Referencia</cf_translate>:&nbsp;#rsEmpresas.Referencia#</cfoutput></B></td>
        </tr>
    </cfloop>
	<tr bgcolor="#CCCCCC" class="style6">
        <td width="15%"  align="left"><B><cf_translate key="LB_Persona">Persona</cf_translate></B></td>
        <td width="10%"  align="center"><B><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></B></td>
        
         <cfloop query="rsEmpresas">
        	<td align="right"><B><cfoutput>#rsEmpresas.Referencia#&nbsp;(#rsEmpresas.posicion#)</cfoutput></B></td>
        </cfloop>
    </tr>
    
	<cfoutput>
        <cfloop query="rsReporte">
            <tr class="style6">	
                <td  width="15%" align="left" >#rsReporte.TLCPnombre#&nbsp;#rsReporte.TLCPapellido1#&nbsp;#rsReporte.TLCPapellido2#</td>
                <td  width="10%" align="center">#rsReporte.TLCPcedula#</td>
                <cfloop from="1" to ="#arraylen(arreglo)#" index="i">
                	<td width="10%" nowrap="nowrap" align="right">#Evaluate("rsReporte.valor_#i#")#</td>
                </cfloop>
           </tr>
        </cfloop>
    </cfoutput>
    <tr>
        <td colspan="<cfoutput>#colspan#</cfoutput>" align="center">&nbsp;</td>
    </tr>
    <tr class="style6">
        <td colspan="<cfoutput>#colspan#</cfoutput>" align="center">-------------------------------<cf_translate key="LB_Empresa">&Uacute;ltima L&iacute;nea</cf_translate>-------------------------------</td>
    </tr>
</table>
