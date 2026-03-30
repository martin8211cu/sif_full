<cfquery name="rsPer" datasource="#Session.DSN#">
	select distinct Speriodo as Speriodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>
<cfif rsPer.recordcount EQ 0>
	<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('La empresa no posee ningún Mes Cerrado en la contabilidad General!')#" >
</cfif>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<script language="javascript">
	function cambio(campo){
		if(document.form1.ckResumido.checked && campo == 1){
			document.form1.ckDetallado.checked = false;
			document.form1.action = 'D-151-sql.cfm';
		}
		if(document.form1.ckDetallado.checked && campo == 2){
			document.form1.ckResumido.checked = false;
			document.form1.action = 'D-151_Detallado-sql.cfm';
		}
	}
</script>

<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte D-151">
			<cfoutput>
            <form action="<cfif isdefined("Form.ckDetallado")>D-151_Detallado-sql.cfm<cfelse>D-151-sql.cfm</cfif>" method="post" name="form1">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr><td colspan="4">&nbsp;</td></tr>
					<!--- Socio Negocio --->
					<tr>
						<!--- Proveedor de servicio--->
                        <td align="right" nowrap="nowrap">
                            <select name="TipoProveedor" id="TipoProveedor" onchange="
                                    document.getElementById('tdBeneficiario').style.display	= (this.value == 'T')?'none':'';
                                    document.getElementById('tdProveedor').style.display	= (this.value == 'T')?'none':'';                           
                                    document.getElementById('tdProveedor').style.display	= (this.value == 'SN')?'':'none';
                                    document.getElementById('espacio1').style.display	= (this.value == 'SN' || this.value == 'T')?'':'none';
                                    document.getElementById('espacio2').style.display	= (this.value == 'SN' || this.value == 'T')?'':'none';
                                    document.getElementById('c1').style.display	= (this.value == 'SN' || this.value == 'T')?'':'none';
                                    document.getElementById('c2').style.display	= (this.value == 'SN' || this.value == 'T')?'':'none';
                                    document.getElementById('tdBeneficiario').style.display	= (this.value == 'B')?'':'none';
                                "
                            >
                            	<option value="T">Todos</option>
                                <option value="SN">Socio Negocio:</option>
                                <option value="B" >Beneficiario:</option>
                            </select>
                        </td>
                   		<td id="tdProveedor" valign="top" align="left" nowrap="nowrap"  style="display:none;">
                        	<cf_sifsociosnegocios2 tabindex="1" size="55" frame="frame1" form="form1">         
                       	</td>
                       	<td id="tdBeneficiario" valign="top" align="left" nowrap="nowrap"  style="display:none;"> 
                        	<cf_tesbeneficiarios form="form1" tabindex="1">
                       	</td>
                        <!---<td colspan="2">&nbsp; Si no se elige filtra por todos los socios</td>--->
              		</tr>                    
<!---					<tr>
                    	<td width="40%" align="right" valign="baseline"><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
						<td valign="baseline" nowrap><cf_sifsociosnegocios2 tabindex="1"></td>
                    	<td colspan="2">&nbsp; Si no se elige filtra por todos los socios</td>
					</tr>--->
					<!--- Clasificacion del SN --->
                    <tr id="espacio1"><td colspan="4">&nbsp;</td></tr>				
                    <tr id="c1">
                        <td nowrap align="right" width="10%"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
                        <td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
                        <td colspan="2">&nbsp; No es Obligatoria, se utiliza para socios de Negocios</td>
                    </tr>
                    <tr id="espacio2"><td colspan="4">&nbsp;</td></tr>				
                    <tr id="c2">
                        <td nowrap align="right" width="10%"><strong>Clasificaci&oacute;n&nbsp;desde:&nbsp;</strong></td>
                        <td width="10%" nowrap valign="bottom"><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>					
                        <td nowrap align="right" width="10%"><strong>Clasificaci&oacute;n&nbsp;hasta:&nbsp;</strong></td>
                        <td width="10%" nowrap valign="bottom"><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
                    </tr>
					<!--- Periodos --->
                    <tr><td colspan="4">&nbsp;</td></tr>				
                    <tr>
                        <td align="right" valign="baseline" nowrap><strong>Mes Ini:</strong></td>
                        <td nowrap align="left">
                            <select name="mes" tabindex="1">
                                <cfloop query="rsMeses">
                                    <option value="#VSvalor#" <cfif isdefined("Form.MES") and Form.MES EQ #VSvalor#>Selected</cfif>>#VSdesc#</option>
                                </cfloop>	
                            </select>
                        </td>
                        <td align="left" valign="baseline" nowrap><strong>Periodo Ini:</strong>
                            <select name="periodo" tabindex="1">
                                <cfloop query="rsPer">
									<option value="#Speriodo#" <cfif isdefined("Form.PERIODO") and Form.PERIODO EQ #Speriodo#>Selected</cfif>>#Speriodo#</option>                                
                                </cfloop>
                            </select>
                        </td>
                        <td nowrap align="left">&nbsp; 
                          
                        </td>
                    </tr>
                    <tr><td colspan="4">&nbsp;</td></tr>				
                    <tr>
                        <td align="right" valign="baseline" nowrap><strong>Mes Fin:</strong></td>
                        <td nowrap align="left">
                            <select name="mes2" tabindex="1">
                                <cfloop query="rsMeses">
                                	<option value="#VSvalor#" <cfif isdefined("Form.MES2") and Form.MES2 EQ #VSvalor#>Selected</cfif>>#VSdesc#</option>
                                </cfloop>	
                            </select>
                        </td>
                        <td align="left" valign="baseline" nowrap><strong>Periodo Fin:</strong>
                       
                            <select name="periodo2" tabindex="1">
                                <cfloop query="rsPer">
                                	<option value="#Speriodo#" <cfif isdefined("Form.PERIODO2") and Form.PERIODO2 EQ #Speriodo#>Selected</cfif>>#Speriodo#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td nowrap align="left">&nbsp;
                         	    
                        </td>
                    </tr>
                    
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr>
                    	<td align="right" nowrap="nowrap">
                        	<input name="ckResumido" type="checkbox" value="Resumido" <cfif not isdefined("Form.ckDetallado")>checked="checked"</cfif> onclick="javascript:cambio(1)"/>
                        </td>
                        <td>
                        	<strong>&nbsp;Resumido</strong>
                        </td>
                    </tr>
                    <tr>
                    	<td align="right" nowrap="nowrap">
                        	<input name="ckDetallado" type="checkbox" <cfif isdefined("Form.ckDetallado")>checked="checked"</cfif> value="Detallado" onclick="javascript:cambio(2)"/>
                        </td>
                        <td>
                        	<strong>&nbsp;Detallado</strong>
                        </td>
                    </tr>                    				
                    <tr>
					<td colspan="4" align="center"> 
						<input name="btnConsultar" type="submit" value="Consultar">
						<input type="reset" name="Reset" value="Limpiar"> </td>
					</tr>
				</table>
			</form>
            </cfoutput>
	<cf_web_portlet_end>	
<cf_templatefooter>