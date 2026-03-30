<!---<cf_dump var="#form#">--->


<cfquery name="rsCCostoOfic" datasource="#session.DSN#">
select CFunc.CFdescripcion 
	  ,CFunc.CFid
	  ,Ofic.Oficodigo   
		
	from 
		RHEscenarios Escenarios,
		RHSituacionActual SituAct,	
        RHPlazaPresupuestaria plzPresup,
		RHPlazas plz,
		CFuncional  CFunc,
		Oficinas Ofic 

	where Escenarios.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Escenarios.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 

	and SituAct.Ecodigo = Escenarios.Ecodigo
	and SituAct.RHEid = Escenarios.RHEid

	and plzPresup.Ecodigo = SituAct.Ecodigo
	and plzPresup.RHPPid = SituAct.RHPPid 

	and plz.Ecodigo = plzPresup.Ecodigo
	and plz.RHPPid   = plzPresup.RHPPid 

	and CFunc.Ecodigo = plz.Ecodigo
	and CFunc.CFid = plz.CFid 

 	and Ofic.Ecodigo = CFunc.Ecodigo
	and Ofic.Ocodigo =  CFunc.Ocodigo 
	                                                   
	group by  CFunc.CFdescripcion  ,CFunc.CFid  ,Ofic.Oficodigo  
    order by   CFunc.CFdescripcion  ,CFunc.CFid ,Ofic.Oficodigo
</cfquery>


<cfquery name="rsPresupXCentroCosto" datasource="#session.DSN#">
	select CFunc.CFdescripcion 
			,CFunc.CFid
		    ,Ofic.Oficodigo   
		   ,coalesce(sum(CSituAct.Monto),0) as monto
		   ,CSituAct.CSid 
 
	from 
		RHEscenarios Escenarios,
		RHSituacionActual SituAct,
		RHCSituacionActual  CSituAct,	
        RHPlazaPresupuestaria plzPresup,
		RHPlazas plz,
		CFuncional  CFunc,
		Oficinas Ofic 

	where Escenarios.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Escenarios.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 

	and SituAct.Ecodigo = Escenarios.Ecodigo
	and SituAct.RHEid = Escenarios.RHEid

	and plzPresup.Ecodigo = SituAct.Ecodigo
	and plzPresup.RHPPid = SituAct.RHPPid 

	and plz.Ecodigo = plzPresup.Ecodigo
	and plz.RHPPid  = plzPresup.RHPPid 

	and CFunc.Ecodigo = plz.Ecodigo
	and CFunc.CFid = plz.CFid 
	
	and Ofic.Ecodigo = CFunc.Ecodigo
	and Ofic.Ocodigo =  CFunc.Ocodigo 
                                                    
	and CSituAct.Ecodigo = SituAct.Ecodigo
    and CSituAct.RHSAid = SituAct.RHSAid

	group by CFunc.CFdescripcion ,CFunc.CFid,Ofic.Oficodigo,CSituAct.CSid 
	order by CFunc.CFdescripcion ,CFunc.CFid,Ofic.Oficodigo,CSituAct.CSid 
</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="RepPresupXCentroCosto-rep.cfm">