<cfquery name="rsVerificaReporte" datasource="#session.DSN#">
	select 1
    from RHReportesNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      and RHRPTNcodigo = 'MT'
</cfquery>
<cfif isdefined('rsVerificaReporte') and rsVerificaReporte.RecordCount>
<cffunction name="convertListItemsToString" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset arrstr[i] = "'" & arr[i] & "'">
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="processNomina" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_LibroDeSalarios" Default="Libro de Salarios" returnvariable="LB_LibroDeSalarios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PeriodoInicio" Default="Periodo Inicio" returnvariable="LB_PeriodoInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PeriodoFin" Default="Periodo Fin" returnvariable="LB_PeriodoFin" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- CREACION DEL RANGO DE FECHAS --->
<cfset Lvar_FechaInicio = CreateDate(#url.anno#,1,1)>
<cfset Lvar_FechaFin = CreateDate(#url.anno#,12,31)>
	<!--- TABLA TEMPORAL PARA LOS EMPLEADOS --->
    <cf_dbtemp name="salidaEmp" returnvariable="empleados">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="LTid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempkey cols="DEid">
    </cf_dbtemp>
		
 	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="MinTrabRep" returnvariable="salidas">
        <cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="Nombre"   		type="varchar(100)" mandatory="yes">
		<cf_dbtempcol name="SegundoNombre"   		type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="Apellido1"   	type="varchar(100)" mandatory="yes">
		<cf_dbtempcol name="Apellido2"   	type="varchar(100)" mandatory="no">		
		<cf_dbtempcol name="NTIcodigo"   	type="char(1)"      mandatory="no">			
		<cf_dbtempcol name="IGSS"           type="varchar(30)"  mandatory="no"> 
		<cf_dbtempcol name="NIT"            type="varchar(30)"  mandatory="no">  
		<cf_dbtempcol name="EstadoCivil"	type="int" 			mandatory="yes">  	
        <cf_dbtempcol name="ID"   			type="varchar(60)"  mandatory="yes">
        <cf_dbtempcol name="Edad"   		type="int"      	mandatory="yes">
        <cf_dbtempcol name="Sexo"   		type="char(1)"      mandatory="yes">
        <cf_dbtempcol name="Etnia"   		type="char(1)"     	mandatory="yes">
		<cf_dbtempcol name="Ppais"   		type="char(2)"     	mandatory="no">		
        <cf_dbtempcol name="Region"   		type="varchar(100)" mandatory="yes">
        <cf_dbtempcol name="Depto"   		type="varchar(100)" mandatory="yes">
        <cf_dbtempcol name="Municipio" 		type="varchar(100)" mandatory="yes">
        <cf_dbtempcol name="FechaIngreso"	type="datetime" 	mandatory="no">
        <cf_dbtempcol name="FechaRetiro"	type="datetime" 	mandatory="no">
		<cf_dbtempcol name="FechaNacimiento" type="datetime"    mandatory="no">
        <cf_dbtempcol name="Ocupacion" 		type="char(100)" 	mandatory="no">
        <cf_dbtempcol name="Dias"			type="int" 			mandatory="no">
		<cf_dbtempcol name="Horas" 			type="int" 			mandatory="no">
		<cf_dbtempcol name="Ordinario" 		type="money"  		mandatory="no">
		<cf_dbtempcol name="HorasExtra"		type="float" 		mandatory="no">
		<cf_dbtempcol name="SalarioExtra"	type="money"    	mandatory="no">
		<cf_dbtempcol name="Aguinaldo" 		type="money"   		mandatory="no">
		<cf_dbtempcol name="Bono" 		    type="money"   		mandatory="no">
		<cf_dbtempcol name="OtrosPagos"		type="money"    	mandatory="no">
		<cf_dbtempcol name="Comisiones"		type="money"    	mandatory="no">
		<cf_dbtempcol name="CantidadHijos"  type="int" 			mandatory="no">
		<cf_dbtempcol name="DocumentoIdentificacion"   	type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="TipoIdentificacion"   	    type="varchar(255)" mandatory="no">
		<cf_dbtempcol name="Jornada"   	                type="varchar(60)" mandatory="no">
		<cf_dbtempcol name="HorasJornada"   	        type="money" mandatory="no">
		<cf_dbtempcol name="NivelAcademico"   	        type="varchar(100)" mandatory="no">
		<cf_dbtempcol name="Indemnizacion"	            type="money"    	mandatory="no">
		<cf_dbtempcol name="PpaisNombre"                type="varchar(30)"  mandatory="no">  
		<cf_dbtempcol name="DEcivil"	                type="int" 			mandatory="no"> 
		<cf_dbtempcol name="RHJid"	                	type="numeric" 			mandatory="no"> 
		
		
	</cf_dbtemp> 
    <!--- INGRESA LOS DATOS DE LOS CALENDARIOS DE PAGO DEL EMPLEADO --->
    <cfset fecha = Now()>
    <cfset fecha1_temp = createdate( 6100, 01, 01 )>
    <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
    	insert into #empleados# (DEid,LTid)
    	select lt.DEid, max(lt.LTid)
        from LineaTiempo lt
        where lt.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
			   or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
			   or (LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
			   		and LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
			   or (LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
			   		and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
			   )
		<cfif isdefined('url.TcodigoList')>
		and lt.Tcodigo in (#processNomina(url.TcodigoList)#)
		</cfif>
        group by lt.DEid
    </cfquery>
		
		
    <cfquery name="rsSalida" datasource="#session.DSN#">
    	insert into #salidas#(DEid,ID, Nombre,Apellido1,Apellido2, NTIcodigo,IGSS,NIT,EstadoCivil,Edad, Sexo, Etnia,Region, Depto, Municipio, FechaIngreso, FechaNacimiento, DocumentoIdentificacion, TipoIdentificacion, Ppais, NivelAcademico,RHJid)
    	select 	e.DEid,				
	        	DEidentificacion, 
				DEnombre,
				DEapellido1,
				DEapellido2, 				     
				NTIcodigo,    
				trim(replace(DEdato1,'-','')),   
				trim(replace(DEdato3,'-','')), 
				case DEcivil 
					when 0 then 0
					when 1 then 1
					when 2 then 3
					when 3 then 2
					when 4 then 1
					when 5 then 3 end,
                <cf_dbfunction name="datediff" args="DEfechanac,#fecha#,yy"> as Edad,
                DEsexo,
                coalesce(<cf_dbfunction name="sPart" args="DEdato4,1,1"> ,'0') as Etnia,			
                coalesce(DEinfo1,'-') as Region,
                coalesce(DEinfo2,'-') as Depto,
                coalesce(DEinfo3,'-') as Muni,
        		DLfvigencia,
				DEfechanac,
				trim(replace(DEobs2,'-','')),   
				DEobs1,
				Ppais,
				DEinfo4,
				(select RHJid from LineaTiempo lt where lt.LTid = e.LTid)
        from #empleados# e
        left outer join DLaboralesEmpleado le
        	on e.DEid = le.DEid
            and le.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
			
        inner join RHTipoAccion ta
			on ta.RHTid = le.RHTid			
            and ta.RHTcomportam = 1
			
        inner join DatosEmpleado de
        	on de.DEid = e.DEid
			
         order by DEid, DLfvigencia
    </cfquery>
	

	
	<!--- PAIS --->
	<cfquery name="rsMPais" datasource="#session.DSN#">
	 update #salidas#
	   SET PpaisNombre= (select Pnombre
						 from Pais
						 where Ppais =  #salidas#.Ppais)
	 </cfquery>

	<!--- FECHA DE RETIRO --->
	<cfquery name="rsDias" datasource="#session.DSN#">
    	update #salidas#
        set FechaRetiro = (select min(DLfvigencia)
        					 from #empleados# e, DLaboralesEmpleado le, RHTipoAccion ta
                            where e.DEid = #salidas#.DEid
                              and e.DEid = le.DEid
                              and le.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                              and le.DLfvigencia > #salidas#.FechaIngreso
                              and ta.RHTid = le.RHTid
                              and ta.RHTcomportam = 2)
    </cfquery>

    <!--- OCUPACION O CARGO --->
    <cfquery name="rsOcupacion" datasource="#session.DSN#">
    	update #salidas#
        set Ocupacion = coalesce((select pe.RHPEcodigo
                                from LineaTiempo a
                                inner join RHPuestos b
                                    on b.Ecodigo = a.Ecodigo
                                    and b.RHPcodigo = a.RHPcodigo
                                inner join RHPuestosExternos pe
                                    on b.Ecodigo = pe.Ecodigo
                                    and b.RHPEid = pe.RHPEid
                                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                  and LTid = (select max(LTid)
                                            from LineaTiempo
                                            where DEid = #salidas#.DEid
                                               and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                                            and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                                                or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                                            and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">))),'No definido')
    </cfquery>
    <!--- ACTUALIZA LOS DIAS PAGADOS EN EL CALENDARIO DE PAGO --->
	<cfquery name="rsDias" datasource="#session.DSN#">
    	update #salidas#
        set Dias = coalesce((select sum(PEcantdias)
                            from HPagosEmpleado
                            where DEid = #salidas#.DEid
                              and (PEdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                              or PEhasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
                            group by DEid),0)
    </cfquery>
    <!--- MONTO DE DIAS DE INCIDENCIAS POR HORAS --->
    <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidas#
        set Horas = coalesce((select sum(ICvalor)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincHJornada 
                            where DEid = #salidas#.DEid	
                              and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                              				and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                           ),0)
    </cfquery>
    <!--- SALARIO ORDINARIO --->
	
	<!--- A ordinario se le suman los conceptos incidentes  --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
	update #salidas#
	set Ordinario = coalesce((
								select sum(a.ICmontores) 
								from HIncidenciasCalculo a
								where a.DEid = #salidas#.DEid
								and a.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
												and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
								and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'Salarios'
											where c.RHRPTNcodigo = 'MT'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
	
  </cfquery>
	  	  
	
	<!--- Salario Base  --->
    <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidas#
        set Ordinario = Ordinario + coalesce((select sum(SEsalariobruto)
                                            from HSalarioEmpleado hse
                                            inner join CalendarioPagos cp
                                                on hse.RCNid = cp.CPid
                                                and cp.CPdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                              									and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                                            where hse.DEid = #salidas#.DEid
        							),0.00)
   	</cfquery>
	
	<!--- Monto por Indemnizacion --->
	
	 <cfquery name="rsIndem" datasource="#session.DSN#">
	 	update #salidas#   
		set Indemnizacion = coalesce(( select  sum(LiqIng.importe)
					
					from DatosEmpleado Demp, 
						DLaboralesEmpleado DLabEmpl, 
						RHTipoAccion rhtipo,
						RHLiquidacionPersonal Liq,
						RHLiqIngresos LiqIng
					
					where Demp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and DLabEmpl.Ecodigo = Demp.Ecodigo
					and DLabEmpl.Ecodigo =rhtipo.Ecodigo
					
					
					and Demp.DEid = DLabEmpl.DEid
					
					and rhtipo.RHTid =  DLabEmpl.RHTid
					and rhtipo.RHTcomportam =2
					
					and Liq.DLlinea = DLabEmpl.DLlinea
					and Liq.DEid = DLabEmpl.DEid
					and Liq.Ecodigo = DLabEmpl.Ecodigo
					and Liq.RHLPestado =1
					
					and LiqIng.DLlinea = Liq.DLlinea
					and LiqIng.DEid=Liq.DEid 

					and LiqIng.CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'INDEMN'
											where c.RHRPTNcodigo = 'MT'
											  and c.Ecodigo = #session.Ecodigo#)), 0.00)
	
		
	</cfquery>
	
    <!--- SEPTIMO --->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" Ecodigo="#session.Ecodigo#" Pvalor="750" default="" returnvariable="ICSeptimo"/>
    <cfif Not Len(ICSeptimo)>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_No_se_ha_definido_el_Concepto_Incidente_de_Septimo"
			Default="Error!, No se ha definido el Concepto Incidente de Séptimo. Proceso Cancelado!!"
			returnvariable="LB_No_se_ha_definido_el_Concepto_Incidente_de_Septimo"/> 
		   
		   <cf_throw message="#LB_No_se_ha_definido_el_Concepto_Incidente_de_Septimo#" errorCode="1015">
	</cfif>
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidas#
        set Ordinario = Ordinario + coalesce((select sum(ICmontores)
                                            from HIncidenciasCalculo
                                            where DEid = #salidas#.DEid
                                              and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ICSeptimo#">
                                              and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                                			and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">),0.00)
    </cfquery>
    
    <!--- CANTIDAD DE HORAS EXTRA --->
     <!--- HORAS EXTRA A --->
    <cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salidas#
        set HorasExtra = coalesce((  select sum(ICvalor)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincExtraA 
                            where DEid = #salidas#.DEid
                              and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                           	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                            group by DEid),0.00)
    </cfquery>
    <!--- HORAS EXTRA B --->
    <cfquery name="rsHorasExtra" datasource="#session.DSN#">
    	update #salidas#
        set HorasExtra = HorasExtra + coalesce((  select sum(ICvalor)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincExtraB 
                            where DEid = #salidas#.DEid
                              and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                           	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                            group by DEid),0.00)
    </cfquery>
     <!--- CALCULO DE LAS HORAS EXTRA (TOTAL HORAS EXTRA A Y HORAS EXTRA B) --->
    <!--- HORAS EXTRA A --->
    <cfquery name="rsMontoExtraA" datasource="#session.DSN#">
    	update #salidas#
        set SalarioExtra = coalesce((  select sum(ICmontores)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincExtraA 
                            where DEid = #salidas#.DEid
                              and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                           	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                            group by DEid),0.00)
    </cfquery>
    <!--- HORAS EXTRA B --->
    <cfquery name="rsMontoExtraB" datasource="#session.DSN#">
    	update #salidas#
        set SalarioExtra = SalarioExtra + coalesce((  select sum(ICmontores)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincExtraB 
                            where DEid = #salidas#.DEid
                              and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                           	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                            group by DEid),0.00)
    </cfquery>
    <!--- AGUINALDO Y BONO 14 --->
    
     <!--- AGUINALDO --->
    <cfquery name="rsAguinaldo" datasource="#session.DSN#">
    	update #salidas#
			set Aguinaldo = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salidas#.DEid
					and a.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                  	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Aguinaldo'
								where c.RHRPTNcodigo = 'MT'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
    
	
	<!---Bono 14 --->	
	 <cfquery name="rsBono" datasource="#session.DSN#">
    	update #salidas#
			set Bono = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salidas#.DEid
					and a.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                  	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Bono'
								where c.RHRPTNcodigo = 'MT'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>
	
	
    <!--- OTROS PAGOS --->
     <cfquery name="rsOtrosPagos" datasource="#session.DSN#">
    	update #salidas#
			set OtrosPagos = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salidas#.DEid
					and a.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                  	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'OtrosPagos'
								where c.RHRPTNcodigo = 'MT'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>	
	
	
	
	    
	<!--- Comisiones ---->
	<cfquery name="rsOtrosPagos" datasource="#session.DSN#">
    	update #salidas#
			set Comisiones = coalesce((
					select sum(a.ICmontores) 
					from HIncidenciasCalculo a
					where a.DEid = #salidas#.DEid
					and a.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                                  	and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
					and CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'comisiones'
								where c.RHRPTNcodigo = 'MT'
								  and c.Ecodigo = #session.Ecodigo#)), 0.00)
    </cfquery>	
	
	

	
	<!--- CANTIDAD DE HIJOS --->
	<cfquery  datasource="#session.DSN#">
	update #salidas#
	set CantidadHijos = coalesce((select count(Fam.Pid)
									from Fempleado Fam
									, RHParentesco parent									
									where Fam.DEid = #salidas#.DEid
									and Fam.Pid= 2 
									and Fam.Pid = parent.Pid ),0)	
									
									
	</cfquery>
	
	<!--- JORNADA --->
   <cfquery name="rsJornada" datasource="#session.DSN#">
        update #salidas#
		set Jornada = (select distinct RHJdescripcion
						from RHJornadas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
						  and RHJid = #salidas#.RHJid)
	</cfquery>
	<!--- HORAS --->
   <cfquery name="rsJornada" datasource="#session.DSN#">
        update #salidas#
		set HorasJornada = (select distinct RHJhoradiaria
						from RHJornadas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
						  and RHJid = #salidas#.RHJid)
	</cfquery>
	
<!--- 	<!--- JORANDA Y HORA --->
   <cfquery name="rsJornadaHora" datasource="#session.DSN#">
        update #salidas#
				set Jornada =  (select  RHJorn.RHJdescripcion			  		
								from LineaTiempo  linea,
									RHJornadas RHJorn
																			
								where linea.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
								and linea.DEid = #salidas#.DEid
								and RHJorn.RHJid = linea.RHJid 
																
								and linea.LTid in ( select max(lt.LTid)
													from LineaTiempo lt 
													where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 								
													and lt.DEid = linea.DEid		
													and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
													and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
													or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
													and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
													or (LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
													and LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
													or (LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
													and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
													) group by lt.DEid)		)
			 
			 ,HorasJornada =	(select  RHJorn.RHJhoradiaria 			  		
								from LineaTiempo  linea,
									RHJornadas RHJorn
																			
								where linea.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
								and linea.DEid = #salidas#.DEid
								and RHJorn.RHJid = linea.RHJid 
																
								and linea.LTid in ( select max(lt.LTid)
													from LineaTiempo lt 
													where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 								
													and lt.DEid = linea.DEid		
													and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
													and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
													or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
													and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
													or (LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
													and LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
													or (LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
													and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
													) group by lt.DEid)		)												
													
													
  </cfquery> --->
	 		
    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select *
        from #salidas# a
		inner join DAtosEmpleado b
			on b.DEid = a.DEid
        order by DEidentificacion, FechaIngreso
    </cfquery>
	    
<!--- <cf_dump var="#rsReporte#"> --->
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
		font-size:18px;
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
		font-size:9px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		text-align:right;}

	.detalle {
		font-size:9px;
		text-align:left;}
	.detaller {
		font-size:9px;
		text-align:right;}
	.detallec {
		font-size:9px;
		text-align:center;}	
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>
	
    <table border="1" align="center" cellpadding="2" cellspacing="0" style="border-color:000000; border-width:thin;">
   
        <tr class="listaCorte1">
		
           <!--- <td colspan="4" nowrap><cf_translate key="LB_MARQUECONX">MARQUE CON X</cf_translate></td>--->
		    <td><cf_translate key="LB_Region">N&uacute;meroEmpleado</cf_translate></td>
			<td><cf_translate key="LB_Region">C&oacute;digo de Empleado</cf_translate></td>
		    <td><cf_translate key="LB_Region">Tipo Documento Identificaci&oacute;n</cf_translate></td>
			<td><cf_translate key="LB_Region">Documento Identificaci&oacute;n</cf_translate></td>
			<td><cf_translate key="LB_Region">Letra de Identificaci&oacute;n</cf_translate></td>
			<td><cf_translate key="LB_Region">PaisOrigen</cf_translate></td>
			<td><cf_translate key="LB_Region">Region Nacimiento</cf_translate></td>
			<td><cf_translate key="LB_Region">Departamento Nacimiento</cf_translate></td>
			<td><cf_translate key="LB_Region">Municipio Nacimiento</cf_translate></td>
			<td><cf_translate key="LB_Region">NitEmpleado</cf_translate></td>
		    <td><cf_translate key="LB_Region">IGSS Empleado </cf_translate></td>
			<td><cf_translate key="LB_Region">Nombre </cf_translate></td>
			<td><cf_translate key="LB_Region">Segundo Nombre </cf_translate></td>
			<td><cf_translate key="LB_Region">Apellido1</cf_translate></td>
			<td><cf_translate key="LB_Region">Apellido2</cf_translate></td>
			<td><cf_translate key="LB_Region">EstadoCivil </cf_translate></td>
		    <td><cf_translate key="LB_Region">N&uacute;meroHijos</cf_translate></td>
		    <td><cf_translate key="LB_Region">Fecha Nacimiento</cf_translate></td>
			 <td><cf_translate key="LB_Region">Edad</cf_translate></td>
			<td><cf_translate key="LB_Region">Sexo</cf_translate></td>
			<td><cf_translate key="LB_Region">Fecha Inicio Labores</cf_translate></td>
			<td><cf_translate key="LB_Region">Fecha Reinicio labores</cf_translate></td>
		    <td><cf_translate key="LB_Region">Fecha Retiro Labores</cf_translate></td>
		   	<td><cf_translate key="LB_Region">Puesto (Utilizar: Manual de Ocupaci&oacute;n -C-)</cf_translate></td>
		    <td><cf_translate key="LB_Region">Dias Trabajados Año</cf_translate></td>
		    <td><cf_translate key="LB_Region">Jornada</cf_translate></td>
		    <td><cf_translate key="LB_Region">Horas Ordinarias Trabajadas D&iacute;a</cf_translate></td>
			<td><cf_translate key="LB_Region">Salario Ordinario Anual</cf_translate></td>
			<td><cf_translate key="LB_Region">Total Horas Extras</cf_translate></td>
			<td><cf_translate key="LB_Region">Salario Extra Ordinario</cf_translate></td>
			<td><cf_translate key="LB_Region">Aguinaldo</cf_translate></td>
			<td><cf_translate key="LB_Region">Bono14</cf_translate></td>
			<td><cf_translate key="LB_Region">Comisiones</cf_translate></td>
			<td><cf_translate key="LB_Region">Otros Pagos</cf_translate></td>
			<td><cf_translate key="LB_Region">Nivel Academico</cf_translate></td>
			<td><cf_translate key="LB_Region">Profesi&oacute;n</cf_translate></td>
			<td><cf_translate key="LB_Region">Etnia</cf_translate></td>
			<td><cf_translate key="LB_Region">Idiomas</cf_translate></td>
			<td><cf_translate key="LB_Region">PermisoTrabajo</cf_translate></td>
			<td><cf_translate key="LB_Region">Tipo Contrato</cf_translate></td>
			<td><cf_translate key="LB_Region">Indemnizaci&oacute;n</cf_translate></td>
			         </tr>
        <cfsilent>
			<cfset Lvar_Dias = 0>
            <cfset Lvar_Horas = 0>
            <cfset Lvar_Ordinario = 0>
            <cfset Lvar_HorasExtra = 0>
            <cfset Lvar_SalarioExtra = 0>
            <cfset Lvar_Bono = 0>
			<cfset Lvar_Agui = 0>			
            <cfset Lvar_OtrosPagos = 0>
        </cfsilent>
        <cfoutput query="rsReporte" >
        	<cfif Find('.',Region)><cfset Lvar_PosR = Find('.',Region) - 1><cfset Lvar_Reg= Mid(Region,1,Lvar_PosR)><cfelse><cfset Lvar_Reg = ''></cfif>
            <cfif Find('.',Depto)><cfset Lvar_PosD = Find('.',Depto) - 1><cfset Lvar_Depto= Mid(Depto,1,Lvar_PosD)><cfelse><cfset Lvar_Depto = ''></cfif>
            <cfif Find('.',Municipio)><cfset Lvar_PosM = Find('.',Municipio) - 1><cfset Lvar_Municipio= Mid(Municipio,1,Lvar_PosM)><cfelse><cfset Lvar_Municipio =''></cfif>
			<cfset Nombre1 = trim(Nombre)>
			<cfif find (" ",Nombre1)>
				<cfset Pto = find (" ",Nombre1)>
				<cfset Nombre2 = mid(Nombre1, Pto+1, 100)>
				<cfset Nombre1 = mid(Nombre1, 1, Pto-1)>
			<cfelse>
				<cfset Nombre2 = "">
			</cfif>
       	<tr>				
			<td class="detallec">#CurrentRow#</td>
			<td class="detallec">#ID#</td>
			<td class="detallec"><cfif UCase(trim(TipoIdentificacion))EQ 'PASAPORTE'>4<cfelse>1</cfif></td>
		  	<td class="detallec"><cfif len(rtrim(#DocumentoIdentificacion#))> #DocumentoIdentificacion#  <cfelse> &nbsp;    </cfif> </td>
		  	<td class="detallec"><cfif len(rtrim(#TipoIdentificacion#))> #TipoIdentificacion#  <cfelse> &nbsp;    </cfif> </td>							
			<td class="detallec"><cfif len(trim(#Ppais#))> #PpaisNombre# <cfelse> &nbsp; </cfif></td>			
        	<td class="detaller"><cfif LEN(TRIM(Lvar_Reg))>#Lvar_Reg#<cfelse>&nbsp;</cfif></td>
            <td class="detaller"><cfif LEN(TRIM(Lvar_Depto))>#Lvar_Depto#<cfelse>&nbsp;</cfif></td>
            <td class="detaller"><cfif LEN(TRIM(Lvar_Municipio))>#Lvar_Municipio#<cfelse>&nbsp;</cfif></td>
			<td class="detalle" nowrap="nowrap"><cfif len(trim(#NIT#))> #NIT# <cfelse>&nbsp;</cfif>  </td>			           
			<td class="detalle" nowrap="nowrap"><cfif len(trim(#IGSS#))> #IGSS# <cfelse>&nbsp;</cfif>   </td>
			 <td class="detalle" nowrap="nowrap">#Nombre1#</td>
			 <td class="detalle" nowrap="nowrap"><cfif len(trim(#Nombre2#)) >#Nombre2# <cfelse> &nbsp; </cfif>   </td>
			<td class="detalle" nowrap="nowrap">#Apellido1#</td>
			<td class="detalle" nowrap="nowrap"><cfif len(trim(#Apellido2#)) > #Apellido2# <cfelse> &nbsp; </cfif></td>
			<td class="detaller">#EstadoCivil#</td>
			<td class="detaller">#CantidadHijos#</td>
			<td class="detaller">#LSDateFormat(FechaNacimiento,"DD/MM/YYYY")#</td>					
            <td class="detaller">#Edad#</td>
			<td class="detaller">#Sexo#</td>    		   		
			<td class="detaller">#LSDateFormat(FechaIngreso, "DD/MM/YYYY")#</td>
			<td class="detaller">&nbsp;</td> 
			<td class="detaller"><cfif len(trim(#LSDateFormat(FechaRetiro, "DD/MM/YYYY")#))>#LSDateFormat(FechaRetiro, "DD/MM/YYYY")# <cfelse> &nbsp;</cfif></td>  
            <td class="detaller"><cfif LEN(TRIM(Ocupacion))>#Ocupacion#<cfelse>&nbsp;</cfif></td>
            <td class="detaller">#Dias#</td>
			<td class="detaller"><cfif len(trim(#Jornada#)) > #Jornada# <cfelse> &nbsp;  </cfif></td>
            <td class="detaller"><cfif len(trim(#HorasJornada#)) > #LSNumberFormat(HorasJornada,'99.99')# <cfelse> &nbsp;  </cfif>  </td>	   	
            <td class="detaller">#LSNumberFormat(Ordinario,'99.99')#</td>
            <td class="detaller">#HorasExtra#</td>
            <td class="detaller">#LSNumberFormat(SalarioExtra,'99.99')#</td>
            <td class="detaller">#LSNumberFormat(Aguinaldo,'99.99')#</td>
			<td class="detaller">#LSNumberFormat(Bono,'99.99')#</td>
			<td class="detaller">#LSNumberFormat(Comisiones,'99.99')#</td>
            <td class="detaller">#LSNumberFormat(OtrosPagos,'99.99')#</td>
            <td class="detaller"><cfif len(trim(#NivelAcademico#))>  #NivelAcademico# <cfelse> &nbsp; </cfif>  </td>
			<td class="detaller"><cfif len(trim(#NivelAcademico#))>  #NivelAcademico# <cfelse> &nbsp; </cfif>  </td>
			<td class="detaller">#Etnia#</td>
			<td class="detaller">&nbsp;</td>
			<td class="detaller">&nbsp;</td>
			<td class="detaller">&nbsp;</td>
			<td class="detaller">#LSNumberFormat(Indemnizacion,'99.99')#</td>
        </tr>
     		<cfsilent>
            	<cfset Lvar_Dias = Lvar_Dias + Dias>
                <cfset Lvar_Horas = Lvar_Horas + Horas>
                <cfset Lvar_Ordinario = Lvar_Ordinario + Ordinario>
                <cfset Lvar_HorasExtra = Lvar_HorasExtra + HorasExtra>
                <cfset Lvar_SalarioExtra = Lvar_SalarioExtra + SalarioExtra>
                <cfset Lvar_Agui = Lvar_Agui + Aguinaldo>
				<cfset Lvar_Bono = Lvar_Bono + Bono>
                <cfset Lvar_OtrosPagos = Lvar_OtrosPagos + OtrosPagos>
            </cfsilent>
        </cfoutput>
        <cfoutput>
		
		
		 <tr class="total">
        	<td colspan="23" class="detaller"><cf_translate key="LB_Total">Total</cf_translate></td>
        	<td class="detaller">&nbsp;</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_Dias,'none')#</td>
			    <td class="detaller">&nbsp;</td>
		   <td class="detaller">&nbsp;</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_Ordinario,'none')#</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_HorasExtra,'none')#</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_SalarioExtra,'none')#</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_Agui,'none')#</td>
			<td class="detaller">#LSCurrencyFormat(Lvar_Bono,'none')#</td>	
			 <td class="detaller">&nbsp;</td>
            <td class="detaller">#LSCurrencyFormat(Lvar_OtrosPagos,'none')#</td>
        </tr>
		
		
        </cfoutput>
    </table>
<cfelse>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
    	<tr class="titulo_empresa2"><td align="center">No se han definido las columnas del reporte.</td></tr>
    </table>
</cfif>