<cfquery name="rsEstado" datasource="#session.DSN#">
    select QPidEstado, QPEdescripcion,QPEdisponibleVenta
    from QPassEstado
    where Ecodigo = #session.Ecodigo#
</cfquery>

<cfset modo = 'Cambio'>
<cfif isdefined("form.QPTidTag") and len(trim(form.QPTidTag)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>

<cfif modo neq 'Alta'>
    <cfquery name="rsQPTAG" datasource="#session.DSN#">
        select
		QPTidTag,
		QPTlista,
        QPTNumParte,
        QPTFechaProduccion,
        QPTNumSerie,
        QPTPAN,
        QPTNumLote,
        QPTNumPall,
        QPTEstadoActivacion,
        QPidEstado,
        QPidLote
        from QPassTag
        where Ecodigo = #session.Ecodigo#
		<cfif isdefined("form.QPTidTag") and len(trim(form.QPTidTag))>
		and QPTidTag = #form.QPTidTag#
		</cfif>
        and QPTEstadoActivacion in (4)
    </cfquery>
</cfif>

<cfquery name="rsEst" datasource="#session.DSN#">
    select a.QPEdisponibleVenta
    from QPassEstado a
		inner join QPassTag b
		on a.QPidEstado = b.QPidEstado
    where a.Ecodigo = #session.Ecodigo#
	<cfif isdefined ('form.QPTidTag') and len(trim(form.QPTidTag)) >
	  and b.QPTidTag = #form.QPTidTag#
	</cfif>
</cfquery>


<cfoutput>
    <form name="form1" action="QPassTag_SQL.cfm" method="post">
		<cfif isdefined("form.QPTidTag")>
    	<input name="QPTidTag" type="hidden" value="<cfif modo neq 'Alta'>#form.QPTidTag#</cfif>" tabindex="1"/>
		</cfif>
        <table cellpadding="2" cellspacing="0" border="0">
	        <tr>
                <td align="right">
                    <strong>Tag:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTPAN" type="text" disabled="disabled" maxlength="16" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTPAN#</cfif>" tabindex="1" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero de Serie:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTNumSerie" type="text" disabled="disabled" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumSerie#</cfif>" tabindex="1" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero de Parte:</strong>&nbsp; 
                </td>
                <td align="left">
                    <input name="QPTNumParte" disabled="disabled" type="text" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumParte#</cfif>" tabindex="1" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Fecha de Producci&oacute;n:</strong>&nbsp;
                </td>
                <td align="left">
                        <cf_sifcalendario name="QPTFechaProduccion" value="#DateFormat(rsQPTAG.QPTFechaProduccion,'dd/mm/yyyy')#"  tabindex="1" readOnly = "true">
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Lote:</strong>&nbsp;
                </td>
                <td align="left">
                    	<cfquery name="rsLote" datasource="#session.DSN#">
                            select QPidLote, QPLcodigo, QPLdescripcion
                            from QPassLote
                            where Ecodigo = #session.Ecodigo#
							<cfif isdefined("form.QPTidTag") and len(trim(form.QPTidTag))>
                           	 and QPidLote = #rsQPTAG.QPidLote#
							</cfif>
                        </cfquery>
                        <input name="QPTNumLotedisable" type="text" disabled="disabled" value="<cfif modo neq 'Alta'>#rsLote.QPLcodigo#</cfif>" tabindex="1" />
                        <input name="QPTNumLote" type="hidden" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumLote#</cfif>" tabindex="1"/>
                        <input name="QPidLote" 	 type="hidden" value="<cfif modo neq 'Alta'>#rsQPTAG.QPidLote#</cfif>" tabindex="1"/>
                    
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero Pall:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTNumPall"  disabled="disabled" type="text" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumPall#</cfif>" tabindex="1"/>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap" align="right">
                    <strong>Estado Activaci&oacute;n TAG:</strong>&nbsp;
                </td>
                <td align="left">
                	<!--- Documentacion de Campo:  Estado de Dispositivo ( QPTEstadoActivacion )
						1: En Banco / Almacen o Sucursal, 
						2:  Recuperado ( En poder del banco por recuperacion )
						3:  En proceso de Venta ( Asignado a Cliente pero no Activado )
						4. Vendido y Activo
						5: Vendido e Inactivo
						6:  Vendido y Retirado
						7: Robado o Extraviado --->
					<cfif modo neq 'ALTA' and rsQPTAG.QPTEstadoActivacion NEQ 9>
                        <select name="QPTEstadoActivacion" id="QPTEstadoActivacion" tabindex="1">
                            <option value="4" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 4>selected="selected"</cfif>>Vendido</option>
                            <option value="2" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 2>selected="selected"</cfif>>Recuperado</option>
                            <option value="7" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 7>selected="selected"</cfif>>Robado/Extraviado</option>
                        </select>
					</cfif>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Estado TAG:</strong>&nbsp;
                </td>
                <td align="left">
                	<select name="QPidEstado" id="QPidEstado" tabindex="1" onChange="ajaxFunction_ComboLista();">
                    	<cfloop query="rsEstado">
							<option value="#QPidEstado#" <cfif modo neq 'Alta' and rsQPTAG.QPidEstado eq rsEstado.QPidEstado>selected="selected"</cfif>>#rsEstado.QPEdescripcion#</option>
						</cfloop>
                    </select>
                </td>
            </tr>
			
			 <tr>
                <td align="right" valign="top">
                    <strong>Lista</strong>&nbsp;
                </td>
                <td align="left">
				<span id="contenedor_Concepto">
				<cfif rsEst.QPEdisponibleVenta neq 1>
	 			" El estado no está disponible<br> para venta, por tanto quedará<br> en lista <strong> Negra </strong>"
				 <cfelse>
					<select name="QPTlista" tabindex="1">
						<option value="B" <cfif modo NEQ 'ALTA' and rsQPTAG.QPTlista eq 'B'>selected="selected"</cfif>>Blanca</option>
						<option value="G" <cfif modo NEQ 'ALTA' and rsQPTAG.QPTlista eq 'G'>selected="selected"</cfif>>Gris</option>
						<option value="N" <cfif modo NEQ 'ALTA' and rsQPTAG.QPTlista eq 'N' or rsEst.QPEdisponibleVenta neq 1>selected="selected"</cfif>>Negra</option>
					</select>
				</cfif>
               </span> </td>
            </tr>			
           
            <tr>
                <td colspan="2">
                    <cf_botones modo="#modo#" exclude = "Nuevo,baja" tabindex="1">
                </td>
            </tr>
        </table>
    </form>
</cfoutput>
