<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cftransaction>
<cfquery name="detallesDDRReclamos" datasource="#session.dsn#">
	select  
			hddr.DDRlinea,
			hddr.DDRcantorigen,														<!--- Cantidad factura --->
			hddr.DDRcantrec,														<!--- Cantidad recibida --->
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,							<!--- Precio factura --->
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRprecioorig")#,						<!--- Precio orden de compra --->
			coalesce(imp.Iporcentaje, 0) as Iporcentaje,							<!--- Porcentaje impuesto en la factura --->
			hedr.Mcodigo,															<!--- Codigo de la moneda de la factura --->
			coalesce(hddr.DDRdescporclin, 0) as DDRdescporclin,						<!--- Porcentaje descuento en la factura --->
			docm.DOcantidad - (docm.DOcantsurtida + docm.DOcantSurtSinDoc) as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
			coalesce(docm.DOporcdesc, 0) as DOporcdesc,								<!--- Porcentaje descuento en la orden de compra --->
			case 
				when hddr.DDRaprobtolerancia = 10 then 1
				else 0
			end DDRaprobtolerancia,
			
			case 
				when (hddr.DDRgenreclamo = 1)  and 
					(hddr.DDRaprobtolerancia is null or
					hddr.DDRaprobtolerancia = 0 or 
					hddr.DDRaprobtolerancia = 5 or	
					hddr.DDRaprobtolerancia=20)
											then ((coalesce(clas.Ctolerancia, 0) / 100) * (docm.DOcantidad - (docm.DOcantsurtida + docm.DOcantSurtSinDoc)))
				else 0
			end Ctolerancia,														<!--- Porcentaje de tolerancia del articulo 	(								(coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad as Ctolerancia,)		--->
			case when clas.Ctolerancia is null then 'F'
				 else 'V'
			end as ArticuloTieneTolerancia,
			impOC.Iporcentaje as IporcentajeOC,										<!--- Porcentaje de impuesto de la orden de compra --->
			case when docm.Ucodigo = hddr.Ucodigo then 1
				 when cu.CUfactor is not null then cu.CUfactor
				 when cua.CUAfactor is not null then cua.CUAfactor
				 else case when hddr.DDRcantorigen = 0 then 0
						   else hddr.DDRcantordenconv / hddr.DDRcantorigen
						   end
				 end as factorConversionU,											<!--- Factor de conversion (factura a orden) --->
			eocm.EOtc,																<!--- Tipo de cambio en la orden de compra --->
			hedr.EDRtc,																<!--- Tipo de cambio en la factura --->
			eocm.Mcodigo as McodigoOC,												<!--- Codigo de la moneda de la orden de compra asociada --->
			hddr.DDRgenreclamo,														<!--- Indica si la linea genera reclamo --->
			hddr.DDRtipoitem,
			hedr.EPDid
			
	from EDocumentosRecepcion hedr
	
		inner join DDocumentosRecepcion hddr
			on  hedr.EDRid = hddr.EDRid
			and hedr.Ecodigo = hddr.Ecodigo
									
		inner join DOrdenCM docm		
			on hddr.DOlinea = docm.DOlinea
			and hddr.Ecodigo = docm.Ecodigo	
		
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

		left outer join Impuestos imp
			on hddr.Icodigo = imp.Icodigo
			and hddr.Ecodigo = imp.Ecodigo
	
	where hedr.Ecodigo = #session.Ecodigo#
	and hddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
</cfquery>

	<!--- Afectacion de Orden de Compra--->
	<cfquery datasource="#session.DSN#" name="dataOrden">
		select 	a.DDRlinea, 
				a.DOlinea, 
				a.DDRcantorigen, 
				a.DDRgenreclamo,
				a.DDRcantordenconv,
				a.DDRtipoitem,
                a.DDRcantrec
				a.Aid,
				b.DOcantidad,
                b.CMtipo
		from DDocumentosRecepcion a
		inner join DOrdenCM b
			on a.DOlinea=b.DOlinea
			and a.Ecodigo=b.Ecodigo
		where a.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		  and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<!--- Variable que indica si se realizan los distintos procesos de aplicación o es necesario que
		  el documento se aprueba la tolerancia.
		  Se establece en false cuando es una recepción sin aplicar que tiene líneas
		  que sobrepasaron la tolerancia y el parámetro de Aprobación de Tolerancia está activado --->
	<cfset NoAprobarTolerancia = true>
	
	<cfset Tolerancia = 0>
	<cfif form.tipo eq 'R'><!--- R: Recepción, D: Devolución --->

		<!--- Obtiene el valor del parámetro de Aprobación de Excesos de Tolerancia por Compradores --->
		<cfquery name="rsParametroTolerancia" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 760
		</cfquery>

		<!--- Obtiene el estado de la recepción --->
		<cfquery name="rsEstadoDocumento" datasource="#session.dsn#">
			select edr.EDRestado
			from EDocumentosRecepcion edr
			where edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
				and edr.Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<!--- Si el estado de la recepción es Por Aplicar, y el parámetro de Aprobación
			  de Excesos de Tolerancia en la Recepción está activado, hace la verificación --->
		<cfif rsEstadoDocumento.EDRestado eq 0 and rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1>
		
			<!--- Verifica si hay líneas con exceso de tolerancia --->
			<cfquery name="rsHayExcesoTolerancia" datasource="#session.dsn#">
				select 1
				from DDocumentosRecepcion ddr
					inner join DOrdenCM docm
						on docm.DOlinea = ddr.DOlinea
						and docm.Ecodigo = ddr.Ecodigo
						
					inner join Articulos art
						on art.Aid = docm.Aid
						and art.Ecodigo = docm.Ecodigo
						
					inner join Clasificaciones clas
						on clas.Ccodigo = art.Ccodigo
						and clas.Ecodigo = art.Ecodigo
				where ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					and ddr.Ecodigo = #session.Ecodigo#
					and clas.Ctolerancia is not null
					and ddr.DDRcantordenconv > (docm.DOcantidad - (docm.DOcantsurtida + docm.DOcantSurtSinDoc)) + (docm.DOcantidad * clas.Ctolerancia / 100.00)
			</cfquery>
			
			<!--- Si hay líneas con exceso de tolerancia --->
			<cfif rsHayExcesoTolerancia.RecordCount gt 0>
			
				<!--- No se va a hacer el proceso de aplicación de recepción todavía --->
				<cfset NoAprobarTolerancia = false>
				
				<!--- Actualiza el estado de la recepción a En Aprobación de Tolerancia --->
				<cfquery name="rsUpdateEstadoDocumento" datasource="#session.dsn#">
					update EDocumentosRecepcion
					set EDRestado = -5
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and Ecodigo = #session.Ecodigo#
				</cfquery>
				
				<!--- Actualiza el estado de las líneas que excedieron la tolerancia, a en espera de aprobación --->
				<cfquery name="rsUpdateLineasExcesoTolerancia" datasource="#session.dsn#">
					update DDocumentosRecepcion
					set DDRaprobtolerancia = case when (select count(1)
														from DDocumentosRecepcion ddr
															inner join DOrdenCM docm
																on docm.DOlinea = ddr.DOlinea
																and docm.Ecodigo = ddr.Ecodigo
															inner join Articulos art
																on art.Aid = docm.Aid
																and art.Ecodigo = docm.Ecodigo
															inner join Clasificaciones clas
																on clas.Ccodigo = art.Ccodigo
																and clas.Ecodigo = art.Ecodigo
														where ddr.DDRlinea = DDocumentosRecepcion.DDRlinea
															and clas.Ctolerancia is not null
															and ddr.DDRcantordenconv > (docm.DOcantidad - (docm.DOcantsurtida + docm.DOcantSurtSinDoc)) + (docm.DOcantidad * clas.Ctolerancia / 100.00)
														) > 0 then 5
												  else 0 end
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and Ecodigo = #session.Ecodigo#
				</cfquery>
			</cfif>
		</cfif>
	
		<cfloop query="dataOrden">
			<cfif dataOrden.DDRcantorigen lte 0 >
				<cfset Request.Error.Backs = 1 >
				<cf_errorCode	code = "50283" msg = "Error al aplicar documento de Recepción.<br>Existen líneas del documento con cantidades en cero.">
				<cfabort>
			</cfif>

			<!--- afectacion de inventario si factor es mayor o igual a 1--->
			
			<cfif NoAprobarTolerancia>
			
				<!--- (Inicio) Calculo de la tolerancia para el caso de los artículos--->
				<cfif trim(dataOrden.DDRtipoitem) eq 'A' >
					<cfquery name="rsTolerancia" datasource="#session.DSN#">
						select coalesce(Ctolerancia,0) as Ctolerancia
						from  Clasificaciones  A , Articulos B
						where  A.Ecodigo = B.Ecodigo
						and A.Ccodigo = B.Ccodigo
						and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.Aid#">
					</cfquery>	
					<cfset Tolerancia = (rsTolerancia.Ctolerancia * dataOrden.DOCantidad)/100>
				</cfif>
				<!--- (Fin) Calculo de la tolerancia para el caso de los artículos--->
				
				<cfif isdefined('dataOrden.DOlinea') and dataOrden.DOlinea NEQ ''>
					<cfquery datasource="#session.DSN#" name="rsSaldolinea">
						select coalesce((DOcantidad - (DOcantsurtida + DOcantSurtSinDoc)),DOcantidad) as saldo 
						from DOrdenCM
						where DOlinea = #dataOrden.DOlinea#
						  and Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfset saldoL = rsSaldolinea.saldo + Tolerancia>
					<!--- ************************************************************************************ --->					
					
					
					
					<!--- ************************************************************************************ --->
					<cfquery datasource="#session.DSN#">
						<cfif saldoL gte dataOrden.DDRcantordenconv >
							update DOrdenCM
							set DOcantsurtida = DOcantsurtida + #dataOrden.DDRcantordenconv#,
								DOcantexceso = 0
							where DOlinea = #dataOrden.DOlinea#
							  and Ecodigo = #session.Ecodigo#
						<cfelse>
							update DOrdenCM
							set DOcantsurtida = DOcantidad + #Tolerancia#,
								DOcantexceso = #dataOrden.DDRcantordenconv# - #saldoL#
							where DOlinea = #dataOrden.DOlinea#
							  and Ecodigo = #session.Ecodigo#
						</cfif>
					</cfquery>
				</cfif>
			
			</cfif>
		</cfloop>
		
		<cfif NoAprobarTolerancia>
		
			<!-----/-*/-*/-*/-*/-*/-*/-*/-*/-*/*/-*/-*/-*/-*/-*/*/-*/-/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*---->
			<cfquery name="rsVerificaPoliza" datasource="#session.DSN#">
				select EPDid from EDocumentosRecepcion 
				where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
					and Ecodigo=#session.Ecodigo# 
			</cfquery>	
			<!-----///////////////// SI TIENE póliza de desalmacenaje inserta en la tabla CMDetalleTransito////////////////////---->
			<cfif rsVerificaPoliza.RecordCount NEQ 0 and len(trim(rsVerificaPoliza.EPDid))>			
				<cfquery datasource="#session.DSN#">
					insert into CMDetalleTransito (EDIid, 
													DDlinea, 
													Ecodigo, 
													EOidorden, 
													DOlinea, 
													EPDid, 
													DPDlinea, 
													DTfechamov, 
													DTmonto, 
													Mcodigo, 
													tipocambio, 
													ETidtracking, 
													CTcuenta, 
													BMUsucodigo, 
													fechaalta, TipoMovimiento, EDRid, DDRlinea)
					select 	null,
							null,
							#session.Ecodigo#,
							b.EOidorden,
							a.DOlinea,
							d.EPDid,
							e.DPDlinea,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							(a.DDRtotallin + coalesce(e.DPDimpuestosrecup,0.00))* -1.00,
							c.Mcodigo,
							c.EDRtc,
							<cf_dbfunction name="to_number" args="d.EPembarque"> as ETidtracking,							
							coalesce(h.IACtransito, ac.ACcadq),
							#session.Usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							8, a.EDRid, a.DDRlinea
					from DDocumentosRecepcion a
					
						inner join DOrdenCM b
							on a.Ecodigo = b.Ecodigo
							and a.DOlinea = b.DOlinea
							
							left outer join Articulos f
								on b.Ecodigo = f.Ecodigo
								and b.Aid = f.Aid
						
							left outer join Existencias g
								on f.Ecodigo = g.Ecodigo
								and f.Aid = g.Aid
								and g.Alm_Aid = b.Alm_Aid
						
								left outer join  IAContables h
									on g.IACcodigo = h.IACcodigo
									and g.Ecodigo = h.Ecodigo	
									
							left outer join AClasificacion ac
								on ac.Ecodigo = b.Ecodigo
								and ac.ACid = b.ACid
								and ac.ACcodigo = b.ACcodigo
					
						inner join EDocumentosRecepcion	c
							on a.Ecodigo = c.Ecodigo
							and a.EDRid = c.EDRid
								
						inner join EPolizaDesalmacenaje d
							on c.Ecodigo = d.Ecodigo
							and c.EPDid = d.EPDid		
					
							left outer join DPolizaDesalmacenaje e
								on d.Ecodigo = e.Ecodigo
								and d.EPDid = e.EPDid
								and e.DOlinea = a.DOlinea	
					
					where a.EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
						and a.Ecodigo=#session.Ecodigo#
				</cfquery>
			</cfif>
			<!-----/-*/-*/-*/-*/-*/-*/-*/-*/-*/*/-*/-*/-*/-*/-*/*/-*/-/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*---->
            
            
            <!--- 
				1. Si se hace una recepción con transacción tipo remisión de CxP:
					- 1.1 Si es un activo: Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida y se tiene que adquirir el activo.
					- 1.2 Si es un artículo: Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida y también tiene que afectar el invertario (Kardex).
					- 1.3 Si es un concepto (servicio): Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida.
				2. Se hace un asiento de la cuenta pendiente Facturas (Remisión) (Puente) (Crédito) contra la cuenta de Gastos (Resultado) (Débito)
			 --->
             
             <!--- 1. Busca si la transacción de CxP en el documento de recepción es de tipo Remisión --->
             <cfquery name="rsTransaccionCxP" datasource="#session.dsn#">
             	select count(1) as cantidad
                from EDocumentosRecepcion a
                    inner join CPTransacciones b
                      on b.Ecodigo = a.Ecodigo
                      and b.CPTcodigo = a.CPTcodigo
                where a.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
                and b.Ecodigo = #session.Ecodigo#
                and b.CPTremision = 1
             </cfquery>
             
             <cfif rsTransaccionCxP.cantidad eq 1>
			 <!---
				DOrdenCM.CMtipo
				A: Artículo
				F: Activo
				P: Obra
				S: Servicio (concepto)
			  --->
             <cfloop query="dataOrden">
             	<cfset LvarDDRcantrec = dataOrden.DDRcantrec>
                <cfset LvarDOlinea = dataOrden.DOlinea>
                <!--- 1.1, 1.2 y 1.3 es un concepto (servicio) --->
                <!--- Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida. --->
             	<cfquery datasource="#session.DSN#">
                	update DOrdenCM
                    set DOcantSurtSinDoc =  #LvarDDRcantrec#
                    where DOlinea = #LvarDOlinea#
                </cfquery>
             
				 <!--- determina si es Activo, Artículo o Concepto --->
                 <cfif dataOrden.CMtipo eq "F">
                    <!--- 1.1 es un activo: Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida y se tiene que adquirir el activo. --->
                    <cfset LvarPreparaAsientoRemision = fnPreparaAsientoRemision()>
                    
                    
                 <cfelseif dataOrden.CMtipo eq "A">
                    <!--- 1.2 es un artículo: Se aumenta solamente el campo DOcantSurtSinDoc, no se afecta el campo DOcantsurtida y también tiene que afectar el invertario (Kardex). --->
                    
                 </cfif>
             </cfloop>
             
             	<!--- Genera asiento de la cuenta pendiente Facturas (Remisión) (Puente) (Crédito) contra la cuenta de Gastos (Resultado) (Débito)  --->
             
             </cfif>
		</cfif>
	<cfelse>
		<cfloop query="dataOrden">
			<!--- (Inicio) Calculo de la tolerancia para el caso de los artículos--->
			<cfif trim(dataOrden.DDRtipoitem) eq 'A' >
				<cfquery name="rsTolerancia" datasource="#session.DSN#">
					select coalesce(Ctolerancia,0) as Ctolerancia
					from  Clasificaciones  A , Articulos B
					where  A.Ecodigo = B.Ecodigo
					and A.Ccodigo = B.Ccodigo
					and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.Aid#">
				</cfquery>	
				<cfset Tolerancia = (rsTolerancia.Ctolerancia * dataOrden.DOCantidad)/100>
			</cfif>
			<!--- (Fin) Calculo de la tolerancia para el caso de los artículos--->
			<cfif dataOrden.DDRgenreclamo eq 0 >
				<cfquery datasource="#session.DSN#" name="rsSaldolinea">
					select coalesce((DOcantidad - (DOcantsurtida + DOcantSurtSinDoc)),DOcantidad) as saldo 
					from DOrdenCM
					where DOlinea=<cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
					  and Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfset saldoL = rsSaldolinea.saldo + Tolerancia>
				<cfquery datasource="#session.DSN#">
					<cfif saldoL gte dataOrden.DDRcantordenconv >
						update DOrdenCM
						set DOcantsurtida = DOcantsurtida + <cfqueryparam value="#dataOrden.DDRcantordenconv#" cfsqltype="cf_sql_float">,
							DOcantexceso = 0
						where DOlinea=<cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
							and Ecodigo=#session.Ecodigo#
					<cfelse>
						update DOrdenCM
						set DOcantsurtida = DOcantidad + <cfqueryparam value="#Tolerancia#" cfsqltype="cf_sql_float">,
							DOcantexceso = <cfqueryparam value="#dataOrden.DDRcantordenconv#" cfsqltype="cf_sql_float"> - (DOcantidad + <cfqueryparam value="#Tolerancia#" cfsqltype="cf_sql_float">) 
						where DOlinea=<cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
							and Ecodigo=#session.Ecodigo#
					</cfif>				
				</cfquery>
			</cfif>
			<!--- se guarda la cantidad convertida --->
			<cfquery datasource="#session.DSN#">
				update DDocumentosRecepcion
				set DDRcantordenconv = #dataOrden.DDRcantorigen#
				,DOcantexceso = <cfqueryparam value="#Tolerancia#" cfsqltype="cf_sql_float"> 
				where DDRlinea = <cfqueryparam value="#dataOrden.DDRlinea#" cfsqltype="cf_sql_numeric">
				and Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfif NoAprobarTolerancia>
		<!--- Pase a Historicos --->
		<cfquery datasource="#session.DSN#">
			insert into HEDocumentosRecepcion( EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, HEDRestadoreclamo, idBL, Usucodigo, fechaalta )
			select EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, 0, idBL, Usucodigo, fechaalta 
			from EDocumentosRecepcion
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfquery datasource="#session.DSN#">
			insert into HDDocumentosRecepcion (DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal)
			select DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal
			from DDocumentosRecepcion
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<!--- recupera alguno de los compradores registrados en la linea--->
		<cfquery name="dataComprador" datasource="#session.DSN#">
			select c.CMCid
			from DDocumentosRecepcion a
			
			inner join DOrdenCM b
			 on a.Ecodigo=b.Ecodigo
			 and a.DOlinea=b.DOlinea
			
			inner join EOrdenCM c
			 on b.Ecodigo=c.Ecodigo
			 and b.EOidorden=c.EOidorden
	
			
			where a.Ecodigo=#session.Ecodigo#
			and a.EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfquery name="rsGeneraReclamo" datasource="#session.DSN#">
			select *
			from DDocumentosRecepcion
			where Ecodigo = #session.Ecodigo#
			  and DDRgenreclamo=1
			  and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		</cfquery>	  
	
		<!--- GENERACION DE RECLAMOS --->
		<cfset hayReclamo = false >
		<cfif rsGeneraReclamo.RecordCount gt 0>
			<!--- Generacion de Reclamos --->
			<cfquery datasource="#session.DSN#" name="HEDR">
				select Ecodigo, SNcodigo, SNcodigo, EDRid, EDRnumero, EDRobs
					from HEDocumentosRecepcion
					where Ecodigo = #session.Ecodigo#
					  and EDRid   = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
				<cfquery datasource="#session.DSN#" name="insert">
					insert into EReclamos (
					   Ecodigo, SNcodigo, SNcodigorec, EDRid, CMCid, EDRnumero, EDRfecharec, Usucodigo, fechaalta, ERestado
					   <cfif len(trim(HEDR.EDRobs))>, ERobs</cfif>
					)
					values( 
					    #HEDR.Ecodigo#, #HEDR.SNcodigo#, #HEDR.SNcodigo#, #HEDR.EDRid#, #dataComprador.CMCid#, '#HEDR.EDRnumero#', <cf_dbfunction name="now">, #session.Usucodigo#, <cf_dbfunction name="now">, 0
							<cfif len(trim(HEDR.EDRobs))>, #HEDR.EDRobs#</cfif>)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				
				
				
				<cfquery datasource="#session.DSN#">
					insert into DReclamos(  ERid, 
											Ecodigo, 
											DDRlinea, 
											DRcantorig, 
											DRcantrec, 
											DRpreciooc, 
											DRpreciorec, 
											DRfecharec, 
											DRfechacomp, 
											Usucodigo, 
											fechaalta, 
											DRestado, 
											DDRobsreclamo
											 )
					select 
						c.ERid, 
						a.Ecodigo, 
						a.DDRlinea, 
					case (a.DDRcantorigen-a.DDRcantrec) 
						when 0  then
							case (d.DOpreciou-a.DDRpreciou) 
								when 0  then
									 d.DOcantsurtida 
								else
									a.DDRcantorigen
								end
						else
							a.DDRcantorigen
						end as DDRcantorigen,
					
					case (a.DDRcantorigen-a.DDRcantrec) 
						when 0  then
							case (d.DOpreciou-a.DDRpreciou) 
								when 0 then
									d.DOcantexceso 
								else
									a.DDRcantrec
								end
						else
							a.DDRcantrec
						end as DDRcantrec,
					d.DOpreciou, 
					a.DDRpreciou, 
					<cf_dbfunction name="now">, 
					<cf_dbfunction name="now">, 
					#session.Usucodigo#, 
					<cf_dbfunction name="now">, 
					10, 
					DDRobsreclamo
					from HDDocumentosRecepcion a
					
					inner join HEDocumentosRecepcion b
					on a.EDRid=b.EDRid
					and a.Ecodigo=b.Ecodigo
					
					inner join EReclamos c
					on b.EDRid=c.EDRid
					and a.Ecodigo=b.Ecodigo
					
					inner join DOrdenCM d
					on a.DOlinea=d.DOlinea
					
					inner join DDocumentosRecepcion e
					on a.DDRlinea=e.DDRlinea
					
					where a.Ecodigo=#session.Ecodigo#
					  and e.DDRgenreclamo=1
					  and a.EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
				</cfquery>
				
				
				
				
				<!--- ******************************************************************************************** --->

				<cfset totalReclamo = 0>
				<!--- <cfset totalFactura = 0> --->
				<cfset idPoliza = 0>
				<cfset contador1 = 1>
				
				
				<cfloop query="detallesDDRReclamos">
					<cfif detallesDDRReclamos.DDRgenreclamo eq 1 >
					 <cfset totalReclamo = calcularReclamo(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin,
																				  detallesDDRReclamos.Iporcentaje, detallesDDRReclamos.DOcantsaldo, detallesDDRReclamos.DDRprecioorig,
																				  detallesDDRReclamos.DOporcdesc, detallesDDRReclamos.IporcentajeOC, detallesDDRReclamos.DDRcantrec,
																				  detallesDDRReclamos.Ctolerancia, detallesDDRReclamos.Mcodigo, detallesDDRReclamos.McodigoOC,
																				  detallesDDRReclamos.EDRtc, detallesDDRReclamos.EOtc, detallesDDRReclamos.factorConversionU, 
																				  detallesDDRReclamos.DDRtipoitem, detallesDDRReclamos.ArticuloTieneTolerancia,idPoliza,detallesDDRReclamos.DDRaprobtolerancia)> 
	
						<cfset LvartotalReclamo =  totalReclamo[1]>
						<cfset LvarCantSaldo =  totalReclamo[2]>
						<cfset LvarTolerancia =  totalReclamo[3]>
						<cfset LvarUnidadesReclamo =  totalReclamo[4]>
						<cfset LvarUnidadesNoRecibidas =  totalReclamo[5]>
						<cfset LvarDifPrecioUnitario =  totalReclamo[6]>
						<cfset LvarDiferenciaDescuentoPor =  totalReclamo[7]>
						<cfset LvarMontoUnidadesExceso =  totalReclamo[8]>
						<cfset LvarMontoUnidadesNoRec =  totalReclamo[9]>
						<cfset LvarMontoDifPrecio =  totalReclamo[10]>
						<cfset LvarMontoDescuento =  totalReclamo[11]>
						<cfset LvarDescuentoSobReclamo =  totalReclamo[12]>
						<cfset LvarMontoImptoReclamo =  totalReclamo[13]>

							<cfquery datasource="#session.DSN#">
								update DReclamos set
									MontoReclamo = #LvartotalReclamo#,
									CantSaldo = #LvarCantSaldo#,
									Tolerancia = #LvarTolerancia#,
									UnidadesReclamo = #LvarUnidadesReclamo#,
									UnidadesNoRecibidas = #LvarUnidadesNoRecibidas#,
									DifPrecioUnitario = #LvarOBJ_PrecioU.enCF(LvarDifPrecioUnitario)#,
									DiferenciaDescuentoPor = #LvarDiferenciaDescuentoPor#,
									MontoUnidadesExceso = #LvarMontoUnidadesExceso#,
									MontoUnidadesNoRec = #LvarMontoUnidadesNoRec#,
									MontoDifPrecio = #LvarOBJ_PrecioU.enCF(LvarMontoDifPrecio)#,
									MontoDescuento = #LvarMontoDescuento#,
									DescuentoSobReclamo = #LvarDescuentoSobReclamo#,
									MontoImptoReclamo = #LvarMontoImptoReclamo#
								where Ecodigo = #session.Ecodigo#
								  and ERid = #insert.identity#
								  and DDRlinea = #detallesDDRReclamos.DDRlinea#
							</cfquery>
							<cfquery datasource="#session.DSN#">
								update DDocumentosRecepcion set 
									DDRcantreclamo = #LvarUnidadesNoRecibidas#
								where Ecodigo   = #session.Ecodigo#
								   and DDRlinea = #detallesDDRReclamos.DDRlinea#
							</cfquery>
							
						 <!--- </cfloop>  --->
						<cfset contador1 = contador1 + 1>
						
					</cfif>
	
					<cfset idPoliza = 0>
					
				</cfloop>
				
				
				<!--- ******************************************************************************************** --->
				
				<cfset hayReclamo = true >
		</cfif>
	
		<cfif form.tipo eq 'D'>
			<cfquery datasource="#session.DSN#">
				update DDocumentosRecepcion
				set DDRcantrec = DDRcantrec*-1,
					DDRcantorigen = DDRcantorigen*-1,
					DDRcantordenconv = DDRcantordenconv*-1,
					DDRpreciou = DDRpreciou*-1
				where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>
	
			<cfquery datasource="#session.DSN#">
				update HDDocumentosRecepcion
				set DDRcantrec = DDRcantrec*-1,
					DDRcantorigen = DDRcantorigen*-1,
					DDRpreciou = DDRpreciou*-1
				where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
		
		<!--- CAMBIA ESTADO AL DOCUMENTO--->	
		<cfquery datasource="#session.DSN#">
			update EDocumentosRecepcion
			set EDRestado = 10
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cftransaction>

<cfif NoAprobarTolerancia>
	<!--- INTERFAZ --->
	<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
	<cfset LobjInterfaz.fnProcesoNuevoSoin(iif(form.tipo eq 'R',101,103),"EDRid=#form.EDRid#","R")>
	
<!--- Si el documento excedió la tolerancia, notifica a los compradores y al usuario --->
<cfelse>

	<!--- Obtiene la lista de compradores a los cuales hay que mandar un correo --->
	<cfquery name="rsCompradoresCorreos" datasource="#session.dsn#">
		select distinct dp.Pemail1, dp.Pnombre #_Cat# ' ' #_Cat#  dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Destino,
						cmc.CMCid, usu.Usucodigo, usu.CEcodigo
		from DDocumentosRecepcion ddr
			inner join DOrdenCM docm
				on docm.DOlinea = ddr.DOlinea
				and docm.Ecodigo = ddr.Ecodigo
			inner join EOrdenCM eo
				on eo.EOidorden = docm.EOidorden
				and eo.Ecodigo = docm.Ecodigo
			inner join CMCompradores cmc
				on cmc.CMCid = eo.CMCid
				and cmc.Ecodigo = eo.Ecodigo
			inner join Usuario usu
				on usu.Usucodigo = cmc.Usucodigo
			inner join DatosPersonales dp
				on dp.datos_personales = usu.datos_personales
		where ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
			and ddr.Ecodigo = #session.Ecodigo#
			and ddr.DDRaprobtolerancia = 5
	</cfquery>
	
	<!--- Envía el correo a cada comprador con las líneas de sus OCs que excedieron la tolerancia --->	
	<cfloop query="rsCompradoresCorreos">

		<cfif len(trim(rsCompradoresCorreos.Pemail1)) gt 0>
			<cfset _contenido_correo = contenidoCorreoCompradorRecepcion(form.EDRid, rsCompradoresCorreos.CMCid, rsCompradoresCorreos.Destino, rsCompradoresCorreos.Usucodigo, rsCompradoresCorreos.CEcodigo)>
				
			<cfquery datasource="asp">
				insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCompradoresCorreos.Pemail1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Notificación. Sistema de Compras">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#_contenido_correo#">,
						1)
			</cfquery>
		</cfif>
	</cfloop>
	
	<!--- Obtiene el correo del usuario que registró la recepción para notificarle que el documento debe ser aprobado --->
	<cfquery name="rsCorreoUsuario" datasource="#session.dsn#">
		select distinct dp.Pemail1, dp.Pnombre #_Cat# ' ' #_Cat#  dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Destino,
						usu.Usucodigo, usu.CEcodigo
		from EDocumentosRecepcion edr
			inner join Usuario usu
				on usu.Usucodigo = edr.Usucodigo
				
			inner join DatosPersonales dp
				on dp.datos_personales = usu.datos_personales
				
		where edr.Ecodigo = #session.Ecodigo#
			and edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	</cfquery>
	
	<!--- Envía el correo al usuario con la lista de compradores que deben aprobar el documento --->
	<cfif rsCorreoUsuario.RecordCount gt 0 and len(trim(rsCorreoUsuario.Pemail1)) gt 0>
		<cfset _contenido_correo = contenidoCorreoUsuarioRecepcion(form.EDRid, rsCorreoUsuario.Destino, 1, rsCorreoUsuario.Usucodigo, rsCorreoUsuario.CEcodigo)>
			
		<cfquery datasource="asp">
			insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCorreoUsuario.Pemail1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Notificación. Sistema de Compras">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#_contenido_correo#">,
					1)
		</cfquery>
	</cfif>
</cfif>

<cffunction name="fnComponentes" access="private" output="no">
	
</cffunction>

<cffunction name="fnPreparaAsientoRemision" access = "private" output	= "no">
			<cfargument name="EDRid"      type="numeric" required="true">
			<cfargument name="Ecodigo"    type="numeric" required="true">
			<cfargument name="Conexion"	  type="string"  required="yes">

			<!--- Asiento:
					2. Se hace un asiento de la cuenta pendiente Facturas (Remisión) (Puente) (Crédito) 
					contra la cuenta de Gastos (Resultado) (Débito)
			--->
            
        <cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")> 
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>

		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(session.dsn)> 
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
            
			<cfset CP_calculoLin	= request.CP_calculoLin	>
			<cfset CP_implinea		= request.CP_implinea>
            
            
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'GN'
				  and Pcodigo = 50
			</cfquery>
            <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
                <cfthrow message="No esta definido el período de Auxiliares. Proceso Cancelado!">
            </cfif>
			<cfset LvarAnoAux = rsSQL.Pvalor>
	
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'GN'
				  and Pcodigo = 60
			</cfquery>
            <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
                <cfthrow message="No esta definido el Mes de Auxiliares. Proceso Cancelado!">
            </cfif>
			<cfset LvarMesAux = rsSQL.Pvalor>

			<cfif len(LvarAnoAux) EQ 0 or len(LvarMesAux) EQ 0>
				<cf_errorCode	code = "51154" msg = "No se han definido los períodos de auxiliar en los parámetros del Sistema. Proceso Cancelado!">
			</cfif>
            
            <cfquery name="rsCuentaPuente" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'CP'
				  and Pcodigo = 1710
			</cfquery>
            
            
            
            <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
            <cf_dbfunction name="string_part"  args="'CM: ' #_Cat# c.SNidentificacion #_Cat# c.SNnombre,1,80" returnvariable= "LvarINTDES">

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, INTCAM, INTMON)
				select 
					'CMRM',
					1,
					a.EDreferencia,
					b.CPTtipo #_Cat# ' ' #_Cat# c.SNnumero,
					b.CPTtipo,
					'#LvarINTDES#',
					<cf_dbfunction name="Date_Format" args="a.EDRfechadoc,YYYYMMDD">,
					#LvarAnoAux#,
					#LvarMesAux#,
					a.Ccuenta, <!--- CUENTA PUENTE --->
					a.Mcodigo,
					d.Ocodigo,
					round(sum(ac.DDRpreciou * ac.DDRcantrec, 2) as INTMOE, <!--- suma de los precios unitarios * cantidades --->
					ac.EOtc,
					<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc>round(round(a.EDtotal,2) * ac.EOtc, 2)<cfelse>round(a.EDtotal, 2)</cfif> as INTMON <!--- suma de los precios unitarios * cantidades --->
				from EDocumentosRecepcion a
                	inner join EOrdenCM ab
                    	on ab.EOidorden = a.EOidorden
                    inner join DDocumentosRecepcion ac
                    	on ac.EDRid = a.EDRid
					inner join CPTransacciones b
						on b.Ecodigo = a.Ecodigo
						and b.CPTcodigo = a.CPTcodigo
                    inner join SNegocios c
                    	on c.SNcodigo = a.SNcodigo
                        and c.Ecodigo = a.Ecodigo
                    inner join CFuncional d
                    	on d.CFid = a.CFid
				where a.EDRid = #Arguments.EDRid#
			</cfquery>
		
            
			<!--- 3c  Detalle (Artículos o Transito o Servicios o Activos Fijos ). Se considera el impuesto aplicable al costo (credito fiscal = 0) --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( 
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,  		
					DDcantidad, DOlinea, 		
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid
					)
				select
					'CPFC',			1,			a.EDdocumento,		'#LvarReferencia#', 
					case c.CPTtipo 
						when 'D' then 'C' 
						else 'D' 
					end,
					case
						when b.DDtipo = 'A' then
							'Articulo: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
							                              <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
											             (select min(<cf_dbfunction name="sPart"args="art.Adescripcion;1;70" delimiters=";">) from Articulos art where art.Aid = b.Aid))
						when b.DDtipo = 'T' then
							'Transito: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
														  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
														  (select min(<cf_dbfunction name="sPart"args="art.Adescripcion;1;70"  delimiters=";">) from Articulos art where art.Aid = b.Aid))
						when b.DDtipo = 'S' AND coalesce(rtrim(b.ContractNo),'') <> '' then 
							'OC-D.' #_Cat# rtrim(b.ContractNo) #_Cat# ', Concepto: ' #_Cat# coalesce( 
														<cf_dbfunction name="sPart"args="b.DDdescalterna;1;37"  delimiters=";">, 
														<cf_dbfunction name="sPart"args="b.DDdescripcion;1;37"  delimiters=";">, 
														(select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;37"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						when b.DDtipo = 'S' then
							'Concepto: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
														  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
														  (select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;70"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						when b.DDtipo = 'F' then
							'Activo: ' #_Cat# coalesce(<cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
													   <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">
													   ,' 0' ) 
						else
							coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;80"  delimiters=";">, 
									  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;80"  delimiters=";">)
					end,
					'#LvarHoyYYYYMMDD#',
					#LvarAnoAux#,		#LvarMesAux#,

					<!---Cuenta Contable--->
					case 
						when DDtipo = 'F' and exists(select 1
													 from DOrdenCM do
									 				 where do.DOlinea = b.DOlinea) then
							coalesce(
								(
									select cf.Ccuenta 
							          from DOrdenCM do
										inner join CFinanciera cf
										 on cf.CFcuenta = do.CFcuenta
									 where do.DOlinea = b.DOlinea
									<!---F sin orden de compra: se debería generar la cuenta de inversión --->
								), #LvarCuentaActivos#
							)
						else
							b.Ccuenta
					end ,
					<!---Cuenta Financiera--->
					case
						when DDtipo = 'F' and exists(select 1
													 from DOrdenCM do
									 				 where do.DOlinea = b.DOlinea)then
								(select do.CFcuenta 
							          from DOrdenCM do
									 where do.DOlinea = b.DOlinea
									<!---F sin orden de compra: se debería generar la cuenta de inversión --->
								)
						else
							b.CFcuenta
					end ,
					
					case DDtipo
						when 'A' then
							(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
						when 'T' then
							(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
						when 'S' then
							coalesce((select min(cf.Ocodigo) from CFuncional cf where cf.CFid = b.CFid), #LvarOcodigoDoc#) 
						when 'F' then
							a.Ocodigo
						else
							a.Ocodigo
					end ,
					b.DDcantidad, 
					b.DOlinea,
					case 
						when DDtipo IN ('A','T') 
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case 
						when DDtipo IN ('A','T') 
						then
							round(
                            	co.costoLinea
								<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif> / #LvarTCvaluacion#
							,2)
						else 
							round(
                            	co.costoLinea
                            ,2)
					end as INTMOE,
					case 
						when DDtipo IN ('A','T') 
							then #LvarTCvaluacion#
						when #LvarMcodigoLocal# <> #LvarMcodigoDoc# 
							then a.EDtipocambio
						else 1.00
					end as INTCAM,
                    round(
                        co.costoLinea
						<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
					,2)
					as INTMON,
					b.PCGDid
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and DDtipo <> 'O'
			</cfquery>


			<!--- 4) Invocar el Posteo de Lineas de Inventario --->
			<!--- 	 Excluir con OC con Tipo Requisición --->
			<cfquery datasource="#Arguments.Conexion#" name="rsInventario">
				select b.FPAEid,b.CFComplemento,
					b.Aid, b.Linea, b.Alm_Aid, b.Dcodigo,
					b.DDcantidad, 
                    	co.costoLinea as CostoOri,
                    (
                        co.costoLinea 
                        <cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
					) as CostoLoc
					,(select min(Ocodigo) from Almacen where Aid = b.Alm_Aid) as Ocodigo
				from EDocumentosCxP a
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						left join DOrdenCM oc
							inner join ESolicitudCompraCM sc
							 on sc.ESidsolicitud = oc.ESidsolicitud
						 on oc.DOlinea = b.DOlinea
					on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo = 'A'
				  and NOT (oc.DOlinea is not null AND sc.TRcodigo is not null)
			</cfquery>

			<cfloop query="rsInventario">
			<cfif #rsInventario.FPAEid# neq ''>
				<cfset LvarFPAEid =  #rsInventario.FPAEid#>
			<cfelse>
				<cfset LvarFPAEid =  0>
			</cfif>
				<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="LvarDatosInv">
					<cfinvokeargument name="Aid" 	       		value="#rsInventario.Aid#"/>							
					<cfinvokeargument name="Alm_Aid"       		value="#rsInventario.Alm_Aid#"/>
					<cfinvokeargument name="Dcodigo"       		value="#rsInventario.Dcodigo#"/>
					<cfinvokeargument name="Tipo_Mov"      		value="E"/>
					<cfinvokeargument name="Cantidad"      		value="#rsInventario.DDcantidad#"/>
					<cfinvokeargument name="ObtenerCosto"  		value="false">
					<cfinvokeargument name="McodigoOrigen" 		value="#LvarMcodigoDoc#">
					<cfinvokeargument name="CostoOrigen"   		value="#rsInventario.CostoOri#">
					<cfinvokeargument name="CostoLocal"       	value="#rsInventario.CostoLoc#">
					<cfinvokeargument name="tcValuacion"      	value="#LvarTCvaluacion#">
					<cfinvokeargument name="Tipo_ES"       	  	value="#LvarTipoES#">
					<cfinvokeargument name="Ocodigo" 	      	value="#rsInventario.Ocodigo#"/>							
					<cfinvokeargument name="Documento" 	      	value="#LvarEDdocumento#"/>							
					<cfinvokeargument name="FechaDoc" 	      	value="#LvarEDtipocambioFecha#"/>							
					<cfinvokeargument name="Referencia" 	  		value="CxP"/>							
					<cfinvokeargument name="insertarEnKardex" 	value="#LvarinsKardex#"/>							
					<cfinvokeargument name="Conexion"         	value="#Arguments.Conexion#">
					<cfinvokeargument name="TransaccionActiva"	value="true">
					<cfinvokeargument name="FPAEid"         		value="#LvarFPAEid#">
					<cfinvokeargument name="CFComplemento"			value="#rsInventario.CFComplemento#">					
				</cfinvoke>	
			</cfloop>

			<!--- BALANCEO MONEDA OFICINA.  Verifica que el Asiento esté Balanceado en Moneda Local --->
			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 100
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="La cuenta de Ajuste por Redondeo de Monedas no esta Definida. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# 
					( 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						INTTIP, INTDES, 
						<!---CFcuenta,---> 
						Ccuenta, 
						Mcodigo, INTMOE, INTCAM, INTMON
					)
				select 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						case 
							when INTTIP = 'D' 
								then case when INTMON > INTMON2 then 'C' else 'D' end
								else case when INTMON < INTMON2 then 'C' else 'D' end
						end, 
						'Ajuste Redondeo', 
						<!---null, --->
						#LvarCtaBalanceMoneda#, 
						i.Mcodigo, 0, 0, 
						abs(INTMON - INTMON2)
				  from #INTARC# i
				 where INTMON2 IS NOT NULL
				   and INTMON <> INTMON2
			</cfquery>

			<cfquery name="rsVerifica" datasource="#Arguments.Conexion#">
				select 	
					sum(case when INTTIP = 'D' then INTMON else -INTMON end) as Diferencia, 
					sum(0.05) as Permitido, 
					sum(case when INTTIP = 'D' then INTMON end) as Debitos, 
					sum(case when INTTIP = 'C' then INTMON end) as Creditos,
					count(1) as Cantidad
				  from #INTARC#
			</cfquery>

			<cfif rsVerifica.recordcount EQ 0 or rsVerifica.Cantidad EQ 0 or rsVerifica.Permitido LT 0.05>
				<cf_errorCode	code = "51158" msg = "El Asiento Generado está vacio. Proceso Cancelado">
			</cfif>

			<cfset LvarDiferencia = rsVerifica.Diferencia>
			<cfset LvarPermitido  = rsVerifica.Permitido>
			
			<cfif rsVerifica.Diferencia LT 0>
				<cfset LvarDiferencia = LvarDiferencia * -1.00>
			</cfif>

			<cfif LvarDiferencia GT LvarPermitido>
				<font color="##FF0000" style="font-size:18px">
					<cfoutput>
					El Asiento Generado no está balanceado en Moneda Local. <BR>Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!
					</cfoutput>
					<BR><BR><BR>
				</font>

				<!--- Pinta el Asiento Contable --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="PintaAsiento">
					<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
					<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
					<cfinvokeargument name="Efecha"			value="#LvarFechaDoc#"/>
					<cfinvokeargument name="Oorigen"		value="CPFC"/>
					<cfinvokeargument name="Edocbase"		value="#LvarEDdocumento#"/>
					<cfinvokeargument name="Ereferencia"	value="#LvarCPTcodigo#"/>						
					<cfinvokeargument name="Edescripcion"	value="Documento de CxP: #LvarEDdocumento#"/>
				</cfinvoke>

				<cftransaction action="rollback" />
				<cf_abort errorInterfaz="El Asiento Generado no está balanceado en Moneda Local. Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!">
			</cfif>

			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 200
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="No esta definida la Cuenta Balance Multimoneda. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC#
					( 
						Ocodigo, Mcodigo, INTCAM, 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, 
						INTTIP, INTDES, 
						<!---CFcuenta, --->
						Ccuenta, 
						INTMOE, INTMON
					)
				select 
						Ocodigo, i.Mcodigo, round(INTCAM,10), 
						min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
						min(INTFEC), min(Periodo), min(Mes), 
						'D', 'Balance entre Monedas', 
						<!---null, --->
						#LvarCtaBalanceMoneda#, 
						-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
						-sum(case when INTTIP = 'D' then INTMON else -INTMON end)
				  from #INTARC# i
				 where i.Mcodigo in
					(
						select Mcodigo
						  from #INTARC#
						 group by Mcodigo
						having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
					)
				group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10)
				having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
			</cfquery>
	</cffunction>