<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templatecss>
<cfquery name="qryLista" datasource="#session.dsn#">
	select 	a.ECid, 
			a.CMPid, 
			a.Ecodigo, 
			a.SNcodigo, 
			a.CMCid, 
			a.Mcodigo, 
			a.ECtipocambio, 
			a.ECconsecutivo, 
			a.ECnumero, 
			a.ECnumprov, 
			a.ECdescprov, 
			a.ECobsprov, 
			a.ECprocesado, 
			a.ECsubtotal as ECsubtotal, 
			a.ECtotdesc, 
			a.ECtotimp, 
			a.ECtotal, 
			a.ECfechacot, 
			a.ECestado, 
			a.Usucodigo, 
			a.fechaalta, 
			a.CPid, 
			b.SNnumero, 
			b.SNnombre, 
			c.CMCcodigo, 
			c.CMCnombre,
			d.DClinea, 
			d.DSlinea, 
			d.DCcantidad, 
			#LvarOBJ_PrecioU.enSQL_AS("d.DCpreciou")#, 
			d.DCgarantia, 
			d.DCplazocredito, 
			d.DCplazoentrega, 
			d.Icodigo, 
			d.DCporcimpuesto, 
			d.DCdesclin, 
			d.DCtotimp, 
			(d.DCcantidad*d.DCpreciou) as Totallin, 
			coalesce(nullif(ltrim(rtrim(d.DCdescprov)),' '),f.DSdescripcion) as DCdescprov, 
			d.DCunidadcot, 
			d.DCconversion, 
			d.Ucodigo,
			case when a.CMFPid is not null then k.CMFPdescripcion else '' end as FormaPago,
			case when a.CMIid is not null then rtrim(g.CMIcodigo) #_Cat# ' - ' #_Cat# g.CMIdescripcion else '' end as Incoterm,
			a.ECfechavalido,
			e.Mnombre,
			f.Aid,
			f.Cid,
			f.ACcodigo,
			z.CMRjustificacion
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
					
				<!----Obtener el resultado de la evaluación---->
				inner join CMResultadoEval z
					on d.CMPid = z.CMPid
					and d.ECid = z.ECid	
					and d.DClinea = z.DClinea
					
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
		and a.Ecodigo = #session.Ecodigo#
</cfquery>
<cfoutput query="qryLista" group="ECid">
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="7" class="tituloListas"><strong>Datos de la Cotizaci&oacute;n</strong></td>
	</tr>
  <tr>
		<td valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td valign="top">#SNnumero# - #SNnombre#</td>
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
		<td colspan="6"><strong>Detalles de la Cotizaci&oacute;n</strong></td>
	</tr>
</table>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td class="tituloListas" style="padding-right: 5px;">&Iacute;tem</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Cantidad</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Unidades</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Garant&iacute;a</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Plazo Cr&eacute;dito</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Plazo Entrega</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Precio Unitario</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">% Impuesto</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Descuento</td>
		<td class="tituloListas" style="padding-right: 5px;">&Uacute;ltimo proveedor de compra</td>
		<td align="right" class="tituloListas" style="padding-right: 5px;">Total</td>		
	</tr>
	<cfif qryLista.RecordCount eq 1 and len(qryLista.DClinea) eq 0>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td colspan="11" style="padding-right: 5px; border-top: 1px solid black;" align="center">&nbsp;-- No extsten detalles en esta Cotizaci&oacute;n --&nbsp;</td>
	</tr>
	<cfelse>
	<cfoutput>
	<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
		<td style="padding-right: 5px; border-top: 1px solid black;">&nbsp;#trim(DCdescprov)#&nbsp;</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#DCcantidad#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#DCunidadcot#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#DCgarantia#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#DCplazocredito#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#DCplazoentrega#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#LvarOBJ_PrecioU.enCF_RPT(DCpreciou)#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#LSCurrencyFormat(DCporcimpuesto,'none')#</td>
		<td align="right" style="padding-right: 5px; border-top: 1px solid black;">#LSCurrencyFormat(DCdesclin,'none')#</td>
		<td style="padding-right: 5px; border-top: 1px solid black;">
			<cfset vnAid = qryLista.Aid><!---Variable con el ID del articulo---->
			<cfset vnCid = qryLista.Cid><!---Variable con el ID del concepto(servicio)---->
			<cfif len(trim(qryLista.ACcodigo)) EQ 0>
				<cfquery name="rsUltimoProveedor" datasource="#session.DSN#" maxrows="1">
					select b.EOfecha, ltrim(rtrim(c.SNidentificacion))#_Cat#' - '#_Cat# ltrim(rtrim(c.SNnombre)) as rsSocio
					from DOrdenCM a
						inner join EOrdenCM b
							on a.EOidorden = b.EOidorden
							and a.Ecodigo = b.Ecodigo
							and b.EOestado = 10
							
							inner join SNegocios c
								on b.SNcodigo = c.SNcodigo
								and b.Ecodigo = c.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
					<cfif len(trim(vnAid))>
						and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnAid#">
					<cfelse> 
						and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCid#">
					</cfif>
					order by EOfecha desc
				</cfquery>
				#rsUltimoProveedor.rsSocio#
			<cfelse>
				N/A
			</cfif>
		</td>
		<td align="right" style="border-top: 1px solid black;">#LSCurrencyFormat(Totallin,'none')#</td>		
	</tr>
	<tr>
		<td>
			<cfif len(trim(CMRjustificacion))>
				#CMRjustificacion#
			<cfelse>
				-----
			</cfif>
		</td>
	</tr>
	</cfoutput>
	</cfif>
</table>
<table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<tr>
		<td rowspan="4" width="100%">&nbsp;</td>
		<td>Subtotal&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECsubtotal,'none')#</td>
	</tr>
	<tr>
		<td>Impuestos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECtotimp,'none')#</td>
	</tr>
	<tr>
		<td>Descuentos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(ECtotdesc,'none')#</td>
	</tr>
	<tr>
		<td><strong>Total&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(ECtotal,'none')#</strong></td>
	</tr>
	<tr><td colspan="11">&nbsp;</td></tr>
	<tr><td colspan="11">&nbsp;</td></tr>
	<tr><td colspan="11">&nbsp;</td></tr>
	<tr><td colspan="11" align="center">
		<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript: window.close();">
	</td></tr>
</table>
</cfoutput>