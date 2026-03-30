<table width="100%">
	<tr>
    	<td valign="top" align="left">
            <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" >
                <cfinvokeargument name="query" 				value="#rsLista#"/>
                <cfinvokeargument name="desplegar" 			value="GFADescripcion"/>
                <cfinvokeargument name="etiquetas" 			value="Descripcion"/>
                <cfinvokeargument name="formatos" 			value="S"/>
                <cfinvokeargument name="align" 				value="left"/>
                <cfinvokeargument name="formName" 			value="fmListaTipGen"/>
                <cfinvokeargument name="checkboxes" 		value="N"/>
                <cfinvokeargument name="keys" 				value="GFAid"/>
                <cfinvokeargument name="ira" 				value="TiposGeneracion.cfm"/>
                <cfinvokeargument name="MaxRows" 			value="10"/>
                <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                <cfinvokeargument name="PageIndex" 			value="1"/>
            </cfinvoke>
		</td>
		<td>
        	<cfoutput>
            <form name="fmTipGen" id="fmTipGen" action="TiposGeneracion-sql.cfm" method="post" onsubmit="return validaporcentaje()">
                    <input name="GFAid" id="GFAid" type="hidden" value="#rsSelected.GFAid#">
                    <table>
                        <tr>
                            <td>Código:</td>
                            <td><input name="GFACodigo" id="GFACodigo" value="#rsSelected.GFACodigo#"/></td>
                        </tr>
                        <tr>
                            <td>Descripción:</td>
                            <td><input name="GFADescripcion" id="GFADescripcion" value="#rsSelected.GFADescripcion#" /></td>
                        </tr>
                        <tr>
                            <td>Periodicidad de Facturación</td>
                            <td>
                                <select name="GFAPeriodicidad" id="GFAPeriodicidad">
                                    <option value="1"  <cfif rsSelected.GFAPeriodicidad EQ 1>selected</cfif>>Mensual</option>
                                    <option value="3"  <cfif rsSelected.GFAPeriodicidad EQ 3>selected</cfif>>Trimestral</option>
                                    <option value="12" <cfif rsSelected.GFAPeriodicidad EQ 12>selected</cfif>>Anual</option>                                        
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Método de Generación:</td>
                            <td>
                                <select name="GFAMetodo" id="GFAMetodo">
                                    <option value="1" <cfif rsSelected.GFAMetodo EQ 1>selected</cfif>>Según Porcentaje de Participación del Total de Ingresos</option>
                                    <option value="2" <cfif rsSelected.GFAMetodo EQ 2>selected</cfif>>Según Porcentaje de los Ingresos Propios</option>
                                    <option value="3" <cfif rsSelected.GFAMetodo EQ 3>selected</cfif>>Manual</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="TRPorcentaje">
                        	<td>Porcentaje:</td>
                        	<td>
                            	<cf_inputNumber name="GFAPorcentaje" enteros="3"  decimales="2" negativos="FALSE" value="#rsSelected.GFAPorcentaje#">%
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <cf_botones modo="#MODO#">
                            </td>
                        </tr>
                    </table>
                </form>
                <cf_qforms form="fmTipGen">
                	
                    <cf_qformsrequiredfield name="GFACodigo" 		description="Codigo">
                    <cf_qformsrequiredfield name="GFADescripcion" 	description="Descripción">
                    <cf_qformsrequiredfield name="GFAPeriodicidad" 	description="Periodicidad de Facturación">
                    <cf_qformsrequiredfield name="GFAMetodo"   		description="Método de Generación">    
                </cf_qforms>
    		</cfoutput>
        </td>
	</tr>
</table>