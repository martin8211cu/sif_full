<!--- Agencia Aduanal --->
<cfquery name="rsCMAgenciaAduanal" datasource="#session.DSN#" >
    select CMAAid, CMAAcodigo, CMAAdescripcion 
    from CMAgenciaAduanal
    where Ecodigo =  #session.Ecodigo#  
    order by CMAAcodigo, CMAAdescripcion 
</cfquery>
<!--- Aduana --->
<cfquery name="rsCMAduanas" datasource="#session.DSN#" >
    select CMAid, CMAcodigo, CMAdescripcion 
    from CMAduanas
    where Ecodigo =  #session.Ecodigo#  
    order by CMAcodigo, CMAdescripcion 
</cfquery>
    
<cf_templateheader title="Reporte de Agencia Aduanal">
<cf_templatecss>
    <cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Reporte de Agencia Aduanal">
    <cfinclude template="../../portlets/pNavegacion.cfm">
        <cfoutput>
            <form method="post" name="form1" action="rpAgenciaAduanal-form.cfm">
                <table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
                     <tr align="left">
                        <td nowrap align="right"><strong>Agencia Aduanal&nbsp;:&nbsp;</strong></td>
                         <td colspan="3" nowrap>   
                            <select name="fCMAAid">
                                <option value="0">--Todas--</option>
                                <cfloop query="rsCMAgenciaAduanal">
                                    <option value="#CMAAid#">#HTMLEditFormat(CMAAdescripcion)#
                                 </option>
                                </cfloop>
                            </select>
                        </td>
					</tr>
                     <tr align="left">
                         <td nowrap align="right"><strong>Aduana&nbsp;:&nbsp;</strong></td>
                         <td colspan="3" nowrap> 
                            <select name="fCMAid">
                                <option value="0">--Todas--</option>
                                <cfloop query="rsCMAduanas">
                                    <option value="#CMAid#" >#HTMLEditFormat(CMAdescripcion)#
                                </option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr align="left">
                        <td nowrap align="right"><strong>De la Fecha:</strong>&nbsp;</td>
                        <td colspan="3" nowrap><cf_sifcalendario name="FechaInicial" value="" tabindex="1"></td>
                    </tr>
                    <tr align="left">
                        <td  nowrap align="right"><strong>Hasta:</strong>&nbsp;</td>
                        <td nowrap colspan="3"><cf_sifcalendario name="FechaFinal" value="" tabindex="1"></td>
                    </tr>  
                    <tr>
                        <td align="center">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center"><input type="submit" value="Generar" name="Reporte" class="btnNormal"></td>
                    </tr>
                </table>
            </form>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>