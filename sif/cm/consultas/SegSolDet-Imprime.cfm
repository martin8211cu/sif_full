<cfif isdefined("url.ESidsolicitud") and not isdefined("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = Url.ESidsolicitud>
</cfif>
<!------ Query con los datos del encabezado de la solicitud seleccionada ------>
<cfquery name = "rsSolicitud" datasource="#session.DSN#" >
	select 	a.ESnumero,a.ESfecha,a.ESestado,a.EStotalest,a.EStipocambio,a.ESidsolicitud,
			b.CMScodigo,b.CMSnombre,
			c.CMTSdescripcion, c.id_tramite,
			d.Mnombre, a.ProcessInstanceid
	from ESolicitudCompraCM a
		
		inner join CMSolicitantes b
			on a.CMSid = b.CMSid
			and a.Ecodigo = b.Ecodigo
		inner join CMTiposSolicitud c
			on a.CMTScodigo = c.CMTScodigo
			and a.Ecodigo = c.Ecodigo
		inner join Monedas d
			on a.Mcodigo = d.Mcodigo
			and a.Ecodigo = d.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
		and a.ESidsolicitud in (#form.ESidsolicitud#)		
</cfquery>

<cfoutput>
<!------------------------- Pintado del reporte ------------------------------------>
<!----- Pintado Encabezado ----->
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0"> 
  <tr><td colspan="8" align="center" class="tituloAlterno"><strong><font size="3">#session.enombre#</font></strong></td></tr>
  <tr><td  nowrap colspan="8">&nbsp;</td></tr>
  <tr>
    <td colspan="8" align="center"><strong><font size="3">Seguimiento de Solicitudes Detallada </font></strong></td>
  </tr>
  <tr><td colspan="8" align="center"><strong><font size="2">Fecha de la Consulta:&nbsp;</font></strong><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></td></tr>
  <tr><td colspan="8" nowrap>&nbsp;</td></tr>
</table> 
</cfoutput> 

	  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	   <cfoutput query="rsSolicitud" group="ESidsolicitud">
			<cfset NumeroSol =  rsSolicitud.ESnumero>
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name = "rsOrdenes" datasource="#session.DSN#">
				select 	a.EOnumero, a.EOfecha, a.Observaciones,a.EOestado,a.EOidorden,
						b.ESidsolicitud, b.DOconsecutivo, b.DOcantidad, b.DOcantsurtida, b.DOfechaes, b.DOlinea,
						m.CMCcodigo,m.CMCnombre,
						b.Ucodigo,
						n.CFcodigo,n.CFdescripcion,
						r.Almcodigo,r.Bdescripcion,
						b.CMtipo,
						case CMtipo when 'A' then Acodigo#_Cat#'-'#_Cat#Adescripcion
									when 'S' then h.Ccodigo#_Cat#'-'#_Cat#Cdescripcion				
									when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Item
				
				from 	EOrdenCM a
					
					inner join CMCompradores m
						on a.CMCid = m.CMCid
						<!--- and a.Ecodigo = m.Ecodigo --->
						
					inner join DOrdenCM b
						on a.EOidorden = b.EOidorden
						and a.Ecodigo = b.Ecodigo
					
					<!---Articulos--->
					left outer join Articulos f
						on b.Aid=f.Aid
						 and b.Ecodigo=f.Ecodigo 	
					  
					<!---Conceptos--->
					left outer join Conceptos h
						on b.Cid=h.Cid
						<!--- and b.Ecodigo=h.Ecodigo --->
					
					<!---Activos--->
					left outer join ACategoria j
						on b.ACcodigo=j.ACcodigo
						and b.Ecodigo=j.Ecodigo
				 
					left outer join AClasificacion k
						on b.ACcodigo=k.ACcodigo
						and b.ACid=k.ACid
						and b.Ecodigo=k.Ecodigo
					
					inner join CFuncional	n
						on b.CFid = n.CFid
						and b.Ecodigo = n.Ecodigo	
					
					left outer join Almacen r
						on b.Alm_Aid = r.Aid
						and b.Ecodigo = r.Ecodigo
				
				where 	a.Ecodigo = #session.Ecodigo#		
						and b.ESidsolicitud = #rsSolicitud.ESidsolicitud#
				order by a.EOnumero, b.DOlinea 
			</cfquery>
				
			<!---Query con las cotizaciones que pertenecen a la solicitud seleccionada --->
			<cfquery name="rsCotizaciones" datasource="#session.DSN#">
				select   count(1) as cuantos
				from 	
					DSolicitudCompraCM a
				
					inner join ESolicitudCompraCM m
						on a.ESidsolicitud = m.ESidsolicitud
						and a.Ecodigo = m.Ecodigo 
				
					inner join CMLineasProceso b
						on a.DSlinea = b.DSlinea
					
					inner join CMProcesoCompra c
						on b.CMPid = c.CMPid		
						and c.CMPestado in (10,50)
				
					inner join ECotizacionesCM d
						on c.CMPid = d.CMPid
						and c.Ecodigo = d.Ecodigo
						and d.ECestado in (5,10)
					
				
					inner join DCotizacionesCM e
						on d.ECid = e.ECid
						and d.Ecodigo = e.Ecodigo
						and e.DSlinea = a.DSlinea
						
				where a.Ecodigo = #session.Ecodigo#
					and m.ESidsolicitud = #rsSolicitud.ESidsolicitud#
					and m.ESestado in (20,25,40,50)												
				<!---order by d.ECnumero--->
			</cfquery>
			
			<!--- Query para saber si la solicitud tiene alguna línea el un proceso de publicación de compra ---->
			<cfquery name="rsProcesoPublicacion" datasource="#session.DSN#">			
				select 	count(a.ESidsolicitud) as solicitud,
						count(b.ESidsolicitud) as proceso
				from DSolicitudCompraCM a
					left outer join CMLineasProceso b
						on a.DSlinea = b.DSlinea
						and a.ESidsolicitud = b.ESidsolicitud
				where a.Ecodigo = #session.Ecodigo#
					and a.ESidsolicitud = #rsSolicitud.ESidsolicitud#
			</cfquery>
            
            <cfquery name="rsDatosProcesoCompra" datasource="#session.dsn#">
				select DISTINCT
                    pc.CMPnumero, 
                    pc.CMPdescripcion, 
                    pc.CMPfechaEnvAprob, 
                    pc.CMPfechaAprob,
                    coalesce((select sum(1) 
                                    from ECotizacionesCM b 
                                  where b.CMPid = pc.CMPid 
                                    and b.ECestado in (5,10)),0) as 'Cantidad_Cot',
					pc.CMPestado,
                    (	select max( u.Usulogin)
                        from  DSolicitudCompraCM ds
                            inner join ESolicitudCompraCM es
                                    on es.ESidsolicitud = ds.ESidsolicitud
                            left outer join WfxActivity xa
                                on xa.ProcessInstanceId = es.ProcessInstanceid
                            inner join WfxActivityParticipant xap
                                on xap.ActivityInstanceId = xa.ActivityInstanceId
                            inner join Usuario u
                                on u.Usucodigo = xap.Usucodigo 
						where xap.HasTransition = 1
							and dc.CMPid = pc.CMPid
                            and ds.DSlinea = dc.DSlinea
                            and xa.FinishTime = (		select max(sxa.FinishTime)
																	from WfxActivity sxa
                                                                        inner join WfxActivityParticipant sxap
                                                                            on sxap.ActivityInstanceId = sxa.ActivityInstanceId
																	where sxa.ProcessInstanceId = m.ProcessInstanceid)) #_Cat#
																(	select max( u.Usulogin)
                                                                    from DSolicitudCompraCM ds
																		inner join ESolicitudCompraCM es
                                                                        	on es.ESidsolicitud = ds.ESidsolicitud
																		inner join Usuario u
                                                                        	on u.Usucodigo = es.Usucodigo
																		where dc.CMPid = pc.CMPid
                                                                        	and ds.DSlinea = dc.DSlinea
                                                                            and es.ProcessInstanceid is null)  as AprobadorSolicitante
               
            	from DSolicitudCompraCM a				    
                 
                    inner join ESolicitudCompraCM m
                        on a.ESidsolicitud = m.ESidsolicitud
                        and a.Ecodigo = m.Ecodigo
                   
                    inner join CMSolicitantes b
                            on m.CMSid = b.CMSid
                            and m.Ecodigo = b.Ecodigo
                    
                    inner join CMTiposSolicitud c
                            on m.CMTScodigo = c.CMTScodigo
                            and m.Ecodigo = c.Ecodigo
                   
                    inner join CMLineasProceso cl
                        on a.DSlinea = cl.DSlinea
                    
                    inner join CMProcesoCompra pc
                        on cl.CMPid = pc.CMPid		
                   
                    left Outer join DCotizacionesCM dc
                            on dc.CMPid = pc.CMPid
                            
				where a.Ecodigo =  #session.Ecodigo#
                        and a.ESidsolicitud in (#rsSolicitud.ESidsolicitud#)
            </cfquery>
              
		  <tr bgcolor="##cccccc">  
			<td nowrap width="17%" style="border-top:2px solid black; border-left:2px solid black;">
            	<strong>&nbsp;N° Solicitud:</strong> 
                
                <a href="javascript: doFormatoSC(#rsSolicitud.ESidsolicitud#);">
                	#rsSolicitud.ESnumero#&nbsp;
                </a>
                <img src="/cfmx/sif/imagenes/find.small.png" style="cursor:pointer; position: relative; bottom: -4px; left: -4px;" onclick="javascript:doConlisSol(#rsSolicitud.ESidsolicitud#, #rsSolicitud.ESestado#);"/>
            </td>
			<td nowrap width="19%" style="border-top:2px solid black;"><strong>&nbsp;Tipo:</strong> &nbsp;#rsSolicitud.CMTSdescripcion#</td>
			<td nowrap width="17%" style="border-top:2px solid black;"><strong>&nbsp;Fecha: </strong>&nbsp;#LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyy')#&nbsp;</td>
			<td nowrap style="border-top:2px solid black;"><strong>Estado:</strong>
            	<CFIF ISDEFINED('rsSolicitud.ESestado') AND LEN(TRIM(rsSolicitud.ESestado))>
                	<CFIF rsSolicitud.ESestado EQ -10>
                    	Cancelada Presupuesto
                    <CFELSEIF rsSolicitud.ESestado EQ 0>
                    	En Preparación
                    <CFELSEIF rsSolicitud.ESestado EQ 10>
                    	En Aprobación o Tramite
                    <CFELSEIF rsSolicitud.ESestado EQ 20>
                    	Aplicada Proceso de Compra
                    <CFELSEIF rsSolicitud.ESestado EQ 25>
                    	Aplicada Compra Directa
                    <CFELSEIF rsSolicitud.ESestado EQ 40>
                    	Parcialmente surtida
                    <CFELSEIF rsSolicitud.ESestado EQ 50>
                    	Totalmente surtida
                    <CFELSEIF rsSolicitud.ESestado EQ 60>
                    	Cancelada
					<CFELSE>
                    	Desconocido
                    </CFIF>
                <CFELSE>
                	Desconocido
                </CFIF>
            </td>
			<td nowrap style="border-top:2px solid black;">
				<strong>&nbsp;En publicación:</strong>
				<cfif isdefined("rsProcesoPublicacion") and rsProcesoPublicacion.RecordCount NEQ 0>
					<cfif rsProcesoPublicacion.proceso EQ rsProcesoPublicacion.solicitud>
						Si
					<cfelseif rsProcesoPublicacion.proceso GTE 1>
						Parcial
					<cfelseif rsProcesoPublicacion.proceso EQ 0>
						 No					
					</cfif>
				</cfif>			
			</td>
			<td style="border-right:2px solid black; border-top:2px solid black;">&nbsp;</td>
		  </tr>
		  
		  <tr bgcolor="##cccccc">
			<td nowrap width="17%" style="border-bottom:2px solid black; border-left:2px solid black;"><strong>&nbsp;Solicitante:</strong>&nbsp;#rsSolicitud.CMSnombre#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Total Estimado: </strong>&nbsp;#LSCurrencyFormat(rsSolicitud.EStotalest,'none')#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Moneda: </strong>&nbsp;#rsSolicitud.Mnombre#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Tipo Cambio: </strong>&nbsp;#rsSolicitud.EStipocambio#&nbsp;</td>
			<td style="border-bottom:2px solid black; border-right:2px solid black;" colspan="7">
				<strong>Cotizaciones Asociadas:</strong>
				<cfif rsOrdenes.RecordCount EQ rsCotizaciones.RecordCount >
					 Si &nbsp;
				<cfelseif rsCotizaciones.cuantos GTE 1>
					Parcial &nbsp;
				<cfelseif rsCotizaciones.cuantos EQ 0>
					No &nbsp;
				<cfelse>
					No &nbsp;
				</cfif>
			</td>
		  </tr>
		  <tr><td colspan="8">
		  
			<!---------- Pintado del Detalle ------------>
			<!--- Pintado de ordenes de compra --->
				<cfset corte = ''>
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">  
					<cfif isdefined("rsSolicitud") and len(trim(rsSolicitud.ProcessInstanceid))>
						<tr><td colspan="8">&nbsp;</td></tr>
					  <!---Hay que agregar campo en la base de datos de id_tramite  --->
						<tr class="titulolistas">
							<td colspan="8"><cfoutput>
								<cfinclude template="SegSolDet-Detalle.cfm">
						    </cfoutput></td>
						</tr>	
					</cfif>
                    <cfif rsDatosProcesoCompra.recordcount gt 0>
			  <tr><td>&nbsp;</td></tr>
              <tr><td colspan="9"><table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
              <cfloop query="rsDatosProcesoCompra">
                      <!--- Visto Bueno sobre la Cotizacion --->
                        <tr   class="titulolistas">
                            <td  width="9%"  style="border-top: 1px solid gray ; border-bottom: 1px solid gray;" align="center"><strong>Num.Proceso</strong></td>
                            <td style="border-top: 1px solid gray; border-bottom: 1px solid gray;" align="center"><strong>Descripci&oacute;n</strong></td>
                            <td  width="10%"  style="border-top: 1px solid gray; border-bottom: 1px solid gray;"align="center"><strong>Fecha envio Aprobación</strong></td>
                            <td  width="10%"   style="border-top: 1px solid gray; border-bottom: 1px solid gray;" align="center"><strong>Fecha Aprobación</strong></td>
                            <td  width="10%"  style="border-top: 1px solid gray; border-bottom: 1px solid gray;" align="center"><strong>Cotizaciones Recibidas</strong></td>
                            <td style="border-top: 1px solid gray; border-bottom: 1px solid gray;" align="center"><strong>Solicitante Aprobador</strong></td>
                            <td style="border-top: 1px solid gray; border-bottom: 1px solid gray;" align="center"><strong>Estado</strong></td>
                        </tr>
                        <tr>
                            <td align="center">
                            	<a href="javascript: verProceso('<cfoutput>#rsDatosProcesoCompra.CMPnumero#</cfoutput>')">#rsDatosProcesoCompra.CMPnumero#</a>
                                 <img src="/cfmx/sif/imagenes/find.small.png" style="cursor:pointer; position: relative; bottom: -4px; left: -4px;" onclick="javascript: verProceso('<cfoutput>#rsDatosProcesoCompra.CMPnumero#</cfoutput>');"/>
							</td>
                            <td align="left">#rsDatosProcesoCompra.CMPdescripcion#</td>
                            <td align="center">#LSDateFormat(rsDatosProcesoCompra.CMPfechaEnvAprob,'dd/mm/yyy')#</td>
                            <td align="center">#LSDateFormat(rsDatosProcesoCompra.CMPfechaAprob,'dd/mm/yyy')#</td>
                            <td align="center">#rsDatosProcesoCompra.Cantidad_Cot#</td>
                            <td align="center">#rsDatosProcesoCompra.AprobadorSolicitante#</td>
                            <td align="center">
                                <cfswitch expression="#CMPestado#">
                                    <cfcase value="0">No Publicado</cfcase>
                                    <cfcase value="10">Publicado</cfcase>
                                    <cfcase value="50">Orden Compra</cfcase>
                                    <cfcase value="79">Pediente de Aprobación Solicitante</cfcase>
                                    <cfcase value="81">Aprobado por Solicitante</cfcase>
                                    <cfcase value="83">Rechazado por Solicitante</cfcase>
                                    <cfcase value="85">Anulados</cfcase>
                                </cfswitch>	
                            </td>
                        </tr>
                 </cfloop>  
                 </table></td></tr>
            </cfif> 
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
				  <cfif rsOrdenes.RecordCount EQ 0>
					<tr><td colspan="8" align="center" style="text-align:center; border-top:1px solid black; border-bottom:1px solid black;"> ------------------- No hay Ordenes Asociadas -------------------</td></tr>
				  	<tr><td colspan="8">&nbsp;</td></tr>
				  <cfelse>		  
					  <cfloop query="rsOrdenes">
						<cfif corte neq rsOrdenes.EOnumero >
						 
						  <tr class="titulolistas">
							 <td colspan="8">
								<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
									<tr>        
										<td width="20%" class = "titulolistas"><a href="javascript: doConlis(#rsOrdenes.EOidorden#);"><strong>&nbsp;&nbsp;&nbsp;N° Orden:&nbsp;#rsOrdenes.EOnumero#</strong></a></td>
										<td width="20%" nowrap><strong>&nbsp;Fecha:</strong> &nbsp;#LSDateFormat(rsOrdenes.EOfecha,'dd/mm/yyy')#</td>
										<td valign="top"><strong>Estado</strong>: 
										<!--- Estados posibles de la Orden--->
                                        <CFIF ISDEFINED('rsOrdenes.EOestado') AND LEN(TRIM(rsOrdenes.EOestado))>
                                            <CFIF 	   rsOrdenes.EOestado EQ 0>
                                            <CFELSEIF  rsOrdenes.EOestado EQ -10>Pendiente de Aprobación Presupuestal
                                            <CFELSEIF  rsOrdenes.EOestado EQ -8>Rechazada por el aprobador
                                            <CFELSEIF  rsOrdenes.EOestado EQ -7>En proceso de firmas
                                            <CFELSEIF  rsOrdenes.EOestado EQ 0>Pendiente
                                            <CFELSEIF  rsOrdenes.EOestado EQ 5>Pendiente Vía Proceso
                                            <CFELSEIF  rsOrdenes.EOestado EQ 7>Pendiente OC Directa
                                            <CFELSEIF  rsOrdenes.EOestado EQ 8>Pendiente Vía Contrato
                                            <CFELSEIF  rsOrdenes.EOestado EQ 9>Autorizada por jefe Compras
                                            <CFELSEIF  rsOrdenes.EOestado EQ 10>Orden Aplicada
                                            <CFELSEIF  rsOrdenes.EOestado EQ 55>Orden Cancelada Parcialmente Surtida
                                            <CFELSEIF  rsOrdenes.EOestado EQ 60>Orden Cancelada
                                            <CFELSEIF  rsOrdenes.EOestado EQ 70>Orden Anulada
                                            <CFELSEIF  rsOrdenes.EOestado EQ 101>Aprobado Mutiperiodo
                                            <CFELSE>Desconocido</CFIF>
                                        <CFELSE>
                                            - No especificado -
                                        </CFIF>
                                    </td>
										<td colspan="5">&nbsp;</td>
									</tr>
									  <tr class="titulolistas">				
										<td nowrap><strong>&nbsp;&nbsp;&nbsp;Comprador:</strong>&nbsp;#trim(rsOrdenes.CMCcodigo)# - #trim(rsOrdenes.CMCnombre)#</td>			  	 
										<td width="40%" nowrap><strong>&nbsp;Observaciones:</strong> &nbsp;#rsOrdenes.Observaciones#</td>
										<td width="40%" nowrap><strong>&nbsp;Ctro Funcional:</strong> &nbsp;#trim(rsOrdenes.CFcodigo)# - #trim(rsOrdenes.CFdescripcion)#</td>
										<td nowrap colspan="5">&nbsp;</td>
									</tr>			
								 </table>
							</td>
						  </tr>	
						  </cfif> <!---Fin del corte por orden de compra ---> 
						  <!--- Detalle de la orden de compra --->
						<cfif corte neq rsOrdenes.EOnumero >						  
							<tr>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="9%" ><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Línea</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="30%" ><strong>&nbsp;Item</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="24%" ><strong>&nbsp;Almacén</strong></td>				  
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="8%"  align="right"><strong>&nbsp;Cant.Solic.</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%"  align="right"><strong>&nbsp;Unidad</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="8%" ><strong>&nbsp;Cant.Surtida</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%"  align="right"><strong>&nbsp;Unidad</strong></td>
							  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%" ><strong>&nbsp;Fecha Entrega</strong></td>
							</tr>	
						</cfif><!---Fin del corte por orden de compra del detalle--->						
						<tr onClick="javascript: goTracking('#rsOrdenes.DOlinea#');" style="cursor: pointer; " title="Ver Seguimiento de Embarque">
							<td width="9%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsOrdenes.DOconsecutivo#&nbsp;</td>
							<td width="30%" nowrap>&nbsp;#rsOrdenes.Item#&nbsp;</td>
							<td width="24%" nowrap>&nbsp;#trim(rsOrdenes.Almcodigo)# - #trim(rsOrdenes.Bdescripcion)#&nbsp;</td>
							<td align="right" width="8%">&nbsp;#rsOrdenes.DOcantidad#&nbsp;</td>
							<td align="right" width="7%">&nbsp;#rsOrdenes.Ucodigo#&nbsp;</td>
							<td align="right" width="8%">&nbsp;#rsOrdenes.DOcantsurtida#&nbsp;</td>
							<td align="right" width="7%">&nbsp;#rsOrdenes.Ucodigo#&nbsp;</td>
							<td width="7%" align="right">&nbsp;#LSDateFormat(rsOrdenes.DOfechaes,'dd/mm/yyy')#&nbsp;</td>
						</tr>				
						<cfset corte=rsOrdenes.EOnumero>
					  </cfloop> <!--- Fin del loop rsOrdenes (las ordenes de compra) --->  
					
					</cfif>	<!--- Fin del if si hay datos en rsOrdenes (hay ordenes de compra) --->
				
				</table><!--- Cierre de la tabla de las ordenes de compra --->	 
				
				<!--------- Pintado de las Cotizaciones ------------->
			  <cfset corte = ''>  
		  
			  </td>
		  </tr>   
            <tr><td>&nbsp;</td></tr>         
	   </cfoutput>
		</table><!--- Cierre de la table encabezado Solicitud---> 

<script language='javascript' type='text/JavaScript' >
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+valor,10,10,1000,550);
	}
	
	function doConlisSol(sol, estado) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?ESidsolicitud="+sol+"&ESestado="+estado,150,150,1000,550);
	}
	
	function doFormatoSC(sol) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/operacion/imprimeSolicitud.cfm?ESidsolicitud="+sol,150,150,1000,550);
	}
	function goTracking(linea) {
		location.href = "/cfmx/sif/cm/consultas/trackingLineaOrden.cfm?DOlinea="+linea;
	}
	function verProceso(proceso)
	{
		location.href = "/cfmx/sif/cm/consultas/TiposProcesosCompras-form.cfm?CMPnumero="+proceso;
	}
</script>	