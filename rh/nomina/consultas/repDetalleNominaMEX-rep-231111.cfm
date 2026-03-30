<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
    
	<!--- Genera variables de traduccion --->
 

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Nomina" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"			Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"	Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario"		Default="Salario" 			returnvariable="LB_Salario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vales"		Default="Vales Despensa" 	returnvariable="LB_Vales"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Subsidio"	Default="Subsidio" 			returnvariable="LB_Subsidio"/>

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BonoEmpleado"	Default="Bono Empleado" 	returnvariable="LB_BonoEmpleado"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PieMaquina"		Default="Pie Maquina" 		returnvariable="LB_PieMaquina"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ComisionVentas"	Default="Comision Ventas" 	returnvariable="LB_ComisionVentas"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasDobleExc"	Default="HExt Dobles Exc" 	returnvariable="LB_TotalHExtrasDobleExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasDobleGrv"	Default="HExt Dobles Grv" 	returnvariable="LB_TotalHExtrasDobleGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtDoblesExc"			Default="Mto HExt Dobles Exc" returnvariable="LB_MtoExtDoblesExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtDoblesGrv"			Default="Mto HExt Dobles Grv" returnvariable="LB_MtoExtDoblesGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasTrip"		Default="HExt Triples" 		returnvariable="LB_TotalHExtrasTrip"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtTriples"			Default="Mto HExt Triples" 	returnvariable="LB_MtoExtTriples"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaDomGrv"	Default="Prima Dom Grv" returnvariable="LB_PrimaDomGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaDomExc"	Default="Prima Dom Exc" returnvariable="LB_PrimaDomExc"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaVacGrv"	Default="Prima Vac Grv" returnvariable="LB_PrimaVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaVacExc"	Default="Prima Vac Exc" returnvariable="LB_PrimaVacExc"/>   
     
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSMG"	Default="Infonavit SMG" returnvariable="LB_InfonaSMG"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSDI"	Default="Infonavit SDI" returnvariable="LB_InfonaSDI"/>
           

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PensionAlim"	Default="Pension Alimenticia" 	returnvariable="LB_PensionAlim"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PensionAlim"	Default="Pension Alimenticia" 	returnvariable="LB_PensionAlim"/>       
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrestaPerso"	Default="Prestamo Personal" 	returnvariable="LB_PrestaPerso"/>  
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CargasIMSS"	Default="IMSS" 					returnvariable="LB_CargasIMSS"/>     
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLab"		Default="Dias Trab" 			returnvariable="LB_DiasLab"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasFalta"	Default="Dias Falta" 			returnvariable="LB_DiasFalta"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoDiasFalta"Default="Mto. Dias Falta" 		returnvariable="LB_MtoDiasFalta"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasIncap"	Default="Dias Incapacidad" 		returnvariable="LB_DiasIncap"/>                       
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 					returnvariable="LB_ISPT"/>                 
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasVac"		Default="Dias Vacacion" 		returnvariable="LB_DiasVac"/>                       
    
    
    
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiExc"	Default="Proporcional Agui Exc" 		returnvariable="LB_PropAguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiGrv"	Default="Proporcional Agui Grv" 		returnvariable="LB_PropAguiGrv"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacGrv"	Default="Proporcional Prima Vac Grv" 	returnvariable="LB_ProPrVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacExc"	Default="Proporcional Prima Vac Exc" 	returnvariable="LB_ProPrVacExc"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProDVac"		Default="Proporcional Dias Vacacaiones" returnvariable="LB_ProDVac"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Indemnizacio"Default="Indemnizacion" 				returnvariable="LB_Indemnizacio"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Separacion"	Default="Separacion" 					returnvariable="LB_Separacion"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriAntigueda"Default="Primas Antiguiedad"			returnvariable="LB_PriAntigueda"/>   
    
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Impuntual"	Default="Impuntual" 		returnvariable="LB_Impuntual"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuoSindical"	Default="Cuota Sindical"	returnvariable="LB_CuoSindical"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AyuSindical"	Default="Ayuda Sindical" 	returnvariable="LB_AyuSindical"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescSindical"Default="Descuento Sindical"returnvariable="LB_DescSindical"/>   




		
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
		<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
		<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
		<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
		<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"     mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        
        <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
        
        <cf_dbtempcol name="Subsidio" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="BonoEmple"		type="money"     	mandatory="no">
        <cf_dbtempcol name="PieMq" 			type="money"       	mandatory="no">
        <cf_dbtempcol name="ComVentas"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExDobleE"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExDobleE"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExDobleG"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExDobleG"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExTriple"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExTriple"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriDomGrv"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriDomExc"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriVacExc" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriVacGrv" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="InfonaSMG" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="InfonaSDI" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="PensionAlime" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="PrestPerso" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="CargaIMSS" 		type="money"       	mandatory="no">
        
        <cf_dbtempcol name="Dfaltas" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="MtoDfaltas"		type="money"       	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="Dincap" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="Dvac" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="DLab" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="Vales" 			type="money"       	mandatory="no">
        
        
        <cf_dbtempcol name="PagAguiExc"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PagAguiGrv"		type="money"       	mandatory="no">
        
        <cf_dbtempcol name="PropAguiExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="PropAguiGrv"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacGrv"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProDVac"		type="money"       	mandatory="no">                

        <cf_dbtempcol name="Indemnisacio"	type="money"       	mandatory="no">        
        <cf_dbtempcol name="Separacion"		type="money"       	mandatory="no">        
        <cf_dbtempcol name="PriAntigueda"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">   
        
        <cf_dbtempcol name="Impuntual"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="CuoSindical"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="AyuSindical"    type="money"       	mandatory="no">   
        <cf_dbtempcol name="DescSindical"	type="money"       	mandatory="no">   
        
        
        
		<cf_dbtempcol name="CFcodigo" 		type="char(10)"     mandatory="no">
		<cf_dbtempcol name="CFdescripcion" 	type="char(50)" 	mandatory="no">
		<cf_dbtempcol name="MaxFecha" 		type="datetime"     mandatory="no">
		
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
    
    
    <cfif form.Tfiltro EQ 1>
        
        <!--- Define Form.CPidlist (Puede venir en Form.CPidlist1 o Form.CPidlist2) --->
        <cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
            <cfset form.CPidlist = form.CPidlist1>
        <cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
            <cfset form.CPidlist = form.CPidlist2>
        <cfelse>
            <!--- Este error no debe presentarse. --->
            <cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
        </cfif>
        <!--- Obtiene informacion del calendario de pago selecccionado por el usuario. --->
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
    <cfelse>
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
                   	and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
        </cfquery>
	</cfif> 


<cfquery datasource="#session.dsn#" name="rsFechas">
    select min(RCdesde) as finicio  , max(RChasta) as ffinal
    from #calendario#
</cfquery>

<!---<cfdump var="#rsFechas#">
          
 <cf_dumptable var="#calendario#">    --->     
        

       
 <!---====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO, tomando en cuenta todos los calendarios para el rango de fechas
    ====================================---> 

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	insert #salida# (DEid, Identificacion, Nombre,Ape1,Ape2, CFcodigo, CFdescripcion,CSsalario )
        select distinct a.DEid, a.DEidentificacion, a.DEnombre, a.DEapellido1, a.DEapellido2
                ,f.CFcodigo
                ,f.CFdescripcion
                ,0
        from DatosEmpleado a
            inner join LineaTiempo b
                on a.DEid = b.DEid
            inner join DLineaTiempo d
                on b.LTid = d.LTid
            inner join ComponentesSalariales cs
                on d.CSid = cs.CSid
                    and CSsalariobase = 1
            inner join CalendarioPagos c
                on c.Tcodigo = b.Tcodigo
                    and c.Ecodigo = a.Ecodigo
            inner join RHPlazas p
                on b.RHPid = p.RHPid
            inner join CFuncional f
                on p.CFid = f.CFid
            inner join #calendario# x
                on 	b.Tcodigo = x.Tcodigo
                    and c.CPid = x.RCNid
                    and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
             
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif isdefined('form.DEid') and len(trim(form.DEid))> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> </cfif>
           order by DEid
</cfquery>


<cfif isdefined('form.tiponomina')>
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
<cfelse>	
	<cfset vSalarioEmpleado 	= 'SalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'RCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'PagosEmpleado'>
    <cfset vCargasCalculo 		= 'CargasCalculo'>
</cfif>

<cfquery datasource="#session.dsn#">
    update #salida# set
        MaxFecha = (Select coalesce(Max(c.RCdesde),getdate())
                from #calendario# a,
                     #vSalarioEmpleado# b,
                     HRCalculoNomina c
                Where b.RCNid=c.RCNid
                and b.DEid=#salida#.DEid
                and b.RCNid=a.RCNid
                )	
</cfquery>


<!---actualiza el valor del subsidio al salario--->
<cfquery datasource="#session.dsn#" name="UpdSubsidio">
    update #salida#
    set Subsidio = 
    coalesce((
    select sum(a.DCvalor)*-1 from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'SubSalario' 	<!---Subsidio al salario MEX--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Infonavit SMG--->
<cfquery datasource="#session.dsn#" name="UpdInfonaSMG">
    update #salida#
    set InfonaSMG = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'InfonaSMG' 	<!---Deduccion de Infonavit SMG--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Infonavit SDI--->
<cfquery datasource="#session.dsn#" name="UpdInfonaSDI">
    update #salida#
    set InfonaSDI = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'InfonaSDI' 	<!---Infonavit SDI--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Pension Alimenticia--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set PensionAlime = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'PensionAlime' 	<!---Deduccion de Pension Alimenticia--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Cuota Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set CuoSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'CuoSindical' 		<!---Deduccion de Cuota Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Ayuda Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set AyuSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'AyuSindical' 		<!---Deduccion de Ayuda Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Descuento Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set DescSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'DescSindical' 		<!---Deduccion de Descuento Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion Prestamos Pesonales--->
<cfquery datasource="#session.dsn#" name="UpdPrestPerso">
    update #salida#
    set PrestPerso = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'PrestPerso' 	<!---Deduccion Prestamos Pesonales--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion Cargas IMSS--->
<cfquery datasource="#session.dsn#" name="UpdCargaIMSSo">
    update #salida#
    set CargaIMSS = 
    coalesce((
    select sum(a.CCvaloremp) from #vCargasCalculo# a, CargasEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.DClinea = b.DClinea
                        and b.DClinea  in (select distinct a.DClinea
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'CargaIMSS' 	<!---Deduccion Cargas IMSS--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Concepto de pago Impuntual--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Impuntual =  
        	coalesce((
            select coalesce(sum(a.ICmontores),0) 
				    from #vIncidenciasCalculo# a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Impuntual'	<!--- Impuntual MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#)
             ),0)
</cfquery>

<!---Bono empleado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set BonoEmple =  
        	coalesce((
            select coalesce(sum(a.ICmontores),0) 
				    from #vIncidenciasCalculo# a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'BonEmpleado'	<!---Bono Empleado MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#)
             ),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'BonEmpleado'	<!---Bono Empleado MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Pie de Maquina--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PieMq =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PieMaquina'	<!---Pie de Maquina MEX--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'PieMaquina'	<!---Pie de Maquina MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Comision sobre ventas MEX--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ComVentas =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Comision'	<!---Comision sobre ventas MEX--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Comision'		<!---Comision sobre ventas MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Horas Extra Dobles Excentas--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExDobleE =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
<!---		where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Total Horas Extra Dobles Excentas--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExDobleE =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Horas Extra Dobles Gravables--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExDobleG =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Gravables--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Excentas--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Total Horas Extra Dobles Gravables--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExDobleG =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Gravables--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
<!---		where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Gravables--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Horas Extra Triples--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExTriple =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Total Horas Extra Triples --->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExTriple =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples --->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples --->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Prima Dominical Excenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriDomExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriDomExc'	<!---Prima Dominical Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'PriDomExc'	<!---Horas Triples--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Prima Dominical Gravable--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriDomGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriDomGrv'	<!---Prima Dominical Gravable--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'PriDomGrv'	<!---Horas Triples--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>


<!---Prima Vacacional Excenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriVacExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriVacExc'	<!---Prima Vacacional Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'PriVacExc'	<!---Prima Vacacional Excenta--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Prima Vacacional Gravable--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriVacGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriVacGrv'	<!---Prima Vacacional Gravable--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
                and a.RCNid = x.RCNid 
                and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'PriVacGrv'	<!---Prima Vacacional Gravable--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Pago Aguinaldo Excento--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PagAguiExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiExc'	<!---Pago Aguinaldo Excento--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Pago Aguinaldo Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PagAguiGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiGrv'	<!---Pago Aguinaldo Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---dias de falta  y el monto por dias falta, Dias de Incapacidad, dias Vacaciones --->
<cfquery datasource="#session.dsn#" name="rsFaltas">
    update #salida#
            <!---Dias de Falta--->
            set Dfaltas = 
                        coalesce(
                        (select sum(pe.PEcantdias)
                        from #vPagosEmpleado# pe
                            inner join  #calendario# x 
                                on pe.RCNid = x.RCNid
                            inner join LineaTiempo lt
                                on pe.LTid = lt.LTid
                            inner join  RHTipoAccion ta
                                on lt.RHTid = ta.RHTid
                                    and ta.RHTcomportam = 13
                                where pe.DEid = #salida#.DEid),0)
            <!---Monto Dias de Falta--->
            , MtoDfaltas = 
                        coalesce(
                        (select sum(((coalesce(ta.RHTfactorfalta,1) * (pe.PEsalario / 30))* pe.PEcantdias))
                        from #vPagosEmpleado# pe
                            inner join  #calendario# x 
                                on pe.RCNid = x.RCNid
                            inner join LineaTiempo lt
                                on pe.LTid = lt.LTid
                            inner join  RHTipoAccion ta
                                on lt.RHTid = ta.RHTid
                                    and ta.RHTcomportam = 13
                                where pe.DEid = #salida#.DEid),0)
    
             <!---Dias de Incapacidad--->
             , Dincap = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid
                                    inner join  RHTipoAccion ta
                                        on lt.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 5
                                        where pe.DEid = #salida#.DEid),0)
				<!---Dias de Vacaciones--->
                , Dvac = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid
                                    inner join  RHTipoAccion ta
                                        on lt.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 3
                                        where pe.DEid = #salida#.DEid),0)     
                , DLab =                      
                             coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid
                                    inner join  RHTipoAccion ta
                                        on lt.RHTid = ta.RHTid
                                            and ta.RHTcomportam not in(3,5,13)
                                        where pe.DEid = #salida#.DEid),0)            
</cfquery>



<!---Renta ISPT--->
<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set ISPT = 
                coalesce(
                        (select sum(se.SErenta)
                        from #vSalarioEmpleado# se
                            inner join  #calendario# x 
                                on se.RCNid = x.RCNid
                                where se.DEid = #salida#.DEid),0)
                                
                ,Vales = 
                    coalesce(
                            (select sum(se.SEespecie)
                            from #vSalarioEmpleado# se
                                inner join  #calendario# x 
                                    on se.RCNid = x.RCNid
                                    where se.DEid = #salida#.DEid),0)
                ,CSsalario = 
                        coalesce(
                                (select sum(se.SEsalariobruto)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)
				,SDI = 
                        coalesce(
                                (select sum(se.SEsalariobc)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)

</cfquery>

<!---Salario Diario--->

<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set SalDiario = CSsalario / DLab
	where DLab > 0
</cfquery>


<!---conceptos de liquidacion --->

<!---Pago Aguinaldo Excento--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PropAguiExc =  coalesce((select coalesce(sum(a.RHLIexento),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PropAguiExc'	<!---Pago Aguinaldo Excento--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Pago Aguinaldo Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PropAguiGrv=  coalesce((select coalesce(sum(a.RHLIgrabado),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiGrv'	<!---Pago Aguinaldo Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>




<!---Proporcional Prima Vacaciones Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ProPrVacExc=  coalesce((select coalesce(sum(a.RHLIexento),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'ProPrVacExc'	<!---Proporcional Prima Vacaciones Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Proporcional Prima Vacaciones Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ProPrVacGrv=  coalesce((select coalesce(sum(a.RHLIgrabado),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'ProPrVacGrv'	<!---Proporcional Prima Vacaciones Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>



<!---Indemnizacion--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Indemnisacio=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Indemnisacio'	<!---Indemnizacion--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Separacion--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Separacion=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Separacion'	<!---Separacion--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Proporcional Prima Antiguedad--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriAntigueda=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriAntigueda'	<!---Proporcional Prima Antiguedad--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---<cf_dumpTABLE var="#salida#">--->





<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleNominaMEX-form.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_TituloReporte#">
<cf_templatecss>
<table width="98%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="45">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>	
				<!---<cfif isdefined('form.tiponomina')>
					<cfinvoke key="LB_IncluyeNominasAplicadas" default="Incluye N&oacute;minas Aplicadas" returnvariable="LB_IncluyeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasAplicadas>
				<cfelse>
					<cfinvoke key="LB_IncluyeNominasEnProceso" default="Incluye N&oacute;minas En Proceso" returnvariable="LB_IncluyeNominasEnProceso" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasEnProceso>
				</cfif>--->
				<cf_EncReporte
					Titulo="#LB_TituloReporte#"
					Color="##E3EDEF"
					filtro1="#form.TDescripcion2#"
					filtro2="Desde:#lsdateformat(rsFechas.finicio,'dd/mm/yyyy')# al #lsdateformat(rsFechas.ffinal,'dd/mm/yyyy')#"
				>
			</td>
		</tr>
		</table>
	</td>
 </tr>
    <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasLab#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoDiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasIncap#</strong>&nbsp;</td>
    
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario#</strong>&nbsp;</td>
    

    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vales#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Subsidio#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_BonoEmpleado#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PieMaquina#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ComisionVentas#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasDobleExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtDoblesExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasDobleGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtDoblesGrv#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasTrip#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtTriples#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaDomGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaDomExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaVacGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaVacExc#</strong>&nbsp;</td>
     <td  class="tituloListas" valign="top" align="right"><strong>#LB_Impuntual#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSMG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSDI#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PensionAlim#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrestaPerso#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_CuoSindical#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AyuSindical#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescSindical#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_CargasIMSS#</strong>&nbsp;</td>
    
    
    <!---<td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoDiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasIncap#</strong>&nbsp;</td>--->
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasVac#</strong>&nbsp;</td>    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProDVac#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Indemnizacio#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Separacion#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriAntigueda#</strong>&nbsp;</td>  
      

</tr>
</cfoutput>

<!---


<cfsilent>
	<cfset Lvar_GrandCount = 0>
	<cfset Lvar_GrandRegular_HoursAcum =  0>
	<cfset Lvar_GrandHoliday_HoursAcum =  0>
	<cfset Lvar_GrandTotal_HoursAcum =  0>
	<cfset Lvar_GrandTotal_Hr_SalaryAcum =  0>
	<cfset Lvar_GrandSalary_HolidayAcum =  0>
	<cfset Lvar_GrandPay_AdjustAcum =  0>
	<cfset Lvar_GrandNet_PayAcum =  0>
	<cfset Lvar_GrandVacationsAcum =  0>
	<cfset Lvar_GrandCommAcum =  0>
	<cfset Lvar_GrandTotal_PayAcum =  0>
	<cfset Lvar_GrandCLTBSAAcum =  0>
	<cfset Lvar_GrandGross_PayAcum =  0>
	<cfset Lvar_GrandEE_AdvanceAcum =  0>
	<cfset Lvar_GrandTotal_Pay_FinalAcum =  0>
</cfsilent>--->
<cfoutput query="rsReporte" group="CFdescripcion">
<!---	<cfsilent>
		<cfset Lvar_GroupCount = 0>
		<cfset Lvar_GroupRegular_HoursAcum =  0>
		<cfset Lvar_GroupHoliday_HoursAcum =  0>
		<cfset Lvar_GroupTotal_HoursAcum =  0>
		<cfset Lvar_GroupTotal_Hr_SalaryAcum =  0>
		<cfset Lvar_GroupSalary_HolidayAcum =  0>
		<cfset Lvar_GroupPay_AdjustAcum =  0>
		<cfset Lvar_GroupNet_PayAcum =  0>
		<cfset Lvar_GroupVacationsAcum =  0>
		<cfset Lvar_GroupCommAcum =  0>
		<cfset Lvar_GroupTotal_PayAcum =  0>
		<cfset Lvar_GroupCLTBSAAcum =  0>
		<cfset Lvar_GroupGross_PayAcum =  0>
		<cfset Lvar_GroupEE_AdvanceAcum =  0>
		<cfset Lvar_GroupTotal_Pay_FinalAcum =  0>
	</cfsilent>
---><!---	<tr>
		<td nowrap class="tituloListas" colspan="17"><strong>#rsReporte.CFdescripcion#</strong>&nbsp;</td>
	</tr>--->

	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsReporte.Identificacion#</td>
            <td nowrap>#rsReporte.Ape1#</td>
            <td nowrap>#rsReporte.Ape2#</td>
            <td nowrap>#rsReporte.Nombre#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DLab,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.MtoDfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dincap,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CSsalario,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vales,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Subsidio,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.BonoEmple,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PieMq,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ComVentas,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExDobleE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExDobleG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExTriple,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExTriple,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacExc,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Impuntual,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSMG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSDI,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PensionAlime,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PrestPerso,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CuoSindical,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AyuSindical,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DescSindical,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CargaIMSS,'none')#</td>
            
            
            
            <!---<td nowrap align="right">#LSCurrencyformat(rsReporte.Dfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.MtoDfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dincap,'none')#</td>--->
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dvac,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProDVac,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Indemnisacio,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Separacion,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriAntigueda,'none')#</td>
         </tr>   
		</tr>
        
       
		<!---<cfsilent>
			<cfset Lvar_GrandCount = Lvar_GrandCount + 1>
			<cfset Lvar_GroupCount = Lvar_GroupCount + 1>
			<cfset Lvar_GrandRegular_HoursAcum = Lvar_GrandRegular_HoursAcum + rsReporte.Regular_Hours>
			<cfset Lvar_GrandHoliday_HoursAcum = Lvar_GrandHoliday_HoursAcum + rsReporte.Holiday_Hours>
			<cfset Lvar_GrandTotal_HoursAcum = Lvar_GrandTotal_HoursAcum + rsReporte.Total_Hours>
			<cfset Lvar_GrandTotal_Hr_SalaryAcum = Lvar_GrandTotal_Hr_SalaryAcum + rsReporte.Total_Hr_Salary>
			<cfset Lvar_GrandSalary_HolidayAcum = Lvar_GrandSalary_HolidayAcum + rsReporte.Salary_Holiday>
			<cfset Lvar_GrandPay_AdjustAcum = Lvar_GrandPay_AdjustAcum + rsReporte.Pay_Adjust>
			<cfset Lvar_GrandNet_PayAcum = Lvar_GrandNet_PayAcum + rsReporte.Net_Pay>
			<cfset Lvar_GrandVacationsAcum = Lvar_GrandVacationsAcum + rsReporte.Vacations>
			<cfset Lvar_GrandCommAcum = Lvar_GrandCommAcum + rsReporte.Comm>
			<cfset Lvar_GrandTotal_PayAcum = Lvar_GrandTotal_PayAcum + rsReporte.Total_Pay>
			<cfset Lvar_GrandCLTBSAAcum = Lvar_GrandCLTBSAAcum + rsReporte.CLTBSA>
			<cfset Lvar_GrandGross_PayAcum = Lvar_GrandGross_PayAcum + rsReporte.Gross_Pay>
			<cfset Lvar_GrandEE_AdvanceAcum = Lvar_GrandEE_AdvanceAcum + rsReporte.EE_Advance>
			<cfset Lvar_GrandTotal_Pay_FinalAcum = Lvar_GrandTotal_Pay_FinalAcum + rsReporte.Total_Pay_Final>
			<cfset Lvar_GroupRegular_HoursAcum = Lvar_GroupRegular_HoursAcum + rsReporte.Regular_Hours>
			<cfset Lvar_GroupHoliday_HoursAcum = Lvar_GroupHoliday_HoursAcum + rsReporte.Holiday_Hours>
			<cfset Lvar_GroupTotal_HoursAcum = Lvar_GroupTotal_HoursAcum + rsReporte.Total_Hours>
			<cfset Lvar_GroupTotal_Hr_SalaryAcum = Lvar_GroupTotal_Hr_SalaryAcum + rsReporte.Total_Hr_Salary>
			<cfset Lvar_GroupSalary_HolidayAcum = Lvar_GroupSalary_HolidayAcum + rsReporte.Salary_Holiday>
			<cfset Lvar_GroupPay_AdjustAcum = Lvar_GroupPay_AdjustAcum + rsReporte.Pay_Adjust>
			<cfset Lvar_GroupNet_PayAcum = Lvar_GroupNet_PayAcum + rsReporte.Net_Pay>
			<cfset Lvar_GroupVacationsAcum = Lvar_GroupVacationsAcum + rsReporte.Vacations>
			<cfset Lvar_GroupCommAcum = Lvar_GroupCommAcum + rsReporte.Comm>
			<cfset Lvar_GroupTotal_PayAcum = Lvar_GroupTotal_PayAcum + rsReporte.Total_Pay>
			<cfset Lvar_GroupCLTBSAAcum = Lvar_GroupCLTBSAAcum + rsReporte.CLTBSA>
			<cfset Lvar_GroupGross_PayAcum = Lvar_GroupGross_PayAcum + rsReporte.Gross_Pay>
			<cfset Lvar_GroupEE_AdvanceAcum = Lvar_GroupEE_AdvanceAcum + rsReporte.EE_Advance>
			<cfset Lvar_GroupTotal_Pay_FinalAcum = Lvar_GroupTotal_Pay_FinalAcum + rsReporte.Total_Pay_Final>
		</cfsilent>--->
	</cfoutput>
	<!---<tr>
		<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate>#rsReporte.CFdescripcion#</strong></td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCount,'none')#&nbsp;&nbsp;</td>
		<td nowrap class="tituloListas" align="right">&nbsp;</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupRegular_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupHoliday_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_HoursAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_Hr_SalaryAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupSalary_HolidayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupPay_AdjustAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupNet_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupVacationsAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCommAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupCLTBSAAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupGross_PayAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupEE_AdvanceAcum,'none')#</td>
		<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GroupTotal_Pay_FinalAcum,'none')#</td>
	</tr>--->
</cfoutput>
<cfoutput>
<!---<tr>
	<td nowrap class="tituloListas"><strong><cf_translate key="LB_Total"> Total </cf_translate></strong></td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCount,'none')#</td>
	<td nowrap class="tituloListas" align="right">&nbsp;</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandRegular_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandHoliday_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_HoursAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_Hr_SalaryAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandSalary_HolidayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandPay_AdjustAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandNet_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandVacationsAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCommAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandCLTBSAAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandGross_PayAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandEE_AdvanceAcum,'none')#</td>
	<td nowrap class="tituloListas" align="right">#LSCurrencyformat(Lvar_GrandTotal_Pay_FinalAcum,'none')#</td>
</tr>--->
</cfoutput>
<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
