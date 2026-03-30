<cfset LvarOBJ_PrecioU 	= createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset LobjINV 			= createObject( "component","sif.Componentes.IN_PosteoLin")> 
<cfset LobjCONTA		= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset IDKARDEX 		= LobjINV.CreaIdKardex(session.dsn)> 
<cfset Tolerancia 		= 0>
<cfset debug 			= false>

<!---►►Variable para el Manejo de la aprobacion de Tolerancia◄◄--->
	<!---TRUE: Indica si se realizan los distintos procesos de aplicación o es necesario que
		  el documento se aprueba la tolerancia.
		  Se establece en false cuando es una recepción sin aplicar que tiene líneas
		  que sobrepasaron la tolerancia y el parámetro de Aprobación de Tolerancia está activado --->
<cfset NoAprobarTolerancia = true>

<!---►►Datos para la obtencion de Reclamos◄◄--->
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
			docm.DOcantidad - docm.DOcantsurtida as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
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
											then ((coalesce(clas.Ctolerancia, 0) / 100) * (docm.DOcantidad - docm.DOcantsurtida))
				else 0
			end Ctolerancia,														<!--- Porcentaje de tolerancia del articulo ((coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad as Ctolerancia,)--->
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
		
		<!--- Para obtener el factor de conversion de factura a orden --->
		left outer join ConversionUnidades cu
			 on cu.Ecodigo    = hddr.Ecodigo
			and cu.Ucodigo    = hddr.Ucodigo
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

<!---►►Se obtienen los Datos del Documento de recepcion◄◄--->
<cfquery datasource="#session.DSN#" name="dataOrden">
	select 	a.DDRlinea, 
			a.DOlinea, 
			a.DDRcantorigen, 
			a.DDRgenreclamo,
			a.DDRcantordenconv,
			a.DDRtipoitem,
			a.Aid,
			b.DOcantidad
	from DDocumentosRecepcion a
		inner join DOrdenCM b
			on a.DOlinea = b.DOlinea
	where a.EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	  and a.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif form.tipo eq 'R'>
	<!---►►Obtiene el valor del parámetro de Aprobación de Excesos de Tolerancia por Compradores◄◄--->
    <cfquery name="rsParametroTolerancia" datasource="#session.dsn#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
          and Pcodigo = 760
    </cfquery>
    <!---►►Obtiene el estado de la recepción (0.No Aplicada, -5.En Aprobación de Tolerancia, 5.Tolerancia Aprobada, 10.Aplicada)◄◄--->
    <cfquery name="rsEstadoDocumento" datasource="#session.dsn#">
        select edr.EDRestado
        from EDocumentosRecepcion edr
        where edr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
            and edr.Ecodigo = #session.Ecodigo#
    </cfquery>
</cfif>

<cfset INTARC = LobjCONTA.CreaIntarc(session.dsn)>

<cftransaction>	
	<!---INICIO DE RECEPCION--->
	<cfif form.tipo eq 'R'>
    
		<!---►►Verificacion de Tolerancia: Si el estado de la recepción es Por Aplicar y parámetro de Aprobación de Excesos de Tolerancia en la Recepción está Activo◄◄--->
		<cfif rsEstadoDocumento.EDRestado eq 0 and rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1>
		
			<cfquery name="rsHayExcesoTolerancia" datasource="#session.dsn#">
				select 1
				from DDocumentosRecepcion ddr
					inner join DOrdenCM docm
						on docm.DOlinea = ddr.DOlinea
						
					inner join Articulos art
						on art.Aid = docm.Aid
						and art.Ecodigo = docm.Ecodigo
						
					inner join Clasificaciones clas
						on clas.Ccodigo = art.Ccodigo
						and clas.Ecodigo = art.Ecodigo
				where ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					and ddr.Ecodigo = #session.Ecodigo#
					and clas.Ctolerancia is not null
					and ddr.DDRcantordenconv > (docm.DOcantidad - docm.DOcantsurtida) + (docm.DOcantidad * clas.Ctolerancia / 100.00)
			</cfquery>
			
			<!---►►Si hay líneas con exceso de tolerancia, no se hace el proceso de recepcion y se cambia el estado a "En Aprobación de Tolerancia" ◄◄--->
			<cfif rsHayExcesoTolerancia.RecordCount gt 0>
			
				<cfset NoAprobarTolerancia = false>
				<cfquery name="rsUpdateEstadoDocumento" datasource="#session.dsn#">
					update EDocumentosRecepcion
					set EDRestado = -5
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and Ecodigo = #session.Ecodigo#
				</cfquery>
				
				<!---►►Actualiza el estado de las líneas que excedieron la tolerancia, a en espera de aprobación(5-Espera de aprobación, 10-Aprobado, 20-rechazado)--->
				<cfquery name="rsUpdateLineasExcesoTolerancia" datasource="#session.dsn#">
					update DDocumentosRecepcion
					set DDRaprobtolerancia = case when (select count(1)
														from DDocumentosRecepcion ddr
															inner join DOrdenCM docm
																on docm.DOlinea = ddr.DOlinea
															inner join Articulos art
																on art.Aid = docm.Aid
																and art.Ecodigo = docm.Ecodigo
															inner join Clasificaciones clas
																on clas.Ccodigo = art.Ccodigo
																and clas.Ecodigo = art.Ecodigo
														where ddr.DDRlinea = DDocumentosRecepcion.DDRlinea
															and clas.Ctolerancia is not null
															and ddr.DDRcantordenconv > (docm.DOcantidad - docm.DOcantsurtida) + (docm.DOcantidad * clas.Ctolerancia / 100.00)
														) > 0 then 5
												  else 0 end
					where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and Ecodigo = #session.Ecodigo#
				</cfquery>
			</cfif>
		</cfif>
	
		<cfloop query="dataOrden">
			<!---►►Valida que no existan lineas del Documento con Cantidad en Cero◄◄--->
			<cfif dataOrden.DDRcantorigen lte 0 >
				<cfset Request.Error.Backs = 1 >
				<cf_errorCode	code = "50283" msg = "Error al aplicar documento de Recepción.<br>Existen líneas del documento con cantidades en cero.">
				<cfabort>
			</cfif>
			
            <!---►►INICIO DE SIN APROBACION DE TOLERANCIA◄◄--->
			<cfif NoAprobarTolerancia>
			
				<!---►►Calculo de la tolerancia para el caso de los artículos((Tolerancia de la Clasificacion * Cantidad de la Orden) / 100)◄◄--->
				<cfif trim(dataOrden.DDRtipoitem) eq 'A' >
					<cfquery name="rsTolerancia" datasource="#session.DSN#">
						select coalesce(Ctolerancia,0) as Ctolerancia
						from Clasificaciones  A 
                        	inner join Articulos B
                            	 on A.Ecodigo = B.Ecodigo
								and A.Ccodigo = B.Ccodigo	
						where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.Aid#">
					</cfquery>	
					<cfset Tolerancia = (rsTolerancia.Ctolerancia * dataOrden.DOCantidad)/100>
				</cfif>
				
				<cfif isdefined('dataOrden.DOlinea') and dataOrden.DOlinea NEQ ''>
					<!---►►Obtienen el Saldo Local (cantidad - Cantidad Surtida + Tolerancia)◄◄--->
                    <cfquery datasource="#session.DSN#" name="rsSaldolinea">
						select coalesce((DOcantidad - DOcantsurtida),DOcantidad) as saldo 
							from DOrdenCM
						where DOlinea = #dataOrden.DOlinea#
					</cfquery>
					<cfset saldoL = rsSaldolinea.saldo + Tolerancia>
					
                    <!---►►Actualiza la cantidad Surtida y el Exceso en el detalle de cada Orden De compra◄◄--->
					<cfquery datasource="#session.DSN#">
						<cfif saldoL gte dataOrden.DDRcantordenconv >
							update DOrdenCM
							set DOcantsurtida = DOcantsurtida + #dataOrden.DDRcantordenconv#,
								DOcantexceso = 0
							where DOlinea = #dataOrden.DOlinea#
						<cfelse>
							update DOrdenCM
							set DOcantsurtida = DOcantidad + #Tolerancia#,
								DOcantexceso = #dataOrden.DDRcantordenconv# - #saldoL#
							where DOlinea = #dataOrden.DOlinea#
						</cfif>
					</cfquery>
				</cfif>
			
			</cfif>
           
		</cfloop>
		
		<cfif NoAprobarTolerancia>
		
			<!----►►Si tienen Poliza de Desalmacenaje, inserta en la tabla CMDetalleTransito◄◄---->
			<cfquery name="rsVerificaPoliza" datasource="#session.DSN#">
				select EPDid 
                	from EDocumentosRecepcion 
				where EDRid   = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = #session.Ecodigo# 
			</cfquery>	
			<cfif rsVerificaPoliza.RecordCount NEQ 0 and len(trim(rsVerificaPoliza.EPDid))>			
				<cfquery name="CuentaActivoTransito" datasource="#session.dsn#">	
                    select Pvalor from Parametros where Pcodigo = 240 and Ecodigo = #session.Ecodigo#
                </cfquery>
                <cfif NOT CuentaActivoTransito.RecordCount>
                    <cfthrow message="La cuenta de activos en transito no esta Configurada">
                </cfif>
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
							<cf_dbfunction name="now">,
							(a.DDRtotallin + coalesce(e.DPDimpuestosrecup,0.00))* -1.00,
							c.Mcodigo,
							c.EDRtc,
							<cf_dbfunction name="to_number" args="d.EPembarque"> as ETidtracking,							
							coalesce(h.IACtransito, #CuentaActivoTransito.Pvalor#),
							#session.Usucodigo#,
							<cf_dbfunction name="now">,
							8, a.EDRid, a.DDRlinea
					from DDocumentosRecepcion a
					
						inner join DOrdenCM b
							on a.DOlinea = b.DOlinea
							
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
					
					where a.EDRid     = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
						and a.Ecodigo = #session.Ecodigo#
				</cfquery>
			</cfif>
		</cfif> 
	<!---►►FIN DE SIN APROBACION DE TOLERANCIA◄◄--->
    <!---►►INICIO APROBACION DE TOLERANCIA◄◄--->
	<cfelse>
		<cfloop query="dataOrden">
			<!---►►Calculo de la tolerancia para el caso de los artículos((Tolerancia de la Clasificacion * Cantidad de la Orden) / 100)◄◄--->
			<cfif trim(dataOrden.DDRtipoitem) eq 'A' >
				<cfquery name="rsTolerancia" datasource="#session.DSN#">
					select coalesce(Ctolerancia,0) as Ctolerancia
					from  Clasificaciones  A 
                    	inner join Articulos B
                        	 on A.Ecodigo = B.Ecodigo
							and A.Ccodigo = B.Ccodigo
					where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.Aid#">
				</cfquery>	
				<cfset Tolerancia = (rsTolerancia.Ctolerancia * dataOrden.DOCantidad)/100>
			</cfif>
           
			<cfif dataOrden.DDRgenreclamo eq 0 >
            
             	<!---►►Si no genera Reclamo, Obtienen el Saldo Local (cantidad - Cantidad Surtida + Tolerancia)◄◄--->
				<cfquery datasource="#session.DSN#" name="rsSaldolinea">
					select coalesce((DOcantidad - DOcantsurtida),DOcantidad) as saldo 
						from DOrdenCM
					where DOlinea = <cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset saldoL = rsSaldolinea.saldo + Tolerancia>
                
                 <!---►►Si no genera Reclamo, Actualiza la cantidad Surtida y el Exceso en el detalle de cada Orden De compra◄◄--->
				<cfquery datasource="#session.DSN#">
					<cfif saldoL gte dataOrden.DDRcantordenconv >
						update DOrdenCM
						set DOcantsurtida = DOcantsurtida + <cfqueryparam cfsqltype="cf_sql_float" value="#dataOrden.DDRcantordenconv#">,
							DOcantexceso = 0
						where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.DOlinea#">
					<cfelse>
						update DOrdenCM
						set DOcantsurtida = DOcantidad + <cfqueryparam cfsqltype="cf_sql_float"value="#Tolerancia#">,
							DOcantexceso  = <cfqueryparam cfsqltype="cf_sql_float"value="#dataOrden.DDRcantordenconv#"> - (DOcantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#Tolerancia#">) 
						where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.DOlinea#">
					</cfif>				 
				</cfquery>
			</cfif>
            
			<!---►►Guarda la cantidad convertida, en el documento de recepcion◄◄--->
			<cfquery datasource="#session.DSN#">
				update DDocumentosRecepcion
				set DDRcantordenconv = #dataOrden.DDRcantorigen#
				,DOcantexceso = <cfqueryparam value="#Tolerancia#" cfsqltype="cf_sql_float"> 
				where DDRlinea = <cfqueryparam value="#dataOrden.DDRlinea#" cfsqltype="cf_sql_numeric">
				and Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfloop>
	</cfif>
	<!---►►FIN APROBACION DE TOLERANCIA◄◄--->
    <!---►►INICIO SIN APROBACION DE TOLERANCIA◄◄--->
	<cfif NoAprobarTolerancia>
    
		<!---►►Inserta El Encabezado del Historico(HEDocumentosRecepcion)◄◄--->
		<cfquery datasource="#session.DSN#">
			insert into HEDocumentosRecepcion( EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, HEDRestadoreclamo, idBL, Usucodigo, fechaalta )
			select EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, 0, idBL, Usucodigo, fechaalta 
			from EDocumentosRecepcion
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
		<!---►►Inserta los Detalles de los Historico (HDDocumentosRecepcion)◄◄--->
		<cfquery datasource="#session.DSN#">
			insert into HDDocumentosRecepcion (DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal)
			select DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal
			from DDocumentosRecepcion
			where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<!---►►Recupera el comprador registrados en la Primera Orden De compra, para el envio de Correo◄◄--->
		<cfquery name="dataComprador" datasource="#session.DSN#">
			select c.CMCid
			from DDocumentosRecepcion a
				inner join DOrdenCM b
			 		on a.DOlinea = b.DOlinea
                   
				inner join EOrdenCM c
			 		on b.EOidorden = c.EOidorden
	
			where a.Ecodigo = #session.Ecodigo#
			  and a.EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		</cfquery>
	
    	<!---►►Verifica si hay lineas del Documento de Recepcion que tienen Reclamos◄◄--->
		<cfquery name="rsGeneraReclamo" datasource="#session.DSN#">
			select *
			from DDocumentosRecepcion
			where Ecodigo 		= #session.Ecodigo#
			  and DDRgenreclamo	= 1
			  and EDRid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		</cfquery>	  
	
		<cfset hayReclamo = false >
        <!---►►INICION DE GENERACION DE RECLAMOS◄◄--->
		<cfif rsGeneraReclamo.RecordCount gt 0>

			<cfquery datasource="#session.DSN#" name="HEDR">
				select Ecodigo, SNcodigo, SNcodigo, EDRid, EDRnumero, EDRobs
					from HEDocumentosRecepcion
					where Ecodigo = #session.Ecodigo#
					  and EDRid   = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>
            
            <!---►►Agrega el Encabezado del Reclamo (EReclamos)◄◄--->	
            <cfquery datasource="#session.DSN#" name="insert">
                insert into EReclamos (
                   Ecodigo, SNcodigo, SNcodigorec, EDRid, CMCid, EDRnumero, EDRfecharec, Usucodigo, fechaalta, ERestado
                   <cfif len(trim(HEDR.EDRobs))>, ERobs</cfif>
                )
                values( 
                    #HEDR.Ecodigo#, #HEDR.SNcodigo#, #HEDR.SNcodigo#, #HEDR.EDRid#, #dataComprador.CMCid#, '#HEDR.EDRnumero#', <cf_dbfunction name="now">, #session.Usucodigo#, <cf_dbfunction name="now">, 0
                        <cfif len(trim(HEDR.EDRobs))>, <cf_jdbcQuery_param cfsqltype="cf_sql_clob"  value="#HEDR.EDRobs#" voidNull></cfif>)
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>	
            	<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				
			<!---►►Agrega el Detalle del Reclamo (DReclamos)◄◄--->		
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
            
            <!---►►debug, Para encenderlo cambiar la variable al Inicio del Fuente◄◄--->	
			<cfif debug>
				<cfquery name="debug1" datasource="#session.DSN#">
				  select 
						c.ERid, 
						a.Ecodigo, 
						a.DDRlinea, 
					case (a.DDRcantorigen-a.DDRcantrec) 
						when 0  then
							case (#LvarOBJ_PrecioU.enSQL("d.DOpreciou")#-#LvarOBJ_PrecioU.enSQL("a.DDRpreciou")#) 
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
					#LvarOBJ_PrecioU.enSQL_AS("d.DOpreciou")#, 
					#LvarOBJ_PrecioU.enSQL_AS("a.DDRpreciou")#, 
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
				<cfdump var="#debug1#" label="debug1">  
				
				<cfquery name="rsRegistra" datasource="#session.dsn#">
					select 
						ERid, 
						Ecodigo, 
						DDRlinea, 
						DRcantorig, 
						DRcantrec, 
						#LvarOBJ_PrecioU.enSQL_AS("DRpreciooc")#, 
						#LvarOBJ_PrecioU.enSQL_AS("DRpreciorec")#, 
						DRfecharec, 
						DRfechacomp, 
						Usucodigo, 
						fechaalta, 
						DRestado, 
						DDRobsreclamo,
						
						MontoReclamo, 
						CantSaldo,
						Tolerancia,
						UnidadesReclamo,
						UnidadesNoRecibidas,
						#LvarOBJ_PrecioU.enSQL_AS("DifPrecioUnitario")#,
						DiferenciaDescuentoPor,
						MontoUnidadesExceso,
						MontoUnidadesNoRec,
						#LvarOBJ_PrecioU.enSQL_AS("MontoDifPrecio")#,
						MontoDescuento,
						DescuentoSobReclamo,
						MontoImptoReclamo
					from DReclamos
					where Ecodigo = #session.Ecodigo#
					  and ERid = #insert.identity#
				</cfquery>
				 <cfdump var="#insert.identity#">
				 <cfdump var="#rsRegistra#"> 
			</cfif>
            
				<cfset totalReclamo = 0>
				<cfset idPoliza     = 0>
				<cfset contador1    = 1>
				
				<cfloop query="detallesDDRReclamos">
					<cfif detallesDDRReclamos.DDRgenreclamo eq 1 >
                    	<!---►►Calcula los Montos, precios, Unidad de Reclamos, etc, para cada una de las lineas que lo Ameriten◄◄--->
						<cfset totalReclamo = calcularReclamo(detallesDDRReclamos.DDRcantorigen, detallesDDRReclamos.DDRpreciou, detallesDDRReclamos.DDRdescporclin,
																				  detallesDDRReclamos.Iporcentaje, detallesDDRReclamos.DOcantsaldo, detallesDDRReclamos.DDRprecioorig,
																				  detallesDDRReclamos.DOporcdesc, detallesDDRReclamos.IporcentajeOC, detallesDDRReclamos.DDRcantrec,
																				  detallesDDRReclamos.Ctolerancia, detallesDDRReclamos.Mcodigo, detallesDDRReclamos.McodigoOC,
																				  detallesDDRReclamos.EDRtc, detallesDDRReclamos.EOtc, detallesDDRReclamos.factorConversionU, 
																				  detallesDDRReclamos.DDRtipoitem, detallesDDRReclamos.ArticuloTieneTolerancia,idPoliza,detallesDDRReclamos.DDRaprobtolerancia)> 
	
						<cfset LvartotalReclamo 			=  totalReclamo[1]>
						<cfset LvarCantSaldo 				=  totalReclamo[2]>
						<cfset LvarTolerancia 				=  totalReclamo[3]>
						<cfset LvarUnidadesReclamo 			=  totalReclamo[4]>
						<cfset LvarUnidadesNoRecibidas 		=  totalReclamo[5]>
						<cfset LvarDifPrecioUnitario 		=  totalReclamo[6]>
						<cfset LvarDiferenciaDescuentoPor 	=  totalReclamo[7]>
						<cfset LvarMontoUnidadesExceso 		=  totalReclamo[8]>
						<cfset LvarMontoUnidadesNoRec 		=  totalReclamo[9]>
						<cfset LvarMontoDifPrecio 			=  totalReclamo[10]>
						<cfset LvarMontoDescuento			=  totalReclamo[11]>
						<cfset LvarDescuentoSobReclamo 		=  totalReclamo[12]>
						<cfset LvarMontoImptoReclamo 		=  totalReclamo[13]>
						
                         <!---►►debug, Para encenderlo cambiar la variable al Inicio del Fuente◄◄--->
                         <cfif 	debug>
                         	<cfdump var="#totalReclamo#"><br />
							<cfdump var="#detallesDDRReclamos.DDRlinea#"><br />
                         </cfif>
                      
                      	 <!---►►Actualiza los Montos, precios, Unidad de Reclamos, etc Calculados en la lineas del Detalle del Reclamo◄◄--->
                         <cfquery datasource="#session.DSN#">
                            update DReclamos set
                                MontoReclamo 			= #LvartotalReclamo#,
                                CantSaldo 				= #LvarCantSaldo#,
                                Tolerancia 				= #LvarTolerancia#,
                                UnidadesReclamo 		= #LvarUnidadesReclamo#,
                                UnidadesNoRecibidas 	= #LvarUnidadesNoRecibidas#,
                                DifPrecioUnitario 	    = #LvarOBJ_PrecioU.enCF(LvarDifPrecioUnitario)#,
                                DiferenciaDescuentoPor  = #LvarDiferenciaDescuentoPor#,
                                MontoUnidadesExceso 	= #LvarMontoUnidadesExceso#,
                                MontoUnidadesNoRec 		= #LvarMontoUnidadesNoRec#,
                                MontoDifPrecio 			= #LvarOBJ_PrecioU.enCF(LvarMontoDifPrecio)#,
                                MontoDescuento 			= #LvarMontoDescuento#,
                                DescuentoSobReclamo 	= #LvarDescuentoSobReclamo#,
                                MontoImptoReclamo 		= #LvarMontoImptoReclamo#
                            where Ecodigo 	= #session.Ecodigo#
                              and ERid 		= #insert.identity#
                              and DDRlinea 	= #detallesDDRReclamos.DDRlinea#
                         </cfquery>
                        
                        <!---►►Actualiza la cantidad reclamada en el Detalle del Documento de Recepcion (DDocumentosRecepcion), con las cantidad no Recibidas◄◄--->
                         <cfquery datasource="#session.DSN#">
                            update DDocumentosRecepcion set 
                                DDRcantreclamo = #LvarUnidadesNoRecibidas#
                            where Ecodigo   = #session.Ecodigo#
                               and DDRlinea = #detallesDDRReclamos.DDRlinea#
                         </cfquery>
						<cfset contador1 = contador1 + 1>
					</cfif>
					<cfset idPoliza = 0>
				</cfloop>
				<cfset hayReclamo = true >
                
                <!---►►debug, Para encenderlo cambiar la variable al Inicio del Fuente◄◄--->
                <cfif debug>
				 	<cftransaction action="rollback">
					<cf_dump var="#form#"> 
                </cfif>
		</cfif>
        <!---►►FIN DE GENERACION DE RECLAMOS◄◄--->
		<!---►►FIN DE RECEPCION◄◄--->
        
		<cfif form.tipo eq 'D'>
			<cfquery datasource="#session.DSN#">
				update DDocumentosRecepcion
				set DDRcantrec 		 = DDRcantrec*-1,
					DDRcantorigen 	 = DDRcantorigen*-1,
					DDRcantordenconv = DDRcantordenconv*-1,
					DDRpreciou 		 = DDRpreciou*-1
				where EDRid=<cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>
	
			<cfquery datasource="#session.DSN#">
				update HDDocumentosRecepcion
				set DDRcantrec    = DDRcantrec*-1,
					DDRcantorigen = DDRcantorigen*-1,
					DDRpreciou    = DDRpreciou*-1
				where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
		<!---►►Genera Entrada al Inventario y Adquisicion de Activos Fijos◄◄--->
        <cfinvoke component="sif.Componentes.CM_DocumentosRecepcion" method="ProcesarDocumento">
        	<cfinvokeargument name="EDRid"  value="#form.EDRid#">
            <cfinvokeargument name="INTARC" value="#INTARC#">
        </cfinvoke>
        
		<!---►►Cambia el estado del Documento a Aplicado◄◄--->	
		<cfquery datasource="#session.DSN#">
			update EDocumentosRecepcion
			  set EDRestado = 10
			where EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
	</cfif>
    <!---►►FIN PROCESO SIN APROBACION DE TOLERANCIA◄◄--->
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
                		
			inner join EOrdenCM eo
				on eo.EOidorden = docm.EOidorden
                
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