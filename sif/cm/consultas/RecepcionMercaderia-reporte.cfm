<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
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
<cfif isdefined("url.fEDRestado") and not isdefined("form.fEDRestado")>
	<cfset form.fEDRestado = Url.fEDRestado>
</cfif>
<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
	<cfset form.Usucodigo = Url.Usucodigo>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = Url.Mcodigo>
</cfif>

<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">

<!--- Contiene la función que calcula el monto de los reclamos --->
<cfinclude template="../operacion/docum-funciones.cfm">

<cfquery name="qryLista" datasource="#session.dsn#">
	select  
		
			hedr.EDRestado,
			hedr.EDRid,
			hedr.SNcodigo,
			sn.SNnombre,
			sn.SNidentificacion,
			hedr.EDRnumero as NumFactura, 
			hedr.EDRfechadoc,
			hedr.EDRfecharec,
			hedr.Usucodigo,
			eocm.EOplazo,
			eocm.EOnumero,
			docm.DOconsecutivo,
			docm.DOcantidad,
			hddr.DDRtipoitem,
			art.Acodigo,
			art.Adescripcion,
			con.Ccodigo,
			con.Cdescripcion,
			alm.Almcodigo,
			coalesce(npp.NumeroParte,art.Acodalterno) as numparte,
			docm.Ucodigo,			  <!---►►Unidad de la Orden Compra◄◄--->
            art.Ucodigo as UcodigoRec,<!---►►Unidad de la recepcion◄◄--->
			hddr.DDRcantordenconv,
			hddr.DDRcantrec,
			hddr.DDRcantorigen,		  <!---►►Cantidad Factura◄◄--->
            Coalesce(kar.Kunidades,hddr.DDRcantorigen * cu.CUfactor, hddr.DDRcantorigen * cua.CUAfactor,hddr.DDRcantorigen) as CantidadRec,	  <!---►►Cantidad Recibida◄◄--->
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,
			
			(select MontoReclamo
				from DReclamos rec
				where rec.DDRlinea = hddr.DDRlinea
			)  as MontoReclamo,
			
			(select UnidadesNoRecibidas
				from DReclamos rec
				where rec.DDRlinea = hddr.DDRlinea
			)  as UnidadesNoRecibidas,
			
			
			floor(docm.DOcantexceso) as Exceso,
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRprecioorig")#,
			hddr.DDRdesclinea,
			hddr.DDRtotallincd,
			hddr.DDRmtoimpfact,
			hddr.DDRtotallincd + hddr.DDRmtoimpfact as total,
			hddr.DDRgenreclamo,														<!--- Indica si la linea genera reclamo --->
			imp.Icodigo,
			imp.Idescripcion,
			coalesce(imp.Iporcentaje, 0) as Iporcentaje,
			imp.Icreditofiscal,
			impOC.Iporcentaje as IporcentajeOC,										<!--- Porcentaje de impuesto de la orden de compra --->
			case when docm.Ucodigo = hddr.Ucodigo then 1
									 when cu.CUfactor is not null then cu.CUfactor
									 when cua.CUAfactor is not null then cua.CUAfactor
									 else case when hddr.DDRcantorigen = 0 then 0
									 		   else hddr.DDRcantordenconv / hddr.DDRcantorigen
											   end
									 end as factorConversionU,											<!--- Factor de conversion (factura a orden) --->
			cfi.CFformato,
			er.EDRnumero,
			dr.DRid,
			DDRcantreclamo as cantReclamo,
			<!---  --dr.DRcantorig - dr.DRcantrec as cantReclamo, --->
			(dr.DRcantorig - dr.DRcantrec) * dr.DRpreciorec as montoReclamo,
			docm.DOcantidad - docm.DOcantsurtida as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
			coalesce(docm.DOporcdesc, 0) as DOporcdesc,								<!--- Porcentaje descuento en la orden de compra --->
			case 
				when hddr.DDRaprobtolerancia = 10 then 1
				else 0
			end as DDRaprobtolerancia,
			case 
				when (hddr.DDRgenreclamo = 1)  and 
					(hddr.DDRaprobtolerancia is null or
					hddr.DDRaprobtolerancia=20)
											then ((coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad)
				else 0
			end Ctolerancia,
			case when clas.Ctolerancia is null then 'F'
				 else 'V'
			end as ArticuloTieneTolerancia,														<!--- Porcentaje de tolerancia del articulo 	(								(coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad as Ctolerancia,)		--->					<!--- Cantidad del saldo en la linea de la orden de compra --->
			docm.DOobservaciones,
			docm.DOalterna,
			eocm.Mcodigo as McodigoOC,
			eocm.EOtc,																<!--- Tipo de cambio en la orden de compra --->
			hedr.EDRtc,																<!--- Tipo de cambio en la factura --->
			hedr.Mcodigo, 
			coalesce(hddr.DDRdescporclin, 0) as DDRdescporclin,						<!--- Porcentaje descuento en la factura --->
			m.Mnombre as Mnombre, 
			m.Miso4217
          
			
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
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between Vdesde and Vhasta

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
		
         <!--- Para obtener el factor de conversion de factura a orden --->
		left outer join ConversionUnidades cu
			 on cu.Ecodigo    = hddr.Ecodigo
			and cu.Ucodigo 	  = docm.Ucodigo
			and cu.Ucodigoref = art.Ucodigo 
            
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
			on docm.Alm_Aid = alm.Aid
			and docm.Ecodigo = alm.Ecodigo
			
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
        
        LEFT OUTER JOIN Kardex kar
        	ON kar.DSlinea = docm.DSlinea
		
	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and DDRtipoitem <> 'F'
	
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

	<cfif isdefined("Form.fEDRestado") and Form.fEDRestado NEQ 'T'>
		and hedr.EDRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fEDRestado#">
	</cfif>
		
	<cfif isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo))>
		and hedr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfif>

	order by hedr.SNcodigo, hedr.Mcodigo, hedr.EDRnumero
</cfquery>

<br>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="24" align="center" style="font-size:17px "><strong>#Session.Enombre#</strong>
		</td></tr>
		<tr><td colspan="24" align="center" style="font-size:15px "><strong>Informe de Entradas</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td colspan="24" align="center"><b>Fecha del reporte:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <br><b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
		</tr>
		<tr>
		  <td colspan="24">&nbsp;</td>
		</tr>
		 <tr>	 	
			<td align="center">
				<table width="100%" border="0" cellspacing="0" cellpadding="2"> 
					<cfif qryLista.RecordCount>
						<cfset cortesocio = "">
						<cfset cortesocioanterior = "">
						<cfset cortefactura = "">
	
						<cfset totallinea = 0>

						<cfloop query="qryLista">
							<cfif isdefined("form.fEDRestado") and trim(form.fEDRestado) eq '10'><!--- Si el estado es aplicado lee la tabla DReclamos --->
								<cfset LvartotalReclamo = 0>
								<cfset LvarUnidadesNoRecibidas = 0>
								
								<cfset LvartotalReclamo =  qryLista.MontoReclamo>
								<cfset LvarUnidadesNoRecibidas =  qryLista.UnidadesNoRecibidas>	
							
							<cfelse><!--- Si no, lee los datos de la función  calcularMonto--->
	<!--- ******************************************************************************************************** --->								
								<cfset LvartotalReclamo = 0>
								<cfset LvarUnidadesNoRecibidas = 0>
								
								<cfset totalReclamo = 0>
								<cfset totalFactura = 0>
								<cfset idPoliza = 0>
												
								<cfset totalFactura = totalFactura + calcularMonto(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin, qryLista.Iporcentaje)>
								<cfif qryLista.DDRgenreclamo eq 1>
									<cfif qryLista.EDRestado eq 10 and qryLista.DOcantsaldo gt 0>
										<cfset totalReclamo = calcularReclamo(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin,
																							  qryLista.Iporcentaje, qryLista.DOcantsaldo, qryLista.DDRprecioorig,
																							  qryLista.DOporcdesc, qryLista.IporcentajeOC, qryLista.DDRcantrec,
																							  qryLista.Ctolerancia, qryLista.Mcodigo, qryLista.McodigoOC,
																							  qryLista.EDRtc, qryLista.EOtc, qryLista.factorConversionU, 
																							  qryLista.DDRtipoitem, qryLista.ArticuloTieneTolerancia,idPoliza,qryLista.DDRaprobtolerancia)>
									<cfelseif qryLista.EDRestado eq 10 and qryLista.DOcantsaldo lte 0>
										<cfset totalReclamo = calcularReclamo(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin,
																							  qryLista.Iporcentaje, qryLista.DOcantidad, qryLista.DDRprecioorig,
																							  qryLista.DOporcdesc, qryLista.IporcentajeOC, qryLista.DDRcantrec,
																							  qryLista.Ctolerancia, qryLista.Mcodigo, qryLista.McodigoOC,
																							  qryLista.EDRtc, qryLista.EOtc, qryLista.factorConversionU, 
																							  qryLista.DDRtipoitem, qryLista.ArticuloTieneTolerancia,idPoliza,qryLista.DDRaprobtolerancia)>														 
									<cfelse>
										<cfset totalReclamo = calcularReclamo(qryLista.DDRcantorigen, qryLista.DDRpreciou, qryLista.DDRdescporclin,
																							  qryLista.Iporcentaje, qryLista.DOcantsaldo, qryLista.DDRprecioorig,
																							  qryLista.DOporcdesc, qryLista.IporcentajeOC, qryLista.DDRcantrec,
																							  qryLista.Ctolerancia, qryLista.Mcodigo, qryLista.McodigoOC,
																							  qryLista.EDRtc, qryLista.EOtc, qryLista.factorConversionU, 
																							  qryLista.DDRtipoitem, qryLista.ArticuloTieneTolerancia,idPoliza,qryLista.DDRaprobtolerancia)>
									
									</cfif>
									<cfset LvartotalReclamo =  totalReclamo[1]>
									<cfset LvarUnidadesNoRecibidas =  totalReclamo[5]>
									
								</cfif>
								
								<cfset idPoliza = 0>
								<cfparam name="LvartotalReclamo" default="0">
								<cfparam name="LvarUnidadesNoRecibidas" default="0">
<!--- ******************************************************************************************************** --->								
							</cfif>
							
							
							
							<cfif cortesocio NEQ qryLista.SNcodigo>
								<cfset cortesocioanterior = cortesocio>
								<cfset cortesocio = qryLista.SNcodigo>
								<cfset cortefactura = qryLista.NumFactura>
								
								<cfif qryLista.currentRow NEQ 1>
								<!--- Pintado del Total de la Factura --->
								<tr>
								  <td style="border-bottom: 1px solid black; " colspan="14"  align="right" nowrap>
									<strong>Total:</strong>
								  </td>
								  <td style="border-bottom: 1px solid black; " align="right" nowrap>
									#LSNumberFormat(totallinea, ',9.00')#
								  </td>
								  <td style="border-bottom: 1px solid black; " nowrap>#qryLista.Mnombre#</td>
								</tr>							
								<cfset totallinea = 0>

								<!--- Query para la lista de Monedas del Socio --->
								<cfquery name="rsMonedasSocio" dbtype="query">
									select distinct Mcodigo
									from qryLista
									where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cortesocioanterior#">
									order by Mcodigo
								</cfquery>
								<cfloop query="rsMonedasSocio">
									<cfquery name="rsTotalMonedas" dbtype="query">
										select sum(total) as total, Mnombre
										from qryLista
										where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cortesocioanterior#">
										and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedasSocio.Mcodigo#">
										group by Mnombre
									</cfquery>
									<!--- Suma de totales de línea --->
									<tr>
									  <td style="border-bottom: 1px solid black; " colspan="14" align="right" nowrap>
										<strong>Total en #rsTotalMonedas.Mnombre#:</strong>
									  </td>
									  <td style="border-bottom: 1px solid black; " align="right" nowrap>
										#LSNumberFormat(rsTotalMonedas.total, ',9.00')#
									  </td>
									  <td style="border-bottom: 1px solid black; " colspan="6">&nbsp;</td>
									</tr>
									<cfset totallinea = 0>
								</cfloop>
								</cfif> <!--- qryLista.currentRow NEQ 1 --->
								
								<!--- Pintado de Corte por Socio --->
								<tr>
									<td colspan="22" class="areaFiltro">
										<table border="0" cellspacing="0" cellpadding="2">
										  <tr>
											  <td><font size="2"><strong>#qryLista.SNnombre#&nbsp;-&nbsp;</strong></font></td>
											  <td><font size="2"><strong>#qryLista.SNidentificacion#&nbsp;</strong></font></td>
										  </tr>
										</table>
									</td>
								</tr>
								<!--- Encabezado Factura --->
								<tr>
									<td colspan="22">
										<table border="0" cellspacing="0" cellpadding="2">
										  <tr>
											  <td align="right"><strong>Factura:&nbsp;</strong></td>
											  <td>#cortefactura#</td>
											  <td align="right"><strong>Fecha:&nbsp;</strong></td>
											  <td>#LSDateFormat(qryLista.EDRfechadoc, 'dd/mm/yyyy')#</td>
											  <td align="right"><strong>Plazo:&nbsp;</strong></td>
											  <td>#qryLista.EOplazo#</td>
											  <td align="right"><strong>Fecha de Entrega:&nbsp;</strong></td>
											  <td>#LSDateFormat(qryLista.EDRfecharec, 'dd/mm/yyyy')#</td>
											  <td align="right"><strong>Bodega:&nbsp;</strong></td>
											  <td><cfif Len(Trim(qryLista.Almcodigo))>#qryLista.Almcodigo#<cfelse>---</cfif></td>
											  <td align="right"><strong>Moneda:&nbsp;</strong></td>
											  <td>#qryLista.Mnombre#</td>
											  <td>
											  	<cfquery name="rsDatosUsuario" datasource="asp">
													select Pnombre#_Cat#' '#_Cat#Papellido1#_Cat#' '#_Cat#Papellido2 as nombre
													from Usuario a
														inner join DatosPersonales b
															on a.datos_personales = b.datos_personales
													where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 	
														and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.Usucodigo#">
												</cfquery>
												<cfif isdefined("rsDatosUsuario") and rsDatosUsuario.RecordCount NEQ 0>
													<strong>Usuario:</strong>&nbsp;#rsDatosUsuario.nombre#
												</cfif>
											  </td>
										  </tr>
										</table>
									</td>
								</tr>
								<!--- Linea de Encabezado --->
								<tr>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black;">O.C.</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Línea</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
								  <!--- <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Bodega</td> --->
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m. Parte</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descripci&oacute;n del Art&iacute;culo</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unidad<br />OC</td>
                                  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unidad<br />Recepción</td>
<!-----								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unds. Conv. a UM de O.C.</td>---->
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Recibida</td>
                                  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Ingresada</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio <br> Unitario</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descuento</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Sub Total</td>
								  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">% Imp.</td>
								  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Recup. <br> Impuesto</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Total L&iacute;nea</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cuenta <br> Financiera</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m. <br> Reclamo</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cant. <br> Reclamo</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Reclamo</td>				  
								</tr>
							</cfif>
							
							<cfif cortefactura NEQ qryLista.NumFactura>
								<cfset cortefactura = qryLista.NumFactura>
								<cfif qryLista.currentRow NEQ 1>
								<!--- Pintado del Total de la Factura --->
								<tr>
								  <td style="border-bottom: 1px solid black; " colspan="14"  align="right" nowrap>
									<strong>Total:</strong>
								  </td>
								  <td style="border-bottom: 1px solid black; " align="right" nowrap>
									#LSNumberFormat(totallinea, ',9.00')#
								  </td>
								  <td style="border-bottom: 1px solid black; " nowrap>#qryLista.Mnombre#</td>
								  <td style="border-bottom: 1px solid black; " colspan="5">&nbsp;</td>
								</tr>							
								<cfset totallinea = 0>
								</cfif> <!--- qryLista.currentRow NEQ 1 --->

								<!--- Encabezado Factura --->
								<tr>
									<td colspan="22">
										<table border="0" cellspacing="0" cellpadding="2">
										  <tr>
											  <td align="right"><strong>Factura:&nbsp;</strong></td>
											  <td>#cortefactura#</td>
											  <td align="right"><strong>Fecha:&nbsp;</strong></td>
											  <td>#LSDateFormat(qryLista.EDRfechadoc, 'dd/mm/yyyy')#</td>
											  <td align="right"><strong>Plazo:&nbsp;</strong></td>
											  <td>#qryLista.EOplazo#</td>
											  <td align="right"><strong>Fecha de Entrega:&nbsp;</strong></td>
											  <td>#LSDateFormat(qryLista.EDRfecharec, 'dd/mm/yyyy')#</td>
											  <td align="right"><strong>Bodega:&nbsp;</strong></td>
											  <td><cfif Len(Trim(qryLista.Almcodigo))>#qryLista.Almcodigo#<cfelse>---</cfif></td>

											  <td align="right"><strong>Moneda:&nbsp;</strong></td>
											  <td>#qryLista.Mnombre#</td>
											  <td>
											  	<cfquery name="rsDatosUsuario" datasource="asp">
													select Pnombre#_Cat#' '#_Cat#Papellido1#_Cat#' '#_Cat#Papellido2 as nombre
													from Usuario a
														inner join DatosPersonales b
															on a.datos_personales = b.datos_personales
													where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 	
														and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.Usucodigo#">
												</cfquery>
												<cfif isdefined("rsDatosUsuario") and rsDatosUsuario.RecordCount NEQ 0>
													<strong>Usuario:</strong>&nbsp;#rsDatosUsuario.nombre#
												</cfif>
											  </td>
										  </tr>
										</table>
									</td>
								</tr>
								<!--- Linea de Encabezado --->
								<tr>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black;">O.C.</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Línea</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
								  <!--- <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Bodega</td> --->
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m. de Parte</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descripci&oacute;n del Art&iacute;culo</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unidad<br />OC</td>
                                  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unidad<br />Recepción</td>
<!-----								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unds. Conv. a UM de O.C.</td>---->
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Recibida</td>
                                  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Ingresada</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio <br> Unitario</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descuento</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Sub Total</td>
								  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">% Imp.</td>
								  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Recup. <br> Impuesto</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Total L&iacute;nea</td>
								  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cuenta <br> Financiera</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;m.<br>Reclamo</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cant. <br> Reclamo</td>
								  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Reclamo</td>				  
								</tr>
							</cfif>
							<tr>
								<td  nowrap>#qryLista.EOnumero#</td>
								<td  nowrap>#qryLista.DOconsecutivo#</td>
								<td  nowrap>
									<cfif qryLista.DDRtipoitem EQ 'A'>
										#qryLista.Acodigo#
									<cfelseif qryLista.DDRtipoitem EQ 'S'>
										#qryLista.Ccodigo#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<!--- <td  nowrap>
									<cfif Len(Trim(qryLista.Almcodigo))>
										#qryLista.Almcodigo#
									<cfelse>
										&nbsp;
									</cfif>
								</td> --->
								<td nowrap>
									<cfif Len(Trim(qryLista.numparte))>
										#qryLista.numparte#
									<cfelse>
										&nbsp;
								</cfif>							
								</td>
								<td >
									<cfif qryLista.DDRtipoitem EQ 'A'>
										#qryLista.Adescripcion#
									<cfelseif qryLista.DDRtipoitem EQ 'S'>
										#qryLista.Cdescripcion#
									<cfelse>
										&nbsp;
								</cfif>							</td>
                                <!---►►Unidad de la Orden Compra◄◄--->
								<td nowrap>
									<cfif Len(Trim(qryLista.Ucodigo))>
										#qryLista.Ucodigo#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
                                <!---►►Unidad de la recepción◄◄--->
                                <td nowrap>#qryLista.UcodigoRec#</td>
							    <!---►►Cantidad Recepcion◄◄--->
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.DDRcantrec))>
										#LSNumberFormat(qryLista.DDRcantrec, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>	
                                </td>
                                <!---►►Cantidad Ingresada a inventario◄◄--->
								<td align="right" nowrap>
									#LSNumberFormat(qryLista.CantidadRec, ',9.00')#
                                </td>
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.DDRpreciou))>
										#LvarOBJ_PrecioU.enCF_RPT(qryLista.DDRpreciou)#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.DDRdesclinea))>
										#LSNumberFormat(qryLista.DDRdesclinea, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.DDRtotallincd))>
										#LSNumberFormat(qryLista.DDRtotallincd, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="center" nowrap>
									<cfif Len(Trim(qryLista.Icodigo))>
										#qryLista.Icodigo# (#qryLista.Iporcentaje#%)
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="center" nowrap>
									<cfif Len(Trim(qryLista.Icodigo)) and qryLista.Icreditofiscal EQ 1>
										X
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.DDRmtoimpfact))>
										#LSNumberFormat(qryLista.DDRmtoimpfact, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="right" nowrap>
									<cfif Len(Trim(qryLista.total))>
										#LSNumberFormat(qryLista.total, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td nowrap>#qryLista.CFformato#</td>
								<td align="right" nowrap>
									<!----<cfif Len(Trim(qryLista.EDRnumero))>--->
								 	<cfif len(trim(qryLista.DRid))>
										#qryLista.EDRnumero#
									<cfelse>
										&nbsp;
									</cfif>					
								</td>
								<td align="right" nowrap>
									<cfif Len(Trim(LvarUnidadesNoRecibidas))>
										#LSNumberFormat(LvarUnidadesNoRecibidas, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif>							</td>
								<td align="right" nowrap>
									<cfif isdefined("LvartotalReclamo") and Len(Trim(LvartotalReclamo))>
										#LSNumberFormat(LvartotalReclamo, ',9.00')#
									<cfelse>
										&nbsp;
								</cfif></td>	

								<tr>
									<td colspan="20" style="border-bottom: 1px solid black; ">
										<cfif Len(Trim(qryLista.DOalterna))>
											#qryLista.DOalterna#/
										<cfelse>
											&nbsp;
										</cfif>
										&nbsp;
										<cfif Len(Trim(qryLista.DOobservaciones))>
											#qryLista.DOobservaciones#&nbsp;
										<cfelse>
											&nbsp;--
										</cfif>
									</td>
								</tr>

							<cfif Len(Trim(qryLista.total))>
								<cfset totallinea = totallinea + qryLista.total>
							</cfif>
						</cfloop>
						<cfif qryLista.RecordCount>
							<!--- Pintado del Total de la ultima linea de la Factura --->
							<tr>
							  <!----<td style="border-bottom: 1px solid black; " colspan="14" nowrap>&nbsp;</td>---->
							  <td style="border-bottom: 1px solid black; " colspan="14" align="right" nowrap>
								<strong>Total:</strong>
							  </td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>
								#LSNumberFormat(totallinea, ',9.00')#
							  </td>
							  <td style="border-bottom: 1px solid black; " nowrap>#qryLista.Mnombre#</td>
							  <td style="border-bottom: 1px solid black; " colspan="5">&nbsp;</td>
							</tr>							
							<cfset totallinea = 0>

							<!--- Query para la lista de Monedas del Socio --->
							<cfquery name="rsMonedasSocio" dbtype="query">
								select distinct Mcodigo
								from qryLista
								where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cortesocio#">
								order by Mcodigo
							</cfquery>
							<cfloop query="rsMonedasSocio">
								<cfquery name="rsTotalMonedas" dbtype="query">
									select sum(total) as total, Mnombre
									from qryLista
									where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cortesocio#">
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedasSocio.Mcodigo#">
									group by Mnombre
								</cfquery>
								<!--- Suma de totales de línea --->
								<tr>
								  <!---<td style="border-bottom: 1px solid black; " colspan="14" nowrap>&nbsp;</td>---->
								  <td style="border-bottom: 1px solid black; " colspan="14" align="right" nowrap>
									<strong>Total en #rsTotalMonedas.Mnombre#:</strong>
								  </td>
								  <td style="border-bottom: 1px solid black; " align="right" nowrap>
									#LSNumberFormat(rsTotalMonedas.total, ',9.00')#
								  </td>
								  
								</tr>							
								<cfset totallinea = 0>
							</cfloop>

							<!--- SUMA GENERAL DE LAS LÍNEAS --->
							<!--- Query para la lista de Monedas del Socio --->
							<cfquery name="rsMonedasSocio" dbtype="query">
								select distinct Mcodigo
								from qryLista
								order by Mcodigo
							</cfquery>
							<cfloop query="rsMonedasSocio">
								<cfquery name="rsTotalMonedas" dbtype="query">
									select sum(total) as total, Mnombre
									from qryLista
									where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedasSocio.Mcodigo#">
									group by Mnombre
								</cfquery>
								<!--- Suma de totales de línea --->
								<tr>
								  <!----<td style="border-bottom: 1px solid black; " colspan="14" nowrap>&nbsp;</td>--->
								  <td style="border-bottom: 1px solid black; " colspan="14" align="right" nowrap>
									<strong>Total General en #rsTotalMonedas.Mnombre#:</strong>
								  </td>
								  <td style="border-bottom: 1px solid black; " align="right" nowrap>
									#LSNumberFormat(rsTotalMonedas.total, ',9.00')#
								  </td>
								  <td style="border-bottom: 1px solid black; " >&nbsp;</td>
								</tr>
								<cfset totallinea = 0>
							</cfloop>

						</cfif>
					<cfelse>
						<tr>
							<td colspan="22" align="center" class="listaCorte">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="22" align="center" class="listaCorte"><strong>----------------------------------  No se encontraron registros ----------------------------------</strong></td>
						</tr>
					</cfif>
					<tr><td colspan="22">&nbsp;</td></tr>
					<cfif qryLista.RecordCount NEQ 0>
						<tr>
							<td colspan="22" align="center" class="listaCorte"><strong>----------------------------------   Fin del reporte   ----------------------------------</strong></td>
						</tr>					
					</cfif>
				</table>
			</td>		
		</tr>
	</table>
</cfoutput>
