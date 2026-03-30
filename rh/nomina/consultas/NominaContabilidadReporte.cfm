<cfif isdefined("form.chkutilizarfiltro")>
	<cfset pre=''>
	<cfif isdefined('form.tiponomina')><!--- historico--->
		<cfset pre='H'>		
	</cfif>
	<cfquery datasource="#session.dsn#" name="listaNominas" >
		select cp.CPid
		from CalendarioPagos cp
			inner join #PRE#RCalculoNomina hr
				on cp.CPid =  hr.RCNid
		where cp.Ecodigo = #session.Ecodigo#
			and CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.filtro_FechaDesde)#">
			and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.filtro_FechaHasta)#">
			<cfif isdefined("form.LISTATIPONOMINA10") and len(trim(form.LISTATIPONOMINA10))>
				and rtrim(ltrim(upper(cp.Tcodigo))) in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ucase(form.LISTATIPONOMINA10)#">)
			</cfif>
	</cfquery> 
	<cfif !len(trim(listaNominas.CPid))>
		<cf_errorCode code="52228" msg="No existen registros para mostrar">	
	</cfif>
	<cfset listaNomina=''>
	<cfloop query="listaNominas">
		<cfset listaNomina = ListAppend(listaNomina, CPid)>
	</cfloop>
	<cfif isdefined('url.tiponomina')><!--- historico--->
		<cfset form.CPidlist1= listaNomina>
	<cfelse>
		<cfset form.CPidlist2= listaNomina>
	</cfif>
</cfif>

<cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
	<cfset form.CPidlist = form.CPidlist1>
<cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
	<cfset form.CPidlist = form.CPidlist2>
<cfelse>
	<!--- Este error no debe presentarse. --->
	<cf_errorCode	code="51920" msg="Atencion: Se requiere que genera la lista de nominas que desea consultar. Proceso Cancelado!">
</cfif>
 <cfset arrayOfi = ListToArray(form.Oficina,',')>


<cfif isdefined('form.TipoNomina')>
	<cfset tablaCalculoNomina = 'HRCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'HDeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'HSalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'HPagosEmpleado'> 
	<cfset tablaIncidenciasCalculo = 'HIncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'HCargasCalculo'>
<cfelse>
	<cfset tablaCalculoNomina = 'RCalculoNomina'>
	<cfset tablaDeduccionesCalculo = 'DeduccionesCalculo'>
	<cfset tablaSalarioEmpleado = 'SalarioEmpleado'>
	<cfset tablaPagosEmpleado = 'PagosEmpleado'>
	<cfset tablaIncidenciasCalculo = 'IncidenciasCalculo'> 
	<cfset tablaCargasCalculo = 'CargasCalculo'>
</cfif>

<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'RepGenPlan'
</cfquery>
<cfquery name="rsNomina" datasource="#session.DSN#">
	select min(RCdesde) as RCdesde, max(RChasta) as RChasta
	from #tablaCalculoNomina#
	where <cf_whereInList Column="RCNid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
	<!---RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">--->
</cfquery>


<cfquery name="rsOficina" datasource="#session.DSN#">
	select Ocodigo,Oficodigo,Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	<cfswitch expression="#arrayOfi[1]#"> 
        <cfcase value="of">
            and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayOfi[2]#">
        </cfcase>
        <cfcase value="go">
            and Ocodigo in (select ct.Ocodigo
                            from AnexoGOficinaDet ct 
                            where ct.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                                and ct.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayOfi[2]#">
                           )
        </cfcase>
     </cfswitch>
	order by Oficodigo
</cfquery>

<cfquery name="rsOfinaCfs" datasource="#session.DSN#">
	select distinct CFid
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	<cfswitch expression="#arrayOfi[1]#"> 
        <cfcase value="of">
            and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayOfi[2]#">
        </cfcase>
        <cfcase value="go">
            and Ocodigo in (select ct.Ocodigo
                            from AnexoGOficinaDet ct 
                            where ct.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                                and ct.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayOfi[2]#">
                           )
        </cfcase>
     </cfswitch>
</cfquery>
<cfset Centros = ValueList(rsOfinaCfs.CFid)>


<style type="text/css">
.detaller {		font-size:10px;
		text-align:right;}
</style>
<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
	<!--- VARIABLES DE TRADUCCION --->
	<cfinvoke key="LB_PLANILLADEPAGOS" default="PLANILLA DE PAGOS" returnvariable="LB_PLANILLADEPAGOS" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_PLANILLADEPAGOSPORDEPARTAMENTO" default="PLANILLA DE PAGOS POR DEPARTAMENTO" returnvariable="LB_PLANILLADEPAGOSPORDEPARTAMENTO" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
	<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
	<!--- FIN VARIABLES DE TRADUCCION --->

	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="NomPlanv1" returnvariable="salida">
        <cf_dbtempcol name="RCNid"   		  	type="int"      	mandatory="yes">
		<cf_dbtempcol name="LTid"   		  	type="int"      	mandatory="yes">
		<cf_dbtempcol name="DEid"   		  	type="int"      	mandatory="yes">
		<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)"  mandatory="yes">
		<cf_dbtempcol name="Nombre"   		  	type="varchar(255)" mandatory="yes">
		<cf_dbtempcol name="Anualidad" 		  	type="money" 		mandatory="no">
		<cf_dbtempcol name="Prohibicion"	  	type="money" 		mandatory="no">	
		<cf_dbtempcol name="CarreraProf"	  	type="money" 		mandatory="no">	
		<cf_dbtempcol name="SubsidioIncapac"  	type="money" 		mandatory="no">	
		<cf_dbtempcol name="PlusVacaciones"   	type="money" 		mandatory="no">		
		<cf_dbtempcol name="PermDietOtro"	  	type="money"    	mandatory="no">	
		<cf_dbtempcol name="Dias"	  		  	type="money"        mandatory="no">
		<cf_dbtempcol name="SalOrdinario"	  	type="money"    	mandatory="no">
		<cf_dbtempcol name="RentaDieta"		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="CoopeSNE" 		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="ASIAR" 		  	  	type="money"  	  	mandatory="no">
		<cf_dbtempcol name="INS" 		  	  	type="money"  	  	mandatory="no">
		<cf_dbtempcol name="Renta" 			  	type="money"    	mandatory="no">
		<cf_dbtempcol name="AFAR" 			  	type="money"    	mandatory="no">
		<cf_dbtempcol name="CargaCCSS"		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="ASAR" 		  	  	type="money"    	mandatory="no">
		<cf_dbtempcol name="AsarNav" 			type="money"    	mandatory="no">
		<cf_dbtempcol name="AsarOtros" 		  	type="money" 		mandatory="no">
		<cf_dbtempcol name="AsarClub" 	  		type="money"    	mandatory="no">
        <cf_dbtempcol name="AsarExtra" 	  		type="money"    	mandatory="no">
        <cf_dbtempcol name="AsarEspec" 	  	  	type="money"    	mandatory="no">
        <cf_dbtempcol name="AsarConting" 	  	type="money"    	mandatory="no">
		<cf_dbtempcol name="BancPopular"	  	type="money"    	mandatory="no">
		<cf_dbtempcol name="BnVital"  	  	  	type="money"    	mandatory="no">        
        <cf_dbtempcol name="LTsalario" 		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="MontoTotalIngreso"  type="money"   	  	mandatory="no">
        <cf_dbtempcol name="CoopeServ" 		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="TotalIngresos" 	  	type="money"    	mandatory="no">
        <cf_dbtempcol name="Embargo"  		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="Devengado" 		  	type="money"    	mandatory="no">
		<cf_dbtempcol name="Colegios" 	  		type="money"   	  	mandatory="no">
		<cf_dbtempcol name="TotalDeducciones" 	type="money"    	mandatory="no">
        <cf_dbtempcol name="ComiteSocial" 	  	type="money"    	mandatory="no">
        <cf_dbtempcol name="Roblealto"   		type="money"    	mandatory="no">   
        <cf_dbtempcol name="FondoSolid" 	  	type="money"    	mandatory="no">  
        <cf_dbtempcol name="Coopenae"    		type="money"    	mandatory="no"> 
		<cf_dbtempcol name="Liquido" 		  	type="money"   	  	mandatory="no">
		<cf_dbtempcol name="CFid"   		  	type="int"      	mandatory="yes">
	</cf_dbtemp>
     
    <!--- INGRESA LOS DATOS DE LOS CALENDARIOS DE PAGO DEL EMPLEADO --->
	<cfquery name="rsCalendarios" datasource="#session.dsn#">	
 	 	insert into #salida#(a.RCNid,DEid, DEidentificacion,Nombre, SalOrdinario,LTid,CFid, LTsalario)
			Select a.RCNid,
				a.DEid, b.DEidentificacion, 
				{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})},
				sum(a.SEsalariobruto),max(x.LTid) as LTid,
				max(e.CFid) as CFid, sum(x.LTsalario)
			from  #tablaSalarioEmpleado# a
			inner join DatosEmpleado b
				on b.DEid = a.DEid
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
				</cfif>
             inner join LineaTiempo x
             	on a.DEid =  x.DEid
                and x.LTid = (select max(LTid) from LineaTiempo j
                			  where x.DEid = j.DEid)  
			inner join #tablaCalculoNomina# c
				  on c.RCNid = a.RCNid
			inner join RHPlazas e
				  on e.RHPid = x.RHPid
				<cfif isdefined("Centros") and len(trim(centros))>
				  and e.CFid in (#Centros#)
				</cfif>
			where <cf_whereInList Column="a.RCNid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
			group by a.RCNid,a.DEid, b.DEidentificacion, 
				{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(' ',DEnombre)})})})}
	</cfquery>
   
	<!--- DIAS VACACIONES --->
	<cfquery datasource="#session.DSN#">
        update #salida#
        set Dias = coalesce((select sum(ICvalor)
        								from #tablaIncidenciasCalculo# a
									inner join CIncidentes bb
										on a.CIid=bb.CIid
                                    		and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'DiasVac' <!---Conceptos usados para pago vacaciones--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>
    
     <!--- Salario Base --->
     <cfquery datasource="#session.DSN#">
          update #salida# 
           set LTSalario = coalesce((select sum(PEmontores)
	           						from #tablaPagosEmpleado# a, RHTipoAccion t
	                                where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid
		                                and a.RHTid = t.RHTid
		                                and t.RHTnocargasley = 0
	                                ),0.00)
	</cfquery>

  
	<!--- Anualidad --->
    <cfquery datasource="#session.DSN#">
    	update #salida#
			set Anualidad = (coalesce((select sum(ICmontores)
										from #tablaIncidenciasCalculo# a
										inner join CIncidentes bb
											on a.CIid=bb.CIid
					    		                and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Anualidad' <!---Conceptos usuados para el pago de anualidad--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
										where a.DEid = #salida#.DEid
											and a.RCNid = #salida#.RCNid),0.00))
    </cfquery>
    
	<!--- Prohibicion --->
    <cfquery datasource="#session.DSN#">
       	update #salida#
	        set Prohibicion = (coalesce((select sum(ICmontores)
										from #tablaIncidenciasCalculo# a
										inner join CIncidentes bb
											on a.CIid=bb.CIid
					    		                and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Prohibicion' <!---Conceptos usados para pago Prohibicion--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
										where a.DEid = #salida#.DEid
											and a.RCNid = #salida#.RCNid),0.00))
   </cfquery>


    <!---CARRERA PROFESIONAL--->
    <cfquery datasource="#session.DSN#">
       	update #salida#
        	set CarreraProf = (coalesce((select sum(ICmontores)
        								from #tablaIncidenciasCalculo# a
										inner join CIncidentes bb
											on a.CIid=bb.CIid
		                                		and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'CarreraProf' <!---Conceptos usuados para el pago de Carrera Profesional--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
										where a.DEid = #salida#.DEid
											and a.RCNid = #salida#.RCNid),0.00))
    </cfquery>

    <!--- SUBSIDIO INCAPACIDAD --->
    <cfquery datasource="#session.DSN#">
    	update #salida#
        set SubsidioIncapac = coalesce((select sum(PEmontores)
		           						from #tablaPagosEmpleado# a
		                                where a.DEid = #salida#.DEid 
											and a.RCNid = #salida#.RCNid
		                        	        and a.RHTid in (1,2)),0.00) 
        					+
     						coalesce((select sum(ICmontores)
	        							from #tablaIncidenciasCalculo# a
										inner join CIncidentes bb
											on a.CIid=bb.CIid
	                                    		and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'SubsIncap' <!---Conceptos usuados para el pago de Subsidio Incapacidad--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
										where a.DEid = #salida#.DEid
											and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>

   
    <!--- PLUS DE VACACIONES --->
    <cfquery datasource="#session.DSN#">
        update #salida#
        set PlusVacaciones = coalesce((select sum(ICmontores)
        							from #tablaIncidenciasCalculo# a
									inner join CIncidentes bb
										on a.CIid=bb.CIid
                                    		and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'PlusVacac' <!---Conceptos usuados para el pago de Subsidio Incapacidad--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>

	<!--- PERMISOS, DIETAS Y OTROS --->
    <cfquery datasource="#session.DSN#">
    	update #salida#
        set PermDietOtro = coalesce((select sum(ICmontores)
        							from #tablaIncidenciasCalculo# a
									inner join CIncidentes bb
									on a.CIid=bb.CIid
                                    and bb.CIid in (select a1.CIid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'PermDietOtro' <!---Conceptos usados para pago Permisos, dietas, otros--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								where a.DEid = #salida#.DEid
								and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>

    <!--- SALARIO ORDINARIO--->
    <cfquery datasource="#session.DSN#">
    	update #salida#
        set SalOrdinario = coalesce((select sum(PEmontores)
        							 from #tablaPagosEmpleado# hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
   	</cfquery>
    
    <!--- RENTA DIETA --->
	<cfquery datasource="#session.DSN#">
    	update #salida#
			set RentaDieta = coalesce((	select sum(a.DCvalor) 
										from #tablaDeduccionesCalculo# a
										inner join DeduccionesEmpleado b
											on a.Did = b.Did
												and a.DEid = b.DEid
										inner join TDeduccion z
											on b.TDid=z.TDid
										where a.DEid = #salida#.DEid 
											and a.RCNid = #salida#.RCNid 
					                        and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'RentaDieta' <!---Deducción Utilizada para el Cobro de Renta de Dieta--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)

					            ),0.00)
    </cfquery>
	
    <!--- COOPESNE --->
	<cfquery datasource="#session.DSN#">
    	update #salida#
			set CoopeSNE = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
									on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'CoopeSNE' <!---Deducción Utilizada para el cobro de CoopeSNE--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
							),0.00)
    </cfquery>
    
    <!--- COMITE SOCIAL SUTEL --->
	<cfquery datasource="#session.DSN#">
    	update #salida#
			set ComiteSocial = coalesce((select sum(a.DCvalor) 
										from #tablaDeduccionesCalculo# a
										inner join DeduccionesEmpleado b
											on a.Did = b.Did
												and a.DEid = b.DEid
										inner join TDeduccion z
											on b.TDid=z.TDid
										where a.DEid = #salida#.DEid 
											and a.RCNid = #salida#.RCNid 
											and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'ComiteSocial' <!---Deducción Utilizada para el cobro de Comite Social Sutel--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>
    
   <!--- ASIAR --->
	<cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salida#
        set ASIAR = coalesce((select sum(a.DCvalor) 
								from #tablaDeduccionesCalculo# a
								inner join DeduccionesEmpleado b
									on a.Did = b.Did
										and a.DEid = b.DEid
								inner join TDeduccion z
									on b.TDid=z.TDid
								where a.DEid = #salida#.DEid 
									and a.RCNid = #salida#.RCNid 
			                        and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Asiar' <!---Deducción Utilizada para el cobro ASIAR--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			            ),0.00)
    </cfquery>

    <!--- INS --->
	<cfquery datasource="#session.DSN#">
    	update #salida#
        set INS = coalesce((select sum(a.DCvalor) 
							from #tablaDeduccionesCalculo# a
							inner join DeduccionesEmpleado b
								on a.Did = b.Did
									and a.DEid = b.DEid
							inner join TDeduccion z
								on b.TDid=z.TDid
							where a.DEid = #salida#.DEid 
								and a.RCNid = #salida#.RCNid 
		                        and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Ins' <!---Deducción Utilizada para el cobro INS--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	                	),0.00)
    </cfquery>

    
    <!--- EMBARGOS --->
    <cfquery  datasource="#session.DSN#">
    	update #salida#
			set Embargo = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
				                        and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Embargo' <!---Deducción Utilizada para el cobro Embargos--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
				                ),0.00)
    </cfquery>
    
    <!--- AFAR --->
    <cfquery  datasource="#session.DSN#">
    	update #salida#
			set AFAR = coalesce((select sum(a.DCvalor) 
								from #tablaDeduccionesCalculo# a
								inner join DeduccionesEmpleado b
									on a.Did = b.Did
										and a.DEid = b.DEid
								inner join TDeduccion z
									on  b.TDid=z.TDid
								where a.DEid = #salida#.DEid 
									and a.RCNid = #salida#.RCNid 
		                        and z.TDid in  (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'Afar' <!---Deducción Utilizada para el cobro AFAR--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
                        ),0.00)
    </cfquery>
    
   	<!--- ASAR - Otros --->
   	<cfquery datasource="#session.DSN#">
		update #salida#
		set AsarOtros = coalesce((select sum(a.DCvalor) 
								from #tablaDeduccionesCalculo# a
								inner join DeduccionesEmpleado b
									on a.Did = b.Did
										and a.DEid = b.DEid
								inner join TDeduccion z
									on b.TDid=z.TDid
								where a.DEid = #salida#.DEid 
									and a.RCNid = #salida#.RCNid 
								and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'AsarOtros' <!---Deducción Utilizada para el cobro Asar - Otros--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
						),0.00)
    </cfquery>

    <!--- RENTA --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salida#
        set Renta = coalesce((select sum(SErenta)
                             from #tablaSalarioEmpleado# hse
                             where hse.RCNid = #salida#.RCNid
                             	and hse.DEid = #salida#.DEid
                             ),0.00)
   	</cfquery>
    
    
    <!--- Cargas C.C.S.S.(9.34%) --->
    <cfquery datasource="#session.DSN#">
    	update #salida#
			set CargaCCSS = coalesce((select sum(a.CCvaloremp) 	
									from #tablaCargasCalculo# a
									inner join DCargas b
										  on b.DClinea = a.DClinea
                                          	and b.DClinea in (select a1.DClinea
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'CargaCCSS' <!---Cargas utilizada para la retencion CCSS--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									where a.DEid = #salida#.DEid
										and a.RCNid = #salida#.RCNid),0.00)
    </cfquery>
    
   <!--- ASAR --->
    <cfquery name="rsCargas" datasource="#session.DSN#">
		update #salida#
		set ASAR = coalesce((select sum(a.CCvaloremp) 	
								from #tablaCargasCalculo# a
								inner join DCargas b
									  on b.DClinea = a.DClinea
	                                      and b.DClinea in  (select a1.DClinea
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'ASAR' <!---Cargas utilizada para la retencion ASAR--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								where a.DEid = #salida#.DEid
									and a.RCNid = #salida#.RCNid
							),0.00)
    </cfquery>

	<!--- BANCO POPULAR --->
	<cfquery  datasource="#session.DSN#">
    	update #salida#
			set BancPopular = coalesce((select sum(a.DCvalor) 
										from #tablaDeduccionesCalculo# a
										inner join DeduccionesEmpleado b
											on a.Did = b.Did
												and a.DEid = b.DEid
										inner join TDeduccion z
											on b.TDid=z.TDid
										where a.DEid = #salida#.DEid 
											and a.RCNid = #salida#.RCNid 
											and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'BancPopular' <!---Deducción Utilizada para el cobros Banco Popular--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									),0.00)
    </cfquery>
    
    <!--- BNVITAL OPC --->
  	<cfquery  datasource="#session.DSN#">
    	update #salida#
			set BnVital = coalesce((select sum(a.DCvalor) 
										from #tablaDeduccionesCalculo# a
										inner join DeduccionesEmpleado b
											on a.Did = b.Did
												and a.DEid = b.DEid
										inner join TDeduccion z
											on b.TDid=z.TDid
										where a.DEid = #salida#.DEid 
											and a.RCNid = #salida#.RCNid 
											and z.TDid in (select a1.TDid
															from RHReportesNomina c1
															    inner join RHColumnasReporte b1
															                inner join RHConceptosColumna a1
															                on a1.RHCRPTid = b1.RHCRPTid
															         on b1.RHRPTNid = c1.RHRPTNid
															        and b1.RHCRPTcodigo = 'BnVital' <!---Deducción Utilizada para el cobro BN-Vital OPC--->
															where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
															  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									),0.00)
    </cfquery>
    
    <!--- COOPESERVIDORES --->
  	<cfquery  datasource="#session.DSN#">
	update #salida#
		set CoopeServ = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'CoopeServ' <!---Deducción Utilizada para el cobro BN-Vital OPC--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>

    
    <!--- Cobro COLEGIOS --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set Colegios = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'Colegios' <!---Deducción Utilizada para el cobro Colegios (Incorporataciones)--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>


    <!--- AHORRO NAVIDEÑO ASAR --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set AsarNav = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'AsarNav' <!---Deducción Utilizada para el cobro ASAR - Ahorro Navideño--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>


    <!--- AHORRO EXTRAORDINARIO ASAR --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set AsarExtra = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'AsarExtra' <!---Deducción Utilizada para el cobro ASAR - Ahorro Extraordinario--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>

	

    
    <!--- AHORRO ESPECIAL ASAR --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set AsarEspec = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'AsarEspec' <!---Deducción Utilizada para el cobro ASAR - Ahorro Especial--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>
 
    

    <!--- FONDO DE CONTINGENCIA ASAR --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set AsarConting = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'AsarConting' <!---Deducción Utilizada para el cobro ASAR - Fondo Contingencia--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>

     <!--- CLUB DE AHORROS ASAR --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set AsarClub = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'AsarClub' <!---Deducción Utilizada para el cobro ASAR - Club de Ahorro --->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>



     <!--- Roblealto --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set Roblealto = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'Roblealto' <!---Deducción Utilizada para el cobro Roble Alto--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>


	<!--- FONDO SOLIDARIO --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set FondoSolid = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'FondoSolid' <!---Deducción Utilizada para el cobro Fondo Solidario--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>
    
	<!--- COOPENAE --->
	<cfquery  datasource="#session.DSN#">
		update #salida#
		set Coopenae = coalesce((select sum(a.DCvalor) 
									from #tablaDeduccionesCalculo# a
									inner join DeduccionesEmpleado b
										on a.Did = b.Did
											and a.DEid = b.DEid
									inner join TDeduccion z
										on b.TDid=z.TDid
									where a.DEid = #salida#.DEid 
										and a.RCNid = #salida#.RCNid 
										and z.TDid in (select a1.TDid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'Coopenae' <!---Deducción Utilizada para el cobro Coopenae--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								),0.00)
    </cfquery>

 
    
	<!--- MONTO TOTALES --->
    <cfquery datasource="#session.DSN#">
    	update #salida#
        set TotalIngresos = (LTsalario + Anualidad+Prohibicion+CarreraProf)
    </cfquery>
    
    <!--- TOTAL DEVENGADO --->
	<cfquery datasource="#session.DSN#">
    	update #salida#
			set   Devengado = ((TotalIngresos+ PermDietOtro + PlusVacaciones) 
            
           				 -   coalesce((select sum(ICmontores)
        								from #tablaIncidenciasCalculo# a
										inner join CIncidentes bb
											on a.CIid=bb.CIid
                                    		and bb.CIid in (select a1.CIid
														from RHReportesNomina c1
														    inner join RHColumnasReporte b1
														                inner join RHConceptosColumna a1
														                on a1.RHCRPTid = b1.RHCRPTid
														         on b1.RHRPTNid = c1.RHRPTNid
														        and b1.RHCRPTcodigo = 'RebDieta' <!---Conceptos usados para Rebajo Monto  Dieta en Total Devengado--->
														where c1.RHRPTNcodigo = 'RepGenPlan' <!---Configuracion Reporte General de Planilla (SUTEL)--->
														  and c1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
										where a.DEid = #salida#.DEid
											and a.RCNid = #salida#.RCNid),0.00))
    </cfquery>


    <!--- SALARIO+SUBSIDIO --->
    <cfquery  datasource="#session.DSN#">
    	update #salida#
			set MontoTotalIngreso= (Devengado + SubsidioIncapac)
    </cfquery>

	<!--- MONTO LIQUIDO --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">
    	update #salida#
        set Liquido = coalesce((select SEliquido
        							 from #tablaSalarioEmpleado# hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
    </cfquery>


	<!--- MONTO TOTAL DEDUCCIONES --->
    <cfquery name="rsSalarioLiq" datasource="#session.DSN#">  
       	update #salida#
        set TotalDeducciones = coalesce((select SEdeducciones
        							 from #tablaSalarioEmpleado# hse
                                     where hse.RCNid = #salida#.RCNid
                                       and hse.DEid = #salida#.DEid
        							),0.00)
	</cfquery>
 



	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	s.DEid,
				s.DEidentificacion,
				s.Nombre,
				sum(s.LTsalario) as LTsalario,
				sum(s.Dias) as Dias,
				sum(s.Anualidad) as Anualidad,
				sum(s.Prohibicion) as Prohibicion,
				sum(s.CarreraProf) as CarreraProf,
				sum (s.SubsidioIncapac) as SubsidioIncapac,
				sum(s.SalOrdinario) as SalOrdinario,
				sum(s.PlusVacaciones) as PlusVacaciones,
				sum(s.PermDietOtro) as PermDietOtro,
				sum(s.CoopeSNE) as CoopeSNE,
				sum(s.ASIAR) as ASIAR,
				sum(s.INS) as INS,
				sum(s.MontoTotalIngreso) as MontoTotalIngreso,
				sum(s.AsarNav) as AsarNav,
				sum(s.CoopeServ) as CoopeServ,
				sum(s.ASAR) as ASAR,
				sum(s.ComiteSocial) as ComiteSocial,
				sum(s.TotalIngresos) as TotalIngresos,
				sum(s.Embargo) as Embargo,
				sum(s.CargaCCSS) as CargaCCSS,
				sum(s.AFAR) as AFAR,
				sum(s.Renta) as Renta,
				sum(s.RentaDieta) as RentaDieta,
				sum(s.AsarOtros) as AsarOtros,
				sum(s.BancPopular) as BancPopular,
				sum(s.Devengado) as Devengado,
				sum(s.Colegios) as Colegios,
				sum(s.TotalDeducciones) as TotalDeducciones,
				sum(s.AsarClub) as AsarClub,
				sum(s.AsarExtra) as AsarExtra,
				sum(s.AsarEspec) as AsarEspec,
				sum(s.AsarConting) as AsarConting,
				sum(s.Roblealto) as Roblealto,
				sum(s.FondoSolid) as FondoSolid,
				sum(s.Coopenae) as Coopenae,
				sum(s.BnVital) as BnVital,
				sum(s.Liquido) as Liquido,
				max(s.CFid) as CFid
        from #salida# s
			inner join CFuncional cf
				on cf.CFid = s.CFid 
            		and cf.CFid = (select min(CFid) from CFuncional k where cf.CFid = k.CFid)
		group by s.DEid, s.DEidentificacion, s.Nombre  
		order by s.Nombre 
	</cfquery>
    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
    
    
    <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <style>
		h1.corte {
			PAGE-BREAK-AFTER: always;}
		.tituloAlterno {
			font-size:20px;
			font-weight:bold;
			text-align:center;}
		.titulo_empresa2 {
			font-size:16px;
			font-weight:bold;
			text-align:center;}
		.titulo_reporte {
			font-size:16px;
			font-style:italic;
			text-align:center;}
		.titulo_filtro {
			font-size:14px;
			font-style:italic;
			text-align:center;}
		.titulolistas {
			font-size:14px;
			font-weight:bold;
			background-color:#CCCCCC;
			}
		.titulo_columnar {
			font-size:14px;
			font-weight:bold;
			background-color:#CCCCCC;
			text-align:right;}
		.listaCorte {
			font-size:10px;
			font-weight:bold;
			background-color: #F4F4F4;
			text-align:left;}
		.listaCorte3 {
			font-size:10px;
			font-weight:bold;
			background-color:  #E8E8E8;
			text-align:left;}
		.listaCorte2 {
			font-size:10px;
			font-weight:bold;
			background-color: #D8D8D8;
			text-align:left;}
		.listaCorte1 {
			font-size:12px;
			font-weight:bold;
			background-color:#CCCCCC;
			text-align:left;}
		.total {
			font-size:14px;
			font-weight:bold;
			background-color:#C5C5C5;
			text-align:right;}

		.detalle {
			font-size:10px;
			text-align:left;}
		.detaller {
			font-size:10px;
			text-align:right;}
		.detallec {
			font-size:10px;
			text-align:center;}	
			
		.mensaje {
			font-size:14px;
			text-align:center;}
		.paginacion {
			font-size:14px;
			text-align:center;}
	</style>
	<cfsilent>
		<cfset Lvar_TotalOrd			= 0>
        <cfset Lvar_TotalAnualidad 	= 0>
        <cfset Lvar_TotalProhibicion 	= 0>
        <cfset Lvar_TotalCarreraProf 	= 0>
        <cfset Lvar_TotalIngresos 		= 0>
        <cfset Lvar_TotalDias 			= 0>
		<cfset Lvar_TotalPlusVacaciones   	 	= 0>
        <cfset Lvar_TotalPermDietOtro   	 	= 0>
        <cfset Lvar_TotalDevengado	 	= 0>
        <cfset Lvar_TotalSubsidioIncapac 	= 0>
        <cfset Lvar_MontoTotalIngreso 	  	 	= 0>
		<cfset Lvar_TotalCargaCCSS 	  	 	= 0>	
        <cfset Lvar_TotalASAR	 	= 0>
		<cfset Lvar_TotalRenta 	 	 	= 0>
        <cfset Lvar_TotalRentaDieta 	 	 	= 0>
        <cfset Lvar_TotalBancPopular 	= 0>
        <cfset Lvar_TotalINS 	 	= 0>
        <cfset Lvar_TotalBnVital	 	= 0>
        <cfset Lvar_TotalAFAR 	  	 	= 0>
        <cfset Lvar_TotalASIAR	  	 	= 0>
        <cfset Lvar_TotalAsarOtros     		= 0>
        <cfset Lvar_TotalAsarEspec 		= 0>
        <cfset Lvar_TotalAsarExtra 		 	= 0>
        <cfset Lvar_TotalAsarNav 	  	= 0>
        <cfset Lvar_TotalAsarClub 	= 0>
        <cfset Lvar_TotalColegios  	= 0>
        <cfset Lvar_TotalAsarConting	 	= 0>
        <cfset Lvar_TotalCoopeServ	  	= 0>	
        <cfset Lvar_TotalRoblealto= 0>
        <cfset Lvar_TotalFondoSolid		= 0>
        <cfset Lvar_TotalEmbargo		= 0>
        <cfset Lvar_TotalCoopenae	= 0>
		<cfset Lvar_TotalCoopeSNE 	 	 	= 0>
		<cfset Lvar_TotalComiteSocial 	= 0>
		<cfset Lvar_TotalDeducciones 	= 0>
		<cfset Lvar_TotalLiquido 	= 0>
	</cfsilent>

	<cf_htmlReportsHeaders
		irA="NominaContabilidad.cfm"
		FileName="Reporte_Nomina_y_Contabilidad.xls"
		title="Reporte de Nomina y Contabilidad"/>
				
    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
		<cfoutput>
	        <tr>
				<td colspan="38">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>						
							<cfif isdefined('form.Agrupar')>
								<cfset titulo = '#LB_PLANILLADEPAGOSPORDEPARTAMENTO#'>
							<cfelse>
								<cfset titulo = '#LB_PLANILLADEPAGOS#'>
							</cfif>
	                        <cfswitch expression="#arrayOfi[1]#"> 
					            <cfcase value="of">
					               <cfset Oficina = 'Oficina #rsOficina.Oficodigo#-#rsOficina.Odescripcion#'>
					            </cfcase>
					            <cfcase value="go">
						            <cfquery name = "rsgo" datasource="#session.dsn#">
						    	        select GOcodigo, GOnombre
							            from AnexoGOficina ct 
							            where ct.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
							                and ct.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayOfi[2]#">
						            </cfquery>
					               	<cfset Oficina = 'Grupo de Oficinas:#rsgo.GOnombre#'>
					            </cfcase>
					            <cfdefaultcase>
					            	<cfset Oficina = 'Todas las Oficinas'>
					            </cfdefaultcase>
					        </cfswitch>

							<cf_locale name="date" value="#rsNomina.RCdesde#" returnvariable="LvarRCdesde"/>
	                		<cf_locale name="date" value="#rsNomina.RChasta#" returnvariable="LvarRChasta"/>
							<cf_EncReporte
								Titulo="#titulo#"
								Color="##E3EDEF"
								filtro1="#LB_FechaRige#: #LvarRCdesde# &nbsp; #LB_FechaVence#: #LvarRChasta#"	
								filtro2="#Oficina#"
							>
						</td></tr>
					</table>
				</td>
			</tr>
        </cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="38"></td></tr>
		<cfif not isdefined('form.Agrupar')>
			<tr class="listaCorte3" valign="bottom">
				<td nowrap>&nbsp;<cf_translate key="LB_Nombre"><p>Nombre</p></cf_translate></td>
				<td nowrap align = "center">&nbsp;<cf_translate key="LB_SalarioBase"><p>Salario <br> Base</p></cf_translate></td>
				<td nowrap align = "center"><p>Anualidad</p><cf_translate key="LB_Anualidad"></cf_translate></td>
				<td nowrap align = "center"><p>Prohibición</p><cf_translate key="LB_Prohibicion"></cf_translate></td>
				<td nowrap align = "center"><p>Carrera <br> Profesional</p><cf_translate key="LB_CarreraProf"></cf_translate></td>
				<td nowrap align = "center">&nbsp;<p>Total <br> Salario</p><cf_translate key="LB_TotalSalario"></cf_translate></td>
				<td nowrap align = "center">&nbsp;<cf_translate key="LB_Dias"><p>dias</p></cf_translate></td>
				<td nowrap align = "center">&nbsp;<cf_translate key="LB_Vacaciones"><p>Plus de <br> Vacaciones</p></cf_translate></td>
				<td nowrap align = "center">&nbsp;<cf_translate key="LB_PermisosDietasOtros"><p>Permisos, Dietas <br> y <br> Otros</p></cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDevengado"><p>Total <br> Devengado</p></cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_SubsidioIncapacidad"><p>Subsidio<br>Incapacidad</p></cf_translate></td>
				<td nowrap align="center"><cf_translate key="LB_SalarioSubsidioPermisosDietasOtros"><p>Salario<br>+<br>Subsidio<br>+<br>Permiso/Dietas/Otros</p></cf_translate></td>
				<td nowrap align="center"><p>C.C.S.S.<br></p><cf_translate key="LB_CCSS"></cf_translate></td>
				<td nowrap align="center"><p>ASAR</p><cf_translate key="LB_Asar"></cf_translate></td>
				<td nowrap align="center"><p>Renta</p><cf_translate key="LB_Renta"></cf_translate></td>
				<td nowrap align="center"><p>Renta<br>DIETA</p><cf_translate key="LB_RentaDieta"></cf_translate></td>
				<td nowrap align = "center"><p>B.P.<br>AH. PA.</p><cf_translate key="LB_BPAHPA"></cf_translate></td>
				<td nowrap align="center"><p>I.N.S.<br>(V.A.I.H)</p><cf_translate key="LB_INS"></cf_translate></td>
				<td nowrap align="center"><p>BNVITAL<br>O.P.C.</p><cf_translate key="LB_BNvital"></cf_translate></td>
				<td nowrap align="center"><p>AFAR</p><cf_translate key="LB_AFAR"></cf_translate></td>
				<td nowrap align="center"><p>ASIAR</p><cf_translate key="LB_Asiar"></cf_translate></td>
				<td nowrap align="center"><p>Otros<br>ASAR</p><cf_translate key="LB_OtrosAsar"></cf_translate></td>
				<td nowrap align="center"><p>AH.ESP.<br>ASAR</p><cf_translate key="LB_AsarEspec"></cf_translate></td>
				<td nowrap align="center"><p>AH.EXT.<br>ASAR</p><cf_translate key="LB_AsarExtra"></cf_translate></td>
				<td nowrap align="center"><p>AH.NAV.<br>ASAR</p><cf_translate key="LB_AsarNav"></cf_translate></td>
				<td nowrap align="center"><p>CLUB<br>ASAR</p><cf_translate key="LB_AsarClub"></cf_translate></td>
				<td nowrap align="center"><p>FON.CONT.<br>ASAR</p><cf_translate key="LB_AsarFondo"></cf_translate></td>
				<td nowrap align="center"><p>Coope<BR>SERV.</p><cf_translate key="LB_Coopeserv"></cf_translate></td>
				<td nowrap align="center"><p>COLEGIOS<br>(CO-AB-IN-LI)</p><cf_translate key="LB_Colegios"></cf_translate></td>
				<td nowrap align="center"><p>ROBLEALTO</p><cf_translate key="LB_Roblealto"></cf_translate></td>
				<td nowrap align="center"><p>Fondo<br>Solidario</p><cf_translate key="LB_FondoSolidario"></cf_translate></td>
				<td nowrap align="center"><cf_translate key="LB_Embargos"><p>Embargos</p></cf_translate></td> 
				<td nowrap align="center"><cf_translate key="LB_Coopenae"><p>Coope<br>NAE</p></cf_translate></td>
				<td nowrap align="center"><cf_translate key="LB_Coopesne"><p>Coope<br>SNE</p></cf_translate></td>
				<td nowrap align="center"><cf_translate key="LB_ComiteSocial"><p>Comite<br>Social</p></cf_translate></td>
				<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDeducciones"><p>Total<br>Deducciones</p></cf_translate></td>
				<td nowrap>&nbsp;<cf_translate key="LB_Liquido"><p>Líquido</p></cf_translate></td>
			</tr>
			<tr><td height="1" bgcolor="000000" colspan="38"></td></tr>
		</cfif>
        <cfoutput query="rsReporte" group="CFid">
			<cfif isdefined('form.Agrupar')>
            	<b>
					<tr>
	                    <td class="detalle" nowrap>&nbsp;</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalOrd,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAnualidad,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalProhibicion,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalCarreraProf,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDias,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalPlusVacaciones,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalPermDietOtro,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDevengado,'none')#</td>
						<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalSubsidioIncapac,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_MontoTotalIngreso,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalCargaCCSS,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalASAR,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalRenta,'none')#</td>                   
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalRentaDieta,'none')#</td>                   
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBancPopular,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalINS,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalBnVital,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAFAR,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalASIAR,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarOtros,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarEspec,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarExtra,'none')#</td>
	                   	<td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarNav,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarClub,'none')#</td>    
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalAsarConting,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalCoopeServ,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalColegios,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalRoblealto,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalFondoSolid,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalEmbargo,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalCoopenae,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalCoopeSNE,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalComiteSocial,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalDeducciones,'none')#</td>
	                    <td class="detaller" nowrap>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</td>
	                </tr>
                </b>
				<cfsilent>
						<cfset Lvar_TotalOrd 			= 0>
                     	<cfset Lvar_TotalAnualidad 		= 0>
                    	<cfset Lvar_TotalProhibicion	= 0>
                        <cfset Lvar_TotalCarreraProf	= 0>
                        <cfset Lvar_TotalIngresos 		= 0>
                        <cfset Lvar_TotalDias	 		= 0>
						<cfset Lvar_TotalPlusVacaciones = 0>
						<cfset Lvar_TotalPermDietOtro   = 0>
                        <cfset Lvar_TotalSubsidioIncapac= 0>
						<cfset Lvar_TotalASIAR 	  		= 0>
						<cfset Lvar_TotalINS 			= 0>
						<cfset Lvar_MontoTotalIngreso 	= 0>
						<cfset Lvar_TotalAsarNav 	  	= 0>
						<cfset Lvar_TotalAsarConting	= 0>
                        <cfset Lvar_TotalCoopeServ		= 0>
						<cfset Lvar_TotalDevengado 		= 0>
						<cfset Lvar_TotalCargaCCSS 	  	= 0>
						<cfset Lvar_TotalAFAR 	  		= 0>
						<cfset Lvar_TotalRenta 	 		= 0>
                        <cfset Lvar_TotalRentaDieta 	= 0>
                        <cfset Lvar_TotalASAR 			= 0>
						<cfset Lvar_TotalAsarOtros     	= 0>
                        <cfset Lvar_TotalAsarEspec 		= 0>
						<cfset Lvar_TotalBancPopular 	= 0>
                        <cfset Lvar_TotalBnVital 		= 0>
                        <cfset Lvar_TotalColegios 		= 0>
						<cfset Lvar_TotalAsarExtra 		= 0>
                        <cfset Lvar_TotalRoblealto		= 0>
                        <cfset Lvar_TotalFondoSolid		= 0>
                        <cfset Lvar_TotalEmbargo		= 0>
                        <cfset Lvar_TotalCoopenae		= 0>
                        <cfset Lvar_TotalCoopeSNE		= 0>
                        <cfset Lvar_TotalDeducciones	= 0>
						<cfset Lvar_TotalLiquido 		= 0>
				</cfsilent>
				<tr class="listaCorte1"><td colspan="70">#CFcodigo#&nbsp;-&nbsp;#CFdescripcion#</td></tr>
		            <tr><td height="1" bgcolor="000000" colspan="38"></td></tr>
					<tr class="listaCorte3" valign="bottom">
						<td nowrap>&nbsp;<cf_translate key="LB_Nombre"><p>Nombre</p></cf_translate></td>
						<td nowrap align = "center">&nbsp;<cf_translate key="LB_SalarioBase"><p>Salario <br> Base</p></cf_translate></td>
						<td nowrap align = "center"><p>Anualidad</p><cf_translate key="LB_Anualidad"></cf_translate></td>
						<td nowrap align = "center"><p>Prohibición</p><cf_translate key="LB_Prohibicion"></cf_translate></td>
						<td nowrap align = "center"><p>Carrera <br> Profesional</p><cf_translate key="LB_CarreraProf"></cf_translate></td>
						<td nowrap align = "center">&nbsp;<p>Total <br> Salario</p><cf_translate key="LB_TotalSalario"></cf_translate></td>
						<td nowrap align = "center">&nbsp;<cf_translate key="LB_Dias"><p>dias</p></cf_translate></td>
						<td nowrap align = "center">&nbsp;<cf_translate key="LB_Vacaciones"><p>Plus de <br> Vacaciones</p></cf_translate></td>
						<td nowrap align = "center">&nbsp;<cf_translate key="LB_PermisosDietasOtros"><p>Permisos, Dietas <br> y <br> Otros</p></cf_translate></td>
						<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDevengado"><p>Total <br> Devengado</p></cf_translate></td>
						<td nowrap align="center">&nbsp;<cf_translate key="LB_SubsidioIncapacidad"><p>Subsidio<br>Incapacidad</p></cf_translate></td>
						<td nowrap align="center"><cf_translate key="LB_SalarioSubsidioPermisosDietasOtros"><p>Salario<br>+<br>Subsidio<br>+<br>Permiso/Dietas/Otros</p></cf_translate></td>
						<td nowrap align="center"><p>C.C.S.S.<br></p><cf_translate key="LB_CCSS"></cf_translate></td>
						<td nowrap align="center"><p>ASAR</p><cf_translate key="LB_Asar"></cf_translate></td>
						<td nowrap align="center"><p>Renta</p><cf_translate key="LB_Renta"></cf_translate></td>
						<td nowrap align="center"><p>Renta<br>DIETA</p><cf_translate key="LB_RentaDieta"></cf_translate></td>
						<td nowrap align = "center"><p>B.P.<br>AH. PA.</p><cf_translate key="LB_BPAHPA"></cf_translate></td>
						<td nowrap align="center"><p>I.N.S.<br>(V.A.I.H)</p><cf_translate key="LB_INS"></cf_translate></td>
						<td nowrap align="center"><p>BNVITAL<br>O.P.C.</p><cf_translate key="LB_BNvital"></cf_translate></td>
						<td nowrap align="center"><p>AFAR</p><cf_translate key="LB_AFAR"></cf_translate></td>
						<td nowrap align="center"><p>ASIAR</p><cf_translate key="LB_Asiar"></cf_translate></td>
						<td nowrap align="center"><p>Otros<br>ASAR</p><cf_translate key="LB_OtrosAsar"></cf_translate></td>
						<td nowrap align="center"><p>AH.ESP.<br>ASAR</p><cf_translate key="LB_AsarEspec"></cf_translate></td>
						<td nowrap align="center"><p>AH.EXT.<br>ASAR</p><cf_translate key="LB_AsarExtra"></cf_translate></td>
						<td nowrap align="center"><p>AH.NAV.<br>ASAR</p><cf_translate key="LB_AsarNav"></cf_translate></td>
						<td nowrap align="center"><p>CLUB<br>ASAR</p><cf_translate key="LB_AsarClub"></cf_translate></td>
						<td nowrap align="center"><p>FON.CONT.<br>ASAR</p><cf_translate key="LB_AsarFondo"></cf_translate></td>
						<td nowrap align="center"><p>Coope<BR>SERV.</p><cf_translate key="LB_Coopeserv"></cf_translate></td>
						<td nowrap align="center"><p>COLEGIOS<br>(CO-AB-IN-LI)</p><cf_translate key="LB_Colegios"></cf_translate></td>
						<td nowrap align="center"><p>ROBLEALTO</p><cf_translate key="LB_Roblealto"></cf_translate></td>
						<td nowrap align="center"><p>Fondo<br>Solidario</p><cf_translate key="LB_FondoSolidario"></cf_translate></td>
						<td nowrap align="center"><cf_translate key="LB_Embargos"><p>Embargos</p></cf_translate></td> 
						<td nowrap align="center"><cf_translate key="LB_Coopenae"><p>Coope<br>NAE</p></cf_translate></td>
						<td nowrap align="center"><cf_translate key="LB_Coopesne"><p>Coope<br>SNE</p></cf_translate></td>
						<td nowrap align="center"><cf_translate key="LB_ComiteSocial"><p>Comite<br>Social</p></cf_translate></td>
						<td nowrap align="center">&nbsp;<cf_translate key="LB_TotalDeducciones"><p>Total<br>Deducciones</p></cf_translate></td>
						<td nowrap>&nbsp;<cf_translate key="LB_Liquido"><p>Líquido</p></cf_translate></td>
					</tr>
	            <tr><td height="1" bgcolor="000000" colspan="38"></td></tr>
			</cfif>
            <cfoutput>
				<tr>
                   	<td class="detalle" nowrap>#Nombre#</td>
                  	<td class="detaller" nowrap>#LSCurrencyFormat(LTsalario,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Anualidad,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Prohibicion,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(CarreraProf,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalIngresos,'none')#</td>
                 	<td class="detaller" nowrap>#LSCurrencyFormat(Dias,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(PlusVacaciones,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(PermDietOtro,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Devengado,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(SubsidioIncapac,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(MontoTotalIngreso,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(CargaCCSS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ASAR,'none')#</td>
          			<td class="detaller" nowrap>#LSCurrencyFormat(Renta,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(RentaDieta,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(BancPopular,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(INS,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(BnVital,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AFAR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(ASIAR,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarOtros,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarEspec,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarExtra,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarNav,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarClub,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(AsarConting,'none')#</td>
                   	<td class="detaller" nowrap>#LSCurrencyFormat(CoopeServ,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Colegios,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Roblealto,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(FondoSolid,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Embargo,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(Coopenae,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(CoopeSNE,'none')#</td>
					<td class="detaller" nowrap>#LSCurrencyFormat(ComiteSocial,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(TotalDeducciones,'none')#</td>
                    <td class="detaller" nowrap>#LSCurrencyFormat(Liquido,'none')#</td>
                </tr>
             
				<cfsilent>
					<cfset 	Lvar_TotalOrd 			= 	Lvar_TotalOrd+LTsalario>
					<cfset 	Lvar_TotalAnualidad 	=	Lvar_TotalAnualidad + Anualidad>
            		<cfset 	Lvar_TotalProhibicion 	= 	Lvar_TotalProhibicion + Prohibicion>
                    <cfset 	Lvar_TotalCarreraProf 	= 	Lvar_TotalCarreraProf + CarreraProf>
					<cfset Lvar_TotalPlusVacaciones = 	Lvar_TotalPlusVacaciones + PlusVacaciones>
					<cfset Lvar_TotalPermDietOtro 	= 	Lvar_TotalPermDietOtro + PermDietOtro>
					<cfset Lvar_TotalASIAR 			= 	Lvar_TotalASIAR + ASIAR>
					<cfset Lvar_TotalINS 			= 	Lvar_TotalINS + INS>
					<cfset Lvar_TotalAsarNav 		= 	Lvar_TotalAsarNav + AsarNav>
					<cfset Lvar_TotalAsarConting 	= 	Lvar_TotalAsarConting + AsarConting>
                    <cfset Lvar_TotalCoopeServ 		= 	Lvar_TotalCoopeServ + CoopeServ>
					<cfset Lvar_TotalIngresos 		= 	Lvar_TotalIngresos + TotalIngresos>
                    <cfset Lvar_TotalDias 			= 	Lvar_TotalDias + Dias>
                    <cfset Lvar_TotalDevengado		= 	Lvar_TotalDevengado + Devengado>
                    <cfset Lvar_TotalSubsidioIncapac= 	Lvar_TotalSubsidioIncapac + SubsidioIncapac>
                    <cfset Lvar_MontoTotalIngreso 	= 	Lvar_MontoTotalIngreso + MontoTotalIngreso>
                    <cfset Lvar_TotalAsarExtra 		= 	Lvar_TotalAsarExtra + AsarExtra>
					<cfset Lvar_TotalCargaCCSS 		= 	Lvar_TotalCargaCCSS + CargaCCSS>
					<cfset Lvar_TotalAFAR 			= 	Lvar_TotalAFAR + AFAR>
					<cfset Lvar_TotalRenta 			= 	Lvar_TotalRenta + Renta>
                    <cfset Lvar_TotalRentaDieta 	= 	Lvar_TotalRentaDieta + RentaDieta>
                    <cfset Lvar_TotalASAR 			= 	Lvar_TotalASAR + ASAR>
					<cfset Lvar_TotalAsarOtros 		= 	Lvar_TotalAsarOtros + AsarOtros>
					<cfset Lvar_TotalBancPopular 	= 	Lvar_TotalBancPopular + BancPopular>
                    <cfset Lvar_TotalAsarEspec		= 	Lvar_TotalAsarEspec + AsarEspec>
                    <cfset Lvar_TotalBnVital 		= 	Lvar_TotalBnVital + BnVital>
					<cfset Lvar_TotalColegios 		= 	Lvar_TotalColegios + Colegios>
					<cfset Lvar_TotalAsarClub 		= 	Lvar_TotalAsarClub + AsarClub>
                    <cfset Lvar_TotalRoblealto 		= 	Lvar_TotalRoblealto + Roblealto>
                    <cfset Lvar_TotalFondoSolid 	= 	Lvar_TotalFondoSolid + FondoSolid>
                    <cfset Lvar_TotalEmbargo		= 	Lvar_TotalEmbargo + Embargo>
                    <cfset Lvar_TotalCoopeSNE		= 	Lvar_TotalCoopeSNE + CoopeSNE>
                    <cfset Lvar_TotalCoopenae		= 	Lvar_TotalCoopenae + Coopenae>
                    <cfset Lvar_TotalComiteSocial	= 	Lvar_TotalComiteSocial + ComiteSocial>				
                    <cfset Lvar_TotalDeducciones	= 	Lvar_TotalDeducciones + TotalDeducciones>				
					<cfset Lvar_TotalLiquido 		= Lvar_TotalLiquido + Liquido>
				</cfsilent>
			</cfoutput>
			<cfif isdefined('form.Agrupar')>
            <tr><td height="1" bgcolor="000000" colspan="38"></td>
			</cfif>
		</cfoutput><!--- CORTE POR CENTRO FUNCIONAL --->
        <tr><td height="0" bgcolor="000000" colspan="38"></td></tr>
		<cfoutput>
			<tr>
				<td class="detalle" nowrap><h3>Total General</h3></td>
				<td class="detalle" nowrap><h3><span class="detaller">#LSCurrencyFormat(Lvar_TotalOrd,'none')#</span></h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAnualidad,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalProhibicion,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalCarreraProf,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalIngresos,'none')#</h3></td>
               
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalDias,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalPlusVacaciones,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalPermDietOtro,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalDevengado,'none')#</h3></td>	
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalSubsidioIncapac,'none')#</h3></td>			
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_MontoTotalIngreso,'none')#</h3></td>
               	<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalCargaCCSS,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalASAR,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalRenta,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalRentaDieta,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalBancPopular,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalINS,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalBnVital,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAFAR,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalASIAR,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarOtros,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarEspec,'none')#</h3></td>
				<td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarExtra,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarNav,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarClub,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalAsarConting,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalCoopeServ,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalColegios,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalRoblealto,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalFondoSolid,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalEmbargo,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalCoopenae,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalCoopeSNE,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalComiteSocial,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalDeducciones,'none')#</h3></td>
                <td class="detaller" nowrap><h3>#LSCurrencyFormat(Lvar_TotalLiquido,'none')#</h3></td>
			</tr>
		</cfoutput>
        <tr><td height="0" bgcolor="000000" colspan="38"></td></tr>
    </table>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>

</cfif>