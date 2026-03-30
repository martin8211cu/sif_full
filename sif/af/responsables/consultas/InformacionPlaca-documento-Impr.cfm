<!--- Parámetro Requerido para el conlis --->
<cftry>
	<cfparam name="url.id">
	<cfcatch>
		<cf_errorCode	code = "50126" msg = "No se encontró el parámetro requerido para ver la información de esta pantalla (Código de Activo). Proceso cancelado!">
	</cfcatch>
</cftry>
<cf_templatecss/>
<cfparam name="url.id" type="numeric" default="-1">
<!--- Fuente para la impresion del documento en Inclusion de documentos --->
<!--- Consulta del modo cambio o precarga para llenar campos con valores iniciales ya sea en modo cambio para una 
modificación o en modo precarga para dar de alta un nuevo registro --->
<cfquery name="rsForm" datasource="#session.dsn#">
	select 
    	a.CRDRdescripcion, 
        a.AFRfini as CRDRfdocumento, 
        a.CRDRdescdetallada, 
        a.CRDRtipodocori, 
        a.CRDRdocori, 
        a.CRDRlindocori, 
        a.Monto, 
		act.Aplaca as CRDRplaca, 
        act.Aserie as CRDRserie, 
		d.DEidentificacion, <cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre"> as DEnombrecompleto, 
        ( select min(b.CRTDcodigo) from CRTipoDocumento b where b.CRTDid = a.CRTDid) as CRTDcodigo, 
        ( select min(b.CRTDdescripcion) from CRTipoDocumento b where b.CRTDid = a.CRTDid) as CRTDdescripcion, 
        ( select min(c.CRTCcodigo) from CRTipoCompra c where c.CRTCid = a.CRTCid) as CRTCcodigo, 
        ( select min(c.CRTCdescripcion) from CRTipoCompra c where c.CRTCid = a.CRTCid) as CRTCdescripcion, 
        e.CFcodigo, e.CFdescripcion,
        f.CRCCcodigo, f.CRCCdescripcion,
        g.ACcodigo,g.ACcodigodesc,g.ACdescripcion,g.ACmascara,
        h.ACid,h.ACcodigodesc as Cat_ACcodigodesc,h.ACdescripcion as Cat_ACdescripcion,
        act.AFCcodigo, 
        ( select min(i.AFCcodigoclas ) from AFClasificaciones i where i.Ecodigo     = act.Ecodigo and i.AFCcodigo = act.AFCcodigo) as AFCcodigoclas, 
        ( select min(i.AFCdescripcion ) from AFClasificaciones i where i.Ecodigo     = act.Ecodigo and i.AFCcodigo = act.AFCcodigo) as AFCdescripcion,
        act.AFMid,
        ( select min(j.AFMcodigo) from AFMarcas j where j.AFMid = act.AFMid) as AFMcodigo,     ( select min(j.AFMdescripcion) from AFMarcas j where j.AFMid = act.AFMid) as AFMdescripcion,
        act.AFMMid,
        ( select min(k.AFMMcodigo) from AFMModelos k where k.AFMMid = act.AFMMid) as AFMMcodigo, ( select min(k.AFMMdescripcion) from AFMModelos k where k.AFMMid = act.AFMMid) as AFMMdescripcion,
        ( select min(l.EOnumero) from DOrdenCM l where a.DOlinea = l.DOlinea) as  EOnumero, ( select min(l.DOconsecutivo) from DOrdenCM l where a.DOlinea = l.DOlinea) as DOconsecutivo
	from AFResponsables a 
		inner join Activos act
		on act.Aid = a.Aid

			inner join ACategoria g 
				on act.Ecodigo = g.Ecodigo
				and act.ACcodigo = g.ACcodigo

			inner join AClasificacion h 
				on act.Ecodigo = h.Ecodigo
				and act.ACid = h.ACid
				and act.ACcodigo = h.ACcodigo

			inner join DatosEmpleado d on
				d.DEid = a.DEid
			inner join CFuncional e on
				e.CFid = a.CFid
			inner join CRCentroCustodia f on
				f.CRCCid = a.CRCCid
	where a.AFRid = #url.id#
</cfquery>
<cfif rsForm.recordcount eq 0>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select 
        	a.CRDRdescripcion, 
            a.CRDRfdocumento, 
            a.CRDRdescdetallada, 
            a.CRDRtipodocori, 
            a.CRDRdocori, 
            a.CRDRlindocori, 
            a.Monto,
            a.CRDRplaca, 
            a.CRDRserie, 
            b.CRTDcodigo, 
            b.CRTDdescripcion, 
            c.CRTCcodigo, 
            c.CRTCdescripcion, 
            d.DEidentificacion, 
            <cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre"> as DEnombrecompleto, 
            e.CFcodigo, 
            e.CFdescripcion,
            f.CRCCcodigo, 
            f.CRCCdescripcion,
            g.ACcodigo,
            g.ACcodigodesc,
            g.ACdescripcion,
            g.ACmascara,
            h.ACid,
            h.ACcodigodesc as Cat_ACcodigodesc,
            h.ACdescripcion as Cat_ACdescripcion,
            i.AFCcodigo,
            i.AFCcodigoclas,
            i.AFCdescripcion,
            j.AFMid,
            j.AFMcodigo,
            j.AFMdescripcion,
            k.AFMMid,
            k.AFMMcodigo,
            k.AFMMdescripcion,
            l.EOnumero, 
            l.DOconsecutivo
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
        where CRDRid = #url.id#
    </cfquery>
</cfif>
<!--- Pintado del formulario --->
<cfoutput>
		<!--- Encabezado --->
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr><td>
				<cfif not isdefined("url.imprimir")>
					<cfset paramsUri = ''>
					<cfset paramsUri = paramsUri & '&imprimir=true&id=#url.id#'>
					<cf_rhimprime datos="/sif/af/responsables/consultas/InformacionPlaca-documento-Impr.cfm" paramsuri="#paramsUri#">
				</cfif>
			</td></tr>
			<tr><td><hr></td></tr>
			<tr><td  align="center"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
			<tr><td  align="center"><strong><cf_translate key="LB_DocumentoDeResponsabilidad">Documento de Responsabilidad</cf_translate></strong></td></tr>
			<tr><td  align="center"><strong><cf_translate key="LB_Usuario">Usuario</cf_translate>: #session.datos_personales.Nombre# #session.datos_personales.Apellido1# #session.datos_personales.Apellido2#</strong></td></tr>
			<tr><td  align="center"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>: #trim(LSDateFormat(Now(),'dd/mm/yyyy'))# #trim(LSTimeFormat(Now(),'HH:mm:ss'))#</strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><hr></td></tr>
		</table>
		<table align="center" border="0" cellspacing="0" cellpadding="2">
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr><td nowrap="NOWRAP" class="fileLabel"><strong><cf_translate key="LB_CentroDeCustodia">Centro de Custodia</cf_translate>:</strong>&nbsp;#rsform.CRCCdescripcion#</td></tr>		
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
										<p><strong><cf_translate key="LB_Placa">Placa</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#rsForm.CRDRplaca#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></p>
									</td>
									<td>#HTMLEditFormat(rsForm.CRDRdescripcion)#</td>
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
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_DescripcionDetallada">Descripci&oacute;n Detallada</cf_translate>:</strong>&nbsp;</p></td>
									<td>#HTMLEditFormat(rsForm.CRDRdescdetallada)#</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Serie">Serie</cf_translate>:&nbsp;</strong></p></td>
									<td>#HTMLEditFormat(rsForm.CRDRserie)#</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
									<td nowrap="nowrap" class="fileLabel"><p><strong><cf_translate key="LB_Monto">Monto</cf_translate>:&nbsp;</strong></p></td>
									<td>#LSCurrencyFormat(rsForm.Monto,'none')#</td>
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
			<tr>
				<td><strong><cf_translate key="LB_FirmaResponsable">Firma Responsable</cf_translate>:___________________________________</strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong>---- <cf_translate key="LB_FinDelDocumentoDeResponsabilidad">Fin del Documento de Responsabilidad</cf_translate> ----</strong></td></tr>
	  </table>
</cfoutput>

