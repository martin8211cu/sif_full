<cfoutput>
<cfset modo = "ALTA">	
	<cfif isdefined("form.CPDCid") and len(trim(form.CPDCid)) and isdefined("form.CFid") and len(trim(form.CFid))>            	
			<cfset modo = "CAMBIO">
			<cfif modo neq 'ALTA'>
				<cfquery name="data" datasource="#session.DSN#">
					select CPDCid, CFid, CPDCCFporc, CPDCCFdefault
					from CPDistribucionCostosCF
					where  CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CPDCid)#">
						 and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CFid)#">
				</cfquery> 
			</cfif>
	</cfif>
    
    <cfif isdefined("form.CPDCid") and len(trim(form.CPDCid))>
    	<cfquery name="porcentaje" datasource="#session.DSN#">
			select coalesce(SUM(CPDCCFporc),0) as porctotal
        	from CPDistribucionCostosCF
        	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CPDCid)#">
            <cfif modo EQ 'CAMBIO' and isdefined("form.CFid") and len(trim(form.CFid))>
            	and CFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CFid)#">
            </cfif>
		</cfquery> 
    </cfif>
	<cfif isdefined('form.LvarReset')>
	   <cfset modo = "ALTA">	
	</cfif>	
	
    <cfquery name="queryValidar" datasource="#session.DSN#">
			select Validada
        	from CPDistribucionCostos
        	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CPDCid)#">
            
	</cfquery> 
 
	<cfif isdefined("form.CPDCid") and len(trim(form.CPDCid))>		
			<form  name="form2" action="TipoCentroFuncionalSql.cfm" method="post" onsubmit="return porcentajes()">
				<table width="98%" border="0" cellpadding="0" cellspacing="2%"> 
					<input type="hidden" name="CPDCid" value="<cfif modo neq 'ALTA'><cfoutput>#data.CPDCid#</cfoutput><cfelse>#form.CPDCid#</cfif>">
                    <input type="hidden" name="Validar" id="Validar" value="#queryValidar.Validada#">
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                    	<td width="11%" align="right" nowrap><strong>Ctro.Funcional:</strong>&nbsp;</td>
                    	<td width="21%" nowrap class="fileLabel">
                    		<cfif isdefined("form.CFid") and Len(Trim(form.CFid))>
                                <cfquery name="rscfuncional" datasource="#Session.DSN#">
                                    select CFid, CFcodigo, CFdescripcion 
                                    from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
                                </cfquery>
                                    <cfif modo neq 'ALTA'>
                                        <cfset LvarReadonly = "yes">
                                    <cfelse>
                                        <cfset LvarReadonly = "no">                                
                                    </cfif>
                                    <input type="hidden" name="CFid" value="<cfif modo neq 'ALTA'><cfoutput>#rscfuncional.CFid#</cfoutput></cfif>">
                                    <cf_rhcfuncional id="CFid" form="form2" query="#rscfuncional#" readonly="#LvarReadonly#">
                                <cfelse>
                                    <cf_rhcfuncional id="CFid" form="form2">
                    		</cfif>
                    	</td>	
                    </tr>
				
					<tr>
						<td nowrap align="right"><strong>Porcentaje: </strong></td>
						<td nowrap>
                        	<input id="CPDCCFporc" name="CPDCCFporc" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'><cfoutput>#data.CPDCCFporc#</cfoutput></cfif>" 
                            onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
                            onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            alt="Porcentaje"> %   
                            <input type="hidden" name="CPDCCFtot" id="CPDCCFtot" value="<cfoutput>#porcentaje.porctotal#</cfoutput>">                
						</td>
					</tr>
					<tr>
						<td  align="right" nowrap>
                            <strong><label for="CPDCCFdefault">Default: </label></strong>
                        </td>		
                        <td>					
                            <input type="checkbox" name="CPDCCFdefault" <cfif modo neq 'ALTA' and data.CPDCCFdefault EQ 1> checked </cfif>>
                        </td>
					</tr>
					<tr>
						<td nowrap colspan="2" align="center">
                       		<input type="submit" name="Alta"    class="btnGuardar" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
                            <input type="reset"  name="Limpiar" class="btnLimpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
							<input type="submit" name="Cambio" class="btnGuardar" value="Modificar" onClick="javascript: return Guardar();">
                            <input type="submit" name="Nuevo"  class="btnNuevo"   value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; 
                            if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
                             
                          	<input type="submit" name="Baja" class="btnEliminar" value="Eliminar" onclick="javascript: return Eliminar();this.form.botonSel.value = this.name; 
                            if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
                            
	                        <input type="button" name="btnImportar"  class="btnNormal"   value="Importar"  onClick="javascript:funcImportar();;">	
                      		<input type="button" name="Valida" class="btnNormal" value="Validar" onclick="javascript:funcValidar();">
						</td>
					</tr>
				              
			   </table> 	

			</form>
		<script language="JavaScript1.2" type="text/javascript">				
			objForm2 = new qForm("form2");
			
			objForm2.CPDCCFporc.validatemayor();	
			objForm2.CPDCCFporc.validate = true;

			// Funcion para validar que el porcentaje total no sea mayor a 100
			function porcentajes()
			{				
				var LvarPorcentajeAsig = (parseFloat(document.getElementById("CPDCCFtot").value));
				var LvarPorcentaje = (parseFloat(document.getElementById("CPDCCFporc").value) + LvarPorcentajeAsig);
				if ( LvarPorcentaje > 100 ){	
				  	alert("Solo tienes " + (100 - LvarPorcentajeAsig) + "% para distribuir");	
					document.getElementById("CPDCCFporc").value = '';	
					return false;
				}
				if ( parseFloat(document.getElementById("CPDCCFporc").value) === 0.00 ){	
				  	alert("El porcentaje debe ser mayor a 0");
					document.getElementById("CPDCCFporc").value = '';				
					return false;
				}
			}
						
			//Validaciones de los campos requeridos	
			objForm2.CFcodigo.required = true;
			objForm2.CFcodigo.description="Centro Funcional";
			
			objForm2.CPDCCFporc.required = true;
			objForm2.CPDCCFporc.description="Porcentaje";
			
			function deshabilitarValidacion(){
				objForm2.CFid.required = false;
				objForm2.CPDCCFporc.required = false;
			}
			
			function btnLimpiar(){
				alert("limpiar");
			}
			
			function funcImportar() {
			
				document.form1.action = "../importador/ImportadorDistribucionCostosForm.cfm";
				document.form1.submit();
			}
			
			
			function setBtn(boton) {
			botonActual = boton.name;
			}
			
				
			function funcValidar()
			{				
		
				var LvarPorcentajeAsig = (parseFloat(document.getElementById("CPDCCFtot").value));
				var LvarValidar = document.getElementById("Validar").value;
				if ( LvarPorcentajeAsig < 100 ){	
				  	alert("Solo tiene "  + LvarPorcentajeAsig + "% distribuido de un 100% que debe distribuir");	
					document.getElementById("CPDCCFporc").value = '';	
					return false;
				}
				if ( parseFloat(document.getElementById("CPDCCFporc").value) === 0.00 ){	
				  	alert("El porcentaje debe ser mayor a 0");
					document.getElementById("CPDCCFporc").value = '';				
					return false;
				}
				if ( LvarValidar == 1 ){	
				  	alert("Esta plantilla ya esta Validada como ultima Versión!");		
					return false;	
				}
				var CPDCid = document.form1.CPDCid.value;
				location.href = "TipoCentroFuncionalSql.cfm?CPDCid="+CPDCid;	
			}
		
		function Guardar()
			{				
				var LvarValidar = document.getElementById("Validar").value;
				if ( LvarValidar == 1 ){	
				  	alert("Esta plantilla ya esta Validada como ultima Versión, No se pueden Cambiar los Detalles!");		
					return false;	
				}
				else {
						
					return true;	
						
				}
				
			}
			
					function Eliminar()
			{				
				var LvarValidar = document.getElementById("Validar").value;
				if ( LvarValidar == 1 ){	
				  	alert("Esta plantilla ya esta Verificada como ultima Versión, No se pueden Eliminar los Detalles!");		
					return false;	
				}
				else {
						
					return true;	
						
				}
				
			}
		
		
		</script>

			
	</cfif>
</cfoutput>