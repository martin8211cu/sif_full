<cfsetting requesttimeout="3600">
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
 	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Acumulados de Ajuste Anual" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario"		Default="Salario" 	returnvariable="LB_Salario"/>
  	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sueldo"		Default="Sueldo"    returnvariable="LB_Sueldo"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetSal"		Default="Retroactivo Salario"   returnvariable="LB_RetSal"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProVacFin"	Default="Prop Vac Finiquito"   returnvariable="LB_ProVacFin"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPVacFin"	Default="Retro Prop Vacaciones Finiquito"   returnvariable="LB_RPVacFin"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac0910"		Default="Vacaciones 2009-2010"   returnvariable="LB_Vac0910"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac1011"		Default="Vacaciones 2010-2011"   returnvariable="LB_Vac1011"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac1112"		Default="Vacaciones 2011-2012"   returnvariable="LB_Vac1112"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VACNS1213"		Default="Vacaciones 2012-2013"   returnvariable="LB_VACNS1213"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VACNS0910"	Default="Vacaciones NS 2009-2010"   returnvariable="LB_VACNS0910"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VACNS1011"	Default="Vacaciones NS 2010-2011"   returnvariable="LB_VACNS1011"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VACNS1112"	Default="Vacaciones NS 2011-2012"   returnvariable="LB_VACNS1112"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetVac"		Default="Retroactivo Vacaciones"   returnvariable="LB_RetVac"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AguiExc"		Default="Aguinaldo Exento"   returnvariable="LB_AguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AguiGrv"		Default="Aguinaldo Gravado"   returnvariable="LB_AguiGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiExc"	Default="Prop Aguinaldo Exento"   returnvariable="LB_PropAguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiGrv"	Default="Prop Aguinaldo Gravado"   returnvariable="LB_PropAguiGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPAguiFin"	Default="Retro Prop Aguinaldo Finiquito"   returnvariable="LB_RPAguiFin"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HExDobleE"	Default="Horas Extras Dobles E"   returnvariable="LB_HExDobleE"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HExDobleG"	Default="Horas Extras Dobles G"   returnvariable="LB_HExDobleG"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HExTriple"	Default="Horas Extras Triples"   returnvariable="LB_HExTriple"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RTEDE"	Default="Retro TE Doble (E)"   returnvariable="LB_RTEDE"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RTEDG"	Default="Retro TE Doble (G)"   returnvariable="LB_RTEDG"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RTET"	Default="Retro TE Triple"   returnvariable="LB_RTET"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriVacExc"	Default="Prima Vac Exenta"   returnvariable="LB_PriVacExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriVacGrv"	Default="Prima Vac Gravada"   returnvariable="LB_PriVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriVacExNS"	Default="Prima Vac Exenta (No Sind)"   returnvariable="LB_PriVacExNS"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriVacGrNS"	Default="Prima Vac Gravada (No Sind)"   returnvariable="LB_PriVacGrNS"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacExc"	Default="Prop Prima Vac Exenta"   returnvariable="LB_ProPrVacExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacGrv"	Default="Prop Prima Vac Gravable"   returnvariable="LB_ProPrVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPPVacFin"	Default="Retro Prim Vac Finiquito"   returnvariable="LB_RPPVacFin"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimVac"	Default="Retroactivo Prima Vac"   returnvariable="LB_RetPrimVac"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriDomExc"	Default="Prima Dominical Exenta"   returnvariable="LB_PriDomExc"/>
   	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriDomGrv"	Default="Prima Dominical Gravable"   returnvariable="LB_PriDomGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimDomE"	Default="Retro Prima Dominical (E)"   returnvariable="LB_RetPrimDomE"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimDomG"	Default="Retro Prima Dominical (G)"   returnvariable="LB_RetPrimDomG"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PTUDias"	Default="PTU en Dias"   returnvariable="LB_PTUDias"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PTUImp"	Default="PTUImp"   returnvariable="LB_PTUImp"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vales"	Default="Vales Despensa" 	returnvariable="LB_Vales"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FOAEmpresa"	Default="Fondo Ahorro" 	returnvariable="LB_FOAEmpresa"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BonEmpleado"	Default="Bono" 	returnvariable="LB_BonEmpleado"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescLabo"	Default="Desc Laborado" 	returnvariable="LB_DescLabo"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FestLab"	Default="Dia Festivo" 	returnvariable="LB_FestLab"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Gratifica"	Default="Gratificación" 	returnvariable="LB_Gratifica"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OtraPrest"	Default="Otras Prestaciones" 	returnvariable="LB_OtraPrest"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PieMaquina"	Default="Pie de Maquina" 	returnvariable="LB_PieMaquina"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetDiaFest"	Default="Retro Dia Festivo" 	returnvariable="LB_RetDiaFest"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPieMaq"	Default="Retro Pie de Maquina" 	returnvariable="LB_RetPieMaq"/>


<cfif isdefined('form.periodo') and #form.Periodo# NEQ -1>
	<cfset periodoAA = #form.Periodo#>
<cfelse>
	<cfthrow message="Elige el periodo de Ajuste Anual">
</cfif>

<cfquery name="rsAjusteAnualId" datasource="#session.DSN#">
		select RHAAid,RHAAfecharige,RHAAfechavence
		from RHAjusteAnual
		where RHAAPeriodo = #periodoAA#
			and Ecodigo = #session.Ecodigo# 
</cfquery>

	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"    mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Sueldo" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RetSal" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="ProVacFin" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RPVacFin" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Vac0910" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Vac1011" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Vac1112" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="VACNS0910" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="VACNS1011" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="VACNS1112" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="VACNS1213" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RetVac" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Vales" 			type="money"     	mandatory="no">
        <cf_dbtempcol name="FOAEmpresa" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="AguiExc" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="AguiGrv" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="PropAguiExc" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="PropAguiGrv" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="RPAguiFin" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="HExDobleE" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="HExDobleG" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="HExTriple" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RTEDE" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RTEDG" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RTET" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="PriVacExc" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="PriVacGrv" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="PriVacExNS" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="PriVacGrNS" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="ProPrVacExc" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="ProPrVacGrv" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="RPPVacFin" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="RetPrimVac" 	type="money"     	mandatory="no">
        <cf_dbtempcol name="PriDomExc"	 	type="money"     	mandatory="no">
        <cf_dbtempcol name="PriDomGrv"	 	type="money"     	mandatory="no">
        <cf_dbtempcol name="RetPrimDomE"	type="money"     	mandatory="no">
        <cf_dbtempcol name="RetPrimDomG"	type="money"     	mandatory="no">
        <cf_dbtempcol name="PTUDias"	type="money"     	mandatory="no">
        <cf_dbtempcol name="PTUImp"	type="money"     	mandatory="no">
        <cf_dbtempcol name="BonEmpleado"	type="money"     	mandatory="no">
        <cf_dbtempcol name="DescLabo"	type="money"     	mandatory="no">
        <cf_dbtempcol name="FestLab"	type="money"     	mandatory="no">
       	<cf_dbtempcol name="Gratifica"	type="money"     	mandatory="no">
        <cf_dbtempcol name="OtraPrest"	type="money"     	mandatory="no">
        <cf_dbtempcol name="PieMaquina"	type="money"     	mandatory="no">
        <cf_dbtempcol name="RetDiaFest"	type="money"     	mandatory="no">
        <cf_dbtempcol name="RetPieMaq"	type="money"     	mandatory="no">
        
	</cf_dbtemp>
        
    
<cfquery datasource="#session.dsn#" name="rsEmpleados">
	insert #salida# (DEid, Identificacion, Nombre,Ape1,Ape2,CSsalario)
    select de.DEid,de.DEidentificacion,de.DEnombre,de.DEapellido1,de.DEapellido2,rhaaa.RHAAAcumuladoSalario
	from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid = rhaa.RHAAid
              inner join DatosEmpleado de on de.DEid = rhaaa.DEid and de.Ecodigo = rhaa.Ecodigo
	where rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">
      and rhaa.Ecodigo = #session.Ecodigo#   
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Sueldo = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Sueldo' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetSal = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetSal' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set ProVacFin = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'ProVacFin' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RPVacFin = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RPVacFin' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Vac0910 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Vac0910' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Vac1011 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Vac1011' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Vac1112 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Vac1112' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set VACNS0910 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'VACNS0910' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set VACNS1011 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'VACNS1011' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set VACNS1112 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'VACNS1112' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set VACNS1213 = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'VACNS1213' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetVac = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetVac' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>




<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Vales = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Vales' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set FOAEmpresa = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'FOAEmpresa' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set AguiExc = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'AguiExc' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>
<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set AguiGrv = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'AguiGrv' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PropAguiExc = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PropAguiExc' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>
<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PropAguiGrv = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PropAguiGrv' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RPAguiFin = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RPAguiFin' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>



<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set HExDobleE = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'HExDobleE' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>
<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set HExDobleG = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'HExDobleG' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set HExTriple = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'HExTriple' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RTEDE = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RTEDE' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

 

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RTEDG = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RTEDG' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RTET = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RTET' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>




<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriVacExc = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriVacExc' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriVacGrv = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriVacGrv' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriVacExNS = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriVacExNS' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriVacGrNS = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriVacGrNS' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set ProPrVacExc = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'ProPrVacExc' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set ProPrVacGrv = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'ProPrVacGrv' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RPPVacFin = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RPPVacFin' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetPrimVac = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetPrimVac' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>


<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriDomExc = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriDomExc' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PriDomGrv = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PriDomGrv' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetPrimDomE = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetPrimDomE' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetPrimDomG = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetPrimDomG' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PTUDias = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PTUDias' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PTUImp = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PTUImp' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>


<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set BonEmpleado = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'BonEmpleado' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set DescLabo = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'DescLabo' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set FestLab = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'FestLab' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set Gratifica = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'Gratifica' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set OtraPrest = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'OtraPrest' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set PieMaquina = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'PieMaquina' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetDiaFest = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetDiaFest' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	update #salida#
    	set RetPieMaq = (select sum(DRHAAAcumulado)
					  from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa 
					  where drha.CIid = ci.CIid 
					  and drha.RHAAid = rhaa.RHAAid 
                      and ci.CIid in (select distinct a.CIid
                            		  from RHReportesNomina c
                                            inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                            on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'RetPieMaq' 
                                      where c.RHRPTNcodigo = 'MX006'				
                                      and c.Ecodigo = #session.Ecodigo#)
                      and drha.DEid = #salida#.DEid
                      and ci.Ecodigo = #session.Ecodigo#
					  and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAjusteAnualId.RHAAid#">)
</cfquery>

 



<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repAjusteAnual.cfm"
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
					filtro2="Desde:#lsdateformat(rsAjusteAnualId.RHAAfecharige,'dd/mm/yyyy')# al #lsdateformat(rsAjusteAnualId.RHAAfechavence,'dd/mm/yyyy')#"
				>
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
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Sueldo#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetSal#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProVacFin#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPVacFin#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac0910#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac1011#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac1112#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_VACNS0910#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_VACNS1011#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_VACNS1112#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_VACNS1213#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetVac#</strong>&nbsp;</td>
 	
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AguiExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AguiGrv#</strong>&nbsp;</td> 
     <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPAguiFin#</strong>&nbsp;</td>
   
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_HExDobleE#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_HExDobleG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_HExTriple#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RTEDE#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RTEDG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RTET#</strong>&nbsp;</td>
    
    
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_PriVacExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriVacGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriVacExNS#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_PriVacGrNS#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPPVacFin#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimVac#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriDomExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriDomGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimDomE#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimDomG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PTUDias#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PTUImp#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vales#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FOAEmpresa#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_BonEmpleado#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescLabo#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FestLab#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Gratifica#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_OtraPrest#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PieMaquina#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetDiaFest#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPieMaq#</strong>&nbsp;</td>
      
</tr>
</cfoutput>


	<cfoutput> <!---- pintado de la informacion----->
	<cfloop query="rsReporte">
		<tr >
			<td nowrap>#rsReporte.Identificacion#</td>
            <td nowrap>#rsReporte.Ape1#</td>
            <td nowrap>#rsReporte.Ape2#</td>
            <td nowrap>#rsReporte.Nombre#</td>         
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CSsalario,'none')#</td>
         	<td nowrap align="right">#LSCurrencyformat(rsReporte.Sueldo,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetSal,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProVacFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPVacFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac0910,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac1011,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac1112,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.VACNS0910,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.VACNS1011,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.VACNS1112,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.VACNS1213,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetVac,'none')#</td>
             
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AguiExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AguiGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPAguiFin,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExTriple,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RTEDE,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RTEDG,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RTET,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacExNS,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacGrNS,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPPVacFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimVac,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimDomE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimDomG,'none')#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.PTUDias,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PTUImp,'none')#</td>     
        	<td nowrap align="right">#LSCurrencyformat(rsReporte.Vales,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.FOAEmpresa,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.BonEmpleado,'none')#</td>
           	<td nowrap align="right">#LSCurrencyformat(rsReporte.DescLabo,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.FestLab,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Gratifica,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.OtraPrest,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PieMaquina,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetDiaFest,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPieMaq,'none')#</td>
      </tr>   
      </cfloop>
</cfoutput>
<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
