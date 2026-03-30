<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<style type="text/css">	
	.LetraDetalle{
		font-size:10px;
	}
	.LetraEncab{
		font-size:11px;
		font-weight:bold;
	}
</style> 
<cfif isdefined("url.fEDRnumeroD") and not isdefined("form.fEDRnumeroD")>
	<cfset form.fEDRnumeroD = Url.fEDRnumeroD>
</cfif>
<cfif isdefined("url.fEDRnumeroH") and not isdefined("form.fEDRnumeroH")>
	<cfset form.fEDRnumeroH = Url.fEDRnumeroH>
</cfif>
<cfif isdefined("url.EOnumero1") and not isdefined("form.EOnumero1")>
	<cfset form.EOnumero1 = Url.EOnumero1>
</cfif>
<cfif isdefined("url.EOnumero2") and not isdefined("form.EOnumero2")>
	<cfset form.EOnumero2 = Url.EOnumero2>
</cfif>
<cfif isdefined("url.fechaD") and not isdefined("form.fechaD")>
	<cfset form.fechaD = Url.fechaD>
</cfif>
<cfif isdefined("url.fechaH") and not isdefined("form.fechaH")>
	<cfset form.fechaH = Url.fechaH>
</cfif>
<cfif isdefined("url.fTDRtipo") and not isdefined("form.fTDRtipo")>
	<cfset form.fTDRtipo = Url.fTDRtipo>
</cfif>
<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
	<cfset form.Usucodigo = Url.Usucodigo>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = Url.Mcodigo>
</cfif>

<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">

<cfinclude template="../operacion/docum-funciones.cfm">

<!--- Funcion que calcula el subtotal --->
<cffunction name="calcularSubTotal" returntype="numeric">
	<cfargument name="cantidad" type="numeric" required="yes">
	<cfargument name="precio" type="numeric" required="yes">
	<cfargument name="descuento" type="numeric" required="yes">
	
	<cfreturn (cantidad * precio) * ((100 - descuento) / 100)>
</cffunction>

<!--- Funcion que calcula el monto del impuesto --->
<cffunction name="calcularImpuesto" returntype="numeric">
	<cfargument name="cantidad" type="numeric" required="yes">
	<cfargument name="precio" type="numeric" required="yes">
	<cfargument name="descuento" type="numeric" required="yes">
	<cfargument name="impuesto" type="numeric" required="yes">
	<cfif isdefined ('formaCalculoImpuestos') and formaCalculoImpuestos.RecordCount gt 0 and formaCalculoImpuestos.Pvalor eq 0>
		<cfreturn ((cantidad * precio) * ((100 - descuento) / 100)) * (impuesto / 100)>
	<cfelse>
		<cfreturn (cantidad * precio) * (impuesto / 100)>
	</cfif>
</cffunction>

<cfquery name="qryLista" datasource="#session.dsn#">
	select  hedr.EDRid,
			sn.SNnombre,
			sn.SNidentificacion,
			hedr.EDRnumero as NumFactura, 
			hedr.EDRfechadoc,
			hedr.EDRfecharec,
			hedr.Usucodigo,
			hedr.EPDid,
			eocm.EOplazo,
			eocm.EOnumero,
			docm.DOconsecutivo,
			hddr.DDRtipoitem,
			art.Acodigo,
			art.Adescripcion,
			con.Ccodigo,
			con.Cdescripcion,
			alm.Almcodigo,
			coalesce(NumeroParte,art.Acodalterno) as NumParte,
			hddr.Ucodigo,																<!--- Codigo de la unidad de medida en la linea de la factura --->
			hddr.DDRcantorigen,															<!--- Cantidad factura --->
			hddr.DDRcantrec,															<!--- Cantidad recibida --->
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,								<!--- Precio factura --->
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRprecioorig")#,							<!--- Precio orden de compra --->
			imp.Icodigo,
			coalesce(imp.Iporcentaje, 0) as Iporcentaje,								<!--- Porcentaje impuesto en la factura --->
			imp.Icreditofiscal,
			cfi.CFformato,
			docm.DOobservaciones,
			docm.DOalterna,
			hedr.Mcodigo,																<!--- Codigo de la moneda de la factura --->
			m.Mnombre as Mnombre, 
			coalesce(hddr.DDRdescporclin, 0) as DDRdescporclin,							<!--- Porcentaje descuento en la factura --->
			docm.DOcantidad,															<!--- Cantidad en la orden de compra --->
			coalesce(docm.DOporcdesc, 0) as DOporcdesc,									<!--- Porcentaje descuento en la orden de compra --->
			case 
				when (hddr.DDRgenreclamo = 1)  and 
					(hddr.DDRaprobtolerancia is null or
					hddr.DDRaprobtolerancia=20)
											then ((coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad)
				else 0
			end Ctolerancia,				<!--- Tolerancia del articulo --->
			case 
				when hddr.DDRaprobtolerancia = 10 then 1
				else 0
			end DDRaprobtolerancia,		
			case when clas.Ctolerancia is null then 'F'
				 else 'V'
			end as ArticuloTieneTolerancia,
			impOC.Iporcentaje as IporcentajeOC,											<!--- Porcentaje de impuesto de la orden de compra --->
			case when docm.Ucodigo = hddr.Ucodigo then 1
				 when cu.CUfactor is not null then cu.CUfactor
				 when cua.CUAfactor is not null then cua.CUAfactor
				 else case when hddr.DDRcantorigen = 0 then 0
						   else hddr.DDRcantordenconv / hddr.DDRcantorigen
						   end
				 end as factorConversionU,												<!--- Factor de conversion (factura a orden) --->
			eocm.EOtc,																	<!--- Tipo de cambio en la orden de compra --->
			hedr.EDRtc,																	<!--- Tipo de cambio en la factura --->
			docm.Ucodigo as UcodigoOC,													<!--- Codigo de la unidad de media en el detalle de la orden de compra --->
			eocm.Mcodigo as McodigoOC,													<!--- Codigo de la moneda de la orden de compra asociada --->
			docm.DOcantidad - docm.DOcantsurtida as DOcantsaldo,						<!--- Cantidad del saldo de la linea en la orden de compra --->
			hddr.DDRgenreclamo															<!--- Indica si se genera reclamo --->
			
	from EDocumentosRecepcion hedr
	
		inner join DDocumentosRecepcion hddr
			on hedr.Ecodigo = hddr.Ecodigo
			and hedr.EDRid = hddr.EDRid
				
		inner join SNegocios sn
			on  hedr.Ecodigo = sn.Ecodigo
			and hedr.SNcodigo = sn.SNcodigo

		inner join Monedas m
			on hedr.Ecodigo = m.Ecodigo
			and hedr.Mcodigo = m.Mcodigo		  	  	
		
		inner join TipoDocumentoR tdr
			on hedr.TDRcodigo = tdr.TDRcodigo
			and hedr.Ecodigo = tdr.Ecodigo
		<cfif isdefined("Form.fTDRtipo") and Form.fTDRtipo NEQ 'T'>
			and tdr.TDRtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fTDRtipo#">
		</cfif>

		inner join DOrdenCM docm		
			on hddr.DOlinea = docm.DOlinea

		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) neq 0 and isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) neq 0>
			<cfif form.EOnumero1  GT form.EOnumero2>
				and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
			<cfelseif form.EOnumero1 EQ form.EOnumero2>
				and docm.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
			<cfelse>
				and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
			</cfif>
		<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and not (isdefined("form.EOnumero2"))>
				and docm.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
		<cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and not (isdefined("form.EOnumero1"))>
				and docm.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif>
		
		<!---/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/---->
		left outer join AClasificacion acl
			on docm.ACid = acl.ACid
			and docm.ACcodigo = acl.ACcodigo
			and docm.Ecodigo = acl.Ecodigo
		<!---/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/---->
		<!--- Para obtener el factor de conversion de factura a orden --->
		left outer join ConversionUnidades cu
			on cu.Ecodigo = hddr.Ecodigo
			and cu.Ucodigo = hddr.Ucodigo
			and cu.Ucodigoref = docm.Ucodigo
		
		<!--- Para obtener el porcentaje de impuesto de la orden de compra --->
		left outer join Impuestos impOC
			on impOC.Icodigo = docm.Icodigo
			and impOC.Ecodigo = hddr.Ecodigo

		inner join EOrdenCM eocm
			on docm.EOidorden=eocm.EOidorden
			and docm.Ecodigo = eocm.Ecodigo
			<cfif isdefined("Form.Mcodigo") and Form.Mcodigo NEQ ''>
				and eocm.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
			</cfif>
			
		left outer join NumParteProveedor npp
			on npp.Ecodigo = docm.Ecodigo
			and npp.SNcodigo = eocm.SNcodigo
			and npp.Aid = docm.Aid
			and <cf_dbfunction name="now"> between Vdesde and Vhasta			

		left outer join CFinanciera cfi
			on docm.Ecodigo = cfi.Ecodigo
			and docm.CFcuenta = cfi.CFcuenta

		left outer join CPVigencia cpv
			on cfi.Ecodigo = cpv.Ecodigo
			and cfi.Cmayor = cpv.Cmayor

		left outer join Articulos art
			on hddr.Aid = art.Aid
			and hddr.Ecodigo = art.Ecodigo	

		<!--- Para obtener el porcentaje de tolerancia del articulo --->
		left outer join Clasificaciones clas
			on clas.Ccodigo = art.Ccodigo
			and clas.Ecodigo = hddr.Ecodigo

		<!--- Para obtener factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->			
		left outer join ConversionUnidadesArt cua
			on cua.Aid = art.Aid
			and art.Ucodigo = hddr.Ucodigo
			and cua.Ucodigo = docm.Ucodigo
			and cua.Ecodigo = hddr.Ecodigo

		left outer join Conceptos con
			on hddr.Cid = con.Cid
			and hddr.Ecodigo = con.Ecodigo
			
		left outer join Almacen alm
			on hedr.Aid = alm.Aid
			and hedr.Ecodigo = alm.Ecodigo

		left outer join Impuestos imp
			on hddr.Icodigo = imp.Icodigo
			and hddr.Ecodigo = imp.Ecodigo

		left outer join EReclamos er
			on hddr.EDRid = er.EDRid
			and hddr.Ecodigo = er.Ecodigo
		
		left outer join DReclamos dr
			on dr.ERid = er.ERid
			and dr.Ecodigo = er.Ecodigo
			and hddr.DDRlinea = dr.DDRlinea			
		
	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!----and DDRtipoitem <> 'F'----->
	and hedr.EDRestado = 0  <!--- Estado sin Aplicar  --->
	<!--- Cuando vienen los dos filtros de numero llenos --->
	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))>
		<cfif form.fEDRnumeroD GT form.fEDRnumeroH>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelseif form.fEDRnumeroD EQ form.fEDRnumeroH>
			and hedr.EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelse>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
		</cfif>
	<!--- Cuando solo viene el primer filtro de numero --->
	<cfelseif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD))>
			and hedr.EDRnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
	<!--- Cuando solo viene el segundo filtro de numero --->
	<cfelseif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))>
			and hedr.EDRnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
	</cfif>
	
	<!--- Cuando vienen ambos filtros de fecha --->
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
		<cfif form.fechaD EQ form.fechaH>
			and hedr.EDRfecharec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
		<cfelse>
			and hedr.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
		</cfif>
	<!--- Cuando solo viene el filtro filtro de fecha --->
	<cfelseif isdefined("Form.fechaD") and len(trim(Form.fechaD))>
			and hedr.EDRfecharec >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
	<!--- Cuando solo viene el segundo filtro de fecha --->
	<cfelseif isdefined("Form.fechaH") and len(trim(Form.fechaH))>
			and hedr.EDRfecharec <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
	</cfif>
		
	<cfif isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo))>
		and hedr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfif>
		
    order by hedr.fechaalta
</cfquery>

<br>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<!--- Encabezado del Reporte --->
	<tr>
		<td colspan="22" align="center" style="font-size:17px ">
			<strong>#Session.Enombre#</strong>
		</td>
	</tr>
	<tr>
		<td colspan="22" align="center" style="font-size:15px ">
			<strong>Informe de Entradas no Aplicadas</strong>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="22" align="center">
			<strong>Fecha del reporte:</strong> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <br>
			<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#
		</td>
	</tr>
	<tr>
		<td colspan="22">&nbsp;</td>
	</tr>
	
	<!--- Líneas de Detalle del Reporte --->
	<tr>	 	
		<td align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<!--- Si encontro registros --->
				<cfif qryLista.RecordCount>
					<cfset cortefactura = "">
					<!---cfset totalRecepcion = 0--->		<!--- Total en recepcion de una factura --->
					<cfset totalReclamo = 0>		<!--- Total en reclamos de una factura --->
					<cfset totalFactura = 0>		<!--- Total de la factura = total en recepcion + total en reclamos --->
	
					<cfloop query="qryLista" >
						<cfif cortefactura NEQ qryLista.NumFactura>
							<cfset cortefactura = qryLista.NumFactura>
							
							<!--- Corte de factura --->
							<cfif qryLista.currentRow NEQ 1>
							
								<!--- Pintado de los totales por factura (factura, reclamo, monto real recibido) --->
								<tr>
									<td style="border-bottom: 1px solid black; " colspan="13" align="left" nowrap class="LetraEncab">Totales en #qryLista.Mnombre#:<br></td>
									<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalFactura, ',9.00')#<br></td>
									<td style="border-bottom: 1px solid black; " colspan="6" class="LetraEncab">&nbsp; <br></td>
									<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalReclamo, ',9.00')#<br></td>
									<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalFactura - totalReclamo, ',9.00')#<br></td>
								</tr>
								<tr>
									<td colspan="22">&nbsp;</td>
								</tr>
								<!--- Se reinician los valores acumulados --->
								<cfset totalReclamo = 0>
								<cfset totalFactura = 0>
							</cfif> 

							<!--- Encabezado Factura --->
							<tr>
								<td colspan="22">
									<table border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td nowrap align="right" class="LetraEncab">#qryLista.SNnombre#&nbsp;-&nbsp; #qryLista.SNidentificacion#</td>
										  	<td nowrap align="right" class="LetraEncab">Factura:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">#cortefactura#</td>
										  	<td nowrap align="right" class="LetraEncab">Fecha:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">#LSDateFormat(qryLista.EDRfechadoc, 'dd/mm/yyyy')#</td>
										  	<td nowrap align="right" class="LetraEncab">Plazo:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">#qryLista.EOplazo#</td>
										  	<td nowrap align="right" class="LetraEncab">Bodega:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">
												<cfif Len(Trim(qryLista.Almcodigo))>
													#qryLista.Almcodigo#
												<cfelse>
													&nbsp;---&nbsp;
												</cfif>
											</td>
										  	<td nowrap align="right" class="LetraEncab">Fecha de Entrega:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">#LSDateFormat(qryLista.EDRfecharec, 'dd/mm/yyyy')#</td>
										  	<td nowrap align="right" class="LetraEncab">Moneda:&nbsp;</td>
										  	<td nowrap class="LetraDetalle">#qryLista.Mnombre#</td>
										  	<td nowrap class="LetraDetalle">
                                            	<cfinclude template="../../Utiles/sifConcat.cfm">
												<cfquery name="rsDatosUsuario" datasource="asp">
													select Pnombre#_Cat#' '#_Cat#Papellido1#_Cat#' '#_Cat#Papellido2 as nombre
													from Usuario a
														inner join DatosPersonales b
														on a.datos_personales = b.datos_personales
													where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 	
														and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.Usucodigo#">
												</cfquery>
												<cfif isdefined("rsDatosUsuario") and rsDatosUsuario.RecordCount NEQ 0>
													Usuario:&nbsp;#rsDatosUsuario.nombre#
												</cfif>
										  	</td>
									  	</tr>
									</table>
								</td>
							</tr>
							
							<!--- Linea de Encabezado --->
							<tr>
								<td nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black;">O.C.</td>
								<td nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Línea</td>
								<td nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
								<td nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m. de <br> Parte</td>
								<td nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">UM</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Facturada</td>								
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Recibida</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio <br> Unitario</td>
								<td align="right" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descuento</td>
								<td align="right" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Sub Total</td>
								<td align="center" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">% Imp.</td>
								<td align="center" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Recup. <br> Impuesto</td>
								<td align="right" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Total L&iacute;nea <br> Factura</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m.<br>Reclamo</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cant. <br> Reclamo</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cant. <br> Orden</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio <br> Orden</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">% Descuento <br> Orden</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">% Impuesto <br> Orden</td>								
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto <br> Reclamo</td>
								<td align="left" nowrap class="LetraEncab" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Real <br> Recibido</td>
							</tr>
						</cfif>
						
						<!--- Lineas de detalle --->						
						<tr>
							<!--- Numero de orden de compra--->
							<td nowrap class="LetraDetalle">#qryLista.EOnumero#</td>
							<!--- Linea de la orden de compra--->
							<td nowrap class="LetraDetalle">#qryLista.DOconsecutivo#</td>
							<!--- Codigo de articulo o de concepto--->
							<td nowrap class="LetraDetalle">
								<cfif qryLista.DDRtipoitem EQ 'A'>
									#qryLista.Acodigo#
								<cfelseif qryLista.DDRtipoitem EQ 'S'>
									#qryLista.Ccodigo#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<!--- Numero de parte --->
							<td nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.NumParte))>
									#qryLista.NumParte#
								<cfelse>
									&nbsp;
								</cfif>							
							</td>
							<!--- Codigo de la unidad de medida de la linea de recepcion --->
							<td nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.Ucodigo))>
									#qryLista.Ucodigo#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<!--- Cantidad facturada --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DDRcantorigen))>
									#LSNumberFormat(qryLista.DDRcantorigen, ',9.00')#
								<cfelse>
									0.00
								</cfif>							
							</td>							
							<!--- Cantidad recibida --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DDRcantrec))>
									#LSNumberFormat(qryLista.DDRcantrec, ',9.00')#
								<cfelse>
									0.00
								</cfif>							
							</td>
							<!--- Precio unitario --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DDRpreciou))>
									#LvarOBJ_PrecioU.enCF_RPT(qryLista.DDRpreciou)#
								<cfelse>
									0.00
								</cfif>							
							</td>
							<!--- Monto de descuento --->
							<td align="right" nowrap class="LetraDetalle">
								<cfoutput>#LSNumberFormat((qryLista.DDRcantorigen * qryLista.DDRpreciou) * (qryLista.DDRdescporclin / 100), ',9.00')#</cfoutput>
							</td>
							<!--- Subtotal --->
							<td align="right" nowrap class="LetraDetalle">
								<cfoutput>#LSNumberFormat(calcularSubTotal(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin), ',9.00')#</cfoutput>
							</td>
							<!--- Porcentaje descuento de la factura --->
							<td align="center" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.Icodigo))>
									#qryLista.Icodigo# (#qryLista.Iporcentaje#%)
								<cfelse>
									0.00
								</cfif>							
							</td>
							<!--- Recupera impuesto --->
							<td align="center" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.Icodigo)) and qryLista.Icreditofiscal EQ 1>
									X
								<cfelse>
									&nbsp;
								</cfif>							
							</td>
							<!--- Monto del impuesto --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif len(trim(qryLista.EPDid))>
									0.00
								<cfelse>
									<cfoutput>#LSNumberFormat(calcularImpuesto(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin, qryLista.Iporcentaje), ',9.00')#</cfoutput>
								</cfif>
							</td>
							<!--- Total de linea facturado --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif len(trim(qryLista.EPDid))>
									<cfset lineaFactura = calcularMonto(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin, 0.00)>
								<cfelse>
									<cfset lineaFactura = calcularMonto(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin, qryLista.Iporcentaje)>
								</cfif>
								<cfset totalFactura = totalFactura + lineaFactura>
								<cfoutput>#LSNumberFormat(lineaFactura, ',9.00')#</cfoutput>
							</td>
							<!--- Numero de reclamo --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif len(trim(qryLista.EDRid)) and qryLista.DDRgenreclamo eq 1>
									#qryLista.NumFactura#
								<cfelse>
									&nbsp;
								</cfif>					
							</td>
							<!--- Cantidad reclamo --->
							<td align="right" nowrap class="LetraDetalle">
								<cfset lineaReclamo =0>
								<cfif qryLista.DDRgenreclamo eq 1>
									<cfif len(trim(qryLista.EPDid))>
										<cfset lineaReclamo = calcularReclamo(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin,
																			  qryLista.Iporcentaje, qryLista.DOcantsaldo, qryLista.DDRpreciou,
																			  qryLista.DDRdescporclin, qryLista.Iporcentaje, qryLista.DDRcantrec,
																			  qryLista.Ctolerancia, qryLista.Mcodigo, qryLista.McodigoOC,
																			  qryLista.EDRtc, qryLista.EOtc, qryLista.factorConversionU, 
																			  qryLista.DDRtipoitem, qryLista.ArticuloTieneTolerancia,qryLista.EPDid,qryLista.DDRaprobtolerancia)>
										<cfset LvartotalReclamo =  lineaReclamo[1]>
										<cfset LvarUnidadesNoRecibidas =  lineaReclamo[5]>		
									<cfelse>
										<cfset lineaReclamo = calcularReclamo(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin,
																			  qryLista.Iporcentaje, qryLista.DOcantsaldo, qryLista.DDRprecioorig,
																			  qryLista.DOporcdesc, qryLista.IporcentajeOC, qryLista.DDRcantrec,
																			  qryLista.Ctolerancia, qryLista.Mcodigo, qryLista.McodigoOC,
																			  qryLista.EDRtc, qryLista.EOtc, qryLista.factorConversionU, 
																			  qryLista.DDRtipoitem, qryLista.ArticuloTieneTolerancia,0,qryLista.DDRaprobtolerancia)>
									  	<cfset LvartotalReclamo =  lineaReclamo[1]>
										<cfset LvarUnidadesNoRecibidas =  lineaReclamo[5]>		
									</cfif>	
																								  
								<cfelse>
										<cfset LvartotalReclamo =  0>
										<cfset LvarUnidadesNoRecibidas =0>
								</cfif>
								
								

								<cfset totalReclamo = totalReclamo + LvartotalReclamo>
							
							
								<cfif Len(Trim(qryLista.DDRcantorigen))>
									#LSNumberFormat((LvarUnidadesNoRecibidas), ',9.00')#
								<cfelse>
									0.00
								</cfif>							
							</td>
							<!--- Cantidad en la orden --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DOcantidad))>
									#LSNumberFormat(qryLista.DOcantidad, ',9.00')#
								<cfelse>
									0.00
								</cfif>							
							</td>
							<!--- Precio en la orden --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DDRprecioorig))>
									#LvarOBJ_PrecioU.enCF_RPT(qryLista.DDRprecioorig)#
								<cfelse>
									0.00
								</cfif>
							</td>
							<!--- % Descuento en la orden --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.DOporcdesc))>
									#LSNumberFormat(qryLista.DOporcdesc, ',9.00')#
								<cfelse>
									0.00
								</cfif>
							</td>
							<!--- % Impuesto en la orden --->
							<td align="right" nowrap class="LetraDetalle">
								<cfif Len(Trim(qryLista.IporcentajeOC))>
									#LSNumberFormat(qryLista.IporcentajeOC, ',9.00')#
								<cfelse>
									0.00
								</cfif>
							</td>
							<!--- Monto del reclamo --->
							<td align="right" nowrap class="LetraDetalle">
							
								<cfoutput>#LSNumberFormat(LvartotalReclamo, ',9.00')#</cfoutput>
							</td>
							<!--- Monto real recibido --->
							<td align="right" nowrap class="LetraDetalle">
								<cfoutput>#LSNumberFormat(lineaFactura - LvartotalReclamo, ',9.00')#</cfoutput>
							</td>
						</tr>
						
						<!--- Descripcion del articulo o concepto y cuenta financiera --->
						<tr>
							<td colspan="22" style="border-bottom: lpx solid black; " class="LetraDetalle">
								<cfif qryLista.DDRtipoitem EQ 'A'>
									#qryLista.Adescripcion#/
								<cfelseif qryLista.DDRtipoitem EQ 'S'>
									#qryLista.Cdescripcion#/
								<cfelse>
									/&nbsp;
								</cfif>
								
								<cfoutput>&nbsp;#qryLista.CFformato#&nbsp;</cfoutput>
							</td>
						</tr>
						
						<!--- Descripciones alternas y observaciones de la linea --->
						<tr>
							<td colspan="22" style="border-bottom: 1px solid black; " class="LetraDetalle">
								<cfif Len(Trim(qryLista.DOalterna))>
									#qryLista.DOalterna#/
								<cfelse>
									&nbsp;
								</cfif>
						
								<cfif Len(Trim(qryLista.DOobservaciones))>
									#qryLista.DOobservaciones#&nbsp;
								<cfelse>
									&nbsp;--
								</cfif>			
							</td>									
						</tr>								
						
					</cfloop>
					
					<cfif qryLista.RecordCount>
					
						<!--- Corte de la ultima factura --->
						<!--- Pintado de los totales por factura (factura, reclamo, monto real recibido) --->
						<tr>
							<td style="border-bottom: 1px solid black; " colspan="13" align="left" nowrap class="LetraEncab">Totales en #qryLista.Mnombre#:<br></td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalFactura, ',9.00')#<br></td>
							<td style="border-bottom: 1px solid black; " colspan="6">&nbsp; <br></td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalReclamo, ',9.00')#<br></td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalFactura - totalReclamo, ',9.00')#<br></td>
						</tr>
						<tr>
							<td colspan="22">&nbsp;</td>
						</tr>
						
						<cfset totalReclamo = 0>
						<cfset totalFactura = 0>

						<!--- Suma General de las lineas --->
						
						<!--- Query para la lista de Monedas del Socio --->
						<cfquery name="rsMonedasSocio" dbtype="query">
							select distinct Mcodigo
							from qryLista
							order by Mcodigo
						</cfquery>
						
						<!--- Para cada moneda encontrada, se hace la sumatoria de las facturas con esa moneda --->
						<cfloop query="rsMonedasSocio">
							<!--- Se obtienen las lineas de las facturas que tengan esa moneda --->							
							<cfquery name="rsLineasPorMoneda" dbtype="query">
								select DDRcantorigen, DDRdescporclin, Iporcentaje, 
									   DDRpreciou, 
									   DDRprecioorig,
									   DOporcdesc, IporcentajeOC, DDRcantrec, Ctolerancia, Mnombre, EDRtc, EOtc, factorConversionU,
									   Mcodigo, McodigoOC, DOcantsaldo, DDRgenreclamo, DDRtipoitem, ArticuloTieneTolerancia,
									   EPDid,DDRaprobtolerancia
								from qryLista
								where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedasSocio.Mcodigo#">
							</cfquery>
							
							<!--- Se hace la sumatoria --->
							<cfset totalesFactura = 0>
							<cfset totalesReclamo = 0>
							<cfset LvarTotalFinal = 0>
							<cfloop query="rsLineasPorMoneda">
								<cfset totalesFactura = totalesFactura + calcularMonto(rsLineasPorMoneda.DDRcantorigen, rsLineasPorMoneda.DDRpreciou,
																						   rsLineasPorMoneda.DDRdescporclin, rsLineasPorMoneda.Iporcentaje)>
								<cfif rsLineasPorMoneda.DDRgenreclamo eq 1>
									<cfif len(trim(rsLineasPorMoneda.EPDid))>
										<cfset totalesReclamo = calcularReclamo(rsLineasPorMoneda.DDRcantorigen, rsLineasPorMoneda.DDRpreciou,
																								 rsLineasPorMoneda.DDRdescporclin, rsLineasPorMoneda.Iporcentaje,
																								 rsLineasPorMoneda.DOcantsaldo, rsLineasPorMoneda.DDRprecioorig,
																								 rsLineasPorMoneda.DOporcdesc, rsLineasPorMoneda.IporcentajeOC,
																								 rsLineasPorMoneda.DDRcantrec, rsLineasPorMoneda.Ctolerancia,
																								 rsLineasPorMoneda.Mcodigo, rsLineasPorMoneda.McodigoOC,
																								 rsLineasPorMoneda.EDRtc, rsLineasPorMoneda.EOtc, rsLineasPorMoneda.factorConversionU,
																								 rsLineasPorMoneda.DDRtipoitem,
																								 rsLineasPorMoneda.ArticuloTieneTolerancia,
																								 rsLineasPorMoneda.EPDid,rsLineasPorMoneda.DDRaprobtolerancia)>
										<cfset LvartotalesReclamo =  totalesReclamo[1]>
									<cfelse>
										<cfset totalesReclamo = calcularReclamo(rsLineasPorMoneda.DDRcantorigen, rsLineasPorMoneda.DDRpreciou,
																								rsLineasPorMoneda.DDRdescporclin,rsLineasPorMoneda.Iporcentaje,
																								rsLineasPorMoneda.DOcantsaldo, rsLineasPorMoneda.DDRprecioorig,
																								rsLineasPorMoneda.DOporcdesc, rsLineasPorMoneda.IporcentajeOC,
																								rsLineasPorMoneda.DDRcantrec,rsLineasPorMoneda.Ctolerancia,
																								rsLineasPorMoneda.Mcodigo, rsLineasPorMoneda.McodigoOC,
																								rsLineasPorMoneda.EDRtc, rsLineasPorMoneda.EOtc, rsLineasPorMoneda.factorConversionU, 
																								rsLineasPorMoneda.DDRtipoitem,
																								rsLineasPorMoneda.ArticuloTieneTolerancia,
																								0,rsLineasPorMoneda.DDRaprobtolerancia)>									
										<cfset LvartotalesReclamo =  totalesReclamo[1]>
									</cfif>
									<cfset LvarTotalFinal = LvarTotalFinal + LvartotalesReclamo>
								</cfif>
							</cfloop>

							<!--- Se hace el pintado de los totales generales de facturas, reclamos y montos reales recibidos--->
							<tr>
								<td style="border-bottom: 1px solid black; " colspan="13" align="left" nowrap class="LetraEncab">Totales Generales en #rsLineasPorMoneda.Mnombre#:</td>
								<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalesFactura, ',9.00')#</td>
								<td style="border-bottom: 1px solid black; " colspan="6">&nbsp;</td>
								<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(LvarTotalFinal, ',9.00')#<br></td>
								<td style="border-bottom: 1px solid black; " align="right" nowrap class="LetraEncab">#LSNumberFormat(totalesFactura - LvarTotalFinal, ',9.00')#</td>
							</tr>
						</cfloop>
					</cfif>
				<!--- Si no encontro registros --->
				<cfelse>
					<tr>
						<td colspan="22" align="center" class="listaCorte">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="22" align="center" class="listaCorte">
							<strong>----------------------------------  No se encontraron registros ----------------------------------</strong>
						</td>
					</tr>
				</cfif>
				<tr><td colspan="22">&nbsp;</td></tr>
				<!--- Fin del reporte --->
				<cfif qryLista.RecordCount NEQ 0>
					<tr>
						<td colspan="22" align="center" class="listaCorte">
							<strong>----------------------------------   Fin del reporte   ----------------------------------</strong>
						</td>
					</tr>					
				</cfif>
			</table>
		</td>		
	</tr>
</table>
</cfoutput>
