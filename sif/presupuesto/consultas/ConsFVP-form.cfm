<cf_templateheader title="Consulta LOG de Version de Formulación Presupuestaria">
	<cf_web_portlet_start titulo="Consulta LOG de Version de Formulación Presupuestaria">
	<cfinclude template="ConsFVP-sql.cfm">
        <form name="formResult"  method="post" action="ConsFVP-form.cfm">
        	<cfoutput>
			<table id="Filtro" width="100%" class="areaFiltro" border="0" cellspacing="0" cellpadding="2">
            	<tr>
                	<td width="100" style="width:100"> Tipo Error </td>
                    <td width="100" style="width:100"> Fecha </td>
                    <td width="100" style="width:100"> Hora Inicio </td>
                    <td width="100" style="width:100"> Hora Final </td>
                    <td width="650" style="width:700"> Mensaje </td>
                </tr>
                <tr>
                	<td width="100" style="width:100"> 
                     	<select name="LogError" id="LogError" style="width:100" >
                        	<option value="Error"
							<cfif isdefined('form.LogError') and #form.LogError# EQ 'Error'>selected</cfif> >
                            Error</option>
							<option value="Information"
							<cfif isdefined('form.LogError') and #form.LogError# EQ 'Information'>selected</cfif> >
                            Information</option>
                            <option value="Warning"
							<cfif isdefined('form.LogError') and #form.LogError# EQ 'Warning'>selected</cfif> >
                            Warning</option>
                        </select>
                    
<!---                    	<input type="text" name="LogError" id="LogError" 
                        
                        value="<cfif isdefined('form.LogError') and #form.LogError# NEQ ''>#form.LogError#</cfif>" 
                        style="width:100" width="100" /> --->
                        
                    </td>
                    <td width="100" style="width:100">
                    	<cfif isdefined('form.LogFecha')>
                     		<cf_sifcalendario conexion="#session.DSN#" form="formResult" name="LogFecha" value="#form.LogFecha#">
                        <cfelse>
                        	<cf_sifcalendario conexion="#session.DSN#" form="formResult" name="LogFecha" value="">
						</cfif>
                    </td>
                    <td width="100" style="width:100">
                    	<cf_hora name="LogHora" form="formResult" value="#form.LogHora#">
                        <cfset form.LogHora = #LogHora#>
                    </td>
                    <td width="100" style="width:100"> 
                    	<cf_hora name="LogHoraFin" form="formResult" value="#form.LogHoraFin#">
                        <cfset form.LogHoraFin = #LogHoraFin#>
                    </td>
                    <td width="700" style="width:700">
                    	<input type="text" name="LogMen" id="LogMen" 
                        value="<cfif isdefined('form.LogMen') and #form.LogMen# NEQ ''>#form.LogMen#</cfif>"  
                        width="700" style="width:700" />
                        
                    </td>
                </tr>
                <tr>
                    <td align="right" width="100" style="width:100">
                    	<input type="checkbox" name="chk_error"  
                        <cfif isdefined('Form.chk_error')> checked="checked" </cfif>>
                    </td>
                    <td align="left" ><strong>Solo Errores</strong> </td>
                    <td align="left" width="100" style="width:100" ><strong>Ultimos:</strong></td>
                    <td align="left" ><input type="text" name="UltReg" id="UltReg" 
                        value="<cfif isdefined('form.UltReg') and #form.UltReg# NEQ ''>#form.UltReg#</cfif>"/>
                    </td>
                    <td align="right">
                        <input name="btnFiltro" type="submit" id="btnFiltro" value="Filtrar" >
                    </td>
                </tr>
            </table>
            </cfoutput>
			<cfif isdefined("form.btnFiltro") and (rsResult.RecordCount GT 501)>
            <table width="100%">
                <tr valign="top" align="center"> 
                    <td colspan="5" align="center">
                        <span style="font-size: 16px"><strong>*** El n&uacute;mero de Logs Resultantes *** <br>
                        *** en la consulta exceden el l&iacute;mite permitido. Delimite la consulta con filtros m&aacute;s detallados. ***</strong></span>
                    </td>
                </tr>
            </table>
			<cfelse>
            
<!---            	<table width="100%">
					<cfset LvarIrA     = 'FApreFactura.cfm'>
					<cfset LvarFileName = "LOGVFP-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
                    <tr>
                        <td align="right">
                            <cfset params = "">
                            <cf_rhimprime >
                        </td>
                    </tr>
                </table>
--->                
				
                <table width="100%">
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
                 <cfif rsResult.RecordCount GT 0>
                    <tr align="center" >
                        <td align="center" colspan="5"> 
                            <input type="submit" name="Imprimir" value="Imprimir"
                            onclick="javascript: return ira();" />
                        </td>
                	</tr>
                 </cfif>   
                </table>
            </cfif>
        </form>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function ira() {
		document.formResult.action = "ConsFVP-Imprime.cfm";
	}		
</script>