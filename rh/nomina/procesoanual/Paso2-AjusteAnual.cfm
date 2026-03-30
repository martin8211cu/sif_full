<!---<cfthrow message="#modoE#">--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptosPago"
	Default="Conceptos de Pago"
	returnvariable="LB_ConceptosPago"/>
 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptosNoPago"
	Default="Conceptos que no se incluyen en el Ajuste Anual"
	returnvariable="LB_ConceptosNoPago"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptosFiniquito"
	Default="Conceptos de Finiquito"
	returnvariable="LB_ConceptosFiniquito"/>

<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Continuar"
					default="Continuar"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Continuar"/>
                    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>	
    
<!---<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>	--->
   
<cfquery name="rsConcPago" datasource="#session.dsn#">
	select * 
    from CIncidentes
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    order by CIdescripcion
</cfquery>

<cfquery name="rsSelectEmpleado" datasource="#session.DSN#">
	select de.DEId, de.DEidentificacion, de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2 as NombreCompleto
	from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid,DatosEmpleado de
	where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		and rhaa.Ecodigo = #session.Ecodigo#
		<!---and rhaaa.RHAAAEstatus = 1--->
		and rhaaa.DEId= de.DEid
	order by de.DEidentificacion
</cfquery>

<!---<cf_dump var="#rsSelectEmpleado#">--->
    
<cfoutput>
	<form name="form1" method="post" action="AjusteAnual-sql.cfm" >
        <input type="hidden" name="hdCodigo" id="hdCodigo" value="" />
		<input type="hidden" name="hdAccion" id="hdAccion" value="" />
    	<table width="100%" align="center">
        	<tr>
            	<td width="90%">
                	<table  id="tblCar" align="center" border="0" cellspacing="0" cellpadding="0">
                    	<tr height="40px">
            				<td colspan="4" align="center">
            					<strong>
                                #LB_ConceptosNoPago#
                                </strong>
                			</td>
            			</tr>
	    				<tr height="20px">
            				<td width="30%" align="left" cellspacing="0" cellpadding="0" >
                            	<input type="hidden" name="RHAAid" value="#form.RHAAid#">
                				#LB_ConceptosPago# 
                			</td>
			    			<td >				
								<select name="Concepto" id="concepto">
                                		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
									<cfloop query="rsConcPago">
										<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIdescripcion# </option>	
									</cfloop>
								</select>	
							</td>	
							<td  nowrap="nowrap">
                            	<!---<cfset IndexSelect = #form.Concepto.selectedIndex#> --->
                                <!--- <cfthrow message="#IndexSelect#">--->
                                <!--- <input type="hidden" name="CIcodigo" value="#form.Concepto#">--->
                                  <!---<input type="hidden" name="CIdescripcion" value="#form.RHAAid#">--->
								<!---<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">	--->						
							</td>
							<td>
                            	<cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount EQ 0 >
                           		<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
                                </cfif>
								<!---<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar();" value="+">--->
							</td>
						</tr> 
            			<tr height="15px">
            				<td colspan="4">
            					<hr />
                			</td>
            			</tr> 
                        <cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
                        <cfquery name = "rsSelectConcepto" datasource ="#session.DSN#">
    							select rhaanc.RHAAid,rhaanc.CIid,ci.CIcodigo,ci.CIdescripcion
								from RHAjusteAnualNoConceptos rhaanc, CIncidentes ci	 
								where rhaanc.CIid = ci.CIid
                                	  and ci.Ecodigo = #session.Ecodigo#
	 								  and RHAAid = #form.RHAAid#
								group by rhaanc.RHAAid,rhaanc.CIid,ci.CIcodigo,ci.CIdescripcion
						</cfquery>                      
						</cfif>
                        <cfif isdefined("rsSelectConcepto") and rsSelectConcepto.recordcount GT 0 > 
                        <cfloop query="rsSelectConcepto">
                        <tr id="trCodigo" height="20px">
            				<td id="tdCodigo" width="30%" align="center" cellspacing="0" cellpadding="0" >
                            	#rsSelectConcepto.CIcodigo#
               			 	</td>
			    			<td align="left" cellspacing="0" cellpadding="0">	
                            	#rsSelectConcepto.CIdescripcion#		
							</td>	
							<td  nowrap="nowrap">
                            <cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount EQ 0 >
							<input name="BTN_Baja" id="BTN_Baja" type="image" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" onClick="javascript: return Eliminar(#rsSelectConcepto.CIid#);">
                            </cfif>
							</td>
            			</tr>
                        </cfloop> 
                        </cfif>			
            		</table> 
                </td>
        	</tr>
            <!---<tr>
            	<td width="90%">
                <table align="center" border="0" cellspacing="0" cellpadding="0">
                    	<tr height="40px">
            				<td colspan="4" align="center">
            					<strong>
                                #LB_ConceptosFiniquito#
                                </strong>
                			</td>
            			</tr>
	    				<tr height="20px">
            				<td width="30%" align="left" cellspacing="0" cellpadding="0" >
                           <!--- 	<input type="hidden" name="RHAAid" value="#form.RHAAid#">--->
                				#LB_ConceptosFiniquito# 
                			</td>
			    			<td>				
								<select name="ConceptoFini" id="conceptoFini">
									<cfloop query="rsConcPago">
										<option value="<cfoutput>#rsConcPago.CIcodigo#</cfoutput>" selected >#CIdescripcion#</option>	
									</cfloop>
								</select>	
							</td>	
							<td  nowrap="nowrap">
							
							</td>
							<td>
                            	<input type="submit" name="BTN_Agregar" id="BTN_Agregar" value="#BTN_Agregar#" >
                            </td>
						</tr> 
            			<tr height="15px">
            				<td colspan="4">
            					<hr />
                			</td>
            			</tr> 
                        <cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
                        <cfquery name = "rsSelectConceptoFini" datasource ="#session.DSN#">
    							select RHAAid,RHAANCcodigo,RHAANCdescripcion 
								from RHAjusteAnualNoConceptos rhaanc, CIncidentes ci	 
								where rhaanc.RHAANCcodigo = ci.CIcodigo
                                	  and ci.Ecodigo = #session.Ecodigo#
	 								  and RHAAid = '#form.RHAAid#'
                                      and DRHAAFiniquito = 1
								group by RHAAid,RHAANCcodigo,RHAANCdescripcion
						</cfquery>                      
						</cfif>
                        <cfif isdefined("rsSelectConceptoFini") and rsSelectConceptoFini.recordcount GT 0 > 
                        <cfloop query="rsSelectConceptoFini">
                        <tr id="trCodigo" height="20px">
            				<td id="tdCodigo" width="30%" align="center" cellspacing="0" cellpadding="0" >
                            	#rsSelectConceptoFini.RHAANCcodigo#
               			 	</td>
			    			<td align="left" cellspacing="0" cellpadding="0">	
                            	#rsSelectConceptoFini.RHAANCdescripcion#		
							</td>	
							<td  nowrap="nowrap">
							<input name="BTN_BajaFini" id="BTN_BajaFini" type="image" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" onClick="javascript: return Eliminar('#rsSelectConceptoFini.RHAANCcodigo#');">
							</td>
            			</tr>
                        </cfloop> 
                        </cfif>			
            		</table> 
                </td>
            </tr>--->
            <tr>
            	<td width="90%" align="center">
                	<cfif isdefined("rsSelectEmpleado") and rsSelectEmpleado.recordcount EQ 0 >
                	<input type="submit" name="BTN_Continuar" id="BTN_Continuar" value="#BTN_Continuar#">
                    </cfif>
            	</td>
        	</tr>
    	</table>	
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
 function Eliminar(id) {
		<cfoutput>
			document.form1.hdCodigo.value = id;
			document.form1.hdAccion.value = "BAJA";
			return true;
		</cfoutput>
	}
</script>

