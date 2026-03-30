<cfquery name="rsDEid" datasource="#session.dsn#">
   select llave from UsuarioReferencia where Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado' 
</cfquery>
<cfif rsDEid.recordcount gt 0 and  len(trim(#rsDEid.llave#))>
 <cfset form.DEid = #rsDEid.llave#>
</cfif>

<cfsavecontent variable="Reporte">
	<table width="97%" border="0" cellspacing="0" cellpadding="0"  align="center">
		<tr bgcolor="#EEEEEE" style="padding: 3px;">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="Boleta_de_Pago_del_Empleado"
			Default="Boleta de Pago del Empleado"
			returnvariable="HistoricoDePagosRealizados"/>		
			<td align="center"><font size="3"><b><cfoutput>#HistoricoDePagosRealizados#</cfoutput></b></font>
			</td>
		</tr>
	</table>
	
	<table width="97%" border="0" cellspacing="0" cellpadding="0"  align="center">
		<tr> 
			<td> 
				<!---<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>--->
					<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr><td align="right">&nbsp;
						</td></tr>
						<tr><td><cfinclude template="/rh/portlets/pEmpleado.cfm"></td> </tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<cfparam name="width" default="800">
								<cfparam name="height" default="125">
								<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td nowrap align="center">
										
										<cfif not isDefined("Form.DEid")>
											<cfquery name="rsGetUsuario" datasource="#session.DSN#">
												select ue.llave as DEid_char, <cf_dbfunction name="to_number" args="llave"> as DEid
												from UsuarioReferencia ue 
												where ue.Ecodigo = #session.EcodigoSDC# 
												and ue.STabla = 'DatosEmpleado' 
												and ue.Usucodigo = #session.Usucodigo#
											</cfquery>
											
											<cfif rsGetUsuario.RecordCount EQ 0>
												<center><strong>El usuario no es empleado</strong></center>
												<cfabort>
											<cfelse>
												<cfset form.DEid = rsGetUsuario.DEid >
											</cfif>
										</cfif>
										
										
										<cfquery name="rsLista" datasource="#session.DSN#">
											select CPfpago as CPfpagos, a.DEid,d.CPid, a.RCNid, b.Tcodigo, 
												   SEincidencias, SErenta, SEcargasempleado, SEdeducciones, 
												   SEliquido, SEsalariobruto, RCdesde as desde, RChasta as hasta, 
												   Tdescripcion,rtrim(d.CPcodigo) as CPcodigo
											from HSalarioEmpleado a
											
											inner join HRCalculoNomina b
											on a.RCNid=b.RCNid 
																					
											inner join TiposNomina c
											on b.Tcodigo=c.Tcodigo 
											and b.Ecodigo=c.Ecodigo 
											
											inner join CalendarioPagos d
											on b.RCNid=d.CPid
	
											where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
											order by d.CPfpago desc
										</cfquery>
	
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Pago"
										Default="Pagos"
										returnvariable="Pago"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Desde"
										Default="Desde"
										returnvariable="Desde"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Hasta"
										Default="Hasta"
										returnvariable="Hasta"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Nomina"
										Default="N&oacute;mina"
										returnvariable="Nomina"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="SalarioBruto"
										Default="Salario Bruto"
										returnvariable="SalarioBruto"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Incidencias"
										Default="Incidencias"
										returnvariable="Incidencias"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Renta"
										Default="Renta"
										returnvariable="Renta"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CargasEmpleado"
										Default="Cargas Empleado"
										returnvariable="CargasEmpleado"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Deducciones"
										Default="Deducciones"
										returnvariable="Deducciones"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="Liquido"
										Default="L&iacute;quido"
										returnvariable="Liquido"/>
										
										
										<cfset navegacion = "DEid=#form.DEid#" >
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaEmpl">
											<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" 
															  value="CPfpagos, desde, hasta, Tdescripcion, SEsalariobruto, SEincidencias,
																	 SErenta, SEcargasempleado, SEdeducciones, SEliquido"/>
											<cfinvokeargument name="etiquetas" 
															  value="#Pago#,#Desde#,#Hasta#,#Nomina#,#SalarioBruto#,#Incidencias#, 																			
																	 #Renta#, #CargasEmpleado#, #Deducciones#, #Liquido#"/>
											<cfinvokeargument name="formatos" value="D, D, D, S, M, M, M, M, M, M"/>
											<cfinvokeargument name="align" 
															  value="center, center, center, center, right, right, right, right, 
																	 right, right"/>
											<cfinvokeargument name="fparams" value="RCNid"/>
											<cfinvokeargument name="MaxRows" value="30"/>
											<cfinvokeargument name="irA" value="Boleta-impr.cfm"/>
											<cfinvokeargument name="MaxRows" value="30"/>
											<cfinvokeargument name="Key" value="DEid"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="showemptylistmsg" value="true"/>
										</cfinvoke>
										</td>
									</tr>
									<tr>
										<td nowrap align="center">&nbsp;</td>
									</tr>
									<cfif rsLista.recordcount eq 0>
									  <tr>
										<td nowrap align="center"> ---------    No existen registros para mostrar -------- </td>
									</tr>
									</cfif>
								</table>
							</td>
						</tr>
					</table>
				<!---</cfif>--->
			</td>
		</tr>
	</table>
</cfsavecontent>
<cfoutput>
	#Reporte#		
</cfoutput>	
