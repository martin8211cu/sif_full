<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
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
	select emp.Edescripcion
	from Empresas emp
	where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de los detalles del reporte --->
<cfquery name="rsDatosDetalles" datasource="#session.dsn#">
	select  eo.EOidorden, eo.EOnumero, eo.Observaciones, eo.EOlugarentrega,
			docm.DOconsecutivo, 
			cf.CFdescripcion, cms.CMSnombre,
			case docm.CMtipo when 'A' then coalesce(art.Acodigo, '') when 'S' then coalesce(conc.Ccodigo,'') else '' end as CodigoItem,
			coalesce(ltrim(rtrim(docm.DOdescripcion)), '') as DescripcionDetalle,
			docm.DOcantidad - docm.DOcantsurtida as CantidadPendiente,
			docm.Ucodigo,
			#LvarOBJ_PrecioU.enSQL_AS("docm.DOpreciou")#,
			coalesce(docm.DOporcdesc, 0.00) as DOporcdesc,
			docm.Icodigo, imp.Idescripcion, imp.Iporcentaje,
                round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad), 2)
                - round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * (docm.DOporcdesc / 100.00), 2)
                + round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * (1.00 - (docm.DOporcdesc / 100.00)) * (imp.Iporcentaje / 100.00), 2) 
            as Total
	from EConsolidadoOrdenCM ecoc
		inner join DConsolidadoOrdenCM dcoc
			on dcoc.ECOCid = ecoc.ECOCid
			and dcoc.Ecodigo = ecoc.Ecodigo
			
		inner join EOrdenCM eo
			on eo.EOidorden = dcoc.EOidorden
			and eo.Ecodigo = dcoc.Ecodigo
			
			inner join DOrdenCM docm
				on docm.EOidorden = eo.EOidorden
				
				left outer join ESolicitudCompraCM es
					on es.ESidsolicitud = docm.ESidsolicitud
					and es.Ecodigo = docm.Ecodigo
					
					left outer join CMSolicitantes cms
						on cms.CMSid = es.CMSid
						and cms.Ecodigo = es.Ecodigo
				
				inner join CFuncional cf
					on cf.CFid = docm.CFid
					and cf.Ecodigo = docm.Ecodigo
				
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
	
	order by eo.EOnumero, docm.DOconsecutivo
</cfquery>

<cfoutput>

	<!--- Encabezado del reporte --->
	<cfsavecontent variable="encabezado">
		<table width="100%" border="0" cellpadding="2"  cellspacing="0" align="center">
			<tr>
				<td class="tituloAlterno" align="center"><strong>#rsDatosEmpresa.Edescripcion#</strong></td>
			</tr>
			<tr>
				<td class="letra" align="center"><b><font size="2">Reporte Detallado - Consolidación No: #rsDatosConsolidado.ECOCnumero#</font></b></td>
			</tr>
			<tr>
				<td class="letra" align="center"><b><font size="2">Proveedor: #rsDatosProveedor.SNnombre# - #rsDatosProveedor.SNidentificacion#</font></b></td>
			</tr>
			<tr>
				<td class="letra" align="center"><b><font size="2">Moneda: #rsDatosMoneda.Mnombre#</font></b></td>
			</tr>
			<tr>
				<td class="letra" align="center"><b>Fecha de consolidación: #LSDateFormat(rsDatosConsolidado.ECOCfechaconsolida, 'dd/mm/yyyy')#</b></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	</cfsavecontent>
	
	<table width="98%" cellpadding="2" cellspacing="0" align="center">
	
		<cfset ordenActual = 0>
		<cfset totalOrden = 0>
		<cfset totalPedido = 0>
		
		<tr>
			<td colspan="12">#encabezado#</td>
		</tr>
		
		<cfloop query="rsDatosDetalles">
		
			<cfif ordenActual neq rsDatosDetalles.EOnumero>
			
				<cfset ordenActual = rsDatosDetalles.EOnumero>
			
				<!--- Pinta los cortes por orden de compra --->
				<cfif rsDatosDetalles.CurrentRow neq 1>
					<tr>
						<td colspan="12">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="9">&nbsp;</td>
						<td align="right"><strong>Total OC:</strong></td>
						<td align="right"><strong>#LSNumberFormat(totalOrden, ',9.00')#</strong></td>
					</tr>
					<tr>
						<td colspan="12">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="12" align="left">Observaciones:</td>
					</tr>
					<tr>
						<td colspan="9">&nbsp;</td>
						<td colspan="2" style="border-top: 1px solid black;" align="center">Recibido por</td>
					</tr>
					<tr>
						<td colspan="9">&nbsp;</td>
						<td colspan="2" align="center">Fecha: #LSDateFormat(Now(),'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td colspan="12">&nbsp;</td>
					</tr>
				</cfif>
				
				<cfset totalOrden = 0>
				
				<!--- Encabezado por orden de compra --->
				<tr style="background-color:##CCCCCC;">
					<td colspan="12"><strong>Orden No. </strong> #rsDatosDetalles.EOnumero# - <strong>Lugar de entrega: </strong> #rsDatosDetalles.EOlugarentrega#</td>
				</tr>
				<tr style="background-color:##CCCCCC;">
					<td colspan="12"><strong>Descripción: </strong> #rsDatosDetalles.Observaciones#</td>
				</tr>
				<!--- Nombres de las columnas del reporte --->
				<tr class="titulolistas">
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-left:  1px solid black; border-right: 1px solid black;"><strong>Línea</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;"><strong>Centro Funcional</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;"><strong>Solicitante</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;"><strong>Item</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;"><strong>Descripción</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right"><strong>Cantidad Pendiente</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right"><strong>Cantidad Recibida</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;"><strong>UM</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right"><strong>Precio Unit</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right" nowrap><strong>%Desc.</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right"><strong>%Imp.</strong></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="right"><strong>Total</strong></td>
				</tr>

			</cfif>
			
			<!--- Listado de detalles --->
			<tr>
				<!--- Línea de OC --->
				<td align="right">#rsDatosDetalles.DOconsecutivo#</td>
				<!--- Centro funcional --->
				<td align="justify">#rsDatosDetalles.CFdescripcion#</td>
				<!--- Nombre del solicitante --->
				<td align="justify">#rsDatosDetalles.CMSnombre#</td>
				<!--- Código del ítem --->
				<td><cfif len(trim(rsDatosDetalles.CodigoItem)) gt 0>#rsDatosDetalles.CodigoItem#<cfelse>N/A</cfif></td>
				<!--- Descripción de la línea --->
				<td>#rsDatosDetalles.DescripcionDetalle#</td>
				<!--- Cantidad pendiente --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.CantidadPendiente, ',9.00')#</td>
				<td align="right">&nbsp;</td>
				<!--- Unidad de medida --->
				<td>#rsDatosDetalles.Ucodigo#</td>
				<!--- Precio unitario --->
				<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDatosDetalles.DOpreciou)#</td>
				<!--- Porcentaje de descuento --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.DOporcdesc, ',9.00')#%</td>
				<!--- Impuesto --->
				<td align="right" nowrap>
					<cfif len(trim(rsDatosDetalles.Icodigo)) gt 0>
					  #LSNumberFormat(rsDatosDetalles.Iporcentaje, ',9.00')#%
					</cfif>
				</td>
				<!--- Total de la línea --->
				<td align="right">#LSNumberFormat(rsDatosDetalles.Total, ',9.00')#</td>
			</tr>
			
			<cfset totalOrden = totalOrden + rsDatosDetalles.Total>
			<cfset totalPedido = totalPedido + rsDatosDetalles.Total>
		</cfloop>
		
		<!--- Pinta el último corte de OC, y el corte total --->
		<cfif rsDatosDetalles.RecordCount gt 0>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="9">&nbsp;</td>
				<td align="right"><strong>Total OC:</strong></td>
				<td align="right"><strong>#LSNumberFormat(totalOrden, ',9.00')#</strong></td>
			</tr>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="12" align="left">Observaciones:</td>
			</tr>
			<tr>
				<td colspan="9">&nbsp;</td>
				<td colspan="2" style="border-top: 1px solid black;" align="center">Recibido por</td>
			</tr>
			<tr>
				<td colspan="9">&nbsp;</td>
				<td colspan="2" align="center">Fecha: #LSDateFormat(Now(),'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="9">&nbsp;</td>
				<td align="right"><strong>Total Pendiente:&nbsp;</strong></td>
				<td align="right"><strong>#LSNumberFormat(totalPedido, ',9.00')#</strong></td>
			</tr>
		</cfif>
	</table>

</cfoutput>
