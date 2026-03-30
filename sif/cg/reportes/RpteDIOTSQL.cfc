<cfcomponent>
	<cffunction name="ConsultaTablaReporte" access="public" returntype="query" output="false">

	<cfif isdefined('Form.sncodigo') and len(trim('Form.sncodigo'))>
		<cfset sncod = replace("#Form.sncodigo#", ",","")>	
	</cfif>
	
	<!---<cf_dump var="#bcoIdInfo#">--->

		<cfquery name="rsDatos" datasource="#session.dsn#">
            select substring(b.SNnombre,0,43) as SNnombre, c.DIOTcodigo, d.DIOTopcodigo,ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion,b.IdFisc,b.Ppais, b.Nacional, 
               isnull(IVAotros.LMontoBaseIVA,0)as IVAOtros,
               isnull(IVABienesServicios.LMontoBaseIVA,0)as IVABienesServicios,
               isnull(IVAAcreditado.LIVAPagado,0)as IVAPagado, 
               isnull(IVAExeBienesServicios.LMontoBaseIVA,0) as IVAExeBienesServicios,
               isnull(IVAcero.LMontoBaseIVA,0)as IVAcero, 
               isnull(IVAExentoOtros.LMontoBaseIVA,0)as IVAExentoOtros, 
               isnull(IVAotrosPagados.LIVAPagado,0)as IVAotrosPagados,
               isnull(IVABienesServiciosPagados.LIVAPagado,0)as IVABienesServiciosPagados,
               b.SNcodigo,
			   isnull(MontoRetencionIVA.MontoRetIVA,0)as MontoRetIVA
            from SNegocios b
            inner join SNDIOTClas c
                on b.SNcodigo = c.SNcodigo
                and b.Ecodigo = c.Ecodigo
            inner join SNDIOTOper d
                on c.SNcodigo = d.SNcodigo
                and c.Ecodigo = d.Ecodigo
			left join (	
				select sum(MontoRetIVA)as MontoRetIVA,SNcodigo,Ecodigo
						from(
								select sum(a.MontoRetIVA)as MontoRetIVA,a.SNcodigo,a.Ecodigo							
                        		from DIOT_Control a
                            	inner join (	
                                        		select b.Icodigo from DIOTiva a
                                                    inner join ImpuestoDIOT b
                                                        on a.DIOTivacodigo = b.DIOTivacodigo
                                                    inner join Impuestos c
                                                        on c.Icodigo = b.Icodigo
                                                        and b.Ecodigo = c.Ecodigo
                                                        and c.Icreditofiscal = 1
                                                where a.DIOTivacodigo = 1
                                                and c.Iporcentaje in (15,16)
                                    		) b
                            	on a.Icodigo = b.Icodigo
                                    where 1=1 and Pagado = 1
                                <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                    and IMes >= #form.MesD#
                                    and IMes <= #form.MesH#
                                </cfif>
                                <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                    and IPeriodo >= #form.PeriodoD#
                                    and IPeriodo <= #form.PeriodoH#
                                </cfif>
                                group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen) as Retencion
                                where 1=1
                                <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                                	and Retencion.SNcodigo = #form.SNcodigo#
                                </cfif>
                    group by  SNcodigo,Ecodigo) as MontoRetencionIVA
                    on MontoRetencionIVA.SNcodigo = b.SNcodigo
                    and MontoRetencionIVA.Ecodigo = b.Ecodigo
						
            left join (						
						select sum(LMontoBaseIVA)as LMontoBaseIVA,SNcodigo,Ecodigo
						from(
								select sum(a.LMontoBaseIVA)as LMontoBaseIVA,a.SNcodigo,a.Ecodigo							
                        		from DIOT_Control a
                            	inner join (	
                                        		select b.Icodigo from DIOTiva a
                                                    inner join ImpuestoDIOT b
                                                        on a.DIOTivacodigo = b.DIOTivacodigo
                                                    inner join Impuestos c
                                                        on c.Icodigo = b.Icodigo
                                                        and b.Ecodigo = c.Ecodigo
                                                        and c.Icreditofiscal = 1
                                                where a.DIOTivacodigo = 1
                                                and c.Iporcentaje in (15,16)
                                    		) b
                            	on a.Icodigo = b.Icodigo
                                    where 1=1 and Pagado = 1
                                <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                    and IMes >= #form.MesD#
                                    and IMes <= #form.MesH#
                                </cfif>
                                <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                    and IPeriodo >= #form.PeriodoD#
                                    and IPeriodo <= #form.PeriodoH#
                                </cfif>
                                group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen) as Iva
                                where 1=1
                        <!---        <cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                                and Iva.Ocodigo = #form.Oficina#
                                </cfif>--->
                                <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                                and Iva.SNcodigo = #form.SNcodigo#
                                </cfif>
                    group by  SNcodigo,Ecodigo) as IVAotros
                    on IVAotros.SNcodigo = b.SNcodigo
                    and IVAotros.Ecodigo = b.Ecodigo
                    
            left join (
                    select sum(LMontoBaseIVA)as LMontoBaseIVA,SNcodigo,Ecodigo
                                from(	 
                        				select sum(a.LMontoBaseIVA)as LMontoBaseIVA,a.SNcodigo,a.Ecodigo		
                        from DIOT_Control a
                            inner join (	
                                        select b.Icodigo from DIOTiva a
                                            inner join ImpuestoDIOT b
                                                on a.DIOTivacodigo = b.DIOTivacodigo
                                            inner join Impuestos c
                                                on c.Icodigo = b.Icodigo
                                                and b.Ecodigo = c.Ecodigo
                                                and c.Icreditofiscal = 1
                                        where a.DIOTivacodigo = 2
                                        and c.Iporcentaje in (10,11)
                                    ) b
                            on a.Icodigo = b.Icodigo
						 where 1=1 and Pagado = 1
						<cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                        	and IMes >= #form.MesD#
                            and IMes <= #form.MesH#
                        </cfif>
						<cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                            and IPeriodo >= #form.PeriodoD#
                            and IPeriodo <= #form.PeriodoH#
                        </cfif>
                        group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen)as IVAByS
                        where 1=1
					<!---	<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                        and IVAByS.Ocodigo = #form.Oficina#
                        </cfif>--->
                        <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                        and IVAByS.SNcodigo = #form.SNcodigo#
                        </cfif>
                group by  SNcodigo,Ecodigo)as IVABienesServicios
                on IVABienesServicios.SNcodigo = b.SNcodigo
                and IVABienesServicios.Ecodigo = b.Ecodigo
                
            left join (	 
						select sum(LIVAPagado)as LIVAPagado,SNcodigo,Ecodigo
                        from(
                            select sum(a.LIVAPagado)as LIVAPagado,a.SNcodigo,a.Ecodigo                                   
                                from DIOT_Control a
                                	inner join Impuestos c
										on c.Icodigo = a.Icodigo
										and a.Ecodigo = c.Ecodigo
                                where c.Icreditofiscal = 0 and Pagado = 1
                                <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                    and IMes >= #form.MesD#
                                    and IMes <= #form.MesH#
                                </cfif>
                                <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                    and IPeriodo >= #form.PeriodoD#
                                    and IPeriodo <= #form.PeriodoH#
                                </cfif>		
                                group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen) as Acreditado
                                where 1=1 
                             <!---   <cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                                and Acreditado.Ocodigo = #form.Oficina#
                                </cfif>--->
                                <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                                and Acreditado.SNcodigo = #form.SNcodigo#
                                </cfif>
                    group by  SNcodigo,Ecodigo)as IVAAcreditado
                    on IVAAcreditado.SNcodigo = b.SNcodigo
                    and IVAAcreditado.Ecodigo = b.Ecodigo
            
            left join (	 
						select sum(LMontoBaseIVA) as LMontoBaseIVA,SNcodigo,Ecodigo
                            from 
                                (select sum(a.LMontoBaseIVA)as LMontoBaseIVA,a.SNcodigo,a.Ecodigo                                       	
                                    from DIOT_Control a
                                        inner join (	
                                                    select b.Icodigo from DIOTiva a
                                                        inner join ImpuestoDIOT b
                                                            on a.DIOTivacodigo = b.DIOTivacodigo
                                                        inner join Impuestos c
                                                            on c.Icodigo = b.Icodigo
                                                            and b.Ecodigo = c.Ecodigo
                                                    where a.DIOTivacodigo = 4
                                                    ) b
                                        on a.Icodigo = b.Icodigo
                                    where 1=1  and Pagado = 1
                            <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                and IMes >= #form.MesD#
                                and IMes <= #form.MesH#
                            </cfif>
                            <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                and IPeriodo >= #form.PeriodoD#
                                and IPeriodo <= #form.PeriodoH#
                            </cfif>
                            group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen) as IVAExeByS
                            where 1=1 
				<!---			<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                            and IVAExeByS.Ocodigo = #form.Oficina#
                            </cfif>--->
							<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                            and IVAExeByS.SNcodigo = #form.SNcodigo#
                            </cfif>
                        group by SNcodigo,Ecodigo) as IVAExeBienesServicios
                        on IVAExeBienesServicios.SNcodigo = b.SNcodigo
                        and IVAExeBienesServicios.Ecodigo = b.Ecodigo
            
            left join (	 select isnull(sum(LMontoBaseIVA),0)as LMontoBaseIVA,SNcodigo,Ecodigo
            			 from(
                                select isnull(sum(a.LMontoBaseIVA),0)as LMontoBaseIVA,a.SNcodigo,a.Ecodigo
                                from DIOT_Control a
                                    inner join (	
                                                select b.Icodigo from DIOTiva a
                                                    inner join ImpuestoDIOT b
                                                        on a.DIOTivacodigo = b.DIOTivacodigo
                                                    inner join Impuestos c
                                                        on c.Icodigo = b.Icodigo
                                                        and b.Ecodigo = c.Ecodigo
                                                where a.DIOTivacodigo = 3
                                            ) b
                                    on a.Icodigo = b.Icodigo
                                 where 1=1 and Pagado = 1
                                <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                    and IMes >= #form.MesD#
                                    and IMes <= #form.MesH#
                                </cfif>
                                <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                    and IPeriodo >= #form.PeriodoD#
                                    and IPeriodo <= #form.PeriodoH#
                                </cfif>
                                group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen
                                )Cero
                                 where 1=1
							<!---	<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                                and Cero.Ocodigo = #form.Oficina#
                                </cfif>--->
                                <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                                and Cero.SNcodigo = #form.SNcodigo#
                                </cfif>
            				group by SNcodigo,Ecodigo) as IVAcero
            on IVAcero.SNcodigo = b.SNcodigo
            and IVAcero.Ecodigo = b.Ecodigo
            
            left join (select  isnull(sum(LMontoBaseIVA),0)as LMontoBaseIVA,SNcodigo,Ecodigo
            			from
                            (select isnull(sum(a.LMontoBaseIVA),0)as LMontoBaseIVA,a.SNcodigo,a.Ecodigo
                            from DIOT_Control a
                                inner join (	
                                            select b.Icodigo from DIOTiva a
                                                inner join ImpuestoDIOT b
                                                    on a.DIOTivacodigo = b.DIOTivacodigo
                                                inner join Impuestos c
                                                    on c.Icodigo = b.Icodigo
                                                    and b.Ecodigo = c.Ecodigo
                                            where a.DIOTivacodigo = 5
                                        ) b
                                on a.Icodigo = b.Icodigo
                             where 1=1 and Pagado = 1
                            <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                and IMes >= #form.MesD#
                                and IMes <= #form.MesH#
                            </cfif>
                            <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                and IPeriodo >= #form.PeriodoD#
                                and IPeriodo <= #form.PeriodoH#
                            </cfif>
                            group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen
                            )IVAExeOtros
                            where 1=1
						<!---	<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                            and IVAExeOtros.Ocodigo = #form.Oficina#
                            </cfif>--->
                            <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                            and IVAExeOtros.SNcodigo = #form.SNcodigo#
                            </cfif>
                        group by  SNcodigo,Ecodigo
                        )IVAExentoOtros
            on IVAExentoOtros.SNcodigo = b.SNcodigo
            and IVAExentoOtros.Ecodigo = b.Ecodigo
        
            left join (select sum(LIVAPagado)as LIVAPagado,SNcodigo,Ecodigo
            		   from(
                            select sum(a.LIVAPagado)as LIVAPagado,a.SNcodigo,a.Ecodigo
                            from DIOT_Control a
                                inner join (	
                                            select b.Icodigo from DIOTiva a
                                                inner join ImpuestoDIOT b
                                                    on a.DIOTivacodigo = b.DIOTivacodigo
                                                inner join Impuestos c
                                                    on c.Icodigo = b.Icodigo
                                                    and b.Ecodigo = c.Ecodigo
                                                    and c.Icreditofiscal = 1
                                            where a.DIOTivacodigo = 1
                                            and c.Iporcentaje in (15,16)
                                        ) b
                                on a.Icodigo = b.Icodigo
                             where 1=1 and Pagado = 1
                            <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                and IMes >= #form.MesD#
                                and IMes <= #form.MesH#
                            </cfif>
                            <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                and IPeriodo >= #form.PeriodoD#
                                and IPeriodo <= #form.PeriodoH#
                            </cfif>
							and LIVAPagado > 0
                            group by  a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen
                           )IVAotrosPag
							where 1=1
							<!---<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                            and IVAotrosPag.Ocodigo = #form.Oficina#
                            </cfif>--->
                            <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                            and IVAotrosPag.SNcodigo = #form.SNcodigo#
                            </cfif>
                        group by  SNcodigo,Ecodigo
                        )IVAotrosPagados
            on IVAotrosPagados.SNcodigo = b.SNcodigo
            and IVAotrosPagados.Ecodigo = b.Ecodigo
            
            left join (	select sum(LIVAPagado)as LIVAPagado,SNcodigo,Ecodigo
            			from (
                                select sum(a.LIVAPagado)as LIVAPagado,a.SNcodigo,a.Ecodigo
                                from DIOT_Control a
                                    inner join (	
                                                select b.Icodigo from DIOTiva a
                                                    inner join ImpuestoDIOT b
                                                        on a.DIOTivacodigo = b.DIOTivacodigo
                                                    inner join Impuestos c
                                                        on c.Icodigo = b.Icodigo
                                                        and b.Ecodigo = c.Ecodigo
                                                        and c.Icreditofiscal = 1
                                                where a.DIOTivacodigo = 2
                                                and c.Iporcentaje in (10,11)
                                            ) b
                                    on a.Icodigo = b.Icodigo
                                 where 1=1 and Pagado = 1
                                <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
                                    and IMes >= #form.MesD#
                                    and IMes <= #form.MesH#
                                </cfif>
                                <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
                                    and IPeriodo >= #form.PeriodoD#
                                    and IPeriodo <= #form.PeriodoH#
                                </cfif>
                                group by a.SNcodigo,a.Ecodigo,a.CampoId,a.TablaOrigen
                               )IVABySPagados
                               where 1=1
							<!---	<cfif isdefined('form.Oficina') and form.Oficina NEQ ''>
                                and IVABySPagados.Ocodigo = #form.Oficina#
                                </cfif>--->
                                <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
                                and IVABySPagados.SNcodigo = #form.SNcodigo#
                                </cfif>
                          group by SNcodigo,Ecodigo
                         )IVABienesServiciosPagados
            on IVABienesServiciosPagados.SNcodigo = b.SNcodigo
            and IVABienesServiciosPagados.Ecodigo = b.Ecodigo
	where 1 = 1
    and b.Ecodigo = #session.Ecodigo#
    <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ '' <!---and (not isdefined ('form.bcoIdInfo') or form.bcoIdInfo EQ -1)--->>
    	and b.SNcodigo = #form.SNcodigo#	
	</cfif>
	<cfif isdefined ('form.bcoIdInfo') and form.bcoIdInfo NEQ -1>
    		and 2=1
	</cfif>
				<!---<cfif not  isdefined('form.SNcodigo') and form.SNcodigo EQ '' and (not isdefined ('form.bcoIdInfo') or form.bcoIdInfo EQ -1)>--->
				UNION
				select substring(b.Bdescripcion,0,43) as SNnombre, 04 as DIOTcodigo, 85 as DIOTopcodigo, ltrim(rtrim(REPLACE(b.RFC,'-',''))) as SNidentificacion,
					'' as IdFisc,'' as Ppais, '' as Nacional, isnull(IVAotros.LMontoBaseIVA,0)as IVAOtros, isnull(IVABienesServicios.LMontoBaseIVA,0)as IVABienesServicios,
					isnull(IVAAcreditado.LIVAPagado,0)as IVAPagado, isnull(IVAExeBienesServicios.LMontoBaseIVA,0) as IVAExeBienesServicios, 
				isnull(IVAcero.LMontoBaseIVA,0)as IVAcero, isnull(IVAExentoOtros.LMontoBaseIVA,0)as IVAExentoOtros, isnull(IVAotrosPagados.LIVAPagado,0)as IVAotrosPagados,
				isnull(IVABienesServiciosPagados.LIVAPagado,0)as IVABienesServiciosPagados, b.Bid,0 as MontoRetIVA
				from Bancos b
				left join (	select sum(LMontoBaseIVA)as LMontoBaseIVA,Bid,Ecodigo 
							from( select sum(a.LMontoBaseIVA)as LMontoBaseIVA, a.Bid,a.Ecodigo	from DIOT_Control a 
							inner join (select b.Icodigo from DIOTiva a 
												inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
												inner join Impuestos c on c.Icodigo = b.Icodigo and b.Ecodigo = c.Ecodigo and c.Icreditofiscal = 1 where a.DIOTivacodigo = 1 
												and c.Iporcentaje in (15,16) )
										 b on a.Icodigo = b.Icodigo where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# 
										 group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen) as Iva
							 	where 1=1 group by Bid,Ecodigo) as IVAotros 
							on IVAotros.Bid = b.Bid and IVAotros.Ecodigo = b.Ecodigo 
				left join ( select sum(LMontoBaseIVA)as LMontoBaseIVA,Bid,Ecodigo from(	select sum(a.LMontoBaseIVA)as LMontoBaseIVA, a.Bid,a.Ecodigo 
							from DIOT_Control a 
							inner join (	select b.Icodigo from DIOTiva a 
											inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
											inner join Impuestos c on c.Icodigo = b.Icodigo and b.Ecodigo = c.Ecodigo and c.Icreditofiscal = 1 where a.DIOTivacodigo = 2 and 			                                            c.Iporcentaje in (10,11) ) b 
										on a.Icodigo = b.Icodigo 
										where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoD# 
										group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen)as IVAByS where 1=1 
							group by Bid,Ecodigo)as IVABienesServicios on IVABienesServicios.Bid = b.Bid and IVABienesServicios.Ecodigo = b.Ecodigo 
				left join (	select sum(LIVAPagado)as LIVAPagado,Bid,Ecodigo 
							from( select sum(a.LIVAPagado)as LIVAPagado,a.Bid,a.Ecodigo
					      		  from DIOT_Control a 
								  inner join Impuestos c on c.Icodigo = a.Icodigo and a.Ecodigo = c.Ecodigo
								  where c.Icreditofiscal = 0 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# 
								  group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen) as Acreditado
							where 1=1 group by Bid,Ecodigo)as IVAAcreditado on IVAAcreditado.Bid = b.Bid and IVAAcreditado.Ecodigo = b.Ecodigo 
				left join (	select sum(LMontoBaseIVA) as LMontoBaseIVA,Bid,Ecodigo 
							from (select sum(a.LMontoBaseIVA)as LMontoBaseIVA, a.Bid,a.Ecodigo	
									from DIOT_Control a 
									inner join (	select b.Icodigo from DIOTiva a 
													inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
													inner join Impuestos c on c.Icodigo = b.Icodigo 
													and b.Ecodigo = c.Ecodigo where a.DIOTivacodigo = 4 ) b 
												on a.Icodigo = b.Icodigo where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH#
												group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen) as IVAExeByS 
										where 1=1 
										group by Bid,Ecodigo) as IVAExeBienesServicios 
							on IVAExeBienesServicios.Bid = b.Bid and IVAExeBienesServicios.Ecodigo = b.Ecodigo 
				left join (	select isnull(sum(LMontoBaseIVA),0)as LMontoBaseIVA,Bid,Ecodigo 
							from( select isnull(sum(a.LMontoBaseIVA),0) as LMontoBaseIVA,a.Bid,a.Ecodigo 
								from DIOT_Control a 
								inner join (	select b.Icodigo from DIOTiva a 
												inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
												inner join Impuestos c on c.Icodigo = b.Icodigo 
												and b.Ecodigo = c.Ecodigo where a.DIOTivacodigo = 3 ) b 
										on a.Icodigo = b.Icodigo where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# 
										group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen )Cero 
										where 1=1 
										group by Bid,Ecodigo) as IVAcero
								 on IVAcero.Bid = b.Bid and IVAcero.Ecodigo = b.Ecodigo 
				left join (select isnull(sum(LMontoBaseIVA),0)as LMontoBaseIVA,Bid,Ecodigo 
							from (select isnull(sum(a.LMontoBaseIVA),0)as LMontoBaseIVA,a.Bid,a.Ecodigo
									from DIOT_Control a 
									inner join (	select b.Icodigo from DIOTiva a 
													inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
													inner join Impuestos c on c.Icodigo = b.Icodigo and b.Ecodigo = c.Ecodigo where a.DIOTivacodigo = 5 ) b 
									on a.Icodigo = b.Icodigo 
									where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# 
									group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen )IVAExeOtros
								where 1=1 group by Bid,Ecodigo)IVAExentoOtros 
							on IVAExentoOtros.Bid = b.Bid and IVAExentoOtros.Ecodigo = b.Ecodigo 
				left join (select sum(LIVAPagado)as LIVAPagado,Bid,Ecodigo 
							from( select sum(a.LIVAPagado)as LIVAPagado,a.Bid,a.Ecodigo
									from DIOT_Control a 
									inner join (	select b.Icodigo from DIOTiva a 
													inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
													inner join Impuestos c on c.Icodigo = b.Icodigo and b.Ecodigo = c.Ecodigo and c.Icreditofiscal = 1 
													where a.DIOTivacodigo = 1 and c.Iporcentaje in (15,16) ) b 
												on a.Icodigo = b.Icodigo where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# 
												group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen )IVAotrosPag 
										where 1=1 group by Bid,Ecodigo)IVAotrosPagados 
									on IVAotrosPagados.Bid = b.Bid and IVAotrosPagados.Ecodigo = b.Ecodigo 
				left join (	select sum(LIVAPagado)as LIVAPagado,Bid,Ecodigo 
							from ( select sum(a.LIVAPagado)as LIVAPagado,a.Bid,a.Ecodigo
								   from DIOT_Control a 
								   inner join (	select b.Icodigo from DIOTiva a inner join ImpuestoDIOT b on a.DIOTivacodigo = b.DIOTivacodigo 
			 									inner join Impuestos c on c.Icodigo = b.Icodigo and b.Ecodigo = c.Ecodigo and c.Icreditofiscal = 1 
												where a.DIOTivacodigo = 2 
			 									and c.Iporcentaje in (10,11) ) b on a.Icodigo = b.Icodigo 
												where 1=1 and IMes >= #form.MesD# and IMes <= #form.MesH# and IPeriodo >= #form.PeriodoD# and IPeriodo <= #form.PeriodoH# and LIVAPagado > 0
										 group by a.Bid,a.Ecodigo,a.CampoId,a.TablaOrigen )IVABySPagados 
										 where 1=1 group by Bid,Ecodigo)IVABienesServiciosPagados 
								 on IVABienesServiciosPagados.Bid = b.Bid and IVABienesServiciosPagados.Ecodigo = b.Ecodigo where 1 = 1 and b.Ecodigo = #session.Ecodigo#
		<cfif isdefined ('form.bcoIdInfo') and form.bcoIdInfo NEQ -1>
    		and b.Bid = #form.bcoIdInfo#	
		</cfif>
	</cfquery>


    <cfquery name="rsDiotControl" datasource="#session.dsn#">
    	select * from DIOT_Control
        where Ecodigo = #session.Ecodigo#
		and Pagado = 1
	 <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
    	and SNcodigo = #form.SNcodigo#
    </cfif>
    <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
        and IMes >= #form.MesD#
        and IMes <= #form.MesH#
    </cfif>
    <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
        and IPeriodo >= #form.PeriodoD#
        and IPeriodo <= #form.PeriodoH#
    </cfif>
    </cfquery>
<!---	<cf_dump var="#rsDatos#">--->
	
    <cfquery name="rsRPTdiot" dbtype="query">
    	select distinct rsDatos.* from rsDatos, rsDiotControl
        where rsDatos.SNcodigo = rsDiotControl.SNcodigo 
        group by rsDatos.SNnombre, rsDatos.DIOTcodigo, rsDatos.DIOTopcodigo,rsDatos.SNidentificacion,rsDatos.IdFisc,rsDatos.Ppais, rsDatos.Nacional, 
				 rsDatos.IVAOtros,rsDatos.IVABienesServicios,rsDatos.IVAPagado,rsDatos.IVAExeBienesServicios,rsDatos.IVAcero,rsDatos.IVAExentoOtros, 
				 rsDatos.IVABienesServiciosPagados,rsDatos.SNcodigo,rsDatos.IVAotrosPagados , rsDatos.MontoRetIVA
		union 
		select distinct rsDatos.* from rsDatos, rsDiotControl
        where rsDatos.SNcodigo = rsDiotControl.Bid 
        group by rsDatos.SNnombre, rsDatos.DIOTcodigo, rsDatos.DIOTopcodigo,rsDatos.SNidentificacion,rsDatos.IdFisc,rsDatos.Ppais, rsDatos.Nacional, 
				 rsDatos.IVAOtros,rsDatos.IVABienesServicios,rsDatos.IVAPagado,rsDatos.IVAExeBienesServicios,rsDatos.IVAcero,rsDatos.IVAExentoOtros, 
				 rsDatos.IVABienesServiciosPagados,rsDatos.SNcodigo,rsDatos.IVAotrosPagados ,  rsDatos.MontoRetIVA
    </cfquery>
	<cfquery name="rsRPTdiot" dbtype="query">
		select distinct ' ' as SNnombre, DIOTcodigo, DIOTopcodigo,SNidentificacion,IdFisc,Ppais, Nacional,	
		sum(IVAOtros) IVAOtros, sum(IVABienesServicios) IVABienesServicios , sum(IVAPagado) IVAPagado, 
		sum(IVAExeBienesServicios) IVAExeBienesServicios, sum(IVAcero) IVAcero, sum(IVAExentoOtros) IVAExentoOtros, 
		sum(IVABienesServiciosPagados) IVABienesServiciosPagados, sum(IVAotrosPagados) IVAotrosPagados, sum(MontoRetIVA) MontoRetIVA 
		from  rsRPTdiot
		where SNidentificacion is not null
		group by 
		 SNnombre, DIOTcodigo, DIOTopcodigo,SNidentificacion,IdFisc,Ppais, Nacional		
	</cfquery>	
	<!---<cf_dump var="#rsRPTdiot#">--->
	<cfreturn rsRPTdiot>
</cffunction>

<!--- Reporte Detallado --->

<cffunction name="ConsultaDetallada" access="public" returntype="query" output="false">
	
	 <cfquery name="rsDiotControl" datasource="#session.dsn#">
          select a.TablaOrigen,a.Documento, a.CampoId ,b.SNnombre, c.DIOTcodigo,  d.DIOTopcodigo, 
          ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion, b.IdFisc,b.Ppais, b.Nacional, b.SNcodigo,
          	   coalesce(a.LMontoBaseIVA,0) as IvaOtros, 
          	   coalesce(a.LIVAPagado,0) as IvaOtrosPagados, 
          	   0 as IvaExentoOtros, 
               0 IVABienesServicios,
               0 IVAPagado, 
               0 IVAExeBienesServicios,
               0 IVAcero, 
               0 IVABienesServiciosPagados 
          from DIOT_Control a
            inner join SNegocios b on a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo
            inner join SNDIOTClas c on b.SNcodigo = c.SNcodigo and b.Ecodigo = c.Ecodigo 
            inner join SNDIOTOper d on c.SNcodigo = d.SNcodigo and c.Ecodigo = d.Ecodigo 
            inner join Impuestos i on  a.Ecodigo=i.Ecodigo and a.Icodigo=i.Icodigo
		  where a.Ecodigo = #session.Ecodigo#
		   <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
              and a.SNcodigo = #form.SNcodigo#
          </cfif>
          <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
              and IMes >= #form.MesD#
              and IMes <= #form.MesH#
          </cfif>
          <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
              and IPeriodo >= #form.PeriodoD#
              and IPeriodo <= #form.PeriodoH#
          </cfif>
          and a.DIOTivacodigo=1        
          union 
          select  a.TablaOrigen,a.Documento, a.CampoId ,b.SNnombre, c.DIOTcodigo,  d.DIOTopcodigo, 
          ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion, b.IdFisc,b.Ppais, b.Nacional, b.SNcodigo,
          	   0 IvaOtros, 
         	   0 IvaOtrosPagados, 
          	   coalesce(LMontoBaseIVA,0) as IvaExentoOtros, 
               0 IVABienesServicios,
               0 IVAPagado, 
               0 IVAExeBienesServicios,
               0 IVAcero, 
               0 IVABienesServiciosPagados 
          from DIOT_Control a
            inner join SNegocios b on a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo
            inner join SNDIOTClas c on b.SNcodigo = c.SNcodigo and b.Ecodigo = c.Ecodigo 
            inner join SNDIOTOper d on c.SNcodigo = d.SNcodigo and c.Ecodigo = d.Ecodigo 
            inner join Impuestos i on  a.Ecodigo=i.Ecodigo and a.Icodigo=i.Icodigo
		  where a.Ecodigo = #session.Ecodigo#
		   <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
              and a.SNcodigo = #form.SNcodigo#
          </cfif>
          <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
              and IMes >= #form.MesD#
              and IMes <= #form.MesH#
          </cfif>
          <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
              and IPeriodo >= #form.PeriodoD#
              and IPeriodo <= #form.PeriodoH#
          </cfif>
          and a.DIOTivacodigo=5
          union
          select a.TablaOrigen,a.Documento, a.CampoId ,b.SNnombre, c.DIOTcodigo,  d.DIOTopcodigo, 
          ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion, b.IdFisc,b.Ppais, b.Nacional, b.SNcodigo,
          	   0 IvaOtros, 
          	   0 IvaOtrosPagados, 
          	   0 as IvaExentoOtros, 
               coalesce(LMontoBaseIVA,0) as IVABienesServicios,
               0 IVAPagado, 
               0 IVAExeBienesServicios,
               0 IVAcero, 
               coalesce(a.LIVAPagado,0) as IVABienesServiciosPagados 
          from DIOT_Control a
            inner join SNegocios b on a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo
            inner join SNDIOTClas c on b.SNcodigo = c.SNcodigo and b.Ecodigo = c.Ecodigo 
            inner join SNDIOTOper d on c.SNcodigo = d.SNcodigo and c.Ecodigo = d.Ecodigo 
            inner join Impuestos i on  a.Ecodigo=i.Ecodigo and a.Icodigo=i.Icodigo
		  where a.Ecodigo = #session.Ecodigo#
		   <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
              and a.SNcodigo = #form.SNcodigo#
          </cfif>
          <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
              and IMes >= #form.MesD#
              and IMes <= #form.MesH#
          </cfif>
          <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
              and IPeriodo >= #form.PeriodoD#
              and IPeriodo <= #form.PeriodoH#
          </cfif>
          and a.DIOTivacodigo=2          
          union 
          select  a.TablaOrigen,a.Documento, a.CampoId ,b.SNnombre, c.DIOTcodigo,  d.DIOTopcodigo, 
          ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion, b.IdFisc,b.Ppais, b.Nacional, b.SNcodigo,
          	   0 IvaOtros, 
         	   0 IvaOtrosPagados, 
          	   0 IvaExentoOtros, 
               0 IVABienesServicios,
               0 IVAPagado, 
               coalesce(LMontoBaseIVA,0) as IVAExeBienesServicios,
               0 IVAcero, 
               0 IVABienesServiciosPagados 
          from DIOT_Control a
            inner join SNegocios b on a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo
            inner join SNDIOTClas c on b.SNcodigo = c.SNcodigo and b.Ecodigo = c.Ecodigo 
            inner join SNDIOTOper d on c.SNcodigo = d.SNcodigo and c.Ecodigo = d.Ecodigo 
            inner join Impuestos i on  a.Ecodigo=i.Ecodigo and a.Icodigo=i.Icodigo
		  where a.Ecodigo = #session.Ecodigo#
		   <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
              and a.SNcodigo = #form.SNcodigo#
          </cfif>
          <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
              and IMes >= #form.MesD#
              and IMes <= #form.MesH#
          </cfif>
          <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
              and IPeriodo >= #form.PeriodoD#
              and IPeriodo <= #form.PeriodoH#
          </cfif>
          and a.DIOTivacodigo=4
          union
          select  a.TablaOrigen,a.Documento, a.CampoId ,b.SNnombre, c.DIOTcodigo,  d.DIOTopcodigo, 
          ltrim(rtrim(REPLACE(b.SNidentificacion,'-',''))) as SNidentificacion, b.IdFisc,b.Ppais, b.Nacional, b.SNcodigo,
          	   0 IvaOtros, 
         	   0 IvaOtrosPagados, 
          	   0 IvaExentoOtros, 
               0 IVABienesServicios,
               0 IVAPagado, 
               0 IVAExeBienesServicios,
               coalesce(LMontoBaseIVA,0) as IVAcero, 
               0 IVABienesServiciosPagados 
          from DIOT_Control a
            inner join SNegocios b on a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo
            inner join SNDIOTClas c on b.SNcodigo = c.SNcodigo and b.Ecodigo = c.Ecodigo 
            inner join SNDIOTOper d on c.SNcodigo = d.SNcodigo and c.Ecodigo = d.Ecodigo 
            inner join Impuestos i on  a.Ecodigo=i.Ecodigo and a.Icodigo=i.Icodigo
		  where a.Ecodigo = #session.Ecodigo#
		   <cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
              and a.SNcodigo = #form.SNcodigo#
          </cfif>
          <cfif (isdefined('form.MesD') and len(trim("MesD"))) and (isdefined('form.MesH') and len(trim("MesH")))>
              and IMes >= #form.MesD#
              and IMes <= #form.MesH#
          </cfif>
          <cfif (isdefined('form.PeriodoD') and len(trim("PeriodoD"))) and (isdefined('form.PeriodoH') and len(trim("PeriodoH")))>
              and IPeriodo >= #form.PeriodoD#
              and IPeriodo <= #form.PeriodoH#
          </cfif>
          and a.DIOTivacodigo=3
      </cfquery>
      
	<cfquery name="rsRPTdiot"  dbtype="query">
    	select TablaOrigen,Documento, CampoId ,SNnombre, DIOTcodigo,  DIOTopcodigo, 
           SNidentificacion, IdFisc,Ppais,Nacional, SNcodigo, 
          		sum(IvaOtros) IvaOtros,
                sum(IvaOtrosPagados) IvaOtrosPagados, 
          	   	sum(IvaExentoOtros) IvaExentoOtros, 
               	sum(IVABienesServicios) IVABienesServicios,
               	sum(IVAPagado) IVAPagado, 
                sum(IVAExeBienesServicios) IVAExeBienesServicios,
               	sum(IVAcero) IVAcero, 
               	sum(IVABienesServiciosPagados) IVABienesServiciosPagados          	   
          FROM rsDiotControl
          group by TablaOrigen,Documento, CampoId ,SNnombre, DIOTcodigo,  DIOTopcodigo, 
           SNidentificacion, IdFisc,Ppais,Nacional, SNcodigo
    </cfquery>
    
	<cfreturn rsRPTdiot>
</cffunction>

</cfcomponent>
