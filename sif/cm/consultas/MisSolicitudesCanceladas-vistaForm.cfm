<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Consulta de Lineas de Solicitud de Compra Canceladas --->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
	select 	a.ESidsolicitud,
			a.ESnumero, 
			a.ESfecha,  
			a.ESobservacion, 
			a.EStipocambio,
			b.CFcodigo,
			b.CFdescripcion,
			c.CMCcodigo,
			c.CMCnombre,
			d.Mcodigo,
			d.Mnombre,
			e.CMTScodigo #_Cat#' '#_Cat# e.CMTSdescripcion as CMTSdescripcion
	from  ESolicitudCompraCM  a
		inner join CFuncional b
			on a.CFid = b.CFid
			and a.Ecodigo = b.Ecodigo
		left outer  join CMCompradores c
			on a.CMCid = c.CMCid
			and a.Ecodigo = c.Ecodigo
		inner join Monedas d
			on a.Mcodigo = d.Mcodigo
			and a.Ecodigo = d.Ecodigo
		inner join CMTiposSolicitud e
			on a.CMTScodigo = e.CMTScodigo
			and a.Ecodigo = e.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
		and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
</cfquery>

<cfquery name="rsDetalle" datasource="#session.dsn#">
	select 	a.ESidsolicitud,
			b.DSlinea,
			b.DSconsecutivo,
			b.DSobservacion,
			b.DSdescripcion,
			(coalesce(b.DScant,0) + coalesce(b.DScantcancel,0)) as DScant,
			coalesce(b.DScantcancel,0) as DScantcancel, 	
			c.CMSCid,		
			c.DSlinea,
			c.cantcancel,
			c.Justificacion,
			c.NAPasociado,
			c.BMUsucodigo,
			c.fechaalta,
			e.Pnombre#_Cat#' '#_Cat#e.Papellido1#_Cat#' '#_Cat#e.Papellido2 as nombre,
			case DStipo when 'A' then ltrim(rtrim(Art.Acodigo))
       					when 'S' then ltrim(rtrim(Con.Ccodigo))
      					when 'F' then '' end as codigo
		from  ESolicitudCompraCM  a
			left outer  join DSolicitudCompraCM  b					
				on a.ESidsolicitud  = b.ESidsolicitud
				and a.Ecodigo = b.Ecodigo
				<!---Articulos--->
				left outer join Articulos Art
					on b.Aid = Art.Aid
					and b.Ecodigo = Art.Ecodigo
				<!---Conceptos--->
				left outer join Conceptos Con
					on b.Cid = Con.Cid
					and b.Ecodigo = Con.Ecodigo
			inner join CMSolicCanceladas c
				on b.ESidsolicitud = c.ESidsolicitud
				and b.DSlinea = c.DSlinea
				and b.Ecodigo = c.Ecodigo
			inner join Usuario d
				on c.BMUsucodigo = d.Usucodigo
				inner join DatosPersonales e
					on d.datos_personales = e.datos_personales
	where a.Ecodigo = #session.Ecodigo#
		and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
	order by b.DSconsecutivo
</cfquery>

<!--- Pintado del Reporte de Lineas de Solicites Canceladas --->
<cfoutput query="rsEncabezado" group="ESidsolicitud">
	<cfinclude template="AREA_HEADER.cfm">
	<br>
	<!--- Pintado del Encabezado de la Solicitud de Compra --->
	<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
		<tr><td colspan="4" class="tituloListas"><strong>Datos de la Solicitud de Compra</strong></td></tr>
		<tr><td colspan="4"><strong>#rsEncabezado.CMTSdescripcion#</strong></td></tr>
  		<tr>
			<td valign="top"><strong>N&uacute;mero de Solicitud&nbsp;:&nbsp;</strong></td>
			<td valign="top">#rsEncabezado.ESnumero#</td>
			<td valign="top"><strong>Comprador&nbsp;:&nbsp;</strong></td>
			<td valign="top">#rsEncabezado.CMCcodigo# - #rsEncabezado.CMCnombre#</td>
  		</tr>
  		<tr>
			<td valign="top"><strong>Fecha de la Solicitud:&nbsp;</strong></td>
			<td valign="top">#LSDateFormat(rsEncabezado.ESfecha,'dd/mm/yyy')#</td>
			<td valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
			<td valign="top"><cfoutput>#rsEncabezado.Mnombre#</cfoutput></td>
  		</tr>
 		<tr>
			<td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
			<td valign="top">#rsEncabezado.ESobservacion#</td>
			<td valign="top"><strong>Tipo de Cambio &nbsp;:&nbsp;</strong></td>
			<td valign="top"><cfoutput>#LSCurrencyFormat(rsEncabezado.EStipocambio,'none')#</cfoutput></td>
  		</tr>
 		<tr>
			<td valign="top"><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
			<td valign="top" colspan="3">#rsEncabezado.CFcodigo# - #rsEncabezado.CFdescripcion#</td>
  		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" style="border-bottom: 1px solid black;" >
				<strong>Detalles de L&iacute;nea(s) Canceladas de la Solicitud de Compra</strong>
			</td>
		</tr>
	</table>
</cfoutput>

<!--- Pintado del Detalle de la Solicitud de Compra --->
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td nowrap width="4%"  class="tituloListas" style="padding-right:5px; border-bottom:1px solid black;">Línea</td>
		<td nowrap width="10%" class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">C&oacute;digo</td>
		<td nowrap width="30%" class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&Iacute;tem</td>
		<td nowrap width="3%"  class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;" align="right">Cant.</td>
		<td nowrap width="3%"  class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;" align="right">Cant.Canc.</td>
		<td nowrap width="5%"  class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">Fecha Canc.</td>
		<td nowrap width="10%" class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">Usuario</td>
		<td nowrap width="5%"  class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">NAP</td>
		<td nowrap width="30%" class="tituloListas" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">Justificaci&oacute;n</td> 
	</tr>
	
	<cfif rsDetalle.RecordCount GT 0>
		<cfoutput query="rsDetalle">
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>> 
				<td nowrap width="4%"  style="padding-right:5px; border-bottom:1px solid black;">&nbsp;#rsDetalle.DSconsecutivo#&nbsp;</td>
				<td nowrap width="10%" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#rsDetalle.codigo#&nbsp;</td>
				<td        width="30%" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#rsDetalle.DSdescripcion#&nbsp;</td>
				<td nowrap width="3%"  style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;" align="right">&nbsp;#rsDetalle.DScant#&nbsp;</td> 
				<td nowrap width="3%"  style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;" align="right">&nbsp;#rsDetalle.DScantcancel#&nbsp;</td>				
				<td nowrap width="5%"  style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#LSDateFormat(rsDetalle.fechaalta,'dd/mm/yyy')#&nbsp;</td>
				<td nowrap width="10%" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#rsDetalle.nombre#&nbsp;</td>
				<td nowrap width="5%"  style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#rsDetalle.NAPasociado#&nbsp;</td>
				<td        width="30%" style="padding-right:5px; border-bottom:1px solid black; border-left:1px solid black;">&nbsp;#rsDetalle.Justificacion#&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="9">&nbsp;</td></tr>
		<tr><td colspan="9" align="center"><strong>--- No hay Detalles de L&iacute;neas Cancaladas en la Solicitud de Compra ---</strong></td></tr>
		<tr><td colspan="9" style="padding-right:5px; border-bottom:1px solid black; ">&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="9">&nbsp;</td></tr>
</table>