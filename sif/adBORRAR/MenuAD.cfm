<cf_templateheader title="Administraci&oacute;n del Sistema">
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Administraci&oacute;n del Sistema">
		<cfinclude template="../portlets/pNavegacion.cfm">
		<br>

		<table width="100%" border="0" cellspacing="0" cellpadding="4">
			<tr>
				<td width="70%" height="446" valign="top">
					<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr> 
							<td width="4%" align="center" valign="middle">
								<a href="/cfmx/sif/ad/catalogos/ParametrosAD.cfm" >
									<img src="../imagenes/16x16_flecha_right.gif" border="0"  >
								</a>
							</td>
							<td nowrap>
								
								<a href="/cfmx/sif/ad/catalogos/ParametrosAD.cfm">
									<cfoutput>#Request.Translate('ParamGen','Parámetros Generales del Sistema')#</cfoutput>
								</a>
								
							</td>
						</tr>
						<tr> 
							<td colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
		
						<tr> 
							<td align="center" >
								<a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm"><img src="../imagenes/16x16_flecha_right.gif" border="0"></a>
							</td>
							<td nowrap>
								<a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm">Par&aacute;metros Adicionales</a>
							</td>
						</tr>			
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
						<tr> 
							<td align="center">
								<a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap>
								<a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm">Asignación de Concepto por Auxiliar Contable</a>
							</td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								</p></blockquote>
							</td>	
						</tr>
						<!--- Parámetros de Cuentas Contables de Operación --->
						<tr> 
							<td align="center">
								<a href="/cfmx/sif/ad/catalogos/ParametrosCuentasAD.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap>
									<a href="/cfmx/sif/ad/catalogos/ParametrosCuentasAD.cfm">Cuentas Contables de Operaci&oacute;n</a>
							</td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
		
						<!--- Centro Funcional --->
						<tr> 
							<td align="center">
								<a href="/cfmx/sif/ad/catalogos/CFuncional.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap>
								<a href="/cfmx/sif/ad/catalogos/CFuncional.cfm"><cfoutput>Centros Funcionales</cfoutput></a>
							</td>
						</tr>

						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>

						<!--- Oficinas --->
						<tr> 
							<td align="center">
								<a href="../ad/catalogos/Oficinas.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap>
								<a href="../ad/catalogos/Oficinas.cfm"><cfoutput>#Request.Translate('Oficinas','Oficinas')#</cfoutput></a>
							</td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>

						<!--- Departamentos --->
						<tr> 
							<td align="center">
								<a href="../ad/catalogos/Departamentos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap>
								<a href="../ad/catalogos/Departamentos.cfm"><cfoutput>#Request.Translate('Deptos','Departamentos')#</cfoutput></a>
							</td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
		
						<!--- Formatos de Impresion --->	
						<tr> 
							<td align="center">
								<a href="../ad/catalogos/listaFormatos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
							</td>
							<td nowrap ><a href="../ad/catalogos/listaFormatos.cfm">Formatos de Impresi&oacute;n </a></td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
					
						<!--- Formatos Adicionales --->	
						<tr> 
							<td align="center">
								
								<a href="../Formatos/Formatos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
								
							</td>
							<td nowrap><a href="../Formatos/Formatos.cfm">Formatos Adicionales</a></td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>
						<!--- Formatos Adicionales --->	
						<tr> 
							<td align="center">
								
								<a href="origenes/lista_origenes.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
								
							</td>
							<td nowrap><a href="origenes/lista_origenes.cfm">Parametrizaci&oacute;n de Origenes Contables </a></td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>					
						<!--- Formatos Adicionales --->	
						<tr> 
							<td align="center">
								
								<a href="origenes/Comp_Finacieros.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a>
								
							</td>
							<td nowrap><a href="origenes/Comp_Finacieros.cfm">Registro de Complementos Finacieros</a></td>
						</tr>
						<tr> 
							<td  colspan="2" >
								<blockquote><p align="justify">
								<!--- FALTA HABLADA --->
								</p></blockquote>
							</td>	
						</tr>					
						
					</table>
			  </td>
				<td valign="top"><cfinclude template="MenuCatalogosAD.cfm"></td>
			</tr>
			
		</table>
	</cf_web_portlet>
<cf_templatefooter>