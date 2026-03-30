<!--- 
Creado por Jose Gutierrez 
	13/03/2018
 --->
<cfset returnTo="VerificarProducto_sql.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Verificar Productos')>
<cfset LB_Campo					= t.Translate('LB_Campo','Campo')>
<cfset LB_Valor					= t.Translate('LB_Valor','Valor')>
<cfset LB_TituloTabla			= t.Translate('LB_TituloTabla','Resultados Verificaci&oacute;n')>
<cfset TIT_VerificarProductos 	= t.Translate('TIT_VerificarProductos','Verificar Productos')>
<cfset LB_TipoTransaccion		= t.Translate('LB_TipoTransaccion','Tipo de Transacci&oacute;n')>
<cfset LB_NumTarjeta 			= t.Translate('LB_NumTarjeta','N&uacute;mero de Tarjeta')>
<cfset LB_NumFolio				= t.Translate('LB_NumFolio','N&uacute;mero de Folio')>
<cfset LB_CodTienda				= t.Translate('LB_CodTienda','C&oacute;digo de Tienda')>
<cfset LB_CodExtDistribuidor	= t.Translate('LB_CodExtDistribuidor','C&oacute;digo Ext. Distribuidor')>
<cfset LB_Monto 				= t.Translate('LB_Monto', 'Monto')>
<cfset LB_EdoCuenta 			= t.Translate('LB_EdoCuenta', 'ESTADO DE CUENTA')>
<cfset LB_FechExp 			    = t.Translate('LB_FechExp', 'FECHA DE EXPIRACI&Oacute;N')>
<cfset LB_ValCheqBlanco			= t.Translate('LB_ValCheqBlanco', 'VALOR VALE EN BLANCO')>
<cfset LB_PermiteContraVale		= t.Translate('LB_PermiteContraVale', 'PERMITE CONTRAVALE')>
<cfset LB_TAdicional			= t.Translate('LB_TAdicional', 'DISPONIBLE TARJETA ADICIONAL')>
<cfset LB_PorcientoSG			= t.Translate('LB_PorcientoSG', 'PORCIENTO SOBREGIRO')>
<cfset LB_ClienteTA				= t.Translate('LB_ClienteTA', 'CLIENTE TARJETA ADICIONAL')>
<cfset LB_MntAprobTA			= t.Translate('LB_MntAprobTA', 'MONTO APROBADO TARJETA ADICIONAL')>
<cfset LB_Disponible			= t.Translate('LB_Disponible', 'DISPONIBLE')>

<cfset LvarPagina = "VerificarProducto.cfm">

<cfoutput>
	<!--- Valores a mandar como argumentos al método chequearProducto --->
			<cfif isdefined('Form.tipoTransaccion') and #Form.tipoTransaccion# neq ''>
				<cfset tipoTran = Rtrim(Ltrim(#Form.tipoTransaccion#))>
			<cfelse>
				<cfset tipoTran = ''>
			</cfif>

			<cfif isdefined('Form.numTarjeta') and #Form.numTarjeta# neq ''>
				<cfset numTarjeta = Rtrim(Ltrim(#Form.numTarjeta#))>
			<cfelse>
				<cfset numTarjeta = ''>
			</cfif>

			<cfif isdefined('Form.numFolio') and #Form.numFolio# neq ''>
				<cfset numFolio = #Form.numFolio#>
			<cfelse>
				<cfset numFolio = ''>
			</cfif>

			<cfif isdefined('Form.codTienda') and #Form.codTienda# neq ''>
				<cfset codTienda = #Form.codTienda#>
			<cfelse>
				<cfset codTienda = ''>
			</cfif>

			<cfif isdefined('Form.codExtDis') and #Form.codExtDis# neq ''>
				<cfset codExtDist = #Form.codExtDis#>
			<cfelse>
				<cfset codExtDist = ''>
			</cfif>

			<cfif isdefined('Form.monto') and #Form.monto# neq ''>
				<cfset monto = #Form.monto#>
				<cfset chkMonto = "True">
			<cfelse>
				<cfset monto = 0>
				<cfset chkMonto = "False">
			</cfif>

		<cfinvoke component="crc.Componentes.Compra.CRCChequearProducto"  method="init" returnvariable="rs">

		<!--- Se invoca al método chequearProducto del componente CRCChequearProducto --->
		<cfif tipoTran neq '' >
			<cfset resultado = rs.chequearProducto("#tipoTran#","#numTarjeta#","#numFolio#", "#codTienda#","#codExtDist#", "#monto#","#chkMonto#", "true")>
		</cfif>
		
		<cfif isdefined("resultado.codigo") and resultado.codigo neq 0>
			<label style="color:red"><h3>#resultado.mensaje#</h3> </label>
		<cfelse>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td>
					<fieldset>
						<table  width="95%" border="1" cellspacing="0" cellpadding="0" align="center" style="font-weight:bold">
							<tr>
								<td align="center" colspan="2" class="listaPar">
									<b>#LB_TituloTabla#</b>
								</td>
								
							</tr> 
							
							<cfif isNull(resultado)>

			 				<cfelse>  
				 				<cfloop collection=#resultado# item="rsChequearProducto">
									<tr>
										
											<cfswitch expression="#Trim(rsChequearProducto)#"> 

												<cfcase value="EstadoCuenta"> 
													<td nowrap align="left" width="10%"></strong>#LB_EdoCuenta#</td>
													<td align="right">#trim(resultado[rsChequearProducto])#</td>
												</cfcase>
												<cfcase value="FechaExpiracion"> 
													<cfif tipoTran eq "VC">
														<td nowrap align="left" width="10%">#LB_FechExp#</td>
														<td align="right">#trim(resultado[rsChequearProducto])#</td>
													</cfif>
												</cfcase>
												<cfcase value="ValorChequeBlanco"> 
													<cfif tipoTran eq "VC">
														<td nowrap align="left" width="10%">#LB_ValCheqBlanco#</td>
														<td align="right">#NumberFormat(resultado[rsChequearProducto],"00.00")#</td>
													</cfif>
												</cfcase>
												<cfcase value="PermiteContraVale"> 
													<cfif tipoTran eq "VC">
														<td nowrap align="left" width="10%">#LB_PermiteContraVale#</td>
														<td align="right">
															<cfif #trim(resultado[rsChequearProducto])# eq 'S'>
																SI
															<cfelseif #trim(resultado[rsChequearProducto])# eq 'N'>
																NO
															<cfelse>
																#trim(resultado[rsChequearProducto])#
															</cfif>
														</td>
													</cfif>
												</cfcase>
												<cfcase value="DISPONIBLETA"> 
													<td nowrap align="left" width="10%">#LB_TAdicional#</td>
													<td align="right">#trim(resultado[rsChequearProducto])#</td>
												</cfcase>
												<cfcase value="PORCIENTOSOBREGIRO"> 
													<cfif tipoTran eq "VC">
														<td nowrap align="left" width="10%">#LB_PorcientoSG#</td>
														<td align="right">#NumberFormat(resultado[rsChequearProducto],"00.00")#</td>
													</cfif>
												</cfcase>
												<cfcase value="NombreTA"> 
													<td nowrap align="left" width="10%">#LB_ClienteTA#</td>
													<td align="right">#trim(resultado[rsChequearProducto])#</td>
												</cfcase>
												 <cfcase value="MontoAprobadoTA"> 
													<td nowrap align="left" width="10%">#LB_MntAprobTA#</td>
													<td align="right">#trim(resultado[rsChequearProducto])#</td>
												</cfcase>
												<cfcase value="DISPONIBLE"> 
													<td nowrap align="left" width="10%"></strong>#LB_Disponible#</td>
													<td align="right">#NumberFormat(resultado[rsChequearProducto],"00.00")#</td>
												</cfcase>
												<cfcase value="CODIGO"></cfcase>
												<cfcase value="ANOTACIONES">
													<td nowrap align="left" width="10%"></strong>ANOTACIONES</td>
													<td align="left">
														<cfset arrAnotaciones = ListToArray(resultado[rsChequearProducto],"|")>
														<ul>
															<cfloop array="#arrAnotaciones#" item="index">
																<li>#index#</li>
															</cfloop>
														</ul>
													</td>
												</cfcase>
												<cfcase value="FIRMA">
													<cfif tipoTran eq "VC" and resultado[rsChequearProducto] neq "" and 1 eq 2> 
														<td nowrap align="left" width="10%"></strong>FIRMA</td>
														<td align="right">
															<cfset myImage = ImageReadBase64(resultado[rsChequearProducto])> 
															<cfimage source="#myImage#" destination="signImage.png" action="writeToBrowser" height="75">
														</td>
													</cfif> 
												</cfcase>
												<cfcase value="FIRMAS">
													
												</cfcase>
												<cfcase value="MENSAJE"></cfcase>
												  
												
												<cfdefaultcase> 
													<td nowrap align="left" width="10%"><strong>#rsChequearProducto#&nbsp;</strong></td>
													<td align="right">#trim(resultado[rsChequearProducto])#</td>
												</cfdefaultcase> 
											</cfswitch>										
									</tr>
				 				</cfloop>
								<cfif tipoTran eq "VC" and resultado[rsChequearProducto] neq ""> 
								 	<tr>
										<td nowrap align="left" width="10%"></strong>FIRMAS</td>
										<td align="right">
											<cfset _firmaArr = ListToArray(resultado["FIRMAS"])>
											<cfloop array="#_firmaArr#" index="index">
												<cfset myImage = ImageReadBase64( index)> 
												<cfimage source="#myImage#" destination="signImage.png" action="writeToBrowser" height="75">
											</cfloop>
										</td>
									</tr>
								</cfif> 
			 				</cfif>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
						</table>
						</fieldset>
					</td>	
				</tr>
			</table>
		</cfif>
</cfoutput>




