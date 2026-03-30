<cfsetting requestTimeOut="8600">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

<cfif isdefined("form.Consultar")>
	<cfparam name="formato" default="Flashpaper">
	<cfparam name="CPid" default="">
	<cfparam name="CFidI" default="">
	<cfparam name="nomail" default="0">									
	<cfset vs_filtro = ''>
	<cfif isdefined("form.ordenamiento") and form.ordenamiento EQ 1>
		<cfset vs_filtro = 'order by d.CFcodigo,e.DEnombre,e.DEapellido1'>
	<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 2>		
		<cfset vs_filtro = 'order by d.CFcodigo,e.DEapellido1,e.DEnombre'>
	<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 3>
		<cfset vs_filtro = 'order by e.DEapellido1,e.DEnombre'>
	<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 4>
		<cfset vs_filtro = 'order by e.DEnombre,e.DEapellido1'>
	<cfelse>
		<cfset vs_filtro = 'order by d.CFcodigo,e.DEnombre,e.DEapellido1'>
	</cfif>
	<cfif isdefined("CFidI") and len(trim(CFidI))>
		<cfquery name="CFuncional" datasource="#session.DSN#">
			select CFpath from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidI#">
		</cfquery>
	</cfif>
	<cfquery name="rsEmpleadosNomina" datasource="#Session.DSN#">		
		select 	distinct a.DEid		
				,<cf_dbfunction name="concat" args="e.DEnombre,' ',e.DEapellido1,' ',e.DEapellido2"> as Empleado
				,e.	DEidentificacion
				,a.DEid as Chequeado
				,d.CFcodigo
				,e.DEnombre,DEapellido1
		from SalarioEmpleado a
			inner join RCalculoNomina rc
				on a.RCNid = rc.RCNid
			inner join  LineaTiempo b
				on (rc.RCdesde between LTdesde and LThasta or rc.RChasta between LTdesde and LThasta)
				and a.DEid = b.DEid
			inner join RHPlazas c 
				on b.RHPid = c.RHPid
				and b.Ecodigo = c.Ecodigo
			inner join CFuncional d
				on c.CFid = d.CFid
				<cfif isdefined("CFcodigoI") and len(trim(CFcodigoI)) and isdefined("form.dependencias") and len(trim(form.dependencias))>
					and (d.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFuncional.CFpath#/%">
							or d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidI#">
						)
				<cfelseif isdefined("CFidI") and len(trim(CFidI)) and not isdefined("form.dependencias")>
					and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidI#">
				</cfif>												
			inner join DatosEmpleado e
				on a.DEid = e.DEid
				<cfif isdefined("nomail") and nomail EQ 1><!----Solo los empleados que no tienen EMAIL---->
					and ltrim(rtrim(e.DEemail)) is null
				</cfif>
		where a.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">	
			<!--- and a.PEdesde = (select max(PEdesde)
							from PagosEmpleado t
							where a.RCNid = t.RCNid 
								and PEtiporeg = 0
								and DEid=a.DEid)  ---->
		
		<cfif len(trim(vs_filtro))>
			#PreserveSingleQuotes(vs_filtro)#      		
		</cfif>
	</cfquery>
</cfif>	

<cfquery name="rsFormato" datasource="#session.DSN#">
	select coalesce(Pvalor,'10') as formato
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 720
</cfquery>

	
	<cfparam name="ordenamiento" default="1">

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ImpresionDeBoletasDePago"
						Default="Impresión de Boletas de Pago"
						returnvariable="LB_ImpresionDeBoletasDePago"/>
                	
					<cf_web_portlet_start titulo="#LB_ImpresionDeBoletasDePago#" >
						<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
						<form style="margin:0 " name="filtro" method="post" action="" onSubmit="return validar();" ><!----ImpBoletasPago-formA.cfm---->
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td align="right" width="25%" nowrap><strong><cf_translate  key="LB_CalendarioDePago">Calendario de Pago</cf_translate>:&nbsp;</strong></td>
									<td>
										<cfif isdefined("form.CPid") and len(trim(form.CPid))>
											<cfquery name="rsCalendario" datasource="#session.DSN#">
												select a.CPid, a.CPcodigo,a.CPdescripcion, b.Tcodigo, b.Tdescripcion
												from CalendarioPagos a
													inner join TiposNomina b
														on a.Tcodigo = b.Tcodigo
														and a.Ecodigo =  b.Ecodigo
												where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
													and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											</cfquery>
											<cf_rhcalendariopagos form="filtro" historicos="false" tcodigo="true" query="#rsCalendario#">
										<cfelse>
											<cf_rhcalendariopagos form="filtro" historicos="false" tcodigo="true">
										</cfif> 									
									</td>
								</tr>								
								<tr>
									<td align="right"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>										
									<td>
										<table>
											<tr>
												<td>
													<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
														<cfquery name="rsCFuncional" datasource="#session.DSN#">
															select CFid as CFidI,CFcodigo as CFcodigoI, CFdescripcion as CFdescripcionI
															from CFuncional
															where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
														</cfquery>
														<cf_rhcfuncional form="filtro" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" codigosize='15' size='60' query="#rsCFuncional#">
													<cfelse>	
														<cf_rhcfuncional form="filtro" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" codigosize='15' size='60' >
													</cfif> 	
												</td>
												<td>&nbsp;</td>
												<td>
													<input type="checkbox" name="dependencias" value="dependencias" <cfif isdefined("form.dependencias")>checked</cfif>>
													<label for="dependencias"><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label>
												</td>
											</tr>
										</table>
									</td>
								</tr>																					
								<tr>
									<td align="right"><strong><cf_translate  key="LB_OrdenadoPor">Ordenado Por</cf_translate>:&nbsp;</strong></td>
									<td>
										<cfoutput>										
											<table width="100%" cellpadding="0" cellspacing="0" border="0">
												<tr>
													<td width="50%">
														<!----type="checkbox"--->
														<input name="ordenamiento" id="ctrofuncionalNA" type="radio"  value="1" <cfif ordenamiento EQ 1>checked</cfif>
															 <cfif isdefined("form.ctrofuncional")>checked</cfif>
															onClick="javascript: if (this.checked == false){
																					document.filtro.ctrofuncionalNA.checked=true;
																				}else{
																					document.filtro.nombreapellido.checked=false;
																					document.filtro.apellidonombre.checked=false;}">
														<label for="ctrofuncionalNA"><cf_translate key="LB_CentroFuncionalNombreApellido">Centro Funcional, Nombre, Apellido</cf_translate></label>
													</td>
													<td width="50%">
														<input name="ordenamiento" id="ctrofuncionalAN" type="radio" value="2" <cfif ordenamiento EQ 2>checked</cfif>
															 <cfif isdefined("form.ctrofuncional")>checked</cfif>
															onClick="javascript: if (this.checked == false){
																					document.filtro.ctrofuncionalAN.checked=true;
																				}else{
																					document.filtro.nombreapellido.checked=false;
																					document.filtro.apellidonombre.checked=false;
																					document.filtro.nombreapellido.checked=false;}">
														<label for="ctrofuncionalAN"><cf_translate key="LB_CentroFuncionalApellidoNombre">Centro Funcional, Apellido, Nombre</cf_translate></label>
													</td>
												</tr>
												<tr>
													<td width="50%">
														<input name="ordenamiento" id="apellidonombre" type="radio" value="3"  <cfif ordenamiento EQ 3>checked</cfif>
															<cfif isdefined("form.apellidonombre")>checked</cfif>
															onClick="javascript: if (this.checked == false){
																					document.filtro.apellidonombre.checked=true;
																				}else{
																					document.filtro.ctrofuncionalNA.checked=false;
																					document.filtro.ctrofuncionalAN.checked=false;
																					document.filtro.nombreapellido.checked=false;
																					}">
														<label for="apellidonombre"><cf_translate  key="LB_ApellidoNombre">Apellido, Nombre</cf_translate></label>
													</td>
													<td width="50%">
														<input name="ordenamiento" id="nombreapellido" type="radio" value="4"  <cfif ordenamiento EQ 4>checked</cfif>
															<cfif isdefined("form.nombreapellido")>checked</cfif>
															onClick="javascript: if (this.checked == false){
																					document.filtro.nombreapellido.checked=false;
																				}else{
																					document.filtro.ctrofuncionalAN.checked=false;
																					document.filtro.apellidonombre.checked=false;}">
														<label for="nombreapellido"><cf_translate  key="LB_NombreApellido">Nombre, Apellido</cf_translate></label>
													</td>
												</tr>
											</table>
										</cfoutput>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<input id="nomail" type="checkbox" name="nomail" value="1" <cfif isdefined("form.nomail")>checked</cfif>>
										<label for="nomail"><cf_translate  key="LB_ImprimirBoletasAColaboradoresSinCorreoElectronicoDefinido">Imprimir boletas a colaboradores sin correo el&eacute;ctronico definido</cf_translate></label>										
									</td>	
								</tr>
								<tr>
									<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
									<td>
										<cfif isdefined("rsFormato") and rsFormato.formato EQ '20'><!---Formato 1/3 CEFA---->
											<select name="formato" tabindex="1">
												<option value="pdf" <cfif isdefined('formato') and formato EQ 'pdf'>selected</cfif>>Adobe PDF</option>
												<!---<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>---->
											</select>
										<cfelseif isdefined("rsFormato") and rsFormato.formato EQ '30'><!---Formato 1/2 Coopelesca--->
											<input type="text" name="formato" value="Html" class="cajasinborde"/>
										<cfelse>
											<input type="text" name="formato" value="Html" class="cajasinborde"/>
										</cfif>
									</td>
								</tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td colspan="2" align="center">
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Consultar"
										Default="Consultar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Consultar"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>
										<cfoutput>
										<input type="submit" name="Consultar" value="#BTN_Consultar#">
										<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
										</cfoutput>
										
										<cfif isdefined("rsEmpleadosNomina") and rsEmpleadosNomina.RecordCount NEQ 0>
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Impimir"
											Default="Impimir"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Impimir"/>												
											<cfoutput>
											<input type="button" name="Imprimir" value="#BTN_Impimir#" onClick="javascript: funcImprimir();">
											</cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>		
								<cfif isdefined("form.Consultar") and isdefined("rsEmpleadosNomina")>								
									<tr>
										<td colspan="2">
											<input id="chkAllItems" type="checkbox" name="chkAllItems" value="1" onClick="javascript: funcChkAll(this);" style="border:none;" checked>
											<label for="chkAllItems">Chequear/Deschequear todos</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" align="center">											
											<div style="width:900;height=350;overflow:auto;vertical-align:text-top;">
												<cfinvoke 
													component="rh.Componentes.pListas"
													method="pListaQuery"
													returnvariable="pListaRet">
													<cfinvokeargument name="query" value="#rsEmpleadosNomina#"/>
													<cfinvokeargument name="desplegar" value="DEidentificacion, Empleado"/>
													<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre"/>
													<cfinvokeargument name="formatos" value="V,V"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<!---<cfinvokeargument name="irA" value="ImpBoletasPago-formA.cfm"/> ---->
													<cfinvokeargument name="showEmptyListMsg" value="true"/>
													<cfinvokeargument name="maxrows" value="#rsEmpleadosNomina.RecordCount#"/>
													<!---<cfinvokeargument name="maxrows" value="18"/>--->
													<cfinvokeargument name="checkboxes" value="S"/>		
													<cfinvokeargument name="keys" value="DEid"/>	
													<cfinvokeargument name="checkedcol" value="Chequeado"/>
													<cfinvokeargument name="checkbox_function" value="UpdChkAll(this)"/>
													<cfinvokeargument name="showLink" value="false"/>
												</cfinvoke>											
											</div>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<cfif isdefined("rsEmpleadosNomina") and rsEmpleadosNomina.RecordCount NEQ 0>
										<tr>
											<td colspan="2" align="center">
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Impimir"
													Default="Impimir"
													XmlFile="/rh/generales.xml"
													returnvariable="BTN_Impimir"/>												
												<cfoutput>
												<input type="button" name="Imprimir" value="#BTN_Impimir#" onClick="javascript: funcImprimir();">
												</cfoutput>
											</td>		
										</tr>							
									</cfif>		
								</cfif>						
							</table>
						</form>
						
						<script type="text/javascript" language="javascript1.2">
							function validar(){
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_SePpresentaronLosSiguientesErrores"
								Default="Se presentaron los siguientes errores"
								returnvariable="MSG_SePpresentaronLosSiguientesErrores"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ElCampoCalendarioDePagoEsRequerido"
								Default="El Campo Calendario de Pago es requerido"
								returnvariable="MSG_ElCampoCalendarioDePagoEsRequerido"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ElCampoCentroFuncional"
								Default="El Campo Centro Funcional es requerido"
								returnvariable="MSG_ElCampoCentroFuncional"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_DebeSeleccionarAlMenosUnEmpleado"
								Default="Debe seleccionar al menos un empleado"
								returnvariable="MSG_DebeSeleccionarAlMenosUnEmpleado"/>
								
								<cfoutput>
								var error = false;
								var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';

								//Calendario de pagos obligatorio
								if ( document.filtro.CPid.value == ''){
									error = true;
									mensaje  = mensaje + '#MSG_ElCampoCalendarioDePagoEsRequerido#\n';									
								}
								//Un centro funcional obligatorio
								if (document.filtro.CFidI.value == '' ){//&& document.filtro.CFidF.value == ''
									error = true;
									mensaje  = mensaje + '#MSG_ElCampoCentroFuncional#\n';
								}
								if (error){
									alert(mensaje);
									return false;								
								}
								</cfoutput>
								return true;
							}

							function funcImprimir(){								
								<cfoutput>
								var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';
								var error = false;
								var sincheck = 0;
								if(validar()){
									//Validar almenos uno chequeado
									var continuar = false;
									if (document.filtro.chk) {
										if (document.filtro.chk.value) {
											if (!document.filtro.chk.disabled){continuar = document.filtro.chk.checked;}
										} else {
											for (var k = 0; k < document.filtro.chk.length; k++) {
												if (document.filtro.chk[k].value) {
													if (!document.filtro.chk[k].disabled && document.filtro.chk[k].checked){ continuar = true;}
												} else {
													for (var counter = 0; counter < document.filtro.chk[k].length; counter++) {
														if (!document.filtro.chk[counter].disabled && document.filtro.chk[counter].checked) { continuar = true; break; }
													}
												}
											}
										}
										if (!continuar) {
											mensaje  = mensaje + '#MSG_DebeSeleccionarAlMenosUnEmpleado#\n';
											alert(mensaje);
										}
										else{
											document.filtro.action = 'ImpBoletasPago-formA.cfm'; 
											document.filtro.submit();	
										}
									} 														
									</cfoutput>
								}								
							}
							//CHEQUEAR
							function funcChkAll(c) {
								if (document.filtro.chk) {
									if (document.filtro.chk.value) {
										if (!document.filtro.chk.disabled) { 
											document.filtro.chk.checked = c.checked;
											//funcChkSolicitud(document.filtro.chk);
										}
									} else {
										for (var counter = 0; counter < document.filtro.chk.length; counter++) {
											if (!document.filtro.chk[counter].disabled) {
												document.filtro.chk[counter].checked = c.checked;
												//funcChkSolicitud(document.form1.ESidsolicitud[counter]);
											}
										}
									}
								}
							}
							//Deschequear
							function UpdChkAll(c) {												
								var allChecked = true;
								if (!c.checked) {
									allChecked = false;
								} else {
									if (document.filtro.chk.value) {
										if (!document.filtro.chk.disabled) allChecked = true;
									} else {
										for (var counter = 0; counter < document.filtro.chk.length; counter++) {
											if (!document.filtro.chk[counter].disabled && !document.filtro.chk[counter].checked) {allChecked=false; break;}
										}
									}
								}
								document.filtro.chkAllItems.checked = allChecked;								
								//alert(c.value)
							}
						</script>
	         		<cf_web_portlet_end>
				</td>	
			</tr>
		</table>			
	<cf_templatefooter>