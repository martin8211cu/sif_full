<cfsetting requesttimeout="900">

<cfif isdefined("form.FechaIni") and isdefined("form.FechaFin") and len(trim(form.FechaIni)) and len(trim(form.FechaFin))>
	<cfset LvarFechainicio = form.FechaIni>
	<cfset LvarFechafinal = form.FechaFin>
</cfif>

<cfquery name="rsVentas" datasource="#session.dsn#" maxrows="30">
	select 
		e.HDid,
		coalesce(oc.OCcontrato, 'N/A') as OCcontrato,
		d.OCid,
		sn.SNnumero, 
		sn.SNnombre, 
		e.CCTcodigo, 
		e.Ddocumento, 
		e.Dfecha, 
		d.DDtotal * ( case when t.CCTtipo = 'D' then 1 else -1 end) as Venta,
		a.Aid as AidProducto,
		a.Acodigo as CodigoProducto,
		a.Adescripcion as Producto
	from HDocumentos e
	<cfif isdefined("form.Periodo") and isdefined("form.Mes")>
		inner join BMovimientos bm
		on  bm.Ecodigo = e.Ecodigo
		 and bm.CCTcodigo = e.CCTcodigo
		 and bm.Ddocumento = e.Ddocumento
		 and bm.CCTRcodigo = e.CCTcodigo
		 and bm.DRdocumento = e.Ddocumento
	</cfif>
		inner join HDDocumentos d
				inner join OCordenComercial oc
				on oc.OCid = d.OCid
	
				inner join Articulos a
				on a.Aid = d.DDcodartcon
		on d.HDid = e.HDid
		and d.DDtipo = 'O'
	
		inner join CCTransacciones t
		on t.Ecodigo = e.Ecodigo
		and t.CCTcodigo = e.CCTcodigo
	
		inner join SNegocios sn
		on sn.Ecodigo = e.Ecodigo
		and sn.SNcodigo = e.SNcodigo
	where e.Ecodigo = #session.Ecodigo#
	<cfif isdefined("LvarFechainicio") and isdefined("Lvarfechafinal")>
	  and e.EDtipocambioFecha between 
	  	<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechainicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechafinal#">
	</cfif>
	<cfif isdefined("form.Periodo") and isdefined("form.Mes")>
		and bm.BMperiodo = #form.Periodo#
		and bm.BMmes     = #form.Mes#
	</cfif>
	order by oc.OCcontrato, a.Acodigo, sn.SNnumero, e.CCTcodigo, e.Ddocumento
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 15px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<cfif isdefined("form.Reporte") and form.reporte eq 'Periodo'>
	<cfset LvarIrA = 'AnalisisRentaOC-periodo.cfm'>
	<cfset Lvartitle = 'Impresion de Análisis de Rentabilidad por Mes'>
	<cfset LvarFileName = 'ANALISISRENTMES.xls'>
	
<cfelse>
	<cfset LvarIrA = 'AnalisisRentaOC.cfm'>
	<cfset Lvartitle = 'Impresion de Análisis de Rentabilidad por Fecha'>
	<cfset LvarFileName = 'ANALISISRENTFECHA.xls'>
</cfif>

<cf_htmlReportsHeaders 
	title="#Lvartitle#" 
	filename="#LvarFileName#"
	irA="#LvarIrA#"
	download="yes"
	preview="no">
<cfset LvarNumeroCols = 6>
<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0"> 
		<tr bgcolor="##E4E4E4">
			<td colspan="#LvarNumeroCols#">&nbsp;</td>
		</tr>
		<tr bgcolor="##E4E4E4" class="style1">
			<td colspan="#LvarNumeroCols#" align="center">#session.Enombre#</td>
		</tr>
		<tr bgcolor="##E4E4E4" class="style1">
			<cfif isdefined("LvarFechainicio") and isdefined("Lvarfechafinal")>
				<td colspan="#LvarNumeroCols#" align="center">An&aacute;lisis de Rentabilidad por Fecha</td>
			</cfif>
			<cfif isdefined("form.Periodo") and isdefined("form.Mes")>
				<td colspan="#LvarNumeroCols#" align="center">An&aacute;lisis de Rentabilidad por Mes</td>
			</cfif>
		</tr>
		<tr bgcolor="##E4E4E4" class="style1">
			<td colspan="#LvarNumeroCols#" align="center">Fecha del Reporte: #dateformat(now(),'dd/mm/yyyy')#</td>
		</tr>
		<tr bgcolor="##E4E4E4" class="style1">
			<cfif isdefined("LvarFechainicio") and isdefined("Lvarfechafinal")>
				<td colspan="#LvarNumeroCols#" align="center">Fecha Inicial: #form.FechaIni#&nbsp;&nbsp;Fecha Final: #form.FechaFin#</td>
			</cfif>
			<cfif isdefined("form.Periodo") and isdefined("form.Mes")>
				<td colspan="#LvarNumeroCols#" align="center">Periodo: #form.Periodo#&nbsp;&nbsp;Mes: #form.Mes#</td>
			</cfif>
		</tr>
		<tr bgcolor="##E4E4E4" class="style6">
			<td colspan="#LvarNumeroCols#">&nbsp;</td>
		</tr>
</cfoutput>
<cfflush interval="64">

<cfoutput query="rsVentas" group="OCcontrato">
	<tr bgcolor="##E4E4E4" class="style3">
		<td colspan="6">Orden Comercial: #OCcontrato#</td>
	</tr>
	<cfoutput group="CodigoProducto">
		<cfset LvarCodigoArticulo = rsVentas.AidProducto>
		<cfset LvarIdDocumento = rsVentas.HDid>
		<tr bgcolor="##E4E4E4" class="style3">
			<td colspan="6">Producto: #CodigoProducto# - #Producto#</td>
		</tr>
		<cfoutput>
			<cfset LvarVenta = rsVentas.venta>
			<tr class="style5">
				<td colspan="2">Socio:   #SNnumero#</td>
				<td colspan="3">Factura: #CCTcodigo# #Ddocumento#</td>
				<td colspan="1" align="right">#NumberFormat(Venta, ',9.00')#</td>
			</tr>
			<!--- Pintar el Dato de la venta --->
			<cfquery name="rsTransportes" datasource="#session.dsn#">
				select distinct coalesce(OCTid, -1) as OCTid
				from HDDocumentos d
				where d.HDid = #LvarIdDocumento#
				  and d.DDcodartcon = #LvarCodigoArticulo#
				  and d.DDtipo = 'O'
			</cfquery>
			
			<cfloop query="rsTransportes">
				<cfset LvarOCTid = rsTransportes.OCTid>
				<cfquery name="rsCompras" datasource="#session.dsn#">
					select 
						oc.OCcontrato,
						d.OCid,
						sn.SNnumero, 
						sn.SNnombre, 
						e.CPTcodigo, 
						e.Ddocumento, 
						e.Dfecha, 
						d.DDtotallin * ( case when t.CPTtipo = 'C' then 1 else -1 end) as Costo,
						a.Aid as AidProducto,
						a.Acodigo as CodigoProducto,
						a.Adescripcion as Producto
					from HDDocumentosCP d
						inner join OCordenComercial oc
						on oc.OCid = d.OCid

						inner join Articulos a
						on a.Aid = d.DDcoditem

						inner join HEDocumentosCP e
								inner join CPTransacciones t
								on t.Ecodigo = e.Ecodigo
								and t.CPTcodigo = e.CPTcodigo

								inner join SNegocios sn
								on sn.Ecodigo = e.Ecodigo
								and sn.SNcodigo = e.SNcodigo

						on e.IDdocumento = d.IDdocumento

					where d.OCTid      = #LvarOCTid#
					  and d.DDcoditem  = #LvarCodigoArticulo#
					  and d.DDtipo     = 'O'
					order by oc.OCcontrato, sn.SNnumero, a.Acodigo
				</cfquery>
				<cfset LvarCosto = 0.00>
				<tr class="style5">
					<td>Contrato</td>
					<td colspan="2">Socio</td>
					<td colspan="2">Documento</td>
					<td align="right">Costo</td>
				</tr>
				<cfloop query="rsCompras">
					<tr class="style4">
						<td>#OCcontrato#</td>
						<td colspan="2">#SNnumero#</td>
						<td colspan="2">#CPTcodigo# #Ddocumento#</td>
						<td align="right">#NumberFormat(Costo, ',9.00')#</td>
					</tr>
					<cfset LvarCosto = LvarCosto + rsCompras.Costo>
				</cfloop>
				<tr class="style5">
					<td colspan="5" align="right">Total:</td>
					<td align="right">#NumberFormat(LvarCosto, ',9.00')#</td>
				</tr>
				<tr class="style5">
					<td colspan="5" align="right">Utilidad:</td>
					<td align="right">#NumberFormat(LvarVenta - LvarCosto, ',9.00')#</td>
				</tr>
			</cfloop>
		</cfoutput>
	</cfoutput>	
</cfoutput>
</table>
