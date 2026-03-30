<CF_NAVEGACION NAME="FechaInicial">
<CF_NAVEGACION NAME="FechaFinal">
<CF_NAVEGACION NAME="EOnumero1">
<CF_NAVEGACION NAME="EOnumero2">
<CF_NAVEGACION NAME="Ccuenta">
<CF_NAVEGACION NAME="AgruparTotales">
<CF_NAVEGACION NAME="Usucodigo">
<CF_NAVEGACION NAME="SNcodigo1">
<CF_NAVEGACION NAME="ETidtracking_move1">
<CF_NAVEGACION NAME="EPDid">
<CF_NAVEGACION NAME="NumeroAsiento">
<CF_NAVEGACION NAME="ColumnasAdicionales">

<!--- Verifica que la orden inicial sea menor que la final, sino las intercambia --->
<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
	<cfif EOnumero1 gt EOnumero2>
		<cfset tmp = form.EOnumero1>
		<cfset form.EOnumero1 = form.EOnumero2>
		<cfset form.EOnumero2 = tmp>
	</cfif>
</cfif>

<!--- Obtiene la descripción de la cuenta seleccionada --->
<cfquery name="rsAuxiliarTransito" datasource="#session.dsn#">
	select cc.Cdescripcion
	from CContables cc
	<cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
    where cc.Ccuenta = <cfqueryparam value="#form.Ccuenta#" cfsqltype="cf_sql_numeric">
    <cfelse>
    where 1 = 2
    </cfif>
</cfquery>

<!---Inicializar variables---->
<cfset vnTotalAnterior = 0>	<!----Variable numerica con el total anterior(Aplica solo cuando hay especificada una fecha inicial)---->
<cfset vnSaldoActual   = 0>	<!----Variable numerica con el saldo actual (Toma el cuenta el rango de fechas seleccionado)---->
<cfset vnDebitos       = 0>	<!----Variable con los debitos---->
<cfset vnCreditos      = 0>	<!----Variable con los creditos---->

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfsavecontent variable="LvarCalculoMonto">
			<cfif isdefined("form.AgruparTotales")>
				sum(case when g.PermiteDesParcial = 1 and a.TipoMovimiento = 7 then coalesce(dpd.DPseguropropio,0)
                	else coalesce(a.DTmonto,0) * coalesce(a.tipocambio,0) end) 
			<cfelse>
				case when g.PermiteDesParcial = 1 and a.TipoMovimiento = 7 then coalesce(dpd.DPseguropropio,0)
                	else coalesce(a.DTmonto,0) * coalesce(a.tipocambio,0) end 
			</cfif>
			<cfif isdefined('form.NoImpRecurp')>
            	<cfif isdefined("form.AgruparTotales")>
					  +<!---Sumatoria del Impuesto recuperable de la poliza--->
					 sum(CASE WHEN a.TipoMovimiento = 8 THEN 
								ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
											   from CMDetalleTransito dt
											 where dt.EPDid          = a.EPDid
											  and dt.DPDlinea        = dpd.DPDlinea
											   and dt.TipoMovimiento = 6),0))
							  ELSE 0 END)
					
				+<!---Sumatoria del Impuesto Recuperable porrateado de la poliza padre si lo tiene
						ImpuestoRecuperable poliza Padre * Porcentaje de prorrateo correspondiente a la poliza--->
				sum(CASE WHEN a.TipoMovimiento = 8 THEN       
					ABS(coalesce((select (coalesce(a2.DTmonto,0) * coalesce(a2.tipocambio,0))*(dpd.DPDcantidad / g.EPDpesobruto)
								
								from CMDetalleTransito a2
									LEFT OUTER JOIN DPolizaDesalmacenaje dpd2
										ON dpd2.DPDlinea = a2.DPDlinea
						
									left outer join EPolizaDesalmacenaje g2
										on a2.EPDid = g2.EPDid	
										and a2.Ecodigo = g2.Ecodigo
						
								where g2.EPDid = g.EPDidpadre
								and a2.TipoMovimiento = 6
								),0))
					else 0 end)		
					  
                <cfelse>
                +<!---Sumatoria del Impuesto recuperable de la poliza--->
					 CASE WHEN a.TipoMovimiento = 8 THEN 
								ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
											   from CMDetalleTransito dt
											 where dt.EPDid          = a.EPDid
											  and dt.DPDlinea        = dpd.DPDlinea
											   and dt.TipoMovimiento = 6),0))
							  ELSE 0 END
				+<!---Sumatoria del Impuesto Recuperable porrateado de la poliza padre si lo tiene
						ImpuestoRecuperable poliza Padre * Porcentaje de prorrateo correspondiente a la poliza--->
				CASE WHEN a.TipoMovimiento = 8 THEN       
					ABS(coalesce((select sum(coalesce(a2.DTmonto,0) * coalesce(a2.tipocambio,0))
												* case when g.EPDpesobruto = 0 then 0 else (dpd.DPDcantidad / g.EPDpesobruto) end
								
								from CMDetalleTransito a2
									LEFT OUTER JOIN DPolizaDesalmacenaje dpd2
										ON dpd2.DPDlinea = a2.DPDlinea
						
									left outer join EPolizaDesalmacenaje g2
										on a2.EPDid = g2.EPDid	
										and a2.Ecodigo = g2.Ecodigo
						
								where g2.EPDid = g.EPDidpadre
								and a2.TipoMovimiento = 6
								),0))
					else 0 end					
                </cfif>
            </cfif>
			<!---                  E X C L U S I O N    D E L    S E G U R O   P R O P I O				--->
			<!---		(Solo se realiza para los debitos, los costos se mantienen con el seguro)--->
             <!---
			 <cfif isdefined('form.NoSeguroPropio')>
             	<cfif isdefined("form.AgruparTotales")>
                    + sum(CASE WHEN a.TipoMovimiento = 8 THEN 
                            ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
                                           from CMDetalleTransito dt
                                         where dt.EPDid          = a.EPDid
                                          and dt.DPDlinea        = dpd.DPDlinea
                                           and dt.TipoMovimiento = 7),dpd.DPseguropropio))
                          ELSE 0 END )
                 <cfelse>
                 	+ CASE WHEN a.TipoMovimiento = 8 THEN 
                            ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
                                           from CMDetalleTransito dt
                                         where dt.EPDid          = a.EPDid
                                          and dt.DPDlinea        = dpd.DPDlinea
                                           and dt.TipoMovimiento = 7),dpd.DPseguropropio))
                          ELSE 0 END          
                 </cfif>         
            </cfif>--->
</cfsavecontent>
<cfsavecontent variable="LvarCalculoMontoAnterior">
			
			sum(case when g.PermiteDesParcial = 1 and a.TipoMovimiento = 7 then coalesce(dpd.DPseguropropio,0)
                	else coalesce(a.DTmonto,0) * coalesce(a.tipocambio,0) end
			
			<cfif isdefined('form.NoImpRecurp')>
                +<!---Sumatoria del Impuesto recuperable de la poliza--->
					 CASE WHEN a.TipoMovimiento = 8 THEN 
								ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
											   from CMDetalleTransito dt
											 where dt.EPDid          = a.EPDid
											  and dt.DPDlinea        = dpd.DPDlinea
											   and dt.TipoMovimiento = 6),0))
							  ELSE 0 END
				+<!---Sumatoria del Impuesto Recuperable porrateado de la poliza padre si lo tiene
						(ImpuestoRecuperable poliza Padre) * (Porcentaje de prorrateo correspondiente a la poliza)--->
				CASE WHEN a.TipoMovimiento = 8 THEN       
					ABS(coalesce((select sum(coalesce(a2.DTmonto,0) * coalesce(a2.tipocambio,0))
															* case when g.EPDpesobruto = 0 then 0 else (dpd.DPDcantidad / g.EPDpesobruto) <end></end>
								
								from CMDetalleTransito a2
									LEFT OUTER JOIN DPolizaDesalmacenaje dpd2
										ON dpd2.DPDlinea = a2.DPDlinea
						
									left outer join EPolizaDesalmacenaje g2
										on a2.EPDid = g2.EPDid	
										and a2.Ecodigo = g2.Ecodigo
						
								where g2.EPDid = g.EPDidpadre
								and a2.TipoMovimiento = 6
								),0))
					else 0 end
            </cfif>
			<!---                  E X C L U S I O N    D E L    S E G U R O   P R O P I O				--->
			<!---		(Solo se realiza para los debitos, los costos se mantienen con el seguro)--->
            <!---
			<cfif isdefined('form.NoSeguroPropio')>
                + CASE WHEN a.TipoMovimiento = 8 THEN 
                        ABS(Coalesce((select sum(coalesce(dt.DTmonto,0) * coalesce(dt.tipocambio,0))  
                                       from CMDetalleTransito dt
                                     where dt.EPDid          = a.EPDid
                                      and dt.DPDlinea        = dpd.DPDlinea
                                       and dt.TipoMovimiento = 7),dpd.DPseguropropio))
                      ELSE 0 END 
            </cfif>--->
            )
</cfsavecontent>
<cfsavecontent variable="LvarFiltroImpuestoSeguro">
	<cfif isdefined('form.NoImpRecurp')>
       	and a.TipoMovimiento <> 6
    </cfif>
    <cfif isdefined('NoSeguroPropio')>
         and a.TipoMovimiento <> 7
    </cfif>
</cfsavecontent>
<!--- Obtiene los datos del reporte --->
<!---<cfset LvarFiltroFecha = "case when g.EPDidpadre is not null
													then convert(date,er.EDRfecharec)
												else 
													case when (select count(1) from EPolizaDesalmacenaje po where po.EPDidpadre = g.EPDid) > 0
															then (select convert(date,min(ph.EPDfecha)) from EPolizaDesalmacenaje ph where ph.EPDidpadre = g.EPDid)
														 else
															convert(date,er.EDRfecharec)    
												end
											end">--->
<cfquery name="rsTotalesMT" datasource="#session.dsn#">
	select  case when a.TipoMovimiento = 1 then 'Fletes'
				when a.TipoMovimiento = 2 then 'Seguros'
				when a.TipoMovimiento = 3 then 'Costos'
				when a.TipoMovimiento = 4 then 'Gastos'
				when a.TipoMovimiento = 5 then 'Impuesto No Recuperable'
				when a.TipoMovimiento = 6 then 'Impuesto Recuperable'
				when a.TipoMovimiento = 7 then 'Seguro propio'
				when a.TipoMovimiento = 8 then 'Costeo de mercancía'
				else ''
			end as Movimiento,
			case h.EDItipo 	when 'F' then 'Factura'
							when 'D' then 'Nota Débito'
							when 'N' then 'Nota Crédito'
							else ''
			end as TipoDocumento,
			h.Ddocumento as NumeroDocumento,
			f.ETconsecutivo as NumeroTracking,
			g.EPDnumero as NumeroPoliza,
			<cfif isdefined("form.AgruparTotales")>
			max(a.DTfechamov) as Fecha,
			min(i.Usulogin) as Usulogin,
			<cfelse>
			case h.EDItipo when 'F' then
						coalesce(EDfechaaplica,a.DTfechamov)
				else a.DTfechamov  end as Fecha,
		    i.Usulogin,	
			</cfif>
			j.Pnombre #_Cat#' '#_Cat# j.Papellido1 #_Cat#' '#_Cat# j.Papellido2 as Usuario,
            <!---►►Para seguro Propio, de desalmacenaje parcial tipo cambio es 1◄◄--->
			case when g.PermiteDesParcial = 1 and a.TipoMovimiento = 7 then 1
            else a.tipocambio end as TipoCambio,
			c.EOnumero as OrdenCompra,
			d.SNidentificacion as CedulaProveedor,
			d.SNnombre as NombreProveedor,
			coalesce(#LvarCalculoMonto#,0) as DTmonto,
			'' as NumeroAsiento,
			h.Ddocumento,
			a.EPDid,
			<cfif not isdefined("form.AgruparTotales")>
			b.DOdescripcion,
			</cfif>
			a.EOidorden,
            cf.CFformato
	
	from CMDetalleTransito a
	
    	LEFT OUTER JOIN DPolizaDesalmacenaje dpd
        	ON dpd.DPDlinea = a.DPDlinea
            
		left outer join EDocumentosI h
			on a.EDIid = h.EDIid 
			and a.Ecodigo = h.Ecodigo
		left join HEDocumentosCP z
            on z.Ddocumento = h.Ddocumento
	
		left outer join  Usuario i
			on a.BMUsucodigo = i.Usucodigo
			
			inner join DatosPersonales j
				on i.datos_personales = j.datos_personales		
	
		inner join ETracking f
			on a.ETidtracking = f.ETidtracking
			and a.Ecodigo = f.Ecodigo
	
		left outer join EPolizaDesalmacenaje g
			on a.EPDid = g.EPDid	
			and a.Ecodigo = g.Ecodigo		
			
		inner join DOrdenCM b
			on a.DOlinea = b.DOlinea
			and a.EOidorden = b.EOidorden
        
					
		inner join EOrdenCM c
			on a.EOidorden = c.EOidorden

        inner join SNegocios d
            on c.SNcodigo = d.SNcodigo
            and c.Ecodigo = d.Ecodigo
         
         LEFT OUTER JOIN CFinanciera cf
         	on cf.Ccuenta = a.CTcuenta

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
		<!---Filtro del usuario----->
		<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
			and a.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>
		<!---Filtro del socio de negocio---->
		<cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
			and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
		</cfif>
		<!----Filtro de numeros de orden de compra---->
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and (isdefined("form.EOnumero2")) and len(trim(form.EOnumero2)) EQ 0>
			and c.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
		<cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and (isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) EQ 0)>
			and c.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>	
			and c.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif> 	
		<!----Filtro de fechas de la poliza,----->
        
        <!--- Fechas Desde / Hasta --->
            <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) and isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
				<cfif datecompare(form.FechaInicial, form.FechaFinal) eq -1> 
	                <cfset LvarFecha1 =  lsparsedatetime(form.FechaInicial)>
                <cfset LvarFecha2 =  lsparsedatetime(form.FechaFinal)>
    	            <cfelseif datecompare(form.FechaInicial, form.FechaFinal) eq 1>
                <cfset LvarFecha1 =  lsparsedatetime(form.FechaFinal)>
        	        <cfset LvarFecha2 =  lsparsedatetime(form.FechaInicial)>
                <cfelseif datecompare(form.FechaInicial, form.FechaFinal) eq 0>
            	    <cfset LvarFecha1 =  lsparsedatetime(form.FechaInicial)>
                	<cfset LvarFecha2 =  LvarFecha1>
                </cfif>
            
			<cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                	and coalesce(EDfechaaplica,DTfechamov)  between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha1#">
                	and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha2#">
                
           <cfelseif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                and coalesce(EDfechaaplica,DTfechamov) >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaInicial)#">
           <cfelseif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
                <cfset LvarFecha2 =  lsparsedatetime(form.FechaFinal)>
                <cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
                and coalesce(EDfechaaplica,DTfechamov) <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha2#">
            
			
			</cfif>
            
		<!--- <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
			and <cf_dbfunction name="to_date00"	args="a.DTfechamov"> >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaInicial)#">
		</cfif>
		<cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
			and <cf_dbfunction name="to_date00"	args="a.DTfechamov"> <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFinal)#">
		</cfif> --->
        
		<!---Filtro de numero de tracking----->
		<cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
			and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
		</cfif>
		<!---Filtro de póliza---->
		<cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
			and a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
		</cfif>			
        <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
			and (a.CTcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">)
		</cfif>	
        #LvarFiltroImpuestoSeguro#
        <!---►►Quita las lineas con Cero--->
        <cfif NOT isdefined("form.AgruparTotales")>
        	and #LvarCalculoMonto# <> 0
        </cfif>
	<cfif isdefined("form.AgruparTotales")>
		group by a.EDIid, h.Ddocumento, h.EDItipo, dpd.DPDlinea,
			a.EPDid, g.EPDnumero,
			a.EDRid,
			a.ETidtracking, f.ETconsecutivo,
			a.EOidorden, c.EOnumero, d.SNidentificacion, d.SNnombre,
			a.TipoMovimiento, a.tipocambio,
			j.Pnombre, j.Papellido1, j.Papellido2,cf.CFformato,
			g.PermiteDesParcial
		order by c.EOnumero, max(a.DTfechamov), a.EDIid, a.EPDid, a.TipoMovimiento
	<cfelse>
	order by c.EOnumero
	</cfif>
</cfquery>

<!----Obtener el número de asiento para c/registro del query----->
<cfloop query="rsTotalesMT">
	<cfif len(trim(rsTotalesMT.Ddocumento))>
		<cfquery name="rsAsiento" datasource="sifinterfaces">		
			select NoAsiento 
			from OE102
			where NumeroDocTransaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTotalesMT.Ddocumento#">
		</cfquery>
		<cfif rsAsiento.recordcount GT 0>
			<cfset QuerySetCell(rsTotalesMT, "NumeroAsiento", rsAsiento.NoAsiento, rsTotalesMT.CurrentRow)>	
		</cfif>
	<cfelseif len(trim(rsTotalesMT.EPDid))>
		<cfquery name="rsDcto" datasource="#session.DSN#">
			select EDRnumero
			from EDocumentosRecepcion
			where EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotalesMT.EPDid#">
		</cfquery>
		<cfif len(trim(rsDcto.EDRnumero))>
			<cfquery name="rsAsiento" datasource="sifinterfaces">		
				select NoAsiento 
				from OE101
				where NumeroDocRecepcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDcto.EDRnumero#">
			</cfquery>
			<cfif rsAsiento.recordcount GT 0>
				<cfset QuerySetCell(rsTotalesMT, "NumeroAsiento", rsAsiento.NoAsiento, rsTotalesMT.CurrentRow)>	
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<!-----Aplicar el filtro del numero de asiento (si viene)------>
<cfif isdefined("form.NumeroAsiento") and len(trim(form.NumeroAsiento))>
	<cfquery name="rsTotalesMT" dbtype="query">
		select NumeroAsiento,* 
		from rsTotalesMT
		where NumeroAsiento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumeroAsiento#">
	</cfquery>
</cfif>
