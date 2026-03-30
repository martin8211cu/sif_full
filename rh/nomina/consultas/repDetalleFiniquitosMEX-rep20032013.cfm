<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>

 <cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
   
</cfif>
<!---<cfthrow message="Deid  #Form.DEid#" >--->
   
	<!--- Genera variables de traduccion --->
 
 <!--- Modificado por Israel  Rodríguez Ruiz APH Mex 2-FEB-12
 	Se realizan  las modificaciones necesarias para obtener el  Reporte de finiquitos --->

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Finiquitos" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre (s)" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaIngreso"Default="Fecha Ingreso"	returnvariable="LB_FechaIngreso"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaBaja"	Default="Fecha Baja" returnvariable="LB_FechaBaja"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"			Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"	Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPAguiFin"	Default="Retro Prop Aguinaldo Finiquito" returnvariable="LB_RPAguiFin"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPVacFin"	Default="Retro Prop Vacaciones Finiquito" returnvariable="LB_RPVacFin"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPPVacFin"	Default="Retro Prop Prima Vacacional Finiquito" returnvariable="LB_RPPVacFin"/> 
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSMG"	Default="Infonavit VSM" returnvariable="LB_InfonaSMG"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSDI"	Default="Infonavit Porcentaje" returnvariable="LB_InfonaSDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 			returnvariable="LB_ISPT"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPTF"		Default="ISPT Real Liquidación" 					returnvariable="LB_ISPTF"/>       
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLab"		Default="Dias Trab" 			returnvariable="LB_DiasLab"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasVac"		Default="Dias Vacacion" 		returnvariable="LB_DiasVac"/>                       
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiExc"	Default="Proporcional Agui Exc" 		returnvariable="LB_PropAguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiGrv"	Default="Proporcional Agui Grv" 		returnvariable="LB_PropAguiGrv"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacGrv"	Default="Proporcional Prima Vac Grv" 	returnvariable="LB_ProPrVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacExc"	Default="Proporcional Prima Vac Exc" 	returnvariable="LB_ProPrVacExc"/>   
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProVacFin"	Default="Proporcion Vac Finiquito" 	returnvariable="LB_ProVacFin"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProDiasAgui"		Default="Proporcional Dias Aguinaldo" returnvariable="LB_ProDiasAgui"/>   
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Indemnizacio"Default="Indemnizacion" 				returnvariable="LB_Indemnizacio"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Separacion"	Default="Separacion" 					returnvariable="LB_Separacion"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriAntigueda"Default="Primas Antiguiedad"			returnvariable="LB_PriAntigueda"/>             
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPreAgui"	Default="Retroactivo Aguinaldo" 	returnvariable="LB_RetPreAgui"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PenAlimen"	Default="Pensión Alimenticia" 	returnvariable="LB_PenAlimen"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PresPers"	Default="Préstamo Personal" 	returnvariable="LB_PresPers"/>    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OtrasDeduc"	Default="Otras Deducciones" 	returnvariable="LB_OtrasDeduc"/>    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Destolls"	Default="Des.Herramienta Trabajo" 	returnvariable="LB_Destolls"/>    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DesEqSeg"	Default="Des.Equipo Seguridad" 	returnvariable="LB_DesEqSeg"/>    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AntNomina"	Default="Anticipo Nómina" 	returnvariable="LB_AntNomina"/>    
    
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
        <cf_dbtempcol name="DLlinea"   		type="int"          mandatory="no">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"     mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        
        <cf_dbtempcol name="FechaIngreso"  	type="char(20)"     mandatory="no">
        <cf_dbtempcol name="FechaBaja"   	type="char(20)"     mandatory="no">
        <cf_dbtempcol name="FactorDiasSalario"   type="int"          mandatory="no">
        <cf_dbtempcol name="diasAnt"   type="int"          mandatory="no">
        <cf_dbtempcol name="InfonaSMG" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="InfonaSDI" 		type="money"       	mandatory="no">        
        <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
        
        <cf_dbtempcol name="Dvac" 			type="float"       	mandatory="no">
        <cf_dbtempcol name="ProDVac"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="ProVacFin"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="Indemnizacion"	type="money"       	mandatory="no">        
        <cf_dbtempcol name="Separacion"		type="money"       	mandatory="no">        
        <cf_dbtempcol name="PriAntigueda"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="DLab" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="PropAguiExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="PropAguiGrv"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacGrv"	type="money"       	mandatory="no">
		<cf_dbtempcol name="ProDiasAgui"	type="money"		mandatory="no">
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">

        <cf_dbtempcol name="RPAguiFin"		type="float"       	mandatory="no">
        <cf_dbtempcol name="RPVacFin"		type="money"       	mandatory="no">
        <cf_dbtempcol name="RPPVacFin"		type="money"       	mandatory="no"> 
        <cf_dbtempcol name="RetPreAgui"		type="money"       	mandatory="no">  

        <cf_dbtempcol name="PenAlimen"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PresPers"		type="money"       	mandatory="no">
        <cf_dbtempcol name="OtrasDeduc"		type="money"       	mandatory="no">
        <cf_dbtempcol name="Destolls"		type="money"       	mandatory="no">
		<cf_dbtempcol name="DesEqSeg"		type="money"		mandatory="no">
        <cf_dbtempcol name="AntNomina"		type="money"       	mandatory="no">
		<cf_dbtempcol name="ISPTTotF"		type="money"       	mandatory="no">

		<!---<cf_dbtempkey cols="DEid">--->
	</cf_dbtemp>
    
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        <cfif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde))>
                    and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
        </cfif> 
        <cfif isdefined("form.FechaHasta")	and len(trim(form.FechaHasta))>           
                   	and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
        </cfif>         
        <cfif isdefined("form.Tcodigo")	and len(trim(form.Tcodigo))>           
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
        </cfif>         
        </cfquery>
	
<cfquery datasource="#session.dsn#" name="rsFechas">
    select min(CPdesde) as finicio  , max(CPhasta) as ffinal
    from calendarioPagos
</cfquery> 

<!---<cfdump var="#rsFechas#">
          
 <cf_dumptable var="#calendario#">   --->     
        
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
    <cfset vDatosEmpleado		= 'DatosEmpleado'>

<!----------------------------------------------->
       
 <!---====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO
    ====================================---> 


<!--- Hay  que probar  estos queries --->


	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
   		insert #salida# (DLlinea, DEid, Nombre,Ape1,Ape2, Identificacion,FechaIngreso,FechaBaja,FactorDiasSalario,diasAnt  )
        select distinct a.DLlinea, b.DEid,
			   b.DEnombre,
               b.DEapellido1,
               b.DEapellido2,
               b.DEidentificacion,
			   a.RHLPfingreso as FechaIngreso,
			   c.DLfvigencia as FechaBaja,
			   <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,
			   <!---<cf_dbfunction name="datediff" args="e.EVfantig, c.DLfvigencia"> as diasAnt---->
			   <cf_dbfunction name="datediff" args="a.RHLPfingreso, c.DLfvigencia"> as diasAnt
		from RHLiquidacionPersonal a
	
			inner join DatosEmpleado b
				on a.DEid = b.DEid
			
			inner join DLaboralesEmpleado c
				on a.DLlinea = c.DLlinea
			
			inner join RHPuestos d
				on c.Ecodigo = d.Ecodigo
				and c.RHPcodigo = d.RHPcodigo
			
			inner join EVacacionesEmpleado e
				on a.DEid = e.DEid
			
			inner join Departamentos f
				on c.Ecodigo = f.Ecodigo
				<!---and c.Dcodigo = f.Dcodigo--->
	
			inner join RHTipoAccion g
				on c.RHTid = g.RHTid
				and g.RHTcomportam = 2
	
			inner join TiposNomina h
				on c.Ecodigo = h.Ecodigo
				and c.Tcodigo = h.Tcodigo
				
			inner join Monedas i
				on h.Ecodigo = i.Ecodigo
				and h.Mcodigo = i.Mcodigo
	
	where
		
	<cfif form.FechaDesde NEQ ''>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(form.FechaDesde,'yyyy-mm-dd')#">
    <cfelse>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(rsFechas.finicio,'yyyy-mm-dd')#">
    </cfif>
     
    <cfif form.FechaHasta NEQ ''>
    	and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(form.FechaHasta,'yyyy-mm-dd')#">
    <cfelse>
	    and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(rsFechas.ffinal,'yyyy-mm-dd')#">
    </cfif>  
      and b.Ecodigo = #session.Ecodigo#
   	<cfif Form.DEid GT 0 >
    	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
    </cfif> 
    and c.Tcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
    and a.RHLPestado = 1
    order by  b.DEidentificacion
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
                                
                ,CSsalario = 
                        coalesce(
                                (select sum(se.SEsalariobruto)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)
				,SDI = 
                        coalesce(
                                (select DEsdi
                                from #vDatosEmpleado# se
                                        where se.DEid = #salida#.DEid
                                        and se.Ecodigo= #session.Ecodigo#),0)
                , DLab =                      
                             coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam not in(3,5,13)
                                        where pe.DEid = #salida#.DEid),0)            
				<!---Dias de Vacaciones--->
               <!--- , Dvac = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 3
                                        where pe.DEid = #salida#.DEid),0) 	--->									
</cfquery>

<!---Salario Diario--->

    <cfquery datasource="#session.dsn#" name="upSD">
        update #salida#
                set SalDiario = CSsalario / DLab
                where  DLab <> 0
    </cfquery> 

<!---Deduccion de Infonavit SMG--->
<cfquery datasource="#session.dsn#" name="InfonaSMG">
    update #salida#
    set InfonaSMG = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = b.DEid 
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
                            where c.RHRPTNcodigo = 'MX004'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Infonavit SDI--->
<cfquery datasource="#session.dsn#" name="infonaSDI">
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
                            where c.RHRPTNcodigo = 'MX004'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEncabezado">
	select * from #salida#
</cfquery>

<!---<cf_dumpTABLE var="#salida#">--->
<cfloop query="rsEncabezado" >
    <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
        <cfinvokeargument name="DLlinea" value="#rsEncabezado.DLlinea#">
        <cfinvokeargument name="DEid" value="#rsEncabezado.DEid#">
    </cfinvoke>
    
    <cfif rsLF.RHLFLisptF GT 0 >
    	<cfset ISPT_1 = rsLF.RHLFLisptF >
    <cfelse>   
    	<cfset ISPT_1 =0>
    </cfif>
  
    <cfif rsLF.RHLFLISPTRealL GT 0 >
    	<cfset ISPT_F = rsLF.RHLFLISPTRealL/100>
    <cfelse>   
    	<cfset ISPT_F =0>
    </cfif>
  
    <cfquery name="uP_isptSalD"  datasource="#session.dsn#">
    	update #salida#
        set ISPT=#ISPT_1#,ISPTTotF=#ISPT_F#       
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
	</cfquery>
      
      
   <!---  <cfif rsLF.RHLFLtotalL GTE 0>
	   <cfset RetroAgui=rsLF.RHLFLtotalL>
     <cfelse>--->
      	<cfset RetroAgui=0>
    <!--- </cfif>--->
     
	<!---<cfset RetroAgui=0> --->
	<cfquery name="rsDetallePrestaciones" datasource="#Session.DSN#">
		select a.DEid, a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe, coalesce(a.RHLIgrabado,0) as RHLIgrabado,
        	coalesce(a.RHLIexento,0) as RHLIexento, b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
		from RHLiqIngresos a
			left outer join DDConceptosEmpleado b
				on a.DLlinea = b.DLlinea and a.CIid = b.CIid
			left outer join CIncidentes c
				on b.CIid = c.CIid
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
        and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
		and coalesce(c.CISumarizarLiq,0) = 0
		and a.RHLPautomatico in (1,0)
	</cfquery>
    
     <cfset DiasVacFin = rsDetallePrestaciones.Cantidad>
    
    <!---ProDiasAgui--->
    <cfquery name="rsProDiasAgui" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PropAguiGrv' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PropDiasAgui = #ValueList(rsProDiasAgui.CIid)#>
	
   <cfif isdefined('PropDiasAgui') and PropDiasAgui NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select cantidad 
        from rsDetallePrestaciones
        where CIid  = #PropDiasAgui#
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsProDiasAgui" datasource="#session.DSN#">
     	update #salida#
    	set ProDiasAgui = #rsPrestaciones.cantidad#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
      </cfif>
    <cfelse>
    <cfquery name="rsProDiasAgui" datasource="#session.DSN#">
     	update #salida#
    	set ProDiasAgui = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---Dvac--->
    <cfquery name="rsDvac" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PropVacFiniq' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   
   <cfset Dvac1 = #rsDvac.CIid#>

   <cfif isdefined('Dvac1') and Dvac1 NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select cantidad 
        from rsDetallePrestaciones
        where CIid  = #Dvac1#
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsDvac" datasource="#session.DSN#">
     	update #salida#
    	set Dvac = #rsPrestaciones.cantidad#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
      </cfif>
    <cfelse>
    <cfquery name="rsDvac" datasource="#session.DSN#">
     	update #salida#
    	set Dvac = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    
    
    
   <!--- <cf_dump var = "#rsDetallePrestaciones#">--->
   
    <!--- Importes Gravados--->
    
   <!--- PropVacFin--->
   <cfquery name="rsPropVacFin" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PropVacFiniq' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PropVacFin = #ValueList(rsPropVacFin.CIid)#>
   
   <cfif isdefined('PropVacFin') and PropVacFin NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  in (#PropVacFin#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProVacFin = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
     </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProVacFin = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!--- ProPrVacGrv --->
    <cfquery name="rsProPrVacGrv" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'ProPrVacGrv' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PropPrVacGrv = #ValueList(rsProPrVacGrv.CIid)#>
   
   <cfif isdefined('PropPrVacGrv') and PropPrVacGrv NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  = #PropPrVacGrv#
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProPrVacGrv = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
      </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProPrVacGrv = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
   <!--- ProAguiGrv--->
    <cfquery name="rsPropAguiGrv" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PropAguiGrv' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset ProAguiGrv = #ValueList(rsPropAguiGrv.CIid)#>
	
   <cfif isdefined('ProAguiGrv') and ProAguiGrv NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  in (#ProAguiGrv#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PropAguiGrv = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
      </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PropAguiGrv = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---Indemnizacion--->
    <cfquery name="rsIndemnizacio" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'Indemnizacio' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset Indemnizacio = #ValueList(rsIndemnizacio.CIid)#>
   
   <cfif isdefined('Indemnizacio') and Indemnizacio NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  in (#Indemnizacio#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set Indemnizacion = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
     </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set Indemnizacion = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
  <!---Separacion--->
  <cfquery name="rsSeparacio" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'Separacio' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset Separacio = #ValueList(rsSeparacio.CIid)#>
   
   <cfif isdefined('Separacio') and Separacio NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  in (#Separacio#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set Separacion = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
     </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set Separacion = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---PriAntigueda--->
    
    <cfquery name="rsPriAntigued" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PriAntigued' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PriAntigued = #ValueList(rsPriAntigued.CIid)#>
   
   <cfif isdefined('PriAntigued') and PriAntigued NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIgrabado) as RHLIgrabado
        from rsDetallePrestaciones
        where CIid  in (#PriAntigued#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PriAntigueda = #rsPrestaciones.RHLIgrabado#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
     </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PriAntigueda = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!--- Importes Exentos--->
    
    <!---ProPrVacExc--->
    
    <cfquery name="rsProPrVacExc" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'ProPrVacExc' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PropPrVacExc = #ValueList(rsProPrVacExc.CIid)#> 
   
   <cfif isdefined('PropPrVacExc') and PropPrVacExc NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIexento) as RHLIexento
        from rsDetallePrestaciones
        where CIid  in (#PropPrVacExc#)
     </cfquery>
     
     <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
      <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProPrVacExc = #rsPrestaciones.RHLIexento#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	  </cfquery>
     </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set ProPrVacExc = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	</cfquery>
    </cfif>

	<!---ProAguiExc  --->  
    <cfquery name="rsProAguiExc" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'ProAguiExc' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset ProAguiExc = #ValueList(rsProAguiExc.CIid)#>
   
   <cfif isdefined('ProAguiExc') and ProAguiExc NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIexento) as RHLIexento
        from rsDetallePrestaciones
        where CIid  in (#ProAguiExc#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PropAguiExc = #rsPrestaciones.RHLIexento#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PropAguiExc = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	</cfquery>
    </cfif>
  
  	<!---RPAguiFin --->
  	<cfquery name="rsRPAguiFin" datasource="#session.DSN#">
   	select a.CIid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'RPAguiFin' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset RPAguiFini= #ValueList(rsRPAguiFin.CIid)#>
   
   <cfif isdefined('RPAguiFini') and RPAguiFini NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(RHLIexento) as RHLIexento
        from rsDetallePrestaciones
        where CIid  in (#RPAguiFini#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set RPAguiFin = #rsPrestaciones.RHLIexento#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set RPAguiFin = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
   <!--- Deducciones--->
   
   <!---PenAlimen--->
   <cfquery name="rsPensionAlime" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PensionAlime' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PensionAlime = #ValueList(rsPensionAlime.TDid)#>
   
   <cfif isdefined('PensionAlime') and PensionAlime  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid  in (#PensionAlime#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PenAlimen = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPropVacFin" datasource="#session.DSN#">
     	update #salida#
    	set PenAlimen = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
	<!---PresPers--->  
    <cfquery name="rsPrestPerso" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'PrestPerso' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset PrestPerso = #ValueList(rsPrestPerso.TDid)#>
   
   <cfif isdefined('PrestPerso') and PrestPerso  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid in (#PrestPerso#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set PresPers = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set PresPers = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---OtrasDeduc--->
    <cfquery name="rsOtrasDeducc" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'OtrasDeducc' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset OtrasDeducc = #ValueList(rsOtrasDeducc.TDid)#>
   
   <cfif isdefined('OtrasDeducc') and OtrasDeducc  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid  in (#OtrasDeducc#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set OtrasDeduc = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set OtrasDeduc = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
  
 <!--- DescHerTrab (Destolls) ---> 
 <cfquery name="rsDescHerTrab" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'DescHerTrab' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset DescHerTrab = #ValueList(rsDescHerTrab.TDid)#>
   
   <cfif isdefined('DescHerTrab') and DescHerTrab  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid  in (#DescHerTrab#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set Destolls = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsPrestPerso" datasource="#session.DSN#">
     	update #salida#
    	set Destolls = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---DesEqSeg--->
    <cfquery name="rsDescEquSeg" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'DescEquSeg' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset DescEquSeg = #ValueList(rsDescEquSeg.TDid)#>
   
   <cfif isdefined('DescEquSeg') and DescEquSeg  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid  in (#DescEquSeg#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsDescEquSeg" datasource="#session.DSN#">
     	update #salida#
    	set DesEqSeg = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsDescEquSeg" datasource="#session.DSN#">
     	update #salida#
    	set DesEqSeg = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
    
    <!---AntiNomin AntNomina--->
    
    <cfquery name="rsAntiNomin" datasource="#session.DSN#">
   	select a.TDid
                       from RHReportesNomina c
                       		inner join RHColumnasReporte b
                       		inner join RHConceptosColumna a on a.RHCRPTid = b.RHCRPTid 
                            		on b.RHRPTNid = c.RHRPTNid
                             and b.RHCRPTcodigo = 'AntiNomin' 	
                       where c.RHRPTNcodigo = 'MX004'				
                             and c.Ecodigo = #session.Ecodigo#
   </cfquery>
   
   <cfset AntiNomin = #ValueList(rsAntiNomin.TDid)#>
   
   <cfif isdefined('AntiNomin') and AntiNomin  NEQ ''>
     <cfquery dbtype="query" name="rsPrestaciones">
        select sum(importe) as importe
        from rsDetallePrestaciones
        where CIid  in (#AntiNomin#)
     </cfquery>
     
    <cfif isdefined('rsPrestaciones') and rsPrestaciones.RecordCount GT 0>
     <cfquery name="rsDescEquSeg" datasource="#session.DSN#">
     	update #salida#
    	set AntNomina = #rsPrestaciones.importe#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   		
   	 </cfquery>
    </cfif>
    <cfelse>
    <cfquery name="rsDescEquSeg" datasource="#session.DSN#">
     	update #salida#
    	set AntNomina = 0
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
   	</cfquery>
    </cfif>
  
     
</cfloop>

<!---<cf_dumpTABLE var="#salida#">--->
 <!---<cfthrow message="salarioDiario #salarioDiario#">--->
 
<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleFiniquitosMEX-form.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_TituloReporte#">
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="100%">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>	
				<cf_EncReporte
					Titulo="#LB_TituloReporte#"
					Color="##E3EDEF"
					filtro1="Desde:#lsdateformat(form.FechaDesde,'dd/mm/yyyy')# al #lsdateformat(form.FechaHasta,'dd/mm/yyyy')#">
			</td>
		</tr>
		</table>
	</td>
 </tr>
 <tr>
  <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaIngreso#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaBaja#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSMG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSDI#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPTF#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProDiasAgui#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPreAgui#</strong>&nbsp;</td>      
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProVacFin#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasVac#</strong>&nbsp;</td>   
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Indemnizacio#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Separacion#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriAntigueda#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PenAlimen#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PresPers#</strong>&nbsp;</td>   
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_OtrasDeduc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Destolls#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DesEqSeg#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AntNomina#</strong>&nbsp;</td>    
</tr>
</cfoutput>    
    
<cfoutput query="rsReporte">
    <tr>
        <td nowrap>#rsReporte.Identificacion#</td>
        <td nowrap>#rsReporte.ape1#</td>
        <td nowrap>#rsReporte.ape2#</td>
        <td nowrap>#rsReporte.Nombre#</td>            
        <td nowrap align="right">#DateFormat(rsReporte.FechaIngreso,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#DateFormat(rsReporte.FechaBaja,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSMG,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSDI,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPTTotF,'none')#</td>        
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ProDiasAgui,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiExc,'none')#</td> 
        <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiGrv,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPreAgui,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacGrv,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacExc,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ProVacFin,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.Dvac,'none')#</td>   
        <td nowrap align="right">#LSCurrencyformat(rsReporte.Indemnizacion,'none')#</td>            
        <td nowrap align="right">#LSCurrencyformat(rsReporte.Separacion,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.PriAntigueda,'none')#</td>        
        <td nowrap align="right">#LSCurrencyformat(rsReporte.PenAlimen,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.PresPers,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.OtrasDeduc,'none')#</td>   
        <td nowrap align="right">#LSCurrencyformat(rsReporte.Destolls,'none')#</td>            
        <td nowrap align="right">#LSCurrencyformat(rsReporte.DesEqSeg,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.AntNomina,'none')#</td>
     </tr>   
</cfoutput>

<tr><td colspan="31" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
