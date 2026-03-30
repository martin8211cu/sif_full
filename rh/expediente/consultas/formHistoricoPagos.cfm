<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="HistoricoDePagosRealizados" Default="Hist&oacute;rico de Pagos Realizados" returnvariable="HistoricoDePagosRealizados" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="Pago" Default="Pagos" returnvariable="Pago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Desde" Default="Desde" returnvariable="Desde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Hasta" Default="Hasta" returnvariable="Hasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Nomina" Default="N&oacute;mina" returnvariable="Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="SalarioBruto" Default="Salario Bruto" returnvariable="SalarioBruto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Incidencias" Default="Incidencias" returnvariable="Incidencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Renta" Default="Renta" returnvariable="Renta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="CargasEmpleado" Default="Cargas Empleado" returnvariable="CargasEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Deducciones" Default="Deducciones" returnvariable="Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="Liquido" Default="L&iacute;quido" returnvariable="Liquido" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function excel(){
		var frame  = document.getElementById("FRAME_EXCEL");
		frame.src 	= "excel.cfm";
	}
</script>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

<cfsavecontent variable="Reporte">
	<table width="97%" border="0" cellspacing="0" cellpadding="0"  align="center">
		<tr bgcolor="#EEEEEE" style="padding: 3px;">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="HistoricoDePagosRealizados"
			Default="Hist&oacute;rico de Pagos Realizados"
			returnvariable="HistoricoDePagosRealizados"/>		
			<td align="center"><font size="3"><b><cfoutput>#HistoricoDePagosRealizados#</cfoutput></b></font>
			</td>
		</tr>
	</table>
	
	<table width="97%" border="0" cellspacing="0" cellpadding="0"  align="center">
		<tr> 
			<td> 
				<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
					<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
						<!---<tr><td align="right">
						<a href="##" tabindex="-1">
						<img src="/cfmx/rh/imagenes/Cfinclude.gif"
							alt="Documento en Formato MS Excel" 
							name="imagen" 
							border="0" 
							align="absmiddle" 
							onClick='javascript: excel();'>	
						</a>
						</td></tr>--->
						<tr><td><cfinclude template="/rh/portlets/pEmpleado.cfm"></td> </tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<cfparam name="width" default="800">
								<cfparam name="height" default="125">
								<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td nowrap align="center">
										<cfquery name="rsLista" datasource="#session.DSN#">
											select CPfpago as CPfpagos, a.DEid, a.RCNid, b.Tcodigo, 
												<cfif UnificaSalarioB>
												   SEincidencias,SEsalariobruto+SEincidencias as SEsalariobruto,
												<cfelse>
													SEincidencias,SEsalariobruto,
												</cfif>
												    SErenta, SEcargasempleado, SEdeducciones, 
												   SEliquido,  RCdesde as desde, RChasta as hasta, 
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
	
										
										
										<cfset navegacion = "DEid=#form.DEid#" >
										<cfif UnificaSalarioB> 
											<cfinvoke 
												component="rh.Componentes.pListas"
												method="pListaQuery"
												returnvariable="pListaEmpl">
												<cfinvokeargument name="query" value="#rsLista#"/>
												<cfinvokeargument name="desplegar" 
																  value="CPfpagos, desde, hasta, Tdescripcion, SEsalariobruto,
																		 SErenta, SEcargasempleado, SEdeducciones, SEliquido"/>
												<cfinvokeargument name="etiquetas" 
																  value="#Pago#,#Desde#,#Hasta#,#Nomina#,#SalarioBruto#, 																			
																		 #Renta#, #CargasEmpleado#, #Deducciones#, #Liquido#"/>
												<cfinvokeargument name="formatos" value="D, D, D, S, M, M, M, M, M, M"/>
												<cfinvokeargument name="align" 
																  value="center, center, center, center, right, right, right, right, 
																		 right, right"/>
												<cfinvokeargument name="fparams" value="RCNid"/>
												<cfinvokeargument name="MaxRows" value="30"/>
												<cfinvokeargument name="irA" value="HResultadoCalculo.cfm"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="showemptylistmsg" value="true"/>
											</cfinvoke>
										<cfelse>
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
												<cfinvokeargument name="irA" value="HResultadoCalculo.cfm"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="showemptylistmsg" value="true"/>
											</cfinvoke>
										</cfif>
										</td>
									</tr>
									<tr>
										<td nowrap align="center">&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</cfif>
			</td>
		</tr>
	</table>
</cfsavecontent>

<cfsavecontent variable="Reporte2">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0"  align="center">
		<tr> 
			<td> 
				<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
					<cfquery name="rsEmpleado" datasource="#session.DSN#">
						select DEapellido1,DEapellido2,DEnombre,NTIdescripcion,DEidentificacion
						from DatosEmpleado a
						inner join NTipoIdentificacion b
							on  a.NTIcodigo = b.NTIcodigo 
						where DEid  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
					</cfquery>
					<cfquery name="rsLista" datasource="#session.DSN#">
						select CPfpago as CPfpagos, a.DEid, a.RCNid, b.Tcodigo, 
							   SEliquido, SErenta, SEcargasempleado, SEdeducciones, 
							   <cfif UnificaSalarioB>
							   SEincidencias+SEsalariobruto as SEsalariobruto, 
							   <cfelse>
							   SEincidencias, SEsalariobruto, 
							   </cfif>
							   RCdesde as desde, RChasta as hasta, 
							   Tdescripcion,rtrim(d.CPcodigo) as CPcodigo
						from HSalarioEmpleado a
						
						inner join HRCalculoNomina b
						on a.RCNid=b.RCNid 
						and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						
						inner join TiposNomina c
						on b.Tcodigo=c.Tcodigo 
						and b.Ecodigo=c.Ecodigo 
						
						inner join CalendarioPagos d
						on b.RCNid=d.CPid

						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						order by d.CPfpago desc
					</cfquery>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" >
						<tr><td  colspan="2" align="center"><b><font style="font-size:14px"><cf_translate  key="LB_historic">Hist&oacute;rico de pagos realizado</cf_translate></font></b></td></tr>	
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td colspan="2"><b><cf_translate  key="LB_Nombre_Completo">Nombre Completo</cf_translate></b>&nbsp;#rsEmpleado.DEapellido1#&nbsp;#rsEmpleado.DEapellido2#&nbsp;#rsEmpleado.DEnombre#</td></tr>		
						<tr><td colspan="2"><b>#rsEmpleado.NTIdescripcion#</b>&nbsp;#rsEmpleado.DEidentificacion#</td></tr>	
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td colspan="2">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr bgcolor="##999999">
										<td align="center"><b>#Pago#</b></td>
										<td align="center"><b>#Desde#</b></td>
										<td  align="center"><b>#Hasta#</b></td>
										<td><b>#Nomina#</b></td>
										<td align="right"><b>#SalarioBruto#</b></td>
										<cfif not UnificaSalarioB><td align="right"><b>#Incidencias#</b></td></cfif>
										<td align="right"><b>#Renta#</b></td>
										<td align="right"><b>#CargasEmpleado#</b></td>
										<td align="right"><b>#Deducciones#</b></td>
										<td align="right"><b>#Liquido#</b></td>
									</tr>
									<cfif rsLista.recordCount GT 0>
										<cfloop query="rsLista">
											<tr >
												<td align="center">#LSDateFormat(rsLista.CPfpagos, "mm/dd/yyyy")#</td>
												<td align="center">#LSDateFormat(rsLista.desde, "mm/dd/yyyy")#</td>
												<td align="center">#LSDateFormat(rsLista.hasta, "mm/dd/yyyy")#</td>
												<td>#rsLista.Tdescripcion#</td>
												<td align="right">#LSNumberFormat(rsLista.SEsalariobruto, ',L.00')#</td>
												<cfif not UnificaSalarioB><td align="right">#LSNumberFormat(rsLista.SEincidencias, ',L.00')#</td></cfif>
												<td align="right">#LSNumberFormat(rsLista.SErenta, ',L.00')#</td>
												<td align="right">#LSNumberFormat(rsLista.SEcargasempleado, ',L.00')#</td>
												<td align="right">#LSNumberFormat(rsLista.SEdeducciones, ',L.00')#</td>
												<td align="right">#LSNumberFormat(rsLista.SEliquido, ',L.00')#</td>
											</tr>
										</cfloop>
									</cfif>
								</table>
							</td>
						</tr>
					</table>
				</cfif>
			</td>
		</tr>
	</table>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#Reporte#	
	<cfset tempfile = GetTempDirectory()>
	<cfset session.tempfile_xls = #tempfile# & "HistoricoPagos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cffile action="write" file="#session.tempfile_xls#" output="#Reporte2#" nameconflict="overwrite">
</cfoutput>	
<iframe id="FRAME_EXCEL" name="FRAME_EXCEL" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>