<!---<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Distribuciones
	</cf_templatearea>
	<cf_templatearea name="body">
--->

<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Distribuciones'>

<!---	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet titulo="Distribucion">--->
		<cfif isdefined("url.IDgd") and len(trim(url.IDgd)) and not isdefined("form.IDgd")>
			<cfset form.IDgd = url.IDgd>
		</cfif>
		
		<cfset modo="ALTA">
		<cfif isdefined("form.IDgd") and form.IDgd GT 0>
			<cfset modo="CAMBIO">
		</cfif>
		<table width="100%"  border="0" cellspacing="2" cellpadding="0">
		  <tr>
			<td valign="top" nowrap>

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td valign="top" width="45%">
								<cf_dbfunction name='concat' args="(B.Oorigen + '-' + B.Odescripcion)" delimiters='+' returnvariable='LvarDOrg'>
								<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
									tabla="DCGDistribucion A, Origenes B"
									columnas="IDgd,	A.DCdescripcion, #LvarDOrg# as DOrg"
									desplegar="DCdescripcion"
									etiquetas="Descripcion"
									formatos="S"
									filtro=" A.Oorigen = B.Oorigen and A.Ecodigo=#session.Ecodigo# Order By IDgd"
									align="left"
									checkboxes="N"
									keys="IDgd"
									MaxRows="6"
									pageindex="1"
									filtrar_automatico="true"
									mostrar_filtro="true"
									filtrar_por="DCdescripcion"
									ira="formgrupos.cfm"
									showEmptyListMsg="true">
						
							</td>					
						  	<td valign="top" width="55%">
								
								<cfquery datasource="#Session.DSN#" name="rsOrigenes">
								select Oorigen,Odescripcion 
								from Origenes
								</cfquery>
								
								<cfif modo neq "ALTA">
									<cfquery name="rsForm" datasource="#Session.DSN#">
										select IDgd, DCdescripcion, Oorigen, ts_rversion
										from DCGDistribucion
										where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
									</cfquery>
								</cfif>
								<cfquery name="rsGD" datasource="#Session.DSN#">
									select IDgd, DCdescripcion, Oorigen, ts_rversion
									from DCGDistribucion									
								</cfquery>
								
								<cfoutput>
								<form action="sqlGrupos.cfm" method="post" name="form1">
									<cfif modo neq "ALTA">
										<input type="hidden" name="IDgd" value="#rsForm.IDgd#">
										<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
										<input type="hidden" name="ts_rversion" value="#ts#">
									</cfif>
									<br>
									<table width="100%"  border="0" cellspacing="2" cellpadding="0">
									<tr>
										<td colspan="2" class="subTitulo">Datos de Grupo </td>
									</tr>
									<tr>
										<td><strong> Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>
											<input type="text" name="DCdescripcion" maxlength="60" <cfif modo neq "ALTA">value="#rsForm.DCdescripcion#"</cfif>>
										</td>
									</tr>
									<tr>
										<td><strong> Origen&nbsp;:&nbsp;</strong></td>
										<td>	
											<select name="DCorigen">
											  <cfloop query="rsOrigenes"> 
												<option value="#rsOrigenes.Oorigen#" <cfif modo NEQ "ALTA"> 
																					   <cfif (rsOrigenes.Oorigen EQ rsForm.Oorigen)>selected</cfif>
																					 </cfif>>#rsOrigenes.Oorigen# - #rsOrigenes.Odescripcion#</option>
											  </cfloop> 
											</select>
										</td>
									</tr>
									</table>
									<br>
									<cfif modo NEQ "ALTA">
										
										<!--- Obtiene la cantidad de distribuciones asociadas --->
										<cfquery name="rsCantidadDistribucion" datasource="#Session.DSN#">
										Select count(1) as cantidad
										from DCGDistribucion a
												inner join DCDistribucion b
													 on a.IDgd = b.IDgd
													  and a.Ecodigo = b.Ecodigo		
										where a.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
										  and a.Ecodigo =  #Session.Ecodigo# 
										</cfquery>
																				
										<!--- Obtiene la cantidad de distribuciones asociadas que tienen cuentas --->
										<cfquery name="rsCantDistconCuentas" datasource="#Session.DSN#">
										Select count(1) as cantidadcuentas
										from DCGDistribucion a
											inner join DCDistribucion b
												 on a.IDgd = b.IDgd
												  and a.Ecodigo = b.Ecodigo
												
										where a.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
										  and a.Ecodigo =  #Session.Ecodigo# 
										  and exists (Select 1 
													   from DCCtasOrigen c 
													   where b.IDdistribucion	= c.IDdistribucion
														   and b.Ecodigo = c.Ecodigo)
										  and exists (Select 1 
													   from DCCtasDestino d 
													   where b.IDdistribucion	= d.IDdistribucion
														   and b.Ecodigo = d.Ecodigo)
				  						  and Tipo != 5
										</cfquery>
										
										<cfquery name="rsCantDistconCuentasCond" datasource="#Session.DSN#">
										Select count(1) as cantidadcuentasC
										from DCGDistribucion a
											inner join DCDistribucion b
												 on a.IDgd = b.IDgd
												  and a.Ecodigo = b.Ecodigo
												
										where a.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
										  and a.Ecodigo =  #Session.Ecodigo# 
										  and exists (Select 1 
													   from DCCtasOrigen c 
													   where b.IDdistribucion	= c.IDdistribucion
														   and b.Ecodigo = c.Ecodigo)
				  						  and Tipo = 5
										</cfquery>												
										
										<cfset totaldist = rsCantidadDistribucion.cantidad>
										<cfset totaldistconcuentas = rsCantDistconCuentas.cantidadcuentas + rsCantDistconCuentasCond.cantidadcuentasC>
										
										<cfif (totaldist eq totaldistconcuentas) and (totaldist neq 0)>
											<!--- En caso de que todas las distribuciones tengan cuentas --->
											<cf_botones modo="#modo#" include="Distribuciones,Generar_Distribucion">
										<cfelse>
											<cf_botones modo="#modo#" include="Distribuciones">
										</cfif>
									<cfelse>	
										<cf_botones modo="#modo#">
									</cfif>
									
								</form>
								<cf_qforms>
								<script language="javascript" type="text/javascript">
								<!--//
									objForm.DCdescripcion.description = "#JSStringFormat('Nombre')#";
									function habilitarValidacion(){		
										objForm.DCdescripcion.required = true;									
									}
									function desahabilitarValidacion(){
										objForm.DCdescripcion.required = false;
									}
									habilitarValidacion();
									objForm.DCdescripcion.obj.focus();
								//-->
								</script>
								</cfoutput>	
							</td>
						</tr>
					</table>
			</td>	
		  </tr>
		</table>
		
		<cfif isdefined("form.IDgd") and form.IDgd neq "">
			<script>
				function funcDistribuciones() {
					document.form1.action = 'lstDistribuciones.cfm';
					document.form1.submit();
					return false;
				}
				function funcGenerar_Distribucion()
				{
					document.form1.action = '../operacion/Distribuir.cfm?IDgd=<cfoutput>#form.IDgd#</cfoutput>';
					document.form1.submit();
					return false;				
				}
			</script>		
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
