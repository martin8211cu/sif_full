<cf_templateheader title="#LvarTitle#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LvarTitle#">
		<form name="form1" method="post" action="<cfoutput>#LvarIrA#</cfoutput>">
        	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
            	<tr>
                	<!---►►Tipo de Reporte◄◄--->
					<td width="20%"><div align="right"><cfoutput>#MSG_ComboTipo#</cfoutput>:</div></td>
				  	<td width="24%">
                    	<select name="ComboTipo" tabindex="1">
                            <option value="A" selected="selected">Anual</option>
                            <option value="M" >Mensual</option>
                        </select>
                  	</td
				  	><td align="right"></td>
				  	<td>
				  	</td>
                </tr>
            	<tr> 
                	<!---►►Oficinas◄◄--->
					<td width="20%"><div align="right"><cfoutput>#MSG_Oficina#</cfoutput>:</div></td>
				  	<td width="24%">
                    	<select name="Oficina" id="Oficina" tabindex="1">
								<option value="-1" label="Todas"><cfoutput>#LB_Todas#</cfoutput></option>
					  		<cfoutput query="rsOficinas"> 
								<option value="#Ocodigo#" label="#rsOficinas.Odescripcion#">#Odescripcion#</option>
					  		</cfoutput> 
                        </select>
                  	</td>
                    <!---►►Periodo◄◄--->
				  	<td align="right"><cfoutput>#MSG_Periodo#:</cfoutput></td>
				  	<td>
						<select name="periodo" tabindex="1">
							<cfloop query = "rsPer">
								<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option>" <cfif periodo EQ "#rsPer.Eperiodo#">selected</cfif>></option>
							</cfloop>
						</select>
				  	</td>
				</tr>
                <tr>
					<!---►►Monedas◄◄--->
                    <td><div align="right"><cfoutput>#MSG_Moneda#</cfoutput></div></td>
				  	<td rowspan="2" valign="top">
              			<table border="0" cellspacing="0" cellpadding="2">
              				<tr>
                				<td nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="1"></td>
                    			<td nowrap><cfoutput>#MSG_Local#:</cfoutput></td>
                    			<td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
         					</tr>
                			<cfif isdefined("rsMonedaConvertida")>
                			<tr>
                                <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                                <td nowrap><cfoutput>#MSG_Convertida#:</cfoutput></td>
                                <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                 			</tr>
							</cfif>
							<!---<tr>
								<td nowrap><input name="mcodigoopt" type="radio" value="-4" tabindex="6"></td>
                                <td nowrap><cfoutput>#MSG_Informe_B15#:</cfoutput></td>
                                <td><cfoutput><strong>#lvarB15M#</strong></cfoutput></td>
                            </tr>
                			<tr>
                                <td nowrap><input name="mcodigoopt" type="radio" value="0" tabindex="1"></td>
                                <td nowrap> <cfoutput>#MSG_Origen#:</cfoutput></td>
                                <td>
                                    <select name="Mcodigo" tabindex="1">
                                        <cfoutput query="rsMonedas">
                                            <option value="#rsMonedas.Mcodigo#"
                                            <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                                                <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
                                            </cfif>
                                        >#rsMonedas.Mnombre#</option>
                                        </cfoutput>
                                    </select>
                          		</td>
                         	</tr>--->
               			</table>
              		</td>
			  		<!---►►Mes◄◄--->
                    <td width="4%" align="right" ><cfoutput>#CMB_Mes#:</cfoutput></td>
			  		<td width="42%"> 
                        <select name="mes" size="1" tabindex="1">
                          <option value="1" <cfif mes EQ 1>selected</cfif>><cfoutput>#CMB_Enero#</cfoutput></option>
                          <option value="2" <cfif mes EQ 2>selected</cfif>><cfoutput>#CMB_Febrero#</cfoutput></option>
                          <option value="3" <cfif mes EQ 3>selected</cfif>><cfoutput>#CMB_Marzo#</cfoutput></option>
                          <option value="4" <cfif mes EQ 4>selected</cfif>><cfoutput>#CMB_Abril#</cfoutput></option>
                          <option value="5" <cfif mes EQ 5>selected</cfif>><cfoutput>#CMB_Mayo#</cfoutput></option>
                          <option value="6" <cfif mes EQ 6>selected</cfif>><cfoutput>#CMB_Junio#</cfoutput></option>
                          <option value="7" <cfif mes EQ 7>selected</cfif>><cfoutput>#CMB_Julio#</cfoutput></option>
                          <option value="8" <cfif mes EQ 8>selected</cfif>><cfoutput>#CMB_Agosto#</cfoutput></option>
                          <option value="9" <cfif mes EQ 9>selected</cfif>><cfoutput>#CMB_Setiembre#</cfoutput></option>
                          <option value="10" <cfif mes EQ 10>selected</cfif>><cfoutput>#CMB_Octubre#</cfoutput></option>
                          <option value="11" <cfif mes EQ 11>selected</cfif>><cfoutput>#CMB_Noviembre#</cfoutput></option>
                          <option value="12" <cfif mes EQ 12>selected</cfif>><cfoutput>#CMB_Diciembre#</cfoutput></option>
                        </select> 
                	</td>
				</tr>
                <tr> 
					<!---►►Nivel◄◄--->
                    <td>&nbsp;</td>
					<td><div align="right"><cfoutput>#LB_Nivel#</cfoutput></div></td>
					<td> 
                        <select name="nivel" tabindex="1">
                          <cfloop index="i" from="1" to="#cantniv#">
                            <option value="<cfoutput>#i#</cfoutput>" <cfif i EQ 2>selected</cfif>><cfoutput>#i#</cfoutput></option>
                          </cfloop>
                        </select> 
                    	<input type="checkbox" name="chkConCodigo" value="1"> <cfoutput>#LB_ConCodigo#</cfoutput>
                    	<input type="checkbox" name="chkNivelSeleccionado" value="1"/>&nbsp;<cfoutput>#MSG_NivelSeleccionado#</cfoutput>
                   	</td>
				</tr>
                <tr>
					<td><div align="right"><cfoutput>#MSG_GrupoOficinas#</cfoutput></div></td>
					<td align="rigth">
						<select name="GOid" id="GOid" tabindex="1">
							<option value="-1"><cfoutput>#CBM_Ninguno#</cfoutput></option>
						  <cfoutput query="rsGruposOficina"> 
							<option value="#rsGruposOficina.GOid#">#rsGruposOficina.GOcodigo# - #rsGruposOficina.GOnombre#</option>
						  </cfoutput> 
						</select>					
					</td>
					<td align="rigth">&nbsp;</td>
					<td align="rigth">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="4" align="rigth">&nbsp;</td>
				</tr>
				<tr> 
				  	<td colspan="4" align="center">
						<cf_botones values="#LvarBotones#" names="#LvarBotones#" tabindex="1">
					</td>
				</tr>
   			</table>
       	</form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_Lightbox link="" titulo="Formular Variables" width="95" height="95" name="Homologar" url="/cfmx/sif/admin/ReportDinamic/formuladoraVariables.cfm"></cf_Lightbox>
<script type="text/javascript" language="javascript">
	function funcConfiguración(){<cfoutput>
		fnLightBoxSetURL_Homologar("/cfmx/sif/cg/consultas/modificaHomologacion.cfm?ANHid=#IDANhomologacion#");</cfoutput>
		fnLightBoxOpen_Homologar();	
		return false;	
	}
</script>