<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(false)>
<title>				insert into OD101 </title>
<!--- 
	Interfaces desde SOIN hacia Dos Pinos.
	Interfaz 101 : "Registro de Recepciones de Compra"
	Entradas :
		ID : ID del Proceso a crear.
		EDRid : PK de EDocumentosRecepcion.
		MODO : Accin a realizar.
	Salidas :
		1 Registro en la Tabla OE101 : Datos del Encabezado de la Recepcin (EDRid).
		N Registros en la Tabla OD101 : Datos de las lneas de detalle de la Recepcin (EDRid).
	Creada : 01 de Noviembre del 2004
--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">

<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>

<!--- Parmetros Requeridos --->
<cfparam name="url.ID"    type="numeric">
<cfparam name="url.EDRid" type="numeric">
<cfparam name="url.MODO"  type="string">

<!--- Valida Parmetros de entrada --->
<cfquery name="rsid_vexists" datasource="sifinterfaces">
	select 1 
	  from OE101 
	where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
</cfquery>

<cfif rsid_vexists.Recordcount GT 0>
	<!--- (Intento de Reprocesar) --->
	<cfthrow message="Error en interfaz Dos Pinos 101, Registro de Recepciones de Mercadera, EL proceso ya fu ejecutado anteriormente, Proceso Cancelado!">
</cfif>

<cfquery name="rsedr_vexists" datasource="#Session.Dsn#">
	select 1 from EDocumentosRecepcion
	where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  and Ecodigo = #Session.Ecodigo#
	  and EDRestado = 10 <!--- Solo si ya fue aplicada --->
</cfquery>

<cfif rsedr_vexists.Recordcount EQ 0>
	<!--- (Error de datos en la Cola) --->
	<cfthrow message="Error en interfaz Dos Pinos 101, Registro de Recepciones de Mercadera, Cdigo de Recepcin no est definido, Proceso Cancelado!">
</cfif>

<cfif not url.MODO EQ 'R'>
	<cfthrow message="Error en interfaz Dos Pinos 101, Registro de Recepciones de Mercadera, Modo invlido, Proceso Cancelado!">
</cfif>

<cfquery name="rs" datasource="#Session.Dsn#">
	SELECT 	a.EDRid, 			a.Ecodigo, 			a.TDRcodigo, 
			a.Mcodigo, 			a.EDRtc, 			a.Aid as Alm_Aid, 
			a.CFid, 			a.CPTcodigo, 		a.EPDid, 
			a.EDRnumero,		a.EDRfechadoc, 		a.EDRfecharec, 
			a.EOidorden, 		a.SNcodigo, 		a.EDRreferencia, 
			a.EDRdescpro, 		a.EDRimppro, 		a.EDRobs, 
			b.DDRlinea, 		b.Ucodigo, 			b.DOlinea, 
			b.Aid, 				b.Cid, 				b.DDRtipoitem, 
			b.DDRcantrec, 		b.DDRcantordenconv, b.DDRcantorigen, 
			coalesce((select min(rec.UnidadesNoRecibidas)
				from DReclamos rec
					where rec.DDRlinea = b.DDRlinea
				
			),0) as DDRcantreclamo,
			#LvarOBJ_PrecioU.enSQL_AS("coalesce(b.DDRpreciou,0)","DDRpreciou")#, 
			#LvarOBJ_PrecioU.enSQL_AS("b.DDRprecioorig")#, 
			coalesce(b.DDRdesclinea,0) as DDRdesclinea,
			coalesce(b.DDRtotallin,0) as DDRtotallin, 		b.DDRcostopro, 		b.DDRcostototal, 
			b.DDRobsreclamo, 	b.DDRgenreclamo,	
			((select min(c.SNnumero) from SNegocios c where c.SNcodigo = a.SNcodigo and c.Ecodigo = a.Ecodigo)) as SNnumero, 
			((select min(d.Miso4217) from Monedas d where d.Mcodigo = a.Mcodigo and d.Ecodigo = a.Ecodigo)) as Miso4217, 		
			((
				select min(e.EOplazo)
				from EOrdenCM e 
			 	where e.EOidorden = a.EOidorden 
				  and e.Ecodigo   = a.Ecodigo
			)) as EOplazo, 			
			b.Icodigo, 
			f.DOconsecutivo as DOconsecutivo_OC, 
			h.EPembarque as ETidtracking,
			coalesce(f.DOcantidad,0.00) as DOcantidad_OC, 
			f.Ucodigo as Ucodigo_OC, 
			null as ETnumtracking_OC, 
			g.EOnumero, 		g.EOplazo as EOplazo_det, 
			g.NAP, 				
			h.EPDnumero, 
			((
				select min(i.Almcodigo)
				from Almacen i 
			 	where i.Aid = f.Alm_Aid 
				  and i.Ecodigo = f.Ecodigo 
			)) as Almcodigo, 		
			j.Acodigo, 			
			((
				select min(k.Ccodigo)
				from Conceptos k 
				where k.Cid     = b.Cid 
				 and  k.Ecodigo = b.Ecodigo
			)) as Ccodigo, 
			((
				select min(l.ESnumero)
				from ESolicitudCompraCM l 
				where l.ESidsolicitud = f.ESidsolicitud 
				  and l.Ecodigo       = f.Ecodigo
			)) as ESnumero, 		
			((
				select min(m.DSconsecutivo)
				from DSolicitudCompraCM m 
				where m.DSlinea = f.DSlinea 
				  and m.Ecodigo = f.Ecodigo
			)) as DSconsecutivo, 	
			((
				select min(n.CFformato)
				from CFinanciera n 
				where n.CFcuenta = f.CFcuenta 
				  and n.Ecodigo = f.Ecodigo
			)) as CFformato, 
			coalesce((
				select sum(o.CPNAPDmonto)
				from CPNAPdetalle o 
				where o.CPNAPnum    = g.NAP 
				  and o.CPNAPDlinea = f.DOconsecutivo 
				  and o.Ecodigo     = f.Ecodigo
			),0.00) as CPNAPDmonto, 
			coalesce((
						select min(imp.Iporcentaje)
						from Impuestos imp 
						where imp.Icodigo = b.Icodigo and imp.Ecodigo = b.Ecodigo
					),0.00) as Iporcentaje, 
			coalesce((
						select min(imp.Iporcentaje)
						from Impuestos imp 
						where imp.Icodigo = b.Icodigo and imp.Ecodigo = b.Ecodigo
					),0.00) as IporcentajeRecuperable, 
			((
						select imp.Icompuesto
						from Impuestos imp 
						where imp.Icodigo = b.Icodigo and imp.Ecodigo = b.Ecodigo
			)) as IcompuestoRecuperable,
			f.Icodigo as Icodigo_orden,
			coalesce((
				select min(imp.Iporcentaje)
				from Impuestos imp 
				where imp.Icodigo = f.Icodigo and imp.Ecodigo = f.Ecodigo
				),0.00) as IporcentajeOC, 
			coalesce((
				select min(imp.Iporcentaje)
				from Impuestos imp 
				where imp.Icodigo = f.Icodigo and imp.Ecodigo = f.Ecodigo
				),0.00) as IporcentajeRecuperableOC, 
			((
				select imp.Icompuesto
				from Impuestos imp 
				where imp.Icodigo = f.Icodigo and imp.Ecodigo = f.Ecodigo
				)) as IcompuestoRecuperableOC, 
			#LvarOBJ_PrecioU.enSQL_AS("f.DOpreciou", "precioParaReclamo")#,
			coalesce(
					(
						select min(ccart.Cformato)
						from  Existencias exis
								inner join IAContables iac
										inner join CContables ccart
											 on iac.IACtransito = ccart.Ccuenta
									 on iac.IACcodigo = exis.IACcodigo
									and iac.Ecodigo   = exis.Ecodigo
						 where exis.Aid     = f.Aid
						   and exis.Alm_Aid = f.Alm_Aid
					), (
						select min(ccact.Cformato)
						from AClasificacion ac
							inner join CContables ccact
								 on ccact.Ccuenta   = ac.ACcadq
								and ccact.Ecodigo   = ac.Ecodigo
						where ac.Ecodigo   = f.Ecodigo
						  and ac.ACid      = f.ACid
						  and ac.ACcodigo  = f.ACcodigo
						)
					) as formato,
			coalesce(f.DOporcdesc,0) as DOporcdesc,
			coalesce(dp.DPseguropropio,0) as DPseguropropio,
			coalesce(dp.DPDimpuestosreal,0) as DPDimpuestosreal,
			coalesce(dp.DPDimpuestosrecup,0) as DPDimpuestosrecup,
			(
					coalesce(dp.DPDimpuestosreal,0) 
				+ 	coalesce(dp.DPDimpuestosrecup, 0)
				-	coalesce((
						select sum(CMImontoteorico)
					    from CMImpuestosItem cmii
						where cmii.Ecodigo  = h.Ecodigo
						  and cmii.EPDid    = h.EPDid
						  and cmii.DPDlinea = dp.DPDlinea
					), 0.00)
		    ) as MontoDiferenciaImpuestos,
			dp.CMSid,
			 (coalesce(clas.Ctolerancia, 0) / 100) * coalesce(f.DOcantidad,0) as Ctolerancia,
			case 
				when b.DDRaprobtolerancia = 20 
					then coalesce((	select min(UnidadesReclamo)
									from DReclamos rec
									where rec.DDRlinea = b.DDRlinea),0)
				else 0
			end as CantidadExcedida,
			(coalesce(dp.DPDporcimpCApoliza,0) - coalesce(dp.DPDporcimpCAarticulo,0)) as PorcentajeDiferenciaImpuestos
			, usu.Usucodigo, usu.Usulogin
	FROM EDocumentosRecepcion a 
		inner join DDocumentosRecepcion b 
					inner join DOrdenCM f 
								inner join EOrdenCM g 
					 			  on g.EOidorden = f.EOidorden 
								 and g.Ecodigo  = f.Ecodigo 
						 on f.DOlinea = b.DOlinea 
						and f.Ecodigo = b.Ecodigo  
			 on b.EDRid   = a.EDRid 
			and b.Ecodigo = a.Ecodigo
			
		inner join Usuario usu
			on usu.Usucodigo = a.Usucodigo

		left outer join Articulos j 
				left outer join Clasificaciones clas
					 on clas.Ccodigo = j.Ccodigo
					and clas.Ecodigo = j.Ecodigo
			 on j.Aid     = b.Aid 

		left outer join DPolizaDesalmacenaje dp
				left outer join EPolizaDesalmacenaje h 
						 on h.EPDid   = dp.EPDid
			 on dp.EPDid   = a.EPDid 
			and dp.DOlinea = b.DOlinea
			and dp.Ecodigo = a.Ecodigo
      WHERE a.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  	and a.Ecodigo = #Session.Ecodigo#
	  	and a.EDRestado = 10 
</cfquery>

<cfoutput query="rs">
	<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>
	<cfif len(trim(rs.ETidtracking)) GT 0>
		<cfquery name="rsTracking" datasource="sifpublica">
			select ETconsecutivo
			from ETracking where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.ETidtracking#">
		</cfquery>
		
		<cfif rsTracking.recordcount GT 0>
			<cfset QuerySetCell(rs, "ETnumtracking_OC", rsTracking.ETconsecutivo, rs.CurrentRow)>
		</cfif>
	</cfif>

	<!--- Impuesto recuperable del documento --->
	<cfif rs.Icodigo NEQ '' and rs.IcompuestoRecuperable EQ 0>
		<cfquery name="rsImpuesto" datasource="#Session.Dsn#">
			select coalesce(sum(Iporcentaje),0.00) as Iporcentaje
			from Impuestos
			where Icreditofiscal = 1
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rs.Icodigo)#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>

	<cfelseif rs.IcompuestoRecuperable GT 0>
		<cfquery name="rsImpuesto" datasource="#Session.Dsn#">
			select coalesce(sum(DIporcentaje),0.00) as Iporcentaje
			from DImpuestos
			where DIcreditofiscal = 1
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rs.Icodigo)#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
	</cfif>

	<cfif isdefined('rsImpuesto') and rsImpuesto.recordcount GT 0>
		<cfset QuerySetCell(rs, "IporcentajeRecuperable", rsImpuesto.Iporcentaje, rs.CurrentRow)>
	</cfif>

	<!---- Impuesto en la OC e impuesto recuperable de la OC------>
	<cfif rs.Icodigo_orden NEQ '' and rs.IcompuestoRecuperableOC EQ 0>
		<cfquery name="rsImpuestoOC" datasource="#Session.Dsn#">
			select coalesce(sum(Iporcentaje),0.00) as Iporcentaje
			from Impuestos
			where Icreditofiscal = 1
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rs.Icodigo_orden)#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
	<cfelseif rs.IcompuestoRecuperableOC GT 0>
		<cfquery name="rsImpuestoOC" datasource="#Session.Dsn#">
			select coalesce(sum(DIporcentaje),0.00) as Iporcentaje
			from DImpuestos
			where DIcreditofiscal = 1
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rs.Icodigo_orden)#">
			  and Ecodigo = #Session.Ecodigo#

		</cfquery>		
	</cfif>	

	<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordcount GT 0>
		<cfset QuerySetCell(rs, "IporcentajeRecuperableOC", rsImpuestoOC.Iporcentaje, rs.CurrentRow)>
	</cfif>
</cfoutput>

<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>

<!--- Valida el Query --->

<cfquery name="rsVCount" datasource="#Session.Dsn#">
	select count(1) as cont from DDocumentosRecepcion
	WHERE EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif rsVCount.Cont NEQ rs.RecordCount>
	<cfthrow message="Error en interfaz Dos Pinos 101, Registro de Recepciones de Mercadera, Datos de Entrada Invlidos, Proceso Cancelado! -- EDRid: #url.EDRid# -- Ecodigo: #session.Ecodigo#">
</cfif>

<!--- Convertir unidades si cambiaron, deben quedar en la unidad de medida de la OC --->

<!--- Salida --->

<cftransaction>

	<cfoutput query="rs" group="EDRid"><!--- Para el EDRid --->
		<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>
		<cfquery datasource="sifinterfaces">
			insert into OE101 
				(ID, NumeroDocRecepcion, FechaRecepcion, 
				FechaDocumento, CodigoProveedor, TipoDocumentoCXP, 
				CodigoMoneda, TipoCambio, DescuentoDoc, 
				ImpuestoDoc, Observaciones, PlazoOC, 
				NumeroEmbarque, NumeroPolizaDes, Modo,
				LoginUsuario, 
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EDRnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rs.EDRfecharec#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rs.EDRfechadoc#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.SNnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CPTcodigo#" null="#len(trim(rs.CPTcodigo)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Miso4217#">,  
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRtc#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRdescpro#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRimppro#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EDRobs#" null="#len(trim(rs.EDRobs)) EQ 0#">,  
				<cfif len(trim(rs.EOplazo)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.EOplazo#">,  <!--- Debe validarse que todas las lneas de detalle tengan la misma Orden de Compra , sino debe actualizarse en nulo --->
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.ETnumtracking_OC#" null="#len(trim(rs.ETnumtracking_OC)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EPDnumero#" null="#len(trim(rs.EPDnumero)) EQ 0#">,  				
				<cfqueryparam cfsqltype="cf_sql_char" value="#url.MODO#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.Usulogin#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Usucodigo#">
			)
		</cfquery>

		<cfoutput><!--- Para cada una de las DDRlinea --->

			<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>

			<cfquery datasource="sifinterfaces">
				insert into OD101 (	ID, LineaDocRecepcion, TipoItem, 
									CodigoAlmacen, CodigoItem, CantidadRecibida, 
									CodigoUnidadMedida, PrecioUnitario, CodigoImpuesto, 
									NumeroSolicitudCompra, LineaSolcitudCompra, NumeroOrdenCompra, 
									LineaOrdenCompra, NAP_OC, MontoLineaNAP_OC, 
									Plazo_OC, Cantidad_OC, CodigoUnidadMedida_OC, 
									CuentaFinanciera_OC, PorcentajeImpuesto, PorcentajeImpuestoRecuperable, 
									BMUsucodigo,CantidadReclamada,PorcentajeImpuesto_OC, 
									PorcentajeImpuestoRec_OC,Precio_reclamo
									,CuentaFinanciera_Transito, 
									PorcentajeDescuento_OC, PorcentajeDescuento_Doc, CantidadExcedida, 
									MontoSeguros, MontoImpuestos, MontoDiferenciaImpuestos, 
									CMSid, 
									PorcentajeDiferenciaImpuestos,
									totallinea
									)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.currentrow#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.DDRtipoitem#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Almcodigo#" null="#len(trim(rs.Almcodigo)) EQ 0#">,
						
						<cfif rs.DDRtipoitem EQ 'A'>
							<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Acodigo#">,
						<cfelseif rs.DDRtipoitem EQ 'S'>
							<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ccodigo#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_char" value="Activo">,
						</cfif>
						
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DDRcantrec#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ucodigo#">, 
						#LvarOBJ_PrecioU.enCF(rs.DDRpreciou)#, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Icodigo#">, 																								
						
						<cfif len(trim(rs.ESnumero)) NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.ESnumero#">, 
						<cfelse>
							null,
						</cfif>

						<cfif len(trim(rs.DSconsecutivo)) NEQ 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DSconsecutivo#">, 
						<cfelse>
							null,
						</cfif>

						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.EOnumero#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.DOconsecutivo_OC#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.NAP#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.CPNAPDmonto#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.EOplazo_det#">,  
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DOcantidad_OC#">, <!--- Obtener el convertido a la OC --->
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ucodigo_OC#">,  <!--- Obtener el convertido a la OC --->
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CFformato#" null="#len(trim(rs.CFformato)) EQ 0#">, 

						<cfif len(trim(rs.EPDnumero)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_float" value="#rs.DPDimpuestosreal + rs.DPDimpuestosrecup#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#rs.DPDimpuestosrecup#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_float" value="#rs.Iporcentaje#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#rs.IporcentajeRecuperable#">,
						</cfif>
						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs.DDRcantreclamo#">,
						<cfif isdefined("rs.IporcentajeOC")><cfqueryparam cfsqltype="cf_sql_float" value="#rs.IporcentajeOC#"><cfelse>null</cfif>,
						<cfif isdefined("rs.IporcentajeRecuperableOC")><cfqueryparam cfsqltype="cf_sql_float" value="#rs.IporcentajeRecuperableOC#"><cfelse>null</cfif>,
						#LvarOBJ_PrecioU.enCF(rs.precioParaReclamo)#,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rs.formato#" null="#len(trim(rs.formato)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs.DOporcdesc#" null="#len(trim(rs.DOporcdesc)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs.DDRdesclinea#" null="#len(trim(rs.DDRdesclinea)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs.CantidadExcedida#" null="#len(trim(rs.CantidadExcedida)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DPseguropropio#" null="#len(trim(rs.DPseguropropio)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DPDimpuestosreal#" null="#len(trim(rs.DPDimpuestosreal)) EQ 0#">,				
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.MontoDiferenciaImpuestos#" null="#len(trim(rs.MontoDiferenciaImpuestos)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CMSid#" null="#len(trim(rs.CMSid)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rs.PorcentajeDiferenciaImpuestos#" null="#len(trim(rs.PorcentajeDiferenciaImpuestos)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DDRtotallin#">						
					)
			</cfquery>
		</cfoutput>
	</cfoutput>
	<cfset LobjInterfaz.sbReportarActividad(101, url.ID)>
</cftransaction>
