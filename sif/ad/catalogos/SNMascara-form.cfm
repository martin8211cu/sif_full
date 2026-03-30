<cfif Modo EQ 'CAMBIO'>
	<cfquery name="SNMascaras" datasource="#session.dsn#">
    	select SNMid,SNMDescripcion,SNMascara,ts_rversion,SNtipo 
        	from SNMascaras 
         where SNMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNMid#">
    </cfquery>
</cfif>
<cfsavecontent variable="helpmsj">
Formato de máscara que utilizaran en los Socios de Negocios<br />
&nbsp;'X': para Letras.<br />
&nbsp;'?': para Numeros. <br />
&nbsp;'*': para Letras y Números. <br />
</cfsavecontent>
<cfsavecontent variable="helpimg">
	<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0"/>
</cfsavecontent>
<cfoutput>
      <table border="0" align="center" width="100%">
            <tr>
            	<td valign="top">
                	<cfinvoke component="sif.Componentes.pListas" method="pListaRH">
                   		<cfinvokeargument name="tabla" 				value="SNMascaras">
                        <cfinvokeargument name="columnas" 			value="SNMid,SNMDescripcion,SNMascara,ts_rversion, case SNtipo 
                        													when 'F' then 'Fisico' 
                                                                            when 'J' then 'Juridico' 
                                                                            when 'E' then 'Extranjero'
																			else 'otro' end SNtipo">
                        <cfinvokeargument name="desplegar" 			value="SNMDescripcion,SNMascara">
                        <cfinvokeargument name="etiquetas" 			value="Descripcion, Mascara">
                        <cfinvokeargument name="formatos" 			value="S,S">
                        <cfinvokeargument name="filtro" 			value="Ecodigo = #session.Ecodigo#">
                        <cfinvokeargument name="align" 				value="L,L">
                        <cfinvokeargument name="keys" 				value="SNMid">
                        <cfinvokeargument name="filtrar_automatico" value="true">
                        <cfinvokeargument name="mostrar_filtro" 	value="true">
                        <cfinvokeargument name="cortes" 			value="SNtipo">
                        <cfinvokeargument name="IrA" 				value="SNMascara.cfm">
                   </cfinvoke>
           	 	</td>
                <td>
                	<form name="form1" action="SNMascara-sql.cfm" method="post">
                    	<cfif Modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts"> 
                            	<cfinvokeargument name="artimestamp" value="#SNMascaras.ts_rversion#">      
							</cfinvoke>
                            <input type="hidden" name="ts_rversion" value="#ts#"/>
                            <input type="hidden" name="SNMid" 		value="#SNMascaras.SNMid#"/>
						</cfif>
							
                        <table border="0" align="center" width="100%">
                            <tr><td>Tipo:</td>
                                <td>
                                    <select name="SNtipo" id="SNtipo">
                                      <option value="F" <cfif SNMascaras.SNtipo EQ "F">selected="true"</cfif>>Físico</option>
                                      <option value="J" <cfif SNMascaras.SNtipo EQ "J">selected="true"</cfif>>Juridico</option>
                                      <option value="E" <cfif SNMascaras.SNtipo EQ "E">selected="true"</cfif>>Extrangero</option>
                                    </select>
                              </td>
                            </tr>
                            <tr>
                            	<td>Descripción:</td>
                                <td><input type="text" name="SNMDescripcion"  id="SNMDescripcion" size="30" maxlength="60" value="#SNMascaras.SNMDescripcion#"></td>
                            </tr>
                            <tr>
                            	<td>Mascara:</td>
                                <td><input type="text" name="SNMascara" id="SNMascara" size="30" maxlength="30"  value="#SNMascaras.SNMascara#">
                                <cf_notas titulo="Mascara Socio de Negocios" link="#helpimg#" pageIndex="1" msg = "#helpmsj#" animar="true">
                              </td>
                            </tr>
                             <tr>
                				<td colspan="2" align="center"><cf_botones modo="#Modo#"></td>
            				</tr>
                        </table>
                    </form>
           	 	</td>
            </tr>
        </table>
</cfoutput>
