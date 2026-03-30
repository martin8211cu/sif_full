<cfset modo = 'Alta'>
<cfif isdefined("url.factura") and not isdefined("form.factura") and len(trim(url.factura))>
	<cfset form.factura = url.factura>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>

<cfif isdefined('url.EVid') and not isdefined('form.EVid')>
	<cfparam name="form.EVid" default="#url.EVid#">
</cfif>
<cfif isdefined("form.factura") and len(trim(form.factura)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>
<cfif isdefined('form.EVid') and len(trim(form.EVid))>
	<cfset modoDep = 'CAMBIO'>
<cfelse>
	<cfset modoDep = 'ALTA'>
</cfif>

<cfset param = 'CPTcodigo=#form.CPTcodigo#&factura=#form.factura#&SNcodigo=#form.SNcodigo#'>

<cfif modo neq 'Alta'>
    <cfquery name="rsDatoFactura" datasource="#session.DSN#">
		select x.folio as folio,es.FTdescripcion as estado, x.IDdocumento as documento,c.CPTdescripcion as descripcion, b.SNnombre as proveedor, x.Ddocumento as factura,x.Dfecha as fecha,x.Dtotal as monto,m.Miso4217  as moneda,
	       x.EVestado
		 from HEDocumentosCP x
			inner join SNegocios b
				on b.SNcodigo = x.SNcodigo
				and b.Ecodigo = x.Ecodigo
			inner join CPTransacciones c
				on c.CPTcodigo = x.CPTcodigo
				and c.Ecodigo = x.Ecodigo
				and c.CPTtipo = 'C'
			inner join Monedas m
				on m.Mcodigo = x.Mcodigo
			left outer join EstadoFact es
				on es.FTidEstado = x.EVestado
		where x.SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		  and x.Ddocumento  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#"> 
		  and x.CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CPTcodigo)#"> 
		  and x.Ecodigo     =  #session.Ecodigo#
		
	union all
		
		select a.folio as folio,es.FTdescripcion as estado, a.IDdocumento as documento,c.CPTdescripcion as descripcion, b.SNnombre as proveedor, a.EDdocumento as factura,a.EDfecha as fecha,a.EDtotal as monto,m.Miso4217 as moneda,
			 a.EVestado
		 from EDocumentosCxP a
			inner join SNegocios b
				on b.SNcodigo = a.SNcodigo
				and b.Ecodigo = a.Ecodigo
			inner join CPTransacciones c
				on c.CPTcodigo = a.CPTcodigo
				and c.Ecodigo = a.Ecodigo
				and c.CPTtipo = 'C'
			inner join Monedas m
				on m.Mcodigo = a.Mcodigo
			left outer join EstadoFact es
				on es.FTidEstado = a.EVestado
			where a.Ecodigo     =  #session.Ecodigo#	
			  and a.CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CPTcodigo)#">
			  and a.EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
			  and a.SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
	</cfquery>
</cfif>

<cf_templateheader title="Facturas">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Seguimiento de Facturas'>

<cfoutput>
	<form action="SeguimientoFact_sql.cfm"  method="post" name="form1" id="form1" style=" margin: 0;">
		<input name="modo" type="hidden" value="#modo#" />
		<table width="100%" align="center" summary="Tabla de entrada" border="0">
			<tr>
				<td  align="right" valign="top"><strong>Num. Factura:</strong></td>
				<td colspan="2" align="left" valign="top" >
					#rsDatoFactura.factura#				
				</td>
				
				<td  align="right" valign="top"><div align="left"><strong>Descripci&oacute;n:&nbsp;</strong>
					#rsDatoFactura.descripcion#
				</td>
			</tr>
			<tr>
				<td  align="right" valign="top"><strong>Fecha:</strong></td>
				<td colspan="2" align="left" valign="top" >
					#DateFormat(rsDatoFactura.fecha,'DD/MM/YYYY')# 				
				</td>
				
				<td  align="right" valign="top"><div align="left"><strong>Proveedor:</strong>
					#rsDatoFactura.proveedor#
				</td>
			</tr>
			<tr>
				<td  align="right" valign="top"><strong>Monto:</strong></td>
				<td colspan="2" align="left" valign="top" >
					#LSNumberFormat(rsDatoFactura.monto, ',9.00')#			
				</td>
				
				<td  align="right" valign="top"><div align="left"><strong>Moneda:</strong>
					#rsDatoFactura.moneda#	
				</td>
			</tr>
			<tr>
				<td  align="right" valign="top"><strong>Estado:</strong></td>
				<td colspan="2" align="left" valign="top" >
					#rsDatoFactura.estado#			
				</td>
				<td  align="right" valign="top"><div align="left"><strong>Num. Folio:</strong>
					#rsDatoFactura.folio#	
				</td>
			</tr>
		</table>
	</form>		  
</cfoutput>

<!---DETALLE--->
<cfif modo neq "ALTA">			
	<cfinclude template="SeguimientoFact_Det.cfm">	
</cfif>
    <cf_web_portlet_end>
<cf_templatefooter>







