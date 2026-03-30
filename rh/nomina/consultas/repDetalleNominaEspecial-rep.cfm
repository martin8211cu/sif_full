<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
     	
   	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Nominas Especiales" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre" 	  returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1"   returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2"   returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DirectoIndirecto"	Default="Directo/Indirecto"   returnvariable="LB_DirectoIndirecto"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde"	Default="Fecha Desde" returnvariable="LB_FechaDesde"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta"	Default="Fecha Hasta" returnvariable="LB_FechaHasta"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"			Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"	Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 		  returnvariable="LB_ISPT"/>
    
    <!---SML. Modificacion para obtener las columnas del reporte de nomina configuradas en Reportes Dinamico.
			El reporte Detallado de Nomina tiene el código de MX002---> 
     
     <cf_dbtemp name="RHColumnasReporte" returnvariable="RHColumnasReporte">
		<cf_dbtempcol name="RHCRPTid"   		type="numeric"      	mandatory="yes">
		<cf_dbtempcol name="RHCRPTcodigo" 		type="char(20)"     	mandatory="no">
		<cf_dbtempcol name="RHCRPTdescripcion" 	type="varchar(80)"  	mandatory="no">
		<cf_dbtempcol name="RHRPTNcolumna" 		type="int"     			mandatory="no">
	</cf_dbtemp>
     
     <cfquery datasource="#session.dsn#" name="rsRHReportesNomina">	
     	insert into #RHColumnasReporte# (RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna)
            select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna
			from RHColumnasReporte
			where RHRPTNid in (select RHRPTNid from RHReportesNomina
				   			   where RHRPTNcodigo = 'MX007'
							   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
			order by RHRPTNcolumna asc
	</cfquery>
    
    <cfquery datasource="#session.dsn#" name="rsCantidadColumnas">	
     	select RHCRPTid as cantidad,RHCRPTdescripcion from #RHColumnasReporte# 
        order by RHRPTNcolumna asc
	</cfquery>
         
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
        <cf_dbtempcol name="IdNomina" 		type="int" 			mandatory="no">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"    mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="DEdato1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="fechaDesde"   	type="datetime"     mandatory="no">
        <cf_dbtempcol name="fechaHasta"   	type="datetime"     mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no"> 
        <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no"> 
        <cf_dbtempcol name="MaxFecha" 		type="datetime"     mandatory="no">
        
    <cfif isdefined('rsCantidadColumnas') and rsCantidadColumnas.RecordCount GT 0>
    	<cfset TotalColumnas = #rsCantidadColumnas.RecordCount#>
    	<cfloop from = "1" to ="#TotalColumnas#" index="i">
    		<cf_dbtempcol name="Columna#i#" 		type="money"     	mandatory="no"> 
        </cfloop>    	
    </cfif>   
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
       <cfquery datasource="#session.dsn#" name="rsCalendarios">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago) 
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CPfpago between <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'dd/mm/yyyy')#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'dd/mm/yyyy')#"> 
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
                    and CPtipo = 1
        </cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="rsFechas">
    select min(RCdesde) as finicio  , max(RChasta) as ffinal
    from #calendario#
</cfquery>


<cfif isdefined('form.tiponomina') or #form.Tfiltro# EQ 2>
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
    <cfset vRHSubsidio          = 'HRHSubsidio'>
<cfelse>	
	<cfset vSalarioEmpleado 	= 'SalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'RCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'PagosEmpleado'>
    <cfset vCargasCalculo 		= 'CargasCalculo'>
    <cfset vRHSubsidio          = 'RHSubsidio'>
</cfif>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	insert #salida# (DEid, IdNomina, Identificacion, Nombre,Ape1,Ape2, DEdato1, FechaDesde, FechaHasta)
        select distinct a.DEid, x.RCNid,a.DEidentificacion, a.DEnombre, a.DEapellido1, a.DEapellido2, a.DEdato1, x.RCdesde, x.RChasta
        from DatosEmpleado a
            inner join #vSalarioEmpleado# b
            	on a.DEid = b.DEid
            inner join #calendario# x
                on b.RCNid = x.RCNid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif isdefined('form.DEid') and len(trim(form.DEid))> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> </cfif>
        order by DEid
</cfquery>

<!---<cf_dump var = "#rsEmpleados#">--->

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

<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set ISPT = 
                coalesce(
                        (select sum(se.SErenta)
                        from #vSalarioEmpleado# se
                            inner join  #calendario# x 
                                on se.RCNid = x.RCNid
                                where se.DEid = #salida#.DEid <cfif form.Tfiltro NEQ 1> and se.RCNid = #salida#.IdNomina</cfif> <!---Modificacion SML--->),0)
				,SDI = 
                        coalesce(
                                (select sum(se.SEsalariobc)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid <cfif form.Tfiltro NEQ 1> and se.RCNid = #salida#.IdNomina</cfif> <!---Modificacion SML--->),0)

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
<!---	where DLab > 0--->
</cfquery>

<cfset a = 1>   
<cfloop query="rsCantidadColumnas">
	<cfquery datasource="#session.dsn#" name="rsValidarCIncidentes">
		select count(CIid) as CIid from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
	<cfquery datasource="#session.dsn#" name="rsValidarTDeduccion">
		select count(TDid) as TDid from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
	<cfquery datasource="#session.dsn#" name="rsValidarDCargas">
		select count(DClinea) as DClinea from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
    <cfif isdefined('rsValidarCIncidentes') and rsValidarCIncidentes.CIid GT 0>
    <cfset Columnan = 'Columna' & #a#>
    <!---<cf_dump var = "#Columnan#">--->
    <cfquery datasource="#session.dsn#">
   		update #salida#
		set #Columnan#=  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid <cfif form.Tfiltro NEQ 1> and a.RCNid = #salida#.IdNomina</cfif> <!---Modificacion SML--->
                                        and a.RCNid = x.RCNid 
                                        and ICespecie = 0
                                        and CIid  in (select CIid as CIid from RHConceptosColumna
													  where RHCRPTid = #rsCantidadColumnas.cantidad#
                                                      )),0)
                                        
		
	</cfquery>
    <cfelseif isdefined('rsValidarTDeduccion') and rsValidarTDeduccion.TDid GT 0>
    <cfset Columnan = 'Columna' & #a#>
    <cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    	update #salida#
    	set #Columnan# = 
    					coalesce((
    					select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
               			where a.DEid = #salida#.DEid <cfif form.Tfiltro NEQ 1> and a.RCNid = #salida#.IdNomina</cfif> <!---Modificacion SML--->
                        	and a.RCNid = x.RCNid 
                        	and a.DEid = b.DEid
                        	and a.Did = b.Did
                        	and b.TDid  in (select TDid as TDid from RHConceptosColumna
											where RHCRPTid = #rsCantidadColumnas.cantidad#)
                        ),0)
	</cfquery>
    <cfelseif isdefined('rsValidarDCargas') and rsValidarDCargas.DClinea GT 0>
    <cfset Columnan = 'Columna' & #a#>
    <cfquery datasource="#session.dsn#" name="UpdCargaIMSSo">
    	update #salida#
    	set #Columnan# = 
    					coalesce((
    						select sum(a.CCvaloremp) from #vCargasCalculo# a, CargasEmpleado b, #calendario# x
                			where a.DEid = #salida#.DEid <cfif form.Tfiltro NEQ 1> and a.RCNid = #salida#.IdNomina</cfif> <!---Modificacion SML--->
                        	and a.RCNid = x.RCNid 
                        	and a.DEid = b.DEid
                        	and a.DClinea = b.DClinea
                        	and b.DClinea in (select DClinea as DClinea from RHConceptosColumna
											where RHCRPTid = #rsCantidadColumnas.cantidad#)
                        ),0)
	</cfquery>
    </cfif>
    
    <cfset a = a + 1>
    
</cfloop>

<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleNominaEspecial.cfm"
FileName="Reporte_Nomina_Especial.xls"
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
					filtro1="#form.TDescripcion2#"
					filtro2="Desde:#lsdateformat(rsFechas.finicio,'dd/mm/yyyy')# al #lsdateformat(rsFechas.ffinal,'dd/mm/yyyy')#"
				>
			</td>
		</tr>
		</table>
	</td>
 </tr>
 <!--- orden de las columnas en el reporte (encabezados )------->
    <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_DirectoIndirecto#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_FechaDesde#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_FechaHasta#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td>
    <cfloop query="rsCantidadColumnas">
    <td  class="tituloListas" valign="top"><strong>#rsCantidadColumnas.RHCRPTdescripcion#</strong>&nbsp;&nbsp;</td>
    </cfloop>
	
    
</tr>
</cfoutput>


<cfloop query="rsReporte">
	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsReporte.Identificacion#</td>
            <td nowrap>#rsReporte.Ape1#</td>
            <td nowrap>#rsReporte.Ape2#</td>
            <td nowrap>#rsReporte.Nombre#</td>
            <td nowrap>#rsReporte.DEdato1#</td>
            <td nowrap>#DateFormat(rsReporte.fechaDesde,'dd/mm/yyyy')#</td>
            <td nowrap>#DateFormat(rsReporte.fechaHasta,'dd/mm/yyyy')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>  
            <cfset x = 1>
            <cfloop query = "rsCantidadColumnas">
            <cfif isdefined('rsCantidadColumnas') and rsCantidadColumnas.RecordCount GT 0>
            <cfset Columnax = 'Columna' & #x#>
            <cfset Columna = rsReporte[Columnax]>
            		<td nowrap>#LSCurrencyFormat(Columna,'none')#</td>
                <cfset x = x + 1>
            </cfif>
            </cfloop>
		</tr>
    </cfoutput>
</cfloop>
<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
