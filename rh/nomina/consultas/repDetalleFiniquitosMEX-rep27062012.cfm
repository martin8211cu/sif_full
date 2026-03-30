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
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSMG"	Default="Infonavit SMG" returnvariable="LB_InfonaSMG"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSDI"	Default="Infonavit SDI" returnvariable="LB_InfonaSDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 					returnvariable="LB_ISPT"/>   
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
        <cf_dbtempcol name="Indemnisacio"	type="money"       	mandatory="no">        
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

        
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
    
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
                   	and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
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

<!----------------------------------------------->
       
 <!---====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO
    ====================================---> 


<!--- Hay  que probar  estos queries --->

	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
    insert #salida# (DEid,DLlinea, Nombre,Ape1,Ape2, Identificacion,FechaIngreso,FechaBaja,FactorDiasSalario,diasAnt  )
        select b.DEid,a.DLlinea,
			   b.DEnombre,
               b.DEapellido1,
               b.DEapellido2,
               b.DEidentificacion,
			   a.RHLPfingreso as FechaIngreso,
			   c.DLfvigencia as FechaBaja,
			   <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,
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
				and c.Dcodigo = f.Dcodigo
	
			inner join RHTipoAccion g
				on c.RHTid = g.RHTid
	
			inner join TiposNomina h
				on c.Ecodigo = h.Ecodigo
				and c.Tcodigo = h.Tcodigo
				
			inner join Monedas i
				on h.Ecodigo = i.Ecodigo
				and h.Mcodigo = i.Mcodigo
	
	where
    <cfif form.FechaDesde NEQ ''>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
    <cfelse>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">
    </cfif>
     
    <cfif form.FechaHasta NEQ ''>
    	and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
    <cfelse>
	    and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
    </cfif>   
      and b.Ecodigo = #session.Ecodigo#
   	<cfif Form.DEid GT 0 >
    	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
    </cfif> 
    and c.Tcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
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
                                (select sum(se.SEsalariobc)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)
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
                , Dvac = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 3
                                        where pe.DEid = #salida#.DEid),0) 										
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
     <cfif rsLF.RHLFLtotalL GTE 0>
	   <cfset RetroAgui=rsLF.RHLFLtotalL>
      <cfelse>
      	<cfset RetroAgui=0>
      </cfif> 
     	<cfquery name="rsDetallePrestaciones" datasource="#Session.DSN#">
		select a.DEid, a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe, 
			   b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
		from RHLiqIngresos a
			inner join DDConceptosEmpleado b
				on a.DLlinea = b.DLlinea and a.CIid = b.CIid
			inner join CIncidentes c
				on b.CIid = c.CIid
		where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
        and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
		and coalesce(c.CISumarizarLiq,0) = 0
		and a.RHLPautomatico = 1
	</cfquery>
 		<cfset VacFin = 0>
        <cfset PrVacExc=0>
        <cfset AguiExc=0>
        <cfset DiasVacFin = 0>
        <cfset PropDiasAgui=0>
        <cfset PrimaAnti=0>
        <cfset SepSDI=0>
        <cfset Indemnizacion=0>
    <cfloop query="rsDetallePrestaciones">		
        <cfif rsDetallePrestaciones.Descripcion EQ  'Prop de Vacaciones Finiquito' >
            <cfset VacFin=rsDetallePrestaciones.importe>
             <cfset DiasVacFin = rsDetallePrestaciones.Cantidad>
        <cfelseif rsDetallePrestaciones.Descripcion EQ 'Prop Prim Vac (Exenta)'>
            <cfset PrVacExc=rsDetallePrestaciones.importe>
        <cfelseif rsDetallePrestaciones.Descripcion EQ 'Proporcional Aguinaldo (Exento)'>
            <cfset AguiExc=rsDetallePrestaciones.importe> 
            <cfset PropDiasAgui = rsDetallePrestaciones.Cantidad>
         <cfelseif rsDetallePrestaciones.Descripcion EQ 'Prima de Antiguedad'>
         	<cfset PrimaAnti=rsDetallePrestaciones.importe>
         <cfelseif rsDetallePrestaciones.Descripcion EQ 'Indemnización'>
         	<cfset SepSDI=rsDetallePrestaciones.importe>
         <cfelseif rsDetallePrestaciones.Descripcion EQ 'Separación (SDI)'>
         	<cfset Indemnizacion=rsDetallePrestaciones.importe>
        </cfif> 
    </cfloop>
     
    <cfquery name="uP_isptSalD"  datasource="#session.dsn#">
    	update #salida#
        set ISPT= #ISPT_1#,ProVacFin=#VacFin#,ProPrVacExc=#PrVacExc#,PropAguiExc=#AguiExc#,RetPreAgui=#RetroAgui#,
        Indemnisacio=#Indemnizacion#,Separacion=#SepSDI#,PriAntigueda=#PrimaAnti#,Dvac=#DiasVacFin#,RPAguiFin=#PropDiasAgui#
        where #salida#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DEid#">
        and  #salida#.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.DLlinea#">
    </cfquery>
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
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPAguiFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiExc,'none')#</td> 
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPreAgui,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProVacFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dvac,'none')#</td>   
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Indemnisacio,'none')#</td>            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Separacion,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriAntigueda,'none')#</td>
         </tr>   
	</cfoutput>

<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
