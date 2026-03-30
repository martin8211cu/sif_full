<cfquery name="rsEstado" datasource="#session.DSN#">
    select QPidEstado, QPEdescripcion,QPEdisponibleVenta
    from QPassEstado
    where Ecodigo = #session.Ecodigo#
</cfquery>

<cfset modo = 'Alta'>
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
        QPTNumLote as QPLcodigo,
        QPTNumPall,
        QPTEstadoActivacion,
        QPidEstado,
        QPidLote
        from QPassTag
        where QPTidTag = #form.QPTidTag#
        and Ecodigo = #session.Ecodigo#
    </cfquery>
	
	<cfquery name="rsLote" datasource="#session.DSN#">
		select QPidLote, QPLcodigo, QPLdescripcion
		from QPassLote
		where Ecodigo = #session.Ecodigo#
		and QPidLote = #rsQPTAG.QPidLote#
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

	<script language="javascript" type="text/javascript">
			
		<!--//Browser Support Code
		function ajaxFunction_ComboLista(){
		var ajaxRequest;  // The variable that makes Ajax possible!
			var QPidEstado ='';
			var QPTlista ='';
			
			QPidEstado = document.form1.QPidEstado.value;
			QPTidTag = document.form1.QPTidTag.value;
				try{
					// Opera 8.0+, Firefox, Safari
					ajaxRequest = new XMLHttpRequest();
				} 
			catch (e){
			// Internet Explorer Browsers
					try{
					ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} 
				catch (e) {
					try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (e){
			// Something went wrong
					alert("Your browser broke!");
					return false;
								}
							}	
					}		
			ajaxRequest.open("GET", '/cfmx/sif/QPass/catalogos/combo.cfm?QPidEstado='+QPidEstado+'&QPTidTag='+QPTidTag+'&QPTlista='+QPTlista, false);
			ajaxRequest.send(null);
			document.getElementById("contenedor_Concepto").innerHTML = ajaxRequest.responseText;
		}			
		//-->
	</script>

<cfoutput>
    <form name="form1" action="QPassTag_SQL.cfm" method="post">
		<input type="hidden" name="TagVendidos" value="#LvarTagVendidos#" />
    	<input name="QPTidTag" type="hidden" value="<cfif modo neq 'Alta'>#form.QPTidTag#</cfif>" tabindex="1"/>
        <table cellpadding="2" cellspacing="0" border="0">
	        <tr>
                <td align="right">
                    <strong>Tag:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTPAN" type="text" maxlength="16" <cfif LvarTagVendidos or modo neq 'Alta'> readOnly </cfif>  value="<cfif modo neq 'Alta'>#rsQPTAG.QPTPAN#</cfif>" tabindex="1"/>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero de Serie:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTNumSerie" <cfif LvarTagVendidos or modo neq 'Alta'> readOnly </cfif> type="text" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumSerie#</cfif>" tabindex="1"/>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero de Parte:</strong>&nbsp; 
                </td>
                <td align="left">
                    <input name="QPTNumParte" <cfif LvarTagVendidos or modo neq 'Alta'> readOnly </cfif> type="text" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumParte#</cfif>" tabindex="1"/>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Fecha de Producci&oacute;n:</strong>&nbsp;
                </td>
                <td align="left">
                    <cfif modo NEQ 'ALTA'> 
							 <input name="QPTFechaProduccion" readOnly type="text" value="#DateFormat(rsQPTAG.QPTFechaProduccion,'dd/mm/yyyy')#" tabindex="1" />
                    <cfelse>
                        <cf_sifcalendario name="QPTFechaProduccion" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"  tabindex="1">			  			  
                    </cfif>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Lote:</strong>&nbsp;
                </td>
                <td align="left">
                	<cfif modo eq 'Alta'>
                        <cf_conlis
                            Campos="QPidLote, QPLcodigo, QPLdescripcion"
                            Desplegables="N,S,S"
                            Modificables="N,S,N"
                            Size="0,10,15"
                            tabindex="1"
                            Title="Lista de Lotes"
                            Tabla="QPassLote a"
                            Columnas="QPidLote, QPLcodigo, QPLdescripcion" 
                            Filtro=" Ecodigo = #session.Ecodigo#"
                            Desplegar="QPLcodigo, QPLdescripcion"
                            Etiquetas="Código, Descripción"
                            filtrar_por="QPLcodigo, QPLdescripcion"
                            Formatos="S,S"
                            Align="left,left,"
                            form="form1"
                            Asignar="QPidLote, QPLcodigo, QPLdescripcion"
                            Asignarformatos="S,S,S"
                            width="800"
                        />
                    <cfelse>
						<cfif LvarTagVendidos>
							<input name="QPLcodigo" type="text" value="#rsLote.QPLcodigo#" tabindex="1" readOnly/> 
							<input name="QPidLote" 	 type="hidden" value="<cfif modo neq 'Alta'>#rsQPTAG.QPidLote#</cfif>" tabindex="1"/>
						<cfelse>
							<cf_conlis
								Campos="QPidLote, QPLcodigo, QPLdescripcion"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								Size="0,10,15"
								tabindex="1"
								Title="Lista de Lotes"
								Tabla="QPassLote a"
								Columnas="QPidLote, QPLcodigo, QPLdescripcion" 
								Filtro=" Ecodigo = #session.Ecodigo#"
								Desplegar="QPLcodigo, QPLdescripcion"
								Etiquetas="Código, Descripción"
								filtrar_por="QPLcodigo, QPLdescripcion"
								Formatos="S,S"
								Align="left,left,"
								form="form1"
								Asignar="QPidLote, QPLcodigo, QPLdescripcion"
								Asignarformatos="S,S,S"
								width="800"
								values="#rsLote.QPidLote#,#rsLote.QPLcodigo#,#rsLote.QPLdescripcion#"
								/>
                 		</cfif>
					</cfif>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>N&uacute;mero Pall:</strong>&nbsp;
                </td>
                <td align="left">
                    <input name="QPTNumPall" <cfif LvarTagVendidos or modo neq 'Alta'> readOnly </cfif> type="text" value="<cfif modo neq 'Alta'>#rsQPTAG.QPTNumPall#</cfif>" tabindex="1"/>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap" align="right">
                    <strong>Trazabilidad dispositivo:</strong>&nbsp;
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
					<cfif modo neq 'ALTA' and rsQPTAG.QPTEstadoActivacion EQ 4>
                        <select name="QPTEstadoActivacion" id="QPTEstadoActivacion" tabindex="1">
                            <option value="4" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 1>selected="selected"</cfif>>Vendido</option>
                            <option value="2" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 2>selected="selected"</cfif>>Recuperado</option>
                            <option value="7" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 7>selected="selected"</cfif>>Robado/Extraviado</option>
                        </select>
					<cfelseif modo neq 'ALTA' and rsQPTAG.QPTEstadoActivacion NEQ 9>	
	                        <select name="QPTEstadoActivacion" id="QPTEstadoActivacion" tabindex="1">
                            <option value="1" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 1>selected="selected"</cfif>>En Banco</option>
                            <option value="2" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 2>selected="selected"</cfif>>Recuperado</option>
                            <option value="7" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 7>selected="selected"</cfif>>Robado/Extraviado</option>
                        </select>
                    <cfelseif modo eq 'ALTA'>
                    	<select name="QPTEstadoActivacion" id="QPTEstadoActivacion" tabindex="1">
	                        <option value="1" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 1>selected="selected"</cfif>>En Banco</option>
                            <option value="2" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 2>selected="selected"</cfif>>Recuperado</option>
                            <option value="7" <cfif modo neq 'Alta' and rsQPTAG.QPTEstadoActivacion eq 7>selected="selected"</cfif>>Robado/Extraviado</option>
                        </select>
                    <cfelseif modo neq 'ALTA' and rsQPTAG.QPTEstadoActivacion EQ 9>
                    	<strong>Asignado a promotor</strong>
                        <input type="hidden" name="QPTEstadoActivacion" value="9" />
                    </cfif>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Estado TAG:</strong>&nbsp;
                </td>
                <td align="left">
                	<select name="QPidEstado" id="QPidEstado" tabindex="1" onchange="ajaxFunction_ComboLista();">
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
					<cfif not LvarTagVendidos>
						<cf_botones modo="#modo#" tabindex="1">
					<cfelse>
						<cf_botones modo="cambio" exclude = "baja,nuevo"tabindex="1">
					</cfif>
                </td>
            </tr>
        </table>
    </form>
</cfoutput>

<cf_qforms form="form1">
    <cf_qformsrequiredfield args="QPTPAN,Tag">
    <cf_qformsrequiredfield args="QPTNumSerie,Número de Serie">
    <cf_qformsrequiredfield args="QPTNumParte,Número de Parte">
    <cf_qformsrequiredfield args="QPTFechaProduccion,Fecha de Producción">
    <cf_qformsrequiredfield args="QPidLote,Lote">
    <cf_qformsrequiredfield args="QPTNumPall,Número Pall">
    <cf_qformsrequiredfield args="QPidEstado,Estado TAG">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.form1.action='QPassTag.cfm';
		document.form1.submit;
	}
</script>
