<!---RVNP--->
<!--- 
	****************************************
	****Consulta de Renta*******************
	****Ultima  modificación: 14/02/2007****
	****Ultima   modificación  realizada****
	****por:   Dorian    Abarca   Gómez.****
	****Descripción:  Se modificó porque****
	****no    tomaba    en  cuenta   los****
	****componentes  que no cargan renta****
	****y  no  obtenía correctamente las****
	****deducciones    de    renta   por****
	****familiares      (hijos/conyuge).****
	****************************************
--->
<!--- Extiende el Tiempo de Respuesta para los request de este archivo--->
<cfsetting requesttimeout="3600">
<!--- Para prender el modo Debug Pinta el desarrollo del llanado de la tambla temporal para el Reporte MSG_Error2--->
<cfset Lvar.Debug = false>
<!--- Etiquetas de Traducción --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Error1" 
			returnvariable="MSG_Error1"  Default="Error. Este reporte requiere que tanto 
			el periodo/mes desde como el hasta se encuentren en una tabla de renta. 
			Proceso Cancelado!"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Error2" 
			returnvariable="MSG_Error2"  Default="Error. Este reporte requiere argumentos 
			que no fueron brindados. Proceso Cancelado!"/>
<!--- Validaciones Iniciales --->
<!--- 1. Se requiere Periodo/Mes Desde/Hasta--->
<cfif (isdefined("Form.periodo_inicial") and len(trim(Form.periodo_inicial)) gt 0
		and isdefined("Form.mes_inicial") and len(trim(Form.mes_inicial)) gt 0
		and isdefined("Form.periodo_final") and len(trim(Form.periodo_final)) gt 0
		and isdefined("Form.mes_final") and len(trim(Form.mes_final)) gt 0)>
	<!--- Factores para comparación por periodo/mes --->
	<cfset Lvar.factorInicial = Form.periodo_inicial * 12 + Form.mes_inicial>

	<cfset Lvar.factorFinal = Form.periodo_final * 12 + Form.mes_final>
	<cfset Lvar.Cantidad_Meses = Lvar.FactorFinal - Lvar.FactorInicial + 1>
	
<!---	
	meses
	<cfdump var="#Lvar.Cantidad_Meses#">
--->	
	<!--- Fechas para comparación por fecha --->
	<cfset Lvar.fechaInicial = CreateDate(Form.periodo_inicial, Form.mes_inicial, 1)>
	<cfset Lvar.fechaFinal = DateAdd('d',-1,DateAdd('m',1,CreateDate(Form.periodo_final, Form.mes_final, 1)))>
	<!--- Periodo/Mes Desde/Hasta Válidos --->
	<cfquery name="rsCodigoImpuesto" datasource="#session.dsn#">
			select Pvalor 
			from RHParametros 
		    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Pcodigo = 30
	</cfquery>
	<cfset Lvar.IRcodigo = rsCodigoImpuesto.Pvalor>

	<cfquery name="rsEImpuestoRenta1" datasource="#session.dsn#">
		select IRcodigo, EIRid
		from EImpuestoRenta
		where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar.IRcodigo#">
		and EIRestado > 0
        and EIRdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar.fechaFinal#">
        and EIRhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar.fechaInicial#">
	</cfquery>

	<!--- hay mas de una tabla de renta, escoge la mayor --->
	<cfif rsEImpuestoRenta1.recordcount gt 1>
		<cfquery name="rsEImpuestoRenta" datasource="#session.dsn#">
			select IRcodigo, EIRid
			from EImpuestoRenta a
			where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar.IRcodigo#">
			and a.EIRid in (#valuelist(rsEImpuestoRenta1.EIRid)#)
			and a.EIRdesde = (  select max(EIRdesde) 
								from EImpuestoRenta b 
								where b.EIRid in (#valuelist(rsEImpuestoRenta1.EIRid)#) )
		</cfquery>							
	<cfelse>
		<cfset rsEImpuestoRenta = rsEImpuestoRenta1 >
	</cfif>

	<cfif rsEImpuestoRenta.recordcount eq 1>
		<cfset Lvar.periodo_inicial = Form.periodo_inicial>
		<cfset Lvar.periodo_final = Form.periodo_final>
		<cfset Lvar.mes_inicial = Form.mes_inicial>
		<cfset Lvar.mes_final= Form.mes_final>
		<cfset Lvar.EIRid = rsEImpuestoRenta.EIRid>
		
	<cfelse>
		<cf_throw message="#MSG_Error1#" errorCode="1025">
	</cfif>
<cfelse>
	<cf_throw message="#MSG_Error2#" errorCode="1030">
</cfif>
<cfif Lvar.Debug>
	<cfdump var="#Lvar#">
</cfif>
<!--- Crea una tabla temporal para guardar los resultados que se desplegaran al final con una consulta a esta temporal. --->
<cf_dbtemp name="RHQueryRenta1" returnvariable="RHQueryRenta" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid"    		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="SalGraba"		type="money"   	mandatory="no">
	<cf_dbtempcol name="SalGrabaOP"		type="money"   	mandatory="no">
	<cf_dbtempcol name="MonRentaOP"		type="money"   	mandatory="no">
	<cf_dbtempcol name="MonRenta"		type="money"   	mandatory="no">
	<cf_dbtempcol name="MonConyu"		type="money"   	mandatory="no">
	<cf_dbtempcol name="MonHijos"		type="money"   	mandatory="no">
	<cf_dbtempcol name="MonOtrasDeduc"	type="money"   	mandatory="no">
	<cf_dbtempcol name="RentNeta"		type="money"   	mandatory="no">
	<cf_dbtempcol name="RentRete"		type="money"   	mandatory="no">
	<cf_dbtempcol name="CantMeses"		type="integer"  mandatory="no">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>

<cf_dbtemp name="CalendariosConsiderar" returnvariable="RHCalendariosConsiderar" datasource="#session.DSN#">
	<cf_dbtempcol name="CPid"    	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPperiodo"  type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPmes"    	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPdesde"    type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPhasta"    type="datetime" mandatory="yes">
	<cf_dbtempkey cols="CPid">
</cf_dbtemp>

<cf_dbtemp name="MHD" returnvariable="MH" datasource="#session.DSN#">
	<cf_dbtempcol name="FElinea"		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="Pid"    		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="DEid"    		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="FEdeducdesde"  	type="datetime" mandatory="yes">
	<cf_dbtempcol name="FEdeduchasta"  	type="datetime" mandatory="yes">
	<cf_dbtempcol name="Cmeses"  		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="FEidconcepto"  	type="numeric" 	mandatory="no">
	<cf_dbtempcol name="MontoHijos"  	type="numeric" 	mandatory="no">
</cf_dbtemp>
<!--- TEMPORAL DATOS OTRAS DEDUCCIONES A LA RENTA --->
<cf_dbtemp name="MPEN" returnvariable="MPEN" datasource="#session.DSN#">
	<cf_dbtempcol name="DClinea"		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="DEid"    		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="Cdeducdesde"  	type="datetime" mandatory="yes">
	<cf_dbtempcol name="Cdeduchasta"  	type="datetime" mandatory="yes">
	<cf_dbtempcol name="Cmeses"  		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="MontoDeduc"  	type="numeric" 	mandatory="no">
</cf_dbtemp>

<!--- TEMPORAL para Salarios Otros Patronos --->
<cf_dbtemp name="TMPSOP" returnvariable="TMPSOP" datasource="#session.DSN#">
	<cf_dbtempcol name="Ecodigo"   		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="DEid"    		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPperiodo"  type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPmes"    	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPfpago"    	type="datetime" 	mandatory="yes">
</cf_dbtemp>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Crea Tabla">
</cfif>
<!--- Obtiene Calendarios de Pago--->
<cfquery datasource="#session.DSN#">
	insert into #RHCalendariosConsiderar# (CPid, CPperiodo, CPmes, CPdesde, CPhasta)
	select CPid, CPperiodo, CPmes, CPdesde, CPhasta
	from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CPperiodo*12+CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
		<!---and CPtipo = 0--->
</cfquery>


<!--- Agrega Lista de Empleados en los calendarios obtenidos a la tabla temporal --->
<cfquery datasource="#session.dsn#">
	insert into #RHQueryRenta#( DEid, SalGraba, SalGrabaOP, MonRentaOP, MonRenta, MonConyu, MonHijos, RentNeta, RentRete, CantMeses)
	select a.DEid, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, sum(b.SErenta), 0
	from DatosEmpleado a
		inner join HSalarioEmpleado b
			inner join #RHCalendariosConsiderar# d
			on d.CPid = b.RCNid
		on b.DEid = a.DEid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
	group by a.DEid
</cfquery>


<!--- Suma a la Renta Retenida lo cobrado por medio de Deducciones de Tipo Renta --->
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set RentRete = RentRete + coalesce((	select sum(DCvalor) 
								from HDeduccionesCalculo a
									inner join DeduccionesEmpleado b
										inner join TDeduccion c
										on b.TDid = c.TDid
										and c.TDrenta = 1 
									on a.Did = b.Did
									inner join #RHCalendariosConsiderar# d
									on d.CPid = a.RCNid
								where #RHQueryRenta#.DEid = a.DEid
								),0)
</cfquery>

<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set CantMeses = ((select 
		count(distinct CPmes) 
		from HSalarioEmpleado h
			inner join #RHCalendariosConsiderar# d
			on d.CPid = h.RCNid
		where h.DEid = #RHQueryRenta#.DEid
		))
</cfquery>


<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set CantMeses = #Lvar.Cantidad_Meses#
	where CantMeses > #Lvar.Cantidad_Meses#
</cfquery>


<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Empleados Insertados">
</cfif>
<!--- Actualiza Salario Grabado --->
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set SalGraba = SalGraba + coalesce((
			select sum(p.PEmontores)  
			from HPagosEmpleado p
				inner join CalendarioPagos cp
				  on cp.CPid = p.RCNid
	  			  and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  <!---and CPtipo = 0--->
				inner join RHTipoAccion t
				  on t.RHTid = p.RHTid
				  and t.RHTnorenta = 0
			where p.DEid = #RHQueryRenta#.DEid
			  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
				  and cp.CPperiodo = #Lvar.Periodo_Inicial#
				  and cp.CPmes >=  #Lvar.Mes_Inicial#
				  and cp.CPmes <= #Lvar.Mes_Final#
			  <cfelse>
				  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
				  and cp.CPperiodo <= #Lvar.Periodo_Final#
				  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			  </cfif>
			), 0.00)
</cfquery>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Actualiza Salario Grabado">
</cfif>

<!--- Suma Inicidencias al Salario --->
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set SalGraba = SalGraba + coalesce((
			select sum(p.ICmontores)
				from HIncidenciasCalculo p
				inner join CalendarioPagos cp
				  on cp.CPid = p.RCNid
	  			  and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  <!---and CPtipo = 0--->
				inner join CIncidentes c
				  on c.CIid = p.CIid
				  and c.CInorenta = 0
			where p.DEid = #RHQueryRenta#.DEid
			  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
				  and cp.CPperiodo = #Lvar.Periodo_Inicial#
				  and cp.CPmes >=  #Lvar.Mes_Inicial#
				  and cp.CPmes <= #Lvar.Mes_Final#
			  <cfelse>
				  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
				  and cp.CPperiodo <= #Lvar.Periodo_Final#
				  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			  </cfif>
			), 0.00)
</cfquery>	  
<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Suma Inicidencias al Salario">
</cfif>

<!--- resta--->
<cfquery datasource="#session.DSN#">
	update #RHQueryRenta# 
	set SalGraba = SalGraba - coalesce(
										(	
											select sum(cc.CCvaloremp)
											from HCargasCalculo cc, DCargas dc, CalendarioPagos cp
											where cc.DEid = #RHQueryRenta#.DEid
											  and dc.DClinea = cc.DClinea
											  and dc.DCnorenta > 0
											  and cp.CPid=cc.RCNid
										  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
											  and cp.CPperiodo = #Lvar.Periodo_Inicial#
											  and cp.CPmes >=  #Lvar.Mes_Inicial#
											  and cp.CPmes <= #Lvar.Mes_Final#
										  <cfelse>
											  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
											  and cp.CPperiodo <= #Lvar.Periodo_Final#
											  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
										  </cfif>
										)
										, 0.00
									) 
</cfquery>

<!--- Resta Inorenta al salario --->
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set SalGraba = SalGraba - coalesce((	select round(sum(a.SEinorenta),2)
											from HSalarioEmpleado a, CalendarioPagos cp
											where a.DEid = #RHQueryRenta#.DEid
											  and cp.CPid = a.RCNid
											  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
											  and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and cp.CPtipo = 1), 0.00)
</cfquery>
<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Resta Inorenta al salario">
</cfif>

<!--- Se obtienen las ultimas fechas de pago de cada mes consultado ------------------------------>

<cfquery datasource="#session.dsn#" name="aa">
	insert into #TMPSOP#(Ecodigo,DEid,CPperiodo,CPmes, CPfpago)
	
	select cp.Ecodigo,h.DEid,cp.CPmes,cp.CPperiodo,max(cp.CPfpago)
	from HSalarioEmpleado h
		inner join CalendarioPagos cp
			on h.RCNid=cp.CPid
		inner join 	#RHQueryRenta# rh
			on rh.DEid=h.DEid
	where 	h.SEotrossalarios > 0
			  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
				  and cp.CPperiodo = #Lvar.Periodo_Inicial#
				  and cp.CPmes >=  #Lvar.Mes_Inicial#
				  and cp.CPmes <= #Lvar.Mes_Final#
			  <cfelse>
				  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
				  and cp.CPperiodo <= #Lvar.Periodo_Final#
				  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			  </cfif>
	group by cp.Ecodigo,h.DEid, cp.CPmes,cp.CPperiodo
</cfquery>

<cfif Lvar.Debug>
	<cf_dumptable abort="false" var="#TMPSOP#">
</cfif>

<!--- se hace una union para obtener el monto de la fecha de pago que es la mayor del mes--->
<cfquery datasource="#session.dsn#" name="aa">
update #RHQueryRenta#
	set SalGrabaOP = coalesce(
			(
			select sum(p.SEotrossalarios)
			from HSalarioEmpleado p
				inner join CalendarioPagos cp
				  on cp.CPid = p.RCNid
	  			  and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				inner join #TMPSOP# tmp
				  on tmp.DEid=#RHQueryRenta#.DEid
				  and tmp.CPfpago=cp.CPfpago
			where p.DEid = #RHQueryRenta#.DEid
			  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
				  and cp.CPperiodo = #Lvar.Periodo_Inicial#
				  and cp.CPmes >=  #Lvar.Mes_Inicial#
				  and cp.CPmes <= #Lvar.Mes_Final#
			  <cfelse>
				  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
				  and cp.CPperiodo <= #Lvar.Periodo_Final#
				  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			  </cfif>
			  )
			  , 0.00)
</cfquery>

<!--- se obtiene la renta de otros patronos segun el filtro---->
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
	set MonRentaOP = coalesce(
			(
			select sum(p.SErentaotrossalarios)
			from HSalarioEmpleado p
				inner join CalendarioPagos cp
				  on cp.CPid = p.RCNid
	  			  and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			where p.DEid = #RHQueryRenta#.DEid
			  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
				  and cp.CPperiodo = #Lvar.Periodo_Inicial#
				  and cp.CPmes >=  #Lvar.Mes_Inicial#
				  and cp.CPmes <= #Lvar.Mes_Final#
			  <cfelse>
				  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
				  and cp.CPperiodo <= #Lvar.Periodo_Final#
				  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			  </cfif>
			  )
			  , 0.00)
			
</cfquery>


<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Actualiza Salario Grabado">
</cfif>


<!--- Actualiza créditos fiscales --->

<!---ljimenez: sacamos la cantidad de meses que corresponde a los hijos--->
<cfquery datasource="#session.dsn#">
	insert into #MH#(FElinea,Pid,DEid, FEdeducdesde,Cmeses,FEidconcepto,FEdeduchasta)
		select f.FElinea, f.Pid, f.DEid, FEdeducdesde,0,f.FEidconcepto,coalesce(f.FEdeduchasta,'61000101')
		from FEmpleado f, #RHQueryRenta# 
		where f.DEid = #RHQueryRenta#.DEid
			<!---and f.Pid = 2--->
			and f.FEdeducrenta = 1
			and (f.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar.fechaInicial#">
			or  f.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar.fechaFinal#">)
</cfquery>


<cfquery name="mhijos" datasource="#session.dsn#">
	select *
		from #MH# 
</cfquery>

<cfloop query="mhijos">
	<cfset fInicial = year(mhijos.FEdeducdesde) * 12 + month(mhijos.FEdeducdesde)>
	<cfset fFinal = Form.periodo_final * 12 + Form.mes_final>
	<cfset HMeses = (FFinal - FInicial) +1>
	
	<cfif HMeses LT 0> <cfset HMeses = 0> </cfif>
	
	<cfif #Lvar.Cantidad_Meses# LT HMeses> 
		<cfset HMeses = #Lvar.Cantidad_Meses#>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update #MH# set Cmeses = #HMeses#
			where DEid = #mhijos.DEid#
			and FElinea = #mhijos.FElinea# 
	</cfquery>
</cfloop>

<!---ljimenez: fin sacamos la cantidad de meses que corresponde a los hijos--->

<cfquery datasource="#session.dsn#">
	update #MH#
		set MontoHijos = Cmeses * 
			coalesce(( select DCDvalor
					from ConceptoDeduc cd
					inner join DConceptoDeduc dc
						  on dc.CDid = cd.CDid
					where EIRid = #Lvar.EIRid#
					  and cd.CDid = #MH#.FEidconcepto
			), 0.00)
	where Pid = 2
</cfquery>

<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
		set MonHijos = MonHijos + 
			coalesce(( 
				select sum(f.MontoHijos) 
				from #MH# f 
				where f.DEid = #RHQueryRenta#.DEid
				and f.Pid = 2
			), 0.00) 
</cfquery>


<cfquery datasource="#session.dsn#">
	update #MH#
		set MontoHijos = Cmeses * 
			coalesce(( select DCDvalor
					from ConceptoDeduc cd
					inner join DConceptoDeduc dc
						  on dc.CDid = cd.CDid
					where EIRid = #Lvar.EIRid#
					  and cd.CDid = #MH#.FEidconcepto
			), 0.00)
	where Pid = 3
</cfquery>
<cfquery datasource="#session.dsn#">
	update #RHQueryRenta#
		set MonConyu = MonConyu + 
			coalesce(( 
				select sum(f.MontoHijos) 
				from #MH# f 
				where f.DEid = #RHQueryRenta#.DEid
				and f.Pid = 3
			), 0.00) 
</cfquery>


<!--- DATOS DE OTRAS DEDUCCIONES SOBRE RENTA (PENSIONES VOLUNTARIAS) --->
<!--- SE BUCAN OTRAS DEDUCCIONES PARA LOS EMPLEADOS --->
<cfquery name="consulta" datasource="#session.DSN#">
	update #RHQueryRenta#
		set MonOtrasDeduc = coalesce((select sum(cc.CCvaloremp)
									from HCargasCalculo cc, DCargas dc, CalendarioPagos cp
									where cc.DEid = #RHQueryRenta#.DEid
									  and dc.DClinea = cc.DClinea
									  and dc.DCnorenta > 0
									  and cp.CPid=cc.RCNid
								  <cfif Lvar.Periodo_Inicial EQ Lvar.Periodo_Final>
									  and cp.CPperiodo = #Lvar.Periodo_Inicial#
									  and cp.CPmes >=  #Lvar.Mes_Inicial#
									  and cp.CPmes <= #Lvar.Mes_Final#
								  <cfelse>
									  and cp.CPperiodo >= #Lvar.Periodo_Inicial#
									  and cp.CPperiodo <= #Lvar.Periodo_Final#
									  and cp.CPperiodo*12+cp.CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
								  </cfif>),0)
</cfquery>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Obtiene créditos fiscales">
</cfif>

<cfquery datasource="#session.dsn#">
	<!---===== Modificacion Lizandro para que funcione el reporte no solo Costa Rica =====--->
	update #RHQueryRenta# 
	set MonRenta = coalesce((	
			select round(
					((#RHQueryRenta#.SalGraba - ((a.DIRinf/c.IRfactormeses) * #RHQueryRenta#.CantMeses)) * (a.DIRporcentaje / 100)) 
					+ (a.DIRmontofijo * #RHQueryRenta#.CantMeses)
					,2)  
			from DImpuestoRenta a, 
				 EImpuestoRenta b, 
				 ImpuestoRenta c
			where a.EIRid = #Lvar.EIRid#
			and a.EIRid = b.EIRid
			and b.IRcodigo=c.IRcodigo
			<cfif Lvar.Debug>
				<cf_dumptable abort=false var="#RHQueryRenta#" label="Obtiene créditos fiscales">
			</cfif>
			and round(#RHQueryRenta#.SalGraba,2) >= (a.DIRinf/c.IRfactormeses) * #RHQueryRenta#.CantMeses
			and round(#RHQueryRenta#.SalGraba,2) <= (a.DIRsup/IRfactormeses) * #RHQueryRenta#.CantMeses
			), 0.00)
</cfquery>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Actualiza MonRenta">
</cfif>

<cfquery datasource="#session.dsn#">
	update #RHQueryRenta# set RentNeta = MonRenta - MonConyu - MonHijos
</cfquery>

<cfquery datasource="#session.dsn#">
	update #RHQueryRenta# 
		set RentNeta = 0
		<!----===== Modificacion Lizandro: "Pues para efectos visuales, aunque la Renta del Empleado es menor a Cero, si le puedo mostrar en pantalla la renta calculada y el monto de los créditos Fiscales."
		, MonConyu = 0, MonHijos = 0, MonRenta = 0 
		=====---->
	where RentNeta <= 0
</cfquery>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryRenta#" label="Actualiza RenNeta">
</cfif>

<cfif not isdefined("Form.INCUIRNORENTA")>
	<cfquery name="data" datasource="#session.dsn#">
		delete #RHQueryRenta#
		where MonRenta = 0
		and RentRete = 0
	</cfquery>
	<cfif Lvar.Debug>
		<cf_dumptable abort=false var="#RHQueryRenta#" label="Elimina Nulos">
	</cfif>
</cfif>

<cfquery name="data" datasource="#session.dsn#">
	select case when len(coalesce(b.DEdato3,b.DEidentificacion))>0 then
						coalesce(b.DEdato3,b.DEidentificacion)
					 else
					 	'0000000000'
					 end as ID,
		{fn concat ( {fn concat ( {fn concat ( {fn concat (  DEapellido1  , ' ' )}, DEapellido2 )}, ', ' )}, DEnombre )} as Name,
		CantMeses as Meses,
		SalGraba,
		SalGrabaOP,
		MonRentaOP,
		MonRenta,
		MonConyu,
		MonHijos,
		MonOtrasDeduc,
		RentNeta,
		RentRete,
		RentNeta - RentRete as Diferencia
	from #RHQueryRenta# a
		inner join DatosEmpleado b
		on b.DEid = a.DEid
</cfquery>
<cfquery name="dataTOTAL" datasource="#session.dsn#">
	select 
		SUM(CantMeses) as MesesTOTAL,
		SUM(SalGraba) as SalGrabaTOTAL,
		SUM(SalGrabaOP) as SalGrabaOPTOTAL,
		SUM(MonRentaOP) as MonRentaOPTOTAL,
		SUM(MonRenta) as MonRentaTOTAL,
		SUM(MonConyu) as MonConyuTOTAL,
		SUM(MonHijos) as MonHijosTOTAL,
		SUM(MonOtrasDeduc) as MonOtrasDeducTOTAL,
		SUM(RentNeta) as RentNetaTOTAL,
		SUM(RentRete) as RentReteTOTAL,
		SUM(RentNeta - RentRete) as DiferenciaTOTAL
	from #RHQueryRenta# 
</cfquery>

<cfinclude template="reporteRenta-wsqlOP.cfm">
