<!--- Obtiene la información del encabezado --->
<cfquery name="rsInfoEncabezado" datasource="#session.dsn#">
	select  edr.EDRid, edr.Mcodigo, edr.EDRtc, edr.Aid, edr.CFid, edr.EDRnumero,
			edr.EDRfechadoc, edr.EDRfecharec, edr.SNcodigo, edr.EDRreferencia,
			edr.EDRdescpro, edr.EDRimppro, edr.EDRobs, edr.ts_rversion, tdr.TDRdescripcion,
			cpt.CPTdescripcion, mon.Mnombre, cf.CFcodigo, cf.CFdescripcion, alm.Almcodigo,
			alm.Bdescripcion, sn.SNnumero, sn.SNnombre
			
	from EDocumentosRecepcion edr
	
		inner join TipoDocumentoR tdr
			on tdr.TDRcodigo = edr.TDRcodigo
			and tdr.Ecodigo = edr.Ecodigo

		left outer join CPTransacciones cpt
			on cpt.CPTcodigo = edr.CPTcodigo
			and cpt.Ecodigo = edr.Ecodigo

		inner join Monedas mon
			on mon.Mcodigo = edr.Mcodigo
			and mon.Ecodigo = edr.Ecodigo
			
		left outer join CFuncional cf
			on cf.CFid = edr.CFid
			and cf.Ecodigo = edr.Ecodigo
			
		left outer join Almacen alm
			on alm.Aid = edr.Aid
			and alm.Ecodigo = edr.Ecodigo
			
		inner join SNegocios sn
			on sn.SNcodigo = edr.SNcodigo
			and sn.Ecodigo = edr.Ecodigo
			
	where edr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
</cfquery>

<cfoutput>
<form action="docsAprobarExcTolerancia-sql.cfm" method="post" name="formEncabezado" onSubmit="javascript: sinbotones();">
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<!--- Socio de negocios --->
					<td align="right"><strong>Socio de Negocios:</strong>&nbsp;</td>
					<td>#rsInfoEncabezado.SNnumero# - #rsInfoEncabezado.SNnombre#</td>
					
					<!--- Observaciones --->
				    <td><strong>Observaciones:</strong>&nbsp;</td>
				    <td>
						<input type="hidden" name="EDRobs" value="#trim(rsInfoEncabezado.EDRobs)#">
						<a href="javascript:info('formEncabezado', 'EDRobs', false);"><img border="0" src="../../imagenes/iedit.gif" alt="Ver Observaciones"></a>
					</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				</tr>

				<tr>
					<!--- Número de la recepción --->
					<td align="right"><strong>N&uacute;mero:</strong>&nbsp;</td>
					<td>#trim(rsInfoEncabezado.EDRnumero)#</td>
					
					<!--- Tipo del documento --->
					<td align="right"><strong>Tipo:</strong>&nbsp;</td>
					<td>#rsInfoEncabezado.TDRdescripcion#</td>
					
					<!--- Tran. CxP --->
					<td align="right"><strong>Tran. CxP:</strong>&nbsp;</td>
					<td>#rsInfoEncabezado.CPTdescripcion#</td>
				</tr>

				<tr>
					<!--- Referencia --->
					<td align="right"><strong>Referencia:</strong>&nbsp;</td>
					<td>#trim(rsInfoEncabezado.EDRreferencia)#</td>
					
					<!--- Moneda --->
					<td align="right"><strong>Moneda O.C.:</strong>&nbsp;</td>
					<td>#rsInfoEncabezado.Mnombre#</td>
					
					<!--- Tipo de cambio --->
					<td align="right"><strong>Tipo de Cambio:</strong>&nbsp;</td>
					<td>#LSNumberFormat(rsInfoEncabezado.EDRtc,',9.0000')#</td>
				</tr>
				
				<tr>
					<!--- Fecha del documento --->
					<td align="right"><strong>Fecha:</strong>&nbsp;</td>
					<td nowrap>#LSDateFormat(rsInfoEncabezado.EDRfechadoc,'dd/mm/yyyy')#</td>
					
					<!--- Fecha de la recepción --->
					<td align="right"><strong>Recepci&oacute;n:</strong>&nbsp;</td>
					<td nowrap>#LSDateFormat(rsInfoEncabezado.EDRfecharec,'dd/mm/yyyy')#</td>
					
					<!--- Descuento --->
					<td align="right"><strong>Descuento:</strong>&nbsp;</td>
					<td>#LSNumberFormat(rsInfoEncabezado.EDRdescpro,',9.0000')#</td>
				</tr>

				<tr>
					<!--- Centro Funcional --->
					<td align="right"><strong>C. Funcional:</strong>&nbsp;</td>
					<td>
						 <cfif len(trim(rsInfoEncabezado.CFid)) gt 0>
							 #trim(rsInfoEncabezado.CFcodigo)# - #trim(rsInfoEncabezado.CFdescripcion)#
						 <cfelse>
							---
						 </cfif>
					</td>
					
					<!--- Almacén --->
					<td align="right"><strong>Almac&eacute;n:</strong>&nbsp;</td>
					<td>
						<cfif len(trim(rsInfoEncabezado.Aid)) gt 0>
							#rsInfoEncabezado.Almcodigo# - #rsInfoEncabezado.Bdescripcion#
						<cfelse>
							---
						</cfif>
					</td>
					
					<!--- Impuesto --->
					<td align="right"><strong>Impuesto:</strong>&nbsp;</td>
					<td>#LSNumberFormat(rsInfoEncabezado.EDRimppro,',9.00')#</td>
				</tr>
				
				<input type="hidden" name="EDRid" value="#form.EDRid#">
				<input type="hidden" name="Opcion" value="">
				
				<!--- Se guardan los filtros para no perderlos al hacer click en Aprobar --->
				<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) gt 0>
					<input type="hidden" name="numparteF" value="#form.numparteF#">
				</cfif>
				<cfif isdefined("form.DOalternaF") and len(trim(form.DOalternaF)) gt 0>
					<input type="hidden" name="DOalternaF" value="#form.DOalternaF#">
				</cfif>
				<cfif isdefined("form.DOobservacionesF") and len(trim(form.DOobservacionesF)) gt 0>
					<input type="hidden" name="DOobservacionesF" value="#form.DOobservacionesF#">
				</cfif>
				<cfif isdefined("form.AcodigoF") and len(trim(form.AcodigoF)) gt 0>
					<input type="hidden" name="AcodigoF" value="#form.AcodigoF#">
				</cfif>
				<cfif isdefined("form.DOdescripcionF") and len(trim(form.DOdescripcionF)) gt 0>
					<input type="hidden" name="DOdescripcionF" value="#form.DOdescripcionF#">
				</cfif>
				<cfif isdefined("form.CMCid1")>
					<input type="hidden" name="CMCid1" value="#form.CMCid1#">
				</cfif>
				<cfif isdefined("form.Reclamo") and len(trim(form.Reclamo)) gt 0>
					<input type="hidden" name="Reclamo" value="#form.Reclamo#">
				</cfif>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
<!--- 			<input type="submit" name="btnAprobarLineas" value="Aprobar Líneas" onClick="javascript: document.formEncabezado.Opcion.value='AprobarLineasFiltro'"> --->
			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: funcRegresar()">
		</td>
	</tr>
</table>
</form>

</cfoutput>
