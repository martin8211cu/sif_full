<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Aplicar"
	default="Aplicar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Recalcular"
	default="Recalcular"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Recalcular"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_LiquidacionDividendos"
	default="Liquidaci&oacute;n de Dividendos"
	returnvariable="LB_LiquidacionDividendos"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	default="Distribuci&oacute;n de Excedentes Solidaristas"
	vsgrupo="103"
	returnvariable="nombre_proceso"/>
<!---===========================================---->	

<!--- query para determinar si ya se realizo el calculo --->
<cfquery name="rs_datos" datasource="#session.DSN#">
	select a.ACDDEperiodo as periodo, a.ACDDEmonto as monto, a.ACDDEestado as estado
	from ACDistribucionDividendosE a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
</cfquery>

<cfset filtro = ''>
<cfif isdefined("url.filtrar") and isdefined('url.f_identificacion') and len(trim(url.f_identificacion))>
	<cfset filtro = filtro & " and de.DEidentificacion like '%#trim(url.f_identificacion)#%'" >
</cfif>
<cfif isdefined("url.filtrar") and isdefined('url.f_nombre') and len(trim(url.f_nombre))>
	<cfset filtro = filtro & " and ( upper(de.DEnombre) like '%#trim(ucase(url.f_nombre))#%' or upper(de.DEapellido1) like '%#trim(ucase(url.f_nombre))#%' or upper(de.DEapellido2) like '%#trim(ucase(url.f_nombre))#%' )" >
</cfif>

<cfquery name="rs_total" datasource="#session.DSN#">
	select count(1) as total
	from ACDistribucionDividendosE a, ACDistribucionDividendos b, ACAsociados c, DatosEmpleado de
	where a.Ecodigo = #session.Ecodigo#
	  and a.ACDDEperiodo = #url.periodo#
	  and b.Ecodigo = a.Ecodigo
	  and b.ACDDEperiodo = a.ACDDEperiodo
	  and c.ACAid=b.ACAid
	  and de.DEid=c.DEid
	  #preservesinglequotes(filtro)#
	  order by de.DEidentificacion
</cfquery>  

<script src="/cfmx/rh/js/utilesMonto.js"></script>	
<cf_templateheader title="Recursos Humanos">
	<cfoutput>
	<cf_web_portlet_start titulo="#nombre_proceso#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
						<tr>
							<td align="center">
								<table width="95%" align="center" border="0" cellpadding="2" cellspacing="0" >
									<form name="form1" method="url" action="liquidaDividendoSocios-sql.cfm" onsubmit="javascript: return validar();">
									<tr><td colspan="2" nowrap="nowrap"><strong>Proceso de Distribuci&oacute;n de Excedentes Solidaristas</strong></td></tr>
									<tr>
										<td nowrap="nowrap" width="10%" ><strong>Per&iacute;odo:</strong></td>
										<td> #rs_datos.periodo#</td>
									</tr>
									<tr>
										<td nowrap="nowrap" ><strong>Monto distribuido:</strong></td>
										<td>
											<cfif rs_datos.estado neq 2>
												<input type="text" size="18" name="monto" tabindex="1" value="#LSNumberFormat(rs_datos.monto, ',9.00')#" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"> <label>* puede modificar el monto y recalcular los datos</label>
											<cfelse>
												#LSNumberFormat(rs_datos.monto, ',9.00')#
											</cfif>											
										</td>	
									</tr>
									
									<tr><td>&nbsp;</td></tr>
									<cfif rs_datos.estado neq 2>
										<cfif rs_total.total gt 30>
											<tr>
												<td colspan="2" align="center" >
													<input type="submit" class="btnGuardar" tabindex="1" name="liquidar" value="#BTN_Recalcular#" onclick="javascript: return confirm('Va a recalular la informacion del proceso de distribucion de excedentes para el periodo indicado.\n Desea continuar?');">
													<input type="submit" class="btnAplicar" tabindex="1" name="Aplicar" value="#BTN_Aplicar#" onclick="javascript: return confirm('Va a aplicar el calculo del proceso de distribucion de excedentes para el periodo indicado.\n Desea continuar?');">
													<input type="hidden" name="periodo" value="#rs_datos.periodo#">												
												</td>									
											</tr>
										</cfif>
									</cfif>
									</form>
									<tr><td colspan="2"><label>Listado de asociados y montos por distribucion de excedentes</label></td></tr>
									<form name="filtro" method="url" action="">
									<input type="hidden" name="periodo" value="#rs_datos.periodo#">												
									<tr>
										<td colspan="2">
											<table class="areaFiltro" width="100%" cellpadding="1">
												<tr>
													<td width="1%"><strong>Identificaci&oacute;n:</strong></td>
													<td><input type="text" size="20" maxlength="60" tabindex="2" name="f_identificacion"onfocus="this.select();" value="<cfif isdefined('url.f_identificacion')>#trim(url.f_identificacion)#</cfif>"></td>
													<td  width="1%"><strong>Nombre:</strong></td>
													<td><input type="text" size="50" maxlength="100" tabindex="2" name="f_nombre" onfocus="this.select();" value="<cfif isdefined('url.f_nombre')>#trim(url.f_nombre)#</cfif>" ></td>
													<td rowspan="2" valign="middle"><input type="submit" tabindex="2" class="btnFiltrar" value="Filtrar" name="Filtrar" onclick="this.form.action='';"></td>
												</tr>
											</table>
										</td>
									</tr>
									</form>
									<tr>
										<td colspan="2">
											<cfset navegacion = '&periodo=#url.periodo#' >
											<cf_dbfunction name="concat" args="DEapellido1,' ', DEapellido2,' ',DEnombre" returnvariable="nombre">
											<cfinvoke 
											 component="rh.Componentes.pListas"
											 method="pListaRH"
											 returnvariable="pListaRet">
												<cfinvokeargument name="tabla" value="ACDistribucionDividendosE a, ACDistribucionDividendos b, ACAsociados c, DatosEmpleado de"/>
												<cfinvokeargument name="columnas" value="de.DEidentificacion, #nombre# as DEnombre, b.ACDDdias as dias, b.ACDDmonto as monto"/>
												<cfinvokeargument name="desplegar" value="DEidentificacion, DEnombre, dias, monto"/>
												<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre, D&iacute;as, Monto"/>
												<cfinvokeargument name="formatos" value="S,S,S,M"/>
												<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
																					  and a.ACDDEperiodo = #url.periodo#
																					  and b.Ecodigo = a.Ecodigo
																					  and b.ACDDEperiodo = a.ACDDEperiodo
																					  and c.ACAid=b.ACAid
																					  and de.DEid=c.DEid
																					  #preservesinglequotes(filtro)#
																					  order by de.DEidentificacion"/>
												<cfinvokeargument name="align" value="left,left,right, right"/>
												<cfinvokeargument name="ajustar" value="S"/>
												<cfinvokeargument name="checkboxes" value="N"/>
												<cfinvokeargument name="showlink" value="false"/>
												<cfinvokeargument name="debug" value="N"/>
												<cfinvokeargument name="PageIndex" value="0" />
												<cfinvokeargument name="maxrows" value="50" />
												<cfinvokeargument name="incluyeForm" value="no" />
												<cfinvokeargument name="navegacion" value="#navegacion#" />
											</cfinvoke>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<table width="100%" cellpadding="2" cellspacing="0" bgcolor="##CFCFCF">
												<tr>
													<td style="padding-left:20px;"><strong>Total:</strong></td>
													<td align="right"><strong>#LSNumberFormat(rs_datos.monto, ',9.00')#</strong></td>
												</tr>
											</table>
										</td>
									</tr>
									
									<form name="form2" method="url" action="liquidaDividendoSocios-sql.cfm" onsubmit="javascript: return validar();">
									<cfif rs_datos.estado neq 2>
										<tr>
											<td colspan="2" align="center" >
												<input type="submit" class="btnGuardar" tabindex="3" name="liquidar" value="#BTN_Recalcular#" onclick="javascript: document.form2.monto.value = document.form1.monto.value; return confirm('Va a recalular la informacion del proceso de distribucion de excedentes para el periodo indicado.\n Desea continuar?');">
												<input type="submit" class="btnAplicar" tabindex="3" name="Aplicar" value="#BTN_Aplicar#" onclick="javascript: return confirm('Va a aplicar el calculo del proceso de distribucion de excedentes para el periodo indicado.\n Desea continuar?');">
												<input type="hidden" name="periodo" value="#rs_datos.periodo#">
											</td>									
										</tr>
										<input type="hidden" name="monto" value="#LSNumberFormat(rs_datos.monto, ',9.00')#">
									</cfif>
									</form>
								</table>
							</td>								
						</tr>
					</table>
				</td>	
			</tr>
		</table>	
	<cf_web_portlet_end>
	</cfoutput>
	
	<script type="text/javascript" language="javascript1.2">
		function validar(){
			var msj = 'Se presentaron los siguientes errores:\n';
			if ( document.form1.monto.value == '' ){
				alert(msj + ' - El monto por distribuir es requerido.');
				return false;
			}

			if ( parseFloat(qf(document.form1.monto.value)) == 0 ){
				alert(msj + ' - El monto por distribuir debe ser mayor a cero.');
				return false;				
			}
			return true;
		}
	</script>
	
<cf_templatefooter>