<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Cantidad de líneas por página --->
<cfset max_lineas = 10 * 1.0>

<!--- Carga los datos que vienen por url --->
<cfif isdefined("url.ECOCid") and len(trim(url.ECOCid)) gt 0 and not isdefined("form.ECOCid")>
	<cfset form.ECOCid = url.ECOCid>
</cfif>
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) gt 0 and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) gt 0 and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>

<style type="text/css">
	.areaNumero {
		BORDER-RIGHT: #000000 2px solid;
		PADDING-RIGHT: 3px;
		BORDER-TOP: #000000 2px solid;
		PADDING-LEFT: 3px;
		PADDING-BOTTOM: 3px;
		BORDER-LEFT: #000000 2px solid;
		COLOR: #000000;
		PADDING-TOP: 3px;
		BORDER-BOTTOM: #000000 2px solid;
	}
</style>

<!--- Datos del encabezado del reporte --->

<!--- Datos del consolidado --->
<cfquery name="rsDatosConsolidado" datasource="#session.dsn#">
	select ecoc.ECOCnumero, ecoc.ECOCfechaconsolida
	from EConsolidadoOrdenCM ecoc
	where ecoc.ECOCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECOCid#">
		and ecoc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos del proveedor --->
<cfquery name="rsDatosProveedor" datasource="#session.dsn#">
	select  sn.SNnumero,
			sn.SNnombre,
			sn.SNidentificacion,
			sn.SNdireccion,
			coalesce(sn.SNtelefono, '') as SNtelefono,
			coalesce(sn.SNFax, '') as SNFax,
			coalesce(sn.SNemail,'') as SNemail
	from SNegocios sn
	where sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de la moneda --->
<cfquery name="rsDatosMoneda" datasource="#session.dsn#">
	select 	mon.Mnombre, 
			mon.Msimbolo
	from Monedas mon
	where mon.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and mon.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de la empresa --->
<cfquery name="rsDatosEmpresa" datasource="#session.dsn#">
	select  emps.Edescripcion, emp.Etelefono1, emp.Efax,
			dir.direccion1, dir.Ppais, dir.estado, dir.ciudad, dir.codPostal
	from Empresas emps
	
		inner join Empresa emp
			on emp.Ecodigo = emps.EcodigoSDC
			
			inner join Direcciones dir
				on dir.id_direccion = emp.id_direccion

	where emps.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de los detalles del reporte --->
<cfquery name="rsDatosDetalles" datasource="#session.dsn#">
	select  coalesce(ltrim(rtrim(docm.DOdescripcion)), '') as DescripcionDetalle,
			case docm.CMtipo when 'A' then coalesce(art.Acodigo, '') when 'S' then coalesce(conc.Ccodigo,'') else '' end as CodigoItem,
			case docm.CMtipo when 'A' then coalesce(docm.numparte, art.Acodalterno) else '' end as NumeroParte,
			sum(docm.DOcantidad - docm.DOcantsurtida) as CantidadPendiente,
			docm.Ucodigo,
			#LvarOBJ_PrecioU.enSQL_AS("docm.DOpreciou")#,
			coalesce(docm.DOporcdesc, 0.00) as DOporcdesc,
			docm.Icodigo, imp.Idescripcion, imp.Iporcentaje,
			sum(round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad), 2)) as Subtotal,
			sum(round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * docm.DOporcdesc / 100.00, 2)) as TotalDescuento,
			sum(round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * (1.00 - (docm.DOporcdesc / 100.00)) * imp.Iporcentaje / 100.00, 2)) as TotalImpuesto
	from EConsolidadoOrdenCM ecoc
		inner join DConsolidadoOrdenCM dcoc
			on dcoc.ECOCid = ecoc.ECOCid
			and dcoc.Ecodigo = ecoc.Ecodigo
			
		inner join EOrdenCM eo
			on eo.EOidorden = dcoc.EOidorden
			and eo.Ecodigo = dcoc.Ecodigo
			
			inner join DOrdenCM docm
				on docm.EOidorden = eo.EOidorden
				
			inner join Unidades uni
				on docm.Ecodigo = uni.Ecodigo
				and docm.Ucodigo = uni.Ucodigo
				
			inner join Impuestos imp
				on imp.Icodigo = docm.Icodigo
				and imp.Ecodigo = docm.Ecodigo
			
			left outer join Articulos art
				on art.Aid = docm.Aid
				and art.Ecodigo = docm.Ecodigo
	
			left outer join Conceptos conc
				on conc.Cid = docm.Cid
				and conc.Ecodigo = docm.Ecodigo

	where ecoc.ECOCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECOCid#">
		and ecoc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and eo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		and eo.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and eo.EOestado = 10
		and docm.DOcantidad > docm.DOcantsurtida
	
	group by docm.CMtipo, docm.Aid, docm.Cid, docm.ACcodigo, docm.ACid, 
		docm.DOdescripcion, art.Acodigo, conc.Ccodigo, docm.numparte, art.Acodalterno,
		docm.Ucodigo, 
		#LvarOBJ_PrecioU.enSQL("docm.DOpreciou")#, 
		docm.DOporcdesc, docm.Icodigo, imp.Idescripcion, imp.Iporcentaje
</cfquery>

<!--- Datos para el resumen del reporte --->
<cfquery name="rsDatosResumen" dbtype="query">
	select 	sum(Subtotal) as Subtotal,
			sum(TotalDescuento) as TotalDescuento,
			sum(TotalImpuesto) as TotalImpuesto

	from rsDatosDetalles
</cfquery>

<cfoutput>

	<!--- Encabezado del reporte --->
	<cfsavecontent variable="encabezado">
		<table width="100%" border="0" cellpadding="2"  cellspacing="0" align="center">
			<!--- Descripción de la empresa --->
			<tr>
				<td align="center"><strong><font size="2">#rsDatosEmpresa.Edescripcion#</font></strong></td>
			</tr>
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">Gerencia de Compras</font></td>
			</tr>
			<!--- Direccion de la empresa --->
			<tr>
				<td align="center" bgcolor="##CCCCCC"><font size="1">#rsDatosEmpresa.direccion1#</font></td>
			</tr>
			<tr>
				<td>
					<table width="98%" border="0" align="center">
						<tr align="center">
							<!--- Teléfono de la empresa --->
							<td nowrap align="right"><strong>Tel&eacute;fono:</strong></td>
							<td nowrap align="left">#rsDatosEmpresa.Etelefono1#</td>
							<!--- Fax de la empresa --->
							<td nowrap align="right"><strong>Fax:</strong></td>
							<td nowrap align="left">#rsDatosEmpresa.Efax#</td>
							<!--- Código postal de la empresa --->
							<td nowrap align="right"><strong>Apdo:</strong></td>
							<cfif len(trim(rsDatosEmpresa.codPostal)) gt 0>
								<td nowrap align="left">
									#rsDatosEmpresa.codPostal#,
									<cfif len(trim(rsDatosEmpresa.ciudad)) gt 0> #rsDatosEmpresa.ciudad#<cfelse> -- </cfif>,
									<cfif len(trim(rsDatosEmpresa.estado)) gt 0> #rsDatosEmpresa.estado#<cfelse> -- </cfif>,
									<cfif len(trim(rsDatosEmpresa.Ppais)) gt 0> #rsDatosEmpresa.Ppais#<cfelse> -- </cfif>
								</td>
							<cfelse>
								<td nowrap>&nbsp;</td>
							</cfif>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<!--- Número de consolidación --->
			<tr>
				<td align="center"><strong><font size="2">REPORTE RESUMIDO - CONSOLIDACION No: #rsDatosConsolidado.ECOCnumero#</font></strong></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<table width="85%" border="0" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<!--- Nombre del proveedor --->
							<td nowrap><strong>Proveedor:</strong></td>
							<td nowrap align="left">#rsDatosProveedor.SNnombre#</td>
							<!--- Fecha de consolidación --->
							<td nowrap><strong>Fecha de consolidación:</strong></td>
							<td nowrap align="left">#LSDateFormat(rsDatosConsolidado.ECOCfechaconsolida, 'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<!--- Cédula del proveedor --->
							<td nowrap><strong>C&eacute;dula Jur&iacute;dica:</strong></td>
							<td nowrap align="left">#rsDatosProveedor.SNidentificacion#</td>
							<!--- Moneda --->
							<td nowrap><strong>Moneda:</strong></td>
							<td nowrap align="left">#rsDatosMoneda.Mnombre#</td>
						</tr>
						<tr>
							<!--- Teléfono --->
							<td nowrap><strong>Telefono:</strong></td>
							<td nowrap align="left">#rsDatosProveedor.SNtelefono#</td>
							<!--- Fax --->
							<td nowrap><strong>Fax:</strong></td>
							<td nowrap align="left">#rsDatosProveedor.SNFax#</td>
						</tr>
						<tr>
							<td colspan="4" nowrap>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfsavecontent>
	
	<cfset contador = 0>

	<table width="98%" cellpadding="2" cellspacing="0" align="center">

		<cfloop query="rsDatosDetalles">

			<!--- Nombres de las columnas del reporte y encabezado --->
			<cfif (isdefined("url.imprimir") and contador eq max_lineas) or rsDatosDetalles.CurrentRow eq 1>
				<tr>
					<td colspan="10">#encabezado#</td>
				</tr>
				<tr class="titulolistas">
					<td><strong>Item</strong></td>
					<td nowrap><strong>## Parte</strong></td>
					<td><strong>Descripción</strong></td>
					<td align="right"><strong>Cantidad Pendiente</strong></td>
					<td align="right"><strong>Cantidad Recibida</strong> </td>
					<td><strong>UM</strong></td>
					<td align="right"><strong>Precio Unit</strong></td>
					<td align="right" nowrap><strong>%Desc.</strong></td>
					<td align="right"><strong>%Imp.</strong></td>
					<td align="right"><strong>Subtotal</strong></td>
				</tr>
				<cfset contador = 0>
			</cfif>
			
			<!--- Listado de detalles --->
			<tr>
				<!--- Códito ítem --->
				<td><cfif len(trim(rsDatosDetalles.CodigoItem)) gt 0>#rsDatosDetalles.CodigoItem#<cfelse>N/A</cfif></td>
				<!--- Número de parte --->
				<td>#rsDatosDetalles.NumeroParte#</td>
				<!--- Descripción de la línea --->
				<td>#rsDatosDetalles.DescripcionDetalle#</td>
				<!--- Cantidad pendiente --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.CantidadPendiente, ',9.00')#</td>
				<td>&nbsp;</td>
				<!--- Unidad de medida --->
				<td>#rsDatosDetalles.Ucodigo#</td>
				<!--- Precio unitario --->
				<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDatosDetalles.DOpreciou)#</td>
				<!--- Porcentaje descuento --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.DOporcdesc, ',9.00')#%</td>
				<!--- Impuesto --->
				<td align="right" nowrap>
					<cfif len(trim(rsDatosDetalles.Icodigo)) gt 0>
						#LSNumberFormat(rsDatosDetalles.Iporcentaje, ',9.00')#%
					</cfif>				</td>
				<!--- Subtotal de la línea --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.Subtotal, ',9.00')#</td>
			</tr>
			
			<cfif isdefined("url.imprimir") and rsDatosDetalles.CurrentRow neq rsDatosDetalles.RecordCount and rsDatosDetalles.CurrentRow mod max_lineas eq 0>
				<tr>
					<td colspan="10" nowrap>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="10" align="right">
						<strong>Pág. #Int(rsDatosDetalles.CurrentRow / max_lineas)# / #Ceiling(rsDatosDetalles.RecordCount / max_lineas)#</strong>					</td>
				</tr>
				<tr class="pageEnd">
					<td colspan="10">&nbsp;</td>
				</tr>
			</cfif>

			<cfset contador = contador + 1>
		</cfloop>
		
		<cfif rsDatosResumen.RecordCount gt 0>

			<tr>
				<td colspan="10">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="10">&nbsp;</td>
			</tr>
			
			<!--- Resumen del consolidado --->
			
			<!--- Subtotal --->
			<tr>
				<td colspan="8">&nbsp;</td>
				<td nowrap align="right"><strong>Subtotal:</strong></td>
				<td align="right">#LSNumberFormat(rsDatosResumen.Subtotal, ',9.00')#</td>
			</tr>
			
			<!--- Total descuento --->					
			<tr>
				<td colspan="8">&nbsp;</td>
				<td align="right"><strong>Descuento:</strong></td>
				<td align="right">#LSNumberFormat(rsDatosResumen.TotalDescuento, ',9.00')#</td>
			</tr>
			
			<!--- Total impuestos --->
			<tr>
				<td colspan="8">&nbsp;</td>
				<td align="right"><strong>Impuestos:</strong></td>
				<td align="right">#LSNumberFormat(rsDatosResumen.TotalImpuesto, ',9.00')#</td>
			</tr>
			
			<!--- Total --->
			<tr>
				<td colspan="8">&nbsp;</td>
				<td align="right"><strong>Total:</strong></td>
				<td align="right">#LSNumberFormat(rsDatosResumen.Subtotal - rsDatosResumen.TotalDescuento + rsDatosResumen.TotalImpuesto, ',9.00')#</td>
			</tr>
			
			<cfif isdefined("url.imprimir")>
				<tr>
					<td colspan="10" nowrap>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="10" align="right">
						<strong>Pág. #Ceiling(rsDatosDetalles.RecordCount / max_lineas)# / #Ceiling(rsDatosDetalles.RecordCount / max_lineas)#</strong>					</td>
				</tr>
				<tr class="pageEnd">
					<td colspan="10">&nbsp;</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="10" nowrap>&nbsp;</td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="10" nowrap align="center"><strong>Este documento no tiene valor comercial</strong></td>
			</tr>
			<tr>
				<td colspan="10">&nbsp;</td>
			</tr>
		</cfif>
	</table>

</cfoutput>
