<!--- <cf_dump var="#form#"> --->

<!--- JMRV. 12/08/2014. --->

<cfset ListaImg = "JPG,BMP,GIF,PNG">
<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">
	
<!--- Validaciones --->
<cfif not isdefined("form.Ecodigo") >
	<cfset form.Ecodigo = #session.Ecodigo#>
</cfif>

<cfif isdefined("url.Auto") and len(trim(url.Auto))>
	<cfset form.Auto = url.Auto>
</cfif>

<cfif not isdefined("form.Auto")>
	<cfset form.Auto = 'N'>
</cfif>

<cfif isdefined("url.CTContid") and len(trim(url.CTContid)) and not isdefined('form.CTContid')>
		<cfset form.CTContid = url.CTContid>
	</cfif>

<cfif form.Auto eq 'S'>
	<cfif isdefined("url.CTContid") and len(trim(url.CTContid))>
		<cfset form.CTContid = url.CTContid>
	</cfif>

	<cfset form.Ecodigo = #session.Ecodigo#>
	<cfset form.consulta = 'S'>

	<cf_templatecss>
	<title>Informaci&oacute;n del Contrato</title>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Descripci&oacute;n del Contrato'>
</cfif>


<!--- Trae el encabezado del contrato --->
<cfquery name="rsContrato" datasource="#Session.DSN#">
	select 	a.CTCnumContrato, a.CTContid, a.CTCdescripcion, a.CTPCid, 
			a.CTFLid, a.CTmonto, a.SNid,
			a.CTfechaFirma, a.CTfechaIniVig, a.CTfechaFinVig, a.CTmonto * a.CTtipoCambio as CTmontoLoc, 
			case	
				when a.CTCestatus = 0 then 'En proceso'
				when a.CTCestatus = 1 then 'Aplicado'
				when a.CTCestatus = 2 then 'Cancelado'
				else 'Sin Estatus'
			end as estatus
			
	from 	CTContrato a
				
	where 	a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
	and      a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("rsContrato.SNid") and rsContrato.SNid neq "">
<!--- Trae la descripcion del proveedor --->
	<cfquery name="rsProveedor" datasource="#Session.DSN#">
		select SNnombre 
		from SNegocios
		where   SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.SNid#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("rsContrato.CTFLid") and rsContrato.CTFLid neq "">
	<!--- Trae la descripcion de Fundamento legal --->
	<cfquery name="rsFundamentoLegal" datasource="#Session.DSN#">
		select CTFLdescripcion
		from CTFundamentoLegal
		where CTFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.CTFLid#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("rsContrato.CTPCid") and rsContrato.CTPCid neq "">
	<!--- Trae la descripcion de Procedimiento de contratacion --->
	<cfquery name="rsProcedimientoContratacion" datasource="#Session.DSN#">
		select CTPCdescripcion
		from CTProcedimientoContratacion
		where CTPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.CTPCid#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>


<!--- Pintado de la Información --->
<cfoutput>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
    <td valign="top" alang="center">
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
		
				<!--- Encabezado del reporte --->
				<tr><td nowrap>&nbsp;</td></tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td><strong><font size=2>Informaci&oacute;n General</font></strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td nowrap align="left"><font size=2>Numero de Contrato:</font></td>
					<td><font size=2>#rsContrato.CTCnumContrato#</font></td>

					<td nowrap align="left"><font size=2>Descripci&oacute;n:</font></td>
						<cfif isdefined("rsContrato.CTCdescripcion")>
					<td><font size=2>#rsContrato.CTCdescripcion#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				</tr>
				<tr>
					<td nowrap align="left"><font size=2>Estatus:</font></td>
						<cfif isdefined("rsContrato.estatus")>
					<td><font size=2>#rsContrato.estatus#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>

					<td nowrap align="left"><font size=2>Procedimiento de Contrataci&oacute;n:</font></td>
						<cfif isdefined("rsProcedimientoContratacion.CTPCdescripcion")>
					<td><font size=2>#rsProcedimientoContratacion.CTPCdescripcion#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				</tr>
				<tr>
					<td nowrap align="left"><font size=2>Fundamento Legal:</font></td>
						<cfif isdefined("rsFundamentoLegal.CTFLdescripcion")>
					<td><font size=2>#rsFundamentoLegal.CTFLdescripcion#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>

					<td nowrap align="left"><font size=2>Importe Contrato:</font></td>
						<cfif isdefined("rsContrato.CTmonto")>
					<td><font size=2>#LSNumberFormat(rsContrato.CTmonto, ',9.00')#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				</tr>
				<tr>
					<td nowrap align="left"><font size=2>Proveedor:</font></td>
						<cfif isdefined("rsProveedor.SNnombre")>
					<td><font size=2>#rsProveedor.SNnombre#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>

					
					<td nowrap align="left"><font size=2>Importe Local:</font></td>
						<cfif isdefined("rsContrato.CTmonto")>
					<td><font size=2>#LSNumberFormat(rsContrato.CTmontoLoc, ',9.00')#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
		       </tr>
			   <tr>
					<td nowrap align="left"><font size=2>Fecha de Firma:</font></td>
						<cfif isdefined("rsContrato.CTfechaFirma")>
				  	<td><font size=2>#LSDateFormat(rsContrato.CTfechaFirma,'dd/mm/yyyy')#</font></td>
				  		<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				
					<td nowrap align="left"><font size=2>Inicio de Vigencia:</font></td>
						<cfif isdefined("rsContrato.CTfechaIniVig")>
					<td><font size=2>#LSDateFormat(rsContrato.CTfechaIniVig,'dd/mm/yyyy')#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>	
					<td>
						&nbsp;
					</td>			
					<td nowrap align="left"><font size=2>Fin de Vigencia:</font></td>
						<cfif isdefined("rsContrato.CTfechaFinVig")>
					<td><font size=2>#LSDateFormat(rsContrato.CTfechaFinVig,'dd/mm/yyyy')#</font></td>
						<cfelse>
					<td><font size=2>- - - -</font></td>
						</cfif>
				</tr>
			</table>
				
				
			<table width="100%" cellpadding="2" cellspacing="0" align="center">	
				<!--- Detalle del reporte --->
				
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td><strong><font size=2>Detalle</font></strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>
				
				<tr>
					<td nowrap align="left"><strong><font size="2">Periodo Presupuestal</font></strong></td>
					<td nowrap align="left"><strong><font size="2">Año</font></strong></td>
					<td nowrap align="left"><strong><font size="2">Mes</font></strong></td>
					<td nowrap align="left"><strong><font size="2">Item</font></strong></td>
					<td nowrap align="left"><strong><font size="2">Cuenta Presupuestal</font></strong></td>
					<td nowrap align="center"><strong><font size="2">Monto Contrato</font></strong></td>
					<td nowrap align="center"><strong><font size="2">Monto Total</font></strong></td>
					<td nowrap align="center"><strong><font size="2">Monto Consumido</font></strong></td>
					<td nowrap align="left"><strong><font size="2">Orden de Compra/Factura</font></strong></td>
				</tr>
				
		<!--- Trae los detalles del contrato --->
		<cfquery name="rsContratoDetalle" datasource="#Session.DSN#">
			select 	b.CTDCont, b.CPCano, b.CPCmes,
					b.CPcuenta, b.CTDCmontoTotal, b.CTDCmontoConsumido,
					b.CMtipo, dist.CPDCdescripcion,
					case
						when b.CMtipo = 'S' then 'Servicio'
						when b.CMtipo = 'F' then 'Activo Fijo'
						when b.CMtipo = 'C' then 'Clasificacion Inventario'
						else 'Otro'
					end as Item, 
					b.CTDCmontoTotalOri
					
			from 	CTDetContrato b
			
			left join CPDistribucionCostos dist
			on b.CPDCid = dist.CPDCid
						
			where 	b.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
			and      b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- Pintado de cada detalle --->
		<cfloop query="rsContratoDetalle">
			
			<cfif isdefined("rsContratoDetalle.CPcuenta") and rsContratoDetalle.CPcuenta neq "">
				<!--- Trae la cuenta presupuestal --->
				<cfquery name="rsCuentaPresupuestal" datasource="#Session.DSN#">
					select CPformato
					from CPresupuesto
					where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDetalle.CPcuenta#">
					and    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
			</cfif>
			
			<!--- Trae las ordenes de compra que estan ligadas al contrato --->
				<cfquery name="rsDOrdenCM" datasource="#Session.DSN#">
					select EOidorden, DOtotal, EOnumero
					from DOrdenCM
					where CTDContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDetalle.CTDCont#">
					and     Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			<!--- Trae las facturas que estan ligadas al contrato --->
				<cfquery name="rsDDocumentosCxP" datasource="#Session.DSN#">
					select IDdocumento as IDdocumento, DDtotallinea as Monto
					from DDocumentosCxP
					where CTDContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDetalle.CTDCont#">
					and     Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					
						union	
					
					select IDdocumento as IDdocumento, DDtotallin as Monto
					from HDDocumentosCP
					where CTDContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDetalle.CTDCont#">
					and     Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
				<!--- Trae las liberaciones que estan ligadas al contrato --->
				<cfquery name="rsCTDetLiberacion" datasource="#Session.DSN#">
					select CTDContL, Monto
					from CTDetLiberacion
					where CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDetalle.CTDCont#">
					and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
				<tr>
						<cfif isdefined("Form.PeriodoPres")>
					<td align="left"><font size="2">#Form.PeriodoPres#</font></td>
						<cfelse>
					<td align="left"><font size="2">- - - -</font></td>
						</cfif>

						<cfif isdefined("rsContratoDetalle.CPCano")>
					<td align="left"><font size="2">#rsContratoDetalle.CPCano#</font></td>
						<cfelse>
					<td align="left"><font size="2">- - - -</font></td>
						</cfif>

						<cfif isdefined("rsContratoDetalle.CPCmes")>
					<td align="left"><font size="2">#rsContratoDetalle.CPCmes#</font></td>
						<cfelse>
					<td align="left"><font size="2">- - - -</font></td>
						</cfif>
						
						<cfif isdefined("rsContratoDetalle.Item")>
					<td align="left"><font size="2">#rsContratoDetalle.Item#</font></td>
						<cfelse>
					<td align="left"><font size="2">- - - -</font></td>
						</cfif>

						<cfif isdefined("rsCuentaPresupuestal.CPformato") and rsCuentaPresupuestal.CPformato neq "">
					<td align="left"><font size="2">#rsCuentaPresupuestal.CPformato#</font></td>
						<cfelseif isdefined("rsContratoDetalle.CPDCdescripcion") and rsContratoDetalle.CPDCdescripcion neq "">
					<td align="left"><font size="1">DISTRIBUCION #rsContratoDetalle.CPDCdescripcion#</font></td>
						<cfelse>
					<td align="left"><font size="2">- - - -</font></td>
						</cfif>
						
						<cfif isdefined("rsContratoDetalle.CTDCmontoTotal") and rsContratoDetalle.CTDCmontoTotalOri neq "">
					<td align="right"><font size="2">#LSNumberFormat(rsContratoDetalle.CTDCmontoTotalOri, ',9.00')#</font></td>
						<cfelse>
					<td align="right"><font size="2">0</font></td>
						</cfif>
						
						<cfif isdefined("rsContratoDetalle.CTDCmontoTotal") and rsContratoDetalle.CTDCmontoTotal neq "">
					<td align="right"><font size="2">#LSNumberFormat(rsContratoDetalle.CTDCmontoTotal, ',9.00')#</font></td>
						<cfelse>
					<td align="right"><font size="2">0</font></td>
						</cfif>
	
						<cfif isdefined("rsContratoDetalle.CTDCmontoConsumido") and rsContratoDetalle.CTDCmontoConsumido neq "">
					<td align="right"><font size="2">#LSNumberFormat(rsContratoDetalle.CTDCmontoConsumido, ',9.00')#</font></td>
						<cfelse>
					<td align="right"><font size="2">0</font></td>
						</cfif>

						<cfif isdefined("rsDOrdenCM") and rsDOrdenCM.RecordCount gt 0>
							<cfloop query="rsDOrdenCM">
								<td align="center"><font size="2"> No. de Orden: #rsDOrdenCM.EOnumero#</font></td><tr></tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
								<td nowrap>&nbsp;</td>
								<td align="center"><font size="2"> Monto: #LSNumberFormat(rsDOrdenCM.DOtotal, ',9.00')#</font></td><tr></tr><tr><td nowrap>&nbsp;</td></tr><td></td><td></td><td></td><td><td></td></td><td></td>
								</cfloop>

						<cfelseif isdefined("rsDDocumentosCxP") and rsDDocumentosCxP.RecordCount gt 0>
							<cfloop query="rsDDocumentosCxP">
								<td align="center"><font size="2"> No. de Factura: #rsDDocumentosCxP.IDdocumento#</font></td><tr></tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
								<td nowrap>&nbsp;</td>
								<td align="center"><font size="2"> Monto: #LSNumberFormat(rsDDocumentosCxP.Monto, ',9.00')#</font></td><tr></tr><tr><td nowrap>&nbsp;</td></tr><td></td><td></td><td></td><td></td><td></td><td></td>
								</cfloop></td>
						
						<cfelseif isdefined("rsCTDetLiberacion") and rsCTDetLiberacion.RecordCount gt 0>
							<cfloop query="rsCTDetLiberacion">
								<td align="center"><font size="2"> No. de Liberacion: #rsCTDetLiberacion.CTDContL#</font></td><tr></tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
								<td nowrap>&nbsp;</td>
								<td align="center"><font size="2"> Monto: #LSNumberFormat(rsCTDetLiberacion.Monto, ',9.00')#</font></td><tr></tr><tr><td nowrap>&nbsp;</td></tr><td></td><td></td><td></td><td></td><td></td><td></td>
								</cfloop></td>
						<cfelse>
					<td align="center"><font size="2">- - - -</font></td>
						</cfif>
						
				</tr>
				<!---<tr><td nowrap>&nbsp;</td></tr>--->
			</cfloop>
				
		</table>
	<br>
	</td>
	</tr>
	</table>

</cfoutput>