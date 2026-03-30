
<cfset session.DSN = #cache#>	
<cfset session.Ecodigo = #empresa#>	

<cfquery datasource="#cache#" name="rsCalculo">
	select cid.CIcalculo 
	from CIncidentes ci, CIncidentesD cid
	where ci.CIid = #vCIidVac#
	and  ci.CIid =  cid.CIid
</cfquery>
<cfif rsCalculo.recordcount gt 0>
	<cfquery name="rsCP1" datasource="#Session.DSN#">
		select 	*
		from CalendarioPagos
			where #FechaInicioCalculo#  between CPdesde and CPhasta
			and Ecodigo =#empresa#
	</cfquery>
	
	
	<!--- 1.Calendarios --->
	<cfquery name="rsCP" datasource="#Session.DSN#">
		select 
			a.CPcodigo, 
			a.CPid, 
			rtrim(a.Tcodigo) as Tcodigo, 
			a.CPdesde, 
			a.CPhasta
		from CalendarioPagos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.CPfenvio is null
		and a.CPtipo in (0,2)
		<!---and #ultimafechaantes#  between a.CPdesde and a.CPhasta--->
		and not exists (
			select 1
			from RCalculoNomina h
			where a.Ecodigo = h.Ecodigo
			and a.Tcodigo = h.Tcodigo
			and a.CPdesde = h.RCdesde
			and a.CPhasta = h.RChasta
			and a.CPid = h.RCNid
		)
		and not exists (
			select 1
			from HERNomina i
			where a.Tcodigo = i.Tcodigo
			and a.Ecodigo = i.Ecodigo
			and a.CPdesde = i.HERNfinicio
			and a.CPhasta = i.HERNffin
			and a.CPid = i.RCNid
		)
		order by CPhasta
	</cfquery>
	
	<cfquery name="rsNCP" dbtype="query">
		select Tcodigo, min(CPdesde) as CPdesde
		from rsCP
		group by Tcodigo
	</cfquery>
	
	<!--- Vacaciones Acumuladas --->
	<cfquery name="rsVacaciones" datasource="#Session.DSN#">
		select 	a.DEid, a.EVfantig, 
				coalesce(a.EVfecha, a.EVfantig) as Antiguedad
		from EVacacionesEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data1.DEid#">
	</cfquery>
	
	<!---
	<cfdump var="#ultimafechaantes#">
	<cfdump var="#rsVacaciones#">
	--->
	
	<!------------------------------------------------->
	<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
	<cfset current_formulas = rsCalculo.CIcalculo>
	
	<!---//	#rsVacaciones.EVfantig#,//<cfargument name="Fecha1_Accion" 	type="date"    required="true" 	default="#DateAdd('d',  7, Now())#"><!--- CreateDate(2003,10,20)  --->--->
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>								
	<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsVacaciones.EVfantig),
								   #FechaInicioCalculo#,
								   0,		
								   '0', 	
								   'd', 	
								   #data1.DEid#,
								   1, 		
								   #empresa#,
								   0, 		
								   0, 		
								   '', 		
								   '',		
								   '',		
								   FindNoCase('SalarioPromedio', current_formulas),
								   'false', 
								   '', 		
								   0,		
								   0, 		
								   FindNoCase('DiasRealesCalculoNomina', current_formulas) 
								   )>
	<cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
	<!---
	Empleado : <cfdump var="#rsVacaciones.DEid#"> <br> 
	Cantida data1 : <cfdump var="#data1.Cantidad#"> <br> 
	
	importe<cfdump var="#values.get('importe').toString()#"> <br> 
	cantidad<cfdump var="#values.get('cantidad').toString()#"> <br> 
	resultado: <cfdump var="#values.get('resultado').toString()#"> <br> 
	--->
					
	
	<cfif Not IsDefined("values") or not isdefined("presets_text")>												
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_NoEsPosibleRealizarElCalculo"
			Default="No es posible realizar el c&aacute;lculo"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
		<cfthrow message="#LB_NoEsPosibleRealizarElCalculo#">
	</cfif>
	<!----------------- Fin de calculadora ------------------->		
	<!--- Actualiza Incidencias --->	
	
	<!--- debe aprobar incidencias tipo calculo --->
	<cfset aprobarIncidenciasCalc = false >
	<cfquery name="rs_apruebacalc" datasource="#cache#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 1060
	</cfquery>
	<cfif trim(rs_apruebacalc.Pvalor) eq 1 >
		<cfset aprobarIncidenciasCalc = true >
	</cfif>		
	
	<cfquery name="rsIexiste" datasource="#cache#">
		select *
		from Incidencias
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVacaciones.DEid#">
			and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCIidVac#">
	</cfquery>
	
	<cfif isdefined("rsIexiste") and rsIexiste.RecordCount eq 0 >
	
		<cfquery name="rsIncidencias" datasource="#cache#">
			insert into Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, Imonto, Iestado, NAP)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVacaciones.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vCIidVac#">,
					null,
		<!---			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosConcepto.Ifecha#">,--->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsNCP.CPdesde#">,
					<!---<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatosConcepto.Ivalor#">,--->
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					null,
					null,
					<!---<cfif len(trim(rsDatosConcepto.RCNid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosConcepto.RCNid#">,
					<cfelse>
						null,
					</cfif>--->
					null,
					0,
					null,
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
					<cfif aprobarIncidenciasCalc>
						, 0, null
					<cfelse>
						, 1, 400
					</cfif>	)
		</cfquery>	
	</cfif>
</cfif>