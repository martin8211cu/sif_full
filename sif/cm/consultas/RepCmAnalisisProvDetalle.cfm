<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfoutput>
	<cfif isdefined("url.Mes") and len(trim(url.Mes)) and not isdefined("form.Mes")>
		<cfset form.Mes = url.Mes>
	</cfif>
	<cfif isdefined("url.Anno") and len(trim(url.Anno)) and not isdefined("form.Anno")>
		<cfset form.Anno = url.Anno>
	</cfif>
	<cfif isdefined("url.MesIni") and len(trim(url.MesIni)) and not isdefined("form.MesIni")>
		<cfset form.MesIni = url.MesIni>
	</cfif>
	<cfif isdefined("url.AnnoIni") and len(trim(url.AnnoIni)) and not isdefined("form.AnnoIni")>
		<cfset form.AnnoIni = url.AnnoIni>
	</cfif>
	<cfif isdefined("url.MesFin") and len(trim(url.MesFin)) and not isdefined("form.MesFin")>
		<cfset form.MesFin = url.MesFin>
	</cfif>
	<cfif isdefined("url.AnnoFin") and len(trim(url.AnnoFin)) and not isdefined("form.AnnoFin")>
		<cfset form.AnnoFin = url.AnnoFin>
	</cfif>
	<cfif isdefined("url.Socio") and len(trim(url.Socio)) and not isdefined("form.SNcodigo")>
		<cfset form.SNcodigo = url.Socio>
	</cfif>
	<cfif isdefined("url.Criterio") and len(trim(url.Criterio)) and not isdefined("form.Criterio")>
		<cfset form.Criterio = url.Criterio>
	</cfif>
	<cfif isdefined("url.AgruparPor") and len(trim(url.AgruparPor)) and not isdefined("form.AgruparPor")>
		<cfset form.AgruparPor = url.AgruparPor>
	</cfif>
	<cfif isdefined("url.CMCid1") and len(trim(url.CMCid1)) and not isdefined("form.CMCid1")>
		<cfset form.CMCid1 = url.CMCid1>
	</cfif>
	<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo)) and not isdefined("form.Ccodigo")>
		<cfset form.Ccodigo = url.Ccodigo>
	</cfif>
	<cfif isdefined("url.CCid") and len(trim(url.CCid)) and not isdefined("form.CCid")>
		<cfset form.CCid = url.CCid>
	</cfif>
</cfoutput>

<!--- Datos del socio de negocio --->
<cfquery name="rsSocio" datasource="#session.DSN#">
	select SNidentificacion, SNnombre
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Comprador en el filtro --->
<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
	<cfquery name="rsComprador" datasource="#session.DSN#">
		select CMCnombre, CMCcodigo
		from CMCompradores
		where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
	</cfquery>
</cfif>

<cfset divisorAgrupar = 1>	<!--- Variable usada en los group by. Por default usa meses --->
<cfset factorAgrupar = 12>

<!--- Agrupar por mes --->
<cfif form.AgruparPor eq 1>
	<cfset divisorAgrupar = 1>
	<cfset factorAgrupar = 12>
<!--- Agrupar por trimestre --->
<cfelseif form.AgruparPor eq 2>
	<cfset divisorAgrupar = 3>
	<cfset factorAgrupar = 4>
<!--- Agrupar por semestre --->
<cfelseif form.AgruparPor eq 3>
	<cfset divisorAgrupar = 6>
	<cfset factorAgrupar = 2>
<!--- Agrupar por año --->
<cfelseif form.AgruparPor eq 4>
	<cfset divisorAgrupar = 12>
	<cfset factorAgrupar = 1>
</cfif>

<!--- Detalle de los datos --->
<cfquery name="rsDetalle" datasource="#session.DSN#">
	select 	b.EOnumero,
			b.EOfecha,
			monOC.Mnombre as MnombreOC,
			a.EOidorden,
			a.DOlinea,
			a.DOconsecutivo,
			a.DOdescripcion,
			a.DOcantidad,
			a.DOcantsurtida,
			a.Ucodigo as UcodigoOC,
			#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,
			coalesce(a.DOporcdesc, 0.00) as DOporcdesc,
			impOC.Iporcentaje as IporcentajeOC,
			a.DOfechaes,
			clas.Ctolerancia,
			c.DDRcantorigen,
			c.DDRcantrec,
			c.Ucodigo as UcodigoF,
			#LvarOBJ_PrecioU.enSQL_AS("c.DDRpreciou")#,
			coalesce(c.DDRdescporclin, 0.00) as DDRdescporclin,
			coalesce(c.DDRimptoporclin, 0.00) as DDRimptoporclin,
			e.EDRfecharec,
			e.EDRid,
			monF.Mnombre as MnombreF,
			coalesce(e.EDRnumero,'---') as documento,
			case when c.DDRgenreclamo is null then '---'
				 when c.DDRgenreclamo = 1 then e.EDRnumero
				 else '---'
			end as reclamo

	from DOrdenCM a
		inner join EOrdenCM b
			on b.Ecodigo = a.Ecodigo
			and b.EOidorden	= a.EOidorden
			and b.EOestado = 10
			and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and (<cf_dbfunction name="date_part" args="YY,b.EOfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,b.EOfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(form.Anno * factorAgrupar + Int((form.Mes - 1) / divisorAgrupar))#">
			and (<cf_dbfunction name="date_part" args="YY,b.EOfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,b.EOfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnnoIni * 12 + form.MesIni - 1#">
			and (<cf_dbfunction name="date_part" args="YY,b.EOfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,b.EOfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnnoFin * 12 + form.MesFin - 1#">
			<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
				and b.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
			</cfif>
			
			inner join Monedas monOC
				on monOC.Mcodigo = b.Mcodigo
				and monOC.Ecodigo = b.Ecodigo

		left outer join DDocumentosRecepcion c
			inner join EDocumentosRecepcion e
				on e.EDRid = c.EDRid
				and e.Ecodigo = c.Ecodigo
				and e.EDRestado = 10
				
				inner join Monedas monF
					on monF.Mcodigo = e.Mcodigo
					and monF.Ecodigo = e.Ecodigo
				
			on c.Ecodigo = a.Ecodigo
			and c.DOlinea = a.DOlinea
			
		inner join Impuestos impOC
			on impOC.Icodigo = a.Icodigo
			and impOC.Ecodigo = a.Ecodigo
			
		left outer join Articulos art
			on art.Aid = a.Aid
			and art.Ecodigo = a.Ecodigo
			
			left outer join Clasificaciones clas
				on clas.Ecodigo = art.Ecodigo
				and clas.Ccodigo = art.Ccodigo
				
		left outer join Conceptos conc
			on conc.Cid = a.Cid
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
			and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
					or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
				)
		<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
			and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
		<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
			and	conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
		</cfif>
	order by b.EOnumero asc
</cfquery>

<table width="98%" cellpadding="0" cellspacing="0">
	<cfoutput>
		<!--- Cantidad de columnas de acuerdo al criterio a visualizar en el reporte --->
		<cfif form.Criterio eq 1>
			<cfset numeroColumnas = 7>
		<cfelseif form.Criterio eq 2>
			<cfset numeroColumnas = 11>
		<cfelseif form.Criterio eq 3>
			<cfset numeroColumnas = 15>
		<cfelse>
			<cfset numeroColumnas = 7>
		</cfif>

		<!--- Encabezado del reporte --->
		
		<!--- Nombre de la empresa de la sesión --->
		<tr><td class="tituloAlterno" colspan="#numeroColumnas#" align="center"><strong>#session.Enombre#</strong></td></tr>
		<!--- Título del reporte --->
		<tr><td style="font-size:13px" colspan="#numeroColumnas#" align="center"><strong>Detalle de an&aacute;lisis del proveedor</strong></td></tr>
		<!--- Proveedor --->
		<tr><td colspan="#numeroColumnas#" align="center"><strong>Proveedor:&nbsp;#rsSocio.SNidentificacion# - #rsSocio.SNnombre#</strong></td></tr>
		<!--- Comprador --->
		<cfif isdefined("rsComprador") and rsComprador.RecordCount gt 0>
			<tr><td align="center" colspan="#numeroColumnas#"><strong>Comprador:&nbsp;<cfoutput>#rsComprador.CMCcodigo#&nbsp;-&nbsp;#rsComprador.CMCnombre#</cfoutput></strong></td></tr>
		</cfif>
		<!--- Criterio de visualización del reporte --->
		<tr>
			<td colspan="#numeroColumnas#" align="center">
				<strong>Criterio:&nbsp;
				<cfif isdefined("form.Criterio") and len(trim(form.Criterio)) and form.Criterio EQ 1>
					Entregas efectivas
				<cfelseif isdefined("form.Criterio") and len(trim(form.Criterio)) and form.Criterio EQ 2>
					Gesti&oacute;n de reclamos por cantidad
				<cfelse>
					Gesti&oacute;n de reclamos por precio
				</cfif>
				</strong>
			</td>
		</tr>
		<!--- Rango de fechas del reporte --->
		<tr>
			<td colspan="#numeroColumnas#" align="center">
				<cfif form.AgruparPor eq 1>
					<cfswitch expression="#form.Mes#">
						<cfcase value="1"><cfset vsMes = 'Enero'></cfcase>
						<cfcase value="2"><cfset vsMes = 'Febrero'></cfcase>
						<cfcase value="3"><cfset vsMes = 'Marzo'></cfcase>
						<cfcase value="4"><cfset vsMes = 'Abril'></cfcase>
						<cfcase value="5"><cfset vsMes = 'Mayo'></cfcase>
						<cfcase value="6"><cfset vsMes = 'Junio'></cfcase>
						<cfcase value="7"><cfset vsMes = 'Julio'></cfcase>
						<cfcase value="8"><cfset vsMes = 'Agosto'></cfcase>
						<cfcase value="9"><cfset vsMes = 'Setiembre'></cfcase>
						<cfcase value="10"><cfset vsMes = 'Octubre'></cfcase>
						<cfcase value="11"><cfset vsMes = 'Noviembre'></cfcase>
						<cfcase value="12"><cfset vsMes = 'Diciembre'></cfcase>
					</cfswitch>
					<strong>Para &nbsp;#vsMes#&nbsp;&nbsp;del&nbsp;#form.Anno#</strong>
				<cfelseif form.AgruparPor eq 2>
					<cfset numeroTrimestre = Int((form.Mes - 1) / divisorAgrupar)>
					<cfset nombreTrimestre = "">
					<cfswitch expression="#numeroTrimestre#">
						<cfcase value="0"><cfset nombreTrimestre = "Primer Trimeste"></cfcase>
						<cfcase value="1"><cfset nombreTrimestre = "Segundo Trimeste"></cfcase>
						<cfcase value="2"><cfset nombreTrimestre = "Tercer Trimeste"></cfcase>
						<cfcase value="3"><cfset nombreTrimestre = "Cuarto Trimeste"></cfcase>
					</cfswitch>
					<strong>Para el &nbsp;#nombreTrimestre#&nbsp;&nbsp;del&nbsp;#form.Anno#</strong>
				<cfelseif form.AgruparPor eq 3>
					<cfset numeroSemestre = Int((form.Mes - 1) / divisorAgrupar)>
					<cfset nombreSemestre = "">
					<cfswitch expression="#numeroSemestre#">
						<cfcase value="0"><cfset nombreSemestre = "Primer Semestre"></cfcase>
						<cfcase value="1"><cfset nombreSemestre = "Segundo Semestre"></cfcase>
					</cfswitch>
					<strong>Para el &nbsp;#nombreSemestre#&nbsp;&nbsp;del&nbsp;#form.Anno#</strong>
				<cfelseif form.AgruparPor eq 4>
					<strong>Para el año &nbsp;#form.Anno#</strong>
				</cfif>
			</td>
		</tr>
	</cfoutput>
	<tr><td colspan="#numeroColumnas#">&nbsp;</td></tr>
	
	<!--- Detalle del reporte --->
	<cfset vscorte=''>
	<cfoutput query="rsDetalle">
		<cfif vscorte NEQ rsDetalle.EOnumero>
			<!--- Corte de orden de compra --->
			<tr>
				<td class="listaCorte" colspan="#numeroColumnas#"><strong>Orden:&nbsp;#rsDetalle.EOnumero#</strong></td>
			</tr>
			<!--- Pintado de los nombres de las columnas --->
			<cfif rsDetalle.CurrentRow EQ 1>
			<tr>
				<td width="5" class="tituloListas">&nbsp;</td>
				<td class="tituloListas"><strong>Línea</strong></td>
				<td class="tituloListas"><strong>Descripci&oacute;n</strong></td>
				<cfif isdefined("form.Criterio") and len(trim(form.Criterio)) and form.Criterio EQ 1>
					<td class="tituloListas"><strong>Fecha estimada</strong></td>
					<td class="tituloListas"><strong>Fecha recepci&oacute;n</strong></td>
				<cfelseif isdefined("form.Criterio") and len(trim(form.Criterio)) and form.Criterio EQ 2>
					<td align="right" class="tituloListas"><strong>Cantidad OC</strong></td>
					<td align="center" class="tituloListas"><strong>Unidad OC</strong></td>
					<td align="right" class="tituloListas"><strong>Cantidad Facturada</strong></td>
					<td align="right" class="tituloListas"><strong>Cantidad Recibida</strong></td>
					<td align="center" class="tituloListas"><strong>Unidad Factura</strong></td>
					<td align="right" class="tituloListas"><strong>Tolerancia</strong></td>
				<cfelse>
					<td align="right" class="tituloListas"><strong>Precio OC</strong></td>
					<td align="center" class="tituloListas"><strong>Moneda OC</strong></td>
					<td align="center" class="tituloListas"><strong>Unidad OC</strong></td>
					<td align="right" class="tituloListas"><strong>Precio factura</strong></td>					
					<td align="center" class="tituloListas"><strong>Moneda factura</strong></td>
					<td align="center" class="tituloListas"><strong>Unidad factura</strong></td>
					<td align="right" class="tituloListas"><strong>Descuento OC</strong></td>
					<td align="right" class="tituloListas"><strong>Descuento Factura</strong></td>
					<td align="right" class="tituloListas"><strong>Impuesto OC</strong></td>
					<td align="right" class="tituloListas"><strong>Impuesto Factura</strong></td>		
				</cfif>
				<td class="tituloListas"><strong>Número recepci&oacute;n</strong></td>
				<td class="tituloListas"><strong>Número reclamo</strong></td>
			</tr>
			</cfif>
		</cfif>
		
		<!--- Detalles del reporte --->
		<tr class="<cfif rsDetalle.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td width="5">&nbsp;</td>
			<!--- Consecutivo de la línea de la orden de compra --->
			<td>#rsDetalle.DOconsecutivo#</td>
			<!--- Descripción de la línea de la orden de compra --->
			<td>#rsDetalle.DOdescripcion#</td>
			
			<cfif isdefined("url.Criterio") and len(trim(url.Criterio)) and url.Criterio EQ 1>
				<!--- Fecha estimada --->
				<td>#LSDateFormat(rsDetalle.DOfechaes,'dd/mm/yyyy')#</td>
				<!--- Fecha recibida --->
				<td><cfif len(trim(rsDetalle.EDRfecharec))>#LSDateFormat(rsDetalle.EDRfecharec,'dd/mm/yyyy')#<cfelse>---</cfif></td>
				
			<cfelseif isdefined("url.Criterio") and len(trim(url.Criterio)) and url.Criterio EQ 2>
				<!--- Cantidad de la orden de compra --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DOcantidad, ',9.00')#</td>
				<!--- Unidad de medida de la orden de compra --->
				<td align="center">#rsDetalle.UcodigoOC#</td>
				<!--- Cantidad facturada --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DDRcantorigen, ',9.00')#</td>
				<!--- Cantidad recibida --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DDRcantrec, ',9.00')#</td>
				<!--- Unidad de medida de la recepción --->
				<td align="center">#rsDetalle.UcodigoF#</td>
				<!--- Tolerancia --->
				<td nowrap align="right"><cfif len(trim(rsDetalle.Ctolerancia))>#LSNumberFormat(rsDetalle.Ctolerancia, ',9.00')#%<cfelse>---</cfif></td>
				
			<cfelse>
				<!--- Precio unitario de la orden de compra --->
				<td nowrap align="right">#LvarOBJ_PrecioU.enCF(rsDetalle.DOpreciou)#</td>
				<!--- Moneda de OC --->
				<td align="center">#rsDetalle.MnombreOC#</td>
				<!--- Unidad de medida de la orden de compra --->
				<td align="center">#rsDetalle.UcodigoOC#</td>
				<!--- Precio unitario --->
				<td nowrap align="right">#LvarOBJ_PrecioU.enCF(rsDetalle.DDRpreciou)#</td>
				<!--- Moneda de recepción --->
				<td align="center">#rsDetalle.MnombreF#</td>
				<!--- Unidad de medida de la factura --->
				<td align="center">#rsDetalle.UcodigoF#</td>
				<!--- Porcentaje de descuento de la orden de compra --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DOporcdesc, ',9.00')#%</td>
				<!--- Porcentaje de descuento de la recepción --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DDRdescporclin, ',9.00')#%</td>
				<!--- Porcentaje de impuesto de la orden de compra --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.IporcentajeOC, ',9.00')#%</td>
				<!--- Porcentaje de impuesto de la recepción --->
				<td nowrap align="right">#LSNumberFormat(rsDetalle.DDRimptoporclin, ',9.00')#%</td>
			</cfif>
			
			<!--- Documento de recepción --->
			<td>#rsDetalle.documento#</td>
			<!--- Número de reclamo --->
			<td>#rsDetalle.reclamo#</td>
		</tr>
		<cfset vscorte= rsDetalle.EOnumero>
	</cfoutput>
</table>
