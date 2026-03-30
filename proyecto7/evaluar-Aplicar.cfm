<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfparam name="params" default="">
<cfif isdefined("Form.Finalizar")>
	<!---Inserta el Encabezado de la Orden de Compra--->
	<!--- Aplicacion por Mejor Cotizacion --->
    <cfset lvarProvCorp = false>
    <!--- Verifica si esta activa la Probeduria Corporativa --->
    <cfquery name="rsProvCorp" datasource="#session.DSN#">
        select Pvalor 
        from Parametros 
        where Ecodigo=#session.Ecodigo#
        and Pcodigo=5100
    </cfquery>
    <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
    	<cfset lvarProvCorp = true>
    </cfif>
    <cfset lvarFiltroEcodigo = session.Ecodigo>
	<cfif isdefined("Form.metodo") and Form.metodo EQ 'C'>
    	<cfif lvarProvCorp>
        <!--- Obtiene la empresa de las solicitudes, se escoge la primera ya que todas las solicitudes son de una misma enpresa --->
            <cfquery name="rsEcodigo" datasource="#Session.DSN#">
                select ds.Ecodigo
                from ECotizacionesCM ec
                    inner join DCotizacionesCM dc
                        on dc.ECid = ec.ECid and dc.Ecodigo = ec.Ecodigo
                    inner join DSolicitudCompraCM ds
                        on ds.DSlinea = dc.DSlinea
                 where ec.ECid = #Session.Compras.OrdenCompra.ECid#
             </cfquery>
			<cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
            <cfif len(trim(lvarFiltroEcodigo)) eq 0>
            	<cfset lvarFiltroEcodigo = session.Ecodigo>
            </cfif>
         </cfif>
		<cftransaction>
			<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
			<cflock name="LCK_EOrdenCM#session.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
				<!--- Calculo de Consecutivo: ultimo + 1 --->
                <cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
                    select coalesce(max(EOnumero), 0) + 1 as EOnumero
                    from EOrdenCM
                    where Ecodigo = #lvarFiltroEcodigo#
                </cfquery>
                <cfquery datasource="#Session.DSN#">
                    update EOrdenCM
                       set EOnumero = EOnumero
                    where Ecodigo = #lvarFiltroEcodigo#
                      and EOnumero = #rsConsecutivoOrden.EOnumero-1#
                </cfquery>
				<!---Inserta el Encabezado de la Orden de Compra--->
                <cfif lvarProvCorp>
                    <cfquery name="rsSocioPC" datasource="#Session.DSN#">
                        select snS.SNcodigo
                        from ECotizacionesCM a
                        	inner join SNegocios snA
                            	on snA.SNcodigo = a.SNcodigo and snA.Ecodigo = a.Ecodigo
                            inner join SNegocios snS
                                on snS.SNidentificacion = snA.SNidentificacion and snS.Ecodigo = #lvarFiltroEcodigo#
                     	where a.Ecodigo = #Session.Ecodigo# and a.ECid = #Session.Compras.OrdenCompra.ECid#
                    </cfquery>
                    <cfset lvarSocioN = rsSocioPC.SNcodigo>
                    <cfif len(trim(lvarSocioN)) eq 0>
                        <cfthrow message="EOrdenCM: El Socio de Negocio no existe en la empresa solicitante, debe de importarla de la empresa Compradora">
                    </cfif>
                    <cfif lvarProvCorp>
                        <cfquery name="rsMonedaPC" datasource="#Session.DSN#">
                            select mS.Mcodigo
                            from ECotizacionesCM a
                            	inner join Monedas mA
                                	on mA.Mcodigo = a.Mcodigo
                            	inner join Monedas mS
                                	on mS.Miso4217 = mA.Miso4217 and mS.Ecodigo = #lvarFiltroEcodigo#
                            where a.Ecodigo = #Session.Ecodigo# and a.ECid = #Session.Compras.OrdenCompra.ECid#
                        </cfquery>
                        <cfset lvarMoneda = rsMonedaPC.Mcodigo>
                        <cfif len(trim(lvarMoneda)) eq 0>
                            <cfthrow message="EOrdenCM: La moneda no existe en la empresa solicitante, debe de copiarla de la empresa Compradora">
                        </cfif>
                    </cfif>
                </cfif>
				 <cfquery name="InsEOCM" datasource="#Session.DSN#">
				 	 select a.ECid, #lvarFiltroEcodigo# as Ecodigo,a.SNcodigo,a.CMCid, <cfif lvarProvCorp>#lvarMoneda#<cfelse>a.Mcodigo</cfif> as Mcodigo, a.CMIid
                    from ECotizacionesCM a
                     where a.Ecodigo = #Session.Ecodigo#
                     and a.ECid = #Session.Compras.OrdenCompra.ECid#
				 </cfquery>
                <cfquery name="insertEOrdenCM" datasource="#Session.DSN#">
                    insert into EOrdenCM (Ecodigo, EOnumero, SNcodigo, CMCid, Mcodigo, Rcodigo, CMTOcodigo, EOfecha, Observaciones, EOtc, EOrefcot, Impuesto, EOdesc, EOtotal, Usucodigo, EOfalta, CMFPid, EOplazo, EOporcanticipo, EOestado, CMPid, CMIid)
                   values(
                        #InsEOCM.Ecodigo#,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#">,
                        #InsEOCM.SNcodigo#, 
                        #InsEOCM.CMCid#, 
                        #InsEOCM.Mcodigo#, 
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.Rcodigo#" null="#Len(Trim(Form.Rcodigo)) EQ 0#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.CMTOcodigo#">,
                        <cf_dbfunction name="now">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Form.EOtc#">,
                        #InsEOCM.ECid#,
                        0.0,
                        0.0,
                        0.0 ,
                        #Session.Usucodigo#,
                        <cf_dbfunction name="now">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CMFPid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.EOplazo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.EOporcanticipo#" scale="2">,
                        5,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#InsEOCM.CMIid#" voidnull>
						)
					<cf_dbidentity1 datasource="#Session.DSN#">
                </cfquery>
                   <cf_dbidentity2 datasource="#Session.DSN#" name="insertEOrdenCM">
				<cfset params = insertEOrdenCM.identity>
			</cflock>         			

			<cfloop collection="#Session.Compras.OrdenCompra#" item="i">
				<cfif FindNoCase("DCcantidad_", i) NEQ 0 and Session.Compras.OrdenCompra[i] NEQ 0>
					<cfset linea = Mid(i, Len("DCcantidad_")+1, Len(i))>
	
					<!--- Obtener el consecutivo de la linea --->
					<cfquery name="rsConsecutivoLinea" datasource="#Session.DSN#">
						select coalesce(max(DOconsecutivo), 0) + 1 as DOconsecutivo
						from DOrdenCM
						where Ecodigo = #lvarFiltroEcodigo#
						and EOidorden = #insertEOrdenCM.identity#
					</cfquery>
                   	<cfif lvarProvCorp>
                        <cfquery name="rsUnidades" datasource="#Session.DSN#">
                        	select b.Ucodigo, ua.Udescripcion
                            from DCotizacionesCM b
                            	inner join Unidades ua
                                	on ua.Ecodigo =  b.Ecodigo and ua.Ucodigo = b.Ucodigo
                            where b.Ecodigo = #Session.Ecodigo#
                              and b.ECid = #Session.Compras.OrdenCompra.ECid#
                              and b.DCpreciou <> 0
                              and b.DSlinea = #linea#
                              and not exists(select u.Ucodigo
                                            from Unidades u
                                            where u.Ecodigo = #lvarFiltroEcodigo# and u.Ucodigo = b.Ucodigo)
                        </cfquery>
                        <cfif rsUnidades.recordcount gt 0>
                        	<cfthrow message="No se han ingresados las siguientes unidades a la empresa solicitante, U:(#ValueList(rsUnidades.Udescripcion)#)">
                        </cfif>
					</cfif>
					<cfquery name="insertDOrdenCM" datasource="#Session.DSN#">
						insert into DOrdenCM (
							Ecodigo, EOidorden, EOnumero, DOconsecutivo, 
							ESidsolicitud, DSlinea, CMtipo, Cid, Aid, Alm_Aid, 
							ACcodigo, ACid, CFid, Icodigo, Ucodigo, DClinea, 
							CFcuenta, CAid, DOdescripcion, DOalterna, DOobservaciones,							
                            DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOmontodesc, 
							DOporcdesc, DOfechaes, 
							DOgarantia, Ppais, DOfechareq, numparte,FPAEid,CFComplemento, PCGDid,DOcontrolCantidad)
						select 
							#lvarFiltroEcodigo#,
							#insertEOrdenCM.identity#,
							#rsConsecutivoOrden.EOnumero#,
							#rsConsecutivoLinea.DOconsecutivo#,
							c.ESidsolicitud,
							b.DSlinea,
							c.DStipo,
							c.Cid,
							c.Aid,
							c.Alm_Aid,
							c.ACcodigo,
							c.ACid,
							c.CFid,
							<cfif isdefined("Form.Icodigo_"&linea)>
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Evaluate('Form.Icodigo_'&linea)#">,
							<cfelse>
							b.Icodigo,
							</cfif>
							<cfif isdefined("Form.Ucodigo_"&linea)>
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Evaluate('Form.Ucodigo_'&linea)#">,
							<cfelse>
							b.Ucodigo,
							</cfif>
							b.DClinea,
							c.CFcuenta,
							(
								select min(CAid)
								from Articulos x
								where x.Aid = c.Aid
								and x.Ecodigo = c.Ecodigo
							) as CAid,
							c.DSdescripcion,
							c.DSdescalterna,
							c.DSobservacion,
							
                            <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#">,
							0.00,
							#LvarOBJ_PrecioU.enSQL_AS("b.DCpreciou")#,
							round(b.DCpreciou * <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#">,2),
							b.DCdesclin, 
							(b.DCdesclin * 100.0) / (b.DCpreciou * <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#"> * 1.0), 
							case when b.DCplazoentrega != 0 then
								<cf_dbfunction name="dateaddString" args="b.DCplazoentrega,#LSDateFormat(Now(), 'dd-mm-yyyy')#" datasource="#Session.DSN#">
							else 
								<cf_dbfunction name="dateaddString" args="0,#LSDateFormat(Now(), 'dd-mm-yyyy')#" datasource="#Session.DSN#">
							end,								
							coalesce(b.DCgarantia, 0) as DCgarantia,
							f.Ppais,
							c.DSfechareq,
							b.numparte,
							c.FPAEid,
							c.CFComplemento,
							c.PCGDid,
							c.DScontrolCantidad
						from DCotizacionesCM b
						  inner join  DSolicitudCompraCM c  
						      on  b.DSlinea = c.DSlinea
						  inner join ESolicitudCompraCM d
						      on c.Ecodigo = d.Ecodigo
						      and c.ESidsolicitud = d.ESidsolicitud
						  inner join ECotizacionesCM e
						      on b.Ecodigo = e.Ecodigo  
   						      and b.ECid = e.ECid
						   inner join SNegocios f
						   	  on e.Ecodigo = f.Ecodigo
						      and e.SNcodigo = f.SNcodigo 
						   left outer join  PCGDplanCompras g
						      on c.PCGDid = g.PCGDid
							  and b.Ecodigo = #Session.Ecodigo#
						where b.Ecodigo = #Session.Ecodigo#
						  and b.ECid = #Session.Compras.OrdenCompra.ECid#
						  and b.DCpreciou <> 0
						  and b.DSlinea = #linea#						
					</cfquery>
				</cfif>
			</cfloop>
			
			<!--- ACTUALIZACION DE TOTALES --->
			<cfquery name="rsSumDetalle" datasource="#Session.DSN#">			    
				select sum((((b.DOtotal-b.DOmontodesc) * d.Iporcentaje)) / 100.0) as TotImpuestoCD,
				       sum((b.DOtotal * d.Iporcentaje) / 100.0) as TotImpuestoSD, 
					   sum(c.DCdesclin) as TotDescuento,
                       sum( b.DOtotal - b.DOmontodesc+((((b.DOtotal-b.DOmontodesc) * d.Iporcentaje)) / 100.0)) as TotalCD,
                       sum( b.DOtotal - b.DOmontodesc+((b.DOtotal * d.Iporcentaje) / 100.0)) as TotalSD
					  
				from EOrdenCM a, DOrdenCM b, DCotizacionesCM c, Impuestos d
				where a.Ecodigo = #lvarFiltroEcodigo#
				and a.EOidorden = #insertEOrdenCM.identity#
				and a.Ecodigo = b.Ecodigo
				and a.EOidorden = b.EOidorden
				and c.Ecodigo = #session.Ecodigo#
				and a.EOrefcot = c.ECid
				and b.DSlinea = c.DSlinea
				and d.Ecodigo = #lvarFiltroEcodigo#
				and b.Icodigo = d.Icodigo				
			</cfquery>
			
			<!--- Actualizar Campos del Encabezado de la Orden de Compra sin Descuento--->
            <cfquery name="updateEOrdenCM" datasource="#Session.DSN#">			   
                update EOrdenCM set
                    Impuesto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSumDetalle.TotImpuestoCD#" scale="2">,
                    EOdesc = <cfqueryparam cfsqltype="cf_sql_money" value="#rsSumDetalle.TotDescuento#">,
                    EOtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSumDetalle.TotalCD#" scale="2">
                where Ecodigo = #lvarFiltroEcodigo#
                and EOidorden = #insertEOrdenCM.identity#
            </cfquery>
			
			<!--- Actualizacion del Proceso de Compra --->
			<cfquery name="updateCMProcesoCompra" datasource="#Session.DSN#">
				update CMProcesoCompra set
					CMPestado = 50
				where Ecodigo = #Session.Ecodigo#
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			</cfquery>
		
		</cftransaction>
	
		<!--- Aplicacion por Mejores Lineas de Cotizacion --->
		<cfelseif isdefined("Form.metodo") and Form.metodo EQ 'L'>
			<cfset index = 1>
			<cfset EOidordenArray = ArrayNew(1)>
			<cfset EOnumeroArray = ArrayNew(1)>
            <cfif lvarProvCorp>
			<!--- Obtiene la empresa de las solicitudes, se escoge la primera ya que todas las solicitudes son de una misma enpresa --->
                <cfquery name="rsEcodigo" datasource="#Session.DSN#">
                    select ds.Ecodigo
                    from CMProcesoCompra pc
                        inner join CMLineasProceso lp
                            on lp.CMPid = pc.CMPid
                        inner join DSolicitudCompraCM ds
                            on ds.DSlinea = lp.DSlinea
                     where pc.CMPid = #Form.CMPid#
                 </cfquery>
                <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
                <cfif len(trim(lvarFiltroEcodigo)) eq 0>
                    <cfset lvarFiltroEcodigo = session.Ecodigo>
                </cfif>
             </cfif>
			<cftransaction>
				<!--- INSERCION DE ENCABEZADOS DE ORDENES DE COMPRA --->
				<!--- Mientras existan ordenes con combinación de proveedores y moneda distintos --->
				<cfloop condition="isdefined('Form.SNcodigo_'&index)">
					<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
                    <cflock name="LCK_EOrdenCM#session.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
                        <!--- Calculo de Consecutivo: ultimo + 1 --->
                        <cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
                            select coalesce(max(EOnumero), 0) + 1 as EOnumero
                              from EOrdenCM
                             where Ecodigo = #lvarFiltroEcodigo#
                        </cfquery>
                        <cfquery datasource="#Session.DSN#">
                            update EOrdenCM
                               set EOnumero = EOnumero
                            where Ecodigo = #lvarFiltroEcodigo#
                              and EOnumero = #rsConsecutivoOrden.EOnumero-1#
                        </cfquery>

                        <!--- Guardar el numero del encabezado de Orden de Compra --->
                        <cfset EOnumeroArray[index] = rsConsecutivoOrden.EOnumero>
                        <cfset lvarSocioN = Evaluate('Form.SNcodigo_'&index)>
                        <cfset lvarMoneda = Evaluate('Form.Mcodigo_'&index)>
    					<cfif lvarProvCorp>
                        	<cfquery name="rsSocioN" datasource="#Session.DSN#">
                                select snS.SNcodigo
                                from SNegocios snA
                                	inner join SNegocios snS
                                    	on snS.SNidentificacion = snA.SNidentificacion and snS.Ecodigo = #lvarFiltroEcodigo#
                                where snA.Ecodigo = #session.Ecodigo#
                                	and snA.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.SNcodigo_'&index)#">
                            </cfquery>
                            <cfset lvarSocioN = rsSocioN.SNcodigo>
                            <cfif len(trim(lvarSocioN)) eq 0>
                            	<cfthrow message="EOrdenCM: El Socio de Negocio no existe en la empresa solicitante, debe de importarla de la empresa Compradora">
                            </cfif>
                            <cfif lvarProvCorp>
                            	<cfquery name="rsMoneda" datasource="#Session.DSN#">
                                    select mS.Mcodigo
                                    from Monedas mA
                                    inner join Monedas mS
                                        on mS.Miso4217 = mA.Miso4217 and mS.Ecodigo = #lvarFiltroEcodigo#
                                  	where mA.Ecodigo = #session.Ecodigo# and mA.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMoneda#">
                              	</cfquery>
                                <cfset lvarMoneda = rsMoneda.Mcodigo>
							 	<cfif len(trim(lvarMoneda)) eq 0>
                                    <cfthrow message="EOrdenCM: La moneda no existe en la empresa solicitante, debe de copiarla de la empresa Compradora">
                                </cfif>
                            </cfif>
                        </cfif>
                        <cfquery name="insertEOrdenCM" datasource="#Session.DSN#">
                            insert into EOrdenCM (Ecodigo, EOnumero, SNcodigo, CMCid, Mcodigo, Rcodigo, CMTOcodigo, EOfecha, Observaciones, EOtc, EOrefcot, Impuesto, EOdesc, EOtotal, Usucodigo, EOfalta, CMFPid, EOplazo, EOporcanticipo, EOestado, CMPid, CMIid)
                            values (
                                #lvarFiltroEcodigo#,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarSocioN#">, 
                                #Session.Compras.Comprador#, 
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMoneda#">, 
                                <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.Rcodigo_'&index)#" null="#Len(Trim(Evaluate('Form.Rcodigo_'&index))) EQ 0#">,
                                <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.CMTOcodigo_'&index)#">,
                                <cf_dbfunction name="now">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.Observaciones_'&index)#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.EOtc_'&index)#">,
                                null,
                                0.0,
                                0.0,
                                0.0,
                                #Session.Usucodigo#,
                                <cf_dbfunction name="now">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.CMFPid_'&index)#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.EOplazo_'&index)#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.EOporcanticipo_'&index)#" scale="2">,
                                5,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Evaluate('Form.CMIid_'&index)#" voidnull>
                            )
                            <cf_dbidentity1 datasource="#Session.DSN#">
                        </cfquery>
                        <cf_dbidentity2 datasource="#Session.DSN#" name="insertEOrdenCM">
                    </cflock>

                    <!--- Guardar la llave del encabezado de Orden de Compra --->
                    <cfset EOidordenArray[index] = insertEOrdenCM.identity>
                    <cfset params = insertEOrdenCM.identity>
					<cfset index = index + 1>
				</cfloop>		
				
				<cfset params = arraytolist(EOidordenArray)>
			
				<!--- INSERCION DE LINEAS DE ORDENES DE COMPRA --->
				<cfloop collection="#Session.Compras.OrdenCompra#" item="i">
					<cfif FindNoCase("DCcantidad_", i) NEQ 0 and Session.Compras.OrdenCompra[i] NEQ 0>
						<cfset linea = Mid(i, Len("DCcantidad_")+1, Len(i))>
	
						<!--- Obtener el codigo de Orden de Compra al que pertenece una linea --->
						<cfif isdefined("Form.linea_"&linea)>
							<cfset IndexOrder = Evaluate("Form.linea_"&linea)>
					
							<!--- Obtener el consecutivo de la linea --->
							<cfquery name="rsConsecutivoLinea" datasource="#Session.DSN#">
								select coalesce(max(DOconsecutivo), 0) + 1 as DOconsecutivo
								from DOrdenCM
								where Ecodigo = #lvarFiltroEcodigo#
								and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EOidordenArray[IndexOrder]#">
							</cfquery>
                            <cfif lvarProvCorp>
                                <cfquery name="rsSocioN" datasource="#Session.DSN#">
                                    select snS.SNcodigo
                                    from DCotizacionesCM dc
                                        inner join ECotizacionesCM ec
                                            on ec.Ecodigo = dc.Ecodigo and ec.ECid = dc.ECid
                                        inner join SNegocios sn
                                            on sn.Ecodigo = ec.Ecodigo and sn.SNcodigo = ec.SNcodigo
                                       	inner join SNegocios snS
                                          	on snS.SNidentificacion = sn.SNidentificacion and snS.Ecodigo = #lvarFiltroEcodigo#
                                    where dc.Ecodigo = #Session.Ecodigo#
                                      and dc.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ECid_'&linea)#"> and dc.DSlinea = #linea#
                                </cfquery>
                                <cfif len(trim(rsSocioN.SNcodigo)) eq 0>
                               		<cfthrow message="DOrdenCM: El Socio de Negocio no existe en la empresa solicitante, debe de importace de la empresa Compradora">
                                </cfif>
                            </cfif>
							<cfquery name="insertDOrdenCM" datasource="#Session.DSN#">
								insert into DOrdenCM (Ecodigo, EOidorden, EOnumero, DOconsecutivo, ESidsolicitud, DSlinea, CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, CFid, Icodigo, Ucodigo, DClinea, CFcuenta, CAid, DOdescripcion, DOalterna, DOobservaciones, 
                                		DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOmontodesc, DOporcdesc, DOfechaes, DOgarantia, Ppais, DOfechareq, DOrefcot, numparte,PCGDid,FPAEid,
									CFComplemento)
								select 
									c.Ecodigo,
									#EOidordenArray[IndexOrder]#,
									#EOnumeroArray[IndexOrder]#,
									#rsConsecutivoLinea.DOconsecutivo#,
									c.ESidsolicitud,
									b.DSlinea,
									c.DStipo,
									c.Cid,
									c.Aid,
									c.Alm_Aid,
									c.ACcodigo,
									c.ACid,
									c.CFid,
									<cfif isdefined("Form.Icodigo_"&linea)>
									<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Evaluate('Form.Icodigo_'&linea)#">,
									<cfelse>
									b.Icodigo,
									</cfif>
									<cfif isdefined("Form.Ucodigo_"&linea)>
									<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Evaluate('Form.Ucodigo_'&linea)#">,
									<cfelse>
									b.Ucodigo,
									</cfif>
									b.DClinea,
									c.CFcuenta,
									(select min(CAid)
									from Articulos x
									where x.Aid = c.Aid
									and x.Ecodigo = c.Ecodigo
									) as CAid,
									c.DSdescripcion,
									c.DSdescalterna,
									c.DSobservacion,
									
                                    <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#">,
									0.00,
									#LvarOBJ_PrecioU.enSQL_AS("b.DCpreciou")#,
									b.DCpreciou * <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#">,
									b.DCdesclin, 
									(b.DCdesclin * 100.0) / (b.DCpreciou * <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&linea)#"> * 1.0), 
									<cf_dbfunction name="dateaddString" args="b.DCplazoentrega,#LSDateFormat(Now(), 'dd-mm-yyyy')#" datasource="#Session.DSN#">,
									b.DCgarantia,
									<cfif lvarProvCorp>snS.Ppais<cfelse>f.Ppais</cfif>,
									c.DSfechareq,
									e.ECid,
									b.numparte,
									c.PCGDid,
									c.FPAEid,
									c.CFComplemento
								from DCotizacionesCM b
                                	inner join DSolicitudCompraCM c
                                    	on b.DSlinea = c.DSlinea
                                   	inner join ESolicitudCompraCM d
                                    	on c.Ecodigo = d.Ecodigo and c.ESidsolicitud = d.ESidsolicitud
                                   	inner join ECotizacionesCM e
                                    	on b.Ecodigo = e.Ecodigo and b.ECid = e.ECid
                                   	inner join SNegocios f
                                    	on e.Ecodigo = f.Ecodigo and e.SNcodigo = f.SNcodigo
                                       	<cfif lvarProvCorp>
                                      	inner join SNegocios snS
                                        	on snS.SNidentificacion = f.SNidentificacion and snS.Ecodigo = #lvarFiltroEcodigo#
                            			</cfif>
								where b.Ecodigo = #Session.Ecodigo#
								  and b.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ECid_'&linea)#"> and b.DSlinea = #linea#
							</cfquery>
						</cfif> <!--- If de ("Form.linea_"&linea) --->
					</cfif> <!--- FindNoCase("DCcantidad_", i) NEQ 0 and Session.Compras.OrdenCompra[i] NEQ 0 --->
				</cfloop>			

				<cfloop from="1" to="#ArrayLen(EOidordenArray)#" index="IndexOrder">
					<cfquery name="rsSumDetalle" datasource="#Session.DSN#">			
						select sum((((b.DOtotal-b.DOmontodesc) * d.Iporcentaje)) / 100.0) as TotImpuestoCD,
							   sum((b.DOtotal * d.Iporcentaje) / 100.0) as TotImpuestoSD, 
							   sum(c.DCdesclin) as TotDescuento,
												   sum( b.DOtotal - b.DOmontodesc+((((b.DOtotal-b.DOmontodesc) * d.Iporcentaje)) / 100.0)) as TotalCD,
												   sum( b.DOtotal - b.DOmontodesc+((b.DOtotal * d.Iporcentaje) / 100.0)) as TotalSD
						from EOrdenCM a
                        	inner join DOrdenCM b 
                            	on a.Ecodigo = b.Ecodigo and a.EOidorden = b.EOidorden
                            inner join DCotizacionesCM c 
                            	on b.DClinea = c.DClinea and b.DSlinea = c.DSlinea
                          	inner join Impuestos d
                            	on b.Ecodigo = d.Ecodigo and b.Icodigo = d.Icodigo	
						where a.Ecodigo = #lvarFiltroEcodigo#
						and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EOidordenArray[IndexOrder]#">										
					</cfquery>
					<!--- Actualizar Campos del Encabezado de la Orden de Compra sin Descuento--->
                    <cfquery name="updateEOrdenCM" datasource="#Session.DSN#">			   
                        update EOrdenCM set
                            Impuesto    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" voidnull value="#rsSumDetalle.TotImpuestoCD#" scale="2">,
                            EOdesc      = <cf_jdbcquery_param cfsqltype="cf_sql_money"   voidnull value="#rsSumDetalle.TotDescuento#">,
                            EOtotal     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" voidnull value="#rsSumDetalle.TotalCD#" scale="2">
                        where EOidorden = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" voidnull value="#EOidordenArray[IndexOrder]#">
                    </cfquery>
				</cfloop>			
					
				<!--- Actualizacion del Proceso de Compra --->
				<cfquery name="updateCMProcesoCompra" datasource="#Session.DSN#">
					update CMProcesoCompra set
						CMPestado = 50
					where Ecodigo = #Session.Ecodigo#
					and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				</cfquery>
				
				<!--- </cftransaction> --->
			<!--- </cfif> If de rsExiste.RecordCount --->
		</cftransaction>
	</cfif> <!--- isdefined("Form.metodo") and Form.metodo EQ 'L' --->
<cfelseif isdefined('form.AprobarS')>
	<cfif isdefined('Session.Compras.ProcesoCompra.CMPid') and len(trim(Session.Compras.ProcesoCompra.CMPid))>
    	<cfset lvarCMPid = Session.Compras.ProcesoCompra.CMPid>
   	<cfelse>
    	<cfset lvarCMPid = form.CMPid>
    </cfif>
    <cf_dbfunction name="to_char" args="de.DEid" isInteger="true" returnvariable="toCharDEid">
    <cf_dbfunction name="to_char" args="sde.DEid" isInteger="true" returnvariable="toCharsDEid">
    <cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
    <cfquery name="rsSolicitante" datasource="#session.DSN#">
       	select distinct 
           	case when de.DEnombre is not null then
           		de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1 #_Cat# ' ' #_Cat# de.DEapellido2
           	when dpc.Pnombre is not null then  
           		dpc.Pnombre #_Cat# ' ' #_Cat# dpc.Papellido1 #_Cat# ' ' #_Cat# dpc.Papellido2
          	when sde.DEnombre is not null then  
           		sde.DEnombre #_Cat# ' ' #_Cat#  sde.DEapellido1 #_Cat# ' ' #_Cat# sde.DEapellido2
           	when dpc1.Pnombre is not null then  
           		dpc1.Pnombre #_Cat# ' ' #_Cat# dpc1.Papellido1 #_Cat# ' ' #_Cat# dpc1.Papellido2
           	else
            	'-'
            end as Nombre,
           coalesce(de.DEemail, dpc.Pemail1, dpc.Pemail2, sde.DEemail, dpc1.Pemail1, dpc1.Pemail2) as Email1
        from CMProcesoCompra pc
            inner join CMLineasProceso lp
                on lp.CMPid = pc.CMPid
            inner join ESolicitudCompraCM sc
                on sc.ESidsolicitud = lp.ESidsolicitud
            left outer join WfxActivity xa
                inner join WfxActivityParticipant xap
                    inner join UsuarioReferencia ur
                        left outer join DatosEmpleado de
                            on #toCharDEid# = ur.llave
                        inner join Usuario uc
                            left outer join DatosPersonales dpc
                                on dpc.datos_personales = uc.datos_personales
                            on uc.Usucodigo = ur.Usucodigo
                        on ur.Usucodigo  = xap.Usucodigo and ur.Ecodigo = #session.EcodigoSDC# and ur.STabla = 'DatosEmpleado'
                    on xap.ActivityInstanceId = xa.ActivityInstanceId and xap.HasTransition = 1
                on xa.ProcessInstanceId = sc.ProcessInstanceid 
                  and xa.FinishTime = (select max(sxa.FinishTime)
                        from WfxActivity sxa
                            inner join WfxActivityParticipant sxap
                                on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                        where sxa.ProcessInstanceId = sc.ProcessInstanceid)
            left outer join UsuarioReferencia sur
                on sur.Usucodigo  = sc.Usucodigo and sur.Ecodigo = #session.EcodigoSDC# and sur.STabla = 'DatosEmpleado'
            left outer join DatosEmpleado sde
            	on #toCharsDEid# = sur.llave
          	left outer join Usuario uc1
                left outer join DatosPersonales dpc1
                    on dpc1.datos_personales = uc1.datos_personales
                on uc1.Usucodigo = sc.Usucodigo
        where pc.Ecodigo = #session.Ecodigo#
        and pc.CMPestado in (0,10)
        and pc.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarCMPid#">
   	</cfquery>
    <cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
        select CMPid, CMPdescripcion, CMPnumero
        from CMProcesoCompra
        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarCMPid#">
        and Ecodigo = #Session.Ecodigo#
    </cfquery>
    <cftransaction>
        <cfquery name="updProceso" datasource="#Session.DSN#">
            update CMProcesoCompra
            set CMPestado = 79 <!--- Buscar un estado, por el momento este es temporal --->
            where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarCMPid#">
            and Ecodigo = #Session.Ecodigo#
        </cfquery>
        <cfloop query="rsSolicitante">
            <cfif len(trim(rsSolicitante.Email1))>
                <cfinclude template="../sif/cm/operacion/compraProceso-correo.cfm">
                <cfset _mailBody = mailBodyCotizacion(rsSolicitante.Nombre)>
                <cfquery datasource="#Session.DSN#">
                    insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                    values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsSolicitante.Email1#">,
                             'Iniciar la Aprobación de Cotizaciones(Solicitante)',
                             <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                </cfquery>
            </cfif>
        </cfloop>
    </cftransaction>
<cfelseif isdefined('url.btnAprobar')>
    <cfset form.CMPid = url.chk>
	<cfset lvarProvCorp = false>
	<cfset lvarFiltroEcodigo = session.Ecodigo>
    <!--- Verifica si esta activa la Proveeeduria Corporativa --->
    <cfquery name="rsEmpresaProv" datasource="#session.DSN#">
        select EPCempresaAdmin
        from DProveduriaCorporativa dpc
            inner join EProveduriaCorporativa epc
                on epc.EPCid = dpc.EPCid
        where dpc.DPCecodigo = #session.Ecodigo#
    </cfquery>
    <cfif len(trim(rsEmpresaProv.EPCempresaAdmin))>
        <cfquery name="rsProvCorp" datasource="#session.DSN#">
            select Pvalor 
            from Parametros 
            where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
            and Pcodigo=5100
        </cfquery>
        <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
            <cfset lvarFiltroEcodigo = rsEmpresaProv.EPCempresaAdmin>
            <cfset lvarProvCorp = true>
        </cfif>
    </cfif>
    <cf_dbfunction name="to_char" args="de.DEid" isInteger="true" returnvariable="toCharDEid">
    <cf_dbfunction name="to_char" args="sde.DEid" isInteger="true" returnvariable="toCharsDEid">
    <cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
    <cfquery name="rsCompradores" datasource="#session.DSN#">
        select distinct 
        	case when dec.DEnombre is not null then
           		dec.DEnombre #_Cat# ' ' #_Cat# dec.DEapellido1 #_Cat# ' ' #_Cat# dec.DEapellido2
           	when dpc.Pnombre is not null then  
           		dpc.Pnombre #_Cat# ' ' #_Cat# dpc.Papellido1 #_Cat# ' ' #_Cat# dpc.Papellido2
           	else
            	'-'
            end as Nombre,
			coalesce(dec.DEemail, dpc.Pemail1, dpc.Pemail2) as Email
        from CMProcesoCompra pc
            inner join CMLineasProceso lp
                on lp.CMPid = pc.CMPid
            inner join ESolicitudCompraCM sc
                on sc.ESidsolicitud = lp.ESidsolicitud
            left outer join CMCompradores cm
                left outer join DatosEmpleado dec
                    on dec.DEid = cm.DEid
                inner join Usuario uc
                    left outer join DatosPersonales dpc
                        on dpc.datos_personales = uc.datos_personales
                    on uc.Usucodigo = cm.Usucodigo
            	on cm.CMCid = sc.CMCid
        where pc.Ecodigo = #lvarFiltroEcodigo#
        and pc.CMPestado = 79
        and pc.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
   	</cfquery>
    <cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
        select CMPid, CMPdescripcion, CMPnumero
        from CMProcesoCompra
        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
        and Ecodigo = #lvarFiltroEcodigo#
    </cfquery>
    <cftransaction>
        <cfquery name="updProceso" datasource="#Session.DSN#">
            update CMProcesoCompra
            set CMPestado = 81 <!--- Buscar un estado, por el momento este es temporal --->
            where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
            and Ecodigo = #lvarFiltroEcodigo#
        </cfquery>
        <cfloop query="rsCompradores">
            <cfif len(trim(rsCompradores.Email))>
                <cfinclude template="../sif/cm/operacion/compraProceso-correo.cfm">
                <cfset _mailBody = mailBodyAprobacionCotizacion(rsCompradores.Nombre)>
                <cfquery datasource="#Session.DSN#">
                    insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                    values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsCompradores.Email#">,
                             'Finaliza Aprobación de Cotizaciones(Solicitante)',
                             <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                </cfquery>
            </cfif>
        </cfloop>
    </cftransaction>
 <cfelseif isdefined('url.btnRechazar')>
	<cfset form.CMPid = url.chk>
    <cfset form.CMPjustificacionRechazo = url.CMPjustificacionRechazo>
	<cfset lvarProvCorp = false> 
	<cfset lvarFiltroEcodigo = session.Ecodigo>
    <!--- Verifica si esta activa la Probeduria Corporativa --->
    <cfquery name="rsEmpresaProv" datasource="#session.DSN#">
        select EPCempresaAdmin
        from DProveduriaCorporativa dpc
            inner join EProveduriaCorporativa epc
                on epc.EPCid = dpc.EPCid
        where dpc.DPCecodigo = #session.Ecodigo#
    </cfquery>
    <cfif len(trim(rsEmpresaProv.EPCempresaAdmin))>
        <cfquery name="rsProvCorp" datasource="#session.DSN#">
            select Pvalor 
            from Parametros 
            where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
            and Pcodigo=5100
        </cfquery>
        <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
            <cfset lvarFiltroEcodigo = rsEmpresaProv.EPCempresaAdmin>
            <cfset lvarProvCorp = true>
        </cfif>
    </cfif>
    <cfquery name="rsCompradores" datasource="#session.DSN#">
        select distinct dec.DEnombre, dec.DEapellido1, dec.DEapellido2 as Nombre1, dpc.Pnombre, dpc.Papellido1, dpc.Papellido2 as Nombre2, coalesce(dec.DEemail, dpc.Pemail1, dpc.Pemail2) as Email1
        from CMProcesoCompra pc
            inner join CMLineasProceso lp
                on lp.CMPid = pc.CMPid
            inner join ESolicitudCompraCM sc
                on sc.ESidsolicitud = lp.ESidsolicitud
            left outer join CMCompradores cm
                left outer join DatosEmpleado dec
                    on dec.DEid = cm.DEid
                inner join Usuario uc
                    left outer join DatosPersonales dpc
                        on dpc.datos_personales = uc.datos_personales
                    on uc.Usucodigo = cm.Usucodigo
            	on cm.CMCid = sc.CMCid
        where pc.Ecodigo = #lvarFiltroEcodigo#
        and pc.CMPestado in (0,10)
        and pc.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
   	</cfquery>
    <cfquery name="rsDatosProcesoEncabezado" datasource="#Session.DSN#">
        select CMPid, CMPdescripcion, CMPnumero
        from CMProcesoCompra
        where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
        and Ecodigo = #lvarFiltroEcodigo#
    </cfquery>
    <cftransaction>
    	<cftry>
            <cfquery name="updProceso" datasource="#Session.DSN#">
                update CMProcesoCompra set
                	CMPestado = 83 <!--- Buscar un estado, por el momento este es temporal --->
                	,CMPjustificacionRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMPjustificacionRechazo#">
                where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
                and Ecodigo = #lvarFiltroEcodigo#
            </cfquery>
            <cfloop query="rsCompradores">
                <cfif len(trim(rsCompradores.Email1))>
                    <cfinclude template="../sif/cm/operacion/compraProceso-correo.cfm">
                    <cfset lvarNombre = rsCompradores.Nombre1>
					<cfif len(trim(rsCompradores.Nombre1)) eq 0>
                        <cfset lvarNombre = rsCompradores.Nombre2>	
                    </cfif>
                    <cfset _mailBody = mailBodyRechazarCotizacion(lvarNombre)>
                    <cf_jdbcquery_open datasource="asp" update="yes">
                        insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                        values ( <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsCompradores.Email1#">,
                                 'Rechazo Cotizaciones por el Solicitante',
                                 <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#_mailBody#">, 1)
                    </cf_jdbcquery_open>
                </cfif>
            </cfloop>
    	<cfcatch type="any">
       	 	<cftransaction action="rollback">
        	<cf_jdbcquery_close>
        </cfcatch>
        </cftry>
        <cf_jdbcquery_close>
    </cftransaction>
</cfif>		

<!--- ACTUALIZACION DE TOTALES version que no consideraba parametros--->

<cfset StructDelete(Session.Compras, "OrdenCompra")>

<cfoutput>
<cfif isdefined('form.AprobarS')>
	<form action="../sif/cm/operacion/evaluarCotizaciones.cfm" method="post" name="sql"></form>
<cfelseif isdefined('url.btnAprobar') or isdefined('url.btnRechazar')>
	<form action="../proyecto7/cotizaciones.cfm" method="post" name="sql"></form>
</cfif>
</cfoutput>

<html>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
