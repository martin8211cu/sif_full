<!---<cfdump var="#form#">--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectEmpleados"
	Default="Seleccionar Empleados"	
	returnvariable="LB_SelectEmpleados"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaAlta"
	Default="Fecha Alta despu&eacute;s del"	
	returnvariable="LB_FechaAlta"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaBaja"
	Default="Fecha Baja antes de "	
	returnvariable="LB_FechaBaja"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_IngresoAnual"
	Default="Ingreso Anual Excedente para no generar Ajuste Anual "	
	returnvariable="LB_IngresoAnual"/>
    
<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_GenerarE"
					default="Generar Empleados"
					returnvariable="BTN_GenerarE"/>
                    
<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Generar"
					default="Generar Ajuste Anual"
					returnvariable="BTN_Generar"/>
                    
<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_VerReporte"
					default="Ver Reporte"
					returnvariable="BTN_VerReporte"/>
                 
<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Continuar3"
					default="Continuar"
					returnvariable="BTN_Continuar3"/>
                    
                    
                    
<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Aplicar"
					default="Aplicar"
					returnvariable="BTN_Aplicar"/>
    
<cfquery name="rsAccion" datasource="#session.DSN#">
	select RHAAfecharige, RHAAfechavence, RHAAPeriodo
	from RHAjusteAnual
	where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
</cfquery>

<cfquery name="rsSelectEmpleado" datasource="#session.DSN#">
	select de.DEId, de.DEidentificacion, de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2 as NombreCompleto
	from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid,DatosEmpleado de
	where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		and rhaa.Ecodigo = #session.Ecodigo#
		and rhaaa.RHAAAEstatus = 1
		and rhaaa.DEId= de.DEid
	order by de.DEidentificacion
</cfquery>

<cfquery name="rsSelectISPT" datasource="#session.DSN#">
	select 1 as existe
	from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid= rhaa.RHAAid 
	where Ecodigo = #session.Ecodigo#
 		and rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		and RHAAAcumuladoISPT is not null 
</cfquery>

<cfif not isdefined("form.reporte") and isdefined("url.Reporte") and len(trim(url.Reporte))>
	<cfset form.reporte = url.reporte>
</cfif>

<cfoutput>
<form name="form2" method="post" style="margin: 0;" action="AjusteAnual-sql.cfm">
<input type="hidden" name="RHAAid" value="#form.RHAAid#">
<input type="hidden" name="hdAccion" id="hdAccion" value=""/>
<input type="hidden" name="hdDEid" id="hdDEid" value=""/>
<table width="100%" align="center">
 <cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount EQ 0 >
	<tr>
    	<td align="center">
    
        	<table width="80%" cellpadding="5">
            	 <tr>
	  				<td colspan="4" align="center">
                    	<p><strong>
                    	  Validaciones de acuerdo a la Ley del ISR
                    	  </strong>
               	    	</p>
                   		<p><strong>
                        	Para descartar a los Empleados que no tendr&aacute;n c&aacute;lculo de Ajuste Anual
                           </strong>
                        </p>
                    </td>
                </tr>
                <tr>
            		<td width="10%" align="right">
                		<input type="checkbox" name="chkAlta" id = "chkAlta" checked="checked" />
                	</td>
                	<td width="40%">
                		#LB_FechaAlta# #DateFormat(rsAccion.RHAAfecharige, 'dd/MM/yyyy')#
                	</td>
                	<td width="10%" align="right">
                		<input type="checkbox" name="chkBaja" checked="checked"/>
               		</td>
                	<td width="40%">
                    	<table>
                        	<tr>
                            	<td width="50%">
                                	#LB_FechaBaja# 
                                </td>
                                <td width="50%">
                                	<cf_sifcalendario form="form2" name="FechaHasta" id="FechaHasta" value = "#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                </td>
                            <tr>
                        </table>
                	</td>
                </tr>
                <tr>
	  				<td colspan="2" align="right">
                		#LB_IngresoAnual#
                	</td>
                	<td colspan="2">
                        <cf_inputNumber name="txtIngresoAnual" id = "txtIngresoAnual" value="" form="form2" enteros="30" decimales="0" negativos='false'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td align="center" width="100%">
  			<input type="submit" name="BTN_GenerarE" id="BTN_GenerarE" value="#BTN_GenerarE#" onclick="javascript: return funcAltaL();">
		</td>
    </tr>
 </cfif>
    <tr>
    	<td width="100%" align="center" >
        	<table width="70%">
    			<cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount GT 0 >
                <tr>
                	<td colspan="2">
                     <hr />
                    	<strong>
							Empleados que tienen Derecho a Ajuste Anual
                       	</strong>
                    </td>
                </tr> 
    				<cfloop query="rsSelectEmpleado">
     			<tr id="trCodigo" height="20px">
     				<td id="tdCodigo" width="30%" align="center" cellspacing="0" cellpadding="0" >
        				#rsSelectEmpleado.DEidentificacion#
        			</td>
					<td align="left">	
            			#rsSelectEmpleado.NombreCompleto#		
					</td>	
					<td  nowrap="nowrap" width="10%">
                    <cfif isdefined("form.reporte") and form.reporte NEQ true>
						<input name="BTN_BajaDos" id="BTN_BajaDos" type="image" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" onClick="javascript: return EliminarE(#rsSelectEmpleado.DEId#);">
                    <cfelseif not isdefined("form.reporte") and isdefined("rsSelectISPT") and rsSelectISPT.RecordCount EQ 0>
                    	<input name="BTN_BajaDos" id="BTN_BajaDos" type="image" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" onClick="javascript: return EliminarE(#rsSelectEmpleado.DEId#);">
                    </cfif>
					</td>
      			</tr>
            		</cfloop>
        		</cfif>	
            </table>
        </td>
    </tr>
    <tr>
    <cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount GT 0 >
    	<td align="center" colspan="2">
        	<table width="100%">
            	<tr>
                 	<td colspan="100%" align="center">
                    <cfif isdefined("form.reporte") and form.reporte NEQ true>
                    	<input type="submit" name="BTN_Generar" id="BTN_Generar" value="#BTN_Generar#">
                    <cfelseif not isdefined("form.reporte") and isdefined("rsSelectISPT") and rsSelectISPT.RecordCount EQ 0>
                    	<input type="submit" name="BTN_Generar" id="BTN_Generar" value="#BTN_Generar#">
                    <cfelse>
                    	<input type="submit" name="BTN_VerReporte" id="BTN_VerReporte" value="#BTN_VerReporte#">
                        <!---<input type="submit" name="BTN_Continuar3" id="BTN_Continuar3" value="#BTN_Continuar3#">--->
                    </cfif>
                    </td>
                    
                    
<!---                    <td width="50%" align="left">
                    	<!---<input type="submit" name="BTN_Aplicar" id="BTN_Aplicar" value="#BTN_Aplicar#">--->
                    </td>--->
               	</tr>
            </table>
         </td>
    </cfif>
    </tr> 	
</table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcAltaL(){
		<cfoutput>
			<!---alert('Aqui estoy');--->
			document.form2.txtIngresoAnual.required = true;
			<!---document.form2.txtIngresoAnual.description = "Código";--->			
		</cfoutput>
	}
 function EliminarE(id) {
		<cfoutput>
			document.form2.hdDEid.value = id;
			document.form2.hdAccion.value = "BAJAE";
			return true;
		</cfoutput>
	}
</script>

