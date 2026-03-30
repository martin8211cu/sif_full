<cfif isdefined("Url.DOlinea") and not isdefined("Form.DOlinea")>
	<cfset Form.DOlinea = Url.DOlinea>
</cfif>

<cfquery name="rsTrackingLinea" datasource="sifpublica">
	select a.ETidtracking, b.ETconsecutivo, 
		   c.CRid, 
		   '' as CRdescripcion,
		   c.DTnumreferencia,
		   case b.ETestado when 'P' then 'En Proceso' when 'T' then 'En Tránsito' when 'E' then 'Entregado' else '' end as EstadoTracking,
		   b.ETestado,
		   b.ETfechasalida, 
		   b.ETfechaestimada,
		   b.ETfechaentrega,
		   c.DTtipo,
		   case c.DTtipo when 'E' then 'Llegada' when 'S' then 'Salida' when 'T' then 'Entregado' when 'C' then 'Consolidado' else '' end as TipoActividad,
		   c.DTfechaincidencia,
		   c.DTactividad,
		   c.DTubicacion
	from ETrackingItems a
	
	inner join ETracking b
	on a.Ecodigo = b.Ecodigo
	and a.ETidtracking = b.ETidtracking
	
	left outer join DTracking c
	on b.Ecodigo = c.Ecodigo
	and b.ETidtracking = c.ETidtracking
	and c.DTtipo in ('E', 'S', 'T') <!--- Se podría cambiar --->
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DOlinea#">
	
	order by a.ETIestado, b.ETidtracking desc, c.DTfechaincidencia desc
</cfquery>

<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">

	union

	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2
</cfquery>
<cfif rsCourier.recordCount GT 0>
	<cfset listaCRid = ValueList(rsCourier.CRid, ',')>
	<cfset listaCRdesc = ValueList(rsCourier.CRdescripcion, ',')>
<cfelse>
	<cfset crid = "">
	<cfset crdesc = "">
</cfif>

<!--- Actualizacion de la descripcion de los courier en la lista de trackings --->
<cfloop query="rsTrackingLinea">
	<cfif Len(Trim(rsTrackingLinea.CRid))>
		<cfset pos = ListFind(listaCRid, rsTrackingLinea.CRid, ",")>
		<cfif pos NEQ 0>
			<cfset QuerySetCell(rsTrackingLinea, "CRdescripcion", ListGetAt(listaCRdesc, pos, ','), currentRow)>
		</cfif>
	</cfif>
</cfloop>

<!--- Datos de la Orden --->
<!--- Se asume que la cantidad generada en el tracking fue el resulta de DOcantidad - DOcantsurtida --->
<cfquery name="rsOrden" datasource="#Session.DSN#">
	select a.DOdescripcion, b.EOnumero, b.Observaciones, a.DOcantidad - a.DOcantsurtida as Cantidad
	from DOrdenCM a
    	inner join EOrdenCM b
        	on b.EOidorden = a.EOidorden
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DOlinea#">
	  and a.Ecodigo = b.Ecodigo
</cfquery>
<cfquery name="rsCantidad" datasource="sifpublica">
	select a.ETIcantidad
	from ETrackingItems a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DOlinea#">
	and a.ETIestado = 0
</cfquery>
<cfif rsCantidad.recordCount>
	<cfset QuerySetCell(rsOrden, "Cantidad", rsCantidad.ETIcantidad)>
</cfif>

<cfoutput>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="3" align="center" class="tituloAlterno"><strong><font size="3">#session.enombre#</font></strong></td></tr>
  <tr><td  nowrap colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3" align="center"><strong><font size="3">Seguimiento de Item de Compra</font></strong></td></tr>
  <tr><td colspan="3" align="center"><strong><font size="2">Fecha de la Consulta:&nbsp;</font></strong><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="8" class="tituloAlterno">
			Detalle de Item de Compra
		</td>
	</tr>
  <tr>
    <td align="right"><strong>No. Orden:</strong></td>
    <td>#rsOrden.EOnumero#</td>
    <td align="right"><strong>Orden:</strong></td>
    <td>#rsOrden.Observaciones#</td>
    <td align="right"><strong>Item:</strong></td>
    <td>#rsOrden.DOdescripcion#</td>
    <td align="right"><strong>Cantidad:</strong></td>
    <td>#rsOrden.Cantidad#</td>
  </tr>
  <tr><td colspan="6">&nbsp;</td></tr>
</table>
</cfoutput>

<cfif rsTrackingLinea.recordCount GT 0>
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="6" class="tituloAlterno">
			Detalle de Tracking
		</td>
	</tr>
	<cfset corte = "">
	<cfloop query="rsTrackingLinea">
		<cfif corte NEQ rsTrackingLinea.ETidtracking>
			<cfset corte = rsTrackingLinea.ETidtracking>
			<tr>
			<td colspan="6">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" bgcolor="##CCCCCC">
				  <tr>
					<td align="right"><strong>No. Tracking:</strong></td>
					<td>#rsTrackingLinea.ETconsecutivo#</td>
					<td align="right"><strong>Fecha Salida:</strong></td>
					<td>
						<cfif Len(Trim(rsTrackingLinea.ETfechasalida))>
							#LSDateFormat(rsTrackingLinea.ETfechasalida, 'dd/mm/yyyy')#
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					<td align="right">
						<cfif rsTrackingLinea.ETestado EQ 'E'>
							<strong>Fecha Entrega:</strong>
						<cfelse>
							<strong>Fecha Estimada:</strong>
						</cfif>					</td>
					<td>
						<cfif rsTrackingLinea.ETestado EQ 'E'>
							<cfif Len(Trim(rsTrackingLinea.ETfechaentrega))>
								#LSDateFormat(rsTrackingLinea.ETfechaentrega, 'dd/mm/yyyy')#
							<cfelse>
								&nbsp;
							</cfif>
						<cfelse>
							<cfif Len(Trim(rsTrackingLinea.ETfechaestimada))>
								#LSDateFormat(rsTrackingLinea.ETfechaestimada, 'dd/mm/yyyy')#
							<cfelse>
								&nbsp;
							</cfif>
						</cfif>
					</td>
					<td align="right"><strong>Estado:</strong></td>
					<td>#rsTrackingLinea.EstadoTracking#</td>
				  </tr>
				</table>
			</td>
			</tr>
			<tr class="tituloListas">
				<td><strong>Tipo Actividad</strong></td>
				<td><strong>Actividad</strong></td>
				<td><strong>Courier</strong></td>
				<td><strong>Tracking Courier</strong></td>
				<td><strong>Fecha</strong></td>
				<td><strong>Ubicaci&oacute;n</strong></td>
			</tr>
		</cfif>
		<tr>
			<td>#rsTrackingLinea.TipoActividad#</td>
			<td>#rsTrackingLinea.DTactividad#</td>
			<td>#rsTrackingLinea.CRdescripcion#</td>
			<td>#rsTrackingLinea.DTnumreferencia#</td>
			<td>
				<cfif Len(Trim(rsTrackingLinea.DTfechaincidencia))>
					#LSDateFormat(rsTrackingLinea.DTfechaincidencia, 'dd/mm/yyyy')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td>#rsTrackingLinea.DTubicacion#</td>
		</tr>
	</cfloop>
		<tr>
			<td colspan="6">&nbsp;</td>
		</tr>
	</table>
	</cfoutput>
</cfif> 
