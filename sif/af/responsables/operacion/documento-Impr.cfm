<cf_templatecss/>
<!--- Fuente para la impresion del documento en Inclusion de documentos --->
<!--- Consulta del modo cambio o precarga para llenar campos con valores iniciales ya sea en modo cambio para una 
modificación o en modo precarga para dar de alta un nuevo registro --->
<cfif not isdefined('url.CRDRid') and isdefined('form.CRDRid')>
	<cfset url.CRDRid = form.CRDRid>
</cfif>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select 
		Edescripcion,ts_rversion,
		Ecodigo
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsForm" datasource="#session.dsn#">
	select a.CRDRid, a.CRTDid, a.CRTCid, a.DEid, a.CFid, a.CRDRdescripcion, a.CRDRfdocumento, a.CRCCid, 
			a.CRDRplaca, a.CRDRdescdetallada, a.CRDRserie, a.CRDRtipodocori, a.CRDRdocori, a.CRDRlindocori, a.Monto,
			a.EOidorden, a.DOlinea, a.ts_rversion, 
			b.CRTDcodigo, b.CRTDdescripcion, 
			c.CRTCcodigo, c.CRTCdescripcion, 
			d.DEidentificacion, 
			{fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombrecompleto, 
			e.CFcodigo, e.CFdescripcion,
			f.CRCCcodigo, f.CRCCdescripcion,
			g.ACcodigo,g.ACcodigodesc,g.ACdescripcion,g.ACmascara,
			h.ACid,h.ACcodigodesc as Cat_ACcodigodesc,h.ACdescripcion as Cat_ACdescripcion,
			i.AFCcodigo,i.AFCcodigoclas,i.AFCdescripcion,
			j.AFMid,j.AFMcodigo,j.AFMdescripcion,
			k.AFMMid,k.AFMMcodigo,k.AFMMdescripcion,
			l.EOnumero, l.DOconsecutivo,
			g.ACatId idCategoria,
			h.AClaId idClase
	from CRDocumentoResponsabilidad a 
			left outer join CRTipoDocumento b on 
				a.CRTDid = b.CRTDid
			left outer join CRTipoCompra c on 
				a.CRTCid = c.CRTCid
			left outer join DatosEmpleado d on
				a.DEid = d.DEid
			left outer join CFuncional e on
				a.CFid = e.CFid
			left outer join CRCentroCustodia f on
				a.CRCCid = f.CRCCid
			left outer join ACategoria g on
				a.ACcodigo = g.ACcodigo
				and a.Ecodigo = g.Ecodigo
			left outer join AClasificacion h on
				a.ACcodigo = h.ACcodigo
				and a.ACid = h.ACid
				and a.Ecodigo = h.Ecodigo
			left outer join AFClasificaciones i on
				a.AFCcodigo = i.AFCcodigo
				and a.Ecodigo = i.Ecodigo
			left outer join AFMarcas j on
				a.AFMid = j.AFMid
			left outer join AFMModelos k on
				a.AFMMid = k.AFMMid
			left outer join DOrdenCM l on
				a.DOlinea = l.DOlinea
		where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CRDRid#">
 </cfquery>

<!--- Pintado del formulario --->
<cfoutput>
		<!--- Encabezado --->
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr><td>
				<cfif not isdefined("url.imprimir")>
					<cfset paramsUri = ''>
					<cfset paramsUri = paramsUri & '&imprimir=true&CRDRid=#url.CRDRid#'>
					<cf_rhimprime datos="/sif/af/responsables/operacion/documento-Impr.cfm" paramsuri="#paramsUri#">
				</cfif>
			</td></tr>
			
			<tr>
			  <td width="14%">
			  <cfinvoke
				 component="sif.Componentes.DButils"
				 method="toTimeStamp"
				 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
						
			  <cfoutput><img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" alt="logo" width="86" height="36" border="0" class="iconoEmpresa"/>			  </cfoutput>			  </td>
			 </tr>
			
<!---			<tr><td><hr></td></tr>--->
			<tr><td  align="center" colspan="5"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
			<tr>
				<td>&nbsp;</td>
				<td width="55%">&nbsp;</td>
				<td width="31%" colspan="4"  align="right"><strong>
			  <cf_translate key="LB_DocumentoDeResponsabilidad">
			    <div align="left"><font size="2"><strong>Placa <cfoutput>#rsForm.CRDRplaca#</cfoutput></strong></font></div>
			  </cf_translate></strong></td>
			</tr>
			
			<tr><td  align="center" colspan="5"><strong><cf_translate key="LB_DocumentoDeResponsabilidad">ASIGNACIÓN DE BIENES NUEVOS</cf_translate></strong></td>
			</tr>
			<tr><td  align="center"  colspan="5"><strong><cf_translate key="LB_Usuario">Usuario</cf_translate>: #session.datos_personales.Nombre# #session.datos_personales.Apellido1# #session.datos_personales.Apellido2#</strong></td></tr>
			<tr><td  align="center"  colspan="5"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>: #trim(LSDateFormat(Now(),'dd/mm/yyyy'))# #trim(LSTimeFormat(Now(),'HH:mm:ss'))#</strong></td></tr>
			<!---<tr><td>&nbsp;</td></tr>
			<tr><td><hr></td></tr>--->
		</table>
		<table align="center" border="0" cellspacing="0" cellpadding="2">
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr><td width="889" nowrap="NOWRAP" class="fileLabel"><strong>
			  <cf_translate key="LB_CentroDeCustodia">Centro de Custodia</cf_translate>:</strong>&nbsp;#rsform.CRCCdescripcion#</td></tr>		
			<tr><td  colspan="5">&nbsp;</td></tr>
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- INI Información del Activo --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend><strong><cf_translate key="LB_InformacionDelActivo">Informaci&oacute;n del Activo</cf_translate></strong></legend>
							<table  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td height="36" nowrap="nowrap" class="fileLabel">
										<p><strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#rsForm.ACcodigodesc# - #rsForm.ACdescripcion#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Clase">Clase</cf_translate>:&nbsp;</strong></p></td>
									<td>#rsForm.Cat_ACcodigodesc#-#rsForm.Cat_ACdescripcion#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
										<p><strong><cf_translate key="LB_Placa">Descripci&oacute;n</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#HTMLEditFormat(rsForm.CRDRdescripcion)#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml"></cf_translate>Serie:</strong>&nbsp;</p>
									

									</td>
									<td>#HTMLEditFormat(rsForm.CRDRserie)#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Marca">Marca</cf_translate>:</strong>&nbsp;</p></td>
									<td>#rsForm.AFMcodigo# - #rsForm.AFMdescripcion#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><strong><cf_translate key="LB_Modelo">Modelo</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#rsForm.AFMMcodigo# - #rsForm.AFMMdescripcion#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
										<p><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#rsForm.AFCcodigoclas# - #rsForm.AFCdescripcion#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_DescripcionDetallada"></cf_translate>
									  <cf_translate key="LB_Monto">Valor Inicial</cf_translate>
									  :</strong>&nbsp;</p></td>
									<td>#LSCurrencyFormat(rsForm.Monto,'none')#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong>Descripci&oacute;n Detallada
								    <cf_translate key="LB_Serie"></cf_translate>:&nbsp;</strong></p></td>
									<td>#HTMLEditFormat(rsForm.CRDRdescdetallada)#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Monto"></cf_translate>&nbsp;</strong></p></td>
									<td>&nbsp;</td>
								<tr>
						</table>
						</fieldset>
					</div>
					<!--- FIN Información del Activo --->
				</td>				
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- Información del Documento --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend><strong><cf_translate key="LB_InformacionDelDocumento">Informaci&oacute;n del Documento</cf_translate></strong></legend>
							<table  border="0" cellspacing="0" cellpadding="2">
								<tr>
								  <td nowrap="NOWRAP" class="fileLabel"><p><strong><cf_translate key="LB_TipoDeDocumento">Tipo de Documento</cf_translate>:</strong>&nbsp;</p></td>
									<td>#rsForm.CRTDcodigo# - #rsForm.CRTDdescripcion#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong></p></td>
									<td colspan="4">#LSDateFormat(rsForm.CRDRfdocumento,'dd/mm/yyyy')#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></p></td>
									<td nowrap>#rsForm.DEidentificacion# - #rsForm.DEnombrecompleto#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</p></td>
									<td nowrap>#rsForm.CFcodigo# - #rsForm.CFdescripcion#</td>
								</tr>
						</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<tr><td colspan="5">&nbsp;</td></tr>			
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- Información del Documento Origen (Factura, Orden de Compra) --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend><strong><cf_translate key="LB_InformacionDelOrigen">Informaci&oacute;n del Origen</cf_translate></strong></legend>
							<table  border="0" cellspacing="0" cellpadding="2">
								<tr>
								  <td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_TipoDeCompra">Tipo de Compra</cf_translate>:</strong>&nbsp;</p></td>
									<td>
										<cfif LEN(TRIM(rsForm.CRTCcodigo))>
										#rsForm.CRTCcodigo# - #rsForm.CRTCdescripcion#
										<cfelse>
										<cf_translate key="LB_NoDefinido">No definido</cf_translate>
								  		</cfif>								  
								  	</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Documento">Documento</cf_translate>:&nbsp;</strong></p></td>
									<td colspan="2">
										<cfif LEN(TRIM(rsform.CRDRdocori))>
										#rsForm.CRDRdocori#
										<cfelse>
										<cf_translate key="LB_NoDefinido">No definido</cf_translate>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_OrdenDeCompra">Orden de Compra</cf_translate>:</strong>&nbsp;</p></td>
									<td>
										<cfif LEN(TRIM(rsForm.EOnumero))>
										#rsForm.EOnumero#
										<cfelse>
										<cf_translate key="LB_NoDefinido">No definido</cf_translate>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong>L&iacute;nea:&nbsp;</strong></p></td>
									<td colspan="2">
										<cfif LEN(TRIM(rsForm.CRDRlindocori))>
											#rsForm.CRDRlindocori#
										<cfelse>
										No definido
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_LineaDeOC">Línea de O.C.</cf_translate>:&nbsp;</strong></p></td>
									<td>
										<cfif LEN(TRIM(rsForm.DOconsecutivo))>
											#rsForm.DOconsecutivo#
										<cfelse>
										<cf_translate key="LB_NoDefinido">No definido</cf_translate>
										</cfif>
									</td>
								</tr>
						</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<!---===Datos Variables===--->
			<tr>
			<td colspan="5">
				<fieldset><legend><strong>Otros Datos</strong></legend>
					<cfif rsForm.recordCount GT 0>
						<cfset Tipificacion = StructNew()> 
						<cfset temp = StructInsert(Tipificacion, "AF", "")> 
						<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#rsForm.idCategoria#")> 
						<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#rsForm.idClase#")>
			
						<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
							<cfinvokeargument name="DVTcodigoValor" value="AF">
							<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
							<cfinvokeargument name="DVVidTablaVal"  value="#rsForm.CRDRid#">
							<cfinvokeargument name="form" 			value="form1">
							<cfinvokeargument name="NumeroColumas"  value="3">
							<cfinvokeargument name="DVVidTablaSec" 	value="1"><!---(0=Activos)(1=CRDocumentoResponsabilidad) (2=DSActivosAdq)--->
							<cfinvokeargument name="readonly" 		value="true">
						</cfinvoke>
					</cfif>
					<cfif rsForm.recordCount EQ 0 OR Cantidad EQ 0>
						<div align="center">No Existen Datos Variables Asignados al Activo</div>
					</cfif>
				</fieldset>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2"><strong><cf_translate key="LB_FirmaResponsable">Firma Responsable</cf_translate>:______________________________</strong></td>
				  <td width="130" align="center"> <strong>Sello</strong></td>
			</tr>
			<!---<tr><td>&nbsp;</td></tr>--->
			<tr><td align="center"><strong>---- <cf_translate key="LB_FinDelDocumentoDeResponsabilidad">Fin del Documento de Responsabilidad</cf_translate> ----</strong></td></tr>
	  </table>

</cfoutput>
