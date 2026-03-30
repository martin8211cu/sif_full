			<cfset navegacion = '' >

			<cfif isdefined("url.Did") and not isdefined("form.Did")>
				<cfset form.Did = url.Did>
			</cfif>
			<cfif isdefined("form.Did") and len(trim(form.Did))>
				<cfset navegacion = "&Did=#form.Did#">
			</cfif> 

			<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
				<cfset form.DEid = url.DEid>
			</cfif>
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				<cfset navegacion = navegacion & "&DEid=#form.DEid#">
			</cfif> 

			<cfquery name="rsDeduccion" datasource="#session.DSN#">
				select Ddescripcion
				from DeduccionesEmpleado
				where Did= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				  and DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>

			<cfif isdefined("form.regresar") and len(trim(form.regresar)) gt 0>
				<script language="JavaScript1.2" type="text/javascript">
					function regresar(){
						if('<cfoutput>#regresar#</cfoutput>' == 'Expediente_concursante.cfm'){
							history.back();		
						}
						else{
							document.form1.action = '<cfoutput>#regresar#</cfoutput>';
							document.form1.submit();
						}	
					}
				</script>	
				
				<cfset regresar = "javascript:regresar();" >				
			<cfelse>
				<link href="/cfmx/rh/css/rh.css" type="text/css" rel="stylesheet">
				<cfset regresar = "">
			</cfif>

			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<!---<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>--->
				<tr><td>&nbsp;</td></tr>
				
				<cfif not isdefined("form.regresar") >
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ConsultaDeTransaccionesDeDeduccion"
					Default="Consulta de Transacciones de Deducci&oacute;n"
					returnvariable="LB_ConsultaDeTransaccionesDeDeduccion"/>
					
					<tr><td class="superTitulo" align="center"><cfoutput>#LB_ConsultaDeTransaccionesDeDeduccion#</cfoutput></td></tr>
					<tr><td>&nbsp;</td></tr>
				</cfif>

				<tr><td align="center">
					<table width="98%" cellpadding="3" cellspacing="0">
						<tr><td>
							<!--- <cfinclude template="/rh/portlets/cons_corporativo.cfm"> --->
							<cfinclude template="consultas-frame-header.cfm">
						</td></tr>
						<tr><td><cfinclude template="frame-infoEmpleado.cfm"></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td class="sectionTitle" colspan="2"><cf_translate key="DEDUCCION">DEDUCCION</cf_translate>: <cfoutput>#rsDeduccion.Ddescripcion#</cfoutput></td></tr>
		
						<tr>
							<td align="center">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_FechaPago"
								Default="Fecha Pago"
								returnvariable="LB_FechaPago"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Fechadesde"
								Default="Fecha desde"
								returnvariable="LB_Fechadesde"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_FechaHasta"
								Default="Fecha Hasta"
								returnvariable="LB_FechaHasta"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Valor"
								Default="Valor"
								returnvariable="LB_Valor"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Saldo"
								Default="Saldo"
								returnvariable="LB_Saldo"/>
								
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="HDeduccionesCalculo a, HRCalculoNomina b,CalendarioPagos cp"/>
									<cfinvokeargument name="columnas" value="CPfpago,b.RCdesde,RChasta,a.DCvalor,a.DCsaldo, a.DEid, a.Did,a.RCNid, '#regresar#' as regresar"/>
									<cfinvokeargument name="desplegar" value="CPfpago,RCdesde,RChasta,DCvalor,DCsaldo"/>
									<cfinvokeargument name="etiquetas" value="#LB_FechaPago#,#LB_Fechadesde#,#LB_FechaHasta#,#LB_Valor#,#LB_Saldo#"/>
									<cfinvokeargument name="formatos" value="D,D,D,M,M"/>
									<cfinvokeargument name="filtro" value="a.Did=#form.Did# and a.DEid=#form.DEid# and a.RCNid=b.RCNid and b.RCNid=cp.CPid"/>
									<cfinvokeargument name="align" value="center,center,center,right,right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="showLink" value="false"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="maxRows" value="15"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
								</cfinvoke>
		
								<cfif isdefined("form.regresar") and len(trim(form.regresar)) gt 0 >

									<form style="margin:0;" name="form1" method="post">
										<table width="100%" align="center">
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Regresar"
										Default="Regresar"
										returnvariable="BTN_Regresar"/>
											<tr><td align="center"><input type="button" name="btnRegresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript:regresar();"></td></tr>
											<tr><td>
												<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>" >
												<input type="hidden" name="o" value="<cfif isdefined('form.o') and form.o NEQ ''><cfoutput>#form.o#</cfoutput><cfelse>7</cfif>" >
											</td></tr>
										</table>
									</form>
								</cfif>
							</td>	
						</tr>
					</table>							
				</td></tr>
			</table>
