<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">
<cfparam name="url.EDRid" type="numeric" default="-1">
<cfset fnObtieneDatos()>
<cfinclude template="AREA_HEADER.cfm">
<br />
<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="12" class="tituloListas"><strong>Datos de la Recepci&oacute;n de Mercader&iacute;a </strong></td>
	</tr>
  <tr>
		<td valign="top"><strong>N&uacute;mero de Recepci&oacute;n &nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#rsEncabezado.EDRnumero#</cfoutput></td>
		<td valign="top"><strong>N&uacute;mero Referencia &nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#rsEncabezado.EDRreferencia#</cfoutput></td>
  </tr>
  <tr>
		<td valign="top"><strong>Fecha de la Recepci&oacute;n:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#LSDateFormat(rsEncabezado.EDRfecharec,'dd/mm/yyyy')#</cfoutput></td>
		<td valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#rsEncabezado.Socio#</cfoutput></td>
  </tr>
  <tr>
		<td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#rsEncabezado.EDRobs#</cfoutput></td>
		<td valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfoutput>#rsEncabezado.Mnombre#</cfoutput></td>
  </tr>
 	<tr>
      <td valign="top"><strong>Centro Funcional:&nbsp;</strong></td>
      <td valign="top"><cfoutput>#rsEncabezado.CtroFuncional#</cfoutput></td>
      <td valign="top"><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
      <td valign="top"><cfoutput>#LSCurrencyFormat(rsEncabezado.EDRtc,'none')#</cfoutput></td>
    </tr>
	
	<tr>
	  <td valign="top"><strong>Tipo Documento :&nbsp;</strong></td>
	  <td><cfoutput>#rsEncabezado.CPTdescripcion#</cfoutput></td>
	  <td valign="top"><strong>Almacén de Recepción:</strong></td>
	  <td><cfoutput>#rsEncabezado.Almacen#</cfoutput></td>
	</tr>
	<tr>
	  <td valign="top">&nbsp;</td>
	  <td>&nbsp;</td>
	  <td valign="top">&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="12">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="12" style="border-bottom: 1px solid black;" ><strong>Detalles de la Recepci&oacute;n de Mercadería</strong></td>
	</tr>
</table>
<cfif len(trim(qryLista.Observacion))>
	<cfset lineaBajo="">
<cfelse>
	<cfset lineaBajo="border-bottom: 1px solid black;">
</cfif>
<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td width="15%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black;">Código</td>
		<td width="30%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Item</td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" nowrap>Num. Orden </td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" align="right">L&iacute;nea</td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.Orden</td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" nowrap align="right">Unidad Orden </td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.Recibida </td>
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Almacen </td>
		<td nowrap      class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" width="15%" align="right">Saldo Orden </td> 
		<td width="5%"  class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" nowrap align="right">Num.Reclamo </td>				
		<td width="15%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" nowrap align="right">Total Línea</td>
	</tr>
	<cfif qryLista.RecordCount eq 0>
		<tr class=<cfif (qryLista.currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			<td colspan="12" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">&nbsp;-- No hay detalles en la Recepci&oacute;n de Mercader&iacute;a --&nbsp;</td>
		</tr>
	<cfelse>
		<cfoutput query="qryLista">
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td width="15%" style="padding-right: 5px;  #lineaBajo#" align="right" ><cfif #codigo# NEQ ''>#codigo#<cfelse>---</cfif></td>
				<td width="30%" style="padding-right: 5px;  #lineaBajo#"><cfif #item# NEQ ''>#item#<cfelse>---</cfif></td>
				<td width="5" 	style="padding-right: 5px;  #lineaBajo#" align="right" nowrap>#EOnumero#</td>
				<td width="5%" 	style="padding-right: 5px;  #lineaBajo#" align="right" nowrap>#DOconsecutivo#</td>
				<td width="5%"  style="padding-right: 5px;  #lineaBajo#" align="right" nowrap>#DOcantidad#</td>
				<td width="5%"  style="padding-right: 5px;  #lineaBajo#" align="right" nowrap>#UnidadOrden#</td>		
				<td width="5%"  style="padding-right: 5px;  #lineaBajo#" align="right" nowrap >		 
				<cfif UnidadOrden NEQ UnidadDcto>
					#DDRcantordenconv#&nbsp;
				<cfelse>
					#DDRcantrec#&nbsp;
				</cfif>
				</td>
				<td width="15%" style="padding-right: 5px; #lineaBajo#"  align="right" nowrap>#Almacen#</td> 				
				<td width="15%" style="padding-right: 5px; #lineaBajo#"  align="right" nowrap>#LSCurrencyFormat(Saldo,'none')#</td> 
				<td width="5%"  style="padding-right: 5px; #lineaBajo#"  align="right" nowrap><cfif NumReclamo NEQ ''>#NumReclamo#<cfelse>---</cfif></td>
				<td width="15%" style="padding-right: 5px; #lineaBajo#"  align="right" nowrap>#LSCurrencyFormat(DDRtotallin,'none')#</td>
			</tr>
			<cfif len(trim(qryLista.Observacion))>
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td colspan="12" nowrap style="border-bottom: 1px solid black;"><strong>Observaciones:</strong>&nbsp;#qryLista.Observacion#</td>
			</tr>
			</cfif>
		</cfoutput>
	</cfif>
	<tr>
		<td  colspan="10"  align="right" ><strong>Subtotal&nbsp;:&nbsp;</strong></td>
		<td align="right"><cfif rsTotales.RecordCount gt 0><cfoutput>#LSCurrencyFormat(rsTotales.Subtotal,'none')#</cfoutput><cfelse>0.00</cfif></td>
	</tr>
	<tr>
		<td colspan="10" align="right"><strong>Impuestos&nbsp;:&nbsp;</strong></td>
		<td align="right"><cfif rsTotales.RecordCount gt 0><cfoutput>#LSCurrencyFormat(rsTotales.EDRimppro,'none')#</cfoutput><cfelse>0.00</cfif></td>
	</tr>
	<tr>
		<td colspan="10" align="right"><strong>Descuentos&nbsp;:&nbsp;</strong></td>
		<td align="right"><cfif rsTotales.RecordCount gt 0><cfoutput>#LSCurrencyFormat(rsTotales.EDRdescpro,'none')#</cfoutput><cfelse>0.00</cfif></td>
	</tr>
	<tr>
		<td colspan="10" align="right"><strong>Total&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong><cfif rsTotales.RecordCount gt 0><cfoutput>#LSCurrencyFormat(rsTotales.Subtotal-rsTotales.EDRdescpro+rsTotales.EDRimppro,'none')#</cfoutput><cfelse>0.00</cfif></strong></td>
	</tr>
</table>  


<cffunction name="fnObtieneDatos" access="private" output="no" returntype="boolean" hint="Obtiene los datos necesarios de las tablas de Ordenes de Compra">
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

	<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select	a.EDRid,
				a.EDRnumero,
				a.EDRfecharec,
				a.EDRobs,
				a.EDRreferencia,
				a.EDRtc,		
				d.SNnumero #_Cat#'-'#_Cat# d.SNnombre as Socio,
				ltrim(rtrim(c.CFcodigo))#_Cat#'-'#_Cat#c.CFdescripcion as CtroFuncional,
				e.Mnombre,
				g.CPTdescripcion,
				alm.Almcodigo #_Cat#'-'#_Cat# alm.Bdescripcion as Almacen
				
		from EDocumentosRecepcion a
			
			inner join Monedas e
				on a.Mcodigo = e.Mcodigo
		
			inner join SNegocios d
				on a.SNcodigo = d.SNcodigo
				  and a.Ecodigo = d.Ecodigo  
		
			left outer join CFuncional c
				on a.CFid = c.CFid
		
			left outer join CPTransacciones g
				on a.CPTcodigo = g.CPTcodigo
				 and a.Ecodigo = g.Ecodigo 
		
			left outer join Almacen alm
				on  alm.Ecodigo = a.Ecodigo
				and  alm.Aid = a.Aid
		
		where a.EDRid = #url.EDRid#
	</cfquery>
	
	<cfquery name="qryLista" datasource="#session.dsn#">
		select	a.EDRid,
				case f.CMtipo 	when 'A' then ltrim(rtrim(Acodigo))
								when 'S' then ltrim(rtrim(n.Ccodigo))
								when 'F' then 'N/A' end as codigo,
				case f.CMtipo 	when 'A' then Adescripcion
								when 'S' then Cdescripcion
								when 'F' then k.ACdescripcion end as Item,	
				f.EOnumero,
				f.DOconsecutivo,
				f.DOcantidad,
				f.DOcantidad - f.DOcantsurtida as Saldo,
				f.Ucodigo as UnidadOrden,
				b.Ucodigo as UnidadDcto,
				b.DDRcantrec,
				b.DDRcantordenconv,
				b.DDRtotallin,
				b.DDRlinea,
				s.EDRnumero as NumReclamo,
				f.DOobservaciones as Observacion,
				alm.Almcodigo #_Cat#'-'#_Cat# alm.Bdescripcion as Almacen
				
		from EDocumentosRecepcion a
			inner join DDocumentosRecepcion b
				inner join DOrdenCM f				
					<!--- Articulos--->
					left outer join Articulos m
						 on m.Aid = f.Aid
						  and m.Ecodigo = f.Ecodigo  
		  
					<!--- Conceptos--->
					left outer join Conceptos n
						 on n.Cid = f.Cid	   
						 and   n.Ecodigo = f.Ecodigo
	 
					<!--- Activos--->
					left outer join ACategoria o
						 on  o.ACcodigo = f.ACcodigo 
						 and o.Ecodigo = f.Ecodigo
	 
					left outer join AClasificacion k
						 on  k.ACcodigo = f.ACcodigo
						and k.ACid = f.ACid
						and k.Ecodigo = f.Ecodigo
				
					<!--- Almacen--->
					left outer join Almacen alm
						 on   alm.Ecodigo = f.Ecodigo  
                         and alm.Aid =  f.Alm_Aid
					
				on b.DOlinea = f.DOlinea	

			on a.EDRid = b.EDRid

			left outer join EReclamos s
				on b.EDRid = s.EDRid
				and b.Ecodigo = s.Ecodigo
		
		where a.EDRid = #url.EDRid#
	</cfquery>
	
	<cfquery name="rsTotales" datasource="#session.DSN#">
		select 
			coalesce(b.EDRdescpro, 0.00) as EDRdescpro, 
			coalesce(b.EDRimppro, 0.00) as EDRimppro,
			coalesce(
				(
					select sum(a.DDRtotallin)
					from DDocumentosRecepcion a
					where a.EDRid = b.EDRid
					  and a.Ecodigo = b.Ecodigo
				), 0.00) as Subtotal 
		from EDocumentosRecepcion b
		where b.EDRid = #url.EDRid#
		  and b.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfreturn true>
</cffunction>

<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=400,left=250, top=200,screenX=250,screenY=200');	
	}
</script>
