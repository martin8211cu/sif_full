<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfparam name="lvarSolicitante" default="false">
<cfquery name="qryLista" datasource="#session.dsn#">
	select a.ECid, a.CMPid, a.Ecodigo, a.SNcodigo, 
		a.CMCid, a.Mcodigo, a.ECtipocambio, a.ECconsecutivo, 
		a.ECnumero, a.ECnumprov, a.ECdescprov, a.ECobsprov, 
		a.ECprocesado, a.ECsubtotal as ECsubtotal, a.ECtotdesc, a.ECtotimp, 
		a.ECtotal, a.ECfechacot, a.ECestado, a.Usucodigo, 
		a.fechaalta, a.CPid, 
		b.SNnumero, b.SNnombre, 
		c.CMCcodigo, c.CMCnombre,
		d.DClinea, d.DSlinea, d.DCcantidad, 
		#LvarOBJ_PrecioU.enSQL_AS("d.DCpreciou")#, 
		d.DCgarantia, d.DCplazocredito, d.DCplazoentrega, d.Icodigo, 
		d.DCporcimpuesto, d.DCdesclin, d.DCtotimp, 
		round(d.DCcantidad*d.DCpreciou,2) as Totallin, 
		coalesce(nullif(ltrim(rtrim(d.DCdescprov)),' '),f.DSdescripcion) as DCdescprov, d.DCunidadcot, d.DCconversion, d.Ucodigo,
		case when a.CMFPid is not null then k.CMFPdescripcion else '' end as FormaPago,
		case when a.CMIid is not null then rtrim(g.CMIcodigo) #_Cat# ' - ' #_Cat# g.CMIdescripcion else '' end as Incoterm,
		a.ECfechavalido,
		e.Mnombre
	from ECotizacionesCM a
		inner join SNegocios b
			on b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
		inner join CMCompradores c
			on c.CMCid = a.CMCid
			and c.Ecodigo = a.Ecodigo
		left outer join DCotizacionesCM d
				inner join DSolicitudCompraCM f
					on f.DSlinea = d.DSlinea
			on d.ECid = a.ECid
			and d.Ecodigo = a.Ecodigo
		inner join Monedas e
			on e.Mcodigo = a.Mcodigo
			and e.Ecodigo = a.Ecodigo
		left outer join CMFormasPago k
			on a.Ecodigo = k.Ecodigo
			and a.CMFPid = k.CMFPid
		left outer join CMIncoterm g
			on a.Ecodigo = g.Ecodigo
			and a.CMIid = g.CMIid
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMPid#">
	and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
</cfquery>
<cfoutput query="qryLista" group="ECid">
<cfinclude template="AREA_HEADER.cfm"><br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="6" class="tituloListas"><strong>Datos de la Cotizaci&oacute;n</strong></td>
	</tr>
  <tr>
		<cfif not lvarSolicitante><td valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td valign="top">#SNnumero# - #SNnombre#</td></cfif>
		<td valign="top"><strong>Fecha de la Cotizaci&oacute;n&nbsp;:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(ECfechacot,'dd/mm/yyy')#</td>
		<td valign="top"><strong>V&aacute;lido hasta&nbsp;:&nbsp;</strong></td>
		<td valign="top">
			<cfif Len(Trim(ECfechavalido))>
				#LSDateFormat(ECfechavalido,'dd/mm/yyy')#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
  </tr>
  <tr>
		<td valign="top"><strong>Comprador&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CMCcodigo# - #CMCnombre#</td>
		<td valign="top"><strong>N&uacute;mero de Cotizaci&oacute;n&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ECnumprov#</td>
		<td valign="top"><strong>Forma de Pago &nbsp;:&nbsp;</strong></td>
		<td valign="top">#FormaPago#</td>
  </tr>
 	<tr>
 	  <td valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
 	  <td valign="top">#Mnombre#</td>
 	  <td valign="top"><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
 	  <td valign="top">#LSCurrencyFormat(ECtipocambio,'none')#</td>
	  <td valign="top"><strong>Incoterm&nbsp;:&nbsp;</strong></td>
	  <td valign="top">#Incoterm#</td>
 	</tr>
 	<tr>
 	  <td valign="top"><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
 	  <td valign="top">#ECdescprov#</td>
	  <td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
	  <td colspan="3" valign="top">#ECobsprov#</td>
	</tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6"  style="border-bottom: 1px solid black;" class="tituloListas"><strong>Detalles de la Cotizaci&oacute;n</strong></td>
	</tr>
	
	
</table>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">&Iacute;tem</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Cantidad</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Unidades</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Garant&iacute;a</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Plazo Cr&eacute;dito</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Plazo Entrega</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Precio Unitario</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">% Impuesto</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Descuento</td>
		<td align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; ">Total</td>
	</tr>
	<cfif qryLista.RecordCount eq 1 and len(qryLista.DClinea) eq 0>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td colspan="10" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">&nbsp;-- No extsten detalles en esta Cotizaci&oacute;n --&nbsp;</td>
	</tr>
	<cfelse>
	<cfoutput>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#trim(DCdescprov)#&nbsp;</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#DCcantidad#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#DCunidadcot#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#DCgarantia#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#DCplazocredito#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#DCplazoentrega#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#LvarOBJ_PrecioU.enCF_RPT(DCpreciou)#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#LSCurrencyFormat(DCporcimpuesto,'none')#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#LSCurrencyFormat(DCdesclin,'none')#</td>
		<td align="right" style="padding-right: 5px; border-bottom: 1px solid black;">#LSCurrencyFormat(Totallin,'none')#</td>
	</tr>
	</cfoutput>
	</cfif>
</table>
<table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<tr>
		<td rowspan="4" width="100%">&nbsp;</td>
		<td >Subtotal&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECsubtotal,'none')#</td>
	</tr>
	<tr>
		<td >Impuestos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECtotimp,'none')#</td>
	</tr>
	<tr>
		<td >Descuentos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECtotdesc,'none')#</td>
	</tr>
	<tr>
		<td ><strong>Total&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(ECtotal,'none')#</strong></td>
	</tr>
</table>
</cfoutput>
