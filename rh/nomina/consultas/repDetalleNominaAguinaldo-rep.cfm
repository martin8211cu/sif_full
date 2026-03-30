<!---<cf_dump var = "#form#">--->
<cfset Session.DebugInfo = true>
<cfsilent>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
    
	<!--- Genera variables de traduccion --->
 	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" 	Default="Reporte Detalle de Nomina de Aguinaldo" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"	Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"			Default="Nombre" 			returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"		Default="Apellido1" 		returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"		Default="Apellido2" 		returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLab"			Default="Dias Trab" 		returnvariable="LB_DiasLab"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasFalta"		Default="Dias Falta" 		returnvariable="LB_DiasFalta"/>       
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasIncap"		Default="Dias Incapacidad" 	returnvariable="LB_DiasIncap"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"		Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"				Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PagAguiExc"	    Default="Aguinaldo Exento" 	returnvariable="LB_PagAguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PagAguiGrv"		Default="Aguinaldo Gravable" 	returnvariable="LB_PagAguiGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PensionAlim"		Default="Pension Alimenticia" 	returnvariable="LB_PensionAlim"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrestaPerso"		Default="Prestamo Personal" 	returnvariable="LB_PrestaPerso"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"			Default="ISPT" 					returnvariable="LB_ISPT"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRCargo" 		Default="ISR a Cargo" 		returnvariable="LB_ISRCargo"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISRFavor" 		Default="ISR a Favor" 		returnvariable="LB_ISRFavor"/>
    
     
    <!--- Genera variables de traduccion --->
    
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
        <cf_dbtempcol name="Nombre"   		type="char(100)"    mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="FAlta"			type="datetime"		mandatory="no">
        <cf_dbtempcol name="TDLab" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="DLab" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="Dfaltas" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="Dincap" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">  
        <cf_dbtempcol name="PagAguiExc"		type="money"     	mandatory="no">
        <cf_dbtempcol name="PagAguiGrv"		type="money"     	mandatory="no">
        <cf_dbtempcol name="PensionAlime" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="PrestPerso" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="ISRCargo"		type="money"       	mandatory="no">
        <cf_dbtempcol name="ISRFavor"		type="money"       	mandatory="no">
        <cf_dbtempcol name="MaxFecha" 		type="datetime"     mandatory="no">
    </cf_dbtemp>
              
        
        <cfif isdefined("form.CaridList") and len(trim(form.CaridList)) gt 0>
            <cfset form.CaridList = form.CaridList>
        <cfelse>
            <cfthrow message="Error. Se requiere la N&oacute;mina de Aguinaldo. Proceso Cancelado!">
        </cfif>

        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and CPid = #form.CaridList#
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsFechas">
    		select  min(RCdesde) as finicio, max(RChasta) as ffinal
    		from #calendario#
		</cfquery>


<!---<cf_dump var="#rsFechas#">--->

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	insert #salida# (DEid, Identificacion, Nombre,Ape1,Ape2)
        select distinct a.DEid, a.DEidentificacion, a.DEnombre, a.DEapellido1, a.DEapellido2
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
                and a.Ecodigo = f.Ecodigo 
            inner join #calendario# x
                on 	b.Tcodigo = x.Tcodigo
                    and c.CPid = x.RCNid
                    and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
             		and b.LThasta = (select MAX(c.LThasta) from LineaTiempo c where c.DEid = a.DEid
					and ((c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#"> and c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">) 
					or (c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#"> and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">))
 						)
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif isdefined('form.DEid') and len(trim(form.DEid))> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> </cfif>
           order by DEid
</cfquery>


<!---<cfquery datasource="#session.dsn#" name="SelrsEmpleados">
	select * from #salida#
</cfquery>

<cf_dump var="#SelrsEmpleados#">--->

<cfif not isdefined('form.NAplicada') or #form.NAplicada# EQ false>	
	<cfset vSalarioEmpleado 	= 'SalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'RCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'PagosEmpleado'>
    <cfset vCargasCalculo 		= 'CargasCalculo'>
    <cfset vRHSubsidio          = 'RHSubsidio'>
    
<cfelseif isdefined('form.NAplicada') or #form.NAplicada# EQ true>
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
    <cfset vRHSubsidio          = 'HRHSubsidio'>
</cfif>

<cfquery datasource="#session.dsn#">
    update #salida# set
        MaxFecha = (Select coalesce(Max(c.RCdesde),getdate())
                from #calendario# a,
                     #vSalarioEmpleado# b,
                     #vRCalculoNomina# c
                Where b.RCNid=c.RCNid
                and b.DEid=#salida#.DEid
                and b.RCNid=a.RCNid 
                )	
</cfquery>

<cf_dbtemp name="EmpleadosAlta" datasource = "#session.DSN#" returnvariable = "EmpleadosAlta">
	<cf_dbtempcol name = "DEid" 		type= "int" 		mandatory="no">
    <cf_dbtempcol name = "FechaAlta"  	type = "datetime" 	mandatory="no">
</cf_dbtemp>
                    
<cfquery name="InsertEmpleadosAlta" datasource="#session.DSN#">
	insert into #EmpleadosAlta# (DEid,FechaAlta)
		select d.DEid, min(DLfvigencia) as FechaAlta 
		from DLaboralesEmpleado d 
    		inner join DatosEmpleado a on d.DEid  = a.DEid and d.Ecodigo=a.Ecodigo
    		inner join RHTipoAccion r on r.RHTid = d.RHTid
		where r.RHTcomportam = 1
	  		and d.Ecodigo = #session.Ecodigo#
		group by d.DEid   
</cfquery>

<cfquery name = "rsEmpleadoAB" datasource="#session.DSN#">
	select DEid, FechaAlta as fechaAlta 
    from #EmpleadosAlta#
</cfquery>

<cfset finicio = CreateDate(year(rsFechas.ffinal), 01, 01)>
<cfset ffinal  = CreateDate(year(rsFechas.ffinal), 12, 31)>
    
<cfloop query="rsEmpleadoAB">
	<cfquery name = "rsUpdMesInicio" datasource="#session.DSN#">
    	update #salida#
        	set FAlta = <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpleadoAB.FechaAlta#"> 
            where DEid = #rsEmpleadoAB.DEid#
    </cfquery>
</cfloop>

<!---<cfquery datasource="#session.dsn#">
    update #salida# set
        FAlta = (select ev.EVfantig from EVacacionesEmpleado ev where ev.DEid = #salida#.DEid)	
</cfquery>--->

<cfquery name="rsFechaAlta" datasource="#session.DSN#">
	select DEid,FAlta from #salida# 
</cfquery>
    
<!---<cf_dump var="#rsFechaAlta#">--->

<cfloop query="rsFechaAlta">
<cfquery datasource="#session.dsn#" name="rsFaltas">
    update #salida#
            <!---Dias de Falta--->
            set Dfaltas = 
                        coalesce(
                        (select distinct sum(pe.PEcantdias)
                        from HPagosEmpleado pe
                            inner join  RHTipoAccion ta
                                on pe.RHTid = ta.RHTid
                                    and ta.RHTcomportam = 13
                                where pe.DEid = #rsFechaAlta.DEid#
                                <cfif #rsFechaAlta.FAlta# LT #finicio# >
                                and pe.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">
                                <cfelse>
                                and pe.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaAlta.FAlta#">
                                </cfif>
                                and pe.PEhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">),0)
            
             <!---Dias de Incapacidad--->
             , Dincap = 
                                coalesce(
                                (select distinct sum(pe.PEcantdias)
                                from HPagosEmpleado pe
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 5
                                            and ta.RHTsubcomportam = 2
                                		where pe.DEid = #rsFechaAlta.DEid#
                                        <cfif #rsFechaAlta.FAlta# LT #finicio# >
                                		and pe.PEdesde >=  <cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">
                                		<cfelse>
                                		and pe.PEdesde >=  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaAlta.FAlta#">
                                		</cfif><!---<cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">--->
                                		and pe.PEhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">),0)
                , TDLab = 
                        coalesce((select case
						when DATEDIFF(dd,<cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaAlta.FAlta#">, <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">)> DATEDIFF(dd,<cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">, <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">) + 1
						then DATEDIFF(dd,<cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">, <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">) + 1
						else DATEDIFF(dd,<cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaAlta.FAlta#">, <cfqueryparam cfsqltype="cf_sql_date" value="#ffinal#">)+1
						end     
						where DEid =  #rsFechaAlta.DEid#) ,0)           
                           <!---(select case
							when <cf_dbfunction name="datediff" args="min(ev.EVfantig), #ffinal# ,DD"  datasource="#session.DSN#"> > 366
                                then 366
							else <cf_dbfunction name="datediff" args="min(ev.EVfantig), #ffinal# ,DD"  datasource="#session.DSN#">
							end     
                            from EVacacionesEmpleado ev inner join #salida# on ev.DEid = #salida#.DEid) --->
         where DEid = #rsFechaAlta.DEid#
 </cfquery>
</cfloop>
 
<cfquery datasource="#session.dsn#" name="rsFaltas">
    update #salida#
          set DLab = TDLab -  Dfaltas  - Dincap                            
</cfquery>

<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set SalDiario = coalesce((select a.DLTmonto / 30
                                from DLineaTiempo a
                                inner join LineaTiempo b
                                    on a.LTid = b.LTid
                                    and b.DEid = #salida#.DEid
                                    and #salida#.MaxFecha between b.LTdesde and b.LThasta
                                inner join ComponentesSalariales c
                                on a.CSid = c.CSid
                                and c.CSsalariobase = 1),0)
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
                                
                ,SDI = 
                        coalesce(
                                (select sum(se.SEsalariobc)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)

</cfquery>

<!---Pago Aguinaldo Exento--->
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
                                                where c.RHRPTNcodigo = 'MX005'				<!--- Codigo Reporte Dinamico --->
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
                                                where c.RHRPTNcodigo = 'MX005'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
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
                            where c.RHRPTNcodigo = 'MX005'					<!--- Codigo Reporte Dinamico --->
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
                            where c.RHRPTNcodigo = 'MX005'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>


<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

<!---<cf_dump var="#rsReporte#">--->
</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleNominaAguinaldo-form.cfm"
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
					filtro2="Desde:#lsdateformat(rsFechas.finicio,'dd/mm/yyyy')# al #lsdateformat(rsFechas.ffinal,'dd/mm/yyyy')#">
			</td>
		</tr>
		</table>
	</td>
 </tr>
 <tr>
 <!--- orden de las columnas en el reporte (encabezados )------->
    <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasLab#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasIncap#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PagAguiExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PagAguiGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PensionAlim#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td>
    <!---<td  class="tituloListas" valign="top" align="right"><strong>#LB_ISRCargo#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISRFavor#</strong>&nbsp;</td>--->
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrestaPerso#</strong>&nbsp;</td>    	
</tr>
</cfoutput>


<cfoutput query="rsReporte" group="DEid">


	<cfoutput> <!---- pintado de la informacion----->
	
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsReporte.Identificacion#</td>
            <td nowrap>#rsReporte.Ape1#</td>
            <td nowrap>#rsReporte.Ape2#</td>
            <td nowrap>#rsReporte.Nombre#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DLab,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dincap,'none')#</td>   
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PagAguiExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PagAguiGrv,'none')#</td>                     
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PensionAlime,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>
            <!---<td nowrap align="right">#LSCurrencyformat(rsReporte.ISRCargo,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ISFavor,'none')#</td>--->
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PrestPerso,'none')#</td>
       </tr>    
	</cfoutput>
</cfoutput>
<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
