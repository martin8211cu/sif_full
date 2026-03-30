<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Si ocurre un error esta línea hace que el botón de regresar sea un history.back--->
<cfset Request.Error.Backs = 1>
<cfset DEBUG = false>

<!---►►Nueva Poliza de Desalmacenage◄◄--->
<cfif isdefined("form.Nuevo")>
	<cflocation url="polizaDesalmacenaje.cfm?btnNuevo=Nuevo">
    
<!---►►Nuevo detalle de la Poliza de Desalmacenage◄◄--->
<cfelseif isdefined("form.NuevoDet")>
	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#form.EPDid#&Pagina2=#form.Pagina2#&Pagina3=#form.Pagina3#&Pagina4=#form.Pagina4#">

<!---►►Agregar Enzabezado de la Poliza de Desalmacenage◄◄
1-Verifica que no exista un número de póliza igual al indicado en el encabezado(EPolizaDesalmacenaje)
2-Se inserta el encabezado de la poliza de desalmacenje (EPolizaDesalmacenaje)
3-Agrega los ítems y facturas de la póliza, si el tracking estaba definido
	a.Inserta los ítems no desalmacenados del tracking de embarque con los respectivos montos de las facturas de costos, fletes y seguros prorrateados que se le han aplicado (pasa ETrackingItems a DPolizaDesalmacenaje).
	b.Inserta las facturas de fletes, seguros y gastos aplicadas asociadas a la póliza (Pasa EDocumentosI (1,2,4) a FacturasPoliza).
	c.Inserta las facturas de impuestos aplicadas asociadas a la póliza (Pasa EDocumentosI (5) a CMImpuestosPoliza)--->
    
<cfelseif isdefined("form.Alta")>
	<!---►►1. Verifica que no exista un número de póliza igual al indicado en el encabezado(EPDnumero en EPolizaDesalmacenaje)◄◄--->
    <cfquery name="validaNum" datasource="#session.dsn#">
        select 1
         from EPolizaDesalmacenaje 
        where lower(ltrim(rtrim(EPDnumero))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Lcase(Trim(form.EPDnumero))#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <cfif validaNum.RecordCount>
        <cf_errorCode	code = "50317" msg = "El Número de Póliza ya existe, Proceso Cancelado!">
    </cfif>
    <cftransaction>
		
		<!---►►2. Se inserta el encabezado de la poliza de desalmacenje (EPolizaDesalmacenaje)◄◄--->
		<cfquery name="insert" datasource="#session.dsn#">
			insert into EPolizaDesalmacenaje 
				(CMAAid, Ecodigo, EPDnumero, EPembarque, SNcodigo, 
				CMAid, EPDfecha, EPDdescripcion, 
				EPDpaisori, EPDpaisproc, EPDtotbultos, EPDpesobruto, 
				EPDpesoneto, EPDobservaciones, Mcodigoref, EPDtcref, 
				CMSid, Usucodigo, fechaalta,
				EPDFOBDecAduana, EPDFletesDecAduana,
			    EPDSegurosDecAduana, EPDGastosDecAduana, PermiteDesParcial)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.CMAAid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" 		value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" 			value="#trim(form.EPDnumero)#">, 
				<cfqueryparam cfsqltype="cf_sql_char" 			value="#trim(form.ETidtracking_move)#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" 		value="#form.SNcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.CMAid#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" 		value="#LSParseDateTime(form.EPDfecha)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.EPDdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_char" 			value="#trim(form.EPDpaisori)#">, 
				<cfqueryparam cfsqltype="cf_sql_char" 			value="#trim(form.EPDpaisproc)#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" 		value="#form.EPDtotbultos#">, 
				<cfqueryparam cfsqltype="cf_sql_float" 			value="#form.EPDpesobruto#">, 
				<cfqueryparam cfsqltype="cf_sql_float" 			value="#form.EPDpesoneto#">, 
				<cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#form.EPDobservaciones#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.Mcodigoref#">,
				<cfqueryparam cfsqltype="cf_sql_money" 			value="#form.EPDtcref#">,
				<cfif len(trim(form.CMSid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" 		value="#Now()#">,
				<cfif isdefined("form.EPDFOBDecAduana") 	and len(trim(form.EPDFOBDecAduana))>	<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDFOBDecAduana,',','','all')#"><cfelse>0.00</cfif>,
				<cfif isdefined("form.EPDFletesDecAduana") 	and len(trim(form.EPDFletesDecAduana))>	<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDFletesDecAduana,',','','all')#"><cfelse>0.00</cfif>,
				<cfif isdefined("form.EPDSegurosDecAduana") and len(trim(form.EPDSegurosDecAduana))><cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDSegurosDecAduana,',','','all')#"><cfelse>0.00</cfif>,
				<cfif isdefined("form.EPDGastosDecAduana") 	and len(trim(form.EPDGastosDecAduana))>	<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDGastosDecAduana,',','','all')#"><cfelse>0.00</cfif>,
                <cfif isdefined("form.PermiteDesParcial")>1<cfelse>0</cfif>
			)
			<cf_dbidentity1>
		</cfquery>
			<cf_dbidentity2 name="insert">
		
		<!---►►3. Agrega los ítems y facturas de la póliza, si el tracking estaba definido◄◄--->
		<cfif isdefined("form.ETidtracking_move") and isNumeric(form.ETidtracking_move)>
			<!---►►3.1 Inserta los ítems no desalmacenados del tracking de embarque con los respectivos montos de las facturas de costos, fletes y seguros prorrateados que se le han aplicado◄◄--->
			<cfquery name="insertdet" datasource="#session.dsn#">
				insert into DPolizaDesalmacenaje
					(EPDid, DOlinea, DDlinea, Ecodigo, CMtipo, Cid, CMSid, 
					Aid, Alm_Aid, ACcodigo, ACid, CAid, Icodigo, 
					DPDpaisori, DPDdescripcion, DPDpeso, 
					DPDcantidad, Ucodigo, DPDcostoudescoc, DPDmontofobreal, 
					DPDmontocifreal, DPDimpuestosreal, DPDsegurosreal, DPDfletesreal, 
					DPDaduanalesreal, DPDmontofobest, DPDmontocifest, DPDimpuestosest, 
					DPDsegurosest, DPDfletesest, DPDaduanalesest, DPDvalordeclarado, 
					DPcostodec, DPfeltedec, DPsegurodec, DPseguropropio, 
					Usucodigo, fechaalta, DPDfletesprorrat, DPDsegurosprorrat,
					DPDporcimpCApoliza, DPDporcimpCAarticulo, CAidarticulo, Icodigoarticulo)
				select #insert.identity#, eti.DOlinea, eti.ETIiditem, eti.Ecodigo, do.CMtipo, do.Cid,
					<cfif len(trim(form.CMSid))><CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CMSid#">
					<cfelse><CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif>,
					do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid, a.CAid, coalesce(ica.Icodigo,ca.Icodigo),
					do.Ppais, do.DOdescripcion, 0.00, eti.ETIcantidad, coalesce(eti.Ucodigo, do.Ucodigo),
					(eti.ETcostodirecto - eti.ETcostodirectorec) / eti.ETIcantidad,
					(eti.ETcostodirecto - eti.ETcostodirectorec),
					0.00, 0.00, 0.00, 0.00,
					eti.ETcostoindgastos, 0.00, 0.00, 0.00,
					0.00, 0.00, 0.00, 0.00,
					0.00, 0.00, 0.00, 0.00,
					#session.Usucodigo#, 
					<cf_dbfunction name="now">,
					(eti.ETcostoindfletes - eti.ETcostoindfletesrec),
					(eti.ETcostoindseg - eti.ETcostoindsegrec),
					coalesce(impy.Iporcentaje, impx.Iporcentaje),
					coalesce(impy.Iporcentaje, impx.Iporcentaje),
					a.CAid, coalesce(ica.Icodigo, ca.Icodigo)
				from ETrackingItems eti
					inner join DOrdenCM do
						on do.DOlinea = eti.DOlinea
					
					left outer join Articulos a
						on a.Aid = do.Aid
					left outer join CodigoAduanal ca
						 on ca.CAid    = a.CAid
						and ca.Ecodigo = a.Ecodigo
					left outer join Impuestos impx
						on impx.Icodigo = ca.Icodigo
						and impx.Ecodigo = ca.Ecodigo
					left outer join ImpuestosCodigoAduanal ica 
						 on ica.CAid     = ca.CAid
						and ica.Ppaisori = do.Ppais
					
					 left outer join Impuestos impy
						 on impy.Icodigo = ica.Icodigo
						and impy.Ecodigo = ica.Ecodigo
				where eti.ETIcantidad > 0
					and eti.ETcantfactura > 0
					and eti.ETIestado = 0
					and eti.DOlinea not in (select dpd.DOlinea
                                                from DPolizaDesalmacenaje dpd
                                                    inner join EPolizaDesalmacenaje epd
                                                        on dpd.EPDid = epd.EPDid
                                                       and dpd.Ecodigo = epd.Ecodigo
                                                where dpd.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                                  and epd.EPDestado  = 0
                                                  and epd.EPembarque = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ETidtracking_move)#">)
					and eti.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.ETidtracking_move)#">
			</cfquery>
			
			<!---►►3.2 Inserta las facturas de fletes, seguros y gastos aplicadas asociadas a la póliza◄◄--->
			<cfquery name="insertfacturas" datasource="#session.dsn#">
				insert into FacturasPoliza
					(EPDid, DOlinea, DDlinea, Ecodigo, SNcodigo, Cid, FMmonto, FPfecha, FPafecta, Usucodigo, fechaalta)
				select #insert.identity#, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, ddi.DDItotallinea * edi.EDItc, edi.EDIfecha,
				 	   ddi.DDIafecta,#session.Usucodigo#,<cf_dbfunction name="now">
				from EDocumentosI edi
					inner join DDocumentosI ddi
						on ddi.EDIid = edi.EDIid
				where ddi.DDIafecta in (1,2,4)
					  and ddi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
					  and ddi.DDlinea not in (select y.DDlinea 
                                                from EPolizaDesalmacenaje x
                                                            inner join FacturasPoliza y
                                                                on x.EPDid = y.EPDid
                                                                and x.Ecodigo = y.Ecodigo
                                                where x.Ecodigo = edi.Ecodigo)
				 		and edi.EDIestado = 10
                        <!---Ojo que pregunta por EPDid, por lo que las facturas que se registraron en el exterior, las que dieron el origen al tracking no dentran aca--->
						and edi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
						and edi.EDIimportacion = 1
						and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<!---►►3.3 Inserta las facturas de impuestos aplicadas asociadas a la póliza◄◄--->
			<cfquery name="insertimpuestos" datasource="#session.dsn#">
				insert into CMImpuestosPoliza
					(EPDid, Ecodigo, DDlinea, Icodigo, CMIPmonto, CMIPcridotfiscal, Usucodigo, fechaalta)
				select #insert.identity#, ddi.Ecodigo, ddi.DDlinea, ddi.Icodigo, ddi.DDItotallinea * edi.EDItc, i.Icreditofiscal, 
					#session.Usucodigo#, 
					<cf_dbfunction name="now">
				from EDocumentosI edi
					inner join DDocumentosI ddi
						on ddi.EDIid = edi.EDIid						
					inner join Impuestos i
						on i.Icodigo = ddi.Icodigo
						and i.Ecodigo = ddi.Ecodigo
				where edi.EDIestado = 10
				  and edi.EPDid = #insert.identity#
				  and edi.EDIimportacion = 1
				  and edi.Ecodigo = #session.Ecodigo#
				  and ddi.DDIafecta = 5
                  <!---Ojo que pregunta por EPDid, por lo que las facturas que se registraron en el exterior, las que dieron el origen al tracking no dentran aca--->
				  and ddi.EPDid = #insert.identity#
				  and ddi.DDlinea not in  (select y.DDlinea 
                                                from EPolizaDesalmacenaje x
                                                    inner join CMImpuestosPoliza y
                                                        on x.EPDid = y.EPDid
                                                        and x.Ecodigo = y.Ecodigo
                                                where x.Ecodigo = edi.Ecodigo)
			</cfquery>
		</cfif>
	</cftransaction>
	
	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#insert.identity#">

<!---►►Modificacion de la poliza de Deasalmacenaje◄◄
1-Verifica que no exista un número de póliza igual al indicado en el encabezado(EPolizaDesalmacenaje)
2-Se Actualiza el encabezado de la poliza de desalmacenje (EPolizaDesalmacenaje)
3-Agrega los ítems y facturas de la póliza, si el tracking estaba definido y que no fueron agregados previamente.
	a.Inserta las facturas de fletes, seguros y gastos aplicadas asociadas a la póliza (Pasa EDocumentosI (1,2,4) a FacturasPoliza), no insertadas previamente.
	b.Inserta las facturas de impuestos aplicadas asociadas a la póliza (Pasa EDocumentosI (5) a CMImpuestosPoliza), no insertadas previamente.--->
    
<cfelseif isdefined("form.Cambio")>
	
    <!---►►Control de Concurrencia◄◄--->
	<cf_dbtimestamp 
        datasource = "#session.dsn#"
        table = "EPolizaDesalmacenaje"
        redirect = "polizaDesalmacenaje.cfm?EPDid=#form.EPDid#"
        timestamp = "#form.ts_rversion#"
        field1 = "Ecodigo"
        type1 = "integer"
        value1 = "#Session.Ecodigo#"
        field2 = "EPDid"
        type2 = "numeric"
        value2 = "#form.EPDid#">
        
     <!---►►1. Verifica que no exista un número de póliza igual al indicado en el encabezado(EPDnumero en EPolizaDesalmacenaje)◄◄--->
		<cfquery name="validaNum" datasource="#session.dsn#">
			select 1
			from EPolizaDesalmacenaje
			where lower(ltrim(rtrim(EPDnumero))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Lcase(Trim(form.EPDnumero))#">
			  and EPDid  <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif validaNum.RecordCount>
			<cf_errorCode	code = "50317" msg = "El Número de Póliza ya existe, Proceso Cancelado!">
		</cfif>
            
    	<cftransaction>
		<!---►►2. Se Actualiza el encabezado de la poliza de desalmacenje (EPolizaDesalmacenaje)◄◄--->
		  <cfquery name="update" datasource="#session.dsn#">
			update EPolizaDesalmacenaje 
			set EPDnumero 			= <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(form.EPDnumero)#">, 
				EPembarque 			= <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(form.ETidtracking_move)#">, 
				CMAAid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.CMAAid#">, 
				CMAid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.CMAid#">, 
				SNcodigo 			= <cfqueryparam cfsqltype="cf_sql_integer" 		value="#form.SNcodigo#">, 
				EPDfecha 			= <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.EPDfecha)#">, 
				EPDpaisori 			= <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(form.EPDpaisori)#">, 
				EPDpaisproc 		= <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(form.EPDpaisproc)#">, 
				EPDtotbultos 		= <cfqueryparam cfsqltype="cf_sql_integer" 		value="#form.EPDtotbultos#">, 
				EPDpesobruto 		= <cfqueryparam cfsqltype="cf_sql_float" 		value="#form.EPDpesobruto#">, 
				EPDpesoneto 		= <cfqueryparam cfsqltype="cf_sql_float" 		value="#form.EPDpesoneto#">, 
				EPDdescripcion 		= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.EPDdescripcion#">,
				EPDobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.EPDobservaciones#" null="#len(form.EPDobservaciones) eq 0#">, 
				Mcodigoref 			= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.Mcodigoref#">,
				EPDtcref 			= <cfqueryparam cfsqltype="cf_sql_money" 		value="#form.EPDtcref#">,
				CMSid 				= <cfif len(trim(form.CMSid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#"><cfelse>null</cfif>,
				Usucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				EPDFOBDecAduana 	= <cfif isdefined("form.EPDFOBDecAduana") 	  and len(trim(form.EPDFOBDecAduana))>    <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDFOBDecAduana,',','','all')#"><cfelse>0.00</cfif>,
				EPDFletesDecAduana	= <cfif isdefined("form.EPDFletesDecAduana")  and len(trim(form.EPDFletesDecAduana))> <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDFletesDecAduana,',','','all')#"><cfelse>0.00</cfif>,
			    EPDSegurosDecAduana = <cfif isdefined("form.EPDSegurosDecAduana") and len(trim(form.EPDSegurosDecAduana))><cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDSegurosDecAduana,',','','all')#"><cfelse>0.00</cfif>,
				EPDGastosDecAduana	= <cfif isdefined("form.EPDGastosDecAduana")  and len(trim(form.EPDGastosDecAduana))> <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.EPDGastosDecAduana,',','','all')#"><cfelse>0.00</cfif>,
                PermiteDesParcial 	= <cfif isdefined("form.PermiteDesParcial")>1<cfelse>0</cfif>

			where EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
		</cfquery>

		<!---►►3. Inserción de las facturas de gastos, fletes, seguros e impuestos, si el tracking estaba definido◄◄--->
		<cfif isdefined("form.ETidtracking_move") and isNumeric(form.ETidtracking_move)>

			<!---►►3.1 Inserta las facturas de gastos, seguros y fletes aplicadas asociadas a la póliza no insertadas previamente◄◄--->
			<cfquery name="insertfacturas" datasource="#session.dsn#">
				insert into FacturasPoliza
					(EPDid, DOlinea, DDlinea, Ecodigo, SNcodigo, Cid, FMmonto, FPfecha, FPafecta, Usucodigo, fechaalta)
				select <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EPDid#">, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, edi.SNcodigo, ddi.Cid, ddi.DDItotallinea * edi.EDItc, edi.EDIfecha, ddi.DDIafecta,
					#session.Usucodigo#, 
					<cf_dbfunction name="now">
				from EDocumentosI edi
					inner join DDocumentosI ddi
						on ddi.EDIid = edi.EDIid
				where edi.EDIestado = 10
					and edi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					and edi.EDIimportacion = 1
					and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ddi.DDIafecta in (1,2,4)
					and ddi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					and ddi.DDlinea not in  (select y.DDlinea 
                                                from EPolizaDesalmacenaje x
                                                    inner join FacturasPoliza y
                                                        on x.EPDid = y.EPDid
                                                        and x.Ecodigo = y.Ecodigo
                                                where x.Ecodigo = edi.Ecodigo)
			</cfquery>

			<!---►►3.2 Inserta las facturas de impuestos aplicadas asociadas a la póliza no insertadas previamente◄◄--->
			<cfquery name="insertimpuestos" datasource="#session.dsn#">
				insert into CMImpuestosPoliza
					(EPDid, Ecodigo, DDlinea, Icodigo, CMIPmonto, CMIPcridotfiscal, Usucodigo, fechaalta)
				select <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EPDid#">, ddi.Ecodigo, ddi.DDlinea, ddi.Icodigo, ddi.DDItotallinea * edi.EDItc, i.Icreditofiscal, 
					#session.Usucodigo#, 
					<cf_dbfunction name="now">
				from EDocumentosI edi
					inner join DDocumentosI ddi
						on ddi.EDIid = edi.EDIid						
					inner join Impuestos i
						on i.Icodigo = ddi.Icodigo
						and i.Ecodigo = ddi.Ecodigo
				where edi.EDIestado 		 = 10
					  and edi.EPDid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					  and edi.EDIimportacion = 1
					  and edi.Ecodigo 		 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and ddi.DDIafecta      = 5
					  and ddi.EPDid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					  and ddi.DDlinea not in (select y.DDlinea 
                                                from EPolizaDesalmacenaje x
                                                    inner join CMImpuestosPoliza y
                                                        on x.EPDid = y.EPDid
                                                        and x.Ecodigo = y.Ecodigo
                                                where x.Ecodigo = edi.Ecodigo)
			</cfquery>
		</cfif>		
	</cftransaction>
	
	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#form.EPDid#&Pagina2=#form.Pagina2#&Pagina3=#form.Pagina3#&Pagina4=#form.Pagina4#">

<!---►►Eliminación de la poliza de desalmacenamiento◄◄
1-Elimina la distribución de gastos (FacturasGastoItem)
2-Elimina las facturas de gastos de la póliza (FacturasPoliza)
3-Elimina la distribución de impuestos (CMImpuetosItem)
4-Elimina las facturas de impuestos de la póliza (CMImpuetosPoliza)
5-Elimina los ítems de la póliza (DPolizaDesalmacenaje)
6-Elimina el encabezado de la póliza (EPolizaDesalmacenaje)
--->
<cfelseif isdefined("form.Baja")>
	
	<cftransaction>
		
		<!---►►1. Elimina la distribución de gastos (FacturasGastoItem)◄◄--->
		<cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="DeleteFacturasGastoItem">
    		<cfinvokeargument name="EPDid" value="#Form.EPDid#">
    	</cfinvoke>
		
		<!---►►2. Elimina las facturas de gastos de la póliza (FacturasPoliza)◄◄--->
		<cfquery name="delete" datasource="#session.dsn#">
			delete from FacturasPoliza
			where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!---►►3. Elimina la distribución de impuestos (CMImpuetosItem)◄◄--->
		<cfquery name="delete" datasource="#session.dsn#">
			delete from CMImpuestosItem
			 where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!---►►4. Elimina las facturas de impuestos de la póliza (CMImpuetosPoliza)◄◄--->
		<cfquery name="delete" datasource="#session.dsn#">
			delete from CMImpuestosPoliza
			 where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!---►►5. Elimina los ítems de la póliza (DPolizaDesalmacenaje)◄◄--->
		<cfquery name="delete" datasource="#session.dsn#">
			delete from DPolizaDesalmacenaje
			 where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!---►►6. Elimina el encabezado de la póliza (EPolizaDesalmacenaje)◄◄--->
		<cfquery name="delete" datasource="#session.dsn#">
			delete from EPolizaDesalmacenaje 
			 where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
	</cftransaction>

<!---►►Agregar (desalmacenar) otro ítem del tracking◄◄--->
<cfelseif isdefined("form.AltaDet")> 
	<!---►►1. Verifica que no desalmacene más de lo que hay disponible en el tracking(ETIcantidad/ETIiditem en ETrackingItems)◄◄--->
    <cfquery name="validamonto" datasource="#session.dsn#">
        select 1
        from ETrackingItems
          where ETIiditem   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETIiditem#">
            and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and ETIcantidad > 0
            and ETIcantidad < <cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#">
    </cfquery>
    <cfif validamonto.recordcount>
        <cf_errorCode	code = "50318" msg = "El monto ingresado supera el monto restante de la línea de la factura, proceso cancelado!">
    </cfif>
	<cftransaction>
		
		<!---►►2. Inserta el ítem indicado (pasa ETrackingItems a DPolizaDesalmacenaje)◄◄--->
		<cfquery name="insertdet" datasource="#session.dsn#">
			insert into DPolizaDesalmacenaje
				(EPDid, DOlinea, DDlinea, Ecodigo, CMtipo, Cid, CMSid,
				Aid, Alm_Aid, ACcodigo, ACid, CAid, Icodigo,
				DPDpaisori, DPDdescripcion, DPDpeso,
				DPDcantidad, Ucodigo, DPDcostoudescoc, DPDmontofobreal,
				DPcostodec, DPfeltedec, DPsegurodec, DPseguropropio,
				DPDcantreclamo, DPDobsreclamo,
				DPDmontocifreal, DPDimpuestosreal, DPDsegurosreal, DPDfletesreal,
				DPDaduanalesreal, DPDmontofobest, DPDmontocifest, DPDimpuestosest,
				DPDsegurosest, DPDfletesest, DPDaduanalesest, DPDvalordeclarado,
				Usucodigo, fechaalta, DPDfletesprorrat, DPDsegurosprorrat,
				DPDporcimpCApoliza, DPDporcimpCAarticulo, CAidarticulo, Icodigoarticulo)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.EPDid)#">,
				eti.DOlinea, eti.ETIiditem, eti.Ecodigo, do.CMtipo, do.Cid,
				<cfif len(trim(form.DCMSid)) GT 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCMSid#"><cfelse>null</cfif>,
				do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAid#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Icodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.DPDpaisori#">,
				do.DOdescripcion,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDpeso#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#">,
				coalesce(eti.Ucodigo, do.Ucodigo), 
				(eti.ETcostodirecto - eti.ETcostodirectorec) / eti.ETIcantidad,
				(eti.ETcostodirecto - eti.ETcostodirectorec) * (<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#"> / eti.ETIcantidad),
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.DPcostodec#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.DPfletedec#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.DPsegurodec#">, 
				0.00, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantreclamo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DPDobsreclamo#" null="#len(trim(form.DPDobsreclamo)) eq 0#">,
				eti.ETcostoindgastos, 0.00, 0.00, 0.00,
				0.00, 0.00, 0.00, 0.00,
				0.00, 0.00, 0.00, 0.00,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cf_dbfunction name="now">,
				(eti.ETcostoindfletes - eti.ETcostoindfletesrec) * (<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#"> / eti.ETIcantidad),
				(eti.ETcostoindseg - eti.ETcostoindsegrec) * (<cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#"> / eti.ETIcantidad),
				coalesce(impy.Iporcentaje, impx.Iporcentaje),
				coalesce(impy.Iporcentaje, impx.Iporcentaje),
				a.CAid, coalesce(ica.Icodigo, ca.Icodigo)
			from ETrackingItems eti
				inner join DOrdenCM do
					on do.DOlinea = eti.DOlinea
					
				left outer join Articulos a
					on a.Aid = do.Aid
				left outer join CodigoAduanal ca
					on ca.CAid = a.CAid
					and ca.Ecodigo = a.Ecodigo
				left outer join Impuestos impx
					on impx.Icodigo = ca.Icodigo
					and impx.Ecodigo = ca.Ecodigo
				left outer join ImpuestosCodigoAduanal ica
					 on ica.CAid     = ca.CAid
					and ica.Ppaisori = do.Ppais
				left outer join Impuestos impy
					on impy.Icodigo = ica.Icodigo
					and impy.Ecodigo = ica.Ecodigo
			where eti.ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETIiditem#">
			  and eti.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cftransaction>
	
	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#form.EPDid#&Pagina2=#form.Pagina2#&Pagina3=#form.Pagina3#&Pagina4=#form.Pagina4#">

<!---►►Modificación de un ítem de la póliza◄◄--->
<cfelseif isdefined("form.CambioDet") and isdefined("form.DPDlinea") and (form.DPDlinea  gt 0)> <cfdump var="#form#">
	
		<!---►►1. Verifica que no desalmacene más de lo que hay disponible en el tracking(ETIcantidad/ETIiditem en ETrackingItems)◄◄--->
		<cfquery name="validamonto" datasource="#session.dsn#">
			select 1
			from ETrackingItems
			  where ETIiditem   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETIiditem#">
				and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ETIcantidad > 0
				and ETIcantidad < <cfqueryparam cfsqltype="cf_sql_float" value="#form.DPDcantidad#">
		</cfquery>
		<cfif validamonto.recordcount>
			<cf_errorCode	code = "50318" msg = "El monto ingresado supera el monto restante de la línea de la factura, proceso cancelado!">
		</cfif>
		
		<!---►►2. Obtiene los datos del item del tracking (cantidad facturada, fletes y seguros)◄◄--->
		<cfquery name="datosItemTracking" datasource="#session.dsn#">
			select ETcantfactura, ETIcantidad,
				   coalesce(ETtipocambiofac, 1.00) as ETtipocambiofac,
				   ETcostoindfletes, ETcostoindfletesrec,
				   ETcostoindseg, ETcostoindsegrec,
				   ETcostodirecto, ETcostodirectorec
			from ETrackingItems
			where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETIiditem#">
		</cfquery>
        
	  <cftransaction>	
		<!---►►3. Actualiza el ítem indicado (DPolizaDesalmacenaje)◄◄--->
		<cfif datosItemTracking.RecordCount gt 0>
			<cf_dbtimestamp 
				datasource 	= "#session.dsn#"
				table 		= "DPolizaDesalmacenaje"
				redirect 	= "polizaDesalmacenaje.cfm?EPDid=#form.EPDid#"
				timestamp 	= "#form.ts_rversiondet#"
				field1 		= "Ecodigo"
				type1 		= "integer"
				value1 		= "#Session.Ecodigo#"
				field2 		= "EPDid"
				type2 		= "numeric"
				value2 		= "#form.EPDid#"
				field3 		= "DPDlinea"
				type3 		= "numeric"
				value3 		= "#form.DPDlinea#">
                
			<cfquery name="updatedet" datasource="#session.dsn#">
				update DPolizaDesalmacenaje 
				set DPDcantidad 		= <cfqueryparam cfsqltype="cf_sql_float" 	value="#form.DPDcantidad#">, 
					CAid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CAid#">, 
					DPDpaisori 			= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(form.DPDpaisori)#">, 
					Icodigo		 		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(form.Icodigo)#">, 
					DPDpeso 			= <cfqueryparam cfsqltype="cf_sql_float" 	value="#form.DPDpeso#">, 
					Usucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
					DPDmontofobreal 	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#(form.DPDcantidad / datosItemTracking.ETIcantidad) * (datosItemTracking.ETcostodirecto - datosItemTracking.ETcostodirectorec)#">,
					DPcostodec 			= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.DPcostodec#">, 
					DPfeltedec 			= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.DPfletedec#">, 
					DPsegurodec 		= <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.DPsegurodec#">,
					DPDcantreclamo 		= <cfqueryparam cfsqltype="cf_sql_float" 	value="#form.DPDcantreclamo#">,
					DPDobsreclamo 		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.DPDobsreclamo#" null="#len(form.DPDobsreclamo) eq 0#">,
					CMSid 				= <cfif len(trim(form.DCMSid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCMSid#"><cfelse>null</cfif>,
					DPDfletesprorrat 	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#(form.DPDcantidad / datosItemTracking.ETIcantidad) * (datosItemTracking.ETcostoindfletes - datosItemTracking.ETcostoindfletesrec)#">,
					DPDsegurosprorrat 	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#(form.DPDcantidad / datosItemTracking.ETIcantidad) * (datosItemTracking.ETcostoindseg - datosItemTracking.ETcostoindsegrec)#">,
					DPDporcimpCApoliza 	= (select imp.Iporcentaje from Impuestos imp where imp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and imp.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Icodigo)#">)
				where DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DPDlinea#">
				  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50319" msg = "No se encontró el ítem asociado en el tracking del encabezado">
		</cfif>

	</cftransaction>

	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#form.EPDid#&Pagina2=#form.Pagina2#&Pagina3=#form.Pagina3#&Pagina4=#form.Pagina4#">

<!---►►Eliminacion de un ítem de la poliza de desalmacenamiento◄◄--->
<cfelseif isdefined("form.BajaDet") and isdefined("form.DPDlinea") and (form.DPDlinea gt 0)>

	<cftransaction>
	
		<!---►►1. Elimina la distribución de gastos, fletes y seguros para la línea (FacturasGastoItem)◄◄--->
		<cfquery name="deletefacturasitem" datasource="#session.dsn#">
			DELETE from FacturasGastoItem
			WHERE DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DPDlinea#">
		</cfquery>
		
		<!---►►2. Elimina la distribución de los impuestos para la línea (CMImpuestosItem)◄◄--->
		<cfquery name="deleteimpuestositem" datasource="#session.dsn#">
			DELETE from CMImpuestosItem
			WHERE DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DPDlinea#">
				and EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!---►►3. Elimina el detalle (ítem) de la póliza (DPolizaDesalmacenaje)◄◄--->
		<cfquery name="deletedet" datasource="#session.dsn#">
			delete from DPolizaDesalmacenaje 
			where DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DPDlinea#">
				and EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
	</cftransaction>
	
	<cflocation url="polizaDesalmacenaje.cfm?EPDid=#form.EPDid#&Pagina2=#form.Pagina2#&Pagina3=#form.Pagina3#&Pagina4=#form.Pagina4#">

<!---►►CALCULA LA DISTRIBUCION DE LOS COSTOS DE LA POLIZA◄◄--->
<cfelseif isdefined("form.Calcular")>

	<!---►►PASO 1 Validaciones sobre las lineas de la poliza:◄◄--->
	<cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="ValidaDPolizaDesalmacenaje">
    	<cfinvokeargument name="EPDid" value="#Form.EPDid#">
    </cfinvoke>
    
     <!---►►PASO 2: Obtiene la distribución tal y como se insertaría a detalle tránsito para que en el cierre no sea necesario realizar otro ajuste.
		   Se redondea a 2 para no perder decimales al insertar las facturas a la póliza ya que se insertan en la moneda local◄◄--->
	<cfquery name="facturasItemPorInsertar" datasource="#session.dsn#">
			select f.FPid, p.DPDlinea, edi.EDItc,
				round(
				(f.FMmonto * (p.DPDmontofobreal + coalesce(p.DPDfletesprorrat, 0.00) + coalesce(p.DPDsegurosprorrat, 0.00)) /
					(
						select sum (a.DPDmontofobreal + coalesce(a.DPDfletesprorrat, 0.00) + coalesce(a.DPDsegurosprorrat, 0.00))
						from DPolizaDesalmacenaje a
						where a.EPDid = p.EPDid
					)
				) / edi.EDItc
				, 2) as FGImontoTransito
			from DPolizaDesalmacenaje p
				inner join FacturasPoliza f
					on f.EPDid = p.EPDid
				inner join DDocumentosI ddi
					on ddi.DDlinea = f.DDlinea
				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
			where p.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by f.FPid, (p.DPDmontofobreal + coalesce(p.DPDfletesprorrat, 0.00) + coalesce(p.DPDsegurosprorrat, 0.00)) desc
		</cfquery>
		

		<cfset FPidActual = "">				<!--- Variable que indica la factura actual que se está ajustando --->
		<cfset FPidAjustada = false>		<!--- Variable que indica si la factura actual ya fue ajustada --->
		<cfset CalcularMontosAjuste = true>	<!--- Variable que indica si hay que calcular el total de montos real y esperado --->
	
    <cftransaction>
	
		<!--- 2. Distribución de gastos por ítem en la póliza --->
		
		<!--- 2.1 Elimina las distribuciones anteriores --->
		<cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="DeleteFacturasGastoItem">
    		<cfinvokeargument name="EPDid" value="#Form.EPDid#">
    	</cfinvoke>
		
		
		<!--- 2.3 Realiza el ajuste --->
		<cfloop query="facturasItemPorInsertar">
		
			<cfif FPidActual neq facturasItemPorInsertar.FPid>
				<cfset FPidActual = facturasItemPorInsertar.FPid>
				<cfset FPidAjustada = false>
				<cfset CalcularMontosAjuste = true>
			</cfif>
			
			<cfif not FPidAjustada>
			
				<cfif CalcularMontosAjuste>
					<cfquery name="rsTotalGastosEsperado" datasource="#session.dsn#">
						select ddi.DDItotallinea as totalGastosEsperado
						from FacturasPoliza fp
							inner join DDocumentosI ddi
								on ddi.DDlinea = fp.DDlinea
						where fp.FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPidActual#">
					</cfquery>
					
					<cfquery name="rsTotalGastosReal" dbtype="query">
						select sum(FGImontoTransito) as totalGastosReal
						from facturasItemPorInsertar
						where FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPidActual#">
					</cfquery>
					
					<cfset TotalAjuste = rsTotalGastosEsperado.totalGastosEsperado - rsTotalGastosReal.totalGastosReal>
				</cfif>

				<cfif TotalAjuste gt 0>
					<cfset nuevoMonto = facturasItemPorInsertar.FGImontoTransito + TotalAjuste>
					<cfset QuerySetCell(facturasItemPorInsertar, "FGImontoTransito", nuevoMonto, facturasItemPorInsertar.CurrentRow)>
					<cfset FPidAjustada = true>
					<cfset TotalAjuste = 0>
					<cfset CalcularMontosAjuste = true>

				<cfelseif TotalAjuste lt 0>
					<cfif -1 * TotalAjuste gt facturasItemPorInsertar.FGImontoTransito>
						<cfset nuevoMonto = 0.00>
						<cfset TotalAjuste = TotalAjuste + facturasItemPorInsertar.FGImontoTransito>
						<cfset CalcularMontosAjuste = false>
					<cfelse>
						<cfset nuevoMonto = facturasItemPorInsertar.FGImontoTransito + TotalAjuste>
						<cfset FPidAjustada = true>
						<cfset TotalAjuste = 0>
						<cfset CalcularMontosAjuste = true>
					</cfif>
					<cfset QuerySetCell(facturasItemPorInsertar, "FGImontoTransito", nuevoMonto, facturasItemPorInsertar.CurrentRow)>
				<cfelse>
					<cfset FPidAjustada = true>
					<cfset CalcularMontosAjuste = true>					
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- 2.4 Inserta los montos ajustados a las facturas de la póliza --->
		<cfloop query="facturasItemPorInsertar">
			<cfquery name="insertfacturasitem" datasource="#session.dsn#">
				insert into FacturasGastoItem
					(FPid, DPDlinea, FGImonto)
				values
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#facturasItemPorInsertar.FPid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#facturasItemPorInsertar.DPDlinea#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#facturasItemPorInsertar.FGImontoTransito * facturasItemPorInsertar.EDItc#">
					)
			</cfquery>
		</cfloop>
<!--- esto no se toca cuando tiene al menos un hijo --->
		<!--- 3. Actualiza los gastos reales para cada ítem de la póliza --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET
				DPDfletesreal = (
						select coalesce(sum(FGImonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00)
						from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
						where a.FPid = b.FPid
							and b.FPafecta = 1
							and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
							and ddi.DDlinea = b.DDlinea
							and edi.EDIid = ddi.EDIid
				),
				DPDsegurosreal = (
						select coalesce(sum(FGImonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00)
						from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
						where a.FPid = b.FPid
							and b.FPafecta = 2
							and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
							and ddi.DDlinea = b.DDlinea
							and edi.EDIid = ddi.EDIid
				),
				DPDaduanalesreal = (
						<!---►►Costos Aduanales Internos◄◄--->
                        coalesce((select sum(coalesce(FGImonto,0.00) * case when edi.EDItipo = 'N' then -1.00 else 1.00 end)
									from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
                                    where a.FPid = b.FPid
                                      and b.FPafecta = 4
                                      and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
                                      and ddi.DDlinea = b.DDlinea
                                      and edi.EDIid = ddi.EDIid
                                     ),0.00) +
                         <!---►►Costos Aduanales Externos◄◄--->
                         coalesce((select coalesce(dt.ETcostoindgastos,0) 
                         			from ETrackingItems dt 
                           		   where dt.ETIiditem = DPolizaDesalmacenaje.DDlinea),0.00)
				)
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 4. Cálculo del seguro propio --->

<!---		<!--- Función para obtener una fórmula de cálculo de seguros --->
		<cffunction name="getFormulaSeguro" returntype="query">
			<cfargument name="CMSid" type="numeric" required="true">
			<cfquery name="rs" dbtype="query">
				select * from rsFormulasSeguro
				where CMSid = #Arguments.CMSid#
			</cfquery>
			<cfreturn rs>
		</cffunction>
--->
		<!--- 4.1 Obtiene la lista de seguros de la empresa --->
		<cfquery name="rsFormulasSeguro" datasource="#session.dsn#">
			SELECT CMSid, Costos, Fletes, Seguros, ESporcadic, ESporcmult
			FROM CMSeguros
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 4.2 Obtiene los ítems de la póliza --->
		<cfquery name="rsLineasPoliza" datasource="#session.dsn#">
			SELECT DPDlinea, CMSid, DPDmontofobreal, DPDfletesreal,
				   DPDsegurosreal, coalesce(DPDfletesprorrat, 0.00) as DPDfletesprorrat,
				   coalesce(DPDsegurosprorrat,0.00) as DPDsegurosprorrat,
				   DOlinea, DPDcantidad
			FROM DPolizaDesalmacenaje
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 4.3 Calcula el seguro propio para cada ítem de la póliza --->
		<cfloop query="rsLineasPoliza">
		
			<!--- 4.3.1 Valida condiciones mínimas para realizar el cálculo --->
			<!--- Para que cumpla con las condiciones mínimas, el seguro debe incluir:
				(Costos o Fletes o Seguros) y tener el porcentaje adicional y multiplicativo mayores a 0 --->
			<cfset reuneCondMin = True>
			<cfif len(rsLineasPoliza.CMSid) eq 0>
				<cfset reuneCondMin = False>
			<cfelse>
				<!--- Cosulta la formula de la línea --->
				<cfset rsFormula = getFormulaSeguro(rsLineasPoliza.CMSid)>
				<cfif rsFormula.RecordCount eq 0>
					<cfset reuneCondMin = False>
				<cfelseif ( (rsFormula.Costos eq 0) and (rsFormula.Fletes eq 0) and (rsFormula.Seguros eq 0) ) or (rsFormula.ESporcadic eq 0) or (rsFormula.ESporcmult eq 0)>
					<cfset reuneCondMin = False>
				</cfif>
			</cfif>
			
			<cfif reuneCondMin>
				<!--- 4.3.2 Obtiene el último tipo de cambio insertado para la moneda,
							así como los montos de costos, fletes y seguros del exterior
							en la moneda original --->
				<cfquery name="rsTipoCambioSeguro" datasource="#session.dsn#">
					select 
						eti.ETtipocambiofac, 
						coalesce(
							(
								select min(tc.TCventa)
								from Htipocambio tc
								where tc.Mcodigo = eti.Mcodigo
								and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EPDfecha)#">
								and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EPDfecha)#">
							)
							, eti.ETtipocambiofac,1) as TCventa,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostodirectofacorig as ETcostodirectofacorig,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostoindfletesfacorig as ETcostoindfletesfacorig,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostoindsegfacorig as ETcostoindsegfacorig
					from ETrackingItems eti
					where eti.DOlinea      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasPoliza.DOlinea#">
					  and eti.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and eti.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move#">
				</cfquery>

				<!--- 4.3.3 Inicializa el seguro propio en 0 --->
				<cfset LSeguroPropio = 0.00>
				<!--- 4.3.4 Si la fórmula indica costos, suma el monto fob real --->
				<cfif rsFormula.Costos>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDmontofobreal--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostodirectofacorig>
				</cfif>
				<!--- 4.3.5 Si la fórmula indica fletes, suma el monto de fletes real --->
				<cfif rsFormula.Fletes>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDfletesprorrat--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostoindfletesfacorig>
				</cfif>
				<!--- 4.3.6 Si la fórmula indica seguros, suma el monto de seguros real --->
				<cfif rsFormula.Seguros>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDsegurosprorrat--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostoindsegfacorig>
				</cfif>
				<!--- 4.3.7 Suma el porcentaje adicional de la fórmula --->
				<cfset LSeguroPropio = LSeguroPropio + (LSeguroPropio * rsFormula.ESporcadic / 100)>
				<!--- 4.3.8 Saca el porcentaje multiplicativo de la fórmula del total --->
				<cfset LSeguroPropio = (LSeguroPropio * rsFormula.ESporcmult / 100)>
				<!--- 4.3.9 Convierte el total al último tipo de cambio en el histórico --->
				<!---cfset LSeguroPropio = (LSeguroPropio / rsTipoCambioSeguro.ETtipocambiofac) * rsTipoCambioSeguro.TCventa--->
				<cfif NOT ISDEFINED('rsTipoCambioSeguro.TCventa') OR NOT LEN(TRIM(rsTipoCambioSeguro.TCventa))>
                	<CFSET rsTipoCambioSeguro.TCventa = 1>
                </cfif>
				<cfset LSeguroPropio = LSeguroPropio * rsTipoCambioSeguro.TCventa>
			<cfelse>
				<cfset LSeguroPropio = 0>
			</cfif>

			<!--- 4.3.10 Actualiza el seguro propio de la línea de la póliza --->
			<cfquery datasource="#session.dsn#">
				UPDATE DPolizaDesalmacenaje
				SET	DPseguropropio = <cfqueryparam cfsqltype="cf_sql_money" value="#LSeguroPropio#">
				WHERE DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasPoliza.DPDlinea#">
					AND EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		</cfloop>
		
		<!--- 5. Actualiza el monto cif real de la línea como el fob + fletes + seguros + seguro propio --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET DPDmontocifreal = DPDmontofobreal + coalesce(DPDfletesprorrat, 0.00) + coalesce(DPDsegurosprorrat, 0.00) + DPseguropropio
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 6. Distribución de los impuestos --->
		
		<!--- 6.1 Elimina la distribución anterior de impuestos --->
		<cfquery name="deleteimpuestositem" datasource="#session.dsn#">
			DELETE from CMImpuestosItem
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 6.2 Realiza la nueva distribución de impuestos --->
			
		<!--- 6.2.1 Distribuye los impuestos distintos al impuesto de ventas
					usado para el entero fiscal --->
		<cfquery name="insertimpuestositem" datasource="#session.dsn#">
			INSERT INTO CMImpuestosItem
				(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
			SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
				coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
				a.DPDmontocifreal * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
				(
					select x.CMIPmonto
					from CMImpuestosPoliza x
					where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo)
						and x.Ecodigo = a.Ecodigo
						and x.EPDid = a.EPDid
						and x.DDlinea = cmip.DDlinea
				)<!---  as montoimp --->
				/
				(
					SELECT sum(x.DPDmontocifreal * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
					FROM DPolizaDesalmacenaje x
						INNER JOIN Impuestos z
							LEFT OUTER JOIN DImpuestos w
							ON w.Icodigo = z.Icodigo
							AND w.Ecodigo = z.Ecodigo
						ON z.Icodigo = x.Icodigo
						AND z.Ecodigo = x.Ecodigo
					WHERE x.EPDid = a.EPDid
						AND x.Ecodigo = a.Ecodigo
						AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                        and w.DIcodigo <> 'VTS'
                        and w.DIcodigo <> 'IVS'
						and z.Icodigo <> 'VTS'
						and z.Icodigo <> 'IVS'
				)<!---  as sumaporcentajes --->
				*
				(
					a.DPDmontocifreal * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
				)<!---  as impuesto --->
			FROM DPolizaDesalmacenaje a
				INNER JOIN Impuestos c
					LEFT OUTER JOIN DImpuestos d
					ON d.Icodigo = c.Icodigo
					AND d.Ecodigo = c.Ecodigo
					and d.DIcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
					and d.DIcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
				ON c.Icodigo = a.Icodigo
				AND c.Ecodigo = a.Ecodigo
				and c.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
				and c.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">

				inner join CMImpuestosPoliza cmip
					on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
					and cmip.Ecodigo = a.Ecodigo
					and cmip.EPDid = a.EPDid

			WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 6.2.2 Distribuye el impuesto de ventas de servicios,
					usando el CIF + los otros gastos en la factura --->
        <cfset LvarDBtype		= Application.dsinfo[session.dsn].type>
        
		<cfif ListFind('sqlserver', LvarDBtype)>
            <cfquery name="rsimpuestositemServicios" datasource="#session.dsn#">
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje 
                    
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
            </cfquery>
            
            <cfloop query="rsimpuestositemServicios">
                <cfset LvarDPDlinea1 = 	rsimpuestositemServicios.DPDlinea>
                <cfset LvarEcodigo1 = 	rsimpuestositemServicios.Ecodigo>
                <cfset LvarIcodigo1 = 	rsimpuestositemServicios.Icodigo>
                <cfset LvarEPDid1 = 		rsimpuestositemServicios.EPDid>
                <cfset LvarDDlinea1 = 	rsimpuestositemServicios.DDlinea>
                <cfset LvarIporcentaje1 = rsimpuestositemServicios.Iporcentaje>
                
                <cfquery name="rsMontoteorico" datasource="#session.DSN#">
                    select coalesce(sum(fgi.FGImonto), 0.00) * #LvarIporcentaje1# / 100.00 as Montoteorico
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                </cfquery>
                
                <cfquery name="rsMonto" datasource="#session.DSN#">
                    Select x.CMIPmonto 
                    from CMImpuestosPoliza x 
                    where x.Icodigo = '#LvarIcodigo1#'
                        and x.Ecodigo = #LvarEcodigo1#
                        and x.EPDid = #LvarEPDid1#
                        and x.DDlinea = #LvarDDlinea1#
                </cfquery>

                <cfquery name="rsMonto2" datasource="#session.DSN#">
                    select sum(coalesce(fgi.FGImonto, 0.00)) * (#LvarIporcentaje1# / 100.00) as Monto2
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                            
				</cfquery>
                
				<cfquery name="rsMonto3" datasource="#session.DSN#">
                    select sum(coalesce(fgi.FGImonto, 0.00)) * (#LvarIporcentaje1#/ 100.00) as Monto3
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                </cfquery>
                
                <cfset LvarCalc1 = rsMonto.CMIPmonto /  rsMonto2.Monto2 * rsMonto3.Monto3>
                
                <cfquery datasource="#session.dsn#">
                	INSERT INTO CMImpuestosItem
                    	(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                    values(
                    	#LvarDPDlinea1#,
                        #LvarEcodigo1#,
                        '#LvarIcodigo1#',
                        #LvarEPDid1#,
                        #LvarDDlinea1#,
                        #LvarIporcentaje1#,
                        #rsMontoteorico.Montoteorico#,
                        #LvarCalc1#
                        )
                        
                </cfquery> <!--- 
                <cfoutput>*<br />
						#LvarDPDlinea1#,<br />
                        #LvarEcodigo1#,<br />
                        '#LvarIcodigo1#',<br />
                        #LvarEPDid1#,<br />
                        #LvarDDlinea1#,<br />
                        #LvarIporcentaje1#,<br />
                        #rsMontoteorico.Montoteorico#,<br />
                        #LvarCalc1#<br />*
				</cfoutput> --->
                
            </cfloop>
        <cfelse>
        	<cfquery name="insertimpuestositemServicios" datasource="#session.dsn#">
                INSERT INTO CMImpuestosItem
                    (DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
                 
                    ( 
                        (
                        select coalesce(sum(fgi.FGImonto), 0.00)
                        from FacturasGastoItem fgi
                            inner join FacturasPoliza fp
                                on fp.FPid = fgi.FPid
                        where fgi.DPDlinea = a.DPDlinea
                            and fp.DDlinea in
                                (select fp2.DDlinea
                                 from FacturasPoliza fp2
                                    inner join DDocumentosI ddi1
                                        on ddi1.DDlinea = fp2.DDlinea
                                 where ddi1.EDIid = (select ddi2.EDIid
                                                     from DDocumentosI ddi2
                                                     where ddi2.DDlinea = cmip.DDlinea)
                                )
                        )
                    ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
                    (
                        select x.CMIPmonto 
                        from CMImpuestosPoliza x 
                        where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo) 
                            and x.Ecodigo = a.Ecodigo
                            and x.EPDid = a.EPDid
                            and x.DDlinea = cmip.DDlinea
                    )<!---  as montoimp --->
                    /
                    (
                        SELECT sum((	
                                    (
                                    select coalesce(sum(fgi.FGImonto), 0.00)
                                    from FacturasGastoItem fgi
                                        inner join FacturasPoliza fp
                                            on fp.FPid = fgi.FPid
                                    where fgi.DPDlinea = x.DPDlinea
                                        and fp.DDlinea in
                                            (select fp2.DDlinea
                                             from FacturasPoliza fp2
                                                inner join DDocumentosI ddi1
                                                    on ddi1.DDlinea = fp2.DDlinea
                                             where ddi1.EDIid = (select ddi2.EDIid
                                                                 from DDocumentosI ddi2
                                                                 where ddi2.DDlinea = cmip.DDlinea)
                                            )
                                    )				
                        ) * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
                        FROM DPolizaDesalmacenaje x
                            INNER JOIN Impuestos z
                                LEFT OUTER JOIN DImpuestos w
                                ON w.Icodigo = z.Icodigo
                                AND w.Ecodigo = z.Ecodigo
                            ON z.Icodigo = x.Icodigo
                            AND z.Ecodigo = x.Ecodigo
                        WHERE x.EPDid = a.EPDid
                            AND x.Ecodigo = a.Ecodigo
                            AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                    )<!---  as sumaporcentajes --->
                    *
                    (
                        (
                            (
                            select coalesce(sum(fgi.FGImonto), 0.00)
                            from FacturasGastoItem fgi
                                inner join FacturasPoliza fp
                                    on fp.FPid = fgi.FPid
                            where fgi.DPDlinea = a.DPDlinea
                                and fp.DDlinea in
                                    (select fp2.DDlinea
                                     from FacturasPoliza fp2
                                        inner join DDocumentosI ddi1
                                            on ddi1.DDlinea = fp2.DDlinea
                                     where ddi1.EDIid = (select ddi2.EDIid
                                                         from DDocumentosI ddi2
                                                         where ddi2.DDlinea = cmip.DDlinea)
                                    )
                            )
                        ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
                    )<!---  as impuesto --->
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
            </cfquery>
        </cfif>        
        
        
		

		<!--- 6.2.3 Distribuye el impuesto de ventas usado para el entero fiscal,
					usando el CIF + los otros impuestos de la factura que no sean el
					impuesto de ventas de servicios --->
		<cfif ListFind('sqlserver', LvarDBtype)>
        	<cfquery name="rsimpuestositemVentas" datasource="#session.dsn#">
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, a.DPDmontocifreal
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
            </cfquery>
            
            <cfloop query="rsimpuestositemVentas">
            	<cfset LvarDPDlinea2 = 		rsimpuestositemVentas.DPDlinea>
	            <cfset LvarEcodigo2 = 		rsimpuestositemVentas.Ecodigo>
                <cfset LvarIcodigo2 = 		rsimpuestositemVentas.Icodigo>
                <cfset LvarEPDid2 = 			rsimpuestositemVentas.EPDid>
                <cfset LvarDDlinea2 = 		rsimpuestositemVentas.DDlinea>
                <cfset LvarDPDmontocifreal2 = rsimpuestositemVentas.DPDmontocifreal>
                <cfset LvarIporcentaje2 = 	rsimpuestositemVentas.Iporcentaje>
            
            	<cfquery name="rsCMImontoteorico" datasource="#session.DSN#">
                	select coalesce(sum(cmii.CMImontoteorico), 0.00) * #LvarIporcentaje2# / 100.00 as CMImontoteorico
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2#
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
                </cfquery>
                
                
                
				<cfquery name="rsCMIPmonto" datasource="#session.DSN#">
                	select x.CMIPmonto 
                    from CMImpuestosPoliza x 
                    where x.Icodigo = '#LvarIcodigo2#' 
                        and x.Ecodigo = #LvarEcodigo2#
                        and x.EPDid = #LvarEPDid2#
                        and x.DDlinea = #LvarDDlinea2#
                </cfquery>
                                
				<cfquery name="rsCMIPmonto1" datasource="#session.DSN#">
                	SELECT sum(x.DPDmontocifreal) as sumDPDmontocifreal 
                    FROM DPolizaDesalmacenaje x
                        INNER JOIN Impuestos z
                            LEFT OUTER JOIN DImpuestos w
                            ON w.Icodigo = z.Icodigo
                            AND w.Ecodigo = z.Ecodigo
                        ON z.Icodigo = x.Icodigo
                        AND z.Ecodigo = x.Ecodigo
                    WHERE x.EPDid = #LvarEPDid2#
                        AND x.Ecodigo = #LvarEcodigo2#
                        AND coalesce(w.DIcodigo,z.Icodigo) = '#LvarIcodigo2#'
                </cfquery>

                <cfquery name="rsCMImontoteorico2" datasource="#session.DSN#">
                	select coalesce(sum(cmii.CMImontoteorico), 0.00) as CMImontoteorico2
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#						
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2# 
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
                </cfquery>
                
                <cfquery name="rsCMImontoteorico3" datasource="#session.DSN#">
                    select  (#LvarDPDmontocifreal2# + coalesce(sum(cmii.CMImontoteorico), 0.00)) * #LvarIporcentaje2# / 100.00 as CMImontoteorico3
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#						
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2#
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
				</cfquery>
                
                
                
                <!--- <cfoutput>
				<br />rsimpuestositemVentas.DPDmontocifreal: #rsimpuestositemVentas.DPDmontocifreal#<br />
				rsCMImontoteorico.CMImontoteorico: #rsCMImontoteorico.CMImontoteorico#<br />
				</cfoutput> --->
                 <cfset LvarCMImontoteorico =  rsimpuestositemVentas.DPDmontocifreal + rsCMImontoteorico.CMImontoteorico>
                 
                 <cfset LvarCalc2 = rsCMIPmonto.CMIPmonto / ((rsCMIPmonto1.sumDPDmontocifreal + rsCMImontoteorico2.CMImontoteorico2 ) * LvarIporcentaje2/ 100.00) * rsCMImontoteorico3.CMImontoteorico3>
                
                 <cfquery datasource="#session.dsn#">
	                INSERT INTO CMImpuestosItem
                    	(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                    values(
	                    #LvarDPDlinea2#,
                        #LvarEcodigo2#,
                        '#LvarIcodigo2#',
                        #LvarEPDid2#,
                        #LvarDDlinea2#,
                        #LvarIporcentaje2#,
                        #LvarCMImontoteorico#,
						
                        #LvarCalc2#
                    	)
                </cfquery><!---

                
                <cfoutput>
					    <br />2*
						DPDlinea #LvarDPDlinea2#,<br />
                        Ecodigo #LvarEcodigo2#,<br />
                        Icodigo '#LvarIcodigo2#',<br />
                        EPDid #LvarEPDid2#,<br />
                        DDlinea #LvarDDlinea2#,<br />
                        Iporcentaje #LvarIporcentaje2#,<br />
                        LvarCMImontoteorico #LvarCMImontoteorico# debe dar 290416.62,<br />
                        LvarCalc #LvarCalc2# debe dar 347726.34<br /> 2*
				</cfoutput>
                 --->
            </cfloop>
			<!--- <cfabort> --->
        <cfelse>
            <cfquery name="insertimpuestositemVentas" datasource="#session.dsn#">
                INSERT INTO CMImpuestosItem
                    (DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
                    (a.DPDmontocifreal + 
                        (
                        select coalesce(sum(cmii.CMImontoteorico), 0.00)
                        from CMImpuestosItem cmii
                        where cmii.Ecodigo = a.Ecodigo
                            and cmii.EPDid = a.EPDid
                            and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                            and cmii.DPDlinea = a.DPDlinea
                            and cmii.DDlinea in
                                (select cmip2.DDlinea
                                 from CMImpuestosPoliza cmip2
                                    inner join DDocumentosI ddi1
                                        on ddi1.DDlinea = cmip2.DDlinea
                                 where ddi1.EDIid = (select ddi2.EDIid
                                                     from DDocumentosI ddi2
                                                     where ddi2.DDlinea = cmip.DDlinea)
                                )
                        )
                    ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
                    
                    (
                        select x.CMIPmonto 
                        from CMImpuestosPoliza x 
                        where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo) 
                            and x.Ecodigo = a.Ecodigo
                            and x.EPDid = a.EPDid
                            and x.DDlinea = cmip.DDlinea
                    )<!---  as montoimp --->
                    /
                    (
                        SELECT sum((x.DPDmontocifreal +	
                                    (
                                    select coalesce(sum(cmii.CMImontoteorico), 0.00)
                                    from CMImpuestosItem cmii
                                    where cmii.Ecodigo = x.Ecodigo						
                                        and cmii.EPDid = x.EPDid
                                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                                        and cmii.DPDlinea = x.DPDlinea
                                        and cmii.DDlinea in
                                            (select cmip2.DDlinea
                                             from CMImpuestosPoliza cmip2
                                                inner join DDocumentosI ddi1
                                                    on ddi1.DDlinea = cmip2.DDlinea
                                             where ddi1.EDIid = (select ddi2.EDIid
                                                                 from DDocumentosI ddi2
                                                                 where ddi2.DDlinea = cmip.DDlinea)
                                            )
                                    )				
                        ) * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
                        FROM DPolizaDesalmacenaje x
                            INNER JOIN Impuestos z
                                LEFT OUTER JOIN DImpuestos w
                                ON w.Icodigo = z.Icodigo
                                AND w.Ecodigo = z.Ecodigo
                            ON z.Icodigo = x.Icodigo
                            AND z.Ecodigo = x.Ecodigo
                        WHERE x.EPDid = a.EPDid
                            AND x.Ecodigo = a.Ecodigo
                            AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                    )<!---  as sumaporcentajes --->
                    *
                    (
                        (a.DPDmontocifreal +
                            (
                            select coalesce(sum(cmii.CMImontoteorico), 0.00)
                            from CMImpuestosItem cmii
                            where cmii.Ecodigo = a.Ecodigo						
                                and cmii.EPDid = a.EPDid
                                and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                                and cmii.DPDlinea = a.DPDlinea
                                and cmii.DDlinea in
                                    (select cmip2.DDlinea
                                     from CMImpuestosPoliza cmip2
                                        inner join DDocumentosI ddi1
                                            on ddi1.DDlinea = cmip2.DDlinea
                                     where ddi1.EDIid = (select ddi2.EDIid
                                                         from DDocumentosI ddi2
                                                         where ddi2.DDlinea = cmip.DDlinea)
                                    )
                            )
                        ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
                    )<!---  as impuesto --->
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
            </cfquery>
        
        </cfif>

		<!--- 6.3 Ajusta la nueva distribución --->
		
		<!--- 6.3.1 Obtiene la distribución hecha con los montos transformados a los tipos de cambio respectivos --->
		<cfquery name="impuestosItemPorAjustar" datasource="#session.dsn#">
			select ii.DPDlinea, ii.Icodigo, ii.DDlinea, round(ii.CMImonto / edi.EDItc, 2) as CMImontoTransito, edi.EDItc
			from CMImpuestosItem ii
				inner join DDocumentosI ddi
					on ddi.DDlinea = ii.DDlinea
				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
			where ii.Ecodigo = #session.Ecodigo#
				and ii.EPDid = #form.EPDid#
			order by ii.DDlinea, ii.CMImonto desc
		</cfquery>
		
		<cfset IcodigoActual = "">				<!--- Variables que indican la factura de impuesto actual que se está ajustando --->
		<cfset DDlineaActual = "">
		<cfset LineaImpuestoAjustada = false>	<!--- Variable que indica si la factura de impuesto actual ya fue ajustada --->
		<cfset CalcularMontosAjuste = true>		<!--- Variable que indica si hay que calcular el total de montos real y esperado --->
		
		<!--- 6.3.2 Realiza el ajuste --->
		<cfloop query="impuestosItemPorAjustar">
		
			<cfif DDlineaActual neq impuestosItemPorAjustar.DDlinea or IcodigoActual neq impuestosItemPorAjustar.Icodigo>
				<cfset IcodigoActual = impuestosItemPorAjustar.Icodigo>
				<cfset DDlineaActual = impuestosItemPorAjustar.DDlinea>
				<cfset LineaImpuestoAjustada = false>
				<cfset CalcularMontosAjuste = true>
			</cfif>
			
			<cfif not LineaImpuestoAjustada>
			
				<cfif CalcularMontosAjuste>
                   	<cfset _LvarTotalImpuestoEsperado = 0.00>
                   	<cfset _LvarTotalImpuestoReal = 0.00>
                    
					<cfquery name="rsTotalImpuestosEsperado" datasource="#session.dsn#">
						select ddi.DDItotallinea as totalImpuestosEsperado
						from CMImpuestosPoliza ip
							inner join DDocumentosI ddi
								on ddi.DDlinea = ip.DDlinea
						where ip.EPDid = #Form.EPDid#
							and ip.Ecodigo = #Session.Ecodigo#
							and ip.DDlinea = #DDlineaActual#
							and ip.Icodigo = '#trim(IcodigoActual)#'
					</cfquery>
                    <cfif rsTotalImpuestosEsperado.recordcount GT 0>
                    	<cfset _LvarTotalImpuestoEsperado = rsTotalImpuestosEsperado.totalImpuestosEsperado>
                    </cfif>
					
					<cfquery name="rsTotalImpuestosReal" dbtype="query">
						select sum(CMImontoTransito) as totalImpuestosReal
						from impuestosItemPorAjustar
						where DDlinea = #DDlineaActual#
							and Icodigo = '#trim(IcodigoActual)#'
					</cfquery>
                    <cfif rsTotalImpuestosReal.recordcount GT 0>
                    	<cfset _LvarTotalImpuestoReal = rsTotalImpuestosReal.totalImpuestosReal>
                    </cfif>

					<cfset TotalAjuste = _LvarTotalImpuestoEsperado - _LvarTotalImpuestoReal>
				</cfif>

				<cfif TotalAjuste gt 0>
					<cfset nuevoMonto = impuestosItemPorAjustar.CMImontoTransito + TotalAjuste>
					<cfset QuerySetCell(impuestosItemPorAjustar, "CMImontoTransito", nuevoMonto, impuestosItemPorAjustar.CurrentRow)>
					<cfset LineaImpuestoAjustada = true>
					<cfset TotalAjuste = 0>
					<cfset CalcularMontosAjuste = true>

				<cfelseif TotalAjuste lt 0>
					<cfif -1 * TotalAjuste gt impuestosItemPorAjustar.CMImontoTransito>
						<cfset nuevoMonto = 0.00>
						<cfset TotalAjuste = TotalAjuste + impuestosItemPorAjustar.CMImontoTransito>
						<cfset CalcularMontosAjuste = false>
					<cfelse>
						<cfset nuevoMonto = impuestosItemPorAjustar.CMImontoTransito + TotalAjuste>
						<cfset LineaImpuestoAjustada = true>
						<cfset TotalAjuste = 0>
						<cfset CalcularMontosAjuste = true>
					</cfif>
					<cfset QuerySetCell(impuestosItemPorAjustar, "CMImontoTransito", nuevoMonto, impuestosItemPorAjustar.CurrentRow)>
				<cfelse>
					<cfset LineaImpuestoAjustada = true>
					<cfset CalcularMontosAjuste = true>				
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- 6.3.3 Actualiza los montos distribuidos para que quedan ajustados tanto al monto
					original, como el que va a quedar en detalle tránsito --->
		<cfloop query="impuestosItemPorAjustar">
			<cfquery name="impuestosItemUpd" datasource="#session.dsn#">
				update CMImpuestosItem
				set CMImonto = <cfqueryparam cfsqltype="cf_sql_money" value="#impuestosItemPorAjustar.CMImontoTransito * impuestosItemPorAjustar.EDItc#">
				where DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#impuestosItemPorAjustar.DPDlinea#">
					and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#impuestosItemPorAjustar.DDlinea#">
					and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(impuestosItemPorAjustar.Icodigo)#">
					and EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfloop>

		<!--- 6.4 Actualiza el valor real de los impuestos no recuperables de la línea --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET 
			DPDimpuestosreal = (
					select coalesce(sum(CMImonto),0.00)
					from CMImpuestosItem a
					where a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
						and a.Icodigo in (select coalesce(dimp.DIcodigo, imp.Icodigo)
										 from Impuestos imp
											 left outer join DImpuestos dimp
												 on dimp.Icodigo = imp.Icodigo
												 and dimp.Ecodigo = imp.Ecodigo
										 where imp.Icreditofiscal = 0
										 	and dimp.DIcreditofiscal = 0
											 and imp.Icodigo = DPolizaDesalmacenaje.Icodigo
											 and imp.Ecodigo = DPolizaDesalmacenaje.Ecodigo
										)
			)
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 6.5 Actualiza el valor real de los impuestos recuperables de la línea --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET 
			DPDimpuestosrecup = (
					select coalesce(sum(CMImonto),0.00)
					from CMImpuestosItem a
					where a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
						and a.Icodigo in (select coalesce(dimp.DIcodigo, imp.Icodigo)
										 from Impuestos imp
											 left outer join DImpuestos dimp
												 on dimp.Icodigo = imp.Icodigo
												 and dimp.Ecodigo = imp.Ecodigo
										 where (imp.Icreditofiscal = 1
										 	or dimp.DIcreditofiscal = 1)
											 and imp.Icodigo = DPolizaDesalmacenaje.Icodigo
											 and imp.Ecodigo = DPolizaDesalmacenaje.Ecodigo
										)
			)
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 7. Actualiza el valor declarado de la línea como cif real + aduanales real (gastos) + impuestos real --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET DPDvalordeclarado = DPDmontocifreal + DPDfletesreal + DPDsegurosreal + DPDaduanalesreal + DPDimpuestosreal
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
	</cftransaction>
	
	<cflocation url="polizaDesalmacenaje-Rep.cfm?EPDid=#form.EPDid#">
    
<!---Comentario Gustavo F: Falta al hijo las facturas de fletes, gastos y/o seguros que se tomen como parte del calculo usando los datos que estan calculados en el Detalle de la póliza.--->   

<!---►►PROCESO DE CALCULAR PARCIAL DE LAS POLIZAS HIJAS EN DESALMACENAJES PARCIALES◄◄--->
<cfelseif isdefined("form.CalcularParcial")>
	
    <!---►►PASO 1 Validaciones sobre las lineas de la poliza:◄◄--->
    <cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="ValidaDPolizaDesalmacenaje">
    	<cfinvokeargument name="EPDid" value="#Form.EPDid#">
    </cfinvoke>
    
    <!---►►PASO 2: Obtiene la distribución tal y como se insertaría a detalle tránsito para que en el cierre no sea necesario realizar otro ajuste.
		   Se redondea a 2 para no perder decimales al insertar las facturas a la póliza ya que se insertan en la moneda local◄◄--->
        <cfsavecontent variable="DIVIDENDO_SQL">
        	(select sum (a.DPDmontofobreal + coalesce(a.DPDfletesprorrat, 0.00) + coalesce(a.DPDsegurosprorrat, 0.00))
              from DPolizaDesalmacenaje a
             where a.EPDid = p.EPDid )
        </cfsavecontent>
		<cfquery name="facturasItemPorInsertar" datasource="#session.dsn#">
			select f.FPid, p.DPDlinea, edi.EDItc,
				CASE WHEN  #DIVIDENDO_SQL# = 0 THEN 0.00
                  ELSE round((f.FMmonto * (p.DPDmontofobreal + coalesce(p.DPDfletesprorrat, 0.00) + coalesce(p.DPDsegurosprorrat, 0.00)) / #DIVIDENDO_SQL#) / edi.EDItc,2) 
                END as FGImontoTransito
			from DPolizaDesalmacenaje p
				inner join FacturasPoliza f
					on f.EPDid = p.EPDid
				inner join DDocumentosI ddi
					on ddi.DDlinea = f.DDlinea
				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
			where p.EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by f.FPid, (p.DPDmontofobreal + coalesce(p.DPDfletesprorrat, 0.00) + coalesce(p.DPDsegurosprorrat, 0.00)) desc
		</cfquery>
		
		<cfset FPidActual           = "">	 <!--- Variable que indica la factura actual que se está ajustando --->
		<cfset FPidAjustada         = false> <!--- Variable que indica si la factura actual ya fue ajustada --->
		<cfset CalcularMontosAjuste = true>	 <!--- Variable que indica si hay que calcular el total de montos real y esperado --->
	
 <cftransaction>
	
	<!---►►PASO 3: Elimina las distribuciones anteriores◄◄--->
    <cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="DeleteFacturasGastoItem">
    	<cfinvokeargument name="EPDid" value="#Form.EPDid#">
    </cfinvoke>
		
	<!---►►PASO 4: Calcula los montos del Ajuste◄◄--->
    <cfloop query="facturasItemPorInsertar">
		
		<cfif FPidActual neq facturasItemPorInsertar.FPid>
            <cfset FPidActual			= facturasItemPorInsertar.FPid>
            <cfset FPidAjustada  		= false>
            <cfset CalcularMontosAjuste = true>
        </cfif>
			
		<cfif not FPidAjustada>
			<cfif CalcularMontosAjuste>
                <cfquery name="rsTotalGastosEsperado" datasource="#session.dsn#">
                    select ddi.DDItotallinea as totalGastosEsperado
                    from FacturasPoliza fp
                        inner join DDocumentosI ddi
                            on ddi.DDlinea = fp.DDlinea
                    where fp.FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPidActual#">
                </cfquery>
                
                <cfquery name="rsTotalGastosReal" dbtype="query">
                    select sum(FGImontoTransito) as totalGastosReal
                    from facturasItemPorInsertar
                    where FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPidActual#">
                </cfquery>
                
                <cfset TotalAjuste = rsTotalGastosEsperado.totalGastosEsperado - rsTotalGastosReal.totalGastosReal>
            </cfif>

			<cfif TotalAjuste gt 0>
                <cfset nuevoMonto = facturasItemPorInsertar.FGImontoTransito + TotalAjuste>
                <cfset QuerySetCell(facturasItemPorInsertar, "FGImontoTransito", nuevoMonto, facturasItemPorInsertar.CurrentRow)>
                <cfset FPidAjustada = true>
                <cfset TotalAjuste = 0>
                <cfset CalcularMontosAjuste = true>

            <cfelseif TotalAjuste lt 0>
                <cfif -1 * TotalAjuste gt facturasItemPorInsertar.FGImontoTransito>
                    <cfset nuevoMonto = 0.00>
                    <cfset TotalAjuste = TotalAjuste + facturasItemPorInsertar.FGImontoTransito>
                    <cfset CalcularMontosAjuste = false>
                <cfelse>
                    <cfset nuevoMonto = facturasItemPorInsertar.FGImontoTransito + TotalAjuste>
                    <cfset FPidAjustada = true>
                    <cfset TotalAjuste = 0>
                    <cfset CalcularMontosAjuste = true>
                </cfif>
                <cfset QuerySetCell(facturasItemPorInsertar, "FGImontoTransito", nuevoMonto, facturasItemPorInsertar.CurrentRow)>
            <cfelse>
                <cfset FPidAjustada = true>
                <cfset CalcularMontosAjuste = true>					
            </cfif>
		</cfif>
	</cfloop>
		
	<!---►►PASO 5: Inserta los montos ajustados a las facturas de la póliza(FacturasGastoItem)◄◄--->
    <cfloop query="facturasItemPorInsertar">
        <cfquery name="insertfacturasitem" datasource="#session.dsn#">
            insert into FacturasGastoItem
                (FPid, DPDlinea, FGImonto)
            values
                (<cfqueryparam cfsqltype="cf_sql_numeric" value="#facturasItemPorInsertar.FPid#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#facturasItemPorInsertar.DPDlinea#">,
                 <cfqueryparam cfsqltype="cf_sql_money" value="#facturasItemPorInsertar.FGImontoTransito * facturasItemPorInsertar.EDItc#">
                )
        </cfquery>
    </cfloop>
        
	<!---Comentario Gustavo F:Cuando es hija:  debe tomar en cuenta lo calculado en DPoliza y sumarle los montos distribuidos de los documentos de flete, gasto o seguro --->
		
	<!---►►PASO 6: Actualiza los gastos reales para cada ítem de la póliza◄◄--->
    <cfquery name="updatedet" datasource="#session.dsn#">
        UPDATE DPolizaDesalmacenaje
        SET
        	<!---►►Fletes◄◄--->
            DPDfletesreal = Coalesce(DPolizaDesalmacenaje.DPDfletesrealRCPar,0) + (
                    select coalesce(sum(FGImonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00)
                    from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
                    where a.FPid = b.FPid
                        and b.FPafecta = 1
                        and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
                        and ddi.DDlinea = b.DDlinea
                        and edi.EDIid = ddi.EDIid
            ),
            <!---►►Seguros◄◄--->
            DPDsegurosreal = Coalesce(DPolizaDesalmacenaje.DPDsegurosrealRCPar,0) + (
                    select coalesce(sum(FGImonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00)
                    from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
                    where a.FPid = b.FPid
                        and b.FPafecta = 2
                        and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
                        and ddi.DDlinea = b.DDlinea
                        and edi.EDIid = ddi.EDIid
            ),
            <!---►►Gastos◄◄--->
            DPDaduanalesreal = Coalesce(DPolizaDesalmacenaje.DPDaduanalesrealRCPar,0) + (
                    select coalesce(sum(FGImonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00)
                    from FacturasGastoItem a, FacturasPoliza b, DDocumentosI ddi, EDocumentosI edi
                    where a.FPid = b.FPid
                        and b.FPafecta = 4
                        and a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
                        and ddi.DDlinea = b.DDlinea
                        and edi.EDIid = ddi.EDIid
            )
        WHERE EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
          AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
        
        
		<!--- 4. Cálculo del seguro propio --->

		<!--- 4.1 Obtiene la lista de seguros de la empresa --->
		<cfquery name="rsFormulasSeguro" datasource="#session.dsn#">
			SELECT CMSid, Costos, Fletes, Seguros, ESporcadic, ESporcmult
			FROM CMSeguros
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 4.2 Obtiene los ítems de la póliza --->
		<cfquery name="rsLineasPoliza" datasource="#session.dsn#">
			SELECT DPDlinea, CMSid, DPDmontofobreal, DPDfletesreal,
				   DPDsegurosreal, coalesce(DPDfletesprorrat, 0.00) as DPDfletesprorrat,
				   coalesce(DPDsegurosprorrat,0.00) as DPDsegurosprorrat,
				   DOlinea, DPDcantidad
			FROM DPolizaDesalmacenaje
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 4.3 Calcula el seguro propio para cada ítem de la póliza --->
		<cfloop query="rsLineasPoliza">
		
			<!--- 4.3.1 Valida condiciones mínimas para realizar el cálculo --->
			<!--- Para que cumpla con las condiciones mínimas, el seguro debe incluir:
				(Costos o Fletes o Seguros) y tener el porcentaje adicional y multiplicativo mayores a 0 --->
			<cfset reuneCondMin = True>
			<cfif len(rsLineasPoliza.CMSid) eq 0>
				<cfset reuneCondMin = False>
			<cfelse>
				<!--- Cosulta la formula de la línea --->
				<cfset rsFormula = getFormulaSeguro(rsLineasPoliza.CMSid)>
				<cfif rsFormula.RecordCount eq 0>
					<cfset reuneCondMin = False>
				<cfelseif ( (rsFormula.Costos eq 0) and (rsFormula.Fletes eq 0) and (rsFormula.Seguros eq 0) ) or (rsFormula.ESporcadic eq 0) or (rsFormula.ESporcmult eq 0)>
					<cfset reuneCondMin = False>
				</cfif>
			</cfif>
			
			<cfif reuneCondMin and isdefined('form.ETidtracking_move') and LEN(TRIM(form.ETidtracking_move))>
				<!--- 4.3.2 Obtiene el último tipo de cambio insertado para la moneda,
							así como los montos de costos, fletes y seguros del exterior
							en la moneda original --->
				<cfquery name="rsTipoCambioSeguro" datasource="#session.dsn#">
					select 
						eti.ETtipocambiofac, 
						coalesce(
							(
								select min(tc.TCventa)
								from Htipocambio tc
								where tc.Mcodigo = eti.Mcodigo
								and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EPDfecha)#">
								and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EPDfecha)#">
							)
							, eti.ETtipocambiofac,1) as TCventa,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostodirectofacorig as ETcostodirectofacorig,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostoindfletesfacorig as ETcostoindfletesfacorig,
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineasPoliza.DPDcantidad#"> / eti.ETIcantidad) * eti.ETcostoindsegfacorig as ETcostoindsegfacorig
					from ETrackingItems eti
					where eti.DOlinea      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsLineasPoliza.DOlinea#">
					  and eti.Ecodigo      = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and eti.ETidtracking = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move#">
				</cfquery><cfdump var="#rsTipoCambioSeguro#" label="rsTipoCambioSeguro lin 2076">

				<!--- 4.3.3 Inicializa el seguro propio en 0 --->
				<cfset LSeguroPropio = 0.00>
				<!--- 4.3.4 Si la fórmula indica costos, suma el monto fob real --->
				<cfif rsFormula.Costos>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDmontofobreal--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostodirectofacorig>
				</cfif>
				<!--- 4.3.5 Si la fórmula indica fletes, suma el monto de fletes real --->
				<cfif rsFormula.Fletes>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDfletesprorrat--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostoindfletesfacorig>
				</cfif>
				<!--- 4.3.6 Si la fórmula indica seguros, suma el monto de seguros real --->
				<cfif rsFormula.Seguros>
					<!---cfset LSeguroPropio = LSeguroPropio + DPDsegurosprorrat--->
					<cfset LSeguroPropio = LSeguroPropio + rsTipoCambioSeguro.ETcostoindsegfacorig>
				</cfif>
				<!--- 4.3.7 Suma el porcentaje adicional de la fórmula --->
				<cfset LSeguroPropio = LSeguroPropio + (LSeguroPropio * rsFormula.ESporcadic / 100)>
				<!--- 4.3.8 Saca el porcentaje multiplicativo de la fórmula del total --->
				<cfset LSeguroPropio = (LSeguroPropio * rsFormula.ESporcmult / 100)>
				<!--- 4.3.9 Convierte el total al último tipo de cambio en el histórico --->
				<!---cfset LSeguroPropio = (LSeguroPropio / rsTipoCambioSeguro.ETtipocambiofac) * rsTipoCambioSeguro.TCventa--->
				<cfset LSeguroPropio = LSeguroPropio * rsTipoCambioSeguro.TCventa>
			<cfelse>
				<cfset LSeguroPropio = 0>
			</cfif>
			
			<!--- 4.3.10 Actualiza el seguro propio de la línea de la póliza --->
			<cfquery datasource="#session.dsn#">
				UPDATE DPolizaDesalmacenaje
				 SET	DPseguropropio = <cfqueryparam cfsqltype="cf_sql_money" value="#LSeguroPropio#">
				WHERE DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasPoliza.DPDlinea#">
				  AND EPDid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				  AND Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		</cfloop>
		
		<!--- 5. Actualiza el monto cif real de la línea como el fob + fletes + seguros + seguro propio --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET DPDmontocifreal = DPDmontofobreal + coalesce(DPDfletesprorrat, 0.00) + coalesce(DPDsegurosprorrat, 0.00) + DPseguropropio
			WHERE EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!---►►6. Distribución de los impuestos◄◄--->
		
		<!--- 6.1 Elimina la distribución anterior de impuestos --->
		<cfquery datasource="#session.dsn#">
			DELETE from CMImpuestosItem
			 WHERE EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- 6.2 Realiza la nueva distribución de impuestos --->
			
		<!--- 6.2.1 Distribuye los impuestos distintos al impuesto de ventas usado para el entero fiscal --->
		<cfquery name="insertimpuestositem" datasource="#session.dsn#">
			INSERT INTO CMImpuestosItem
				(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
			SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
				coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
				a.DPDmontocifreal * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
				(
					select x.CMIPmonto
					from CMImpuestosPoliza x
					where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo)
						and x.Ecodigo = a.Ecodigo
						and x.EPDid = a.EPDid
						and x.DDlinea = cmip.DDlinea
				)<!---  as montoimp --->
				/
				(
					SELECT sum(x.DPDmontocifreal * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
					FROM DPolizaDesalmacenaje x
						INNER JOIN Impuestos z
							LEFT OUTER JOIN DImpuestos w
							ON w.Icodigo = z.Icodigo
							AND w.Ecodigo = z.Ecodigo
						ON z.Icodigo = x.Icodigo
						AND z.Ecodigo = x.Ecodigo
					WHERE x.EPDid = a.EPDid
						AND x.Ecodigo = a.Ecodigo
						AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                        and w.DIcodigo <> 'VTS'
                        and w.DIcodigo <> 'IVS'
						and z.Icodigo <> 'VTS'
						and z.Icodigo <> 'IVS'
				)<!---  as sumaporcentajes --->
				*
				(
					a.DPDmontocifreal * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
				)<!---  as impuesto --->
			FROM DPolizaDesalmacenaje a
				INNER JOIN Impuestos c
					LEFT OUTER JOIN DImpuestos d
					ON d.Icodigo = c.Icodigo
					AND d.Ecodigo = c.Ecodigo
					and d.DIcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
					and d.DIcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
				ON c.Icodigo = a.Icodigo
				AND c.Ecodigo = a.Ecodigo
				and c.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
				and c.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">

				inner join CMImpuestosPoliza cmip
					on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
					and cmip.Ecodigo = a.Ecodigo
					and cmip.EPDid = a.EPDid

			WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 6.2.2 Distribuye el impuesto de ventas de servicios,usando el CIF + los otros gastos en la factura --->
        <cfset LvarDBtype		= Application.dsinfo[session.dsn].type>
        
		<cfif ListFind('sqlserver', LvarDBtype)>
            <cfquery name="rsimpuestositemServicios" datasource="#session.dsn#">
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje 
                    
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
            </cfquery>
            
            <cfloop query="rsimpuestositemServicios">
                <cfset LvarDPDlinea1 	=  rsimpuestositemServicios.DPDlinea>
                <cfset LvarEcodigo1 	=  rsimpuestositemServicios.Ecodigo>
                <cfset LvarIcodigo1 	=  rsimpuestositemServicios.Icodigo>
                <cfset LvarEPDid1 		=  rsimpuestositemServicios.EPDid>
                <cfset LvarDDlinea1     =  rsimpuestositemServicios.DDlinea>
                <cfset LvarIporcentaje1 =  rsimpuestositemServicios.Iporcentaje>
                
                <cfquery name="rsMontoteorico" datasource="#session.DSN#">
                    select coalesce(sum(fgi.FGImonto), 0.00) * #LvarIporcentaje1# / 100.00 as Montoteorico
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                </cfquery>
                
                <cfquery name="rsMonto" datasource="#session.DSN#">
                    Select x.CMIPmonto 
                    from CMImpuestosPoliza x 
                    where x.Icodigo = '#LvarIcodigo1#'
                        and x.Ecodigo = #LvarEcodigo1#
                        and x.EPDid = #LvarEPDid1#
                        and x.DDlinea = #LvarDDlinea1#
                </cfquery>

                <cfquery name="rsMonto2" datasource="#session.DSN#">
                    select sum(coalesce(fgi.FGImonto, 0.00)) * (#LvarIporcentaje1# / 100.00) as Monto2
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                            
				</cfquery>
                
				<cfquery name="rsMonto3" datasource="#session.DSN#">
                    select sum(coalesce(fgi.FGImonto, 0.00)) * (#LvarIporcentaje1#/ 100.00) as Monto3
                    from FacturasGastoItem fgi
                        inner join FacturasPoliza fp
                            on fp.FPid = fgi.FPid
                    where fgi.DPDlinea = #LvarDPDlinea1#
                        and fp.DDlinea in
                            (select fp2.DDlinea
                             from FacturasPoliza fp2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = fp2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea1#)
                            )
                </cfquery>
                
                <cfset LvarCalc1 = rsMonto.CMIPmonto /  rsMonto2.Monto2 * rsMonto3.Monto3>
                
                <cfquery datasource="#session.dsn#">
                	INSERT INTO CMImpuestosItem
                    	(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                    values(
                    	#LvarDPDlinea1#,
                        #LvarEcodigo1#,
                        '#LvarIcodigo1#',
                        #LvarEPDid1#,
                        #LvarDDlinea1#,
                        #LvarIporcentaje1#,
                        #rsMontoteorico.Montoteorico#,
                        #LvarCalc1#
                        )
                        
                </cfquery> 
            
            </cfloop>
        <cfelse>
        	<cfquery name="insertimpuestositemServicios" datasource="#session.dsn#">
                INSERT INTO CMImpuestosItem
                    (DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
                 
                    ( 
                        (
                        select coalesce(sum(fgi.FGImonto), 0.00)
                        from FacturasGastoItem fgi
                            inner join FacturasPoliza fp
                                on fp.FPid = fgi.FPid
                        where fgi.DPDlinea = a.DPDlinea
                            and fp.DDlinea in
                                (select fp2.DDlinea
                                 from FacturasPoliza fp2
                                    inner join DDocumentosI ddi1
                                        on ddi1.DDlinea = fp2.DDlinea
                                 where ddi1.EDIid = (select ddi2.EDIid
                                                     from DDocumentosI ddi2
                                                     where ddi2.DDlinea = cmip.DDlinea)
                                )
                        )
                    ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
                    (
                        select x.CMIPmonto 
                        from CMImpuestosPoliza x 
                        where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo) 
                            and x.Ecodigo = a.Ecodigo
                            and x.EPDid = a.EPDid
                            and x.DDlinea = cmip.DDlinea
                    )<!---  as montoimp --->
                    /
                    (
                        SELECT sum((	
                                    (
                                    select coalesce(sum(fgi.FGImonto), 0.00)
                                    from FacturasGastoItem fgi
                                        inner join FacturasPoliza fp
                                            on fp.FPid = fgi.FPid
                                    where fgi.DPDlinea = x.DPDlinea
                                        and fp.DDlinea in
                                            (select fp2.DDlinea
                                             from FacturasPoliza fp2
                                                inner join DDocumentosI ddi1
                                                    on ddi1.DDlinea = fp2.DDlinea
                                             where ddi1.EDIid = (select ddi2.EDIid
                                                                 from DDocumentosI ddi2
                                                                 where ddi2.DDlinea = cmip.DDlinea)
                                            )
                                    )				
                        ) * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
                        FROM DPolizaDesalmacenaje x
                            INNER JOIN Impuestos z
                                LEFT OUTER JOIN DImpuestos w
                                ON w.Icodigo = z.Icodigo
                                AND w.Ecodigo = z.Ecodigo
                            ON z.Icodigo = x.Icodigo
                            AND z.Ecodigo = x.Ecodigo
                        WHERE x.EPDid = a.EPDid
                            AND x.Ecodigo = a.Ecodigo
                            AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                    )<!---  as sumaporcentajes --->
                    *
                    (
                        (
                            (
                            select coalesce(sum(fgi.FGImonto), 0.00)
                            from FacturasGastoItem fgi
                                inner join FacturasPoliza fp
                                    on fp.FPid = fgi.FPid
                            where fgi.DPDlinea = a.DPDlinea
                                and fp.DDlinea in
                                    (select fp2.DDlinea
                                     from FacturasPoliza fp2
                                        inner join DDocumentosI ddi1
                                            on ddi1.DDlinea = fp2.DDlinea
                                     where ddi1.EDIid = (select ddi2.EDIid
                                                         from DDocumentosI ddi2
                                                         where ddi2.DDlinea = cmip.DDlinea)
                                    )
                            )
                        ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
                    )<!---  as impuesto --->
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
            </cfquery>
        </cfif>        
        
		<!--- 6.2.3 Distribuye el impuesto de ventas usado para el entero fiscal,
					usando el CIF + los otros impuestos de la factura que no sean el
					impuesto de ventas de servicios --->
		<cfif ListFind('sqlserver', LvarDBtype)>
        	<cfquery name="rsimpuestositemVentas" datasource="#session.dsn#">
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, a.DPDmontocifreal
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
            </cfquery>
            
            <cfloop query="rsimpuestositemVentas">
            	<cfset LvarDPDlinea2 = 		rsimpuestositemVentas.DPDlinea>
	            <cfset LvarEcodigo2 = 		rsimpuestositemVentas.Ecodigo>
                <cfset LvarIcodigo2 = 		rsimpuestositemVentas.Icodigo>
                <cfset LvarEPDid2 = 			rsimpuestositemVentas.EPDid>
                <cfset LvarDDlinea2 = 		rsimpuestositemVentas.DDlinea>
                <cfset LvarDPDmontocifreal2 = rsimpuestositemVentas.DPDmontocifreal>
                <cfset LvarIporcentaje2 = 	rsimpuestositemVentas.Iporcentaje>
            
            	<cfquery name="rsCMImontoteorico" datasource="#session.DSN#">
                	select coalesce(sum(cmii.CMImontoteorico), 0.00) * #LvarIporcentaje2# / 100.00 as CMImontoteorico
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2#
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
                </cfquery>
                
                
                
				<cfquery name="rsCMIPmonto" datasource="#session.DSN#">
                	select x.CMIPmonto 
                    from CMImpuestosPoliza x 
                    where x.Icodigo = '#LvarIcodigo2#' 
                        and x.Ecodigo = #LvarEcodigo2#
                        and x.EPDid = #LvarEPDid2#
                        and x.DDlinea = #LvarDDlinea2#
                </cfquery>
                                
				<cfquery name="rsCMIPmonto1" datasource="#session.DSN#">
                	SELECT sum(x.DPDmontocifreal) as sumDPDmontocifreal 
                    FROM DPolizaDesalmacenaje x
                        INNER JOIN Impuestos z
                            LEFT OUTER JOIN DImpuestos w
                            ON w.Icodigo = z.Icodigo
                            AND w.Ecodigo = z.Ecodigo
                        ON z.Icodigo = x.Icodigo
                        AND z.Ecodigo = x.Ecodigo
                    WHERE x.EPDid = #LvarEPDid2#
                        AND x.Ecodigo = #LvarEcodigo2#
                        AND coalesce(w.DIcodigo,z.Icodigo) = '#LvarIcodigo2#'
                </cfquery>

                <cfquery name="rsCMImontoteorico2" datasource="#session.DSN#">
                	select coalesce(sum(cmii.CMImontoteorico), 0.00) as CMImontoteorico2
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#						
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2# 
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
                </cfquery>
                
                <cfquery name="rsCMImontoteorico3" datasource="#session.DSN#">
                    select  (#LvarDPDmontocifreal2# + coalesce(sum(cmii.CMImontoteorico), 0.00)) * #LvarIporcentaje2# / 100.00 as CMImontoteorico3
                    from CMImpuestosItem cmii
                    where cmii.Ecodigo = #LvarEcodigo2#						
                        and cmii.EPDid = #LvarEPDid2#
                        and cmii.Icodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
                        and cmii.DPDlinea = #LvarDPDlinea2#
                        and cmii.DDlinea in
                            (select cmip2.DDlinea
                             from CMImpuestosPoliza cmip2
                                inner join DDocumentosI ddi1
                                    on ddi1.DDlinea = cmip2.DDlinea
                             where ddi1.EDIid = (select ddi2.EDIid
                                                 from DDocumentosI ddi2
                                                 where ddi2.DDlinea = #LvarDDlinea2#)
                            )
				</cfquery>
                
                 <cfset LvarCMImontoteorico =  rsimpuestositemVentas.DPDmontocifreal + rsCMImontoteorico.CMImontoteorico>
                 
                 <cfset LvarCalc2 = rsCMIPmonto.CMIPmonto / ((rsCMIPmonto1.sumDPDmontocifreal + rsCMImontoteorico2.CMImontoteorico2 ) * LvarIporcentaje2/ 100.00) * rsCMImontoteorico3.CMImontoteorico3>
                
                 <cfquery datasource="#session.dsn#">
	                INSERT INTO CMImpuestosItem
                    	(DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                    values(
	                    #LvarDPDlinea2#,
                        #LvarEcodigo2#,
                        '#LvarIcodigo2#',
                        #LvarEPDid2#,
                        #LvarDDlinea2#,
                        #LvarIporcentaje2#,
                        #LvarCMImontoteorico#,
						
                        #LvarCalc2#
                    	)
                </cfquery>
            </cfloop>
        <cfelse>
        	<cfsavecontent variable="DIVISOR_SQl">
            	 (SELECT sum((x.DPDmontocifreal +	
                                    (
                                    select coalesce(sum(cmii.CMImontoteorico), 0.00)
                                    from CMImpuestosItem cmii
                                    where cmii.Ecodigo = x.Ecodigo						
                                        and cmii.EPDid = x.EPDid
                                        and cmii.Icodigo <> <cf_jdbcquery_param cfsqltype="cf_sql_char" value="IVS">
                                        and cmii.DPDlinea = x.DPDlinea
                                        and cmii.DDlinea in
                                            (select cmip2.DDlinea
                                             from CMImpuestosPoliza cmip2
                                                inner join DDocumentosI ddi1
                                                    on ddi1.DDlinea = cmip2.DDlinea
                                             where ddi1.EDIid = (select ddi2.EDIid
                                                                 from DDocumentosI ddi2
                                                                 where ddi2.DDlinea = cmip.DDlinea)
                                            )
                                    )				
                        ) * coalesce(w.DIporcentaje,z.Iporcentaje) / 100.00)
                        FROM DPolizaDesalmacenaje x
                            INNER JOIN Impuestos z
                                LEFT OUTER JOIN DImpuestos w
                                ON w.Icodigo = z.Icodigo
                                AND w.Ecodigo = z.Ecodigo
                            ON z.Icodigo = x.Icodigo
                            AND z.Ecodigo = x.Ecodigo
                        WHERE x.EPDid = a.EPDid
                            AND x.Ecodigo = a.Ecodigo
                            AND coalesce(w.DIcodigo,z.Icodigo) = coalesce(d.DIcodigo,c.Icodigo)
                    )
                    *
                    (
                        (a.DPDmontocifreal +
                            (
                            select coalesce(sum(cmii.CMImontoteorico), 0.00)
                            from CMImpuestosItem cmii
                            where cmii.Ecodigo = a.Ecodigo						
                                and cmii.EPDid = a.EPDid
                                and cmii.Icodigo <> <cf_jdbcquery_param cfsqltype="cf_sql_char" value="IVS">
                                and cmii.DPDlinea = a.DPDlinea
                                and cmii.DDlinea in
                                    (select cmip2.DDlinea
                                     from CMImpuestosPoliza cmip2
                                        inner join DDocumentosI ddi1
                                            on ddi1.DDlinea = cmip2.DDlinea
                                     where ddi1.EDIid = (select ddi2.EDIid
                                                         from DDocumentosI ddi2
                                                         where ddi2.DDlinea = cmip.DDlinea)
                                    )
                            )
                        ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00
                    )
            </cfsavecontent>
            <cfquery name="insertimpuestositemVentas" datasource="#session.dsn#">
                INSERT INTO CMImpuestosItem
                    (DPDlinea, Ecodigo, Icodigo, EPDid, DDlinea, CMIporcimpteo, CMImontoteorico, CMImonto)
                SELECT a.DPDlinea, a.Ecodigo, coalesce(d.DIcodigo,c.Icodigo) as Icodigo, a.EPDid, cmip.DDlinea,
                    coalesce(d.DIporcentaje,c.Iporcentaje) as Iporcentaje, 
                    (a.DPDmontocifreal + 
                        (
                        select coalesce(sum(cmii.CMImontoteorico), 0.00)
                        from CMImpuestosItem cmii
                        where cmii.Ecodigo = a.Ecodigo
                            and cmii.EPDid = a.EPDid
                            and cmii.Icodigo <> <cf_jdbcquery_param cfsqltype="cf_sql_char" value="IVS">
                            and cmii.DPDlinea = a.DPDlinea
                            and cmii.DDlinea in
                                (select cmip2.DDlinea
                                 from CMImpuestosPoliza cmip2
                                    inner join DDocumentosI ddi1
                                        on ddi1.DDlinea = cmip2.DDlinea
                                 where ddi1.EDIid = (select ddi2.EDIid
                                                     from DDocumentosI ddi2
                                                     where ddi2.DDlinea = cmip.DDlinea)
                                )
                        )
                    ) * coalesce(d.DIporcentaje,c.Iporcentaje) / 100.00 as montoteorico,
                    
                    CASE WHEN #preservesinglequotes(DIVISOR_SQl)# = 0 THEN 0.00 ELSE (select x.CMIPmonto 
                                                            from CMImpuestosPoliza x 
                                                            where x.Icodigo = coalesce(d.DIcodigo,c.Icodigo) 
                                                                and x.Ecodigo = a.Ecodigo
                                                                and x.EPDid = a.EPDid
                                                                and x.DDlinea = cmip.DDlinea
                                                        )/ #preservesinglequotes(DIVISOR_SQl)# END 
                 
                FROM DPolizaDesalmacenaje a
                    INNER JOIN Impuestos c
                        LEFT OUTER JOIN DImpuestos d
                        ON d.Icodigo = c.Icodigo
                        AND d.Ecodigo = c.Ecodigo
                    ON c.Icodigo = a.Icodigo
                    AND c.Ecodigo = a.Ecodigo
    
                    inner join CMImpuestosPoliza cmip
                        on cmip.Icodigo = coalesce(d.DIcodigo, c.Icodigo)
                        and cmip.Ecodigo = a.Ecodigo
                        and cmip.EPDid = a.EPDid
    
                WHERE a.EPDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    AND a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and coalesce(d.DIcodigo,c.Icodigo) = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="VTS">
            </cfquery>
        
        </cfif>

		<!--- 6.3 Ajusta la nueva distribución --->
		
		<!--- 6.3.1 Obtiene la distribución hecha con los montos transformados a los tipos de cambio respectivos --->
		<cfquery name="impuestosItemPorAjustar" datasource="#session.dsn#">
			select ii.DPDlinea, ii.Icodigo, ii.DDlinea, round(ii.CMImonto / edi.EDItc, 2) as CMImontoTransito, edi.EDItc
			from CMImpuestosItem ii
				inner join DDocumentosI ddi
					on ddi.DDlinea = ii.DDlinea
				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
			where ii.Ecodigo = #session.Ecodigo#
				and ii.EPDid = #form.EPDid#
			order by ii.DDlinea, ii.CMImonto desc
		</cfquery>
		
		<cfset IcodigoActual = "">				<!--- Variables que indican la factura de impuesto actual que se está ajustando --->
		<cfset DDlineaActual = "">
		<cfset LineaImpuestoAjustada = false>	<!--- Variable que indica si la factura de impuesto actual ya fue ajustada --->
		<cfset CalcularMontosAjuste = true>		<!--- Variable que indica si hay que calcular el total de montos real y esperado --->
		
		<!--- 6.3.2 Realiza el ajuste --->
		<cfloop query="impuestosItemPorAjustar">
		
			<cfif DDlineaActual neq impuestosItemPorAjustar.DDlinea or IcodigoActual neq impuestosItemPorAjustar.Icodigo>
				<cfset IcodigoActual = impuestosItemPorAjustar.Icodigo>
				<cfset DDlineaActual = impuestosItemPorAjustar.DDlinea>
				<cfset LineaImpuestoAjustada = false>
				<cfset CalcularMontosAjuste = true>
			</cfif>
			
			<cfif not LineaImpuestoAjustada>
			
				<cfif CalcularMontosAjuste>
                   	<cfset _LvarTotalImpuestoEsperado = 0.00>
                   	<cfset _LvarTotalImpuestoReal = 0.00>
                    
					<cfquery name="rsTotalImpuestosEsperado" datasource="#session.dsn#">
						select ddi.DDItotallinea as totalImpuestosEsperado
						from CMImpuestosPoliza ip
							inner join DDocumentosI ddi
								on ddi.DDlinea = ip.DDlinea
						where ip.EPDid = #Form.EPDid#
							and ip.Ecodigo = #Session.Ecodigo#
							and ip.DDlinea = #DDlineaActual#
							and ip.Icodigo = '#trim(IcodigoActual)#'
					</cfquery>
                    <cfif rsTotalImpuestosEsperado.recordcount GT 0>
                    	<cfset _LvarTotalImpuestoEsperado = rsTotalImpuestosEsperado.totalImpuestosEsperado>
                    </cfif>
					
					<cfquery name="rsTotalImpuestosReal" dbtype="query">
						select sum(CMImontoTransito) as totalImpuestosReal
						from impuestosItemPorAjustar
						where DDlinea = #DDlineaActual#
							and Icodigo = '#trim(IcodigoActual)#'
					</cfquery>
                    <cfif rsTotalImpuestosReal.recordcount GT 0>
                    	<cfset _LvarTotalImpuestoReal = rsTotalImpuestosReal.totalImpuestosReal>
                    </cfif>

					<cfset TotalAjuste = _LvarTotalImpuestoEsperado - _LvarTotalImpuestoReal>
				</cfif>

				<cfif TotalAjuste gt 0>
					<cfset nuevoMonto = impuestosItemPorAjustar.CMImontoTransito + TotalAjuste>
					<cfset QuerySetCell(impuestosItemPorAjustar, "CMImontoTransito", nuevoMonto, impuestosItemPorAjustar.CurrentRow)>
					<cfset LineaImpuestoAjustada = true>
					<cfset TotalAjuste = 0>
					<cfset CalcularMontosAjuste = true>

				<cfelseif TotalAjuste lt 0>
					<cfif -1 * TotalAjuste gt impuestosItemPorAjustar.CMImontoTransito>
						<cfset nuevoMonto = 0.00>
						<cfset TotalAjuste = TotalAjuste + impuestosItemPorAjustar.CMImontoTransito>
						<cfset CalcularMontosAjuste = false>
					<cfelse>
						<cfset nuevoMonto = impuestosItemPorAjustar.CMImontoTransito + TotalAjuste>
						<cfset LineaImpuestoAjustada = true>
						<cfset TotalAjuste = 0>
						<cfset CalcularMontosAjuste = true>
					</cfif>
					<cfset QuerySetCell(impuestosItemPorAjustar, "CMImontoTransito", nuevoMonto, impuestosItemPorAjustar.CurrentRow)>
				<cfelse>
					<cfset LineaImpuestoAjustada = true>
					<cfset CalcularMontosAjuste = true>				
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- 6.3.3 Actualiza los montos distribuidos para que quedan ajustados tanto al monto
					original, como el que va a quedar en detalle tránsito --->
		<cfloop query="impuestosItemPorAjustar">
			<cfquery name="impuestosItemUpd" datasource="#session.dsn#">
				update CMImpuestosItem
				set CMImonto = <cfqueryparam cfsqltype="cf_sql_money" value="#impuestosItemPorAjustar.CMImontoTransito * impuestosItemPorAjustar.EDItc#">
				where DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#impuestosItemPorAjustar.DPDlinea#">
					and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#impuestosItemPorAjustar.DDlinea#">
					and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(impuestosItemPorAjustar.Icodigo)#">
					and EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfloop>

		<!--- 6.4 Actualiza el valor real de los impuestos no recuperables de la línea --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET 
			DPDimpuestosreal = Coalesce(DPDimpuestosrealRCPar,0) + (
					select coalesce(sum(CMImonto),0.00)
					from CMImpuestosItem a
					where a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
						and a.Icodigo in (select coalesce(dimp.DIcodigo, imp.Icodigo)
										 from Impuestos imp
											 left outer join DImpuestos dimp
												 on dimp.Icodigo = imp.Icodigo
												 and dimp.Ecodigo = imp.Ecodigo
										 where imp.Icreditofiscal = 0
										 	and dimp.DIcreditofiscal = 0
											 and imp.Icodigo = DPolizaDesalmacenaje.Icodigo
											 and imp.Ecodigo = DPolizaDesalmacenaje.Ecodigo
										)
			)
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<!--- 6.5 Actualiza el valor real de los impuestos recuperables de la línea --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET 
			DPDimpuestosrecup = Coalesce(DPDimpuestosrecupRCPar,0) + (
					select coalesce(sum(CMImonto),0.00)
					from CMImpuestosItem a
					where a.DPDlinea = DPolizaDesalmacenaje.DPDlinea
						and a.Icodigo in (select coalesce(dimp.DIcodigo, imp.Icodigo)
										 from Impuestos imp
											 left outer join DImpuestos dimp
												 on dimp.Icodigo = imp.Icodigo
												 and dimp.Ecodigo = imp.Ecodigo
										 where (imp.Icreditofiscal = 1
										 	or dimp.DIcreditofiscal = 1)
											 and imp.Icodigo = DPolizaDesalmacenaje.Icodigo
											 and imp.Ecodigo = DPolizaDesalmacenaje.Ecodigo
										)
			)
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
		<!--- 7. Actualiza el valor declarado de la línea como cif real + aduanales real (gastos) + impuestos real --->
		<cfquery name="updatedet" datasource="#session.dsn#">
			UPDATE DPolizaDesalmacenaje
			SET DPDvalordeclarado = DPDmontocifreal + DPDfletesreal + DPDsegurosreal + DPDaduanalesreal + DPDimpuestosreal
			WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
	</cftransaction>
    
	<cflocation url="polizaDesalmacenaje-Rep.cfm?EPDid=#form.EPDid#">

<cfelseif isdefined("form.MostrarCalculo")>
	<cflocation url="polizaDesalmacenaje-Rep.cfm?EPDid=#form.EPDid#">
    
<!---►►►►Proceso de Cierre de Póliza (Relacionar con pólizas Nuevas)◄◄◄◄◄◄--->
<cfelseif isdefined("form.CierrePoliza")>
	
    <!---►►Se obtienen la información del Encabezado de la póliza de desalmacenaje (EPolizaDesalmacenaje)◄◄--->
  	<cfquery name="rsEncabezadoPoliza" datasource="#session.dsn#">
        select EPembarque, PermiteDesParcial, EPDidpadre
        from EPolizaDesalmacenaje
        where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    
    <!---►►Obtiene la moneda local◄◄--->
    <cfquery name="rsMonedaLocal" datasource="#session.dsn#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    
    <!---►►Obtiene Periodo Auxiliar◄◄--->
    <cfquery name="rsAuxiliaresP" datasource="#session.dsn#">
        select Pvalor as Periodo
        from Parametros
        where Pcodigo = 50
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    
    <!---►►Obtiene Mes Auxiliar◄◄--->
    <cfquery name="rsAuxiliaresM" datasource="#session.dsn#">
        select Pvalor as Mes
         from Parametros
        where Pcodigo = 60
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
            
	<!---►►Verifica que exista el tipo de documento de recepción, y si no existe lo inserta(no importa que este fuera de transaccion)◄◄--->
    <cfquery name="rsEDR" datasource="#session.dsn#" maxrows="1">
        select TDRcodigo
         from TipoDocumentoR
        where TDRtipo = 'R'
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>	
    <cfif rsEDR.RecordCount  eq 0>
        <cfquery datasource="#session.dsn#">
            insert into TipoDocumentoR
                (Ecodigo, TDRcodigo, TDRdescripcion, TDRtipo, Usucodigo, fechaalta)
            values
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                , 'R'
                , 'Recepción'
                , 'R'
                , <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                , <cf_dbfunction name="now">
                )
        </cfquery>
        <cfset LTDRcodigo = 'R'>
    <cfelse>
        <cfset LTDRcodigo = rsEDR.TDRcodigo>
    </cfif>
    
    <!---►►Obtiene la cuenta en transito◄◄--->
    <cfquery name="CuentaActivoTransito" datasource="#session.dsn#">	
        select Pvalor 
        	from Parametros 
          where Pcodigo = 240 
            and Ecodigo = #session.Ecodigo#
    </cfquery>
    <cfif NOT CuentaActivoTransito.RecordCount>
        <cfthrow message="La cuenta de activos en transito no esta Configurada">
    </cfif>
    
    <!---►►Verifica que se pueda convertir las unidades de la póliza a las de la orden de compra◄◄--->
    <cfif rsEncabezadoPoliza.PermiteDesParcial eq 0>
            <cfquery name="rsVerificaConversionUnidades" datasource="#session.dsn#">
                select case when dpd.Ucodigo = do.Ucodigo then 1
                            else coalesce(cu.CUfactor, cua.CUAfactor)
                       end as CUfactor
                from DPolizaDesalmacenaje dpd
    
                    inner join DOrdenCM do
                        on do.DOlinea = dpd.DOlinea
    
                    left outer join ConversionUnidades cu
                        on cu.Ecodigo = dpd.Ecodigo
                        and cu.Ucodigo = dpd.Ucodigo
                        and cu.Ucodigoref = do.Ucodigo
    
                        left outer join Articulos art
                            on art.Aid = do.Aid
        
                        left outer join ConversionUnidadesArt cua
                            on cua.Aid = do.Aid
                            and art.Ucodigo = dpd.Ucodigo
                            and cua.Ucodigo = do.Ucodigo
                            and cua.Ecodigo = art.Ecodigo
                where dpd.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
            </cfquery>
            
            <cfquery dbtype="query" name="rsLineasSinConversion">
                select 1
                from rsVerificaConversionUnidades
                where CUfactor is null
            </cfquery>
    
            <cfif rsLineasSinConversion.RecordCount gt 0>
                <cf_errorCode	code = "50322" msg = "No todos los artículos de la póliza tienen un factor de conversión a las unidades de la orden">
            </cfif>
    
            <cfquery name="rsSelecEDR" datasource="#session.dsn#">
                select 
                    1.00 as EDRtc,
                    <cfif len(trim(form.Aid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#"><cfelse>null</cfif> as Aid,
                    <cfif len(trim(form.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"><cfelse>null</cfif> as CFid,
                    null as CPTcodigo, 
                    epd.EPDnumero,
                    epd.EPDid,
                    epd.EPDfecha as EDRfechadoc, 
                    epd.SNcodigo, 
                    epd.EPDnumero as EDRreferencia, 
                    0.00 as EDRdescpro, 
                    0.00 as EDRimppro, 
                    null as EDRobs, 
                    #rsAuxiliaresP.Periodo# as EDRperiodo, 
                    #rsAuxiliaresM.Mes# as EDRmes, 
                    0 as EDRestado
                from EPolizaDesalmacenaje epd
                WHERE EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
            
         <cfquery name="numeroPoliza" datasource="#session.dsn#">
            select EPDnumero
             from EPolizaDesalmacenaje
            where EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
     </cfif>
    
    <cfset ETidtracking  = rsEncabezadoPoliza.EPembarque>
    <cfset entregas      = "">
    <cfset cambioDeLinea = "">
    
   <cfquery name="rsEsPadre" datasource="#session.DSN#">
        select count(1) as cantidad
         from EPolizaDesalmacenaje a
        where EPDidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
   </cfquery>
	
       
    <cfif isdefined("rsEncabezadoPoliza") and (rsEncabezadoPoliza.PermiteDesParcial eq 0 or len(trim(rsEncabezadoPoliza.EPDidpadre)) gt 0)>
		
		<!--- ►►Obtiene los ítems de la póliza (DPolizaDesalmacenaje)◄◄--->
        <cfquery name="itemsPoliza"	datasource="#session.dsn#">
            select dpd.DDlinea, dpd.DPDcantidad, dpd.DPDaduanalesreal, dpd.DPDimpuestosreal,
                dpd.DPDfletesreal, dpd.DPDsegurosreal, dpd.DPseguropropio, dpd.DPDvalordeclarado,
                do.DOdescripcion, do.EOidorden, dpd.DPDimpuestosrecup, dpd.DPDmontofobreal,
                dpd.DPDfletesprorrat, dpd.DPDsegurosprorrat
            from DPolizaDesalmacenaje dpd
                inner join DOrdenCM do
                     on do.DOlinea = dpd.DOlinea
            where dpd.EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
              and dpd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        
		<!---►►Verifica que existan ítems en la póliza◄◄--->
		<cfif itemsPoliza.RecordCount eq 0>
            <cf_errorCode	code = "50321" msg = "No se encontraron líneas en la Póliza de Desalmacenaje, Proceso Cancelado!">
        </cfif>	
        
        <!---►►Obtiene la cantidad de ítems disponibles en el tracking◄◄--->
        <cfquery name="cantidadItemsDisponibles" datasource="#session.dsn#">
            select 1 as totalLineasDisponibles
            from ETrackingItems
            where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtracking#">
                and ETIestado = 0
                and ETIcantidad > 0
        </cfquery>
   	</cfif>
 	
	<!---►►Crea las tablas temporales de trabajo◄◄--->
    <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="fnCreaTablasTemp">
    </cfinvoke>
        
	<cftransaction>
		<cfif isdefined("rsEncabezadoPoliza") and (rsEncabezadoPoliza.PermiteDesParcial eq 0 or len(trim(rsEncabezadoPoliza.EPDidpadre)) gt 0)>
            <cfloop query="itemsPoliza">
                <!--- 3. Actualiza los ítems en el tracking contenidos en la póliza --->
                <cfquery name="updateTrackingItems" datasource="#session.dsn#">
                    update ETrackingItems 
                    set ETIcantidad 			= ETIcantidad 			 - <cfqueryparam cfsqltype="cf_sql_float" value="#itemsPoliza.DPDcantidad#">,
                        ETcantrecibida 			= ETcantrecibida 		 + <cfqueryparam cfsqltype="cf_sql_float" value="#itemsPoliza.DPDcantidad#">,
                        ETcostoindgastos 		= ETcostoindgastos  	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDaduanalesreal#">,
                        ETcostoindimp 			= ETcostoindimp 		 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDimpuestosreal + itemsPoliza.DPDimpuestosrecup#">,
                        ETcostoindfletesPoliza 	= ETcostoindfletesPoliza + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDfletesreal#">,
                      ETcostoindsegPoliza 	= ETcostoindsegPoliza 	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDsegurosreal#">,
                       ETcostoindsegpropio 	= ETcostoindsegpropio 	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPseguropropio#">,
                       ETcostorecibido 		= ETcostorecibido 		 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDvalordeclarado + itemsPoliza.DPDimpuestosrecup#">,
                       ETcostodirectorec 		= ETcostodirectorec 	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDmontofobreal#">,
                       ETcostoindfletesrec 	= ETcostoindfletesrec 	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDfletesprorrat#">,
                       ETcostoindsegrec	 	= ETcostoindsegrec 	 	 + <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#itemsPoliza.DPDsegurosprorrat#">,
                        ETcostodirectofacorig 	= ETcostodirectofacorig   - ((<cfqueryparam cfsqltype="cf_sql_float" value="#itemsPoliza.DPDcantidad#"> / ETIcantidad) * ETcostodirectofacorig),
                        ETcostoindfletesfacorig = ETcostoindfletesfacorig - ((<cfqueryparam cfsqltype="cf_sql_float" value="#itemsPoliza.DPDcantidad#"> / ETIcantidad) * ETcostoindfletesfacorig),
                        ETcostoindsegfacorig 	= ETcostoindsegfacorig    - ((<cfqueryparam cfsqltype="cf_sql_float" value="#itemsPoliza.DPDcantidad#"> / ETIcantidad) * ETcostoindsegfacorig)
                   
                    where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtracking#">
                      and ETIiditem    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#itemsPoliza.DDlinea#">
                      and Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>
                <cfset entregas = entregas & "#itemsPoliza.DPDcantidad# #itemsPoliza.DOdescripcion#" & cambioDeLinea>
            </cfloop>
			
            <!--- 5. Actualiza el encabezado del tracking a entrega si se desalmacenó todo el tracking --->
            <cfif cantidadItemsDisponibles.RecordCount eq 0>
                <cfquery name="updateTracking" datasource="#session.dsn#">
                    update ETracking
                    set ETfechaentrega = <cf_dbfunction name="now">,
                        ETrecibidopor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#">,
                        ETestado = 'E'
                    where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtracking#">
                </cfquery>
            </cfif>

			<!--- 6. Actualiza el estado de la póliza a cerrada --->
            <cfquery name="updateepd" datasource="#session.dsn#">
                UPDATE EPolizaDesalmacenaje
                SET EPDestado = 10
                WHERE EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>

      	</cfif>
		  <!---►Se eliminan Ciertos Movimientos, que posteriormete se volveran a insertar con los montos recalculados
                    1-'Fletes' 
                    2-'Seguros' 
                    3-'Costos' 
                    4-'Gastos' 
                    5-'Impuesto No Recuperable' 
                    6-'Impuesto Recuperable' 
                    7-'Seguro propio' 
                    8'Costeo de mercancía'
        ◄◄--->
		<cfquery name="Delete" datasource="#session.dsn#">
        	delete from CMDetalleTransito 
            where EPDid         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
             and TipoMovimiento in (1,2,4,5,6,7)
        </cfquery>
		<!---►►Realiza las afectaciones al tránsito◄◄--->

		<!--- 7.1 Realiza las afectaciones de las facturas propias de la póliza --->
		<cfquery name="rsAjustesGastosTransito" datasource="#session.dsn#">
			insert into CMDetalleTransito
				(EDIid, DDlinea, Ecodigo, EOidorden,
				 DOlinea, EPDid, DPDlinea,
				 DTfechamov,
				 DTmonto,
				 Mcodigo, tipocambio,
				 ETidtracking,
				 CTcuenta,
				 BMUsucodigo,
				 fechaalta, TipoMovimiento)
			select edi.EDIid, ddi.DDlinea, fp.Ecodigo, do.EOidorden,
				   do.DOlinea, fp.EPDid, dpd.DPDlinea,
				   <cf_dbfunction name="now">,
				   (coalesce(fgi.FGImonto, 0.00) / edi.EDItc) * case when edi.EDItipo = 'N' then -1.00 else 1.00 end,
				   edi.Mcodigo, edi.EDItc,
				   <cf_dbfunction name="to_number" args="epd.EPembarque">,
				   coalesce(iac.IACtransito, #CuentaActivoTransito.Pvalor#),
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				   <cf_dbfunction name="now">,
				   ddi.DDIafecta
			from FacturasGastoItem fgi
				inner join FacturasPoliza fp
					on fp.FPid = fgi.FPid
				inner join DPolizaDesalmacenaje dpd
					on dpd.DPDlinea = fgi.DPDlinea
				inner join EPolizaDesalmacenaje epd
					on epd.EPDid = dpd.EPDid
				inner join DDocumentosI ddi
					on ddi.DDlinea = fp.DDlinea
				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
				inner join DOrdenCM do
					on do.DOlinea = dpd.DOlinea
				left outer join Existencias e
					on e.Aid = do.Aid
					and e.Alm_Aid = do.Alm_Aid
				left outer join IAContables iac
					on iac.IACcodigo = e.IACcodigo
					and iac.Ecodigo  = epd.Ecodigo
				left outer join AClasificacion ac
					 on ac.Ecodigo  = epd.Ecodigo
					and ac.ACid     = do.ACid
					and ac.ACcodigo = do.ACcodigo
			where fp.EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
			  and fp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- *7.2 Realiza las afectaciones de los impuestos de la póliza --->
		<cfquery name="rsAjustesImpuestosTransito" datasource="#session.dsn#">
			insert into CMDetalleTransito
				(EDIid, DDlinea, Ecodigo, EOidorden,
				 DOlinea, EPDid, DPDlinea,
				 DTfechamov,
				 DTmonto,
				 Mcodigo, tipocambio,
				 ETidtracking,
				 CTcuenta,
				 BMUsucodigo,
				 fechaalta, TipoMovimiento)
			select edi.EDIid, ddi.DDlinea, ii.Ecodigo, do.EOidorden,
				   do.DOlinea, ii.EPDid, dpd.DPDlinea,
				   <cf_dbfunction name="now">,
				   coalesce(ii.CMImonto, 0.00) / edi.EDItc,
				   edi.Mcodigo, edi.EDItc,
				   <cf_dbfunction name="to_number" args="epd.EPembarque">,
				   coalesce(iac.IACtransito, #CuentaActivoTransito.Pvalor#) as CuentaTransito,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				   <cf_dbfunction name="now">,
				   case when cmiicf.DDlinea is null then 6 else 5 end as TipoImpuesto
			from CMImpuestosItem ii
				inner join CMImpuestosPoliza ip
					on ip.Ecodigo = ii.Ecodigo
					and ip.Icodigo = ii.Icodigo
					and ip.EPDid = ii.EPDid
					and ip.DDlinea = ii.DDlinea
				inner join DPolizaDesalmacenaje dpd
					on dpd.DPDlinea = ii.DPDlinea
				inner join EPolizaDesalmacenaje epd
					on epd.EPDid = dpd.EPDid
				inner join DDocumentosI ddi
					on ddi.DDlinea = ip.DDlinea

					left outer join CMImpuestosItem cmiicf
						on cmiicf.DPDlinea = dpd.DPDlinea
						and cmiicf.Ecodigo = dpd.Ecodigo
						and cmiicf.EPDid = dpd.EPDid
						and cmiicf.Icodigo = ddi.Icodigo
						and cmiicf.DDlinea = ddi.DDlinea
						and cmiicf.Icodigo in (select coalesce(dimp.DIcodigo, imp.Icodigo)
											   from Impuestos imp
											   left outer join DImpuestos dimp
												   on dimp.Icodigo = imp.Icodigo
												   and dimp.Ecodigo = imp.Ecodigo
											   where imp.Icreditofiscal = 0
												   and dimp.DIcreditofiscal = 0
												   and imp.Icodigo = dpd.Icodigo
												   and imp.Ecodigo = dpd.Ecodigo
											  )

				inner join EDocumentosI edi
					on edi.EDIid = ddi.EDIid
				inner join DOrdenCM do
					on do.DOlinea = dpd.DOlinea
				left outer join Existencias e
					on e.Aid = do.Aid
					and e.Alm_Aid = do.Alm_Aid
				left outer join IAContables iac
					on iac.IACcodigo = e.IACcodigo
					and iac.Ecodigo = e.Ecodigo
				left outer join AClasificacion ac
					 on ac.Ecodigo  = epd.Ecodigo
					and ac.ACid     = do.ACid
					and ac.ACcodigo = do.ACcodigo
			where ii.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and ii.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ii.CMImonto > 0
		</cfquery>

		<!--- *7.3 Realiza las afectaciones de los seguros propios --->
		<cfquery name="afectacionAlTransitoSegurosPropios" datasource="#session.dsn#">
			insert into CMDetalleTransito
				(Ecodigo, EOidorden,
				 DOlinea, EPDid, DPDlinea,
				 DTfechamov,
				 DTmonto,
				 Mcodigo, tipocambio,
				 ETidtracking,
				 CTcuenta,
				 BMUsucodigo,
				 fechaalta, TipoMovimiento)
			select dpd.Ecodigo, do.EOidorden,
				   do.DOlinea, dpd.EPDid, dpd.DPDlinea,
				   <cf_dbfunction name="now">,
				   dpd.DPseguropropio,
				   emp.Mcodigo, 1.00,
				    <cf_dbfunction name="to_number" args="epd.EPembarque"> as EPembarque,
				   coalesce(iac.IACtransito, #CuentaActivoTransito.Pvalor#),
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				   <cf_dbfunction name="now">,
				   7
			from DPolizaDesalmacenaje dpd
				inner join EPolizaDesalmacenaje epd
					on epd.EPDid = dpd.EPDid
				inner join Empresas emp
					on emp.Ecodigo = epd.Ecodigo
				inner join DOrdenCM do
					on do.DOlinea = dpd.DOlinea
				left outer join Existencias e
					on e.Aid = do.Aid
					and e.Alm_Aid = do.Alm_Aid
				left outer join IAContables iac
					on iac.IACcodigo = e.IACcodigo
					and iac.Ecodigo = dpd.Ecodigo
				left outer join AClasificacion ac
					 on ac.Ecodigo  = epd.Ecodigo
					and ac.ACid     = do.ACid
					and ac.ACcodigo = do.ACcodigo
			where dpd.EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
			  and dpd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and dpd.DPseguropropio > 0
		</cfquery>
        
		<!--- solo crea el documento de recepción cuando PermiteDesParcial  = 0 --->
		<cfif rsEncabezadoPoliza.PermiteDesParcial eq 0>
			<!--- 8. Crea documento de recepción --->
          
            <cfquery name="rsEDR" datasource="#session.dsn#">
                insert into EDocumentosRecepcion( 
                    Ecodigo, TDRcodigo, Mcodigo, EDRtc, 
                    Aid, CFid, CPTcodigo, EDRnumero, EPDid,
                    EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, 
                    EDRreferencia, Usucodigo, fechaalta, EDRdescpro, 
                    EDRimppro, EDRobs, EDRperiodo, EDRmes, EDRestado )
                VALUES(
                   #session.Ecodigo#,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#LTDRcodigo#"     			voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsMonedaLocal.Mcodigo#"    	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#rsSelecEDR.EDRtc#"         	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelecEDR.Aid#"           	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelecEDR.CFid#"          	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#rsSelecEDR.CPTcodigo#"     	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#rsSelecEDR.EPDnumero#"     	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelecEDR.EPDid#"         	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#rsSelecEDR.EDRfechadoc#"   	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#itemsPoliza.EOidorden#"    	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelecEDR.SNcodigo#"      	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#rsSelecEDR.EDRreferencia#" 	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#form.Usucodigo#"  		   	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsSelecEDR.EDRdescpro#"    	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsSelecEDR.EDRimppro#"     	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_clob"              value="#rsSelecEDR.EDRobs#"        	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelecEDR.EDRperiodo#"    	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelecEDR.EDRmes#"        	voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelecEDR.EDRestado#"     	voidNull>
            )
                <cf_dbidentity1>
            </cfquery>
            <cf_dbidentity2 name="rsEDR">
            
            <!--- 8.6 Inserta los detalles del documento (DDocumentosRecepcion) --->
            <cfquery datasource="#session.dsn#">
                insert into DDocumentosRecepcion(
                    Ecodigo, EDRid, DOlinea, DDRtipoitem, Aid, Cid, 
                    DDRprecioorig, Ucodigo, DDRgenreclamo, DDRcantreclamo, DDRobsreclamo, Usucodigo, fechaalta,
                    DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal,
                    DDRdescporclin, DDRtotallincd, DDRimptoporclin, DDRmtoimpfact, Icodigo, DDRcantordenconv)
                select 
                    dpd.Ecodigo, #rsEDR.identity#, dpd.DOlinea, case when dpd.Aid is not null then 'A' when dpd.Cid is not null then 'S' else 'F' end, dpd.Aid, dpd.Cid, 
                    case when dpd.DPDcantidad = 0 then 0 else #LvarOBJ_PrecioU.enSQL("dpd.DPDvalordeclarado / dpd.DPDcantidad")# end,
                    dpd.Ucodigo,
                    case when coalesce(dpd.DPDcantreclamo,0.00) = 0.00 then 0 else 1 end, 
                    coalesce(dpd.DPDcantreclamo,0.00),
                    dpd.DPDobsreclamo,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                    <cf_dbfunction name="now">,
                    dpd.DPDcantidad, 
                    dpd.DPDcantidad, 
                    case when dpd.DPDcantidad = 0 then 0 else #LvarOBJ_PrecioU.enSQL("dpd.DPDvalordeclarado / dpd.DPDcantidad")# end,
                    0.00, 
                    dpd.DPDvalordeclarado,
                    0.00,
                    0.00,
                    0.00,
                    dpd.DPDvalordeclarado,
                    0.00,
                    0.00, dpd.Icodigo,
                    dpd.DPDcantidad *
                    case when dpd.Ucodigo = do.Ucodigo then 1
                         else coalesce(cu.CUfactor, cua.CUAfactor)
                    end
                from DPolizaDesalmacenaje dpd
    
                    inner join DOrdenCM do
                        on do.DOlinea = dpd.DOlinea
    
                    left outer join ConversionUnidades cu
                         on cu.Ecodigo    = dpd.Ecodigo
                        and cu.Ucodigo    = dpd.Ucodigo
                        and cu.Ucodigoref = do.Ucodigo
    
                        left outer join Articulos art
                             on art.Aid     = do.Aid
                            and art.Ecodigo = dpd.Ecodigo
        
                        left outer join ConversionUnidadesArt cua
                             on cua.Aid		= do.Aid
                            and art.Ucodigo = dpd.Ucodigo
                            and cua.Ucodigo = do.Ucodigo
                            and cua.Ecodigo = art.Ecodigo
    
                where dpd.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                    and dpd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
    
            <!--- 9. Genera la actividad de seguimiento --->
            <cfif Len(Trim(entregas)) gt 0>
                
                <cfset entregas = "Lista de ítems desalmacenados:" & cambioDeLinea & entregas>
    
                <cf_dbdatabase table="DTracking" returnvariable="LvarDTracking" datasource="sifpublica">
                <cf_dbdatabase table="ETracking" returnvariable="LvarETracking" datasource="sifpublica">
                <cfquery name="insDTracking" datasource="#session.DSN#">
                    insert into #LvarDTracking#(ETidtracking, CEcodigo, EcodigoASP, Ecodigo, cncache, DTactividad, DTtipo, DTfecha, DTfechaincidencia, CRid, DTnumreferencia, ETcodigo, BMUsucodigo, Observaciones)
                    select 
                        ETidtracking,
                        CEcodigo,
                        EcodigoASP,
                        Ecodigo,
                        cncache,
                        'Entrega de ítems por la póliza No. #numeroPoliza.EPDnumero#',
                        'T',
                        <cf_dbfunction name="now">,
                        <cf_dbfunction name="now">,
                        CRid,
                        ETnumreferencia,
                        ETcodigo,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        '#entregas#'
                    from #LvarETracking#
                    where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtracking#">
                </cfquery>

            </cfif>
        </cfif><!--- fin if PermiteDesParcial  = 0  --->

    
    <!--- *******************************************Inicio nuevo de CxP  ********************************************************************************************** --->
    <!--- Aplica solo para las transacciones que están asociadas a una póliza de desalmacenaje.
		  Solamente las pólizas padres "primerisos" pueden pasar los documentos a CxP, si no daría error que el documento ya existe en el auxiliar.
	 --->
   <cfif rsEsPadre.cantidad eq 0>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        <cfquery name="rsDatosDet" datasource="#session.DSN#">
            select 
                ddi.EDIid,
                ddi.DDItipo,
                coalesce(ddi.Cid, -1) as Cid,
                coalesce(c.Alm_Aid, -1) as Alm_Aid,
                Coalesce(dcm.Ecodigo,do.Ecodigo) as Ecodigo,
                -1 as Dcodigo,
                -1  as Ccuenta,
                coalesce(ddi.Aid, c.Aid) as Aid, 
                do.DOlinea, 
                do.CFid,  
                
                case ddi.DDIafecta 
                    when 1 then 'Fletes:' #_Cat# do.DOdescripcion
                    when 2 then 'Seguro:' #_Cat# do.DOdescripcion
                    when 4 then 'Gasto:'  #_Cat# do.DOdescripcion
                    when 5 then 'Impuesto:'   #_Cat# (select imp.Idescripcion 
                                                    from Impuestos imp
                                                 where imp.Ecodigo = ddi.Ecodigo
                                                   and imp.Icodigo = ddi.Icodigo)
              		else do.DOdescripcion end as DOdescripcion,
              
                case ddi.DDIafecta when 5 then null else do.DOalterna end as DOalterna,
                
                
                ddi.DDIcantidad, 
				 (b.DTmonto / ddi.DDIcantidad) as DDIpreciou, 
                (case ddi.DDIafecta when 5 then b.DTmonto - Coalesce(c.DPDimpuestosrealRCPar,0) else b.DTmonto end / ddi.DDIcantidad * coalesce(ddi.DDIporcdesc,0)) /100  as DDdesclinea, 
                ddi.DDIporcdesc, 
                <!---►►Monto Total: es el monto del detalle de transito excepto cuando es impuesto no Fiscal, es el impuesto real, sin los montos de la poliza padre◄◄--->
                 b.DTmonto as DDItotallinea, 
                ddi.DDItipo, 
                #session.Usucodigo# as BMUsucodigo, 
				<!---►►Se coloca el impuesto en null para que sea excento, ya que los montos de impuestos van como una linea más◄◄--->
                -1 as Icodigo,

                coalesce(ddi.Ucodigo, do.Ucodigo, null) as Ucodigo, 
                -1 as OCTtipo, 
                -1 as OCTtransporte, 
                -1 as OCCid, 
                -1 as OCid, 
                -1 as CFcuenta, 
                -1 as PCGDid, 
                -1 as FPAEid, 
                -1 as OBOid, 
                -1 as DSespecificacuenta, 
                case when ddi.DDIafecta = 5 and  
                (select imp.DIcreditofiscal 
                	from DImpuestos imp
                 where imp.Ecodigo  = ddi.Ecodigo
                   and imp.Icodigo  = c.Icodigo
                   and imp.DIcodigo = ddi.Icodigo) = 1 then 1 else 0 end as CreditoFiscal,
                '' as GrupoImpuestoAduanal,
                '' as ImpuestoAduanal
                
            from DDocumentosI ddi
                INNER JOIN CMDetalleTransito b
                	on b.DDlinea = ddi.DDlinea
                INNER JOIN DPolizaDesalmacenaje c
                	on c.DOlinea = b.DOlinea
                   and c.EPDid   = ddi.EPDid
                INNER JOIN DOrdenCM do
                	on do.DOlinea = c.DOlinea
                LEFT OUTER JOIN DSolicitudCompraCM dcm
                    ON dcm.DSlinea = do.DSlinea 
                    
            where ddi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
             and (case when ddi.DDIafecta = 5 and  
                (select imp.DIcreditofiscal 
                	from DImpuestos imp
                 where imp.Ecodigo  = ddi.Ecodigo
                   and imp.Icodigo  = c.Icodigo
                   and imp.DIcodigo = ddi.Icodigo) = 1 then 1 else 0 end ) = 0
            
           UNION ALL
            <!---LINEAS DEL CREDITO FISCAL--->
            select 
                ddi.EDIid,
                ddi.DDItipo,
                coalesce(ddi.Cid, -1) as Cid,
                coalesce(c.Alm_Aid, -1) as Alm_Aid,
                Coalesce(dcm.Ecodigo,do.Ecodigo) as Ecodigo,
                -1 as Dcodigo,
                -1 as Ccuenta,
                coalesce(ddi.Aid, c.Aid) as Aid, 
                do.DOlinea, 
                do.CFid,  
                case ddi.DDIafecta 
                    when 1 then 'Fletes:' #_Cat# do.DOdescripcion
                    when 2 then 'Seguro:' #_Cat# do.DOdescripcion
                    when 4 then 'Gasto:'  #_Cat# do.DOdescripcion
                    when 5 then 'IVCF:'   #_Cat# (select imp.Idescripcion 
                    									from Impuestos imp
                                                     where imp.Ecodigo = ddi.Ecodigo
                                                       and imp.Icodigo = ddi.Icodigo)
                   else do.DOdescripcion end as DOdescripcion,
                null as DOalterna, 
                ddi.DDIcantidad, 
                b.DTmonto  / ddi.DDIcantidad as DDIpreciou, 
                (b.DTmonto / ddi.DDIcantidad * coalesce(ddi.DDIporcdesc,0)) /100  as DDdesclinea, 
                ddi.DDIporcdesc, 
                b.DTmonto as DDItotallinea, 
                ddi.DDItipo, 
                #session.Usucodigo# as BMUsucodigo, 
				<!---►►Se coloca el impuesto en null para que sea excento, ya que los montos de impuestos van como una linea más◄◄--->
                -1 Icodigo,

                coalesce(ddi.Ucodigo, do.Ucodigo, null) as Ucodigo, 
                -1 as OCTtipo, 
                -1 as OCTtransporte, 
                -1 as OCCid, 
                -1 as OCid, 
                -1 as CFcuenta, 
                -1 as PCGDid, 
                -1 as FPAEid, 
                -1 as OBOid, 
                -1 as DSespecificacuenta, 
                case when ddi.DDIafecta = 5 and imp.DIcreditofiscal = 1 then 1 else 0 end as CreditoFiscal,
                imp.Icodigo as GrupoImpuestoAduanal,
                imp.DIcodigo as ImpuestoAduanal
                
            from DDocumentosI ddi
                inner join CMDetalleTransito b
                	on b.DDlinea = ddi.DDlinea
                inner join DPolizaDesalmacenaje c
                	on c.DOlinea = b.DOlinea
				  and c.EPDid = ddi.EPDid
                  
                inner join DOrdenCM do
                	on do.DOlinea = c.DOlinea
                    
                LEFT OUTER JOIN DSolicitudCompraCM dcm
                    ON dcm.DSlinea = do.DSlinea 
                 
                left outer join DImpuestos imp
                    on imp.Ecodigo  = ddi.Ecodigo
                   and imp.Icodigo  = c.Icodigo
                   and imp.DIcodigo = ddi.Icodigo
                   
            where ddi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
             and (case when ddi.DDIafecta = 5 and  
                (select imp.DIcreditofiscal 
                	from DImpuestos imp
                 where imp.Ecodigo  = ddi.Ecodigo
                   and imp.Icodigo  = c.Icodigo
                   and imp.DIcodigo = ddi.Icodigo) = 1 then 1 else 0 end ) = 1
        </cfquery>
        
		<cfset EDIidparam = rsDatosDet.EDIid> <!--- Todos los registros del detalle  --->
  
        <!--- Si existe al menos un detalle tipo Artículo o activo: pasa el dato a CxP --->
        <cfif rsDatosDet.recordcount gt 0>
        	<!---►►Valida que no se hallan Mesclado Empresas◄◄--->
            <cfquery name="rsEcodigo" dbtype="query">
                select Distinct Ecodigo from rsDatosDet
            </cfquery>
            <cfif rsEcodigo.RecordCount GT 1>
                <cfthrow message="No puede incluir Lineas de Costos de Distintas Empresas">
            <cfelse>
                <cfset LvarEcodigoSolicitante = rsEcodigo.Ecodigo>
            </cfif>
            <cfquery name="rsEmpresa" datasource="#session.dsn#">
            	select Edescripcion from Empresas where Ecodigo = #LvarEcodigoSolicitante#
            </cfquery>
        
            <cfquery name="rsDatosEnc" datasource="#session.DSN#">
                select 
                	a.EDIid,
                    a.CPcodigo,
                    a.Ddocumento,
                    a.EDItc as EDtipocambio,
                    a.Ocodigo,
                    a.EDIfecha as EDfecha,
                    a.EDIfecha as EDfechaarribo,
                    a.CPTcodigo,
                    
                    0 as EDdescuento,
                    0 as EDimpuesto,
                    
                    -1 as Rcodigo,
                    -1 as EDdocref,
                    -1 as TESRPTCid,
                    -1 as SNcodigo,
                    -1 as id_direccion,
                    -1 as Ccuenta, 
                    -1 as Mcodigo,
                   
                   '#session.Usulogin#' as EDusuario,
                    #session.Usucodigo# as Usucodigo,
                    
                    <!---►ISO de la Moneda--->
                    (select Miso4217 from Monedas where Mcodigo = a.Mcodigo) as Miso4217,
                    <!---►Total de la Factua--->
                     Coalesce((select sum(d.DDIcantidad * d.DDIpreciou)
                            	from DDocumentosI d
                            	where d.EDIid = a.EDIid),0) as EDtotal,
                    <!---►Identificación del Socio de Negocio--->
                    Coalesce((select SNidentificacion 
                                from SNegocios 
                               where SNcodigo = a.SNcodigo 
                                  and Ecodigo = a.Ecodigo),'') as SNidentificacion
    
                from EDocumentosI  a
                where a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
                  and a.EDIestado = 10 <!--- Aplicado --->
            </cfquery>
    	</cfif>
    </cfif>
    
   <cfif rsEsPadre.cantidad eq 0>
        <cfif rsDatosDet.recordcount gt 0>
            <cfloop query="rsDatosEnc">
                <cfinvoke component="sif.cm.Componentes.CM_Alta_DocumentosCxP" method="fnAltaEncDoc" returnvariable="LvarIDdocumento">
                        <cfinvokeargument name="CPTcodigo" 			value="#rsDatosEnc.CPTcodigo#">
                        <cfinvokeargument name="EDdocumento" 		value="#rsDatosEnc.Ddocumento#">
                        <cfinvokeargument name="SNcodigo" 			value="#rsDatosEnc.SNcodigo#">
                        <cfinvokeargument name="Mcodigo" 			value="#rsDatosEnc.Mcodigo#">
                        <cfinvokeargument name="EDtipocambio" 		value="#rsDatosEnc.EDtipocambio#">
                        <cfinvokeargument name="EDdescuento" 		value="#rsDatosEnc.EDdescuento#">
                        <cfinvokeargument name="EDimpuesto" 		value="#rsDatosEnc.EDimpuesto#">
                        <cfinvokeargument name="EDtotal" 			value="#rsDatosEnc.EDtotal#">
                        <cfinvokeargument name="Ocodigo" 			value="#rsDatosEnc.Ocodigo#">
                    	<cfinvokeargument name="Ccuenta" 			value="#rsDatosEnc.Ccuenta#">
                        <cfinvokeargument name="EDfecha" 			value="#rsDatosEnc.EDfecha#">
                        <cfinvokeargument name="Rcodigo" 			value="#rsDatosEnc.Rcodigo#">
                        <cfinvokeargument name="EDusuario" 			value="#rsDatosEnc.EDusuario#">
                        <cfinvokeargument name="EDdocref" 			value="#rsDatosEnc.EDdocref#">
                        <cfinvokeargument name="EDfechaarribo" 		value="#rsDatosEnc.EDfechaarribo#">
                        <cfinvokeargument name="id_direccion" 		value="#rsDatosEnc.id_direccion#">
                        <cfinvokeargument name="TESRPTCid" 			value="#rsDatosEnc.TESRPTCid#">
                        <cfinvokeargument name="Usucodigo" 			value="#rsDatosEnc.Usucodigo#">
                        <cfinvokeargument name="ActivarTran" 		value="false">
                        <cfinvokeargument name="EDAdquirir" 		value="0">
                        <cfinvokeargument name="EDexterno" 			value="1">
                        <cfinvokeargument name="Ecodigo" 			value="#LvarEcodigoSolicitante#">
                        <cfinvokeargument name="SNidentificacion" 	value="#rsDatosEnc.SNidentificacion#">
                        <cfinvokeargument name="Miso4217" 			value="#rsDatosEnc.Miso4217#">
              	</cfinvoke>
                
                <cfquery dbtype="query" name="rsLineasFac">
                	select * from rsDatosDet where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEnc.EDIid#">
                </cfquery>
        
                <cfloop query="rsLineasFac">
                	<cfif rsLineasFac.CreditoFiscal EQ 0>
                        <cfinvoke component="sif.Componentes.CM_OrdenCompra" method="obtenerCuentaTransito" returnvariable="LvarCuentaTransito">
                            <cfinvokeargument name="DOlinea" value="#rsLineasFac.DOlinea#"/>
                            <cfinvokeargument name="Ecodigo" value="#LvarEcodigoSolicitante#"/>
                        </cfinvoke>
                    <cfelse>
                    	<cfquery name="rsImpuestos" datasource="#session.dsn#">
                        	  select Ccuenta
                              	from DImpuestos imp
                    		 where Ecodigo  = #LvarEcodigoSolicitante#
                               and Icodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasFac.GrupoImpuestoAduanal#">
                               and DIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasFac.ImpuestoAduanal#">
                        </cfquery>
                        <cfif NOT rsImpuestos.RecordCount>
                        	<cfthrow message="El Grupo de impuestos #rsLineasFac.GrupoImpuestoAduanal# no tienen definido el impuesto #rsLineasFac.ImpuestoAduanal# en la empresa #rsEmpresa.Edescripcion#">
                        </cfif>
                        <cfif NOT LEN(TRIM(rsImpuestos.Ccuenta))>
                        	<cfthrow message="El impuesto #rsLineasFac.ImpuestoAduanal# del grupo aduanal #rsLineasFac.GrupoImpuestoAduanal# no tiene la cuenta Configurada">
                        </cfif>
                    	<cfset LvarCuentaTransito = rsImpuestos.Ccuenta>
                    </cfif>
                        
                    <cfinvoke component="sif.cm.Componentes.CM_Alta_DocumentosCxP" method="fnAltaDetDoc" returnvariable="ResultadoDet">
                        <cfif LEN(TRIM(rsLineasFac.Aid))>
                        	<cfinvokeargument name="Aid"					value="#rsLineasFac.Aid#">
                        </cfif>
                        <cfif LEN(TRIM(rsLineasFac.Aid))>
                            <cfinvokeargument name="Alm_Aid"				value="#rsLineasFac.Alm_Aid#">
                        </cfif>
                        	<cfinvokeargument name="IDdocumento" 			value="#LvarIDdocumento#">
                            <cfinvokeargument name="Cid"					value="#rsLineasFac.Cid#">
                            <cfinvokeargument name="DDdescripcion"			value="#rsLineasFac.DOdescripcion#">
                            <cfinvokeargument name="DDdescalterna"			value="#rsLineasFac.DOalterna#">
                            <cfinvokeargument name="CFid"					value="#rsLineasFac.CFid#">
                            <cfinvokeargument name="Dcodigo"				value="#rsLineasFac.Dcodigo#">
                            <cfinvokeargument name="DDcantidad"				value="#rsLineasFac.DDIcantidad#">
                            <cfinvokeargument name="DDpreciou"				value="#rsLineasFac.DDIpreciou#">
                            <cfinvokeargument name="DDdesclinea"			value="#rsLineasFac.DDdesclinea#">
                            <cfinvokeargument name="DDporcdesclin"			value="#rsLineasFac.DDIporcdesc#">
                            <cfinvokeargument name="DDtotallinea"			value="#rsLineasFac.DDItotallinea#">
                            <cfinvokeargument name="DDtipo"					value="#rsLineasFac.DDItipo#">
                            <cfinvokeargument name="Ccuenta"				value="#LvarCuentaTransito#">
                            <cfinvokeargument name="CFcuenta"				value="#rsLineasFac.CFcuenta#">
                            <cfinvokeargument name="Ecodigo"				value="#rsLineasFac.Ecodigo#">
                            <cfinvokeargument name="Icodigo"				value="#rsLineasFac.Icodigo#">
                            <cfinvokeargument name="BMUsucodigo"			value="#rsLineasFac.BMUsucodigo#">
                            <cfinvokeargument name="DSespecificacuenta"		value="#rsLineasFac.DSespecificacuenta#">
                            <cfinvokeargument name="DDtransito"				value="0">
                            <cfinvokeargument name="ActivarTran"			value="false">
                   </cfinvoke>
                </cfloop>
             </cfloop>
			<cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="CP_CalcularDocumento">
				<cfinvokeargument name="IDdoc" 				value="#LvarIDdocumento#">
				<cfinvokeargument name="CalcularImpuestos" 	value="true">
				<cfinvokeargument name="Ecodigo" 			value="#LvarEcodigoSolicitante#">
				<cfinvokeargument name="conexion" 			value="#session.dsn#">
			</cfinvoke>
        </cfif>
    </cfif><!--- Fin Solo padres "primerisos" pueden Pasar docs al Auxiliar de CxP --->

    
    <!--- Copiar la poliza tal cual a una nueva poliza con el nombre XXXX _1.. XXXX _2, siempre y cuando sea poliza de desalmacenaje parcial y sea el padre --->
    <cfif isdefined("rsEncabezadoPoliza") and rsEncabezadoPoliza.PermiteDesParcial eq 1 and len(trim(rsEncabezadoPoliza.EPDidpadre)) eq 0>
        <cfinvoke component="sif.cm.Componentes.CM_Alta_DocumentosCxP" method="fnGenerarPolizasParciales" returnvariable="Resultado">
            <cfinvokeargument name="formulario"  value="#Form#">
            <cfinvokeargument name="ActivarTran" value="false">
            <cfinvokeargument name="debug" 		 value="#debug#">
        </cfinvoke>
    </cfif>
        
	</cftransaction>

    <!--- *******************************************Fin de lo nuevo de CxP ******************************************************************************************** --->
    <cflocation url="polizaDesalmacenaje.cfm">
<cfelseif isdefined('form.btnRevertir')>
	<cfinvoke component="sif.Componentes.CM_PolizasDesalmacenaje" method="ReversarDesalmacenajeParcial">
    	 <cfinvokeargument name="EPDid" value="#Form.EPDid#">
    </cfinvoke>
</cfif>

<!--- Función para obtener una fórmula de cálculo de seguros --->
<cffunction name="getFormulaSeguro" returntype="query">
    <cfargument name="CMSid" type="numeric" required="true">
    <cfquery name="rs" dbtype="query">
        select * from rsFormulasSeguro
        where CMSid = #Arguments.CMSid#
    </cfquery>
    <cfreturn rs>
</cffunction>

<cflocation url="polizaDesalmacenaje.cfm">