<!---<cfif isdefined('Form.periodo')>
    <cfset UltimoPeriodo = #Form.periodo#>
<cfelse>
    <cfquery name="rsParam1" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 30
    </cfquery>
    <cfset UltimoPeriodo = rsParam1.Pvalor>
</cfif>--->

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
   <!--- select distinct Speriodo
    from CGPeriodosProcesados
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    order by Speriodo desc--->
    select RHAAPeriodo
	from RHAjusteAnual
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	<!---and RHAAEstatus = 1--->
    order by RHAAPeriodo
</cfquery> 

<cfquery name="rsConcPago" datasource="#session.dsn#">
	select * 
    from CIncidentes
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    order by CIdescripcion
</cfquery>

<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="DeclaracionInformativa_SQL.cfm" style="margin: 0">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
    	<tr>
        	<td rowspan="3" width="45%">
            	<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
					<div align="justify">
						<p>
							<cf_translate  key="LB_Reporte">
								Archivo generado para importar información relacionada con Ajuste Anual y Constancia de Sueldos,Salarios.
							</cf_translate>
						</p>
					</div>
				<cf_web_portlet_end>
            </td>
        	<td width="10%" align="right">
            	<strong>Per&iacute;odo:</strong>
            </td>
            <td width="45%">
            	<select name="periodo">
              		<option value="-1">---Selecciona Periodo---</option>
                		<cfloop query = "rsPeriodos">
              		<option value="#rsPeriodos.RHAAPeriodo#" <!---<cfif #UltimoPeriodo# EQ "#rsPeriodos.RHAAPeriodo#">selected</cfif>--->>#rsPeriodos.RHAAPeriodo# </option>
                		</cfloop>
              	</select>
            </td>
        </tr>
        <tr>
        	<td width="10%" align="right">
            	<strong>Empleado:</strong>
            </td>
        	<td width="45%">
            	<cf_rhempleado tabindex="1">&nbsp;
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="center">
            	<input type="submit" name="GenerarTxt" value="Generar archivo">
            	<input type="submit" name="GenerarPdf" value="Generar PDF">
            </td>
        </tr>
       <tr height="25px">
        	<td colspan = "3" align="left"> 
            	
            </td>
        </tr> 
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>PARAMETRIZACI&Oacute;N DE CONCEPTOS PARA DECLARACIONES INFORMATIVAS DE AJUSTE ANUAL &nbsp; &nbsp;</strong>
            </td>
        </tr> 
        <tr height="25px">
        	<td colspan = "3" align="left"> 
            	
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Sueldos, salarios, rayas y jornales &nbsp; &nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto1">	
                        		<select name="Concepto" id="concepto">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto.options[Concepto.selectedIndex].value,Concepto.options[Concepto.selectedIndex].text,'Campo58','tblConcepto')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	<hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Gratificación anual &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto2" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto2">	
                        		<select name="Concepto2" id="concepto2">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas2">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto2.options[Concepto2.selectedIndex].value,Concepto2.options[Concepto2.selectedIndex].text,'Campo60','tblConcepto2')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	<hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Viáticos y gastos de viaje &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto3" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto3">	
                        		<select name="Concepto3" id="concepto3">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas3">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto3.options[Concepto3.selectedIndex].value,Concepto3.options[Concepto3.selectedIndex].text,'Campo62','tblConcepto3')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Tiempo extraordinario &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto4" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto4">	
                        		<select name="Concepto4" id="concepto4">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas4">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto4.options[Concepto4.selectedIndex].value,Concepto4.options[Concepto4.selectedIndex].text,'Campo64','tblConcepto4')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	<hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Prima vacacional &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto5" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto5">	
                        		<select name="Concepto5" id="concepto5">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas5">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto5.options[Concepto5.selectedIndex].value,Concepto5.options[Concepto5.selectedIndex].text,'Campo66','tblConcepto5')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Prima dominical &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto6" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto6">	
                        		<select name="Concepto6" id="concepto6">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas6">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto6.options[Concepto6.selectedIndex].value,Concepto6.options[Concepto6.selectedIndex].text,'Campo68','tblConcepto6')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Participación de los trabajadores en las utilidades (PTU) &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto7" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto7">	
                        		<select name="Concepto7" id="concepto7">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas7">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto7.options[Concepto7.selectedIndex].value,Concepto7.options[Concepto7.selectedIndex].text,'Campo70','tblConcepto7')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Reembolso de gastos médicos, dentales y hospitalarios &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto8" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto8">	
                        		<select name="Concepto8" id="concepto8">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas8">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto8.options[Concepto8.selectedIndex].value,Concepto8.options[Concepto8.selectedIndex].text,'Campo72','tblConcepto8')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
         <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Fondo de ahorro &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto9" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto9">	
                        		<select name="Concepto9" id="concepto9">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas9">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto9.options[Concepto9.selectedIndex].value,Concepto9.options[Concepto9.selectedIndex].text,'Campo74','tblConcepto9')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
         <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Caja de ahorro &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto10" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto10">	
                        		<select name="Concepto10" id="concepto10">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas10">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto10.options[Concepto10.selectedIndex].value,Concepto10.options[Concepto10.selectedIndex].text,'Campo76','tblConcepto10')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Vales para despensa &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto11" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto11">	
                        		<select name="Concepto11" id="concepto11">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas11">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto11.options[Concepto11.selectedIndex].value,Concepto11.options[Concepto11.selectedIndex].text,'Campo78','tblConcepto11')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Ayuda para gastos de funeral &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto12" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto12">	
                        		<select name="Concepto12" id="concepto12">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas12">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto12.options[Concepto12.selectedIndex].value,Concepto12.options[Concepto12.selectedIndex].text,'Campo80','tblConcepto12')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Contribuciones a cargo del trabajador pagadas por el patrón &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto13" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto13">	
                        		<select name="Concepto13" id="concepto13">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas13">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto13.options[Concepto13.selectedIndex].value,Concepto13.options[Concepto13.selectedIndex].text,'Campo82','tblConcepto13')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Premios por puntualidad &nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto14" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto14">	
                        		<select name="Concepto14" id="concepto14">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas14">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto14.options[Concepto14.selectedIndex].value,Concepto14.options[Concepto14.selectedIndex].text,'Campo84','tblConcepto14')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Prima de seguro de vida&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto15" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto15">	
                        		<select name="Concepto15" id="concepto15">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas15">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto15.options[Concepto15.selectedIndex].value,Concepto15.options[Concepto15.selectedIndex].text,'Campo86','tblConcepto15')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3"align="left"> 
            	<strong>Seguro de gastos médicos mayores&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto16" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto16">	
                        		<select name="Concepto16" id="concepto16">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas16">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto16.options[Concepto16.selectedIndex].value,Concepto16.options[Concepto16.selectedIndex].text,'Campo88','tblConcepto16')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Vales para restaurante&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto17" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto17">	
                        		<select name="Concepto17" id="concepto17">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas17">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto17.options[Concepto17.selectedIndex].value,Concepto17.options[Concepto17.selectedIndex].text,'Campo90','tblConcepto17')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Vales para gasolina&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto18" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto18">	
                        		<select name="Concepto18" id="concepto18">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas18">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto18.options[Concepto18.selectedIndex].value,Concepto18.options[Concepto18.selectedIndex].text,'Campo92','tblConcepto18')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Vales para ropa&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto19" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto19">	
                        		<select name="Concepto19" id="concepto19">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas19">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto19.options[Concepto19.selectedIndex].value,Concepto19.options[Concepto19.selectedIndex].text,'Campo94','tblConcepto19')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
         <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Ayuda para renta&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto20" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto20">	
                        		<select name="Concepto20" id="concepto20">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas20">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto20.options[Concepto20.selectedIndex].value,Concepto20.options[Concepto20.selectedIndex].text,'Campo96','tblConcepto20')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Ayuda para artículos escolares&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto21" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto21">	
                        		<select name="Concepto21" id="concepto21">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas21">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto21.options[Concepto21.selectedIndex].value,Concepto21.options[Concepto21.selectedIndex].text,'Campo98','tblConcepto21')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3"align="left"> 
            	<strong>Dotación o ayuda para anteojos&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto22" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto22">	
                        		<select name="Concepto22" id="concepto22">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas21">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto22.options[Concepto22.selectedIndex].value,Concepto22.options[Concepto22.selectedIndex].text,'Campo100','tblConcepto22')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Ayuda para transporte&nbsp;&nbsp;</strong>
            </td>
            <td width="0%">
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto23" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto23">	
                        		<select name="Concepto23" id="concepto23">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas23">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto23.options[Concepto23.selectedIndex].value,Concepto23.options[Concepto23.selectedIndex].text,'Campo102','tblConcepto23')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr> 
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Cuotas sindicales pagadas por el patrón&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto24" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto24">	
                        		<select name="Concepto24" id="concepto24">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas24">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto24.options[Concepto24.selectedIndex].value,Concepto24.options[Concepto24.selectedIndex].text,'Campo104','tblConcepto24')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Subsidios por incapacidad&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto25" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto25">	
                        		<select name="Concepto25" id="concepto25">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas25">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto25.options[Concepto25.selectedIndex].value,Concepto25.options[Concepto25.selectedIndex].text,'Campo106','tblConcepto25')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Becas para trabajadores y/o sus hijos&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto26" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto26">	
                        		<select name="Concepto26" id="concepto26">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas26">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto26.options[Concepto26.selectedIndex].value,Concepto26.options[Concepto26.selectedIndex].text,'Campo108','tblConcepto26')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>                        
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Pagos efectuados por otros empleadores (sólo si el patrón que declara realizó cálculo anual)&nbsp;&nbsp;</strong>
            </td>
            <td width="0%">
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto27" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto27">	
                        		<select name="Concepto27" id="concepto27">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas27">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto27.options[Concepto27.selectedIndex].value,Concepto27.options[Concepto27.selectedIndex].text,'Campo110','tblConcepto27')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr align="center">
        	<td colspan = "3">
            	 <hr width="50%" color="#000066#" />
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="left"> 
            	<strong>Otros ingresos por salarios&nbsp;&nbsp;</strong>
            </td>
        </tr> 
        <tr align="center">
			<td align="center" colspan = "3">
            	<table id="tblConcepto28" border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td>
							<span id="contenedor_Concepto28">	
                        		<select name="Concepto28" id="concepto28">
                            		<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
										<cfloop query="rsConcPago">
											<option value="<cfoutput>#rsConcPago.CIid#</cfoutput>"> #CIcodigo# - #CIdescripcion# </option>	
										</cfloop>
								</select>	
                             </span> 
                       	</td>		
						<td  nowrap="nowrap">
							<div style="display:none ;" id="verCargas28">
						    	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
							</div>
						</td>
						<td>	
							<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar(Concepto27.options[Concepto28.selectedIndex].value,Concepto28.options[Concepto28.selectedIndex].text,'Campo112','tblConcepto28')" value="+" >
						</td>
					</tr>
				</table>
            </td>
        </tr>         
  	</table>
</form>              
</cfoutput>	

<script language="JavaScript">

var vnContadorListas = 0;
	var GvarNewTD;

	//Función para agregar TRs
	function fnNuevoCar(idConcepto,nombreConcepto,numCampo,tblConcepto)
	{
	 <!--- objSelect = document.createElement('Select');
	  objSelect.id = Concepto;
	  
	  objSelect.name = Concepto;--->
	 <!--- var IndexSelect= document.form1.Concepto.selectedIndex ;--->
	  var RHTidSelec = idConcepto; <!---document.form1.Concepto.options[IndexSelect].value;--->	
	  var RHTdescSelec = nombreConcepto;<!--- document.form1.Concepto.options[IndexSelect].text;--->
		<!---alert(tblConcepto);
	  	alert(RHTdescSelec);--->
			 	
	  if (RHTidSelec != '' && RHTdescSelec != ''){ 
	 		vnContadorListas = vnContadorListas + 1; 	
	  }
	  
	  var LvarTable = document.getElementById(tblConcepto);
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= RHTidSelec;//id
	  var p2 		= RHTdescSelec;//desc

	 
	  RHTidSelec = "";
	  RHTdescSelec = "";

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCar(p1,tblConcepto)) {alert('El código seleccionado es repetido.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", numCampo);

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  
	   // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon"; 
	}
		  
	function existeCodigoCar(v,tblConcepto){
		var LvarTable = document.getElementById(tblConcepto);
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}
	
		function existeCodigoDed(v){
		var LvarTable = document.getElementById("tblDed");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));	
			var data = value.split('|');
			<!---alert(data);--->
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}
	
	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}
	
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
</script>

