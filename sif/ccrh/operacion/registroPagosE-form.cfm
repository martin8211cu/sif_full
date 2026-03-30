	<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Pago Extraordinario">

		<cfif isdefined("form.Did") and len(trim(form.Did))>
			<cfquery name="rsPendientes" datasource="#session.DSN#">
				select 1 
				from DeduccionesEmpleadoPlan 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				and PPpagado=0
			</cfquery>
			<cfif rsPendientes.recordCount lte 0>
				<cflocation url="listaRegistroPagosE.cfm">
			</cfif>
		</cfif>

		<cfif not isdefined("form.btnRecalcular")>
			<cfquery name="dataPlan" datasource="#session.DSN#">
				select 	a.TDid,
						d.TDcodigo,
						d.TDdescripcion,
						a.Dreferencia, 
						a.Ddescripcion, 
						a.SNcodigo,
						e.SNnumero,
						e.SNnombre,
						a.Dmonto, 
						a.Dtasa, 
						a.Dfechaini, 
						a.Dobservacion,
						( select distinct PPtasamora 
						  from DeduccionesEmpleadoPlan b 
						  where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and b.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and b.PPpagado = 0 
							and a.Did = b.Did 
							and a.Ecodigo=b.Ecodigo ) as Dtasamora,
						( select coalesce(count(1),0)
						  from DeduccionesEmpleadoPlan c
						  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							and c.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and c.PPpagado = 0 
							and a.Did = c.Did
							and a.Ecodigo = c.Ecodigo ) as Dnumcuotas
				from DeduccionesEmpleado a
				
				inner join TDeduccion d
				on a.TDid=d.TDid
				   and a.Ecodigo=d.Ecodigo 
			
				left outer join SNegocios e
				on a.SNcodigo=e.SNcodigo
				   and a.Ecodigo=e.SNcodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				  and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			</cfquery>
	
			<cfquery name="dataSaldo" datasource="#session.DSN#">
				select PPfecha_vence, coalesce(PPsaldoant, 0) as PPsaldoactual
				from DeduccionesEmpleadoPlan 
				where Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#"> 
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
				  and PPpagado=0
				  and PPnumero = ( select min(PPnumero) from DeduccionesEmpleadoPlan where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#"> and PPpagado=0)
				order by PPfecha_vence
			</cfquery>
			
			<cfquery name="rsTipoNomina" datasource="#session.DSN#">
				select Tcodigo 
				from LineaTiempo 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
			</cfquery>
			<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
			<cfif rsTipoNomina.recordCount EQ 0>
				<cfquery name="rsTipoNomina" datasource="#session.DSN#">
					select a.Tcodigo 
					from LineaTiempo a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and a.LThasta = (
						select max(x.LThasta)
						from LineaTiempo x
						where x.DEid = a.DEid
						and x.Ecodigo = a.Ecodigo
					)
				</cfquery>
			</cfif>
	
			<cfquery name="rsPeriodicidad" datasource="#session.DSN#">
				select Ttipopago 
				from TiposNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoNomina.Tcodigo)#">
			</cfquery>
			
			<cfquery name="dataMoneda" datasource="#session.DSN#">
				select Mcodigo 
				from Empresas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
	
			<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script> 
			<form name="form1"  method="post" style="margin:0; " onSubmit="javascript: return validar(this);">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Informaci&oacute;n de Deducci&oacute;n</font></strong></td></tr></table></td></tr>
					<tr><td>
						<table width="99%" align="center" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td width="1%" nowrap align="right"><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td>
								<td>#dataPlan.TDcodigo# - #dataPlan.TDdescripcion#</td>
								<td align="right" width="1%" nowrap><strong>Referencia:&nbsp;</strong></td>
								<td>#dataPlan.Dreferencia#</td>
							</tr>
		
							<tr>
								<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
								<td>#dataPlan.Ddescripcion#</td>
								<td align="right"><strong>Socio:&nbsp;</strong></td>
								<td>#dataPlan.SNnumero# - #dataPlan.SNnombre#</td>
							</tr>
		
							<tr>
								<td align="right"><strong>Monto:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dmonto,',9.00')#</td>
								<td align="right"><strong>Saldo actual:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataSaldo.PPsaldoactual,',9.00')#<input type="hidden" name="Dmonto" value="#dataSaldo.PPsaldoactual#"></td>
							</tr>
							
							<tr>
								<td nowrap align="right"><strong>Fecha Inicial:&nbsp;</strong></td>
								<td>#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#<input type="hidden" name="PPfecha_vence" value="#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#"></td>
								<td nowrap align="right"><strong>Cuotas restantes:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dnumcuotas,',9.00')#<input type="hidden" name="Dnumcuotas" value="#dataPlan.Dnumcuotas#"></td>
							</tr>
							
							<tr>
								<td align="right"><strong>Inter&eacute;s:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dtasa,',9.00')#%<input type="hidden" name="Dtasa" value="#dataPlan.Dtasa#"></td>
								<td align="right" nowrap><strong>Inter&eacute;s Moratorio:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dtasamora,',9.00')#%<input type="hidden" name="Dtasamora" value="#dataPlan.Dtasamora#"></td>
							</tr>
						
						</table>
					</td></tr>
					
					<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Registro de Pago Extraordinario</font></strong></td></tr></table></td></tr>
					<tr>
						<td>
							<table width="99%" align="center">
								<tr id="idDoc" style="display:; ">
									<td align="right"><strong>Documento:</strong>&nbsp;</td>
									<td><input type="text" name="EPEdocumento" value="" size="30" maxlength="20"></td>
									<td align="right"><strong>Fecha Documento:</strong>&nbsp;</td>
									<td>
										<cfset Hoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
										<cf_sifcalendario form="form1" name="EPEfechadoc" value="#Hoy#">
									</td>
								</tr>

								<tr>
									<td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
									<td>
										 <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
									</td>
									<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
									<td>
										<input tabindex="1" type="text" name="DPEtc" style="text-align:right"size="18" maxlength="10" 
													onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
													onFocus="javascript:this.select();" 
													onChange="javascript: fm(this,4);"
													value="0.00"> 
									</td>
								</tr>

								<tr>
									<td nowrap align="right"><strong>Monto Efectivo:&nbsp;</strong></td>
									<td valign="top">
										<input name="Dmontopago" tabindex="1" type="text" value="0.00" size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
									</td>
									<td nowrap align="right"><strong>Monto Documentos:&nbsp;</strong></td>
									<td valign="top" >
										<input name="Dmontodoc" tabindex="1" type="text" value="0.00" size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2); mostrar_cuenta(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
									</td>
								</tr>
								<tr>
								  <td nowrap align="right">&nbsp;</td>
								  <td valign="top">&nbsp;</td>
								  <td align="right"><a href="javascript:verPlan();" ><b>Ver Plan de Pagos</b></a></td>
								  <td><a href="javascript:verPlan();" ><img src="../../imagenes/findsmall.gif" border="0" alt="Ver Plan de Pagos"></a></td>
							  </tr>
							</table>
						</td>
					</tr>
	
					<!--- 
					<tr>
						<td valign="top" style="padding-left:10px; "><strong>Observaciones:&nbsp;</strong></td>
						<td colspan="3"><cfif len(trim(dataPlan.Dobservacion))>#dataPlan.Dobservacion#<cfelse>-</cfif></td>
					</tr>
					--->
					
					<tr id="frcuenta" style=" display:none; ">
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
							
								<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Documentos de Pago</font></strong></td></tr></table></td></tr>
								<tr><td>
									<table width="80%" align="center" cellpadding="2" cellspacing="0" >
									<tr>
										<td align="left"><strong>Referencia:&nbsp;</strong></td>
										<td align="left" ><strong>Documento:&nbsp;</strong></td>
										<td align="left" ><strong>Cuenta:&nbsp;</strong></td>
										<td align="left" ><strong>Monto:&nbsp;</strong></td>
									</tr>
									<tr>
										<td><input type="text" name="DPEreferencia" value="" size="20" maxlength="20"></td>
										<td><input type="text" name="DPEdescripcion" value="" size="30" maxlength="80"></td>
										<td><cf_cuentas></td>
										<td><input name="DPEmonto" tabindex="1" type="text" value="0.00" size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
										<td style="padding-left:10px; "><input type="button" name="Agregar" value="Agregar" onClick="javascript: fnNuevoTR();"></td>
									</tr>
			
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="7" align="center">
											<table id="tbldynamic" border="0" width="80%" cellpadding="0" cellspacing="0" align="center">
												<tr class="tituloListas">
													<td></td>
													<td><strong>Referencia</strong></td>
													<td></td>
													<td><strong>Documento</strong></td>
													<td></td>
													<td></td>
													<td><strong>Cuenta</strong></td>
													<td></td>
													<td align="right"><strong>Monto</strong></td>
													<td>&nbsp;</td>
												</tr>
												<!--- agrega inputs dinamicos --->
												<cfinclude template="registroPagosE-cuentas.cfm">
											</table>
										</td>
									</tr>
			
									</table>
								</td></tr>
							</table> 
						</td>
					</tr>

					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
						<input type="submit" value="<< Regresar" name="btnRegresar2" onclick="document.form1.action='listaRegistroPagosE.cfm';">
						<input type="submit" value="Aceptar" name="btnRecalcular" onClick="javascript: return aceptar_plan()">
					</td></tr>
					<tr><td align="center">&nbsp;</td></tr>
				</table>
	
				<!--- empleado y deduccion actuales --->
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="Did" value="#form.Did#">
				<input type="hidden" name="TDid" value="#form.TDid#">
				<input type="hidden" name="Dperiodicidad" value="#rsPeriodicidad.Ttipopago#">
				<input type="hidden" name="Dtraercuentas" value="0"> <!--- 0 No usa cuentas, 1 Usa cuentas --->

				<!--- para tablas dinamicas--->
				<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
				<input type="image" id="imgDel" src="../../imagenes/Borrar01_S.gif" title="Eliminar cuenta." style="display:none;">
				<input type="hidden" name="Dcantidad" value="0">
				<input type="hidden" name="SNcodigo" value="#dataPlan.SNcodigo#">
			</form>
			
			<script type="text/javascript" language="javascript1.2">
				function aceptar_plan(){
					if ( confirm('Desea registrar el Pago?') ) {
						document.form1.Dcantidad.value = index;
						document.form1.action = 'registroPagosE-sql.cfm';
						return true;
					}
					return false;
				}
				
				function validar(f){
					var error   = false;
					var suma = 0;
					var mensaje = 'Se presentaron los siguientes errores:\n';
					
					if ( trim(f.EPEdocumento.value) == '' ){
						error   = true;
						mensaje = mensaje + ' - El campo Documento es requerido.\n';
					}

					if ( trim(f.EPEfechadoc.value) == '' ){
						error   = true;
						mensaje = mensaje + ' - El campo Fecha Documento es requerido.\n';
					}

					if ( trim(f.Mcodigo.value) == '' ){
						error = true;
						mensaje = mensaje + ' - El campo Moneda es requerido.';
					}

					if ( trim(f.DPEtc.value) == '' ){
						error = true;
						mensaje = mensaje + ' - El campo Tipo de Cambio es requerido.';
					}

					if ( trim(f.Dmontopago.value) == '' ){
						error = true;
						mensaje = mensaje + ' - El campo Monto Efectivo es requerido.';
					}

					if ( trim(f.Dmontodoc.value) == '' ){
						error = true;
						mensaje = mensaje + ' - El campo Monto Documentos es requerido.';
					}

					if ( (parseInt(qf(f.Dmontopago.value)) + parseInt(qf(f.Dmontodoc.value))) == 0 ){
						error = true;
						mensaje = mensaje + ' - El monto efectivo y el monto en documentos son iguales a cero, al menos uno de ellos debe ser diferente a cero.';
					}
					else
					{
						if ( (parseInt(qf(f.Dmontopago.value)) + parseInt(qf(f.Dmontodoc.value))) > #dataSaldo.PPsaldoactual#)
						{
							error   = true;
							mensaje = mensaje + ' - La suma del Monto Efectivo y del Monto Documentos debe ser menor o igual al Saldo actual.\n';
						}
					}

					if ( index == 0 && parseFloat(qf(f.Dmontodoc.value)) > 0 ){
						error   = true;
						mensaje = mensaje + ' - Al menos un Documento de Pago es requerido.\n';
					}
					
					if ( error ){
						alert(mensaje);
						return false;
					}
					
					f.Dcantidad.value = index; 
					f.DPEtc.disabled = false;
					return true;
				}
				
				// TAG DE MONEDAS - INI
				function asignaTC() {	
					if (document.form1.Mcodigo.value == "<cfoutput>#dataMoneda.Mcodigo#</cfoutput>") {		
						formatCurrency(document.form1.TC,2);
						document.form1.DPEtc.disabled = true;			
					}
					else{
						document.form1.DPEtc.disabled = false;
					}	
					var estado = document.form1.DPEtc.disabled;
					document.form1.DPEtc.disabled = false;
					document.form1.DPEtc.value = fm(document.form1.TC.value,2);
					document.form1.DPEtc.disabled = estado;
				}
				asignaTC();
				// TAG MONEDAS - FIN
				
				function mostrar_cuenta(obj){
					if ( parseFloat(qf(obj.value)) > 0 ){
						//document.getElementById("idDoc").style.display = '';
						document.getElementById("frcuenta").style.display = '';
						document.form1.Dtraercuentas.value = 1;
					}
					else{
						//document.getElementById("idDoc").style.display = 'none';
						document.getElementById("frcuenta").style.display = 'none';
						document.form1.Dtraercuentas.value = 0;
					}
				}
				
				function verPlan(){
					window.open('verPlanPagos.cfm?Did=#form.Did#', 'PlanPagos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=650,height=400,left=250, top=100,screenX=250,screenY=100');
				}
				
			</script> 
			
		</cfif>
	<cf_web_portlet_end>
	</cfoutput>