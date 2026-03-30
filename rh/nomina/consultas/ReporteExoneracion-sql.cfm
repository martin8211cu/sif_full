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
<cfif isDefined("form.CPcodigo2") and len(trim(Form.CPcodigo2)) gt 0>
	<!--- No realiza el calculo de los periodos desde y hasta --->
	<cfelse>
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
</cfif>

<cfif Lvar.Debug>
	<cfdump var="#Lvar#">
</cfif>

<!--- Prueba para realizar el reporte de exoneraciones ---->
<!--- Para prender el modo Debug Pinta el desarrollo del llanado de la tambla temporal para el Reporte MSG_Error2--->
<cfset Lvar.Debug = false>


<cfif isDefined("form.chkHistorico")>
	<cfset historia = "H">
<cfelse>
	<cfset historia = "" >
</cfif>


<!--- Se realiza el filtro por nomina--->
 
<cfif form.radio eq 1 >
	<!--- Obtiene el Tcodigo de la nomina --->
	<cfset local.listaTcodigo=''>

	<cfif len(trim(form.Tcodigo1))><cfset local.listaTcodigo=listAppend(local.listaTcodigo,form.Tcodigo1)></cfif>
	<cfif isDefined("form.ListaTipoNomina1")><cfset local.listaTcodigo=listAppend(local.listaTcodigo,form.ListaTipoNomina1)></cfif>

<cfelseif form.radio eq 2>	<!--- Se realiza el filtro por calendario de pago --->
	<cfset local.ListaCPid = '0'>
	<cfif isDefined("form.chkHistorico")>
		<cfif len(trim(form.CPid2))><cfset local.ListaCPid=listAppend(local.ListaCPid,form.CPid2)></cfif>
		<cfif isDefined("form.ListaTCodigoCalendario2")><cfset local.ListaCPid=listAppend(local.ListaCPid,form.ListaTCodigoCalendario2)></cfif>
	<cfelse>	
		<cfif len(trim(form.CPid21))><cfset local.ListaCPid=listAppend(local.ListaCPid,form.CPid21)></cfif>
		<cfif isDefined("form.ListaTCodigoCalendario21")><cfset local.ListaCPid=listAppend(local.ListaCPid,form.ListaTCodigoCalendario21)></cfif>
	</cfif>
</cfif>
	
<!--- Tabla temporal para guardar los datos de exoneracion del empleado a consultar --->
<cf_dbtemp name="RHQueryExoneracion" returnvariable="RHQueryExoneracion" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid"    				type="numeric" 	mandatory="yes"> 
	<cf_dbtempcol name="PC"						type="money"   	mandatory="no"> <!--- Pago de pension complementaria --->
	<cf_dbtempcol name="CPE"					type="money"   	mandatory="no"> <!--- Pago Realizado por empleado en Cargas --->
	<cf_dbtempcol name="RPE"					type="money"   	mandatory="no">	<!--- Pago Realizado por empleado en Renta --->
	<cf_dbtempcol name="RCony"					type="money"   	mandatory="no"> <!--- Pago de exoneracion por Conyuge --->
	<cf_dbtempcol name="RHijo"					type="money"  	mandatory="no"> <!--- Pago de exoneracion por hijo --->
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>

<!--- Tabla temporal para guardar el periodo --->
<cf_dbtemp name="CalendariosConsiderar" returnvariable="RHCalendariosConsiderar" datasource="#session.DSN#">
	<cf_dbtempcol name="CPid"    	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPperiodo"  type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPmes"    	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPdesde"    type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPhasta"    type="datetime" mandatory="yes">
	<cf_dbtempkey cols="CPid">
</cf_dbtemp>

<cfif Lvar.Debug>
	<cf_dumptable abort=false var="#RHQueryExoneracion#" label="Crea Tabla">
</cfif>

<!--- Obtiene Calendarios de Pago--->

<cfquery datasource="#session.DSN#">
	insert into #RHCalendariosConsiderar# (CPid, CPperiodo, CPmes, CPdesde, CPhasta)
	select CPid, CPperiodo, CPmes, CPdesde, CPhasta
	from CalendarioPagos cp
		inner join #historia#RCalculoNomina rcn
			on cp.CPid=rcn.RCNid
	where 

		<cfif form.radio eq 1>
			CPperiodo*12+CPmes between #Lvar.factorInicial# and #Lvar.factorFinal#
			and ltrim(rtrim(cp.Tcodigo)) in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.listaTcodigo#" list="yes">)
			and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfelse>
		 	cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#local.ListaCPid#" list="true">)	
		</cfif>
</cfquery> 

<!--- Agrega DEid de acuerdo al periodo y mes consultado--->
	
<cfquery datasource="#session.dsn#" name="rsInsertRHQueryExo">
	insert into #RHQueryExoneracion#(DEid)
	select de.DEid
	from DatosEmpleado de
		inner join #historia#SalarioEmpleado hse
			 inner join #RHCalendariosConsiderar# rhcc
			on rhcc.CPid = hse.RCNid
		on hse.DEid = de.DEid
		inner join #historia#RHExoneracionCalculo rhec 
		on rhec.DEid = de.DEid
		and rhec.RCNid = rhcc.CPid
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif> 
		group by de.DEid
</cfquery>

	
<!---Indice para actualizar los datos en la tabla temporal a los empleados --->
<cfquery datasource="#session.dsn#" name="rsDeid">
	select DEid
	from #RHQueryExoneracion# 
</cfquery>	
 

 <cfif isdefined("form.DEid") and len(trim(form.DEid))>
	 <!--- Llama a la funcion para actualizar los datos de pagos de exoneracion del usuario que se esta consultando --->
	 <cfinvoke method="updateRHQueryExoneracion">
	    <cfinvokeargument name="datasource" value="#session.dsn#">
	    <cfinvokeargument name="DEid" value="#form.DEid#">
	 </cfinvoke>

	 <cfelse>
	 <cfloop query="rsDEid">
	 	<!--- Llama a la funcion para actualizar los datos de pagos de exoneracion de los usuarios --->
	 	<cfinvoke method="updateRHQueryExoneracion">
    		<cfinvokeargument name="datasource" value="#session.dsn#">
         	<cfinvokeargument name="DEid" value="#rsDEid.DEid#">
 		</cfinvoke>
	 </cfloop>	

 </cfif>

<!--- Para imprimir el reporte --->
<cfquery name="data" datasource="#session.dsn#">
	select DEidentificacion as Id, 
		{fn concat ( {fn concat ( {fn concat ( {fn concat (  DEapellido1  , ' ' )}, DEapellido2 )}, ', ' )}, DEnombre )} as Name,
		<!---Pension complementaria para cargas ---->
		PC,
		<!--- Pago realizado para cargas --->
		CPE,
		<!--- Total --->
		coalesce(PC,0) + coalesce(CPE,0)  as totalp,
		<!--- Monto pago exoneracion por conyuge --->
		RCony, 
		<!--- Monto pago exoneracion por hijo --->
		RHijo,
		<!--- Pension complementaria para renta ---->
		PC,
		<!--- PAgo realizado para renta --->
		RPE,
		<!--- Total --->
		coalesce(RCony,0) +coalesce(RHijo,0) +coalesce(PC,0) + coalesce(RPE,0) as totals 
		 
		from #RHQueryExoneracion# rhqe
		inner join DatosEmpleado de
		on de.DEid = rhqe.DEid
		
</cfquery>

<cfinclude template="ReporteExoneracion-wsql.cfm">

<!--- Generar el reporte a excel --->
<cfif isdefined("ExportarExcel")>
	<cfset archivo = "ReporteExoneracion_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'ReporteExoneracion')>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#Exportar#" charset="windows-1252">
	<cfheader name="Content-Disposition" value="attachment;filename=#archivo#.xls">
	<cfcontent file="#txtfile#" type="application/vnd.ms-excel" deletefile="yes">

	<cfelseif isdefined("ExportarPDF")>
		<cfdocument format="PDF" >
			<cfoutput>
				#Exportar#
			</cfoutput>
		</cfdocument>
	<cfelse>
		<!--- Lo muestra en pantalla --->
		<cfoutput>
				#Exportar#
		</cfoutput>	
</cfif>


<!--- Agrega los pagos realizados tanto en cargas como en renta y registro de pago de exoneracion por hijo y conyuge--->
<cffunction name="updateRHQueryExoneracion" returntype="void">
    <cfargument name="datasource" type="string" required="true">
    <cfargument name="DEid" type="numeric" default="-1" required="true">
   
    <cfquery datasource="#session.dsn#">
		update #RHQueryExoneracion# 
			set PC = (select sum(rhec.RHECmonto)
						from #historia#RHExoneracionCalculo rhec
						inner join #RHCalendariosConsiderar# rhcc
							on rhec.RCNid = rhcc.CPid
						where rhec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and rhec.DClinea is not null 
						),

				CPE = coalesce( (
							select sum(TT.monto)
							from (
								select cp.CPperiodo, cp.CPmes, rhec.PEXid,max(rhec.RHECmonto) as monto
								from #historia#RHExoneracionCalculo rhec
								inner join #RHCalendariosConsiderar# rhcc
									on rhec.RCNid = rhcc.CPid
								inner join CalendarioPagos cp
									on cp.CPid = rhcc.CPid	
								where rhec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								and rhec.PEXid is not null 
								and rhec.PEXTtipo <> 1 <!--- Aplica los tipos 2  o 3 --->
								group by cp.CPperiodo, cp.CPmes, rhec.PEXid
							) TT

						  ) , 0),


				RPE = coalesce( (
							select sum(TT.monto)
							from (
								select cp.CPperiodo, cp.CPmes, rhec.PEXid,max(rhec.RHECmonto) as monto
								from #historia#RHExoneracionCalculo rhec
								inner join #RHCalendariosConsiderar# rhcc
									on rhec.RCNid = rhcc.CPid
								inner join CalendarioPagos cp
									on cp.CPid = rhcc.CPid	
								where rhec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								and rhec.PEXid is not null 
								and rhec.PEXTtipo <> 2 <!--- Aplica los tipos 1 o 3 --->
								group by cp.CPperiodo, cp.CPmes, rhec.PEXid
							) TT

						  ) , 0),

				RCony = (
							select SUM(Monto)
							from (
								select cp.CPperiodo as Periodo, cp.CPmes as Mes, rhec.PEXTtipo as Tipo, MAX(rhec.RHECmonto) as Monto, rhec.FElinea as Felinea
									from CalendarioPagos cp
									inner join #historia#RHExoneracionCalculo rhec
										on cp.CPid = rhec.RCNid 
									where rhec.PEXTtipo = 3
									and rhec.PEXid is null
								    and rhec.DClinea is null
								    and rhec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								    and rhec.DEid in (select DEid from #RHQueryExoneracion#) <!--- Empleado se encuentra en la tabla de temporal de exoneracion --->  
								   	and exists (select 1 
								    				from #RHCalendariosConsiderar# rhcc
								    				where rhcc.CPid = cp.CPid 
								    			)
									group by CPperiodo, CPmes, PEXTtipo, RHECmonto, FElinea
							) TT
						),



				RHijo = (
							select SUM(Monto)
							from (
								select cp.CPperiodo as Periodo, cp.CPmes as Mes, rhec.PEXTtipo as Tipo, MAX(rhec.RHECmonto) as Monto, rhec.FElinea as Felinea
									from CalendarioPagos cp
									inner join #historia#RHExoneracionCalculo rhec
										on cp.CPid = rhec.RCNid 
									where rhec.PEXTtipo = 2
									and rhec.PEXid is null
								    and rhec.DClinea is null
								    and rhec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								    and rhec.DEid in (select DEid from #RHQueryExoneracion#)  <!--- Empleado se encuentra en la tabla de temporal de exoneracion --->  
								   	and exists (select 1 
								    				from #RHCalendariosConsiderar# rhcc
								    				where rhcc.CPid = cp.CPid 
								    			)
									group by CPperiodo, CPmes, PEXTtipo, RHECmonto, FElinea
							) TT
						)
			 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>	
</cffunction>

