<cffunction name="fnDetalleCCSS1" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- ***************************************************** ---> 
	<!--- Inserto al personal con pagos en el periodo           --->
	<!--- ***************************************************** --->
	<cfquery  datasource="#Session.DSN#" name="LZ">
		insert into  #Temp# (DEid, Numpatronal, Ecodigo, FECHDE, FECHAS, Salario)
		select 
			pe.DEid, 
			'#Arguments.NumeroPatronal#' as NumPat, 
			#session.Ecodigo# as Ecodigo, 
			<cfqueryparam value="#Arguments.fecini#" cfsqltype="cf_sql_date"> as Fecini, 
			<cfqueryparam value="#Arguments.fecfin#" cfsqltype="cf_sql_date"> as FecFin, 
			sum(PEmontores) as Montores
		from CalendarioPagos cp
			inner join  HPagosEmpleado pe
			on pe.RCNid  	= cp.CPid
		where cp.Ecodigo        	= #session.Ecodigo#
		  and cp.CPperiodo     	= #form.CPperiodo#
		  and cp.CPmes          	= #form.CPmes#
		  and cp.CPnocargasley 	= 0
		  and pe.Ocodigo in (#Arguments.ListaOficinas#)
		group by pe.DEid
	</cfquery>
	<!--- ***************************************************** ---> 
	<!--- les actualizo las incidencias                         --->
	<!--- ***************************************************** --->
	<cfquery datasource="#Session.DSN#">
		update #Temp# 
		set Incidencias = coalesce((
				select sum(ICmontores)
				from CalendarioPagos cp 
					inner join HIncidenciasCalculo ic
						on  ic.RCNid    = cp.CPid
					inner join CIncidentes ci
						on  ic.CIid          = ci.CIid
				where   cp.Ecodigo          = #session.Ecodigo#
				and     cp.CPperiodo     	= #form.CPperiodo#
				and     cp.CPmes          	= #form.CPmes#
				and     cp.CPnocargasley 	= 0
				and     ci.CInocargasley 	= 0
				and 	ic.DEid     		= #Temp#.DEid

				),0)
		
	</cfquery>
	

	<!--- ***************************************************** ---> 
	<!--- insert into o al personal con pagos en el periodo anterior  --->
	<!--- ***************************************************** --->
	<cfquery datasource="#Session.DSN#">
		insert into  #Temp# (DEid, Numpatronal, Ecodigo, FECHDE, FECHAS, Salario)
		select 	pe.DEid, 
				'#Arguments.NumeroPatronal#', 
				#session.Ecodigo#, 
				<cfqueryparam value="#Arguments.fecini#" cfsqltype="cf_sql_date"> as Fecini, 
				<cfqueryparam value="#Arguments.fecfin#" cfsqltype="cf_sql_date"> as FecFin, 
				0
		from CalendarioPagos cp
			inner join  HPagosEmpleado pe
				on pe.RCNid  	= cp.CPid
		where cp.Ecodigo        = #session.Ecodigo#
		and cp.CPperiodo     	= #Lvar_periodoA#
		and cp.CPmes          	= #Lvar_mesA#
		and cp.CPnocargasley 	= 0
		and pe.Ocodigo in (#Arguments.ListaOficinas#)
		and 
			(( select count(1)
				from #Temp# p2
				where p2.DEid = pe.DEid
			)) = 0
		group by pe.DEid
	</cfquery>
	<!--- ***************************************************** ---> 
	<!--- les actualizo los pagos recibidos el periodo anterior --->
	<!--- ***************************************************** --->
	<cfquery datasource="#Session.DSN#">
		update #Temp# 
		set Salarioa = coalesce((
				select sum(PEmontores)
				from CalendarioPagos cp 
					inner join HPagosEmpleado pe
					on cp.CPid 			= pe.RCNid 
					and cp.Tcodigo      =  pe.Tcodigo 
	
				where cp.Ecodigo        = #session.Ecodigo#
				and cp.CPperiodo     	= #Lvar_periodoA#   
				and cp.CPmes          	= #Lvar_mesA#
				and cp.CPnocargasley 	= 0
				and #Temp#.DEid 	= pe.DEid 

			),0)
	</cfquery>
	<!--- *********************************************************** ---> 
	<!--- les actualizo las incidencias recibidas el periodo anterior --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		update #Temp# 
		set Incidenciasa = isnull((select sum(ICmontores)
								from CalendarioPagos cp 
								inner join HIncidenciasCalculo ic
									on cp.CPid 		= ic.RCNid 
									
								inner join CIncidentes ci
									on ic.CIid = ci.CIid
									and ci.CInocargasley = 0
								where cp.Ecodigo        	= #session.Ecodigo#
									and cp.CPperiodo     	= #Lvar_periodoA#   
									and cp.CPmes          	= #Lvar_mesA#
									and cp.CPnocargasley 	= 0
									and #Temp#.DEid = ic.DEid 
							),0)
	</cfquery>
	<!--- *********************************************************** ---> 
	<!--- Actualiza la Fecha Max en base al PEdesde                   --->
	<!--- *********************************************************** ---> 
	<cfquery  datasource="#Session.DSN#">
		update #Temp# 
			set Fechamax = (select max(CPhasta)
							from CalendarioPagos cp
							where 	cp.Ecodigo        		= #session.Ecodigo#
									and cp.CPperiodo     	= #form.CPperiodo#   
									and cp.CPmes          	= #form.CPmes#
									and cp.CPnocargasley 	= 0)
	</cfquery>
	<!--- *********************************************************** ---> 
	<!--- Acualiza el Codigo de Puesto                                --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		update #Temp# 
		set RHPcodigo = (select ltrim(rtrim(Max(RHPcodigo)))
							from CalendarioPagos cp
							inner join HPagosEmpleado pe
								on  cp.CPid         = pe.RCNid 
								and cp.Tcodigo      = pe.Tcodigo  
								and pe.PEtiporeg = 0
							where 	cp.Ecodigo        		= #session.Ecodigo#
									and cp.CPperiodo     	= #form.CPperiodo#   
									and cp.CPmes          	= #form.CPmes#
									and cp.CPnocargasley 	= 0		
									and #Temp#.DEid     = pe.DEid			
		)

	 </cfquery>
	<!--- *********************************************************** ---> 
	<!--- Actualiza la Fecha Minima en base al RCdesde de la Nomina   --->
	<!--- *********************************************************** ---> 
	
	<cfquery  datasource="#Session.DSN#">
		update #Temp# 
			set Fechamin = (select min(CPdesde)
							from CalendarioPagos cp
							where 	cp.Ecodigo        		= #session.Ecodigo#
									and cp.CPperiodo     	= #form.CPperiodo#   
									and cp.CPmes          	= #form.CPmes#
									and cp.CPnocargasley 	= 0)
	</cfquery>
	<!--- *********************************************************** ---> 
	<!--- Actualiza la informacion del monto Ganado                   --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		update #Temp# 
			set MONTO = coalesce(Salario,0) + coalesce(Incidencias,0), 
				MONTOa = coalesce(Salarioa,0) + coalesce(Incidenciasa,0)
	</cfquery>
	
</cffunction> 
<cffunction name="fnDetalleCCSS2" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	
	<!--- *********************************************************** ---> 
	<!--- INICIAN LAS INSERCIONES DE REGISTROS 35                     --->
	<!--- *********************************************************** ---> 
	<!--- *********************************************************** ---> 
	<!--- 1. Inserto los Cambio de Salario                            --->
	<!--- *********************************************************** ---> 
	
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid,FECINI,MONTO,TIPCAM,FECFIN,TINCAPACI,RHOcodigo,CONSE)
		select
			a.DEid,
			a.FECHAS,
			a.MONTO,
			'SA',
			null,
			'GEN',
			p.RHOcodigo,
			1.0
		from #Temp# a
		inner join RHPuestos p
			on  a.Ecodigo   = p.Ecodigo
			and a.RHPcodigo = p.RHPcodigo
		where  p.Ecodigo   = #session.Ecodigo#	
	</cfquery>

	
	<!--- *********************************************************** ---> 
	<!--- 2. Inserto las Inclusiones   --->
	<!--- LZ 27-3-1976 Se buscan las Inserciones según la Fecha Desde y Hasta del Mes Calendario, 
		  Se Modifica para que use la Fecha Min y Fecha Max de los Calendarios de Pago del Mes Periodo --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#" name="LZ">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CLAJOR, RHOcodigo, CONSE)
		select  
			a.DEid, 
	<!--- 	la.DLfvigencia  LZ 27-3-1976 Se Elimina esta opción 
							por el CASE para analizar con qué Fecha se Almacenrá de la Inclusión en caso que pertenezca mes anterior (Bisemanas)--->
			case  when 
				la.DLfvigencia < FECHDE then
					 FECHDE
				 else
				  	la.DLfvigencia
			end FechaRige,
			a.MONTO,
			'IC',
			null,
			'GEN',
			j.RHJhoradiaria,
			la.RHJid,
		case
			  when j.RHJtipo = 0 then 'DIU'
			  when j.RHJtipo = 1 then 'MIX'
			  when j.RHJtipo = 2 then 'NOC'
			  when j.RHJtipo = 3 then 'PAR'
			  when j.RHJtipo = 4 then 'VES'
		end,
		p.RHOcodigo,
		2
		from #Temp# a
		inner join DLaboralesEmpleado la
			on 	  a.DEid     = la.DEid
			and   la.Ecodigo = a.Ecodigo
<!---			and   la.DLfvigencia between a.FECHDE and a.FECHAS			--->
			and   la.DLfvigencia between a.Fechamin and a.Fechamax
			and   la.Ocodigo in (#Arguments.ListaOficinas#)
		inner join RHTipoAccion ta
			on    ta.RHTcomportam = 1 -- Es Nombramiento
			and   la.Ecodigo = ta.Ecodigo
			and   ta.RHTid = la.RHTid
		inner join RHJornadas j
			on   la.RHJid = j.RHJid
			and   la.Ecodigo = j.Ecodigo
		inner join RHPuestos p
			on   la.RHPcodigo = p.RHPcodigo
			and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ************************************************************************************************************* ---> 
	<!--- 2.1 Inserto las Inclusiones que se ingresaron el mes pasado aunque la fecha de rige sea antes del mes pasado  --->
	<!--- ************************************************************************************************************* ---> 
	<cfquery datasource="#Session.DSN#" >
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CLAJOR, RHOcodigo, CONSE)
		select  
			a.DEid, 
			a.FECHDE,
			a.MONTO,
			'IC',
			null,
			'GEN',
			j.RHJhoradiaria,
			la.RHJid,
			case
				  when j.RHJtipo = 0 then 'DIU'
				  when j.RHJtipo = 1 then 'MIX'
				  when j.RHJtipo = 2 then 'NOC'
				  when j.RHJtipo = 3 then 'PAR'
				  when j.RHJtipo = 4 then 'VES'
			end,
			p.RHOcodigo,
			2.1
		from #Temp# a
		inner join DLaboralesEmpleado la
			on 	  a.DEid = la.DEid
			and   la.Ecodigo = a.Ecodigo
			and   la.DLfvigencia < a.FECHDE
			and   la.DLfechaaplic between a.Fechamin and a.FECHAS 
			and   la.Ocodigo in (#Arguments.ListaOficinas#)
			and   not exists (select 1 from LineaTiempo x where x.DEid = la.DEid and <cf_dbfunction name="dateadd" args="1, LThasta"> = la.DLfvigencia)
	
		inner join RHTipoAccion ta
			on    ta.RHTcomportam = 1 -- Es Nombramiento
			and   la.Ecodigo = ta.Ecodigo
			and   ta.RHTid = la.RHTid
		inner join RHJornadas j
			on    la.RHJid = j.RHJid
			and   la.Ecodigo = j.Ecodigo
		inner join RHPuestos p
			on    la.RHPcodigo = p.RHPcodigo
			and   la.Ecodigo = p.Ecodigo
		where not exists (select 1 from #registro35# q where q.DEid = a.DEid and q.TIPCAM = 'IC')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CLAJOR, RHOcodigo, CONSE)
		select  
				distinct 
				a.DEid, 
				#Arguments.fecini#,
				a.MONTO,
				'IC',
				null,
				'GEN',
				j.RHJhoradiaria,
				lt.RHJid,
			case
				  when j.RHJtipo = 0 then 'DIU'
				  when j.RHJtipo = 1 then 'MIX'
				  when j.RHJtipo = 2 then 'NOC'
				  when j.RHJtipo = 3 then 'PAR'
				  when j.RHJtipo = 4 then 'VES'
			end,
			p.RHOcodigo,
			2
			from #Temp# a
			inner join RHRepCCSS  x
				on 	  a.DEid     = x.DEid
				and (  x.RHRCCSSfecha between  #Arguments.fecini# and #Arguments.fecfin#
				or    x.Aplicado       = 0)
			inner join LineaTiempo lt
				on 	  a.DEid     = lt.DEid
				and   lt.Ecodigo = a.Ecodigo
				and   lt.Ocodigo in (#Arguments.ListaOficinas#)
 			    and   (lt.LTdesde >  #Arguments.fecfin#
				or  lt.LThasta < #Arguments.fecini# )
			inner join RHJornadas j
				on   lt.RHJid = j.RHJid
				and   lt.Ecodigo = j.Ecodigo
			inner join RHPuestos p
				on   lt.RHPcodigo = p.RHPcodigo
				and  lt.Ecodigo = p.Ecodigo
		where not exists (select 1 from #registro35# q where q.DEid = a.DEid and q.TIPCAM = 'IC')
	</cfquery>
	<!--- *********************************************************** ---> 
	<!--- 3. Inserto las Inclusiones por movimientos de planilla      --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CLAJOR, RHOcodigo, CONSE)
		select
			lt.DEid, 
			lt.LTdesde,
			a.MONTO,
			'IC',
			null,
			'GEN',
			j.RHJhoradiaria,
			lt.RHJid,
			case
				  when j.RHJtipo = 0 then 'DIU'
				  when j.RHJtipo = 1 then 'MIX'
				  when j.RHJtipo = 2 then 'NOC'
				  when j.RHJtipo = 3 then 'PAR'
				  when j.RHJtipo = 4 then 'VES'
			end,
			p.RHOcodigo,3
		from #Temp# a
		inner join LineaTiempo lt
			on   lt.DEid =  a.DEid
			and  lt.LTdesde between a.FECHDE and a.FECHAS
		inner join LineaTiempo lta
		   on  lta.DEid = lt.DEid
		   and lta.LTdesde < lt.LTdesde
		   and lta.LThasta = <cf_dbfunction name="dateadd" args="-1, lt.LTdesde">
		   and lta.Ocodigo != lt.Ocodigo
		   and lt.Ocodigo in  (#Arguments.ListaOficinas#)
		inner join RHPuestos p
		   on  p.RHPcodigo = lt.RHPcodigo
		   and p.Ecodigo   = lt.Ecodigo
		inner join RHJornadas j
		   on j.RHJid = lt.RHJid
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS3" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- *********************************************************** ---> 
	<!--- 4. Inserto los cambios de Jornada de la linea del tiempo    --->
	<!--- *********************************************************** ---> 
	
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CLAJOR, RHOcodigo,CONSE)
		select
			lt.DEid, 
			lt.LTdesde,
			a.MONTO, 
			'JO', 
			lt.LThasta,
			null,
			j.RHJhoradiaria, lt.RHJid,
			case
				  when j.RHJtipo = 0 then 'DIU'
				  when j.RHJtipo = 1 then 'MIX'
				  when j.RHJtipo = 2 then 'NOC'
				  when j.RHJtipo = 3 then 'PAR'
				  when j.RHJtipo = 4 then 'VES'
			end,
			RHOcodigo, 
			4
		from #Temp# a
		inner join LineaTiempo lt
			on  lt.DEid =  a.DEid
		   and  lt.LTdesde between a.FECHDE and a.FECHAS
		   and  lt.Ocodigo in (#Arguments.ListaOficinas#)
		inner join LineaTiempo lta
		   on  lta.DEid = lt.DEid
		   and lta.LTdesde < lt.LTdesde
		   and lta.LThasta =<cf_dbfunction name="dateadd" args="-1, lt.LTdesde">
		   and lta.RHJid != lt.RHJid
		inner join RHJornadas j
		  on  j.RHJid = lt.RHJid
		inner join RHPuestos p
		   on  p.RHPcodigo = lt.RHPcodigo
		   and p.Ecodigo      = lt.Ecodigo		  
	</cfquery>
	
	<!--- *********************************************************** ---> 
	<!--- 5. Inserto los cambios de puesto de la linea del tiempo     --->
	<!--- *********************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHOcodigo, CONSE)
		select
			lt.DEid, 
			lt.LTdesde,
			a.MONTO, 
			'OC', 
			'', 
			null, 
			null, 
			RHOcodigo, 
			5
		from #Temp# a 
		inner join LineaTiempo lt
			on  lt.DEid =  a.DEid
		   and  lt.LTdesde between a.FECHDE and a.FECHAS
   		   and  lt.Ocodigo in (#Arguments.ListaOficinas#)
		inner join LineaTiempo lta
		   on lta.DEid = lt.DEid
		   and lta.LTdesde < lt.LTdesde
		   and lta.LThasta = <cf_dbfunction name="dateadd" args="-1, lt.LTdesde">
		   and lta.RHPcodigo != lt.RHPcodigo
		inner join RHPuestos p
		   on  p.RHPcodigo = lt.RHPcodigo
		   and p.Ecodigo      = lt.Ecodigo
	</cfquery>  
	<!--- ***************************************************************** ---> 
	<!--- 6 Inserto las incapacidades del periodo                           --->
	<!--- 6.1 Agrega a las personas que si tienen un salario en el mes.     --->
	<!--- ***************************************************************** ---> 
	<cfquery datasource="#Session.DSN#" name="cc">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CONSE) 
		 select
			sp.DEid,
			(case when sp.RHSPEfdesde <  #Arguments.fecini#
				then #Arguments.fecini#
			else 
				sp.RHSPEfdesde end),  
			a.MONTO,
			'IN',
			(case when sp.RHSPEfhasta > #Arguments.fecfin#    
				then #Arguments.fecfin# 
			else 
				sp.RHSPEfhasta end), 
			rh.RHTdatoinforme, 
			null, 
			null, 
			6.1
		 from #Temp# a 
		 inner join RHSaldoPagosExceso sp
			 on   a.DEid =  sp.DEid
			 and  a.Ecodigo = sp.Ecodigo
		
			 and   (
					( sp.RHSPEfdesde >= #Arguments.fecini# and  sp.RHSPEfhasta <= #Arguments.fecfin#) or
					( sp.RHSPEfdesde <= #Arguments.fecini# and  sp.RHSPEfhasta < #Arguments.fecfin# and sp.RHSPEfhasta > #Arguments.fecini#) or
					( sp.RHSPEfdesde <= #Arguments.fecini# and  sp.RHSPEfhasta >= #Arguments.fecfin#) or
					( sp.RHSPEfdesde > #Arguments.fecini# and sp.RHSPEfdesde < #Arguments.fecfin# and  sp.RHSPEfhasta >= #Arguments.fecfin#)            )
			 
		 inner join RHTipoAccion rh
			 on   sp.RHTid = rh.RHTid
			 and  sp.Ecodigo = rh.Ecodigo
			 and  sp.RHSPEanulado = 0
			 and  rh.RHTcomportam = 5
	</cfquery>
	
	<cfquery datasource="#Session.DSN#" name="cc">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CONSE) 
		  select
			lt.DEid,
			(case when lt.LTdesde <  #Arguments.fecini#
				then #Arguments.fecini#
			else 
				lt.LTdesde end),  
			a.MONTO,
			'IN',
			(case when lt.LThasta > #Arguments.fecfin#    
				then #Arguments.fecfin# 
			else 
				lt.LThasta end), 
			rh.RHTdatoinforme, 
			null, 
			null, 
			6.1
		 from #Temp# a 
		 inner join LineaTiempo lt
			 on   a.DEid =  lt.DEid
			 and  a.Ecodigo = lt.Ecodigo
		
			 and   (
					( lt.LTdesde >= #Arguments.fecini# and  lt.LThasta <= #Arguments.fecfin#) or
					( lt.LTdesde <= #Arguments.fecini# and  lt.LThasta < #Arguments.fecfin# and lt.LThasta > #Arguments.fecini#) or
					( lt.LTdesde <= #Arguments.fecini# and  lt.LThasta >= #Arguments.fecfin#) or
					( lt.LTdesde > #Arguments.fecini# and lt.LTdesde < #Arguments.fecfin# and  lt.LThasta >= #Arguments.fecfin#)            )
		 inner join RHTipoAccion rh
			 on   lt.RHTid = rh.RHTid
			 and  lt.Ecodigo = rh.Ecodigo
			 and  rh.RHTcomportam = 5
	</cfquery>
	<!--- ******************************************************************************* ---> 
	<!--- 6.2 Agrega a las personas con una incapacidad larga que no les paga salario     --->
	<!--- ******************************************************************************* ---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, RHOcodigo, CONSE ) 
		select 
			sp.DEid, 
			#Arguments.fecfin#,
			0.00, 
			'IN', 
			null, 
			rh.RHTdatoinforme, 
			null, 
			null, 
			p.RHOcodigo, 
			6.21
		from LineaTiempo lt
		inner join RHSaldoPagosExceso sp
			on    sp.RHSPEanulado = 0	
			and   lt.DEid = sp.DEid
			and   (
					(sp.RHSPEfdesde >= #Arguments.fecini# 
					 and  sp.RHSPEfhasta <= #Arguments.fecfin#) or
					(sp.RHSPEfdesde < #Arguments.fecini# 
					 and  sp.RHSPEfhasta > #Arguments.fecfin#) )	
		inner join RHTipoAccion rh
			on    rh.RHTcomportam = 5
			and	sp.RHTid = rh.RHTid
			and   sp.Ecodigo = rh.Ecodigo
		inner join RHPuestos p
			on    lt.RHPcodigo = p.RHPcodigo
			and   lt.Ecodigo = p.Ecodigo
		where    lt.DEid not in (select X.DEid from #registro35# X)
			and   (( lt.LTdesde <= #Arguments.fecini# 
			and lt.LThasta >= #Arguments.fecfin#) 
			or (lt.LThasta >= #Arguments.fecini#
			and lt.LTdesde <= #Arguments.fecfin#))
			and  lt.Ocodigo in (#Arguments.ListaOficinas#)
			and  lt.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, RHOcodigo, CONSE ) 
		select 
			lt.DEid, 
			#Arguments.fecfin#,
			0.00, 
			'IN', 
			null, 
			rh.RHTdatoinforme, 
			null, 
			null, 
			p.RHOcodigo, 
			6.21
		from LineaTiempo lt
	
		inner join RHTipoAccion rh
			on    rh.RHTcomportam = 5
			and	  lt.RHTid = rh.RHTid
			and   lt.Ecodigo = rh.Ecodigo
		inner join RHPuestos p
			on    lt.RHPcodigo = p.RHPcodigo
			and   lt.Ecodigo = p.Ecodigo
		where    lt.DEid not in (select X.DEid from #registro35# X)
			and   (( lt.LTdesde <= #Arguments.fecini# 
			and lt.LThasta >= #Arguments.fecfin#) 
			or (lt.LThasta >= #Arguments.fecini#
			and lt.LTdesde <= #Arguments.fecfin#))
			and  lt.Ocodigo in (#Arguments.ListaOficinas#)
			and  lt.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	
	
	
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, RHOcodigo, CONSE)
		select 
			distinct lt.DEid,
			(case when lt.LTdesde < #Arguments.fecini# 
				then #Arguments.fecini#
			 else 
				lt.LTdesde end), <!--- lt.LTdesde --->
			(case  when exists (select 1 from #Temp# t where lt.DEid = t.DEid) 
				then (select MONTO from #Temp# t1 where lt.DEid = t1.DEid)
				else 0.00 end),
			'SA',
			(case when lt.LThasta > #Arguments.fecfin# 
				then #Arguments.fecfin# 
			else 
				 lt.LThasta end),<!---  lt.LThasta --->
			null, 
			null, 
			null, 
			p.RHOcodigo,  
			6.22
		from LineaTiempo lt 
		inner join RHTipoAccion rh
			on    lt.RHTid = rh.RHTid
			and   rh.RHTcomportam = 5
		inner join RHSaldoPagosExceso sp
			on   (
					(sp.RHSPEfdesde >= #Arguments.fecini# 
					and  sp.RHSPEfhasta <= #Arguments.fecfin#) or
					(sp.RHSPEfdesde < #Arguments.fecini# 
					and  sp.RHSPEfhasta > #Arguments.fecfin#) )
			and   sp.RHTid = rh.RHTid
			and   sp.Ecodigo = rh.Ecodigo
			and   sp.RHSPEanulado = 0
			and   lt.DEid = sp.DEid
		inner join RHPuestos p
			on   lt.RHPcodigo = p.RHPcodigo
			and   lt.Ecodigo = p.Ecodigo	
		where    lt.Ecodigo = #session.Ecodigo#
   		    and  lt.Ocodigo in (#Arguments.ListaOficinas#)
			and  lt.DEid not in (select DEid from #registro35# where TIPCAM = 'SA')
			and  ((lt.LTdesde <= #Arguments.fecini# 
			and   lt.LThasta >= #Arguments.fecfin#) 
			or 	  (lt.LThasta >= #Arguments.fecini#  
			and 	lt.LTdesde <= #Arguments.fecfin#))
	</cfquery>
	<!--- ******************************************************************************* ---> 
	<!--- 6.3 Agrega las incapacidades de las personas que se les sustituye el salario    --->
	<!--- ******************************************************************************* ---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CONSE)
		 select 
			distinct sp.DEid,
			(case when sp.RHSPEfdesde < #Arguments.fecini# 
				then 
				#Arguments.fecini#
			 else 
				sp.RHSPEfdesde	 end),
			a.MONTO, 
			'IN',
			(case when sp.RHSPEfhasta > #Arguments.fecfin# 
				then 
				#Arguments.fecfin#
			 else 
				sp.RHSPEfhasta  end),
			rh.RHTdatoinforme, 
			null, 
			null, 
			6.3
		 from #registro35# a 
		 inner join RHSaldoPagosExceso sp
			 on   a.DEid =  sp.DEid
			 and  sp.DEid  not in (select DEid from #Temp#)
			 and  sp.Ecodigo = #session.Ecodigo#
			 and   (
						(sp.RHSPEfdesde >= #Arguments.fecini# 
							and  sp.RHSPEfhasta <= #Arguments.fecfin#) or
						(sp.RHSPEfdesde <= #Arguments.fecini# 
							and  sp.RHSPEfhasta < #Arguments.fecfin# 
							and sp.RHSPEfhasta > #Arguments.fecini#) or
						(sp.RHSPEfdesde <= #Arguments.fecini# 
							and  sp.RHSPEfhasta >= #Arguments.fecfin#) or
						(sp.RHSPEfdesde > #Arguments.fecini#
							and sp.RHSPEfdesde < #Arguments.fecfin# 
							and  sp.RHSPEfhasta >= #Arguments.fecfin#)            )
			 and  sp.RHSPEanulado = 0
		 inner join RHTipoAccion rh
			on  rh.RHTcomportam = 5
			and  sp.RHTid = rh.RHTid
			and  sp.Ecodigo = rh.Ecodigo 
	</cfquery>
	<!--- ******************************************************************************* ---> 
	<!--- 6.4  Agrega las incapacidades de las personas que se les sustituye el salario   --->
	<!--- ******************************************************************************* ---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, CONSE)
			 select 
			 distinct lt.DEid,
			 (case when lt.LTdesde < #Arguments.fecini# 
				then #Arguments.fecini# 
				else lt.LTdesde  end), <!--- lt.LTdesde --->
			 0.00, 
			 'IN',
			 (case when lt.LThasta > #Arguments.fecfin# 
				then #Arguments.fecfin#
				else lt.LThasta end), <!--- lt.LThasta --->
			 rh.RHTdatoinforme, 
			 null, 
			 null, 
			 6.4
		 from LineaTiempo lt 
		 inner join RHTipoAccion rh
			 on  lt.Ecodigo = rh.Ecodigo
			 and lt.RHTid   = rh.RHTid
			 and rh.RHTcomportam = 5
		 inner join ConceptosTipoAccion ct
			 on rh.RHTid = ct.RHTid
			 and ct.CTAsalario = 1
		 where lt.Ecodigo = #session.Ecodigo#
   		     and  lt.Ocodigo in (#Arguments.ListaOficinas#)
			 and   (
					(lt.LTdesde >= #Arguments.fecini# 
					and  lt.LThasta <= #Arguments.fecfin#) or
					(lt.LTdesde <= #Arguments.fecini# and  
					lt.LThasta < #Arguments.fecfin# 
					and lt.LThasta > #Arguments.fecini#) or
					(lt.LTdesde <= #Arguments.fecini# 
					and  lt.LThasta >= #Arguments.fecfin#) or
					( lt.LTdesde >   #Arguments.fecini# 
					and lt.LTdesde  < #Arguments.fecfin# 
					and  lt.LThasta >= #Arguments.fecfin#))
					
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS4" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- ***************************************************************************************************** ---> 
	<!--- 6.5  Agrega el cambio de salario para incapacidades de las personas que se les sustituye el salario   --->
	<!--- ***************************************************************************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHJid, RHOcodigo, CONSE)
			 select 
			 distinct lt.DEid,
			 (case when lt.LTdesde < #Arguments.fecini# 
				then #Arguments.fecini#
				else lt.LTdesde  end),<!--- lt.LTdesde --->
			 (case  when exists (select 1 from #Temp# t where lt.DEid = t.DEid) 
				then (select MONTO from #Temp# t1 where lt.DEid = t1.DEid)
				else 0.00 end)
			 ,'SA',
			 (case when lt.LThasta > #Arguments.fecfin# 
				then #Arguments.fecfin# 
				else lt.LThasta  end),<!--- lt.LThasta --->
			 null, 
			 null, 
			 null, 
			 p.RHOcodigo,  
			 6.5
		 from LineaTiempo lt 
		 inner join  RHTipoAccion rh
			 on lt.Ecodigo = rh.Ecodigo
			 and lt.RHTid = rh.RHTid
			 and rh.RHTcomportam = 5
		 inner join ConceptosTipoAccion ct
			 on  ct.CTAsalario = 1
			 and rh.RHTid = ct.RHTid
		 inner join RHPuestos p
			 on  lt.RHPcodigo = p.RHPcodigo
			 and lt.Ecodigo = p.Ecodigo
		 where lt.Ecodigo = #session.Ecodigo#
			 and  lt.Ocodigo in (#Arguments.ListaOficinas#)
			 and   (
						(lt.LTdesde >= #Arguments.fecini# and  
						 lt.LThasta <= #Arguments.fecfin#) or
						(lt.LTdesde <= #Arguments.fecini# and  
						 lt.LThasta < #Arguments.fecfin# and 
						 lt.LThasta > #Arguments.fecini#) or
						(lt.LTdesde <= #Arguments.fecini# and  
						 lt.LThasta >= #Arguments.fecfin#) or
						(lt.LTdesde >   #Arguments.fecini# and 
						 lt.LTdesde  < #Arguments.fecfin# and  
						 lt.LThasta >= #Arguments.fecfin#)  )
			 and not exists (select 1 from #registro35# k where k.DEid = lt.DEid and k.TIPCAM = 'SA')
	</cfquery>
	<!--- ***************************************** ---> 
	<!---  7. Inserto los Permisos con y sin goce   --->
	<!---  7.1 Con Sueldo del mismo mes             --->
	<!--- ***************************************** ---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'PE', 
			DLffin, 
			ta.RHTdatoinforme , 
			p.RHOcodigo, 
			7.1
		 from #Temp# a
		 inner join  DLaboralesEmpleado la
			 on a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLffin <= a.FECHAS
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and   ta.RHTpaga = 0      <!--- -- Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ****************************---> 
	<!--- 7.1.1 salario del periodo   --->
	<!--- ****************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid , 
			la.DLfvigencia, 
			a.MONTO, 
			'SA', 
			DLffin, 
			null, 
			p.RHOcodigo, 
			7.11
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLffin <= a.FECHAS
 			 and  la.Ocodigo in (#Arguments.ListaOficinas#)
			 and   not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
		 
		 inner join RHTipoAccion ta
			 on   ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and  ta.RHTpaga = 0      <!--- -- Paga --->
			 and  la.Ecodigo = ta.Ecodigo
			 and  ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ****************************************************************************---> 
	<!--- 7.2 Con Sueldo que se inicio en meses anteriores y finalizan en el actual   --->
	<!--- ****************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'PE', 
			DLffin,  
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.2
		 from #Temp# a 
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia < a.FECHDE
			 and   la.DLffin >= a.FECHDE
			 and   la.DLffin <= a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and   ta.RHTpaga = 0 <!--- -- Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and  la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ****************************************************************************---> 
	<!--- 7.2.1 Cambio de salario                                                     --->
	<!--- ****************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
	  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
	  select  
		a.DEid, 
		la.DLfvigencia, 
		a.MONTO, 'SA', 
		DLffin,
		null, 
		p.RHOcodigo, 
		7.21
	  from #Temp# a
	  inner join DLaboralesEmpleado la
		  on a.DEid = la.DEid
		  and   la.Ecodigo = #session.Ecodigo#
		  and   la.DLfvigencia < a.FECHDE
		  and   la.DLffin >= a.FECHDE
		  and   la.DLffin <= a.FECHAS
		  and   la.Ocodigo in (#Arguments.ListaOficinas#)
		  and   not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
	  inner join RHTipoAccion ta
		  on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
		  and   ta.RHTpaga = 0 <!--- -- Paga --->
		  and   la.Ecodigo = ta.Ecodigo
		  and   ta.RHTid = la.RHTid
	  inner join RHPuestos p
		  on    la.RHPcodigo = p.RHPcodigo
		  and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ******************************************************************************---> 
	<!--- 7.3 Con Sueldo que se inicio en meses anteriores y finalizan en Meses futuros --->
	<!--- ******************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			a.FECHDE,
			a.MONTO, 
			'PE', 
			a.FECHAS,
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.3
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia < a.FECHDE
			 and   la.DLfvigencia < a.FECHAS
			 and   la.DLffin >= a.FECHDE
			 and   la.DLffin >= a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and   ta.RHTpaga = 0 <!--- -- Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.3.1 Con Sueldo que se inicio en meses anteriores y finalizan en Meses futuros --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		  select  
			a.DEid, 
			a.FECHDE,
			a.MONTO, 'SA', 
			a.FECHAS,
			null, 
			p.RHOcodigo, 
			7.31
		  from #Temp# a
		  inner join DLaboralesEmpleado la
			  on    a.DEid = la.DEid
			  and   la.Ecodigo = #session.Ecodigo#
			  and   la.DLfvigencia < a.FECHDE
			  and   la.DLfvigencia < a.FECHAS
			  and   la.DLffin >= a.FECHDE
			  and   la.DLffin >= a.FECHAS
  			  and   la.Ocodigo in (#Arguments.ListaOficinas#)

			  and not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
		  inner join RHTipoAccion ta
			  on   ta.RHTcomportam = 4 -- Es Permiso
			  and   ta.RHTpaga = 0 -- Paga
			  and   la.Ecodigo = ta.Ecodigo
			  and   ta.RHTid = la.RHTid
		inner join RHPuestos p
			  on    la.RHPcodigo = p.RHPcodigo
			  and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.4 Con Sueldo que se inicio en mes actual y finalizan en Meses futuros         --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia,
			a.MONTO, 
			'PE', 
			a.FECHAS,
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.4
		 from #Temp# a 
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLfvigencia <= a.FECHAS
			 and   la.DLffin >= a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
			 
		 inner join RHTipoAccion ta
			 on   ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and   ta.RHTpaga = 0 <!--- -- Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.4.1 Cambio de Salario                                                         --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		  select  
			 a.DEid, 
			 la.DLfvigencia, 
			 a.MONTO, 
			 'SA', 
			 a.FECHAS,
			 null, 
			 p.RHOcodigo, 
			 7.41
		  from #Temp# a
		  inner join DLaboralesEmpleado la
			  on    a.DEid = la.DEid
			  and   la.Ecodigo = #session.Ecodigo#
			  and   la.DLfvigencia >= a.FECHDE
			  and   la.DLfvigencia <= a.FECHAS
			  and   la.DLffin >= a.FECHAS
			  and   la.Ocodigo in (#Arguments.ListaOficinas#)
			  and   not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')  
		  inner join RHTipoAccion ta
			  on   ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			  and   ta.RHTpaga = 0 <!--- -- Paga --->
			  and   la.Ecodigo = ta.Ecodigo
			  and   ta.RHTid = la.RHTid
		  inner join RHPuestos p
			  on   la.RHPcodigo = p.RHPcodigo
			  and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.5 Sin Sueldo del mismo mes                                                    --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'PE', 
			DLffin,
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.5
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLffin <= a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			 and   ta.RHTpaga > 0 <!--- -- No Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!---  7.5.1 Cambio de Sueldo del mismo mes                                           --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		  select  
			a.DEid, 
			la.DLfvigencia,
			a.MONTO, 
			'SA', 
			DLffin,
			null, 
			p.RHOcodigo, 
			7.51
		  from #Temp# a
		  inner join DLaboralesEmpleado la
			  on    a.DEid = la.DEid
			  and   la.Ecodigo = #session.Ecodigo#
			  and   la.DLfvigencia >= a.FECHDE
			  and   la.DLffin <= a.FECHAS
   			  and   la.Ocodigo in (#Arguments.ListaOficinas#)
			  and not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
		  inner join RHTipoAccion ta
			  on    ta.RHTcomportam = 4 <!--- -- Es Permiso --->
			  and   ta.RHTpaga > 0 <!--- -- No Paga --->
			  and   la.Ecodigo = ta.Ecodigo
			  and   ta.RHTid = la.RHTid
		  inner join RHPuestos p
			  on   la.RHPcodigo = p.RHPcodigo
			  and   la.Ecodigo = p.Ecodigo
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS5" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- ********************************************************************************---> 
	<!--- 7.6 Sin Sueldo que se inicio en meses anteriores y finalizan en el actual       --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			a.FECHDE, 
			a.MONTO, 
			'PE', 
			DLffin, 
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.6
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia < a.FECHDE
			 and   la.DLffin >= a.FECHDE
			 and   la.DLffin <= a.FECHAS
	 	     and   la.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			 and   ta.RHTpaga > 0 <!---  No Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.6.1 Cambio de Salario                                                         --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		  select  
			a.DEid, 
			a.FECHDE, 
			a.MONTO, 
			'SA', 
			DLffin, 
			null, 
			p.RHOcodigo, 
			7.61
		  from #Temp# a
		  inner join DLaboralesEmpleado la
			  on    a.DEid = la.DEid
			  and   la.Ecodigo = #session.Ecodigo#
			  and   la.DLfvigencia < a.FECHDE
			  and   la.DLffin >= a.FECHDE
			  and   la.DLffin <= a.FECHAS
	          and   la.Ocodigo in (#Arguments.ListaOficinas#)			  
			  and   not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
		  inner join RHTipoAccion ta
			  on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			  and   ta.RHTpaga > 0 <!---  No Paga --->
			  and   la.Ecodigo = ta.Ecodigo
			  and   ta.RHTid = la.RHTid
		  inner join RHPuestos p
			  on    la.RHPcodigo = p.RHPcodigo
			  and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.7 Sin Sueldo que se inicio en meses anteriores y finalizan en Meses futuros   --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			a.FECHDE, 
			a.MONTO, 
			'PE', 
			a.FECHAS, 
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.7
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia < a.FECHDE
			 and   la.DLfvigencia < a.FECHAS
			 and   la.DLffin >= a.FECHDE
			 and   la.DLffin >= a.FECHAS
	         and   la.Ocodigo in (#Arguments.ListaOficinas#)			 	 
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			 and   ta.RHTpaga > 0 <!---  No Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid	 
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.7.1 Sin Salario en el mes                                                     --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		  select  
			a.DEid, 
			a.FECHDE, 
			a.MONTO, 
			'SA', 
			a.FECHAS, 
			null, 
			p.RHOcodigo, 
			7.71
		  from #Temp# a
		  inner join DLaboralesEmpleado la
			  on    a.DEid = la.DEid
			  and   la.Ecodigo = #session.Ecodigo#
			  and   la.DLfvigencia < a.FECHDE
			  and   la.DLfvigencia < a.FECHAS
			  and   la.DLffin >= a.FECHDE
			  and   la.DLffin >= a.FECHAS
	          and   la.Ocodigo in (#Arguments.ListaOficinas#)			  
			  and not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')	  
		  inner join RHTipoAccion ta
			  on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			  and   ta.RHTpaga > 0 <!---  No Paga --->
			  and   la.Ecodigo = ta.Ecodigo
			  and   ta.RHTid = la.RHTid
		  inner join RHPuestos p
			  on    la.RHPcodigo = p.RHPcodigo
			  and   la.Ecodigo = p.Ecodigo
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS6" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- ********************************************************************************---> 
	<!--- 7.8 Sin Sueldo que se inicio en mes actual y finalizan en Meses futuros         --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'PE', 
			a.FECHAS, 
			ta.RHTdatoinforme, 
			p.RHOcodigo, 
			7.8
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLfvigencia <= a.FECHAS
			 and   la.DLffin >= a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)	 
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			 and   ta.RHTpaga > 0 <!---  No Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 7.8.1 Cambio del salario                                                        --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid , 
			la.DLfvigencia, 
			a.MONTO, 
			'SA', 
			a.FECHAS, 
			null, 
			p.RHOcodigo, 
			7.81
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia >= a.FECHDE
			 and   la.DLfvigencia <= a.FECHAS
			 and   la.DLffin >= a.FECHAS
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)	 
			 and not exists (select 1 from #registro35# k where k.DEid = la.DEid and k.TIPCAM = 'SA')
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 4 <!---  Es Permiso --->
			 and   ta.RHTpaga > 0 <!---  No Paga --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 8. Inserto los ceses por pension                                                --->
	<!--- 8.1 Ceses por pension que recibieron salario                                    --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'PN', 
			null, 
			null, 
			8.1
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between a.FECHDE and a.FECHAS
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)	 
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!--- Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!---  Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
	</cfquery>
	<!--- ********************************************************************************---> 
	<!--- 8.1.2 aparte de la pension se insert into a la exclusion                              --->
	<!--- ********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'EX', 
			null, 
			null, 
			8.12
		 from #Temp# a 
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between a.FECHDE and a.FECHAS
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)	 
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS7" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- **************************************************************************************************************---> 
	<!--- 8.2 Inserto los ceses por pension que se hicieron el Primero del Mes y por eso no tinen salario en el periodo --->
	<!--- **************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia, 
			0.00, 
			'PN', 
			null, 
			null, 
			8.2
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 where la.DEid not in (select DEid from #Temp#)
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)	 
			 and   la.DLfvigencia between #Arguments.fecini# and #Arguments.fecfin#
	</cfquery>
	<!--- **************************************************************************************************************---> 
	<!--- 8.2.1 aparte de la pension se insert into a la exclusion                                                            --->
	<!--- **************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia, 
			0.00, 
			'EX', 
			null, 
			null, 
			8.21
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!--- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join Oficinas o
			 on    la.Ocodigo = o.Ocodigo
			 and   la.Ecodigo = o.Ecodigo
			<cfif Lvar_PatEmp eq 0>
				and coalesce(o.Onumpatronal, '0') =  '0'
			<cfelse>
				and coalesce(o.Onumpatronal, '0') = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_NUMPAT#">
			</cfif>
		 where la.DEid not in (select DEid from #Temp#)
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between #Arguments.fecini# and #Arguments.fecfin#
	</cfquery>
	<!--- ********************************************************************************************************************************************---> 
	<!--- 8.3 Inserto los cambios de salario para los ceses por pension que se hicieron el Primero del Mes y por eso no tinen salario en el periodo   --->
	<!--- ********************************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia, 
			0.00, 
			'SA', 
			null, 
			'GEN', 
			p.RHOcodigo, 
			8.3
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where la.DEid not in (select DEid from #Temp#)
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between #Arguments.fecini# and #Arguments.fecfin#
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS8a" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- ****************************************************************************************************************---> 
	<!--- 8.4 Inserto los ceses por pension que se hicieron el Primero del Mes y por eso no tinen salario en el periodo   --->
	<!--- ****************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, CONSE)
		 select  
			la.DEid, 
			#Arguments.fecini#, 
			0.00, 
			'PN', 
			null, 
			null, 
			8.4
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2          <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) > 0 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 where la.DEid not in (select DEid from #Temp#)
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)
			 and   la.DLfvigencia between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
	</cfquery>
	<!--- ********************************************************************************************************************************************---> 
	<!--- 8.5 Inserto los cambios de salario para los ceses por pension que se hicieron el Primero del Mes y por eso no tinen salario en el periodo   --->
	<!--- ********************************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			#Arguments.fecini#,
			0.00, 
			'SA', 
			null, 
			'GEN', 
			p.RHOcodigo, 
			8.5
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull( ta.RHTpension, 0) > 0 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where la.DEid not in (select DEid from #Temp#)
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)			 
			 and   la.DLfvigencia between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
	</cfquery>
	<!--- *****************************************************---> 
	<!--- 9. Inserto los ceses por movimientos de planilla     --->
	<!--- 9.1 del periodo actual                               --->
	<!--- *****************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select
			 lta.DEid ,
			 (case 	when lta.LThasta < #Arguments.fecini# 
				then #Arguments.fecini# 
				else lta.LThasta  end),
			 0.00, 
			 'EX', 
			 null, 
			 null, 
			 p.RHOcodigo, 
			 9.1
		 from LineaTiempo lt 
		 inner join LineaTiempo lta
			 on   lta.DEid = lt.DEid
			 and   lta.LTdesde < lt.LTdesde
			 and   lta.LThasta = <cf_dbfunction name="dateadd" args="-1, lt.LTdesde">
			 and   lta.Ocodigo != lt.Ocodigo
			 and   lta.Ocodigo in (#Arguments.ListaOficinas#)
		 inner join RHPuestos p
			 on    p.RHPcodigo = lta.RHPcodigo
			 and   p.Ecodigo = lta.Ecodigo
		 <!--- LZ Cambio Purdy 18-09-2007 Para que haga la Exclusion solo si el Numero Patronal es Diferente --->
		 inner join Oficinas olt
			  on    olt.Ocodigo = lt.Ocodigo
			  and   olt.Ecodigo = lt.Ecodigo
			  and   olt.Onumpatronal != '#Lvar_NUMPAT#'
			  and   olt.Ocodigo in (#Arguments.ListaOficinas#)		 
		 where lt.Ecodigo = #session.Ecodigo#
			 and   lt.LTdesde between #Arguments.fecini# 
			 and   #Arguments.fecfin#
	</cfquery>
	<!--- *****************************************************---> 
	<!--- 9.3 del periodo anterior                             --->
	<!--- *****************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select
			 lta.DEid,
			 #Arguments.fecini#,
			 0.00, 
			 'EX', 
			 null, 
			 null, 
			 p.RHOcodigo, 
			 9.3
		 from LineaTiempo lt
		 inner join LineaTiempo lta
			 on    lta.DEid = lt.DEid
			 and   lta.LTdesde < lt.LTdesde
			 and   lta.LThasta = <cf_dbfunction name="dateadd" args="-1,lt.LTdesde">
			 and   lta.Ocodigo != lt.Ocodigo
			 and   lta.Ocodigo in (#Arguments.ListaOficinas#)		 
		 inner join RHPuestos p
			 on   p.RHPcodigo = lta.RHPcodigo
			 and   p.Ecodigo = lta.Ecodigo
		
		 where lt.Ecodigo = #session.Ecodigo#
			 and   (lta.LTdesde between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
					and <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
					or  lta.LThasta between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
					and <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">)
		 <!--- 
			LZ Cambio Purdy 18-09-2007 Completo MacGiver, para que no incluya casos donde
			exista una Linea de Tiempo con Fecha dentro del Rango de la Nomina, pues significa que no es un Cese Anterior 	
			and not exists (Select 1 from LineaTiempo a
			Where a.DEid=lt.DEid
			and a.LThasta > #Arguments.fecini#)
			OJO verificar end PM , pues se modificó para Monge  
		   --->
	</cfquery>

	<!--- *****************************************************---> 
	<!--- 9.4 salarios para los registros del periodo anterior --->
	<!--- *****************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select
			lta.DEid, #Arguments.fecini#, 0.00, 'SA', null, null, p.RHOcodigo, 9.4
		 from LineaTiempo lt
		 inner join LineaTiempo lta
			 on    lta.DEid = lt.DEid
			 and   lta.LTdesde < lt.LTdesde
			 and   lta.LThasta = <cf_dbfunction name="dateadd" args="-1,lt.LTdesde">
			 and   lta.Ocodigo != lt.Ocodigo
			 and   lta.Ocodigo in (#Arguments.ListaOficinas#)		 
		 inner join RHPuestos p
			 on    p.RHPcodigo = lta.RHPcodigo
			 and   p.Ecodigo = lta.Ecodigo
		 where not exists (select 1 from #registro35# t where lt.DEid = t.DEid and t.CONSE = 5)
			 and lt.Ecodigo = #session.Ecodigo#
			 and   lt.LTdesde between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
			 <!--- LZ Cambio Purdy 18-09-2007 Completo MacGiver, para que no incluya casos donde
				   exista una Linea de Tiempo con Fecha dentro del Rango de la Nomina, 
				   pues significa que no es un Cese Anterior
			   --->
			  and not exists (Select 1 from LineaTiempo a
				Where a.DEid=lt.DEid
				 and a.LThasta > #Arguments.fecini#)
			 <!---  LZ Cambio Purdy 18-09-2007 Completo MacGiver,
					para que no incluya casos donde
					exista una Linea de Tiempo con Fecha dentro del Rango de la Nomina,
					pues significa que no es un Cese Anterior*--->
	</cfquery>
	<!--- *****************************************************---> 
	<!--- 10.1 Ceses que recibieron salario                    --->
	<!--- *****************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia <!--- la.DLfvigencia --->, 
			0, 
			'EX', 
		null, 
			null, 
			p.RHOcodigo,
			10.1
		 from #Temp# a
		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between a.FECHDE and a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
		 inner join  RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!--- -- Cese Normal --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join  RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	
	<!--- *****************************************************---> 
	<!--- 10. Inserto los ceses por otras razones              --->
	<!--- 10.1 Ceses que recibieron salario                    --->
	<!--- *****************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			a.DEid, 
			la.DLfvigencia, 
			a.MONTO, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.1
		 from #Temp# a

		 inner join DLaboralesEmpleado la
			 on    a.DEid = la.DEid
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between a.FECHDE and a.FECHAS
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 1 <!--- -- Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
	</cfquery>
	

	<!--- ***********************************************************************************************************************************---> 
	<!--- 10.1.1 Inserto los cambios de salario para los ceses que se hicieron el Primero del Mes y aun se cargaron con salario 0 en #Temp#  --->
	<!--- ***********************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia<!--- la.DLfvigencia --->, 
			0.00, 
			'SA', 
			null,  
			'GEN', 
			p.RHOcodigo,
			10.11
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!---  No es Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where not exists (select 1 from #Temp# t where t.DEid = la.DEid and MONTO > 0)
			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   not exists (select 1 from #registro35# r where r.DEid = la.DEid and r.TIPCAM = 'SA')
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between #Arguments.fecini# 
			 and 	#Arguments.fecfin#
	</cfquery>
	<!--- ****************************************************************************************************---> 
	<!--- 10.2 Inserto los ceses que se hicieron el Primero del Mes y por eso no tinen salario en el periodo  --->
	<!--- ****************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia <!--- la.DLfvigencia --->, 
			0.00, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.2
			
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!---  No es Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where not exists (select 1 from #Temp# t where t.DEid = la.DEid)
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between #Arguments.fecini# 
			 and   #Arguments.fecfin#
			 
	</cfquery>
	<!--- ********************************************************************************************************************************---> 
	<!--- 10.3 Inserto los cambios de salario para los ceses que se hicieron el Primero del Mes y por eso no tinen salario en el periodo  --->
	<!--- ********************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			la.DLfvigencia, 
			0.00, 
			'SA', 
			'   ', 
			'GEN', 
			p.RHOcodigo,
			10.3
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!---  No es Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on   la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where not exists (select 1 from #Temp# t where t.DEid = la.DEid)
			 and   not exists (select 1 from #registro35# r where r.DEid = la.DEid and r.TIPCAM = 'SA')
			 and   la.Ecodigo = #session.Ecodigo#
 			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   la.DLfvigencia between #Arguments.fecini# 
			 and   #Arguments.fecfin#
	</cfquery>
</cffunction>	
<cffunction name="fnDetalleCCSS8b" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- *****************************************************************************************************************************---> 
	<!--- 10.4 Inserto los cambios de salario para los ceses que se hicieron el Mes anterior y por eso no tinen salario en el periodo  --->
	<!--- *****************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			#Arguments.fecfin#, 
			0.00, 
			'SA', 
			null, 
			'GEN', 
			p.RHOcodigo, 
			10.4
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!---  No es Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
		 inner join RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where not exists (select 1 from #Temp# t where t.DEid = la.DEid)
  			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   not exists (select 1 from #registro35# r where r.DEid = la.DEid and r.TIPCAM = 'SA')
			 and   la.Ecodigo = #session.Ecodigo#
			 and   la.DLfvigencia between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
			 and   <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
	</cfquery>

	 
	<cfquery datasource="#Session.DSN#">
		 update #registro35# set 
		 RHOcodigo = ( select p.RHOcodigo  
		 				from #Temp# a, RHPuestos p  
						 where #registro35#.TIPCAM = 'IN'
						 and #registro35#.DEid = a.DEid
						 and a.RHPcodigo = p.RHPcodigo
						 and a.Ecodigo = p.Ecodigo),
		
		MONTO = ( select a.MONTO  
		 				from #Temp# a, RHPuestos p  
						 where #registro35#.TIPCAM = 'IN'
						 and #registro35#.DEid = a.DEid
						 and a.RHPcodigo = p.RHPcodigo
						 and a.Ecodigo = p.Ecodigo)						 

		where exists (
				select 1
				from #Temp# a, RHPuestos p  
					 where #registro35#.TIPCAM = 'IN'
					 and #registro35#.DEid = a.DEid
					 and a.RHPcodigo = p.RHPcodigo
					 and a.Ecodigo = p.Ecodigo
		)						 
	</cfquery>
	<!--- *************************************************************************************************---> 
	<!--- 10.5 Inserto los ceses que se hicieron el Mes Anterior y por eso no tinen salario en el periodo  --->
	<!--- *************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			la.DEid, 
			#Arguments.fecini#, 
			0.00, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.5
		 from DLaboralesEmpleado la
		 inner join RHTipoAccion ta
			 on    ta.RHTcomportam = 2 <!---  Es Cese --->
			 and   isnull(ta.RHTpension, 0) = 0 <!---  No es Cese por Pension --->
			 and   la.Ecodigo = ta.Ecodigo
			 and   ta.RHTid = la.RHTid
			 inner join  RHPuestos p
			 on    la.RHPcodigo = p.RHPcodigo
			 and   la.Ecodigo = p.Ecodigo
		 where
			 not exists (select 1 from #registro35# r where r.DEid = la.DEid and r.TIPCAM = 'EX')
			 and   la.Ecodigo = #session.Ecodigo#
  			 and   la.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   la.DLfvigencia between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
			 <!--- 
				 /* LZ Modificacion Purdy Motor 18-09-2007 para que considere todos los contratos temporales*/
				 /* 10.Incluyo el Cese, siempre y cuando en el Periodo no existe un movimiento para la persona, por ejemplo Recontratacion*/
			 --->  
			 <!---  LZ 03-03-2009, Dado que TODOS los registros ingresan con un SA, esta regla nunca se cumple, pero es requerida para los Casos Bisemanales, 
			        donde el movimiento se hace en el mes anterior, pero la nómina pertenece al mes siguiente, se comenta in (SA,IC) y se deja el ultimo --->
			 		--  and not exists (select 1 from #registro35# a where a.DEid = la.DEid and a.TIPCAM in ('SA','IC'))
						and not exists (select 1 from #registro35# a where a.DEid = la.DEid and a.TIPCAM in ('IC'))
			 <!---
				 /* LZ Modificacion Purdy Motor 18-09-2007 para que considere todos los contratos temporales*/
				 /* 10.Incluyo el Cese, siempre y cuando en el Periodo no existe un movimiento para la persona, por ejemplo Recontratacion*/
			 --->  		 
	</cfquery>	
	
	
	
	<cfif isdefined("form.Pvez")>
		<!--- ***********************************************************************---> 
		<!--- Esto es mientras para el arranque, despues de eso se debe de comentar  --->
		<!--- ***********************************************************************---> 
		<cfquery datasource="#Session.DSN#">
			  INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHOcodigo, CONSE)
			  select 
				distinct a.DEid,
				#Arguments.fecini#,
				a.MONTO,
				'OC',
				'',
				null,
				null,
				a.RHOcodigo,
				4
			  from #registro35# a
			  where a.TIPCAM = 'SA'
				  and not exists (select 1 from #registro35# k where k.DEid = a.DEid and k.TIPCAM = 'OC')
				  and not exists (select 1 from #registro35# k where k.DEid = a.DEid and k.TIPCAM = 'IC')
		</cfquery>
	</cfif>
	<!--- *************************************************************************************************************************---> 
	<!--- LZ Modificacion Purdy Motor 18-09-2007 para que considere todos los contratos temporales                                 --->
	<!--- 10.9 Incluye las Exclusiones de las Personas que fueron Cesadas durante el Periodo y a la vez pudieron ser recontratados --->
	<!--- *************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			distinct lt.DEid,  
			dle.DLffin,
			0.00, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.9
		 from DLaboralesEmpleado dle
		 inner join LineaTiempo lt
			 on lt.Ecodigo = #session.Ecodigo#
 			 and   lt.Ocodigo in (#Arguments.ListaOficinas#)		 
			 and   lt.LThasta between dle.DLfvigencia  and dle.DLffin	 
			 and  dle.DEid = lt.DEid
		 inner join RHTipoAccion ta
			 on    lt.RHTid = ta.RHTid
			 and   ( ta.RHTcomportam = 1 or ta.RHTcomportam = 6)
			 and   ta.RHTpfijo = 1
			 and   lt.Ecodigo = ta.Ecodigo
		 inner join RHPuestos p
			 on    lt.Ecodigo = p.Ecodigo
			 and   lt.RHPcodigo = p.RHPcodigo
		 where   dle.DLffin between #Arguments.fecini#  
			 and #Arguments.fecfin#
	</cfquery>
	<!--- *************************************************************************************************************************---> 
	<!--- 10.7 Inserto Salarios de ceses por finalizaci¢n de Contrato Temporal del Mes Anterior                                    --->
	<!--- *************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			distinct lt.DEid,
			(select max(LThasta) from LineaTiempo lt2 where lt2.DEid = lt.DEid ),
			0.00,'SA',
			null,
			null,
			p.RHOcodigo,
			10.7
		 from LineaTiempo lt
		 inner join RHTipoAccion ta
			 on    lt.RHTid = ta.RHTid
			 and   (ta.RHTcomportam = 1 or ta.RHTcomportam = 6)
			 and   ta.RHTpfijo = 1
			 and   lt.Ecodigo = ta.Ecodigo	 
		 inner join  RHPuestos p
			 on    lt.Ecodigo = p.Ecodigo
			 and   lt.RHPcodigo = p.RHPcodigo
		 where not exists (select 1 from #registro35# r where r.DEid = lt.DEid and r.TIPCAM = 'EX')
			 and   not exists  (select 1 from #Temp# t where t.DEid = lt.DEid)
			 and   lt.LThasta between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
			 and   lt.Ecodigo = #session.Ecodigo#
  			 and   lt.Ocodigo in (#Arguments.ListaOficinas#)		 
	</cfquery>
	<!--- *************************************************************************************************************************---> 
	<!--- 10.8 Inserto los ceses por finalizacion de Contrato Temporal del Mes Anterior                                            --->
	<!--- *************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		 INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		 select  
			distinct lt.DEid,
			#Arguments.fecini#, 
			0.00, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.8
		 from LineaTiempo lt
		 inner join RHTipoAccion ta
			 on    lt.RHTid = ta.RHTid
			 and   (ta.RHTcomportam = 1 or ta.RHTcomportam = 6)
			 and   ta.RHTpfijo = 1
			 and   lt.Ecodigo = ta.Ecodigo
		 inner join  RHPuestos p
			 on    lt.Ecodigo = p.Ecodigo
			 and   lt.RHPcodigo = p.RHPcodigo
		 where not exists (select 1 from #registro35# r where r.DEid = lt.DEid and r.TIPCAM = 'EX')
			 and   not exists (select 1 from #Temp# t where t.DEid = lt.DEid)
			 and   lt.LThasta between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp">
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
			 and   lt.Ecodigo = #session.Ecodigo#
 			 and   lt.Ocodigo in (#Arguments.ListaOficinas#)		 
	</cfquery>
	<!--- *************************************************************************************************************************---> 
	<!--- 10.10 Inserto los ceses por finalizacion de Contrato Temporal del Mes TrasAnterior                                       --->
	<!--- *************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		select  
			distinct lt.DEid, 
			#Arguments.fecini#, 
			0.00, 
			'EX', 
			null, 
			null, 
			p.RHOcodigo, 
			10.10
		from LineaTiempo lt
		inner join CalendarioPagos cp
			on cp.CPperiodo     =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_periodoT#">
			and cp.CPmes         = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_mesT#">
			and cp.Ecodigo       = lt.Ecodigo
		inner join RHPuestos p
			on p.RHPcodigo = lt.RHPcodigo
			and p.Ecodigo = lt.Ecodigo
		where lt.Ecodigo        = #session.Ecodigo#
			and   lt.Ocodigo in (#Arguments.ListaOficinas#)		 
			and (CPdesde between LTdesde and LThasta
			or CPhasta between LTdesde and LThasta)
			and exists (select 1 from  LineaTiempo lta, CalendarioPagos cpa
			where lta.Ecodigo = lt.Ecodigo
			and cpa.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_periodoA#">
			and cpa.CPmes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_mesA#">
			and lta.Tcodigo = cpa.Tcodigo
			and lta.Ocodigo != lt.Ocodigo
			and cpa.CPdesde between lta.LTdesde and lta.LThasta
			and lta.DEid = lt.DEid )
	</cfquery>
	<!--- *******************************************************---> 
	<!--- Inicia DELETE´s                                        --->
	<!--- *******************************************************---> 
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where (#registro35#.TIPCAM = 'IC' or #registro35#.TIPCAM = 'EX' )
		and exists (select 1 from #registro35# b  
					inner join	#registro35# c
						on c.TIPCAM = 'EX'
						and c.DEid = b.DEid
						and b.FECINI = c.FECFIN
					where b.TIPCAM = 'IC'
					and #registro35#.DEid = b.DEid
					and isnull(#registro35#.RHOcodigo,'0') = isnull(b.RHOcodigo,'0')
					and isnull(#registro35#.RHOcodigo,'0') = isnull( c.RHOcodigo,'0')
					
					)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where  #registro35#.TIPCAM not in ('IC', 'EX')
		and exists (select 1
			  from #registro35# r2
			  where #registro35#.DEid = r2.DEid and r2.TIPCAM = 'IC'
			  and #registro35#.FECINI = r2.FECINI)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where TIPCAM = 'OC' and MONTO = 0
		and exists (select 1 from #registro35# a where a.DEid = #registro35#.DEid and TIPCAM = 'EX')
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS9a" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<!--- **************************************************************************************************************************************---> 
	<!--- Se borran los registros de inclusion en donde existe linea del tiempo hasta el dia anterior (o sea que es un nombramiento continuo)   --->
	<!--- LZ 18-09-2007  le inclui que el IC solo se elimine si no se habia generado por alguna Razon (Contratos Temporales) una Exclusion      --->
	<!--- **************************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where TIPCAM = 'IC'
		and exists (select 1 
					from LineaTiempo a 
					where a.DEid = #registro35#.DEid
					and   a.Ocodigo in (#Arguments.ListaOficinas#)					
					and <cf_dbfunction name="dateadd" args="-1, #registro35#.FECINI"> = a.LThasta)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where TIPCAM = 'EX'
		and exists (select 1 
					from LineaTiempo a
					where a.DEid = #registro35#.DEid
					and   a.Ocodigo in (#Arguments.ListaOficinas#)		
					and <cf_dbfunction name="dateadd" args="-1, #registro35#.FECINI"> = a.LTdesde)
	</cfquery>
	
	<cfset LvarFecha = createdate(6010,1,1)> 
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
			where #registro35#.FECINI >= coalesce((SELECT max(a.FECINI) from #registro35# a  where a.DEid =  #registro35#.DEid and a.TIPCAM = 'EX'),<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">)
			and  #registro35#.TIPCAM not in ('EX','SA')
			and  #registro35#.FECINI > coalesce((SELECT max(a.FECINI) from #registro35# a where a.DEid = #registro35#.DEid and a.TIPCAM = 'EX'),<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">)
			and  #registro35#.TIPCAM not in ('IC')
	</cfquery> 
	<!--- **************************************************************************************************************************************---> 
	<!--- Intentaremos Borrar todas las Inclusiones/Exclusiones en medio del Mes  LZ JC 2007-10-03                                              --->
	<!--- **************************************************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		delete from #registro35#
		Where TIPCAM = 'IC'
		and FECINI > (select  min(FECINI) from #registro35# a where  TIPCAM = 'EX' and   #registro35#.DEid = a.DEid  )
		and exists (select  1 from #registro35# a where  TIPCAM = 'EX' and   #registro35#.DEid = a.DEid  )
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete from #registro35#
		Where TIPCAM = 'IC'
		and FECINI > (select  min(FECINI) from #registro35# a where  TIPCAM = 'IC' and   #registro35#.DEid = a.DEid and  #registro35#.FECINI != a.FECINI  )
		and exists (select  1 from #registro35# a where  TIPCAM = 'IC' and  #registro35#.FECINI != a.FECINI )
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete from #registro35#
		Where TIPCAM = 'EX'
		and FECINI < (select  max(FECINI) from #registro35# a where  TIPCAM = 'EX' and   #registro35#.DEid = a.DEid and  #registro35#.FECINI != a.FECINI  )
		and exists (select  1 from #registro35# a where  TIPCAM = 'EX' and  #registro35#.FECINI != a.FECINI )
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		delete from #registro35#
		Where TIPCAM = 'EX'
		and exists (select  1 from #registro35# a , LineaTiempo b
						where  TIPCAM = 'EX'
						and  #registro35#.DEid = a.DEid
			 and <cf_dbfunction name="dateadd" args="-1, #Arguments.fecfin#">  between LTdesde and LThasta
			 and  b.Ocodigo in (#Arguments.ListaOficinas#)	
			 and a.DEid = b.DEid  )
	</cfquery>
	<!--- *******************************************************************************************---> 
	<!--- 5.1 Inserto los cambios de puesto de la linea del tiempo                                   --->
	<!--- *******************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, NUMJOR, RHOcodigo, CONSE)
		select
			lt.DEid, 
			lt.LTdesde, 
			a.MONTO, 
			'OC', 
			'', 
			null, 
			null, 
			RHOcodigo, 
			5
		from #Temp# a
		inner join LineaTiempo lt
		   on  lt.LTdesde between a.FECHDE and a.FECHAS
		   and lt.DEid =  a.DEid
		   and not exists (Select 1 from #registro35# c where lt.DEid=c.DEid and c.TIPCAM='OC' and lt.LTdesde=c.FECINI)
		   and not exists (Select 1 from #registro35# c where lt.DEid=c.DEid and c.TIPCAM='IC' and lt.LTdesde=c.FECINI)
		   and   lt.Ocodigo in (#Arguments.ListaOficinas#)
		inner join LineaTiempo lta
		   on  lta.LTdesde < lt.LTdesde
		   and lta.LThasta =  <cf_dbfunction name="dateadd" args="-1, lt.LTdesde">
		   and lta.RHPcodigo != lt.RHPcodigo
		   and lta.DEid = lt.DEid
		inner join RHPuestos p
		   on p.RHPcodigo = lt.RHPcodigo
		   and p.Ecodigo      = lt.Ecodigo
	</cfquery>
	<!--- *********************************************************---> 
	<!--- continuan los borrados                                   --->
	<!--- *********************************************************---> 
	<cfquery datasource="#Session.DSN#">
		delete #registro35#
		where  #registro35#.TIPCAM = 'SA'
		and exists (select 1 from #registro35# r2 where #registro35#.DEid = r2.DEid and r2.TIPCAM = 'IC')
	</cfquery>
	<!--- *********************************************************************************---> 
	<!--- iNCLUIR SIEMPRE UN SA EN CERO DONDE HAYA UNA EXCLUSIO Y HAYA QUEDADO PENDIENTE   --->
	<!--- *********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE)
		select                       
			DEid, 
			FECINI,         
			0,   
			'SA',     
			FECFIN, 
			'GEN', 
			RHOcodigo, 
			1.0
		from #registro35# a
		Where exists (Select 1 from #registro35# b Where TIPCAM='EX' and a.DEid=b.DEid )
		and not exists (Select 1 from #registro35# c Where TIPCAM in ('SA','IC') and a.DEid=c.DEid)
	</cfquery>
	
	<!--- *******************************************************************************************---> 
	<!--- iInclusión de los Movimientos Generados por un Cambio de Identificacion no identificados   --->
	<!--- *******************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( RHRCCSSid, DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI,  RHOcodigo, CONSE) 
		 select             
			b.RHRCCSSid,lt.DEid, 
			#Arguments.fecini#,
			0.00, 
			'SA', 
			null, 
			null,      
			p.RHOcodigo, 
			0.0
		 from LineaTiempo lt
		 inner join   RHPuestos p
			on    p.RHPcodigo = lt.RHPcodigo
			and   p.Ecodigo = lt.Ecodigo
		 inner join   RHRepCCSS b
			 on    lt.DEid=b.DEid
			 --and   b.Aplicado=0
			 and   b.RHRCCSSfecha between #Arguments.fecini# 
			 and   #Arguments.fecfin#
		 where 
				lt.Ecodigo = #session.Ecodigo# 
				and   lt.Ocodigo in (#Arguments.ListaOficinas#)
				and lt.LTid = ( select min(x.LTid) from LineaTiempo x
								where x.Ecodigo =  #session.Ecodigo# 
								and x.DEid = 	b.DEid
								and   (x.LTdesde >=  #Arguments.fecfin#
								or  x.LThasta <=  #Arguments.fecini# )	
				)
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( RHRCCSSid, DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE) 
		 select             
			b.RHRCCSSid, 
			lt.DEid,
			#Arguments.fecini#,
			0.00, 
			'EX', 
			null, 
			null,      
			p.RHOcodigo, 
			0.1
		 from LineaTiempo lt 
		 inner join  RHPuestos p 
			 on    p.RHPcodigo = lt.RHPcodigo
			 and   p.Ecodigo   = lt.Ecodigo
		 inner join	  RHRepCCSS b
			 on    lt.DEid=b.DEid
			 --and   b.Aplicado=0
			 and   b.RHRCCSSfecha between #Arguments.fecini# 
			 and   #Arguments.fecfin#
		 where 
				lt.Ecodigo = #session.Ecodigo# 
				and   lt.Ocodigo in (#Arguments.ListaOficinas#)
				and lt.LTid = ( select min(x.LTid) from LineaTiempo x
								where x.Ecodigo =  #session.Ecodigo# 
								and x.DEid = 	b.DEid
								and   (x.LTdesde >=  #Arguments.fecfin#
								or  x.LThasta <=  #Arguments.fecini# )	
				)
	</cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS9b" access="private" output="no">
	<cfargument name="ListaOficinas" type="string" required="yes">
	<cfargument name="NumeroPatronal" type="string" required="yes">
	<cfargument name="fecini" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	
	<!--- ************************************************************************************************---> 
	<!--- Inclusión de los Movimientos Generados por un Cambio de Identificacion mes anterior             --->
	<!--- ************************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( RHRCCSSid, DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI,  RHOcodigo, CONSE) 
		 select             
			b.RHRCCSSid,lt.DEid, 
			#Arguments.fecini#,
			0.00, 
			'SA', 
			null, 
			null,      
			p.RHOcodigo, 
			0.0
		 from LineaTiempo lt
		 inner join   RHPuestos p
			on    p.RHPcodigo = lt.RHPcodigo
			and   p.Ecodigo = lt.Ecodigo
		 inner join   RHRepCCSS b
			 on    lt.DEid=b.DEid
			 and   b.RHRCCSSfecha between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
		 where 
				lt.Ecodigo = #session.Ecodigo# 
				and lt.Ocodigo in (#Arguments.ListaOficinas#)
				and lt.LTid = ( select max(x.LTid)from LineaTiempo x
								where x.Ecodigo =  #session.Ecodigo# 
								and x.DEid = 	b.DEid
								and   (x.LTdesde >=  <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
								or  x.LThasta <=  <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> )	
				)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		INSERT  into #registro35#( RHRCCSSid, DEid, FECINI, MONTO, TIPCAM, FECFIN, TINCAPACI, RHOcodigo, CONSE) 
		 select             
			b.RHRCCSSid, 
			lt.DEid,
			#Arguments.fecini#,
			0.00, 
			'EX', 
			null, 
			null,      
			p.RHOcodigo, 
			0.1
		 from LineaTiempo lt 
		 inner join  RHPuestos p 
			 on    p.RHPcodigo = lt.RHPcodigo
			 and   p.Ecodigo   = lt.Ecodigo
		 inner join	  RHRepCCSS b
			 on    lt.DEid=b.DEid
			 and   b.RHRCCSSfecha between <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> 
			 and   <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
		 where 
				lt.Ecodigo = #session.Ecodigo# 
				and lt.LTid = ( select max(x.LTid) from LineaTiempo x
								where x.Ecodigo =  #session.Ecodigo# 
								and x.DEid = 	b.DEid
								and   (x.LTdesde >=  <cfqueryparam value="#fecfinA#" cfsqltype="cf_sql_timestamp">
								or  x.LThasta <=  <cfqueryparam value="#feciniA#" cfsqltype="cf_sql_timestamp"> )	
				)
				and   lt.Ocodigo in (#Arguments.ListaOficinas#)
	</cfquery>
	<cfif isdefined("form.Cierre")>
		<cfquery datasource="#Session.DSN#">
			update 	RHRepCCSS set Aplicado = 1
			where RHRCCSSfecha <= #Arguments.fecfin#
			and   Aplicado=0 
		</cfquery>
	</cfif>
	<!--- *********************************************************************************---> 
	<!--- actualizo la fecha desde de los cambios de salario de las exclusiones            --->
	<!--- *********************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		update #registro35#
		set FECINI = (select max(FECINI) from #registro35# p2 where p2.DEid = #registro35#.DEid and p2.TIPCAM = 'EX')
		where TIPCAM = 'SA'
		and exists(
			select 1
			from #registro35# p1
			where p1.DEid = #registro35#.DEid
			   and p1.TIPCAM = 'EX')
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update #registro35# set MONTO = 0 where MONTO < 0
	</cfquery>
	<!--- *********************************************************************************---> 
	<!--- 11. actualizo Informacion Personal                                               --->
	<!--- *********************************************************************************---> 
	<!--- ************************************************************************************************************************ --->
	<cf_dbfunction name="to_number" args="(MONTO* 100)" returnvariable="vRMONTO">
	<cf_dbfunction name="to_number" args="NUMJOR" returnvariable="vRNUMJOR">
	<cfquery datasource="#Session.DSN#">
		update #registro35# 
		set TIPIDE =  (select de.NTIcodigo from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#),
		IDENTI  = (select coalesce(de.DESeguroSocial,de.DEdato3) from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#),     
		APE1    = (select de.DEapellido1 from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#), 
		APE2    = (select de.DEapellido2 from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#),  
		NOMBRE  = (select de.DEnombre from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#), 
		MONTO1  = <cf_dbfunction name="to_char" args="#vRMONTO#">,    
		NUMJOR1 = <cf_dbfunction name="to_char" args="#vRNUMJOR#">,
		Ppais   = (select de.Ppais from  DatosEmpleado de where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#)
		where exists(
			select 1 from  DatosEmpleado de
			where #registro35#.DEid = de.DEid and de.Ecodigo = #session.Ecodigo#
		)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35#
		set IDENTI = (
			select b.DESegSocial from  RHRepCCSS b
			where #registro35#.DEid    = b.DEid 
			and #registro35#.RHRCCSSid = b.RHRCCSSid
			and b.Ecodigo              = #session.Ecodigo# 
		)
		where exists(
			select 1 from  RHRepCCSS b
			where #registro35#.DEid    = b.DEid 
			and #registro35#.RHRCCSSid = b.RHRCCSSid
			and b.Ecodigo              = #session.Ecodigo# 
		)
		and #registro35#.RHRCCSSid is not null

	</cfquery>
	<!--- ***************************************************---> 
	<!--- UPDATE'S                                           --->
	<!--- ***************************************************---> 
	<cfset LvarFecha = createdate(1900,1,1)>
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			TIPIDE  =  case when  Ppais != 'CR' then  '7' else '0' end,  				<!--- actualiza tipo de indetificacion segun el pais               --->
			FECFIN  =  case when  FECFIN  is null  then  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> else FECFIN end,	<!--- actualiza fecha FECFIN a infinito para las que estan en nulo --->
			APE1 	=  {fn UCASE({fn LTRIM({fn LTRIM(APE1)})})},		   			    <!--- actualiza  APE1 que tengan mayusculas                        --->
			APE2 	=  {fn UCASE({fn LTRIM({fn LTRIM(APE2)})})},			            <!--- actualiza  APE2 que tengan mayusculas                        --->
			NOMBRE 	=  {fn UCASE({fn LTRIM({fn LTRIM(NOMBRE)})})}			            <!--- actualiza  NOMBRE que tengan mayusculas                      --->
	</cfquery>
	<!--- **************************---> 
	<!--- quita todas las tildes    --->
	<!--- **************************---> 
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			APE1 	= <cf_dbfunction name="string_replace"   args="APE1,'Á','A'">,
			APE2 	= <cf_dbfunction name="string_replace"   args="APE2,'Á','A'">,
			NOMBRE 	= <cf_dbfunction name="string_replace"   args="NOMBRE,'Á','A'">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			APE1 	= <cf_dbfunction name="string_replace"   args="APE1,'É','E'">,
			APE2 	= <cf_dbfunction name="string_replace"   args="APE2,'É','E'">,
			NOMBRE 	= <cf_dbfunction name="string_replace"   args="NOMBRE,'É','E'">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			APE1 	= <cf_dbfunction name="string_replace"   args="APE1,'Í','I'">,
			APE2 	= <cf_dbfunction name="string_replace"   args="APE2,'Í','I'">,
			NOMBRE 	= <cf_dbfunction name="string_replace"   args="NOMBRE,'Í','I'">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			APE1 	= <cf_dbfunction name="string_replace"   args="APE1,'Ó','O'">,
			APE2 	= <cf_dbfunction name="string_replace"   args="APE2,'Ó','O'">,
			NOMBRE 	= <cf_dbfunction name="string_replace"   args="NOMBRE,'Ó','O'">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35# set 
			APE1 	= <cf_dbfunction name="string_replace"   args="APE1,'Ú','U'">,
			APE2 	= <cf_dbfunction name="string_replace"   args="APE2,'Ú','U'">,
			NOMBRE 	= <cf_dbfunction name="string_replace"   args="NOMBRE,'Ú','U'">
	</cfquery>
	<!--- ******************************************************************************************---> 
	<!--- se actualiza El tipo de Seguro  (C = para todos (IVM+SEM), A = sólo pensionados (SEM) )   --->
	<!--- ******************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		update #registro35#
		set CLASEG = 'A'
		where exists(
			select 1
			from DLaboralesEmpleado d
			inner join  RHTipoAccion t 
				on d.RHTid = t.RHTid
				and RHTpension = 1
				and RHTcomportam = 1			
			where d.DEid = #registro35#.DEid
			)
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update #registro35#
		set CLASEG = 'C'
		where CLASEG is null
	</cfquery>
	<!--- **************************---> 
	<!--- insert into a en  ReporteCCSS   --->
	<!--- **************************---> 
	<cfquery name="RS_Datos" datasource="#Session.DSN#">
		select * from #registro35#
		order by APE1,APE2,NOMBRE,IDENTI,FECINI,CONSE
	</cfquery>
	<!--- <cf_dump var="#RS_Datos#"> --->
	<cfset HILERA = "">
	<cfset nombre = "">
	<cfloop query="RS_Datos">
		 <cfset HILERA = "35"
			&  RS_Datos.TIPIDE
			&  RepeatString('0', (25 -len(trim(RS_Datos.IDENTI)))) & trim(RS_Datos.IDENTI)
			& trim(RS_Datos.APE1)   &  RepeatString(' ', (20 -len(trim(RS_Datos.APE1)))) 
			& trim(RS_Datos.APE2)   &  RepeatString(' ', (20 -len(trim(RS_Datos.APE2)))) 
			& trim(RS_Datos.NOMBRE) &  RepeatString(' ', (60 -len(trim(RS_Datos.NOMBRE))))
			& trim(RS_Datos.RHOcodigo)&  RepeatString(' ', (4 -len(trim(RS_Datos.RHOcodigo))))
			&  RepeatString('0', (15 -len(trim(RS_Datos.MONTO1)))) & trim(RS_Datos.MONTO1)
			&  RS_Datos.CLASEG
			&  RS_Datos.TIPCAM>
			
		 <cfif len(trim(RS_Datos.NUMJOR1))>
			 <cfset HILERA = HILERA & RepeatString('0', (2 -len(trim(RS_Datos.NUMJOR1)))) & trim(RS_Datos.NUMJOR1) >
		 <cfelse>
			<cfset HILERA = HILERA &  '  '>
		 </cfif>	 
	
		 <cfif len(trim(RS_Datos.CLAJOR))>
			 <cfset HILERA = HILERA & RepeatString(' ', (3 -len(trim(RS_Datos.CLAJOR)))) & trim(RS_Datos.CLAJOR) >
		 <cfelse>
			<cfset HILERA = HILERA &  '   '>
		 </cfif>
		 <!--- Purdy este Caracter debe ir en la posicion 65 por lo tanto los espacios van despues ---> 
		 <cfif len(trim(RS_Datos.TINCAPACI))>
 			 <cfset HILERA = HILERA & trim(RS_Datos.TINCAPACI) & RepeatString(' ', (3 -len(trim(RS_Datos.TINCAPACI))))>
		 <cfelse>
			<cfset HILERA = HILERA &  '   '>
		 </cfif>
		 
		 <cfset HILERA = HILERA &  LSDateFormat(RS_Datos.FECINI, "yyyymmdd")>
		 <cfif len(trim(RS_Datos.FECFIN)) and LSDateFormat(RS_Datos.FECFIN, "yyyymmdd") neq '19000101'> 
		 	 <cfif  LSDateFormat(RS_Datos.FECFIN, "yyyymmdd") neq '61000101' >
			 		<cfset HILERA = HILERA &  #LSDateFormat(RS_Datos.FECFIN, "yyyymmdd")# >
			<cfelse>
					<cfset HILERA = HILERA &  RepeatString(' ',8)>	 		
			</cfif>					
		 <cfelse>
			<cfset HILERA = HILERA &  RepeatString(' ',8)>
		 </cfif>
		 <cfquery name="rh_ReporteCCSS_GC" datasource="#Session.DSN#">
			insert into  #ReporteCCSS#(RCCtexto, RCCTipo, Ecodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#HILERA#">,
				35,
				#session.Ecodigo#	
			)
		 </cfquery> <!--- --->
	</cfloop>
	<cfquery name="rh_ReporteCCSS_GC" datasource="#Session.DSN#">
		select * from  #ReporteCCSS#
	 </cfquery>
</cffunction>
<cffunction name="fnDetalleCCSS10" access="private" output="no">
	<cfquery name="RS_Datos" datasource="#Session.DSN#">
		delete  #registro35#
	</cfquery>
	<cfquery name="RS_Datos" datasource="#Session.DSN#">
		delete  #Temp#
	</cfquery>
</cffunction>

