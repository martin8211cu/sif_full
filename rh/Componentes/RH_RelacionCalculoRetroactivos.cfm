<!--------------------------------------------------------------------------------------------------->	
	<!------------------------------------- CALCULO DE RETROACTIVOS ------------------------------------->
	<!--------------------------------------------------------------------------------------------------->	
	<!--- BUSCA TODOS LOS CALENDARIOS DE PAGO DONDE APLICA RETROACTIVO --->
	<!--- TIPO DE NOMINA CPtipo = 0 NORMAL CPtipo = 2 ANTICIPO --->
	<cfif CalendarioPagos.CPtipo Is 0 or CalendarioPagos.CPtipo Is 2>
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempo a, CalendarioPagos d, CalendarioPagos e<cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and d.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPdesde >= d.CPdesde
			  and e.CPtipo in (0,2)
			  and d.CPtipo in (0,2)
			  and e.CPfcalculo is not null
			  <cfif CalendarioPagos.CPtipo Is 2>
				  and a.Ecodigo = de.Ecodigo
				  and a.DEid = de.DEid
				  and de.DEporcAnticipo > 0
				</cfif>
                union
		
		<!---=============================================MCZ--Retroactivos en caso de Recargo========================================================
		========Cuando se utiliza la linea de tiempo de recargos si se toma el salario base y a este no se le restan los componentes salariales del ==
		detalle de la linea del tiempo esto porque si se trabajan con tablas salariales no se les debe de quitar los componentes q ya traia asociados=
		entonces el calculo puede ser incorrecto======================================================================================================			
		==========================================================================================================================================--->
			select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempoR a, CalendarioPagos d, CalendarioPagos e<cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and d.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPdesde >= d.CPdesde
			  and e.CPtipo in (0,2)
			  and d.CPtipo in (0,2)
			  and e.CPfcalculo is not null
			  <cfif CalendarioPagos.CPtipo Is 2>
				  and a.Ecodigo = de.Ecodigo
				  and a.DEid = de.DEid
				  and de.DEporcAnticipo > 0
			</cfif>
		</cfquery>
	
	 <cfelseif CalendarioPagos.CPtipo Is 3 ><!--- CUANDO ES UNA NÓMINA DE RETROACTIVO --->
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			  select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempo a, CalendarioPagos d, CalendarioPagos e
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPtipo in (0,2)
			  and d.CPtipo = 3
			  and e.CPdesde >= d.CPdesde
			  and e.CPfcalculo is not null
			  and e.CPhasta <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			  and d.CPhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
		</cfquery> 
		<!--- RECARGOS--->
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			  select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempoR a, CalendarioPagos d, CalendarioPagos e
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPtipo in (0,2)
			  and d.CPtipo = 3
			  and e.CPdesde >= d.CPdesde
			  and e.CPfcalculo is not null
			  and e.CPhasta <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			  and d.CPhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
		</cfquery>
	</cfif>
    <!---Retroactivos positivos para el primer corte  --->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes, CPperiodo
		)
		select distinct 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
		case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta end, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempo 
										where LTid=a.LTid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		<!---►►Salario de Referencia◄◄--->
        round (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							    from DLineaTiempo 
							 where LTid = a.LTid 
							   and CIid in (select CIid 
												from ComponentesSalariales
											 where Ecodigo = #session.Ecodigo# 
                                               and CIid is not null)
				),2) * coalesce(a.LTporcsal,100)/100,
        0, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempo 
										where LTid=a.LTid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
		a.RVid, a.LTporcplaza, a.LTid,0, a.RHJid, RHJhoradiaria, 1, ce.CPid , b.RHTcomportam, ce.CPmes, ce.CPperiodo
		from #CalendariosEmpleado# ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and a.DEid = ce.DEid
		  and a.Ecodigo = b.Ecodigo
		  and a.RHTid = b.RHTid
		  and a.RHJid = c.RHJid
		  and a.LThasta >= ce.CPdesde
		  <cfif CalendarioPagos.CPtipo NEQ 3 >
 		  and (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid) between a.LTdesde and a.LThasta
		  and a.LTdesde < (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
	</cfquery>
    <!--- CARGA LOS DATOS EN TABLA DE PAGOS DE RECARGO --->
    <cfquery datasource="#session.DSN#">
        insert into #PagosRecargosRetro#(LTRid,RHPid,DEid,PEdesde,PEhasta,PEmontores,PEsalario)
        select a.LTRid,a.RHPid,a.DEid,a.LTdesde, a.LThasta,  
        
        (round
            (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
                                from DLineaTiempoR
                            where LTRid=a.LTRid 
                            and CIid in (select CIid 
                                            from ComponentesSalariales
                                          where Ecodigo=#session.Ecodigo# and CIid is not null
                                         )
                           ),2)
            * coalesce(a.LTporcsal,100)/100),
         (round
            (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
                                from DLineaTiempoR
                            where LTRid=a.LTRid 
                            and CIid in (select CIid 
                                            from ComponentesSalariales
                                          where Ecodigo=#session.Ecodigo# and CIid is not null
                                         )
                           ),2)
            * coalesce(a.LTporcsal,100)/100)
        from #CalendariosEmpleado# ce, LineaTiempoR a, RHTipoAccion b, RHJornadas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and a.DEid = ce.DEid
		  and a.Ecodigo = b.Ecodigo
		  and a.RHTid = b.RHTid
		  and a.RHJid = c.RHJid
          and (ce.CPdesde between LTdesde and LThasta or ce.CPhasta between LTdesde and LThasta)
    </cfquery>
	<!--- SE ELIMINAN LOS CORTE DE RECARGOS QUE SE TRASLAPAN, SE DEJA EL ACTUAL --->
    <cfquery datasource="#session.DSN#">
        delete from #PagosRecargosRetro#
        where LTRid not in(
        select max(LTRid)
        from #PagosRecargosRetro#
        group by RHPid,PEdesde,PEhasta,DEid)
    </cfquery> 
    <cfquery datasource="#Arguments.datasource#">
        update #PagosRecargosRetro#
        set PEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
        where PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
    </cfquery>
    
    <cfquery datasource="#Arguments.datasource#">
        update #PagosRecargosRetro#
        set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
        where PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
    </cfquery>
    <cfquery datasource="#Arguments.datasource#">
        update #PagosRecargosRetro# set PEcantdias = <cf_dbfunction name="datediff" args="PEdesde,PEhasta,DD,true"> + 1
    </cfquery>	
    <cfquery datasource="#Arguments.datasource#">
        update #PagosRecargosRetro# set PEmontores = PEmontores * PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
    </cfquery>
    
	<!---RECARGOS Retroactivos positivos para el primer corte  --->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes, CPperiodo
		)
		select distinct 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
		case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR
										where LTRid=a.LTRid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		<!---►►Salario de Referencia◄◄--->
        round (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
								from DLineaTiempoR
							 where LTRid = a.LTRid 
							   and CIid in (select CIid 
											  from ComponentesSalariales
											where Ecodigo = #session.Ecodigo# 
                                              and CIid is not null)
			  ),2) * coalesce(a.LTporcsal,100)/100,
        0, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR
										where LTRid=a.LTRid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
		a.RVid, a.LTporcplaza,0, a.LTRid, a.RHJid, RHJhoradiaria, 1, ce.CPid , b.RHTcomportam, ce.CPmes, ce.CPperiodo
		from #CalendariosEmpleado# ce, LineaTiempoR a, RHTipoAccion b, RHJornadas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and a.DEid = ce.DEid
		  and a.Ecodigo = b.Ecodigo
		  and a.RHTid = b.RHTid
		  and a.RHJid = c.RHJid
		  and a.LThasta >= ce.CPdesde
          and a.LTRid = (select max(LTRid) from LineaTiempoR where DEid = a.DEid and RHPid = a.RHPid and LTdesde = a.LTdesde)
          and a.LTRid in(select LTRid from #PagosRecargosRetro#)
		  <cfif CalendarioPagos.CPtipo NEQ 3 >
 		  and (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid) between a.LTdesde and a.LThasta
		  and a.LTdesde < (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
	</cfquery>

    <!---  Retroactivos positivos con corte posterior al primer dia del mes seleccionado --->
	<!--- APLICA SOLO PARA LAS OTRAS NOMINAS PORQUE LA DE RETROACTIVOS YA TIENE LOS CORTES EN EL QUERY ANTERIOR --->
	 <cfif CalendarioPagos.CPtipo NEQ 3 > 
		<cfquery datasource="#Arguments.datasource#">
			insert into #PagosEmpleado# (
			RCNid, DEid, PEbatch, 
			PEdesde, 
			PEhasta, 
			PEsalario, 
            PEsalarioref, 
			PEcantdias, 
			PEmontores, 
			PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
			RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes,CPperiodo
			)
			select distinct 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
			case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
			case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempo 
							where LTid=a.LTid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	 
			<!---►►Salario de Referencia◄◄--->
            round ((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							        from DLineaTiempo 
							     where LTid = a.LTid 
                                   and CIid in (select CIid 
                                                   from ComponentesSalariales 
                                                where Ecodigo = #session.Ecodigo# 
                                                  and CIid is not null)
                               ))
							* coalesce(LTporcsal,100)/100,2),
            0, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempo 
							where LTid=a.LTid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	
			0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
			a.RVid, a.LTporcplaza, a.LTid,0, a.RHJid, RHJhoradiaria, 1, ce.CPid, b.RHTcomportam,ce.CPmes,ce.CPperiodo
			from #CalendariosEmpleado# ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  and a.DEid = ce.DEid
			  and a.Ecodigo = b.Ecodigo
			  and a.RHTid = b.RHTid
			  and a.RHJid = c.RHJid
			  and a.LThasta >= ce.CPdesde
			  and a.LTdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
			  and a.LTdesde <= ce.CPhasta
			  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		</cfquery>
		<!--- RECARGOS --->
		<cfquery datasource="#Arguments.datasource#">
			insert into #PagosEmpleado# (
			RCNid, DEid, PEbatch, 
			PEdesde, 
			PEhasta, 
			PEsalario, 
            PEsalarioref, 
			PEcantdias, 
			PEmontores, 
			PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
			RVid, LTporcplaza, LTid, LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes,CPperiodo
			)
			select distinct 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
			case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
			case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempoR 
							where LTRid=a.LTRid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	 
			<!---►►Salario de Referencia◄◄--->
            round ((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							        from DLineaTiempoR 
							     where LTRid = a.LTRid 
                                   and CIid in (select CIid 
                                                 from ComponentesSalariales 
                                                where Ecodigo = #session.Ecodigo# 
                                                  and CIid is not null)
                     )) * coalesce(LTporcsal,100)/100,2),
            0, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempoR 
							where LTRid=a.LTRid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	
			0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
			a.RVid, a.LTporcplaza,0, a.LTRid, a.RHJid, RHJhoradiaria, 1, ce.CPid, b.RHTcomportam,ce.CPmes,ce.CPperiodo
			from #CalendariosEmpleado# ce, LineaTiempoR a, RHTipoAccion b, RHJornadas c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  and a.DEid = ce.DEid
			  and a.Ecodigo = b.Ecodigo
			  and a.RHTid = b.RHTid
			  and a.RHJid = c.RHJid
              and a.LTRid in(select max(LTRid) from LineaTiempoR where DEid = a.DEid and RHPid = a.RHPid and LTdesde = a.LTdesde)
			  and a.LThasta >= ce.CPdesde
			  and a.LTdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
			  and a.LTdesde <= ce.CPhasta
			  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		</cfquery>
	 </cfif> 
	

	<!---  3. Retroactivos negativos--->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, CPmes, CPperiodo, PEtiporeg,CPid
		)
		select 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		e.PEdesde, 
		e.PEhasta, 
		abs(e.PEsalario),
        <!---►►Salario de Referencia◄◄--->
        abs(e.PEsalarioref),
		<cf_dbfunction name="datediff" args="e.PEdesde,e.PEhasta"> + 1, 
		sum(e.PEmontores*-1), 
		0.00, e.PEdesde, e.PEhasta, e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, 
		e.RVid, 100, LTid,-1, e.RHJid, e.PEhjornada, ce.CPmes, ce.CPperiodo, 2, 733
		from #CalendariosEmpleado# ce, HPagosEmpleado e
		where e.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and e.DEid = ce.DEid
		  and e.RCNid = ce.CPid
		  and e.PEmontores != 0.00
		   <cfif CalendarioPagos.CPtipo NEQ 3 >
		  and e.PEdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and e.PEhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
		group by  ce.DEid, e.PEdesde, e.PEhasta, abs(e.PEsalario), abs(e.PEsalarioref), e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, e.RVid, LTporcplaza, LTid,LTRid,e.RHJid, e.PEhjornada, ce.CPmes, ce.CPperiodo
		having sum(e.PEmontores*-1) != 0
	</cfquery>


 <!--- 2010-03-05 RX PARA EL AJUSTE DE LA CANTIDAD DE DIAS PARA LOS RETROACTIVOS YA PAGADOS --->	   
	<cfquery name="factordias" datasource="#Arguments.datasource#">
		select FactorDiasSalario,Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
	</cfquery>
    <cfif factordias.RecordCount and ( NOT LEN(TRIM(factordias.FactorDiasSalario)) OR factordias.FactorDiasSalario EQ 0)>
    	<cfthrow message="El tipo de Nomina #factordias.Tdescripcion# no tienen defincido el Factor de días para salario diario">
	</cfif>	   
	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado# 	set 
			PEcantdias = round(PEmontores / (PEsalario / <cfqueryparam cfsqltype="cf_sql_float" value="#factordias.FactorDiasSalario#">),2)
		where PEtiporeg=2
	</cfquery>	


	<cfif Arguments.debug>
		<cfquery datasource="#Arguments.datasource#" name="debugCalendariosEmpleado">
			select CPid, DEid, CPdesde, CPhasta
			from #CalendariosEmpleado#
				<cfif IsDefined('Arguments.pDEid')>where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					order by DEid, CPdesde
					select RCNid, DEid, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid 
					from #PagosEmpleado#
				<cfif IsDefined('Arguments.pDEid')>where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>

			order by PEtiporeg, PEdesde
		</cfquery>
		<cfdump var="#debugCalendariosEmpleado#" label="debugCalendariosEmpleado">
	</cfif>

	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado#
		set PEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			, CPmes 	= #LvarCPmes#
			, CPperiodo = #LvarCPperiodo#
		where PEtiporeg = 0 
		  and PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
    </cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado#
		set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
			, CPmes 	= #LvarCPmes#
			, CPperiodo = #LvarCPperiodo#
		where PEtiporeg = 0 
		  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
	</cfquery>

	<cfset PEhasta = DateAdd("d", -1, RCalculoNomina.RCdesde)>
	<!--------------------------------------------------------------------------------------------------->	
	<!--------------------------------- FIN CALCULO DE RETROACTIVOS ------------------------------------->
	<!--------------------------------------------------------------------------------------------------->	